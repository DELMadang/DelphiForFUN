unit U_GraphTraverse2;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, shellAPI, ComCtrls;

const
  boardsize:integer=15;

type
  TPath=array of integer;
  TBoard=array of array of integer;

  TForm1 = class(TForm)
    SolveBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    GenerateBtn: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    SmartSolveBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StringGrid1: TStringGrid;
    TabSheet3: TTabSheet;
    StringGrid3: TStringGrid;
    StringGrid2: TStringGrid;
    AnimateBox: TCheckBox;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SolveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SmartSolveBtnClick(Sender: TObject);
    procedure TabSheetEnter(Sender: TObject);
    procedure TabSheetExit(Sender: TObject);
    procedure AnimateBoxClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
  public
    { Public declarations }
    board:TBoard;  {the array of numbers}
    globalmaxpath, globalminpath:TPath; {largest & smallst paths found}
    pathstried:integer; {coun t of paths tested}
    UpdateDisplay:integer; {loop count begtween display updates}
    starttime,freq:int64; {run start time internal clock count and frequency}
    running:boolean; {flag=true while doing Version1 (exhaustive) search}
    Procedure getpath(p:TPoint; pathin:TPath);
    Procedure UpdatePathDisplay(final:boolean);
    Procedure resetlabels;
    procedure generateBoard;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
{initialization stuff at create time}
begin
  randomize;
  updatedisplay:=1000;
  queryperformancefrequency(freq);
  pagecontrol1.activepage:=tabsheet1;
  generateboard;
end;


{***************** StringGrid1DrawCell ***********}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{draw cells that have changed}
  var
    s:string;
begin
  with Sender as TStringGrid, canvas do
  Begin
    s:=cells[acol,arow];
    if running then
      if tag>0 then brush.color:=clred
      else brush.color:=clwhite
    else
    if s<>'' then
    case integer(objects[acol,arow]) of
      1: begin
           brush.color:=rgb(150,255,255);  {maxpath}
         end;

      2: begin
           brush.Color:=rgb(255,255,150);  {minpath}
         end;
      3: brush.color:= rgb(150,255,150);  {both paths}
      else brush.color:=clwhite;
    end;
    FillRect(Rect);
    if (s<>'00') and (s<>'999')
    then Textout(rect.left+2, rect.top+2,s)   {only draw the non-zero cells}
    else if (s='999') then  {fill in start and finish cells}
    begin
      if acol=0 then Textout(rect.left+2,rect.top+2,'S')
      else if acol=boardsize-1 then Textout(rect.left+2,rect.top+2,'F')
    end;
  end;
end;

