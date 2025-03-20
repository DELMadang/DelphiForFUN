program SystrayDemo2;

uses
  Forms,
  U_SystrayDemo2 in 'U_SystrayDemo2.pas' {Form1},
  U_CloseDlg in 'U_CloseDlg.pas',
  CoolTrayIcon in 'CoolTrayIcon.pas';

{CloseDlg}

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TCloseDlg, CloseDlg);
  Application.Run;
end.
