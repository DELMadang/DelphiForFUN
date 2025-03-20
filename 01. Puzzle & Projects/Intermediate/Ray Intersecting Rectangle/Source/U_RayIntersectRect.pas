unit U_RayIntersectRect;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{
Contact requested
I have a puzzle that's bugged me for a long time.  This is probably just my
failure to learn enough math.

A-----------B
|           |
E     F     G
|           |
D-----------C

Given a bounding rectangle defined by points A,B,C,D; where AB = CD and BC = DA.  Point F is a point in the absolute middle of the bounding rectangle, given half way between AB and BC.  Point E is half way between A and D.  Point G is half way between B and C. The last variable is an angle THETA from 0-360 that is based upon the line EG, where 0/360 is defined by the line of FG and 180 is defined by FE.

The puzzle is how to create a formula to define a line that will always
intercept point F using angle THETA, but will also define the two X,Y
coordinate points where the line will intercept the perimiter of the bounding
rectangle.  For instance, if angle THETA was 0, 180 or 360, the line would
intercept at points F and G.

If this is an easy one for people.. i'm gonna go back to school.  All my
solutions had some random error, but it might be due to my need to convert
back & forth from radians.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, shellapi;

type
  TForm1 = class(TForm)
    ABLength: TSpinEdit;
    Label1: TLabel;
    BCLength: TSpinEdit;
    Label2: TLabel;
    Label3: TLabel;
    ThetaDegrees: TSpinEdit;
    Image1: TImage;
    Memo1: TMemo;
    Label4: TLabel;
    StaticText1: TStaticText;
    procedure ValueChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    s1,s2,theta:extended;
    procedure drawrect(x,y,theta:extended);

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

{************* Drawrect ***************}
procedure TForm1.drawrect(x,y,theta:extended);
{Draw the labeled rectangle with sides X,Y and the ray from center at angle theta}
var
  c,xy1:TPoint;
  r:Trect;
  offset,half:integer;
  maxside:integer;

begin
  with image1, canvas do
  begin
    fillrect(clientrect); {clear the old image}

    {Draw the rectangle}
    c:=point(width div 2, height div 2);
    r:=rect(c.x - trunc(x /2),c.y-trunc(y/2),
              c.x+trunc(x/2),c.y+trunc(y/2));
    rectangle(r.left,r.top,r.right,r.bottom);

    {label the corners}
    font.size:=14;
    offset:=textheight('A');
    half:=offset div 3;
    textout(r.left-half,r.top-offset,'A');
    textout(r.right-half,r.top-offset,'B');
    textout(r.right-half,r.bottom+1,'C');
    textout(r.left-half,r.bottom+1,'D');

    {Draw the ray from center to just outside he farthest crner}

    maxside:=trunc(0.6*sqrt(x*x+y*y));
    xy1:=point(trunc(c.x+(maxside*cos(theta))),
               trunc(c.y-(maxside*sin(theta))));
    moveto(c.x,c.y);
    lineto(xy1.x,xy1.y);

  end;
end;

{************* ValueChange **********}
procedure TForm1.ValueChange(Sender: TObject);
{called each time one of the three input values changes}
{Calculate which side of the defined rectangle is intersected by a
 line from the center of the rectangle}
var
  x,y:extended;
  t1,t2:extended;
  Q:integer;
begin
  if not (sender is TForm) then memo1.lines.clear;
  if (ABLength.text='') or (BCLength.text='') or (ThetaDegrees.text='') then exit;
  s1:=ABLength.value / 2;
  s2:=BCLength.value / 2;
  theta:= ThetaDegrees.value*pi/180; {theta (in radians)}
  Q:=(ThetaDegrees.value div 90) mod 4; {quadrants (numbered 0 to 3)}
  Drawrect(2*s1,2*s2,theta);

  with memo1.lines do
  begin
    add('Setup:');
    add(format('AB=DC=%d',[ABLength.value]));
    add(format('BC=AD=%d',[BCLength.value]));
    add(format('Theta=%d',[ThetaDegrees.value]));
    add('---------------------------------------------------');
    add('Intersection(s)');

    {Compute t1=tanget theta used in evaluating x=y*tan(theta)
     Assign large value when tangent is undefined}
    if (ThetaDegrees.value<>90)  and (ThetaDegrees.value<>270) then  t1:=tan(theta)
    else t1:=1000;
    {compute t2 = cotangent theta used in evaluating y=x*cotan(theta)}
    if (ThetaDegrees.value<>0)  and (ThetaDegrees.value<>360) then t2:=cotan(theta)
    else t2:=1000;

    {check intersection with AB}
    y:=s2; {equation of AB}
    {for the line, x=r*cos(theta) and y=r*sin(theta) ==> r=y/sin(theta)
     At the point of intersection, y=s2 so r=s2/sin(theta)
     and  x=(s2/sin(theta))*cos(theta).
     Since cos(theta)/sin(theta)=cotangent(theta) by definition,we can code ...}
    x:=y*t2;
    {For the ray to intersect the line segment AB, x must be between -s1 and s1
     and theta must be between -90 (or 270) and 90 degrees (quadrant 0 or 3}
    if (x>=-s1) and (x<=s1) and ((q=0) or (q=1))
    then add(format('AB: Intersected at (%d,%d)',[trunc(x),trunc(y)]));

    {check intersection with BC}
    {Similar logic for the other sides}
    x:=s1;
    y:=x*t1;
    if (y>=-s2) and (y<=s2) and ((q=0) or (q=3))
    then add(format('BC: Intersected at (%d,%d)',[trunc(x),trunc(y)]));

    {check intersection with CD}
    y:=-s2;  {equation of CD}
    x:=y*t2; {possible x intercept}
    if (x>=-s1) and (x<=s1) and ((q=2) or (q=3))
    then add(format('CD: Intersected at (%d,%d)',[trunc(x),trunc(y)]));

    {check intersection with AD}
    x:=-s1;
    y:=x*t1;
    if (y>=-s2) and (y<=s2) and ((q=1) or (q=2))
    then add(format('AD: Intersected at (%d,%d)',[trunc(x),trunc(y)]));
  end;
  memo1.selstart:=0; {make sure the original screen has 1st line in view}
  memo1.sellength:=0;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  valuechange(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
