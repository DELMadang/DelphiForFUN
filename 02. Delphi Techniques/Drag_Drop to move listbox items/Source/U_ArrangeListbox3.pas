unit U_ArrangeListbox3;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{This is the third version of a program which allows listbox items to be
 rearranged by dragging up or down.

 This version replaces Delphi's built in drag/drop processing with
 Mouse events.  The advantage is we can capture the mouse so that when the
 cursor moves above or below the listbox we can start automatic scrolling to
 bring additional items into view. }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, ExtCtrls;

type
  TForm1 = class(TForm)
    Listbox2: TListBox;
    Button1: TButton;
    StaticText1: TStaticText;
    Memo1: TMemo;
    Verbose: TCheckBox;
    scrollList: TTimer;
    procedure ResetBtnClick(Sender: TObject);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Listbox2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Listbox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Listbox2MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure scrollListTimer(Sender: TObject);
  public
    draggedindex:integer;
    dropindex, previndex:integer;
    lastitemincrement:integer;
    dragflag:boolean;
    scrollamt:integer; {controls scroll direction when autoscrolling during drag}

    {variables used by debug routine to detect changes}
    savedraggedindex,saveddropindex,savedtopindex,savedbottemindex:integer;

    {Operations performed from several places, so encapsulated in procedures}
    procedure RedrawItems;
    Procedure StopTimer;
     procedure debug(const msg:string; const force:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{******** FormCreate ********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  with Listbox2 do
  begin
    doublebuffered:=true;
   {These three properties could be pre-set at design time, set here just to
    document the changes}
    {set item height to allow extra room for horizontal "drop here" lines}
    itemheight:=canvas.textheight('Ay')+5;
    {Set listbox height to allow room for integral # of items plus a few pixels
     extra for the outline lines}
    height:=(height div itemheight)*itemheight+8;
    lastitemincrement:=height div itemheight-1;{added to to topindex gives bottomindex}
  end;
  resetbtnclick(sender);
end;

{****** ResetBtnclick *****}
procedure TForm1.ResetBtnClick(Sender: TObject);
var  a:char;
begin
  Listbox2.clear;
  for a:= 'A' to 'Z' do Listbox2.items.add(StringofChar(a,8));
  dragflag:=false;
end;

{************* Listbox2MouseDown **************}
procedure TForm1.Listbox2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Keep track of the index of the item to be dragged}
begin
  draggedindex:=Listbox2.itemindex;
  Listbox2.itemindex:=-1;

  {we need to capture the mouse so that we can get feedback even when mouse
   is above or below the listbox and we can then scroll non-displayed items into view}
  dragflag:=true;
  setcapturecontrol(Listbox2);
  stoptimer;



  If verbose.checked then
  begin
    memo1.clear;
    debug('StartDrag',true);
  end;
end;

{************** Listbox2MouseMove ***********}
procedure TForm1.Listbox2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{Dragging across a cell.  Keep track of the index so we can indicate that it is
 the current drop point when the cell is redrawn.}
begin
  if not dragflag then exit;
  if verbose.checked then debug('MouseMoveIN('+inttostr(x)+','+Inttostr(y)+')',True);
  with Listbox2 do
  begin
    {if mouse is back within bounds, then stop auto-scrolling}
    if (y>=0) and (y<=height) and scrolllist.enabled then stoptimer;
    if not (ScrollList.enabled) then
    begin  {Scrolling is not taking place}

      if (y<0) or (y>=height) then {start scrolling}
      begin {Mouse has moved outside of field, scroll the listbox as appropriate}
        if (y>height) and (not scrollList.enabled) and (dropindex<items.count-1) then
        begin
          scrollamt:=+1;
          If verbose.checked then debug('Start scroll down',true);
          scrollList.enabled:=true;
        end
        else
        {if mouse is high and  not at top then start scroll up }
        if (y<0) and (not scrollList.enabled) and (topindex>0)then
        begin
          scrollamt:=-1;
          If verbose.checked then debug('Start scroll up',true);
          if  (topindex>0) then scrollList.enabled:=true;
        end;
      end
      else {mouse is in range}
      begin
        dropindex:=itemAtPos(point(0,y),true);
        If verbose.checked then debug('After Dropindex calc',false);
        if dropindex<0 then dropindex:=topindex+lastitemincrement;
        if scrollList.enabled then stoptimer;
        RedrawItems;
      end;
    end;
  end;
  if verbose.checked then debug('MouseMoveOut',false);
end;

{**************** Listbox2.mouseup ****************}
procedure TForm1.Listbox2MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Called when the dragged cell is dropped}
begin
  if not dragflag then exit;
  stoptimer; {in case we were scrolling}

  {The "Move" below will shift up or down as necessary from dropindex to the
   slot evacuated by the dragged object to make room for the dragged index at
   the dropindex location}
  if dropindex>=0 then
  begin
    Listbox2.items.move(draggedindex, dropindex); {move the dragged item}
    Listbox2.itemindex:=dropindex;  {keep it as the selected item}
  end;
  releasecapture; {release mouse control}
  dragflag:=false; {turn off the dragging flag}
  
  If verbose.checked then debug('DropEnd',false);
