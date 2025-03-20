program DragsterTreeRelay2;

uses
  Forms,
  U_DragsterTreeRelay2 in 'U_DragsterTreeRelay2.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
