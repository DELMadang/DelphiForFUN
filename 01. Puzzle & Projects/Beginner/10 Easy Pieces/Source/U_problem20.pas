unit U_problem20;
{
  n! means n × (n – 1) × ... × 3 × 2 × 1

Find the sum of the digits in the number 100!


}



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    SpinEdit1: TSpinEdit;
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

uses math;

const maxdigits=500;
      basepower=10;
      nbrpieces=maxdigits div basepower;

procedure TForm1.Button1Click(Sender: TObject);
 var
  i,j:integer;
  n:array[1..nbrpieces] of int64;  {10 digit parts of numbers up to 500 digits}
  base:int64;
  sum:integer;
begin
  base:=trunc(power(10,basepower));
  {initialize n to 1}
  n[1]:=1;
  for i:=2 to high(n) do n[i]:=0;
  {multiply n by 2 up to 1000 times}
  for i:= 1 to spinedit1.value do
  begin
    for j:= 1 to High(n) do  n[j]:=n[j]*i; {factorial}
    for j := 1 to high(n) do {make carries if necessary}
    if (j<high(n)) and (n[j]>base) then {carry to next part is necessary}
    begin
      n[j+1]:=n[j+1]+ n[j] div base;
      n[j]:=n[j] mod base;
    end;
  end;
  sum:=0;
  for i:=1 to high(n) do
  begin
    while n[i] >0 do
    begin
      sum:=sum+n[i] mod 10;
      n[i]:=n[i] div 10;
    end;
  end;
  showmessage('Sum of digits of 2^1000 is '+inttostr(sum));


end;

end.

