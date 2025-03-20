program AniFileDemo;

uses
  Forms,
  U_AniFileDemo in 'U_AniFileDemo.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
