unit U_SystrayDemo2;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Version 1 of this program made API calls directly to "minimize" an
application to the taskbar notification area  (commonly known as the systray). }

{
 This version uses a version of the CoolTrayIcon written by Troels Jakobsen.

 I added a couple of new properties to CoolTrayIcon:

   ShowformOnTrayIconClick:  If true, eliminates need for a user exit simply to
                             restore the program when the use clicks the tray
                             icon. Default value is false.

   PersistentTrayIcon  Keeps tray icon visible when form is visible, or hides it
                       if value is false.  Default value is true.

 I also made Application.icon the default icon.

 To avioid the need to install the components, I am simply using it as a unit.
 Procedure FormCreate is used to create the instance and override non-default
 property values.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ShellAPI, StdCtrls, ExtCtrls, CoolTrayIcon, DFFUtils;

type
  TForm1 = class(TForm)
    ModeGrp: TRadioGroup;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure ModeGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    trayicon:TCoolTrayIcon;
  end;

var
  Form1: TForm1;

implementation

uses U_CloseDlg;

{$R *.DFM}

{**************** ModeGrpClick ****************}
procedure TForm1.ModeGrpClick(Sender: TObject);
begin
  with trayicon do
  if modegrp.itemindex=0 then  persistenttrayicon:=true
  else persistenttrayicon:=false;
end;


{***************** FormCreate **************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Trayicon:=TCoolTrayIcon.create(self);
  with trayicon do
  begin
    Hint:= 'Click to restore';
    {Icon:= application.icon;} {now is default}
    minimizetotray:=true; {sets action if user clicks sysmenu minimize icon}
    ShowFormOnTrayIconClick:=true;
    persistentTrayIcon:=modegrp.itemindex=0;
  end;
  reformatmemo(memo1);
end;

{********************** FormClose ***************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
{Closedlg showmodal gives user choice of closing or minimizing}
begin
  if CloseDlg.showmodal= MrYes then
  begin
    trayicon.Destroy;
    action:=CaFree;
  end
  else
  begin  {just minimize}
    application.minimize;
    action:=CaNone;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
     ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
