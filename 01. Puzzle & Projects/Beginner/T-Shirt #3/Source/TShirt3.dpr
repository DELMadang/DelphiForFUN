program TShirt3;

uses
  Forms,
  U_TShirt3 in 'U_TShirt3.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
