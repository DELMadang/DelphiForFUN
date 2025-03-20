program keyDisplay;

uses
  Forms,
  U_KeyDisplay in 'U_KeyDisplay.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
