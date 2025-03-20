unit UBeadsDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin;

type
  TBeadsDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Init1: TSpinEdit;
    Init3: TSpinEdit;
    Init5: TSpinEdit;
    Init7: TSpinEdit;
    Label1: TLabel;
    RewAdd: TSpinEdit;
    LastWinBonus: TSpinEdit;
    LastLossBonus: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LossSub: TSpinEdit;
    TieAdd: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  BeadsDlg: TBeadsDlg;

implementation

{$R *.DFM}

end.
