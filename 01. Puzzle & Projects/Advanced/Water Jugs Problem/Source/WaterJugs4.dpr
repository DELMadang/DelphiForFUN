program WaterJugs4;

uses
  Forms,
  U_WaterJugs4 in 'U_WaterJugs4.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
