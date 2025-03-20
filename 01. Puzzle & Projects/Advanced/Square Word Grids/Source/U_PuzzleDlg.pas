unit U_PuzzleDlg;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls;

type
  TPuzzleDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    PuzzleList: TListBox;
    Label1: TLabel;
    procedure PuzzleListDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PuzzleDlg: TPuzzleDlg;

implementation

{$R *.dfm}

procedure TPuzzleDlg.PuzzleListDblClick(Sender: TObject);
{let double lick close the dialog}
begin
  Modalresult:=MrOK;
  exit;
end;

end.
