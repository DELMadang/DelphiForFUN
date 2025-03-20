program KeyCodes3;

uses
  Forms,
  U_keycodes3 in 'U_keycodes3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
