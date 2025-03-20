program TravelingMen;

uses
  Forms,
  U_TravelingMen in 'U_TravelingMen.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
