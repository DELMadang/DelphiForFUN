unit U_Reversed;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Reversed numbers}

{ Find a six digit number which, when multiplied by an integer
between 2 and 9 inclusive, gives the original six digit number
with it's digits reversed.

Thus, for example, if the original number was 123456, and the
chosen integer was 8, then 123456 X 8 should equal 654321,
which of course it doesn't.    It is possible to find more than
one  solution to the problem, but I'll accept any one that
meets the  required condition.

Source:  Math and Logic Puzzles for PC Enthusiasts,
              J. J.  Clessa.  Problem # 34.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure SolveBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i,j:integer;
  n1,n2:integer;
  digits:array[0..5] of integer;
  startcount, stopcount, freq:int64;
  sec:extended;
begin
  screen.cursor:=crhourglass;
  queryperformancecounter(startcount); {get start time count}
  {for all 6 digit integers}
  for i:=100000 to {999999} 500000 do {no need to check beyond halfway}
  begin
    {separate the digits into an array, units digit in digits[0]}
    n1:=i;
    j:=0;
    while n1>0 do
    begin
      digits[j]:=n1 mod 10;
      n1:=n1 div 10;
      inc(j);
    end;

    {now build a number with the digits reversed}
    n2:=0;
    for j := 0 to 5 do n2:=n2*10+ digits[j];
    {see if the original number time some digit 2 - 9 equals the second #}
    for j:= 2 to 9 do
    begin
      if i*j=n2  {a solution}
      then memo1.lines.add(inttostr(i)+' X '+inttostr(j)+' = '+inttostr(n2))
      else If i*j>n2 then break; {no sense trying any bigger j's}
    end;
  end;
  queryperformancecounter(stopcount); {end time count}
  queryperformancefrequency(freq); {counts per second}
  sec:= (stopcount-startcount)/freq; {run time in seconds}
  memo1.lines.add(format('Run time %6.3f seconds',[sec]));
  screen.cursor:=crdefault;
end;

end.
