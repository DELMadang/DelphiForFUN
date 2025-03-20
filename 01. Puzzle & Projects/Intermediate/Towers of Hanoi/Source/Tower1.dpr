program Tower1;

uses
  Forms,
  U_Tower1 in 'U_Tower1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
