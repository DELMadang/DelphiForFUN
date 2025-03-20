unit U_Decrypt3;
{Copyright 2001-2009 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Deciphers messages encoded with a simple substitution code - each occurence
  of a letter value replaced by the same encrypting letter throughout the
  message}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, ExtCtrls, CheckLst, ShellAPI;

type
  TUsedLetters=array['a'..'z'] of boolean;
  TLettercounts=array['a'..'z'] of integer;
  TDecryptform = class(TForm)
    PageControl1: TPageControl;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Timelbl: TLabel;
    StopBtn: TButton;
    Memo2: TMemo;
    SearchBtn: TButton;
    ListBox2: TListBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo4: TMemo;
    TabSheet3: TTabSheet;
    Label6: TLabel;
    Label5: TLabel;
    LoadMsgBtn: TButton;
    SaveBtn: TButton;
    CheckListBox1: TCheckListBox;
    Memo5: TMemo;
    Memo1: TMemo;
    Label9: TLabel;
    Label10: TLabel;
    IgnoredWordsMemo: TMemo;
    MakeMsgBtn: TButton;
    LoadDicBtn: TButton;
    StaticText1: TStaticText;
    SuggestBtn: TButton;
    Label8: TLabel;
    SuggestMemo: TMemo;
    Memo3: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadMsgBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure MakeMsgBtnClick(Sender: TObject);
    procedure LoadDicBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SuggestBtnClick(Sender: TObject);
    procedure Memo5Change(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure TabSheet2Enter(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    wordlist:TStringlist; {enciphered words in original order}
    dwords:TStringlist; {enciphered words in descending length order}
    IgnoredWords:TStringList;
    FromString:string[26];  {the enciphered alphabet}
    Tostring:string[26];   {the plaintext alphabet}
    initialized:boolean;
    maxlevel:integer;  {to test to closest solution}
    bestsubst:string; {the solution substitution string,
                   i.e replace FromString[i] with bestsubst[i] for all i}

    suggestionsconfirmed:boolean;
    procedure extractwords(FromMemo:TMemo; ToList:TStrings);
    procedure setup;
    function checkwords(subst:string):boolean;
    function findNextletters(i:integer; subst:string; minlevel:integer):boolean;
    function SetupToString(tryword:string; orderlist:TStringlist):boolean;
    function checktranslate(s:string; var validword:string):boolean;
    procedure makeFromString;
    function removedups(s:string):string;
    procedure clearsuggestions;
  end;

var
  Decryptform: TDecryptform;
  count:integer;
implementation

{$R *.DFM}

Uses math, UDict, U_Decrypt3Msg, U_Decrypt3Suggest, DffUtils;

var
  {order of trying to resolve letters - freq of occurence in English}
   origorder:string[26]='etnrioasdhlcfpumygwvbxkqjz';

procedure TDecryptform.FormCreate(Sender: TObject);
{tell form activate to do first time stuff}
begin
  initialized:=false;  {should be default anyway}
   
end;


{*************** TDecryptform.Formactivate *********}
procedure TDecryptform.FormActivate(Sender: TObject);
begin
  if not initialized then
  begin
    if not assigned (Dicform) then Application.CreateForm(TDicForm, DicForm);
    wordlist:=Tstringlist.create;
    dwords:=TStringlist.create;
    IgnoredWords:=TStringlist.create;
    If (application.mainform=self) then
    begin  {we are the main program - manage dics ourselves}
      pubDic.LoadDefaultDic; {load the default loaded}
      statusbar1.panels[1].text:='Current Dictionary:'+pubdic.dicname;
      loaddicbtn.visible:=true;
    end
    else  {we are being called by a wrapper program}
    begin
      caption:='Decrypt - Current Dictionary:'+pubdic.dicname;
      loaddicbtn.visible:=false;
    end;
    dwords.clear;
    opendialog1.Title:='Open an encrypted message';
    opendialog1.initialdir:=extractfilepath(application.exename);
    initialized:=true;
  end;
  label1.caption:='';
  label2.caption:='';
  stopbtn.visible:=false;
  stopbtn.BringToFront; {in case it was in back at design time}
  suggestionsconfirmed:=false;
  clearsuggestions;
end;

  {****************** CheckTranslate *****************}
  function TDecryptform.checktranslate(s:string; var validword:string):boolean;
  {see if decipherment could be a valid word}
  var
    j,index:integer;
    a,f,c:boolean;
    error:boolean;
    wordok:boolean;
    len:integer;

  begin
    len:=length(s);
    result:=false;
    if len=0 then exit;
    if s[1] <>'_' then  PubDic.SetRange(s[1],Len,s[1],Len)
    else  PubDic.SetRange('a',Len,'z',Len);
    wordOK:=false;
    while (wordOK=false) and (Pubdic.getnextword(validword,a,f,c)) do
    if not a then {a true ==> abbreviation, don't use abbreviations}
    Begin
      error:=false;
      j:=0;
      while (not error) and (j<len) do
      begin
        inc(j);
        if (s[j]='_') or (s[j]=validword[j]) then
        else error :=true;
      end;
      {don't count the word as valid even though it is the dictionary if it is in
       the ignoredwords list}
      if (not error) and ignoredwords.find(validword,index) then error:=true;

      {check any double letters in encrpyted word, if not doubled in validword
       then this can';t  be the word we want}
      if not error then
      begin
        for j:=1 to length(s)-1 do if (s[j]<>'_') and (s[j]=s[j+1]) then
        begin  {found a double letter in encrypted word}
          if validword[j]<>validword[j+1] then
          begin  {not doubled in the candidate plain test word}
            error:=true;
            break;
          end;
        end;
      end;
      wordOK:=not error;
    end;
    result:=wordOK;
 end;

{************** TDecryptForm.checkwords ***************}
function TDecryptform.checkwords(subst:string):boolean;
{called by findNextLetters to check a particular trial set against
 the words in wordlist}
var
  s, scopy, validword:string;
  i,j,k, len:integer;
  wordOK:boolean;

begin
  result:=true;
  for i:= 0 to dwords.count-1 do {for each of the encrypted words}
  begin
    s:=lowercase(dwords[i]);
    scopy:=s; {we'll use scopy to display valid words in listbox2}
    len:=length(s);
    {decrypt the encrypted word}
    for j:=1 to len do
    begin
      k:=1;
      {look for the letter in FromString}
      while FromString[k]<>s[j] do inc(k);
      s[j]:=subst[k]; {and replace it with decrypted letter}
    end;
    {check for ignored words and double letters in the encrypted word and make
     sure that this word qualifies}
     wordOK:=checktranslate(s,validword);


    if (not wordOK)  then
    begin
      {there is no valid word so we might as well quit checking}
      result:=false;
      break;
    end
    else
    begin {If valid, find the encrypted word in wordlist }
      j:=wordlist.indexof(scopy);
      if j>=0 then
      begin
        {and put valid word inlistbox2}
        listbox2.items[j]:=s +'...('+ validword+')';
        listbox2.update;
      end;
    end; {wordOK}
  end;  {dword list scan}
  label2.caption:='Substitution   letters "'+subst+'"';
  application.processmessages;
end;



{************** TDecryptForm.findnextletters *****************}
function TDecryptform.findNextletters(i:integer; subst:string; minlevel:integer):boolean;
{recursive function that is the heart of decipher process}
var
  j:integer;
  c:char;
  used:TUsedLetters;
begin
  result:=false;
  if (tag<>0) or (length(subst)=0)  then exit;
  {initialize array of used letters}
  for c:='a' to 'z' do used[c]:=false;
  {mark current contents of subst string as used}
  for j:= 1 to length(subst) do used[subst[j]]:=true;
  j:=1;
  repeat
    {find the next unused letter from ToString string}
    repeat if used[ToString[j]] then inc(j)
                                 until (J>length(ToString)) or (not used[ToString[j]]);
    if j<=length(ToString) then {we have found a letter to try}
    begin
      {add a substitute letter}
      subst[i]:=ToString[j];
      {mark it as used}
      used[ToString[j]]:=true;
      {valid subst?}
      if checkwords(subst)
      then {that letter is OK}
      begin
        If i<length(FromString) {if we need more - try the next, recursion}
        then
        begin
          if i>maxlevel then
          begin  {a new longest string of substitution letters, save it}
            bestsubst:=subst;
            maxlevel:=i;
          end;
          result:=findnextletters(i+1,subst,minlevel);
        end
        else
        begin
          result:=true;  {otherwise we're done!}
          bestsubst:=subst;
        end;
      end
      else
      begin
        if i>maxlevel then {save the best so far}
        begin
          bestsubst:=subst;
          maxlevel:=i;
        end;
        if i<minlevel then tag:=1;
      end;
    end;
  until result or (j>length(ToString)) or (tag<>0);
end;



{************** TDecryptForm.SetupToString *****************}
function TDecryptform.SetupToString(tryword:string; orderlist:TStringlist):boolean;
{speed up search by rearranging the order that letters are tried
 in such a way that the word passed (the longest word) is always deciphered
 successfully}

   {local - maketemplate }
   function maketemplate(s:string):string;
   {make a tmeplate that identifies unique and repeated letters in input string}
   var i,j:integer;
       t:string;
       ch:char;
   begin
     t:=s;
     ch:='a';
     t[1]:=ch;
     for i:=2 to length (s) do
     begin
       ch:=succ(ch);
       t[i]:=ch;
       for j:= 1 to i-1 do if s[i]=s[j] then
       begin
         t[i]:=t[j];
         break;
       end;
     end;
     result:=t;
   end;

var
  s,validword:string;
  t1,t2:string;
  a,f,c:boolean;
begin
  s:= tryword;  {get the word to check}
  t1:=maketemplate(s);
  PubDic.SetRange('a',Length(s),'z',Length(s));
  orderlist.clear;
  while (Pubdic.getnextword(validword,a,f,c)) do
  if not a then
  begin
    (*
    if (( not a) and (not  f) and (not c))
       or (a and useabbrevs.checked)
       or (f and useforeign.checked)
       or (c and usecaps.checked)
    then*) t2:=maketemplate(validword);
    if t1=t2 then
    begin
      orderlist.add(validword);
    end;
  end;
  result:=TRUE;
end;


 {******************* RemoveDups **************}
  function TDecryptform.removedups(s:string):string;
  {return a string with all duplicate letters removed from the input string}
  var  i,j:integer;
       dup:boolean;
  begin
    result:='';
    for i:=1 to length(s) do
    begin
      dup:=false;
      for j:=1 to length(result) do if s[i]=result[j] then
      begin
        dup:=true;
        break;
      end;
      if not dup then result:=result+s[i];
    end;
  end;


{************** TDecryptform.SearchBtnClick *************}
procedure TDecryptform.SearchBtnClick(Sender: TObject);
{Start the decryption process}



  {local - couldbevalid}
  function couldbevalid(eword, decipher, testword:string):boolean;

  var
    enodups:string;
    test2:string;
    i,j:integer;
    validword:string;
  begin
     enodups:=removedups(eword);
     test2:=stringofchar('_',length(testword));
     for i:=1 to length(testword) do
     begin
       for j:=1 to length(enodups) do if enodups[j]=testword[i] then
       begin
         test2[i]:=decipher[j];
         break;
       end;
     end;
     result:=checktranslate(test2,validword);
   end;


var
  i,j:integer;
  s,ss,s1,s2:string;
  subst:string;
  AllOK:boolean;
  decode:array['a'..'z'] of char;
  c:char;
  starttime:TTime;
  timestr:string;
  olist1,olist2,olist3:TStringlist;
  saveword:string;
  fromword:string;

  begin  {searchbtnclick}
    if dwords.count=0 then
    begin
      showmessage('Load or enter a message first');
      exit;
    end;
    tag:=0;
    olist1:=TStringlist.create;
    olist2:=TStringlist.create;
    olist3:=tstringlist.create;
    stopbtn.visible:=true;
    loaddicbtn.enabled:=false;
    makemsgbtn.enabled:=false;
    {On first entry for new message , things are  already setup
    but if the user clicks search 2nd time, we need to setup again }
    //Setup;

    {for each length try assigning unused letters, if it makes a word
     - keep it and try all other words with this letter
     - if word exists, continue othewise backtrack and try the next letter}
    screen.cursor:=crHourglass;

    starttime:=time;
    allok:=false;
    maxlevel:=0;
    repeat
      SETUPToString(dwords[0], olist1);
      if olist1.count=0 then
      begin
        showmessage('The word '+dwords[0] + ' has no matching pattern in the dictionary and will be ignored');
        dwords.delete(0);
      end;
    until (dwords.count=0) or (olist1.count>0);
    fromword:=dwords[0];
    if dwords.count>1 then
    repeat
      SetupToString(dwords[1],olist2);
      if olist2.count=0 then
      begin
        showmessage('The word '+dwords[1] + ' has no matching pattern in the dictionary and will be ignored');
        dwords.delete(1);
      end;
    until (dwords.count=1) or (olist2.count>0);

    if    (olist1.count>1) and (olist1.count<10)
      and (olist2.count>1) and (olist2.count<10) then
    begin
      {how many sets would be valid?}
      for i:=0 to olist1.count-1 do
      for j:=0 to olist2.count-1 do
      begin
        s1:=removedups(olist1[i]);
        s2:=removedups(olist2[j]);

        {If we decrypted s2 according to the letters from s1, and vice versa ,
         could they be a valid words?}
        if couldbevalid(dwords[0],s1, dwords[1]) and couldbevalid(dwords[1],s2,dwords[0])
        then
        begin
           olist3.add(removedups(s1+s2));
        end;
      end;
      if olist3.count< min(olist1.count,olist2.count) then
      begin
         olist1.assign(olist3);
         fromword:=dwords[0]+dwords[1];
      end
      else if olist1.count>olist2.count then
      begin
        olist1.assign(olist2);
        fromword:=dwords[1];
      end;
    end
    {olist2 contains possible decryptions of the 2nd longest word, there had
     better be at least 5 fewer of these before using them is preferable
     to using the longest possible word list (olist1)}
    else if olist1.count>olist2.count+5 then
    begin
      olist1.assign(olist2);
      fromword:=dwords[1];
    end;

    makeFromString; {make the list of enciphered letters in the order they will be scanned}
    FromString:=removedups(suggestiondlg.firstfrom+fromword+FromString);
    label1.caption:='Substitute for letters "'+FromString+'" in order';

    for i:=0 to olist1.count-1 do
    begin
      subst:=stringofchar('_',length(FromString));
      ss:=olist1[i];
      ToString:=removedups(suggestiondlg.firstto+ss+origorder);
      ss:=removedups(suggestiondlg.firstto+ss);
      subst:=ss+stringofchar('_',length(FromString)-length(ss));
      {here is the call to the recursive search function}
      (*
      {initialize array of used letters}
      for c:='a' to 'z' do used[c]:=false;
      for j:= 1 to length(subst) do
      if subst[j]<>'_' then used[subst[j]]:=true
      else break;
      *)
      allok:=findnextletters(length(ss)+1,subst,length(ss)+1);
      if allok then break;
      timestr:=format('%6.1f seconds',[(time-starttime)*secsperday]);
      timelbl.caption:='Run time: '+timestr;
      timelbl.update;
    end;

    {No solution, try ignoring suggestions}
    if (not allok) and (tag=0) and (length(suggestiondlg.firstto) >0) then
    begin
      showmessage('No solution found with suggestions, trying with suggestions ignored');
      makeFromString; {make the list of enciphered letters in the order they will be scanned}
      FromString:=removedups(fromword+FromString);
      label1.caption:='Substitute for letters "'+FromString+'" in order';
      for i:=0 to olist1.count-1 do
      begin
        subst:=stringofchar('_',length(FromString));
        subst:=stringofchar('_',length(FromString));
        ss:=olist1[i];
        ToString:=removedups(ss+origorder);
        ToString:=origorder;
        allOK:=findnextletters(1,subst,0);
        dwords.insert(i,saveword);
        if allok then break;
      end;
    end;
    if (not allok) and (tag=0) then  {that didn't work, start dropping words}
    begin
      Showmessage('No solution found, Try dropping words from first to last');
      for i:=0 to dwords.count-1 do
      begin
        saveword:=dwords[i];
        dwords.Delete(i);
        subst:=stringofchar('_',length(FromString));
        ToString:=origorder;
        allOK:=findnextletters(1,subst,0);
        dwords.insert(i,saveword);
        if allok then break;
      end;
    end;
    olist1.free;
    olist2.free;
    olist3.free;

    screen.cursor:=crdefault;

    If not allok then showmessage('Message not deciphered');
    begin
      memo2.clear;
      for c:='a' to 'z' do decode[c]:='_';
      for i:= 1 to length(FromString) do decode[FromString[i]]:=bestsubst[i];
      with memo1 do
      for i:= 0 to lines.count-1 do
      begin
        s:=lowercase(lines[i]);
        for j:=1 to length(s) do
          if (s[j] in ['a'..'z']) then s[j]:=decode[s[j]];
        memo2.lines.add(s);
      end;

    end;
    stopbtn.visible:=false;
    loaddicbtn.enabled:=true;
    makemsgbtn.enabled:=true;
  end;

{******************* Formcreate ****************}


{************** TDecryptform.LoadMsgBtnClick ***********}
procedure TDecryptform.LoadMsgBtnClick(Sender: TObject);
{Load an encrypted  message from a file}
var
  i:integer;
begin
   if opendialog1.execute then
   begin
     memo5.lines.loadfromfile(opendialog1.filename);
     Statusbar1.panels[0].text:='Encrypted message file: ' +opendialog1.filename;
     extractwords(memo5,CheckListBox1.items);
     with checklistbox1 do
     for i:=0 to items.count-1 do checked[i]:=true;
     setup;
     clearsuggestions;
   end;
end;

{************** TDecryptform.StopBtnClick ************}
procedure TDecryptform.StopBtnClick(Sender: TObject);
{sewt the stop flag}
begin    tag:=1; end;

type
  TFreqrec =record
     count:integer;
     letter:char;
  end;

  TFreqset = array [1..26] of TFreqrec;

procedure GetFrequencies(list:TStrings; direction:char; var freqset:TFreqset);

    procedure swap(i,j:integer); {swap 2 frequency records (used for sorting)}
    var temp:TFreqrec;
    begin
      temp:=freqset[i];
      freqset[i]:=freqset[j];
      freqset[j]:=temp;
    end;

var
 i,j:integer;
 line:string;
 dir:char;
begin
  dir:=upcase(direction);
  for i:=1 to 26 do
  with freqset[i] do
  begin
    count:=0;
    letter:=char(ord(pred('a'))+i);
  end;

  for i:= 0 to list.count-1 do
  begin
    line:=lowercase(list[i]);
    for j:=1 to length(line) do
    if line[j] in ['a'..'z'] then inc(freqset[ord(line[j])-ord(pred('a'))].count);
  end;
  {now sort by count}
  for i:=1 to 25 do
  for j:=i+1 to 26  do
  if (dir='A') and (freqset[j].count<freqset[i].count) then swap(i,j)
  else if (dir='D') and (freqset[j].count>freqset[i].count) then swap(i,j);
end;



procedure TDecryptform.makeFromString;
  {make the list of enciphered letters in the order they will be scanned}
  var
    i:integer;
    freqset:TFreqset;
  begin
    FromString:='';
    getfrequencies(wordlist,'d',freqset);
    for i:=1 to 26 do if freqset[i].count>0 then fromstring:=fromstring+freqset[i].letter;
    //label1.caption:='Substitute for letters "'+FromString+'" in order';
  end;

(*
{******************* MakeFromString ***********}
procedure TDecryptform.makeFromString;
  {make the list of enciphered letters in the order they will be scanned}
  var
    c:char;
    i,j:integer;
    used:TUsedLetters;
    s:string;

  begin
    FromString:='';
    for c:='a' to 'z' do used[c]:=false;
    for i:=0 to dwords.count-1 do
    begin
      s:=lowercase(dwords[i]);
      for j:=1 to length(s) do
      begin
        if not used[s[j]] then
        begin
          FromString:=FromString+s[j];
          used[s[j]]:=true;
        end;
      end;
    end;
    label1.caption:='Substitute for letters "'+FromString+'" in order';
  end;
*)


procedure TDecryptform.extractwords(Frommemo:TMemo; ToList:TStrings);
{copy words from inout message to checklistbox1}
var
  i,j:integer;
  line,s:string;
begin
  ToList.clear;
  for i:=0 to FromMemo.lines.count-1 do
  begin
    line:=FromMemo.lines[i]+' ';
    s:='';
    j:=1;
    while (j<=length(line)) do
    begin
      while (j<=length(line)) and (line[j]>' ') do
      begin
         s:=s+line[j];
         inc(j);
      end;
      inc(j);
      if length(s)>0 then
      with ToList do
      begin
        add(lowercase(s));
      end;
      s:='';
    end;
  end;
end;

{************** Setup *************}
procedure TDecryptform.setup;
{Setup a new decipher search }
var
  i,j:integer;
  s,line:string;

begin
 {make a list of words sorted by size}
  dwords.clear;
  wordlist.clear;
  memo1.clear;
  memo2.clear;
  line:='';
  with checklistbox1 do
  for i:=0 to items.count-1 do
  begin
    s:=items[i];
    {delete punctuation marks from search word list}
    j:=length(s);
    while j>=1 do
    begin
      if not (s[j] in ['a'..'z']) then delete(s,j,1);
      dec(j);
    end;

    if checked[i] then
    with wordlist do
    begin
      {sort from long to short- we'll try to resolve longest words first since
       that will typically provide the fewest dictionary hits to test and will
       prune the search space quicker}
       dwords.add(format('%2.2d',[99-length(s)])+lowercase(s));
       add(s);
       line:=line+items[i]+' ';
    end;
    memo1.text:=line;

  end;
  extractwords(Ignoredwordsmemo,ignoredwords);
  ignoredwords.sort;
  dwords.sort;
  {done with length field, delete it}
  for i:=0 to dwords.Count-1 do dwords[i]:=copy(dwords[i],3,length(dwords[i])-2);

  {we'll use listbox2 to display trial decrypted words}
  listbox2.items.assign(wordlist);
  makeFromString;

end;

{************** TDecryptform.MakeMsgBtnClick *************}
procedure TDecryptform.MakeMsgBtnClick(Sender: TObject);
{Make a new encrypted message}
begin
  Makemsgdlg.showmodal;
  memo1.lines.assign(makemsgdlg.msg);
  //label3.caption:='Decrypting:'+makemsgdlg.msgfilename;
  statusbar1.panels[0].text:='Decrypting:'+makemsgdlg.msgfilename;;
  setup;
  clearsuggestions;
end;

{************** TDecryptform.LoadDicBtnClick *************}
procedure TDecryptform.LoadDicBtnClick(Sender: TObject);
{Load a dictionary - only called if loadic btn is visible -
 which only happens when this is the main form}
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    begin
      pubdic.loadDicFromFile(filename);
      caption:='Decrypt - Current Dictionary:'+pubdic.dicname;
    end;
  end;
end;

{**************** FormCloseQuery **************}
procedure TDecryptform.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  tag:=1;
  canclose:=true;
end;

{***************** SuggestBtnClick ************}
procedure TDecryptform.SuggestBtnClick(Sender: TObject);
var i:integer;
begin
  if SuggestionDlg.showmodal = mrOK then
  with suggestiondlg do
  begin
    suggestmemo.clear;

    if memo1.lines.count>0 then
    with memo1, suggestiondlg  do
    begin
      firstfrom:='';
      firstTo:='';
      for i:=0 to lines.count-1 do
      begin
        firstfrom:=firstfrom+lines[i];
        firstto:=firstto+memo2.lines[i];
        suggestmemo.Lines.add('From: '+lines[i]);
        suggestmemo.Lines.add('To  : '+memo2.lines[i]);
        suggestmemo.Lines.add('');
      end;
      removedups(firstfrom);
      removedups(firstto);
    end;
  end;
end;

 procedure TDecryptform.clearsuggestions;
 begin
   with suggestiondlg do
   begin
      firstTo:='';
      firstfrom:='';
      memo1.Clear;
      memo2.clear;
    end;
    suggestmemo.clear;
    suggestionsconfirmed:=false;
  end;

{************** Memo1Change **************}
procedure TDecryptform.Memo5Change(Sender: TObject);
var
  i:integer;
begin
  {Enciphered message changed, clear "suggestion" fields if user says to do it}
  if (length(suggestiondlg.firstfrom)>0) and  (not suggestionsconfirmed)
    and (messagedlg('Clear suggestions?',mtconfirmation,[mbyes,mbno],0)=mryes)
  then clearsuggestions;
  suggestionsconfirmed:=true;
  extractwords(memo5,checklistbox1.Items);
  with checklistbox1 do for i:=0 to items.count-1 do checked[i]:=true;
end;

{**************** SaveBtnClick *************}
procedure TDecryptform.SaveBtnClick(Sender: TObject);
begin
  if savedialog1.execute then
  begin
    memo5.lines.savetofile(savedialog1.filename);
  end;
end;

procedure TDecryptform.TabSheet2Enter(Sender: TObject);
begin
  setup;
end;

procedure TDecryptform.PageControl1Change(Sender: TObject);
begin
  if pagecontrol1.activepage=tabsheet3 then setup;
end;

procedure TDecryptform.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
