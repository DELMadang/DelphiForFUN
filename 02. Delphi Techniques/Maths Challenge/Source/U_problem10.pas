unit U_problem10;

{
The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

Find the sum of all the primes below one million.
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

function isprime(f:int64):boolean;
var
  i:int64;
  stop:int64;
begin
  result:=true;
  if (f=2) or (f=3) or (f=5) then exit;
  if (f mod 2 = 0) or (f mod 3=0) or (f mod 5=0) then result:=false;
  if result then
  begin
    i:=7;
    stop:=trunc(sqrt(0.0+f));
    while result and (i<=stop) do
    begin
      if f mod i=0 then result:=false;
      inc(i,2);
    end;
  end;
end;



procedure TForm1.Button1Click(Sender: TObject);
var n:int64;
    sum:int64;
begin
  n:=3;
  sum:=2;
  while (n<1000000) do
  begin
    if isprime(n) then sum:=sum+n;
    inc(n,2);
  end;
  showmessage('Sum of primes less than 1,000,000 is '+inttostr(sum)); 
end;

end.
