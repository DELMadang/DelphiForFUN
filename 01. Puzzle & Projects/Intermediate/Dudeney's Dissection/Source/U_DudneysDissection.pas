unit U_DudneysDissection;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{In 1902,  puzzleist H.E. Dudeney discovered this interesting method of cutting
 a square into four pieces that can be reassembled to form an equilateral
 triangle (with the same area of course).

 Here are three ways to play with this puzzle:
     Hardest - print the outlines and try it yourself.
     Easier -  let the program show you the dissection, then print, cut and
               reassemble into the triangle.

     Real Wimp!  - let the program show you both the dissection and the reassembly.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Printers, ComCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Memo1: TMemo;
    PrintBtn: TButton;
    ShowGrp: TRadioGroup;
    StatusBar1: TStatusBar;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure ShowGrpClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    currentwidth,currentheight:integer;
    currentCanvas:TCanvas;
  end;

var Form1: TForm1;

implementation

Uses U_DudeneyConstruction;

{$R *.DFM}
type
 Tline=record
    p1,p2:TPoint; {starting and ending points of a line segment}
  end;

function PointPerpendicularLine(L:TLine; P:TPoint):TLine;
{Define the line segemnt from a given point that is perpendicular to a given
 line segment}
var
  m1,m2,b1,b2:extended;
  rx:extended;
begin
  with L do
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     m1:=(p2.y-p1.y)/(p2.x-p1.x)  else m1:=1e20;
     b1:=p1.y-m1*p1.x;
  end;
  with result do
  begin
    p1:=p;
    if m1<>0 then
     begin
        m2:=-1/m1;
        b2:=p.y-m2*p.x;
        rx:=(b2-b1)/(m1-m2);
        p2.x:=round(rx);
        p2.y:=round(m2*rx+b2);
    end
    else
    begin
      p2.x:=p1.x;
      p2.y:=L.p2.y;
    end;
  end;
end;

function dist(p1,p2:TPoint):single;
begin
  result:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
end;

procedure TForm1.FormActivate(Sender: TObject);
{Draw initial square and triangle images}
begin
  Showgrp.itemindex:=0;
  with image1 do
  begin
    currentwidth:=width;
    currentheight:=height;
    currentcanvas:=canvas;
  end;
  Showgrpclick(sender); {show initial outlines}
end;

procedure TForm1.ShowGrpClick(Sender: TObject);
{User clicked print button or changed display option, redraw everything
 based on global variables CurrentWidth, CurrentHeight, and CurrentCanvas}
var
  S,Top1,L:integer;
  T, Top2:integer;
  W:integer;
  H2:integer;
  TLine1,Tline2,Tline3:TLine;
  d1a,d4a,d2b:integer;
  procedure InitialOutlines;
  begin
    with currentcanvas do
    begin
      fillrect(rect(0,0,currentwidth,currentheight));
      W:=currentwidth;
      s:=33*w div 100;  {s=side of square}
      L:=33*w div 100;  {left border}
      Top1:=w div 10;   {top of square}

      moveto(L, Top1);  {Draw the square}
      lineto( L, Top1+S);
      lineto(L+s,Top1+S);
      lineto(L+s,Top1);
      lineto(L,Top1);

      {draw  a triangle with the same area}
      T:=152*s div 100;  {triangle side = (2 / 4th root of 3) x s}
      H2:=866*T div 1000; {height of triangle}
      Top2:=currentHeight div 2; {triangle top}
      moveto(w div 2,Top2 );
      lineto((w-T) div 2, Top2+h2);
      lineto((w+T) div 2, Top2+h2);
      lineto(w div 2, Top2);

      {the heart of the matter - divide the triangle into appropriate polygons}
      {from midpoint of one side to a point 3/4 across on adjacent side (bottom)}
      Tline1.p1.x:=w div 2+ t div 4; Tline1.p1.y:=Top2 + h2 div 2;
      Tline1.p2.x:=w div 2 - t div 4; Tline1.p2.y:=top2+h2;
      {drop perpendicular from midpoint of 3rd side to the line}
      Tline2:=pointperpendicularline(TLine1,point(w div 2- t div 4,Top2+H2 div 2));
      {and perpendicular from 1/4 across bottom to the line}
      Tline3:=pointperpendicularline(TLine1,point(w div 2+ t div 4,Top2+H2));

      {calculate enough distances to let us determine corresponding points
       when we overlay these polygons on the square }
      (* I labeled the polygons A,B,C,D and square sides 1,2,3,4 and calculated
         distances, e.g. d3c is the distance of the side of polygon c that lies
         on side 3 of the square -
         it turned out that only a few of them were needed}
      d3c:=trunc(dist(Tline2.p1,Tline2.p2));
      d3d:=d3c;
      d4d:=trunc(dist(Tline1.p2,Tline2.p1));
      d2c:=trunc(dist(Tline1.p1,Tline1.p2)-d4d);
      *)
      d1a:=trunc(dist(Tline3.p2, Tline3.p1));
      {d1b:=d1a;}

      d4a:=trunc(dist(Tline1.p2,Tline3.p2));
      d2b:=trunc(dist(Tline1.p1,Tline1.p2))-d4a;
    end;
  end;

  procedure dissectSquare;
  {draw the polygons on the square}
  begin
    with currentcanvas do
    begin
      moveto(L+d1a,top1); lineto(l,top1+d4a);
      moveto(l+s div 4, top1+ d4a div 2); lineto(l+s div 2, top1+s);
      moveto(l+s div 4, top1+ d4a div 2); lineto(l+s, top1+ d2b);
    end;
  end;

  procedure dissectTriangle;
  {draw the polygons on the triangle}
  begin
    with currentcanvas do
    begin {equilateral solution}
      with Tline1.p1 do moveto(x,y);  with Tline1.p2 do lineto(x,y);
      with Tline2.p1 do moveto(x,y);  with Tline2.p2 do lineto(x,y);
      with Tline3.p1 do moveto(x,y);  with Tline3.p2 do lineto(x,y);
    end;
  end;

begin
  case showgrp.itemindex of
  0: {display outlines only}
    begin
      InitialOutlines;
    end;
  1: {show dissected square}
    begin
      InitialOutlines;
      dissectSquare;
    end;
  2: {show dissected square and reassembled triangle}
    begin
      InitialOutlines;
      DissectSquare;
      DissectTriangle;
    end;
  end;
end;

procedure TForm1.PrintBtnClick(Sender: TObject);
{Print the current image to the default printer}
begin
  with printer do
  begin
    begindoc;
    canvas.pen.width:=2;
    Currentcanvas:=canvas;
    currentheight:=pageheight;
    currentwidth:=pagewidth;
    ShowGrpclick(sender);
    currentheight:=image1.height;
    currentwidth:=image1.width;
    Currentcanvas:=image1.canvas;
    enddoc;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  {image1.Picture.Bitmap.savetofile('Dud2.bmp');}
  Form2.showmodal;
end;

end.
