program MercatorDemo;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_MercatorDemo in 'U_MercatorDemo.pas' {Form1},
  UGetLocDlg in 'UGetLocDlg.pas' {AddLocDlg},
  UAngles in 'UAngles.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAddLocDlg, AddLocDlg);
  Application.Run;
end.
