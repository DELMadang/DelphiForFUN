unit U_TShirt4;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Find the smallest prime number that remains prime when added to its reversal}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Image1: TImage;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var Form1: TForm1;

implementation
{$R *.DFM}

{******* IsPrime *******}
function isprime(n:integer):boolean;
{Check is a number is prime}
var i:integer;
begin
  result:=true;
  for i:=2 to trunc(sqrt(n)) do
  if i*(n div i)= n then  {is i a factor of n?}
  begin
    result:=false;
    break;
  end;
end;

{********* Reverse ********}
function reverse(n:integer):integer;
{reverse the digits of an integer}
begin
  result:=0;
  while n>0 do
  begin
    result:=10*result+n mod 10;
    n:=n div 10;
  end;
end;

{********** SolveBtnClick ********}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i,r:integer;
begin
  for i:= 13 to  999 do
  begin
    if isprime(i) then
    begin
      r:=reverse(i);
      if isprime(i+r) then
      listbox1.items.add(inttostr(i) +' + '+inttostr(r)+' = '+inttostr(r+i));
    end;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  statusbar1.panels[0].text:=#169+' 2002 Gary Darby, www.delphiforfun.org';
end;

end.
