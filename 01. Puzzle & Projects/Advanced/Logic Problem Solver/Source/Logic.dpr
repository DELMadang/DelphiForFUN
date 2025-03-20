program Logic;
  {Copyright 2002-2012, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_SolveUnit in 'U_SolveUnit.pas' {SolveForm},
  U_Show_If in 'U_Show_If.pas' {ShowIFForm},
  U_GetValCountDlg in 'U_GetValCountDlg.pas' {GetValCountDlg},
  U_EditVarValue in 'U_EditVarValue.pas' {VarValDlg},
  U_ChgVarName in 'U_ChgVarName.pas' {OKBottomDlg1},
  U_PrintRoutines in 'U_PrintRoutines.pas',
  U_PrintTables in 'U_PrintTables.pas' {Form2},
  U_Logic in 'U_Logic.pas' {Form1},
  U_LogForm in 'U_LogForm.pas' {Logform};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSolveForm, SolveForm);
  Application.CreateForm(TShowIFForm, ShowIFForm);
  Application.CreateForm(TGetValCountDlg, GetValCountDlg);
  Application.CreateForm(TVarValDlg, VarValDlg);
  Application.CreateForm(TOKBottomDlg1, OKBottomDlg1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TLogform, Logform);
  Application.Run;
end.
