unit U_SaveDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, Dialogs;

type
  TSaveDlg = class(TForm)
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
  SaveDlg: TSaveDlg;

implementation

{$R *.dfm}

{******** OkBtnClick ***********}
procedure TSaveDlg.OKBtnClick(Sender: TObject);
var
  index:integer;
  newname:string;
  r:integer;
begin
  If length(trim(edit1.Text))>0 then
  with listbox1 do
  begin
    newname:=edit1.Text;
    index:=items.indexof(newname);
    If index>=0
    then
    begin
      r:=messagedlg('Replace existing?',mtconfirmation,[mbYes, mbRetry],0);
      case r of
        Mryes: ModalResult:=MrOK;
        MrRetry: modalresult:=mrNone;
      end;
    end
    else modalresult:=MrOK;
    if modalresult=MrOK then
    begin
      gridname:=newname;
      Items.Add(gridname);
    end;
  end;
end;

{*********** ListBox1Click ***********}
procedure TSaveDlg.ListBox1Click(Sender: TObject);
begin
   with listbox1 do edit1.Text:=items[itemindex];
end;

end.
