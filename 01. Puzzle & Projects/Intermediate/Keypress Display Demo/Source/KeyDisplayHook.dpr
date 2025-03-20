library KeyDisplayHook;
uses Windows, Classes, Messages;

type
  PHookRec = ^THookRec;
  THookRec = record
    AppHnd: Integer;
    MemoHnd: Integer;
  end;

 TGetChar = Procedure(Sender: TObject; aChar: Char) of object;

 var
  Hooked: Boolean;
  hKeyHook, hMemo, hMemFile, hApp: HWND;
  PHookRec1: PHookRec;


{************* KeyHookFunc ***************}
function KeyHookFunc(Code, VirtualKey, KeyStroke: Integer): LRESULT; stdcall;
var
  C: Char;
  WChar:array[0..1] of char;
  count:integer;
  KeyState1: TKeyBoardState;

begin
  Result := CallNextHookEx(hKeyHook, Code, VirtualKey, KeyStroke);
  if code<>HC_Action then exit;

  {a key notification has occured, prepare the HWNDs
   before checking the actual key state }
  if (hMemo = 0) or (hApp = 0) then
  begin
    if hMemFile = 0 then
    begin
      hMemFile := OpenFileMapping(FILE_MAP_WRITE, False, 'NetParentMAP');
      if hMemFile = 0 then Exit;
    end;
    if PHookRec1 = nil then
    begin
      PHookRec1 := MapViewOfFile(hMemFile, FILE_MAP_WRITE, 0, 0, 0);
      if PHookRec1 = nil then Exit;
    end;
    hMemo := PHookRec1.MemoHnd;
    hApp  := PHookRec1.AppHnd;
    if (hMemo = 0) and (hApp = 0) then exit;  {redundant?}
  end;
  if (Code=HC_Action) then
  begin
    If keystroke and $80000000 =0 then  {keydown}
    begin
      GetKeyboardState(keystate1);
      {update keyboard state with current shift key position!}
      keystate1[vk_shift]:=getkeystate(VK_shift);

      Count := ToAscii(VirtualKey, KeyStroke, KeyState1, WChar, 0);
      if Count = 1 then  {it is a simple 1 byte ascii character}
      begin
        C:=WChar[0];
        if hMemo <> 0 then SendMessage(hMemo, WM_CHAR, ord(C),0);
        if hApp <> 0 then PostMessage(hApp, WM_USER + 1678, virtualkey, 0);
      end;
    end;
  end;

end;


{*********** StartHook ***************}
function StartHook(MemoHandle, AppHandle: HWND): Byte; export;
begin
  Result:= 0;
  if Hooked then
  begin
    Result := 1;
    Exit;
  end;
  if not IsWindow(MemoHandle) then
  begin
    Result := 4;
    Exit;
  end;
  hKeyHook := SetWindowsHookEx(WH_KEYBOARD, KeyHookFunc, hInstance, 0);
  if hKeyHook > 0 then
  begin
    {We need to use a mapped file because this DLL attatches to every app
     that gets windows messages when it's hooked, and you can't get info except
     through a Globally avaiable Mapped file}
    hMemFile := CreateFileMapping($FFFFFFFF, // $FFFFFFFF gets a page memory file
      nil,                // no security attributes
      PAGE_READWRITE,      // read/write access
      0,                   // size: high 32-bits
      SizeOf(THookRec),           // size: low 32-bits
       'Global7v9k');    // name of map object
    PHookRec1 := MapViewOfFile(hMemFile, FILE_MAP_WRITE, 0, 0, 0);
    hMemo     := MemoHandle;
    PHookRec1.MemoHnd := MemoHandle;
    hApp      := AppHandle;
    PHookRec1.AppHnd := AppHandle;
    {set the Memo and App handles to the mapped file}
    Hooked := True;
  end
  else
    Result := 2;
end;

{*************** StopHook **************}
function StopHook: Boolean; export;
begin
  if PHookRec1 <> nil then
  begin
    UnmapViewOfFile(PHookRec1);
    CloseHandle(hMemFile);
    PHookRec1 := nil;
  end;
  if Hooked then
    Result := UnhookWindowsHookEx(hKeyHook)
  else
    Result := True;
  Hooked := False;
end;

 exports
  StartHook,
  StopHook;

begin
  PHookRec1 := nil;
  Hooked := False;
  hKeyHook := 0;
  hMemo := 0;
end.
