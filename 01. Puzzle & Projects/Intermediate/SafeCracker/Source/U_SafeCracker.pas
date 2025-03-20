unit U_SafeCracker;
{Copyright  © 2002,2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


 { Unlock the safe by clicking all squares in order from first to last,
   Last square is marked  "LAST".  It is up to you to find the first square.

   Each square except the last, has a number for the distance to move
   and a direction letter (U=Up, D=Down, L=Left, R=Right). }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, ComCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    MakeBtn: TButton;
    UnlockBtn: TButton;
    Image1: TImage;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    ColEdt: TEdit;
    ColUD: TUpDown;
    Label2: TLabel;
    RowEdt: TEdit;
    RowUD: TUpDown;
    ClearBtn: TButton;
    Memo1: TMemo;
    SavePicBtn: TButton;
    StaticText1: TStaticText;
    procedure MakeBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UnlockBtnClick(Sender: TObject);
    procedure EdtChange(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClearBtnClick(Sender: TObject);
    procedure SavePicBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    grid:array of array of string;
    path:array of TPoint;
    pathcount:integer;
    xincr,yincr:integer;
    cols,rows:integer;
    offsetx,offsety:integer;  {pixel offsets in cell to center text}
    offsetxlast,offsetylast:integer;
    bordersize:integer;
    maxdist:integer;  {maximum distance to move}
    procedure initialize;
    procedure drawboard;
    procedure drawpath(pathcount,sleepval:integer);
    function MakeValidMove(prevcell:TPoint; var newdir:char;
                                            var newdist:Integer):boolean;
    function IsTarget(x,y, px,py:integer):boolean;
    function GetNext(cellin:TPoint):TPoint;
    function GetPrev(cellin:TPoint):TPoint;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  dirarray:array[0..3] of char=('U','D','L','R');
  boardwidth,boardheight:integer;

{******************* MakeValidMove ****************}
function TForm1.MakeValidMove(prevcell:TPoint; var newdir:char;
                                               var newdist:Integer):boolean;
{Create a new valid move, used while generating a board}
var  count,n,d:integer;
begin
  result:=false;
  count:=0;
  while (result=false) and (count<1000) do
  begin
    n:=random(4);
    d:=random(maxdist)+1; {limit distance to smaller of rows-1, cols-1}
    case n of
      0: {up} if     (prevcell.y+d<rows)
                 and (grid[prevcell.x,prevcell.y+d]='')
             then result:=true;
      1: {down} if (prevcell.y-d>=0)
                and (grid[prevcell.x,prevcell.y-d]='')
                then result:=true;
      2: {left} if (prevcell.x+d<cols)
                   and (grid[prevcell.x+d,prevcell.y]='')
                then result:=true;
      3: {right} if (prevcell.x-d>=0)
                 and (grid[prevcell.x-d,prevcell.y]='')
                  then result:=true;
    end;
    inc(count);
    if result=true then
    begin
      newdir:=dirarray[n];
      newdist:=d;
    end;
  end;
end;

{******************** DrawBoard **********}
procedure tform1.drawboard;
var   i,j:integer;
begin
  if (cols=0) or (rows=0) then exit;
  setlength(grid,cols,rows);
  bordersize:=4;
  with image1, canvas do
  begin
    brush.color:=clwindow;
    xincr:=boardwidth div cols;
    yincr:=boardheight div rows;
    width:=xincr*cols;
    height:=yincr*rows;
    picture.bitmap.width:=width;
    picture.bitmap.height:=height;
    pen.width:=bordersize;
    pen.color:=clgray;
    rectangle(clientrect);
    for i:=1 to cols do
    begin
      moveto(i*xincr,0);
      lineto(i*xincr,height);
    end;
    for j:=1 to rows do
    begin
      moveto(0,j*yincr);
      lineto(width,j*yincr);
    end;
    offsetx:=(xincr-bordersize-textwidth('XX')) div 2;
    offsety:=(yincr-bordersize-textheight('XX')) div 2+5;
    offsetxlast:=(xincr-bordersize-textwidth('LAST')) div 2;
    offsetylast:=(yincr-bordersize-textheight('LAST')) div 2+5;
    if (rows<8) then font.size:=12 else font.size:=8;
    font.style:=[fsbold];
    for i:=0 to cols-1 do
    for j:=0 to rows-1 do
      If grid[i,j]='LAST'
      then textout(i*xincr+offsetxlast,j*yincr+offsetylast,grid[i,j])
      else textout(i*xincr+offsetx,j*yincr+offsety,grid[i,j]);
    update;
  end;
end;


{***************** DrawPath *********}
procedure Tform1.DrawPath(pathcount, sleepval:integer);
{Show the partial or full path}
var
  i:integer;
  nx,ny:integer;
begin
  {Add small step #'s in  corner of cell}
  with image1, canvas do
  begin
    font.size:=8;
    brush.color:=clgreen;
    for i:= 0 to pathcount {high(path)} do
    begin
      nx:=path[i].x;
      ny:=path[i].y;
      if trim(grid[nx,ny])='LAST' then brush.color:=clred
      else if i=0 then brush.color:=clgreen
      else brush.color:=clsilver;
      fillrect(rect(nx*xincr+bordersize,ny*yincr+bordersize,
                    nx*xincr+xincr-bordersize,
                    ny*yincr+yincr-bordersize));
      font.size:=8;
      textout(nx*xincr+bordersize,ny*yincr+bordersize,inttostr(i+1));
      font.size:=12;
      if grid[nx,ny]='LAST'
      then textout(nx*xincr+offsetxlast,ny*yincr+offsetylast,grid[nx,ny])
      else textout(nx*xincr+offsetx,ny*yincr+offsety,grid[nx,ny]);
      if sleepval>0 then
      begin
        sleep(sleepval);
        update;
      end;
    end;
  end;
end;


{******************** MakeBtnClick *************}
procedure TForm1.MakeBtnClick(Sender: TObject);
{Fill the grid with moves by trial and error}
var
  FCol, FRow:integer;
  prevcell:TPoint;
  dir:char;
  dist, count:integer;
  i,j:integer;
  filledcells:integer;
begin
  screen.cursor:=crHourGlass;
  initialize;
  count:=-1;
  repeat
    filledcells:=1;
    for i:=0 to cols-1 do for j:= 0 to rows-1 do grid[i,j]:='';
    Fcol:=random(cols);
    FRow:=random(rows);
    grid[FCol,FRow]:='LAST';
    prevcell:=point(FCol,Frow);
    //prevdir:=' ';
    while MakeValidMove(prevcell,dir,dist) do
    begin
      case dir of
        'U': prevcell.y:=prevcell.y+dist;
        'D': prevcell.y:=prevcell.y-dist;
        'L': prevcell.x:=prevcell.x+dist;
        'R': prevcell.x:=prevcell.x-dist;
      end;
      grid[prevcell.x,prevcell.y]:=inttostr(dist)+dir;
      inc(filledcells);
      //prevdir:=dir;
    end;
    inc(count);
    if count mod  256 = 0 then
      {draw the board once in a while, just to prove that the program is busy}
      begin
        drawboard;
        count:=0;
      end;
  until filledcells=rows*cols;
  screen.cursor:=crdefault;
  clearbtnclick(sender);
  drawboard;
end;

{************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  doublebuffered:=true;
  cols:=colUD.position;
  rows:=rowUD.position;
  if cols>rows then maxdist:=rows-1 else maxdist:=cols-1;
  Makebtnclick(sender);
  Clearbtnclick(sender);
  drawboard;
end;

{****************** IsTarget ****************}
function TForm1.IsTarget(x,y,px,py:integer):boolean;
{Return true if grid[px,py] is the destination of the move specified
 at grid[x,y]}
var d:integer;
begin
  result:=false;
  if (length(grid[x,y])=2) and (grid[x,y][1] in ['1'..'9']) then
  begin
    d:=strtoint(grid[x,y][1]);
    case grid[x,y][2] of
     'U': result:=py=y-d;
     'D': result:=py=y+d;
     'L': result:= px=x-d;
     'R': result:=px=x+d;
    end;
  end;
end;

{*************** GetNext *******************}
function TForm1.GetNext(cellin:TPoint):TPoint;
{Given a cell, return the "moveto"  cell}
var  d:integer;
begin
  result:=cellin;
  with cellin do
  if (length(grid[x,y])=2) and (grid[x,y][1] in ['1'..'9']) then
  begin
    d:=strtoint(grid[x,y][1]);
    case grid[x,y][2] of
     'U': result.y:=y-d;
     'D': result.y:=y+d;
     'L': result.x:=x-d;
     'R': result.x:=x+d;
    end;
  end
  else result.x:=-1; {must be "F" cell, make sure no valid cell is returned};
end;

{*************** GetPrev *******************}
function TForm1.GetPrev(cellin:TPoint):TPoint;
{Given a cell, return the "movefrom"  cell}
var  c,r:integer;
     nextcell:TPoint;
begin
  result:=cellin;
  for c:=0 to cols-1 do
  for r:=0 to rows-1 do
  begin
    nextcell:=getnext(point(c,r));
    if (nextcell.x=cellin.x) and (nextcell.y=cellin.y) then
    begin
      result.x:=c;
      result.y:=r;
      exit;
    end;
  end;
end;

{****************** UnlockBtnClick *************}
procedure TForm1.UnlockBtnClick(Sender: TObject);
{Find the solution}
var
  px,py:integer;
  movenbr:integer;
  cell:TPoint;
begin
  {Solve it backwards
    first find the Last cell then find the cell that would move to Last,
    then the cell that would move us to that cell, etc. }
  {1. Find the "Last" cell;}
  for px:=0 to cols-1 do
  for py:=0 to rows-1 do
  if trim(grid[px,py])='LAST'  then
  begin
    {2. Trace path backward from there}
    setlength(path,cols*rows);
    movenbr:=high(path);
    path[movenbr]:=point(px,py);
    repeat  {filling in path info in reverse order}
      cell:=getprev(path[movenbr]);
      dec(movenbr);
      path[movenbr]:=cell;
    until movenbr=0;
    break;
  end;
  drawboard;
  drawpath(high(path), 500); {draw path with 1/2 second delay between moves}
end;

procedure TForm1.Initialize;
{Clear the board and path info}
begin

   setlength(grid,0,0); {clear the board}
   setlength(grid,cols,rows);
   setlength(path,0);
   setlength(path,rows*cols);
   pathcount:=-1;
   drawboard;
end;

{**************** ColEdtChange *********}
procedure TForm1.EdtChange(Sender: TObject);
{Row or column count changed}
begin
  if sender = coledt then cols:=colUD.position
  else if sender = rowedt then rows:=RowUD.position;
  if cols>rows then maxdist:=rows-1 else maxdist:=cols-1;
  initialize;
end;

{************ Image1MouseDown ************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{detect mouse click on board and add square to the path if it's valid}
var
  cellx,celly:integer;
  nextcell:Tpoint;
begin
  if length(path)=0 then exit; {user clicked without any numbers displayed}
  cellx:=x div xincr;
  celly:=y div yincr;
  if (cellx<cols) and (celly<rows) then
  begin
    if pathcount<0 then  {first move}
    begin
      path[0]:=point(cellx,celly);
      inc(pathcount);
      drawpath(pathcount,0);
    end
    else
    begin  {find the next valid square}
      nextcell:=getnext(path[pathcount]);
      {if that's the one the user clicked, then}
      if (nextcell.x=cellx) and (nextcell.y=celly) then
      begin  {add it ot the path}
        inc(pathcount);
        path[pathcount]:=point(cellx,celly);
        drawpath(pathcount,0);
        if pathcount=cols*rows-1   {if we're done and all sqaure were filled}
        then showmessage('Excellent work!'
                        +#13+'But remember to use your safecracking skills '
                        + 'only for good, '+#13+ 'never for evil')
        else if trim(grid[cellx,celly])='LAST'  {at end but not all filled}
        then
        begin
          showmessage('Not bad, but not perfect - '
                         +' try to start at the beginning this time!');
          ClearBtnclick(sender);
        end;
      end
      else beep;
    end;
  end;
end;

{************* ClearBtnClick *************}
procedure TForm1.ClearBtnClick(Sender: TObject);
{Clear any existing path info}
begin
  setlength(path,0);
  setlength(path,rows*cols);
  pathcount:=-1;
  drawboard;
end;

procedure TForm1.SavePicBtnClick(Sender: TObject);
begin
  image1.picture.bitmap.pixelformat:=pf24bit;
  image1.picture.savetofile(extractfilepath(application.exename)+'safecracker.bmp')
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  boardwidth:=image1.width;
  boardheight:=image1.height;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
