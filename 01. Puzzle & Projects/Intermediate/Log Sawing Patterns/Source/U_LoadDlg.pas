unit U_LoadDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TLoadDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    ListBox1: TListBox;
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Loadcasename:string;
  end;

var
  LoadDlg: TLoadDlg;

implementation

{$R *.dfm}

procedure TLoadDlg.OKBtnClick(Sender: TObject);
begin
  with listbox1 do
  begin
    if itemindex>=0 then LoadCasename:=items[itemindex]
    else showmessage('No case selected');
  end;
end;

end.
