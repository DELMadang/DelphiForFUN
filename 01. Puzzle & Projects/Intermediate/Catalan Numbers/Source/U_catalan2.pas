unit U_catalan2;
 {Copyright  © 2003, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Generate all possible parenthesized expressions for N variables connected by
 binary operators - the number of such expressions is the N-1 term of the series
 of Catalan numbers}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, shellAPI;

type
  TForm1 = class(TForm)
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    GenerateBtn: TButton;
    ListBox2: TListBox;
    Label3: TLabel;
    Memo1: TMemo;
    Catlbl: TLabel;
    CatNbrLbl: TLabel;
    StaticText1: TStaticText;
    procedure GenerateBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    maxvars:integer;
    values:array of integer; {current set of values to use}
    target:integer;
    {We'll look for solutions with 1 to maxvars variables}
    nbrvars:integer; {current nbr of variables being tested}
    templates:array of string; {parenthesized expressions}
    ops:array of array of integer;{array of permutations of operators for this nbrvars}
    variables:array of array of integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** IsLetter ***********}
function isletter(ch:char):boolean;
{return 'true' boolean value if 'ch' is a lower case letter}
begin result:=ch in ['a'..'z']; end;


{************* BinStringToInt **********}
function binstringtoint(s:string):integer;
{Convert a binary string to an integer}
var i:integer;
    v:integer;
begin
  i:=length(s);
  v:=1;
  result:=0;
  for i:=length(s) downto 1 do
  begin
    if s[i]='1' then result:=result+ v;
    v:=2*v;
  end;
end;

{************* MakeBinary **********}
function makeBinaryStr(n:integer):string;
{Convert an integer to a binary string}
var i:integer;
begin
  result:='';
  i:=n;
  while i>0 do
  begin
    if i mod 2=0 then result:='0'+result
    else result:='1'+result;
    i:=i div 2;
  end;
end;

{******************* IsOK *************}
function isOK(n, nbrones:integer):boolean;
{return true if the binary representation of N has
 has "nbrones" 1's and the number of 0's to the left of
 any '0' is less than of '1's to to the left of that '0'}
var
  s:string;
  ones,zeros:integer;
  i:integer;
begin
  s:=makeBinaryStr(n);
  ones:=0;
  zeros:=0;
  result:=false;
  for i:=1 to length(s) do
  begin
    if s[i]='0' then
    begin
      inc(zeros);
      if zeros>ones then exit;
    end
    else inc(ones);
    if ones>nbrones then exit;
  end;
  if ones=nbrones then result:=true;
end;

{***************** AddRightParens ***********}
function AddRightParens(s:string):string;
{Given an expression with only letters and left parens, figure out where
 the right parens belong and return a string with right parens inserted}
var
  i:integer;
  r:string;
  count, lettercount:integer;
  t:string;
begin
  r:=s;
  count:=0;
  lettercount:=0;
  i:=1;
  t:='';
  while i<=length(r) do {examine the input expression character by character}
  begin
    if r[i]='(' then
    begin {found a left paren}
      inc(count);   {count it}
      t:=t+'(';  {add ( to output expression}
      lettercount:=0;
    end
    else if isletter(r[i]) then
    begin  {it's a letter}
      inc(lettercount); {count it}
      if lettercount=1 then t:=t+r[i]{it's the first letter, add it to output}
      else
      begin  {it's the second letter, just add it to the output and add a right )}
        t:=t+r[i]+')';
        dec(count);  {move up one paren level}
        dec(lettercount); {and reduce the reduce letter count}
      end;
    end;
    inc(i,1);
  end;
  while count>0 do
  begin  {now close up all open parens}
    t:=t+')';
    dec(count);
  end;
  result:=t;
end;


{**************AddOps ***********}
 function addops(s:string):string;
 {Add operator codes to an expression}
 {Insert operator between ')('
  or 'x(' where x is any letter,
  or 'xy', where x and y are any letters}
 var j:integer;
 begin
   j:=length(s);
   while j>1 do
   begin
     if (s[j]='(') and ((s[j-1]=')')or isletter(s[j-1]))
      or (isletter(s[j]))
     then
     begin
       insert('*',s,j);
       dec(j);
     end;
     dec(j);
   end;
   result:=s;
 end;

{************** GenerateBtnClick ***********}
procedure TForm1.GenerateBtnClick(Sender: TObject);
{One way to generate Catalan number N is to find all combinations of
 symbols withing a string containing N x's and N y's with the condition
 that there are never more y's than x's to the left of any y.  }

var i,j:integer;
    key:string;
    maxvalstr,minvalstr:string;
    minval, maxval:integer;
    nbrvars,N:integer;
    s:string;
    ch:char;

begin
  {how many digits?}
  nbrvars:=spinedit1.value;
  n:=nbrvars-1;
  key:='';
  listbox1.clear;
  listbox2.clear;
  maxvalstr:='1';
  minvalstr:='10';

  for i:=2 to n do
  begin
    maxvalstr:=maxvalstr+'1'; {111...  N times}
    minvalstr:=minvalstr+'10'; {101010... N times, string length 2N}
  end;
  for i:=1 to n do maxvalstr:=maxvalstr+'0'; {111...000... total length 2N}
  maxval:=Binstringtoint(maxvalstr);
  minval:=BinStringToInt(minvalstr);

  for i:= minval to maxval do
  {test if i value meets the Catalan criteria, all initial substrings contain no more 0's than 1's}
  if isok(i, n) then
  begin
    key:=makeBinaryStr(i);
    listbox1.Items.add(key);
  end;

  CatNbrLbl.caption:=format('Catalan (%d) #',[n]);
  Catlbl.caption:=inttostr(listbox1.items.count);
  {now go through and convert valid catalan values to expressions}
  with listbox1 do
  begin
    for i:= 0 to items.count-1 do
    begin
      ch:='a';
      s:=items[i];
      for j:=1 to length(s) do
      if s[j]='1' then s[j]:='('
      else
      begin
        s[j]:=ch;
        ch:=succ(ch); {set next variable character}
      end;
      s:=s+ch;  {add the last variable}
      items[i]:=items[i]+'  --  '+s;
      s:=AddRightParens(s);  {add right parens}
      listbox2.items.Add(s+' --  '+addops(s)); {add operations}
    end;
  end;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
