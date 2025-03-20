unit U_OnesPuzzle;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Solves two puzzles from the Car-Talk radio show:
  1: On a six digit odomenter, how many times does the digit "1" appear
     between 000000 and 999999?
  2: On a six digit odometer, how many of the 1,000,000 values contain no "1"s>
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Spin, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    Puzzle2Btn: TButton;
    Label2: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Intlength: TSpinEdit;
    Digit2: TSpinEdit;
    Label10: TLabel;
    IntNbr: TSpinEdit;
    AtLeasrRBtn: TRadioButton;
    ExactRBtn: TRadioButton;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Puzzle1Btn: TButton;
    IntLength1: TSpinEdit;
    Digit1: TSpinEdit;
    Label5: TLabel;
    Label11: TLabel;
    Memo2: TMemo;
    TimingGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure Puzzle2BtnClick(Sender: TObject);
    procedure Puzzle1BtnClick(Sender: TObject);
    public
      
      function countdigits(const int, intlen, searchdigit:integer):integer;
      function countdigits2(const int,intlen,i:integer):integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{****************** CountDigits **************}
function TForm1.countdigits(const int, intlen, searchdigit:integer):integer;
{Return the nbr of occurrences of the digit "Searchdigit" in a passed integer,
"Int",  by converting the integer to a string and examining character
 by character.  This version "zero fills" the passed integer to make a number
 "intlen" digits long}
var
  s:string;
  i:integer;
  ch:char;
  begin
  ch:=char(ord('0')+searchdigit);
    s:=format('%*.*d',[intlen,intlen,int]);
    result:=0;
    for i:=1 to intlen do if s[i] = ch then inc(result);
end;

{************* CountDigits2 ***************}
function TForm1.countdigits2(const int,intlen,i:integer):integer;
{Return the nbr of digits in a passed integer by successively finding the
 unit digit using a "mod 10" operation (giving us the remainder when the
 number is divided by 10).  We then divided the number by 10, making the 10's
 digit the units digit, and looping as long as the number is greater than 0.
 }
var
  n:integer;
begin
  n:=int;
  //i:=ord(ch)-ord('0');
  result:=0;
  while n>0 do
  begin
    if n mod 10 = i then inc(result);
    n:=n div 10;
  end;
end;


{************* Puzzle1BtnClick *************}
procedure TForm1.Puzzle1BtnClick(Sender: TObject);
var
  i, maxint, digit:integer;
  count,sum:integer;
  //ch:char;
  Intlen:integer;

begin
  {check digits of length IntLength.value looking for one of AtLeastRBtn.checked
   or ExactRBtn.checked  IntNbr occurrences of the digit "Digit.value}
  Intlen:=IntLength1.value;
  maxint:=10;
  for i:=1 to intlen-1 do maxint:=10*maxint;
  dec(maxint);
  count:=0;
  //ch:=inttostr(digit1.Value)[1];
  digit:=digit1.value;
  for i:=0 to maxint do
  begin
    sum:=countdigits(i,intlen,digit);
    inc(count,sum);
  end;
  Showmessage(format('%.0n occurrences of the digit %d found',[count+0.0,digit]));
end;

{********** Puzzle2BtnClick ************}
procedure TForm1.Puzzle2BtnClick(Sender: TObject);
{Answer the question "How many integers of a given length contain 'at least"
 of "exactly" number of occurrences of a given digit?}
var
  i, maxint, digit:integer;
  count,sum:integer;
  //ch:char;
  Intlen:integer;
  exact:boolean;
  targetdigitcount:integer;
  Freq,Start,Stop:Int64;
  Secs:single;
begin
  {check digits of length IntLength.value looking for one of AtLeastRBtn.checked
    or ExactRBtn.checked  IntNbr occurrences of the digit "Digit.value}
  Intlen:=IntLength.value;
  {calculate the largest number to be checked}
  maxint:=10;
  for i:=1 to intlen-1 do maxint:=10*maxint;
  dec(maxint);

  count:=0;
  targetdigitcount:=intnbr.value;
  digit:=digit2.value;
  if exactrbtn.Checked then exact:=true else exact:=false;
  screen.cursor:=crHourGlass;
  QueryPerformanceFrequency(Freq);
  QueryPerformanceCounter(Start);
  for i:=0 to maxint do
  begin
    if timinggrp.ItemIndex = 0 then sum:=countdigits(i,intlen,digit) else sum:=countdigits2(i,intlen,digit) ;
    if exact then
       if (sum=TargetDigitCount) then inc(count)
       else
    else if sum>=TargetDigitcount then inc(count);
  end;
  QueryPerformanceCounter(stop);
  secs:=(stop-start)/freq;
  screen.cursor:=crDefault;
  Showmessage(format('%.0n numbers containing the digit %d found in %5.2f seconds',
                      [count+0.0, digit, secs]));
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
