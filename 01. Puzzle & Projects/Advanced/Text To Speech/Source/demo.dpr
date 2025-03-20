program demo;

uses
  Forms,
  U_Demo in 'U_Demo.pas' {frmMain},
  mSpeech in 'mSpeech.pas',
  speech in 'Speech.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
