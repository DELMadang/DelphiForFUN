program Roman2;

uses
  Forms,
  U_Roman2 in 'U_Roman2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
