unit U_KeyDisplay;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, shellapi;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label1: TLabel;
    Memo1: TMemo;
    Label3: TLabel;
    Panel1: TPanel;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    hLib2: THandle;
    DllStr1: string;
    KeyCount: Integer;
    procedure DllMessage(var Msg: TMessage); message WM_USER + 1678;
  public
    { Public declarations }
    firsttime:boolean;
    procedure showmsg(msg:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{********* DLLMessage ***********}
procedure TForm1.DllMessage(var Msg: TMessage);
begin
  if (Msg.wParam = 8) then  Exit;
  Inc(KeyCount);
  Label2.Caption := Format('KeyCount: %d',[KeyCount]);
  //label3.Caption:=label1.Caption; {save as prior key for debugging}
 //label1.Caption := format('Wparam:%x, Lparam:%x',[msg.wparam,msg.lparam]); {For debugging}
  if Msg.WParam = VK_Return then  close;
  //else DllStr1 := DllStr1 + Chr(Msg.wParam);
end;

type
  TStartHook = function(MemoHandle, AppHandle: HWND): Byte;
  TStopHook = function: Boolean;

{*********** FormA ctivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
{things display better here than from formCreate}
var
  StartHook1: TStartHook;
  SHresult: Byte;
begin
  if not firsttime then exit; {but we still only want to do it one time}
  top:=0;
  left:=screen.Width-width;
  hLib2 := LoadLibrary('KeyDisplayHook.dll');
  @StartHook1 := GetProcAddress(hLib2, 'StartHook');
  if @StartHook1 = nil then
  begin
    Showmessagepos('Keyboard start hook failed',left,top);
    Exit;
  end;
  SHresult := StartHook1(Memo1.Handle, Handle);
  case SHresult  of
    0:ShowMsg('Key Hook started');  {pause for expected message}
    1:ShowMessagePos('Key Hook was already Started',left,top);
    2:ShowMessagePos('the Key Hook can''t be Started',left,top);
    4:ShowMessagePos('MemoHandle is incorrect',left,top);
  end;
  KeyCount := 0;
  firsttime:=false;
end;

procedure TForm1.showmsg(msg:string);
{Show start up and close messages for a short period of time}
  begin
    with panel1 do
    begin
      BringToFront;
      caption:=msg;
      visible:=true;
      update;
      sleep(1500);   {show message for 1.5 seconds}
      sendtoBack;
      visible:=false;
    end;
  end;

{****************** FormClose ***************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  StopHook1: TStopHook;
begin
  @StopHook1 := GetProcAddress(hLib2, 'StopHook');
  if @StopHook1 = nil then
  begin
    ShowMessagePos('Stop Hook DLL not found',left,top);
    Exit;
  end;
  //if StopHook1 then ShowMessagePos('Hook was stopped',left,top);
  if stophook1 then showmsg('Hook released');
  FreeLibrary(hLib2);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  firsttime:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure TForm1.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  if keycount=0 then memo1.clear;
end;

end.
