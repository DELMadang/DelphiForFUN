program WordSearch2;
{Copyright © 2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_WordSearch2 in 'U_WordSearch2.pas' {Form1},
  U_TargetDialog in 'U_TargetDialog.pas' {TargetWordDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TTargetWordDlg, TargetWordDlg);
  Application.Run;
end.
