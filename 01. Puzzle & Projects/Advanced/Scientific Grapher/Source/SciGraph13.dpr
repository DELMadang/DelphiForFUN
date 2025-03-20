program SciGraph13;
 {Copyright 2000-2007 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_SciGraph13 in 'U_SciGraph13.pas' {Form1},
  U_ExpressionDlg in 'U_ExpressionDlg.pas' {ExpressionDlg},
  U_Aboutpas in 'U_Aboutpas.pas' {AboutBox},
  U_NavigateHelp in 'U_NavigateHelp.pas' {NavNotesDlg},
  U_FuncNotes in 'U_FuncNotes.pas' {FuncNotesDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TExpressionDlg, ExpressionDlg);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TNavNotesDlg, NavNotesDlg);
  Application.CreateForm(TFuncNotesDlg, FuncNotesDlg);
  Application.Run;
end.
