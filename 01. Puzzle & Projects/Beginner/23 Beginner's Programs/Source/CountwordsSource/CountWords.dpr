program CountWords;

uses
  Forms,
  U_CountWords in 'U_CountWords.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
