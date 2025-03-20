program DigitsSumToThree;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_DigitsSumToThree in 'U_DigitsSumToThree.pas' {Form1},
  U_ExplainDlg in 'U_ExplainDlg.pas' {ExplainDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TExplainDlg, ExplainDlg);
  Application.Run;
end.
