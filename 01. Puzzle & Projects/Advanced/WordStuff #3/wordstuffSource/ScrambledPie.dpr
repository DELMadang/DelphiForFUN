program ScrambledPie;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  UDict in 'UDict.pas' {DicForm},
  U_DrawScrambledPie in 'U_DrawScrambledPie.pas',
  U_Invertedtext in 'U_Invertedtext.pas',
  U_EnterWordsDlg in 'U_EnterWordsDlg.pas' {EnterWordsDlg},
  U_ScrambledPie in 'U_ScrambledPie.pas' {ScrambledPieForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TScrambledPieForm, ScrambledPieForm);
  Application.CreateForm(TDicForm, DicForm);
  Application.CreateForm(TEnterWordsDlg, EnterWordsDlg);
  Application.Run;
end.
