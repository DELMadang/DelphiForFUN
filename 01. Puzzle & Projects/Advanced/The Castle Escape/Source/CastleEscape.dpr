program CastleEscape;

uses
  Forms,
  U_castleEscape in 'U_castleEscape.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
