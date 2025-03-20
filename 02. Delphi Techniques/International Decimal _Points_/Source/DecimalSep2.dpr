program DecimalSep2;

uses
  Forms,
  U_DecimalSep2 in 'U_DecimalSep2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
