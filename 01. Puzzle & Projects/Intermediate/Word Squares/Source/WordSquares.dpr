program WordSquares;

uses
  Forms,
  U_WordSquares in 'U_WordSquares.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
