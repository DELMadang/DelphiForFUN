program EquationSearch;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_EquationSearch in 'U_EquationSearch.pas' {Form1},
  UMakeCaption in 'UMakeCaption.pas',
  Ureward in 'Ureward.pas' {rewarddlg},
  U_SetOptions in 'U_SetOptions.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(Trewarddlg, rewarddlg);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
