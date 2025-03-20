program Pendulum;

{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  URungeKutta4 in 'URungeKutta4.pas',
  U_Info in 'U_Info.pas' {Info},
  U_Pendulum in 'U_Pendulum.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TInfo, Info);
  Application.Run;
end.
