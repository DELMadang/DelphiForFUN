program Shadow;

uses
  Forms,
  U_Shadow in 'U_Shadow.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
