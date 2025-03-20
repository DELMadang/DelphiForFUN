unit U_Unscramble;
{Copyright 2001-2009, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{An anagram solver} 

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
   Dialogs, UDict, StdCtrls, ComCtrls, ExtCtrls, Menus, shellapi,
   uComboV2, UIntegerPartition, math, CheckLst;

type
  AnyString=ansistring;
  CharSet=Set of Char;

  {"TWords" object passes the dictionary words against a set of letters
   retieving by first letter and length.
   For each word found, a check is made to see if it matches
   1-1 with the letters required
  }


  Twords=class(tcontrol)
  {a class to search for dictionary entries matching a set of letters}
  public
    Curword,CapWord,FirstletterSt:ansistring;
    NextsearchPos:word;
    Len,Minlen,MaxLen:word;
    Rest:ansistring;
    useabbrevs,useforeign,usecaps:boolean;
    {find all words between specified lengths contained in letters provided}
    Procedure Init(newletters:ansistring;NewMinLen,NewMaxLen:word;
                    newa,newf,newc:boolean);

    Function GetNext(Dic:TDic;Var Validword:ansistring):boolean;

  End;

  TUnscrambleForm = class(TForm)
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    LettersEdt: TEdit;
    UpDown1: TUpDown;
    MinLengthEdt: TEdit;
    MaxLengthEdt: TEdit;
    UpDown2: TUpDown;
    SearchBtn: TButton;
    NbrWordsGroup: TRadioGroup;
    StopBtn: TButton;
    StaticText1: TStaticText;
    Label7: TLabel;
    LoadDicBtn: TButton;
    DicLbl: TLabel;
    Memo1: TMemo;
    InterlacedBox: TCheckBox;
    Label8: TLabel;
    CheckListBox1: TCheckListBox;
    Label9: TLabel;
    procedure SearchBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure NbrWordsGroupClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure LoadDicBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure optionchange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure LettersEdtKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure LettersEdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    c:TWords;
    Function GetInputString:boolean;
    Procedure SolveScrambled;
    procedure SolveInterlaced;
  end;

var
  UnscrambleForm: TUnscrambleForm;
  Y:integer;
  NbrWords:Integer;

implementation

 {$R *.DFM}

Var
  MinWordLen, MaxWordLen:integer;
  ValidWordChar  :  CharSet;
  CurWord:ansistring;
  LengthFirstLetterSt:Word;
  Totlength:word;
  {word lists}
  FirstWords,SecondWords,remainders,remainders2:TStringList;

 procedure SortString(var SortSt : ansistring);
 {sort the potential first letters ansistring in ascending sequence}
   var
     InOrder: Boolean;
     I: Integer;
     C: Char;
   begin
     If length(sortst)>0 then
     {exchange sort - swap out-of-order pairs until no more swaps needed}
     repeat
       Inorder := True;
       for I := 1 to Length(SortSt)-1 do
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



 {**************** TWORDS.INIT **********************}
 Procedure TWords.Init(newletters:ansistring;NewMinLen,NewMaxLen:Word;
                       newA,newF,newC:boolean);
   {Initialize dictionary with an array of firstletters
    and max and min word lengths}
   var
     ValidFirstChar : Charset;
     I, J           : Integer;
   begin {INIT}
      ValidFirstChar := ['a'..'z'];
      Curword:=Newletters;
      Len := Length(CurWord);
      MinLen:=NewMinLen;
      MaxLen:=NewMaxLen;
      useabbrevs:=newA;
      useforeign:=newf;
      usecaps:=newC;
      Capword := lowercase(newletters);
      FirstLetterSt := '';
      for I := 1 to Len do
         if (Pos(CapWord[I],FirstLetterSt) = 0) and
            (CapWord[I] in ValidFirstChar) then
            FirstLetterSt := FirstLetterSt + CapWord[I];
      LengthFirstLetterSt:=length(FirstLetterSt);
      SortString(FirstLetterSt);
      ValidWordChar := [];
      for J := 1 to len do
            ValidWordChar := ValidWordChar + [CapWord[J]];
      NextSearchPos:=1;
      if application.mainform=owner then
      begin
        If pubdic.dicloaded then
          pubDic.SetRange(FirstLetterSt[NextSearchPos],MinLen,FirstLetterSt[NextSearchPos],MaxLen);
      end
      else
      begin
        If pubdic.dicloaded then
        PubDic.SetRange(FirstLetterSt[NextSearchPos],MinLen,FirstLetterSt[NextSearchPos],MaxLen);
        If privdic.dicloaded then
        PrivDic.SetRange(FirstLetterSt[NextSearchPos],MinLen,FirstLetterSt[NextSearchPos],MaxLen);
      end;
      Rest:='';
   end; { procedure Init}



{****************   TWORDS.GETNEXT ************************}
Function TWords.GetNext(Dic:TDic; Var Validword:ansistring):boolean;
{ Get the next word that contains all of the letters in validword
 If found, Return the resulting word in Validword with result=true
 else return '' and result=false
}
   {********** GETNEXTMATCH (in Getnext) ***********************}
   {Gets a word with all letters in the ValidWordChar set}
   Procedure GetNextMatch(var NextWord : ansistring);
   var
     I              : Integer;
     Match          : Boolean;
     l:word;
     a,f,c:boolean;
   begin
     match:=false;
     repeat
       if not Dic.GetNextWord(NextWord,a,f,c) then nextword:='';
       L:=length(nextword);

       if (( not a) and (not  f) and (not c))
           or (a and useabbrevs)
           or (f and useforeign)
           or (c and usecaps)
       then
       begin
         if L = 0 then Match := False else match:=true;
         I := 1;
         while (I <= L) and Match do
         begin
           if (not ((NextWord[I]) in ValidWordChar))
           then Match:=False;
           inc(I);
         end;
       end;
     until Match or (L = 0);
     if match and c
     then nextword[1]:=upcase(nextword[1]);
   end; { procedure GetNextmatch}

   {**************  VALIDMATCH (in GetNext) *************}
   {Makes sure that all letters in dicword are
    in letters being checked match 1-1 and returns
    leftover letters in rest}
   function ValidMatch(DictWord : ansistring) : Boolean;
   var
     WorkCurWord    : ansistring;
     WorkDictWord   : ansistring;
     Position       : Integer;
     Found:boolean;
   begin
      WorkCurWord  := CapWord;
      WorkDictWord := lowercase(DictWord);
      Found:=true;
      repeat
         Position := Pos(WorkDictWord[1],WorkCurWord);
         if Position > 0 then
         Begin
           Delete(WorkCurWord,Position,1);
           Delete(WorkDictWord,1,1);
         End
         Else found:=false;
      until (WorkDictWord = '') or (found=false);
      ValidMatch := Found;
      Rest:=WorkCurword;
    end; { function ValidMatch }

  Var
    WordWasFound:Boolean;
  Begin  {Getnext}
    WordWasFound := False;
    If NextSearchPos<= LengthFirstLetterSt then
    While (NextSearchPos<=LengthFirstLetterSt) and (Not WordWasFound) do
    begin
      repeat
        GetNextMatch(ValidWord);
        if (length(validword)>0)  and (ValidMatch(ValidWord))
        then WordWasFound := True;
      until (Length(ValidWord) = 0) or (WordWasFound);
      If Length(ValidWord)=0 Then
      Begin
        NextSearchPos:=Succ(NextSearchPos);
        Dic.Setrange(FirstLetterSt[NextSearchPos],MinLen,FirstLetterSt[NextSearchPos],MaxLen);
      End;
    End;
    result:=wordwasfound;
  End; {getnext}

{************* TUnscramblForm.FormCreate ************}
procedure TUnscrambleForm.FormCreate(Sender: TObject);
begin
  c:=TWords.create(self);
  firstwords:=TStringlist.create;
  Secondwords:=TStringlist.create;
  remainders:=TStringlist.create;
  remainders2:=TStringlist.create;
end;

{*************** TUnscrambleForm.FormActivate ************}
procedure TUnscrambleForm.FormActivate(Sender: TObject);
begin
   If application.mainform=self then

   begin
     if not assigned(pubdic) then pubDic:=TDic.Create(false);
     if not pubdic.dicloaded  then pubDic.LoadDefaultDic;
     caption:='Unscramble Version 2.3.1 - Dictionary: '+ pubdic.dicname;
     with pubdic do
     diclbl.caption:=format('Current Dictionary:%s (%d entries)',
          [dicname,getdicsize]);
     loaddicbtn.visible:=true;
   end
   else
   with pubdic do
   begin
     diclbl.caption:=format('Current Dictionary:%s (%d entries)',
          [dicname,getdicsize]);
   end;
end;

{************** TUnscrambleform.GETINPUTSTRING ***********}
Function TUnscrambleForm.GetInputString:boolean;
var
  i,errorcode:integer;
begin
   result:=true;
   Curword:=LettersEdt.text;
   for i:=length(curword) downto 1 do if not (upcase(curword[i]) in ['A'..'Z'])
   then delete(curword,i,1);
   if length(curword)<> length(lettersEdt.text) then LettersEdt.text:=curword;
   Totlength:=length(CurWord);
   If totlength>0 then
   Begin
     val(MinLengthEdt.text,MinWordLen,errorcode);
     If (errorcode=0)
         and ((MinWordLen<0)
            or (MinWordLen>Totlength)) then errorcode:=999;
     If errorcode>0 then
     Begin
       Showmessage('Enter valid min length between 0 and number of letters');
       exit;
     End;
     val(MaxLengthEdt.text, MaxWordLen, errorcode);
     If (errorcode=0)
         and ((MaxWordLen<MinWordLen)
            or (MinWordLen>Totlength)) then errorcode:=999;
     If errorcode>0 then
     Begin
       Showmessage('Enter valid max length between minlength and number of letters');
       exit;
     End;
   End;
   result:=true;
end; {GetInputString }

{----------- SwapStr two strings ------------}
 procedure swapStr(var s1,s2:ansistring);
 var
   test:ansistring;
 begin
   test:=s1;
   s1:=s2;
   s2:=test;
 end;

{********** TUnscrambleForm.SolveScrambled *****************}
{Original version - pass dictionary words against input}
procedure TUnscrambleForm.SolveScrambled;
    {------------- GetMatchingWords ----------------}
    Procedure getmatchingwords(wordlist,remainderlist:TStringlist);
    {scan for valid words within some preset range - add remaniders to 2nd list}
    var
      w:ansistring;
    begin
        if application.mainform = self then
        begin
          if pubdic.dicloaded then
          While (c.Getnext(pubdic,w))  and (stopbtn.tag=0) do
          Begin
            wordlist.add(w);
            remainderlist.add(c.rest);
          End;
        end
        else
        begin
          if pubdic.dicloaded then
          While (c.Getnext(pubdic,w))  and (stopbtn.tag=0) do
          Begin
            wordlist.add(w);
            remainderlist.add(c.rest);
          End;
          if privdic.dicloaded then
          While c.Getnext(privdic,w)  and (stopbtn.tag=0)  do
          Begin
            wordlist.add(w);
            remainderlist.add(c.rest);
          End;
        end;
    end;

    {----------- AddSorted ------------}
    procedure addsorted(ins:ansistring);
    {break the words ansistring back into individual words,
     sort them, and rebuild the ansistring to add to memo1.lines if unique}


    var
      w:array[1..3] of ansistring;
      i,n:integer;
      s, newS:ansistring;
    begin {AddSorted}
      s:=trim(ins)+' ';
      i:=0;
      repeat
        n:=pos(' ',s);
        if n>0 then
        begin
          inc(i);
          w[i]:=copy(s,1,n);
          delete(s,1,n);
        end;
      until length(s)=0;
      newS:='';
      case i of
      1: news:=trim(w[1]);
      2: begin
           if w[1]>w[2] then swapstr(w[1],w[2]);
           news:=w[1]+trim(w[2]);
         end;
      3: begin
           if w[1]>w[2] then swapstr(w[1],w[2]);
           if w[1]>w[3] then swapstr(w[1],w[3]);
           if w[2]>w[3] then swapstr(w[2],w[3]);
           news:=w[1]+w[2]+trim(w[3]);
         end;
      end; {case}
      if memo1.lines.indexof(newS)<0
      then memo1.lines.add(newS);
    end;

    {------------- ExtractLastWords --------------}
    function extractlastwords(prefixword, useletters:ansistring):boolean;
    {get the final words - using all remaining letters and add to list}
      var
        len:integer;
        w:ansistring;
      begin
         result:=false;
         len:=length(useletters);
         if len=0 then exit;
         with CheckListBox1 do c.init(useletters,Len,Len,
                      checked[0],checked[2],checked[1]);
         if application.mainform=self then
         begin
           If pubdic.dicloaded then
           While (c.Getnext(pubdic,w)) and (stopbtn.tag=0) do
           Begin
             //memo1.lines.add(prefixword+' '+w);
             addsorted(prefixword+' '+w); {new: sort to eliminate duplicate sets}
           End;
         end
         else
         begin
           If pubdic.dicloaded then
           While (c.Getnext(pubdic,w)) and (stopbtn.tag=0) do
           Begin
             //memo1.lines.add(prefixword+' '+w);
             addsorted(prefixword+' '+w); {new: sort to eliminate duplicate sets}
           End;
           If privdic.dicloaded then
           While c.Getnext(privdic,w)  and (stopbtn.tag=0) do
                       memo1.lines.add(prefixword+' '+w);
         end;
          application.processmessages;
          result:=stopbtn.tag=0;
       end;



var
  I,j  : Integer;
  L:Word;
  starttime,stoptime:tdatetime;

begin {SolveScrambled}
  firstwords.clear;
  Secondwords.clear;
  remainders.clear;
  remainders2.clear;
  if  GetinputString then
  Begin
    starttime:=time;
    memo1.clear;
    with CheckListBox1 do c.init(curword,MinWordLen,MaxWordLen,
              checked[0],checked[2],checked[1]);
    with stopbtn do
    begin
      top:=Searchbtn.top;
      left:=Searchbtn.Left;
      visible:=true;
      tag:=0;
    end;

    If NbrWords=1 then
    begin
      if minwordlen=length(curword) then
      begin
        firstwords.add(curword);
        MinWordLen:=1;
        If firstwords.count=0 then memo1.lines.add('No words found')
        else
        For i:= 0 to Firstwords.count-1 do
        begin
          if not extractlastwords('',firstwords[i]) then break;
        end;
      end
      else
      begin  {extract single words less than input word length}
        if MinWordLen=0 then MinWordLen:=1;
        with CheckListBox1 do c.init(curword,MinWordLen,MaxWordLen,
               checked[0],checked[2],checked[1]);
        if (MaxWordLen>0) and (length(curword)>0) then
        begin
          getmatchingwords(firstwords,remainders);
          If firstwords.count=0 then memo1.lines.add('No words found')
          else
          for i:= 0 to firstwords.count-1 do  memo1.lines.add(firstwords[i]);

        end;
      end
    end
    else If NbrWords=2 then
    begin
      if MinWordLen=0 then MinWordLen:=1;
      with CheckListBox1 do c.init(curword,MinWordLen,MaxWordLen,
             checked[0],checked[2],checked[1]);
      if (MaxWordLen>0) and (length(curword)>0) then
      begin
        getmatchingwords(firstwords,remainders);
        If firstwords.count=0 then memo1.lines.add('No words found')
        else
        for i:= 0 to firstwords.count-1 do
          if not extractlastwords(firstwords[i],remainders[i]) then break;
      end;
    end
    else If NbrWords=3 then
    begin
      if MinWordLen=0 then MinWordLen:=1;
      with CheckListBox1 do c.init(curword,MinWordLen,MaxWordLen,
            checked[0],checked[2],checked[1]);
      if (MaxWordLen>0) and (length(curword)>0) then
      begin
        getmatchingwords(firstwords,remainders);
        If firstwords.count>0 then
        for i:= 0 to Firstwords.count-1 do
        begin
          l:=length(remainders[i]);
          if l>0 then
          begin
            with CheckListBox1 do c.init(remainders[i],MinWordLen,MaxWordLen,
                       checked[0],checked[2],checked[1]);
            secondwords.clear;
            remainders2.clear;
            getmatchingwords(secondwords,remainders2);

            For j:= 0 to Secondwords.count-1 do
              if not extractlastwords(firstwords[i]+' '+secondwords[j],
                                remainders2[j]) then break;
          end;
          application.processmessages;
        end;
      end;
    end;
    stoptime:=time;
    Label5.caption:=formatfloat('###.##',24*3600*(stoptime-starttime))+' seconds';
    memo1.lines.Add(inttostr(memo1.lines.count)+' Qualified word sets found');

    memo1.invalidate;  {force redraw  to show top of list}

  end;
  stopbtn.visible:=false;
end; {SolveScrambled }

type
TInterlaced=class(TObject)
  positions:array of integer
end;

{********** TUnscrambleForm.SolveInterlaced *****************}
{Original version - pass dictionary words against input}
procedure TUnscrambleForm.SolveInterlaced;

{------------- GetNextWord --------------}
function getnextword(combos:TComboset;
                    letters:ansistring;
                    const size:integer;
                    var w:ansistring;
                    interlaced:TInterlaced):boolean;
  var
   i:integer;
 begin
   setlength(w,size);

   with combos do
   if getnext then
   begin
     result:=true;
     for i:=1 to size do
     begin
       w[i]:=letters[selected[i]];
       interlaced.positions[i-1]:=selected[i];
     end;
   end
   else result:=false;
 end;

 {---------- IsValidword ---------}
 function Isvalidword(s:ansistring):boolean;
 {Return true of "s" is in the dictionary}
 var
   a,f,c:boolean;   {want abbreviations, foreign, capitalizes?}
 BEGIN
   a:=false; f:=false; c:=false;  {No,No,No}
   result:=pubdic.lookup(s,a,f,c);
   if result then
   with checkListBox1 do
   if (a and (not checked[0])) or {(it's an abbreviation and user doesn't want}
      (c and (not checked[1])) or
      (f and (not checked[0]))
   then result:=false;
 end;

 {------------ Removveletters -----------}
 function removeletters(s:ansistring; interlaced:TInterlaced):ansistring;
 {Remove the letter positions indicated by "interlaced.postions" from "s"}
 var
   i:integer;
 begin
   result:=s;
   for i:=high(interlaced.positions) downto 0
   do delete(result,interlaced.positions[i],1);
 end;
var
  i,j,n,nn:integer;
  min,max:integer;
  letters,s:ansistring; {The input letters}
  w1,w2,w3:ansistring; {The words found}

  interlaced1:TInterlaced; {object containing letter locations so that they can be}
  interlaced2:TInterlaced;  {removed from input to continue checking }

  combos1,combos2:TComboset; {Holds combinations of letter positions to generate
                              trial words for 1st and 2nd words}
  starttime, stoptime:TDateTime;
  OK:boolean;
  sizes:array [1..3] of integer; {Partition sizes (ways to split the input
                                  letters into words) are arranged in "sizes"
                                  array from large to small with the idea that
                                  there are fewer of the larger words, so check
                                  them first}
begin
  //pubdic.loadlargedic;
  min:=updown1.position;
  max:=updown2.position;
  combos1:=TComboset.create;
  combos2:=TComboset.create;
  letters:=LettersEdt.Text;
  screen.Cursor:=crHourGlass;
  tag:=0;   {reset "stop" flag}
  stopbtn.Top:=searchbtn.top; {Hide the "Search" button}
  stopbtn.left:=searchbtn.left;
  stopbtn.visible:=true;
  interlaced1:=TInterlaced.Create;
  interlaced2:=TInterlaced.Create;
  starttime:=time;
  memo1.clear;
  n:=defpartition.partitioncount(length(letters),nbrwords);

  for i:=1 to n do {for all partitions of letters into "nbrwords" words}
  with defpartition do
  begin
    Unrank(length(letters), Nbrwords, i); {get next partition}
    OK:=true;
    for j:= 1 to high(p) do
    if (p[j]<min) or (p[j]>max) then {Are all lengths valid?}
    begin
      ok:=false; {No, ignore this partitioning}
      break;
    end;
    If OK then {partition elements are all between min and max word lengths}
    with combos1 do
    begin
      {sort by partition size}
      for j:=1 to nbrwords do sizes[j]:=p[nbrwords+1-j];
      if self.tag<>0 then break;
      Setup(sizes[1],length(letters),combinations);
      setlength(interlaced1.positions,sizes[1]);
      while (self.tag=0) and getnextword(combos1,letters, sizes[1],w1, interlaced1) do
      begin
        application.processmessages;
        if Isvalidword(w1) then
        begin  {word is in the dictionary}
          s:=removeletters(letters, interlaced1); {strip the word from input letters}
          nn:=length(s);
          if (nbrwords=2) and (nn>=min) and (nn<=max) and Isvalidword(s)
          then
          begin
            w2:=s; {only 2 words, all the remaining letters must be the 2nd word}
            if w1>w2 then swapstr(w1,w2);
            s:=w1+', '+w2;
            if memo1.lines.indexof(s)<0 then memo1.lines.add(s);
          end
          else if (nbrwords=3) and (nn>min) then
          begin
            //if sizes[2]<=nn-min then with combos2 do
            begin
              combos2.Setup(sizes[2],nn,combinations);
              setlength(interlaced2.positions,sizes[2]);
              while (self.tag=0) and getnextword(combos2,s, sizes[2],w2,interlaced2) do
              if Isvalidword(w2) then
              begin
                w3:=removeletters(s,interlaced2);
                if Isvalidword(w3)and (length(w1)+length(w2)+length(w3)=length(letters))  then
                begin
                  {sort words}
                  If w1>w2 then swapstr(w1,w2);
                  If w1>w3 then swapstr(w1,w3);
                  If w2>w3 then swapstr(w2,w3);

                  s:=format('%s, %s, %s',[w1,w2,w3]);
                  if memo1.lines.indexof(s)<0 then
                  memo1.lines.add(s);
                end;
              end;  {while loop for w2}
            end; {enough letters to form w2 and w3}
          end;   {Nbrwords=3}
        end; {if validword(w1)}
      end; {while loop for w1}
    end; {with defpartition}
  end;
  screen.Cursor:=crDefault;
  stopbtn.visible:=false;
  stoptime:=time;
  Label5.caption:=formatfloat('###.##',secsperday*(stoptime-starttime));
  with memo1,lines do
  begin
    if self.tag<>0 then add('Search interupted');
    Add(format('Run time %6.1f seconds',[(stoptime-starttime)*secsperday]) );
    invalidate;
  end;
  stopbtn.visible:=false;
end; {SolveInterlaced}

{************** TUnscrambleForm.SEARCHBTNCLICK **********}
procedure TUnscrambleForm.SearchBtnClick(Sender: TObject);
begin
  Cursor:=crhourglass;
  SearchBtn.cursor:=crhourglass;
  Nbrwords:=NbrWordsGroup.ItemIndex+1;
  If InterlacedBox.checked then solveInterlaced else SolveScrambled;
  cursor:=crdefault;
  SearchBtn.cursor:=crdefault;
end;

{***************** TUnscrambleForm.NbrWordsGroupClick *********}
procedure TUnscrambleForm.NbrWordsGroupClick(Sender: TObject);
Var
 Setting:boolean;
begin

  If NbrWordsGroup.Itemindex=0 then
  begin
    //setting:=false;
    MinLengthEdt.text:=inttostr(length(LettersEdt.text));
    MaxLengthEdt.text:=MinLengthEdt.text;
  end;
  setting:=true;
  {Disable a bunch of stuff if only one word}
  Label2.Enabled:=setting;
  Label3.Enabled:=setting;
  Label4.Enabled:=setting;
  MinLengthEdt.Enabled:=setting;
  MaxLengthEdt.Enabled:=setting;
  UpDown1.Enabled:=setting;
  UpDown2.Enabled:=setting;
end;

{************** TUnscramblform.StopBtnClick **********}
procedure TUnscrambleForm.StopBtnClick(Sender: TObject);
begin
  {set stop flag;}
  Stopbtn.tag:=1;
end;

{***************** TUnscrambleForm.LoadBtnClick **********}
procedure TUnscrambleForm.LoadDicBtnClick(Sender: TObject);
{load a different dictionary}
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    with pubdic do
    begin
      loadDicFromFile(filename);
      diclbl.caption:=format('Current Dictionary:%s (%d entries)',
          [dicname,getdicsize]);
    end;
  end;
end;

{********** LettersEdtKeyUp ************}
procedure TUnscrambleForm.LettersEdtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Len:integer;
begin
  //memo1.lines.add('Keypress1');
  Lettersedt.update;
  application.processmessages;
  Len:=length(LettersEdt.text);
  UpDown2.max:=max(len,1);
  updown2.position:=updown2.max;
  maxlengthedt.text:=inttostr(updown2.position);
  if nbrwords=1 {GDD 2/9/18- for single word,default to min = max}
  then updown1.position:=updown2.position
  else updown1.position:=min(updown1.position, updown2.position);
  If key=VK_RETURN then
  begin
    key:=0;
    SearchBtnClick(sender);
  end;
end;

{*********** UpDown2Click ***********}
procedure TUnscrambleForm.UpDown2Click(Sender: TObject;
  Button: TUDBtnType);
begin
  If updown2.position>length(LettersEdt.text) then updown2.position:=length(LettersEdt.text);
  if Updown1.position>updown2.position then updown1.position:=updown2.position;
end;

{************* LettersEdtKeyPress ************}
procedure TUnscrambleForm.LettersEdtKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not (upcase(key) in ['A'..'Z',#8]) then key:=char(0);  {#8=backspace}
end;

procedure TUnscrambleForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

End.





