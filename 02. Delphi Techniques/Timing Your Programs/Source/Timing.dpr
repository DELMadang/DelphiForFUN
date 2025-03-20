program Timing;

uses
  Forms,
  U_Timing in 'U_Timing.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
