unit U_ShowPattern;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.

 Mastermind is a registered trademark of Pressman Toy Corporation
 }

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TShowPegsDlg = class(TForm)
    OKBtn: TButton;
    Bevel1: TBevel;
    PaintBox1: TPaintBox;
    Label1: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ShowPegsDlg: TShowPegsDlg;

implementation

uses U_Mastermind;

{$R *.DFM}

procedure TShowPegsDlg.FormActivate(Sender: TObject);
var
  i:integer;
begin
  with paintbox1 do
  Begin
    for i:=1 to nbrpegs do Form1.showbigpeg(i,i,1,Paintbox1);
  end;
end;

end.
