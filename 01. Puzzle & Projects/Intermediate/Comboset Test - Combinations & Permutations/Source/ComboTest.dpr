program ComboTest;

uses
  Forms,
  U_ComboTest in 'U_ComboTest.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
