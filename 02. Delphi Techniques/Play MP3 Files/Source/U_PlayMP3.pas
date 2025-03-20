unit U_PlayMP3;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, StrUtils, shellapi;

type
  TForm1 = class(TForm)
    RichEdit1: TRichEdit;
    ListBox1: TListBox;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    Label2: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Label3: TLabel;
    procedure RichEdit1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    sentencepos:array of integer;
    sentencecount:integer;
    dir:string;
    procedure BuildSentencetable;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{************* FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  dir:=extractfilepath(application.exename);
  buildSentencetable; {Build a table of sentence end position}
end;

{************ BuiidSentencetable}
procedure TForm1.BuildSentencetable;
{This procedure scans the richedit text and identifies the start and end character
 counts for each sentence. They are displayed in a stringgrid just for testing
 purposes.  After the senteces have been identified, in end positions for each
 sentence is placed in an integer array which is what will be used when the
 richedit text is clicked.  In the real application, I would just build the
 "sentencepos" array after the text was loaded without the stringgrid at all}
var
  i,n,position:integer;
begin
  with richedit1, stringgrid1 do
  begin
    rowcount:=1;
    position:=1;
    n:=posex('.',text,position); {look for a period - end of sentence}
    cells[0,0]:='Start';
    cells[1,0]:='End';
    while n>0 do
    begin
      RowCount:=rowcount+1;
      if rowcount=2 then fixedrows:=1;
      cells[0,rowcount-1]:=inttostr(position); {sentence start locations}
      cells[1,rowcount-1]:=inttostr(n); {sentence ending location}
      position:=n+1; {next sentence start}
      n:=posex('.',text,position); {look for next sentence end}
    end;

    {copy the end locations to the sentencepos array}
    setlength(sentencepos, rowcount-1);
    for i:=1 to rowcount-1 do sentencepos[i-1]:=strtoint(cells[1,i]);
    sentencecount:=rowcount-1; {save the count of sentences}
  end;
end;

{*************** RichEdit1MouseUp **************}
procedure TForm1.RichEdit1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User clicked the richedit control somewhere.  RichEdit has no onClick exit so
 we'll substitute MouseUp}
var
  pos,i, sentencenbr:integer;
  mp3filename:string;
begin
  pos:=richedit1.selstart; {selstart is the character positon that was clicked}
  sentencenbr:=-1;  {initialize , just in case - for example richedit text
   may not have ended with a period or have many blank after the last sentence
   which would not play a file}
  for i:= 0 to sentencecount-1 do
  {find the first sentence end that is higher than the clicked position,
   that is the sentence that was clicked}
  begin
    if sentencepos[i]>=pos then
    begin    {found it}
      sentencenbr:=i;
      break;
    end;
  end;
  {use the sentence number to index into a list of mp3 files to be played for
   that sentence}

  if (sentencenbr>=0) and (sentencenbr<listbox1.items.count-1) then {play the specified file}
  begin
    mp3filename:=dir+listbox1.items[sentencenbr];
    if fileexists(mp3filename)
    then  shellexecute(handle,'open',
      {player location}  {C:\Program Files\Windows Media Player\}'wmplayer.exe',
      {MP3 file location} pchar('"'+mp3filename+'"'),nil,
                         sw_hide)
    else showmessage('MP3 file '+mp3filename +' does not exist');
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
