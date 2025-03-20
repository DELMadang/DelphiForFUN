program Genaille;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
uses
  Forms,
  U_Genaille in 'U_Genaille.pas' {Form1},
  U_GenailleInfo in 'U_GenailleInfo.pas' {InfoForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.Run;
end.
