unit U_FourFours2;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Define sets of operations which together with the digits 4444 make expressions
 evaluating to all integers from 0 to 100}
{There are noe solutions under those rules for any 4 digits, but here is a
 program which can find solutions for 5 digits as well as other variations}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, UComboV2, UGetParens, uTEvalInt, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Label3: TLabel;
    Memo2: TMemo;
    GroupBox1: TGroupBox;
    Addbox: TCheckBox;
    SubBox: TCheckBox;
    DivBox: TCheckBox;
    Multbox: TCheckBox;
    ExpBox: TCheckBox;
    SolutionsCountBox: TRadioGroup;
    ShowErrors: TCheckBox;
    Label2: TLabel;
    Label4: TLabel;
    CalcBtn: TButton;
    LowTargetEdt: TEdit;
    SourceEdt: TEdit;
    HightargetEdt: TEdit;
    PermuteBox: TCheckBox;
    Memo3: TMemo;
    RangeGrp: TGroupBox;
    FromEdt: TEdit;
    ToEdt: TEdit;
    Label1: TLabel;
    Searchbtn: TButton;
    Label5: TLabel;
    Label6: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SearchbtnClick(Sender: TObject);
  public
    { Public declarations }
    currentexpression:string;
    Eval:TEvalInt; {Class to evaluate integer expressions}
    lowtarget,hightarget:integer;  {target expresion values}
    results: array of integer; {solution counts for targets from "lowtarget"
                                to "hightarget"}
    opstr:array of char; {current set of operations}

    function SumResults:integer; {return number of expressions meeting targets}
    function NZeroResults:integer; {return number of target values with at least
                                      one expression matching it}
  end;

var
  Form1: TForm1;

implementation
Uses math;

{$R *.DFM}


type Tarray=array of integer;

var
 Fullopstr:array[0..5] of char=(' ','+','-','*','/','^'); {for display}


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

