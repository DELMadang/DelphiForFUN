unit U_ChallengingMathTeasers;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{ Here are three problems from the 100 presented in the "Challenging Mathematical Teasers" book by J.A.H.
Hunter and published ny Dover Publications.  These puzzles generally require math techniques beyond simply
solving an algebraic equation or two.  The three presented here were chosen randomly are easily amenable to
programmed solutions (and have relatively short descriptions :>) }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo5: TMemo;
    GrandpaBtn: TButton;
    SquaresBtn: TButton;
    Memo1: TMemo;
    Memo3: TMemo;
    WrongBtn: TButton;
    Memo2: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure GrandpaBtnClick(Sender: TObject);
    procedure SquaresBtnClick(Sender: TObject);
    procedure WrongBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    bitmap1,bitmap2:TBitmap;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{**************** GrandPaBtn **************}
procedure TForm1.GrandpaBtnClick(Sender: TObject);
var
  n,sum:integer;
  G,age,D1,D10:integer;
begin
  for age:=1 to 20 do
  begin
    sum:=(age+1)*age div 2;
    G:=sum-1;
    N:=G;
    D1:=n mod 10;
    D10:= (N div 10) mod 10;
    if D1+D10=age then showmessage(format('I am %d and Grandpa is %d',[age,G]));
  end;
end;

{************** SquaresBtnClick **********}
procedure TForm1.SquaresBtnClick(Sender: TObject);
var
  i,N,D1,D10,D100:integer;
begin
  for i:= 50 to 499 do  {doubling "i" will create }
  begin                 {even 3 digit numbers (from 100 to 998)}
    N:=2*i;
    D1:=N mod 10;  {"1s" digit}
    D10:= (N div 10) mod 10; {"10s" digit}
    D100:= (N div 100) mod 10; {"100s" digit}
    if D1*D1+D10*D10+D100*D100 = i
    then showmessage(format('Sum of squares of digits of %d equals %d',[N,I]));
  end;
end;

(*
procedure TForm1.WrongBtnClick(Sender: TObject);
{A floating point solution, but calculated result never comes back to exactly 5.70
 so a "close enough" test is required. The problem then is determining how close
 is close enough. There are a number of solutions that come within .1 cent of the
 given answer. Tolerance must be set to .01 cent or less to match the desired
 answer.}
var
  i,j,k:extended;
  target,test:extended;
begin
  target:=5.70;
  i:=1.00;
  while i<target do
  begin
    i:=i+0.01;
    j:=i-0.01;
    while j<=target-i do
    begin
      j:=j+0.01;
      k:=target-i-j;
      if k< j then break;
      test:=i*j*k;
      {Exact equality test will fail for floating point values,
       use "almost equal" test}
      if abs(test-target)<=0.0001
      then showmessage(format('%.2f + %.2f + %.2f = %.2f * %.2f * %.2f = %.2f',[i,j,k,i,j,k,target]));
    end;
  end;
end;
*)

{************ WrongBtnClick ***********}
procedure TForm1.WrongBtnClick(Sender: TObject);
var
  i,j,k,n:integer;
  target:integer;
  test:extended;
begin
  target:=570; {in cents}
  i:=100; {To use integer arithemtic, we'll do the calculations in cents,
          100 times larger than the true $ value and divide them by 100 when
          displaying results}
  while i<target do
  begin
    inc(i);
    j:=i;
    while j<=target-i do
    begin
      k:=target-i-j;
      test:=i*j*k /10000; {product will be 100*100*100 (i.e. 1,000,000 times
                            too large, but we'll only dvidie the value by 10,000
                            to compare the value to the target in cents}
      if test-target=0  {cents values are equal, but we will display the results
                         back in dollars}
      then showmessage(format('%.2f + %.2f + %.2f = %.2f * %.2f * %.2f = %.2f',
             [i/100,j/100,k/100,i/100,j/100,k/100,test/100]));
       inc(j);
    end;
  end;
end;

 procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
