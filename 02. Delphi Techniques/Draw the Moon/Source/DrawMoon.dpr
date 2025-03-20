program DrawMoon;

uses
  Forms,
  U_DrawMoon in 'U_DrawMoon.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
