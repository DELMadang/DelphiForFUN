program PrimeFactors1;

uses
  Forms,
  U_PrimeFactors1 in 'U_PrimeFactors1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
