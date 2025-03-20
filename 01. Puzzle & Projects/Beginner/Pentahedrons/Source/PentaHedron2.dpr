program PentaHedron2;

uses
  Forms,
  U_PentaHedron2 in 'U_PentaHedron2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
