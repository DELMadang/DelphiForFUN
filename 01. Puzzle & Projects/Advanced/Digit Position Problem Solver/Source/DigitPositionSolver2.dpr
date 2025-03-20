program DigitPositionSolver2;

uses
  Forms,
  U_DigitPositionSolver2 in 'U_DigitPositionSolver2.pas' {Form1},
  UTEval in 'UTEval.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
