program CountPhrases;

uses
  Forms,
  U_CountPhrases in 'U_CountPhrases.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
