unit U_Decrypt3Msg;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{ Creates encrypted messages for testing decrypt}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs, Menus;

type
  TMakeMsgDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    CodeEdt: TEdit;
    MakeCodeBtn: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    Options1: TMenuItem;
    Useabbrevs1: TMenuItem;
    Useforeignwords1: TMenuItem;
    Usecap: TMenuItem;
    Button1: TButton;
    SaveBtn: TButton;
    OpenDialog1: TOpenDialog;
    procedure MakeCodeBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    msg:Tstringlist;
    msgfilename:string;
  end;

var
  MakeMsgDlg: TMakeMsgDlg;

implementation

{$R *.DFM}


{**************** MakeCodeBtnClick ***********}
procedure TMakeMsgDlg.MakeCodeBtnClick(Sender: TObject);
var
  s:string;
  i,j:integer;
  c:char;
begin
  s:='';
  for c:='a' to 'z' do s:=s+c;
  codeedt.text:=s;
  for i:= 1 to 26 do
  begin
    j:=random(26)+1;
    c:=s[j];
    s[j]:=s[i];
    s[i]:=c;
    codeedt.text:=s;
    application.processmessages;
  end;

end;

{**************** OKBtnClick *************}
procedure TMakeMsgDlg.OKBtnClick(Sender: TObject);
var
  s,s2:string;
  i,j:integer;

begin
  msg.clear;
  s:=codeedt.text;
  with memo1 do
  for i:= 0 to lines.count-1 do
  begin
    s2:=lowercase(lines[i]);
    for j:=1 to length(s2) do
      if (s2[j] in ['a'..'z']) then s2[j]:=s[ord(s2[j])-ord(pred('a'))];
     msg.add(s2);
  end;
end;

{**************** FormCreate *************}
procedure TMakeMsgDlg.FormCreate(Sender: TObject);
begin
  msg:=Tstringlist.create;
end;

{*************** FormActivate *************}
procedure TMakeMsgDlg.FormActivate(Sender: TObject);
begin
  Makecodebtnclick(sender);   {make a new code}
end;

{*************** SaveBtnClick *************}
procedure TMakeMsgDlg.SaveBtnClick(Sender: TObject);
begin
  if savedialog1.execute
  then memo1.lines.savetofile(savedialog1.filename);
end;

end.
