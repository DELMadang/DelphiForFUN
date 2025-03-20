program ConcentrationStudy;

uses
  Forms,
  U_ConcentrationStudy in 'U_ConcentrationStudy.pas' {Form1},
  U_CardComponent in 'U_CardComponent.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
