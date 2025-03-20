program SquaresCubes4;

uses
  Forms,
  U_SquaresCubes4 in 'U_SquaresCubes4.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
