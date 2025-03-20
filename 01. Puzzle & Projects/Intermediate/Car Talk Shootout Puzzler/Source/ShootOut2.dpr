program ShootOut2;

uses
  Forms,
  U_ShootOut2 in 'U_ShootOut2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
