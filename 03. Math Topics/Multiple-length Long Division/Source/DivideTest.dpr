program DivideTest;
{Copyright 2005, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_DivideTest in 'U_DivideTest.pas' {bigints};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tbigints, bigints);
  Application.Run;
end.
