unit U_GraphicsEffects2;
{Copyright  © 2003, Gary Darby & Ivan Sivak,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Most of the code contained here was written by Ivan Sivak, a 16 year-old
 Delphi programmer from Czechoslovakia..   I took some of the parameters that
 were hard coded and made them user input variables, and made a few other
 enhancements, but 90% of the code here is Ivan's.

 Some of the pages I'm not even sure I understand (e.g. Pixel distribution and
 Pixel sorting), but they  may have some artistic puropose.

 In any event, it covers many image pixel manipulation tricks that might be
 useful.
 }

{
    Hi !!!

    I am Ivan Sivak [ivanoslav], you can use this code where you would like,
    cemmercial, freeware - all.

    MODIFY THIS AT YOUR OWN RISK
    -------------------------------------------------------------------------------------
    Here is my e-mail:   ivanoslav@forehv.comx-m

     Comments, Threatening Letters, Money... are welcomed...  <:-)))))

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtDlgs, StdCtrls, ExtCtrls, ComCtrls, Spin;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    img1: TImage;
    Panel2: TPanel;
    Button1: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    TabSheet2: TTabSheet;
    Panel3: TPanel;
    Img2: TImage;
    Button2: TButton;
    TabSheet3: TTabSheet;
    Panel4: TPanel;
    Img3: TImage;
    Label5: TLabel;
    Value1: TEdit;
    Button3: TButton;
    Button4: TButton;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    TabSheet5: TTabSheet;
    Panel7: TPanel;
    originalImg2: TImage;
    Img4: TImage;
    Button7: TButton;
    Button8: TButton;
    Memo6: TMemo;
    TabSheet6: TTabSheet;
    Panel8: TPanel;
    Img5: TImage;
    originalImg3: TImage;
    Button9: TButton;
    Memo7: TMemo;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet13: TTabSheet;
    TabSheet14: TTabSheet;
    TabSheet15: TTabSheet;
    TabSheet16: TTabSheet;
    Button10: TButton;
    Panel9: TPanel;
    originalImg4: TImage;
    Img6: TImage;
    Memo8: TMemo;
    Button11: TButton;
    Button12: TButton;
    Panel10: TPanel;
    originalImg5: TImage;
    Img7: TImage;
    Memo9: TMemo;
    Button13: TButton;
    Button14: TButton;
    Panel11: TPanel;
    originalImg6: TImage;
    Img8: TImage;
    Memo10: TMemo;
    Button15: TButton;
    Button16: TButton;
    Panel12: TPanel;
    originalImg7: TImage;
    Img9: TImage;
    Memo11: TMemo;
    Button17: TButton;
    Button18: TButton;
    Panel13: TPanel;
    originalImg8: TImage;
    Img10: TImage;
    Memo12: TMemo;
    Button19: TButton;
    Button20: TButton;
    originalImg9: TImage;
    Img11: TImage;
    Memo13: TMemo;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    originalImg10: TImage;
    Img12: TImage;
    Memo14: TMemo;
    Button24: TButton;
    Button25: TButton;
    Panel14: TPanel;
    Img13: TImage;
    Img14: TImage;
    Memo15: TMemo;
    Load14bBtn: TButton;
    Button27: TButton;
    Button28: TButton;
    Img15: TImage;
    Img16: TImage;
    Memo16: TMemo;
    Button29: TButton;
    Button30: TButton;
    Panel15: TPanel;
    Img17: TImage;
    Img18: TImage;
    Memo17: TMemo;
    Button31: TButton;
    originalImg1: TImage;
    GreenBox5: TCheckBox;
    RedBox5: TCheckBox;
    BlueBox5: TCheckBox;
    RedWeight: TSpinEdit;
    GreenWeight: TSpinEdit;
    BlueWeight: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Button33: TButton;
    Label9: TLabel;
    NumEdit16: TSpinEdit;
    ContrastEdit: TSpinEdit;
    Label10: TLabel;
    Label11: TLabel;
    Median11: TSpinEdit;
    Blendgrp: TRadioGroup;
    XBlob: TSpinEdit;
    YBlob: TSpinEdit;
    BlobCnt: TSpinEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label12: TLabel;
    NbrBlobs: TSpinEdit;
    Label13: TLabel;
    BlackWhite: TSpinEdit;
    Label14: TLabel;
    BrightEdit: TSpinEdit;
    Label2: TLabel;
    AmpEdit: TSpinEdit;
    PeriodEdit: TSpinEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    MagAreaEdit: TSpinEdit;
    RaisedTextEdit: TEdit;
    Label18: TLabel;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure originalImg1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure originalImg1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure originalImg1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Value1KeyPress(Sender: TObject; var Key: Char);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Load14bBtnClick(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button30Click(Sender: TObject);
    procedure Button32Click(Sender: TObject);
    procedure Button33Click(Sender: TObject);
    procedure Img18Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public

    dx,dy : integer; // as "down" x and "down" y (mouse down)
    mx,my : integer; // as "mouse" x and y
    mdown : boolean; // is mouse down ? variable stores this information

    CLR_CLEAR: TColor; // Variable that stores the background color...
    starttime:TDatetime;

    (*this procedure recursively filling all images, and gives white background *)
    Procedure FillAllImagesEveryWhere;

    (*This procedure set up all the variables*)
    Procedure SetApplicationVariables;

    (*auto-load pictures to all images, and then just clicking the "proceed" button*)
    Procedure AutoLoadPicturesToAllImages;

    Function GetFirstPicture: string;
    Function GetSecondPic   : string;

    procedure loadscaled(Image:TImage; filename:string);
  end;

var
  Form1: TForm1;

implementation

uses math;

{$R *.dfm}



Const
     RP = 0.2989;
     GP = 0.5866;
     BP = 1 - RP - GP;

//####################################################################
//############## Filling all the images in the form ##################
//####################################################################
procedure TForm1.FillAllImagesEveryWhere;
Var I: Integer;

    // recursive function is used, because we don't know how many images are there...
   Function GoRecursive(C: TComponent): TComponent;
   Var J: Integer;
          // next easy sub-procedure to do "fill" action
            Procedure FillIt(Img: TImage);
            begin
              Img.Canvas.Brush.Color := CLR_CLEAR;
              Img.Canvas.FillRect(rect(0,0,Img.Width,Img.Height));
            end;
   begin
      result := C;
      if C is TImage then
        FillIt(TImage(C));

     //Always, we have to check all the "children" of the component...
      For J := 0 to C.ComponentCount - 1 do
       GoRecursive(C.Components[J]);
   end;

begin
// this is a first loop we must to do to check for all the images in the form
   For I := 0 to form1.ComponentCount - 1 do
    GoRecursive(form1.Components[I]);
end;


procedure TForm1.SetApplicationVariables;
begin
  DoubleBuffered := True;
  CLR_CLEAR := clWhite; // usually is white...
  FillAllImagesEveryWhere;
  PageControl1.ActivePage := TabSheet2;
  AutoLoadPicturesToAllImages;
  OpenPictureDialog1.InitialDir := ExtractFilePath(Application.ExeName);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SetApplicationVariables;
end;



//####################################################################
//############## Example - 1 ##################
//####################################################################

procedure TForm1.originalImg1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

{Rectangle selection }
begin
  dx := x;dy:=y; // store mouse down x and y
  {mdown := true;}

  originalImg1.Canvas.Brush.Style := bsClear;
  originalImg1.Canvas.Pen.Style   := psDash;
  originalImg1.Canvas.Pen.Mode    := pmNot;

  mx:=x;my:=y;
  originalImg1.Canvas.Rectangle(dx, dy, mx, my);
end;

procedure TForm1.originalImg1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if ssLeft in shift {mdown} then begin
      originalImg1.Canvas.Rectangle(dx, dy, mx, my);
      mx:=x;my:=y;
      originalImg1.Canvas.Rectangle(dx, dy, mx, my);
  end;
end;

procedure TForm1.originalImg1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var  r:Trect;

    function normalizerect(r:Trect):TRect;
    {make sure that top, left really is }
    begin
      result:=r;
      with result do
      begin
        if right<left then begin left:=r.right; right:=r.left; end;
        if bottom<top then begin  top:=r.bottom; bottom:=r.top; end;
      end;
    end;

begin
  originalImg1.Canvas.Rectangle(dx, dy, mx, my);
  Img1.Canvas.Brush.Color := CLR_CLEAR;
  Img1.Canvas.FillRect(Rect(0, 0, Img1.Width, Img1.Height));
  r:=normalizerect(rect(x,y,dx,dy));
  Img1.Canvas.CopyRect(Rect(0,0,r.right-r.left,r.bottom-r.top),
                       originalImg1.Canvas, R);

  (*  Ivan's original code}
  if (X >= DX) and (Y >= DY) then
  Img1.Canvas.CopyRect(Rect(0, 0, X - dx+1, Y - dy+1),
                       originalImg1.Canvas,
                       Rect(dx, dy, X, Y));
  if (X < DX) and (Y >= DY) then
  Img1.Canvas.CopyRect(Rect(0, 0, DX - X, Y - dy+1),
                       originalImg1.Canvas,
                       Rect(X, dy, DX, Y));
  if (X < DX) and (Y < DY) then
  Img1.Canvas.CopyRect(Rect(0, 0, DX - X, DY - Y),
                       originalImg1.Canvas,
                       Rect(X, Y, DX, DY));
  if (X > DX) and (Y < DY) then
  Img1.Canvas.CopyRect(Rect(0, 0, X - dx+1, DY - Y),
                       originalImg1.Canvas,
                       Rect(DX, Y, X - DX, DY - Y));
 *)
end;

//####################################################################
//############## Example - 2 ##################
//####################################################################
procedure TForm1.Button2Click(Sender: TObject);
{raised text}
var text:string;
begin
  text:=raisedTextEdit.text;
  Img2.Canvas.Font.Name   := 'Arial';
  Img2.Canvas.Brush.Color := clGray;
  Img2.Canvas.Rectangle(0,0,Img2.Width,Img2.Height);
  Img2.Canvas.Brush.Style := bsClear;
  Img2.Canvas.Font.Size   := 48;
  Img2.Canvas.Font.Style  := [fsBold];
  Img2.Canvas.Font.Color  := clBlack;
  Img2.Canvas.TextOut(50,50,text);
  iMG2.update;
  sleep(1000);
  Img2.Canvas.Font.Color  := clWhite;
  Img2.Canvas.TextOut(48,48,text);
  Img2.update;
  sleep(1000);
  Img2.Canvas.Font.Color  := clGray;
  Img2.Canvas.TextOut(49,49,text);
end;


//####################################################################
//############## Example - 3 ##################
//####################################################################
procedure TForm1.Value1KeyPress(Sender: TObject; var Key: Char);
{Rotate text}
begin
 // we have to test if is there any number...because we need only NUMBER
  if not(key in ['0'..'9']) then key := #0;
end;

// this procedure makes text rotated....
procedure TForm1.Button3Click(Sender: TObject);
Var LogRec: TLOGFONT;
begin
  with img3, canvas do
  begin
    Font.Name   := 'Arial';
    Brush.Color := CLR_CLEAR;
    FillRect(rect(0,0,Width,Height));
    Font.Size := 48;
    Font.Style := [fsBold];
    GetObject(Font.Handle, SizeOf(LogRec),Addr(LogRec));

    LogRec.lfEscapement := StrToInt(Value1.Text)*10;  {escapement in 10ths of degrees}
    Font.Handle := CreateFontIndirect( LogRec );
    TextOut(20,height-20-TextHeight('H') {150},'HOHOHO :)');
  end;
end;

{this procedure animates the canvas text}
procedure TForm1.Button4Click(Sender: TObject);
Var  LogRec: TLOGFONT;
Begin
  Img3.Canvas.Font.Name   := 'Arial';
  Img3.Canvas.Brush.Color := CLR_CLEAR;

  Img3.Canvas.Font.Size := 48;
  Img3.Canvas.Font.Style := [fsBold];
  GetObject(Img3.Canvas.Font.Handle, SizeOf(LogRec),Addr(LogRec));


  logrec.lfEscapement:=0; // if we start must be zero (angle in 10ths of degrees)
  // loop where is the text animated, maximal animated value is 900
  While logrec.lfEscapement < 900 do  {up to 90 degrees}
  with img3, canvas do
  begin
    FillRect(rect(0,0,Width,Height));
    Font.Handle := CreateFontIndirect( LogRec );
    TextOut(20,height-20-textheight('H'),'HOHOHO :) ');
    Sleep(1);       // time - out,bigger value = slower movement
    Img3.Update;
    Inc(logrec.lfEscapement, 5); // very important, always we have to increment angle value
  end;
  // after loop, we define the default parameters...
  Button3.Click;
end;





//####################################################################
//############## Example - 5 ##################
//####################################################################
{Filter out colors}

procedure TForm1.Button8Click(Sender: TObject);
Var K, L: Integer;
    P   : TColor;
    Scan, scan2:PByteArray;
    bitmap:TBitmap;
begin
  For K := 0 to originalimg2.Width do
  begin
    Img4.Repaint;
    For L := 0 to originalimg2.Height do
    begin
      P := OriginalImg2.Canvas.Pixels[K, L];
      If redbox5.checked then P := (P and $FFFF00);
      If greenbox5.checked then P := (P and $FF00FF);
      If bluebox5.checked then P := (P and $00FFFF);

       Img4.Canvas.Pixels[K, L] := P;
    end;
  end;
 // showmessage(format('Time:= %.3f seconds',[(now-starttime)*secsperday]));
end;

procedure clearimage(image:TImage);
begin
  with image do
  begin
    canvas.Brush.Color:=clWhite;
    canvas.FillRect(clientrect);
  end;
end;

procedure TForm1.LoadBtnClick(Sender: TObject);
{Convert to grayscale}
var image:TImage;
begin
  image:=nil;
  {Selection}
  if sender = button1      then begin image:=originalimg1; clearimage(img1); end
  {PixelFilter}
  else if sender = button7 then begin image:=originalimg2; clearimage(img4); end
  {Grayscale}
  else if sender = button9 then begin image:=originalimg3; clearimage(img5); end
  {Black & White}
  else if sender = button11 then begin image:=originalimg4; clearimage(img6); end
  {Pixel Dist}
  else if sender = button13 then begin image:=originalimg5; clearimage(img7); end
  {Invert Colors}
  else if sender = button15 then begin image:=originalimg6; clearimage(img8); end
  {Contrast}
  else if sender = button17 then begin image:=originalimg7; clearimage(img9); end
  {Relief image}
  else if sender = button19 then begin image:=originalimg8; clearimage(img10) end
  {Blob deformation}
  else if sender = button24 then begin image:=originalimg10; clearimage(img12); end
  {blend}
  else if sender = button27 then image:=img13
  {Sine deformation}
  else if sender = button29 then begin image:=img15; img16.Picture:=nil; end
  {Magnify}
  else if sender = button31 then begin image:=img17; img18.Picture:=nil; end;

  if (Image<>nil) and OpenPictureDialog1.Execute  {load the left side image}
  then loadscaled(Image,OpenPictureDialog1.FileName);

  if sender=button13 then loadscaled(img7,OpenPictureDialog1.FileName)

  else if sender=button31 then loadscaled(img18,OpenPictureDialog1.FileName)


end;


//####################################################################
//############## Example - 6 ##################
//####################################################################


procedure TForm1.Button10Click(Sender: TObject);
Var
  X, Y: Integer;
  P   : TColor;
  r,g,b: byte;
  RP,GP,BP:single;
begin
  x:=RedWeight.value+GreenWeight.value+BlueWeight.value;
  RP:=RedWeight.value/x;
  GP:=Greenweight.value/x;
  BP:=BlueWeight.value/x;
  starttime:=now;

  For X := 0 to originalImg3.Width do
  begin
    Img5.Repaint;
    For y := 0 to originalImg3.Height do
    begin
      P := originalImg3.Canvas.Pixels[X, Y];
      r := (P and $0000FF);
      g := (P and $00FF00) shr 8;
      b := (P and $FF0000) shr 16;
      Img5.Canvas.Pixels[X, Y] :=  round (
      r * RP + g * GP + b*BP) * $010101;
    end;
  end;
  //showmessage(format('Time:= %.3f seconds',[(now-starttime)*secsperday]));
end;


//####################################################################
//############## Example - 7 ##################
//####################################################################

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if not(key in ['0'..'9']) then key := #0;
end;

procedure TForm1.Button12Click(Sender: TObject);
Var
  X, Y: Integer;
  P   : TColor;
  r,g,b: byte;
  light, value: byte;
begin
   value := blackwhite.value;
   For X := 0 to originalImg4.Width do begin
    Img6.Repaint;
      For y := 0 to originalImg4.Height do begin
        P := originalImg4.Canvas.Pixels[X, Y];
        r := (P and $0000FF);
        g := (P and $00FF00) shr 8;
        b := (P and $FF0000) shr 16;
        light := trunc(
                    r * RP + g * GP + b * BP);
        if light > value then
          Img6.Canvas.Pixels[X, Y] := clWhite else
           Img6.Canvas.Pixels[X, Y] := clBlack;
      end;
  end;
end;


//####################################################################
//############## Example - 8 ##################
//####################################################################
{Pixel Distribution}
procedure TForm1.Button14Click(Sender: TObject);
Const
     MY = 500;
Var
  light: Integer;
  L0, L1: array[-1..MY+1] of Integer;
  X, Y: Integer;
  P   : TColor;
  r,g,b: byte;
begin
  FillChar(L1, SizeOf(L1), #0);

   For X := 0 to Img7.Width do begin
       Img7.Repaint;
       L0 := L1;
       FillChar(L1, SizeOf(L1), #0);
       For Y := 0 to Img7.Height do begin
          P := originalImg5.Canvas.Pixels[X, Y];
          r := (P and $0000FF);
          g := (P and $00FF00) shr 8;
          b := (P and $FF0000) shr 16;
          light := Trunc(r * RP + g * GP + b * BP);
          light := light + L0[Y];

          if light > 255 then begin
              Img7.Canvas.Pixels[X, Y] := clWhite;
              light := light - 255;
          end else
          Img7.Canvas.Pixels[X, Y] := clBlack;

          Inc(L0[Y+1], light div 4);
          Inc(L1[Y-1], light div 4);
          Inc(L1[Y  ], light div 4);
          Inc(L1[Y+1], light - 3*(light div 4) );
       end;
   end;
end;


//####################################################################
//############## Example - 9 ##################
//####################################################################
{Invert colors}

procedure TForm1.Button16Click(Sender: TObject);
Var
  X, Y: Integer;
  P   : TColor;
  r,g,b: byte;
begin
    For X := 0 to originalImg6.Width do begin
      Img8.Repaint;
        For Y :=0 to originalImg6.Height do begin
            P := originalImg6.Canvas.Pixels[X, Y];
            r := (P and $0000FF);
            g := (P and $00FF00) shr 8;
            b := (P and $FF0000) shr 16;
            r := 255 - r;
            g := 255 - g;
            b := 255 - b;
            Img8.Canvas.Pixels[X, Y] := r + g shl 8 + b shl 16;
        end;
    end;
end;


//####################################################################
//############## Example - 10 ##################
//####################################################################
{Brightess and Contrast adjsutment}


type
  TRGBrec=record
    r,g,b:integer;
   end;

   THSVRec=record
     h,s,v:extended;
   end;

function RGBtoHSV(Inrec:TRGBrec):THSVrec;
var
  mn,mx,delta:extended;
  rr,gg,bb:extended;
begin
  with result do
  begin
    with inrec do begin rr:=r/255; gg:=g/255; bb:=b/255; end;
    mn:=min(rr,min(gg,bb));
    mx:=max(rr,max(gg,bb));
    v:=mx;
    delta:=mx-mn;
    if mx<>0 then s:=delta/mx
    else
    begin
      s:=0;
      h:=-1;
      exit;
    end;
    if delta=0 then h:=0
    else If rr=mx then h:= (gg-bb)/delta
    else if gg=mx then h:=2+(bb-rr)/delta
    else h:=4+(rr-gg)/delta;
    h:=h*60;
    if h<0 then while h<0 do h:=h+360;
  end;
end;
(*   {C version}
   // r,g,b values are from 0 to 1
// h = [0,360], s = [0,1], v = [0,1]
//		if s == 0, then h = -1 (undefined)
void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
	float min, max, delta;
	min = MIN( r, g, b );
	max = MAX( r, g, b );
	*v = max;				// v
	delta = max - min;
	if( max != 0 )
		*s = delta / max;		// s
	else {
		// r = g = b = 0		// s = 0, v is undefined
		*s = 0;
		*h = -1;
		return;
	   }
	if( r == max )
		*h = ( g - b ) / delta;		// between yellow & magenta
	else if( g == max )
		*h = 2 + ( b - r ) / delta;	// between cyan & yellow
	else
		*h = 4 + ( r - g ) / delta;	// between magenta & cyan
	*h *= 60;				// degrees
	if( *h < 0 )
		*h += 360;
}
*)


function HSVtoRGB(Inrec:THSVRec):TRGBRec;
var
  i:integer;
  f,p,q,t:extended;
begin
  with inrec, result do
  begin
    if s=0 then
    begin
      //r:=trunc(v)*255;
      //g:=trunc(v)*255;
      //b:=trunc(v)*255;
      r:=trunc(v*255);
      g:=trunc(v*255);
      b:=trunc(v*255);
      exit;
    end;
    h:=h/60;
    i:=floor(h);
    f:=h-i;
    p:=v*(1-s);
    q:=v*(1-s*f);
    t:=v*(1-s*(1-f));
    case i of
    0:
      begin
      	r := trunc(v*255);
			  g := trunc(t*255);
			  b := trunc(p*255);
			 end;
		1:
      begin
  			r := trunc(q*255);
	  		g := trunc(v*255);
		  	b := trunc(p*255);
			end;
		2:
      begin
  			r:= trunc(p*255);
	  		g := trunc(v*255);
		  	b := trunc(t*255);
			end;
		3:
      begin
  			r := trunc(p*255);
	  		g := trunc(q*255);
		  	b := trunc(v*255);
			end;
		4:
      begin
			  r := trunc(t*255);
			  g := trunc(p*255);
			  b := trunc(v*255);
			end;
		else
      begin
    		r := trunc(v*255);
			  g := trunc(p*255);
			  b := trunc(q*255);
			end;
    end; {case}
  end;
end;

(*      {C Version}
void HSVtoRGB( float *r, float *g, float *b, float h, float s, float v )
{
	int i;
	float f, p, q, t;
	if( s == 0 ) {
		// achromatic (grey)
		*r = *g = *b = v;
		return;
	}
	h /= 60;			// sector 0 to 5
	i = floor( h );
	f = h - i;			// factorial part of h
	p = v * ( 1 - s );
	q = v * ( 1 - s * f );
	t = v * ( 1 - s * ( 1 - f ) );
	switch( i ) {
		case 0:
			*r = v;
			*g = t;
			*b = p;
			break;
		case 1:
			*r = q;
			*g = v;
			*b = p;
			break;
		case 2
			*r = p;
			*g = v;
			*b = t;
			break;
		case 3:
			*r = p;
			*g = q;
			*b = v;
			break;
		case 4:
			*r = t;
			*g = p;
			*b = v;
			break;
		default:		// case 5:
			*r = v;
			*g = p;
			*b = q;
			break;
	}
}

*)


{Adjust contrast}

// to highten Contrast use  f(x) = x*x/256
// to make contrast smaller use f(x) = 16 * sqrt(x);
procedure TForm1.Button18Click(Sender: TObject);
Var
  X, Y: Integer;
  P   : TColor;
  exponent,f : extended;
  hsv:THsvRec;
  rgb:TRGBRec;
  bright:extended;
begin
  bright:=brightedit.value/10;;

  For X := 0 to originalImg7.Width do
  begin
    Img9.Repaint;
    exponent:=contrastedit.value/10.0;
    f:=256/power(256,exponent);
    For Y :=0 to originalImg7.Height do
    with rgb do
    begin
      P := originalImg7.Canvas.Pixels[X, Y];
      r := (P and $0000FF);
      g := (P and $00FF00) shr 8;
      b := (P and $FF0000) shr 16;
      r := trunc(power(r,exponent)*f);
      g := trunc(power(g,exponent)*f);
      b := trunc(power(b,exponent)*f);

      {Convert rgb pixel to hsv, set new prightness, convert back to rgb}
      HSV:=RGBToHSV(rgb);
      with HSV do begin v:=v*bright; if v>1 then v:=1;   end;
      rgb:=HSVtoRGB(Hsv);

      Img9.Canvas.Pixels[X, Y] := r + g shl 8 + b shl 16;
    end;
  end;
end;


//####################################################################
//############## Example - 11 ##################
//####################################################################
procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
if not(key in ['0'..'9']) then key := #0;
end;

procedure TForm1.Button20Click(Sender: TObject);

Var
  X, Y: Integer;
  P   : TColor;
  r,g,b : byte;
  value,light1,light2,vlight : Integer;
  cs:array of array of byte;
begin
   setlength(cs,2,originalimg8.width);
   Value := median11.value;
   For y := 0 to originalImg8.height do
   begin
     Img10.Repaint;
     For x :=0 to originalImg8.width do
     begin

       P := originalImg8.Canvas.Pixels[X-3, Y-3];
       r := (P and $0000FF);
       g := (P and $00FF00) shr 8;
       b := (P and $FF0000) shr 16;
       light1 := trunc (r * RP + g * GP + b * BP);

       P := originalImg8.Canvas.Pixels[X, Y];
       r := (P and $0000FF);
       g := (P and $00FF00) shr 8;
       b := (P and $FF0000) shr 16;
       light2 := trunc (r * RP + g * GP + b * BP);

       vlight := (Value + light2 - Light1);

       if vlight < 0 then vlight := 0;
       if vlight > 255 then vlight := 255;
       Img10.Canvas.Pixels[X, Y] := vlight * $010101;
     end;
  end;
end;


//####################################################################
//############## Example - 12 ##################
//####################################################################
{Pixel Sorting}
Var STOP: Boolean;
    BM  : TBitMap;
procedure TForm1.Button21Click(Sender: TObject);
begin
  if OpenPictureDialog1.Execute then
  begin
   loadscaled( OriginalImg9,OpenPictureDialog1.filename);
   If assigned(BM) then BM.free;
   BM := TBitMap.Create;
   BM.Width := originalImg9.Width;
   BM.Height := originalImg9.Height;
   BM.Assign(originalImg9.Picture.Bitmap);
   Img11.Picture.Bitmap.Assign(BM);
 end;
end;

//because using the canvas would be very slow,we using the BitMap,it's faster than canvas...
procedure TForm1.Button22Click(Sender: TObject);


Var x, y, x2, y2, i: integer;
    p1, p2: TColor;
    r,g,b: byte;
    light1,light2: integer;
begin
  STOP := False;
  screen.cursor:=crHourGlass;
  Repeat
   for i:=1 to 100000 do
   begin
     x := 1+random(Img11.Width - 1);
     y := random(Img11.Height);
     x2 := x - 1 + random(3);
     y2 := y + Random(10);

     p1 := BM.Canvas.Pixels[x, y];
     r := (P1 and $0000FF);
     g := (P1 and $00FF00) shr 8;
     b := (P1 and $FF0000) shr 16;
     light1 := trunc (r * RP + g * GP + b*BP);

     p2 := BM.Canvas.Pixels[x2, y2];
     r := (P2 and $0000FF);
     g := (P2 and $00FF00) shr 8;
     b := (P2 and $FF0000) shr 16;
     light2 := trunc (r * RP + g * GP + b*BP);

     if light2 > light1 then begin
         BM.Canvas.Pixels[x, y] := p2;
         BM.Canvas.Pixels[x2, y2] := p1;
     end;
    end;

    with Img11 do
     Canvas.CopyRect( Rect( 0,0,width-1,Height-1 ),
                    BM.Canvas,
                    Rect( 0,0,width-1,Height-1 ) );

      Img11.Repaint;
      Application.ProcessMessages;
      //MessageBeep(0)

  until STOP;
  screen.cursor:=crdefault;
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
  STOP := True;
end;


//####################################################################
//############## Example - 13 ##################
//####################################################################


{Random blobs}

procedure TForm1.Button25Click(Sender: TObject);
Var x, y: Integer;
    p: Tcolor;
    r,g,b : byte;
    sr,sg,sb: integer;
    i,j: Integer;
    rx,ry,cnt:integer;
begin
   screen.cursor:=crhourglass;
   rx:=xblob.value;
   ry:=yblob.value;
   cnt:=blobcnt.value;
   img12.picture.assign(OriginalImg10.picture);
   img12.canvas.brush.color:=clwhite;

   Img12.Canvas.Pen.Style := psClear;
   For I :=0 to nbrblobs.value do
   begin
     x := random(originalImg10.Width);
     y := random(originalImg10.Height);

     sr := 0; sg := 0; sb := 0;
     For j := 1 to cnt do begin
         p := originalImg10.Canvas.Pixels[x-Rx+Random(2*rx+1),y-Ry+Random(2*ry+1)];
         sr := sr + (p and $0000FF);
         sg := sg + (p and $00FF00) shr 8;
         sb := sb + (p and $FF0000) shr 16;
     end;
     r := sr div cnt;
     g := sg div cnt;
     b := sb div cnt;

     Img12.Canvas.Brush.Color := r + g shl 8 + b shl 16;
     Img12.Canvas.Ellipse(x-Rx, y-Ry, x+Rx, y+Ry);
   end;
   screen.cursor:=crdefault;
end;


//####################################################################
//############## Example - 14 ##################
//####################################################################
var  blendmap:TBitmap; {holds the second image for blending}

{Blend 2 pictures}

procedure TForm1.Load14bBtnClick(Sender: TObject);
begin

if OpenPictureDialog1.Execute then
begin
   loadscaled(img14,OpenPictureDialog1.FileName);
   If assigned(BlendMap) then Blendmap.free;
   BlendMap := TBitMap.Create;
   BlendMap.Width := Img14.Width;
   BlendMap.Height := Img14.Height;
   BlendMap.Assign(Img14.Picture.Bitmap);
  end;
end;



procedure TForm1.Button28Click(Sender: TObject);
{blend 2 pictures}
var  x,y: integer;
     c: TColor;
     r,g,b: byte;
     r1,g1,b1: byte;
     r2,g2,b2: byte;
     t: real;
begin
  if not assigned(blendmap) then load14bBtnClick(sender)
  else  Img14.Picture.Bitmap.Assign(BlendMap);

  panel4.doublebuffered:=true;
  for x:=0 to Img13.picture.Width-1 do
  begin
     case blendgrp.itemindex of
     0:  t := 1/2;
     1:  t := x / Img13.picture.Width;
     2:  t := 1-(x / Img13.picture.Width);
     end;

     for y:=0 to Img13.picture.Height-1 do
     begin
       c := Img13.Canvas.Pixels[x,y];
       r1 := (c and $0000FF);
       g1 := (c and $00FF00) shr 8;
       b1 := (c and $FF0000) shr 16;
       c := Img14.Canvas.Pixels[x,y];
       r2 := (c and $0000FF);
       g2 := (c and $00FF00) shr 8;
       b2 := (c and $FF0000) shr 16;
       r := round( t*r1 + (1-t)*r2 );
       g := round( t*g1 + (1-t)*g2 );
       b := round( t*b1 + (1-t)*b2 );
       Img14.Canvas.Pixels[x,y] := r + g shl 8 + b shl 16
     end;
     Img14.update;
   end;
end;

//####################################################################
//############## Example - 15 ##################
//####################################################################
{Deform pictures Sine}

procedure TForm1.Button30Click(Sender: TObject);
var  x,y,x2,y2: integer;
     amp,freq:single;
begin
  for x:=1 to 10 do
   with Img15.Canvas do
   begin
      MoveTo( 50*x,0 ); LineTo( 50*x,500 );
      MoveTo( 0,50*x ); LineTo( 500,50*x );
   end;
   application.ProcessMessages;
   freq:=1/periodedit.value;
   amp:=ampedit.Value;
   for x := 0 to Img16.Width do
   begin
      img16.Repaint;

      for y := 0 to img16.Height do
      begin
         x2 := x+round( amp*sin(y*freq) );
         y2 := y+round( amp*cos(x*freq) );

         Img16.Canvas.Pixels[x,y]
              := Img15.Canvas.Pixels[x2,y2]
      end
   end;
end;


//####################################################################
//############## Example - 15 ##################
//####################################################################
{Magnify pictures}

procedure TForm1.Button32Click(Sender: TObject);
var  x,y,x2,y2: integer;
     r: integer;
     Zvetseni: real;
     x0:integer { = 104};
     y0:integer {=203};
     mag:single;
     d:single;  {diameter cutoff limit}
     p:TPoint;

begin

  mag:=numedit16.value*100;
  d:=Mag * magareaedit.Value/100.0;
  p:=img18.screentoclient(mouse.cursorpos);
  if (p.x<0) or (p.y<0) then begin p.x:=50; p.y:=175; end;
  x0:=p.x;
  y0:=p.y;

  {Change May 2013 to copy entire image first, then change only pixels in the
   magnified area}
  Img18.Picture.Assign(Img17.picture);  // first change
  for x := 0 to Img18.Width do
  begin
    for y := 0 to Img18.Height do
    begin
      r := (x-x0)*(x-x0) + (y-y0)*(y-y0);
      if (r > d) or (r=0) then Zvetseni := 1
         {else if r=0 then zvetseni:=1 }{mag/10}
      else // second change
      begin
         Zvetseni := mag / r;
         x2 := round( x0+ (x-x0)/Zvetseni );
         y2 := round( y0+ (y-y0)/Zvetseni );
         Img18.Canvas.Pixels[x,y] := Img17.Canvas.Pixels[x2,y2];
      end;
    end;
  end;
  (*  {Original code, copies enitre image pixel by pixel whether it is magnified or not}
  for x := 0 to Img18.Width do
  begin
    Img18.update;
    for y := 0 to Img18.Height do
    begin
      r := (x-x0)*(x-x0) + (y-y0)*(y-y0);
      if (r > d) or (r=0) then Zvetseni := 1
         {else if r=0 then zvetseni:=1 }{mag/10}
      else Zvetseni := mag / r;

      x2 := round( x0+ (x-x0)/Zvetseni );
      y2 := round( y0+ (y-y0)/Zvetseni );

      Img18.Canvas.Pixels[x,y] := Img17.Canvas.Pixels[x2,y2]
    end
  end;
  *)
end;

procedure TForm1.Img18Click(Sender: TObject);
var
  p:Tpoint;
begin
  button32click(sender);
end;

{************* LoadScaled ***********}
procedure TForm1.loadscaled(Image:TImage; filename:string);
{Added May 2013 with Version 2.0:
 Loads pictures into the specified TImage scaled proportionately so that the
 largeat dimension just fits the avaiable TImage size in that direction}
var
  bitmap1:TBitmap;
  scalex,scaley,scale:extended;
 begin
   bitmap1:=TBitmap.create;
   bitmap1.loadfromfile(filename);
   scalex:=image.width/bitmap1.width;
   scaley:=image.height/bitmap1.height;
   if scalex>scaley then scale:=scaley else scale:=scalex;
   with image.picture.bitmap do
   begin
     width:=trunc(scale*bitmap1.width);
     height:=trunc(scale*bitmap1.height);
     canvas.stretchdraw(rect(0,0,width,height),bitmap1);
   end;
   bitmap1.Free;
 end;

procedure TForm1.AutoLoadPicturesToAllImages;
begin
   loadscaled(originalImg1,GetFirstPicture);
   loadscaled(originalImg2,GetFirstPicture);
   loadscaled(originalImg3,GetFirstPicture);
   loadscaled(originalImg4,GetFirstPicture);
   loadscaled(originalImg5,GetFirstPicture);
   loadscaled(originalImg6,GetFirstPicture);
   loadscaled(originalImg7,GetFirstPicture);
   loadscaled(originalImg8,GetFirstPicture);
    {load img9 & Img11 for pixel sorting}
   loadscaled(originalImg9,GetFirstPicture);
   if BM <> nil then BM.Free;
   BM := TBitMap.Create;
   BM.Width := originalImg9.Width;
   BM.Height := originalImg9.Height;
   BM.Assign(originalImg9.Picture.Bitmap);
   Img11.Picture.Bitmap.Assign(BM);

   loadscaled(originalImg10,GetFirstPicture);
   loadscaled(Img7,GetFirstPicture);
   loadscaled(Img17,GetfirstPicture);
   loadscaled(Img18,GetFirstPicture);

   loadscaled(Img13,GetfirstPicture);
   loadscaled(Img15,GetFirstPicture);
   Img14.width:=Img13.width;
   Img14.height:=Img13.height;
   Img14.picture.bitmap.width:=Img13.picture.bitmap.width;
   Img14.picture.bitmap.height:=Img13.picture.bitmap.height;
   Loadscaled(Img14,GetSecondPic);
   if Blendmap <> nil then Blendmap.Free;
   BlendMap := TBitMap.Create;
   BlendMap.Width := Img14.Width;
   BlendMap.Height := Img14.Height;
   BlendMap.Assign(Img14.Picture.Bitmap);
end;

function TForm1.GetFirstPicture: string;
begin
  result := ExtractFilePath(Application.ExeName)+'original_picture.bmp';
end;

function TForm1.GetSecondPic: string;
begin
  result := ExtractFilePath(Application.ExeName)+'second_picture.bmp';
end;

procedure TForm1.Button33Click(Sender: TObject);
{Restore NTSC grayscale weights}
begin
  Redweight.value:=299;
  GreenWeight.value:=589;
  BlueWeight.value:=114;
end;



procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Stop:=true;
  canclose:=true;
end;

end.
