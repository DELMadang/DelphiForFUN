unit U_NumWords2;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls;

type

{Record type to hold count of 2 letters and vowels in Testword which may be the
 input text or the number words which may be inserted into the text would make
 the statement true.}
TWordCountRec= record
    LCount:array[1..3] of integer;
    Testword:string;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SolveitBtn: TButton;
    Memo1: TMemo;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    CheckBox2: TCheckBox;
    Edit2: TEdit;
    CheckBox3: TCheckBox;
    Memo2: TMemo;
    Memo3: TMemo;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    CheckitBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure SolveitBtnClick(Sender: TObject);
    procedure CheckitBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    {Array holding count of targets in number words "zero" to "twenty"}
    NumWordrecs:array[0..20] of TWordCountRec;
    Textrec:TWordCountRec;
    procedure Counttargets(var wordrec:TWordCountRec);
    function IsSolution(i,j,k:integer; var s:string):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{Constants for converting numbers to words}
var
  nbrstr:array[1..9] of string=('one','two','three','four','five',
                                 'six', 'seven','eight','nine');

  decadestr:array[2..9] of string=('twenty','thirty','forty','fifty','sixty',
                            'seventy','eighty','ninety');

  {Because we do not say "oneteen", "twoteen", "threeteen", we need to handle
   10 to 19 as a special case}
  teenstr:array[10..19] of string=('ten', 'eleven','twelve','thirteen','fourteen',
                           'fifteen','sixteen','seventeen','eighteen','nineteen');



