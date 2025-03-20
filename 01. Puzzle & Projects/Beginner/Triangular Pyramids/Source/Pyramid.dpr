program Pyramid;

uses
  Forms,
  U_Pyramid in 'U_Pyramid.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
