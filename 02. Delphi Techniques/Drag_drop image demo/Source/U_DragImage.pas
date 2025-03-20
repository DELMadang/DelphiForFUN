unit U_DragImage;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A drag/drop demo with separate scroll boxes for dragged objects "home" location
 and  area for target panels.  Dragcontrol images are the shape and color
 of the dragged shapes.  Shapes dropped on panel may be snapped" to top left
 positions}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ImgList, Contnrs, ShellAPI;

type

  {A class to hold the dragged objects}
  TMyDragObject = class(TDragControlObject)
  protected
    function GetDragImages: TDragImageList; override;
  end;

  {Main form}
  TForm1 = class(TForm)
    Panel1: TPanel;
    shape1:TShape;
    shape2:TShape;
    shape3:TShape;
    shape4:TShape;
    shape5:TShape;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Panel2: TPanel;
    Panel3: TPanel;
    DragImageList: TImageList;
    SnapBox: TCheckBox;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    StaticText1: TStaticText;
    Memo1: TMemo;

    {Set up a shape for dragging}
    procedure Shape1StartDrag(Sender: TObject;
      var DragObject: TDragObject);

    procedure FormCreate(Sender: TObject);


    {exit when dragging over or dropping a shape on a panel}
    procedure Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Panel1DragDrop(Sender, Source: TObject; X, Y: Integer);


    {Used when dragging over or dropping a shape on another shape(i.e.itself
     for a small adjustment move)}
    procedure Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);


    {checkbox for snapping objects up and left}
    procedure SnapBoxClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);

  public
    PartsList:TObjectList; {List of the parts that may be dragged/dropped}
    hotx,hoty:integer; {Used to keep track of image offset from clicked position}
    {test if shape overlaps another shape already in place}
    function overlaps(sender:TWincontrol; shape:Tshape; x,y:integer):boolean;

    {Snap the shape up and left as far as possible without overlapping another}
    function snap(shape:Tshape):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* IsBetween **************}
function IsBetween(i1,i2,i3:integer):boolean;
{return true if i1>i2 and i1<i3}
begin
  If (i1>i2) and (i1<i3) then result:=true
  else result:=false;;
end;

{************ GetDragImages **********}
function TMyDragObject.GetDragImages: TDragImageList;
{called at drag start time to get the image to be dragged}
begin
  Result := form1.DragImageList;
end;

{************** FormCreate *************8}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  {Must add csDisplayDragImage to the ControlStyle of each control that is to
   diaply drag images}
  ControlStyle := ControlStyle + [csDisplayDragImage];
  {Create list of shapes which the pieces to be dropped}
  PartsList:=TObjectlist.create;

  {Fix up controlStyle property for all controls and child controls of scrollboxes
   (the shapes for Scrollbox1 and the panels on Scrollbox2)}
  for i:=0 to controlcount-1 do
  with controls[i] do
  begin
    controlstyle:=ControlStyle + [csDisplayDragImage];
    if controls[i] is TScrollbox then
    begin
      if controls[i]=Scrollbox1 then
      begin  {Scrollbox1 (the shapes parent) may accept pieces back}
        TScrollbox(controls[i]).ondragover:=Panel1DragOver;
        TScrollbox(controls[i]).ondragdrop:=Panel1DragDrop;
      end;

      with controls[i]as TScrollbox do
      begin
        for j:=0 to controlcount-1 do {for all controls belonging to the scrollboxes}
        begin
          with controls[j] do controlstyle:=ControlStyle + [csDisplayDragImage];
          if controls[j] is TShape then
          begin
            Partslist.add(controls[j]); {add shape to list}
            with controls[j] as TShape do
            begin  {shapes may accept drops if other conditions are met}
              ondragover:=Shape1DragOver;
              ondragdrop:=Shape1DragDrop;
            end;
          end
          else if controls[j] is TPanel then
          begin
            with controls[j] as TPanel do
            begin  {panels may accept dropped shapes}
              ondragover:=Panel1DragOver;
              ondragdrop:=Panel1DragDrop;
            end;
          end;
        end;
      end;
    end;
  end;
end;

