unit U_HangMan2;
 {Copyright © 2006, Gary Darby,  www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This version of Hangman allows human or computer to play the role of
 Hamgman or Convict.  There is also the option to allow a "Tricky Hangman"
 who will not exactly cheat but does bend the rules to increase the chance that
 justice will be done}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ComCtrls, shellapi;

type
  TKind=(circle,rectangle,Line); {kinds of elements to draw figure}
  THPiece=class(TObject)  {pieces used to draw victim}
    kind:TKind;
    start,stop: TPoint;
  end;

  TForm1 = class(TForm)
    DeadLbl: TLabel;
    PlayerPanel: TPanel;
    Label4: TLabel;
    WordLbl: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Guesseslbl: TLabel;
    GallowsImage: TImage;
    NewGameBtn: TBitBtn;
    Label5: TLabel;
    AboutBtn: TButton;
    GroupBox1: TGroupBox;
    HangmanRGrp: TRadioGroup;
    ConvictRGrp: TRadioGroup;
    CABox: TCheckBox;
    MovesLeftLbl: TLabel;
    Panel2: TPanel;
    Memo1: TMemo;
    Levelbar: TTrackBar;
    Label1: TLabel;
    MaxLenLbl: TLabel;
    MaxMovesLbl: TLabel;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure EditKeyPress(Sender: TObject; var Key: Char);
    procedure NewGameBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure HangmanRGrpClick(Sender: TObject);
    procedure LevelbarChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    HangmanList:TList;  {a list of gallows/convict pieces}
    piececount:integer; {nbr of  pieces}
    lastcolor:TColor;
    TheWord:string;  {The secret word - only its length may be know if human
                      hangman opts not to tell us}
    count:integer;
    maxmoves, maxwordlen:integer;
    movesleft:integer;
    Wordlist: TStringlist; {Eligible word list, used when computer is Hangman}
    GuessedLetters:set of char;
    function CheckaLetter(ch:char):boolean;
    procedure drawAPiece(piececolor:TColor);
    procedure MakeComputerGuesses;
    function HumanCheckChar(ch:char; var partword:string):boolean;
  end;

var
  Form1: TForm1;

implementation

uses U_About2, U_GetWordDlg, UDict, U_HumanScoreDlg;


{$R *.DFM}

{**************** FormCreate *****************}
procedure TForm1.FormCreate(Sender: TObject);
var
  piece:THPiece;
begin
  {Define all of the hangman pieces}
  piececount:=0;
  HangManList:=TList.create;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;  {base}
    start:=point(200,350);
    stop:=point(50,350);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;   {upright}
    start:=point(50,350);
    stop:=point(50,50);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;   {crosspiece}
    start:=point(50,50);
    stop:=point(125,50);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;  {rope}
    start:=point(125,50);
    stop:=point(125,75);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=circle;  {head}
    start:=point(100,75);
    stop:=point(150,125);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;       {body}
    start:=point(125,125);
    stop:=point(125,225);
    HangmanList.add(piece);
  end;

  piece:=THPiece.create;
  with piece do
  begin
    kind:=line;   {arm1}
    start:=point(125,150);
    stop:=point(75,175);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin
    kind:=line; {arm2}
    start:=point(125,150);
    stop:=point(175,175);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin      {leg1}  {9}
    kind:=line;
    start:=point(125,225);
    stop:=point(100,300);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin      {foot1}  {10}
    kind:=line;
    start:=point(100,300);
    stop:=point(90,290);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin      {leg2}  {11}
    kind:=line;
    start:=point(125,225);
    stop:=point(150,300);
    HangmanList.add(piece);
  end;
  piece:=THPiece.create;
  with piece do
  begin      {foot2}  {12}
    kind:=line;
    start:=point(150,300);
    stop:=point(160,290);
    HangmanList.add(piece);
  end;
  pubdic.LoadDicFromFile(extractfilepath(application.exename)+'HangmanWords.txt');
  wordlist:=TStringlist.create;
  randomize;
  LevelBarchange(sender);
end;

{***************** CheckALetter ***************}
function TForm1.CheckaLetter(ch:char):boolean;
{check a guess and return result true until we are hung or win}
var
  i,j:integer;
  s:string;
  goodguess, deleted,a,f,c:boolean;
