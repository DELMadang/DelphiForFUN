unit U_SimpleBackTrack;

{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ShellAPI;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    MakeCaseBtn: TButton;
    SolveItBtn: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure MakeCaseBtnClick(Sender: TObject);
    procedure SolveItBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    target:integer;
    visited:array[0..3,0..3] of boolean;
    path:Tstringlist;
    first:boolean;
    function makepathFrom(c, r, nbrfound:integer):boolean;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** FormAxctivate **************}
procedure TForm1.FormActivate(Sender: TObject);
{start up stuff}
begin
  randomize;  {make results non-repeatable}
  first:=true; {flag so that memo info does not cleared for the initial case}
  makecasebtnclick(sender);
end;



 var
   {data for making cases}
   n:array[0..7] of char=('A','B','C','D','X','X','X','X'); {, 'X' = (blocked cell}

{************** MakecaseBtnClick ***********}
procedure TForm1.MakeCaseBtnClick(Sender: TObject);
var i,j,k:integer;
begin
  {initialize the grid}
  for i:=0 to 3 do
  for j:= 0 to 3 do
  with stringgrid1 do
  cells[i,j]:='';
  target:=0;
  {plug in the numbers randomly, 'X' = block}
  k:=0;
  with stringgrid1 do
  begin
    while k <=high(n) do
    begin {look randomly for an empty cell}
      i:=random(length(n));
      j:=random(length(n));
      if (i<=3) and (j<=3) then
      with stringgrid1 do
      if cells[i,j]='' then  {it's empty, so put the value here}
      begin
        if n[k]<>'X' then inc(target);
        cells[i,j]:=n[k];
        inc(k);
      end;
    end; {while}
    cells[3,3]:='S';
    row:=3; col:=3;
  end;
  {leave intro data in memo1 the first time we build a case}
  if not first then memo1.clear;
  first:=false;
end;

{************ MakePathFrom ************}
function TForm1.makepathFrom(c, r, nbrfound:integer):boolean;

   function trymove(nextc,nextr:integer):boolean;
   {check if this is a valid move, if it is, try  making next moves from here }
   {if we try next moves and result is false - remove all traces of this
    move and exit }
   begin
      result:=false;
      {make sure that c & r are valid}
      if (nextc>=0) and (nextc<=3) and (nextr>=0) and (nextr<=3)
        and (stringgrid1.cells[nextc,nextr]<>'X') {and not blocked}
        and (not visited[nextc,nextr]) {and not previously visited}
      then
      begin
        if stringgrid1.cells[nextc,nextr]<>'' then inc(nbrfound);
        memo1.lines.add(format('Try move to (%d, %d), found %d ',
                                [nextc,nextr,nbrfound]));
        visited[nextc,nextr]:=true;
        path.add('('+inttostr(nextc)+','+inttostr(nextr)+') - '
            + stringgrid1.cells[nextc,nextr]); {identify the col,row, and contents}
        result:=makepathfrom(nextc,nextr, nbrfound);
        if not result then
        begin {do everything necessary to undo the move we tried}
          memo1.lines.add(format('Backtrack out of (%d, %d) ',[nextc,nextr]));
          visited[nextc,nextr]:=false; {unvisit the cell}
          path.delete(path.count-1);  {remove move from the path}
          {back out the nbrfound if we added to it}
          if stringgrid1.cells[nextc,nextr]<>'' then dec(nbrfound);
        end;
      end;
    end;

var i:integer;
begin    {MakePathFrom}
  if nbrfound=target then
  begin
    memo1.lines.add('Done!   Path is:');
    for i:= 0 to path.count-1 do memo1.Lines.add(path[i]);
    result:=true;
    exit;
  end;

  with stringgrid1 do
  begin   {find a move}
    {try left}  result:=trymove(c-1,r);
    {try right} if not result then result:=trymove(c+1,r);
    {try up}    if not result then result:=trymove(c,r-1);
    {try down}  if not result then result:=trymove(c,r+1);
  end;
  if not result then Memo1.lines.add('Dead end');
end;

{************* SolveitbtnClick*************}
procedure TForm1.SolveItBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  path:=tstringlist.create;
  for i:=0 to 3 do for j:=0 to 3 do visited[i,j]:=false;
  visited[3,3]:=true;
  if not MakePathFrom(3,3,0) then memo1.lines.add('No solution for this case');
  path.Free;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
