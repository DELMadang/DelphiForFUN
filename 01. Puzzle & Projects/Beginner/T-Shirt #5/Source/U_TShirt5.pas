unit U_TShirt5;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{An "emirp" ("prime" spelled backwards), is a prime number
which forms a different prime when its digits are reversed.

A prime number is a integer with no exact integer divisors
except 1 and the number itself.

The text on the back of T-shirt #5 says "The smallest
3-digit emirp"  What number should we place on the front?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    SearchUpBtn: TButton;
    DigitsEdt: TEdit;
    Label1: TLabel;
    UpDown1: TUpDown;
    ListBox1: TListBox;
    Label2: TLabel;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Image1: TImage;
    procedure SearchBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*************** IsPrime ************}
function isprime(n:integer):boolean;
{Test an integer for "primeness"}
var i,j,stop:integer;
begin
  result:=false;
  {get rid of most of the cases right away}
  if (n mod 2 = 0) or (n mod 3=0) or (n mod 5 =0) then exit;
  result:=true;
  i:=7;
  stop:=trunc(sqrt(n+0.0)); {no need to check higher than this number}
  while result and (i<=stop) do
  begin
    if i*(n div i)=n then result:=false;
    inc(i);
  end;
end;

{********* Reverse ********}
function reverse(n:integer):integer;
{reverse the digits of an integer}
begin
  result:=0;
  while n>0 do
  begin {"n mod 10" is the low order digit of n}
    result:=10*result+n mod 10;
    n:=n div 10; {chop the low order digit from n}
  end;
end;

{************** IntPower *************}
function intpower(n,power:integer):integer;
{Raise an integer to an integer power}
var i:integer;
begin
  result:=1;
  for i:=1 to power do result:=result*n;
end;

{************** SearchBtnClick ************}
procedure TForm1.SearchBtnClick(Sender: TObject);
var stop,i,r,count:integer;
begin
  listbox1.clear;
  i:=intpower(10,updown1.position-1);
  stop:=i*10-1;
  count:=0;
  while (i<=stop) and (count<=100) do
  begin
    r:=reverse(i);
    if isprime(i) and isprime(r) and (i<>r) then
    begin
      inc(count);
      listbox1.items.add(inttostr(i) + ' is an emirp');
    end;
    inc(i);
  end;
end;

end.
