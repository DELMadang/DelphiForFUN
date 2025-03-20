program CoachsDilemma;

uses
  Forms,
  U_CoachsDilemma in 'U_CoachsDilemma.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
