program ParkingLot;

uses
  Forms,
  U_ParkingLot in 'U_ParkingLot.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
