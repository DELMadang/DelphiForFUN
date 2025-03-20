unit U_PartsEditDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TPartEditDlg = class(TForm)
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
  public
    { Public declarations }
    newlen:extended;
    newqty:integer;
  end;

var
  PartEditDlg: TPartEditDlg;

implementation

{$R *.dfm}

procedure TPartEditDlg.FormShow(Sender: TObject);
begin
  edit1.text:=floattostr(newlen);
  edit2.text:=inttostr(newQty);
end;

procedure TPartEditDlg.OKBtnClick(Sender: TObject);
begin
  newlen:=strtofloatdef(edit1.text,newlen);
  newqty:=strtointdef(edit2.text,newqty);
end;

end.
