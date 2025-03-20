program CopyTruncateStrings;

uses
  Forms,
  U_CopyTruncateStrings in 'U_CopyTruncateStrings.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
