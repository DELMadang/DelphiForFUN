program Josephus2;

uses
  Forms,
  U_Josephus2 in 'U_Josephus2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
