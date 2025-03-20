library MonitorOffDLL2;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This is the DLL containing the "global hook" logic to intercept each keystroke
 regardless of the program which "owns" the keyboard at the time.  When it finds
 that the Pause key has been pressed, it generates a Windows messages to turn
 off the monitor.  That's it - moving the mouse (or pressing any other key) will
 restore power to the monitor.

 We are getting close to Windows internal processing here so use at your own
 risk!
 }


uses
  SysUtils, Controls,
  Classes,windows, messages, inifiles;

var CurrentHook: HHook;
    dir:string;
    //Poweroption:integer;
    (*
    {DEBUG code }
      {Write messages to a text file to help debugging}
       curfile:textfile;
       controldown, Altdown:boolean;
       LogFilename:string;
    *)


{******* GlobalKeyboardHook **********}
function GlobalKeyBoardHook(code: integer; wParam: word; lParam: longword): longword; stdcall;
{"Hook" procedure to be loaded from MonitorOff.exe"}
var
  poweroption:integer;
  ini:TInifile;
begin
  if code<0 then
  begin
     {
     According to documentation if code is <0 your keyboard hook should always
     run CallNextHookEx and then return the value from it.}
     beep(400,1250);  {for debugging}
    result:=CallNextHookEx(CurrentHook,code,wParam,lparam);
  end
  else
  begin
    { wParam contains the scan code of the key }
    if  (wparam=VK_Pause)  and ((lparam and $80000000)<>0){it's a keyup}
    then
    begin
      {initialize the poweroff option currently set in the ini file}
      ini:=TInifile.create(dir+'MonitorOff.Ini');
      powerOption:=ini.readinteger('General','PO_Option',1);
      ini.free;
     (*
      writeln(curfile,format('Wparam: %s (%8x),  LParam:%8x Monitor Off %4x %4x',
                               [char(wparam),wparam, lparam, hi(lparam),lo(lparam)]));
      flush(curfile);  {make sure that it gets written}
    *)

      {Final parameter below 1=Standby, 2=Power off}
      Sendmessage(HWND_BROADCAST,WM_SYSCOMMAND, SC_MONITORPOWER, poweroption); {power off message}
      result:=1;  {stop the key from propagating further}
    end
    else
    begin {not our key, pass it on}
      //beep(200,50);   {for debugging}
      result:=CallNextHookEx(CurrentHook,code,wParam,lparam); {call the next hook proc if there is one}
    end;
  end;
end;

{SetHookHandle
-------------
Called by MonitorOff.exe  to 'inform' the dll of
the handle generated when creating the hook. This is required
for GlobalHookProcedure to call CallNextHookEx.
}
procedure SetHookHandle(HookHandle: HHook; NewDir:string); stdcall;
var ini:TInifile;
begin
    CurrentHook:=HookHandle;
    Dir:=newDir;

      (*
       {DEBUG code -set up a log file that can resord key press results}
      logfilename:=IncludeTrailingBackslash(NewDir)+'log.txt';
      assignfile(CurFile,logfilename);
      {if log.txt exists, add to it, otherwise recreate it.}
      if fileexists(logfilename)=false then rewrite(CurFile) else append(CurFile);
      showmessage('Debug set');
      *)
end;

exports GlobalKeyBoardHook index 1,
        SetHookHandle index 2;
begin


end.



