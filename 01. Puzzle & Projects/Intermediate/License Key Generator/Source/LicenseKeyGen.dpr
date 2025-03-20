program LicenseKeyGen;
{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_LicenseGen in 'U_LicenseGen.pas' {Form1},
  U_Rules in 'U_Rules.pas' {RulesForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TRulesForm, RulesForm);
  Application.Run;
end.
