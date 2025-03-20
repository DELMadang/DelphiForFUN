program SquaresCubes1;

uses
  Forms,
  U_SquaresCubes1 in 'U_SquaresCubes1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
