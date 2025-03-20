unit U_ErrDlg2;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Spin;

type
  TErrDlg = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    d1Lbl: TLabel;
    D2Lbl: TLabel;
    DDiffLbl: TLabel;
    RecalcLblYMD: TLabel;
    CancelBtn: TButton;
    Memo1: TMemo;
    PauseBox: TCheckBox;
    Repeatbox: TCheckBox;
    RecalcLblDMY: TLabel;
    Memo2: TMemo;
    Difflimit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure CancelBtnClick(Sender: TObject);
  public
    Testcount:integer;
    errcount:integer;
    done:boolean;
  end;

var
  ErrDlg: TErrDlg;

implementation

{$R *.dfm}

procedure TErrDlg.OKBtnClick(Sender: TObject);
begin
  if done then close
end;

procedure TErrDlg.CancelBtnClick(Sender: TObject);
begin
  close;
end;

end.
