program PanMagicSquares;

uses
  Forms,
  U_PanMagicSquares in 'U_PanMagicSquares.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
