program Dictmaint;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_Dictmaint in 'U_Dictmaint.pas' {DicMaintForm},
  U_AttribEdit in 'U_AttribEdit.pas' {EditwordDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TDicMaintForm, DicMaintForm);
  Application.CreateForm(TEditwordDlg, EditwordDlg);
  Application.Run;
end.
