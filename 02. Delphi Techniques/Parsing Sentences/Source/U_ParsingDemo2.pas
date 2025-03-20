unit U_ParsingDemo2;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, shellapi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ParseBtn: TButton;
    OutText: TRichEdit;
    Label1: TLabel;
    Label2: TLabel;
    StaticText1: TStaticText;
    OpenDialog1: TOpenDialog;
    LoadBtn: TButton;
    Abbrevbtn: TButton;
    procedure ParseBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AbbrevbtnClick(Sender: TObject);
    public
      abList:TStringlist;
      function IsAbbreviation(const textstr:String;
                               var index:integer;
                               var word, delims :string;
                               var eos,eop:boolean):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  tab=#8;
  CR=#13; {Carriage return}
  LF=#10; {Linefeed}
  CRLF=CR+LF;

var
  endofsentence:set of char=['.','?','!'];  {end of sentence}
  letters:set of char= ['A'..'Z','a'..'z','0'..'9','_'];
  blankline:string=CRLF+CRLF; {Double CRLF = blankline = end of paragraph}

  {sample abbreviation in case no abbreviation file is loaded}
  abbreviations:array [0..26] of string =('Mr.','Mrs.','vs.','e.g.', 'eg.','A.D.',
                                         'B.A.','B.S.','Dec.','Dr.','Feb','fl.',
                                         'gal.','i.e.','Jr.','Jan.','M.D.','mt.',
                                         'Nov.','Oct.','pop.','Sept.','U.S.','Sr.',
                                         'lat.','Ltd.','etc.' );

{************* GetnextWord ************}
function getnextword(const text:String;
                         var index:integer;
                         var word, delims :string;
                         var eos,eop:boolean):boolean;
{Scans "text" from location "index" looking for a non-letter.
 When found, it returns the "word", the traing delimiters, "delims",
 and end-of-senence, "eos", and end of paragraph, "eop", binary flags}
var
  start:integer;
  n:integer;
  i:integer;
