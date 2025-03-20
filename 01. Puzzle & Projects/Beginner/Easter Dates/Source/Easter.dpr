program Easter;

uses
  Forms,
  U_Easter in 'U_Easter.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