{*************** Overlaps *************}
function TForm1.overlaps(sender:TWincontrol; shape:Tshape; x,y:integer):boolean;
{Check to see if shape at (x,y) would overlap any inplace shapes}
var
  i:integer;
  r:Trect; {holds boundary rectangle for shape being dropped}
  rr:Trect; {work rectangle }
  shape2:TShape;
  begin
    Result:=false;
    {the rectangle coordinates relative to the sender (the panel)}
    r:=rect(x-hotx,y-hoty,x+shape.width-hotx,y+shape.height-hoty);

    {first make sure that it is entirely inside the sender -no intersect}
    intersectrect(rr,r,sender.clientrect);
    if not equalrect(rr,r) then result:=true {r needs to be entirely inside the
                                             or scrollbox}
    else
    begin
      {check to make sure that this piece does not overlap any already in place}
      with PartsList do
      for i:=0 to count-1 do
      begin
        shape2:=TShape(items[i]);
        if (shape2<>shape) and (sender=shape2.parent) and (intersectrect(rr,r,shape2.boundsrect)) then
        begin {shapes overlap, deny drop}
          result:=true;
          break;
        end;
      end;
    end;
  end;


{************** Panel1dragDrop **************}
procedure TForm1.Panel1DragDrop(Sender, Source: TObject; X, Y: Integer);
{Dropping a hape on a panel}
var
  shape:Tshape; {points to shape being dropped, just for ease of reference}
begin
  if source is tMyDragObject then
  with source as TMyDragObject do
  begin
    shape:=Tshape(control);
    {Make sure it does overlap any other shape}
    if not overlaps(TWincontrol(sender),shape,x,y) then
    begin {no overlap}
      {move the shape}
      shape.parent:=TWincontrol(sender);
      shape.left:=x-hotx;
      shape.top:=y-hoty;

      {If we are dropping on a panel then snap it if option is set and add it
       to "PartInPlace" list}
      if (shape.parent is TPanel) and snapbox.checked then snap(shape);
    end;
  end;
end;

{************* PanelDragOver ************8}
procedure TForm1.Panel1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{dragging a shape over a panel or the scrollbox}
var  shape:TShape;
begin
  if source is TMyDragObject then
  with source as TMyDragObject do
  begin
    shape:=Tshape(control);
    if not overlaps(TWincontrol(sender),shape,x,y) then accept:=true
    else accept:=false;
  end;
end;

{**************** ShapeStartDrag ************}
procedure TForm1.Shape1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
{set up the dragimage list to reflect the image being dragged}
var
  b:TBitmap;
  index:integer;
  p:TPoint;
begin
  if sender is TShape then
  with sender as TShape do
  begin
    dragImageList.clear;
    dragimagelist.height:=height;
    dragimagelist.width:=width;
    b:=tBitmap.create;
    b.width:=width;
    b.height:=height;
    with b.canvas do
    begin
      brush.color:=tshape(sender).brush.color;
      brush.style:=bssolid;
      case shape of
        stRectangle: rectangle(0,0,width,height);
        stRoundrect: roundrect(0,0,width,height, width div 4, height div 4);
      end;
    end;
    if DragImageList.Add(b,nil)<0 then showmessage('Dragmage add failed');
    p:=screentoclient(mouse.cursorpos);
    hotx:=p.x;  {keep track of cursor location relative to top left corner }
    hoty:=p.y;  {of the shape being dragged}

    dragimagelist.setdragimage(0,hotx,hoty);   {set the drag image}
    DragObject := TMyDragObject.Create(Tshape(Sender)); {Create the drag object}
    {remove from PartsList list is there}
    //index:=PartsList.indexof(TShape(sender));
    //if index>=0 then PartsList.extract(Tshape(sender));
  end;
end;

{************** ShapeDragOver ***************}
procedure TForm1.Shape1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{shape can drag over other shapes, but only drop on itself!}
var
  shape:TShape;
