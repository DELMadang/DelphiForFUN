program FourDice3;

uses
  Forms,
  U_FourDice3 in 'U_FourDice3.pas' {Form1},
  U_PrintCards in 'U_PrintCards.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
