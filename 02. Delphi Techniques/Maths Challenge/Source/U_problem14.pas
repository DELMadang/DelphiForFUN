unit U_problem14 ;

{
The following iterative sequence is defined for the set of natural numbers:

n ® n/2 (n is even)
n ® 3n + 1 (n is odd)

Using the rule above and starting with 13, we generate the following sequence:


13 ® 40 ® 20 ® 10 ® 5 ® 16 ® 8 ® 4 ® 2 ® 1

It can be seen that this sequence (starting at 13 and finishing at 1) contains
10 terms. Although it has not been proved yet (Collatz Problem), it is thought
that all starting numbers finish at 1.

Which starting number, under one million, produces the longest chain?

NOTE: Once the chain starts the terms are allowed to go above one million.
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
  n,start,longest,count:int64;
begin
  longest:=0;
  for i:= 2 to 1000000 do
  begin
    n:=i;
    count:=1;
    while n<>1 do
    begin
      if n mod 2 = 0 then n:= n div 2
      else n:=3*n+1;
      inc(count);
    end;
    if count>longest then
    begin
      longest:=count;
      start:=i;
    end;
  end;
  showmessage('Series starting at '+inttostr(start)+ ' has '+inttostr(longest)
             +' terms (longest)');
end;

end.
