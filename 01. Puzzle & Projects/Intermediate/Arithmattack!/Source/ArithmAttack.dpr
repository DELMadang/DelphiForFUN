program ArithmAttack;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {An arithmetic drill program converted from a Javascript program writtten
  by David Baurac at Argonne National Laboratories,
  http://www.dep.anl.gov/aattack.htm}

uses
  Forms,
  U_Arithmattack in 'U_Arithmattack.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
