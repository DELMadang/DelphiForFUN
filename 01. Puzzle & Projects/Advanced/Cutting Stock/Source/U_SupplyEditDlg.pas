unit U_SupplyEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TSupplyEditDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    newlen,newcost:extended;
  end;

var
  SupplyEditDlg: TSupplyEditDlg;

implementation

{$R *.dfm}

procedure TSupplyEditDlg.FormShow(Sender: TObject);
begin
  edit1.text:=floattostr(newlen);
  edit2.text:=floattostr(newcost);
end;

procedure TSupplyEditDlg.OKBtnClick(Sender: TObject);
begin
  newlen:=strtofloatdef(edit1.text,newlen);
  newcost:=strtofloatdef(edit2.text,newcost);
end;

end.
