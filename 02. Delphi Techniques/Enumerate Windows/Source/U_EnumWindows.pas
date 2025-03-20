unit U_EnumWindows;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A test program to enumerate all top level windows on the screen or
 check for a specific window }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, extctrls,TlHelp32;

type
  TForm1 = class(TForm)
    ListWindowsBtn: TButton;
    ListBox1: TListBox;
    SearchForEdt: TEdit;
    LookForBtn: TButton;
    Foundlbl: TLabel;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    ListProgsBtn: TButton;
    ListBothBtn: TButton;
    procedure ListWindowsBtnClick(Sender: TObject);
    procedure LookForBtnClick(Sender: TObject);
    procedure SearchForEdtChange(Sender: TObject);
    procedure ListProgsBtnClick(Sender: TObject);
    procedure ListBothBtnClick(Sender: TObject);
  public
   end;

var   Form1: TForm1;

implementation

{$R *.DFM}


{****************** GetWindowExeName ***********}
function GetWindowExeName(Handle: THandle): String;
{Given a window handlew, return the program name}
var
 PE: TProcessEntry32;
 Snap: THandle;
 ProcessId: cardinal;
begin
  result:='???';
  pe.dwsize:=sizeof(PE);
 GetWindowThreadProcessId(Handle,@ProcessId);
 Snap:= CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
 if Snap <> 0 then
 begin
   if Process32First(Snap, PE) then
     if PE.th32ProcessID = ProcessId then
       Result:= String(PE.szExeFile)
     else while Process32Next(Snap, PE) do
       if PE.th32ProcessID = ProcessId then
       begin
         Result:= String(PE.szExeFile);
         break;
       end;
   CloseHandle(Snap);
 end;
end;

{***************************************************}
{******* The callback functions ********************}
{******* in three flavors: *************************}
{******* NextWindow, NextProgram, NextBoth     *****}
{***************************************************}

      {**************** NextWindow ****************}
      function NextWindow(wnd:Thandle;list:Tstringlist):boolean;  stdcall;
      {This is the callback function which is called by EnumWindows procedure
       for each top-level window.  Return "true" to keep retrieving, return
       "false" to stop EnumWindows  from calling}
      var title:array[0..255] of char;
      begin
        getwindowtext(wnd,title,256);
        list.add(pchar(@title));
        result:=true;
      end;

      {**************** NextProgram ****************}
      function Nextprogram(wnd:Thandle;list:Tstringlist):boolean;  stdcall;
      {This is the callback function which is called by EnumWindows procedure for each
       top-level window.  Return "true" to keep retrieving, return "false" to stop
       EnumWindows  from calling}
      var s:string;
      begin
        s:=getWindowexename(wnd);
        if list.indexof(s)<0 then list.add(s);
        result:=true;
      end;

      {**************** NextBoth ****************}
      function Nextboth(wnd:Thandle;list:Tstringlist):boolean;  stdcall;
      {This is the callback function which is called by EnumWindows procedure for each
       top-level window.  Return "true" to keep retrieving, return "false" to stop
       EnumWindows  from calling}
      var s:string;
          title:array[0..255] of char;
      begin
        getwindowtext(wnd,title,256);
        s:=getWindowexename(wnd);
        list.add(s+': '+pchar(@title));
        result:=true;
      end;


 {************* Buttons ************}

{*************** ListAllBtn *************}
procedure TForm1.ListWindowsBtnClick(Sender: TObject);
{Calls EnumWindows to list all top-level window titles in Listbox1}
begin
  listbox1.clear;
  enumwindows(@nextwindow,lparam(listbox1.items)); {pass the list as a parameter}
end;

{************** :ostProgsBtnClick **********}
procedure TForm1.ListProgsBtnClick(Sender: TObject);
begin
  listbox1.clear;
  enumwindows(@nextprogram,lparam(listbox1.items)); {pass the list as a parameter}
end;

{******************* ListBothBtnClick **********}
procedure TForm1.ListBothBtnClick(Sender: TObject);
begin
  listbox1.clear;
  enumwindows(@nextboth,lparam(listbox1.items)); {pass the list as a parameter}
end;

{************* IsRunning **************}
function isrunning(s:string):boolean;
{Calls EnumWindows to check for a specific program,
 returns boolean value  True if found, False otherwise}
var
  i:integer;
  proglist:Tstringlist;
begin
  result:=false;
  proglist:=Tstringlist.create;
  enumwindows(@nextprogram,lparam(proglist)); {pass the list as a parameter}
  with proglist do
  for i:=0 to proglist.count-1 do
  if comparetext(s,proglist[i])= 0 then
  begin
    result:=true;
    break;
  end;
  proglist.free;
end;

{************* LookForBtnClick *************}
procedure TForm1.LookForBtnClick(Sender: TObject);
{Make a list of top-level windows and search for a secific title}
begin
  with foundlbl do
  If isrunning(SearchForEdt.text) then caption:='Running'
  else caption:='Not Running';
end;

{**************** SearchForEdtChange ************}
procedure TForm1.SearchForEdtChange(Sender: TObject);
begin
  foundlbl.caption:=''; {erase previous result when window search name changes}
end;





end.
