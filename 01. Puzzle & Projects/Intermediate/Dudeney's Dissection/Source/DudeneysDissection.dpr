program DudeneysDissection;

uses
  Forms,
  U_DudneysDissection in 'U_DudneysDissection.pas' {Form1},
  U_DudeneyConstruction in 'U_DudeneyConstruction.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
