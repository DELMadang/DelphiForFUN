program TShirt2_XXL;

uses
  Forms,
  U_TShirt2_XXL in 'U_TShirt2_XXL.pas' {Form1},
  U_BigInts in 'U_BigInts.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
