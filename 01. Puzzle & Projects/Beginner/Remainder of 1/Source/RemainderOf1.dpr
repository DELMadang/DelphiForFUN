program RemainderOf1;

uses
  Forms,
  U_RemainderOf1 in 'U_RemainderOf1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
