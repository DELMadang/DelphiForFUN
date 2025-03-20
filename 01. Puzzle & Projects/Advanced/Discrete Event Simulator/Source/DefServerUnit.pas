unit DefServerUnit;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Unit with dialog to set or change server fields}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Grids;

type
  TDefServerForm = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PDistBox: TComboBox;
    ClassBox: TComboBox;
    ServerNbrEdt: TEdit;
    PTimeEdt: TEdit;
    CostTimeEdt: TEdit;
    ProtocolRgrp: TRadioGroup;
    ServerNameEdt: TEdit;
    Label6: TLabel;
    procedure EdtChange(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
    procedure ProtocolRgrpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DefServerClasses:string;
    Procedure Initboxes;
  end;

var
  DefServerForm: TDefServerForm;

implementation

{$R *.DFM}

uses simunit;

Procedure LoadDisttypes(Box:TComboBox);
var
  i:TDistType;
Begin
  With Box do
  Begin
    clear;
    {skip 1st dist type (unknown) in combobox}
    for i := succ(low(TDistType)) to high(TDistType) do
    Begin
      items.add(DistTypeToStr(i));
    end;
    itemindex:=0;
  end;
end;

procedure TDefServerForm.Initboxes;
var
  i:integer;
  s:TServer;
begin
  {Make avail class list}
  Classbox.clear;
  If sim.servers.count>0 then
  Begin
    s:=sim.findserver(sim.servers.count-1);
    If s<> nil then costtimeedt.text:=floattostr(s.defaultcostrate);
  end
  else costtimeedt.text:='0';
  if ServerNbrEdt.text='' then
  begin
    ServerNbrEdt.text:='1';
    PTimeEdt.text:='1';
    classbox.itemindex:=0;
  end;
   LoadDistTypes(PDistBox);
   For i:= ord('A') to ord('Z') do Classbox.items.add(char(i));
end;

{****************** EdtChange **********}
procedure TDefServerForm.EdtChange(Sender: TObject);
begin
  If sender is TEdit then
  begin
    if TEdit(sender).text = ''
    then TEdit(sender).text:='0';
  end;
end;

var backspace:char=#8;

{**************** EdtKeyPress ***************}
procedure TDefServerForm.EdtKeyPress(Sender: TObject; var Key: Char);
begin
  If sender is TEdit then
  Begin
    if Key in [backspace, '0'..'9'] then exit;
    if (Key = '.') and (Pos('.', TEdit(sender).Text) = 0)
    then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0)
     and (pos('-',TEdit(sender).text)=0) then  exit;
    Key := #0;
    messagebeep(MB_ICONEXCLAMATION);
  end;
end;


procedure TDefServerForm.ProtocolRgrpClick(Sender: TObject);
begin
  {SelectionProtocol:=Protocolrgrp.itemindex;}
end;

end.
