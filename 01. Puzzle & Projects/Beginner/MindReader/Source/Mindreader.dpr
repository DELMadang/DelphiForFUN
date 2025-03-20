program Mindreader;

uses
  Forms,
  U_Mindreader in 'U_Mindreader.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
