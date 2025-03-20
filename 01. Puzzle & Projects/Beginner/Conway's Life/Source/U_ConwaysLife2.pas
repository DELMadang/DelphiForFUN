unit U_ConwaysLife2;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Version 2 of Conway's Life "game"}

{
Changes for V2:
  Make boardsize dynamic.
  Make grid arrays dynamic
  Add size radio group to specify boardsize.
  Adjust stringgrid cell sizes when boardsize changes or form size changes
  Add multiple steps to start button  a various rates
  Modify MakeStep function to reconize when board does not change after a step.
  Add timer code to StartBtnclick
  Add code to save and load configurations
 }




interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, ComCtrls, shellapi;


type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    RateGrp: TRadioGroup;
    StartBtn: TButton;
    StringGrid1: TStringGrid;
    SizeGrp: TRadioGroup;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Clearbtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    RestoreBtn: TButton;
    StaticText1: TStaticText;
    GenLbl: TLabel;
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StartBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SizeGrpClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure RestoreBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure RateGrpClick(Sender: TObject);
    procedure ClearbtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  public
    {Grid is a triply dimensioned array defining two boards, the current
     generation (indexed by "Active"), and the one being built (indexed by "Next")}
    grid:array[0..1] of array of array of boolean;
    active,next:integer;  {index values for the two grids}
    savedgrid: array of array of boolean; {a place to store initial patterns for thr restore button}
    boardsize:integer;  {The height and width of the current board}
    looptime:extended; {time per generation step}
    stepmode:boolean; {true = single step mode}
    Gencount:integer; {count of generations}
    procedure setsize;
    function makestep:boolean;  {function to generate the next generation grid}
    procedure savegrid;  {save initial copy of a grid position}
    procedure restoregrid;  {restore a saved  initial grid}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ StringGrid1Click ***********}
procedure TForm1.StringGrid1Click(Sender: TObject);
{Set up a board}
begin
  with stringgrid1 do
  if cells[col,row]='' then
  begin
    cells[col,row]:='1';
    grid[active,col,row]:=true;
  end
  else
  begin
    cells[col,row]:='';
    grid[active,col,row]:=false;
  end;
end;

