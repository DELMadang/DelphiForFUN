unit U_MouseEnterLeave;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, shellapi;

type
  {Here;s a descendant of Tshape which will have procedures called when the
   mouse cursor enters and leaves shape rectangle}
  TMyShape=class(TShape)
    procedure CMMouseEnter(var Msg: TMessage); message CM_MouseEnter;
    procedure CMMouseLeave(var Msg: TMessage); message CM_MouseLeave;
    procedure assign(proto:TShape);
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Shape2: TShape;
    Shape1: TShape;
    IdLbl: TLabel;
    StaticText1: TStaticText;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Square:TMyShape;
    Circle:TMyShape;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Procedure TMyShape.assign(proto:TShape);
{we'll only copy the critical published properties of the model Tshape and those
 which we might have changed}
begin
  left:=proto.left;
  top:=proto.top;
  width:=proto.width;
  height:=proto.height;
  parent:=proto.parent;
  shape:=proto.shape;
  brush.assign(proto.brush);
  pen.assign(proto.pen);
  name:='My'+proto.name;  {Make a new name based on prototype name}
  onmousemove:=proto.onmousemove;
end;


{************ CMMouseEnter ************}
procedure TMyShape.CMMouseEnter(var Msg: TMessage);
{Message received when mouse enters the shape rectangle}
begin
  form1.IdLbl.caption:='Cursor is in '+name;
  brush.color:=brush.color*2;  {Make it brighter - only works with selected colors
                                i.e only one of red,green,blue bytes set and
                                that one has value <=127}
end;

{************** CMMouseLeave ************}
procedure TMyShape.CMMouseLeave(var Msg: TMessage);
{Message received whe the mouse leaves the shape}
begin
  with form1.IdLbl do
  begin
    caption:='Cursor not in any shape';
    left:=20;
    top:=parent.height-20;
  end;
  brush.color:=brush.color div 2; {Make it dimmer, only works with selected colors}
end;

{************** FormCreate ******************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  Square:=TMyShape.create(self); {Make the new shapes}
  square.assign(shape1);  {Get info for the new shapes from shapes laid out visually}
  Circle:=TMySHape.create(self);
  Circle.assign(shape2);
  shape1.free;  {these shapes were just an easy way to get layout, we may as well}
  shape2.free;  {delete them now}
  idlbl.BringToFront;  {otherwise label will be behind the shapes}
  idlbl.caption:='';
end;

{**************** ShapeMouseMove ************}
procedure TForm1.ShapeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer );
{Move idlbl to follow the mouse cursor as it moves over the shape}
begin
  with TMyShape(sender) do
  begin
    {Note: the 5 pixel offsets in the following positioning keep the label from
     overlapping the mouse cursor.  If it does overlap, the shape will receive
     extra MousLeave and MouseEnter messages as the mouse get assigned to the
     label then to the shape}
    if left+x+5+idlbl.width<parent.width {if label right of cursor will fit on the panel}
    then idlbl.left:=left+5+x  {then move it there}
    else idlbl.left:=left+x-idlbl.width; {otherwise move it to the left side of cursor}
    idlbl.top:=top+y-idlbl.height-5;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
