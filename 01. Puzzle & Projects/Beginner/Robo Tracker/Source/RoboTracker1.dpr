program RoboTracker1;

uses
  Forms,
  URobo1 in 'URobo1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
