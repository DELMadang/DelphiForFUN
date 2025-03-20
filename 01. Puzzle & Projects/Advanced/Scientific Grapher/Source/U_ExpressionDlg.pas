unit U_ExpressionDlg;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{dialog form to enter or change expressions}

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TExpressionDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label3: TLabel;
    ExpressionEdt: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MinVEdt: TEdit;
    MaxVEdt: TEdit;
    Label4: TLabel;
    NbrPointsEdt: TEdit;
    AngleconvertBox: TCheckBox;
    SeriesTitleEdt: TEdit;
    Label5: TLabel;
    GroupBox2: TGroupBox;
    Label6: TLabel;
    ScaleMinEdt: TEdit;
    Label7: TLabel;
    ScaleMaxEdt: TEdit;
    AutoScaleBox: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    ConstEdt: TEdit;
    procedure AutoScaleBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExpressionDlg: TExpressionDlg;

implementation

{$R *.DFM}

procedure TExpressionDlg.AutoScaleBoxClick(Sender: TObject);
begin
   if not AutoscaleBox.checked then
   begin
     scaleMinEdt.enabled:=true;
     ScaleMaxEdt.enabled:=true;
     label6.enabled:=true;
     label7.enabled:=true;
   end
   else
   begin
     scaleMinEdt.enabled:=true;
     ScaleMaxEdt.enabled:=true;
     label6.enabled:=true;
     label7.enabled:=true;
   end;

end;

end.
