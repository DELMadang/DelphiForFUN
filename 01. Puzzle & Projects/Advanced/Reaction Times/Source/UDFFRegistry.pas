unit UDFFRegistry;
{Routines which retrieve or set the registry entries used by DFF programs.
 All Data names and values exist under subkey "\Software\DelphiForFun\Common"
 in root key HKEY_CURRENT_USER }

 {
 WORKPATH is the common path primarily intended to provide a folder for  programs
 to use if they need to write data to a hard drive and happen to run  from a
 "Read Only" folder or CD Rom drive.  Functions "GetDFFCommonPath",
 "SetDFFCommonPath" to pass a new WORKPATH value, and "ChangeDFFCommonPath"
 to retrieve and  create/change WORKPATH.
 }

interface
uses  Windows, SysUtils, Forms, Registry, FileCtrl;

function GetDFFCommonPath(CreateDir:boolean):string;
procedure SetDFFCommonPath(Newpath:string);
function ChangeDFFCommonPath:string;

implementation
var
  DFFkey:string='\Software\DelphiForFun\Common';

{************* GetDFFCommonPath ***************}
function GetDFFCommonPath(CreateDir:boolean):string;
var
  Reg: TRegistry;
  r:boolean;
begin
  Reg := TRegistry.Create;
  with reg do
  begin
    try
      RootKey := HKEY_CURRENT_USER;
      OpenKey(DFFKey, True);
      r:=ValueExists('WorkPath');
      if r then
      begin
        result:=reg.readstring('WorkPath');
      end
      else
      begin
        result:=extractfilepath(application.exename);
        reg.writestring('WorkPath',result);
      end;
      (*
      if (createDir and ((not r) or (result=''))) then
      begin
        if not r then createkey(key);
        chdir(result);
        selectdirectory(result,[ sdAllowCreate, sdPerformCreate, sdPrompt],
                 0);
        result:=includetrailingbackslash(result);
        writestring('WorkPath',result);
      end;
      *)
      CloseKey;
    finally
      Free;
    end;
  end;
  result:=includetrailingbackslash(result);
end;


{************* SetDFFCommonPath *************}
procedure SetDFFCommonPath(Newpath:string);
{Set a new DFF Common Path folder}
var
  Reg: TRegistry;
  key:string;
begin
  Reg := TRegistry.Create;
  with reg do
  begin
    try
      RootKey := HKEY_CURRENT_USER;
      key:='\Software\DelphiForFun\Common';
      if not keyExists(key) then createkey(key);
      OpenKey('\Software\DelphiForFun\Common', True);
      writeString('WorkPath',NewPath);
      CloseKey;
    finally
      Free;
    end;
  end;
end;


{************* ChangeDFFCommonPath *************}
function ChangeDFFCommonPath:string;
{Prompt user for a new DFF Common path folder}
var
  Reg: TRegistry;
  r:boolean;
  key,path:string;
  buf:array[0..99] of char;
  n:integer;
begin
  Reg := TRegistry.Create;
  with reg do
  begin
    try
      RootKey := HKEY_CURRENT_USER;
      key:='\Software\DelphiForFun\Common';
      if not keyExists(key) then createkey(key);
      OpenKey('\Software\DelphiForFun\Common', True);
      path:=reg.readstring('WorkPath');
      if path='' then
      begin
        //n:=getenvironmentvariable(Pchar('USERPROFILE'),buf,100);
        path:=buf+ '\Local Settings\Temp';
      end;
      chdir(path);
      selectdirectory(result,[sdAllowCreate, sdPerformCreate, sdPrompt],0);
      writeString('WorkPath',result);
      CloseKey;
    finally
      Free;
    end;
  end;
end;

end.