begin
  result:=false;
  eos:=false;
  eop:=false;
  n:=length(text);
  {find the start of the next word {just in case the index pointer was not
   already there}
  while (index<=n) and (not (text[index] in letters)) do inc(index);

  {we found a letter, start of word, scan for end of word (a non-letter)}
  if (index<=n) then
  begin
    start:=index;
    while (index<=n) and (text[index] in letters) do inc(index);
    word:=copy(text,start,index-start); {this is the word}
    result:=true;
    {the delimiter after this word may not be an end-of sentence delimeter
     but may be in a string that ends with end-of-sentence.  "). for example.
     We'll collect all of the word ending delimiters and pass them back to
     the user}
    start:=index;
    while (index<=n)
          and (not (text[index] in letters)) do  {finding a letter}
    begin
      if text[index] in endofsentence then eos:=true; {end of senence?}
      if eos and (index<=length(text)-3) and (copy(text,index,4)=blankline)
      then eop:=true; {end of paragraph?}
      inc(index);
    end;
    {Build delimiters string omitting any CR or LF characters}
    delims:='';
    for i:=start to index-1 do
    if not(text[i] in [CR,LF]) then delims:=delims+text[i];
  end;
end;

var
  debugtext:string;

{************* IsAbbreviation ************}
function TForm1.IsAbbreviation(const textstr:String;
                               var index:integer;
                               var word, delims :string;
                               var eos,eop:boolean):boolean;
{the end of sentence might just be an abbreviation (or the first part
         of and abbreviation such as "e.g.".  We need to detect that and not
         count it as EOS}
var
  i,j:integer;
  idx, start:integer;
  maxlen:integer;
  wordstart:integer;
  test:string;
  n:integer;
begin
  begin
    result:=false;
    if (trim(delims)='') or (delims[1]<>'.') then exit;
    if ablist.find(word, idx) then result:=true
    else
    begin
      debugtext:=textstr;
      wordstart:=index;
      while (wordstart>0) and (copy(textstr,wordstart,length(word))<>word) do dec(wordstart);
      maxlen:=length(textstr)-wordstart; {the maximum word we can check}

      {not found, but it may be the start of an abbreviation}
      for i:=idx to ablist.count-1 do
      begin
        test:=ablist.strings[i];
        if (length(test)<=maxlen) and (test=copy(textstr,wordstart,length(test))) then
        begin
          eos:=eop;
          word:=test;
          n:=length(textstr);
          index:=wordstart+length(test);
          start:=index;
          while (index<=n)
            and (not (textstr[index] in letters)) do  {finding a letter}
          begin
            if textstr[index] in endofsentence then eos:=true; {end of sentence?}
            if eos and (index<=length(textstr)-3) and (copy(textstr,index,4)=blankline)
            then eop:=true; {end of paragraph?}
            inc(index);
          end;
          {Build delimiters string omitting any CR or LF characters}
          delims:='';
          for j:=start to index-1 do
          if not(textstr[j] in [CR,LF]) then delims:=delims+textstr[j];
          result:=true;
          break;
        end
        else if test[1]<>textstr[wordstart] then break;
      end;
    end;
  end;
end;

{**************** Formcreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  f:string;
begin
  {abbreviations with '.' can return false end-of-sentence conditions.  Ablist
   will help catch abbrenviations and ignore them as EOS}
  AbList:=TStringlist.create;
  opendialog1.initialdir:=extractfilepath(application.exename);
  f:='Abbrev1.txt';

  if fileexists(f) then ablist.LoadFromFile(f)
  else for i:=0 to high(abbreviations) do ablist.add(abbreviations[i]);
  ablist.sort;
end;

{********** AbbrevBtnClick *********}
procedure TForm1.AbbrevbtnClick(Sender: TObject);
begin
  with opendialog1 do
  begin
    title:='Select abbreviation text file';
    If Execute then
    begin
      ablist.loadfromfile(filename);
      ablist.sort;
    end;
  end;
end;

{************ Parsebtnclick *************}
procedure TForm1.ParseBtnClick(Sender: TObject);
{Parse memo1 and display color coded identification of paragraphs, sentences,
 words, and delimiters.}
var
  paragraphnbr:integer;
  sentencenbr:integer;
  startloc:integer;   {pointer next starting location for retrieveing a word}
  word,delims:string; {returned word and trailing delimiters}
  eos,eop:boolean;  {end-of-sentence and end-of-paragraph flags}
begin
  with outtext do
  begin
    clear;
    startloc:=1;
    paragraphnbr:=1;
    sentencenbr:=1;
    selattributes.color:=clblue;
    lines.add('Paragraph number '+inttostr(paragraphnbr));
    selattributes.color:=clgreen;
    lines.add('     Sentence number '+inttostr(sentencenbr));
    while getnextword(memo1.lines.text, startloc, word, delims, eos, eop) do
    begin
      if eos and (delims[1]='.') then isAbbreviation(memo1.lines.text,startloc,word,delims,eos,eop);
      {add the delimiters in red on the same line as the word}
      lines.add('               '+word+'  ');
      if trim(delims)<>'' then
      begin  {non-blank delimiters exist}
        SelStart := GetTextLen-2; {set selstart to end of text but before trailing CRLF}
        selattributes.color := clred;
        selattributes.style:=[fsbold];
        seltext := delims;{Selstart sets SelLength=0, and ==> seltext is inserted}
      end;
      selstart:=gettextlen;
      if eop then
      begin
        inc(paragraphnbr);
        sentencenbr:=1;
        selattributes.color:=clblue;
        lines.add('Paragraph number '+inttostr(paragraphnbr));
        selattributes.color:=clgreen;
        lines.add('     Sentence number '+inttostr(sentencenbr));
      end
      else if eos
      then
      begin
        {the end of sentence might just be an abbreviation (or the first part
         of and abbreviation such as "e.g.".  We need to detect that and not
         count it as EOS}
        inc(sentencenbr);
        selattributes.color:=clgreen;
        lines.add('     Sentence number '+inttostr(sentencenbr));
      end;
    end;
    {Scroll to top}
    SelStart := 0; {Set the caret to the last character}
    Perform(EM_SCROLLCARET, 0, 0);  {Scroll the caret into view}
  end;
end;

{************* LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  with opendialog1 do
  begin
    title:='Select text file to parse';
    If Execute
    then memo1.lines.loadfromfile(filename);
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;




end.
