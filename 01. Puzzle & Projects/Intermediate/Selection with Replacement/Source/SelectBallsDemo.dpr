program SelectBallsDemo;

uses
  Forms,
  U_SelectballsDemo in 'U_SelectballsDemo.pas' {Form1},
  Combo in 'Combo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
