unit U_ExplainDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TExplainDlg = class(TForm)
    OKBtn: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    line1:string;
  end;

var
  ExplainDlg: TExplainDlg;

implementation

{$R *.DFM}

procedure TExplainDlg.FormActivate(Sender: TObject);
  {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
begin
  memo1.lines[0]:=line1;
end;

end.
