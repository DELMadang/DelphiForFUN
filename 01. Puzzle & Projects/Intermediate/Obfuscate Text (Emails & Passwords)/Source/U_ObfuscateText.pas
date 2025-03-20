unit U_ObfuscateText;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, StrUtils;

type
  TCharSet=set of char;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    ProcessBtn: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    InitDelimEdt: TEdit;
    Label1: TLabel;
    ReplaceTypeGrp: TRadioGroup;
    ReplaceCharEdt: TEdit;
    ReplaceWordEdt: TEdit;
    FinalDelimEdt: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    SampleGrp: TRadioGroup;
    Label4: TLabel;
    MustHaveEdt: TEdit;
    Label5: TLabel;
    EndSpaceDelim: TCheckBox;
    StartSpaceDelim: TCheckBox;
    WhichwordGrp: TRadioGroup;
    Memo2: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure ProcessBtnClick(Sender: TObject);
    procedure SampleGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    filenameIn, filenameOut:string;
    Initdelims: TCharset; //set of char =['<',':',' '];
    Finaldelims:TCharSet; // set of char;
    function makedelims(s:string):Tcharset;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}




{*******MakerandomWord ******}
function MakerandomWord(length:integer):string;
{Return a random lower case letter string of the specified length}
var i:integer;
begin
  setlength(result,length);
  for i:=1 to length do result[i]:=char(ord('a')+random(26));
end;



{************* MakeDelims ************}
function TForm1.makedelims(s:string):Tcharset;
{Convert text string to a set of characters}
var
  i:integer;
  ss:string;
begin
  ss:=trim(s);
  result:=[];
  for i:=1 to length(ss) do result:=result+[ss[i]];
end;

