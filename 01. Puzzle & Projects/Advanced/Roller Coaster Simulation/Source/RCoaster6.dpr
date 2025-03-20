program RCoaster6;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org  
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_Splines in 'U_Splines.pas',
  U_CoasterB in 'U_CoasterB.pas',
  U_RCoaster6 in 'U_RCoaster6.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
