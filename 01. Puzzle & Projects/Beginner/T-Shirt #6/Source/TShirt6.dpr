program TShirt6;

uses
  Forms,
  U_TShirt6 in 'U_TShirt6.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
