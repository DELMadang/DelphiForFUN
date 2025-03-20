program CenturySunday;

uses
  Forms,
  U_CenturySunday in 'U_CenturySunday.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
