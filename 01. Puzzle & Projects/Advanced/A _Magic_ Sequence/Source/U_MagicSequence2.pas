unit U_MagicSequence2;
{For any n, find sequences of length n with the property that
if the members are defined as x[i], 0<=i<=n-1, and x[i] = count of number of
times that i appears in the sequence, then x[i]=i for all i}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Spin, UIntegerpartition2, UComboV2, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    CalcBtn: TButton;
    TimeLbl: TLabel;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure CalcBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
  public
    start,stop,freq:int64;
    n:integer;
    x:array of byte;
    counts:array of byte;
    used:array of boolean;
    procedure Setup; {Prepare to calculate}
    procedure Report; {report run time}
    function isvalidsequence:boolean;
    Procedure Method0;
    procedure Method1;
    function Handleit2:boolean;
    function Handleit3:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses mathslib;

{*********** Method0 ***********}
procedure TForm1.Method0;
{Code submitted with the original inquiry}
var i,j,k,l,m,n,o,jumi, jumj, jumk, juml,jumm,jumn,jumo : integer;
begin
  setup;
  jumi:=0;
  jumj:=0;
  jumk:=0;
  juml:=0;
  jumm:=0;
  jumn:=0;
  jumo:=0;

  for i:=0 to 6 do
  for j:=0 to 6 do
  for k:=0 to 6 do
  for l:=0 to 6 do
  for m:=0 to 6 do
  for n:=0 to 6 do
  for o:=0 to 6 do
  begin
    case i of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    case j of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    case k of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    case l of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    case m of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    case n of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    case o of
      0 : jumi:=jumi+1;
      1 : jumj:=jumj+1;
      2 : jumk:=jumk+1;
      3 : juml:=juml+1;
      4 : jumm:=jumm+1;
      5 : jumn:=jumn+1;
      6 : jumo:=jumo+1;
    end;
    if  (i+j+k+l+m+n+o =7) and ((i*0)+(j*1)+(k*2)+(l*3)+(m*4)+(n*5)+(o*6)=7) and (jumo = o) and (jumn =n) and (jumm=m) and (jumi=i) and (jumj=j) and (jumk=k) and (juml=l) then
    begin
      memo1.Lines.Add(inttostr(i)+ inttostr(j)+ inttostr(k)+ inttostr(l)+ inttostr(m)+ inttostr(n)+ inttostr(n));
    end;

    jumi:=0;
    jumj:=0;
    jumk:=0;
    juml:=0;
    jumm:=0;
    jumn:=0;
    jumo:=0;
  end;
  report;
end;

{*********** Setup ***********}
procedure TForm1.setup;
{Initialize fields }
var i:integer;
begin
  {initialization stuff}
  n:=spinedit1.value;
  setlength(x,n);
  setlength(counts,n);
  setlength(used,n+1);
  for i:=0 to n-1 do x[i]:=0;
  memo1.lines.clear;
  screen.cursor:=crHourGlass;
  tag:=0;
  calcbtn.caption:='Stop';
  queryperformancecounter(start);
end;

{************ Report ******8}
procedure TForm1.report;
{Stop timing}
begin
  queryperformancecounter(stop);
  Timelbl.caption:=format('Run time %7.4f seconds',[(stop-start)/freq]);
  screen.cursor:=crdefault;
  calcbtn.caption:='Calculate';
end;


