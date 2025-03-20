program OlympicRings;

uses
  Forms,
  U_OlympicRings in 'U_OlympicRings.pas' {Form1},
  UMakeCaption in 'UMakeCaption.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
