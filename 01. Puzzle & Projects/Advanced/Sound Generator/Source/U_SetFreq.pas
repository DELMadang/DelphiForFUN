unit U_SetFreq;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin;

type
  TElementDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    FreqEdt: TSpinEdit;
    PhaseEdt: TSpinEdit;
    AmpEdt: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    WaveGrp: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetElement(newf,newp,newa,newshape:integer);

  end;

var
  ElementDlg: TElementDlg;

implementation

{$R *.DFM}
procedure TElementDlg.SetElement;
begin
  freqedt.value:=newf;
  Phaseedt.value:= newp;
  AmpEdt.value:=newa;
  WaveGrp.itemindex:=newshape;
end;

end.
