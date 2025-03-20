unit U_DrawMoon;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    PBox: TPaintBox;
    CloseBtn: TButton;
    MoonBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure PBoxPaint(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MoonBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    moonphase:single; {fraction of moon visible:  0 to 1}
    runflag:boolean; {controls program stopping}
    waxing:boolean;  {true ==> moon visibility is increasing}
    b:TBitmap;       {moon image}
    showmoon:boolean; {flag}

    {moon image coordinates}
    lx,rx,ty,by:integer; {corners of moon image}
    cx,cy:integer; {center of moon image}
    rad:integer; {radius}
  end;

var
  Form1: TForm1;

implementation
uses math;

{$R *.DFM}

{******************* FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
var
  inc:single; {angle - radian increment for each view}
  angle:single;  {the angle of sun}
  fname:string;
  i,j:integer;
begin
  with pbox do
  begin {set moon image dimensions}
    lx:=3;  {left x}
    ty:=2;  {top y}
    rx:=width-lx; {right x}
    by:=height-ty;{bottom y}
    cx:=width div 2; {center}
    cy:=height div 2;
    rad:= cx-lx;{radius}
  end;
  showmoon:=false; {no moon image initially}
  fname:=extractfilepath(application.exename)+'BrightFullMoon.bmp';
  if fileexists(fname) then
  begin
    b:=TBitMap.create;
    b.loadfromfile(fname);
    {b.pixelformat:=pf24bit;} {to force true black background}
    moonbtn.visible:=true; {OK to show the button}
    {trim image to circle}
    for i:=0 to b.width-1 do
    for j:= 0 to b.height-1 do
    if trunc(sqrt((cx-i)*(cx-i)+(cy-j)*(cy-j)))>=rad
    then b.canvas.pixels[i,j]:=clblack;
  end;
  doublebuffered:=true;
  runflag:=true;
  angle:=0;
  inc:=pi/64;
  {loop to set moon phase info}
  repeat
    angle:=angle+inc;
    if angle>=2*pi then angle:=angle-2*pi;
    moonphase:=(1+cos(angle))/2;
    if angle>=Pi then waxing:=true
    else waxing:=false;
    pbox.invalidate;
    application.processmessages;
    sleep(50);
  until runflag=false;
  b.free;
end;

  procedure swap(var a,b:integer);
  {exchange 2 integers}
    var n:integer;
    begin  n:=a; a:=b; b:=n; end;

{****************** PBoxPaint *****************}
procedure TForm1.PBoxPaint(Sender: TObject);
var
  delta:integer; {x distance from cebter edge of image to center edge of arc}
  fillfrom:integer;  {x coordinate for floodfill}
  ds,de:integer;  {y coord start and end points for arc}
  myblack:integer;
begin
  with PBox,canvas do
  begin
    {make the radius of the crescent vary from "rad" down to 0 as moonphase
     varies from 0 to 1/2 and then back to "rad" as phase goes to 1}
    delta:=trunc(rad*2*abs(moonphase-0.5));
    if showmoon then
    begin
      draw(0,0,b); {draw moon image}
      brush.style:=bsClear; {let ellipse draw only the border}
      myblack:=b.canvas.pixels[1,1];
    end
    else
    begin
      myblack:=clblack;
      brush.color:=myblack;
      rectangle(0,0,width,height);
      brush.color:=$C0E0E0; {B-G-R value $C0E0E0 = light GOLD}
    end;
    pen.color:=myblack;
    ellipse(Lx,TY,RX,By);
    ds:=ty-1;  {set arc start and end points}
    de:=by+1;
    if waxing then {increasing moon}
    begin
      {x coordinate for floodfill to black-out left side for waxing moon}
      fillfrom:=lx+2;
      {arc draws counter-clockwise, so to draw right half of ellipse, start at bottom}
      if moonphase<0.5 then swap(ds,de);

    end
    else {waning (decreasing) moon}
    begin
      fillfrom:=rx-2; {set right side point for floodfill}
      {same thing - waning moon with over 50% showing, draw right portion of ellipse}
      if moonphase>0.5 then swap(ds,de)
    end;
    if delta>1
    then arc(cx-delta,ty,cx+delta,BY,cx,ds,cx,de)
    else {ellipse too narrow to draw, use a line}
    begin
     moveto(cx,ty);
     lineto(cx,by);
    end;
    brush.color:=myblack;
    If moonphase<0.99 then floodfill(fillfrom,cy,myblack,fsborder);
    {pixels[fillfrom,cy]:=cllime;} {for debugging}
  end;
end;
{********************* CloseBtnClick *************}
procedure TForm1.CloseBtnClick(Sender: TObject);
begin
  close;
end;

{******************* FormClose *****************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  runflag:=false;
  action:=cafree;
end;

{*********************** MoonBtnClick *************}
procedure TForm1.MoonBtnClick(Sender: TObject);
{Set/reset flag to show moon image}
begin
  if not showmoon then
  begin
    showmoon:=true;
    moonbtn.caption:='Hide moon image';
  end
  else
  begin
    showmoon:=false;
    moonbtn.caption:='Show moon image';
  end;
end;

end.
