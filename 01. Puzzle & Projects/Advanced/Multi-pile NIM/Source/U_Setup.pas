unit U_Setup;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Grids;

type
  TSetupDlg = class(TForm)
    OKBtn: TButton;
    Boardgrid: TStringGrid;
    Memo1: TMemo;
    RandomBoardBtn: TButton;
    procedure RandomBoardBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupDlg: TSetupDlg;

implementation

{$R *.DFM}

{************** RandomBoardBtnClick *************}
procedure TSetupDlg.RandomBoardBtnClick(Sender: TObject);
var  i:integer;
begin
  with boardgrid do
  for i:=1 to rowcount-1 do cells[1,i]:=inttostr(random(11));
end;

end.
