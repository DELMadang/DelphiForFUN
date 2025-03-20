unit U_Explain;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, Grids;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

type
  TExplainDlg = class(TForm)
    OKBtn: TButton;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    Resultlbl: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ExplainDlg: TExplainDlg;

implementation

{$R *.DFM}
uses u_magicmatrix;

var
  data:array[0..4] of array [0..4] of integer =
     ((0,1,3,7,5),(8,9,11,15,13),(4,5,7,11,9),(6,7,9,13,11),(2,3,5,9,7));

procedure TExplainDlg.FormActivate(Sender: TObject);
var i,j:integer;
begin
  with stringgrid1 do
  for i:=0 to 4 do for j:=0 to 4 do if i+j>0 then cells[i,j]:=inttostr(data[i,j]);
  resultlbl.caption:='';
end;

procedure TExplainDlg.StringGrid1Click(Sender: TObject);
begin
  form1.stringgrid1click(sender);
end;

procedure TExplainDlg.StringGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  form1.Stringgrid1drawcell(sender,acol,arow,rect,state);
end;

end.
