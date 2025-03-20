unit U_Circle3point2;
 {Copyright  © 2001-2003, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
This program tests two functions which define a circle given
three points on its circumference.

Function "GetCenter" determines the equation (slope and
intercept) of the perpendicular bisectors of lines connecting any
2 pairs from the three given points.  These bisectors intersect at
the center of the circle.  So by solving  the two bisector
equations we can determine the center point.

Of course, Pythagoras will tell us the radius if we use his
theorem to calculate the distance from the center to  any of the
three points.

In this case, though, a second function GetRadius is used to
obtain the radius.  GetRadius is much quicker if we don't need to
know where the center is,
just how far away it is.

To test, just click three points on the rectangle at right and watch the
circle magically appear.

References:
http://forum.swarthmore.edu/dr.math/problems/culpepper9.9.97.html
http://192.154.43.167/goebel/statecon/Topics/triangl/TRIANGL.htm

Version 2 (December 2009) adds ability to manually enter points to
solve specific problems. Manually entered values may  have
decimal points.  When the "Show circle" button is clicked, center
and radius for the circumscribing circle are given in the inout units
and the points are automatically scaled to fit the screen.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, shellAPI;

type

  TRealPoint = record
    x,y:extended;
  end;


  TForm1 = class(TForm)
    Image1: TImage;
    ListBox1: TListBox;
    Memo1: TMemo;
    Label1: TLabel;
    P1X: TEdit;
    P1Y: TEdit;
    P2x: TEdit;
    P2y: TEdit;
    P3x: TEdit;
    P3y: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ShowBtn: TButton;
    StaticText1: TStaticText;
    Memo2: TMemo;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ManualChange(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    p:array[1..3] of TRealPoint;
    Editpoints:array[1..3,1..2] of TEdit;
    nbrpoints:integer;
    scale:extended;
    offsetx, offsety: integer;
    honorchange:boolean;
    Procedure Showcircle;
    procedure makepoint(const x,y:extended;n:integer; const changeedit:boolean);
    procedure showpoint(const fx,fy:extended; clcolor:TColor);
    procedure setscale;
    function scalex(x:extended):integer;
    function scaley(y:extended):integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


function realpoint(x,y:extended):Trealpoint;
begin
  result.x:=x;
  result.y:=y;
end;


{----------- Swap ------------}
procedure swap(var p1,p2:Trealpoint);
{swapt two pint values}
var
  temp:TrealPoint;
begin
  temp:=p1;
  p1:=p2;
  p2:=temp;
end;

{--------- SamePoint -----------}
function samepoint(const p1,p2:TRealPoint):boolean;
begin
  if (p1.x=p2.x) and (p1.y=p2.y) then result:=true
  else result:=false;
end;

{------------ GetCenter -----------}
function getcenter(p1,p2,p3:TRealpoint; var center:TRealPoint):boolean;
var
  x,y:extended;
  ma,mb:extended;
begin
  result:=true;
  if samepoint(p1,p2)or samepoint(p1,p3) or samepoint(p2,p3)
    or ((p1.x=p2.x) and (p1.x=p3.x))  then
  begin
    result:=false;
    exit;
  end;

  {we don't want infinite slopes,
   (or 0 slope for line 1, since we'll divide by "ma" below)}
  if (p1.x=p2.x) or (p1.y=p2.y) then swap(p2,p3);
  if (p2.x=p3.x) then swap(p1,p2);

  if p1.x<>p2.x then ma:=(p2.y-p1.y)/(p2.x-p1.x)
  else ma:=1e6; {result:=false;}
  if p2.x<>p3.x then mb:=(p3.y-p2.y)/(p3.x-p2.x)
  else mb:=1e6; {result:=false;}
  If (ma=0) and (mb=0) then result:=false;
  if result=true then
  begin
    x:=(ma*mb*(p1.y-p3.y)+mb*(p1.x+p2.x)-ma*(p2.x+p3.x))/(2*(mb-ma));
    if ma<>0 then  y:=-(x-(p1.x+p2.x)/2)/ma + (p1.y+p2.y)/2
    else y:=-(x-(p2.x+p3.x)/2)/mb + (p2.y+p3.y)/2;
    center.x:=(x);
    center.y:=(y);
  end;
end;

{------------- Getradius -------------}
function getradius(p1,p2,p3:TRealPoint):single;
{Return the radius of a circle defined by 3 points on it's circumference}
var
  s:extended;
  a,b,c:extended;
begin
  a:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
  b:=sqrt(sqr(p2.x-p3.x)+sqr(p2.y-p3.y));
  c:=sqrt(sqr(p3.x-p1.x)+sqr(p3.y-p1.y));
  s:=(a+b+c)/2;
  result:=(a*b*c)/(4*sqrt(s*(s-a)*(s-b)*(s-c)));
end;

{*************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  nbrpoints:=0;
  image1.canvas.Rectangle(image1.clientrect);
  {assign Tedits to an array for ease of access}
  editpoints[1,1]:=P1x;
  editpoints[1,2]:=P1y;
  editpoints[2,1]:=P2x;
  editpoints[2,2]:=P2y;
  editpoints[3,1]:=P3x;
  editpoints[3,2]:=P3y;
  setscale;
  honorchange:=true;
end;


(************* Image1Mousedown *************)
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

  var i:integer;
begin
  with image1, canvas do
  begin
    if nbrpoints>=3 then
    with image1, canvas do
    begin
      nbrpoints:=0;
      rectangle(clientrect);
      listbox1.clear;
      for i:=1 to 3 do p[i]:=realpoint(0,0);
      scale:=1.0;
      offsetx:=0;
      offsety:=0;
    end;
    inc(nbrpoints);
    makepoint(x,image1.clientheight-y,nbrpoints, true);

    listbox1.items.add(format('#%1d X: %3d Y: %3d',[nbrpoints,x, image1.clientheight-y]));
    if nbrpoints=3 then showcircle;
  end;
end;

{************** MakePoint **********}
procedure TForm1.makepoint(const x,y:extended; n:integer; const changeEdit:boolean);
begin
  with image1,canvas do
  begin
    {erase the old point}
    //brush.color:=clwhite;
    //pen.color:=clwhite
    with p[n] do showpoint(x,y,clwhite);

    p[n]:=realpoint(x,y);
    if changeEdit then  {we need to also set the Tedit control to reflect this click}
    begin
      honorchange:=false;
      editpoints[n,1].text:=floattostr(x);
      editpoints[n,2].text:=floattostr(y);
      honorchange:=true;
    end;
    showpoint(x,y, clred);
  end;
end;

{******** ShowPoint *********}
procedure TForm1.showpoint(const fx,fy:extended; clcolor:TColor);
var
  x,y:integer;
begin
  with image1, canvas do
  begin
    brush.color:=clcolor;
    pen.color:=clcolor;
    x:=scalex(fx);
    y:=scaley(fy);
    ellipse(x-3,y-3,x+3,y+3);
    pen.color:=clblack;
    brush.color:=clwhite;
  end;
end;


{************** ShowCircle ***********}
procedure TForm1.Showcircle;
  var
    c:TRealPoint;
    rf:extended;
    r:integer;
    ymax:integer;
    c1,c2,c3,freq:int64;
    i:integer;
  begin
    listbox1.Clear;
    with image1,canvas do rectangle(clientrect);
    for i:=1 to 3 do
    with p[i] do
    begin
      showpoint(x,y, clred); {redraw the points}
      {relist the points}
      listbox1.items.add(format('#%1d X: %.3f Y: %.3f',[i,x,y]));
      //listbox1.items.add(format('     Plotted at (%d,%d)',[scalex(x), scaley(y)]));
    end;
    queryperformancecounter(c1);
    if Getcenter(p[1],p[2],p[3],c)
    then
    with image1,canvas do
    begin
      queryperformancecounter(c2);
      rf:=(GetRadius(p[1],p[2],p[3]));
      queryperformancecounter(c3);
      queryperformancefrequency(freq);
      r:=round(rf);

      ellipse(scalex(c.x-rf),scaley(c.y-rf),scalex(c.x+rf),scaley(c.y+rf)); {draw the circle}
      ellipse(scalex(c.x)-3,scaley(c.y)-3, scalex(c.x)+3, scaley(c.y)+3);
      moveto(0, scaley(0)); lineto(clientwidth, scaley(0));
      moveto(scalex(0),0); lineto(scalex(0), clientheight);
      listbox1.items.add(format('Center: X:%.3f,  Y: %.3f',[c.x,c.y]));
      listbox1.items.add(format('Radius: %.3f',[rf]));
      listbox1.items.add(format('Center calc time: %5.0n microsecs',[10e6*(c2-c1)/freq]));
      listbox1.items.add(format('Radius calc time: %5.0n microsecs',[10e6*(c3-c2)/freq]));
    end
    else showmessage('No circle - points are co-linear');
  end;




{*************** Image1MouseMove ***************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
                                 Y: Integer);
var pt:TPoint;
begin
  with image1 do
  begin
    label1.caption:='X:'+inttostr(x)+'  Y:'+inttostr(clientheight-y);
  end;
end;


{*********** ManualChange *********}
procedure TForm1.ManualChange(Sender: TObject);
var
  i, j:integer;
  pt:extended;
  found:boolean;  {flag to break loop when correct edit is found}
begin
  if not honorchange then exit;
  with sender as TEdit do
  begin
    found:=false;
    for i:=1 to 3 do
    begin
      for j:=1 to 2 do
      if editpoints[i,j]=Tedit(sender) then
      begin
        found:=true;
        pt:=strtofloatdef(text,0);

        if j=1 then {x value changed}
        begin
          if pt>image1.Width then
          begin
            pt:=image1.Width;
            text:=floattostr(pt);
          end;
           makepoint(pt,p[i].y,i, false); {false ==> no need to change the Tedit}

        end
        else
        begin   {y value changed}
          makepoint(p[i].x,pt,i,false);
        end;
        break;
      end;  {j loop}
      if found then break;
    end;  {i loop}
  end;
  //setscale;
end;

procedure TForm1.ShowBtnClick(Sender: TObject);
begin
  setscale;
  showcircle;
end;


{*********** Setscale *********}
procedure TForm1.setscale;
var
  i:integer;
  maxx, maxy, minx, miny:extended;
  xrange,yrange:extended;
  scalex, scaley:extended;
begin
  maxx:=p[1].x;
  maxy:=p[1].y;
  minx:=maxx;
  miny:=maxy;
  for i:= 2 to 3 do
  with p[i] do
  begin
    if x>maxx then maxx:=x
    else if x<minx then minx:=x;
    if y>maxy then maxy:=y
    else if y<miny then miny:=y;
  end;
  xrange:=maxx-minx;
  yrange:=maxy-miny;
  if xrange=0 then xrange:=0.8*image1.width;
  if yrange=0 then yrange:=0.8*image1.height;
  scalex:=0.8*image1.width/xrange;
  scaley:=0.8*image1.height/yrange;
  if scalex < scaley then scale:=scalex else scale:=scaley;
  if scale=0 then scale:=1;
  if scale=1 then
  begin
    offsetx:=0;
    offsety:=0;
  end
  else
  begin
    offsetx:=trunc((image1.width-scale*xrange)/2);
    offsety:=trunc((image1.Height-scale*yrange)/2);
  end;
end;

{*********** Scalex ***********}
function Tform1.scalex(x:extended):integer;
  begin
    result:=trunc(offsetx +scale*x);
  end;


{************* Scaley ***********}
function Tform1.scaley(y:extended):integer;
  begin
    result:=image1.height- trunc(offsety+scale*y);
  end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
