program NumbrixGenerator;

uses
  Forms,
  U_NumbrixGenerator in 'U_NumbrixGenerator.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
