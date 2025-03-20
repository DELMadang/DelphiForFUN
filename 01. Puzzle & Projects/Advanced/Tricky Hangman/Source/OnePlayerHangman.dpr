program OnePlayerHangman;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_OneplayerHangMan in 'U_OneplayerHangMan.pas' {Form1},
  U_OnePlayerGetWordDlg in 'U_OnePlayerGetWordDlg.pas' {GetWordDlg},
  UDict in 'UDict.pas' {DicForm},
  U_HumanScoreDlg in 'U_HumanScoreDlg.pas' {HumanScoreDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TGetWordDlg, GetWordDlg);
  Application.CreateForm(TDicForm, DicForm);
  Application.CreateForm(THumanScoreDlg, HumanScoreDlg);
  Application.Run;
end.
