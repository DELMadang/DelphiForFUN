unit UTSyncMemo;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

Uses Messages,stdctrls;

type
   TSyncMemo=class(TCustomMemo)
  public
    synched:array of TCustomMemo;
    procedure WMVScroll(var Msg: TMessage); message WM_VSCROLL;
    procedure EMSetSel(var Msg: TMessage); message EM_SETSEL;
    procedure assignmemo(M:TMemo);
    procedure Setsynch(M:TCustomMemo);
  end;
implementation

{**************** TSyncMemo Methods **************}
procedure TSyncMemo.WMVScroll(var Msg: TMessage);
var i:integer;
begin
  for i:=0 to high(synched) do synched[i].perform(msg.Msg,msg.WParam,msg.LParam);
  inherited;
end;

procedure TSyncMemo.EMSetSel(var Msg: TMessage);
var i:integer;
begin
  inherited;
  for i:=0 to high(synched) do synched[i].perform(msg.Msg,msg.WParam,msg.LParam);
end;

procedure TSyncMemo.assignmemo(M:TMemo);
begin
  left:=M.left;
  top:=M.top;
  height:=m.height;
  width:=m.width;
  parent:=m.parent;
  name:='SYNC_'+m.name;
  scrollbars:=m.scrollbars;
end;



procedure TSyncMemo.Setsynch(M:TCustomMemo);
begin
  setlength(synched,length(synched)+1);
  synched[high(synched)]:=M;
end;

end.
 