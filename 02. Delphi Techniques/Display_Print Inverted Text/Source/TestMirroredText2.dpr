program TestMirroredText2;

uses
  Forms,
  U_TestMirroredText2 in 'U_TestMirroredText2.pas' {Form1},
  U_FullScreen2 in 'U_FullScreen2.pas' {Fullscreen};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFullscreen, Fullscreen);
  Application.Run;
end.
