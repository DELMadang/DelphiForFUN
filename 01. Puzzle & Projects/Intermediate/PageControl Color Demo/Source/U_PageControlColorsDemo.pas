unit U_PageControlColorsDemo;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
The default active tab drawing on  a TPageConrol has always
been less than optimal because there is very little to distinghuish
it from the inactive tabs.

Here is a simple demo program showing how to add a "Color"
property to Tabsheets within a PageControl  and how to color the
tab to match the sheet.  Also other ways to tailor tab drawing to
change font properties, add graphics, etc.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls,
  VCLFixes {corrects Delphi 7 bug under 64 bit Windows versions}  ;

type

  {********** P. Below's TTabsheet mod to add Color property ****}
  TTabSheet = class(ComCtrls.TTabSheet)
  private
    FColor: TColor;
    procedure SetColor(Value: TColor);
    procedure WMEraseBkGnd(var Msg: TWMEraseBkGnd);
      message WM_ERASEBKGND;
  public
    constructor Create(aOwner: TComponent); override;
    property Color: TColor read FColor write SetColor;
  end;
 {***************************************************************}


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo3: TMemo;
    TabSheet2: TTabSheet;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    TestSmileyBtn: TButton;
    Memo1: TMemo;
    TabSheet4: TTabSheet;
    Memo4: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure PageControl1DrawTab(Control: TCustomTabControl;
      TabIndex: Integer; const Rect: TRect; Active: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TestSmileyBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{**********************************************************************}
{**** Impoalment modified TTabsheet to include "Color" property ****}
{**********************************************************************}

{********* Create *******}
constructor TTabSheet.Create(aOwner: TComponent);
begin
  inherited;
  FColor := clBtnFace;
end;

{**********Setcolor **********}
procedure TTabSheet.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    Invalidate;
  end;
end;

{********** WMEraseBkGnd ***********}
procedure TTabSheet.WMEraseBkGnd(var Msg: TWMEraseBkGnd);
begin
  if FColor = clBtnFace then inherited
  else
  begin
    Brush.Color := FColor;
    Windows.FillRect(Msg.dc, ClientRect, Brush.Handle);
    Msg.Result := 1;
  end;
end;
{********* End TTabsheet mods *********}

{**************** DrawSmiley ************}
procedure Drawsmiley(canvas:TCanvas; x,y,size:integer);
{Draw a Smiley on "Canvas" at (x,y) of size "Size"}
var
  bcolor,pcolor:TColor;
  pwidth:integer;
begin
  with canvas do
  begin
    bcolor:=brush.color; {it's polite to save brush & pen info}
    pcolor:=pen.Color;
    pwidth:=pen.width;

    fillrect(rect(x, y, x+size, Y+size)); {Fill with current canvas brush}

    pen.Color:=clblack;  {Our drawing parameters}
    pen.Width:=2;
    brush.color:=clyellow;

    {Draw the head}
    ellipse(x+trunc(0.10*size),Y+trunc(0.10*size),x+trunc(0.9*size),Y+trunc(0.9*size));

    {Draw the eyes}
    brush.color:=clblack;
    ellipse(x+trunc(0.30*size),y+trunc(0.30*size),x+trunc(0.40*size),y+trunc(0.45*size));
    ellipse(x+trunc(0.60*size),y+trunc(0.30*size),x+trunc(0.70*size),y+trunc(0.45*size));

    {Draw the smile}
    arc(x+trunc(0.25*size),y+trunc(0.40*size),
        x+trunc(0.75*size),y+trunc(0.75*size),
        x+trunc(0.20*size),y+trunc(0.65*size),
        x+trunc(0.80*size),y+trunc(0.65*size));
    {restore stuff}
    brush.color:=bcolor;
    pen.color:=pcolor;
    pen.width:=pwidth;
  end;

end;

{*************** FormCreate *************8}
procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.ActivePage:=Tabsheet1; {Make sure Intro show first}
  PageControl1.OwnerDraw := True; {Take our OnDrawTab exit}
  Tabsheet1.Color:=clsilver;
  Tabsheet2.Color:=clSkyBlue;
  Tabsheet3.Color:=clMoneyGreen;
  Tabsheet4.Color:= RGB(249,187,83);
end;


{************ PageControl1Drawtab *************}
procedure TForm1.PageControl1DrawTab(Control: TCustomTabControl;
  TabIndex: Integer; const Rect: TRect; Active: Boolean);
 {Exit will allow customizing the look of the active tab (or inactive
  if you prefer)}
var
  AText: string;
  APoint: TPoint;
  W,H:integer;
  index:integer;
begin
  {Since tabindex is also TPageControl property, rename the passed parameter!}
  index:=tabindex;
  with (Control as TPageControl), Canvas do
  begin
    {To change the background and font colors of the active tab}
    if active then
    begin
      //Brush.Color := rgb(255,255,221); {highlight color}
      Brush.Color:=TTabsheet(Pages[index]).color;
      font.color:=clgreen;
      font.Style:=[fsBold];
    end;
    FillRect(Rect);
    AText := Pages[Index].Caption;
    h:=rect.bottom-rect.top;
    w:=rect.right-rect.left;
    APoint.x := W div 2 - TextWidth(AText) div 2;
    APoint.y := H div 2 - TextHeight(AText) div 2;
    TextRect(Rect, Rect.Left + APoint.x, Rect.Top + APoint.y, AText);
    if active
    then drawsmiley(canvas, rect.Left, rect.Top, 9*h div 10);
  end;
end;

{************** TestSmileyBtnClick *********8}
procedure TForm1.TestSmileyBtnClick(Sender: TObject);


  procedure setup(image:TImage; bgcolor:TColor);
  {some setup for each image to revceive the smiley}
  begin
    with image do
    begin
      {make the image square}
      if height>width then height:=width else width:=height;
      picture.bitmap.height:=height; {Set bitmap to image size}
      picture.bitmap.width:=width;
      image.canvas.brush.color:=bgcolor; {Set smiley background color}
    end;
  end;
begin  {TestSmileyBtnClick}
  setup(Image1,clwhite);
  drawsmiley(Image1.Picture.Bitmap.Canvas, 0,0,image1.Height);
  setup(Image2,clyellow);
  drawsmiley(image2.Picture.Bitmap.Canvas, 0,0,image2.Height);
  setup(Image3,tabsheet3.color);
  drawsmiley(image3.Picture.Bitmap.Canvas, 0,0,image3.Height);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

