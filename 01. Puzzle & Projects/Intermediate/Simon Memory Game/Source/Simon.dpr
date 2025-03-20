program Simon;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Original code by Shane A. Holmes.
}

uses
  Forms,
  U_Simon in 'U_Simon.pas' {frmMain},
  U_Common in 'U_Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
