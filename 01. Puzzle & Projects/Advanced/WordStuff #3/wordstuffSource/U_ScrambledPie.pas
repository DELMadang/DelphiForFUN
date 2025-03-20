Unit U_ScrambledPie;
{Copyright  © 2004-2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{If you have a Mensa Daily Puzzle Calendar, you have seen
these "Scrambled  Pie" puzzles,  Four words are
displayed in quarters of a "pie", each missing the same
single. letter.

Your task is to identify the missing letter and unscramble
the words.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
   Dialogs, StdCtrls, ComCtrls, ExtCtrls, Menus, Spin, Printers, ShellAPI,
   UDict, USearchAnagrams;
type
  //TTestWords= array ['a'..'z'] of string;

  AnyString=String;
  //CharSet=Set of Char;

  (*
  {"TWords" object passes the dictionary words against a set of letters
   retieving by first letter and length.
   For each word found, a check is made to see if it matches
   1-1 with the letters required
  }
  Twords=class(tcontrol)
  {a class to search for dictionary entries matching a set of letters}
  public
    Curword,CapWord,FirstletterSt:string;
    NextsearchPos:word;
    Len,Minlen,MaxLen:word;
    Rest:string;
    useabbrevs,useforeign,usecaps:boolean;
    {find all words between specified lengths contained in letters provided}
    Procedure Init(newletters:string;NewMinLen,NewMaxLen:word;
                    newa,newf,newc:boolean);

    Function GetNext(Dic:TDic;Var Validword:string):boolean;

  End;
  *)

  TScrambledPieForm = class(TForm)
    Bevel1: TBevel;
    Label5: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    DicLbl: TLabel;
    StopBtn: TButton;
    SearchBtn: TButton;
    LoadBtn: TButton;
    GenBtn: TButton;
    Level: TSpinEdit;
    PrintBtn: TButton;
    Memo1: TMemo;
    EnterBtn: TButton;
    StaticText1: TStaticText;
    Memo2: TMemo;
    PrintDialog1: TPrintDialog;
    procedure SearchBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure optionchange(Sender: TObject);
    procedure GenBtnClick(Sender: TObject);
    procedure EnterBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    w:array [1..4] of string;  {the scrambled words}
    AllPossibles:array[1..4] of TTestWords;
  end;

var
  ScrambledPieForm: TScrambledPieForm;
  Y:integer;
  NbrWords:Integer;

implementation

 {$R *.DFM}

uses U_DrawScrambledPie, U_EnterWordsDlg, U_InvertedText;

Var
  FirstWords,SecondWords,remainders,remainders2:TStringList;

{************** TUnscrambleForm.SEARCHBTNCLICK **********}
procedure TScrambledPieForm.SearchBtnClick(Sender: TObject);
var
  i:integer;
  ch:char;
  OK:Boolean;
begin
  Cursor:=crhourglass;
  SearchBtn.cursor:=crhourglass;
  {for each of the four ords, fill an array with valid words for each choice of
   missing letter}
  memo2.clear;
  stopbtn.visible:=true;
  stopbtn.tag:=0;
  for i:=1 to 4 do allpossibles[i]:=SearchAnagrams.FindMissingLetter(w[i]);
  stopbtn.visible:=false;
  {now find a letter which could complete all 4 words}
  for ch:='a' to 'z' do
  begin
    OK:=true;
    for i:=1 to 4 do if allpossibles[i,ch] ='' then
    begin
      ok:=false;
      break;
    end;

    if OK then  {found one}
    with memo2.lines do
    begin
      add('Missing letter is '+upcase(ch));
      add('');
      for i:=1 to 4 do add(uppercase(allpossibles[i,ch]));
      with image1 do fillcenter(upcase(ch),canvas, width, height);
      break;
   end;
  end;
  if memo2.lines.count=0 then memo2.lines.add('No solution found');

  cursor:=crdefault;
  SearchBtn.cursor:=crdefault;
end;

{*************** TUnscrambleForm.FormActivate ************}
procedure TScrambledPieForm.FormActivate(Sender: TObject);
begin
   randomize;
   stopbtn.boundsrect:=searchbtn.boundsrect; {put stopbtn over searchbtn}
   If application.mainform=self then
   begin
     (*
     if not assigned(pubdic) then
     begin
       puDic:=TDic.Create(false);
       Dic.LoadSmallDic;
     end;
     *)
     PubDic.LoadSmallDic;
     caption:='Scrambled Pie - Dictionary: '+ pubdic.dicname;
     DicLbl.caption:=extractfilename(pubdic.dicname)+ ' ('+inttostr(pubdic.getdicsize)
                           +' words)';
     loadbtn.visible:=true;
   end
   else
   begin
     caption:='Scrambled Pie - Current Dictionary:'+pubdic.dicname;
     DicLbl.caption:=extractfilename(pubdic.dicname)+ ' ('+inttostr(pubdic.getdicsize)
                           +' words)';
     {loadbtn.visible:=false;}  {might as well leave it visible}
   end;
   GenBtnClick(sender);
end;


{************** TUnscramblform.StopBtnClick **********}
procedure TScrambledPieForm.StopBtnClick(Sender: TObject);
begin
  {set stop flag;}
  Stopbtn.tag:=1;
  SearchAnagrams.tag:=1;
end;

{***************** TUnscrambleForm.LoadBtnClick **********}
procedure TScrambledPieForm.LoadBtnClick(Sender: TObject);
{load a different dictionary}
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(pubdic.dicname);
    if execute then
    begin
      pubdic.loadDicFromFile(filename);
      caption:='Unscramble - Current Dictionary:'+pubdic.dicname;
      DicLbl.caption:=extractfilename(pubdic.dicname)+ ' ('+inttostr(pubdic.getdicsize)
                           +' words)';
    end;
  end;
end;

{************* TUnscramblForm.FormCreate ************}
procedure TScrambledPieForm.FormCreate(Sender: TObject);
begin

  firstwords:=TStringlist.create;
  Secondwords:=TStringlist.create;
  remainders:=TStringlist.create;
  remainders2:=TStringlist.create;
end;

{************* TUnscrambleform.OptionChange ********}
procedure TScrambledPieForm.Optionchange(Sender: TObject);
{Check or uncheck abbrev, foreign, & caps options}
begin
   with sender as tmenuitem do  checked:= not checked;
end;

(*
procedure TUnscrambleForm.WEdtChange(Sender: TObject);
var
  i:integer;
begin
  with sender as TEdit do
  begin
    w[tag]:=lowercase(text);
    for i:=length(w[tag]) downto 1 do
      if not (w[tag,i]in ['a'..'z']) then delete(w[tag],i,1);
  end;
end;
*)

procedure TScrambledPieForm.GenBtnClick(Sender: TObject);
{Genrate four valid words sharing a common letter that is not
 repeated in any word}
var
  minw,maxw:integer;
  letterkey:longword;
  list:Tstringlist;
  ww:string;
  a,f,c:boolean;
  i,j, index, goodwords:integer;
  mask:longword;
  ok:boolean;
  letter,ch:char;
begin
  case Level.value of
    1: begin minw:=2; maxw:=4; end;
    2: begin minw:=3; maxw:=5; end;
    3: begin minw:=4; maxw:=7; end;
    else begin minw:=5; maxw:=8; end;
  end;
  {Load a stringlist with words of length between minw and maxw}
  pubdic.setrange('a',minw,'z',maxw);
  list:=TStringlist.create;
  while pubdic.getnextword(ww,a,f,c) do
  if  (not a) and (not f) and (not c)  then {no abbreviations, foreign, or capitalized}
  begin
    {letterkey will contain a 1 bit turned on for each non-vowel in the word}
    {positioned count from the right end of the word}
    {It will be used later to make sure that the set of words has at least
     letter in common}
    letterkey:=0;
    oK:=true;
    for i:= 1 to length(ww) do
    begin
      {don't count vowels, otherwise too many generated puzzles will have a
       vowel as the missing letter}
      if not (ww[i] in ['a','e','i','o','u']) then
      begin
        index:=ord(ww[i])-ord('a');
        mask:=1 shl index;
        if letterkey and mask = 0  {if
        this is first occurence of this letter}
        then letterkey:=letterkey or mask {then add it to the letterkey}
        else
        begin
          ok:=false;
          break;
        end;
      end;
    end;
    if ok then list.addobject(ww, tobject(letterkey));
  end;
  {now find four words that share a common consonant}
  repeat
    goodwords:=0;
    mask:=$FFFFFFFF;
    for i:=1 to 4 do
    begin
      index:=random(list.count);
      w[i]:=list.strings[index];
      mask:=mask and longword(list.objects[index]);
      if mask>0 then inc(goodwords) else break;
    end;
  until goodwords>=4;
  {we have 4 words with at least one letter in common,
   we'll select the letter nearest the end of the alphabet
   just to make things a litle harder}
   letter:=' ';
   for ch:='z' downto 'a' do
   begin
     i:=1 shl (ord(ch)- ord('a'));
     if (mask and i) >0 then
     begin
      letter:=ch;
      break;
    end;
  end;
  for i := 1 to 4 do
  begin
    index:=pos(letter,w[i]);
    delete(w[i],index,1);
  end;
  for i:=1 to 4 do
  for j:=1 to length(w[i]) do
  begin
    ch:=w[i,j];
    index:=random(length(w[i]))+1;
    w[i,j]:=w[i,index];
    w[i,index]:=ch;
  end;
  with image1 do drawwords(w[1],w[2],w[3],w[4],canvas, width,height);
  list.free;
  memo2.clear;
end;

procedure TScrambledPieForm.EnterBtnClick(Sender: TObject);
var i,j:integer;
begin
  with EnterWordsDlg do
  begin
    W1.text:=w[1];
    W2.text:=w[2];
    W3.text:=w[3];
    W4.text:=w[4];
    if showmodal=MROK then
    begin
      w[1]:=lowercase(W1.text);
      w[2]:=lowercase(W2.text);
      w[3]:=lowercase(W3.text);
      w[4]:=lowercase(W4.text);
      for i := 1 to 4 do
      for j:= 1 to length(w[i]) do
      if not (w[i,j]in ['a'..'z']) then delete(w[i],j,1);
      with image1 do drawwords(w[1],w[2],w[3],w[4],canvas, width,height);
    end;
  end;
end;

{***************** PrintBtnClick *************}
procedure TScrambledPieForm.PrintBtnClick(Sender: TObject);
var i:integer;
    b:TBitmap;
    imageleft:integer;
    savesize:integer;
    scale:extended;
begin
  if PrintDialog1.Execute then
  begin
    with Printer{ Image2} do
    begin
      BeginDoc;
      canvas.font:=memo1.font; {set printer font to memo font}
      for i:= 0 to memo1.lines.count-1 do {write the puzzle  at top of page}
          canvas.textout(10,abs(canvas.font.height)*(i+1),memo1.lines[i]);
      (*
      for i:=1 to 4 do  {add the 4 partial words}
          canvas.textout(10,abs(canvas.font.height)*(memo1.lines.count+2+i),w[i]);
      *)

      {now add the pie image}
      {create a bitmap scaled up to printer page size and regenerate the pie there}
       b:=TBitmap.create;
       b.transparent:=true;
       scale:=printer.pagewidth/self.width;
       b.width:=trunc(scale*image1.width); {scale width}
       b.height:=b.width;
       b.canvas.Font.PixelsPerInch:=canvas.font.PixelsPerInch;
       imageleft:=trunc(scale*image1.left); {scale left side}
       drawwords(w[1],w[2],w[3],w[4],b.canvas,b.width,b.height);
       canvas.copyrect(rect(imageleft,10,imageleft+b.width,10+b.height),
                                 b.canvas,rect(0,0,b.width,b.height));
       b.free;

      If memo2.lines.count>0 then
      begin
        savesize:=canvas.font.size;
        canvas.font.size:=6; {make answer harder to read}
        InitInvertedtext(canvas,printer.pagewidth,printer.pageheight); {Set up inverted print area}
        for i:= 1 to memo2.lines.count-1 do {and write solutions inverted at bottom of the page}
                DrawInvertedText(canvas,printer.pagewidth,printer.pageheight,i+1, lowercase(memo2.lines[i]));
        canvas.font.size:=savesize;
      end;
      EndDoc;
    end;
  end;
end;

procedure TScrambledPieForm.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

End.





