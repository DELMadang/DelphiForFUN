unit U_ConwaysLife1;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{The simplest version of Conway's Life "game"}

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, shellAPI;

const boardsize=25;  {The height and width of the board}
type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    StartBtn: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StartBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    {CurrentGrid and NextGrid are 2-dimensional arrays defining two boards, the
     current and next generations}
    Currentgrid,NextGrid:array [0..boardsize-1, 0..boardsize-1] of boolean;
    Procedure makestep;  {Procedure  to generate the next generation grid}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ StringGrid1Click ***********}
procedure TForm1.StringGrid1Click(Sender: TObject);
{Set up a board, switch state of clicked cell}
begin
  with stringgrid1 do
  if cells[col,row]='' then
  begin  {make "live" }
    cells[col,row]:='1';
    currentgrid[col,row]:=true;
  end
  else
  begin  {make "dead"}
    cells[col,row]:='';
    currentgrid[col,row]:=false;
  end;
end;

{************ StringgridDrawCell **************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  {OnDrawCell exit updates the board image cell by cell as it is drawn }
begin
  with stringgrid1,canvas do
   begin
     if cells[acol,arow]<>'' then brush.color:=clblack else brush.color:=clwhite;
     fillrect(rect);
   end;
end;


{************** MakeStep *************}
Procedure TForm1.makestep;
{The meat of the program - create next generation, return true if pattern changed}

  function CountPrevNeighbors(const i,j:integer):integer;
  {local function to count the number of neighbors}
  var
    L,R,U,D:integer;  {Left, Right, Up, Down offsets for neighbors}
  begin
    result:=0;
    if i>0 then L:=i-1 else L:=boardsize-1; {counters loop around as if the }
    if j>0 then U:=j-1 else U:=boardsize-1; {board were a closed torus (a doughnut)}
    if i<boardsize-1 then R:=i+1 else R:=0;
    if j<boardsize-1 then D:=j+1 else D:=0;
    {check all 8 neightbors}
    if Currentgrid[L,j] then inc(result);  {left}
    if Currentgrid[i,U] then inc(result);  {up}
    if Currentgrid[R,j] then inc(result);  {right}
    if Currentgrid[i,D] then inc(result);  {down}
    if Currentgrid[L,U] then inc(result);  {left & up}
    if Currentgrid[R,U] then inc(result);  {right & up}
    if Currentgrid[L,D] then inc(result);  {left & down }
    if Currentgrid[R,D] then inc(result);  {right & down}
  end;

  var
    i,j:integer;
    n:integer; {neighbor count}
    livecell:boolean;
  begin
    for i:=0 to boardsize-1 do
    for j:=0 to boardsize-1 do
    begin
      Nextgrid[i,j]:=Currentgrid[i,j]; {copy old to new in case no change for next generation}
      Livecell:=Currentgrid[i,j];  {state of the cell being tested}
      n:=countprevNeighbors(i,j);  {count the neighbors}
      {rules: 1.Any live cell with fewer than two or more than 3 live neighbors dies.
              2.Any dead cell with exactly three live neighbors comes to life.  }
      if Livecell then
      begin
        if ((n<2) or (n>3)) then    {Rule 1}
        begin
          nextgrid[i,j]:=false;
          stringgrid1.cells[i,j]:='';
        end;
      end
      else {check dead cell}
      if n=3 then   {Rule 2}
      begin
        Nextgrid[i,j]:=true;
        stringgrid1.cells[i,j]:='1';
      end;
    end;
    {make the new (next) grid the current grid}
    for i:=0 to boardsize-1 do
    for j:= 0 to boardsize-1 do
    Currentgrid[i,j]:=NextGrid[i,j];
  end;

{************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,j:integer;
begin  {Initialize the active grid}
  for i:=0 to high(Currentgrid) do
  for j:=0 to high(Currentgrid) do Currentgrid[i,j]:=false;
end;

{************** StartBtnClick ***********}
procedure TForm1.StartBtnClick(Sender: TObject);
begin
  makestep;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin {link to delphiforfun when text is clicked}
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
