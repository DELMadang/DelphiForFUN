unit U_Monges_Circles;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
Monge's Circle theorem:

Given three circles of differing sizes none of which lies completely inside
another, the common external tangent lines for each pair of circles lie on a
straight line.

This program illustrates the theorem .
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, UGeometry;

type

  TWorkMode=(Sizing, Drag);

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    ResetBtn: TButton;
    PaintBox1: TPaintBox;
    MakeRandBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure MakeRandBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    circles:array[1..3] of TCircle;
    TanLines:array[1..6] of TLine; {TL[1],TL[2]=circles 1,2 tangents, etc.}
    MongeLine1, Mongeline2:TLine;
    nbrdefined:integer;
    workingon:integer;
    working:TWorkMode;
    nullPoint:TPoint;
    function IsInCircle(x,y:integer):integer;
    function maketangents(InA,InB:integer):boolean;
    function extendlines:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

var
  colors:array[1..3] of TColor =(clFuchsia, clLime, clSkyBlue);

{************** Radius ************}
function radius(cx,cy,x2,y2:integer):integer;
begin
  result:= trunc(sqrt(sqr(cx-x2)+sqr(cy-y2)));
  if result<4 then result:=4;  {minimum radius = 4 pixels}
end;

{************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  doublebuffered:=true;   {prevent screen flicker}
  nullPoint:=point(-1,-1);
end;

{************** IsInCircle **********}
function TForm1.IsInCircle(x,y:integer):integer;
{If passed point is inside of a defined circle, return circle number}
var
  i:integer;
begin
  result:=0;
  for i:=1 to nbrdefined do
  with circles[i] do
  begin
    if radius(cx,cy,x,y)<r then
    begin
      result:=i;
      break;
    end;
  end;
end;

{************** MakeTangents ************}
function TForm1.maketangents(InA,InB:integer):boolean;
var
  C3:TCircle;
  L1,L2,PL1,PL2:TLine;
  TL1,TL2:TLine;
  Index:integer;
begin
  Index:= 2*(Ina+InB)-5; {1, 3, or 5}
  If circlecircleExtTangentLines(circles[Ina],circles[InB],C3,L1,L2,PL1,PL2,TL1,TL2) then
  begin
    TanLines[Index]:=TL1;
    TanLines[Index+1]:=TL2;
    result:=true;
  end
  else
  begin  {no tangents - "undefine" the lines}
    Tanlines[Index]:=line(point(-1,-1),point(-1,-1));
    Tanlines[Index+1]:=Tanlines[Index];
    result:=false;
  end;
end;

{************** ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i:integer;
begin
  {generate 3 non overlapping circles with different random centers & radii}
  {taking them in pairs, draw the 2 external tangents for each pair}
  {the three intersection points of the radii will be colinear!}
  nbrdefined:=0;
  tanlines[1]:=line(point(-1,-1),point(-1,-1));
  for i:=2 to 6 do tanlines[i]:=tanlines[1];
  MongeLine1:=tanlines[1];
  Mongeline2:=tanlines[1];

  //working:=none;
  workingon:=0;
  paintbox1.invalidate;
end;

{*************** PaintBox1Paint **********8}
procedure TForm1.PaintBox1Paint(Sender: TObject);
{Draw or redraw all the circles and lines currently defined}
var
  i:integer;
begin
  with Paintbox1.canvas  do
  begin
    brush.style:=bssolid;
    brush.color:=clwhite;
    pen.color:=clblack;
    pen.width:=1;
    rectangle(clientrect);
    brush.style:=bsClear;
    for i:=1 to nbrdefined do
    with circles[i] do
    begin
      pen.color:=colors[i];
      ellipse(cx-r,cy-r,cx+r,cy+r);
    end;
    for i:=1 to nbrdefined do
    begin
      brush.color:=colors[i];
      with circles[i] do ellipse(cx-4,cy-4,cx+4,cy+4);
    end;
    pen.color:=clblack;
    brush.color:=clwhite;
    {draw as many of the 6 tangent lines as have been defined}
    for i:=1 to 3 do
    begin
      if (nbrdefined>=i) then
      begin
        with tanlines[2*i-1] do
        begin

          moveto(p1.x,p1.Y);
          lineto(p2.x,p2.Y);
        end;
        with tanlines[2*i] do
        begin
          moveto(p1.x,p1.Y);
          lineto(p2.x,p2.Y);
        end;
      end
      else break;
      if i=3 then
      begin
        pen.width:=2;
        pen.Color:=clred;
        with mongeline1 do
        begin
          moveto(p1.x,p1.y);
          lineto(p2.x,p2.y);
          ellipse(p1.x-2,p1.y-2,p1.x+2,p1.y+2);
          ellipse(p2.x-2,p2.y-2,p2.x+2,p2.y+2);
        end;
        with mongeline2 do
        begin
          moveto(p1.x,p1.y);
          lineto(p2.x,p2.y);
          ellipse(p1.x-2,p1.y-2,p1.x+2,p1.y+2);
          ellipse(p2.x-2,p2.y-2,p2.x+2,p2.y+2);
        end;
      end;
    end;
  end;
end;

  

{*************** ExtendLines *************}
function TForm1.ExtendLines:boolean;
{Extend tangent lines to intersection points and connect them}
var
  i,N:integer;
  IP: array [1..3] of TPoint;
  minindex,midindex,maxindex:integer;

  function nullpoint(p:TPoint):boolean;
  begin
    result:=(p.x=-1) and (p.y=-1);
  end;


begin
  result:=true;
  for i:=1 to 3 do
  begin
    n:=2*i;
    if (not (nullpoint(tanlines[n-1].p1) and nullpoint(tanlines[n-1].p2)))
     and extendedlinesintersect(TanLines[N-1],TanLines[N],true,IP[i])
    then
    begin
      tanlines[N-1].p1:=ip[i];
      tanlines[n].p1:=ip[i];
    end
    else
    begin
      result:=false;
      break;
    end;
  end;
  if result then
  begin
    minindex:=1;
    maxindex:=1;
    for i:=2 to 3 do
    begin
      if ip[i].x<ip[minindex].x then minindex:=i;
      if ip[i].x>ip[maxindex].x then maxindex:=i;
    end;
    if minindex= maxindex then
    begin
      minindex:=1;
      maxindex:=1;
      for i:=2 to 3 do
      begin
        if ip[i].y<ip[minindex].y then minindex:=i;
        if ip[i].y>ip[maxindex].y then maxindex:=i;
      end;
    end;
    midindex:=6-minindex-maxindex;
    MongeLine1:=line(ip[minindex],ip[midindex]);
    Mongeline2:=line(ip[midindex],ip[maxindex]);
  end
  else
  begin
    mongeline1:=line(point(-1,-1),point(-1,-1));
    mongeline2:=mongeline1;
  end;


end;

{************** PaintBox1MouseDown ************8}
procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  l:TLine;
  p:TPoint;
begin
  if button=mbleft then
  begin
    workingon:=Isincircle(x,y);
    if (workingon=0) then
    begin
      if (nbrdefined<3) then
      begin     {defining a new circle}
        working:=sizing;
        inc(nbrdefined);
        workingon:=nbrdefined;
        with circles[workingon] do
        begin
          cx:=x;
          cy:=y;
          if working=sizing then r:=4;
          with mouse do setcursorpos(cursorpos.x+4,cursorpos.Y);
        end;
      end;
    end
    else with circles[workingon] do
    begin  {Moving or resizing an existing circle}
      if radius(cx,cy,x,y)<5
      then
      begin
        working:=drag;
        with circles[workingon] do
        begin
          cx:=x;
          cy:=y;
        end;
      end
      else
      begin
        working:=sizing;
        L:=line(point(cx,cy),point(x,y));
        extendline(L, r-intdist(L.p1,L.p2));
        p:=paintbox1.clienttoscreen(L.p2);
        setcursorpos(p.x, p.y);
      end;
    end;
  end;
  paintbox1.invalidate;
end;

{*************** PaintBox1MouseMove **************}
procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if workingon >0 then
  with paintbox1, canvas, circles[workingon] do
  begin
    if working=sizing then r:=radius(cx,cy,x,y)
    else  {dragging, set new center}
    begin
      cx:=x;
      cy:=y;
    end;
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
        maketangents(1,3);
        maketangents(2,3);
      end;
    end;
  end;
  if nbrdefined=3 then extendlines;
  paintbox1.invalidate;
end;

{************* PaintBoxMouseUp ****************}
procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:TPoint;
begin
  workingon:=0;
  if nbrdefined=3 then
  begin
    extendlines;  {extend the tangent lines to intersection}
  end;
  paintbox1.invalidate;
end;


procedure TForm1.MakeRandBtnClick(Sender: TObject);
var
  i,j,w3,w6,n:integer;
  ok:boolean;

      function inrange(L:TLine):boolean;
      begin
        with L, paintbox1  do
        if (p1.x<0) or (p1.x>width) or (p1.y<0) or (p1.y>height)
        or (p2.x<0) or (p2.x>width) or (p2.y<0) or (p2.y>height)
        then result:=false
        else result:=true;
      end;

begin
  repeat
    resetbtnclick(sender);
    w6:=width div 6;
    w3:=width div 3;
    with paintbox1 do
    begin
      ok:=true;
      for i:=1 to 3 do
      begin
        circles[i]:=circle(random(w3)+w6, random(w3)+w6, random(w3 div i)+10);
        (*
        {debug}
        with circles[i] do
        case i of
          1: circles[i]:=circle(243,455,51);
          2: circles[i]:=circle(453,451,115);
          3: circles[i]:=circle(243,378,19);
        end;        {end debug}
        *)
        with circles[i] do
        if (cx-r<0) or (cx+r>width) or (cy-r<0) or (cy+r>height) then
        begin
          ok:=false;
          break;
        end;
        nbrdefined:=i;
        if ok and (i>1)then
        for j:=1 to i-1 do
        begin
          n:=intdist(point(circles[i].cx,circles[i].cy),
                          point(circles[j].cx,circles[j].cy) );
          if (N<circles[i].r) or (N<circles[j].r) then
          begin
            ok:=false;
            break;
          end
        end;
      end;
      if ok then
      begin
        for i:=1 to 2 do
        for j:= i+1 to 3 do if not maketangents(i,j) then
        begin
          ok:=false;
          break;
        end;
        if ok then
        begin
          if not extendlines then OK:=false
          else
          for i:=1 to 3 do if not inrange(tanlines[i]) then
          begin
            ok:=false;
            break;
          end;
        end;
        if ok then
        begin
          if (not inrange(mongeline1)) or (not inrange(mongeline2))
          then ok :=false;
        end;
      end;
    end;
  until OK;
   paintbox1.Invalidate;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
