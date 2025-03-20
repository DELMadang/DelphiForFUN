program TShirt7;

uses
  Forms,
  U_TShirt7 in 'U_TShirt7.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
