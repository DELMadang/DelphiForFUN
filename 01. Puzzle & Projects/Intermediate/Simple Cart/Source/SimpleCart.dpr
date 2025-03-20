program SimpleCart;

uses
  Forms,
  U_SimpleCart in 'U_SimpleCart.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
