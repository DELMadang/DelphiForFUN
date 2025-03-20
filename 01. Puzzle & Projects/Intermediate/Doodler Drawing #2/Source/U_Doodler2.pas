Unit U_Doodler2;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A Doodler drawing program featuring:
  . user selected pen characteristics
  . rotate-duplicated and kaleidoscope drawing
  . fill closed areas with user selected color
  . print and save images
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Menus, Buttons, printers, Spin, ToolWin;

type

  TPoints=record  {a point in cartesian and polar coordinate form}
    px,py:integer;
    r,theta:real;
  end;


  TSegments=record
   {a drawing segment - array of points connected by pen with specified color
    and width}
    color:TColor;
    width:integer;
    nbrsegpoints:integer;
    points:array of TPoints;
  end;

  TForm1 = class(TForm)
    ResetBtn: TButton;
    ColorDialog1: TColorDialog;
    UndoBtn: TButton;
    SaveBtn: TButton;
    SaveDialog1: TSaveDialog;
    PrintBtn: TButton;
    Image1: TImage;
    RefreshBtn: TButton;
    PrintDialog1: TPrintDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label7: TLabel;
    ColorRect: TPanel;
    Label8: TLabel;
    Edit6: TEdit;
    WidthUD: TUpDown;
    FillColorRect: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    RotateDegUD: TUpDown;
    RotateTimesUD: TUpDown;
    Edit3: TEdit;
    Label3: TLabel;
    RotateCheck: TCheckBox;
    Label5: TLabel;
    Edit4: TEdit;
    MirrorStartUD: TUpDown;
    MirrorAngleUD: TUpDown;
    Edit5: TEdit;
    Label6: TLabel;
    KaleidoscopeCheck: TCheckBox;
    Showborders: TCheckBox;
    TabSheet4: TTabSheet;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure ShowbordersClick(Sender: TObject);
    procedure PenColorBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure SpinEdit1Exit(Sender: TObject);
    procedure RefreshBtnClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  public
    drawing:boolean; {true while left button is depressed on the image}
    segments:array of TSegments; {array of all the drawing segments}
    nbrsegs:integer; {nbr of drawing segments in the drawing}
    cx,cy:integer;  {center of the image}
    penwidth:integer;
    mirrorstart,mirrorangle:real;
    mirrorcount:integer;
    pctleft,pcttop,pctwidth,pctheight:real; {Used to rescale image on resize}
    procedure drawborders; {draw mirrors}
    procedure makepolar(var P:TPoints); {add radius and angle to Tpoints rec}
    procedure drawLineInSeg(SegNbr, EndPoint :integer);
    procedure redrawimage;
    Procedure clearimage;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses math, UMakeCaption;

