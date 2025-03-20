unit U_SquaresCubes3;
{There is a number which, when cubed is 2,000,000 larger
than a number which is the square of a facotr of 2,000,000}
{What is the number?}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Memo1: TMemo;
    procedure SolveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses  math;

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  start,n3,nm2,root:int64;
  solved:boolean;
  i:integer;
begin
{since we are going to cube start values
 and subtract 2,000,000 and since the result
 must be positive (it is to the square of a factor),
 we might as well start at the cube root of 2,000,000}

  start:=trunc(power(2000000.0,1/3));
  root:=0;
  solved:=false;
  while  (not solved) and (root< 1000000) do
  begin
    inc(start);
    n3:=start*start*start;
    nm2:=n3-2000000;
    {trick sqrt function by forcing conversion of
     nm2 to extended by adding 0.0 to it - it's a fluke
     of Delphi that integer types will automatically be
     convereted but int64 types will not}
    root:=trunc(sqrt(0.0+nm2));
    if root*root=nm2 then
    begin
      {if root is a factor of 2,000,000 then solved}
      if 2000000 mod root = 0 then
      begin
        showmessage('Solved! '
                   +#13+inttostr(start)
                   +' cubed is '+format('%6.0n',[0.0+n3])
                   +', which less 2,000,000 is '
                   +format('%6.0n',[0.0+nm2])
                   +#13+ ' which is the square of '
                   +format('%6.0n',[0.0+root])
                   +' which is a factor of 2,000,000');
        solved:=true;
      end;
    end;
  end;
  If not solved then showmessage('No solution found');
end;

end.
