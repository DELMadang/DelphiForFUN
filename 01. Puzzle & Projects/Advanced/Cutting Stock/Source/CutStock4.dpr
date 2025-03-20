program CutStock4;
{Copyright © 2007, 2010 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_CutStock4 in 'U_CutStock4.pas' {Form1},
  UDelayedColumnGeneration in 'UDelayedColumnGeneration.pas',
  UDisplayRodPattern in 'UDisplayRodPattern.pas',
  UGridQuickSort in 'UGridQuickSort.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
