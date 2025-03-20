program FlatLandPianoMovers;

uses
  Forms,
  U_FlatLandPianoMovers in 'U_FlatLandPianoMovers.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
