program Translations;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  gnuGettext,
  U_Translations in 'U_Translations.pas';

{Form1}

{$R *.RES}

begin
  //uselanguage('de');
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
