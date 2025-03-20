program Reversed;

uses
  Forms,
  U_Reversed in 'U_Reversed.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
