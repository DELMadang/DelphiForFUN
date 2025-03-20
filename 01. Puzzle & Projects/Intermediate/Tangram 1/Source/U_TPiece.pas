unit U_TPiece;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Prelim version 0.1 - load, drag, rotate pieces}


interface

uses windows, classes, sysutils, graphics, controls, extctrls;
type
  tline=record
    p1,p2:TPoint;
  end;


  tpiece = class(TObject)       {TPIECE - Tangram piece class}
    private
      FShape:TShapeType;
      procedure SetShape(value:TShapeType);
    protected
    public
    points:array [1..4] of TPoint;   {make dynamic later}
    drawpoints:array[1..4] of TPoint; {make dynamic}
    center,drawcenter,offset:TPoint;
    nbrpoints:integer;
    piececolor:TColor;
    gridsize:integer;
    angle:integer;  {0..7, angle in 45 degree units}
    dragging:boolean;
    movable:boolean; {may want unmovable white pieces for targets}
    property Shape: TShapeType read FShape write SetShape;
    procedure assign(p:TPiece);
    procedure rotate45;
    procedure moveby(p:TPoint);
    procedure makedrawpoints;
    procedure draw(canvas:TCanvas);
    procedure flip;
    function pointinpoly(x,y:integer):boolean; {to recognize mouse clicks}
  end;


  tTangram=class(TPaintbox)
  protected
     procedure Paint;   override;
     procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
     procedure MouseMove(Shift: TShiftState; X,Y: Integer); override;
     public
       piece, homepiece:array of Tpiece;
       nbrpieces:integer;
       dragnbr:integer; {which piece is selected}
       gridsize:integer;  {multiplier for grid}
       splitpoint:integer;  {divider beween figures and pieces home}
       constructor createTangram(aowner:TWinControl; newsize:TRect);
       destructor destroy;  override;
       Procedure Loadpieces(fname:string);
       procedure addpiece(p:TPiece);
       procedure restart;
   end;


implementation


procedure TPiece.assign(p:TPiece);
var
  i:integer;
begin
  Fshape:=p.fshape;
  nbrpoints:=p.nbrpoints;
  for i:= 1 to nbrpoints do
  begin
    points[i]:=p.points[i];
    drawpoints[i]:=p.drawpoints[i];
  end;
  center:=p.center;
  drawcenter:=p.drawcenter;
  piececolor:=p.piececolor;
  angle:=p.angle;
  gridsize:=p.gridsize;
  dragging:=false;
  movable:=p.movable;
  offset:=p.offset;
end;

procedure TPiece.SetShape;
begin
  if value<>Fshape then FShape:=value;
end;


procedure tpiece.draw(canvas:TCanvas);
begin
  with canvas do
  begin
    if dragging then pen.width:=2
    else pen.width:=1;
    pen.color:=clblack;
    brush.color:=piececolor;
    polygon(slice(drawpoints,nbrpoints));
  end;
end;


function TPiece.pointinpoly(x,y:integer):boolean;
{returns true if passed point is inside of piece }

  function sameside(L:TLine; p1,p2:TPoint):int64;
  {same side =>result>0
   opposite sides => result <0
   a point on the line => result=0 }
  var
    dx,dy,dx1,dy1,dx2,dy2:int64;
  begin
    dx:=L.p2.x-L.P1.x;
    dy:=L.p2.y-L.P1.y;
    dx1:=p1.x-L.p1.x;
    dy1:=p1.y-L.p1.y;
    dx2:=p2.x-L.p2.x;
    dy2:=p2.y-L.p2.y;
    result:=(dx*dy1-dy*dx1)*(dx*dy2-dy*dx2);
  end;

  function  intersect(L1,L2:TLine):boolean;
  var
    a,b:int64;
  begin
    a:=sameside(L1,L2.p1,L2.p2);
    b:=sameside(L2,L1.p1,L1.p2);
    result:=(a<=0) and (b<=0);
  end;

