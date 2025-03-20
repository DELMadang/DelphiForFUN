unit U_Geometry4;



{Copyright  © 2002-2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Test some routines from UGeometry to compute geometric properties of lines and
 polygons:

    1. Intersect - reports whether two line segments intersect.

    2. PointPerpendicularLine - defines the point of intersection on a given
                               line of a line through a given point and
                               intersecting the given line at a 90 degree angle.

    3. AngledLineFromLine - computes other end of a line segment drawn from a given
                         point of a given length and a given angle to another
                         line segment (or its extension).

    4. Point In Polygon -  determines where a given point is in relation to a
                        given polygon.  Works by extending a line from the point
                        to "infinity" and counting the number of times that the
                        line intersects a polygon edge.  (Odd count=inside, even
                        count=outside)

    5. InflatePolygon - changes size of a polygon by a given amount, also uses
                     Polygonarea function to determine which way the polygon
                     was built (afffect whether edges must move right or left
                     from original position.
Version 4 adds:

    6. Line Translation and Rotation - Illistrates the basic operations of
                     moving (translating) the line to new left end (P1) coordinates
                     and rotating the right end of a line (P2) about the left end.

    7. Circle intersection - Find and draws the intersection points of 2
                     intersecting circles.

    8, Point-Circle Tangents - Calulates and draws the tangent lines from a given
                     circle to a given exterior point.

    9, Circle-Circle Exterior Tangents - Illustrates the algorithm for determing
                     the points of tangency for the exterior tangent lines between
                     two circles.


}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Spin, Shellapi, UGeometry;

type
  Tdrawmode=(startingline, endingline , resetmode );

  TWorkMode=(None, Sizing, Drag, Drawdot);

  TForm1 = class(TForm)
    Image1: TImage;
    Label2: TLabel;
    ResultLbl: TLabel;
    PageControl1: TPageControl;
    IntersectSheet: TTabSheet;
    PerpSheet: TTabSheet;
    ClearBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    AngleSheet: TTabSheet;
    DistEdt: TSpinEdit;
    Memo3: TMemo;
    RightLeftBox: TRadioGroup;
    Label1: TLabel;
    Label3: TLabel;
    AngleEdt: TSpinEdit;
    AdjustBox: TCheckBox;
    PointInPolySheet: TTabSheet;
    Memo4: TMemo;
    AlignGrp: TRadioGroup;
    StaticText1: TStaticText;
    AlignGrpIL: TRadioGroup;
    InflateSheet: TTabSheet;
    Memo5: TMemo;
    Label4: TLabel;
    InflateBy: TSpinEdit;
    Label5: TLabel;
    AreaLbl: TLabel;
    TangentPC: TTabSheet;
    LineManip: TTabSheet;
    Memo6: TMemo;
    SpinEdit2: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    TranslateBtn: TButton;
    RotateBtn: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    Memo7: TMemo;
    Memo8: TMemo;
    CircleCircleIntersectSheet: TTabSheet;
    Memo9: TMemo;
    CCIntersectBtn: TButton;
    Memo10: TMemo;
    PointTanBtn: TButton;
    TabSheet1: TTabSheet;
    Memo11: TMemo;
    CircCircTanBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ClearBtnClick(Sender: TObject);
    procedure AlignGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure InflateByChange(Sender: TObject);
    procedure TranslateBtnClick(Sender: TObject);
    procedure RotateBtnClick(Sender: TObject);
    procedure CCIntersectBtnClick(Sender: TObject);
    procedure PointTanBtnClick(Sender: TObject);
    procedure CircCircTanBtnClick(Sender: TObject);
  public
    L1,L2,L3:Tline;
    dragval:integer;
    moved:boolean;
    startPoint:TPoint;
    pointColor:TColor;
    Points:array of TPoint;
    nbrpoints:integer;  {# of points in the polygon}
    alignval:integer;   {grid alignment for polygon points}
    workingon:integer;
    working:TWorkMode;
    nbrdefined:integer;
    circles:array[1..2] of TCircle;
    procedure reset;
    procedure EraseLine(L:TLine);
    Procedure DrawIntersecting;
    procedure drawpoint(p:TPoint; Pcolor:TColor);
    procedure drawline(L:TLine);
    Procedure drawpoly(const points:array of TPoint;
                       const color:TColor; const erase:boolean);
    function IsInCircle(x,y:integer):integer;
    procedure drawcircle(const C:TCircle; const pencolor:TColor);
    procedure erasecircle(C:TCircle);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

{**************** FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  doublebuffered:=true;
  pagecontrol1.activepage:= TangentPC;
  reset;
end;

{*********** reset *******}
procedure TForm1.reset;
  begin
    dragval:=0;
    nbrpoints:=0;
    moved:=false;
    nbrdefined:=0;
    working:=none;
    workingon:=0;
    if pagecontrol1.activepage=IntersectSheet
    then aligngrpclick(aligngrpIL)
    else if (pagecontrol1.activepage=PointInPolySheet)
    then aligngrpclick(aligngrp)
    else alignval:=1;
    image1.canvas.fillrect(image1.clientrect);
    resultlbl.caption:='';
    arealbl.caption:='';
end;






{************** DrawPoint ***********}
procedure TForm1.drawpoint(p:TPoint;PColor:TColor);
var save:TColor;
begin
  with image1, canvas do
  begin
    save:=brush.Color;
    brush.Color:=PColor;
    ellipse(p.x-3,p.y-3, p.x+3,p.y+3);
    brush.Color:=save;
  end;
end;

{************** DrawLine ***********}
procedure TForm1.drawLine(L:TLine);
begin
  with image1, canvas, L do
  begin
    moveto(p1.x,p1.y);
    lineto(p2.x,p2.y);
    drawpoint(l.p1,clgreen);
    drawpoint(l.p2,clred);
  end;
end;

{************** EraseLine ***********}
procedure TForm1.EraseLine(L:TLine);
var
  save:TColor;
begin
  with image1, canvas, L do
  begin
    save:=brush.color;
    brush.color:=clwhite;
    pen.color:=clwhite;
    moveto(p1.x,p1.y);
    lineto(p2.x,p2.y);
    drawpoint(l.p1,clwhite);
    drawpoint(l.p2,clwhite);
    pen.color:=clblack;
    brush.color:=save;
  end;
end;


{************* DrawCircle *********}
procedure TForm1.drawcircle(const C:TCircle; const pencolor:TColor);
begin
  with c, image1.canvas do
  begin
    pen.color:=penColor;
    brush.style:=bsClear;
    ellipse(cx-r,cy-r,cx+r,cy+r);
    brush.Color:=clred;
    ellipse(cx-4,cy-4,cx+4,cy+4);
    brush.color:=clwhite;
  end;
end;

{************ EraseCircle ********}
procedure TForm1.erasecircle(C:TCircle);
begin
  with C, Image1.canvas do
  begin
    pen.color:=clwhite;
    brush.Color:=clwhite;
    ellipse(cx-r,cy-r,cx+r,cy+r);
  end;
end;




{***************** DrawPoly *************}
procedure TForm1.drawpoly(const points:array of TPoint;
                          const color:TColor; const erase:boolean);
var i:integer;
  begin
    with image1.canvas do
    begin
      If erase then fillrect(image1.clientrect);
      pen.color:=color;
      polyline(Points);
      with points[high(points)] do moveto(x,y);
      with points[0] do lineto(x,y); {close the drawing}
    end;
    for  i:=0 to high(points) do drawpoint(points[i],clgreen);
  end;


{************** DrawIntersecting *********}
procedure TForm1.Drawintersecting;
var
  r,pb:boolean;
  IP:TPoint;
  s:string;
begin
  with image1, canvas do
  begin
    fillrect(clientrect);
    case dragval of
    1,2: begin
        moveto(l1.p1.x, l1.p1.y);
        lineto(l1.p2.x, L1.p2.y);
        drawpoint(l1.p1,clgreen); drawpoint(l1.p2,clred);
       end;
    3: begin
         moveto(l1.p1.x, l1.p1.y);
         lineto(l1.p2.x, L1.p2.y);
         drawpoint(l1.p1,clgreen); drawpoint(l1.p2,clred);
         moveto(L2.p1.x, L2.p1.y);
         lineto(L2.p2.x, L2.p2.y);
         drawpoint(l2.p1,clgreen); drawpoint(l2.p2,clred);
         r:= intersect(l1,l2,pb,IP) ;
         s:='('+inttostr(ip.x)+','+inttostr(ip.Y)+')  ';
         if r and pb then s:=s+'Intersection point on border'
         else if r then s:=s+'Lines cross'
         else s:='No intersect';
         resultLbl.caption:=s;
       end;
    end;
  end;
end;

{************** IsInCircle **********}
function TForm1.IsInCircle(x,y:integer):integer;
var
  i:integer;
begin
  result:=0;
  for i:=1 to nbrdefined do
  with circles[i] do
  begin
    if intdist(point(cx,cy),point(x,y))<r then
    begin
      result:=i;
      break;
    end;
  end;
end;


{****************** IMage1MouseDown ************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:TPoint;

begin
  moved:=false;  {used by mousemove}
  startpoint:=point(x,y);
  with pagecontrol1 do
  begin
    if (activepage=IntersectSheet) then
    begin
      aligngrpclick(aligngrpIL);
      p:=point(x,y);
      if alignval>1 then
      begin
        p.x:=round(p.x / alignval)*alignval;
        p.y:=round(p.y / alignval)*alignval;
        mouse.cursorpos:=image1.clienttoscreen(p);
      end;
    end
    else
    if (activepage=PerpSheet) or (activepage=AngleSheet)
    then
    begin
      case dragval of
        0: begin  {1st point}
             L1.p1:=point(x,y);
             dragval:=1;
             pointcolor:=clgreen;
           end;
        1,2: begin
               L2.p1:=point(x,y);
               dragval:=2;
               pointcolor:=clred;
             end;
      end; {case}
    end
    else if (activepage=pointinPolySheet) or (activepage=InflateSheet) then
    begin
      {For Polygon inflation, start a new polygon on next click after polygon was closed}
      if (activepage=InflateSheet) and (dragval=3) then dragval:=0;
      aligngrpclick(aligngrp);
      p:=point(x,y);
      if alignval>1 then
      begin
        p.x:=round(p.x / alignval)*alignval;
        p.y:=round(p.y / alignval)*alignval;
        mouse.cursorpos:=image1.clienttoscreen(p);
      end;

      case dragval of
      0: {start a polygon}
        begin
          setlength(points,2);
          points[0]:=point(p.x,p.y);
          nbrpoints:=2;
          dragval:=1;
        end;
      1: {continue or close a polygon}
        begin
          inc(nbrpoints);
          setlength(points,nbrpoints);
          points[nbrpoints-1]:=p;
          if intdist(points[0],p)<7 then
          begin
            dec(nbrpoints,2);
            setlength(points,nbrpoints);
            {points[nbrpoints]:=points[1];}
            dragval:=2;
            drawpoly(points,clblack,true);
          end;
        end;
      end; {case}
    end
    else if pagecontrol1.activepage=linemanip then
    begin
      if dragval=0 then
      begin
        reset;
        L1.p1:=point(x,y);
        dragval:=1;
        pointcolor:=clgreen;
      end;
    end
    else if pagecontrol1.activepage=TangentPC then
    begin
      workingon:=Isincircle(x,y);
      if (workingon=0) then
      begin
        if (nbrdefined<2) then
        begin
          working:=sizing;
          inc(nbrdefined);
          workingon:=nbrdefined;
        end
      end
      else with circles[workingon] do
      begin
        if intdist(point(cx,cy),point(x,y))<5
        then working:=drag
        else working:=sizing;
      end;
      with circles[workingon] do
      begin
        cx:=x;
        cy:=y;
        if working=sizing then r:=4;
        with mouse do setcursorpos(cursorpos.x+4,cursorpos.Y);
      end;
      drawcircle(circles[workingon],clblack);
    end;

  end;
end;

(*
{*************** PaintBox1MouseMove **************}
procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if working <>none  then
  with paintbox1, canvas, circle[workingon] do
  begin
    erasecircle(workingon);
    if working=sizing then r:=radius(cx,cy,x,y)
    else
    begin
      cx:=x;
      cy:=y;
    end;
    drawcircle(workingon);
    case workingon of
      1:
      begin
        if nbrdefined>1 then maketangents(1,2);
        if nbrdefined>2 then maketangents(1,3);
      end;

      2:begin
        maketangents(1,2);
        if nbrdefined>2 then maketangents(2,3);
      end;
      3:
      begin
        maketangents(1,2);
        maketangents(2,3);
      end;
    end;
  end;
  paintbox1.invalidate;
end;

{************* PaintBoxMouseUp ****************}
procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:TPoint;
begin
  working:=none;
end;
    end;
  end; {If activepage= }
end;
*)

{******************** Image1MouseMove **********************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p:TPoint;
begin
  p:=point(x,y);
  if alignval>1 then
  begin
    p.x:=round(p.x / alignval)*alignval;
    p.y:=round(p.y / alignval)*alignval;
  end;
  label2.caption:='X:'+inttostr(p.x)+'  Y:'+inttostr(p.y);
  {if ssleft in shift then}
  begin
    with pagecontrol1 do
    begin
      if ((activepage=PerpSheet) or (activepage=AngleSheet))
      and (dragval=1) then
      begin
        label2.caption:='X:'+inttostr(x)+'  Y:'+inttostr(y);
        if not moved then {first time just draw the start point}
        begin
          drawpoint(startpoint,pointcolor);
          moved:=true;
        end;
        L1.p2:=point(x,y);
        image1.canvas.fillrect(image1.clientrect);  {erase the image}
        drawline(L1);
      end
      else if (activepage=Linemanip) and (dragval=2) then
      begin
        label2.caption:='X:'+inttostr(x)+'  Y:'+inttostr(y)+ ', dv='+inttostr(dragval);
        if not moved then {first time just draw the start point}
        begin
          drawpoint(startpoint,pointcolor);
          moved:=true;
        end;
        L1.p2:=point(x,y);
        image1.canvas.fillrect(image1.clientrect);  {erase the image}
        drawline(L1);
      end;
    end;
  end;
  if pagecontrol1.activepage=IntersectSheet then
      begin
        label2.caption:='X:'+inttostr(p.x)+'  Y:'+inttostr(p.y);
        if (dragval>0) and (not moved) then {first time just draw the start point}
        begin
          drawpoint(startpoint,pointcolor);
          moved:=true;
        end;
        case dragval of
          1:L1.p2:=point(x,y);
          3:L2.p2:=point(x,y);
        end;
        If dragval>0 then drawintersecting;
      end;
  {-------- mouse move -  PointInPoly}
  if (pagecontrol1.activepage=pointinpolySheet)
     or (pagecontrol1.activepage=InflateSheet)
  then
  begin
    if (dragval=1) and (nbrpoints>=2) then
    begin
      points[nbrpoints-1]:=p;
      drawpoly(points,clBlack,true);
    end;
  end
  else  if pagecontrol1.activepage=TangentPC then
  begin
    if working <>none  then
    with circles[workingon] do
    begin
      erasecircle(circles[workingon]);
      if working=sizing then r:=intdist(point(cx,cy),point(x,y))
      else
      begin
        cx:=x;
        cy:=y;
      end;
      drawcircle(circles[workingon],clBlack);
    end;
  end;
end;


{***************** Image1MouseUp **************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var a:extended;
    p:TPoint;
    n:PPResult;
    s:string;
    V:integer;
    Points2:array of TPoint;
    Area, area2:integer;
    clockwise:boolean;
begin
  if pagecontrol1.activepage=IntersectSheet then
  begin
    p:=point(x,y);
    if alignval>1 then
    begin
      p.x:=round(p.x / alignval)*alignval;
      p.y:=round(p.y / alignval)*alignval;
      mouse.cursorpos:=image1.clienttoscreen(p);
    end;
    case dragval of
      0: begin
           L1.p1:=point(x,y);
           dragval:=1;
           pointcolor:=clgreen;
         end;
      1: {Draw first line}
        begin
          L1.p2:=point(p.x,p.y);
          drawline(L1);
          dragval:=2;
        end;
      2: begin  {start drawing second line}
           L2.p1:=point(p.x,p.y);
           dragval:=3;
           moved:=false;
           pointcolor:=clred;
         end;
      3: begin
           L2.p2:=point(p.x,p.y);
           DrawIntersecting;
           dragval:=0;
          end;
    end;
  end
  else if pagecontrol1.activepage=PerpSheet then
  begin
    if dragval=2 then
    begin
      l2.p1:=point(x,y);{assume user wants the perp start point to be mouseup point}
      L2:=pointperpendicularLine(L1,L2.p1);
      drawline(l2);
    end;
  end
  else if pagecontrol1.activepage=AngleSheet then
  begin
    if dragval=2 then dragval:=3 {end of initial base line}
    else if dragval=3 then
    begin
      l2.p1:=point(x,y); {assume user wants the angle start point to be mouseup point}
      a:=angleEdt.value/180*Pi; {default, increase angle (counter clockwise)}
      if rightleftbox.itemindex=0 then a:=-a;  {right reduces andgle}
      if adjustbox.checked then
      begin {drop perp from pt to line first}
        L2:=pointperpendicularLine(L1,L2.p1);
        l2.p1:=l2.p2; {and make that the new line start point}
      end;
      L2:=AngledLineFromLine(L1,L2.P1,distedt.value,a);
      drawline(l2);
    end;
  end
  else If pagecontrol1.activepage = PointInPolySheet then
  begin
    {find out if this point is inside or outside of polygon}
    If dragval=2 then dragval:=3 {Ignore the 1st mouse up after closing poly}
    else if dragval=3 then
    begin
      if (nbrpoints>2)  then
      begin
        p:=point(x,y);
        if alignval>1 then
        begin
          p.x:=round(p.x / alignval)*alignval;
          p.y:=round(p.y / alignval)*alignval;
          mouse.cursorpos:=image1.clienttoscreen(p);
        end;
        n:=pointinpoly(p, points);
        drawpoly(points,clBlack,true);
        drawpoint(p,clgreen);
        case n of
          PPoutside:s:='Point is outside of polygon';
          PPInside: s:='Point is inside polygon';
          PPVertex: s:='Point is on a vertex';
          PPEdge:   s:='Point is on an edge, not at vertex';
          PPError:  s:='Cannot determine where the heck that point is';
        end;
        resultLbl.caption:=s;
      end;
    end;
  end
  else If pagecontrol1.activepage = InflateSheet then
  begin
    If (dragval=2) or (sender = InflateBy) then
    begin
      if sender = Image1 then  dragval:=3;
      if (nbrpoints>2)  then
      begin
        p:=point(x,y);
        v:=inflateby.value;
        setlength(points2,nbrpoints);

        InflatePolygon(points,points2,area,
                      {screencoordinates} true, v);
        area2:=Polygonarea(points2, {screencoordinates}true, clockwise);
        Arealbl.caption:= 'Area: Original '+inttostr(area)
                              + ', New '+inttostr(area2);

        drawpoly(points,rgb(255,221,221),{erase first=} true); {draw the previous polygon}
        drawpoly(points2,clBlack,false); {draw the new polygon}

      end;
    end;
  end
  else if Pagecontrol1.activepage=Linemanip then
  begin
    l1.p2:=point(x,y);
    inc(dragval);
    if dragval>2 then dragval:=0;
    //;;else dragval:=0;;
    drawline(L1);
  end
  else if pagecontrol1.ActivePage=TangentPC then
  begin
    working:=none;
  end;
end;

{***************** ClearBtnClick ************}
procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  reset;
end;


{*********************** AlignGrpBtnClick ***********}
procedure TForm1.AlignGrpClick(Sender: TObject);
begin
  if sender<>nil then
  begin
    With sender as TRadioGroup do
    case itemindex of
      0: alignval:=1;
      1: alignval:=5;
      2: alignval:=10;
    end;
  end
  else alignval:=1;
end;



{************ InflatebyChange *********}
procedure TForm1.InflateByChange(Sender: TObject);
begin
  Image1MouseUp(InflateBy,mbleft,[],0,0);
end;

{************** TranslateBtnClick *************8}
procedure TForm1.TranslateBtnClick(Sender: TObject);
begin
  eraseline(L1);
  TranslateLeftTo(L1,point(spinedit1.Value, spinedit2.value));
  Drawline(L1);
end;

{************ RotatebtnClick ***********}
procedure TForm1.RotateBtnClick(Sender: TObject);
begin
  memo7.clear;
  eraseline(L1);
  with L1 do
  begin
    p1.y:=-p1.y; {adjust y values so up ==> increasing Y}
    p2.y:=-p2.y;
    RotateRightEndTo(L1, degtorad(spinedit3.value));
    p1.y:=-p1.y; {readjust to screen coordinates (up=decreasing Y) }
    p2.y:=-p2.y;
  end;
  DrawLine(L1);
end;

{***************** CCIntersectBtnClick *************}
procedure TForm1.CCIntersectBtnClick(Sender: TObject);
{Circle-Circle intersections}
var
  i:integer;
  Ip1,Ip2:TPoint;
begin
  reset;
  nbrdefined := 2;
  for i:= 1 to 2 do   {define 2 random circles resonably sized and spaced}
  with circles[i], image1 do
  begin
    cx:= random(width div 2)+ width div 3;
    cy:= random(width div 2)+ width div 3;
    r:=random(width div 3) + 20;
    drawcircle(circles[i],clBlack);
  end;

(*
{debug}
reset;
with circle[1] do
begin
  cx:=130; cy:= 130;  r:=130;
end;
with circle[2] do
begin
  cx:=170; cy:= 200;  r:=100;
end;
drawcircle(circle[1]);
drawcircle(circle[2]);
*)

  memo10.lines.add(format('C1: (%d, %d) Radius= %d, C2:(%d, %d),Radius= %d',
               [circles[1].cx, circles[1].cy, circles[1].r,
                circles[2].cx, circles[2].cy, circles[2].r]));

  for i:=1 to 2 do with circles[i] do cy:=-cy;

  if circlecircleintersect(circles[1],circles[2],Ip1,Ip2) then
  begin
    ip1.y:=-ip1.y;
    ip2.y:=-ip2.y;
    for i:=1 to 2 do with circles[i] do cy:=-cy;
    drawline(line(point(circles[1].cx,circles[1].cy),Ip1));
    drawline(line(point(circles[1].cx,circles[1].cy),Ip2));
    memo10.lines.add (format('Intersections at (%d,%d) and (%d,%d)',
                        [Ip1.x, Ip1.Y, Ip2.x, Ip2.Y]));
  end
  else memo10.lines.add('No intersection');;
  memo10.Lines.add('------------------------');
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;




{**************** PointTanbtnClick ****************}
procedure TForm1.PointTanBtnClick(Sender: TObject);
{Tangent from exterior point to circle}
  var
  d:integer;
  p,pc, m, Ip1, Ip2:TPoint;
  L,L1,L2,l3:TLine;
  C1,C2:TCircle;
begin
  reset;
  nbrdefined := 1;
  with circles[1], image1, canvas do
  begin
    cx:= random(width div 2)+ width div 3;
    cy:= random(width div 2)+ width div 3;
    r:=random(width div 3) + 20;
    drawcircle(circles[1],clBlack);
    textout(cx-8,cy-8,'C');
    pc:=point(cx,cy);
    repeat
      p.X:=random(width);
      p.y:=random(height);
      d:=intdist(p,pc)
    until d>r+10;
    L:=line(pc,p);
    drawline(L);
     textout(p.x-8,p.y-8,'P');
    image1.update;
    sleep(1000);
    

    {To find the points of tangency:}
    {1. find the midpoint,M, of line L}
    {2. define the circle, C1, centered on M through the endpoints of L}
    {3  define the circle, C2, centerd on the original circlem Circle[1]}
    {4. Find the intersection point of C1 and C2, call them IP1 and IP2}
    {5. Define the tangent lines, L2, L3, from the point P through IP1 and IP2}
    {1}
     M:=point((cx+p.x) div 2, (cy+p.Y) div 2);
    {2}
    C1:=Circle(m.x, m.y, d div 2);
    textout(m.x,m.y,'M');
    Drawcircle(C1, Clred);
    {3}
    C2:=Circles[1];
    {4}
    if circleCircleIntersect(C1,C2,Ip1,Ip2) then
    begin
      image1.update;
      sleep(1000);
      L1:=line(P,Ip1);
      L2:=Line(P,Ip2);

    //if PointCircleTangentLines(Circles[1],P, L1,L2) then
    //begin
    {PointCircleTangentLines function code embedded here to allow display
     of intermediate results}
      pen.color:=clgreen;
      pen.width:=2;
      Drawline(L1);
      textout(L1.p2.x,l1.p2.y-12,'IP1');
      {Extend the l1 tangent line by 50 pixels}
      l3:=l1;
      extendline(L3,50);

      l3.p1:=l1.p2;
      drawline(l3);

      pen.width:=1;
      Drawline(line(pc,ip1));
      image1.update;
      sleep(500);
      pen.width:=2;
      Drawline(L2);
      textout(L2.p2.x,l2.p2.y+12,'IP2');
      {Extend the L2 tangent line by 50 pixels}
      l3:=l2;
      extendline(L3,50);
      l3.p1:=l2.p2;
      drawline(l3);

      pen.width:=1;
      Drawline(line(pc,ip2));
    end;
  end;
end;






{*************** CircCircTanBtnClick *****************}
procedure TForm1.CircCircTanBtnClick(Sender: TObject);
{Draw two random circles and their exterior tangents}

  procedure screenDrawLine(L:TLine);
  {Invert Y axis values for drawing on screen}
  begin
    with L do drawline(line(point(p1.x,-p1.y),point(p2.x,-p2.y)));
  end;

var
  c1,c2,c3:TCircle;
  pc:TPoint;
  d:extended;
  L1,L2,Pl1,Pl2,TL1,TL2, extline:TLine;
  loops:integer;
begin
  reset;

  with c1, image1 do
  repeat
    cx:= random(width div 2)+ width div 3;
    cy:= random(width div 2)+ width div 3;
    r:=random(width div 3) + 20;
    pc:=point(cx,cy);
    with c2 do
    begin
      loops:=0;
      repeat
        cx:= random(width div 2)+ width div 3;
        cy:= random(width div 2)+ width div 3;
        r:=random(width div 3) + 20;
        d:=intdist(point(cx,cy),pc);
        inc(loops);
      until (d>c2.r+c1.r) or (loops>100);
    end;
  until d>c1.r+c2.r;

   (*
  {debug}
  c1:=circle(100,100,100);
  c2:=circle(300,100,50);
  *)

  If CircleCircleExtTangentLines(C1,C2,C3,L1,L2,Pl1,Pl2,TL1,Tl2) then
  begin
    with image1, canvas do
    begin
      drawcircle(c1,clGreen);
      with c1 do textout(cx+8,cy+8,'C1');
      drawcircle(c2,clRed);
      with c2 do textout(cx+8,cy+8,'C2');
      drawcircle(C3,clyellow);
      drawline(L1);
      drawline(L2);

      pen.color:=cllime;
      DrawLine(pl1);
      pen.color:=clblue;

      {extend the tangent line a little for visual effect}
      extline:=TL1;
      extendline(Extline,50);
      {make the line just the extension do that tangency point still shows up}
      extline.p1:=tl1.p2;
      DrawLine(TL1);
      Drawline(Extline);

      {do the 2nd tangent line}
      pen.color:=cllime;
      drawline(Pl2);
      pen.color:=clblue;
       {extend the tangent line a little for visual effect}
      extline:=TL2;
      extendline(Extline,50);
      {make the line just the extension do that tangency point still shows up}
      extline.p1:=tl2.p2;
      DrawLine(TL2);
      Drawline(Extline);

    end;
  end;
end;


end.