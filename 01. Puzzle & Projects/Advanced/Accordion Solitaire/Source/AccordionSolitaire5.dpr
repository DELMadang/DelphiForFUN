program AccordionSolitaire5;
{Copyright © 2008, 2009  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_AccordionSolitaire5 in 'U_AccordionSolitaire5.pas' {Form1},
  USearch5 in 'USearch5.pas' {Form2};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