begin
  if source is TMyDragObject then
  with source as TMyDragObject do
  begin
    shape:=TShape(control); {shape is the object being dragged, sender is the object
                             being dragged over - check if they are the sme}
    if  (sender<>shape) then accept:=false else
      {even if dragging over ourselves, don't drop on another shape}
      accept:=not overlaps(shape.parent,shape,shape.left+x,shape.top+y);
  end;
end;

{************ ShapeDragDrop *****************}
procedure TForm1.Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
var   shape:TShape;
begin
  if source is TMyDragobject then
  with source as TMyDragObject do
  begin
    shape:=Tshape(control);
    if (sender=shape)then {dropping on ourselves, move the shape}
    begin
      shape.left:=shape.left+x-hotx;
      shape.top:=shape.top+y-hoty;
      {snap if dropping on panel and option is checked}
      if shape.parent is TPanel then
      begin
        if snapbox.checked then snap(shape);
      end;
    end;
  end;
end;

{**************** Snap ************8}
function TForm1.Snap(shape:Tshape):boolean;
{"Snap" the passed shape as far up and left as it can go without overlapping
 any other shape already placed}
var
  j,n:integer;
  r,r2:Trect;
  mindx,mindy:integer;
  shape2:Tshape;
  changed:boolean;
begin
  result:=false;
  with PartsList do
  begin
    r:=shape.boundsrect;
    mindx:=shape.left;   {the furthest we can move the shape left and up}
    mindy:=shape.top;
    if count>0 then
    repeat  {for all other PartsList}
      changed:=false;
      for j:= 0 to count-1  do
      begin  {check for furthest valid vertical move}
        shape2:=TShape(items[j]);
        if (shape<>shape2) and (shape.parent=shape2.parent) then
        with shape2 do
        begin
          r2:=boundsrect;
          n:=r.top-r2.bottom;
          {we can move it this far if either left or right corener of either
           shape being tested is above the shape being snapped (n>0)
           and the distance is less than the previous minimum distance found
           and the left or right corner of ether shape lies within the boundaies
           of the other or left and right corners are in line}
          if (n>=0) and (n<mindy)
            and (IsBetween(r2.left,r.left,r.right)
                 or IsBetween(r2.right,r.left,r.right)
                 or IsBetween(r.left,r2.left,r2.right)
                 or IsBetween(r.right,r2.left,r2.right)
                 or ((r.left=r2.left) and (r.right=r2.right))
                 )
          then
          begin
            changed:=true;
            mindy:=n;
          end;
        end;
      end; {end vert move}
      offsetrect(r,0,-mindy); {move the snapped boundary rectangle up by mindy}
      mindy:=0; {the min distance we can move up}

      {Now apply the same logic for a move left}
      for j:= 0 to count -1 do
      begin
        shape2:=tshape(items[j]);
        if (shape<>shape2) and (shape.parent=shape2.parent) then
        with shape2 do
        begin
          r2:=boundsrect;
          n:=r.left-r2.right;
          if (n>=0) and (n<mindx)
            and (IsBetween(r2.top,r.top,r.bottom)
            or IsBetween(r2.bottom,r.top,r.bottom)
            or IsBetween(r.top,r2.top,r2.bottom)
            or IsBetween(r.bottom,r2.top,r2.bottom)
            or ((r.top=r2.top) and (r.bottom=r2.bottom))
            )
          then
          begin
            changed:=true;
            mindx:=n;
          end;
        end;
      end;
      offsetrect(r,-mindx,0);
      mindx:=0;

      {If the boundary really moved, then move the shape and set result to true}
      if (shape.left<>r.left) or (shape.top<>r.top) then
      begin
        result:=true;
        shape.left:=r.left;
        shape.top:=r.top;
      end;
    until not changed {loop (stairstep up and left) until no more moves possible}
    else
    begin {None in place, snap to (0,0)}
      if (mindx>0) or (mindy>0) then result:=true;
      shape.left:=shape.left-mindx;
      shape.top:=Shape.top-mindy;
    end;
  end;
end;


{************** SnapBoxClick ***********}
procedure TForm1.SnapBoxClick(Sender: TObject);
var
  i:integer;
  snapped:boolean;
begin
  snapped:=false;
  If snapbox.checked then
  repeat  {loop snapping all "inplace" shapes until no more movement}
    with PartsList do
    if count>0 then
    begin
      snapped:=false;
      for i:=0 to count-1 do
      with TShape(items[i]) do
      if parent is tPanel then
      snapped:=snapped or snap(TShape(items[i]));
    end;
  until snapped=false;
end;

{Link to Delphiforfun.org}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

