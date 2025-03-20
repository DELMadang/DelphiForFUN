program Tangram01;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Prelim version 0.1 - load, drag, rotate pieces}


uses
  Forms,
  U_tangram01 in 'U_tangram01.pas' {Form1},
  U_TPiece in 'U_TPiece.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
