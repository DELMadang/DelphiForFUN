program FontViewer;

uses
  Forms,
  U_FontViewer in 'U_FontViewer.pas' {Form1},
  UMakeCaption in 'UMakeCaption.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
