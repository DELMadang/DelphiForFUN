program FourInARow2C;
{Copyright 2002-2003, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_FourInARow2C in 'U_FourInARow2C.pas' {Form1},
  U_FourInaRowDebug in 'U_FourInaRowDebug.pas' {Debug};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDebug, Debug);
  Application.Run;
end.
