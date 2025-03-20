program NIM;

uses
  Forms,
  U_NIM in 'U_NIM.pas' {Form1},
  UMakeCaption in 'UMakeCaption.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
