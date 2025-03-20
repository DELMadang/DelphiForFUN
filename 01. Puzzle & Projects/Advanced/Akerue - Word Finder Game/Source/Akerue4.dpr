program Akerue4;

uses
  Forms,
  U_Akerue4 in 'U_Akerue4.pas' {Form1},
  U_TimeDlg in 'U_TimeDlg.pas' {TimeDlg},
  U_SelDicDlg in 'U_SelDicDlg.pas' {SelDicDlg},
  UDict;

{$R *.RES}
{$R AkerueSounds.Res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTimeDlg, TimeDlg);
  Application.CreateForm(TSelDicDlg, SelDicDlg);
  Application.CreateForm(TDicForm, DicForm);
  Application.Run;
end.
