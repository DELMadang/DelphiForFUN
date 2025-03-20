program MostAll3;

uses
  Forms,
  U_MostAll3 in 'U_MostAll3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
