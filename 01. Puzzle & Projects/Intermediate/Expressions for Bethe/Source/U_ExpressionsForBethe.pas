unit U_ExpressionsForBethe;

{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
  Insert + (plus) , - (minus),  * (times) or / (divide)
  signs as required into a given set of source
  digits  to   form an expression that evaluates to the
  given Target value.

  Operations will be performed in normal order
  of precedence (multiplcation and division
  before addition and subtrraction; left to right
  within equal precedence operatorsi).

  Division operations are allowed only if the
  resulting quotient is an exact integer.


 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellapi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    CalcBtn: TButton;
    SolutionBox: TListBox;
    TargetEdt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SourceEdt: TEdit;
    StaticText1: TStaticText;
    procedure CalcBtnClick(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
    procedure StaticText1Click(Sender: TObject);
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

var opstr:array[1..4] of char=('+','-','*','/'); {for display}

{************** TForm1.CalcBtnClick ********}
procedure TForm1.CalcBtnClick(Sender: TObject);
{Solve the problem}
{Given N source diogits, the plan is to generate N-1 base 5 numbers
  from 0 to 5^(N-1)-1
 and use the resulting numbers as indicators of the operation
 to perform  for each of the N-1 "slots" between the N digits:
   0=concatenate, 1=+, 2=-, 3=*, 4=/.

 Because * & / have priority over + & -, we'll just push the operaands
 onto a "stack".  When we have a * or / operand, we can can go ahead and
 multiply the top stack operand by the next number and push the result
 back onto the stack
 }

var
  ops:Tarray; {the base 5 numbers}
  i,j,N:integer;
  x,y:integer;
  sum, nextnum, lastop, target:integer;
  s:string;
  stack:array of integer; {"stack" to hold interim results}
  count:integer;  {nbr of entries in the stack}
  OK:boolean;
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
  N:=length(sourceedt.text);
  setlength(stack,N+1);
  Solutionbox.clear;
  setlength(ops,N-1);
  screen.cursor:=crhourglass;
  for j:= 0 to power(5,N-1) do
  begin
    Convertbase(j,5,ops); {get the next arrangement}
    nextnum:=strtoint(sourceedt.text[1]); lastop:=-1;
    ok:=true;
    COUNT:=0;   {clear the stack in case previous expression was aborted}
    for i:= 0 to N-1 do
    begin
      if (i=N-1{handle lastop and last number}) or (ops[i]>0)  then
      begin {current op is + or *}
        case lastop of
          1: push(nextnum);
          2: push(-nextnum);
          3: push(pop*nextnum);
          4:begin  {division, make sure it divides evenly}
              x:=pop;
              if nextnum<>0 then y:=x div nextnum else y:=0;
              if {(y<>0) and} (nextnum*y = x) then push(y)
              else
              begin
                ok:=false;
                break;
              end;
            end;
          else push(nextnum); {no last op, handles first time}
        end; {case}
        if i<n-1 then nextnum:=strtoint(sourceedt.text[i+2]);
        if i<=high(ops) then lastop:=ops[i];{save the op for next iteration}
      end
      else nextnum:=nextnum*10+strtoint(sourceedt.text[i+2]);{current op is concatenate, append the next digit}
    end;
    if Ok then
    begin
      {all terms are in the stack, everything in the stack can be summed}
      sum:=0;
      while count>0 do sum:=sum+pop;
      if sum=target then {solution found}
      begin
        s:=''; {make a solution display string}
        For i:= 0 to n-1 do
        begin
          s:=s+sourceedt.text[i+1]; {get a digit}
          if i<n-1 then
          case ops[i] of  {add a sign if necessary}
            1, 2,3,4: s:= s+ opstr[ops[i]];
          end;
        end;
        s:=s+' = '+targetedt.text;
        Solutionbox.items.add(s);
        solutionbox.update;
        if solutionbox.items.count>=100 then
        begin
          showmessage('More than 100 solutions, first 100 shown');
          break;
        end;
      end;
    end;
  end;
  if solutionbox.items.count=0
  then solutionbox.items.add('No solutions found');
  screen.cursor:=crdefault;
end;

{*************** TForm1.TargetEdtKeyPress ***********}
procedure TForm1.EdtKeyPress(Sender: TObject; var Key: Char);
{make sure only digits (or backspace) are entered in the edit field}
begin
  If not (key in ['0'..'9',#8]) then
  begin
    key:=#0;
    beep
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
