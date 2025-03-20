program SoundGen3;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_SoundGen3 in 'U_SoundGen3.pas' {Form1},
  U_SetFreq in 'U_SetFreq.pas' {ElementDlg};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TElementDlg, ElementDlg);
  Application.Run;
end.
