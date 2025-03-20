program TCardSum;

uses
  Forms,
  U_TCardSum in 'U_TCardSum.pas' {Form1},
  Combo in 'Combo.pas',
  U_CardComponent in 'U_CardComponent.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
