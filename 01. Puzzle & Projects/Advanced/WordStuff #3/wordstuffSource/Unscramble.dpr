program Unscramble;

uses
  Forms,
  U_Unscramble in 'U_Unscramble.pas' {Form12};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TUnscrambleForm, UnscrambleForm);
  Application.Run;
end.
