program Alphametics;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_Permutes in 'U_Permutes.pas',
  U_Alphametics in 'U_Alphametics.pas' {Form1},
  U_SolvedDlg in 'U_SolvedDlg.pas' {OKBottomDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TOKBottomDlg, SolvedDlg);
  Application.Run;
end.
