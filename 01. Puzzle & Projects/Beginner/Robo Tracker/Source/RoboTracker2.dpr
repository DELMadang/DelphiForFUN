program RoboTracker2;

uses
  Forms,
  URobo2 in 'URobo2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
