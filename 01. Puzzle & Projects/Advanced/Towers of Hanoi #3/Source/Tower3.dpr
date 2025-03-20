program Tower3;
 {Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {Tower of Hanoi with animated graphics}

uses
  Forms,
  U_Tower3 in 'U_Tower3.pas' {Form1},
  Results in 'Results.pas' {ResultsDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TResultsDlg, ResultsDlg);
  Application.Run;
end.
