program Datecalc2;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_Datecalc2 in 'U_Datecalc2.pas' {Form1},
  U_ErrDlg2 in 'U_ErrDlg2.pas' {ErrDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TErrDlg, ErrDlg);
  Application.Run;
end.
