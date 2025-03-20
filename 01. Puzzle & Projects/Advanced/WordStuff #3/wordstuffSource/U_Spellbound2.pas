Unit U_Spellbound2;
{Copyright 2010, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{An anagram solver}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
   Dialogs, UDict, StdCtrls, ComCtrls, ExtCtrls, Menus, shellapi, UcomboV2,
  Spin;

type
  AnyString=ansistring;
  CharSet=Set of Char;

  TSpellboundform = class(TForm)
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    Useabbrevs: TMenuItem;
    Useforeign: TMenuItem;
    Usecaps: TMenuItem;
    StaticText1: TStaticText;
    ChangeDictionary1: TMenuItem;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    DicLbl: TLabel;
    Memo1: TMemo;
    LettersEdt: TEdit;
    UpDown1: TUpDown;
    WordLengthEdt: TEdit;
    LoadDicBtn: TButton;
    GenerateBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    CompSheet: TTabSheet;
    TimeLbl: TLabel;
    StopBtn: TButton;
    Edit1: TEdit;
    Label5: TLabel;
    UserWordList: TMemo;
    Memo3: TMemo;
    SearchBtn: TButton;
    ScoreLbl: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    procedure SearchBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure LoadDicBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure optionchange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure GenerateBtnClick(Sender: TObject);
    procedure Edit1DblClick(Sender: TObject);
    procedure WordLengthEdtChange(Sender: TObject);
    procedure LettersEdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    currword:ansistring;
    combos2:TComboset;
    SearchWordLength:integer;  {word length to find}
    CurWord:ansistring;
    limit:integer;
    starttime,stoptime:tdatetime;
    CurPermuteLength:integer;
    curpermute:ansistring;
    firsttime:boolean;
    {word lists}
    BaseWords,PermuteWords:TStringList;
    MaxLenWordList:TStringlist;
    alphacounts:array['a'..'z'] of integer;


    Function GetInputString:boolean;
    Procedure Resetcalc;  {Set up to start next OnIdleExit search}
    Procedure Startcalc;
    function getletterstotest:ansistring;
    procedure FindWordIdle(sender:TObject; var Done:boolean);
    procedure UpdateScore;
  end;

var
  Spellboundform: TSpellboundform;

implementation

 {$R *.DFM}



 {*********** SortString ***********}
 procedure SortString(var SortSt : ansistring);
 {inplace sort the potential first letters ansistring in ascending sequence}
   var
     InOrder: Boolean;
     I: Integer;
     C: Char;
   begin
     If length(sortst)>1 then
     {exchange sort - swap out-of-order pairs until no more swaps needed}
     repeat
       Inorder := True;
       for I := 0 to Length(SortSt)-2 do
       if Ord(SortSt[I]) > Ord(SortSt[I+1]) then
       begin
         {swap letters I and I+1}
         Inorder := False;
         c:=sortst[i];
         sortst[i]:=sortst[i+1];
         sortst[i+1]:=c;
       end;
     until InOrder;
   end; { procedure SortString }

{************* FormCreate ************}
procedure TSpellboundform.FormCreate(Sender: TObject);
begin
  BaseWords:=TStringlist.create;
  Basewords.Sorted:=true;
  PermuteWords:=TStringlist.create;
  permutewords.sorted:=true;
  combos2:=TComboset.create;
  MaxLenWordList:=TStringlist.create;
  randomize;
end;

{*************** TSpellBoundForm.FormActivate ************}
procedure TSpellboundform.FormActivate(Sender: TObject);
begin
  If application.mainform=self then
  begin
    if not assigned(pubdic) then pubDic:=TDic.Create(false);
    if not pubdic.dicloaded  then pubdic.LoadDefaultDic;
    with pubdic do
    diclbl.caption:=format('Current Dictionary:%s (%d entries)',
          [dicname,getdicsize]);
    loaddicbtn.visible:=true;
  end
  else
  with pubdic do diclbl.caption:=format('Current Dictionary:%s (%d entries)',
                       [dicname,getdicsize]);
  stopbtn.visible:=true;
  ResetCalc;
  StartCalc;
end;

{************** TSpellBoundForm.GetInputString ***********}
Function TSpellboundform.GetInputString:boolean;
var
  errorcode:integer;
  totlength:integer;
begin
  result:=false;
  Curword:=LettersEdt.text;
  Totlength:=length(CurWord);
  If totlength>=3 then
  begin
    val(WordLengthEdt.text,SearchWordLength,errorcode);
    If (errorcode>0) or (SearchWordLength<3) or (SearchWordLength>length(curword))  then
    Begin
      Showmessage('Enter search word length between 3 and '+inttostr(totlength));
      exit;
    End
    else result:=true;
  end
  else showmessage('Enter a string from 3 to 7 letters for search');
end; {GetInputString }

{************* ResetCalc ************}
procedure TSpellboundForm.ResetCalc;
begin
  userwordlist.Lines.clear;
  memo3.lines.clear;
  TimeLbl.caption:='';
  updatescore;
  firsttime:=true;
  permutewords.clear;
  curpermute:='';
  if  GetinputString then
  begin
    application.ProcessMessages;
    if SearchWordLength>5 then limit:=5 else limit:=SearchWordLength;
    CurPermuteLength:=SearchWordLength;
    combos.setup(CurPermuteLength,length(curword),combinations);
    basewords.Clear;
    application.OnIdle:=nil;
    curpermute:=getletterstoTest;  {get the first set of letters to test}
  end;
end;

{************** StartCalc **********}
procedure TSpellboundForm.Startcalc;
begin
  starttime:=time;
  stopbtn.visible:=true;
  stopbtn.tag:=0;
  application.OnIdle:=FindWordIdle;
end;

{************* GetLettersToTest *************}
function TSpellBoundForm.getletterstotest:ansistring;
var
  i,j,index:integer;
  ch,firstch,lastch:char;
  w:ansistring;
  a,f,c:boolean;
  done:boolean;
begin
  result:='';
  if stopbtn.tag<>0 then exit;
  if curpermutelength<=5 then
  begin
    with combos do
    if Getnext then
    begin {get all sets of "CurPermuteLength" letters from the given letters (curword)}
      result:=curword[selected[1]];
      for j:=2 to curpermutelength do result:=result+curword[selected[j]];
      sortstring(result);
      if not basewords.find(result,index) then
      begin
        //if stopbtn.tag>0 then exit;
        basewords.add(result);  {This a unque set of "i" letters chosen from "curword"}
        combos2.setup(curpermutelength,curpermutelength,permutations);
        permutewords.clear;
      end;
    end
    else
    begin
      if CurPermuteLength<=limit then
      begin
        combos.setup(CurPermuteLength,length(curword),combinations);
        basewords.Clear;
        curpermute:=getletterstoTest;
      end;
    end;
  end
  else
  if CurPermuteLength<=SearchWordLength then {length>limit but less than or equal to SearchWordLength}
  begin  {for words of 6 or 7, it is faster to to check the dictionary words
            against the available letters  (not many matches)}
              {get the set of available letters in the input letters}
    if firsttime then
    begin
      for ch:='a' to 'z' do alphacounts[ch]:=0;
      firstch:='z';
      lastch:='a';
      for i:=1 to length(curword) do
      begin
        inc(alphacounts[curword[i]]);
        if curword[i]<firstch then firstch:=curword[i]
        else if curword[i]>lastch then lastch:=curword[i];
      end;
      {for each word of the required length in the dictionary, check to see if it
       can be found in the available letters, if it can, list it}
      pubdic.setrange(firstch,curpermutelength, lastch,curpermutelength);
      firsttime:=false;
    end;

    if (pubdic.GetnextWord(w,a,f,c)) {and (stopbtn.tag=0)} then
    begin
      done:=false;
      repeat
        if (not done) and (useforeign.checked or (not f)) and
                            (usecaps.checked or (not c)) and
                            (useabbrevs.checked or (not a))
         then
         begin
           result:=w;
           done:=true;
         end {found a word, return it}
         else {the word doesn't meet the A,F,C condition, try thre next}
           done := (not pubdic.GetnextWord(w,a,f,c)) {or (stopbtn.tag<>0)};
      until done;
    end;
  end;
end;

{********** FindWordIdle ************}
procedure TSpellboundForm.FindWordIdle(sender:TObject; var done:boolean);
var
  i,j:integer;
  w:ansistring;
  index:integer;
  a,f,c:boolean;
  testcounts:array['a'..'z'] of integer;
  ok:boolean;
  ch:char;

   procedure wrapup; {call when done processing}
   begin
     done:=true;
     stopbtn.visible:=false;
     stoptime:=time;
     application.onidle:=nil;
     Timelbl.caption:=format('Search complete, %6.2f',[(time-starttime)*secsperday]);
   end;


begin
  if (length(curpermute)=0) or (stopbtn.tag<>0) then begin wrapup; exit; end;
  done:=false;
  if length(curpermute)<=5 then
  begin
    with combos2 do
    if getnext then
    begin
      w:=curpermute[selected[1]];
      for j:=2 to curpermutelength do w:=w+curpermute[selected[j]];
      begin
        if not permutewords.find(w,index) then
        begin {we haven't tested this string yet}
          permutewords.add(w);
          if pubdic.lookup(w,a, f,c)
          then
          if (useabbrevs.checked or (not a)) and
             (useforeign.checked or (not f))and
             (usecaps.checked or (not c))
          then
          begin
            if memo3.lines.indexof(w) <0  then
            begin
              memo3.Lines.add(w);
              Timelbl.caption:=format('Still searching, %6.2f',[(time-starttime)*secsperday]);
              UpdateScore;
            end;
          end;
        end;
      end;
    end
    else curpermute:=getletterstotest; {get a new set of letters for next entry}
  end
  else  {Length>5}
  begin
    for i:= 1 to length(curpermute) do  testcounts[curpermute[i]]:=0;
    ok:=true;
    for i:=1 to length(curpermute) do
    begin
      ch:=curpermute[i];
      inc(testcounts[ch]);
      if testcounts[ch] > alphacounts[ch] then
      begin
        ok:=false;
        break;
      end;
    end;
    if ok and (memo3.lines.indexof(curpermute)<0) then
    begin
      memo3.lines.add(curpermute);
      updatescore;
    end;
    curpermute:=getletterstotest;
  end;
  if length(curpermute)=0 then wrapup;
end;

{************** UpdateScore ***********}
procedure TSpellBoundForm.UpdateScore;
begin
  scorelbl.caption:=format('Score: User %d  Computer %d', [
           Userwordlist.lines.count, memo3.lines.count]);
end;


{************** SearchbtnClick **********}
procedure TSpellboundform.SearchBtnClick(Sender: TObject);
begin
  resetcalc;
  startcalc;
end;

{************** TSpellBoundForm.StopBtnClick **********}
procedure TSpellboundform.StopBtnClick(Sender: TObject);
begin
  {set stop flag;}
  Stopbtn.tag:=1;
end;

{***************** TSpellBoundForm.LoadBtnClick **********}
procedure TSpellboundform.LoadDicBtnClick(Sender: TObject);
{load a different dictionary}
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    with pubdic do
    begin
      loadDicFromFile(filename);
      diclbl.caption:=format('Spellbound - Current Dictionary:%s (%d entries)',
          [dicname,getdicsize]);
      Searchbtnclick(sender);
    end;
  end;
end;

{************* OptionChange ********}
procedure TSpellboundform.Optionchange(Sender: TObject);
{Check or uncheck abbrev, foreign, & caps options}
begin
   with sender as tmenuitem do  checked:= not checked;
end;

{**************** LettersEdtKeyPress ************}
procedure TSpellboundform.Edit1KeyPress(Sender: TObject;
  var Key: Char);
{Make Enter key act to register the user word}
begin
  If ord(key)=13 then
  begin
    key:=char(0);
    Edit1DblClick(sender);
  end;
end;

{**************** LettersEdtKeyPressd *********8}
procedure TSpellboundform.LettersEdtKeyPress(Sender: TObject;
{User is entering a set of letters from which to form words}
{If Enter is pressed, start the program background search for words}
  var Key: Char);
begin
  If ord(key)=13 then
  begin
    key:=char(0);
    SearchBtnClick(Sender);
  end;
end;


{************ GenerateBtnClick *********8}
procedure TSpellboundform.GenerateBtnClick(Sender: TObject);
{Generate a set of letters by scrambling a random 7 letter word}
var
  i,n:integer;
  w:ansistring;
  a,f,c:boolean;

  procedure swap(i,j:integer);
  var ch:char;
  begin  {swap letters i and j in word "w"}
    ch:=w[i];
    w[i]:=w[j];
    w[j]:=ch;
  end;

begin
  If MaxLenWordList.count=0 then
  with pubdic do
  begin  {initialize the list with all 7 letter words}
    Setrange('a',7,'z',7);
    while getnextword(w,a,f,c) do
    if (useabbrevs.checked or (not a)) and
         (useforeign.checked or (not f))and
         (usecaps.checked or (not c))
     then MaxLenWordList.add(w);
  end;
  n:=MaxLenWordList.Count;
  w:=MaxLenWordList[random(n)];  {choose a random 7 letter word}
  {scramble the letters}
  for i:=1 to 7 do swap(i,random(7)+1);
  lettersedt.Text:=w;
  SearchbtnClick(sender)
end;

{***************** Edit1DblClick *************8}
procedure TSpellboundform.Edit1DblClick(Sender: TObject);
{User has entered a word" and wants to record it}
var
  w:ansistring;
  a,c,f:boolean;
  index:integer;
begin
  w:=edit1.text;
  if pubdic.lookup(w,a,c,f) then
  begin
    index:=userwordlist.lines.indexof(w);
    if index<0 then
    begin
      userwordlist.lines.add(w);
      edit1.text:='';
      updatescore;
    end
    else showmessage('That word is already in your list!');
  end
  else showmessage('Sorry, I do not know that word');
end;

{************ WordLengthEdtChange ************}
procedure TSpellboundform.WordLengthEdtChange(Sender: TObject);
begin
  if  (updown1.position>=3) and (updown1.position<=7)
  then SearchbtnClick(Sender);
end;

procedure TSpellboundform.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.





