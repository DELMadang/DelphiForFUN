program RotatingSums;

uses
  Forms,
  U_RotatingSums in 'U_RotatingSums.pas' {Form1},
  U_Permutes in 'U_Permutes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