end;

{*************** ListBoxDrawItem ************}
procedure TForm1.ListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
{Called each time a listbox item needs to be drawn.  We'll write the item data
 to the canvas and then if we are draggining over this item, draw a line above
 or below the text to indicate where the item being dragged will be dropped.
 Above or below devpending on which direction the item is moving.}

begin
  with Listbox2, canvas, rect do
  begin
    {highlight the selected item}
    if (odselected in state) then brush.color:=clHighlight
    else brush.color:=color;
    fillrect(rect);
    textout(left+2, top+2, items[index]);
    if dragflag and (index=dropindex) then
    begin
      pen.width:=2;
      pen.color:=clred;
      if index>draggedindex then
      begin
        moveto(rect.left, rect.bottom-2);
        lineto(rect.right,rect.bottom-2);
      end
      else
      begin
        moveto(rect.left, rect.top+2);
        lineto(rect.right,rect.top+2);
      end;
      pen.width:=1;
      pen.color:=clBlack;
    end;
  end;
end;

{************* Redrawitems ************}
procedure TForm1.Redrawitems;
{now force the old and new "dragto" items to be redrawn}
begin
  if (draggedindex<>dropindex) then {only draw if not dropping on self}
  with listbox2 do
  begin
    ListBoxDrawItem(Listbox2, previndex, Itemrect(previndex), []);
    if (dropindex <>previndex) then
    begin {only redraw current drop if different than previous draw}
      {for example when mosue moves within an item prev and current may be the same}
      ListBoxDrawItem(Listbox2, dropindex, Itemrect(dropindex), []);
      previndex:=dropindex;
    end;
  end;
end;

{************** ScrollListTimer ***********8}
procedure TForm1.scrollListTimer(Sender: TObject);
{Timer pop routine called to automatically scroll the
 listbox to bring the desired drop point into view.  Scrolling
 is one item per timer pop.}
var
  newindex:integer;
begin
  {After first scroll, set scroll rate at .25 seconds per item}
  scrollList.interval:=250;
  with Listbox2 do
  begin
    newindex:=Listbox2.topindex+scrollamt;
    if (newindex>=0) and (newindex<items.count)
    then
    begin
      previndex:=dropindex;
      if (dropindex=0) or (dropindex=items.count-1)
        or (itematpos(screentoclient(mouse.cursorpos),true)>=0)
      then stoptimer
      else
      begin
        if scrollamt>0 then dropindex:=newindex+lastitemincrement
        else dropindex:=newindex;
      end;
      topindex:=newindex;
      redrawitems;
    end;
  end;
end;

{********** Stoptimer ********}
procedure TForm1.Stoptimer;
{We have a couple of things to do when scrolling is stopped, and we do it from
 several places, so might as well put it in a procedure}
begin 
  with scrollList do
  begin
    enabled:=false;
    interval:=500;
  end;
end;

{***************** Debug ***************}
procedure tform1.debug(const msg:string; const force:boolean);
{displays a message plus current index values when called}

  function changed:boolean;
  begin
    result:=(savedraggedindex<>draggedindex)
            or(saveddropindex<>dropindex) or (savedtopindex<>Listbox2.topindex)
            or (savedbottemindex<>Listbox2.topindex+lastitemincrement);
  end;

begin
  if force or changed then {force=true ==> always display, otherwise only if data changed}
  memo1.lines.add(format('%s dragidx %d, dropidx %d, topidx %d, botidx %d',
                   [msg,draggedindex, dropindex, Listbox2.topindex, Listbox2.topindex+lastitemincrement]));
  {save current values before exit}
  savedraggedindex:=draggedindex;
  saveddropindex:=dropindex;
  savedtopindex:=Listbox2.topindex;
  savedbottemindex:=Listbox2.topindex+lastitemincrement;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
