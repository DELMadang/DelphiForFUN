program EvaluateExpressions;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_EvalExpressions in 'U_EvalExpressions.pas' {Form1},
  UTEval in 'UTEval.pas',
  U_VerboseDisplay in 'U_VerboseDisplay.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
