program RotateASquare;

uses
  Forms,
  U_RotateASquare in 'U_RotateASquare.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
