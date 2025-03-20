unit U_ArrangeListbox1;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
This is the initial version of a program which allows a listbox to be
rearranged by dragging items up or down.

This version uses Delphi, StdCtrls, Classes, Controls's built in drag/drop
methods to keep track of where the items is to be dropped and a heavy horizontal
line is drawn at the insertion point.   The actual movement of the selected item
takes place when the mouse button is release and the OnDragDrop event is processed.
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
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    draggedindex:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{******** FormCreate ********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  listbox1.dragmode:=dmAutomatic;
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
end;

{*********** ListBoxDragOver *********}
procedure TForm1.ListBoxDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragstate; Var Accept: Boolean);
begin
  Accept:=True;
end;

{************ ListBoxDragDrop *********}
procedure TForm1.ListBoxDragDrop(Sender, Source: TObject; X, Y: Integer);
{Called when the dragged cell is dropped}
var dropindex:integer;
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


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
