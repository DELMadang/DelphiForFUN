program RandomMatching;

uses
  Forms,
  U_RandomMatching in 'U_RandomMatching.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
