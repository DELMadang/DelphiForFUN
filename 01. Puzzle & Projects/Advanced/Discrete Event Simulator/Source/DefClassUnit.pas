unit DefClassUnit;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Unit dialog to set or change customer class fields}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   Buttons ,StdCtrls, SimUnit;

type
  TDefClassForm = class(TForm)
    DistTimeBox: TComboBox;
    ClassBox: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label6: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    ATimeEdt: TEdit;
    MaxWaitEdt: TEdit;
    JobProfitEdt: TEdit;
    WaitCostRateEdt: TEdit;
    GiveUpCostEdt: TEdit;
    Label8: TLabel;
    ClassNameEdt: TEdit;
    procedure EdtChange(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    {CustomerClass:TCustomerClass;}
    Procedure InitBoxes;

  end;

var
  DefClassForm: TDefClassForm;

implementation

{$R *.DFM}
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

procedure TDefClassForm.Initboxes;
var
  i:integer;
begin
  {Make avail class list}
  Classbox.clear;
  For i:= ord('A') to ord('Z') do
  begin
    Classbox.items.add(char(i));
  end;
  classbox.itemindex:=0;
  LoadDistTypes(DistTimeBox);
  Atimeedt.text:='2';
  MaxWaitEdt.text:='9999';
  JobProfitEdt.text:='0';
  GiveUpCostEdt.text:='0';
  WaitCostRateEdt.text:='0';
end;

procedure TDefClassForm.EdtChange(Sender: TObject);
begin
  If sender is TEdit then
  Begin
    if TEdit(sender).text = ''
    then TEdit(sender).text:='0';
  end;
end;

var backspace:char=#8;

procedure TDefClassForm.EdtKeyPress(Sender: TObject; var Key: Char);
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

end.