{******************* GetPath ************}
Procedure TForm1.getpath(p:TPoint; pathin:TPath);
{recursive routine to trace all  paths through the board}
var
  i:integer;
  secs:real;
  pathout:TPath;
  now:int64;

  Begin
    setlength(pathout,length(pathin));
    for i:= 0 to boardsize-1 do pathout[i]:=pathin[i];
    with p, stringgrid1 do
    Begin
      pathout[x{-1}]:=y{board[x,y]};
      if animatebox.checked then  {if showing paths as tested}
      Begin
        If y>=1 then
        begin
          stringgrid1.tag:=1;
          cells[x-1,y-1]:=cells[x-1,y-1]; {color in the cell we're checking}
          stringgrid1.update;
          sleep(25)
        end;

        {if not at right edge,  check path northeast}
        if (x<boardsize) and (board[p.x+1,p.y-1]>0) then getpath(point(x+1,y-1),pathout);
        {check path east}
        if (x<boardsize) and (board[p.x+1,p.y]>0) then getpath(point(x+1,y),pathout);
        {check path southeast}
        if (x<boardsize) and (board[p.x+1,p.y+1]>0) then getpath(point(x+1,y+1),pathout);
        {path complete - erase current cell}
        if y>=1 then
        with stringgrid1 do
        Begin
          tag:=0;
          cells[x-1,y-1]:=cells[x-1,y-1]; {force redraw?}
          stringgrid1.update;
          sleep(25);
        end;
        application.processmessages;
      end
      else
      {***********************}
      Begin {no animations}
        if (x<boardsize) and (board[x+1,y-1]>0) then getpath(point(x+1,y-1),pathout); {recusive call NorthEast}
        if (x<boardsize) and (board[x+1,y]>0) then getpath(point(x+1,y),pathout); {recursive call East}
        if (x<boardsize) and (board[x+1,y+1]>0) then getpath(point(x+1,y+1),pathout); {recursive call SouthEast}
      end;

      if (animatebox.checked) or (pathstried mod updatedisplay =0)
      {update display once in a while}
      then
      begin
        label1.caption:='Paths tried: '+ inttostr(pathstried);
        queryperformancecounter(now);
        secs:=(now-starttime)/freq;
        label2.caption :=format('Run Seconds: %6.4f',[secs]);
        application.processmessages;
      end;
    end;
    If p.x=boardsize then
    {we're at the end, so calculate max and min path values}
    begin
      inc(pathstried);
      {sum the path in pathout[boardsize]}
      {positions 0 and boardsize-1 are 999, so skip them}
      pathout[boardsize]:=board[2,pathout[2]];
      for i:=3 to boardsize-1 do
          pathout[boardsize]:=pathout[boardsize]+board[i,pathout[i]];

      if pathout[boardsize] > globalmaxpath[boardsize] {it's a new max sum}
      then Begin globalmaxpath:=pathout; UpdatePathDisplay(false); End
      else
      if pathout[boardsize] < globalminpath[boardsize]  {it's a new min sum}
      then Begin globalminpath:=pathout; UpdatePathDisplay(false); End;
    end;

  end;

{***************** UpdatePathDisplay ********}
Procedure Tform1.UpdatePathDisplay(final:boolean);
{periodic display update during exhaustive search}
  var
    s1,s2:string;
    i:integer;
  Begin
    {display current max and min path values}
    s1:='';
    s2:='';
    for i:= 2 to boardsize-1 do
    Begin
      s1:=s1+' '+inttostr(board[i,Globalmaxpath[i]]);
      s2:=s2+' '+inttostr(board[i,Globalminpath[i]]);
      if final then
      begin {set stringgrid object values to color the paths on the grid (see drawcell rtn)}
        if globalmaxpath[i]<>globalminpath[i] then
        begin
          stringgrid1.objects[i-1,globalmaxpath[i]-1]:=TObject(1);
          stringgrid1.objects[i-1,globalminpath[i]-1]:=TObject(2);
        end
        else
        begin {max and min paths intersect, use a 3rd color}
          stringgrid1.objects[i-1,globalmaxpath[i]-1]:=TObject(3);
          stringgrid1.objects[i-1,globalminpath[i]-1]:=TObject(3);
        end
      end;
    end;
    Label3.caption:=s1+', Sum='+inttostr(Globalmaxpath[boardsize]);
    Label4.caption:=s2+', Sum='+inttostr(Globalminpath[boardsize]);
    application.processmessages;
  end;

{********* ResetLabels *****}
Procedure TForm1.resetlabels;
  Begin
    label1.caption:='Paths tried';
    label2.caption:='Run seconds:';
    label3.caption:='';
    label4.caption:='';
  end;



{************** GenerateBoard ***********}
procedure TForm1.generateBoard;
{generate a random board with boardsize rows and columns}
var
  i,j,k:integer;
  start,endx:integer;
begin
  if boardsize mod 2 = 0 then inc(boardsize); {make sure size is odd}
  with stringgrid1 do
  Begin
    rowcount:=boardsize;
    colcount:=boardsize;
    tag:=0;
    invalidate;
  end;
  with stringgrid2 do
  Begin
    rowcount:=boardsize;
    colcount:=boardsize;
    tag:=0;
    invalidate;
  end;
  with stringgrid3 do
  Begin
    rowcount:=boardsize;
    colcount:=boardsize;
    tag:=0;
    invalidate;
  end;
  setlength(Globalmaxpath,boardsize+1);
  setlength(Globalminpath,boardsize+1);
  setlength(board,boardsize+2,boardsize+2);
  for i:=0 to boardsize+1 do
  for j:= 0 to boardsize+1 do board[i,j]:=0;

  for i:= 1 to boardsize do
  Begin   {fill the board with random values}
    if i<=boardsize div 2 + 1 then
    Begin  {fill left half of the board}
      start:=(boardsize+1) div 2 - i + 1;
      endx:=start+2*i-2;
    end
    else
    Begin  {fill right half of the board}
      k:=boardsize+1-i;
      start:=(boardsize+1) div 2 - k +1;
      endx:=start+2*k-2;
    end;
    for j:=start to endx do board[i,j]:=random(24)+1;
  end;
  {Set 999 as flag for start & end}
  board[1,(boardsize+1) div 2]:=999;
  board[boardsize,(boardsize+1) div 2]:=999;
  {load up the stringgrid display}
  For i:= 0 to boardsize-1 do
  For j:=0 to boardsize-1 do
  begin
    StringGrid1.Cells[i,j]:=Format('%2.2D',[Board[i+1,j+1]]);
    Stringgrid1.objects[i,j]:=TObject(0);
    StringGrid2.Cells[i,j]:='';
    Stringgrid2.objects[i,j]:=TObject(0);
    StringGrid3.Cells[i,j]:='';
    Stringgrid3.objects[i,j]:=TObject(0);
  end;
  {no sense of showing the tabs, nothis to display yet}
  tabsheet2.TabVisible:=false;
  tabsheet3.TabVisible:=false;
  label9.Caption:=format('Board size: %d x %d',[boardsize,boardsize]);
end;

{***************** GenerateBtnClick **********}
procedure TForm1.GenerateBtnClick(Sender: TObject);
{Generate a random board}
begin
  Resetlabels;
  boardsize:=random(12)+4; {size from 4 to 15}
  GenerateBoard;
  stringgrid1.setfocus;

end;

{***************** SolveBtnClick **************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{User clicked the version 1 Solve button}
var
  i:integer;
  path:TPath;
  secs:real;
  now:int64;
begin
  screen.cursor:=crHourglass;
  setlength(path,boardsize+1);
  ResetLabels;
  pathstried:=0;
  running:=true;
  QueryPerformanceCounter(starttime);
  for i := 0 to boardsize do
  begin
    globalmaxpath[i]:=0;
    globalminpath[i]:=999;
  end;
  for i:=0 to boardsize-1 do path[i]:=0;
  getpath(point(1, boardsize div 2 +1),path);
  screen.cursor:=crDefault;
  label1.caption:='Paths tried: '+inttostr(pathstried);
  queryperformancecounter(now);
  secs:=(now-starttime)/freq;
  label2.caption :=format('Run Seconds: %6.4f',[secs]);
  UpdatePathDisplay(true);
  stringgrid1.Invalidate; {update the display}
  running:=false;
  pagecontrol1.ActivePage:=tabsheet1;
end;

{***************** StaticText1Click **********}
procedure TForm1.StaticText1Click(Sender: TObject);
{Show DFF Homepage}
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

type
  tSumrec=record {We'll make an array of these, one for each # in the field}
    maxsum,minsum:integer; {Min or max sum to this entry}
    //maxpath,minpath:TPath; {This will hold the path information to each sum}
  end;

{************* SmartSolveBtnClick ************}
procedure TForm1.SmartSolveBtnClick(Sender: TObject);
  var
  i,j,k:integer;
  start,endx:integer;
  max,min,val:integer;
  minindex,maxindex:integer;
  //maxpath,minpath:TPath;
  secs:extended;
  sums:array of array of TSumrec;
  now:int64;


       function getpreventry(i,j:integer; Mode:string; var path:TPath):boolean;
       {recursively back through the sums array to build the path that led to
        sums[i,j]}
       var
         k:integer;
         prev:integer;
         grid:TStringgrid;
         colorindex:integer;
       begin
         if i=2 then {back to the first entry}
         begin {path found}
           for k:=2 to boardsize-1 do
           begin
             if mode='MAX' then
             begin
               grid:=Stringgrid3;
               colorindex:=1
             end
             else
             begin
               grid:=stringgrid2;
               colorindex:=2;
             end;
             grid.objects[k-1,path[k]-1]:=TObject(colorindex);
           end;
           grid.invalidate;
           result:=true;
         end
         else
         begin
           result:=false;
           if mode='MAX' then  prev:=sums[i,j].maxsum-board[i,j]
           else prev:=sums[i,j].minsum-board[i,j];
           for k:=j-1 to j+1 do
           begin
             if mode='MAX' then val:=sums[i-1,k].maxsum
             else val:=sums[i-1,k].minsum;

             if (val>0) and (val= prev) then
             begin
               path[i-1]:=k;
               result:=getpreventry(i-1,k,Mode, path);
               if result then break;
             end;
           end;
         end;
       end; {GetPrevEntry}



begin
  tabsheet2.TabVisible:=true;
  tabsheet3.TabVisible:=true;
  application.processmessages;
  screen.cursor:=crHourglass;
  setlength(sums,boardsize+2,boardsize+2);
  ResetLabels;
  pathstried:=0;
  tabsheet1.highlighted:=false;
  queryPerformanceCounter(starttime);

  //setlength(maxpath,boardsize+1);
  //setlength(minpath,boardsize+1);
  for i := 1 to boardsize+1 do
  for j := 1 to boardsize+1 do
  begin
    with sums[i,j] do
    begin
      maxsum:=0;
      minsum:=0;
    end;
  end;
  start:=(boardsize+1) div 2;
  endx:=start;
  for i:=1 to boardsize do
  begin
    if i<=boardsize div 2 + 1 then
    begin
      start:=(boardsize+1) div 2 - i + 1;
      endx:=start+2*i-2;
    end
    else
    begin
      k:=boardsize+1-i;
      start:=(boardsize+1) div 2 - k +1;
      endx:=start+2*k-2;
    end;
    for j:=start to endx do
    with sums[i,j] do
    begin

      max:=0; min:=high(integer);
      if i>1 then
      for k:=j-1 to j+1 do
      begin
        inc(pathstried);
        if sums[i-1,k].maxsum>max then max:=sums[i-1,k].maxsum;
        if (sums[i-1,k].minsum<min) and  (sums[i-1,k].minsum>0)
        then min:=sums[i-1,k].minsum;
      end;
      if max>0 then maxsum:=max;
      if min<high(integer) then minsum:=min;
      if board[i,j]<>999 then
      begin
        inc(maxsum, board[i,j]);
        inc(minsum, board[i,j]);
      end;
    end;
  end;
  For i:= 1 to boardsize-1 do
  begin
    For j:=1 to boardsize do
    begin
      StringGrid2.Cells[i-1,j-1]:=Format('%2.2D',[sums[i,j].minsum]);
      StringGrid3.Cells[i-1,j-1]:=Format('%2.2D',[sums[i,j].maxsum]);
    end;
  end;
  {now find max & min paths and set to display them}
  i:=boardsize-1;
  max:=0;
  min:=high(integer);
  for j:= boardsize div 2  to boardsize div 2 +2 do
  begin
    if sums[i,j].maxsum>max then
    begin
      max:=sums[i,j].maxsum;
      maxindex:=j;
      globalmaxpath[i]:=j;
    end;
    if sums[i,j].minsum<min then
    begin
      min:=sums[i,j].minsum;
      minindex:=j;
      globalminpath[i]:=j;
    end;
  end;
  {We now know where the max and min sums are, reconstruct the paths}
   globalminpath[boardsize]:=min;
   globalmaxpath[boardsize]:=max;
   getpreventry(boardsize-1,minindex, 'MIN',globalminpath);
   getpreventry(boardsize-1,maxindex, 'MAX',globalmaxpath);

  label1.caption:='Paths tried: '+inttostr(pathstried);
  queryperformancecounter(now);
  secs:=(now-starttime)/freq;
  label2.caption :=format('Run Seconds: %6.4f',[secs]);
  updatePathdisplay(true);
  screen.cursor:=crDefault;
  pagecontrol1.activepage:=tabsheet2;
  stringgrid2.setfocus;
end;


procedure TForm1.TabSheetEnter(Sender: TObject);
begin
  with sender as TTabsheet do highlighted:=true;
end;

procedure TForm1.TabSheetExit(Sender: TObject);
begin
  with sender as TTabsheet do highlighted:=false;
end;

procedure TForm1.AnimateBoxClick(Sender: TObject);
begin
  If animatebox.checked then
  begin
    Updatedisplay:=100;
  end
  else
  begin
    //animatebtn.tag:=0;
    UpdateDisplay:=1000;
    //Animatebtn.caption:='Show paths as tested';
  end;
  application.processmessages;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
  Pagecontrol1.ActivePage.highlighted:=true;
end;

procedure TForm1.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  Pagecontrol1.Activepage.highlighted:=false;
end;

end.
