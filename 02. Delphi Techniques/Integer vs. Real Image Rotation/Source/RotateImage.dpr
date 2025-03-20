program RotateImage;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

uses
  Forms,
  U_RotateImage in 'U_RotateImage.pas' {Form1},
  URealRotate in 'URealRotate.pas',
  UIntegerRotate in 'UIntegerRotate.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
