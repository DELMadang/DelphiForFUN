program BinaryClock;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A simple binary clock}


uses
  Forms,
  U_BinaryClock in 'U_BinaryClock.pas' {Form1},
  U_Config in 'U_Config.pas' {ConfigDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TConfigDlg, ConfigDlg);
  Application.Run;
end.
