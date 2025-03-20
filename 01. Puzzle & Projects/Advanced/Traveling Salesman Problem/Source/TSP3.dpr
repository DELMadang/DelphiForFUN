program TSP3;

uses
  Forms,
  U_TSP3 in 'U_TSP3.pas' {Form1},
  U_CityDlg3 in 'U_CityDlg3.pas' {CityDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TCityDlg, CityDlg);
  Application.Run;
end.
