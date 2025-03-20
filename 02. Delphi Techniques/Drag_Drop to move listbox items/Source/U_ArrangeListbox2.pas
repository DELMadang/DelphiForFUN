unit U_ArrangeListbox2;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
This is version 2 of a program which allows a listbox to be
rearranged by dragging items up or down.

This version uses Delphi, StdCtrls, Classes, Controls's built in drag/drop
methods to keep track of where the items is to be dropped and a heavy horizontal
line is drawn at the insertion point.   The actual movement of the selected item
takes place when the mouse button is released and the OnDragDrop event is processed.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    StaticText1: TStaticText;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure ListBoxStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    draggedindex:integer;
    dropindex:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{******** FormCreate ********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  with listbox1 do
  begin
    doublebuffered:=true; {stop flicker while redrawing}
   {These three properties could be pre-set at design time, set here just to
    document the changes}
    dragmode:=dmAutomatic;
    itemheight:=canvas.textheight('Ay')+5;
    height:=(height div itemheight)*itemheight+8;

  end;
end;

{****** FormActivate *****}
procedure TForm1.FormActivate(Sender: TObject);
var  a:char;
begin
  listbox1.clear;
  for a:= 'A' to 'Z' do listbox1.items.add(StringofChar(a,8));
end;

{********** ListBoxStartDrag *******}
procedure TForm1.ListBoxStartDrag(Sender: TObject; var DragObject: TDragObject);
{Keep track of the index of the item to be dragged}
begin
  draggedindex:=Listbox1.itemindex;
  listbox1.itemindex:=-1;
end;

{*********** ListBoxDragOver *********}
procedure TForm1.ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
                                 State: TDragState; var Accept: Boolean);
{Dragging across a cell.  Keep track of the index so we can indicate that it is
 the current drop point when the cell is redrawn.}

      function nochange(s:string):string;
      begin
        result:=s;
      end;

var previndex:integer;
begin
  accept:=true;
  with listbox1 do
  begin
    previndex:=dropindex;
    dropindex:=itemAtPos(point(x,y),true);
    if dropindex>=0 
    then listboxdrawitem(listbox1,dropindex,itemrect(dropindex),[]);
    if (previndex>=0) and (previndex<>dropindex)
    then listboxdrawitem(listbox1,previndex,itemrect(previndex),[]);
  end;
end;

{************ ListBoxDragDrop *********}
procedure TForm1.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
{Called when the dragged cell is dropped}
begin
  dropindex:=listbox1.itemAtPos(point(x,y),false); {this is where to drop it}
  {The "move" call below  will shift items up or down as necessary from
  dropindex to the slot evacuated by the dragged object to make room for the
  dragged index at the dropindex location}
  if dropindex>=0 then
  begin
    listbox1.items.move(draggedindex, dropindex); {move the dragged item}
    listbox1.itemindex:=dropindex;  {keep it as the selected item}
  end;

end;

{*************** ListBoxDrawItem ************}
procedure TForm1.ListBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
{Called each time a listbox item needs to be drawn.  We'll write the item data
 to the canvas and then if we are draggining over this item, draw a line above
 or below the text to indicate where the item being dragged will be dropped.
 Above or below devpending on which direction the item is moving.}

begin
  with listbox1, canvas, rect do
  begin
    {highlight the selected item}
    if (odselected in state) then brush.color:=clHighlight
    else brush.color:=color;
    fillrect(rect);
    textout(left+3, top+3, items[index]);
    if dragging and (index=dropindex) then
    begin
      pen.width:=2;
      pen.color:=clred;
      if index>draggedindex then
      begin
        moveto(rect.left, rect.bottom-1);
        lineto(rect.right,rect.bottom-1);
      end
      else
      begin
        moveto(rect.left, rect.top+2);
        lineto(rect.right,rect.top+2);
      end;
      pen.width:=1;
      pen.color:=clblack;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
