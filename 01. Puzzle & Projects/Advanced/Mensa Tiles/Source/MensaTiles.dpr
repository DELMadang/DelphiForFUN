program MensaTiles;

uses
  Forms,
  U_MensaTiles in 'U_MensaTiles.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
