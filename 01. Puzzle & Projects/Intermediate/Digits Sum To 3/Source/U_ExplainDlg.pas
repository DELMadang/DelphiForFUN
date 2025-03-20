unit U_ExplainDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TExplainDlg = class(TForm)
    OKBtn: TButton;
    Memo3: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExplainDlg: TExplainDlg;

implementation

{$R *.dfm}

end.
