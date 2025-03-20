unit U_PhraseFinder;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, UDict, ShellAPI;

type
  TMSetRec=array['a'..'z'] of integer;

  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    countlbl: TLabel;
    Label3: TLabel;
    Edit3: TEdit;
    UpDown2: TUpDown;
    Label4: TLabel;
    Edit4: TEdit;
    UpDown3: TUpDown;
    Label5: TLabel;
    Phraselist: TMemo;
    TimeLbl: TLabel;
    Label8: TLabel;
    Label6: TLabel;
    ExcludeWords: TMemo;
    Label7: TLabel;
    FirstWords: TMemo;
    ListBox1: TListBox;
    SearchBtn: TButton;
    StaticText1: TStaticText;
    SelectDicBtn: TButton;
    DicLbl: TLabel;
    DicCountLbl: TLabel;
    Label9: TLabel;
    WordcountLbl: TLabel;
    Label10: TLabel;
    procedure SearchBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure SelectDicBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure EditChange(Sender: TObject);
  public

    n,t:integer;
    p:array[0..20] of char;
    minlen,maxlen:integer;
    targetwordcount:integer;
    wordcount:integer;
    wordlist:Tstringlist;
    firstwordsOK:boolean;
    starttime:TDatetime;
    function makemultiset(const s:string):TMsetRec;
    function IsSubset(const M1,M2:TMsetrec):boolean;
    function SetDiff(const M1, M2:TMsetrec):TMSetrec;
    function Lowletter(const M1:TMsetrec):char;
    function Highletter(const M1:TMsetrec):char;
    function Sum(const M1:TMsetrec):integer;
    procedure findwords(const M1:TMsetrec;  nextstart:integer);
    procedure MakeWordlist;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  a:TMSetRec;

{********* MakeMultiset ***********}
function TForm1.makemultiset(const s:string):TMSetRec;
var
  ch:char;
  i:integer;
begin
  for ch:='a' to 'z' do result[ch]:=0;
  for i:=1 to length(s) do inc(result[s[i]]);
end;


{********** IsSubset **********}
function TForm1.IsSubset(const M1,M2:TMsetrec):boolean;
var
  ch1:char;
  workset:TMsetRec;
begin
  result:=true;
  workset:=M1;
  for ch1:= low(M2) to high(m2) do
  if  m2[ch1]>m1[ch1] then
  begin
    result:=false;
    break;
  end;
end;


{************ Lowletter ***********}
function TForm1.Lowletter(const M1:TMsetrec):char;
{Find the low letrter in a multiset}
var  ch:char;
begin
  for ch:='a' to 'z' do if M1[ch]>0 then break;
  if m1[ch]>0 then result:=ch else result:=' ';
end;

{********** Highletter ************}
function TForm1.Highletter(const M1:TMsetrec):char;
{Find the high letter in a multiset}
var ch:char;
begin
  for ch:='z' downto 'a' do if M1[ch]>0 then break;
  if m1[ch]>0 then result:=ch else result:=' ';
end;

{******** Sum ***********}
function TForm1.Sum(const M1:TMsetrec):integer;
var
  ch:char;
begin
  result:=0;
  for ch:='a' to 'z' do inc(result,M1[ch]);
end;

{******** Sum ***********(overloaded version)}
function TForm1.SetDiff(const M1,M2:TMsetrec):TMsetrec;
var
  ch:char;
begin
  for ch:='a' to 'z' do result[ch]:=M1[ch]-m2[ch];
end;

{********** MakeWordList ******}
procedure TForm1.Makewordlist;
var
  AA,Z:char;
  s:string;
  m2:TMSetRec;
begin
  wordlist.clear;
  with pubdic do
  begin
    {set up the dictionary}
    AA:=LowLetter(A);
    Z:=highletter(A);
    setrange(AA,minlen,Z,maxlen);
    while getnextword(s) do
    if excludewords.lines.indexof(s)<0
    then
    begin
      m2:=makemultiset(s);
      {only add words that can be formed from inital set of letters}
      if issubset(a,m2) then  wordlist.add(s);
    end;
  end;
  wordcountlbl.caption:=inttostr(wordlist.count)+' possible words from given letters and lengths';
end;

var testcount:integer=0;

{************* FindWords *********}
procedure TForm1.findwords(const M1:TMsetrec; nextstart:integer);
var
  i,j:integer;
  jstart:integer;
  s:string;
  Ms2,M3:TMsetrec;
