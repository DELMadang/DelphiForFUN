program ManualCutStock;

uses
  Forms,
  U_ManualCutStock in 'U_ManualCutStock.pas' {f},
  URodPartition3 in 'URodPartition3.pas',
  U_PartsEditDlg in 'U_PartsEditDlg.pas' {PartEditDlg},
  U_SupplyEditDlg in 'U_SupplyEditDlg.pas' {SupplyEditDlg};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tf, f);
  Application.CreateForm(TPartEditDlg, PartEditDlg);
  Application.CreateForm(TSupplyEditDlg, SupplyEditDlg);
  Application.Run;
end.