{*********** FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
  Samplegrp.itemindex:=0;
  randomize;
end;

{********** ProcessBtnClick **********}
procedure TForm1.ProcessBtnClick(Sender: TObject);

       {------------- GetNextWord -------------}
       function getNextQualifyingWord(const line:string; var n:integer; var word:string):boolean;
       {Starting from line[n] find the next word ending with a character in finaldelims}
       {If space character is an end od word  delimiter, then also count end of
        line as an end of word delimiter}
          var
            len:integer;
            start:integer;

          begin
            result:=false;
            len:=length(line);
            {skip to the last of multiple consecutive final delimiters}
            while (n<len) and (line[n] in finaldelims ) do inc(n);
            {now find end of word}
            if n<len then
            begin
              while (n<=len) and (not (line[n] in finaldelims)) do inc(n);
              if    ((n<len+1) and (line[n] in finaldelims))
                 or ((n=len+1) and endspacedelim.checked) then
              begin {found a word}
                start:=n;
                {search back for start of this word}
                while (start>1) and (not (line[start-1] in Initdelims)) do dec(start);
                word:=copy(line,start,n-start);
                result:=true;
              end
            end;
            if not result then word:='';
          end;


var
  n, start:integer;
  fIn,fOut:textfile;
  origline, line, Oldword, Newword:string;
  ch:char;
  Oldlength, NewLength:integer;
  Len:integer;  {currentline length}
  Linecount:integer;
begin {ProcessBtnClick}
  memo1.Clear;
  {Clear any extra spaces}
  musthaveEdt.text:=trim(mustHaveEdt.text);
  replaceCharEdt.text:=trim(ReplaceCharEdt.text);

  if opendialog1.execute then
  begin  {got an input file}
    filenameIn:=opendialog1.filename;
    savedialog1.initialdir:=extractfilepath(filenameIn);
    if savedialog1.execute then  {get an output filename}
    if savedialog1.filename<>filenamein then
    begin
      assignfile(fIn,filenameIn);
      assignfile(fOut,savedialog1.filename);
      reset(fIn);
      rewrite(fOut);

      {Build delimiter character sets}
      Initdelims:=MakeDelims(Initdelimedt.text);
      if StartSpaceDelim.checked then Initdelims:=Initdelims+[' '];
      FinalDelims:=MakeDelims(FinalDelimEdt.text);
      if EndSpaceDelim.checked then FinalDelims:=FinalDelims+[' '];

      {Loop to process all lines}
      linecount:=0;
      while not eof(fIn) do
      begin
        readln(fIn,origline);
        inc(linecount);
        line:=origline;
        {If space is a word ending delimiter then end of line  should also end a word}
        n:=1;
        len:=length(line);
        while n<len do
        begin
          if getNextQualifyingWord(line, n, oldword ) then
          begin
            oldlength:=length(oldword);
            newword:=oldword; {so no change is recognized unless there is one}
            start:=n-oldlength;
            if (length(musthaveedt.text)=0) or
              ((length(mustHaveEdt.text)>0)
              and (pos(uppercase(musthaveedt.text), uppercase(oldword))>0))
            then
            begin
              if  whichwordgrp.itemindex=1 then{act on next word}
              begin
                getNextQualifyingWord(line,n,oldword);  {get the next word}
                oldlength:=length(oldword);
                if oldlength=0
                then
                begin
                  memo1.Lines.Add(format('No word found following %s in line %d',
                         [newword, linecount]));
                  memo1.lines.add(format('   Line %d: "%s"',[Linecount, origline]));
                end;
                start:=n-oldlength;
                newword:=oldword;
              end;
              if oldlength>0 then
              begin
                with replacetypeGrp do
                case itemindex of
                  0,1:
                  begin
                    NewWord:=makeRandomWord(n-start);
                    if itemindex=1 then newword:=uppercase(newWord);
                   end;
                  2:
                  begin
                    if length(replacecharedt.text)=0 then replacecharedt.text:='X';
                    ch:=replacecharedt.text[1];
                    newWord:=stringofchar(ch,n-start) ;
                  end;
                  3: newword:=replaceWordEdt.text;
                end; {case}
                newlength:=length(newword);
                              delete(line,start,oldlength);
                insert(newword,line,start);
                len:=length(line);
              end
              else newlength:=0;
              inc(n, newlength-oldlength+1);
            end;
          end;
          if newword<>oldword then memo1.lines.add(oldword+ ' changed to ' +newword);
          oldword:='';
          newword:='';
        end;
        writeln(fout,line)
      end;
      closefile(fIn);
      closefile(fOut);
    end
    else showmessage('Output file name must be different than input file name');
  end;
end;

{********** SampleGrpClick ***********}
procedure TForm1.SampleGrpClick(Sender: TObject);
begin
  Case SampleGrp.ItemIndex of
    0:
    begin   {obfuscate email name field}
      InitDelimEdt.text:='<(,:';
      ReplaceTypeGrp.ItemIndex:=0;
      ReplaceWordEdt.text:=' ';
      ReplaceCharEdt.text:=' ';
      FinalDelimEdt.text:='@';
      StartSpaceDelim.checked:=true;
      EndSpacedelim.checked:=false;
      MustHaveEdt.text:='';
      Whichwordgrp.ItemIndex:=0;
    end;

    1:  {hide entire email adress}
    begin
      InitDelimEdt.text:='<(,:';
      ReplaceTypeGrp.ItemIndex:=3;
      ReplaceCharEdt.text:=' ';
      ReplaceWordEdt.text:='Email address removed';
      FinalDelimEdt.text:='>),:';
      StartSpaceDelim.Checked:=true;
      EndSpaceDelim.checked:=true;
      MustHaveEdt.text:='@';
      Whichwordgrp.ItemIndex:=0;
    end;

    2:   {Change word following "Password:" with 8 asterisks}
    begin
      InitDelimEdt.text:='<(,';
      ReplaceTypeGrp.ItemIndex:=3;
      ReplaceCharEdt.text:=' ';
      ReplaceWordEdt.text:='********';
      FinalDelimEdt.text:='';
      StartSpaceDelim.Checked:=true;
      EndSpaceDelim.checked:=true;
      MustHaveEdt.text:='Password:';
      Whichwordgrp.ItemIndex:=1;
    end;
  end; {case}
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
