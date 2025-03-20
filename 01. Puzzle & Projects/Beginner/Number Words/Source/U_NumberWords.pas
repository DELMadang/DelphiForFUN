unit U_NumberWords;
 {Copyright  © 2005, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     StdCtrls, ExtCtrls, ComCtrls, shellAPI;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    RandBtn: TButton;
    ConvertBtn: TButton;
    Words: TEdit;
    Label1: TLabel;
    NumString: TEdit;
    Label2: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure RandBtnClick(Sender: TObject);
    procedure ConvertBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{Constants for converting numbers to words}
var
  nbrstr:array[1..9] of string=('one','two','three','four','five',
                                 'six', 'seven','eight','nine');
  decadestr:array[2..9] of string=('twenty','thirty','forty','fifty','sixty',
                            'seventy','eighty','ninety');

  {Because we do not say "oneteen", "twoteen", "threeteen", we need to handle
   10 to 19 as a special case}
  teenstr:array[10..19] of string=('ten', 'eleven','twelve','thirteen','fourteen',
                           'fifteen','sixteen','seventeen','eighteen','nineteen');

{************ FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;  {set random seed so that random results are not repeatable}
end;


{********** ConvertHundreds **********}
 function converthundreds(n:integer):string;
 {convert a 1, 2, or 3 digit number to words}
 var
   m:integer;
   s:string;
 begin
    m:=n div 100; {get the hundreds digit}
    n:=n mod 100; {retain the tens and units digits}
    if m>0 then s := nbrstr[m]+' hundred ' {convert hundreds to a word}
    else s:='';

    if n>19 then {"Tens" digit is greater than 1}
    begin
      m:=n div 10; {get the tens digit}
      n:=n mod 10; {retain the units digit}
      s:=s+decadestr[m];
      if n>0 then s:=s+'-'+nbrstr[n];
    end
    else
    begin {number is in the range 1 to 19}
      if n>=10 {10 to 19}
      then s:=s + teenstr[n] {get those nasty "teens" words}
      else if n>0 then s:=s+ nbrstr[n] {otherwise just get the units word}
    end;
    result:=s; {That's all folks - return the converted string}
  end;

{********** MakeNumberString *************}
function makenumberstring(const newn:integer):string;
{Convert integer N,  0<=N<1000000,  to words}
var m,n:integer;
    s:string;
begin
  n:=newn;
  if n=0 then s:='zero'
  else if n<1000000 then  {only handle numbers up to 1,000,000}
  begin
    m:=n div 1000; {get the "thousands" value, rightmost 3 digits stripped off}
    n:=n mod 1000; {get the "hundreds", the rightmost 3 digits}
    {convert the thousands, if any, to words}
    if m >0 then s:=convertHundreds(m)+' thousand '
      else s:='';
    if n>0 then s:=s+convertHundreds(n); {convert the hundreds to words}
  end
  else s:='Number too large';
  s[1]:=upCase(s[1]);
  result:=s;
end;

{************** RandBtnClick *************8}
procedure TForm1.RandBtnClick(Sender: TObject);
begin
   numstring.text:=inttostr(random(1000000));
end;


{************ ConvertBtnClick ************}
procedure TForm1.ConvertBtnClick(Sender: TObject);
{Convert a number to word form}
var
  n:integer;
  s:string;
begin
  {Convert the input digit string to an integer}
  s:=numstring.Text;
  {in case user used commas, delete them
  (Europe uses '.' for ',', ThousandSeparator variable reflects this difference)}
  s:=stringreplace(s, ThousandSeparator, '', [rfReplaceAll]);
  n:=strtointdef(s,-1); {return -1 if # is invalid}
  if n>=0  {digit string was valid}
  then words.Text:=makenumberstring(n)
  else showmessage('Input is not a valid positive integer');
end;


{*********** StaticText1Click **********}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
