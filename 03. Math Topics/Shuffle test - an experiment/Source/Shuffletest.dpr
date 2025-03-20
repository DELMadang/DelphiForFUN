program Shuffletest;

uses
  Forms,
  U_Shuffletest in 'U_Shuffletest.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
