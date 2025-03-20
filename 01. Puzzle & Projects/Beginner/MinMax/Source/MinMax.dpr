program MinMax;

uses
  Forms,
  U_MinMax in 'U_MinMax.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
