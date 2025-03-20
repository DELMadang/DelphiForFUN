program ClearBlankLines4A;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_ClearBlankLines4A in 'U_ClearBlankLines4A.pas' {Form1},
  U_ProcessAFile4A in 'U_ProcessAFile4A.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
