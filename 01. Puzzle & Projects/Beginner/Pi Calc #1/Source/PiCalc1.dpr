program PiCalc1;

uses
  Forms,
  U_PiCalc1 in 'U_PiCalc1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
