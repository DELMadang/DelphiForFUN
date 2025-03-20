unit U_TShirt3;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Third in a series of programs producing numbers suitable for a line of T-Shirts:
"The only non-palidnromic integer less than a million whose cube is a palindrome"
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    SearchBtn: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    Label1: TLabel;
    StopBtn: TButton;
    procedure SearchBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  end;

var  Form1: TForm1;

implementation
{$R *.DFM}

{**************** IsPalindrome **********}
function IsPalindrome(n:int64):boolean;
{Test for palindromic integer}
var
  i,j:integer;
  s:string;
begin
  s:=inttostr(n); {set up to compare digits from both ends}
  i:=1;
  j:=length(s);
  while (i<j) and (s[i]=s[j]) do  begin  inc(i);  dec(j);  end;
  if i>=j then result:=true  else result:=false;
end;

{****************** SearchBtnClick *****************}
procedure TForm1.SearchBtnClick(Sender: TObject);
var  i,n:int64;
begin
  screen.cursor:=crHourglass; {set busy cursor}
  tag:=0; {reset stop flag}
  stopbtn.visible:=true;  {show stop button}
  searchbtn.enabled:=false; {& don't honor Search button clicks}
  application.processmessages; {Let windows draw the stop button}
  i:=10;  {Initialize loop variable}
  while i<1000000 do
  begin
    n:=i*i*i; {get i cubed}
    if ispalindrome(n)  {is it a palindrome?}
    then listbox1.items.add(inttostr(i)+' cubed is '+inttostr(n));
    inc(i);
    if i mod 32768 =0 then {interrupt once in a while}
    begin
      label1.caption:='Checked up to '+inttostr(i); {update staus label}
      application.processmessages;   {show label and check for stop button click}
      if tag<>0 then break;  {stop if flag turned on}
    end;
  end;
  label1.caption:='Checked up to  '+inttostr(i);
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
  searchbtn.enabled:=true;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin   tag:=1;  end;   {set stop flag}

end.
