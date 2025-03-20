program RayIntersectRect;

uses
  Forms,
  U_RayIntersectRect in 'U_RayIntersectRect.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
