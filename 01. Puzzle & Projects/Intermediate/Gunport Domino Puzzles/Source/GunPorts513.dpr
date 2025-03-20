program GunPorts513;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_GunPorts513 in 'U_GunPorts513.pas' {Form1},
  U_PresolveDlg51 in 'U_PresolveDlg51.pas' {PresolveDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TPresolveDlg, PresolveDlg);
  Application.Run;
end.
