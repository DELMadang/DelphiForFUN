unit U_RemainderOf1;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 { What is the smallest multiple of 13 which leaves a remainder of 1 when
   divided by each of the numbers 2 through 12?

   We'll try 2 methods to find a solution:
      1. Brute force- testing successive multiples of 13  until we find one
         that leaves a remainder of 1 when divided by 2 througgh 12.
      2, Find lowest common multiple (LCM) of 2 through 12 and
         test successive (multiples of LCM) + 1 until we find one
         divisible by 13
  }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SearchBtn1: TButton;
    SearchBtn2: TButton;
    Memo2: TMemo;
    Memo3: TMemo;
    StatusBar1: TStatusBar;
    StatusBar2: TStatusBar;
    procedure SearchBtn1Click(Sender: TObject);
    procedure SearchBtn2Click(Sender: TObject);
  end;

var  Form1: TForm1;

implementation
{$R *.DFM}

var searchlimit:integer=100000;

{************** TForm1.SearchBtn1Clcik *********}
procedure TForm1.SearchBtn1Click(Sender: TObject);
var  i:int64;
     j:integer;
     solved:boolean;
     start,stop,freq:int64;
begin
  i:=13;
  queryperformancecounter(start);
  repeat
    inc(i,26); {it has to remain odd}
    solved:=true;
    for j:=2 to 12 do
    if i mod j <>1 then
    begin
      solved:=false;
      break;
    end;
  until solved or (i>Searchlimit);
  queryperformancecounter(stop);
  queryperformancefrequency(freq);
  if solved then showmessage(format('Solution is %8.0n,'
  +#13+'Calculation time:  %8d microseconds',
                   [i+0.0, 1000000*(stop-start) div freq]))
  else showmessage(format('No solutions less than %8.0n',[searchlimit+0.0]));
end;

{**************** GCD2 *************}
Function gcd2(a,b:integer):integer;
{return greated common denominator of a and b}
{Euclids method -  any number that divides a and b must divide a-b}

var g,z:integer;
begin
  g:=b;
  If b<>0 then
  while g<>0 do
  begin
    z:=a mod g;
    a:=g;
    g:=z;
  end;
  result:=a;
end;

(*
{*************** GCD **************}
{Not used here but included for completeness}
Function GCD(A:array of integer):integer;
{Greatest Common Denominator of an array of integers}
var i,g:integer;
begin
  g:=a[0];
  if length(a)>=2 then
  begin
    g:=gcd2(g,a[1]);
    if length(a)>2 then
    for i:= 2 to length(a)-1 do g:=gcd2(g,a[i]);
  end;
  result:=g;
end;
*)

{*************** LCM ************}
Function LCM(A:array of integer):integer;
{Find the Lowest Common Multiple of an array of integers}
var i,x:integer;
begin
  x:=a[0];
  for i:=1 to length(a)-1 do x:=(x*a[i]) div gcd2(x,a[i]);
  result:=x;
End;

{************** Tform1.SearchBtn2Click *********}
procedure TForm1.SearchBtn2Click(Sender: TObject);
var i,n:integer;
    start,stop,freq:int64;
begin
  queryperformancecounter(start);
  n:=lcm([2,3,4,5,6,7,8,9,10,11,12]);
  i:=0;
  repeat
    inc(i);
  until ((i*n +1) mod 13 =0) or (i>10);
  queryperformancecounter(stop);
  queryperformancefrequency(freq);
  if (i*n+1) mod 13 =0

  then showmessage(format('LCM of [2..12] is %8.0n,'
                          +#13
                          +'Solution is %8.0n (%2.0n X %8.0n + 1),'
                          +#13+'Calculation time:  %8d microseconds'
                           ,[n+0.0,i*n+1.0,i+0.0,n+0.0,
                              1000000*(stop-start) div freq]))
  else showmessage(format('No solutions less than %8.0n',[i*n+1+0.0]));
end;

end.
