unit U_BlendDemo2;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, JPEG, Spin, ShellAPI;

type
  PPixelArray = ^TPixelArray;
  TPixelArray = array[0..16383] of array[0..2] of byte;

  TForm1 = class(TForm)
    ColorDialog1: TColorDialog;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    DemoSheet: TTabSheet;
    Image1: TImage;
    BlendPctLbl: TLabel;
    Label1: TLabel;
    ShadeLoc: TRadioGroup;
    ColorBtn: TButton;
    LoadBtn: TButton;
    BlendColor: TPanel;
    BlendedColor: TPanel;
    BlendPct: TSpinEdit;
    GroupBox1: TGroupBox;
    BlendTechnique: TRadioGroup;
    PerformBtn: TButton;
    Displaybox: TCheckBox;
    DragBtn: TRadioGroup;
    Label2: TLabel;
    TimeLbl: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    FileNameLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ShadeLocClick(Sender: TObject);
    procedure ColorBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlendPctChange(Sender: TObject);
    procedure PerformBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    BMP:Tbitmap;
    W,H:Integer;
    Qx,Qy:integer;
    T:real;
    R2,G2,B2:integer;
    TR2,TG2,TB2:real;
    offsetx,offsety:integer;
    dragging:boolean;
    MoveBMP:TBitmap;
    nbrpanels:integer;
    seconds:real;
    freq, startcount, endcount:int64;
    procedure LoadImage(Fname:string;  B:TBitmap);
    procedure ApplyBlendAmount;
    procedure DrawBlend;
    procedure Refresh(xLeft,yTop:integer);
    procedure restrictloc(var x,y:integer);
    procedure UpdateStats;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{*********** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
{Do one time initialization things}
var
  dir:string;
begin
  PageControl1.ActivePage:=Introsheet;
  dir:=extractfilepath(application.exename);
  Opendialog1.initialdir:=dir;
  BMP:=TBitmap.Create;  {Unmodified Bitmap of image}
  //BMP.LoadFromFile('A1.bmp');  {load a picture and make the image that size}
  LoadImage(dir+'A1.BMP', BMP);
  BMP.PixelFormat:=pf24bit;   {make sure the pixels use 3 bytes, one for each of R,G,B}
  image1.height:=bmp.height;  {this is required for scanline blending}
  image1.width:=bmp.width;
  image1.canvas.draw(0,0,bmp);
  W:=BMP.Width  div 2; {Set width and height of shaded area}
  H:=BMP.Height div 2;
  ApplyBlendAmount;
  MoveBMP:=TBitmap.create; {Bit map for use while dragging shaded area}
  ColorDialog1.color:=clgray;   {Make initial color gray}
  Blendcolor.Color:=Colordialog1.Color;
  applyblendAmount;
end;

{*********** ShadeLocClick *********}
procedure TForm1.ShadeLocClick(Sender: TObject);
begin
  {set quadrant qx and qy offsets for selected quarter}
  case shadeloc.itemindex of
    0: begin qx:=0; qy:=0; end;
    1: begin qx:=0; qy:=1; end;
    2: begin qx:=1; qy:=0; end;
    3: begin qx:=1; qy:=1; end;
  end;
  drawblend;
end;

{************** DrawBlend ***********}
procedure TForm1.DrawBlend;
{Set up the new blend color and refreesh the image with it}
var
  C:TColor;
begin
  c := BlendColor.color; {set up blend red, blue, green pixel values for current blend color}
  r2:=(c and $000000FF);          {Shift color value right by 0, 8, and 16 bit}
  g2:=((c and $0000FF00) shr 8);  {positions to separate R,G,B colors}
  b2:=((c and $00FF0000) shr 16);
  Tr2 := T*r2; {Apply the Blend Percent to each component of the blend color}
  Tg2 := T*g2;
  Tb2 := T*b2;
  {Get the sample color showing the blend color blebed with White}
  BlendedColor.color:=RGB(round(255-T*255+Tr2),round(255-T*255+Tg2),round(255-T*255+Tb2));
  refresh(qx*W, qy*H); {redraw the currentr image}
end;

{************** Refresh *********}
procedure TForm1.Refresh(xLeft,yTop:integer);
{Redraw the image with shading using the current parameters and top left of
 shaded area at xLeft, yTop}
var
  r1,g1,b1,r,g,b:Byte;
  x,y:integer;
  T2:Real;
  P : PPixelArray;
  c:TColor;
begin
  image1.picture.bitmap.Assign(BMP); {restore original picture}
  T2:=1-T;
  If blendTechnique.itemindex=0 then {pixel update}
  with image1.Canvas do
  begin  {pixel by pixel update}
    for x:=XLeft to Xleft+w do
    for y:=yTop to Ytop+h do
    begin
      C:=Pixels[x,y];  {split out image red, blue. green colors at this pixel
                        location and blend with current blend color}
      if blendPct.value=50 then
      begin {shortcut for 50-50 blend, faster than general method, but not by much}
        Pixels[x,y]:= ((C and $0000FF) + r2) shr 1       {adjust red}
                    +((C and $00FF00) shr 9 + g2 shr 1 ) shl 8  {adjust green}
                    + ((C and $FF0000) shr 17 + b2 shr 1) shl 16; {adjust blue}
      end
      else
      begin
        r:=round(T2*(C and $0000FF) + Tr2);
        g:=round(T2*((C and $00FF00) shr 8)  + Tg2);
        b:=round(T2*((C and $FF0000) shr 16) + Tb2);
        Pixels[x,y]:=r + g shl 8 + b shl 16 {rebuild the the pixel}
      end;
    end;
  end
  else
  begin  {scanline update}
    with image1.picture.bitmap do  {do the blending on the image piucture bitmap}
    begin
      for y:= YTop+1 to YTop+H-1 do
      begin
        P:= Scanline[y];
        for x:= XLeft to XLeft+w-1 do
        begin
          r1:=P[x,2]; {Extract the 3 color bytes for pixel X in line Y}
          g1:=P[x,1];
          b1:=P[x,0];
          {blend it}
          if blendPct.value=50 then
          begin
            r:=(r1+r2)shr 1;
            g:=(g1+g2) shr 1;
            b:=(b1 +b2) shr 1;
          end
          else
          begin  {honor user blend %}
            r:=round(T2*r1 + Tr2);
            g:=round(T2*g1 + Tg2);
            b:=round(T2*b1 + Tb2);
          end;
          {and put it back}
          P[x,2]:=r; P[x,1]:=g; p[x,0]:=b;
        end;
      end;
    end;
  end;
end;

{********* ApplyBlendAmount ********}
procedure TForm1.ApplyBlendAmount;
{Blend pct amolunt changed, recalulate the blend color}
begin
  with BlendPct do
  begin
    T:=value/100;
    //BlendedColor.color:=round(T*blendColor.color);  {drawblend will update this}
  end;
  DrawBlend;
end;

{************* ColorBtnClick ***********}
procedure TForm1.ColorBtnClick(Sender: TObject);
begin
  {Get a new blend color}
  If ColorDialog1.Execute then Blendcolor.color:=Colordialog1.color;
  //BlendedColor.color:=round(T*blendColor.color); {now done by DrawBlend}
  DrawBlend;
end;

{************ LoadBtnClick ************}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  if opendialog1.execute then
  begin  {load a new image}
    Loadimage(Opendialog1.filename, BMP);
    image1.height:=bmp.height;
    image1.width:=bmp.width;
    image1.canvas.draw(0,0,bmp);
    W:=BMP.Width  div 2; {Set width and height of shaded area}
    H:=BMP.Height div 2;
    Drawblend;
  end;

end;



{************** LoadImage ************}
procedure TForm1.LoadImage(Fname:string;  B:TBitmap);
{Load "bmp" or "Jpeg" image from filename  "Fname"  into bitmap B}
var
  jpeg:TJPegImage;
  s:string;
begin
  s:=uppercase(extractfileext(fname));
  if s='.JPG' then
  begin
    jpeg:=TJPegImage.create;
    jpeg.loadfromfile(fname);
    B.assign(jpeg);
    jpeg.free;
  end
  else B.LoadFromFile(Fname);
  FileNameLbl.caption:=format('Image "%s" (%d x %d)',
                    [extractfilename(FName), b.width,b.height]);
end;

{*********** Image1MouseDown **********}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {start drag if left button down and cursor is within the shaded area}
  if (button=mbLeft)  and (x>=qx*w) and (x<=(qx+1)*w)
                       and (Y>=qy*h) and (y<=(qy+1)*H) then
  with image1.canvas do
  begin  {get ready to drag the shaded area}
    offsetx:=x-qx*W; {offsets let us know where the top left corner of the dragged
                      are is in relation to the cursor position}
    offsety:=y-qy*H;
    pen.color:=clred;
    pen.Width:=3;
    MoveBMP.assign(Image1.picture.bitmap); {Save original image}
  end;
end;

procedure TForm1.restrictloc(var x,y:integer);
{keep mouse cursor within valid range for draggin the shaded area}
    begin
      if (x-offsetx<0) then x:=offsetx
      else if (x-offsetx+W>Image1.width) then x:=Image1.width+offsetx-w;
      if (y-offsety<0) then y:=offsety
      else if (y-offsety+H>Image1.height) then y:=Image1.height+offsety-h;
    end;

{********** Image1MouseMove ************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) then
  begin  {user wants to drag the shaded area}
    restrictloc(x,y);  {make sure shaded rectangle stays within image boundaries}
    if dragbtn.itemindex=0 then
    begin  {we are moving and redrawing the entire area}
      refresh(x-offsetx, y-offsety);
    end
    else   {we are speeding things up by only drawing the outline of the new location}
    with image1,canvas do
    begin
      picture.bitmap.assign(movebmp);
      moveto(x-offsetx, y-offsety);
      lineto(x-offsetx+w, y-offsety);
      lineto(x-offsetx+w, y-offsety+H);
      lineto(x-offsetx, y-offsety+H);
      lineto(x-offsetx, y-offsety);
    end;
  end;
end;

{************ Image1MouseUp *********}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbleft then
  begin
    restrictloc(x,y);
    refresh(x-offsetx, y-offsety); {pass top left corner of shaded area}
    MoveBMP.Assign(image1.Picture.Bitmap);
  end;
end;

{*********** BlendPctCHange ***********}
procedure TForm1.BlendPctChange(Sender: TObject);
begin
  ApplyBlendAmount;
end;

{*********** PerformBtnClick ************}
procedure TForm1.PerformBtnClick(Sender: TObject);
{Run performance test}
var
  x,y:integer;

  function runtime:real;
  begin  {update runtime seconds for this test}
    QueryPerformanceCounter(endcount);
    result:=(endcount-startcount)/freq;
  end;

begin
  if form1.tag<0 then
  begin {Stop button clicked}
    form1.tag:=+1;  {tell the perform loop that user wants to stop the test}
    PerformBtn.caption:='Performance Test';
    application.processmessages;
  end
  else
  begin  {Starting performance test}
    tag:=-1;
    PerformBtn.caption:='Stop (May take several seconds)';
    QueryPerformancefrequency(freq);
    QueryPerformanceCounter(startcount);
    drawblend;
    nbrpanels:=0;
    updatestats;  {show initial (reset) stats}
    screen.Cursor:=crHourglass;
    for x:=0 to image1.width-W do
    begin
      for y:=0 to image1.height-H do
      begin                                                    
        if tag>0 then break; {user requested stop}
        refresh(x,y); {rebuild the image}

        if displaybox.Checked then Image1.Update;
        inc(nbrpanels);

        if ((blendtechnique.itemindex=0) and (nbrpanels and $F=0))
           or ((blendtechnique.itemindex=1) and (nbrpanels and $3F=0))
          then updatestats;
      end;
      if tag>0 then break;
      if runtime>30 then break;
    end;
    screen.Cursor:=crDefault;
    QueryPerformanceCounter(endcount);
    seconds:=(endcount-startcount)/freq;
    tag:=0;
    PerformBtn.caption:='Performance Test';
    Timelbl.Caption:=format('%.1f seconds for %d panels', [seconds, nbrpanels])
             +#13 + format('%.1f panels per second',[nbrpanels/seconds]);
  end;
end;

{********* UpdateStats ************}
procedure TForm1.UpdateStats;
var
  endcount:int64;
begin
  QueryPerformanceCounter(endcount);
  seconds:=(endcount-startcount)/freq;
  Timelbl.caption:=format('%.1f seconds for %d panels', [seconds, nbrpanels])
    +#13 + format('%.1f panels per second',[nbrpanels/seconds]);
  application.processmessages;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
