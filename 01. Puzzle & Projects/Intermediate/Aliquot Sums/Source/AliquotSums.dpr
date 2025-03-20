program AliquotSums;

uses
  Forms,
  U_AliquotSums in 'U_AliquotSums.pas' {Form1},
  u_primes in 'u_primes.pas',
  U_IntList in '\\UPSTAIRS\G (PROJECTS)\Projects\Friendly Numbers\U_IntList.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
