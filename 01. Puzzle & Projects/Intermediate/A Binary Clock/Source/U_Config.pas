unit U_Config;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This dialog is used to set various binary clock parameters}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TConfigDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    BkgLabel: TLabel;
    LEDLabel: TLabel;
    FontLabel: TLabel;
    ColorDialog1: TColorDialog;
    BkgColor: TShape;
    LEDColor: TShape;
    LblColor: TShape;
    GroupBox2: TGroupBox;
    HMSLblBox: TCheckBox;
    BinLblBox: TCheckBox;
    Realtime: TCheckBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    TimeEdt: TEdit;
    HideTime: TCheckBox;
    Label2: TLabel;
    hhFormat: TRadioGroup;
    procedure ColorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HideTimeClick(Sender: TObject);
    procedure TimeEdtChange(Sender: TObject);
  end;

var ConfigDlg: TConfigDlg;

implementation

{$R *.DFM}

{*********** ColorMouseDown ***************}
procedure TConfigDlg.ColorMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{Routine called when user clicks either the label or the colored square in the
 Color box - it calls a TColordialog and sets the appropriate color}
begin
  if Colordialog1.execute then
  begin
    if (sender=bkglabel) or (sender=bkgcolor)
    then  bkgcolor.brush.color:=colordialog1.color
    else if (sender=ledLabel) or (sender=LEDcolor)
         then LEDcolor.brush.color:=colordialog1.color
    else if (sender=Fontlabel) or (sender=LblColor)
         then Lblcolor.brush.color:=colordialog1.color;
  end;
end;

{*************** HideTimeClick **************}
procedure TConfigDlg.HideTimeClick(Sender: TObject);
{Set passwordchar if user want to hide decimal display of the time value being
 entered}
begin
  If hidetime.checked then timeedt.passwordchar:='*'
  else timeedt.passwordchar:=#00;
end;

{*************** TimeEditChange ******************}
procedure TConfigDlg.TimeEdtChange(Sender: TObject);
{Assume user wants to use entered time when data is entered here,
 so uncheck system-time checkbox}
begin
   realtime.checked:=false;
end;

end.
