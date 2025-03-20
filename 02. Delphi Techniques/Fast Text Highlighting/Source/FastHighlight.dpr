program FastHighlight;

uses
  Forms,
  U_FastHighLight in 'U_FastHighLight.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
