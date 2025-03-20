program FibonacciSunflowers;

uses
  Forms,
  U_FibonacciSunflower in 'U_FibonacciSunflower.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
