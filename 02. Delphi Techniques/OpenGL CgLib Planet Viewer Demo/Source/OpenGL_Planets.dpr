program OpenGL_Planets;

uses
  Forms,
  U_OpenGL_Planets in 'U_OpenGL_Planets.pas' {PForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TPForm, PForm);
  Application.Run;
end.
