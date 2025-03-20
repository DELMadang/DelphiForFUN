program HowManysquares;

uses
  Forms,
  U_HowManySquares in 'U_HowManySquares.pas' {Form1},
  U_LoadDlg in 'U_LoadDlg.pas' {LoadDlg},
  U_SaveDlg in 'U_SaveDlg.pas' {SaveDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TLoadDlg, LoadDlg);
  Application.CreateForm(TSaveDlg, SaveDlg);
  Application.Run;
end.
