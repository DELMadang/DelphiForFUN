program PandigitalFractions;

uses
  Forms,
  U_PandigitalFractions in 'U_PandigitalFractions.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
