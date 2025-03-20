unit U_PolarCartesian;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, CheckLst, Menus;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    RBar: TTrackBar;
    Label4: TLabel;
    TBar: TTrackBar;
    Image1: TImage;
    REdt: TEdit;
    TEdt: TEdit;
    XBar: TTrackBar;
    XEdt: TEdit;
    Label1: TLabel;
    Ybar: TTrackBar;
    YEdt: TEdit;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    Info1: TMenuItem;
    Anglerange1: TMenuItem;
    N0to360degrees1: TMenuItem;
    N180to180degrees1: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure XYBarChange(Sender: TObject);
    procedure RTBarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Info1Click(Sender: TObject);
    procedure N180to180degrees1Click(Sender: TObject);
    procedure N0to360degrees1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    scalecenterx,scalecentery:integer;
    currx,curry:integer;
    rfloat, theta:real;
    x,y:integer;
    scalew:integer;
    {Trackbars have OnChange exits: eg.  X or Y change changes R&T, but
    we don't want the RT Onchange exit taken or we'll have a bad loop, etc.
    The next two flags prevent this looping behavior}
    ignoreXYChange, ignoreRtChange:boolean;
    saveFOnt:TFont;
    procedure showcoords;
    procedure makecaption(leftSide, Rightside:string);
  end;

var
  Form1: TForm1;

implementation
uses math, U_Info;
{$R *.DFM}

procedure TForm1.makecaption(leftSide, Rightside:string);
var
  Metrics:NonClientMetrics;
  captionarea,spacewidth,nbrspaces:integer;
  b:TBitmap;
