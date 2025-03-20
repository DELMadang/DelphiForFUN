program CardTrick;

uses
  Forms,
  U_CardTrick in 'U_CardTrick.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
