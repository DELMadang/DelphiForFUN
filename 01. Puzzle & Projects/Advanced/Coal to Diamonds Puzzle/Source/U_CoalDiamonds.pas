unit U_CoalDiamonds;
{Copyright © 2006, 2016 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Spin, UTGraphSearch, UIntList, UCountdownTimer, ExtCtrls,
  ComCtrls, ImgList, shellAPI, strutils;

type
  TSolverec=record
     path:integer;
     nclick:TPoint; {column and row clicked}
   end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Boardgrid: TStringGrid;
    DSolveBtn: TButton;
    DFBtn: TButton;
    BFBtn: TButton;
    Panel1: TPanel;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    StaticText1: TStaticText;
    GenAllBtn: TButton;
    CountLbl: TLabel;
    MakeAGameBtn: TButton;
    ImageList1: TImageList;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Memo5: TMemo;
    DisplayGrp: TRadioGroup;
    Memo1: TMemo;
    Edit3: TEdit;
    Memo6: TMemo;
    Panel2: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    OneMoveFwdBtn: TButton;
    OneMovebackBtn: TButton;
    Label4: TLabel;
    SpinEdit2: TSpinEdit;
    Edit2: TEdit;
    Label9: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    CountUniqueBtn: TButton;
    Bevel3: TBevel;
    Panel4: TPanel;
    SearchSolutionsBtn: TButton;
    Memo7: TMemo;
    Panel5: TPanel;
    PruneGraphBtn: TButton;
    Label5: TLabel;
    Memo8: TMemo;
    Restorebtn: TButton;
    Label10: TLabel;
    GoalEdt: TEdit;
    SetGoalBtn: TButton;
    Label7: TLabel;
    StopPanel: TPanel;
    Label11: TLabel;
    Label6: TLabel;
    Label13: TLabel;
    procedure MakeRandomGame(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BoardgridClick(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure DSolveBtnClick(Sender: TObject);
    procedure DFBtnClick(Sender: TObject);
    procedure BFBtnClick(Sender: TObject);
    procedure OneMoveFwdBtnClick(Sender: TObject);
    procedure OneMovebackBtnClick(Sender: TObject);
    procedure CountUniqueBtnClick(Sender: TObject);
    procedure PruneGraphBtnClick(Sender: TObject);
    procedure GenAllBtnClick(Sender: TObject);
    procedure MakeAGameBtnClick(Sender: TObject);
    procedure BoardgridDrawCell(Sender: TObject; ACol, ARow: Integer;
                                Rect: TRect; State: TGridDrawState);
    procedure DisplayGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SearchSolutionsBtnClick(Sender: TObject);
    procedure Memo2Click(Sender: TObject);
    procedure RestorebtnClick(Sender: TObject);
    procedure GoalEdtKeyPress(Sender: TObject; var Key: Char);
    procedure GoalEdtExit(Sender: TObject);
    procedure GoalEdtKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StopPanelClick(Sender: TObject);
  public
    visited:array[0..262143] of boolean; {Position for each possible board used
                                         to identify reachable boards from a goal board}
    filename:string;
    ncount:integer;
    board:integer;   {current board}
     goal:string; {current goal string}
    OrigBoard:integer; {board as created}
    boardhist:array of integer;
    Graph:TGraphList;
    TImer:TCountDown;
    manualplay:boolean; {flag set when board is 1st clicked after new game}
    maxdepth:integer;

    Procedure timerpop(sender:TObject);
    function ForwardMove(const board, InvN:integer):integer;
    function ReverseMove(const board, InvN:integer):integer;
    function boardToKey(b:integer):string;
    function keytoBoard(s:string):integer;
    procedure showboard;
    procedure GoalFound;
    procedure GoalFound2;
    Function SetUpToSolve(mode:string):string;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
  {the 9 "2 bit" numbers which, when "anded" with a board index, will give us
   the 9 integers  assiciated with a board position}
  masks:array[0..8] of integer =($3,$c,$30,$c0,$300,$c00,$3000,$C000,$30000);

Procedure TForm1.timerpop;
begin
   (*
   if ansicontainstext(panel6.caption, 'Breadth') then
   label10.Caption:=format('Nodes searched: %.n Current Path Len: %d, MaxDepth %d',
          [0.0+graph.nodessearched,graph.pathlen, maxdepth])
   else label10.caption:='';
   *)
end;

function validgoal(var g:string):boolean;
var i:integer;
    s:string;
begin
  result:=true;
  s:=stringreplace(g,' ','',[rfreplaceall]);

  if (length(s)=9) then
  begin
    for i:=1 to 9 do
    if not (s[i] in ['0'..'3']) then
    begin
      result:=false;
      break;
    end;
  end
  else result:=false;

  if not result then showmessage('Goal '+ g +' invalid, not set')
  else g:=s;
end;

{************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  StopPanel.bringtofront;  {was in back during design phase for convenience}
  Timer:=TCountdown.create(Panel1);
  timer.runmode:=CountUp;
  timer.nosound:=true;
  timer.onTimerPop:=TimerPop;
  Graph:=TGraphList.create;
  filename:='CoalDiamondPrunedGraph.gph';
  if fileexists(filename) then graph.loadgraph(filename) else
  if messagedlg('File "'+filename +'"  missing.  Rebuild? (may take a few minutes)',
                MTConfirmation,[mbyes,mbno],0)=MrYes then
  begin
    prunegraphbtnclick(sender);
  end
  else halt;
  goal:=goaledt.text;
  MakeAGameBtnclick(sender);
end;

{************ ForwardMove *************}
function TForm1.ForwardMove(const board, InvN:integer):integer;
{Make the next board if position InvN is clicked}
var  m,nn,c,r,cc,n:integer;
begin
 result:=board;
 n:=Invn;
 cc:=n mod 3;
 for r:= 0 to 2 do
 begin  {increment pahses in the rows of the clicked colu,m}
   nn:=3*r + cc;  {Position of N withing the board}
   m:= (board and masks[nn]) shr (2*nn);  {Bit position of N (2 bits per position) }
   m:=((m+1) mod 4) shl (2*nn);
   result:=result and ($3FFFF -  ($3 shl (2*nn)));  {00 the  bits in (cc,r)}
   result:=result or m; {put the new increments value in )cc,rr}
 end;

 r:=n div 3;  {get the clicked row}
 for c:= 0 to 2 do {for the columns in that row}
 if c<>cc then  {we've already changed the clicked cell in r loop,
                 so don't change it again}
 begin    {do the same incrementing across columns for row r}
   nn:=3*r + c;
   m:= (board and masks[nn]) shr (2*nn);
   m:=((m+1) mod 4) shl (2*nn);
   result:=result and ($3FFFF -  ($3 shl (2*nn)));
   result:=result or m;
 end;
end;

{************* ReverseMove ************}
function TForm1.ReverseMove(const board, InvN:integer):integer;

var  m,n,nn,c,r,cc:integer;
begin
  n:=Invn; {the position clicked to produce the input "board" }
  result:=board;
  {reduce each cell in affected row and column}
  cc:=n mod 3;
  for r:= 0 to 2 do
  begin
    nn:=3*r + cc;
    m:= (board and masks[nn]) shr (2*nn);
    m:=((m-1) mod 4);
    if m<0 then inc(m,4);
    m:=m shl (2*nn);
    result:=result and ($3FFFF -  ($3 shl (2*nn)));
    result:=result or m;
  end;

  r:=n div 3;
  for c:= 0 to 2 do
  if c<>cc then  {we've already changed the clicked cell in r loop,
                 so don't change it again}
  begin
    nn:=3*r + c;
    m:= (board and masks[nn]) shr (2*nn);
    m:=((m-1) mod 4);
    if m<0 then inc(m,4);
    m:=m shl (2*nn);
    result:=result and ($3FFFF - ($3 shl (2*nn)));
    result:=result or m;
  end;
end;

{************* BoardToKey **********}
 function TForm1.boardToKey(b:integer):string;
 {Turn a integer into a board key - conver 18 bits into 9 characters, each between 0 and 3}
 var
   i,n:integer;
   s:string;
 begin
   s:='';
   for i:=0 to 8 do
   begin
     n:=b and 3;{n = two rightmost bits, 0 to 3}
     s:=inttostr(n)+s; {add it to the key}
     b:= b shr 2;  {shift next two bits to rightmost position}
   end;
   result:=s;
 end;

(*

{************** BoardtoStringrep ***********}
function TForm1.boardToStringrep(b:integer):string;
{Stringrep has board digits reversed as they appear to user}
var i,n:integer;
    mask,K:integer;
    s:string;
begin
   mask:=$3;
   s:='';
   for i:= 0 to 8 do
   begin
     n:=mask and b;
     K:=n shr (2*i);
     s:=inttostr(K)+s;
     if (i=2) or (i=5) then s:='  '+s;
     mask:=$3 shl (2*(i+1));
   end;
   result:=s;
 end;
 *)

{************* KeyToBoard *************}
function TForm1.KeyToBoard(s:string):integer;
{convert a board key string to an 18 bit integer (2 bits per number}
var
  i,n:integer;
begin
  i:=1;
  n:=0;
  while i<=length(s) do
  begin
    if s[i] in ['0'..'3'] then n:= n*4+strtoint(s[i]);
    inc(i);
  end;
  result:=n;
end;

 {***** Showboard ********}
 procedure TForm1.showboard;
 {Display the  board represented by "b"}
 var
   r,c,i:integer;
   s:string;
 begin
   with  Boardgrid do
   begin
     i:=0;
     for r:=0 to 2 do
     for c:=0 to 2 do
     begin
       s:=boardtokey(board);
       cells[c,r]:=s[i+1];
       inc(i);
     end;
   end;
 end;


{*********** MakeRandomGame ***********88}
procedure TForm1.MakeRandomGame(Sender: TObject);

var
  i,j,n:integer;
  s:string;
begin
   manualplay:=false;
   memo1.clear;
   memo2.clear;
   setlength(boardhist,100);
   n:=spinedit1.value;
   maxdepth:=spinedit1.value;
   //setlength(solvepath,N+1);

   board:=keytoboard(goal){'$3FFFF};  {winning board position}
   for i:=n-1 downto 0 do
   begin
     j:=random(9);
     board:=ReverseMove(board, j);
   end;
   OrigBoard:=board;
   showboard;
   s:=boardtokey(board);
   edit3.Text:=format('%s %s %s',[copy(s,1,3), copy(s,4,3),copy(s,7,3)]);
 end;

{************** BoardGridClick ***********}
procedure TForm1.BoardgridClick(Sender: TObject);
var
  n:integer;
  oldboard:integer;
  intGoal:integer;
begin
  intgoal:=KeyToBoard(goal);
  if not manualplay then
  begin
    memo1.clear;
    manualplay:=true;
  end;
  with boardgrid do
  begin

    n:=8 - (3*row+col);
    oldboard:=board;
    board:=forwardMove(board,n);
    showboard;
    with memo1.lines do
    begin
      add(format('Clicked column %d, row %d',[col+1,row+1]));
      if count>=length(boardhist) then setlength(boardhist,count+100);
      boardhist[count-1]:=oldboard;
    end;
    if board=intGoal { $3FFFF} then showmessage('Winner!')
  end;
end;


{************ Memo1Click ************}
procedure TForm1.Memo1Click(Sender: TObject);
{Use clicks during back up to a particular position}
var
  i,n:integer;
  line:string;
begin
  n := Memo1.Perform(EM_LINEFROMCHAR,  -1, 0);
  with memo1,lines do
  begin
    line:=lines[n];
    if pos('Clicked',line)>0 then
    begin
      if integer(objects[n])>=0 then
      begin
        board:=boardhist[n];
        showboard;
        for i:=lines.count-1 downto n do delete(i);
      end;
    end;
  end;
end;



{************** GoalFound ***********}
procedure TForm1.GoalFound;
{Procedure called by depth first, breadth first and Dijstra when solution is
 found to report results}
var
  i,c,r:integer;
  s,s2,s3:string;
begin
  with graph.q do
  begin
    if count=0 then memo2.lines.add('No solution found')
    else
    with memo2, lines do
    begin
       add('');
       add('Solution found, '+ inttostr(graph.q.count-1)+ ' moves');
       add('');
       add('Click here to replay solution');
       add('');
       add('Board key    Move (Col,Row)');
       add('---------   ------------------');
       for i:=0 to graph.q.count-1 do
       with  TNode(graph.q[i]) do
       begin
         s:=graph[index];
         s3:=BoardToKey(KeyToBoard(s));
         if i<graph.q.count-1 then
         begin {derive the move from  two board positions}
           s2:=graph[TNode(graph.q[i+1]).index];
           if (s[1]<>s2[1])
              and (s[2]<>s2[2])
              and (s[3]<>s2[3]) then R:=1
           else
           if (s[4]<>s2[4])
              and (s[5]<>s2[5])
              and (s[6]<>s2[6]) then R:=2
           else
           if (s[7]<>s2[7])
              and (s[8]<>s2[8])
              and(s[9]<>s2[9]) then R:=3
           else r:=-1; {Error!}

           if (s[1]<>s2[1])
              and (s[4]<>s2[4])
              and(s[7]<>s2[7]) then C:=1
            else
            if (s[2]<>s2[2])
              and (s[5]<>s2[5])
              and(s[8]<>s2[8]) then C:=2
            else
            if (s[3]<>s2[3])
              and (s[6]<>s2[6])
              and(s[9]<>s2[9]) then C:=3
              else c:=-1; {error!}

            add(format('%s         (%d,%d)',[s3,c,r]));
          end
          else add(format('%s         Goal!',[s3]));
       end;
       selstart:=0;
       sellength:=1;
    end;
  end;
end;

{*************** SetUpToSolve *********}
function TForm1.SetupToSolve(mode:string):string;
{Common initialization tasks for all solve methods}
var
  index:integer;
begin
  result:=BoardtoKey(board);
  If not graph.find(goal,index) then
  begin
    if messagedlg('Goal board '+ goal + 'is not available.  Create new Pruned node file?',
              mtconfirmation,[mbyes,mbno],0) = mrNo then
    begin
      result:='';
      exit;
    end
    else
    begin
      countUniqueBtnClick(self);
      prunegraphbtnClick(self);
      makerandomgame(self); 
    end;
  end;
  If not graph.find(result,index) then
  begin
    showmessage('Starting board '+ result + ' cannot reach the current goal.');
    result:='';
    exit;
  end;
  memo2.clear;   memo1.clear;
  StopPanel.caption:='STOP '+ mode;
  StopPanel.visible:=true;
  tag:=0;
  Timer.setStarttimeHMS(0,0,0);
  Timer.starttimer;


end;


{************* DFBtnClick ***********8}
procedure TForm1.DFBtnClick(Sender: TObject);
{Depth first search}
var
  s:string;
begin
  s:=SetupToSolve('Depth 1st');
  if s='' then exit;
  memo2.lines.add('Depth first (thorough but slow and not may not be optimal)');
  screen.cursor:=crhourglass;
  graph.MakePathsToDF(s,goaledt.text,16, Goalfound);
  timer.stoptimer;
  screen.cursor:=crdefault;
  StopPanel.visible:=false;
  if tag<>0 then memo2.lines.add('Stopped by user');
end;

{*************** BFBtnClick ***********}
procedure TForm1.BFBtnClick(Sender: TObject);
var
  s:string;
begin
  s:=setuptosolve('Breadth 1st');
  if s='' then exit;
  screen.cursor:=crhourglass;
  memo2.lines.add('Breadth first (optimal but may be slow)');
  graph.MakePathsToBF(s,goal,maxdepth+1, Goalfound);
  timer.stoptimer;
  screen.cursor:=crdefault;
  StopPanel.visible:=false;;
  if tag<>0 then memo2.lines.add('Stopped by user');
end;

{************** DSolveBtnClick ***********}
procedure TForm1.DSolveBtnClick(Sender: TObject);
{Dijkstra search for solution}
var
  list:TIntlist;
  s:string;
begin
  s:=SetUpToSolve('Dijkstra');
  If s='' then exit;
  screen.cursor:=crhourglass;
  Memo2.lines.add('"Dijkstra''s Shortest Path" algorithm; fast and optimal');
  list:=TIntlist.create; {"List" is an integer list containing pointers to
                          solution nodes if "graph"}
  if graph.dijkstra(s,goal,list, goalfound)<0 then showmessage('Djijkstrra search failed') ;
  timer.stoptimer;
  screen.cursor:=crdefault;
  StopPanel.visible:=false;
end;

{************** MakeAGameBtnClick ***********}
procedure TForm1.MakeAGameBtnClick(Sender: TObject);
{make a specific board}
var
  n:integer;
  s,g:string;
  index:integer;
  list:TIntlist;
begin
  list:=TIntList.create;
  memo1.clear;
  memo2.clear;
  manualplay:=false;
  g:=goaledt.text;
  if  validgoal(g) then goal:=g;
  maxdepth:=15; {game length unknown, let searches go to longest valid game length}
  board:=KeyToBoard(edit3.text);
  s:=BoardToKey(board);
  if not graph.find(s,index) then showmessage('No solution for this board')
  else
  begin
    screen.cursor:=crhourglass;
    n:=graph.dijkstra(s,goal,list);
    screen.cursor:=crDefault;
    if n<0
    then showmessage('No Dijkstra solution for this board');
  end;
  showboard;
  origboard:=board;
  list.free;
end;

{********** BoardGridDrawCell **********}
procedure TForm1.BoardgridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw the coal/diamond shapes based on cell contents}
begin
  with boardgrid do
  begin
    canvas.fillrect(rect);
    if displaygrp.itemindex=1
    then canvas.textout(rect.left+2, rect.top+2, cells[acol,arow])
    else
    begin
      if cells[acol,arow]='' then cells[acol,arow]:=' ';
      if cells[acol,arow][1] in ['0'..'3'] then
      imagelist1.draw(canvas,rect.left,rect.top,strtoint(cells[acol,arow]));
    end;
  end;
end;

{********** StopbtnClick ************}
procedure TForm1.StopPanelClick(Sender: TObject);

begin
  graph.stop:=true;
  tag:=1;
end;

{************** DisplayGrpClick ************}
procedure TForm1.DisplayGrpClick(Sender: TObject);
{Force board to redraw after truning images draw o n or off}
begin
  boardgrid.invalidate;
end;

{************** Memo2Click **************}
procedure TForm1.Memo2Click(Sender: TObject);
{Replay an calculated soluted by displaying moves one per second}
var
  i:integer;
  s,s2:string;
  intgoal:integer;
begin
  intgoal:=KeyToBoard(goal);
  with memo2 do
  for i:= 0 to lines.count-1 do
  begin
    s:=trim(lines[i]);
    if (length(s)>=11) and (s[1] in ['0'..'3']) then
    begin
      s2:=stringreplace(s,' ','',[rfReplaceall]);
      board:={stringrep}Keytoboard(copy(s2,1,9));
      showboard;
      application.processmessages;
      sleep(1000);
      if board=intGoal{ $3FFFF} then showmessage('Winner!');
    end;
  end;
end;

{***************** RestorebtnClick **********}
procedure TForm1.RestorebtnClick(Sender: TObject);
{restore the board to the last generated board state}
begin
  memo1.clear;  {forget any user moves}
  board:=origboard;   {restore board}
  showboard;
end;



{*******************************************}
{**               Test routines           **}
{*******************************************}


{*************** OneMoveFwdBtnClick *********}
procedure TForm1.OneMoveFwdBtnClick(Sender: TObject);
{Test single move forward}
var b:integer;
begin
  b:=keytoboard(edit1.text);
  b:=forwardmove(b,spinedit2.value);
  edit2.text:=boardtoKey(b);
end;

{************** OneMovebackBtnClick *************}
procedure TForm1.OneMovebackBtnClick(Sender: TObject);
{Test single move back}
var b:integer;
begin
  b:=Keytoboard(edit1.text);
  b:=reversemove(b,spinedit2.value);
  edit2.text:=boardtoKey{stringrep}(b);
end;

{************ CountUniqueBtnClick **********}
procedure TForm1.CountUniqueBtnClick(Sender: TObject);
{Generate 1,000,000 random moves backwards from current goal (the solution space)
 and count number of unique positions that can be reached}
var
  i,j,n,ncount,sum:integer;
begin
  for i:=0 to high(visited) do visited[i]:=false{''};
  ncount:=0;
  screen.cursor:=crHourGlass;
  begin
    board:=keytoboard(goal);  {key equivalemt of board 333333333}
    for j:= 0 to 1000000 do
    begin
      n:=random(9);
      board:=forwardmove(board,n);
      visited[board]:=True{'Y'};
      inc(ncount)
    end;
  end;
  sum:=0;
  screen.cursor:=crdefault;
  for i:= 0 to high(visited) do if visited[i]{<>''}  then inc(sum);
  memo3.lines.add(inttostr(sum)+' unique nodes, '+inttostr(ncount)+' nodes generated');
end;

{************ PruneGraphSolnClick *************}
procedure TForm1.PruneGraphBtnClick(Sender: TObject);
{Generate 16,384 solvable positions and make new Graph list}
var
  i,j:integer;
  s2:string;
  b,bb:integer;
  filename:string;
begin
  CountUniqueBtnClick(sender);
  if assigned(graph) then graph.free;
  Graph:=TGraphList.create;
  filename:='CoalDiamondPrunedGraph.gph';
  screen.cursor:=crHourglass;
  for i:= low(visited) to high(visited) do
  begin
    if  visited[i]{<>''}
    then graph.addnode(boardtoKey(i));
  end;
  Graph.finalize;
  memo3.lines.add(intTostr(graph.count)+ ' board positions added');
  memo3.lines.add('Adding 9 adjacents for each board');
  for i:=0 to graph.count-1 do
  with graph do
  begin
    bb:=KeyToBoard(strings[i]); {here is a possible board}
    for j:=0 to 8 do {for each cell the user could click}
    begin
      b:=forwardmove(bb,j);
      s2:=boardtokey(b);
      addedge(strings[i],s2,1);
    end;
  end;
  screen.cursor:=crDefault;
  graph.savegraph(filename);
end;

var
 maxlength:integer;
 lengths:array of integer;
 solutions:array[0..16] of tstringlist;



{************** GoalFound2 ***********}
procedure TForm1.GoalFound2;
{Procedure called by  Dijstra solve all when solution is
 found to save solutions}
var
  i,c,r:integer;
  s,s2,s3:string;
begin
  with graph.q do
  begin
    if count=0 then showmessage('Unsolvable found, error?')
    else
    with memo2, lines do
    begin
       i:= TNode(graph.q[0]).index;
       s3:=BoardToKey(KeyToBoard(graph[i]))+'=';
       for i:=0 to graph.q.count-1 do
       with  TNode(graph.q[i]) do
       begin
         s:=graph[index];
         //s3:=BoardToStringrep(StringrepToBoard(s)+'=');
         if i<graph.q.count-1 then
         begin {derive the move from  two board positions}
           s2:=graph[TNode(graph.q[i+1]).index];
           if (s[1]<>s2[1])
              and (s[2]<>s2[2])
              and (s[3]<>s2[3]) then R:=1
           else
           if (s[4]<>s2[4])
              and (s[5]<>s2[5])
              and (s[6]<>s2[6]) then R:=2
           else
           if (s[7]<>s2[7])
              and (s[8]<>s2[8])
              and(s[9]<>s2[9]) then R:=3
           else r:=-1; {Error!}

           if (s[1]<>s2[1])
              and (s[4]<>s2[4])
              and(s[7]<>s2[7]) then C:=1
            else
            if (s[2]<>s2[2])
              and (s[5]<>s2[5])
              and(s[8]<>s2[8]) then C:=2
            else
            if (s[3]<>s2[3])
              and (s[6]<>s2[6])
              and(s[9]<>s2[9]) then C:=3
              else c:=-1; {error!}
            s3:=s3+ format('(%d,%d),',[c,r]);
          end;
       end;
       solutions[graph.q.count-1].add(s3);
    end;
  end;
end;

{************ GenAllBtnClick ********}
procedure TForm1.GenAllBtnClick(Sender: TObject);
{Generate all 16,384 games, save all solutions as stringlists,
 and calculate length distribution}
{Results
1 games of length 0
9 games of length 1
45 games of length 2
165 games of length 3
465 games of length 4
1017 games of length 5
1765 games of length 6
2493 games of length 7
2907 games of length 8
2803 games of length 9
2223 games of length 10
1431 games of length 11
723 games of length 12
267 games of length 13
63 games of length 14
7 games of length 15
0 games of length 16
0 unsolved games
7497 are part of longer solutions
}

var
  i,j,L,index:integer;
  list:TIntList;
  NoSolveCount, dupsolvecount:integer;
  solvedlist:TStringlist;
  s2:string;
begin
  for i:=0 to 16 do solutions[i]:=TStringlist.create;
  solvedlist:=TStringList.create;
  solvedlist.sorted:=true;
  NoSolveCount:=0;
  DupSolveCount:=0;
  setlength(lengths,100);
  list:=TIntList.create;
  for i:=0 to 99 do lengths[i]:=0; {array for game length distribution}
  maxlength:=0;
  {Play all games}
  for i:=0 to graph.count-1 do
  begin
    with graph do
    if not solvedlist.find(strings[i],index) then {this node has not appeared in a solution}
    begin
      s2:=graph.strings[i];
      if dijkstra(graph.strings[i],goal, list,Goalfound2)>=0 then
      {solution found}
      begin

        with list do
        if count>maxlength then
        begin
          maxlength:=count;
          memo3.lines.add('Max game length so far = '+inttostr(count-1));
        end;
        inc(lengths[list.count-1]);
        for j:=0 to list.count-1 do
        begin
          if solvedlist.find(graph[list[j]],index) then
          begin
            if integer(solvedlist.objects[index])> j
            then solvedlist.objects[index]:=TObject(j);
          end
          else solvedlist.addobject(graph[list[j]], TObject(j));
        end;
      end
      else inc(noSolveCount);
    end
    else
    begin {update lengths with shortest path from here to solution}
      L:=integer(solvedlist.objects[index]);
      inc(lengths[L]);
      inc(DupSolveCount);
    end;
    countlbl.caption:=inttostr(i+1)+' games played';
  end;
  for j:=0 to 16 do solutions[j].savetofile('Solution'+format('%2d',[j])+'.txt');
  for i:= 0 to maxlength do memo3.lines.add(inttostr(lengths[i])
                + ' games of length '+inttostr(i));
  memo3.lines.add(inttostr(Nosolvecount)+' unsolved games');
  memo3.lines.add(inttostr(DupsolveCount)+' are part of longer solutions');
  list.free;
  solvedlist.free;
end;

{************ SearchSolutionsBtnClick ***********}
procedure TForm1.SearchSolutionsBtnClick(Sender: TObject);
var
  list:TStringlist;
  maxmoves,N:integer;
  ncount:array[0..16] of integer;

  procedure makenextpath(b:integer; clicked:integer;
                           pathlength:integer);
    {recursive search for solutions}
    var
      i:integer;
      newboard:integer;
      index:integer;
      s:string;
      intgoal:Integer;
    begin
      intgoal:=KeytoBoard(goal);
      newboard:=reversemove(b,clicked);  {moving backwards from solution}
      if newboard=intgoal then exit;{we have cycled back to the start point}
      s:=boardtoKey(newboard);

      if not list.find(s,index) then
      begin  {first solution for this board}
        index:=list.addobject(s,TObject(1 shl pathlength));
        inc(ncount[pathlength]);
        memo4.lines[pathlength+1]:=inttostr(pathlength)+': '+inttostr(ncount[pathlength]);
        if pathlength=maxmoves then application.processmessages;
      end
      else
      begin {add this pathlength as another solution path length for this board}
        n:=integer(list.objects[index]);
        n:=n or (1 shl pathlength);
        list.objects[index]:=TObject(n);
      end;
      if pathlength<maxmoves
      then for i:=clicked to 8 do makenextpath(newboard, i, pathlength+1);
    end;

var
  i,j:integer;
  sum,sum2,mask:integer;
  ncount2:array[0..16] of integer;
  intgoal:integer;
begin
  memo4.clear;
  memo4.lines.add('Depth first moves to solve ');
  maxmoves:=16;
  screen.cursor:=crhourglass;
  list:=tstringlist.create;
  list.sorted:=true;
  for i:=0 to 16 do
  begin
    ncount[i]:=0;
    ncount2[i]:=0;
    memo4.lines.add(inttostr(i)+': 0');
  end;
  {one solution with 0 moves!}
  intGoal:=keytoboard(goal);
  list.addobject(goal,TObject(1));
  ncount[0]:=1;
  memo4.lines[1]:='0: '+inttostr(ncount[0]);
  for i:=0 to 8 do
  begin
    makenextpath(intGoal,i,1);
  end;
  Memo3.clear;
  Memo3.lines.add('Starting boards with longest (15) moves to solve ');
  for i:=0 to list.count-1 do
  begin  {find breadth first totals);
    {find rightmost bit}
    for j:=0 to 16 do
    begin
      mask:=1;
      n:= (mask shl j)and integer(list.objects[i]);
      if n>0 then
      begin
        inc(ncount2[j]);
         if j=15 then memo3.lines.add(list[i]);
        break;
      end;
    end;
  end;
  {Show statistics}
  sum:=0; {Depth first totals}
  sum2:=0; {Breadth first totals}

  memo4.lines.add('Breadth first moves to solution ');
  for i:=0 to 16 do
  begin
    inc(sum,ncount[i]);
    inc(sum2,ncount2[i]);
    memo4.lines.add(inttostr(i)+': '+inttostr(ncount2[i]));
  end;
  memo4.lines.add(format('Unique Totals DF:%d, BF:%d, All:%d',[sum,sum2,list.count]));
  screen.cursor:=crdefault;
end;

{********* GoalEdtKeyPress **********}
procedure TForm1.GoalEdtKeyPress(Sender: TObject; var Key: Char);
{Only allow blanks or valid digits}
begin
  If not (key in [' ','0'..'3']) then key:=#0;
end;

{************ GoalEdtExit *************}
procedure TForm1.GoalEdtExit(Sender: TObject);
{Do final validation on the goal when users goes to another control}
var
  g:string;
begin
  g:=goaledt.Text;
  if validgoal(g) then
  begin
    goal:= g;
    edit1.Text:=goal;
  end;
end;

{************* GoalEdtKeyUp **********}
procedure TForm1.GoalEdtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{If the length of the deblanked goal string is > 9 then ignore this key}
begin
  If length(stringreplace(goaledt.text,' ','',[rfreplaceall])) >=9 then key:=0;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
