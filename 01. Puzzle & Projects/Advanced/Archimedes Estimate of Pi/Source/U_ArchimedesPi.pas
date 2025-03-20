unit U_ArchimedesPi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls, ComCtrls, UGeometry, DFFUtils, shellAPI;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Image1: TImage;
    TabSheet3: TTabSheet;
    PaintBox1: TPaintBox;
    StringGrid2: TStringGrid;
    Memo2: TMemo;
    Memo1: TMemo;
    NextPolygonsBtn: TButton;
    TabSheet1: TTabSheet;
    StringGrid1: TStringGrid;
    Memo3: TMemo;
    PaintBox2: TPaintBox;
    ResetBtn: TButton;
    Memo4: TMemo;
    Label1: TLabel;
    StaticText2: TStaticText;
    Label2: TLabel;
    Label3: TLabel;
    TabSheet4: TTabSheet;
    Memo5: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure NextPolygonsBtnClick(Sender: TObject);
    procedure PaintCircumscribedDetail(Sender: TObject);
    procedure PaintInscribedDetail(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    nbrsides:integer;
    cr,cx,cy:integer;
    bgcolor:TColor;
    procedure drawcircle(Image:TImage);
    Procedure drawinscribed(sides:integer; initangle:double);
    procedure drawcircumscribed(sides:integer; initangle:double);
    function getindex:integer;   {which polgon are we drawing? (1..5)}
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses math;

var
  esides:array[1..5] of double= (2*153/265, 2*153/571, 2*153/1162.125, 2*153/2334.25, 2*153/4673.5); {external side ratios}
  isides:array[1..5] of double= (1/2, 780/3013.75, 240/1838.818,66/1009.1667,66/2017.250);   {internal side ratios}

{******** IntPower************}
function intpower(a, b: int64): int64;
{Integer power funtion}
var
  i: integer;
begin
  Result := 1;
  for i := 1 to b do
    Result := Result * a;
end;

{************ FormActivate ***********}
Procedure TForm1.FormActivate(Sender: TObject);
begin

  pagecontrol1.ActivePage:=tabsheet2;
  Reformatmemo(memo3);
  Reformatmemo(memo4);
  Reformatmemo(Memo5);

   bgcolor:=rgb(255,255,221);

  nbrsides:=3; {NextpolygonsBtn will double it to 6}
  NextPolygonsBtnClick(sender);

  with stringgrid2 do
  begin
    cells[0,0]:='# Sides';
    cells[1,0]:='Radius';
    cells[2,0]:='Side Len';
    cells[3,0]:='Perimeter';
    cells[4,0]:='Pi <';
    cells[5,0]:='Next side';
  end;

  with stringgrid1 do
  begin
    cells[0,0]:='Sides';
    cells[1,0]:='Diameter';
    cells[2,0]:='Side Len';
    cells[3,0]:='Perimeter';
    cells[4,0]:='Pi >';
    cells[5,0]:='Next side';
  end;
end;

{************** NextPolygonsBtn ************}
procedure TForm1.NextPolygonsBtnClick(Sender: TObject);
var
  msg:string;
begin
  nbrsides:=2*nbrsides;
  if nbrsides>96 then resetbtnclick(sender);
  if nbrsides<=96 then
  begin
    drawcircle(Image1);
    drawcircumscribed(nbrsides, 180.0/nbrsides);
    PaintCircumscribedDetail(sender);
    drawinscribed(nbrsides, 0/nbrsides);
    PaintInscribedDetail(sender);
    label1.Caption:='Polygon sides = '+inttostr(nbrsides);
    if nbrsides<96 then  msg:= 'Calculating for ' + inttostr(2*nbrsides)
    else msg:='Last calculation complete';
    label2.caption:=msg;
    label3.Caption:=msg;
  end
end;

{************ ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
  procedure cleargrid(grid:TStringgrid);
  var
    c,r:integer;
  begin
    with grid do
    for c:=0 to colcount-1 do
    for r:=2 to rowcount-1 do
    cells[c,r]:='';
  end;

begin
  nbrsides:=3;
  nextPolygonsBtnClick(sender);
  cleargrid(stringgrid2);
  cleargrid(stringgrid1);
end;


{********** DrawCircle ***********}
procedure TForm1.drawcircle(Image:TIMage);
begin
  with image, canvas do
  begin
    brush.color:=bgcolor;
    rectangle(clientrect);
    cx:=width div 2;
    cy:=height div 2;
    cr:=min(width,height) div 2 -40;
    pen.Color:=clblack;
    pen.width:=2;
    brush.color:=panel1.color;
    ellipse(cx - cr, cy - cr, cx + cr, cy + cr);
    pen.width:=1;
  end;
end;

{************* DrawInscribed ***********}
procedure TForm1.drawinscribed(sides:integer; initAngle:double);
var
  i:integer;
  r,angle, increment:double;
  x,y:double;
begin
  with image1, canvas do
  begin
    pen.width:=2;
    r:=cr;
    angle:=initangle*pi/180;
    increment:=2*pi/sides;
    pen.Color:=clRed;
    for i:=0 to sides do
    begin
      x:=r*cos(angle);
      y:=r*sin(angle);
      if i=0 then moveto(cx+trunc(x), cy+trunc(y))
      else lineto(cx+trunc(x), cy+trunc(y));
      angle:=angle+increment;
    end;
    pen.width:=1;
    moveto(cx+cr, cy);
    lineto(cx-cr,cy);
    lineto(cx+trunc(r*cos(-increment)),cy+trunc(r*sin(-increment)));
  end;
end;


{************  DrawCircumscribed *************}
procedure tForm1.drawcircumscribed(sides:integer; initangle:double);
var
  i:integer;
  r,angle, increment:double;
  x,y:double;
begin
  with image1, canvas do
  begin
    pen.width:=2;
    pen.Color:=clGreen;
    cx:=width div 2;
    cy:=height div 2;
    angle:=initangle*pi/180;
    increment:=2*pi/sides;
    r:=cr/cos(increment/2.0);

    for i:=0 to sides do
    begin
      x:=r*cos(angle);
      y:=r*sin(angle);
      if i=0 then moveto(cx+trunc(x), cy+trunc(y))
      else lineto(cx+trunc(x), cy+trunc(y));
      angle:=angle+increment;
    end;
    {draw solution "hint" lines}
    pen.width:=1;
    moveto(cx+cr,cy-2);
    lineto(cx,cy-2);
    lineto(cx+trunc(r*cos(-increment/2)), cy+trunc(r*sin(-increment/2)));
    brush.color:=clBlack;
    ellipse(cx-1,cy-3,cx+3,cy+3);

  end;
end;

{*********** GetIndex *********8}
function TForm1.getindex:integer;
{Return index 1,,5 based on current NbrSides value}
var
  i:integer;
begin
  result:=0;
  i:=nbrsides div 6;
  while i>0 do begin inc(result); i:= i div 2; end;
end;

{*************** PaintCircumscribedDetail ***********}
procedure TForm1.PaintCircumscribedDetail(Sender: TObject);
var
  cx,cy, Dx, Dy:integer;
  r:integer;
  N:integer;
  alpha, HalfAlpha, L, H:double;
  radius:double;
  i:integer;
  letter:char;

      procedure fillgridrow(i, nbrsides:integer);
      begin
        with stringgrid2 do
        begin
         cells[0,i]:=inttostr(Nbrsides);   {sides}
         cells[1,i]:='50.0';     {OA, radius}
         cells[2,i]:=format('%.2f',[radius*esides[i]]);                      {AC, 1/2 side length}
         cells[3,i]:=format('%.2f',[radius*nbrsides*esides[i]]);          {Perimeter}
         cells[4,i]:=format('%.5f',[radius*nbrsides*esides[i]/(2*radius)]); {Pi estimate}
         if nbrsides<96 then cells[5,i]:=format('%.2f',[radius*esides[i+1]])
         else cells[5,i]:='---';
       end;
     end;


begin
   radius:=50;
   i:=getindex;
   fillgridrow(i, nbrsides);

   with paintbox1,Canvas do
   begin

     brush.color:= bgcolor;
     rectangle(clientrect);
     cx:=20;
     cy:=height div 2;
     r:=8*width div 10;

     N:=6;
     alpha:=2*Pi/N;
     halfalpha:=alpha/2;
     H:=r/cos(halfalpha);
     L:=sqrt(sqr(H)-sqr(R));
     brush.color:=color;
     pen.Width:=2;
     arc(cx-r, cy-r,cx+r, cy+r,
         cx+trunc(L*cos(pi/4)),cy+trunc(L*sin(pi/4)),
         cx+trunc(L*cos(-pi/4)),cy+trunc(L*sin(-pi/4)));
     floodfill(cx,cy,bgcolor,fsSurface);

     brush.color:=clBlack;
     Dx:=trunc(H*cos(halfalpha));
     Dy:=trunc(H*sin(halfalpha));
     ellipse(cx-3,cy-3,cx+3,cy+3);

     moveto(cx,cy);
     lineto(cx+Dx,cy+Dy);
     brush.color:=color;
     textout(cx-16,cy,'O');

     Dx:=trunc(H*cos(-halfalpha));
     Dy:=trunc(H*sin(-halfalpha));
     brush.color:=clBlack;
     ellipse(cx +dx-3,cy+dy-3,cx+dx+3,cy+dy+3);
     moveto(cx,cy);
     lineto(cx+trunc(H*cos(-halfalpha)),cy+trunc(H*sin(-halfalpha)));
     moveto(cx,cy);
     lineto(cx+r,cy);

     ellipse(cx+r-3,cy-3,cx+r+3,cy+3);
     brush.color:=bgcolor;
     textout(cx+r+8, cy-8,'A');

     {circumscribed hexagon}
     pen.width:=2;
     pen.Color:=clGreen;
     moveto(cx+trunc(H*cos(alpha/2+alpha)), cy+trunc(H*sin(alpha/2+alpha)));
     lineto(cx+trunc(H*cos(alpha/2)), cy+trunc(H*sin(alpha/2)));
     lineto(cx+trunc(H*cos(-alpha/2)), cy+trunc(H*sin(-alpha/2)));
     lineto(cx+trunc(H*cos(-alpha/2-alpha)), cy+trunc(H*sin(-alpha/2-alpha)));
     brush.color:=bgcolor;
     pen.color:=clblack;
     textout(cx+16+trunc(H*cos(-alpha/2)), cy-8+trunc(H*sin(-alpha/2)),'C');


     {Draw intersection for next polygon with 2N sides}
     if nbrsides<=96 then
     begin
       n:=6;
       i:=0;
       while (n< 2*nbrsides) and (n<=96) do
       begin
         inc(i);
         n :=2*N;
         alpha:=2*Pi/N;
         if N>96 then  alpha:=-4*Pi/N;  {for line H}
         H:= r/Cos(alpha/2); {for case H}
         dx:=trunc(H*cos(alpha/2));
         dy:=trunc(H*sin(alpha/2));
         Letter:= char(ord('C')+i);  {'D', 'E', 'F', 'G' }
         pen.Color:=clmaroon;
         brush.color:=clBlack;
         moveto(cx+trunc(H*cos(-alpha/4+alpha)), cy+trunc(H*sin(-alpha/4+alpha)));
         lineto(cx+dx, cy+dy);
         lineto(cx+dx, cy-dy );
         lineto(cx+trunc(H*cos(alpha/4-alpha)), cy+trunc(H*sin(alpha/4-alpha)));
         moveto(cx,cy);
         lineto(cx+dx, cy-dy);
         brush.color:=bgcolor;
         if n>96 then dec(i);  {Make H letter offset same as G}
         textout(cx+dx+4+16*((i+1) mod 2 ),cy-dy-8,Letter);
         pen.Color:=clblack;
       end;
     end;
   end;
end;


{************ PaintInscribedDetail **********}
procedure TForm1.PaintInscribedDetail(Sender: TObject);
var
  i:integer;
  cx,cy, Dx, Dy:integer;
  r:integer;
  N:integer;
  alpha, HalfAlpha:double;
  A,B,C,D,E:TPoint;
  diameter:double;
  letter:char;

    Function Len(A,B:TPoint):double;
    begin
      result:=sqrt(sqr(a.x-b.x)+sqr(a.y-b.y));
    end;

     procedure fillgridrow(i, nbrsides:integer);
      begin
        with stringgrid1 do
        begin
         cells[0,i]:=inttostr(Nbrsides);   {sides}
         cells[1,i]:='100.0';     {AB, diameter}
         cells[2,i]:=format('%.2f',[diameter*isides[i]]);                      {AC, 1/2 side length}
         cells[3,i]:=format('%.2f',[diameter*nbrsides*isides[i]]);          {Perimeter}
         cells[4,i]:=format('%.5f',[diameter*nbrsides*isides[i]/(diameter)]);          {Pi estimate}
         if nbrsides<96 then cells[5,i]:=format('%.2f',[diameter*isides[i+1]])
         else cells[5,i]:='---';
       end;
     end;


begin
   diameter:=100;
   with stringgrid1 do
   begin
     i:=getindex;
     fillgridrow(i, nbrsides);
   end;

   with paintbox2,Canvas do
   begin
     brush.color:=bgColor;
     rectangle(clientrect);
     cx:=width div 2;
     cy:=height div 2;
     r:=40*width div 100;

     N:=6;  {always draw the initial hexagon}
     alpha:=2*Pi/N;
     halfalpha:=alpha/2;
     brush.color:=color;
     pen.width:=2;
     ellipse(cx-r, cy-r,cx+r, cy+r);

     brush.color:=clBlack;

     {Points A an d B}
     moveto(cx-r,cy);
     lineto(cx+r,cy);
     brush.color:=clBlack;
     A:=Point(cx-r,cy);
     B:=Point(cx+r,cy);
     ellipse(cx-r-3,cy-3,cx-r+3,cy+3);
     ellipse(cx+r-3,cy-3,cx+r+3,cy+3);
     brush.color:=bgcolor;
     textout(cx-r-16,cy-16,'A');
     textout(cx+r+4, cy-16,'B');

     {Point C}
     Dx:=trunc(r*cos(-alpha));
     Dy:=trunc(r*sin(-alpha));
     brush.color:=clBlack;
     ellipse(cx +dx-3,cy+dy-3,cx+dx+3,cy+dy+3);
     brush.color:=bgcolor;
     textout(cx+dx+3,cy+dy-16,'C');
     moveto(cx-r,cy);
     C:=point(cx+Dx, cy+Dy);
     lineto(C.x,C.y);


     {Point D}
     Dx:=trunc(r*cos(-halfalpha));
     Dy:=trunc(r*sin(-halfalpha));
     brush.color:=clBlack;
     D:=point(cx+dx,cy+dy);
     with D do
     begin
       ellipse(D.x-3,D.y-3,D.x+3,D.y+3);
       brush.color:=bgcolor;
       textout(D.x+3, D.y-16,'D');
       moveto(cx-r,cy);
       lineto(x,y);
       lineto(cx+r, cy);
     end;

     {inscribed hexagon}
     pen.color:=clRed;
     moveto(cx+r,cy);
     for i:=1 to N do
     begin
       lineto(cx+trunc(r*cos(i*alpha)),cy+trunc(r*sin(i*alpha)));
     end;
     pen.Color:=clblack;

     {Calculate and label "d", intersection of lines AD and CB}
     ExtendedLinesIntersect(Line(c,b), Line(a,d),false,E);
     brush.color:=clBlack;
     ellipse(e.x-3,e.y-3,e.x+3, e.y+3);
     brush.color:=color;
     textout(e.x-16,e.y-16,'d');


     {Draw intersection for next polygon with 2N sides}
     if nbrsides<=96 then
     begin
       n:=12;
       i:=1;
       while (n< 2*nbrsides) and (n<96) {no need to draw the "H" line here} do
       begin
         inc(i);
         alpha:=2*Pi/N;
         halfalpha:=alpha/2;
         Dx:=trunc(r*cos(-halfalpha));
         Dy:=trunc(r*sin(-halfalpha));
         brush.color:=clBlack;
         D:=point(cx+dx,cy+dy);
         with D do
         begin
           ellipse(D.x-3,D.y-3,D.x+3,D.y+3);
           brush.color:=bgcolor;
           Letter:= char(ord('C')+i);  {'E', 'F', 'G', 'H' }
           textout(D.x+3+16*((i+1) mod 2), D.y-16,Letter);
           moveto(cx-r,cy);
           lineto(x,y);
           lineto(cx+r, cy);
           n :=2*N;
         end;
       end;
     end;
   end;
end;


{External links}

procedure TForm1.StaticText2Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.archive.org/details/worksofarchimede029517mbp',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.



