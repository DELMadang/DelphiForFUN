program IntPowerDemo;

uses
  Forms,
  U_IntPowerDemo in 'U_IntPowerDemo.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
