unit U_Find3Primes;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{There is only one set of 3 different two-digit prime numbers with the property
 that the mean of any two or all three are all two digit primes.  Find that set}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls;

type
TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearcBtn: TButton;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure SearcBtnClick(Sender: TObject);
  public
    Primes:array of integer;
    Procedure MakeThePrimes;
    function isprimeinteger(m,k:integer):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  smallprimes:array[0..3] of integer=(2,3,5,7);
  tab:char=#09;

{************ SearchbtnClick ***********}
procedure TForm1.SearcBtnClick(Sender: TObject);
var
  i,j,k:integer;
  p1,p2,p3:integer;{the 3 primes to test}
  count:integer;
begin
  makethePrimes;
  count:=length(primes);
  {Check the list for 3 that meet the given conditions}
  for i:=0 to count-3 do { for 1st trial prime}
  begin
    p1:=primes[i];
    for j:=i+1 to count-2 do  {and all other 2nd trial primes}
    begin
      p2:=primes[j];
      for k:=j+1 to count-1 do {and all other 3rd trial primes}
      begin
        p3:=primes[k];
        if isprimeInteger((p1+p2), 2)  {see if they meet the conditions}
        and isprimeinteger((p2+p3), 2)
        and isprimeInteger((p1+p3),2)
        and isprimeInteger((p1+p2+p3),3)
        then {Yes, show a solution}
        with memo1.Lines do
        begin
          add('');
          add(format('Solution primes are: %d, %d, and %d:',[p1,p2,p3]));
          add(tab+format('(%d+%d) div 2 = %d (prime)',[p1,p2, (p1+p2) div 2]));
          add(tab+format('(%d+%d) div 2 = %d (prime)',[p2,p3, (p2+p3) div 2]));
          add(tab+format('(%d+%d) div 2 = %d (prime)',[p1,p3, (p1+p3) div 2]));
          add(tab+format('(%d+%d+%d) div 3 = %d (prime)',[p1,p2,p3, (p1+p2+p3) div 3]));
        end;
      end;
    end;
  end;
end;

{*********** MakethePrimes *********}
procedure TForm1.maketheprimes;
  var
    i,j:integer;
    count:integer;
    OK:boolean;
  begin
  {Build an array of all 2 digit primes}
  count:=0;
  setlength(primes,90);
  for i:=11 to 99 do     {these are the 2 digit numbers to test}
  {Test for primality:
    For any B < A,
    if "(A div B) * B = A" then B divides A evenly and A is not prime}
    {If B is not prime, then if B divides A, the factors of B also divide A,
     so we only need to check whether primes less than A are factors.}
  begin
    OK:=true;
    for j:=0 to 3 do
    if (i div smallprimes[j])*smallprimes[j]=i then
    begin
      OK:=false;
      break;
    end;
    if OK then {OK so far, try all the smaller 2 digit primes already discovered}
    for j:=0 to count-1 do
    if (i div primes[j])*primes[j]=i then
    begin
      OK:=false;
      break;
    end;
    if OK then  {we have found the next 2 digit prime}
    begin  {add it to the list}
      primes[count]:=i;
      inc(count);
    end;
  end;
  setlength(primes,count);
end;

{************ IsPrimeInteger ***********}
function TForm1.isprimeInteger(m,k:integer):boolean;
{If k divides the sum, m, evenly then search the table of primes to see if it
 includes m div k}
  var i:integer;
      n:integer;
  begin
    i:=0;
    result:=false;
    n:=m div k;
    if n*k=m then
    repeat  {k divides m}
      if primes[i]=n then result:=true;
      inc(i);
    until (primes[i]>n) or result;
  end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
