program ReactionTimes4;

uses
  Forms,
  U_ReactionTrialDefs4 in 'U_ReactionTrialDefs4.pas' {Form2},
  U_ReactionTimes4 in 'U_ReactionTimes4.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
