program RandomTriangles2;

uses
  Forms,
  U_RandomTriangles2 in 'U_RandomTriangles2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