{***************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  with image1 do
  begin
    pctleft:=left/self.width;
    pcttop:=top/self.height;
    pctheight:=height/self.height;
    pctwidth:=width/self.width;
  end;
  windowstate:=wsmaximized;
  penwidth:=3;
  clearimage;
  doublebuffered:=true;
  setlength(segments,10);
  nbrsegs:=0;
  colorrect.color:=clblue;
  image1.Canvas.pen.color:=clblue;
  fillcolorrect.color:=clred;
  makecaption('Doodler 2',
              'Copyright '+ #169+' 2002, G. Darby, http://delphiforfun.org',
              self);
end;

{***************** MakePolar *************}
procedure TForm1.makepolar(var P:TPoints);
  {Add radius and angle to a Tpoints record}
    begin
      with p do
      begin
        r:=round(sqrt(px*px+py*py));
        theta:=arctan2(-py,px);
        if theta<0 then theta:=theta+2*Pi;
      end;
    end;

{********************** ImageMouseDown **************}
procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{If left button, start a new drawing segment with current pen color and width}
{If right button, flood fill area with current fill color}
begin
  if button = mbleft then
  begin
    spinedit1exit(sender);
    refreshbtn.setfocus; {force trigger onexit from last control changed}
    drawing:=true;
    inc(nbrsegs);
    if nbrsegs>high(segments) then setlength(segments,length(segments)+10);
    with segments[nbrsegs-1] do
    begin
      image1.canvas.pen.color:=colorrect.color;
      color:=colorRect.color;
      width:=WidthUD.position;
      setlength(points, 100);
      with points[0] do
      begin
        px:=x-cx;
        py:=y-cy;
        makepolar(points[0]);
      end;
      nbrsegpoints:=0;
    end;
  end
  else
  with image1.canvas do {right click - fill an area}
  begin
    brush.color:=fillColorRect.color;
    image1.canvas.floodfill(x,y,pixels[x,y],fsSurface);
  end;
end;

{***************** ImageMouseMove *******************}
procedure TForm1.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{Add line segment points to current last segment}
begin
  if drawing then
  with segments[nbrsegs-1] do
  begin
    inc(nbrsegpoints);
    if nbrsegpoints>=length(points) then setlength(points, length(points)+100);
    with points[nbrsegpoints] do
    begin
      px:=x-cx;
      py:=y-cy;
      makepolar(points[nbrsegpoints]);
    end;
    if nbrsegpoints>1 then drawlineInseg(nbrsegs-1, nbrsegpoints);
  end;
end;

{********************* ImageMouseUp ***************}
procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{end of segment, trim the points array to exact length used}
begin
 if button = mbleft then
 begin
    drawing:=false;
    with segments[nbrsegs-1] do setlength(points, nbrsegpoints+1);
 end;
end;

{********************* DrawLineInSeg ****************}
procedure TForm1.drawLineInSeg(SegNbr, EndPoint :integer);
{draw a single line segment and its rotations/reflections}
{Draw from segment "SegNbr" and from point "Endpoint"-1 to "Endpoint"}
var
  rotate:real;

  procedure getmirrornbrs(p:TPoints; var m1,m2:integer);
   {return the first mirror with a smaller angle than p}
   VAR
     i:integer;
   begin
     m1:=0;
     for i:= mirrorcount-1 downto 0 do
     begin
       if mirrorstart+i*mirrorangle<p.theta then
       begin
         m1:=i;
         break;
       end;
     end;
     if m1<mirrorcount-1 then m2:=m1+1
     else m2:=0;
   end;



   procedure drawMirrorSegs(mnbr:integer; p1,p2:TPoints; var newp1,newp2:TPoints);
   {Draw the p1 to p2 line segment for mirror number mnbr}
   var
    {a,}b:real;
    {v,}v2:real;
   begin
     v2:=2*(mirrorstart+mnbr*mirrorangle); {v2=twice mirror angle}
     {v2:=2*v;}
     with image1.canvas do
     begin
       with p1 do
       begin
         (*
         a:=theta-v; {angle between point and mirror}
         {angle for reflected point = mirror angle - twice the difference bewteen point and mirror}
         b:=theta-2*a;
         *)
         b:=V2-theta;{equivalent to above but a little faster}
         newp1.px:=round(r*cos(b));
         newp1.py:=-round(r*sin(b));
       end;

       with p2 do
       begin
         b:=V2-theta;
         newp2.px:=round(r*cos(b));
         newp2.py:=-round(r*sin(b));
       end;
       moveto(cx+newp1.px,cy+newp1.py); lineto(cx+newp2.px,cy+newp2.py);
      {for debugging} {textout(cx+newp1.px,cx+newp1.py-5,'M:'+intTostr(mnbr));}
     end;
   end;

var
  i,k:integer;
  p1,p2,p3,p4:TPoints;
  x2,y2,m1,m2:integer;
  a,b:real;
begin   {DrawLineInSeg}
  rotate:=rotateDegUD.position*pi/180;
  if segnbr<0 then exit;
  with segments[segnbr], image1, canvas do
  begin
    pen.width:=segments[segnbr].width;
    pen.color:=segments[segnbr].color;
    if nbrsegpoints>=Endpoint then
    with points[endpoint] do
    begin
      moveto(cx+points[endpoint-1].px,cy+points[endpoint-1].py);
      lineto(cx+px,cy+py);
    end;
    {Do rotate draw}
    if  rotatecheck.checked and (rotatetimesud.position>0) then
    begin
      a:=points[endpoint-1].theta;
      b:=points[endpoint].theta;
      for k:= 1 to rotatetimesud.position do
      begin
        a:=a+rotate;
        x2:=round(points[endpoint-1].r*cos(a));
        {note - sign for y since screen coordinates increase downward}   
        y2:=-round(points[endpoint-1].r*sin(a));
        moveto(cx+x2,cy+y2);
        b:=b+rotate;
        x2:=round(points[endpoint].r*cos(b));
        y2:=-round(points[endpoint].r*sin(b));
        lineto(cx+x2,cy+y2);
      end;
    end;

    {Do reflection (kaleidoscope) draw}
    if  Kaleidoscopecheck.checked and (MirrorCount>0) then
    begin
      getmirrornbrs(points[endpoint-1],m1,m2);
      p1:=points[endpoint-1];
      p2:=points[endpoint];
      p3:=p1; p4:=p2;
      {each mirror reflects the previous reflected image, working
       clockwise and counter clockwise from original points}
      for i:= 0 to mirrorcount div 2 -1 do
      begin
        makepolar(p1); makepolar(p2);
        makepolar(p3); makepolar(p4);
        drawMirrorSegs(m1,p1,p2, p1,p2);
        drawMirrorSegs(m2,p3,p4, p3, p4);
        inc(m2); if m2>mirrorcount-1 then m2:=m2-mirrorcount;
        dec(m1); if m1<0 then m1:=m1+mirrorcount;
      end;
    end;
  end;
end;

{**************** ClearImage ***********}
Procedure TForm1.clearimage;
{erase the screen image}
begin
  with image1.canvas do
  begin
    brush.color:=clwhite;
    fillrect(rect(0,0,width,height));
  end;
end;

{**************** ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{clear everything and start over}
begin
  setlength(segments,10);
  nbrsegs:=0;
  clearimage;
  drawborders;
end;

{******************* UndoBtnClick ************}
procedure TForm1.UndoBtnClick(Sender: TObject);
{Delete the last segment}
begin
  If nbrsegs>0 then dec(nbrsegs);
  redrawimage;
end;

{******************* SaveBtnClick *************}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Save the drawing as a bitmap, bmp file}
var
  b:TBitmap;
begin
   if savedialog1.execute then
   with savedialog1, image1  do
   begin
     b:=TBitmap.create;
     b.height:=clientheight;
     b.width:=clientwidth;
     b.pixelformat:=pf24bit;
     b.canvas.copyrect(clientrect, canvas, clientrect);
     b.savetofile(savedialog1.filename);
     b.free;
   end;
end;

{**************** ShowBordersClick **************}
procedure TForm1.ShowbordersClick(Sender: TObject);
begin  redrawimage;  end;

{******************** DrawBorders *************}
procedure TForm1.drawborders;
{draw the mirrors if option is turned on}
var
  angle,incr,h:real;
  x,y:integer;
  i:integer;
begin
  if showborders.checked then
  with image1, image1.canvas do
  begin
    pen.width:=1;
    pen.color:=clblack;
    brush.color:=clsilver;
    if mirrorcount=0 then
    begin
      moveto(0,height div 2); lineto(width, height div 2);
      moveto(width div 2, 0); lineto(width div 2, height);
    end
    else
    begin
      pen.color:=cldkgray;
      pen.width:=4;
      angle:= mirrorstart;
      incr:=mirrorangle;
      {get x,y coordinates for outer edge of each mirror}
      for i:= 0 to mirrorcount-1 do
      begin
        if angle<pi/4 then
        begin
          x:=width div 2;
          h:=abs(cx/cos(angle));
          y:=trunc(sin(angle)*h);
        end
        else if angle < 3*pi/4 then
        begin
          y:=height div 2;
          h:=abs(cy/sin(angle));
          x:=trunc(cos(angle)*h);
        end
        else if angle<5*pi/4 then
        begin
          x:=-width div 2;
          h:=abs(cx/cos(angle));
          y:=trunc(sin(angle)*h);
        end
        else
        begin
          y:=-height div 2;
          h:=abs(cy/sin(angle));
          x:=trunc(cos(angle)*h);
        end;
        moveto(cx,cy); lineto(cx+x,cy-y); {draw the mirror}
        angle:=angle+incr;
        if angle>2*pi then angle:=angle-2*pi;
      end;
    end;
  end;
end;

{******************** PenColorBtnClick **************}
procedure TForm1.PenColorBtnClick(Sender: TObject);
{select a new pen or fill color}
begin
  if (sender is TPanel)then
  begin
    colordialog1.color:=TPanel(sender).color; {set initial dialog color to current}
    if (colordialog1.execute)
    then TPanel(sender).color:=colordialog1.color;
  end;
end;

{****************** ReDrawImage *****************}
procedure TForm1.redrawimage;
{redraw the entire image}
var
  i,j:integer;
  savecursor:TCursor;
begin
  savecursor:=screen.cursor;
  screen.cursor:=crhourglass;
  clearimage;
  drawborders;
  for i:=0 to nbrsegs-1 do
  with segments[i] do
  if nbrsegpoints>1 then
  for j:= 1 to nbrsegpoints-1 do DrawLineInSeg(i,j);
  screen.cursor:=savecursor;
end;

{**************** PrintbtnClick **************}
procedure TForm1.PrintBtnClick(Sender: TObject);
var
  x1,y1,x2,y2,n:integer;
begin
  If Printdialog1.execute then
  with printer, printer.canvas do
  Begin
    begindoc;
    if pagewidth<pageheight then n:=pagewidth else n:=pageheight;
    x1:=n div 10;  {left border at 10% of short page dimension}
    y1:=x1;
    x2:=9*n div 10; {right border at 90% of short page dimension}
    y2:=x2;
    {draw image on page}
    stretchdraw(rect(0,0,x2-x1,y2-y1),image1.picture.bitmap);
    enddoc;
  end;
end;

{********************* Spindit1Exit *******************}
procedure TForm1.SpinEdit1Exit(Sender: TObject);
begin

 if Mirrorstartud.position>0 then mirrorstart:=pi*MirrorstartUD.position/180
  else mirrorstart:=0;
  if MirrorangleUD.position>0 then
  begin
    mirrorcount:=360 div MirrorangleUD.position;
    mirrorangle:=pi*MirrorangleUD.position/180;
  end
  else
  begin
    mirrorcount:=0;
    mirrorangle:=0;
  end;
end;

{********************* RefreshBtnClick ****************}
procedure TForm1.RefreshBtnClick(Sender: TObject);
begin redrawimage; end;

{************* FormResize ***************}
procedure TForm1.FormResize(Sender: TObject);
{Change image size when form is resized}
var
  i,j:integer;
  oldw,oldh:integer;
  scalex,scaley:real;
begin
  with image1 do
  begin
    left:=round(self.width*pctleft);
    top:=round(self.height*pcttop);
    oldw:=width;
    oldh:=height;
    width:=round(self.width*pctwidth);
    height:=round(self.height*pctheight);
    picture.bitmap.width:=width;
    picture.bitmap.height:=height;
    cx:=width div 2;
    cy:=height div 2;
    scalex:=width/oldw;
    scaley:=height/oldh;
  end;
  for i:=0 to nbrsegs-1 do
  with segments[i] do
  if nbrsegpoints>1 then
  for j:= 0 to nbrsegpoints-1 do
  with points[j] do
  begin
    px:=round(scalex*px);
    py:=round(scaley*py);
    makepolar(points[j]);
  end;
  redrawimage;
end;


end.
