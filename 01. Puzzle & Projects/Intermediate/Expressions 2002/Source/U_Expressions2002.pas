unit U_Expressions2002;

{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
 Insert + or * signs as required into the string of digits 123456789 to
 form an expression that evaluates to 2002.

 Integers 1 Through 9 must appear in increasing order.  Integers used
 in the expression are may be a concatenation of digits.  Assume,
 as usual, that multiplications are performed before additions.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    CalcBtn: TButton;
    SolutionBox: TListBox;
    TargetEdt: TEdit;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    procedure CalcBtnClick(Sender: TObject);
    procedure TargetEdtKeyPress(Sender: TObject; var Key: Char);
  end;

var Form1: TForm1;

implementation

{$R *.DFM}
type Tarray=array of integer;

{*********** Power ************}
function Power(n,exponent:integer):integer;
{raise integer, n,  to the integer ,exponent, power}
var i:integer;
begin
  result:=n;
  for i := 1 to exponent-1 do result:=result*n;
end;

{*************** Convertbase ************}
procedure convertbase (n,base:integer;var converted:Tarray);
{convert numbers to another base - 3 in this case}
var
  i,w:integer;
begin
  w:=n;
  for i := high(converted)  downto 0 do
  begin
    converted[i]:= w mod base;
    w:=w div base;
  end;
end;

var signstr:array[1..2] of char=('+','*'); {for display}

{************** TForm1.CalcBtnClick ********}
procedure TForm1.CalcBtnClick(Sender: TObject);
{Solve the problem}
{Plan is to generate 8-digit base 3 numbers from 0 to 3^8-1
 and use the resulting numbers as indicators of the operation
 to perform  for each of the 8 "slots" between the 9 digits:
   0=concatenate, 1=+, 2=*

 Because * has priority over +, we'll just push the operaands
 onto a "stack".  When we have a * operand, we can can go ahead and
 multiply the top stack operand by the next number and push the result
 back onto the stack
 }

var
  signs:Tarray; {the base 3 numbers}
  i,j:integer;
  sum, nextnum, lastop, target:integer;
  s:string;
  stack:array[1..8] of integer; {"stack" to hold interim results}
  count:integer;  {nbr of entries in the stack}

      {********* push ********}
      procedure push(n:integer);
      {a simple push procedure}
      begin
        inc(count);
        stack[count]:=n;
      end;

      {********** Pop *******}
      function pop:integer;
      {a simple Pop procedure - returns 0 if there are no items in the stack}
      begin
        if count>0 then
        begin
          result:=stack[count];
          dec(count);
        end
        else result:=0;
      end;

begin
  target:=strtoint(targetedt.text);
  Solutionbox.clear;
  setlength(signs,8);
  count:=0; {clear the stack}
  for j:= 0 to power(3,8) do
  begin
    Convertbase(j,3,signs); {get the next arrangement}
    nextnum:=1; lastop:=-1;
    for i:= 0 to 8 do
    begin
      if (i=8{handle lastop and last number}) or (signs[i]>0)  then
      begin {current op is + or *}
        case lastop of
          1: push(nextnum);
          2: push(pop*nextnum);
          else push(nextnum); {no last op, handles first time}
        end; {case}
        nextnum:=i+2;
        if i<=high(signs) then lastop:=signs[i];{save the op for next iteration}
      end
      else nextnum:=nextnum*10+i+2;{current op is concatenate, append the next digit}
    end;
    {all terms are in the stack, everything in the stack can be summed}
    sum:=0;
    while count>0 do sum:=sum+pop;
    if sum=target then {solution found}
    begin
      s:=''; {make a solution display string}
      For i:= 0 to 8 do
      begin
        s:=s+inttostr(i+1); {get a digit}
        case signs[i] of  {add a sign if necessary}
          1, 2: s:= s+ signstr[signs[i]];
        end;
      end;
      s:=s+' = '+targetedt.text;
      Solutionbox.items.add(s);
    end;
  end;
end;

{*************** TForm1.TargetEdtKeyPress ***********}
procedure TForm1.TargetEdtKeyPress(Sender: TObject; var Key: Char);
{make sure only digits (or backspace) are entered in the edit field}
begin
  If not (key in ['0'..'9',#8]) then
  begin
    key:=#0;
    beep
  end;
end;

end.
