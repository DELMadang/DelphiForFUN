program MasterMind;
 {Copyright 2001-2004, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved.

 Mastermind is a registered trademark of Pressman Toy Corporation
 }

uses
  Forms,
  U_Mastermind in 'U_Mastermind.pas' {Form1},
  U_SelectPattern in 'U_SelectPattern.pas' {PatternDlg},
  U_ShowPattern in 'U_ShowPattern.pas' {ShowPegsDlg},
  U_GetHiderOptions in 'U_GetHiderOptions.pas' {GetHiderOptions},
  U_Verbose in 'U_Verbose.pas' {VerboseForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPatternDlg, PatternDlg);
  Application.CreateForm(TShowPegsDlg, ShowPegsDlg);
  Application.CreateForm(TGetHiderOptions, GetHiderOptions);
  Application.CreateForm(TVerboseForm, VerboseForm);
  Application.Run;
end.