{************ StringgridDrawCell **************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  {Update the bard image}
begin
  with stringgrid1,canvas do
   begin
     if cells[acol,arow]<>'' then brush.color:=clblack else brush.color:=clwhite;
     fillrect(rect);
   end;
end;


{************** MakeStep *************}
function TForm1.makestep:boolean;
{Create next generation, return true if pattern changed}

  function countneighbors(const i,j:integer):integer;
  {Count the number of neighbors}
  var
    L,R,U,D:integer;  {Left, Right, Up, Down offsets for neighbors}
  begin
    result:=0;
    if i>0 then L:=i-1 else L:=boardsize-1; {counters loop around}
    if j>0 then U:=j-1 else U:=boardsize-1;
    if i<boardsize-1 then R:=i+1 else R:=0;
    if j<boardsize-1 then D:=j+1 else D:=0;
    {check and count all 8 neightbors}
    if grid[active,L,j] then inc(result);  {left}
    if grid[active,i,U] then inc(result);  {up}
    if grid[active,R,j] then inc(result);  {right}
    if grid[active,i,D] then inc(result);  {down}
    if grid[active,L,U] then inc(result);  {left & up}
    if grid[active,R,U] then inc(result);  {right & up}
    if grid[active,L,D] then inc(result);  {left & down }
    if grid[active,R,D] then inc(result);  {right & down}
  end;

  var
    i,j:integer;
    n:integer; {neighbor count}
    livecell:boolean;
    change:boolean; {flag to identify if grid has become stable}
  begin
    result:=false;
    if tag<>0 then exit;

    next:=(active+1) mod 2;
    setlength(grid[next],boardsize,boardsize);
    change:=false;
    for i:=0 to boardsize-1 do
    for j:=0 to boardsize-1 do
    begin
      grid[next,i,j]:=grid[active,i,j];
      Livecell:=grid[active,i,j];
      n:=countNeighbors(i,j);
      {rules:
      1.Any live cell with fewer than 2 or more than 3 live neighbours dies,
        as if by loneliness or overcrowding.
      2.Any dead cell with exactly three live neighbours comes to life.
      }
      if Livecell then
      begin
        if ((n<2) or (n>3)) then    {Rule 1}
        begin
          grid[next,i,j]:=false;
          stringgrid1.cells[i,j]:='';
          change:=true;
        end;
      end
      else {check dead cell}
      if n=3 then   {Rule 2}
      begin
        grid[next,i,j]:=true;
        stringgrid1.cells[i,j]:='1';
        change:=true;
      end;
    end;
    inc(gencount);
    setlength(grid[active],0,0);
    active:=next; {make the new grid the active one}
    Genlbl.caption:='Generation: '+inttostr(gencount);
    application.processmessages;
    result:=change;
  end;

{************ SetSize **********}
procedure TForm1.setsize;
{set the baord size and reinitialize global variables}
var
  i,j:integer;
begin
  case sizegrp.itemindex of
    0: boardsize:=25;
    1: boardsize:=50;
    2: boardsize:=100;
  end;
  setlength(grid[0],boardsize,boardsize);
  setlength(grid[1],boardsize,boardsize);
  with stringgrid1 do
  begin
    colcount:=boardsize;
    rowcount:=boardsize;
    defaultrowheight:=height div rowcount-1;
    defaultcolwidth:=width div colcount-1;
  end;
  active:=0;
  for i:=0 to boardsize-1 do
  for j:=0 to boardsize-1 do
  begin
    grid[active,i,j]:=false;
    stringgrid1.Cells[i,j]:='';
  end;
  restorebtn.enabled:=false; {any restore information lost on grid resize}
  stepmode:=false;  {assume not in single step mode}
  Gencount:=0;
  genlbl.caption:='Generation: 0';
end;

{*************** SaveGrid ************}
procedure TForm1.savegrid;  {save initial copy of a grid position}
var
  i,j:integer;
begin
  setlength(savedgrid,boardsize,boardsize);
  for i:=0 to boardsize-1 do
  for j:=0 to boardsize-1 do
  savedgrid[i,j]:=grid[active,i,j];
  //restorebtn.enabled:=true;
end;


{************** RestoreGrid **************}
procedure TForm1.restoregrid;
{restore a saved  initial grid}
var
  i,j:integer;
begin
  setsize;
  for i:=0 to boardsize-1 do
  for j:=0 to boardsize-1 do
  begin
    grid[active,i,j]:=savedgrid[i,j];
    If savedgrid[i,j] then stringgrid1.cells[i,j]:='1';
  end;
end;

{************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.InitialDir;
  setsize;
end;

{************** StartBtnClick ***********}
procedure TForm1.StartBtnClick(Sender: TObject);
var
  nexttime:Tdatetime; {time when we want the next loop to start}
  sleeptime:integer;
begin
  if StartBtn.caption='Stop' then  {user requested to stop}
  begin
    StartBtn.Caption:='Start';  {set the button caption back}
    tag:=1; {set flag to stop the loop}
  end
  else
  begin
    tag:=0;
    rategrpclick(sender);  {set loop speed}
    if not stepmode then
    begin
      savegrid;
      Startbtn.caption:='Stop';
      nexttime:=now+looptime; {next target loop end time}
      repeat
        if (not makestep)then tag:=1;
        sleeptime:=trunc((nexttime-now)*1000*secsperday);
        if (not stepmode) and (sleeptime>0) and (sleeptime<=1000) then sleep(sleeptime);
        nexttime:=nexttime+looptime;
        application.processmessages;
      until (tag <>0);
      startbtn.caption:='Start';
      restorebtn.enabled:=true;
    end
    else
    begin
      if gencount=0 then
      begin
        savegrid;
        restorebtn.enabled:=true;
      end;
      makestep;
    end;
  end;
end;

{************** FormCloseQuery ****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1; {in case life is going on}
  canclose:=TRUE;
end;

{************** SizegrpClick ********8}
procedure TForm1.SizeGrpClick(Sender: TObject);
begin
  setsize;
end;

{*********** FormResize ***********}
procedure TForm1.FormResize(Sender: TObject);
begin
  with stringgrid1 do
  begin
    defaultrowheight:=height div rowcount-1;
    defaultcolwidth:=width div colcount-1;
  end;
end;

{**************** LoadBtnClick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  f:textfile;
  line:string;
  list:TStringlist;
  maxline:integer;
  i,j:integer;
  startx,starty:integer;
begin
  if opendialog1.execute then
  begin
    list:=TStringlist.Create;
    maxline:=0;
    setsize;  {clear the board}
    assignfile(f,opendialog1.filename);
    reset(f);
    {put the definition lines in a stringlist}
    while not eof(f) do
    begin
      readln(f,line);
      line:=trim(line);
      if (length(line)>1) and (copy(line,1,2)<>'//') then
      begin
        list.add(line);
        if length(line)>maxline then maxline:=length(line);
      end;
    end;
    closefile(f);
    startx:=(boardsize-maxline) div 2;
    starty:=(boardsize-list.count) div 2;
    for i:=0 to list.count-1 do
    begin
      line:=list[i];
      for j:=1 to length(line) do
      if line[j] in ['*','O','o']  {several choices for occupied}
      then
      begin
        grid[active,startx+j,starty+i]:=true;
        stringgrid1.cells[startx+j,starty+i]:='1';
      end;
    end;
    list.free;
  end;
end;


{**************** SaveBtnClick **********}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  f:textfile;
  i,j:integer;
  minx,maxx,miny,maxy:integer; {range of pattern}
  s:string;
begin
  if savedialog1.execute then
  begin
    {find the boundaries of the pattern}
    minx:=1000000; maxx:=0;
    miny:=1000000; maxy:=0;

    for i:=0 to boardsize-1 do
    for j:=0 to boardsize-1 do
    if grid[active,i,j] then
    begin
      if i<minx then minx:=i else if i>maxx then maxx:=i;
      if j<miny then miny:=j else if j>maxy then maxy:=j;
    end;
    {now build strings for each row and write to file}
    assignfile(f,savedialog1.filename);
    rewrite(f);
    for j:= miny to maxy do
    begin
      s:='';
      for i:=minx to maxx do
      if grid[active,i,j] then s:=s+'O' else s:=s+'.';
      writeln(f,s);
    end;
    closefile(f);
  end;
end;

{********* RestorebtnClick ***********}
procedure TForm1.RestoreBtnClick(Sender: TObject);
begin
  restoreGrid;
end;

{**************** RateGrpClick **********}
procedure TForm1.RateGrpClick(Sender: TObject);
begin
     stepmode:=false;
  {Calculate looptime as fraction of a day}
    case rategrp.itemindex of
      0:begin looptime:=0; stepmode:=true; end;
      1:looptime:=1.0/secsperday;
      2:looptime:=0.5/secsperday;
      3: looptime:=0.2/secsperday;
      4: looptime:=0.1/secsperday;
      5: looptime:=0.05/secsperday;
      else looptime:=0;
    end;
end;

{************** ClearbtnClick ********}
procedure TForm1.ClearbtnClick(Sender: TObject);
begin
  setsize;
end;


{************ StatictextClick **********}
procedure TForm1.StaticText1Click(Sender: TObject);
begin {link to delphiforfun when text is clicked}
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
