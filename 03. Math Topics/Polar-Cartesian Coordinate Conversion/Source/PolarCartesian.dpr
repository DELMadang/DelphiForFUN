program PolarCartesian;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_PolarCartesian in 'U_PolarCartesian.pas' {Form1},
  U_Info in 'U_Info.pas' {InfoDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TInfoDlg, InfoDlg);
  Application.Run;
end.
