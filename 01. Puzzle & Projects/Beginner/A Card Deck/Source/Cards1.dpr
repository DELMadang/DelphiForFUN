program Cards1;

uses
  Forms,
  U_Cards1 in 'U_Cards1.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
