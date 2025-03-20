unit U_LoadDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TLoadDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    GroupBox1: TGroupBox;
    ListBox1: TListBox;
    Edit1: TEdit;
    Label1: TLabel;
    procedure OKBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    gridName:string;
  end;

var
  LoadDlg: TLoadDlg;

implementation

{$R *.dfm}

{*********** OkBtnClick ************}
procedure TLoadDlg.OKBtnClick(Sender: TObject);
var
  index:integer;
begin
  If length(trim(edit1.Text))>0 then
  begin
    gridname:=edit1.Text;
    index:=listbox1.items.indexof(gridname);
    if index<0 then
    begin
      showmessage('Select a grid name from the list');
      modalresult:= MrNone;
    end;
  end;
end;

{*************Listbox1Click **************}
procedure TLoadDlg.ListBox1Click(Sender: TObject);
begin
   with listbox1 do edit1.Text:=items[itemindex];
end;

end.
