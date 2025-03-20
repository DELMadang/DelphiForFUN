unit U_HowManyOnes;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
How many does the digit 1 appear in all of the
numbers between 0 and 999,999?

This simple 30 line program provides the
generalized answer for all appearances of a
specified digit between any two integers.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Spin, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    SearchBtrn: TButton;
    Memo2: TMemo;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    CalcMethod: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtrnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{****** Button1Click ************8}
procedure TForm1.SearchBtrnClick(Sender: TObject);
var
  i,N,count:integer;
  sdigit:char;
  s:string;
begin
  count:=0; {initialize the counter}
  screen.cursor:=crhourglass;   {show "busy" cursor}
   sdigit:=char(ord('0')+spinedit1.value); {Character form of the digit to test in Method 2}
  for i:=spinedit2.value to spinedit3.value do {For each digit in the range}
  case Calcmethod.itemindex of
  0:begin {Method 1}
     N:=i;
     while N > 0 do
     begin
       {check for digit spinedit1.value in the units position using the "mod" function}
       if N mod 10 =spinedit1.value then inc(count); {yes, matched, increment the count}
       N:=N div 10; {move the next leftmost digit to the units position}
      end;
    end;
  1:begin {Method 2}
      S:=inttostr(i); {make string version of integer to test}
      for N:=1 to length(S) do if S[N]=sdigit then inc(count) {Check each character}
    end;
  end; {end case}
  memo2.lines.add(format('Method %d: There are %d %d''s between %d and %d',
         [calcmethod.itemindex+1, count,Spinedit1.value, spinedit2.value, spinedit3.value]));
  screen.cursor:=crdefault;
end;

{************ StaticText1Click ********}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
