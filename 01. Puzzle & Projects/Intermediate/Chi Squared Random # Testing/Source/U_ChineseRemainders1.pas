unit U_ChineseRemainders1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Memo1: TMemo;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  dividedby:array [1..3] of integer;
  remainders: array [1..3] of integer;
  i,N:integer;
  solved:boolean;
begin
  with stringgrid1 do
  for i:=1 to 3 do
  begin  {convert divisors and remainders to integer form}
    dividedby[i]:=strtoint(cells[0,i]);
    remainders[i]:=strtoint(cells[1,i]);
  end;
  n:=0;
  solved:=false; {just to force 1st time through}
  while (not solved) and (n<1000) do
  begin
    solved:=true; {initialized solved to true}
    inc(n); {next N}
    for i:=low(dividedby) to high(dividedby) do
    {Test N div D has remainder R}
    begin  {we'll quit at first equation not satisfied}
      if n mod dividedby[i] <> remainders[i] then
      begin
        solved:=false;
        break;
      end;
    end;
  end;
  if solved then label1.caption:='Solution is '+inttostr(n)
  else label1.caption:='No solution less than 1000 found';
end;

procedure TForm1.FormActivate(Sender: TObject);
{set up grid}
begin
  with stringgrid1 do
  begin
    cells[0,0]:=' N divided by ';
    cells[1,0]:=' Has remainder';
    cells[0,1]:='6'; cells[1,1]:='5';
    cells[0,2]:='5'; cells[1,2]:='4';
    cells[0,3]:='4'; cells[1,3]:='3';
  end;
end;

end.
