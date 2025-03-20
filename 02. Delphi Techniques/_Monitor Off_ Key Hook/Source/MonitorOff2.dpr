program MonitorOff2;

uses
  Forms,
  U_MonitorOff2 in 'U_MonitorOff2.pas' {MainForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
