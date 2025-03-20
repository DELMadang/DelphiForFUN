unit U_Expressions100B;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Insert + and - into the string 123456789 so that the  expression evaluates to
 a specified sum.   Version B also allows expression with a leading minus sign
 as a valid possible solution}
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
type Tarray=array of integer;

function Power(n,exponent:integer):integer;
{raise n to the exponent power}
var
  i:integer;
begin
  result:=n;
  for i := 1 to exponent-1 do result:=result*n;
end;



procedure convertbase (n,base:integer;var converted:Tarray);
{convert numbers to another base - 3 in this case}
var
  i,w:integer;
begin
  w:=n;
  for i := length(converted)-1  downto 0 do
  begin
    converted[i]:= w mod base;
    w:=w div base;
  end;
end;


procedure TForm1.CalcBtnClick(Sender: TObject);
{Solve the problem}
{Plan is to generate 9 digit base 3 numbers from 0 to 3^9
 and use the resulting numbers as indicators of the operation
 to perform  for each of the 9 "slots" between the digits
 (including a "slot" for a leading minus sign):
   0=concatenate with previous number, 1= insert +, 2= insert -
 }
const
  signstr:array[1..2] of char=('+','-'); {for display}
var
  signs:Tarray; {the base 3 numbers}
  i,j:integer;
  sum, nextnum, lastop, target:integer;
  s:string;
begin
  target:=strtoint(targetedt.text);
  Solutionbox.clear;
  setlength(signs,9);

  for j:= 0 to power(3,9) do
  Begin
    Convertbase(j,3,signs); {get the next arrangement}
    sum:=0;
    nextnum:=1; lastop:=signs[0];
    if lastop<>1 then {don't check leading +, but do check leading -}
    begin
      for i:= 1 to 8 do
      begin
        if (signs[i]=1) or (signs[i]=2) then
        begin
          case lastop of
            1: sum:=sum+nextnum;
            2: sum:=sum-nextnum;
            else sum:=nextnum; {no last op, handles first time}
           end; {case}
           nextnum:=0;
           lastop:=signs[i]; {save the op for later}
        end;
        nextnum:=nextnum*10+i+1; {generate the next digit}
      end;
      {handle final operation}
      case lastop of
         1: sum:=sum+nextnum;
         2: sum:=sum-nextnum;
         else sum:=nextnum;
      end; {case}
      if sum=target then {solution found}
      begin
        s:=''; {make a solution display string}
        For i:= 0 to 8 do
        begin
          case signs[i] of  {add a sign if necessary}
            1, 2: s:= s+ signstr[signs[i]];
          end;
          s:=s+inttostr(i+1); {get a digit}
        end;
        s:=s+' = '+targetedt.text;
        Solutionbox.items.add(s);
      end;
    end;
  end;
end;

procedure TForm1.TargetEdtKeyPress(Sender: TObject; var Key: Char);
{make sure only digits are entered}
begin
  If not (key in ['0'..'9',#8]) then
  begin
    key:=#0;
    beep
  end;
end;

end.
