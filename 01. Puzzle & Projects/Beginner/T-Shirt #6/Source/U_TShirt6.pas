unit U_TShirt6;

{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Find numbers with the sum of the Nth powers of their digits equal to the number}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ComCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  end;

var  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var i,sum:integer;
    j,k,n,m, val, limit:integer;
begin
  listbox1.Clear;
  screen.cursor:=crhourglass; {show busy cursor}
  val:=spinedit1.value; {the power to check}
  {calculate the upper limit to check (10^val-1), then largest number with val digits}
  k:=10;
  for j:=1 to val-1 do k:=k*10 ;
  limit:=k-1;
  {Check all numbers in the range}
  for i:=2 to limit do
  begin
    n:=i;  {work version of the number}
    sum:=0;  {the sum}
    while (n>0) and (sum<i) do
    begin
      m:=n mod 10; {get the low order digit}
      k:=m; {k wil be the  "val"th power of the digit}
      for j:=1 to val-1 do k:=k*m;
      sum:=sum+k; {add power to the sum}
      n:=n div 10; {chop off the low order digit}
    end;
    if (n=0) and (sum=i) {We have a winner!
      (Processed all the digits and the sum euals the number)}
    then listbox1.items.Add(format('%d',[sum]));
  end;
  screen.cursor:=crdefault;
end;


end.
