unit U_msg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TMsgDlg = class(TForm)
    OKBtn: TButton;
    msgLbl: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MsgDlg: TMsgDlg;

implementation

{$R *.DFM}

end.