begin
  result:=true;
  goodguess:=false;
  if not (ch in GuessedLetters) then  {can't guess the same letter twice}
  begin
    GuessedLetters:=GuessedLetters+[ch];
    guessesLbl.caption:=guesseslbl.caption+ch+', ';
    if hangmanrgrp.itemindex=2 then
    begin  {the tricky hangman part}
      {if the current word contains the selected letter,
       see if we can find another word that doesn't}
      i:=0;
      while (i<wordlist.count) do
      begin
        s:=uppercase(wordlist[i]);
        deleted:=false;
        for j:= 1 to length(s) do
        if s[j]=ch then
        begin
          wordlist.delete(i);
          deleted:=true;
          break;
        end;
        if not deleted then inc(i);
      end;
      if wordlist.count>0 then Theword:=uppercase(wordlist[0]);
    end;
    s:=Wordlbl.caption; {use s for temp string storage}
    if (HangmanRgrp.itemindex>0) or CABox.checked then
    begin  {computer hangman or computer assisted scoring}
      for i:=1 to length(TheWord) do {see if the letter is in the word}
      begin
        if ch=Theword[i] then
        begin
          s[2*i-1]:=ch; {fill in the  letter in display}
          goodguess:=true;
        end;
      end;
    end
    else goodguess:=HumanCheckChar(ch, s); {let the human hangman score it}
    wordlbl.caption:=s; {update the partial word display}
    if not goodguess then
    begin
      drawAPiece(clred);
      dec(movesleft);
      movesleftlbl.caption:='You have '+inttostr(movesleft)+' mistakes left!';
    end;
    If pos('_',WordLbl.caption)=0 {all underscores replaced by letters}
    then
    begin {We have a winner!}
      if convictrgrp.itemindex=0 then
        deadlbl.caption:='Your lucky guesses have earned'+#13+'you a reprieve (this time)'
      else deadlbl.caption:='My superior intelligence has again won the day';
      result:=false;
    end
    else If piececount=Hangmanlist.count
    then
    begin  {Loser!}
      if convictrgrp.itemindex=0 then {Convict was human}
      begin
         s:='Oh, oh  Goodbye!';
         deadlbl.caption:='You''re dead!' ;
      end
      else
      begin {Convict was computer}
         s:='Rotten luck!';
         deadlbl.caption:='I''ll get you next time!' ;
      end;
      If not CABox.checked then
      begin
        s:=Inputbox('Hangman:','What was the '+inttostr(length(TheWord))+
                       '-letter secret word?',' ');
        if length(s)<>length(Theword) then Theword:= s+' (Wrong length!)'
        else
          if pubdic.lookup(s,a,f,c) then theword:=s
          else Theword:=s+'(but not in your average normal hangman''s vocabulary)';
      end;
      showmessage(s+#13 +'(The word was '+theword+')');
      result:=false;
    end;
  end
  else messagebeep(mb_IconExclamation);
end;


{********************** DrawAPiece **************}
procedure TForm1.DrawAPiece(piececolor:TColor);
var
  piece:THPiece;
  w,h:integer;
  piecestomove:integer;
  i:integer;
begin
  piecestomove:=1;
  If (maxmoves=8) and  ((piececount= 0)or (piececount=6) or (piececount>=8))
  then piecestomove:=2
  else
  If (maxmoves=10) and ((piececount= 0)or (piececount=6))
  then piecestomove:=2;

  for i:=1 to piecestomove do
  begin
    inc(piececount);    {get to the next piece}
    if piececount<=HangManList.count then
    with Gallowsimage, canvas, piece do
    begin
      lastcolor:=piececolor;
      piece:=Hangmanlist[piececount-1];
      case piece.kind of
        line:
        begin
          pen.width:=4;
          pen.color:=piececolor;
          if piececolor=color {to erase face}
          then brush.color:=piececolor;
          moveto(start.x,start.y);
          lineto(stop.x,stop.y);
        end;
        circle: {The face}
        begin
          ellipse(start.x,start.y,stop.x,stop.y);
          w:=stop.x-start.x;
          h:=stop.y-start.y;
          {right eye}
          moveto(start.x+2*w div 10,
                start.y+3*h div 10);
          lineto(start.x+4*w div 10,
                start.y+3*h div 10);
          moveto(start.x+3*w div 10,
                start.y+2*h div 10);
          lineto(start.x+3*w div 10,
                start.y+4*h div 10);
          {left eye}{right eye}
          moveto(start.x+6*w div 10,
                start.y+3*h div 10);
          lineto(start.x+8*w div 10,
                start.y+3*h div 10);
          moveto(start.x+7*w div 10,
                start.y+2*h div 10);
          lineto(start.x+7*w div 10,
                start.y+4*h div 10);
         {mouth}
          ellipse(start.x+4*w div 10,
                  start.y+7*h div 10,
                  start.x+6*w div 10,
                  start.y+8*h div 10);
        end;
      end; {case}
    end; {piecestomove loop}
  end;
end;

function TForm1.HumanCheckChar(ch:char; var partword:string):boolean;
{Human hangman didn't trust the us to help score,
 call a dialog to let him score convict's latest guess}
 {Partword is the expanded version of the word being guessed w/embedded spaces
  at even numbered locations}
 var
   i:integer;
 begin
   with HumanScoreDlg do
   begin
     guess:=ch;
     {set up known part of secret word over in the dialog (without the embedded spaces)}
     knownpart:=StringOfChar(' ',length(partword)div 2);
     for i:= 1 to length(knownpart) do  knownpart[i]:=partword[2*i-1];
     result:= showmodal = MrOK;
     {now pass the result back to caller}
     for i:= 1 to length(knownpart) do partword[2*i-1]:=knownpart[i];
   end;
 end;

{**************Edit1KeyPress ******************}
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
{Check convict entry to make sure it is an uppercase letter}
begin
  key:=upcase(key);
  If not (key in ['A'..'Z']) then messagebeep(mb_iconexclamation)
  else  CheckALetter(key);
  key:=#00;
end;


{*******************EditKeyPress ****************}
procedure TForm1.EditKeyPress(Sender: TObject; var Key: Char);
{Make sure user enters only letters}
begin
  if not (upcase(key) in ['A'..'Z']) then
  begin
    messagebeep(mb_iconexclamation);
    key:=#0;
  end;
end;

{**************** NewGameBtnClick **************}
procedure TForm1.NewGameBtnClick(Sender: TObject);
{reset things for a new game}
var
  s,w:string;
  i,n:integer;
  a,f,c:boolean;
begin
  panel2.visible:=false;
  if hangmanrgrp.itemindex=0 then {human hangman}
  begin
    if CABox.checked then {computer assisted scoring}
    begin
      if GetWordDlg.showmodal=MROK
      then TheWord:=uppercase(GetWordDlg.WordEdt.text)
      else exit;
    end
    else  {no computer scoring help}
    begin
      showmessage('You have chosen to keep score yourself. '
                  +#13+'Choose your secret word, write it down, then click OK to begin');
      repeat
        s:=inputbox('Unassisted hangman','Enter length of the secret word','0');
        n:=strtointdef(s,0);
        if n>maxwordlen then showmessage('Maximum word length at this level is '
                             +inttostr(maxwordlen) )
        else if n=0 then showmessage('Enter a length from 2 to '+inttostr(maxwordlen));
      until n>=2;
      theword:=stringofchar(' ',n); {Set length of the word, even though we don't know it}
    end;
  end
  else
  with pubdic do
  begin {Computer is hangman - go select a random secret word from the dictionary}
    {choose random word length between 1/2 maxwordlength and maxwordlength}
    n:=(maxwordlen+1) div 2 + random(maxwordlen div 2)+1;
    if n<3 then n:=3;
    setrange('a',n,'z',n);
    n:=Getwordcount;
    wordlist.clear;
    while pubdic.getnextword(w,a,f,c) do
      if (not a) and (not f) and (not c) then wordlist.add(uppercase(w));

    //    wordlist.assign(pubdic.expandedlist);
    getwordbynumber(random(n),Theword);
    TheWord:=uppercase(TheWord);
  end;
  {Common stuff regardless of who plays the hangman}
  Playerpanel.visible:=true;
  Gallowsimage.visible:=true;
  wordlbl.caption:='';
  for i:=1 to length(Theword) do WordLbl.caption:=wordlbl.caption+'_ ';
  guessedletters:=[];
  guessesLbl.caption:='';
  with gallowsimage do canvas.rectangle(clientrect);
  piececount:=0;
  deadlbl.caption:='';
  edit1.text:='';
  edit1.setfocus;
  movesleft:=maxmoves;
  movesleftlbl.caption:='You have '+inttostr(movesleft)+' mistakes left!';
  if Convictrgrp.itemindex=1 then {Computer is the Convict}
  begin
    edit1.readonly:=true; {stop user from making guesses}
    MakeComputerguesses;
  end
  else edit1.readonly:=false;  {let user make guesses}
end;

{*************** MakeComputerguesses *********}
procedure TForm1.MakeComputerGuesses;
{The computer is the convict}
{No cheating here!  But we will take advantage of the dictionary to
 guess the most frequently occurring letter of the possible solution
 words at each turn}

type TCountsrec=record
      letter:char;
      count:integer;
     end;
var
  n:integer;
  triedset:set of char;
  list:TStringlist;
  counts:array[1..26] of TCountsrec;
  temp:TCountsrec;
  ch:char;
  i:integer;
  w:string;
  a,f,c:boolean;

       procedure buildcounts;
       {Build a list of all possible words based on word length, and
        which letters have already been guessed}
       var
         i,j,k:integer;
         ch2:char;
       begin
          {1. Rebuild the word list eliminating all the words that can't be the answer}
          for j:= 1 to (length(wordlbl.caption) div 2) do
          begin
            ch2:=wordlbl.caption[2*j-1];
            if ch2<>'_' then
            begin
              k:=0;
              while k<list.count do
              {Next line is "dumber" guessing technique - delete word if
                 matched letter not anywhere in the word.
                 if pos(ch2,list[k])=0 then list.delete(k) else inc(k);}
              {"Smarter" - delete word if not (matched letter in correct position)}
              if list[k][j]<>ch2 then list.delete(k) else inc(k);
            end;
          end;

          {2. Loop through the list and build a table of counts of words containing
           each letter in an unfilled position - we'll select the letter with
           the highest count each time}
          for i:=1 to 26 do {initialize counts array}
          with counts[i] do
          begin
            count:=0;
            letter:=char(ord('A')+i-1);
          end;
          {Accumulate letter counts for all words still in the list}
          for i:= 0 to list.count-1 do
          begin
            For j:= 1 to length(list[i]) do
            begin
              ch2:=list[i][j];
              inc(counts[ord(ch2)-ord('A')+1].count);
            end;
          end;
          {3. Sort array by descending word count}
            {This is the order that we'll be making our guesses}
          for i:=1 to 25 do
          begin
            for j:=i+1 to 26 do
            if counts[j].count>counts[i].count then
            begin
              temp:=counts[i];
              counts[i]:=counts[j];
              counts[j]:=temp;
            end;
          end;
        end; {buildcounts}

begin {MakeComputerGuess}
    n:=length(wordlbl.caption) div 2;
    triedset:=['_'];  {letters guessed so far}
    pubdic.Setrange('a',n,'z',n);
    list:=TStringList.create;
    pubdic.getwordcount; {build the expanded list of words}
    {build uppercase list of dictionary words of proper length}
    while pubdic.getnextword(w,a,f,c) do
     if (not a) and (not f) and (not c) then list.add(uppercase(w));
    //with pubdic do for i:=0 to expandedlist.count-1
    //  do list.add(uppercase(expandedlist[i]));
    repeat {the guess loop}
      buildcounts;
      i:=0;
      repeat {find an untried letter}
        inc(i);
        ch:=counts[i].letter;
        {if not (ch in triedset) then buildcounts; }
      until (i=26) or (not (ch in triedset));
      sleep(1000);
      application.processmessages;
      triedset:=triedset+[ch];
    until (not checkaletter(ch)) or (i=26);
    list.free;
end;

{************** AboutBtnClick ****************}
procedure TForm1.AboutBtnClick(Sender: TObject);
{Show About box }
begin  aboutbox.showmodal; end;


{***************** HangManRGrpClick **************}
procedure TForm1.HangmanRGrpClick(Sender: TObject);
{Hangman radiogroup was clicked}
begin
  {only show computer assisted checkbox if hangman is human}
  If hangmanrgrp.itemindex=0
  then CABox.visible:=true else CABox.visible:=false;
end;

{**************** LevelBarChange **************}
procedure TForm1.LevelbarChange(Sender: TObject);
{ Level was changed - set max word length and number of gallows pieces
  based on level}
begin
  MaxLenLbl.caption:='Max word size '+ inttostr(levelbar.position);
  case levelbar.position of
    3,4: maxmoves:=12;
    9,10: maxmoves:=8;
    else maxmoves:=10;
  end;
  MaxMovesLbl.caption:='Max mistakes ' +inttostr(maxmoves);
  maxwordlen:=levelbar.position;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
