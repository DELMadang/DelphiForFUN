program Multi_Newton1;

uses
  Forms,
  U_Multi_NewtonDemo1 in 'U_Multi_NewtonDemo1.pas' {Form1},
  UNewtonMulti in 'UNewtonMulti.pas',
  U_CoeffDlg1 in 'U_CoeffDlg1.pas' {CoeffDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TCoeffDlg, CoeffDlg);
  Application.Run;
end.
