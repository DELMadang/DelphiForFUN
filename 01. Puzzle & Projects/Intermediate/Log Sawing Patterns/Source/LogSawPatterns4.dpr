program LogSawPatterns4;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_LogSawPatterns4 in 'U_LogSawPatterns4.pas' {Form1},
  U_LoadDlg in 'U_LoadDlg.pas' {LoadDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TLoadDlg, LoadDlg);
  Application.Run;
end.
