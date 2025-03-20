unit U_SimpleCart;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type
  float=single;
  TRamp=class(TObject)
    public
     rpoints:array of TPoint;
     {deltas:array of TPoint; }{x & y differences to next point, sppeds calculations}
     nbrpoints:integer;
     canvas:Tcanvas;
     constructor create(newcanvas:TCanvas);
     procedure Addpoint(newx,newy:integer);
     function getangle(x:integer;
                       var startAt:integer; var newy:float;
                       lookback:boolean):float;
     procedure drawramp;
   end;

  TCart =class(TObject)
   public
     time:single;
     xval,yval:float;
     cartx,carty:integer;
     mass:integer;
     gravity:float;
     friction:float;
     theta:float;
     V, Acceleration:float;
     locscale,timescale,timestep:float;
     Canvas:TCanvas;
     Savebg:TBitmap;
     saverect:TRect;
     ramp:Tramp;
     startAt:integer;
     procedure init(newimage:TImage; var newramp:Tramp;
                        newx,newy,newmass:integer;
                        newlocscale,newtimescale,newtimestep,
                        newfriction,newgravity:float);
     procedure start(locx,locy,vZero,newtheta,newtimestep:float);
     function steptime:boolean;
     procedure drawcart;
  end;

  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    FrictionBar: TTrackBar;
    SpeedBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure FrictionBarChange(Sender: TObject);
    procedure SpeedBarChange(Sender: TObject);
    {procedure Button3Click(Sender: TObject);}
  private
    { Private declarations }
  public
    { Public declarations }
    ramp:TRamp;
    cart:TCArt;
    friction:float;
    msDelay:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

constructor TRamp.create(newcanvas:TCanvas);
begin
  inherited create;
  setlength(rpoints,100);
  nbrpoints:=0;
  canvas:=newcanvas;
end;

procedure TRamp.Addpoint(newx,newy:integer);
begin
  if nbrpoints>=high(rpoints) then setlength(rpoints,length(rpoints)+50);
  with rpoints[nbrpoints] do
  begin
    x:=newx;
    y:=newy;
  end;
  inc(nbrpoints);
end;

{******************* TRamp.GetAngle ****************}
function TRamp.getangle(x:integer; var startat:integer; var newy:float;
                        lookback:boolean):float;
{Get the angle for the ramp line segment at X}
{start at Startat, look towards beginning of list if lookback is true}
   function between(lo,med,hi:integer):boolean;
   begin
     if ((lo<=med) and (med<hi))
     or ((lo>=med) and (med>hi))
     then result:=true
     else result:=false;
   end;

var
  i:integer;
  n, dy:integer;
begin
  result:=0;
  n:=startat;
  if n=0 then n:=1;
  startat:=-1;
  if not lookback then
  begin
    for i:= n to nbrpoints-1 do
    if between(rpoints[i-1].x, x, rpoints[i].x)
    then
    begin
       dy:=rpoints[i].y-rpoints[i-1].y;
       result:=arctan(dy/(rpoints[i].x-rpoints[i-1].x));
       startat:=i;
       newy:=rpoints[i-1].y+
           (x- rpoints[i-1].x)/(rpoints[i].x-rpoints[i-1].x)
            *(rpoints[i].y-rpoints[i-1].y);
       break;
    end;
  end
  else
  for i:= n-1 downto 0 do
  if between(rpoints[i].x, x, rpoints[i+1].x)
  then
  begin
     dy:=rpoints[i].y-rpoints[i+1].y;
     result:=arctan(dy/(rpoints[i].x-rpoints[i+1].x));
     newy:=rpoints[i+1].y+
       (rpoints[i].y-rpoints[i+1].y)*(x- rpoints[i+1].x)/(rpoints[i].x-rpoints[i+1].x);
     startat:=i+1;
     break;
  end
end;

{**************** TRamp.DrawRamp **************}
procedure tRamp.drawramp;
var
  i:integer;
begin
  with canvas do
  begin
    pen.width:=2;
    with rpoints[0] do moveto(x,y);
    for i:=1 to nbrpoints-1 do
    with rpoints[i] do lineto(x,y);
    pen.width:=1;
  end;

end;

{***************TCart.init ********************}
procedure TCart.init(newImage:TImage; var newramp:Tramp;
                        newx,newy,newmass:integer;
                        newlocscale,newtimescale,newtimestep,
                        newfriction,newgravity:float);

begin
  canvas:=newImage.canvas;
  if assigned(savebg) then savebg.free;
  savebg:=TBitmap.create;
  savebg.width:=newimage.Width;
  savebg.height:=newimage.height;
  saverect.left:=-1;
  time:=0;
  xval:=0; yval:=0;
  startAt:=0;
  locscale:=newlocscale;
  timescale:=newtimescale;
  cartx:=trunc(locscale*newx); carty:=trunc(locscale*newy);
  mass:=newmass;
  gravity:=newgravity;
  friction:=newfriction;
  V:=0; Acceleration:=0;  theta:=0;
  timestep:=timescale*newtimestep;
  ramp:=newramp;
end;

procedure TCart.start(locx,locy,vZero,newtheta,newtimestep:float);
begin
  xval:=locscale*locx;
  yval:=locscale*locy;
  theta:=newtheta;
  v:=vzero;
  time:=0;
