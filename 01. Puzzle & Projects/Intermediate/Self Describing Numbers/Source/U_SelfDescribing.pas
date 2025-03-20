unit U_SelfDescribing;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Self-describing numbers:

Integers of a specified length, N,  with the property that,  when digit positions
are labeled 0 to N-1, the digit in each position is equal to the the number of
times that digit appears in the number.

For example, 1210 is a four digit self-describing number because position
"0" has value 1 and there is one 0 in the number; position "1" has value 2 and
there are two 1's, etc.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, shellAPI;

type
  TForm1 = class(TForm)
    SearchBtn: TButton;
    Memo1: TMemo;
    countlbl: TLabel;
    StopBtn: TButton;
    NbrLen: TSpinEdit;
    SearchAllBtn: TButton;
    Label1: TLabel;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure SearchBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SearchAllBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  tag:=0;  {indicates that no search is running}
  {tag 0 ==> stopped}
  {tag 1 ==> running}
  {tag 2 ==> stopping}
end;

{******** IntPower *********}
function intpower(a:int64; b:integer): int64;
{Raises an integer to a power and returns an integer}
var i: integer;
begin
  Result := 1;
  for i := 1 to b do
    Result := Result * a;
end;

{********** SearchBtnClick ***********}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  i,stop:int64;
  j,n:integer;
  s:string;
  d:array [0..9] of integer;
  ok:boolean;
  maxdigit:char;
begin
  if tag=1 {running} then exit;
  tag:=1;
  memo1.lines.add('Self describing of length '+inttostr(NbrLen.value));
  screen.cursor:=crhourglass;
  n:=NbrLen.value; {nbr of digits in numbers to be checked}
  stop:=intpower(10,n)-1; {max value for an N digit number}
  i:=(stop+1) div 10;
  maxdigit:=inttostr(i-1)[1];

  while (i<=stop) and (tag=1) do
  begin
    s:=inttostr(i);
    //s:=stringofchar('0',n-length(s))+s;
    for j:=0 to 9 do d[j]:=0;
    ok:=true;

    {count occurences of each digit}
    for j:= 1 to length(s) do
    if s[j]>maxdigit then
    begin   {digit too large, might as well stop checking}
      ok:=false;
      break;
    end
    else inc(d[ord(s[j])-ord('0')]); {otherswise add digit s[i] to counters}


    if ok then  {check if digit in string character i+1 matches the count in position i}
    for j:=0 to length(s)-1 do
    if (ord(s[j+1])-ord('0'))<>d[j] then
    begin  {no, count did not match position value}
      OK:=false;
      break;
    end;
    if ok then  memo1.lines.add(s); {found one!}

    if i and $FFFFF=0 then {lower 20 bits are 0}
    begin {update progress counter and allow stopping every 1,000,000 numbers or so}
      countlbl.caption:=s;
      application.processmessages;
    end;
    inc(i);  {get next integer to test}
  end;
  countlbl.caption:=s; {show last value checked}
  if (sender<>SearchAllBtn) then tag:=0; {stopped}
  screen.cursor:=crdefault;
end;

{************** SearchAllBtnClick ***********}
procedure TForm1.SearchAllBtnClick(Sender: TObject);
var i:integer;
begin
  memo1.clear;
  for i:=1 to 10 do
  begin
   NbrLen.value:=i;
   searchbtnclick(sender);
   if tag=2 then break;
   tag:=0; {set stopped for next call}
  end;
  tag:=0;
end;

{************* StopbtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  if tag=1 then tag:=2; {if running the set stop flag}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=2; {in case search is running, this will stop it}
  canclose:=true;
end;

end.
