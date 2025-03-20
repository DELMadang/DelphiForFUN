unit U_DigitsAndNumbers;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {
 Here are program solutions fo a few problems adapted from the
latest Dover Publications addition  to my library, "Challenging
Mathematical Treasers" by J.A.H. Hunter.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Memo3: TMemo;
    GrandPaBtn: TButton;
    TabSheet5: TTabSheet;
    LicenseBtn: TButton;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    ExampleBtn: TButton;
    Memo2: TMemo;
    PhoneBtn: TButton;
    Memo1: TMemo;
    AgeBtn: TButton;
    ExtraBtn: TButton;
    Memo7: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure PhoneBtnClick(Sender: TObject);
    procedure AgeBtnClick(Sender: TObject);
    procedure GrandPaBtnClick(Sender: TObject);
    procedure LicenseBtnClick(Sender: TObject);
    procedure ExampleBtnClick(Sender: TObject);
    procedure ExtraBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ ExampleBtnClick ************}
procedure TForm1.ExampleBtnClick(Sender: TObject);
var n, test, sum: integer;
begin
 for n:=100 to 999 do
 begin
   test:=n; {Make "test" the work field}
   sum:=test mod 10; {Put the low order digit of "test" into "sum"}
   test:=test div 10; {shift "test" one digit to the right}
   sum:=sum + test mod 10; {add the second digit to sum}
   test:=test div 10; {get down to the final digit}
   sum:=sum+ test; {add it to "sum"}
   {is n an exact multiple of sum and does n div sum =35?}
   if (n mod sum = 0) and (n div sum =35)
   then showmessage(  'The number '+inttostr(n) +'  is '
                   + ' 35 times the sum  of its digits!');
 end;
end;

{************** AgeBtnClick (Problem 16)************}
procedure TForm1.AgeBtnClick(Sender: TObject);
var i,a,b,c:integer;
begin
  for i:=111 to 999 do
  begin
    a:=i div 100;
    b:=(i div 10) mod 10;
    c:= i mod 10;
    if i=32*(a+b+c) then
    begin
      showmessage(format('The ages are (%d, %d, %d) which when written as %d is 32 times the sum of the ages, %d',
                          [a,b,c,i, a+b+c]));
    end;
  end;
end;

{************* ExtraBtnClick ***********}
procedure TForm1.ExtraBtnClick(Sender: TObject);
var n, test, sum: integer;
    a,b,c:integer;
    count, num:array[1..100] of integer;
    largest,smallest:integer;
begin
  for n:=1 to 100 do count[n]:=0;

  for n:=111 to 999 do
  begin
    test:=n;
    a:=test mod 10;
    test:=test div 10;
    b:=test mod 10;
    c:=test div 10;
    if n mod (a+b+c) =0 then
    begin
      inc(count[n div (a+b+c)]);
      num[n div (a+b+c)]:=n;
    end;
  end;
  largest:=0;
  smallest:=1000;
  for n:=1 to 100 do if count[n]=1 then
  begin
    if num[n]>largest then largest:=num[n];
    if num[n]<smallest then smallest:=num[n];
  end;
  showmessage(format('The smallest 3 digit number which is uniquely a multiple of the sum of its digits is %d',[smallest])
              +#13
              +format('The largest 3 digit number which is uniquely a multiple of the sum of its digits is %d',[largest]));
end;

{**************** PhoneBtnClick (Problem 17)************}
procedure TForm1.PhoneBtnClick(Sender: TObject);
var i, x:integer;
    start:tDatetime;
begin
  start:=now;
  for i:=1000000 to 9999999 do
  begin {check all 7 digit nuumbers}
    x:= i div 10000;  {get the leftmost 3 digits}
    x:=x + 1000*(i mod 10000); {add in 1000 times the bottom 4 digits};
    if 2*i+1=x  then
    begin
      showmessage(format('The number is %d which when doubled and incremented by 1 = %d',
                          [i,x])
                  +#13+format('The time to find this answer was %.4f seconds',
                  [(now-start)*secsperday]));
    end;
  end;
end;
{*************** GrandPaBtnClick (Problem 47) ***************}
procedure TForm1.GrandPaBtnClick(Sender: TObject);
(*
Doug said "Today is my Grandfather's birthday  and I made
up something on his age.  If you add up all of the ages that have been,
including my age now, you get one more than his age.  Plus the total of
the two digit in his age is my age."
*)

var n,g,g1,g2,targetsum:integer;
begin
  for g:=11 to 99 do
  begin
    g1:=g div 10; {High order digit}
    g2:=g mod 10; {Units position digit}
    targetsum:=g+1; {Sum of grandson's ages must be this number}
    if targetsum>40 then  {a reasonable minimumahe for grandpa}
    begin
      n:=g1+g2;  {Sum of grandpa's age digits is possible grandson's age}
      {sum of first n digits is average value=((first + last)/2 )* number of digits, (n}
      if n*(n+1) div 2 = targetsum  then  {sum=targetsum? if yes then}
      showmessage(format('Grandpa''s age is %d and Doug'' age is %d',[g, n]));
    end;
  end;
end;

{*************** LicenseBtnClick (Problem 61)*************}
procedure TForm1.LicenseBtnClick(Sender: TObject);
{"I found something very interesting about your license plate" said Stan.
"It's one  more than the number you get if you square the two halves and add
 them together.  You're number is 403491" and the two halves squared sum to 403490"
 Are there any othe 6 digit numbers that have this same property?}

var
  i, PartA, PartB, SumSq:integer;
begin
  for i:=100000 to 9999999 do
  begin
    Parta:=i div 1000;
    PartB:=i mod 1000;

    sumsq:=parta*parta+partb*PartB;
    if sumsq = i-1
    then memo5.lines.add (format('For %d, %d squared plus %d squared = %d',
          [i, PartA, PartB, sumsq]));
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
