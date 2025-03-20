unit U_PrimesFromDigits;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  strutils, ShellAPI, ExtCtrls {manually added to access PosEx function};

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Part1Btn: TButton;
    Part2Btn: TButton;
    Memo2: TMemo;
    Memo3: TMemo;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure Part1BtnClick(Sender: TObject);
    procedure Part2BtnClick(Sender: TObject);
    procedure Memo2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    count:integer;
    baseparts:array of string;
    basepartsindex: array of integer; {pointers to base partition}
    parts:array of array of integer;
    //partscounts:array of integer;
    list:TStringlist;
    basepartscount:integer;
    //function Callback:boolean;
    function NextPartitionCallback:boolean;  {receives partitions one per call}
    procedure FindPrimeSets(index:integer; list:TStrings; var maxtoReturn:integer);
  end;

var
 Form1: TForm1;

implementation

{$R *.DFM}

uses mathslib, ucombov2, uintegerpartition2;

procedure TForm1.FormActivate(Sender: TObject);
begin
  list:=TStringlist.create;
  list.sorted:=true;
end;

{*********** Part1BtnClick ************}
procedure TForm1.Part1BtnClick(Sender: TObject);
var
  i,primecount:integer;
  p:int64;
begin
  primecount:=0;
  combos.setup(9,9,permutations);
  with combos  do
  while getnext do
  if selected[9] in [1,3,7,9] then
  begin
    p:=selected[1];
    for i:=2 to 9 do p:=10*p + selected[i];
    if primes.isprime(p) then
    begin
      inc(primecount);
    end;
  end;
  memo2.Clear;
  showmessage(format('There are %d primes containing exactly one occurrence of the digits 1 through 9.'
                  +#13+'No matter how they are arranged, the sum of digits 1 though 9 is 45, a multiple of 3.'
                  +#13+'Any number whose digits sum to a multiple of 3 is divisible by 3. i.e. is not prime',
                  [primecount]));
                  
end;

{************* NextPartitionCallback **********}
function TForm1.NextPartitionCallback:boolean;
var
  i:integer;
  s:string;