var
  count,i,j:integer;
  lt,lp:TLine;
begin
    count:=0; j:=nbrpoints;
    lt.p1:=point(x,y);
    lt.p2:=point(x,y);
    lt.p2.x:=2000;
    for i:= 1 to nbrpoints do
    begin
      Lp.p1:=drawpoints[i];
      Lp.p2:=drAWpoints[i];
      if not intersect(Lp,Lt) then
      begin
        Lp.p2:=Drawpoints[j];
        j:=i;
        if intersect(Lp,lT) then inc(count);
      end;
    end;
    result:=count mod 2 =1;
end;

{**************** TPiece.roatae45 ******************}
procedure TPiece.rotate45;

    procedure rotate(var p:Tpoint; a:real);
     {rotate point "p" by "a" radians about the origin (0,0)}
     var
       t:TPoint;
     Begin
       t:=P;
       p.x:=round(t.x*cos(a)-t.y*sin(a));
       p.y:=round(t.x*sin(a)+t.y*cos(a));
     end;

     procedure translate(var p:TPoint; t:TPoint);
     {move point "p" by x & y amounts specified in "t"}
     Begin
       p.x:=p.x+t.x;
       p.y:=p.y+t.y;
     end;

var
  i:integer;
begin
  angle:=(angle +1) mod 8;
  for i:= 1 to nbrpoints do
  begin
    translate(points[i],point(-center.x,-center.y));
    rotate(points[i],pi/4.0);
    translate(points[i],center);
  end;
  makedrawpoints;
end;


{**************** Tpiece.Moveby ****************}
Procedure TPiece.moveby(P:TPoint);
{move piece by p.x and p.y}
var
  i:integer;
begin
  for i:= 1 to nbrpoints do
  with points[i] do
  begin
    inc(x,p.x);
    inc(y,p.y);
  end;
  inc(center.x,p.x);
  inc(center.y,p.y);
  makedrawpoints;
end;

{***************** Tpiece.drawpoints *************}
procedure TPiece.makedrawpoints;
{Precalc screen positions to improve redraw speed}
var
  i:integer;
begin
  for i:= 1 to nbrpoints do
  begin
    drawpoints[i].x:=points[i].x*gridsize+offset.x;
    drawpoints[i].y:=points[i].y*gridsize+offset.y;
  end;
  drawcenter.x:=center.x*gridsize+offset.x;
  drawcenter.y:=center.y*gridsize+offset.y;
end;

procedure TPiece.flip;
begin
end;


 {*************************************************}
 {***************** tTangram methods **************}
 {*************************************************}

{************ TTangram,Paint ****************}
procedure TTangram.Paint;
vaR
  i:integer;
begin
  with canvas do
  begin
    brush.color:=color;
    pen.color:=clblack;
    rectangle(cliprect{clientrect});
    moveto(splitpoint,0);
    lineto(splitpoint,height);
  end;
  {start with high pieces to draw unmovables first}
  for i:= high(piece) downto low(piece) do
    if assigned(piece[i])and (i<>dragnbr)
    then piece[i].draw(canvas);
  {make sure that selected piece shows on top}
  if (dragnbr>=0) then piece[dragnbr].draw(self.canvas);
end;

{**************** tTangram.Mousedown ******************}
procedure TTangram.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i:integer;
  p:TPoint;
begin
  if dragnbr<0 then  {not dragging, is mouse on a piece?}
  Begin
    for i:= low(piece) to high(piece) do
    if assigned(piece[i]) and (piece[i].movable) then
    begin
      if piece[i].pointinpoly(x,y) then
      with piece[i] do
      begin
        p:=clienttoscreen(drawcenter);
        setcursorpos(p.x,p.y);
        dragnbr:=i;
        dragging:=true;
        if button = mbright then  rotate45;
        invalidate;
        break;
      end;
    end;
  end
  else
  case button of
    mbleft:
      begin
        piece[dragnbr].dragging:=false;
        invalidate;
        dragnbr:=-1;
      end;
    mbright:
      begin
        piece[dragnbr].rotate45;
        invalidate;
      end;
  end; {case}
