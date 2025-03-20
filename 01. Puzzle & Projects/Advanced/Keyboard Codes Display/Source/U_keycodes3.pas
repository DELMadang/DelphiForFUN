unit U_keycodes3;
{Copyright © 2008-2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
A program to play with keyboard codes returned
when a key is pressed.

I used it to identify how to activate the "Pause"
key on my Dell laptop since they forgot to
document it in the Owners Manual.  (Fn key +
Insert key does the job.  The Fn key also
activates the Numeric Keypad simulator keys
embedded within the normal keys. )

In addition to the keyname displayed at top right,
the key press event codes are displayed.  Status
of the "toggle" keys is also displayed.

The device independent "Virtual Key Codes" are
available under the Virtual Key Codes tab. 
 *)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Memo4: TMemo;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    VKTable: TMemo;
    Events: TMemo;
    Label2: TLabel;
    StaticText1: TStaticText;
    Capslock: TStaticText;
    Label3: TLabel;
    Numlock: TStaticText;
    Label4: TLabel;
    scrollLock: TStaticText;
    Label5: TLabel;
    StaticText2: TStaticText;
    IncludeKeyDown: TCheckBox;
    ClearBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure StaticText2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClearBtnClick(Sender: TObject);
  public
    vk_list:TStringlist;
    vk_desc:array[0..255] of string;
    keypress:boolean;
    lshift,rshift,lcntrl, rcntrl, lmenu,rmenu:boolean;
    procedure Showkey(const key:string);
    procedure LoadVKStringList;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R VKeys.res}


