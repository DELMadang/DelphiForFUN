program File_Update;

uses
  Forms,
  U_FileUpdate in 'U_FileUpdate.pas' {Form1},
  UTSyncMemo in 'UTSyncMemo.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
