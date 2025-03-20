unit U_RotateASquare;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Shape1: TShape;  {Just a circle to rotate around}
    TBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel; {Use a trackbar to let user change the angle}
    procedure TBarChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    p1,p2,p3,p4:TPoint; {the four corners of the square}
    origin:TPoint;  {the center of the square}
    procedure makebox(const origin:TPoint;
                      const angle,side:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure Tform1.makebox(const origin:TPoint;
                         const angle,side:integer);
{draw a square with side length "side",
 centered on "origin"
 with one side at "angle" from horizontal}


     procedure rotate(var p:Tpoint; a:real);
     {rotate point "p" by "a" radians about the origin (0,0)}
     var
       t:TPoint;
     Begin
       t:=P;
       p.x:=trunc(t.x*cos(a)-t.y*sin(a));
       p.y:=trunc(t.x*sin(a)+t.y*cos(a));
     end;

     procedure translate(var p:TPoint; t:TPoint);
     {move point "p" by x & y amounts specified in "t"}
     Begin
       p.x:=p.x+t.x;
       p.y:=p.y+t.y;
     end;

var
  a:real;
  w:integer;
begin
  a:=angle*pi/180.0; {convert angle from degrees to radians}
  w:=side div 2 + 2; {set "radius" to make square centered on (0,0)}
  {get the corners of a square @ 0 deg angle}
  {then rotate it and translate it to the real origin}
  p1:=point(-w,-w);
  rotate(p1,a);
  translate(p1,origin);
  p2:=point(+w,-w);
  rotate(p2,a);
  translate(p2,origin);
  p3:=point(+w,+w);
  rotate(p3,a);
  translate(p3,origin);
  p4:=point(-w,+w);
  rotate(p4,a);
  translate(p4,origin);
  invalidate;
end;

procedure TForm1.TBarChange(Sender: TObject);
{user moved the track bar}
begin
  {rebuild the square at a new angle}
  makebox(origin,TBar.position, shape1.Width);
  label1.caption:=inttostr(Tbar.position);
end;

procedure TForm1.FormPaint(Sender: TObject);
begin
  {draw the square}
  canvas.polyline([p1,p2,p3,p4,p1] );
end;

procedure TForm1.FormActivate(Sender: TObject);
{At startup, set origin of square to center of shape}
begin
  origin.x:=shape1.left+shape1.Width div 2;
  origin.y:=shape1.top+ shape1.height div 2;
  makebox(origin,0,shape1.width);
  doublebuffered:=true;
end;

end.
