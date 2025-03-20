program MagicSquare1;

uses
  Forms,
  U_MagicSquare1 in 'U_MagicSquare1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
