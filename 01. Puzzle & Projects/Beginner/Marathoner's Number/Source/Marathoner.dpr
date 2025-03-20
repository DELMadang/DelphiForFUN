program Marathoner;

uses
  Forms,
  U_Marathoner in 'U_Marathoner.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