var
  {the delimiters}
  delims: set of char=[' ', #9];

{*********** Getword *********}
function getword( var line:string):string;
{destructive getword, pass a copy of the original input since upon return the
 first word will have been removed and returned as the result of the function }
 {Used here to help parse the Virtual Key Code text file}
var
  i,start:integer;
begin
  result:='';
  if length(line)>0 then
  begin
    line:=line+' ';
    start:=1;
    while (line[start] in delims) do inc(start);
    i:=start+1;
    if i<=length(line) then
    while not (line[i] in delims) do inc(i);
    result:=copy(line,start,i-start);
    delete(line,1,i);
  end;
end;

{************** HexToInt **********}
function hextoint(input:string):integer;
{Convert hex string to an integer}
var
  i,next:integer;
  s:string;
begin
  result:=0;
  s:=trim(uppercase(input));
  for i:=1 to length(s) do
  begin
    if s[i] in ['0'..'9']
    then next:= ord(s[i])-ord('0')
    else if s[i] in ['A'..'F']
    then next:= ord(s[i])-ord('A')+10
    else next:=0;
    result:=result*16+next;
  end;
end;

{********** LoadVKStringList}
procedure TForm1.LoadVKStringList;
Var ResourceStream:  TResourceStream;
begin
  ResourceStream := TResourceStream.Create(hInstance, 'STRINGLIST', RT_RCDATA);
  Try
    VK_List.LoadFromStream(ResourceStream);
  Finally  ResourceStream.Free
  end;
end;

{************ FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,j,n:integer;
  start,stop:integer;
  keyname,line,s:string;
begin

  {Load the Virtual key definition table from a text file}
  VK_List:=TStringlist.create;
  LoadVKStringList;  {Load list from resource}
  {retain the option of allowing local override of the standard VKey codes
   definitions if the Vkeys.txt file is available}
  if fileExists('NewVKeys.txt') then VK_List.loadfromfile('NewVKeys.txt');


  for i:=0 to VK_List.count-1 do
  begin
    line:=VK_List[i];
    keyname:=getword(line);  {skip the first word}
    if keyname[1]='V' then keyname:='('+keyname+')' else keyname:='';
    s:=getword(line);
    n:=pos('-',s);
    if n>0 then {this line specifies a range of entries with the same value}
    begin
      start:=hextoint(copy(s,1,n-1));
      delete(s,1,n);
      stop:= hextoint(s);
    end
    else
    begin
      start:=hextoint(s);
      stop:=start;
    end;
    s:=trim(line); {get the description}
    for j:=start to stop do
    begin
      vk_desc[j]:=s;
      s:=stringofchar('.',20-length(s))+s;
      VKTable.lines.add(format('%3d  %32s %s',[j,s,keyname]));
    end;
  end;

  {Initialize the toggle key displays}
  if 1 and getkeystate(vk_capital)>0 then capslock.caption:='ON'
  else capslock.caption:='OFF';
  if 1 and getkeystate(VK_Numlock)>0 then numlock.caption:='ON'
  else numlock.caption:='OFF';
  if 1 and getkeystate(VK_Scroll)>0 then ScrollLock.caption:='ON'
  else ScrollLock.caption:='OFF';

  //if 1 and getkeystate(VK_Insert)>0 then Insert.caption:='ON'
  //else Insert.caption:='OFF';
end;

{********** ShowKey *********}
procedure TForm1.Showkey(const key:string);
{display the key value or key name}
begin
  statictext1.caption:=' '+trim(key)+' ';
end;

(****************** GetExtendedKeys *********)
function GetExtendedKeys(shift:TShiftState):string;
var ctlkeys:string;
begin
  ctlkeys:=' ';
  if ssShift in shift then
  begin
    if getkeystate(VK_LShift)<0 then ctlkeys:='Shift{Left}+'
    else if getkeystate(VK_RShift)<0 then ctlkeys:='Shift{Right}+';
  end;
  if ssAlt in shift then
  begin
    if getkeystate(VK_LMenu)<0 then ctlkeys:=ctlkeys+'Alt{Left}+'
    else if getkeystate(VK_RMenu)<0 then ctlkeys:=ctlkeys+'Alt{Right}+';
  end;
  if ssCtrl in shift then
  begin
    if getkeystate(VK_LControl)<0 then ctlkeys:=ctlkeys+'Ctrl{Left}+'
    else if getkeystate(VK_RControl)<0 then ctlkeys:=ctlkeys+'Ctrl{Right}+';
  end;
  delete(ctlkeys,length(ctlkeys),1); {get rid of final '+'}
  result:=ctlkeys;
end;


(**************** FormKeyDown *************)
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var
  msg:string;
  keyname,ctlkeys:string;
begin
  
  if not includekeydown.checked then exit;
  msg:='';
  {make message for control keys  down}
  ctlkeys:=GetExtendedKeys(Shift);
  {Make upper/lower case keyname for letters}
  if (not (ssshift in shift)) and (key>=$41) and (key<=$5a)
  then keyname:=lowercase(vk_desc[key])
  else keyname:=vk_desc[key];
  {Display the key name}
  showkey(keyname);

  {Update display for toggle keys (Capslock, NumLock, Scrolllock)}
  if key=vk_capital then
  begin
    if 1 and getkeystate(key)>0 then capslock.caption:='ON'
    else capslock.caption:='OFF';
  end;
  if key=vk_Numlock then
  begin
    if 1 and getkeystate(key)>0 then numlock.caption:='ON'
    else numlock.caption:='OFF';
  end;
  if key=vk_Scroll then
  begin
    if 1 and getkeystate(key)>0 then ScrollLock.caption:='ON'
    else ScrollLock.caption:='OFF';
  end;
  (*
  if key=vk_Insert then
  begin
    if 1 and getkeystate(key)>0 then Insert.caption:='ON'
    else Insert.caption:='OFF';
  end;
  *)

  {Add message to the list of events}
  events.lines.add(format('OnKeyDown, Key code=%d, Control keys=%s, Key name %s',
        [key, ctlkeys, keyname]));
  key:=0;  {no further processing for this key}

end;


{*************** FormKeyPress ***********}
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
{OnKeyPress exit - taken for all normal character key presses}
var n:integer;
begin
  events.lines.add('OnKeyPress '+ key);
  showkey(key);
  n:=getkeystate(VK_LShift);
  if n<0
  then lshift:=true
  else lshift:=false;
  if getkeystate(VK_RSHIFT)<0
  then Rshift:=true
  else Rshift:=false;
  key:=#00;
  keypress:=true;  {flag to tell KeyUp exit that key has been handled}
end;


{********** FormKeyUp **********}
procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Key preview exit - handles all keystrokes which generate a scan code}
var
  msg:string;
  keyname,ctlkeys:string;
begin
  msg:='';
  {make message for control keys still down}
  ctlkeys:=GetExtendedKeys(Shift);
  (*
  ctlkeys:=' ';
  if ssShift in shift then
  begin
    msg:='';
    if lshift then msg:='{Left}';
    if rshift then msg:=msg+'{Right}';
    ctlkeys:='Shift'+msg+'+';
  end;

  if ssAlt in shift then ctlkeys:=ctlkeys+'Alt+';
  if ssCtrl in shift then ctlkeys:=ctlkeys+'Ctrl+';
  delete(ctlkeys,length(ctlkeys),1); {get rid of final '+'}
  *)

  {Make upper/lower case keyname for letters}
  if (not (ssshift in shift)) and (key>=$41) and (key<=$5a)
  then keyname:=lowercase(vk_desc[key])
  else keyname:=vk_desc[key];

  {Display the key name if it was not handled by KeyPress exit and is not just
   the exit for a control key being released}
  if ((not keypress) and (key<>VK_Shift) and (key<>VK_MENU) and (key<>VK_CONTROL))
     or (keypress and ((key=VK_Escape) or (key=VK_BACK) or (key=VK_RETURN)))
    then showkey(keyname);

  {Update display for toggle keys (Capslock, NumLock, Scrolllock)}
  if key=vk_capital then
  begin
    if 1 and getkeystate(key)>0 then capslock.caption:='ON'
    else capslock.caption:='OFF';
  end;
  if key=vk_Numlock then
  begin
    if 1 and getkeystate(key)>0 then numlock.caption:='ON'
    else numlock.caption:='OFF';
  end;
  if key=vk_Scroll then
  begin
    if 1 and getkeystate(key)>0 then ScrollLock.caption:='ON'
    else ScrollLock.caption:='OFF';
  end;
  (*
  if key=vk_Insert then
  begin
    if 1 and getkeystate(key)>0 then Insert.caption:='ON'
    else Insert.caption:='OFF';
  end;
  *)

  {Add message to the list of events}
  events.lines.add(format('OnKeyup, Key code=%d, Control keys=%s, Key name %s',
        [key, ctlkeys, keyname]));
  //if (not keypress) {there was not real keypress}
  //   or (keypress and (ctlkeys=''))  {there was a keypress with no ctrl keys}
  if (ctlkeys='')
  //   or (keypress and (ctlkeys=''))  {there was a keypress with no ctrl keys}
  then events.lines.add(''); {then add and extra blank line to mark end}
  key:=0;  {no further processing for this key}
  keypress:=false;
end;







procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  events.Clear;
end;

end.
