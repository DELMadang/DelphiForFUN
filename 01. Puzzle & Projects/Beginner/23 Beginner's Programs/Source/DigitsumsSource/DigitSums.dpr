program DigitSums;

uses
  Forms,
  U_DigitSums in 'U_DigitSums.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
