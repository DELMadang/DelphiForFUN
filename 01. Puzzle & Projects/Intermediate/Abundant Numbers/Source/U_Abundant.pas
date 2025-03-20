unit U_Abundant;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
A number, the sum of whose proper divisors is equal to the number itself,  is
called a perfect number.  If the sum is less than the number,  the number is
deficient and if the sum is greater, it is  abundant.

It has been proven that every number greater than 83,160 can be expressed as
the sum of two abundant numbers. This program answers some questions about
the number of abundants and the sums which they can (and can't) form.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Solve: TButton;
    Memo2: TMemo;
    ExamBtn: TButton;
    Solve2: TButton;
    Label1: TLabel;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    SmartSolvebtn: TButton;
    StaticText1: TStaticText;
    Memo6: TMemo;
    SmallestOddBtn: TButton;
    procedure SolveClick(Sender: TObject);
    procedure ExamBtnClick(Sender: TObject);
    procedure Solve2Click(Sender: TObject);
    procedure SmartSolvebtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SmallestOddBtnClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type
  TBoolArray=array of boolean;{make an boolean array type to hold the abundants
                              table passed as a parameter}

  Tnbrtype=(deficient, perfect, abundant); {number types}

{************** CheckType ************}
function checktype(const n:integer):TNbrType;
{Identify integer "n" as deficient, perfect, or abundant}
var  i:integer;
     limit:integer;
     sum:integer;
begin
  {start finding proper divisors of N until weve found them all or
   sum of divisors exceeds N}
   limit:=trunc(sqrt(n)); {check proper factors up to here}
   sum:=1;
   i:=2;
   while (i<=limit) and (sum<=N+limit) do
   begin
     if n mod i = 0 then  sum:=sum+i+n div i;
     inc(i);
   end;
   if limit*limit=N then sum:=sum-limit; {it was a perfect square - we added sqrt

                                         twice, so subtract one}
   if sum<N then result:=deficient
   else if sum>N then result:=abundant
   else result:=perfect;
end;

{*************** MakeAbundants ***********}
procedure makeabundants(var a:TBoolArray; const max:integer);
{Make a table of all abundant numbers up to max}
{Note that the value of each abundant number is also its position in the array}
var
  i:integer;
begin
  setlength(a,max+1); {changing the length of a passed array can only be done
                       for predefined types, i.e. TIntArray }
  for i:= 1 to max do
  if checkType(i)=abundant then a[i]:=true
  else a[i]:=false;
end;

function makefactorsString(i:integer):string;
  var
    j, sum:integer;
    s1,s2:string;
  begin
    {"Just for fun", let's show the factors too}
    s1:='1 + ';
    s2:='';
    sum:=1;
    for j:=2 to trunc(sqrt(i)) do
    begin
      if (i mod j=0) then
      begin
        inc(sum,j);
        s1:=s1+inttostr(j)+' + ';
        if (j <> (i div j)) then
        begin
          inc(sum, i div j);
          s2:=inttostr(i div j)+' + '+s2;
        end;
      end;
    end;
    result :=s1+s2+ ' = '+inttostr(sum);
  end;


{************ ExamBtnClick ************}
procedure TForm1.ExamBtnClick(Sender: TObject);
{check all integers up to 1,000,000 and count as deficient, perfect, or abundant}
var
  a,d,p:integer;
  i:integer;
  perfects:array[1..10] of integer;
begin
  {initialize counters}
  a:=0;
  d:=0;
  p:=0;
  memo2.clear;
  screen.cursor:=crhourglass;
  for i:=0 to 1000000 do
  begin
    case checkType(i) of
      deficient: inc(d);
      perfect:
         begin
          inc(p);
          if p<10 then perfects[p]:=i; {save to display later}

         end;
      abundant: inc(a);
    end;
  end;
  screen.cursor:=crdefault;

  with memo2, lines do
  begin
    add('');
    add('Distribution of 1st 1,000,000 integers');
    add('');
    add(format('Deficient count: %.0n',[0.0+d]));
    add(format('Perfect count: %.0n',[0.0+p]));
    add(format('Abundant count: %.0n',[0.0+a]));
    
    for i:=1 to p do
    begin
      add('');
      add(format('Perfect #%d: %.0n',[i,0.0+perfects[i]]));
      add(format('  (%s)',[makefactorsString(perfects[i])]));
    end;
  end;
end;



{************ SolveClick ************}
procedure TForm1.SolveClick(Sender: TObject);
var
  i,n:integer;
  a:TBoolArray; { Array of integer}
  sumfound:boolean;
  max:integer;
  smallest1, smallest2, smallestsum:integer;
  largestNonsum:integer;
  start:TDatetime;
  secs:extended;
begin
  max:=83160;
  screen.cursor:=crhourglass;
  start:=now;

  makeAbundants(a,83160);

  {now start backward from max looking for a nbr than is not the sum of two
   numbers in table "a"}
  n:=0 ;
  smallestsum:=0;
  smallest1:=0;
  smallest2:=0;
  LargestNonSum:=0;
  repeat
    sumfound:=false;
    {check table of abundants until }
    for i:= 1 to n  div 2 do
    Begin
      {i + (n-i) = n  and both a[i] and a[n-1] are >0 if they are abundant}
      if (a[i]) and (a[n-i]) then {this nbr is the sum of two abundants}
      begin
        sumfound:=true;
        if smallestsum=0 then {save only the first sum that we find}
        begin
          smallest1:=n-i;
          smallest2:=i;
          smallestsum:=n;
        end else break;
      end;
    end;
    if (not sumfound) then
    begin
      largestnonSum:=n;
    end;
    inc(n);
  until n>max;
  secs:=secsperday*(now-start);
  screen.cursor:=crdefault;
  with memo2, lines do
  begin
    clear;
    add(format('Smallest number which is sum of two abundants: %d= %d + %d',
                        [smallestsum, smallest1, smallest2]));
    add('');
    add(format('Largest number not the sum of two abundants is %.0n',
                         [0.0+largestNonsum]));

    add('');
    add(format('Solved in %.2f seconds by search from 1 up to 83,160 looking '
    +'for smallest which is the sum and largest which is not the sum of two abundants',
    [secs]));
  end;
end;


{*************** SmartSolveBtnClick ************}
procedure TForm1.SmartSolvebtnClick(Sender: TObject);
{Faster way, check up from the bottom for the  smallest sum,
 then check down from the top for the first (i.e. largets) non-sum}
var
  i,n:integer;
  a:TBoolArray;
  sumfound:boolean;
  smallest1, smallest2, smallestsum:integer;
  largestNonsum:integer;
  start:TDatetime;
  secs:extended;
begin
  screen.cursor:=crhourglass;
  start:=now;
  makeabundants(a, 83160);
  {now start 1 looking for a nbr than is the sum of two
   numbers in table "a"}
  n:=1 ;
  smallestsum:=0;
  smallest1:=0;
  smallest2:=0;
  largestnonsum:=0;
  repeat
    {check table of abundants until }
    for i:= 1 to n  div 2 do
    Begin {check all possible ways to form N as the sum of two integers}
      {i + (n-i) = n  and both a[i] and a[n-1] are >0 if they are abundant}
      if (a[i]) and (a[n-i]) then {this nbr is the sum of two abundants}
      begin
        if smallestsum=0 then {save only the first sum that we find}
        begin
          smallest1:=n-i;
          smallest2:=i;
          n:=high(a);
          break;
        end;
      end;
    end;
    inc(n);
  until (n>high(a)) ;


  {now start backward from max looking for a nbr than is not the sum of two
   numbers in table "a"}
  n:=high(a);
  repeat
    sumfound:=false;
    {check table of abundants until }
    for i:= 1 to n  div 2 do
    Begin
      {i + (n-i) = n  and both a[i] and a[n-1] are >0 if they are abundant}
      if (a[i]) and (a[n-i]) then {this nbr is the sum of two abundants}
      begin
        sumfound:=true;
        break;
      end;
    end;
    if (not sumfound) then
    begin
      largestnonSum:=n;
      break;
    end;
    dec(n);
  until n=0;

  secs:=secsperday*(now-start);
  screen.cursor:=crdefault;
  with memo2, lines do
  begin
    clear;
    add(format('Smallest number which is sum of two abundants: %d= %d + %d',
                        [smallest1+smallest2, smallest1, smallest2]));
    add('');
    add(format('Largest number not the sum of two abundants is %.0n',
                         [0.0+largestNonsum]));
    add('');
    add(format('Solved in %.2f seconds by search from 1 to first which is the sum of '
      +'2 abundants, then search down from 83,160 to first which is not sum of 2 abundants',[secs]));
  end;
end;


{*************** Solve2 click ***********}
procedure TForm1.Solve2Click(Sender: TObject);
{Find all integers which are not the sum of 2 abundant numbers}
var
  i,n:integer;
  a:TBoolArray;
  sumfound:boolean;
begin
  makeabundants(a,83160);

  {now start checking from 1 to max looking for nbrs which are not the sum of two
   numbers in table "a"}
  n:=1;
  memo2.clear;
  memo2.lines.add('All integers not the sum of two abundants');
  repeat
    sumfound:=false;
    {check all possible ways that n can be formed as the sum of 2 integers}
    for i:= 1 to n  div 2 do
    {i + (n-i) = n  and both a[i] and a[n-1] are >0 if they are abundant}
    if (a[i]) and (a[n-i]) then
    begin
      sumfound:=true;
      break;
    end;
    if not sumfound
    {no sum was found so we have a number which is not the sum of 2 abundants!}
    {add it to the displayed list}
    then  with memo2.lines do add(format('#%d: %.0n',[count, 0.0+n]));
    inc(n);
  until (n>high(a));
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************** SmallestOddbtnClick ***********}
procedure TForm1.SmallestOddBtnClick(Sender: TObject);
{Smallest odd abundant number?}
var
  i:integer;
begin
  memo2.clear;
  for i:= 1 to 83160 do
  if (checkType(i)=abundant) and (i mod 2>0) then
  begin
    memo2.lines.add(inttostr(i) + ' is the smallest odd abundant number');
    memo2.lines.add('   Proper divisors sum: '+makefactorsString(i));
    break;
  end;
end;

end.