end;

{********************* tTangram.MouseMove **************}
procedure TTangram.MouseMove(Shift: TShiftState; X,Y: Integer);
var
  nx,ny:integer;
begin
  If (dragnbr>=0) then
  with piece[dragnbr] do
  If  (abs(x-drawcenter.x)>gridsize) or  (abs(y-drawcenter.y)>gridsize) then
  begin
    nx:=((x-drawcenter.x) div (gridsize));
    ny:=((y-drawcenter.y) div (gridsize));
    moveby(point(nx,ny));
    invalidate;
  end;
end;

{******************** tTangram.CreateTangram *******************}
constructor TTangram.createTangram(aowner:TWinControl; newsize:TRect);
begin
  randomize;
  inherited create(aowner);
  parent:=aowner;
  left:= newsize.left;
  top:=newsize.top;
  width:=newsize.right-left;
  height:=newsize.bottom-top;
  nbrpieces:=0;
  setlength(piece,0);
  setlength(homepiece,0);
  dragnbr:=-1;
  splitpoint:= 2*width div 3;
  gridsize:= (width-splitpoint) div 18;
  invalidate;
end;


{******************* tTangram.destroy ************}
destructor TTangram.destroy;
var
  i:integer;
begin
  for i:= low(piece) to high(piece) do piece[i].free;
  for i:= low(homepiece) to high(homepiece) do homepiece[i].free;
  setlength(piece,0);
  setlength(homepiece,0);
  inherited;
end;


{******************* tTangram.LoadPieces **************}
Procedure TTangram.Loadpieces(fname:string);
{Load a piece definition file}
var
  f:textfile;
  i,j:integer;
  topx,topy,newrotate,newflip:integer;
  newx,newy:integer;
  version:integer;
  piececount, pointcount:integer;
begin
   if fileexists(fname) then
   begin
     for i:= low(piece) to high(piece) do piece[i].free;
     for i:= low(homepiece) to high(homepiece) do homepiece[i].free;
     nbrpieces:=0;
     assignfile(f,fname);
     reset(f);
     readln(f,version);
     readln(f,piececount);
     setlength(piece,piececount);
     for i:= 0 to piececount-1 do
     begin
       readln(f);
       inc(nbrpieces);
       piece[i]:=TPiece.create;
       with piece[i] do
       begin
         gridsize:=self.gridsize;
         readln(f,topx,topy,newrotate,newflip);
         offset.x:=splitpoint+topx*gridsize;
         offset.y:=topy*gridsize;
         readln(f,pointcount);
         nbrpoints:=0;
         for j:= 1 to pointcount do
         begin
           inc(nbrpoints);
           readln(f,newx,newy);
           with points[nbrpoints] do
           begin
            x:=newx;
            y:=newy;
           end;
         end;
         center.x:=0;
         center.y:=0;
         piececolor:=clwhite;
         {piececolor:=random(4)*64+random(4)*256*64+random(4)*256*256*64;}
         movable:=true;
         makedrawpoints;
       end;
     end;
     closefile(f);
     invalidate;
     setlength(homepiece,length(piece));
     for i:= low(homepiece) to high(homepiece) do
     begin
       homepiece[i]:=TPiece.create;
       homepiece[i].assign(piece[i]);
     end;
   end;
 end;

 {******************** tTangram.AddPiece **************}
 procedure TTangram.addpiece(p:TPiece);
 begin
   setlength(piece,length(piece)+1);
   piece[high(piece)]:=p;
   inc(nbrpieces);
 end;

 {********************** tTangram.restart ******************}
 procedure tTangram.restart;
 {reset pieces to home position}
 var
   i:integer;
 begin
   for i:= low(homepiece) to high(homepiece)
   do piece[i].assign(homepiece[i]);
 end;

end.
