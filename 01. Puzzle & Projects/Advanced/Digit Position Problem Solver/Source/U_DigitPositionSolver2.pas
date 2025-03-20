unit U_DigitPositionSolver2;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A program that interprets a class of digit-relations story problems and
 tries to generate the equations which will solve the problem.  Current examples
 involve 5 and 6 digit numbers, and solve by brute force substition of all
  possible 5 or 6 digit numbers into the equations.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellapi, UTEVal, inifiles, ExtCtrls;

type
  TSentenceRec = record
    origsentence:string;{the sentence as entered}
    sentence:string; {the sentence as it gets modified while building equations}
    SList:TStringlist; {the separate words of the sentence in a stringlist}
    comment:boolean;
  end;

type
  TForm1 = class(TForm)
    OpenBtn: TButton;
    Solvebtn: TButton;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    ProblemSheet: TTabSheet;
    ParseSheet: TTabSheet;
    SentenceDisplayMemo: TMemo;
    NameDisplay: TMemo;
    Label1: TLabel;
    problem: TMemo;
    StaticText1: TStaticText;
    ProblemLbl: TLabel;
    Memo1: TMemo;
    LoadIniBtn: TButton;
    Label2: TLabel;
    OpenDialog2: TOpenDialog;
    BacktestBtn: TButton;
    Stopfirst: TCheckBox;
    procedure OpenBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SolvebtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure LoadIniBtnClick(Sender: TObject);
    procedure BacktestBtnClick(Sender: TObject);
  public
    Sentences:Array of TSentenceRec;
    NameList:TStringList;
    FirstWordslist:TStringlist;
    UnNeededWordsList:TStringList;
    CapitalizedList:TStringlist;
    NumbersList:TStringList;
    DigitIdList:TStringlist;
    DenomList:TStringlist;
    OpWordsList:TStringList;
    problemstr:string;
    Loaded:boolean;  {flag indicating that tables have been loaded}
    filename:string;
    tablesname:string;
    numsize:integer;

    RunSilent:boolean; {true=do not display problem details; used for back testing}
    procedure loadfile(f:string);
    procedure setupProblem; {reset fields of currently loaded problem}
    procedure Preprocess(n:integer); {remove unneeded words, etc}
    function FindNames(n:integer):boolean; {Identify people's names and build namelist}
    procedure convertnumbers(n:integer); {convert number words to numbers}
    procedure convertops(num:integer); {table driven conversion to insert operators}
    procedure showsentence(n:integer; msg:String; showdelim:boolean); {display a sentence}
    procedure shownames; {display people names}
    function evaluate:boolean;  {returns true if solution found}
    function loadtables(filename:string):boolean;
    procedure ResultDisplay(const s:string);
    function solvecase:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses mathslib;

type
  charset=set of char;

var
  delims:set of char=[' ', '.', ',', ';', '!','?'];
  eosdelims:set of char=[',','.', ';', '!','?'];  {these represent end of sentence}
  {digitnames in sequential order}
  digitnames:array[1..6] of string {=('AA','BB','CC','DD','EE','FF')};

 {*********** Getword ********}
   function getword(var s:string; const delims:charset; var delim:char):string;
   {return the first word in string "s" and delete it
    from the string.  Also return the delimiter found}
   var  i:integer;
   begin
     s:=s+' ';
     while (length(s)>0) and (s[1]in delims {=' '})  do delete(s,1,1);
     if length(s)>0 then
     begin
       i:=1;
       while (not (s[i] in delims)) do inc(i);
       result:=copy(s,1,i-1);
       delim:=s[i];
       delete(s,1,i);
     end
     else result:='';
   end;

{*********** Nextword ********}
   function Nextword(s:string; const delims:charset; var delim:char):string;
   {return the first word in string "s" without deleting it
    from the string.  Also return the delimiter found}
   var  i:integer;
   begin
     s:=s+' ';
     while (length(s)>0) and (s[1]in delims {=' '})  do delete(s,1,1);
     if length(s)>0 then
     begin
       i:=1;
       while (not (s[i] in delims)) do inc(i);
       result:=copy(s,1,i-1);
       delim:=s[i];
     end
     else result:='';
   end;

{************ FormCreate ********}
procedure TForm1.FormCreate(Sender: TObject);
var
  filename:string;

begin
  setlength(sentences,0);

  {Create table lists}
  namelist:=TStringList.create;
  namelist.duplicates:=dupIgnore;
  namelist.sorted:=true;
  firstWordsList:=Tstringlist.create;
  UnneededWordsList:=Tstringlist.create;

  CapitalizedList:=Tstringlist.create;
  NumbersList:=TStringList.create;
  DigitIdList:=TStringList.create;
  OpWordslist:=TStringlist.create;
  DenomList:=TStringlist.create;

  filename:=extractfilepath(application.exename)+'DigitProblemTables.ini';
  opendialog1.initialdir:=extractfilepath(application.exename);
  opendialog2.initialdir:=opendialog1.initialdir;

  Loaded:=LoadTables(filename);

  if fileexists(opendialog1.initialdir+'\Problem00.txt') then
  begin
    loadfile(opendialog1.initialdir+'\Problem00.txt');
  end;
end;


{*********** Loadtables **************}
function TForm1.loadTables(filename:string):boolean;
var
  ini:TInifile;
  i:integer;
begin
  if fileexists(filename) then
  begin
    result:=true;
    ini:=TInifile.create(filename);
    Tablesname:=extractfilename(filename);

    {Common capitalized first words to help identify names}
    if ini.sectionexists('FirstWords') then
    begin
      ini.readsection('FirstWords', FirstwordsList);
      Firstwordslist.sort;
    end;

    if ini.sectionexists('Unneeded') then
    begin
      ini.readsection('UnNeeded', UnNeededwordsList);
    end;

    if ini.sectionexists('Capitalize') then
    begin
      ini.readsection('Capitalize', CapitalizedList);
      Capitalizedlist.sort;
    end;

   if ini.sectionexists('Numbers') then
   begin
     {Number words}
     ini.readsectionvalues('Numbers', Numberslist);
     Numberslist.sort;
   end;

   if ini.sectionexists('DigitNames') then
   begin
     {Digit names ("third", "fourth", etc.)}
     ini.readsectionvalues('Digitnames', DigitIdList);
     DigitIdList.sort;
     {make a table of name values (First="AA", etc.}
     with digitidlist do
     for i:=0 to count-1 do
     begin
       if names[i] = 'first' then digitnames[1]:=values[names[i]]
       else if names[i] = 'second' then digitnames[2]:=values[names[i]]
       else if names[i] = 'third' then digitnames[3]:=values[names[i]]
       else if names[i] = 'fourth' then digitnames[4]:=values[names[i]]
       else if names[i] = 'fifth' then  digitnames[5]:=values[names[i]]
       else if names[i] = 'sixth'then  digitnames[6]:=values[names[i]];
     end;

   end;

   if ini.sectionexists('Denominators') then
   begin
    {Denominator words ("thirds", "fourths", etc.)}
    ini.readsectionvalues('Denominators', DenomList);
    Denomlist.sort;
   end;

   if ini.sectionexists('OpWords') then
   begin
    {Patterns which can be used to produce equations}

    ini.readsectionvalues('OpWords', OpWordsList);
    {the order of entries in this list is important so list is not sorted}
    end;
  end
  else
  begin
    showmessage('Missing tables file '+ filename);
    result:=false;
  end;
end;

{var debug_s:string;} {make a global variable so value is available for
                       debugging even though it it never referenced}



{************** FindNames ***********}
function TForm1.FindNames(n:integer):boolean;
{Build and/or check the list of names found}

  function InFirstWordList(s:string):boolean;
  var index:integer;
  begin
    result:=FirstWordsList.find(s,index);
  end;

var
  j:integer;
  index:integer;
begin
  result:=false;
  with sentences[n], slist do
  if count>0 then
  begin
    if namelist.find(slist[0],index) then result:=true;
    if (not infirstwordlist(slist[0])) and (slist[0]<>'last')
    then result:=result or (namelist.add(digitIdlist.values[slist[0]])>=0);
    for j:=0 to count-1 do
    begin
      if namelist.find(slist[j],index) then result:=true;
      //debug_s:=strings[j];
      if (J>0)
      and (capitalizedlist.find(strings[j],index))
      then result:=(namelist.add(capitalizedlist[j])>=0) or result;
    end;
  end;
end;


{*********** OpenBtnClick ***********}
procedure TForm1.OpenBtnClick(Sender: TObject);
{Load a problem}
begin
  runsilent:=false;
  If opendialog1.execute then loadfile(opendialog1.filename);
end;

{************* Loadfile ************}
procedure TForm1.loadfile(f:string);
begin
  filename:=extractfilename(f);
  pagecontrol1.activepage:=problemsheet;
  problem.visible:=not runsilent;
  problem.lines.loadfromfile(f);
  setupproblem;
  pagecontrol1.activepage:=problemsheet;
  problemlbl.caption:='Current problem: '+ extractfilename(f);
end;

{********* SetupProblem *********}
procedure TForm1.setupProblem;
var
  i:integer;
  s,w:string;
  newsentence:boolean;
  delim:char;
begin
    problemstr:='';
    for i:=0 to problem.lines.count-1 do problemstr:=problemstr+' '+problem.lines[i];
    if high(sentences)>0 then
    begin
      for i:= 0 to high(sentences) do sentences[i].slist.free;
      setlength(sentences,0);
    end;
    {now process problemstr and build the sentences array}
    s:=problemstr;
    newsentence:=true;
    //comment:=false;
    repeat
      w:=getword(s,delims+['-'],delim);
      if w<>'' then
      begin
        if newsentence then
        begin
          setlength(sentences, length(sentences)+1);
          with sentences[high(sentences)] do
          begin
            origsentence:='';
            sentence:='';
            slist:=TStringlist.create;
            if (length(w)>=2) and (copy(w,1,2)='//')
            then comment:=true
            else comment:=false;
          end;
          newsentence:=false;
        end;
        i:=high(sentences);
        with sentences[i] do
        begin
          if not comment then slist.add(w);
          origsentence:=origsentence+w+delim;
          sentence:=sentence+w+' ';
        end;
        if delim in eosdelims  then
        begin
          newsentence:=true;
        end;
      end;
    until s='';
    namelist.clear;
  end;


{************** Preprocess **********}
procedure TForm1.Preprocess(n:integer);
{Replace unneeded delimiters and words, expand contractions, etc.}

var
  i, len, j:integer;
  s,w:string;
  delim:char;
  finaldelim:char;
  msg:string;

  function lastTwo(const s:string):string;
  {return last 2 characters of a string}
  begin
    if length(s)>2 then result:=copy(s,length(s)-1,2)
    else result:='';
  end;


begin
  with sentences[n] do
  begin
    s:=sentence;
    {remove final delimiter}
    if s[length(s)] in delims then
    begin
      finaldelim:=s[length(s)];
      delete(s,length(s),1);
    end
    else finaldelim:=' ';
    msg:='Find a six digit number ';
    j:=pos(msg,s);
    if j>0 then
    begin
      NumSize:=6;
      delete(s,j,length(msg));
      For i:=1 to numsize do namelist.add(digitnames[i]);
    end
    else
    begin
      msg:='Find a five digit number ';
      j:=pos(msg,s);
      if j>0 then
      begin
        NumSize:=5;
        delete(s,j,length(msg));
        For i:=1 to numsize do namelist.add(digitnames[i]);
      end;
    end;

    if n>=0 then
    {remove unnecessary words}
    for i:=0 to unneededwordslist.count-1 do
    with unneededwordslist do
    begin
      len:=length(strings[i]);
      {unneeded at start of sentence}
      if comparetext(strings[i]+' ', copy(s,1,len+1))=0
      then system.delete(s,1,len);

      {unneeded word embedded or last}
      s:=stringreplace(s,' '+strings[i],' ',[rfReplaceall, rfignorecase]);

      {unneeded only at end of sentence (strings[i] includes final delimiter)}
      if comparetext(' '+lowercase(strings[i]), copy(s,length(s+finaldelim)-len,len+1))=0
      then system.delete(s,length(s)-len,len+1);
    end;
    s:=trim(s);

    for i:=0 to digitidlist.count-1 do
    with digitidlist do
    begin
      {digit name embedded or last}
      s:=stringreplace(s,names[i],values[names[i]],[rfReplaceall, rfignorecase]);
    end;

    {Expand contractions}
     s:=stringreplace(s,'she''ll','she will',[rfreplaceall]);
     s:=stringreplace(s,'he''ll','he will',[rfreplaceall]);
     {later on, after identifying names, we will replace "she" or "he"
      with the first name in the preceding sentence}

    {rebuild word list (Slist)}
    sentence:='';
    slist.clear;
    repeat
      w:=getword(s,delims,delim);
      if w<>'' then
      begin
        if lasttwo(w)='''s' then delete(w,length(w)-1,2);
        slist.add(w);
        sentence:=sentence+w+delim;
      end;
    until s='';
  end;
end;

{*************** ShowSentence **********}
procedure TForm1.showsentence(n:integer; msg:string; showdelim:boolean);
{display the nth sentence }
var
  i:integer;
  s:string;
begin
  if not runsilent then
  with sentencedisplayMemo, sentences[n] do
  begin
    lines.add(msg);
    s:='';
    for i:=0 to slist.count-1 do s:=s+' '+ slist[i];
    if showdelim
    then if origsentence[length(origsentence)]='?' then s:=s+'?' else s:=s+'.';
    delete(s,1,1);   {delete the extra space added at the beginning}
    lines.add('     "'+s+'"');
  end;
end;

{*********  ResultDisplay ***********}
procedure TForm1.ResultDisplay(const s:string);
begin
  if not runsilent then sentencedisplaymemo.lines.add(s);
end;

{************* ShowNames ***********}
procedure TForm1.Shownames;
{display names in list}
var
  i:integer;
  s:string;
begin
  namedisplay.clear;
  if runsilent then exit;
  s:='';
  with namedisplay,lines do
  begin
    for i:=0 to namelist.count-1 do
    if indexof(namelist[i])<0 then
    begin
      add(namelist[i]);
      s:=s+','+namelist[i];
    end;
    selstart:=0; sellength:=0; 
  end;
  
  delete(s,1,1);  {delete that extra ','}
  Resultdisplay('Names: '+s);
end;

{************** ConvertNumbers ************}
procedure TForm1.Convertnumbers(n:integer);
{replace number words with numbers}
var
  i,index:integer;
  s:string;
begin
  with sentences[n] do
  begin
    for i:=0 to slist.count-1 do
    with slist do
    begin
      s:=lowercase(strings[i]);
      index:= numberslist.indexofname(s);
      if index>=0 then strings[i]:=numberslist.values[s];
    end;
  end;
end;

{*********** ConvertOps ***********}
procedure TForm1.ConvertOps(num:integer);
{Final step to build equation from the sentence words}
var
  i, j, m, n:integer;
  s, oldstr, newstr, w, sumstr:string;
  delim:char;
  ncount, vcount, dcount:integer;
  nums, vars, denoms:array[1..20] of string;
  global:char;
  nbrtosum:integer;
  stop:integer;
begin
  with sentences[num] do
  begin
    {make a version of the sentence with numbers and names identified}
    ncount:=0;
    vcount:=0;
    dcount:=0;
    global:=' ';
    stop:=slist.count-1;
    i:=0;
    while i<=stop do
    begin
      if lowercase(slist[i])='last' then slist[i]:=digitnames[numsize];
      If lowercase(slist[i])='sum'  then
      begin
        {If previous op is &SUM and next entry is &N then
         sentence is assumed to be like ... plus the sum of the last 3 digits" }
        if (i>1) and (lowercase(slist[i+1])='last') and (slist[i+2][1] in['1'..'9'])  then
        begin
          //slist[i-1]:='SUM';
          j:=numsize;
          //if digitidlist.count<numsize then
          nbrtosum:=strtoint(slist[i+2]);
          slist[i]:=digitnames[j]+' + ';
          s:=s+slist[i];
          dec(j);
          slist[i+1]:=digitnames[j];
          s:=s+slist[i+1];
          inc(i,2);
          dec(j);
          while j>numsize-nbrtosum do
          begin
            s:=s+' + '+digitnames[j];
            dec(j);
          end;
          stop:=slist.count-1;
        end
        else
        begin
          s:=s+' '+slist[i];
        end;
        inc(i);
      end {sum}
      else
      if lowercase(slist[i])='product'  then
      begin
        s:=s+' '+slist[i];
        inc(i);
      end
      else
      //begin
        //if lowercase(slist[i])='last' then slist[i]:=digitnames[numsize];

      if lowercase(slist[i])='same'  then
      begin
        if (i>=2) and (slist[i-1][1] ='2')  then
        begin
          if slist[i-2]=digitnames[1] then
          begin
            delete(s,length(s)-2,3); {delete &N added previously}
            dec(ncount); {forget about the '2' added previuosly}
            s:=s+' = &V';
            inc(vcount);
            vars[vcount]:=digitnames[2];
          end;
        end
        else s:=s+' '+slist[i];
        inc(i);
      end
      else
      begin
        if slist[i][1] in ['1'..'9'] then
        begin
          s:=s+' &N';
          inc(ncount);
          nums[ncount]:=slist[i];
        end
        else
        if namelist.indexof(slist[i])>=0 then
        begin
          s:=s+' &V';
          inc(vcount);
          vars[vcount]:=slist[i];
        end
        else if denomlist.indexofname(slist[i])>=0 then
        begin
          s:=s+' &D';
          inc(dcount);
          denoms[dcount]:=denomlist.values[slist[i]];
        end
        else s:=s+' '+slist[i];
        inc(i);
      end;
    end;
    delete(s,1,1);  {delete the leading blank}

    {Now we have rebuilt the sentence with numbers, and variables identified.
    Next step is to check for patterns in
     OpWordsList which are in the text and replace them with equation pieces}

    for i:=0 to opWordslist.count-1 do
    with opwordslist do
    begin
      oldstr:=names[i];
      newstr:=values[names[i]];
      {if an opening phrase specifies a past or future time, it will apply to
       both parties unless the sentence specifies "is now" or "current age"
       for person 2}

      n:=pos(lowercase(OLDSTR),lowercase(s));
      if n>0 then
      begin
       If    (length(newstr)>0)
          and (length(oldstr)>5)
          and (newstr[length(newstr)]='=')
          and (pos('=',s)=0) {the LEFT SIDE of the equation}
        then
        begin
           if (copy(oldstr,1,5)='in &N') then global:='+'
           else if (copy(oldstr,1,2)='&N')and (pos('ago',oldstr)>0)
                then global:='-';
           {If a sentence ends with a phrase indicating that global doesn't apply
               then remove the phrase and reset the global flag}
           if (global<>' ') and
           (
             (copy(s,length(s)-2,3)=' is')
             or (copy(s,length(s)-6,7)=' is now')
             or (copy(s,length(s)-3,4)=' now')
           )
           then
           begin
             global:=' ';
             {remove the current time phrase}
             if (copy(s,length(s)-2,3)=' is') then system.delete(s,length(s)-2,3)
             else if (copy(s,length(s)-6,7)=' is now') then system.delete(s,length(s)-6,7)
             else if (copy(s,length(s)-3,4)=' now') then system.delete(s,length(s)-3,4);
           end;
           s:=StringReplace(S, oldstr, newstr, [rfReplaceAll,rfignorecase]);
        end
        else
        if pos('=',newstr)>0 {the replacement is a complete equation}
        then  s:=StringReplace(S, oldstr, newstr, [rfReplaceAll,rfignorecase])
        else
        begin {a RIGHT SIDE}
          s:=TRIM(StringReplace(S, oldstr, newstr, [rfReplaceAll,rfignorecase]));
          if global<>' ' then
          begin  {otherwise, insert +- global offset to 2nd person also}
            j:=length(s);
            while s[j]<>'&' do dec(j);
            system.insert('(',s,j{+1});
            s:=s+global+nums[1]+')';
          end;
          global:=' ';
        end;
        n:=pos('&SUMALL',s);
        if n>0 then
        begin
          sumstr:=namelist[0];
          for j:=1 to namelist.count-1 do sumstr:=sumstr+' + '+namelist[j];
          s:=stringreplace(s,'&SUMALL',sumstr,[]);
        end;
        n:=pos('&SUM',s);  {replace &SUM by sum of ages}
        If n>0 then
        begin  {sum the next set of contiguous names}
          m:=pos('=',s);
          if m=0 then m:=pos('equals',s);
          if n>m then
          begin {sum is on rightside of equation}
            sumstr:=vars[2]+' + '+vars[3];
            s:=stringreplace(s,'&V', vars[1],[]);
            for j:=1 to 2 do
            begin
              s:=stringreplace(s,'&V','',[]);
            end;
          end
          else
          begin {sum is left of equals}
            sumstr:=vars[1]+' + '+vars[2];
            for j:=1 to 2 do
            begin
              s:=stringreplace(s,'&V','',[]);
            end;
            s:=stringreplace(s,'&V', vars[3],[]);
          end;
          s:=stringreplace(s,'&SUM',sumstr,[]);
        end;  {sum}
      end;
    end;
    {reinsert the numbers and names}
    ncount:=0;
    repeat
      j:=pos('&N',s);
      if j>0 then
      begin
        inc(ncount);
        s:=stringreplace(s,'&N',nums[ncount],[rfIgnorecase]);
      end;
    until j=0;
  
    vcount:=0;
    repeat
      j:=pos('&V',s);
      if j>0 then
      begin
        inc(vcount);
        s:=stringreplace(s,'&V',vars[vcount],[]);
      end;
    until j=0;

    dcount:=0;
    repeat
      j:=pos('&D',s);
      if j>0 then
      begin
        inc(dcount);
        s:=stringreplace(s,'&D',denoms[dcount],[rfIgnorecase]);
      end;
    until j=0;

    {now rebuild the sentence from s}
    sentence:='';
    slist.clear;
    repeat
      w:=getword(s,delims,delim);
      if w<>'' then
      with sentences[num] do
      begin
        slist.add(w);
        sentence:=sentence+w+delim;
      end;
    until s='';
  end;
end;

{********* SolveBtnClick *********}
procedure TForm1.SolvebtnClick(Sender: TObject);
{Solve a problem}
begin
  RunSilent:=false;
  sentenceDisplayMemo.clear;
  SolveCase;
end;

{*************** Solvecase **********}
function TForm1.SolveCase:boolean;
{Start the search for equations}
var
  i,n:integer;
begin
  if not loaded then
  begin
    showmessage('No parsing tables loaded');
    result:=false;
    exit;
  end;
  setupProblem; {reset tables and parameters}
  pagecontrol1.activepage:=Parsesheet;
  for i:=0 to high(sentences) do
  begin
    Resultdisplay('');
    Resultdisplay('Sentence #'+inttostr(i+1));
    with sentences[i] do
    if (origsentence[length(origsentence)]<>'?') and (not comment) then
    begin
      Preprocess(i);
      showsentence(i,'After removing unneeded words, etc.',false);
      n:=pos('all digits',sentence);
      if (n=0) then n:=pos('sum all',sentence);
      if (n>0) or FindNames(i) then
      begin  {sentence has at least one name}
        //Resultdisplay('After finding names');
        //shownames;
        convertnumbers(i);
        showsentence(i,'After converting numbers',true);
        convertops(i);
        showsentence(i,'After operations inserted, (hopefully an equation!)',false);
      end
      else
      begin
        Resultdisplay('Sentence ignored - No names');
      end;
    end
    else showsentence(i,'Comment or Question ignored',true);
  end;
  result:=evaluate;
end;


{************* Evaluate ************}   {From ageproblem solver}
function Tform1.evaluate:boolean;
var
  i, k, n, index:integer;
  left1, right1:string;
  val1,val2:single;
  totcount :integer;
  eval:TEval;
  error:boolean;
  ok:boolean;
  start, stop:integer;
  nstr:string;
  cancelflag:boolean;

  procedure showerror(msg:string);
  var
    mr:integer; {messagedlg return value}
  begin
    if not runsilent then
    begin
      mr:=messagedlg(msg,mtconfirmation,[mbOK, mbcancel],0);
      cancelflag:=mr=mrcancel;
    end;
    error:=true;
  end;


begin
  begin
    eval:=TEval.create;
    eval.silent:=runsilent;
    result:=true;
    totcount:=0;
    cancelflag:=false;
    screen.cursor:=crHourglass;
    eval.clearvariables;
    for i:=0 to namelist.count-1 do  eval.addvariable(namelist[i],0);
    start:=intpower(10,numsize-1); {no "0..." nbrs, 1st digit will be >=1}
    stop:=10*(start)-1;
    for n:= start to stop do {for all feasible solutions}
    begin
      ok:=true;
      nstr:=format('%*.*d',[numsize,numsize,n]);
      {fill in trial variable values}
      //for k:=0 to namelist.count-1 do eval.addvariable(namelist[k], strtoint(nstr[k+1]));
      for k:=0 to namelist.count-1 do
      begin
        val1:=ord(nstr[k+1])-ord('0');
        eval.varlist.objects[k]:= TObject(val1);
      end;

      for i:=0 to high(sentences) do  {for all equations}
      with sentences[i] do
      begin
        index:=pos('=',sentence);
        if index>0 then
        begin
          left1:=trim(copy(sentence,1,index-1));
          right1:=trim(copy(sentence,index+1,length(sentence)-index));
          if eval.evaluate(left1,val1) then
          begin
            if eval.evaluate(right1,val2) then
            if val1<>VAL2 THEN
            begin
              OK:=false;
              break;
            end
            else
            else
            begin {EVAL FAILED}
              showerror(eval.getlasterror);
              if cancelflag then break;
            end;
          end
          else
          begin
            showerror(eval.getlasterror);
            If cancelflag then break;
          end;
        end;{'=' sign found loop}
        if cancelflag then break;
      end; {for all sentences loop}

      if OK then {solution found}
      with sentencedisplaymemo.lines do
      begin
        inc(totcount);
        add('');
        add('--------------------');
        add('Solution #'+inttostr(totcount));

        for i:=0 to namelist.count-1 do add(namelist[i]+'='+nstr[i+1]);
        if stopfirst.checked then break {stop if only one solution wanted}
        else if totcount>=10 then
        begin
          add('Probable parsing error, only first 10 solutions shown');
          break;
        end;
      end;
    end; {for all possible solutions loop}

    if totcount=0 then result:=false;
    eval.free;
    screen.cursor:=crdefault;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.LoadIniBtnClick(Sender: TObject);
begin
  with opendialog2 do
  begin
    title:='Select a tables file';
    if opendialog2.execute then
    begin
      loadtables(opendialog2.filename);
    end;
  end;
end;

procedure TForm1.BacktestBtnClick(Sender: TObject);
var
  f:TSearchrec;
  r:integer;
  s:string;
begin

  {process all *.txt files in the program directory
   as age problem cases and summarize results}
   runsilent:=true;
   sentencedisplaymemo.Clear;
   r:=findfirst(extractfilepath(application.exename)+'*.txt',FAAnyfile,f);

   repeat
    if r=0 then
    begin
      s:=f.name;
      loadfile(s);
      if solvecase then s:=s+'  Solved'
      else s:=s+'  Not Solved';
      sentencedisplaymemo.lines.add(s);
      r:=findnext(f);
    end;
  until r<>0;
end;

end.