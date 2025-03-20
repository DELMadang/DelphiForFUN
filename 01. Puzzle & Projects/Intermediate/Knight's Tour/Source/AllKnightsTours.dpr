program AllKnightsTours;
 {Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_AllKnightsTours in 'U_AllKnightsTours.pas' {f};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tf, f);
  Application.Run;
end.
