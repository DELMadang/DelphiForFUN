unit U_FlatLandPianoMovers;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NumEdit, Buttons, ExtCtrls, ComCtrls;

type


  TForm1 = class(TForm)
    Image1: TImage;
    TryMoveBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    PLenUD: TUpDown;
    PWidthUD: TUpDown;
    C1UD: TUpDown;
    C2UD: TUpDown;
    C1Edt: TEdit;
    C2Edt: TEdit;
    PLengthEdt: TEdit;
    PWidthEdt: TEdit;
    Label5: TLabel;
    Steps: TEdit;
    StepsUD: TUpDown;
    Memo1: TMemo;
    procedure TryMoveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PLengthEdtChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure drawimage;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;
type
  tline=record
    p1,p2:TPoint;
  end;

function sameside(L:TLine; p1,p2:TPoint; var pointonborder:boolean):int64;
  {used by Intersect function}
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
    if ((dx<>0) or (dy<>0)) and (result=0) then pointonborder:=true
    else pointonborder:=false;
  end;

 {******************** INTERSECT *******************}
  function  intersect(L1,L2:TLine; var pointonborder:boolean):boolean;
  {test for 2 line segments intersecting }
  var
    a,b:int64;
    pb:boolean;
  begin
    pointonborder:=false;
    a:=sameside(L1,L2.p1,L2.p2, pb);
    if pb then pointonborder:=true;
    b:=sameside(L2,L1.p1,L1.p2,pb);
    if pb then pointonborder:=true;
    result:=(a<=0) and (b<=0);
  end;

procedure TForm1.TryMoveBtnClick(Sender: TObject);
var
  L,W,N,H,V:integer;
  PrevDrawAngle:integer;  {used to check when piano was last drawn}
  Angle:extended;
  line1,line2:Tline;
  pointonborder, fits:boolean;
begin
  with image1, canvas do
  begin
    brush.color:=clwhite;
    rectangle(clientrect);
    drawimage;
    L:=PlenUD.position;
    w:=PWidthUD.position;
    {define a line from outside to inside of corrider corner}
    line2.p1:=point(0,0);
    line2.p2:=point(c1ud.position,c2UD.position);
    h:=0;
    angle:=0;
    prevdrawangle:=-1;
    fits:=true;
    while (fits) and (angle<=Pi/2) do
    begin
      v:=trunc(sqrt(L*L-H*H));
      {line1 contains coordinates of lower corners of the piano.
     If it intersects a line fron the outside to inside corners
     of the hallway (line2), it clears the corner at this angle}
      line1.p1:=point(trunc(L*sin(angle)+w*cos(angle)),trunc(W*sin(angle)));
      line1.p2:=point(trunc(w*cos(angle)),trunc(L*cos(angle)+W*sin(angle)));
      if not intersect(line1,line2, pointonborder)
      then fits:=false;
      N:=trunc(radtodeg(angle));
      if not fits or (N-prevdrawangle>10) then
      begin {only draw piano if stuck or every 10 degrees}
        prevdrawangle:=N;
        Moveto(0,V);
        lineto(H,0);
        lineto(H+trunc(W*cos(angle)),trunc(W*sin(angle)));
        lineto(trunc(W*sin(pi/2-angle)),V+trunc(W*cos(pi/2-angle)));
        lineto(0,V);
      end;
      angle:=angle+pi/2/StepsUD.position;
      h:=trunc(l*sin(angle));
    end;
    if fits then
    begin
     rectangle(L,0,L+L, W);
     showmessage('Made it!');
    end
    else showmessage('Won''t fit!')
  end;
end;

procedure TForm1.drawimage;
{draw inital and final image of the piano}
var
  L,W:integer;
begin
  with image1, canvas do
  begin
    brush.color:=clWhite;
    rectangle(clientrect);
    pen.width:=2;
    moveto(c1UD.position,height);
    lineto(c1UD.position,c2ud.position);
    lineto(width,c2UD.position);
    pen.width:=1;
    brush.color:=clsilver;
    brush.style:= bsdiagcross;
    canvas.floodfill(3,3,clblack,fsborder);
    L:=PlenUD.position; {piano length}
    W:=PWidthUD.position; {piano width}
    brush.color:=clgreen;
    brush.style:=bssolid;
    rectangle(0,L ,W,L+L);
    moveto(c1UD.position,height);
    lineto(c1UD.position,c2ud.position);
    lineto(width,c2UD.position);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  drawimage;
end;

procedure TForm1.PLengthEdtChange(Sender: TObject);
begin
  drawimage;
end;

end.
