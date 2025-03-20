program Concentration2;

uses
  Forms,
  U_Concentration2 in 'U_Concentration2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
