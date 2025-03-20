program SquareWordGrids3;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_SquareWordGrids3 in 'U_SquareWordGrids3.pas' {Form1},
  U_PuzzleDlg in 'U_PuzzleDlg.pas' {PuzzleDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPuzzleDlg, PuzzleDlg);
  Application.Run;
end.