begin
  result:=true;
  with defpartition do
  begin
    {Save partition definitions for later use}
    {we'll save all unique permutations of this partition}
    s:='';
    for i:=0 to partsize-1 do s:=s+','+inttostr(p[partsize-1-i]);
    inc(count);
    inc(basepartscount);
    delete(s,1,1);
    baseparts[basepartscount]:=s;
    if count>=length(parts) then
    begin
      setlength(parts,count+100);
      setlength(basepartsindex,count+100);
    end;
    basepartsindex[count]:=basepartscount;
    setlength(parts[count],partsize+1);
    for i:=1 to partsize do parts[count,i]:=p[partsize-i];
    parts[count,0]:=0;
  end;
  setlength(parts,count+1);
end;




{************** Part2BtnClick *************}
procedure TForm1.Part2BtnClick(Sender: TObject);
var
  N:integer;
  i,j,k:integer;
  startat:integer;
  s:string;
  p:integer;
  ok:boolean;
  pp:array[1..9] of integer;
  pcount:integer;
  temp,index:integer;
  basepartscounts:array of integer;
  totpartscount, dupcount:integer;
  starttime:TDatetime;
begin
  memo2.Clear;
  screen.Cursor:=crHourglass;
  n:=defpartition.partitioncount(9,0);
  setlength(parts,n+1);
  setlength(baseparts,n+1);
  setlength(basepartscounts,500);
  setlength(basepartsindex,n+1);
  count:=0;
  dupcount:=0;
  basepartscount:=0;
  totpartscount:=0;
  defpartition.PartitionInit(9,0,NextPartitionCallback);
  {now we have generated and saved all paritions,
   generate permutations of 123456789 and break into
   a set of numbers based on each partition.  then check
   each number in the set for "primeness"}
  list.clear;
  starttime:=now;

  combos.setup(9,9,permutations);
  with combos  do
  while getnext do
  if selected[9] in [1,3,7,9] then
  begin
    for i:=1 to count do
    begin
      ok:=true;
      startat:=1;
      pcount:=0;
      s:='';
      for j:=1 to high(parts[i]) do
      begin {split this permutation into primes based on }
        p:=0;
        for k:=startat to startat+parts[i,j]-1  do
        p:=10*p+selected[k];

        if not primes.isprime(p) then
        begin
          ok:=false;
          break;
        end;
        inc(pcount);
        pp[pcount]:=p;
        startat:=startat+parts[i,j];
      end;
      if OK then
      begin
        {sort this set of primes from smallest to largest value}
        for j:=1 to pcount-1 do
        for k:= j+1 to pcount do
        if pp[j]>pp[k] then
        begin
          temp:=pp[j];
          pp[j]:=pp[k];
          pp[k]:=temp;
        end;
        s:='';
        for j:=1 to pcount do s:=s+','+inttostr(pp[j]);
        delete(s,1,1);
        if not list.find(s,index) then
        begin {some sets may be duplicates, only save the first of those}
          list.add(s);
          (*
          if baseparts[basepartsindex[i]]='1,2,2,2,2'
          then memo2.lines.add(format('Sets of primes with lengths %s: %s',
                 [baseparts[basepartsindex[i]],s]));
          *)
          inc(totpartscount);
          inc(parts[i,0]);  {Keep counts by partition}
        end
        else inc(dupcount);
      end;
    end;
  end;

  temp:=0;
  for i:=1 to count do
  begin
    s:='';
    for j:=1 to high(parts[i]) do s:=s+','+inttostr(parts[i,j]);
    delete(s,1,1);
    memo2.lines.add(format('[%s] has %d prime sets',
                           [s,parts[i,0]{,baseparts[basepartsindex[i]]}]));
    inc(temp, parts[i,0]);
  end;

  (*
  {for debugging - add up the individual partition counts in "temp" to compare with total count}
  temp:=0;
  for i:= 1 to basepartscount do
  begin
    memo2.lines.add(format('For partition  [%s], there are %d prime sets',[baseparts[i],basepartscounts[i]]));
    inc(temp,basepartscounts[i]);
  end;
  *)

  screen.Cursor:=crdefault;
  If totpartscount<>temp
  then showmessage(format('Program error! Detail count(%.0n) <> Total count (%.0n)',
                             [0.0+temp,(now-starttime)*secsperday, 0.0+totpartscount]))
  else

  showmessage(format('%.0n unique prime sets found in %.1f seconds'
                   +#13+'%d duplicate prime sets found',
                   [0.0+totpartscount,(now-starttime)*secsperday, dupcount]));

end;





function LineClicked(Memo:TMemo):integer;
{For a click on a memo line return the line number (number is relative to 0)}
begin
  with memo do result:=Perform(Em_LineFromChar,Selstart,0);
end;


function LinePositionClicked(Memo:TMemo):integer;
{When a TMemo line is clicked, return the character position
 within the line (position is relative to 1)}
var LineIndex:integer;
begin
  with memo do
  begin
     LineIndex:=Perform(Em_LineIndex,Lineclicked(memo),0);
     Result:=Selstart-Lineindex+1;
  end;
end;


{************ FindPrimeSets ***************}
procedure TForm1.FindPrimeSets(index:integer; list:TStrings; var maxtoreturn:Integer);
{Performs the same search as the original Part2 button except does it
 for only the particular partitioning licked by the user}
var
  j,k:integer;
  ok:boolean;
  startat,p,pcount,temp:integer;
  pp:array[1..9] of integer; {primes found for a particular arrangement of digits}
  s:string;
  dummy:integer;
begin
  combos.setup(9,9,permutations);
  with combos  do
  while getnext do
  if selected[9] in [1,3,7,9] then
  begin
    ok:=true;
    startat:=1;
    pcount:=0;
    s:='';
    for j:=1 to high(parts[index]) do
    begin {split this permutation into primes based on }
      p:=0;
      for k:=startat to startat+parts[index,j]-1  do
      p:=10*p+selected[k];

      if not primes.isprime(p) then
      begin
        ok:=false;
        break;
      end;
      inc(pcount);
      pp[pcount]:=p;
      startat:=startat+parts[index,j];
    end;
    if OK then
    begin

      {sort this set of primes from smallest to largest value}
      {makes is easy to delete duplicate prime sets}
      for j:=1 to pcount-1 do
      for k:= j+1 to pcount do
      if pp[j]>pp[k] then
      begin
        temp:=pp[j];
        pp[j]:=pp[k];
        pp[k]:=temp;
      end;

      s:='';
      for j:=1 to pcount do s:=s+','+inttostr(pp[j]);
      delete(s,1,1);
      {some sets may be duplicates, only save the first of those}
      dummy:=list.IndexOf(s);
      if dummy<0 then list.add(s);
      if list.count>=maxtoreturn then break;
    end;
  end;
  maxtoreturn:=list.Count;
end;

{**************** Memo2Click ************}
procedure TForm1.Memo2Click(Sender: TObject);
var
  lineNbr:integer;
  i,n,n2:integer;
  line,partition:string;
  maxtoreturn:integer;
begin
  LineNbr:=lineclicked(Memo2);
  line:=memo2.lines[lineNbr];
  n:=pos('[',line);
  if n>0 then
  begin
    n2:=posex(']',line,n+1);
    partition:=copy(line,N+1, n2-n-1);
    if baseparts[linenbr+1]=partition then
    begin
      memo3.clear;
      maxtoreturn:=100;
      FindPrimeSets(linenbr+1, memo3.lines, maxtoreturn);
    end
    else showmessage(format('Program error: Partition %s not found',[partition]));
  end
  else Showmessage('No partition found on clicked line');
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
