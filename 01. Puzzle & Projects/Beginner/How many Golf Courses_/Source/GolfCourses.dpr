program GolfCourses;

uses
  Forms,
  U_GolfCourses in 'U_GolfCourses.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
