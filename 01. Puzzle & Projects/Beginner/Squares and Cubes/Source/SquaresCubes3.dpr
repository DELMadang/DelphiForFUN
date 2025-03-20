program SquaresCubes3;

uses
  Forms,
  U_SquaresCubes3 in 'U_SquaresCubes3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