{************* IsValidSequence *********}
function TForm1.IsValidsequence:boolean;
{Check a sequence to see if it is "magic"}
  var
    i:integer;
    ok:boolean;
  begin
    ok:=true;
    {count how many of each x[i] value appears in the sequence}
    for i:=0 to high(x) do counts[i]:=0;
    for i:=0 to high(x) do inc(counts[x[i]]);
    {by definition for each position i, counts[i] must = x[i]}
    for i:=0 to high(x) do if x[i]<>counts[i] then
    begin
      ok:=false;
      break;
    end;
    result:=OK
  end;

  {************** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  queryperformancefrequency(freq); {save counter clock frequency}
end;


  {************* CalcBtnClick **********}
procedure TForm1.CalcBtnClick(Sender: TObject);
begin
  if CalcBtn.caption='Stop' then tag:=1
  else
  {call the selected method}
  case radiogroup1.itemindex of
    {Code submiited bt viewer, does length 7 only}
    0: Method0;

    {Method 1 - Generate all possible sequences formed from digits 0 to N-1
     sequences of length N  (like counting in base N)}
    1: Method1;

    {Method 2 - permute integer paritions of N expanded to length N with zeros,
                checking each for valid magin-sequence}
    2:
      begin
        setup;
        {generate all partitions of N calling "Handleit2" for each one}
        Defpartition.Partitioninit(n,0,Handleit2);
        report;
      end;

    {Method 3 - permute integer partitions of N inserted into array of N zeros,
                checking each for valid magin-sequence. Permute (partition length
                 -1) out of N to get insertion positions}
    3:
      begin
        setup;
        {generate all partitions of N calling "Handleit3" for each one}
        Defpartition.Partitioninit(n,0,Handleit3);
        report;
      end;
  end;
end;



{************ Method1 *********}
procedure TForm1.Method1;
  var sum:integer;
      {----------- NextLexRepRPermute ---------}
      function NextLexRepRPermute: boolean;
      {Generate all permutations of integers from 0 to N-1  in array X
       allowing repeats and maintaining the sum of the digits as a
       side affect.  Each element of X and Sum must be initialized to 0
       before the first call.
       Note: this is essentially counting in base N}

      var
        i,k,n: integer;
      begin
        n:=high(x);
        Result := True;
        k      := n {r};
        if X[k] < n then      {try to increase last item in sequence}
        begin
          Inc(X[k]);
          inc(sum);
          exit;
        end;
        while (k>0) and (X[k] = X[k - 1]) do {walk down chain}
        begin
          Dec(k);
        end;
        if k = 0 then              {check for end of sequence}
        begin
          Result := False;
          exit;
        end;
        Inc(x[k - 1]); {increase position by one}
        inc(sum);
        for i := k to n do           {reset all other itmes}
        begin
          dec(sum,x[i]);
          x[i] := 0
        end;
      end;



var
  i, count:integer;
  s:string;
begin
  setup;
  sum:=0;
  count:=0;
  while nextLexReprpermute do
  begin
    sum:=0;
    for i:=0 to N-1 do sum:=sum+i*x[i];
    if (sum=N) and IsValidSequence then
    begin
      s:='';
      for i:=0 to high(x) do s:=s+inttostr(x[i])+',';
      delete(s,length(s),1);
      memo1.lines.add(s);
    end;
    inc(count);
    if (count and $FFFF) = 0
    then  {check once in a while to see if user wants to stop}
    begin
      application.processmessages;
      if tag<>0 then break;
      count:=0;
    end;
  end;
  report;
end;


{*********** HandleIt2 ********}
function TForm1.Handleit2:boolean;
{analyze each integer partion of N and determine which could be the non zero
 elements of a magic sequence - one of the numbers in the partition must equal
 number of zeros which would appear in a parition of this length}
 {This callback for integer partitions of N reduces search time by expanding
 potential sequence elements with zeros to the required length and permuting
 the elements looking for valid magic sequences.

 For example, if N=5 and we are testing partition  [2,2,1], we decide that the
 first position, the number of zeros in the sequence could be 2, so we'll
 build the sequence 2,2,1,0,0 and check all permutations of the last 4 elements
 [2,1,0,0] looking for any that form valid magic seqeunces.
 }
var
  i,j,k,count:integer;
  s:string;
  perm:array of integer;
begin
  with defpartition do
  begin
    for i:=0 to high(used) do used[i]:=false;
    for i:=0 to high(p) do
    if not used[p[i]] then
    begin  {test to see if this integer could be the zero count value}
      used[p[i]]:=true; {no need to test it more than once}
      x[0]:=p[i]; {nbr or zeros}
      if partsize+x[0]=n then {# of zeros + # of non-zero elements must =N}
      begin
        {yup, could be a solution}
        for j:=1 to high(x) do x[j]:=0;
        {permute the rest}
        setlength(perm,n-1);
        k:=0;
        for j:= 0 to high(p) do if j<>i then
        begin
          perm[k]:=p[j];
          inc(k);
        end;
        count:=0;
        for j:=k to high(perm) do perm[j]:=0; {fill out the sequqence with zeros}
        {now permute perm array}
        combos.setup(n-1,n-1,permutations);
        while combos.getnextpermute do
        begin
          for j:=1 to n-1 do x[j]:=perm[combos.selected[j]-1];
          if IsValidSequence then
          begin
            s:='';
            for j:=0 to high(x) do s:=s+inttostr(x[j])+',';
            delete(s,length(s),1);
            if memo1.lines.indexof(s)<0  {check to see if solution already reported}
            then memo1.lines.add(s);
          end;
          inc(count);
          if (count and $FFFF) = 0
          then  {check once in a while to see if user wants to stop}
          begin
            application.processmessages;
            if tag<>0 then break;
            count:=0;
          end;
        end;
      end;
    end;
    result:=(tag=0);
  end;
end;



{*********** HandleIt3 ********}
function TForm1.Handleit3:boolean;
{analyze each integer partion of N and determine which could be the non zero
 elements of a magic sequence}
{This callback for integer partitions of N reduces search time by only permuting
 the elements which do not represent the 0 position and permuting the positions
 where the elements are appear in the sequence,
 For example, if N=5 and we are testing partition  [2,2,1], we decide that the
 first position, the number of zeros in the sequence could be 2, so we'll select
 al permutations for positions of the other 2 elements in the remaining 4
 positions [1,2], [1,3], [1,4], 2,1], [2,3], [2,4], [3,1], etc.
 }
var
  i,j,k,count:integer;
  s:string;
  perm:array of integer;
begin
  with defpartition do
  begin

    for i:=0 to high(used) do used[i]:=false;

    for i:=0 to high(p) do
    if not used[p[i]] then
    begin  {test to see if this integer could be the zero count value}
      used[p[i]]:=true; {no need to test it more than once}
      x[0]:=p[i]; {nbr of zeros}
      if partsize+x[0]=n then {# of zeros + # of non-zero elements must =N}
      begin
        {yup, could be a solution}
        {Place the rect of the values in each position and evaluate the sequence}
        for j:=1 to high(x) do x[j]:=0;
        {permute the rest }
        {put them in array perm first}
        setlength(perm,length(p));
        j:=0;
        for k:=0 to high(p) do if k<>i then
        begin
          inc(j);
          perm[j]:=p[k];
        end;

        combos.setup(partsize-1,n-1,permutations);
        count:=0;
        while combos.getnextpermute do
        with combos do
        begin
          for j:=1 to n-1 do x[j]:=0;

          for j:=1 to partsize-1 do x[selected[j]]:=perm[j];

          if IsValidSequence then
          begin
            s:='';
            for j:=0 to high(x) do s:=s+inttostr(x[j])+',';
            delete(s,length(s),1);
            if memo1.lines.indexof(s)<0  {check to see if solution already reported}
            then memo1.lines.add(s);
          end;
          inc(count);
          if (count and $FFFF) = 0
          then  {check once in a while to see if user wants to stop}
          begin
            application.processmessages;
            if tag<>0 then break;
            count:=0;
          end;
        end;
      end;
    end;
    result:=(tag=0);
  end;
end;


(*
procedure TForm1.Button1Click(Sender: TObject);
 {check by counting by from 0 to N^(N+1)-1 Base N }
 
  procedure converttobaseN(M:integer);
  var i,j,q:integer;
  begin
    q:=n-1;
    j:=M;
    while q>=0 do
    begin
      x[q]:=j mod N;
      j:=j div N;
      dec(q);
    end;
  end;


var
  i,j:integer;
  s:string;
begin
  setup;
  for i:=0 to intpower(N,N+1)-1 do
  begin
    converttoBaseN(i);
    if isvalidsequence then
    begin
      s:='';
      for j:=0 to high(x) do s:=s+inttostr(x[j])+',';
      delete(s,length(s),1);
      if memo1.lines.indexof(s)<0  {check to see if solution already reported}
      then memo1.lines.add(s);
    end;
  end;
  report;
end;
*)


end.
