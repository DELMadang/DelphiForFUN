unit UGetLocDlg;
{Solicit Name, latitude,  and longitude for a scaling point or a point to add to
 the location list.}
interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TAddLocDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Memo1: TMemo;
    Label1: TLabel;
    LocEdt: TEdit;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    AddLocId:string;
    Lat, Long:extended;
  end;

var
  AddLocDlg: TAddLocDlg;

implementation

{$R *.DFM}

Uses UAngles; {To get access to AngleToStr and StrToAngle functions}

{************* FormActivate **************}
procedure TAddLocDlg.FormActivate(Sender: TObject);
{Move fields to string}
begin
  locedt.text:=Addlocid;
  edit1.text:=angletostr(lat);
  edit2.text:=angletostr(long);
  locedt.setfocus;
end;

{*********** OKBtnClick ********}
procedure TAddLocDlg.OKBtnClick(Sender: TObject);
var
  msg:string;
begin
  AddLocId:=LocEdt.text;
  msg:='';
  if not strtoangle(Edit1.text,lat) then msg:='Latitude is invalid angle'
  else if not strtoangle(Edit2.text,Long) then msg:='Longitude is invalid angle';
  if msg='' then OKbtn.modalresult:=MrOK
  else
  begin
    showmessage(msg);
    OKbtn.modalresult:=mrNone;
  end;
end;




end.
