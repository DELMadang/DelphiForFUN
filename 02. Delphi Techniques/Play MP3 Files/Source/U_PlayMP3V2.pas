unit U_PlayMP3V2;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, strutils, MPlayer, Grids, ValEdit;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    MediaPlayer1: TMediaPlayer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Testtext: TRichEdit;
    TabSheet2: TTabSheet;
    InputText: TRichEdit;
    Memo1: TMemo;
    Label1: TLabel;
    LoadListBtn: TButton;
    SaveListBtn: TButton;
    LoadTextBtn: TButton;
    SavetextBtn: TButton;
    Label2: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    OpenDialog2: TOpenDialog;
    SaveDialog2: TSaveDialog;
    procedure StaticText1Click(Sender: TObject);
    procedure TesttextMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadListBtnClick(Sender: TObject);
    procedure SaveListBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LoadTextBtnClick(Sender: TObject);
    procedure SavetextBtnClick(Sender: TObject);
  public
    FileList:TStringlist;
    mp3dir:string;
    function CanPlayMsg(Tagid:String):boolean;
  end;
var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* RichEditMouseUp *************}
procedure TForm1.TesttextMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  tagstart,tagend,sentenceEnd:integer;
  TagId:string;
begin
  with Testtext do
  begin
    sentenceEnd:=posex('.',text,selstart); {Look for end of sentence}
    tagend:=sentenceend-1;
    while (tagend>1) and (text[tagend]<>')') and (text[tagend]<>'.') do dec(tagend);
    if text[tagend]=')' then {This may be a request to play a file}
    begin
      tagstart:=tagend; {find the left paren}
      while (tagstart>1) and (text[tagstart]<>'(') do dec (tagstart);
      if text[tagstart]='(' then
      begin  {Found it, get the enclosed text}
        TagID:=copy(text,tagstart+1,tagend-tagstart-1);
        tagid:=stringreplace(tagid,char($D)+char($A),'',[rfreplaceall]);
        if CanPlaymsg(TagID) then  
        begin {text was a fileid and the file name exists}
          {highlight the enclosed text}
          selstart:=tagstart;
          sellength:=length(tagid);
          with selattributes  do
          begin
            color:=clred;
            style:=[fsbold];
            sellength:=0; {this stops the default selection highlighting}
            with mediaplayer1 do
            begin

              Open;
              Wait:=true; {wait until file plays before returning}
              play;
            end;
            sellength:=length(TagId);
            color:=defattributes.Color;
            style:=defattributes.Style;
            sellength:=0; {again, stop the default selection highlighting from showing}
          end;
        end;
      end;
    end;
  end;
end;

{************* CanPlayMsg *************}
function TForm1.CanPlayMsg(Tagid:String):boolean;
{return true if we sholuld be able to play tagid the file for tagid}
var
    s:string;
    index:integer;
begin
  result:=false;
  with filelist do
  begin
    index:=indexofname(tagid);
    if index >=0 then
    begin
      s:=mp3dir+valuefromindex[index];
      if fileexists(s) then
      begin
        mediaplayer1.filename:=s;
        result:=true
      end
      ;//else showmessage('File '+s+' not found'); {used for debugging}
    end
    ;//else showmessage('Parenthesized text '+tagid+' not found in File Association table'); {used for debugging}
  end;
end;

{************ Page Control Change ************}
procedure TForm1.PageControl1Change(Sender: TObject);
{When moving back to the "Intro & Test" page from the "Settings" page, transfer
 the memo text and resfresh the Filelist stringlist}
var
  i:integer;
begin
  If pagecontrol1.activepage= Tabsheet1 then
  begin
    TestText.text:=Inputtext.text;
    filelist.clear;
    for i:=0 to memo1.lines.count-1 do filelist.add(memo1.lines[i]);
  end;
end;

{************ FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Filelist:=TStringlist.create;
  Filelist.sorted:=true;
  mp3dir:=extractfilepath(application.exename); {default mp3 file location}
  opendialog1.initialdir:=mp3dir;
  savedialog1.InitialDir:=mp3dir;
  opendialog2.initialdir:=mp3dir;
  savedialog2.InitialDir:=mp3dir;
end;

{********** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  pagecontrol1.ActivePage:=tabsheet1;
  pagecontrol1change(sender);
end;

{************* LoadListBtnClick *********8}
procedure TForm1.LoadListBtnClick(Sender: TObject);
begin
  with opendialog1 do
  begin
    Title:='Select File association table file to load';
    If execute then
    begin
      filelist.loadfromfile(filename);
      savedialog1.FileName:=filename;
    end
  end;
end;

{************* SaveListBtnClick *************}
procedure TForm1.SaveListBtnClick(Sender: TObject);
begin
  with opendialog2 do
  begin
    Title:='Select or enter File association text file to save';
    if execute then filelist.savetofile(filename);
  end;
end;


{************ LoadtextBtnClick **************}
procedure TForm1.LoadTextBtnClick(Sender: TObject);
begin
  with opendialog2 do
  begin
    Title:='Select text file to load';
    If execute then
    begin
      filelist.loadfromfile(filename);
      savedialog2.FileName:=filename;
    end;
  end;
end;

{************* SavetextBtnClick ************}
procedure TForm1.SaveTextBtnClick(Sender: TObject);
begin
  with savedialog2 do if execute then filelist.savetofile(filename);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
