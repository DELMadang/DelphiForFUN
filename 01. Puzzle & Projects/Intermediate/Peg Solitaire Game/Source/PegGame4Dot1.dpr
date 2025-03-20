program PegGame4Dot1;

uses
  Forms,
  U_PegGame4Dot1 in 'U_PegGame4Dot1.pas' {Form1},
  U_PegBoard4Dot1 in 'U_PegBoard4Dot1.pas',
  U_CrackerDlg in 'U_CrackerDlg.pas' {CrackerBarrelDlg};

{$R *.RES }
{$R PegCursors.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TCrackerBarrelDlg, CrackerBarrelDlg);
  Application.Run;
end.
