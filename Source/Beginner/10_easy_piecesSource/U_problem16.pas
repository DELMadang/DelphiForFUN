unit U_problem16;

{
  Work out the first 10 digits of the sum of the one-hundred 50-digit numbers
  defined below
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
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.Button1Click(Sender: TObject);
{2^1000 will be about 10^300 or a 300 digit number}
var
  i,j:integer;
  n:array[1..50] of int64;  {10 digit parts of numbers up to 500 digits}
  s:string;
  base:int64;
  x:int64;
  sum:integer;
begin
  base:=trunc(1e10);
  {initialize n to 1}
  n[1]:=1;
  for i:=2 to 50 do n[i]:=0;
  {multiply n by 2 up to 1000 times}
  for i:= 1 to spinedit1.value do
  begin
    for j:= 1 to 50 do  n[j]:=n[j]*2; {double each part}
    for j := 1 to 50 do {make carries if necessary}
    if (j<50) and (n[j]>base) then {carry to next part is necessary}
    begin
      n[j+1]:=n[j+1]+ n[j] div base;
      n[j]:=n[j] mod base;
    end;
  end;
  sum:=0;
  for i:=1 to 50 do
  begin
    while n[i] >0 do
    begin
      sum:=sum+n[i] mod 10;
      n[i]:=n[i] div 10;
    end;
  end;
  showmessage('Sum of digits of 2^'+inttostr(spinedit1.value)+' is '+inttostr(sum));

end;

end.
