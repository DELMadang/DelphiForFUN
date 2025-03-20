program NumEditTest2;

uses
  Forms,
  U_NumEditTest2 in 'U_NumEditTest2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
