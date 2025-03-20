program Go3;

uses
  Forms,
  U_Go3 in 'U_Go3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
