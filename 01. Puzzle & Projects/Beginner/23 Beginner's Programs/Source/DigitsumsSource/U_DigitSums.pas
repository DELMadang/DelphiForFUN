unit U_DigitSums;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ A recent Mensa puzzle calendar asked
"How many 4 digit numbers are there
whose digits sun to 34?"  That one is
not too difficult since the sum cannot
exceed 36 (for the integer 9999), but it
started me thinking about other sums.

This program counts and lists the
number of integers of given length
which sum to any value.  About 25 lines
of user written Delphi code answer the
question for two thouugh five digit
integers.  }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ShellAPI;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    Memo1: TMemo;
    CalcBtn: TButton;
    Label1: TLabel;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure CalcBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses mathslib;

{********* CalcBtnClick ***********}
procedure TForm1.CalcBtnClick(Sender: TObject);
var
  i,N:integer;
  start:integer;
  sum, totsum:integer;
  sums:array of integer;
begin
  start:=intpower(10,spinedit1.Value-1); {For example 3 digits start at 10^2=100}

  setlength(sums,9*spinedit1.value+1); {For example 3 has sums from 1 to *3 = 27}
             {set length to 28 since we'll leave the [0] entry unused}

  for i:=start to start*10-1 do  {100 to 999 for example for all 3 digit numbers}
  begin
    sum:=0; {initialize sum}
    N:=i;  {N is the work value we'll use to extract the digits}
    while N>0 do
    begin
      inc(sum, N mod 10); {N mod 10 is the low order digit of N}
      N:=N div 10; {dividing by 10 drops the low order digit}
    end; {loop until N=0 (no more digits}
    inc(sums[sum]); {add 1 to the sum position in "sums" array}
  end;
  memo1.Clear;
  totsum:=0; {to add up all the individual sums as a double check}
  with memo1, lines do
  begin
    for i:= 1 to high(sums) do {display the number of occurrences of each sum}
    begin
      add(format('%2d: %5d', [i,sums[i]]));
      inc(totsum,sums[i]); {there should be as many sums as there were numbers}
                           {900 for 3 digit numbers from 100 to 999 for example}
    end;
    add(format('Total: %d',[totsum]));
    selstart:=0; sellength:=0; {force the memo back to display 1st line}
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
