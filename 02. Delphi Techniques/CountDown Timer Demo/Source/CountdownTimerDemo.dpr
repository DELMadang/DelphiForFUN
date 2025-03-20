program CountdownTimerDemo;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_CountdownTimerDemo in 'U_CountdownTimerDemo.pas' {Form1},
  UCountDownTimer in 'UCountDownTimer.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
