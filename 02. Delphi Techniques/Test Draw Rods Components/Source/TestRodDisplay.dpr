program TestRodDisplay;

uses
  Forms,
  U_TestRodDisplay in 'U_TestRodDisplay.pas' {Form1},
  U_DisplayRodPattern in 'U_DisplayRodPattern.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