begin
  b:=TBitmap.create;  {to get a canvas}
  metrics.cbsize:=sizeof(Metrics);
  if SystemParametersInfo(SPI_GetNonCLientMetrics, sizeof(Metrics),@metrics,0)
  then  with metrics   do
  begin
    b.canvas.font.name:=Pchar(@metrics.LFCaptionFont.LfFaceName);
    b.canvas.font.height:=metrics.LFCaptionFont.LFHeight;
    b.canvas.font.style:=[fsbold];
    {subtract 3 buttons + Icon + some border space}
    captionarea:=clientwidth-4*iCaptionwidth-4*iBorderWidth;;
    {n = # of spaces to insert}
    spacewidth:=b.canvas.textwidth(' ');
    nbrspaces:=(captionarea-b.canvas.textwidth(Leftside + Rightside)) div spacewidth;
    if nbrspaces>3 then caption:=LeftSide+stringofchar(' ',nbrspaces)+RightSide
    else caption:=LeftSide+' '+RightSide;
  end;
  b.free;
end;


{******************* ShowCoords ************************}
procedure TForm1.ShowCoords;
{Draw X,Y,R,Theta lines and labels, update text box value displays}
var
  scalex,scaley:integer;
  scaler:integer;
  dx,dy:integer;
  s1:string;
  quadrant:integer;
  i:integer;
  angle:real;
  x1,y1: Integer;
begin
  with Image1,canvas do
  begin
    brush.color:=$FFFFDD; {pale blue}
    rectangle(0,0,width,height);
    pen.width:=1;
    pen.color:=clblack;
    pen.style:=pssolid;
    moveto(scalecenterx, 0); lineto(scalecenterx, height);
    moveto(0,scalecentery); lineto(width,scalecentery);
    pen.width:=2;
    with xbar do scalex:=scalecenterx+(position)*scalew div (max-min);
    with ybar do
    begin
      curry:=position;
      scaley:=scalecentery+(position)*scalew div (max-min);
    end;
    moveto(scalecenterx, scalecentery);
    lineto(scalex,scaley);
    dx:=scalex-scalecenterx;
    dy:=scalecentery-scaley;
    scaleR:=round(sqrt(dx*dx+dy*dy))div 3; {draw arc 1/3 of the way out}
    pen.style:=psdot;
    pen.width:=1;

    if (dy>0) or (tbar.min=0)
    then arc(scalecenterx-scaler,scalecentery-scaler,scalecenterx+scaler,
             scalecentery+scaler, scalecenterx+scaler,
             scalecentery, scalex, scaley)
    else if dy<0
    then arc(scalecenterx-scaler,scalecentery-scaler,scalecenterx+scaler,
             scalecentery+scaler,scalex,
             scaley, scalecenterx+scaler, scalecentery);

    pen.color:=clgreen;
    pen.style:=psdot;
    font.color:=clgreen;
    {Add some graph labels if they will fit}
    {Do X label}
    If abs(dx)>textwidth('|-X-|') then
    begin
      moveto(scalecenterx+dx, scalecentery); lineto(scalecenterx+dx,scalecentery-dy);
      textout(scalecenterx+dx div 2, scalecentery-dy-textheight('X'),'X');
    end;
    {Do Y label}
    If abs(dy)>5*textheight('.') then
    begin
      moveto(scalecenterx, scalecentery-dy); lineto(scalecenterx+dx,scalecentery-dy);
      textout(scalecenterx+dx-(textwidth('Y')) div 2, scalecentery- dy div 2,'Y');
    end;
    {Do theta label}
    if dy<>0 then
    begin
      {convert 1/2 theta to radians- so we can draw symbol in center of arc}
      angle:=pi*theta/360;
      s1:=font.name;
      i:=font.size;
      font.name:='symbol';
      font.size:=12;
      textout(scalecenterx+ round(scaler*cos(angle))-textwidth('q') div 2,
            scalecentery-round(scaler*sin(angle))-textheight('q') div 2, 'q');
      font.name:=s1;
      font.size:=i;
    end;
    {Do Radius label}
    if (abs(dx)>10) and (abs(dy)>10) then
    begin
      angle:=theta*pi/180;
      scaleR:=round(sqrt(dx*dx+dy*dy))div 2;
      x1:= scalecenterx+round(scaler*cos(angle))-textwidth('R');
      y1:= scalecentery-round(scaler*sin(angle))-textheight('R');
      quadrant:= (round(theta+360) div 90) mod 4; {make quadrant 0 to 3}
      if (quadrant=1) or (quadrant=3)  then x1:=x1+textwidth('R');
      textout(x1,y1,'R');
    end;
    pen.style:=pssolid;
    pen.color:=clblack;
    font.color:=clblack;
  end;

  {Update text fields}
  Xedt.text:=inttostr(xbar.position);
  with ybar do Yedt.text:=inttostr(min + max-position);
  REdt.text:=format('%4.1f',[rfloat]);
  with TBar do TEdt.text:=inttostr(min+max-position);
end;

{***************** Resize ****************}
procedure TForm1.FormResize(Sender: TObject);
{Rescale form values after size changes}
begin
  with image1 do
  begin
    width:=min(width,height);
    height:=width;
    scalecenterx:=width div 2;
    scalecentery:=scalecenterx;
    xbar.left:=left;
    xbar.width:=width;
    ybar.top:=top;
    ybar.height:=height;
  end;
  with image1.picture.bitmap do
  begin
    width:=image1.width;
    height:=image1.height;
  end;
  scalew:=image1.width ;
  ShowCoords;
end;


{*************** FormActivate *****************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  image1.picture.bitmap:=TBitmap.create;
  windowstate:=WSMaximized;
  xbar.position:=50;  {force trackbar updates}
  makecaption(caption,#169+'G.Darby, 2001, www.delphiforfun.org');
end;

{****************** XYBarChange **************}
procedure TForm1.XYBarChange(Sender: TObject);
{X or Y trackbar changed - recalc everything}
begin
  If ignoreXYChange then exit;  {radius or theta change called us}
  x:=xbar.position;
  with ybar do y:=min+max-position;
  ignoreRTChange:=true;
  RFloat:=sqrt(x*x+y*y);
  with rbar do Position:=min+max-round(rfloat);
  if x{-centerx}<>0 then Theta:=(round(180/pi*arctan2(y,x)))
  else if y>0 then  theta:=90 else If y<0 then theta:=-90 else theta:=0;
  if Theta<tbar.min then theta:=theta+360;
  with Tbar do position:=min+max-round(theta);
  IgnoreRtChange:=false;
  showcoords;
end;

{*************** RTBarChange ***************}
procedure TForm1.RTBarChange(Sender: TObject);
{Radius or Theta Bar changed - recalc everything}
var
  thetaRad,newx,newy:real;
begin
  if ignoreRTChange then exit; {xbar or ybar change called us}
  with TBar do theta:=(min+max-position);
  thetaRad:=theta*pi/180; {angle in radians}
  with rbar do rfloat:=min+max-position;
  {trim radius if necessary to keep image onscreen}
  newx:=round(Rfloat*cos(thetaRad));
  newy:=round(Rfloat*sin(thetaRad));
  newx:=max(min(newx,xbar.max),xbar.min);
  newy:=max(min(newy,ybar.max),ybar.min);
  rfloat:=sqrt(newx*newx+newy*newy);
  ignoreXYChange:=true;
  with rbar do rfloat:=min+max-position;
  xbar.position:=round(Rfloat*cos(thetaRad));
  with ybar do position:=min+max - round(Rfloat*sin(thetarad));
  ignoreXYChange:=false;
  showcoords;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin savefont:=TFont.create;  end;

procedure TForm1.Info1Click(Sender: TObject);
begin   InfoDlg.showmodal; end;

procedure TForm1.N180to180degrees1Click(Sender: TObject);
var  n:integer;
begin
   with tbar do
   begin
     n:=position;
     max:=+180;
     min:=-180;
     if n>180 then position:=n-360;
   end;
   N180to180Degrees1.checked:=true;
   N0to360Degrees1.checked:=false;
   RTBarChange(Tbar);
end;

procedure TForm1.N0to360degrees1Click(Sender: TObject);
var  n:integer;
begin
  with tbar do
  begin
    n:=position; {save position before changing max or min}
    max:=+360;
    min:=0;
    if n<0 then position:=n+360;
   end;
   N180to180Degrees1.checked:=false;
   N0to360Degrees1.checked:=true;
   Rtbarchange(Tbar);
end;

end.
