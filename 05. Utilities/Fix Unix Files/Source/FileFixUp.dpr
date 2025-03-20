program FileFixUp;

uses
  Forms,
  U_FileFixUp in 'U_FileFixUp.pas' {Form1},
  U_HexView in 'U_HexView.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
