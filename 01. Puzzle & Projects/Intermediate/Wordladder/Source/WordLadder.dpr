program WordLadder;

uses
  Forms,
  U_wordladder in 'U_wordladder.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
