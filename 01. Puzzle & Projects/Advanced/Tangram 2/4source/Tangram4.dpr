program Tangram4;
{Copyright 2001-2005, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Tangram project}  

uses
  Forms,
  U_tangram4 in 'U_tangram4.pas' {Form1},
  U_TPiece4 in 'U_TPiece4.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
