unit U_DigitProducts2;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 
{
 Among the 2 and 3 digit positive integers, there are
one or two which are an exact multiples of the product
of their digits for each multiple from 2 through 9,.
Find them.

In "math speak": If P(N) is the product of the digits of
N,, find all 2 and 3 digit integers, N,  such that N = M *
P(N) for integer M with  2<= M<=9.

Example: For N=24, P(N)=8 and N = 3 * 8, so M=3.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Strutils;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    PageControl1: TPageControl;
    Problem4: TTabSheet;
    Problem1: TTabSheet;
    P1Memo: TMemo;
    P4Memo: TMemo;
    Problem2: TTabSheet;
    P2Memo: TMemo;
    Problem3: TTabSheet;
    P3Memo: TMemo;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure SolveP1;
    procedure SolveP2;
    procedure SolveP3;
    procedure SolveP4;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



{************ SearchBtnClick *********8}
procedure TForm1.SearchBtnClick(Sender: TObject);
begin
  if  Pagecontrol1.Activepage =  problem1 then  solveP1
  else if pagecontrol1.Activepage=problem2 then SolveP2
  else if pagecontrol1.Activepage=problem3 then SolveP3
  else solveP4;
end;




{*********** SolveP1 *************}
Procedure TForm1.SolveP1;
{Find the 2 and 3 digit positive integers which become exact multiples of their
original value when multiplied by some digit 2 through 9.}
var
  i,m,n,p,d:integer;
begin
  P2memo.lines.add('');
  for N:=10 to 999 do {for 2 and 3 digit N}
  begin
    i:=n; {i = work value}
    p:=1; {initialize product}
    while i>0 do
    begin  {for each digit of I}
      d:= i mod 10; {get the low order digit of I}
      p:=p*d; {calcuate product so far}
      i:=i div 10;  {drop the low order digit}
    end;
    if P>0 then {cant calculate M if P is 0}
    begin
      M:=N div P; {get the truncated multipole}
      if (M>=2) and (M<=9) and (M*P=N) {multiple in range and it's an exact multiple}
      then P1Memo.Lines.Add(format('For %d the digit product is %d which * %d is %d',[N,P,M,N])); {report it}
    end;
  end;
end;

{**************** SolveP2 *************}
procedure TForm1.SolveP2;
{Find 6-digit integers which reverse their digits when multiplied by some single digit}
var
  i,j,k,n:integer;
  s1,s2:string;
  OK:boolean;
begin
 for i:=100000 to 499999 do
  begin
    s1:=inttostr(i);
    if s1[6]<>'0' then
    for j:=2 to 9 do
    begin
      n:=j*i;
      s2:=inttostr(n);
      if length(s2)>6 then break;
     (* {Method 1: Compare digits one through 6 of product with 6 through 1 of original #}
      ok:=true;
      for k:=1 to 6 do if s2[k]<>s1[7-k] then
      begin
        OK:=false;
        break;
      end;
      *)
      OK:=s1=reversestring(s2); {or Method2: Just reverse the product string and compare to original}
      if OK then p2memo.Lines.add(format('%s * %d = %s',[s1,j,s2]));
    end;
  end;
end;

{**************** SolveP3 ***************}
procedure TForm1.SolveP3;
{Find intergers whose square and 4th powers contains exactly the digits 0 through 9}
var
  i,n,d:integer;
  x3,x4:integer;
  s3,s4:string;
  digits:string[10];
  OK:boolean;
begin
  for i:= 1 to 30 do
  begin
    x3:=i*i*i;
    x4:=x3*i;
    s3:=inttostr(x3);
    s4:=inttostr(x4);
    if length(s3)+length(s4)=10 then
    begin
      digits:='NNNNNNNNNN';
      OK:=true;
      n:=x3;
      while OK and (n>0) do
      begin
        d:=n mod 10 +1; {'0' is in string position 1, etc.}
        n:=n div 10;
        if digits[d]<>'N' then OK:=false
        else digits[d]:='Y';
      end;
      n:=x4;
      while OK and (n>0) do
      begin
        d:=n mod 10 +1 ;
        n:=n div 10;
        if digits[d]<>'N' then OK:=false
        else digits[d]:='Y';
      end;
      if OK
      then P3Memo.lines.add(format('Solution: %d cubed = %d and 4th power = %d',
                                    [i, x3, x4]));
    end;
  end;
end;

{*************** SolveP4 ************}
procedure TForm1.SolveP4;
{The lucky, numerically handicapped, shopper}
var
  a,b,c,d,sum:integer;
  product:extended;
begin
  for a:=1 to 708 do
  begin
    for b:=a to 708 do
    begin
      sum:=a+b;
      if sum <= 711 then
      begin
        product:=a*b/10000;  {values are in cents, so a*b is 10^4 times too high for  $ test}
        if product<=7.11 then
        begin
          for c:=b to 708 do
          begin
            sum:=a+b+c;
            if sum>711 then break; {already too large, stop checking this set}
            begin
              d:=711-a-b-c;
              {we want only solutions with a,b,c,d in ascending order}
              if (d<a) or (d<b) or (d<c) then break;
              {values are each is in cents, 100 times larger than dollar value,
              so divide product of all four by 10^8}
              product:=a*b*c*d/100000000;
              if product=7.11
              then P4Memo.lines.add(
                  format('Prices for the four items are: $%.2f, $%.2f, $%.2f, and $%.2f',
                     [a/100, b/100, c/100, d/100]));
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
