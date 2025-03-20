program BadDNATheory;

uses
  Forms,
  U_BadDnaTheory in 'U_BadDnaTheory.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
