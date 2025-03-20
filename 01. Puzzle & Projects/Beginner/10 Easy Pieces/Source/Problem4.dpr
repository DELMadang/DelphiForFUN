program Problem4;

uses
  Forms,
  U_Problem4 in 'U_Problem4.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