{********** ConvertTens **********}
 function convertTens(n:integer):string;
 {convert a 1 or 2 digit number to words}
 var
   m:integer;
   s:string;
 begin
    s:='';
    If n=0 then s:='zero'
    else if (n>0) and (n<100) then
    begin
      if n>19 then {"Tens" digit is greater than 1}
      begin
        m:=n div 10; {get the tens digit}
        n:=n mod 10; {retain the units digit}
        s:=s+decadestr[m];
        if n>0 then s:=s+'-'+nbrstr[n];
      end
      else
      begin {number is in the range 0 to 19}
        if n>=10 {10 to 19}
        then s:=s + teenstr[n] {get those nasty "teens" words}
        else if n>0 then s:=s+ nbrstr[n] {otherwise just get the units word}
      end;
    end;
    result:=s; {That's all folks - return the converted string}
  end;

{********* ConvertWords ***********}
function convertwords(inputs:string):integer;
{convert number word for a one or two digit number to the integer form}
var
  i,j,n:integer;
  s:string;
  errcode:integer;
begin
  result:=-1;
  s:=lowercase(trim(inputs));
  val(s,n,errcode);
  if errcode<>0 then
  begin  {it is not a numeric value}
    {is the word 'zero' through 'nine'? }
     if s='zero' then result:=0
     else
     for i:= low(nbrstr) to high(nbrstr) do
     begin
       if s=nbrstr[i] then
       begin
         result:=i;
         break;
       end;
     end;

    {is the word 'ten' through 'nineteen'}
    if result<0 then
    for i:= low(teenstr) to high(teenstr) do
    begin
      if s=teenstr[i] then
      begin
        result:=i;
        break;
      end;
    end;
    {does it start with 'twenty' through 'ninety'?
     and  with nothing or 'one' through 'nine'?}
    if result<0 then
    begin
      for i:= low(decadestr) to high(decadestr) do
      begin
        if copy(s,1,length(decadestr[i])) = decadestr[i] then
        begin
          result:=10*i;
          if length(s)>length(decadestr[i]) then
          begin {must be a suffix word}
            for j:= low(nbrstr) to high(nbrstr) do
            begin
              if copy(s, length(s)-length(nbrstr[j]),length(nbrstr[j]))=nbrstr[j] then
              begin
                result:=result+i;
                break;
              end;
            end;
          end;
          break;
        end;
      end;
    end;
  end
  else result:=n;
end;


{********** CountTargets ************}
procedure TForm1.Counttargets(var wordrec:TWordCountRec);
var
  i:integer;
  ch1,ch2:char;
  ch:char;
begin
  {count target letters/vowels}

  if length(edit1.text)>0 then ch1:=edit1.text[1] else ch1:=' ';
  if length(edit2.text)>0 then ch2:=edit2.text[1] else ch2:=' ';
  with wordrec do
  begin
    for i:= 1 to 3 do Lcount[i]:=0;
    for i:=1 to length(Testword) do
    begin
      ch:=upcase(testword[i]);
      If checkbox1.checked and (ch=ch1) then inc(Lcount[1])
      else If checkbox2.checked and (ch=ch2) then inc(Lcount[2]);
      If checkbox3.checked and (ch in ['A','E','I','O','U'])then inc(Lcount[3]);
    end;
  end;
end;


{************** IsSolution **************}
function TForm1.IsSolution(i,j,k:integer; var s:string):boolean;
var
  OK1,OK2,OK3:boolean;
  sum1,sum2,sum3:integer;
begin
  result:=false;
  if i>=0 then
  begin
    sum1:=(TextRec.lcount[1]);{Accumulate counts of 1st letter for the input text}
    inc(sum1,numWordrecs[i].LCount[1]); {plus 1st letter count}
    {plus 1st letter count in the  2nd letter word, if we are guessing a count for it}
    if j>=0 then inc(sum1,numwordrecs[j].lcount[1]);
    {plus 1st letter count in the vowel count, if vowels count are being guessed}
    if k>=0 then inc(sum1,numwordrecs[k].lcount[1]);

  end
  else sum1:=-1;

  if j>=0 then  {similar tests for 2nd letter count checks}
  begin
    sum2:=(TextRec.lcount[2]);
    inc(sum2,numWordrecs[j].LCount[2]);
    if i>=0 then inc(sum2,numwordrecs[i].lcount[2]);
    if k>=0 then inc(sum2,numwordrecs[k].lcount[2]);
  end
  else sum2:=-1;

  if k>=0 then {similar tests for vowel count tests}
  begin
    sum3:=(TextRec.lcount[3]);
    inc(sum3,numWordrecs[k].LCount[3]);
    if i>=0 then inc(sum3,numwordrecs[i].lcount[3]);
    if j>=0 then inc(sum3,numwordrecs[j].lcount[3]);
  end
  else sum3:=-1;

  {Now set switches to see if a solution has been found}
  if i>=0 then
    if sum1=i then ok1:=true {Count is OK for 1st letter}
    else ok1:=false          {or not OK}
  else ok1:=true; {No check is also OK}
  if   j>=0 then {2nd  letter checks}
    if sum2=j then ok2:=true
    else ok2:=false
  else ok2:=true;
  if   k>=0 then  {Vowel checks}
    if sum3=k then ok3:=true
    else ok3:=false
  else ok3:=true;

  if Ok1 and ok2 and ok3 then result:=true;  {a solution found!}
  {set up the return string}
  s:='';
  if i>=0 then s:=numwordrecs[i].testword+' '+edit1.text+'''s, ';
  if j>=0 then s:=s+numwordrecs[j].testword+' '+edit2.text+'''s, ';
  if k>=0 then s:=s+numwordrecs[k].testword+' '+'vowels';
  if length(s)>0 then s[1]:=upcase(s[1]);
end;


{********* SolveitBtnClick *************8}
procedure TForm1.SolveitBtnClick(Sender: TObject);
var
  i,j,k:integer;

  n1,n2,n3:integer;
  solutionstring:string;

  begin
  {count target letters/vowels}
  Textrec.Testword:=memo1.Text;
  counttargets(Textrec);

  {now count all occurrences of the targets in the number words from 0 to 20}
  for i:=0 to 20 do
  with NumwordRecs[i] do
  begin
    Testword:=convertTens(i);
    countTargets(NumWordRecs[i])
  end;

  memo3.Clear;
  {Now look cases for where the sum of all the occurrences of a target letter or
   vowel count in the input text plus the occurrences in a numword is equal to
   the value of the numword for all of the checkboxed targets}
  for i:= Textrec.lcount[1] to 20 do
  for j:= Textrec.lcount[2] to 20 do
  for k:= Textrec.lcount[3] to 20 do
  begin
    if checkbox1.checked then n1:=i else n1:=-1;
    if checkbox2.checked then n2:=j else n2:=-1;
    if checkbox3.checked then n3:=k else n3:=-1;

    if issolution(n1,n2,n3, solutionstring) then
    begin
      memo3.lines.add('');
      memo3.lines.add(solutionstring);
    end;
  end;
  If memo3.lines.count=0 then memo3.lines.add('No solution');
end;



{*********** CheckItBtnClick ***********}
procedure TForm1.CheckitBtnClick(Sender: TObject);
var
  i:integer;
  n1,n2,n3:integer;
  solutionstring:string;
begin
  {count target letters/vowels}
  Textrec.Testword:=memo1.Text;
  counttargets(Textrec);

  {now count all occurrences of the targets in the number words from 0 to 20}
  for i:=0 to 20 do
  with NumwordRecs[i] do
  begin
    Testword:=convertTens(i);
    countTargets(NumWordRecs[i])
  end;

  memo3.Lines.Clear;
  if checkbox1.Checked then n1:=convertwords(edit3.text) else n1:=-1;
  if checkbox2.Checked then n2:=convertwords(edit4.text) else n2:=-1;
  if checkbox3.Checked then n3:=convertwords(edit5.text) else n3:=-1;
  if isSolution(n1,n2,n3,solutionstring)
  then memo3.lines.Add(solutionstring+ ' is correct!')
  else memo3.lines.add(format('Sorry, %s Is not a solution',[solutionString]));
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;




procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  
end;

end.
