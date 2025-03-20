program IntersectingCircles;

uses
  Forms,
  U_IntersectingCircles in 'U_IntersectingCircles.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
