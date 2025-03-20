program BigIntsRegrTest;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_BigIntsRegrTest in 'U_BigIntsRegrTest.pas' {Form1},
  URegrTest in 'URegrTest.pas',
  U_ShowAll in 'U_ShowAll.pas' {ShowAllDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TShowAllDlg, ShowAllDlg);
  Application.Run;
end.