begin
  if wordcount<targetwordcount-2 then
  begin {to speed things up, only check for messages only once in a while}
    application.processmessages;
    if tag<>0 then exit; {check stop flag}
  end;

  if firstwordsOK and (wordcount<=firstwords.lines.count) then
  with firstwords do
  begin
    if not wordlist.find(lines[wordcount],jstart)
    then {word is not in the list, so start search with next word}
    begin
      firstwordsOK:=false;
      jstart:=nextstart;
    end;
  end
  else jstart:=nextstart;
  {Once we have handled wordcount words one time, stop checking for
   initial starting words}
  if wordcount=targetwordcount-1 then firstwordsOK:=false;
  for j:= jstart to wordlist.count-1 do
  begin
    s:=wordlist[j];
    ms2:=makemultiset(lowercase(s));
    if issubset(M1,ms2) then
    begin
      inc(wordcount);
      listbox1.items.add(s);
      m3:=setdiff(m1,ms2);
      if wordcount<targetwordcount
      then findwords(M3,j)
      else  {found the required nbr of words}
      if sum(M3)=0 then {and no leftover letters, so this is a solution}
      with listbox1 do
      begin
        s:=items[0];
        for i:=1 to items.count-1 do
        begin
          s:=s+' '+items[i];
        end;
        phraselist.Lines.add(s);
        countlbl.caption:=inttostr(phraselist.lines.count)+' solutions found';
        timelbl.caption:=format('%6.2f seconds',[secsperday*(now-starttime)]);
        application.processmessages;
      end
      else inc(testcount);
      if testcount and 4095 {65536-1} = 0 then
      begin
        testcount:=0;
        application.processmessages;
      end;
      {back from recursion, remove last word tried so we can try the next}
      if tag<>0 then exit;
      with listbox1.items do delete(count-1);
      dec(wordcount);
    end;
  end;
end;

{*********** Sort *********}
procedure sort(var s:string);
{sort letters in alpha ascending}
var
  i,j:integer;
  ch:char;
begin
  for i:= 1 to length(s)-1 do
  for j:=i+1 to length(s) do
  if s[i]>s[j] then
  begin
    ch:=s[i];
    s[i]:=s[j];
    s[j]:=ch;
  end;
end;



{*********** SearchBtnClick ***********}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  i:integer;
  index:integer;
  s:string;
begin
  If searchbtn.caption='Stop' then
  begin
    tag:=1;
    searchbtn.caption:='Start';
     application.processmessages;
  end
  else
  begin
    starttime:=now;
    tag:=0;
    searchbtn.CAPTION:='Stop';
    screen.cursor:=crHourglass;
    s:=lowercase(edit1.text);
    sort(s); {No real need to sort except to move blanks to front}

    {PUT LETTER SET IN MULTISET FORMAT}
    a:=makemultiset(trim(s));
    t:=26;
    listbox1.clear;
    phraselist.clear;
    minlen:=updown1.position;
    maxlen:=updown2.position;
    targetwordcount:=updown3.position;
    makewordlist;
    wordcount:=0;
    firstwordsOK:=true;
    if firstwords.lines.count>0 then
    begin
      firstwordsOK:=true;
      for i:=0 to firstwords.lines.count-1 do
      if not wordlist.find(firstwords.lines[i],index) then
      begin
        firstwordsOK:=false;
        break;
      end;
    end;
    findwords(a,0); {start word search}
    if phraselist.lines.count>0 then
    begin
      firstwords.clear;
      s:=phraselist.lines[phraselist.lines.count-1]+' ';
      while length(s)>0 do
      begin
        n:=pos(' ',s);
        if n>0 then firstwords.lines.add(copy(s,1,n-1));
        delete(s,1,n);
      end;
    end;
  end;
  screen.cursor:=crdefault;
  searchbtn.caption:='Start search';
end;

{************ FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
var s:string;
begin
  s:=extractfilepath(application.exename)+'general.dic';
  if fileexists(s) then
  begin
    pubdic.loaddicfromfile(s);
    diclbl.caption:=pubdic.dicname;
    DicCountLbl.caption:=inttostr(pubdic.getdicsize)+' words in this dictionary';
  end
  else selectDicBtnClick(sender);
  wordlist:=TStringlist.create;
  wordlist.sorted:=true;
end;

{************ EditkeyPress ***********}
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
{make sure we accept only letters}
begin
  if not (key in ['A'..'Z','a'..'z']) then key:=#00;
end;

{***************** SelectDicBtnClick *************}
procedure TForm1.SelectDicBtnClick(Sender: TObject);
begin
  editchange(sender);
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    begin
      pubdic.loadDicFromFile(filename);
      diclbl.caption:=pubdic.dicname;
      DicCountLbl.caption:=inttostr(pubdic.getdicsize)+' words in this dictionary';
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1; {set stop flag}
end;

procedure TForm1.EditChange(Sender: TObject);
{reset labels and results whenever an input field changes}
begin
  firstwords.clear;
  with phraselist, lines do
  if (count>0) and (length(lines[0])>3) and (copy(lines[0],1,3)<>'I h')
  then clear;
  countlbl.caption:='Countlbl:=0';
  timelbl.caption:='0.0 seconds';
  wordcountlbl.caption:='...';
end;

end.
