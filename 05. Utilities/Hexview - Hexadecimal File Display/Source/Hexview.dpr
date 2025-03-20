program Hexview;

uses
  Forms,
  U_HexView in 'U_HexView.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
