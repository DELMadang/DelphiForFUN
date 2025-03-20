program AniResDemo;

uses
  Forms,
  U_AniResDemo in 'U_AniResDemo.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
