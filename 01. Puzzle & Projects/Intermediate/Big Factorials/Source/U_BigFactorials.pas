unit U_BigFactorials;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Compute and display big factorials by simulating ordinary long multiplication}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Factout: TMemo;
    ComputeBtn: TButton;
    UpDown1: TUpDown;
    procedure ComputeBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure Factorial(a:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Procedure TForm1.Factorial(a:integer);
{I'm sure there are better algorithms - but this one works}
 {The trickiest part is that numbers are held in reverse order,
  ie units digit in the leftmost position, high order digits on the right.
  This lets us always start operating with an index of 1 instead of some
  number that depends on the current size of the numbers involved.
  When we carry, we just to the next number on the right instead of the
  next number on the left.
  At printout time, just pick up digits from left to right and tack then
  onto the beginning of the output string
 }

Var
  m1,m2, result: array of byte;  {dynamic arrays - size changes}
  sizem1, sizem2:integer;
  c, count:Integer;
  v:Char;
  s:string;
  i,j,k, lastPos, shift:integer;
  LeadingZeros:boolean;
Begin
  factout.clear;  {clear the output display}
  {initialize result to 1}
  setlength(result,2);
  result[1]:=1;
  For i := 2 to a do  {factorial=1*2*3*4.... *a}
  begin
    {load previous result into m1, multiplicand #1}
    {while we're at it, find the last non-zero character position
     so we can trim trailing zeros off
     - remember they're really the leading zeros
    }
    setlength(m1,length(result));
    leadingzeros:=true;
    for j:= length(result)-1 downto 1 do
    Begin
      m1[j]:=result[j];
      If m1[j] <> 0 then
      Begin
        if leadingZeros then lastpos:=j;
        leadingzeros:=false;
      end;
    end;

    {Now trim those trailing (leading) 0s }
    setlength(m1,lastpos+1);
    sizem1:=length(m1)-1;

    {multiplicand 2 : convert i to digits in byte array}
    s:=inttostr(i);
    {and reverse it since we're working left to right}
    setlength(m2,length(s)+1);
    sizem2:=length(s);
    for j:=1 to length(s) do m2[length(s)-j+1]:=strtoint(s[j]);

    {initialize the next result}
    {set result length to the biggest it can be - we'll trim it back later}
    setlength(result,sizem2+sizem1+1);
    For j:=1 to length(result)-1 do result[j]:=0;

    {for each digit in m2}
    for j:=1 to sizem2 do
    Begin
      shift:=j-1;  {for each digit , shift result position by 1, just
                   like long multiplication, 1st digit shifted 0, 2nd digit by 1, etc}
      for k:=1 to sizem1 do {for each digit in m1}
      Begin
        c:=m2[j]*m1[k]; {product of 2 current digits- could be a much as 81}
        result[k+shift]:=result[k+shift]+ c mod 10; {add in the units part}
        result[k+shift+1]:=result[k+shift+1]+ c div 10; {add in the tens part}
        {Oops, even adding the units part could have caused a carry}
        If result[k+shift]>=10 then
        Begin
          {if so, just chop it back and add the 10's digit to the next column}
          c:=result[k+shift];
          result[k+shift]:= c mod 10;
          result[k+shift+1]:=result[k+shift+1]+ c div 10;
        end;
     end;
   end;
 end;
 {That's it!}
 {if result[length(result)] =0 then delete(result,length(result),1);}
 {Now to print it out}

 s:='';
 {get rid of that last leading 0}
 if  result[high(result)]=0 then setlength(result,high(result));
 for j :=  1 to high(result)do
 Begin
   s:=inttostr(result[j])+s;
   if (j mod 3 =0) and (j<> length(result)-1 ) then s:=', '+s;
 end;
 If high(result)>10
 then factout.lines.add(Inttostr(a)+'! contains '+inttostr(high(result))+' digits');
 factout.lines.add(s);
 {scroll back to top}
 factout.selstart:=0;
 factout.perform(EM_SCROLLCARET,0,0);
end;

(*
Procedure TForm1.Factorial(a:integer);
{I'm sure there are better algorithms - but this one works}
 {The trickiest part is that numbers are held in reverse order,
  ie units digit in the leftmost position, high order digits on the right.
  This lets us always start operating with an index of 1 instead of some
  number that depends on the current size of the numbers involved.
  When we carry, we just to the next number on the right instead of the
  next number on the left.
  At printout time, just pick up digits from left to right and tack then
  onto the beginning of the output string
 }

Var
  m1,m2, result: array of byte;  {dynamic arrays - size changes}
  sizem1, sizem2:integer;
  c, count:Integer;
  v:Char;
  s:string;
  i,j,k, lastPos, shift:integer;
  LeadingZeros:boolean;
Begin
  factout.clear;  {clear the output display}
  {initialize result to 1}
  setlength(result,2);
  result[1]:=1;
  For i := 2 to a do  {factorial=1*2*3*4.... *a}
  begin
    {load previous result into m1}
    {while we're at it, find the last non-zero character position
     so we can trim trailing zeros off
     - remember they're really the leading zeros
    }
    setlength(m1,length(result));
    leadingzeros:=true;
    for j:= length(result)-1 downto 1 do
    Begin
      m1[j]:=result[j];
      If m1[j] <> 0 then
      Begin
        if leadingZeros then lastpos:=j;
        leadingzeros:=false;
      end;
    end;

    {Now trim trailing 0s (which are really leading 0s)}
    setlength(m1,lastpos+1);
    sizem1:=length(m1)-1;

    {convert i to digits}
    s:=inttostr(i);
    {and reverse it}
    setlength(m2,length(s)+1);
    sizem2:=length(s);
    for j:=1 to length(s) do m2[length(s)-j+1]:=strtoint(s[j]);

    {initialize the next result}
    {set result length to the biggest it can be - we'll trim it back later}
    setlength(result,sizem2+sizem1+1);
    For j:=1 to length(result)-1 do result[j]:=0;

    {for each digit in m2}
    for j:=1 to sizem2 do
    Begin
      shift:=j-1;  {for each digit , shift result position by 1, just
                   like long multiplication, 1st digit shifter 0, 2nd digit by 1, etc}
      {for each digit in m1}
      for k:=1 to sizem1 do
      Begin
        c:=m2[j]*m1[k]; {product of 2 current digits}
        result[k+shift]:=result[k+shift]+ c mod 10; {the units part}
        If k+shift+1>length(result)-1 then setlength(result,k+shift+2);
        result[k+shift+1]:=result[k+shift+1]+ c div 10; {the tens part}
        {Oops, even adding the units part could have caused a carry}
        If result[k+shift]>=10 then
        Begin
          {if so, just chop it back and add carry to next column}
          c:=result[k+shift];
          result[k+shift]:=c mod 10;
          result[k+shift+1]:=result[k+shift+1]+ c div 10;
        end;
     end;
   end;
 end;
 {That's it!}
 {if result[length(result)] =0 then delete(result,length(result),1);}
 {Now to print it out}

 s:='';
 {get rid of that last leading 0}
 if  result[high(result)]=0 then setlength(result,high(result));
 for j :=  1 to high(result)do
 Begin
   s:=inttostr(result[j])+s;
   if (j mod 3 =0) and (j<> length(result)-1 ) then s:=', '+s;
 end;
 If high(result)>10
 then factout.lines.add(Inttostr(a)+'! contains '+inttostr(high(result))+' digits');
 factout.lines.add(s);
 {scroll back to top}
 factout.selstart:=0;
 factout.perform(EM_SCROLLCARET,0,0);
end;
*)

procedure TForm1.ComputeBtnClick(Sender: TObject);
begin
  screen.cursor:=crHourGlass;
  Factorial(UpDown1.position);
  screen.cursor:=crdefault;
end;


procedure TForm1.FormActivate(Sender: TObject);
var
  n:int64;
begin
  {do initial computation}
  ComputeBtnClick(Sender);
end;

end.



