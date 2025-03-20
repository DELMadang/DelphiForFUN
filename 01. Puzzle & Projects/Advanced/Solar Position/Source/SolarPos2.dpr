program SolarPos2;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {SunPos displays solar position and sunrise/sunset infor for any given date
 and time at any given location on earth.
 Also displays a plot of the shadow analemma for a location and time of day
 }


uses
  Forms,
  U_SolarPos2 in 'U_SolarPos2.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
