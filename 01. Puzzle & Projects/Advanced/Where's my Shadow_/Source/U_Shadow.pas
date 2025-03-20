unit U_Shadow;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{A program which displays the shadow of a vertical rod cast by the sun at a
 given azimuth and altitude as seen from a given eyepoint}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Spin;

type

  Float=double;

  TRealPoint = record
    x,y: float;
  end;

  T3DPoint = record
    x,y,z: float;
  end;


  TSavedRec = record
    view:TPoint; {the current x,y coordinates of the shadow point}
    {dist = true distance from rod base and az=true azimuth of shadow point.
     These are adjusted by height and bearing of the eyepoint for plotting}
    dist,az:single;
  end;

  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    Label1: TLabel;
    RodSpinEdt: TSpinEdit;
    Label2: TLabel;
    AzSpinEdt: TSpinEdit;
    Label3: TLabel;
    AltSpinEdt: TSpinEdit;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    EyeDistSpinEdt: TSpinEdit;
    Label5: TLabel;
    EyeAzSpinEdt: TSpinEdit;
    Label6: TLabel;
    EyeAltSpinEdt: TSpinEdit;
    Memo1: TMemo;
    StaticText1: TStaticText;
    SavePtBtn: TButton;
    ClearPtsBtn: TButton;
    LoadAnalemmaBtn: TButton;
    OpenDialog1: TOpenDialog;
    procedure FormActivate(Sender: TObject);
    procedure AltSpinEdtChange(Sender: TObject);
    procedure RodSpinEdtChange(Sender: TObject);
    procedure PaintFigure(Sender: TObject);
    procedure EyeSpinEdtChange(Sender: TObject);
    procedure AzSpinEdtChange(Sender: TObject);
    procedure SavePtBtnClick(Sender: TObject);
    procedure ClearPtsBtnClick(Sender: TObject);
    procedure LoadAnalemmaBtnClick(Sender: TObject);
  public
    RodHeight: float; {Height of the rod}
    Azimuth, Altitude: float;   {Sun location}
    EyeDist, EyeAlt, EyeAz:float;  {Eye location}
    OrigEyeRodDist:integer;
    DistScale:float;
    BaseCircle: Array of TRealPoint; {Shadow circle looking straight down}
    ViewCircle:Array of TPoint {TInt3DPoint}; {Base circle adjust for eyepoint}
    NbrPoints:integer;
    N1,N2,N3:integer;  {calculated 1/4, 1/2, 3/4 viewcircle indices for N, W, S, directions}
    BaseRod:T3DPoint;
    savedshadowpoints:array of TSavedrec; {For redrawing saved shadow points}
    savedptr:integer; {index of last saved shadow point}
    currentshadowpoint:integer;
    midx,midy:integer;
    Procedure RecalcBaseCircle;
    Procedure RecalcViewCircle;
    procedure SetFontAngle( afont:Tfont; const angle:float);
  end;

var
  Form1: TForm1;
  r: float;

implementation

uses Math;


{$R *.dfm}

var
  TwoPi:float=2*Pi;
  HalfPi:float=Pi/2;
  PiDiv180:float=Pi/180;


