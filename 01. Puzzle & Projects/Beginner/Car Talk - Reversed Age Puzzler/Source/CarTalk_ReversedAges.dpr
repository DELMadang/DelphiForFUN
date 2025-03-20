program CarTalk_ReversedAges;

uses
  Forms,
  U_CarTalk_ReversedAges in 'U_CarTalk_ReversedAges.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
