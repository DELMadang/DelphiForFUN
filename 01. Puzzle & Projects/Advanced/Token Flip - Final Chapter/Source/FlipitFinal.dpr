program FlipitFinal;
{Copyright  © 2001-2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_FlipitFinal in 'U_FlipitFinal.pas' {Form1},
  U_Bernd in 'U_Bernd.pas' {SolveForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TSolveForm, SolveForm);
  Application.Run;
end.
