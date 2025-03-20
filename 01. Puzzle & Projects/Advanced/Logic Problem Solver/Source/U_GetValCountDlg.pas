unit U_GetValCountDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Spin;

type
  TGetValCountDlg = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    ValCount: TSpinEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GetValCountDlg: TGetValCountDlg;

implementation

{$R *.DFM}

end.
