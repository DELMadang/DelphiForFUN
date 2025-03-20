unit U_MonitorOff2;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Program set a global hook to intercept all keystrokes and turn monitor off if
 the "Pause" key is pressed.   The actual logic for this must exist in a seaparte
 DLL, MonitorOffDLL.DLL in this case, which is loaded here at FormCreate time}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, {Local, global,}
  StdCtrls, ShellAPI, Inifiles, ExtCtrls;

type
  TInitializeHook = procedure(HookHandle: HHook; NewLogdir:string); stdcall;

  TMainForm = class(TForm)
    Memo1: TMemo;
    StaticText1: TStaticText;
    PowerGrp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StaticText1Click(Sender: TObject);
    procedure PowerGrpClick(Sender: TObject);
    public
      LibHandle: HModule;  {dll handle}
      HookProcAddress: pointer;  {memory address of hook procedure in windows}
      InitializeHook: TInitializeHook; {address of the initial call procedure}
      currenthook:integer;
    end;
var
  MainForm: TMainForm;

implementation

{$R *.DFM}

{**************** FormCreate ***********}
procedure TMainForm.FormCreate(Sender: TObject);
  var ini:TInifile;
begin
  currenthook:=-1;
  {load the previously set power off code if it has been set}
  ini:=TInifile.create(extractfilepath(application.exename)+'MonitorOff.Ini');
  with ini do
  begin
    powergrp.ItemIndex:=readinteger('General','PO_option', 1)-1;
    free;
  end;

   powergrpclick(sender);  {set initial power off option}
  {To install a global keyboard hook,
   1. Load the DLL containing the hook procedure.
   2. Get the addresses of the initial procedure to be called to initialize
      the hook and the procedure to be called when a key is pressed.
   3. Call "SetWindowsHookEx" specifying "WH_KEYBOARD" as the hook type and the
      addresses obtained in step 2.  Set "threadid" to 0 to indicate a global hook.
   4. Call the hook initializatoion procedure.
  }
  {1}
   LibHandle:=LoadLibrary('MonitorOffDLL2.dll');
   if LibHandle=0 then
   begin  {if loading fails, exit and return false}
     showmessage('Load for ''MonitorOFFDLL2.dll'' failed');
     halt;
   end;
   {2}
   HookProcAddress:=GetProcAddress(LibHandle, pchar(1) {or 'GlobalKeyBoardHook'});
   InitializeHook:=GetProcAddress(LibHandle,pchar(2) {or 'SetHookHandle'});
   if (HookProcAddress=nil)or(addr(InitializeHook)=nil) then
   begin  {if loading fails, unload library, exit and return false}
     showmessage('Hook procedure addresses could not be obtained, halted');
     halt;
   end;
   {3} CurrentHook:=SetWindowsHookEx(WH_KEYBOARD,HookProcAddress,LibHandle,0);
   {4} InitializeHook(CurrentHook, Extractfilepath(application.exename));
end;



{************ FormClose **********}
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  UnhookWindowshookEx(currenthook);
  If libhandle>0 then FreeLibrary(LibHandle);
end;



{********** PowerGrpClick ************}
procedure TMainForm.PowerGrpClick(Sender: TObject);
{Save new power off option for use by DLL (1=standby, 2=power off)}
var
  ini:TInifile;
begin
  ini:=TInifile.create(extractfilepath(application.exename)+'MonitorOff.Ini');
  with ini do
  begin
    writeinteger('General','PO_option', powerGrp.itemindex+1);
  end;
  ini.free;

  //If currenthook>=0 then InitializeHook(CurrentHook, Extractfilepath(application.exename));
end;

{*************** StaticText1Click *********8}
procedure TMainForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
