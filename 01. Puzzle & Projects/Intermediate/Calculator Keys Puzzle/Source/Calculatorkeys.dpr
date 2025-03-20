program Calculatorkeys;

uses
  Forms,
  U_Calculatorkeys in 'U_Calculatorkeys.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
