program Triangles_3Lines;

uses
  Forms,
  U_Triangle_3Lines in 'U_Triangle_3Lines.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
