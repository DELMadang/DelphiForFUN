unit U_Numbrix;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
"Numbrix" (Tradmeark) is a puzzle game currently appearing in the "Ask Marilyn"
column of Parade Magazine.  The puzzles are satisfyingly solvable, some would
say "too easy".   New Numbrix puzzles are currently (Sept, 2008) being posted
frequently on the www.parade.com web site.

Given a square grid, fill the cells with a chain of integers from 1 to the
number of cells (81 in a 9x9 grid, for example),  with each number adjoining the
preceding one vertically or horizontally.  Some of the numbers are pre-filled,
so your entries must of course match up to the pre-filled ones.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Grids, Spin;

type
  TBoard=array of array {[0..11, 0..11]} of integer; {allow boards up to 10x10}

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    Solvebtn: TButton;
    StringGrid1: TStringGrid;
    DebugBox: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    Loadbtn: TButton;
    ForceFillBtn: TButton;
    CaseNameLbl: TLabel;
    ReloadBtn: TButton;
    OpenDialog1: TOpenDialog;
    Label6: TLabel;
    Speedbar: TScrollBar;
    Button3: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Checkbtn: TButton;
    DebugCheckBox: TCheckBox;
    PauseMemo: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SolvebtnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure LoadbtnClick(Sender: TObject);
    procedure ForceFillBtnClick(Sender: TObject);
    procedure ReloadBtnClick(Sender: TObject);
    procedure SpeedbarChange(Sender: TObject);
    procedure CheckbtnClick(Sender: TObject);
    procedure DebugCheckBoxClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PauseMemoClick(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
  public
    { Public declarations }
    board:Tboard;
    location:array of TPoint;
    solved:boolean;
    filename:string;
    showprogress:boolean;
    paused:boolean;
    procedure initboard;
    procedure showboard;
    function findnext(nextx,nexty,n:integer):boolean;
    function fillholes:boolean;
    procedure loaddefault;
    procedure loadcase(fname:string);
    function nbrneighbors(const nextx,nexty:integer):integer;
    function leaveshole(const nextx,nexty,N:integer):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var

  size:integer=9;
  sqsize:integer;

  Default: array [1..9,1..9] of integer=
         ((03,04,05,78,77,68,67,64,63),
          (02,00,00,00,00,00,00,00,62),
          (09,00,00,00,00,00,00,00,61),
          (10,00,00,00,00,00,00,00,58),
          (11,00,00,00,00,00,00,00,57),
          (12,00,00,00,00,00,00,00,38),
          (13,00,00,00,00,00,00,00,37),
          (14,00,00,00,00,00,00,00,36),
          (15,16,23,24,25,30,31,34,35)
          );

  offsets: array[1..4] of TPoint=
       ((x:0; y:-1), (x:0;y:1), (x:-1;y:0),(x:1;y:0));


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{**************** FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);

begin
 loaddefault;
 opendialog1.initialdir:=extractfilepath(application.exename);
 with stringgrid1 do canvas.font:=font;
end;

{********** Initboard *********}
procedure TForm1.initboard;
var
  c:integer;
begin
  setlength(board, size+2, size+2);
  setlength(location,sqsize+1);
  {Set up sentinels as border around the board to simplify checking}
  for c:=0 to size+1 do
  begin
    board[c,0]:=100;
    board[0,c]:=100;
    board[c,size+1]:=100;
    board[size+1,c]:=100;
  end;
end;

{*************** Loadcase ***********}
procedure TForm1.loadcase(fname:string);
var
  f:textfile;
  c,r:integer;
begin
  tag:=1; {stop any existing run}
  application.processmessages;
  assignfile(f,fname);
  filename:=fname;
  reset(f);
  CasenameLbl.caption:=extractfilename(filename);
  {determine size}
  size:=0; {count the number of entries on thr first line}
  while not eoln(f) do
  begin
    read(f,r);
    inc(size);
  end;
  sqSize:=size*size;
  initboard;
  with stringgrid1 do
  begin
    rowcount:=size;
    colcount:=size;
    defaultcolwidth:=(width-size-2) div size;
    defaultrowheight:=(height-size-2) div size;
  end;
  for c:=1 to sqSize do location[c]:=point(0,0);
  reset(f);
  for r:=1 to size do
  begin
    for c:=1 to size do
    begin
      read(f,board[c,r]);
      if board[c,r]>0 then location[board[c,r]]:=Point(c,r);
    end;
    readln(f);
  end;
  closefile(f);
  showboard;
end;


{*********** Loaddefault **********}
procedure Tform1.loaddefault;
var
  c,r:integer;
begin
  {load the default board}
  //for c:=1 to sqsize do location[c]:=point(0,0);
  filename:=extractfilepath(application.exename)+'Numbrix1.txt';
  if fileexists(filename) then loadcase(filename)
  else
  begin
    size:=9;
    sqsize:=81;
    initboard;
    With stringgrid1 do
    begin
      for r:=1 to size do
      for c:=1 to size do
      if default[r,c]>0 then
      begin
        board[c,r]:=default[r,c];
        location[default[c,r]]:=Point(c,r);
      end
      else
      begin
        board[c,r]:=0;
      end;
      showboard;
    end;
  end;
end;

{********** Showboard *******}
procedure TForm1.showboard;
var
  c,r:integer;
begin
  with stringgrid1 do
  for c:=1 to size do
  for r:=1 to size do
  begin
    if board[c,r]>0 then cells[c-1,r-1]:=inttostr(board[c,r])
    else cells[c-1,r-1]:='';
  end;
end;

{*********** Fillholes **********}
function tform1.fillholes:boolean;
{if an empty cell is surrounded on three all 4 side, then the value, n of the
 cells must have neighbors N-1 and N+1 and N can be filled in, otherwise it is
 and orphan cell that can never be filled and is an error}
var
  c,r:integer;
  i,j:integer;
  OK:boolean;
  n1,n2:integer;
begin
  result:=true;
  for c:=1 to size do
  begin
    for r:=1 to size do
    begin
      if board[c,r]=0 then {check neighbors}
      begin
        ok:=false;
        for i:=1 to 3 do
        with offsets[i] do
        begin
          n1:=board[c+x, r+y];
          for j:=i+1 to 4 do
          with offsets[j] do
          begin
            n2:=board[c+x,r+y];
            if (n1=0) or (n2=0) or (abs(n1-n2)=2) then
            begin
              OK:=true;
              break;
            end;
          end;
          if ok then break;
        end;
        if not OK then
        begin
          result:=false;
          break;
        end;
      end;
    end;
    if not result then break;
  end;
end;

{************* NbrNeighbors *************8}
function Tform1.nbrneighbors(const nextx,nexty:integer):integer;
    var
      i:integer;
    begin
      result:=0;
      for i:=1 to 4 do
      with offsets[i] do
      begin
        if board[nextx+x, nexty+y]>0 then inc(result);
      end;
    end;

    {---------- LeavesHole --------}
    function TForm1.leaveshole(const nextx,nexty,N:integer):boolean;
    {if nbr N to be placed in cell nextx, nexty would leave a hole that could
    not be filled then return true - not a good thing since the hole could never
    be filled.  Hole is OK if one of the neigbors is 2 higher or lower than N
    and that number has not already been placed elsewhere, or if it is the last
    number because one of the neighbors = lastnumber-1}

        {----------HasHigherNeighbor ---------}
        function HasHighNeighbor(nextx, nexty:integer):boolean;
        var
          i:integer;
          n2:integer;
        begin
          result:=false;

          for i:=1 to 4 do
          with offsets[i] do
          begin
            n2:=board[nextx+x, nexty+y];
            if (n2=sqsize-1) then
            begin
              result:=true;
              break;
            end;
            if (abs(n2-n)=2) and
               (location[(n2+n) div 2].x=0) then
            begin
              result:=true;
              break;
            end;
          end;
        end;    {HasHighNeighbor}

     var
      i:integer;
    begin  {examine neighbors for a hole}
      result:=false;
      for i:=1 to 4 do
      with offsets[i] do
      begin
        if (board[nextx+x, nexty+y]=0)
        and ((nbrneighbors(nextx+x, nexty+y)=4))
        {if hole has 3 neighbors and none of them are 81, then return true}
        and (not hasHighNeighbor(nextx+x, nexty+y))
        then
        begin
          result:=true;
          exit;
        end;
      end;
    end;

{************** Findnext ************}
function TForm1.findnext(nextx,nexty,n:integer):boolean;
{Recursive depth first search for solutions}
var
  i:integer;
  nextval:integer;
begin
  result:=false;
  if tag>0 then  exit; {Stop button was pushed}
  {Check pause condition}
  if     (n=spinedit3.value)
        and (nextx=spinedit4.value)
        and (nexty=spinedit5.value)

  then
  begin {Pause condition met - loop so other parameters can be changed until
         pause condition is reset}
    showboard;
    screen.cursor:=crdefault;
    paused:=true; {set paused flag}
    pauseMemo.visible:=true; {show the "Click to Continue" control}
    while  (paused=true) and (tag=0) do
    begin {loop waiting for user to tell us to continue or stop}
      application.processmessages;
      sleep(400);
    end;
    {pause reset, continue search}
    if tag>0 then begin result:=true;  exit; end; {Stop button was pushed}
    pausememo.visible:=false;
    screen.cursor:=crHourglass;
    spinedit3.visible:=true;
  end;

  board[nextx,nexty]:=n;  {set the move requested}
  nextval:=n+1;
  {check if we need to show progress}
  if (showprogress) and (n>=spinedit1.value) and (n<=spinedit2.value) then
  begin {show progress if requested}
    stringgrid1.cells[nextx-1,nexty-1]:=inttostr(n);  {show the number}
    application.processmessages;
    if showprogress then
    begin
      sleep(750-3*speedbar.position div 4);
      stringgrid1.cells[nextx-1,nexty-1]:=''; {to blink predefined numbers}
      stringgrid1.update;
      sleep(250-speedbar.position div 4);
      stringgrid1.cells[nextx-1,nexty-1]:=inttostr(n);  {show the number}
    end;
  end;

  (*
    {Search would be more efficient if we check if this addition leaves a hole
    which cannot be filled - might a well prune this branch of the search tree
    now - current version does not work in all cases and needs debugging}
    if leaveshole(nextx, nexty,N) then
    begin
      if location[n].x=0  {it is not an initial point}
      then board[nextx,nexty]:=0; {remove the entry if we are backtracking}
      result:=false;
      exit;
    end;
  *)



  if n=sqsize then {all number have been placed}
  begin
    result:=true;
    solved:=true;
    exit;  {all numbers placed}
  end;

  for i:=1 to 4 do
  with offsets[i] do
  begin
    if (location[nextval].x=0) and (board[nextx+x, nexty+y]=0) then
    begin
      result:=findnext(nextx+x, nexty+y, nextval); {recursive search call}
      if result then break; {solved}
    end
    else if board[nextx+x, nexty+y]=nextval then
    begin
      result:=findnext(nextx+x, nexty+y, nextval);  {recursive search call}
      //if result and  solved then exit;
      break; {no need to check the rest since N+1 must be at this location}
    end;
  end;

  if not result then
  begin  {we got stopped but it is not solved yet, backtrack }
    application.processmessages;
    if location[n].x=0 then {if it is not a pre-defined point}
    begin
      board[nextx,nexty]:=0; {remove the entry}
      if (showprogress) and (n>=spinedit1.value) and (n<=spinedit2.value) then
      begin
        stringgrid1.cells[nextx-1,nexty-1]:='';
        stringgrid1.update; {show that number has been removed}
        if showprogress then sleep(1000-speedbar.position); {for a little while}
      end;
    end; {not predefined}
  end; {result=false}
end;


{***************** SolvebtnClick ***********}
procedure TForm1.SolvebtnClick(Sender: TObject);
var
  msg:string;
  i,n,c,r:integer;
  start:TPoint;
  starters:array of integer;
  lastindex,nextindex:integer;
  nearstart:TPoint;
  dist,lowfound:integer;
  starttime,freq,stop:int64;
  secs:extended;
begin
  //forcefillBtnClick(sender);
  queryperformancecounter (starttime);
  queryperformancefrequency(freq);
  setlength(starters, sqsize+1);
  if location[1].x>0 then
  begin {depth first search for next moves}
    lastindex:=0;
    nextindex:=0;
    for c:=1 to size do
    for r:=1 to size do
    if board[c,r]=1 then
    begin
      start:=point(c,r);
      lastindex:=0;
      break;
    end;
  end
  else {oh,oh, #1 location is not specified, we'll search starting from
        board locations nearest to the smallest number that is specified}
  begin {make a list of starting points}
    for i:=1 to sqsize do
    if location[i].x>0 then
    begin
      NearStart:=location[i];
      lowfound:=i;
      break;
    end;
    lastindex:=0;
    for c:=1 to size do
    for r:=1 to size do
    begin
      if board[c,r]=0 then
      begin
        dist:=abs(c-nearstart.x)+abs(r-nearstart.y);
        if (dist <=lowfound-1) then
        begin {any valid starting location must be  an most "lowfound"-1 moves
               away from the "1", may be less if the path zig-zags}
          inc(lastindex);
          starters[lastindex]:=100*c+r;
        end;
      end;
    end;
    n:=starters[1];
    start.x:= n div 100;
    start.y:= n mod 100;
    nextindex:=1;
  end;

  tag:=0;
  solved:=false;
  screen.cursor:=crhourglass;

  //if  fillholes then
  repeat
    inc(nextindex);
    if findnext(start.x, start.y,1) then
    begin
      msg:='Solved';
    end
    else
    begin
      if nextindex<=lastindex then
      begin
        n:=starters[nextindex];
        start.x:= n div 100;
        start.y:= n mod 100;
      end;
      msg:='No solution found';
    end;
  until (tag>0) or solved or (location[1].x>0) or (nextindex>lastindex);
  queryperformancecounter(stop);
  secs:=(stop-starttime)/freq;
  if secs<1.0 then
  msg:=msg+format(' Time: %.2f msecs',[1000.0*secs])
  else msg:=msg+format(' Time: %.2f secs',[secs]);
  showboard;
  screen.cursor:=crdefault;
  showmessage(msg);
end;

{************ StopBtn **************}
procedure TForm1.Button3Click(Sender: TObject);
begin
  tag:=1;
end;

{************ LoadBtnClick ************8}
procedure TForm1.LoadbtnClick(Sender: TObject);
begin
  if opendialog1.execute then loadcase(opendialog1.filename);
end;

{************** ForceFillbtnClick **********8}
procedure TForm1.ForceFillBtnClick(Sender: TObject);
{fill all cells that must contain speficic values beased on neighboring values}
var
  c,r:integer;
  i,n:integer;
  closecount, sumx, sumy:integer;
  changed:boolean;
begin
  {commented statements prevent fill filling of all forced numbers,
   only one pass thrugh the data per button click}
  // reloadbtnclick(sender); {reset the board}
  //repeat
    changed:=false;
    for n:=1 to sqsize do
    begin
      if location[n].x=0 then {this # is not on the initial board}
      begin  {look for a cell where it must be placed}
        for c:=1 to size do
        begin
          for r:=1 to size do
          begin
            If ((board[c,r] =n+1) or ((n>1) and (board[c,r]=n-1)))
            and (nbrneighbors(c,r)=3) then
            {found a # next or previous to n with only one choice to be adjacent}
            begin
              for i:=1 to 4 do
              with offsets[i] do
              begin  {find the empty neighbor}
                if board[c+x,r+y]=0 then
                begin {place the number there}
                  board[c+x,r+y]:=n;
                  location[n]:=point(c+x,r+y);
                  changed:=true;
                  break;
                end

              end; {i loop}
            end;
            if location[n].x>0 then break;
            {2nd test}
             {if any two nigbors of an empty cell contain values that differ from
              N by 1, then N must belong in this cells}
            if (board[c,r]=0) then
            begin
              closecount:=0;
              sumx:=0; sumy:=0;
              for i:=1 to 4 do
              with offsets[i] do
              if (board[c+x,r+y]>0)
              and  ( (board[c+x,r+y]-1=N)
                 or (board[c+x,r+y]+1=N)) then
              begin
                sumx:=sumx+x;
                sumy:=sumy+y;
                inc(closecount);
              end;
              if closecount=2 then
              begin {there are two adjoing neighbors with values adjacent to N}
                {check for one more "gotcha": if the neighbors lie in both
                 directions (L shape) then the diagonally opposite cell must
                 not be emnpty
                 eg:  N+1 0
                      0   N-1 cannot fill either of the 0 locations with N}
                if (sumx=0) or (sumy=0)  {adjacents are inline}
                  or (board[c+sumx,r+sumy]<>0)
                then
                begin
                  board[c,r]:=n;  {so N must belong here}
                  location[n]:=point(c,r);
                  changed:=true;
                  break;
                end;
              end;
            end;
          end; {r loop}
          if location[n].x>0 then break; {N added, might as well stop checking}
        end; {c loop}
      end
    end; {n loop}
  //until not changed;
  showboard;
  if not changed then Showmessage('No changes')
  else showboard;
end;

{********** Reloadbtn *******8}
procedure TForm1.ReloadBtnClick(Sender: TObject);
begin
  loadcase(filename);
end;

{*********** SpeedbarChange ********}
procedure TForm1.SpeedbarChange(Sender: TObject);
begin
  with speedbar do
  if position=max then showprogress:=false else showprogress:=true;
end;

{********** CheckBtnClick ********}
procedure TForm1.CheckbtnClick(Sender: TObject);
var
  c,r,next:integer;
  c1,r1:integer;
  i:integer;
  OK:boolean;
begin
  c:=0;
  {find the start}
  for c1:=1 to size do
  begin
    for r1:=1 to size do
    if board[c1,r1]=1 then
    begin
      c:=c1;
      r:=r1;
      break;
    end;
    if c>0 then break;
  end;
  if c>0 then
  begin
    next:=1;
    repeat
      inc(next);
      OK:=false;
      for i:=1 to 4 do
      with offsets[i] do
      if board[c+x,r+y]=next then
      begin
        inc(c,x);
        inc(r,y);
        OK:=true;
        break;
      end;
    until (not OK) or (next=sqsize);
    if next=sqsize then showmessage('Solution OK!')
    else showmessage(format('Error: There is no %d adjoining %d',[next,next-1]));
  end
  else showmessage('Error: No "1" was found');
end;

{*********** DebugCheckBoxClick *********}
procedure TForm1.DebugCheckBoxClick(Sender: TObject);
begin
  debugbox.visible:=debugcheckbox.checked;
end;

{*********** StringGrid1DrawCell ********}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  n:integer;
begin
  with stringgrid1 do
  begin

    n:=strtointdef(cells[acol,arow],0);
    canvas.fillrect(rect);
    if (n>0) and (n<=SqSize) and (location[n].x>0)
    then
    begin
       canvas.font.color:=clblue;
    end
    else
    begin
      canvas.font.color:=clred;
    end;
    canvas.pen.color:=clblack;
    canvas.TextOut(rect.left+4,rect.top+4,cells[acol,arow]);
    if gdfocused in state
    then canvas.drawfocusrect(rect);
  end;
end;

procedure TForm1.PauseMemoClick(Sender: TObject);
begin
  paused:=false;
end;

{********** StringRrid1SetEditText ************88}
procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
var
  n:integer;  
begin
  with stringgrid1 do
  begin
    n:=strtointdef(value,0);
    if (n>0) and (N<=sqsize) then
    begin
      board[acol+1,arow+1]:=n;
    end;
  end;
end;  

end.
