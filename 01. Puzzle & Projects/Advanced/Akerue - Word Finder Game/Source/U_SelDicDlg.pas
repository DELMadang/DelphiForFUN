unit U_SelDicDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Dialogs;

type
  TSelDicDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    SmallnameEdt: TEdit;
    Button1: TButton;
    Label2: TLabel;
    MediumnameEdt: TEdit;
    Button2: TButton;
    Label3: TLabel;
    LargeNameEdt: TEdit;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SelDicDlg: TSelDicDlg;

implementation

{$R *.DFM}

procedure TSelDicDlg.Button1Click(Sender: TObject);
begin
  with Opendialog1 do
  begin
    if sender = button1 then
    begin
       title:='Select dictionary for Easy level';
       if opendialog1.execute then  Smallnameedt.text:=filename;
    end
    else if sender=button2 then
    begin
       title:='Select dictionary for Medium level';
       if opendialog1.execute then  Mediumnameedt.text:=filename;
    end
    else
    begin
       title:='Select dictionary for Hard level';
       if opendialog1.execute then  LargeNameedt.text:=filename;
    end;
 end;
end;

end.
