program NIM3;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_NIM3 in 'U_NIM3.pas' {Form1},
  U_Setup in 'U_Setup.pas' {SetupDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSetupDlg, SetupDlg);
  Application.Run;
end.
