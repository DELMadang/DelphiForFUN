program X4X2;

uses
  Forms,
  U_X4X2 in 'U_X4X2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
