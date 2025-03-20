unit U_Syllables3;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, strutils, udict, spin, dffutils,
  USyllables3, Grids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    Introsheet: TTabSheet;
    SetupSheet: TTabSheet;
    TestSheet: TTabSheet;
    Memo5: TMemo;
    Label2: TLabel;
    ChooseDicGrp: TRadioGroup;
    ScanDicBtn: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    LookupBtn: TButton;
    LookupLbl: TLabel;
    Memo2: TMemo;
    Memo1: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    ReBuildBtn: TButton;
    BuildBtn: TButton;
    Memo6: TMemo;
    CountLbl: TLabel;
    RuleBox: TCheckBox;
    Memo7: TMemo;
    Memo8: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    CheckBox1: TCheckBox;
    RuleGrid: TStringGrid;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo9: TMemo;
    ScanTextBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure BuildBtnClick(Sender: TObject);
    procedure LookupBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ScanDicBtnClick(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ReBuildBtnClick(Sender: TObject);
    procedure ScanTextBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    dir:string;
    Syllables:TSyllables;
    RuleNbr:integer;
    rulecount,wordcount,matchedcount, compoundcount, errcount: integer;
    function makerulemsg(rulenbr:integer; w,w2:string):string;
    procedure CheckWord(w:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{************ FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,r,c:integer;
  rule:TStringx3;
begin
  dir:=extractfilepath(application.ExeName);
  reformatmemo(memo5);
  syllables:=TSyllables.create(dir,false,true);
  pagecontrol1.ActivePage:=Introsheet;
  with rulegrid do
  begin
    cells[0,0]:='Rule #';
    cells[1,0]:='Replace' ;
    cells[2,0]:='With';
    cells[3,0]:='Reinsert';
    cells[4,0]:='Sample word';
    cells[0,1]:='Prefix';
    rowcount:=2;

    for i:=1 to nbrprefixrules do
    begin
      rule:=getprefixrule(i);
      r:=rowcount;
      rowcount:=rowcount+1;
      cells[0,r]:='#P'+inttostr(i);
      for c:=1 to 3 do  cells[c,r]:=rule[c];
      cells[4,r]:='';
    end;

    r:=rowcount;
    rowcount:=rowcount+1;
    cells[0,r]:='Suffix';
    for i:=1 to nbrsuffixrules do
    begin
      rule:=getsuffixrule(i);
      r:=rowcount;
      rowcount:=rowcount+1;
      cells[0,r]:='#S'+inttostr(i);
      for c:=1 to 3 do  cells[c,r]:=rule[c];
      cells[4,r]:='';
    end;
  end;
end;

{************** BuildbtnClick ************}
procedure TForm1.BuildBtnClick(Sender: TObject);
{Make list of words and their syllablization}
 {http://archive.org/details/mobyhyphenationl03204gut}
{Build Syllables.txt from mhyphen.txt}
var
  i:integer;
  dir:string;
  s,line:string;
  inf, outf :Textfile;
  A,F,C:boolean;
  incount,droppedcount, singlecountsaved, multicountsaved:integer;
  singlecountdropped, multicountdropped:integer;
  ok:boolean;
  OKchars:set of char;
  w:string;
  HyphenName, syllablefilename:string; //, updatename, symbolListName:string;
begin
  OKChars:=['a'..'z', char($B7)];
  dir:=extractfilepath(application.ExeName);
  syllablefilename:=dir+'Syllables.txt';
  hyphenname:=dir+'mhyph.txt';
  screen.cursor:=crhourglass;
  If fileexists(hyphenName) then
  begin
    incount:=0;
    droppedCount:=0;
    multicountsaved:=0; multicountdropped:=0;
    singlecountsaved:=0; singlecountdropped:=0;
    assignfile(inf,hyphenname);
    Assignfile(outf,syllablefilename);
    reset(inf);
    rewrite(outf);
    pubdic.loadLargedic;

    while not eof(inf) do
    begin
      readln(inf,line);
      inc(incount);
      if incount and $ff = 0 then
      begin
        countlbl.caption:=line+' '+ inttostr(incount);
        application.processmessages;
      end;
      line:=lowercase(trim(line));
      ok:=true;
      for i:=1 to length(line) do if not (line[i] in OKchars)
      then
      begin
        ok:=false;
        break;
      end;
      if OK  then
      begin
        if pos(char($b7),line)>0 then
        begin
          w:=stringreplace(line,char($b7),'',[rfreplaceall]);
          if (pubdic.lookup(w, A,F,C)) and (not A) {and (not F)} then
          begin
            s:=w+'='+line;
            writeln(outf,s);
            inc(multicountsaved);
          end
          else inc(multicountdropped);
        end
        else
        begin {one syllable word}
          if (pubdic.lookup(line, A,F,C)) and (not A) {and (not F)} then
          begin
            s:=line+'='+line;
            writeln(outf,s);
            inc(singlecountsaved);
          end
          else inc(singlecountdropped);
        end;
      end
      else inc(droppedcount);
    end;
    closefile(inf);
    closefile(outf);
    memo6.Clear;
    with memo6.Lines do
    begin
      add('Syllables.txt file rebuilt from Mhyph.txt');

      add(format('%.0n records read',[0.0+incount]));
      add(format('%.0n phrases (non-alpha, abbreviation, or embedded blanks words) dropped',[0.0+DroppedCount]));
      add(format('%.0n  words not matching dictionary were dropped',
       [0.0+Droppedcount+SingleCountDropped+MultiCountDropped]));
      add(format('%.0n total words written',[0.0+singlecountsaved+multicountsaved]));
    end;
    scrolltotop(memo6);
  end
  else showmessage('No action taken. File '+hyphenname +' not available');
  screen.cursor:=crdefault;
end;

(************* ReBuildBtnClick *********)
procedure TForm1.ReBuildBtnClick(Sender: TObject);
begin
  if assigned(syllables) then syllables.free;
  syllables:=TSyllables.create(dir,true, true);
end;

{************ LookupBtnClick **********88}
procedure TForm1.LookupBtnClick(Sender: TObject);
var
  s, msg:string;
  byRuleNbr:integer;
begin
  memo9.visible:=false;
  if not assigned(syllables) then syllables:= Tsyllables.create(dir,false,true);
  if syllables.getsyllables(edit1.Text, 0, s, byRuleNbr)
  then
  begin
    if byrulenbr>0
    then msg:=makerulemsg(byrulenbr,edit1.Text,s)
    else msg:=format('From list match'+#13+'%s=%s',[edit1.text,s]);
    lookuplbl.caption:=msg; //format('%s=%s '+#13+'(%s)',[edit1.text,s,msg]);
  end
  else
  begin
    lookuplbl.caption:=edit1.Text+' not found';
    memo1.Lines.add(edit1.Text+'='+Edit1.Text);
  end;

end;

(************ MakeRuleMsg *************)
function Tform1.makerulemsg(rulenbr:integer; w,w2:string):string;
{A single integer is used to identify the higest level rule used in syllabizing.
 a word.  Suffix rules are returned un changed, prefix rules are incrreased by
 100 and Compound words increased by 1000.  MakeRuleMsg decodes the coded rule
 number for reporting to the specific rule used back to the user. }
var
  id, msg:string;
  offset:integer;
begin
  offset:=0;
  if (rulenbr<100) then id:='S'
  else if rulenbr<200 then begin id:='P'; dec(rulenbr,100); end
  else if rulenbr=1000 then id:='C'
  else if rulenbr<1100 then begin id:='S'; dec(rulenbr,1000); end
  else if rulenbr<1200 then begin id:='P'; dec(rulenbr,1100); end
  else if rulenbr=2000 then id:='C'
  else id :='?';
  if (id='P') or (id='S') then
  with rulegrid do
  begin {get to correct row in rule grid to add sample of rule}
    if id='P' then offset:= 1
    else if id='S' then offset:= nbrprefixrules+2;
    if cells[4,rulenbr+offset]='' then cells[4,rulenbr+offset]:= w;
    msg:=format('#%s%d',[id, rulenbr]);
  end
  else if id='C' then msg:='Compound';
  result:=(format('From rule %s: %s=%s',[msg,w,w2]));
end;

{**************** ScanDicBrnClick ***************}
procedure TForm1.ScanDicBtnClick(Sender: TObject);
var
  w:string;
  A,F,C:boolean;
  msg:string;
begin
  memo9.Visible:=false;
  if assigned(syllables) then syllables.free;
  syllables:=TSyllables.create(dir,false,true);
  screen.cursor:=crhourGlass;
  memo1.Clear;
  memo2.clear;

  with syllables do
  {Load a dictionary}
  with pubdic do
  begin
    rulecount:=0;
    wordcount:=0;
    matchedcount:=0;
    compoundcount:=0;
    errcount:=0;
    case choosedicgrp.itemindex of
      0: loadsmalldic;
      1: loadmediumdic;
      2: loadlargedic;
    end;
    if dicloaded then
    begin
      setrange('a',3,'z',15);
      while getnextword(w, A,F,C) do
      begin
        If (not A) and (not F) and (length(w)>2)
        then CheckWord(w);
      end;
    end;
  end;
  scrolltotop(memo1);
  scrolltotop(memo2);
  screen.cursor:=crDefault;
  if errcount=1 then msg:='word was' else msg:='words were';
  showmessage(format('%.0n non-abbreviation, non-foreign words scanned from dictionary.'
                    +#13+'%.0n words were syllabized by match to syllable list.'
                     +#13+'%.0n words were syllabized by rules.'
                    +#13+'%.0n %s not syllabized by either method.',
                  [0.0+wordcount, 0.0+matchedcount, 0.0+rulecount, 0.0+errcount, msg]));
end;

{************** CheckWord ************}
procedure TForm1.CheckWord(w:string);
  var
    msg:string;
    w2:string;
    begin
      inc(wordcount);
      ruleNbr:=0;
      if syllables.GetSyllables(w, 0, w2, RuleNbr) then
      begin
        if RuleNbr>0 then
        begin
          msg:=makerulemsg(rulenbr,w,w2);
          if rulebox.Checked
          then  memo2.Lines.add(msg);
          inc(rulecount);
        end
        else inc(matchedcount);
      end
      else
      begin
        memo1.Lines.add(format('%s=%s',[w,w]));
        inc(errcount);
        if memo1.Lines.Count mod 256=0 then application.processmessages;
      end;
    end;

{********* Edit1KeyUp ************}
procedure TForm1.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Initialte lookup search if user presses Enter key after keying in the word}
begin
  if key=vk_return then lookupbtnclick(sender);
end;

const
  validchars:set of char =['a'..'z'];

(*********** ScanTextBtnClick ***************)
procedure TForm1.ScanTextBtnClick(Sender: TObject);

  function getword(var line:string):string;
  var
    i,start:integer;
    len:integer;
  begin
    result:='';
    len:=length(line);
    if len>0 then
    begin
      if line[len]<>' ' then  line:=line+' ';
      len:=length(line);
      start:=1;
      while (start<=len)  and (not (line[start] in  validchars)) do inc(start);
      i:=start+1;
     // while (i<=len)  and (not (line[i] in  validchars)) do inc(i);
      while (i<=len)  and (line[i] in  validchars) do inc(i);
      result:=copy(line,start,i-start);
      delete(line,1,i);
    end;
  end;

var
  f:textfile;
  line:string;
  w:string;
  msg:string;

begin  {ScanTextBtnClick}
  if opendialog1.execute then
  begin
    assignfile(f,opendialog1.filename);
    reset(f);
    memo9.Visible:=false;
    if assigned(syllables) then syllables.free;
    syllables:=TSyllables.create(dir,false,true);
    screen.cursor:=crhourGlass;
    memo1.Clear;
    memo2.clear;
    with syllables do
    begin
      rulecount:=0;
      wordcount:=0;
      matchedcount:=0;
      compoundcount:=0;
      errcount:=0;
      while not eof(f) do
      begin
        readln(f,line);
        line:=lowercase(line);
        repeat
          w:=getword(line);
          if length(w) >2 then CheckWord(w);
        until w='';
      end;
    end;
    scrolltotop(memo1);
    scrolltotop(memo2);
    screen.cursor:=crDefault;
    if errcount=1 then msg:='word was' else msg:='words were';
    showmessage(format('%.0n non-abbreviation, non-foreign words scanned from dictionary.'
                      +#13+'%.0n words were syllabized by match to syllable list.'
                       +#13+'%.0n words were syllabized by rules.'
                      +#13+'%.0n %s not syllabized by either method.',
                    [0.0+wordcount, 0.0+matchedcount, 0.0+rulecount, 0.0+errcount, msg]));

    end;
  closefile(f);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
