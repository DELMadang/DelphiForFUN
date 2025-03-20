unit U_TargetDialog;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TTargetWordDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TargetWordDlg: TTargetWordDlg;

implementation

{$R *.dfm}

end.
