program JumpFrogs;

uses
  Forms,
  U_JumpFrogs in 'U_JumpFrogs.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
