program SixOfAKind;

uses
  Forms,
  U_SixOfAKind in 'U_SixOfAKind.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
