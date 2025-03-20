unit U_Doodler1;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A drawing program - version 1}


interface
uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     ExtCtrls, StdCtrls, ComCtrls;

type
  TPoints=record {info saved with each segment point}
    px,py:integer;
    color:TColor; {pen color}
    width:integer; {pen width}
    break:boolean; {true ==> this is the end of a segment}
  end;

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    ResetBtn: TButton;
    ColorDialog1: TColorDialog;
    WidthUD: TUpDown;
    Edit1: TEdit;
    PenColor: TStaticText;
    Label1: TLabel;
    NumDivsGrp: TRadioGroup;
    procedure FormActivate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure PenColorClick(Sender: TObject);
    procedure NumDivsGrpClick(Sender: TObject);
  public
    drawing:boolean;  {mouse button is down}
    points:array of TPoints; {an array of points}
    numpoints:integer; {how many points to draw}
    cx,cy:integer;
    numdivs:integer;
    {penwidth:integer;}
    procedure makecaption(leftSide, Rightside:string);
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

{******************* FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  windowstate:=wsmaximized;
  with paintbox1 do
  begin
    cx:=width div 2;
    cy:=height div 2;
  end;
  NumDivsGrpClick(sender);
  numpoints:=-1;
  doublebuffered:=true;
  setlength(points,1000);
  makecaption('Doodler #1',#169+' 2001  G. Darby, www.delphiforfun.org' );
end;

{*************** PaintBox1Paint ************}
procedure TForm1.PaintBox1Paint(Sender: TObject);
{called whenever the drawing needs to be drawn}
var
  i:integer;
  x2,y2:integer;
begin
  with paintbox1, canvas do
  begin
    pen.color:=clblack;
    pen.width:=1;
    ellipse(cx-1,cy-1,cx+1,cy+1);
    if numpoints<=0 then exit;
    pen.width:=points[0].width;
    pen.color:=points[0].color;
    for i:=1 to numpoints do
    with points[i] do
    begin
      if width<>points[i-1].width
      then pen.width:=points[i].width;
      if color<>points[i-1].color
      then pen.color:=points[i].color;
       if not points[i-1].break then
       begin
        moveto(cx+points[i-1].px,cy+points[i-1].py); {first line}
        lineto(cx+points[i].px,cy+points[i].py);
        If numdivs mod 4 =0 then {4 or 8 divisions}
        begin {add 3 more line segments}
          moveto(cx-points[i-1].px,cy+points[i-1].py);
          lineto(cx-points[i].px,cy+points[i].py);
          moveto(cx+points[i-1].px,cy-points[i-1].py);
          lineto(cx+points[i].px,cy-points[i].py);
          moveto(cx-points[i-1].px,cy-points[i-1].py);
          lineto(cx-points[i].px,cy-points[i].py);
        end;
        if numdivs=8 then {add four more lines rotated 45,135,225,315 degrees}
        begin
          x2:=round(0.707*(points[i-1].px-points[i-1].py));
          y2:=round(0.707*(points[i-1].px+points[i-1].py));
          moveto(cx-x2,cy+y2);
          x2:=round(0.707*(points[i].px-points[i].py));
          y2:=round(0.707*(points[i].px+points[i].py));
          lineto(cx-x2,cy+y2);

          x2:=round(0.707*(points[i-1].px-points[i-1].py));
          y2:=round(0.707*(-points[i-1].px-points[i-1].py));
          moveto(cx-x2,cy+y2);
          x2:=round(0.707*(points[i].px-points[i].py));
          y2:=round(0.707*(-points[i].px-points[i].py));
          lineto(cx-x2,cy+y2);

          x2:=round(0.707*(-points[i-1].px+points[i-1].py));
          y2:=round(0.707*(-points[i-1].px-points[i-1].py));
          moveto(cx-x2,cy+y2);
          x2:=round(0.707*(-points[i].px+points[i].py));
          y2:=round(0.707*(-points[i].px-points[i].py));
          lineto(cx-x2,cy+y2);

          x2:=round(0.707*(-points[i-1].px+points[i-1].py));
          y2:=round(0.707*(points[i-1].px+points[i-1].py));
          moveto(cx-x2,cy+y2);
          x2:=round(0.707*(-points[i].px+points[i].py));
          y2:=round(0.707*(points[i].px+points[i].py));
          lineto(cx-x2,cy+y2);
        end;
      end;
    end;
  end;
end;

{******************* PaintBox1MouseDown **************}
procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin drawing:=true; end;  {tells mouse move to add a point}

{******************* PaintBox1MouseMove **************}
procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if drawing then
  begin
    inc(numpoints); {make a new point}
    if numpoints>length(points) then setlength(points, length(points)+1000);
    with points[numpoints] do
    begin
      px:=x-cx;
      py:=y-cy;
      color:=pencolor.color;
      width:=widthUD.position;
      break:=false;
    end;
    paintbox1.refresh;
  end;
end;

{*************** PaintBox1MouseUp *************}
procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  drawing:=false;
  points[numpoints].break:=true; {mark end of segment}
end;

{***************** ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{erase drawing info}
begin
  setlength(points,1000);
  numpoints:=-1;
  paintbox1.refresh;
end;

{******************* PenColorClick ************}
procedure TForm1.PenColorClick(Sender: TObject);
{get a new pen color}
begin
  If colordialog1.execute then
  begin pencolor.color:=ColorDialog1.Color; end;
end;

{****************** NumDivsGrpClick ************}
procedure TForm1.NumDivsGrpClick(Sender: TObject);
{set nbr of replications in drawing}
begin
  case NumDivsGrp.itemindex of
    0: numdivs:=1;
    1: numdivs:=4;
    2: numdivs:=8;
  end;
  paintbox1.refresh;
end;

{******************** MakeCaption ***************}
procedure TForm1.makecaption(leftSide, Rightside:string);
{draws a left/righ justified form caption}
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
    with metrics.LFCaptionFont, b.canvas.font do
    begin
      height:=LFHeight;
      if lfweight=700 then style:=[fsbold];
      if lfitalic<>0 then style:=style+[fsitalic];
    end;
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

end.
