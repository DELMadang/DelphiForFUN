unit U_SquaresCubes1;
{from Clessa #37}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, GIFImage;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    Image1: TImage;
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

function cubeof(n:integer):integer;
{A cubeof function just to save writing a little code}
begin
  result:=n*n*n;
end;

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i:integer;
  solved:boolean;
  start,test:integer;
  x:integer;
begin
  start:=1;
  While (start<20) do
  begin
    solved:=false;
    inc(start);  {get the next number to try  - inc means add 1}
    i:=0;
    test:=0;
    {we'll try adding up to 100 consecutive cubes from start}
    while (not solved) and (i<100)
    do
    begin
      test:=test+cubeof(start+i); {accumulate cubes}
      If i>=3 then {when i gets to 3 or more ,we've added up at least 4 numbers}
      begin
        x:=trunc(sqrt(test)); {get the integer part of square root}
        if test=x*x then {if squaring gets back to test, then we've got it!}
        begin
          solved:=true;
          showmessage('Solution is sum of '+ inttostr(i+1)+' cubes from '
             +inttostr(start) + ' to ' + inttostr(start+i)
             + ' is ' + inttostr(x) +'^2');
        end;
      end;
      inc(i);
    end;
  end;
end;



end.
