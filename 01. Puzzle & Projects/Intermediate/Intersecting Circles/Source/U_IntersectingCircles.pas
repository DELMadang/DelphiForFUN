unit U_IntersectingCircles;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, jpeg, shellapi;

type
  TForm1 = class(TForm)
    Image1: TImage;
    DrawBtn: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Image2: TImage;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    ResultLbl: TLabel;
    CX1UD: TUpDown;
    Edit1: TEdit;
    Edit2: TEdit;
    CY1UD: TUpDown;
    Edit9: TEdit;
    R1UD: TUpDown;
    Cx2UD: TUpDown;
    Edit10: TEdit;
    Edit11: TEdit;
    Cy2UD: TUpDown;
    Edit12: TEdit;
    R2UD: TUpDown;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    procedure DrawBtnClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure UDClick(Sender: TObject; Button: TUDBtnType);
    procedure FormActivate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure StaticText1Click(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
      x1,y1,x2,y2,r1,r2:integer;
      procedure solve;
      procedure drawcircles;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{Original source code for CircleIntersection was written in C by  Tim Voght at
  http://astronomy.swin/edu.au/~pbourke/geometry/2circle/tvoght.c
}

function CircleIntersection(x1,y1,r1,x2,y2,r2:extended;
                           var ix1,iy1,ix2,iy2,ix3,iy3:extended):integer;
{Given two circles centered at P1, (x1,y1) and P2, (x2,y2) with radii
 r1 and r2,  find the points of intersection, if any.
 Result value is the number of intersection points, 0 1, or 2.
 First intersection point IP1 is (ix1,iy1), second intersection point
 IP2 is (ix2,iy2),  P3 (ix3,iy3) is the intersection point of line connecting
 P1 and P2  with line connecting IP1 and IP2
 }

var  a, dx, dy, d, h, rx, ry:extended;
  { dx and dy are the vertical and horizontal distances between
    the circle centers. }
begin
  dx := x2 - x1;
  dy := y2 - y1;

  { Determine the straight-line distance between the centers. }
  d := sqrt((dy*dy) + (dx*dx));

  { Check for solvability. }
  if   (d > (r1 + r2)) {too far apart}
    or (d< abs(r1-r2)) {one contained in other}
  then result:=0
  else
  begin   {there is at least one intersection}

    { P3 is the point where the line through the circle
      intersection points crosses the line between the circle
      centers.
     }

    { Determine a,  the distance from P1 to P3. }
    {cos(alpha)=a/r1 where alpha is the angle at P1  (IP1,P1,P2) }
    {also by law of cosines cos(alpha)=(r1^2+d^2-r2^2)/(2*r1*d) }
    {so, by setting equations equal to each other}
    a := ((r1*r1) - (r2*r2) + (d*d)) / (2.0 * d) ;

    {Determine the coordinates of point 3}
    ix3 := x1 + (dx * a/d);
    iy3 := y1 + (dy * a/d);

    {Determine the distance from point 3 to either of the
      intersection points.
     }
    h := sqrt((r1*r1) - (a*a));

    {Determine the absolute intersection points.}

    {0riginal C code calc}
    (*
    {Determine the offsets of the intersection points from point 3. }
    rx := -dy * (h/d);
    ry := dx * (h/d);
    ix1 := ix3 + rx;
    iy1 := iy3 + ry;
    ix2 := ix3 - rx;
    iy2 := iy3 - ry;
    *)

    {replacement code}
    ix1:=x1+(a*dx-h*dy)/d;
    iy1:=y1+(h*dx+a*dy)/d;

    ix2:=x1+(a*dx+h*dy)/d;
    iy2:=y1+(-h*dx+a*dy)/d;

    if (abs(ix1-ix2) +abs(iy1-iy2)) <1e-3
    then result:=1 {really close call them touching}
    else result:=2;
  end;
end;

{********* DrawCircles *********}
Procedure TForm1.DrawCircles;
{clear the screen and redraw two circles}
{called when random circles are being drawn or when one of the
 displayed dimensions is changed by the user}
begin
  with image1,canvas do
  begin
    brush.style:=bssolid;
    brush.color:=clwhite;
    fillrect(clientrect);
    {draw circles}
    pen.color:=clblack;
    brush.style:=bsclear;
    ellipse(x1-r1,height-y1-r1,x1+r1,height-y1+r1);
    ellipse(x2-r2,height-y2-r2,x2+r2,height-y2+r2);
    {draw centers}
    brush.color:=clblack;
    brush.style:=bsSolid;
    ellipse(x1-2,height-y1-2,x1+2,height-y1+2);
    ellipse(x2-2,height-y2-2,x2+2,height-y2+2);
    {update coordinate display}
    Cx1UD.position:=x1; Cy1UD.position:=y1; R1UD.position:=r1;
    Cx2UD.position:=x2; Cy2UD.position:=y2; R2UD.position:=r2;
  end;
  Solve;  {find and display intersection points}
end;

{*********** DrawBtnClick ***********}
procedure TForm1.DrawBtnClick(Sender: TObject);
{Draw two random circles (which may or may not intersect}
var
  d,dx,dy:extended;
  OK:boolean;
begin
  panel1.visible:=true;
  image2.visible:=false;
  with image1, canvas do
  begin
    picture.Bitmap.height:=height;
    picture.bitmap.width:=width;
    repeat
      OK:=true;
      r1:=random(height div 4)+height div 8;
      r2:=random(height div 4)+height div 8;
      x1:=random(width -2*r1)+r1;
      x2:=random(width -2*r2)+r2;
      y1:=random(height -2*r1)+r1;
      y2:=random(height -2*r2)+r2;
      {make most, but not all result intersect}
      if random(3)>0 then  {check for intersection 2/3 of the time}
      begin
        dx := x2 - x1;
        dy := y2 - y1;
        d := sqrt((dy*dy) + (dx*dx));
        if   (d > (r1 + r2)) {too far apart}
          or (d< abs(r1-r2)) {one contained in other}
        then OK:=false;
      end;
    until OK;
    DrawCircles;
    solve;
  end;
end;

{************ Solve ************}
procedure TForm1.Solve;
var
  ix1,iy1,ix2,iy2:extended; {Circle intersection points}
  ix3,iy3:extended; {intersection of line between circle centers and line
                     connecting circle intersection points}
  n:integer;
  xx1,yy1,xx2,yy2,xx3,yy3:integer;
begin
  with image1, canvas do
  begin
    n:=circleintersection(x1,y1,r1,x2,y2,r2,ix1,iy1,ix2,iy2,ix3,iy3);
    if n>0 then
    begin
      pen.color:=clred;
      {convert intersection points back to integer values for plotting}
      xx1:=trunc(ix1); yy1:=trunc(iy1);
      xx2:=trunc(ix2); yy2:=trunc(iy2);
      xx3:=trunc(ix3); yy3:=trunc(iy3);
      //moveto(x1,height-y1); lineto(x2,height-y2);
      //moveto(xx1,height-yy1); lineto(xx2,height-yy2);
      //moveto(x1,height-y1); lineto(xx1,height-yy1);
      //moveto(x2,height-y2); lineto(xx1,height-yy1);
      if n=1
      then  Resultlbl.caption:=format('Results -  1 point:  (%d,%d)',[xx1,yy1])
      else Resultlbl.caption:=format('Results -  2 points:  (%d,%d) & (%d,%d)',
                                     [xx1,yy1,xx2,yy2]);
      brush.style:=bssolid;
      brush.color:=clred;

      ellipse(xx1-2,height-yy1-2,xx1+2,height-yy1+2);
      if n>1 then ellipse(xx2-2,height-yy2-2,xx2+2,height-yy2+2);
    end
    else Resultlbl.caption:='No intersection';
  end;
end;

{************ Image1MouseMove **************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{Display mouse cursor coordinates as it moves, change y so that increasing y
 is up}
var
  p:TPoint;
begin
  p:=point(x,image1.height-y);
  label1.caption:='X:'+inttostr(p.x)+'  Y:'+inttostr(p.y);
end;

{*********** UDClick **************}
procedure TForm1.UDClick(Sender: TObject; Button: TUDBtnType);
{User changed one of the circle parameters, just reset and redraw everything}
begin
  x1:=Cx1UD.position; y1:=Cy1UD.position; r1:=R1UD.position;
  x2:=Cx2UD.position; y2:=Cy2UD.position; r2:=R2UD.position;
  Drawcircles;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  x1:=150;  y1:=120; r1:=100;
  x2:=280;  y2:=175; r2:=70;
  drawcircles;
  //DrawBtnClick(sender);
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   if key=#13 then
   begin
     udclick(sender,btNext);
     key:=#0;
   end;  
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
  'http://www.delphiforfun.org/programs/math_topics/intersectingCircles.htm',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.



