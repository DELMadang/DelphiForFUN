unit U_problem6; 
{
 The sum of the squares of the first ten natural numbers is,


1² + 2² + ... + 10² = 385

The square of the sum of the first ten natural numbers is,


(1 + 2 + ... + 10)² = 55² = 3025

Hence the difference between the sum of the squares of the first ten natural
numbers and the square of the sum is 3025 – 385 = 2640.

Find the difference between the sum of the squares of the first one hundred
natural numbers and the square of the sum.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  i:integer;
  sum, sumsq: integer;
begin
  sum:=0;
  sumsq:=0;
  for i:=1 to 100 do
  begin
    sum:=sum+i;
    sumsq:=sumsq+i*i;
  end;
  showmessage('Square of sums - Sum of squares for 1st 100 is '
               +inttostr(sum*sum-sumsq));
end;

end.