end;

 function sign(x:float):integer;
 begin
   if x<0 then result:=-1
   else result:=+1;
 end;
{************* Steptime **************}
function TCart.steptime:boolean;
var
  sintheta:float;
begin
  time:=time+timestep;
  xval:=xval+v*cos(theta)*timestep;
  {yval:=yval+v*sin(theta)*timestep;}
  theta:=ramp.getangle(trunc(xval),startat,yval, v<0);
  sintheta:=sin(theta);
  if startat>=0 then
  begin
    {use -sign(v) because friction always opposes the direction of travel}
    acceleration:=gravity*(sintheta - sign(v)*friction*abs(cos(theta)));
    v:=v+acceleration*timestep;
    drawcart;
    result:= (abs(sintheta)>0.1) or (abs(v)>2);
  end
  else result:=false;
end;

{***************** TCart.drawcart ***************}
procedure TCart.drawcart;

     procedure rotate(var p:Tpoint; a:real);
     {rotate point "p" by "a" radians about the origin (0,0)}
     var
       t:TPoint;
     Begin
       t:=P;
       p.x:=trunc(t.x*cos(a)-t.y*sin(a));
       p.y:=trunc(t.x*sin(a)+t.y*cos(a));
     end;

     procedure translate(var p:TPoint);
     {move point "p" by x & y amounts specified in "t"}
     Begin
       p.x:=p.x+trunc(xval);
       p.y:=p.y+trunc(yval);
     end;

var
  w,wr:integer;
  p1,p2,p3,p4:tpoint;
begin
  if saverect.left>=0 {restore previously save background (w/o cart)}
  then  canvas.copyrect(saverect,savebg.canvas,saverect);
  wr:=4;
  w:=trunc(cartx) div 2 ;  {get the corners of the car @ 0 deg angle}
  {then rotate it and translate it to the real origin}
  p1:=point(-w,-wr);   rotate(p1,theta);   translate(p1);
  p2:=point(+w,-wr);   rotate(p2,theta);   translate(p2);
  p3:=point(+w,-trunc(carty)-wr);   rotate(p3,theta);   translate(p3);
  p4:=point(-w,-trunc(carty)-wr);   rotate(p4,theta);   translate(p4);

  {save background rectangle where cart will be before drawing cart there}
  with saverect do
  begin
    topleft:=point(trunc(xval-cartx),trunc(yval-2*carty));
    bottomright:=point(trunc(xval+cartx),trunc(yval+carty));
    if left<0 then left:=0;
  end;
  savebg.canvas.copyrect(saverect,canvas,saverect);

  canvas.brush.color:=clred;
  canvas.polygon([p1,p2,p3,p4]);
  canvas.brush.color:=clblack;
  canvas.ellipse(p1.x-wr,p1.y-wr,p1.x+wr,p1.y+wr);
  canvas.ellipse(p2.x-wr,p2.y-wr,p2.x+wr,p2.y+wr);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ramp:=tramp.create(image1.canvas);;
  cart:=TCart.create;
  with ramp do {set up a ramp}
  begin
    addpoint(0,100);
    addpoint(50,150);
    addpoint(250,200);
    addpoint(300,200);
    addpoint(400,175);
    addpoint(image1.width,75);
    drawramp;
  end;
  image1.picture.bitmap.pixelformat:=pf24bit;  {for temp image.savetofile }
  button1click(sender);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  lscale, timestep, timescale:float;

begin
  lscale:=4;
  timestep:=0.1;
  Timescale:=1.0;
  speedbarchange(sender);
  frictionbarchange(sender);
  cart.init(Image1, ramp,
                   5,3,   {cart width and height (in feet)}
                   1000,  {mass, lbs}
                   Lscale,   {location scale (pixels/ft)}
                   Timescale,  {time scale}
                   Timestep,   {timestep}
                   friction,   {rolling friction}
                   32.2    {gravity acceration ft/sec*sec}
                  );
   cart.start(0,                {x}
              lscale*ramp.rpoints[0].y, {y}
              0, {initial velocity}
              0,
              1);
    with image1, canvas do
   begin
     brush.color:=clgreen;
     canvas.fillrect(rect(0,201,width,height));
     brush.color:=$FF8060; {light blue (value = bbggrr)}
     canvas.rectangle(0,0,width,201);
     brush.color:=clred;
   end;
   ramp.drawramp;
   tag:=0;
   repeat
     application.processmessages;
     sleep(msdelay);
   until (tag<>0) or  (not cart.steptime);
   cart.drawcart;
  end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   tag:=1;  {set stopflag}
   canclose:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  tag:=1;  {set stop flag}
end;

procedure TForm1.FrictionBarChange(Sender: TObject);
begin
  friction:=frictionbar.position/1000;
  cart.friction:=friction;
end;

procedure TForm1.SpeedBarChange(Sender: TObject);
begin
  {set so that high position values = low delay}
  with speedbar do  msDelay:=max-position;
end;

(*
procedure TForm1.Button3Click(Sender: TObject);
begin
  image1.picture.savetofile('Simplecart.bmp');
end;
*)

end.
