program Problem2;

uses
  Forms,
  U_Problem2 in 'U_Problem2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
