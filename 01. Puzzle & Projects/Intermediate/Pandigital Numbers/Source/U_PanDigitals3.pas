unit U_PanDigitals3;
{Copyright 2002, 2008, 2010 Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {
  Pandigital numbers contain all of the digits 0 through 9 exactly once.
  "Almost pandigital" numbers contain the digits 1 through 9 exactly once.

  As an  introduction to pandigital numbers,  here's a program that solves

  1. The smallest pandigtal number that is a perfect square.
  2. A number and it's square which together are almost pandigital.

  and a few other sample problems.
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ShellAPI, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo2: TMemo;
    PageControl1: TPageControl;
    Introsheet: TTabSheet;
    Memo1: TMemo;
    Prob1Sheet: TTabSheet;
    Memo3: TMemo;
    Problem1Btn: TButton;
    LeadZeroBox: TCheckBox;
    Prob2Sheet: TTabSheet;
    Memo4: TMemo;
    Problem2Btn: TButton;
    Prob3Sheet: TTabSheet;
    Memo5: TMemo;
    Problen3Btn: TButton;
    TabSheet1: TTabSheet;
    Problem4Btn: TButton;
    Memo6: TMemo;
    TabSheet2: TTabSheet;
    Memo7: TMemo;
    Problem5Btn: TButton;
    TabSheet3: TTabSheet;
    Memo8: TMemo;
    Problem6Btn: TButton;
    procedure Problem1BtnClick(Sender: TObject);
    procedure Problem2BtnClick(Sender: TObject);
    procedure Problen3BtnClick(Sender: TObject);
    procedure Problem4BtnClick(Sender: TObject);
    procedure Problem5BtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Problem6BtnClick(Sender: TObject);
    procedure PageChangesExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    nums:array [0..9] of integer; {the digits of the next pandigital}
    function GetNextPandigital(size:integer; var digits:array of integer) : Boolean;
    function IsPanDigital(size:integer; n:int64):boolean;
    function IsDoublePanDigital(size:integer; n:int64):boolean;
  end;

var   Form1: TForm1;

implementation
{$R *.DFM}

uses math;

  {************** GetNext pandigital}
 function TForm1.GetNextPandigital(size:integer; var digits:array of integer):Boolean;
  {Generates 9 or 10 digit permutations of digits in increasing sequence,
   Input parameter "size" is the number of digits to generate (9 or 10).
   Output placed in open array "digits",  so index value of k refers
   to (k+1)th entry.
   Result is true until all values have been returned.
   Initialize "digits" array with 0,1,2,3,4,5,6,7,8,9 (10 digit pandigitals) or
   1,2,3,4,5,6,7,8,9 (9 digit "almost" pandigitals) before first call.
  }
       procedure swap(i:integer; j:integer);
        {swap digits[i] and digits[j]}
        var temp : integer;
        begin
          temp := digits[i];
          digits[i] := digits[j];
          digits[j] := temp;
        end;


  var k,j,r,s : integer;
  begin
    k := size-2; {start at next-to-last}
    {find the last increasing-order pair}
    while (k>=0) and (digits[k] > digits[k+1]) do dec(k);
    if k<0 then result:=false {if none in increasing order, we're done}
    else
    begin
      j := size-1; {find the rightmost digit less than digits[k]}
      while digits[k] > digits[j] do j:=j-1;
      swap(j,k); {and swap them}
      r:=size-1;
      s:=k+1;  {from there to the end, swap end digits toward the center}
      while r>s do
      begin
        swap(r,s);
        r:=r-1;
        s:=s+1;
      end;
      result:=true;  {magic!}
    end;
  end;


procedure TForm1.Problem1BtnClick(sender:TObject);
{Find smallest pandigital that is a perfect square}
var
  x:int64;
  n:int64;
  s,sx:string;
  count:integer;
  i:integer;
begin
  for i:=0 to 9 do nums[i]:=i; {initialize digits with 0-9}

  {To disallow answers with leading zeros, start with 1023456789
   by swapping 1st two digits}
  If not leadzerobox.checked then
  begin
    nums[0]:=1;
    nums[1]:=0;
  end;

  count:=0;
  memo2.clear;
  repeat {loop on pandigitals in sequence looking for a perfect square}
    n:=0;
    for i:= 0 to 9 do n:=10*n + nums[i];
    x:=trunc(sqrt(n+0.0)); {+0.0 forces converion to extended}
    if x*x=n then
    begin
      s:=inttostr(n);
      sx:=inttostr(trunc(sqrt(n+0.0)));
      if length(s)=9 then s:='0'+s;
      inc(count);
      memo2.Lines.add('Solution '+inttostr(count)+': '+s);
      memo2.lines.add('     ('+sx+' x '+sx+' = '+s+')');
    end;
  until not getnextpandigital(10, nums);
  If count=0 then memo2.lines.add('No solution found');
end;



procedure TForm1.Problem2BtnClick(Sender: TObject);
{Find 2 numbers, one the square of the other which together are 9 digits in
 length and contain all of the digits 1 through 9 exactly once}
var
  n1,n2:int64;
  s1,s2:string;
  count:integer;
  i:integer;
begin
  for i:=0 to 8 do nums[i]:=i+1; {initialize output permutations}
  count:=0;
  memo2.clear;
  repeat {Loop on all "almost" panndigitals, splitting each into two parts] }
    n1:=0;
    n2:=0;
    {3 digit numbers squared will have 5 or 6 digits, we need a total of 9
     4 digit number will be too big, 2 digit numbers will be to small, so
     we must be looking for a three digit number squared}
    for i:= 0 to 2 do n1:=10*n1 + nums[i]; {get 1st 3 digts as a number}
    for i:=3 to 8 do n2:=10*n2+nums[i]; {get last 6 digits as a number}

    if n1*n1=n2 then {if one is the square of the other, we're done}
    begin
      s1:=inttostr(n1);
      s2:=inttostr(n2);
      inc(count);
      memo2.Lines.add('Solution '+inttostr(count)+ ': '+ s1+ 'x' + s1+' = ' +s2);
                      {+ '  ('+s1+'X'+s1+'='+s2+').');}
    end;
  until (not getnextpandigital(9, nums)) ;
  If count=0 then memo2.lines.add('No solution found');
end;

procedure TForm1.Problen3BtnClick(Sender: TObject);
{First i digits divisible by i}
var
  i:integer;
  p:int64;
  solved:boolean;
begin
  memo2.clear;
  for i:=0 to 9 do nums[i]:=i;  {initialize pandigital digits}
  nums[0]:=1; nums[1]:=0; {Skip those starting with 0}
  screen.cursor:=crHourglass;
  repeat
    solved:=true; {assume # is a solution until one non-divisible is found}
    p:=0;
    for i:= 1 to 10 do
    begin
      p:=10*p+nums[i-1]; {get next piece of pandigital}
      If p mod i <>0 then {not divisible by i}
      begin
        solved:=false;
        break;
      end;
    end;
    if solved then
    with memo2 do
    begin
      lines.add(format('Solution %d is %10d',[lines.count+1,p]));
      {itemindex:=items.count-1;}
      update;
    end;
  until not getnextpandigital(10,nums); {get next pandigital}
  screen.cursor:=crdefault;
end;


procedure TForm1.Problem4BtnClick(Sender: TObject);
var
  n1,n2,n3:int64;
  s1,s2,s3:string;
  count:integer;
  i:integer;
  sum:integer;
begin
  for i:=0 to 8 do nums[i]:=i+1; {initialize output permutations}
  count:=0;
  sum:=0;
  memo2.clear;
  repeat {Loop on all "almost" panndigitals, splitting each into 3 parts }
    {1 digit number times a 4 digit number could be a 4 digit number
     2  digits times 3 digits could be 4 digits number
     These two will cover all possible equations
     }
    {Case #1}
    n2:=0;
    n3:=0;
    n1:=nums[0]; {get 1st digit as the first number}
    for i:= 1 to 4 do n2:=10*n2 + nums[i]; {get next 4 digts as a 2nd number}
    for i:= 5 to 8 do n3:=10*n3+nums[i]; {get last 4 digits as a potentail productnum}
    if n1*n2=n3 then
    begin
      s1:=inttostr(n1);
      s2:=inttostr(n2);
      s3:=inttostr(n3);
      inc(count);
      memo2.Lines.add('Solution '+inttostr(count)+ ': '+ s1+ 'x' + s2+' = ' +s3);
                      {+ '  ('+s1+'X'+s1+'='+s2+').');}
      sum:=sum+n3;
    end;
    {Case #2}
    n1:=0;
    n2:=0;
    n3:=0;
    for i:= 0 to 1 do n1:=10*n1 + nums[i]; {get 1st 2 digts as a 1st number}
    for i:= 2 to 4 do n2:=10*n2 + nums[i]; {get next 3 digts as a 2nd number}
    for i:=5 to 8 do n3:=10*n3+nums[i]; {get last 4 digits as product}

    if n1*n2=n3 then
    begin
      s1:=inttostr(n1);
      s2:=inttostr(n2);
      s3:=inttostr(n3);
      inc(count);
      memo2.Lines.add('Solution '+inttostr(count)+ ': '+ s1+ 'x' + s2+' = ' +s3);
                      {+ '  ('+s1+'X'+s1+'='+s2+').');}
      sum:=sum+n3;
    end;
  until (not getnextpandigital(9, nums)) ;
  If count=0 then memo2.lines.add('No solution found') ;
  //else memo2.Lines.Add('Sum of products is '+inttostr(sum));

end;

{********** Problem5BtnClick *************}
procedure TForm1.Problem5BtnClick(Sender: TObject);
var
  i:integer;
  p, n:int64;
  solutioncount:integer;
begin
  memo2.clear;
  for i:=0 to 8 do nums[i]:=i+1;  {initialize pandigital digits}
  screen.cursor:=crHourglass;
  SolutionCount:=0;
  repeat
    p:=0;
    for i:= 0 to 8 do
      p:=10*p+nums[i]; {get next piece of pandigital}
    n:=p*p;
    if isdoublepandigital(9,n) then
    with memo2 do
    begin
      inc(solutioncount);
      lines.add(format('Solution %d is %10d',[SolutionCount,p]));
      lines.add(format('     NxN=%d',[n]));
      update;
    end;
  until not getnextpandigital(9,nums); {get next pandigital}
  screen.cursor:=crdefault;
end;

{************* IsDoublePanDigital ************}
function TForm1.IsDoublePanDigital(size:integer; n:int64):boolean;
var
  s:string;
  count:array['0'..'9'] of integer;
  i:integer;
  ch:char;
  allsmall:boolean;
begin
  s:=inttostr(n);
  result:=false;
  if (size=10)and (length(s)<19) then
  begin  {pad with leading zeros if necessary}
    s:= '0'+s;
    if (length(s)<20) then s:= '0'+s;
  end;

  if (length(s)=2*size) then
  begin
    for ch:='0' to '9' do count[ch]:=0;
    if size=9 then count['0']:=2;
    allsmall:=true;
    for i:=1 to length(s) do
    begin
      inc(count[s[i]]);
      if count[s[i]]>2 then
      begin
        allsmall:=false;
        break;
      end;
    end;
    if allsmall then
    begin
      result:=true;
      for ch:='0' to '9' do
      if count[ch]<>2 then
      begin
        result:=false;
        break;
      end;
    end;
  end;
end;

{************* IsPanDigital ************}
function TForm1.IsPanDigital(size:integer; n:int64):boolean;
var
  s:string;
  count:array['0'..'9'] of integer;
  i:integer;
  ch:char;
begin
  s:=inttostr(n);
  result:=true;
  if (size=10)and (length(s)<10) then
  begin  {pad with leading zeros if necessary}
    s:= '0'+s;
    if (length(s)<10) then s:= '0'+s;
  end;

  if (length(s)=size) then
  begin
    for ch:='0' to '9' do count[ch]:=0;
    if size=9 then count['0']:=1;
    for i:=1 to length(s) do
    begin
      inc(count[s[i]]);
      if count[s[i]]<>1 then
      begin
        result:=false;
        break;
      end;
    end;
  end;
end;

(*
{*************** IsPandigital *******}
function TForm1.ispandigital(const n, Base: int64;
  const includezero, exactlyOnce: boolean): boolean;
{Test to see if N is pandigital in base "Base" number system.
 Includezero true ==> pandigital, false ==> "almost" pandigital
 ExactlyOnce true ==" no repeated digiyd, false ==> repeats OK
}

var
  i:      integer;
  Digits: array of integer;
begin
  SetLength(Digits, Base);
  for i := 0 to Base - 1 do
    Digits[i] := 0;
  Result := True;
  i := n;
  while i > 0 do
  begin
    Inc(Digits[i mod Base]);
    i := i div Base;
  end;
  {sure that all digit from 1 to max digit found occured exactly once and no higher digit occurred a all}
  for i := 0 to Base - 1 do
  begin
    if exactlyonce then
    begin
      if ((i = 0) and includezero and (Digits[i] <> 1)) or
        ((i > 0) and (Digits[i] <> 1)) then
      begin
        Result := False;
        break;
      end;
    end
    else
    begin
      if ((i = 0) and includezero and (Digits[i] = 0)) or ((i > 0) and (Digits[i] = 0))
      then
      begin
        Result := False;
        break;
      end;
    end;
  end;
end;
*)

procedure TForm1.Problem6BtnClick(Sender: TObject);
var
  i,count,pancount,checkedcount:integer;
  x,y,xysq,n:int64;

  procedure solved;
  begin
    if count>1000 then exit;
    inc(count);
    memo2.lines.add(format('Solution %3d) x=%d and y=%d',[count,x,y]));
    memo2.lines.add(format('      x^2+y^2=%d',[x*x+y*y]));
    //memo2.lines.add(format('%3d) x=%d and y=%d, x^2+y^2=%d',[count,x,y,x*x+y*y]));

    application.processmessages;
  end;

begin
  for i:=0 to 8 do nums[i]:=i+1; {initialize output permutations}
  count:=0;
  pancount:=0;
  checkedcount:=0;

  memo2.clear;
  repeat {Loop on all "almost" panndigitals, splitting each into two parts] }
    x:=0;
    y:=0;
    n:=0;
    inc(pancount);
    {Split "nums" into 2 parts and check sum of squares of the parts for being
     almost pandigital. Since the sums of squares must contain 9 digits, at least
     one or both of the squares must be 8 or 9 digits, so the numbers themselves
     must be 4 ot 5 digits.  We'll split each pandigital into two partss and check
     sun of squares of the part for almostr pandigital.}
    for i:= 0 to 3 do x:=10*x + nums[i]; {get 1st 4 digts as a number}
    for i:=4 to 8 do y:=10*y+nums[i]; {get last 5 digits as a number}
    for i:=0 to 8 do n:=10*n+nums[i];
    xysq:=x*x+y*y;
    if (xysq>100000000) and (xysq<1000000000)  then
    begin
      //if ispandigital(x*x+y*y,10,false,true) then solved;
      if ispandigital(9,x*x+y*y) then solved;
      inc(checkedcount);
    end;

    (* {checking the other way (x=5 digits, y=4 digits), is redundant}
    x:=10*x+nums[4];  {make x = 1st 5 digits}
    y:=y mod 10000;   {make y = last 4 digits}
    xysq:=x*x+y*y;
    if (xysq>100000000) and (xysq<1000000000)  then
    begin
      if ispandigital(x*x+y*y,10,false,true) then solved;
      inc(checkedcount);
    end;
    *)
  until (not getnextpandigital(9, nums)) ;
  memo2.lines.add('********************');
  memo2.lines.add(format('%d x,y pairs, %d in range and checked, %d solutions found', [2*pancount, checkedcount,count]));
  If count=0 then memo2.lines.add('No solution found');
end;

{******** PageControl1Exit *******}
procedure TForm1.PageChangesExit(Sender: TObject);
begin
  memo2.Clear;
end;

{********** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin   {make sure that Introduction is the 1st page shown}
  PageControl1.ActivePage:= Introsheet;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.

