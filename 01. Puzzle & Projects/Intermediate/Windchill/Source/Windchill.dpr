program Windchill;

uses
  Forms,
  U_Windchill in 'U_Windchill.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
