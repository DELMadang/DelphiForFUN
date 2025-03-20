program SimpleDecrypt;

uses
  Forms,
  U_SimpleDecrypt in 'U_SimpleDecrypt.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
