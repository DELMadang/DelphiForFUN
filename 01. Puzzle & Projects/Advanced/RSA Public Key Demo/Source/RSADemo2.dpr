program RSADemo2;

uses
  Forms,
  U_RSADemo2 in 'U_RSADemo2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
