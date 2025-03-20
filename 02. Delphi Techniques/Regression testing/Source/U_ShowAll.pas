unit U_ShowAll;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TShowAllDlg = class(TForm)
    OKBtn: TButton;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowAllDlg: TShowAllDlg;

implementation

{$R *.DFM}

end.