{************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  savedptr:=-1;
  Nbrpoints:=200;
  N1:=Nbrpoints div 4; {1/4 == > index equivalent of Pi/2 (E)}
  N2:=Nbrpoints div 2;  {index equivalent of Pi (S)}
  N3:=3*Nbrpoints div 4;  {index equivalent of 3/2 Pi (W)}
  setlength(BaseCircle,nbrpoints);
  setlength(ViewCircle,nbrpoints);
  midx:=paintbox1.Width div 2;
  midy:=paintbox1.Height div 2;

  {Initialize values from spin edits without triggerring other change actions}
  EyeDist:=EyeDistSpinEdt.value;
  Eyealt:=EyeAltSpinEdt.value*PiDiv180;
  altitude:=altspinedt.value*PiDiv180;
  rodheight:=rodspinedt.value;
  OrigEyeRodDist:=trunc(2*Rodheight);  {save it for future scaling computations;}
  Distscale:=OrigEyeRodDist/Eyedist;
  EyeDistSpinEdt.value:=OrigEyeRodDist;  {arbitrary to establish a scaling factor}
  doublebuffered:=true;
  Altspinedtchange(Sender);
  AzSpinEdtChange(Sender);
  EyeSpinEdtChange(Sender);
  paintfigure(sender);
  opendialog1.InitialDir:=extractfilepath(application.ExeName);
End;

{************ AltSpinEdtChange **************}
procedure TForm1.AltSpinEdtChange(Sender: TObject);
{Altitude of sun changed, redefine the base shaowcircle}
begin
  Altitude:=piDiv180*AltSpinEdt.value; {in radians}
  RecalcBaseCircle;
  paintfigure(sender);
end;

{************** RecalcbaseCircle **************}
{Define the basic "shadow circle" which changes when the sun altitude changes}
{For drawing efficiency, the effective viewing distance is also reflected
 in the basecircle values}
procedure TForm1.RecalcbaseCircle;
var
  i:integer;
  D, angle,angleInc:float;
begin
  if altitude=0 then d:=1000
  else if altitude=halfpi then d:=0
  else d:=RodHeight/tan(altitude);
  d:=distscale*d;
  angleinc:=2*pi/length(basecircle);
  angle:=0.0;
  for i:=0 to high(BaseCircle) do
  with basecircle[i] do
  begin
    x:=d*cos(angle);
    y:=d*sin(angle);
    angle:=angle+angleinc;
  end;
  recalcviewcircle;
end;

{***************** RecalcViewCircle ************}
procedure tForm1.RecalcViewCircle;
{Calculate the shadow circle}
var
  i:integer;
  sinq:float;
  d:float;
begin
    sinq:=sin(eyealt);
    i:=high(basecircle);
    {Start and end drawing ar the last point}
    with viewcircle[i] do
    begin  {Moveto to start point}
      x:=trunc(basecircle[i].x);
      y:=trunc(basecircle[i].y*sinq);
    end;

    for i:= 0 to high(basecircle) do
    with viewcircle[i] do  {lineto each point in the array}
    begin
      x:=trunc(basecircle[i].x);
      y:=trunc(basecircle[i].y*sinq);
    end;

    {Relocate saved shadow points based on eye position}
    for i:= 0 to savedptr do
    with savedshadowpoints[i], view do
    begin
      d:=distscale*dist;      {adjustment for eye distance}
      x:=trunc(d*cos(eyeaz-az+halfpi)); {adjust for eye bearing}
      y:=trunc(d*sin(eyeaz-az+halfpi)*sinq);  {sing adjusts y for eye altitude}
    end;
end;

{*************** AzSpinEdtChange ****************}
procedure TForm1.AzSpinEdtChange(Sender: TObject);
begin
  {Convert input azimuth to radians and add 180 deg for shadow direction}
  Azimuth:=-AzSpinEdt.value*PiDiv180-Pi;
  If azimuth > TwoPi then Azimuth:=Azimuth- TwoPi
  else If azimuth < -TwoPi then Azimuth:=Azimuth + TwoPi;
  If sender = AzSpinEdt then Paintfigure(Sender);
end;



{************** RodSpinEdtChange *********}
procedure TForm1.RodSpinEdtChange(Sender: TObject);
{rod length changed}
begin
  Rodheight:=RodSpinEdt.value;
  BaseRod.z:=RodSpinEdt.value; {get the new value}
  RecalcBaseCircle;
  If sender = RodSpinEdt then Paintfigure(Sender); {and redraw the image}
end;


{*************** Paintfigure **************}
procedure TForm1.PaintFigure(Sender: TObject);
var
  i:integer;
  angle:float;
  x,y,y2,dx,dy:integer;
  letterdist:float;
  sing:float;
  cosa,sina:float;
  dshadow:integer;
begin

  with paintbox1, canvas do
  begin
    brush.color:=$00B0F9B4; {light green};
    rectangle(clientrect);
    pen.color:=clblack;
    pen.width:=1;

    font.name:='Arial';
    font.size:=14;
    letterdist:=200*distscale;

    {This sin{eyealt) adjustment intended to move the letters vertically based on
     eye altitude closer to zero move the letters vertically nearer to the mid-y
     value.  Would look better if the letters themselse got distorted vertically
     as if they were being viewed in 3D from an angle}
    sing:=sin(eyealt);


    angle:= (eyeaz-halfpi);
    sina:=sin(angle);
    cosa:=cos(angle);
    setfontangle(font, -angle+halfpi);
    x:=midx-trunc(letterdist*cosa);
    y:=midy-trunc(letterdist*sina*sing);
    textout(x,y,'N');

    setfontangle(font, -angle-halfpi);
    x:=midx+trunc(letterdist*cosa);
    y:=midy+trunc(letterdist*sina*sing);
    textout(x,y,'S');

    angle:= angle-halfpi;
    sina:=sin(angle);
    cosa:=cos(angle);
    setfontangle(font, - angle+halfPi);
    x:=midx-trunc(letterdist*cosa);
    y:=midy-trunc(letterdist*sina*sing);
    textout(x,y,'W');

    setfontangle(font, -angle-halfpi);
    x:=midx+trunc(letterdist*cosa);
    y:=midy+trunc(letterdist*sina*sing);
    textout(x,y,'E');


    {Draw the circle defined by basecircle but from the eye
     postion defined by the three Eye spinedit values}

    {Start and end drawing at the last point}
    with viewcircle[high(viewcircle)] do moveto(x+midx,y+midy);  {Moveto to start point}
    for i:= 0 to high(basecircle) do
    with viewcircle[i] do  lineto(x+midx,y+midy);{lineto each point in the array}

    {Baserod}
    pen.width:=4;
    moveto(midx,midy);
    y2:=trunc(rodheight*cos(Eyealt));
    lineto(midx, midy-y2);
    {Light ray & Shadow}
    pen.width:=2;
    pen.color:=clyellow;
    {Connect the "ray" to the shadowcircle at the same fraction of the way
     around the circle as the difference between the viewing azimuth and the
     azimuth is to the full circle}
     {add 5/4 nbrpoints to start, 1/4 to account for trionometric coordinates
     assume 0 degrees is "East" not "North", extra 4/4 nbrpoints is to keep total positive}
    i:= (5*nbrpoints div 4 + trunc(nbrpoints*(eyeaz-azimuth)/twoPi)) mod nbrpoints;
    pen.width:=4;
    lineto(midx+viewcircle[i].x,midy+viewcircle[i].y);
    dshadow:=currentshadowpoint-i;
    currentshadowpoint:=i;

    pen.color:=clbtnshadow;
    lineto(midx,midy);
    {extend the ray to the edge of the screen}
    pen.Color:=clyellow;
    dx:=viewcircle[i].x;
    dy:=-y2-viewcircle[i].y{-y2};
    x:=midx; y:=midy-y2;
    moveto(x,y);
    If (dx<>0) or (dy<>0) then
    repeat
      x:=x-dx; y:=y+dy;
      lineto(x,y);
    until (x<0) or (x>width) or (y<0) or (y>height);

    {Draw the saved shadow points}
    pen.Color:=clblack;
    for i:= 0 to savedptr do
    with  savedshadowpoints[i], view do
    begin
      with view do
      ellipse(midx+x, midy+y, midx+x+1,midy+y+1);
    end;
  end;
end;

{**************** EyeSpinEdtChange ***************}
procedure TForm1.EyeSpinEdtChange(Sender: TObject);
begin
  if sender=EyeDistSpinEdt then
  begin
    EyeDist:=EyeDistSpinEdt.value;
   if eyedist>0 then  Distscale:=OrigEyeRodDist/Eyedist;
    RecalcBaseCircle;
  end
  else
  begin
    EyeAz:=EyeAzSpinEdt.value*PiDiv180;
    EyeAlt:=EyeAltSpinEdt.value*piDiv180;
    recalcViewCircle;
  end;
  if Sender is TSpinedit then Paintfigure(sender);
end;




{*************** SetFontAngle ************8}
procedure TForm1.SetFontAngle( afont:Tfont; const angle:float);
{Procedure lifted from the Internet, no attribution available.  Used to
 "rotate the N,S,E,W direction letters as the eye bearing changes}
{Input:
  afont   MUST be Truetype; NOT checked.
	Angle 	rotation angle counter clockwise in Degrees (real)
Output:
  afont  with angle.
Revisions..
	3/8/00 convert method to standalone function for general use
note, Windows font defaults to non-true-type.
}

var
		LogFont:TLOGFONT; //a Windows logical font
		SaveFont:Tfont; //copy of original canvas font (VCL font)

    //reduce angle to 0..360
    function mod360( const angle:float ):float;
    begin
            RESULT := FRAC( angle/pidiv180/360 )*360;
            if RESULT<0 then RESULT := RESULT+360;
    end;

begin
//save the canvas   font
		SaveFont := TFont.Create;
		SaveFont.Assign(aFont);

//Get the canvas  Windows Logical Font
		{The GetObject function obtains information about a specified graphics object}
		if GetObject(SaveFont.Handle,Sizeof(LogFont),@LogFont)=0 //current fontattrs
    then showmessage('SetFontAngle.GetObject='+SysErrorMessage(GetLastError)) ; //whoops
(* I don't know how to check if font is rotatable ,
  if it is not truetype, you will get an unrotated text without diagnostic. *)
//modify the logical font (but leave all other attributes unchanged)
		LogFont.lfEscapement:=ROUND(mod360(angle)*10);  //set the logical font angle in 0.1 degrees
		LogFont.lfOrientation:=LogFont.lfEscapement; //w95 says char orient must be same as escapement
		LogFont.lfOutPrecision:=OUT_TT_ONLY_PRECIS	;//choose a TrueType font, even if it must substitute another name.

//create a new Canvas font from Logical Font
		SaveFont.Handle:=CreateFontIndirect(LogFont);
		//ASSERT (SaveFont.Handle<>Null,
		//		'SetFontAngle.CreateFontIndirect err='+SysErrorMessage(GETLASTERROR));

//assign this new rotated font to the Canvas font property
		aFont.Assign(SaveFont); //set canvas to modoified font
		SaveFont.Free;//free up the work area

end; {setangle}


{************ SavePtBtnClick *************8}
procedure TForm1.SavePtBtnClick(Sender: TObject);
{Add the current shadow point to the array of saved shadow points}
var
  rx,ry,d:single;
begin
    inc(savedptr);
    if savedptr>high(savedshadowpoints)
    then setlength(savedshadowpoints,length(savedshadowpoints)+12);
    with basecircle[currentshadowpoint], savedshadowpoints[savedptr] do
    begin
      rx:=x;
      ry:=y;
      dist:=sqrt(rx*rx+ry*ry);
      az:=azimuth;  {save current azimuth so we can redraw this shadow point later}
      {View is the eyepoint adjusted data which must be recalculated for every drawing}
      d:=distscale*dist;      {adjustment for eye distance}
      view.x:=trunc(d*cos(eyeaz-az+halfpi));
      view.y:=trunc(d*sin(eyeaz-az+halfpi)*sin(eyealt));
    end;
    paintfigure(sender);
end;

{*********** ClearPtsBtn **************8}
procedure TForm1.ClearPtsBtnClick(Sender: TObject);
begin
  savedptr:=-1;
end;

{************ LoadAnalemmabtnClick ***********8}
procedure TForm1.LoadAnalemmaBtnClick(Sender: TObject);
{Load a text file of points (azimuth & altitude, one point per line)
 nominally representing an analemma whose shadow is to be displayed}
var
  f:Textfile;
  x:float;
  n:integer;
  line:string;
begin
  if opendialog1.Execute then
  begin
    assignfile(f,opendialog1.filename);
    reset(f);
    ClearPtsBtnClick(sender);
    while not eof(f) do
    begin
      readln(f,line);
      line:=trim(line);
      if (length(line)>=1) and (line[1]<>';') then
      begin
         n:=pos(' ',line);
         if n>0 then
         begin
           x:=strtofloatdef(copy(line,1,n-1),0);
           azspinedt.Value:=round(x);
           x:=strtofloatdef(copy(line,n+1,length(line)-n),0);
           altspinedt.Value:=round(x);
           SavePtbtnClick(Sender);
           update;
           sleep(500);
         end;
       end;
    end;
  end;
end;

end.
