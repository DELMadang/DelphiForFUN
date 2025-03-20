program PrimesFromDigits;

uses
  Forms,
  U_PrimesFromDigits in 'U_PrimesFromDigits.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
