program MostDivisors;

uses
  Forms,
  U_MostDivisors in 'U_MostDivisors.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
