program SelfDescribing;

uses
  Forms,
  U_SelfDescribing in 'U_SelfDescribing.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
