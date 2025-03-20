program PlayMP3;

uses
  Forms,
  U_PlayMP3 in 'U_PlayMP3.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
