unit U_CountDownPlus;
{Copyright  © 2003-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
CountDown is a British TV program (or
programme)  with an anagram verbal
segment and an "expression search"
mathematical segment. The objective is to
rearrange some or all of six semi-randomly
selected numbers into a parenthisized
arithmetic expression whose value is
closest to a given target value..

This program solves generalized
expression search problems through brute
force searching.  In this version, operators
may be optionally excluded and up to 10
input values are allowed.

The "Use all input values" checkbox omits
solutions that do not use all input values.

The "Filter solutions" checkbox  tries (not
very successfully) to avoid displaying
duplicate solutions.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, ShellAPI;

type
  string64=string[64];
  Tpermute=array[1..9] of integer{shortint};
  TopN=array[1..9] of integer{shortint};

  TTemplate = record {templates are generated as prototypical expressions
                      into which opermutations of operators and operands are inserted}
    e:string64; {infix string for building expresssions for display}
    postfix:array[1..64] of integer{shortint};
    optimize:array[1..5] of integer; {array of indices of leftmost of
                                variable pairs that can be eliminated when
                                second operand is less than the first and
                                they will be added or multiplied  - because
                                procesing in reverse order has already been done
                                and produces the same result}
  end;
  PTTemplate=^TTemplate;

  TForm1 = class(TForm)
    Nbrvarsedt: TSpinEdit;
    Label1: TLabel;
    EvalBtn: TButton;
    GroupBox1: TGroupBox;
    PlusBox: TCheckBox;
    MinusBox: TCheckBox;
    TimesBox: TCheckBox;
    DivideBox: TCheckBox;
    GroupBox2: TGroupBox;
    V1Edt: TSpinEdit;
    V2Edt: TSpinEdit;
    V3Edt: TSpinEdit;
    V4Edt: TSpinEdit;
    V5Edt: TSpinEdit;
    V6Edt: TSpinEdit;
    Label6: TLabel;
    TargetEdt: TSpinEdit;
    Memo1: TMemo;
    MaxToShow: TSpinEdit;
    Label2: TLabel;
    Timelbl: TLabel;
    V7Edt: TSpinEdit;
    V8Edt: TSpinEdit;
    V9Edt: TSpinEdit;
    UseAllBox: TCheckBox;
    StopBtn: TButton;
    Filterbox: TCheckBox;
    Countlbl: TLabel;
    Gen1Btn: TButton;
    Gen2Btn: TButton;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure EvalBtnClick(Sender: TObject);
    procedure NbrvarsedtChange(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Gen1BtnClick(Sender: TObject);
    procedure Gen2BtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    maxvars:integer;
    valedt:array[1..9] of TSpinedit;
    val:array of integer; {current set of values to use}
    target:integer;
    {We'll look for solutions with 1 to maxvars variables}
    nbrvars:integer; {current nbr of variables being tested}
    nbrops:integer; {number of operators to use}
    opstr:string[5]; {allowable operators for current calculation}

    expressioncount:integer;  {number of expressions generated}

    opsN:array of TopN;
    opcount:integer;  {number of sets of operations to test}

    permutes:array of string[9];
    permutesN: array of Tpermute;
    TemplateList:TList;
    duplist:TStringlist; {list of unique solution keys, duplicate solutuons not reported}

    MinDiff:integer;
    w:integer;  {global integer field for debuggung}
    critical:boolean;
    exactsolutions:integer;
    procedure maketemplates(n:integer);
  end;

var   Form1: TForm1;

implementation

{$R *.DFM}

uses math, combo;

const
  opchar='@';
  varchar='#';

var
  nan:integer=1000000;
  opstrings:array[1..4] of char=('+','-','*','/');

{********************************************************}
{Routines down though "makeTemplates" are used to construct
 templates for all possible fully parenthesized expressions
 for each number of variables.  the number of such expresions
 irs related to the Catalan numbers.

 Templates contain a string version of the expression and a
 "postfix" formatted list which tells how to evaluate the
 expression.  In the postfix list, positive numbers represent
 the position in the input expression (and in the current permutation of values)
 of the value to be used  and the negative numbers repesent the positions in
 the expression (and in the current operation array) of the operator to be applied.}
{********************************************************}

{***************** AddRightParens ***********}
function AddRightParens(s:string):string;
{Given an expression with only letters and left parens, figure out where
 the right parens belong and return a string with right parens inserted}
var
  i:integer;
  level:integer;
  t:string;
  termcount:array[0..10] of integer; {# of terms at this level, when =2,
                                        generate a ')' and close out the level}
begin
  level:=0;
  i:=1;
  t:='';
  while i<=length(s) do
  begin
    if s[i]='(' then
    begin
      inc(level);
      t:=t+'(';
      termcount[level]:=0;
    end
    else if s[i]=varchar then
    begin
      t:=t+s[i];
      inc(termcount[level]);
      if termcount[level]=2 then
      while (level>0) and (termcount[level]=2) do
      begin
        t:=t+')';
        dec(level);
        inc(termcount[level]);
      end;
    end;
    inc(i);
  end;
  while level>0 do
  begin
    t:=t+')';
    dec(level);
  end;
  result:=t;
end;

{************ BinString *********}
function binstringtoint(s:string):integer;
var i:integer;
    v:integer;
begin
  v:=1;
  result:=0;
  for i:=length(s) downto 1 do
  begin
    if s[i]='1' then result:=result+ v;
    v:=2*v;
  end;
end;

{*************** MakeBinary ***********}
function makebinary(n:integer):string;
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

{**************** IsOk ***********}
function isOK(n, nbrones:integer):boolean;
{return true if the binary representation of this N has
 has "nbrones" 1's and the number of 0's to the right of
 any 1 is as least as large as the nbr of 1's}
var
  s:string;
  c,z:integer;
  i:integer;
begin
  s:=makebinary(n);
  c:=0;
  z:=0;
  result:=false;
  for i:=length(s) downto 1 do
  begin
    if s[i]='1' then
    begin
      inc(c);
      if c>z then exit;
    end
    else inc(z);
    if c>nbrones then exit;
  end;
  if c=nbrones then result:=true;
end;

{************* Addops **********}
 function addops(s:string):string;
 var j:integer;
 begin
   j:=length(s);
   while j>1 do
   begin
     if (s[j]='(') and ((s[j-1]=')') or (s[j-1]=varchar))
      or (s[j]=varchar)
     then
     begin
       insert(opchar,s,j);
       dec(j);
     end;
     dec(j);
   end;
   result:=s;
 end;

{************** Maketemplates **********}
procedure TForm1.maketemplates(n:integer);

var i,j,k:integer;
    key:string;
    maxvalstr:string;
    s:string;
    minval, maxval:integer;
    T:PTTemplate;
    stackcount:integer;
    pfcount:integer;
    opcount,varcount:integer;
    stack:array[1..64] of integer{shortint};
    opt,optcount:integer;
begin
  if TemplateList.count>0 then
  for i:=0 to TemplateList.count-1 do dispose(PTTemplate(TemplateList[i]));
  TemplateList.clear;
  begin
    key:='';
    maxvalstr:='';
    for i:=1 to n-1 do maxvalstr:=maxvalstr+'1';
    for i:=1 to n-1 do maxvalstr:=maxvalstr+'0';
    maxval:=Binstringtoint(maxvalstr);
    minval:=1;
    for i:=1 to n-1 do minval:=2*minval;
    i:=0;
    if n=1 then minval:=0;
    for k:= minval to maxval do
    if isok(k, n-1) then
    begin
      inc(i);
      s:=makebinary(k);
      for j:=1 to length(s) do
      if s[j]='1' then s[j]:='('
      else  s[j]:=varchar;
      s:=s+varchar;  {add the last variable}
      s:=AddRightParens(s);
      if length(s)>2 then
      {delete extra redundant outside parens}
      begin  {saves a second or two  in a full search}
        delete(s,1,1); delete(s,length(s),1);
      end;
      t:=new(PTTemplate);
      with t^ do
      begin
        e:=addops(s);
        if e='' then e:=varchar;
        stackcount:=0;
        pfcount:=0;
        opcount:=0;
        varcount:=0;
        for j:=1 to length(e)+1 do postfix[j]:=0;
        for j:=low(optimize) to high(optimize) do optimize[j]:=0;
        opt:=0;
        optcount:=0;
        for j:=1 to length(e) do
        case e[j] of
          opchar:
            begin
              inc(opcount);
              inc(stackcount);
              stack[stackcount]:=-opcount;
            end;
          varchar:
            begin
              inc(varcount);
              inc(pfcount);
              postfix[pfcount]:=varcount;
              inc(opt); {increment count of consecutive variables}
            end;
          '(':
            begin
              inc(stackcount);
              stack[stackcount]:=-128;
            end;
          ')':
            begin
              while (stackcount>0) and (stack[stackcount]<>-128) do
              begin
                inc(pfcount);
                postfix[pfcount]:=stack[stackcount];
                If opt>=2 then {last two variables will be operated on directly}
                begin
                  inc(optcount);
                  optimize[optcount]:={postfix[}pfcount-2{]}; {point to "a" of "a b op" term}
                end;
                opt:=0; {reset consecutive variables counter}
                dec(stackcount);
              end;
              if (stackcount>0) and (stack[stackcount]=-128) then dec(stackcount);
            end;
        end; {case}

        while stackcount>0 do {finish flushing stack}
        begin
          inc(pfcount);
          postfix[pfcount]:=stack[stackcount];
          If opt>=2 then {last two variables will be operated on directly}
          begin
            inc(optcount);
            optimize[optcount]:=postfix[pfcount-2];
          end;
          opt:=0; {reset consecutive variables counter}

          dec(stackcount);
        end;
      end; {with t^ do}
      TemplateList.add(t);
    end;
  end;
end;

{***********************************************}
{Routines from here on relate to evaluating expressions.
 Evaluation is a nested loop:
    For each number of variables
       For each expression template
         For each permutation of operators
           For each permutation of input values
                 Evaluate the expression and compare to target
{******************************************************}


{***************** EvalBtnClick ************}
procedure TForm1.EvalBtnClick(Sender: TObject);
  {************ MakeOp ***********}
  function makeop(s:string):TopN;
  {convert ops string from number to symbols}
  var i:integer;
  begin
    {replace '1', '2', '3', '4' with -1,-2,-3,-4}
    for i:=1 to length(s) do result[i]:=(ord(s[i])-ord('0'));
  end; {makeop}


{************* BuildValuePermutations **********}
procedure BuildValuePermutations(N:integer);
{generate all arrangements of variables in advance}

var j,k:integer;
begin
  combos.setup(N,maxvars,permutations);
  setlength(permutesN,combos.getcount+1);
  setlength(permutes,combos.getcount+1);

  {we'll save the variable index values (1-9) in expressions rather than the
  values themselves in order to speed up search.}

  j:=0;
  while combos.getnextpermute do
  with combos do
  begin
    inc(j);
    permutes[j]:='';
    for k:=1 to N do
    begin
      permutesN[j,k]:=val[selected[k]];
      {we'll also keep strings of permutation numbers to simplify identifying
      duplicate solutions later on}
      permutes[j]:=permutes[j]+char(ord('0')+selected[k]);
    end;
  end;
end;

{************* BuildOps ***********}
procedure BuildOps(i:integer);
{make an array of all arrangeemnts of operations}

     {************ MakeNextOp **********}
      function MakeNextOp(s:string):string;
      {generate next arrangement of operation to plug in to templates}
      var i,n:integer;
      begin {MakeNextOp}
        result:=s;
        for i:=length(s) downto 1 do
        begin
          n:=strtoint(s[i]);
          if n<nbrops then
          begin
            inc(n);
            result[i]:=inttostr(n)[1];
            exit;
          end
          else result[i]:='1';
        end;
      end; {MakeNextOp}

  var
    j,k:integer;
    ch:char;
    s, smax:string;
  begin {buildops}
    {build array of all possible operator strings}
    {we'll do this in advance to save time while generating expressiosn}
    s:='';
    opcount:=0;
       if i>1 then setlength(opsN,trunc(intpower(nbrops,i))+1)
    else setlength(opsN,nbrops+1);
    ch:=inttostr(nbrops)[1];
    smax:='';
    for j:=1 to i-1 do
    begin
      s:=s+'1';
      smax:=smax+ch;
    end;
    while s<smax do
    begin
      inc(opcount);
      {fill OpsN with numeric versions of operator codes}
      for k:=1 to length(s) do opsn[opcount,k]:=(ord(s[k])-ord('0'));
      s:=makenextop(s);
    end;
  end; {buildops}

{*********************************************}
{******************* Eval ********************}
{*********************************************}
function eval (const t:PTTemplate; const curops:TopN;const p:TPermute):integer;
{evaluate an expressions string in postfix format}
var
  count:integer;
  i:integer;
  n:int64;
  invalid:boolean;
  stack:array[1..64] of int64;

procedure push(n:int64);
begin
  inc(count);
  stack[count]:=n;
end;

function pop:int64;
begin
  result:=stack[count];
  dec(count);
end;

begin
  count:=0;
  invalid:=false;
  i:=1;
  with t^ do
  while postfix[i]<>0 do
  begin
    n:=t^.postfix[i];
    if n>0 then  push(p[n])
    else
    begin
      n:=curops[-n];
      {b:=pop;}
      {a:=pop;}{no need to pop and repush operands, and slightly faster not to}
      case opstr[n] of
        '+': stack[count-1]:=stack[count-1]+stack[count];
        '-': stack[count-1]:=stack[count-1]-stack[count]{b};
        '*': if (not useallbox.checked and ((stack[count]{b}=1) or (stack[count-1]=1)))
             then invalid:=true
             else stack[count-1]:=stack[count-1]*stack[count]{b};
        '/':
          begin
            if (stack[count]{b}=0) or ((stack[count]{b}=1) and (not useallbox.checked))
            then invalid:=true
            else
            begin

              n:=stack[count-1]div stack[count]{b};
              if n*stack[count]{b}=stack[count-1] then stack[count-1]:=n
              else invalid:=true;
              (*   {alternative method, no time difference}
              if STACK[COUNT-1] MOD STACK[COUNT] =0
              THEN STACK[COUNT-1]:=stack[count-1]div stack[count]
              ELSE INVALID:=TRUE;
              *)
            end;
          end;
      end;
      dec(count);
      (*
      {eliminating 0 terms doesn't seem to save any time}
      if stack[count]=0
      then invalid:=true;
      *)
    end;
    if invalid then break;
    inc(i);
  end;
  if (not invalid) and (stack[1]>high(integer)) then invalid:=true;
  if not invalid then  result:=stack[1] else result:=nan;
end;

  {*************** UniqueSolution *********}
  function uniquesolution(s:string64):boolean;
  {return true if  solution s is unique}
  {doesn't work well if there are duplicate values, in this case
  say with two "X"s, a +X for the first X and *X for the second X
  will have a different key than the expression that has *X for the first X and
  +X for the second X m even though these will look identical to  humans}
  {We could solve this by generating two keys for each duplicate value}
  var
    i,j,n, index:integer;
    key:string[9];
  begin
    {create a key of operators associated with each value}
    key:='         ';
    result:=false;
    for i:=1 to length(s) do
    begin
      if s[i] in ['1'..'9'] then
      begin
        n:=ord(s[i])-ord('0');
        j:=i-1;
        if (j>=1) and (s[j] in ['+','-','*','/']) then key[n]:=s[j]
        else
        begin
          j:=i+1;
          if (j<=length(s)) and (s[j] in ['+','-','*','/']) then key[n]:=s[j]
        end;
      end;
    end;
    if not duplist.find(key,index) then
    begin  {it is unique, sadd it to the duplist and set result}
      duplist.add(key);
      result:=true;
    end;
  end;

 {***********AddValues ************}
 procedure addvalues(t:PTTemplate ; curops:TopN);
 {Run through permutations of input values to plug into templates}
 var
        i,j,k,n:integer;
        s:string64;
        varcount,opcount:integer;
        OK:boolean;
        temp:array[1..30] of integer;
    begin {addvalues}
      with t^ do
      for i:= 1 to high(permutesN) do
      begin
        {See if we need to process this exprression}
        j:=1;
        ok:=true;

        while OK and (optimize[j]<>0) do
        begin
          w:=optimize[j]+2; {pointer to the operator in postfix}
          If (permutesn[i,postfix[w-2]]>permutesn[i,postfix[w-1]]) {operands out of sequence?}
           and ((curops[-postfix[w]]=1) or (curops[-postfix[w]]=3)) {is it '+' or '*'?}
          then OK:=false

          {we can also skip divide a/b operations where b doesn't divide a evenly}
          else if (curops[-postfix[w]]=4)
            and (permutesN[i,postfix[w-2]] mod permutesN[i,postfix[w-1]] <>0)
            then OK:=false

          else inc(j);
        end;
        
        If OK then
        begin
          inc(expressioncount);
          {**********************************}
          {evaluate expression "t", with operation set "curops" and value
           permutation set "permutesN[i]"}
          n:=eval (t,curops,permutesN[i]);
          
          {**********************************}
          j:=abs(n-target);
          if (j < mindiff) or (j=0) then
          begin
            s:=t^.e;
            if (j=0) and (mindiff>0) then memo2.clear; {first exact solution}
            mindiff:=j;
            {build displayable expression, also used in unique solution check}
            varcount:=0;
            opcount:=0;
            for j:= 1 to length(s) do
            begin
              if s[j]=opchar then
              begin
                inc(opcount);
                s[j]:=opstr[curops[opcount]];
              end
              else if s[j]=varchar then
              begin
                inc(varcount);
                s[j]:=permutes[i,varcount];
              end;
            end;
            j:=1;
            while t^.postfix[j]<>0 do
            with t^ do
            begin
              temp[j]:=postfix[j];
              if temp[j]>0 then temp[j]:={val[} permutesN[i,temp[j]] {]}
              else temp[j]:= -curops[-temp[j]];
              inc(j);
            end;
            temp[j]:=0;
            {which solutions to display}
            if (mindiff>0) or ( (mindiff=0) and
              ((not filterbox.checked) or (filterbox.checked and uniquesolution(s)))) then
            begin
              {replace value index value with actual value for display purposes}
              for j:=length(s) downto 1 do if s[j] in['1'..'9'] then
              begin
                k:=ord(s[j])-ord('0');
                delete(s,j,1);
                insert(inttostr(val[k]),s,j);
              end;
              if mindiff=0 then
              begin
                inc(exactsolutions);
                if exactsolutions<=maxtoshow.value then
                begin
                  memo2.lines.add(s +' = ' + inttostr(n));
                end
                else
                begin  {not displaying any more, might as well stop}
                  tag:=1;
                  break;
                end;
              end
              else
              begin
                memo2.lines[0]:='Closest:';
                memo2.lines[1]:='   '+ s +' = ' + inttostr(n);
              end;
            end;
          end;
        end;
      end;
  end; {addvalues}

var
  i,j,k:integer;
  t:PTTemplate;
  starttime:TTime;
  start:integer;
  dummyops:TopN;

begin   {Evalbtnclick}
  dummyops[1]:=0;
  memo2.clear;
  memo2.lines.add('');
  memo2.lines.add('');
  duplist.clear;
  starttime:=time;
  target:=targetedt.value;
  maxvars:=nbrvarsedt.value;
  setlength(val,maxvars+1);
  screen.cursor:=crHourGlass;
  for i:=1 to maxvars do val[i]:=valedt[i].value;
  opstr:='';
  if plusbox.checked then opstr:=opstr+'+';
  if minusbox.checked then opstr:=opstr+'-';
  if timesbox.checked then opstr:=opstr+'*';
  if dividebox.checked then opstr:=opstr+'/';
  if length(opstr)=0 then
  begin
    showmessage('No operations selected');
    exit;
  end;
  critical:=false;
  nbrops:=length(opstr);
  mindiff:=1000000;
  exactsolutions:=0;
  tag:=0;
  countlbl.caption:='';
  timelbl.caption:='';

  stopbtn.visible:=true;
  if useAllBox.checked then start:=maxvars else start:=1;

  {for all nbrs of variables in expression, fewest to most}
  for i:= start to maxvars do
  begin
    maketemplates(i); {generate expression templates for i variables}
    BuildValuePermutations(i); {build array of permuations of input values}
    BuildOps(i);  {build combinations of operations}
    expressioncount:=0;

    {********************************************************************}
    {********************************************************************}
    {***** THE CRITICAL PROCESSING LOOP STARTS HERE **********************}
    {********************************************************************}
    {********************************************************************}

    for j:=0 to (TemplateList.count-1)  do
    begin
      t:=PTTemplate(TemplateList[j]);
      if opcount>0 then
      begin
        for k:=1 to opcount do
        begin
          addvalues(t,opsN[k]); {go evaluate for each permutation of values}
          application.processmessages;
          if tag<>0 then break;
        end;
      end     {operator permutations loop}
      else  {handle the one value case}
      begin
        t:=PTTemplate(TemplateList[j]);
        addvalues(t,dummyops);
      end;
      if tag<>0 then break;
    end;  {templates loop}
    if tag<>0 then break;
  end;  {nbrvars loop}

  if (mindiff=0)  then
  begin
    countlbl.caption:=inttostr(memo2.lines.count)+ ' solutions displayed';
    if (memo2.lines.count>5) then memo2.lines.add(countlbl.caption);
  end;

  screen.cursor:=crdefault;
  stopbtn.visible:=false;
  timelbl.caption:= format('%6.1f seconds,  %9.0n expressions',
                        [(time-starttime)*secsperday, expressioncount+0.0]);
end;


{**************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization stuff}
begin
  timesbox.caption:=#215;
  dividebox.caption:=#247;
  timelbl.caption:='';
  countlbl.caption:='';
  {put value edits in an array}
  valedt[1]:=v1edt; valedt[2]:=v2edt; valedt[3]:=v3edt;
  valedt[4]:=v4edt; valedt[5]:=v5edt; valedt[6]:=v6edt;
  valedt[7]:=v7edt; valedt[8]:=v8edt; valedt[9]:=v9edt;
  TemplateList:=tlist.create;
  duplist:=TStringlist.create;
  duplist.sorted:=true;
  nbrvarsedtchange(sender);
  stopbtn.top:=evalbtn.top;
  stopbtn.left:=evalbtn.left;
  randomize;
end;

{***************** NbrVarsEdtClick ***********}
procedure TForm1.NbrvarsedtChange(Sender: TObject);
var i:integer;
begin
  for i:=1 to 9 do
  begin
    if i<=nbrvarsedt.value then valedt[i].visible:=true
    else valedt[i].visible:=false;
    valedt[i].value:=i;
  end;
end;

{******************** StopBtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin tag:=1; end; {set stop flag}

{***************** FormCloseQuery ***************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1;{set stop flag in case we're running}
  canclose:=true;
end;

{****************** Gen1BtnClick ***********}
procedure TForm1.Gen1BtnClick(Sender: TObject);
var i:integer;
    n:integer;
begin
  n:=1;
  for i:=1 to nbrvarsedt.value do
  begin
    valedt[i].value:=10+random(90);
    //n:=n*valedt[i].value;
  end;
  targetedt.value:=10+random(nbrvarsedt.value*90);
end;

{***************** Gen2BtnClick **********}
procedure TForm1.Gen2BtnClick(Sender: TObject);
var
  cards:array[1..24] of integer;
  i,n,max:integer;
begin
  for i:=1 to 20 do cards[i]:=(i+1) div 2;
  for i:=21 to 24 do cards[i]:= 25*(i-20);
  nbrvarsedt.value:=6;
  {select 6 cards randomly}
  max:=24;
  for i:=1 to 6 do
  begin
    n:=random(max)+1;
    valedt[i].value:=cards[n];
    cards[n]:=cards[max];
    dec(max);
  end;
  targetedt.value:=random(900)+100;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.