{************ FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Eval:=TEvalInt.create;
  Pagecontrol1.ActivePage:=Tabsheet1;
end;

{--------- SumResults -----------}
 function TForm1.SumResults:integer;
 {Count total expressions which whose value was a target value}
 var i:integer;
 begin
   result:=0;
   for i:=low(results) to high(results) do inc(result,results[i]);
 end;

 {--------- NZeroresults -------}
 function TForm1.NZeroResults:integer;
 {Count the number of targets that were the value of at least one expression}
 var i:integer;
 begin
   result:=0;
   for i:=low(results) to high(results) do if results[i]>0 then inc(result);
 end;




{************** TForm1.CalcBtnClick ********}
procedure TForm1.CalcBtnClick(Sender: TObject);
{Solve the problem}
{Given M source digits and N operations, the plan is to generate base N numbers
   containing M-1 digits  from 0 to N^(M-1)-1
 and use the resulting numbers as indicators of the operation
 to perform  for each of the M-1 "slots" between the M digits:
   0=concatenate, 1=+, 2=-, 3=*, 4=/, 5=^ if all operations are selected. }

 {We'll use procedure Getparens to generate templatse for each of the ways the
  N constants can be parenthesized.
  Then move the epressions to parser to evaluate them.
  }
var
  ops:Tarray; {the base n numbers}
  i,j,k,N:integer;

  s, varstr:string;
  stack:array of integer; {"stack" to hold interim results}

  opflag:char;
  list:TStringList;
  skipit:boolean;
  uniquevals:integer;
  base:integer;
  done:boolean;
  nbrvars:integer;

        {--------- Check --------}
        procedure check(s:string);
        {Check expression "s" to see if it meets a target}
        var intval:int64;
        begin
          {make postfix from infix}
          {Use TEvalInt to evaluate}
          eval.lasterror:='';
          eval.evaluate(s,intval ); {s= the epression, intval=then expression value}
          if eval.lasterror<>'' then
            if showerrors.checked then  memo2.lines.add(eval.lasterror)
            else
          else
          begin
            if (intval>=lowtarget) and (intval<=highTarget) then
            begin
              if (results[intval-lowtarget]=0) and (solutionscountbox.itemindex=0) then
              begin
                memo2.Lines.Add(format('%3d = %s',[intval, s]));
                inc(uniquevals);
              end
              else if (solutionscountbox.itemindex=1)
              then memo2.Lines.Add(format('%3d = %s',[intval, s]));
              inc(results[intval-lowtarget]);
            end;
          end;
        end;



begin
  memo2.clear;
  {build the set of oiperations to use}
  s:='';
  if addbox.Checked then s:=s+'+';
  if subbox.Checked then s:=s+'-';
  if multbox.Checked then s:=s+'*';
  if divbox.Checked then s:=s+'/';
  if expbox.Checked then s:=s+'^';
  eval.Setops(s);
  setlength(opstr,length(s)+1);
  opstr[0]:=' ';
  for i:=1 to length(s) do opstr[i]:=s[i];

  {set targets,  results array and other parameters}
  lowtarget:=strtointdef(lowtargetedt.text,0);
  hightarget:=strtointdef(hightargetedt.text,10);
  if hightarget<lowtarget then hightarget:=lowtarget;
  setlength(results,hightarget-lowtarget+1);
  for i:=low(results)to high(results) do results[i]:=0;
  Nbrvars:=length(sourceedt.text);
  setlength(stack,Nbrvars+1);
  setlength(ops,Nbrvars-1);
  screen.cursor:=crhourglass;
  list:=tStringlist.create;
  Opflag:='+';

  uniquevals:=0;
  base:=length(opstr);
  if (permutebox.Checked) then
  begin
    combos.setup(nbrvars,nbrvars,permutations);
    done:=not combos.getnext;  {Get the next permutation of input digits}
  end
  else
  begin
    done:=true;
    varstr:=sourceedt.Text;  {the digits for a single calculation}
  end;

  repeat
    If not done then
    begin
      varstr:='';
      {set up the next set of digits for the extended search mode}
      for i:=1 to Nbrvars do varstr:=varstr+sourceedt.Text[combos.selected[i]];
    end;
    getParens(varstr,Opflag,list); {build list of parenthesized expression templates}
    for j:= 0 to power(base,Nbrvars-1) do {generate all operation multisets}
    begin
      Convertbase(j,base,ops); {get the next arrangement of operators}
      for i:=0 to list.count-1 do
      begin
        s:=list[i];    {get the next expression template}
        currentexpression:=s;
        n:=0;
        skipit:=false;
        for k:=length(s) downto 1 do {fill in the current operation arrangement
                                      into the current parenthesized template}
        begin
          if s[k]=opflag then
          begin
            s[k]:=opstr[ops[n]];
            if (s[k]=' ') {concatenation}
            then
            begin
              if (s[k-1]=')') or  (s[k+1]='(') then
              begin
                skipit:=true;
                break;
              end
              else delete(s,k,1);
            end;
            inc(n);
          end;
        end;
        if not skipit then check(s); {There was no error so go evaluate expression}
      end;
    end;
    if (not done) then done:=not combos.getnext; {get the next permutation of digits}
  until done;

  {report results for current set of digits}
  with memo2,Lines do
  begin
    list.text:=lines.text;
    list.Sort;
    lines.Text:=list.Text;
    list.free;
    if sumResults=0 then add('No solutions found')
    else
    if solutionscountbox.itemindex=0
    then add(format('%d unique values found between %d and %d',
                    [uniquevals, lowtarget,hightarget]))
    else
    begin
      add(format('For digits %s:',[sourceedt.Text]));
      add(format('%d total solutions found',[sumResults]));
      add(format('%d target values have at least one solution',[NZeroResults]));
    end;
  end;
  screen.cursor:=crdefault;
end;






{*********** SearchBtnClick ************8}
procedure TForm1.SearchbtnClick(Sender: TObject);
var num:integer;
    nzero:integer;
    highscore:integer;
    highvalue:string;
    start,stop:integer;
begin
  if Searchbtn.Tag=0 then
  with searchbtn do
  begin
    Tag:=1;
    Caption:='Search';
  end
  else
  begin
    Searchbtn.tag:=0;
    highscore:=0;
    start:=strtointdef(fromedt.Text,1);
    stop:=strtointdef(toedt.text,100);
    Searchbtn.caption:='Stop';
    for num:=start to stop do
    begin
      sourceedt.text:=format('%4d',[num]);
      calcbtnclick(sender);
      application.processmessages;
      nzero:=nzeroresults;
      if nzero>highscore then
      begin
        highscore:=nzero;
        highvalue:=sourceedt.Text;
        label1.Caption:=format('Best so far %d for value %s',[highscore,highvalue]);
      end;

      if  NZero= hightarget-lowtarget+1
      then
      begin
        showmessage('Complete Solution found!');
        break;
      end;
      if searchbtn.tag<>0 then break;
    end;
    with searchbtn do
    begin
      Caption:='Search';
      tag:=1;
    end;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
