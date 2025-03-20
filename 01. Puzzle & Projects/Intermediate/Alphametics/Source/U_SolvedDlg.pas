unit U_SolvedDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TOkBottomDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Memo3: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SolvedDlg: TOKBottomDlg;

implementation

{$R *.dfm}

end.
