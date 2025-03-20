unit U_SystrayDemo;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ShellAPI, StdCtrls, ExtCtrls, ComCtrls;

const
  WM_NOTIFYICON  = WM_USER+333;

type
  TForm1 = class(TForm)
    ModeGrp: TRadioGroup;
    Memo1: TMemo;
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ModeGrpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    TrayIcon: TNotifyIconData;
    HMainIcon: HICON;
    procedure ClickTrayIcon(var msg: TMessage); message WM_NOTIFYICON;
    Procedure MinimizeClick(Sender:TObject);
  end;

var
  Form1: TForm1;

implementation

uses U_CloseDlg;

{$R *.DFM}



{***************** FormCreate ******************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  HMainIcon:=LoadIcon(MainInstance, 'MAINICON');

  Shell_NotifyIcon(NIM_DELETE, @TrayIcon);
  with trayIcon do
  begin
    cbSize              := sizeof(TNotifyIconData);
    Wnd                 := handle;
    uID                 := 123;
    uFlags              := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage    := WM_NOTIFYICON;
    hIcon               := HMainIcon;
    szTip               := 'Click to restore Systray Demo';
  end;
  Application.OnMinimize:= MinimizeClick;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   {can't do this at create time because task button hasn't been created yet}
   if modegrp.itemindex=0 then
  begin
    Shell_NotifyIcon(NIM_ADD, @TrayIcon);
     {hide the taskbar button}
     if IsWindowVisible(Application.Handle)
     then ShowWindow(Application.Handle, SW_HIDE);
  end;
end;

{**************** MinimizeClick ************}
Procedure TForm1.MinimizeClick(Sender:TObject);
begin
   if modegrp.itemindex=1 then Shell_NotifyIcon(NIM_Add, @TrayIcon);
   hide;
   {hide the taskbar button}
   if IsWindowVisible(Application.Handle)
   then ShowWindow(Application.Handle, SW_HIDE);
end;

{***************** FormClose ******************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if CloseDlg.showmodal= MrYes then action:=CAFree
  else
  begin  {user just wants to minimize the app}
    application.minimize;
    action:=CAnone;
  end;
end;

{**************** ModeGrpClick ****************}
procedure TForm1.ModeGrpClick(Sender: TObject);
begin
  if modegrp.itemindex=0 then Shell_NotifyIcon(NIM_ADD, @TrayIcon)
  else Shell_NotifyIcon(NIM_Delete, @TrayIcon);
end;

{******************** ClickTrayIcon ************}
procedure TForm1.ClickTrayIcon(var msg: TMessage);
begin
  case msg.lparam of
    WM_LBUTTONUP, WM_LBUTTONDBLCLK :
    {WM_BUTTONDOWN may cause next Icon to activate if this icon is deleted -
        (Icons shift left and left neighbor will be under mouse at ButtonUp time)}
    begin
      Application.Restore;  {restore the application}
      If WindowState = wsMinimized then WindowState := wsNormal;  {Reset minimized state}
      {Added 5/6/04 ====>} visible:=true;
      SetForegroundWindow(Application.Handle); {Force form to the foreground }
      if modegrp.itemindex=1 then Shell_NotifyIcon(NIM_Delete, @TrayIcon);
    end;
  end;
end;

{************* FoirmDestroy **************}
procedure TForm1.FormDestroy(Sender: TObject);
{Ensure that systray icon is removed at end - no matter what}
begin
  Shell_NotifyIcon(NIM_Delete, @TrayIcon)
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
     ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;



end.
