unit U_IntersectingCircleCenters;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
  -----Original Message-----
From: bounce@easycgi.com [mailto:bounce@easycgi.com]
Sent: Wednesday, August 29, 2012 4:47 PM
To: feedback@delphiforfun.org
Subject: Intersecting circle coordinates

*******************************************************************************
Intersecting circle coordinates
XXXXXXXXXX
michael.XXXXXX@XXXXXXXXX.com
ContactRequested
Wednesday, August 29, 2012
04:47 PM

Hello and thank you for the great webpage! Question: is there a formula to determine the X,Y coordinates of two intersecting circles when you know:
+ the area of circle A (or radius)
+ the area of circle B (or radius)
+ the area of the intersection
Assume:
+ center of circle A = (0,0)
+ center of circle B = (x1,0) (i.e. on same plane)
+ 0 < radius(A) < x1 (meaning circle B is not inside circle A)
Thanks for your consideration!
*)

{Given A=area of intersection and
       r1, R2 = radii of thw two circles
       find d= the distance between the two circle centers}

{
A= sqr(r1)*arccos((sqr(d)+sqr(r1)-sqr(R2))/(2*d*r1))
         + sqr(R2)*arccos((sqr(d)+sqr(R2)-sqr(r1))/(2*d*R2))
         - -.5*sqrt((-d+r1+R2)*(d+r1-R2)*(d-r1+R2)*(d+r1+R2));
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    R1Btn: TRadioButton;
    DistBtn: TRadioButton;
    AreaBtn: TRadioButton;
    R2Btn: TRadioButton;
    AreaEdt: TEdit;
    DistEdt: TEdit;
    R1Edt: TEdit;
    R2Edt: TEdit;
    Image1: TImage;
    ResolutionGrp: TRadioGroup;
    AnimateBox: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    procedure RadioBtnClick(Sender: TObject);
    procedure ResolutionGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    scale:extended;
    offsetx,offsety, midLiney:integer;
    oldr1,oldr2,oldDist:string;
    decimals:integer;
    procedure calculate;
    procedure Setscale(r1,r2,d:extended);
    procedure drawcircles(r1,r2,d:extended);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

var   resolution:extended=0.001;

{---------- GetArea -------------}
function GetArea(const r1,r2,d:extended):extended;
var
  part1,part2:extended;
begin
  if d<= abs(r1-r2) then result:=Pi*sqr(min(r1,r2))
  else if (r1=0) or (r2=0) then result:=0
  else if (-d+r1+R2)*(d+r1-R2)*(d-r1+R2)<=0 then result:=0
  else
  begin
    part1:=(d*d+r1*r1-r2*r2)/(2*d*r1);
    part2:=(d*d-r1*r1+r2*r2)/(2*d*r2);
    if (abs(Part1)>1) or (abs(Part2)>1) then result:=Pi*sqr(min(r1,r2))
    else result :=  r1*r1*arccos(part1)
                  + r2*r2*arccos(Part2)
                  - 0.5*sqrt((-d+r1+R2)*(d+r1-R2)*(d-r1+R2)*(d+r1+R2));
  end;
end;


{************** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  resolutiongrpclick(sender);{ser initial resolution}
end;

{**************** ResolutionGrpClick *************}
procedure TForm1.ResolutionGrpClick(Sender: TObject);
{set resolutions based on click item in the Resolution radio group}
begin
  with ResolutionGrp do
  begin
    resolution:=strtofloat(items[itemindex]);
    decimals:=itemindex+1;
  end;
end;

{************* Setscale **********}
procedure TForm1.Setscale(r1,r2,d:extended);
{Set scaling for drawing the circles with the given radii and spacing}
var
  scalex,scaley:extended;
begin
  with image1 do
  begin
    scaley:=0.4*height/(max(r1,r2));
    scalex:=0.4*width/(r1+r2);
    scale:=min(scalex, scaley);
    offsety:=trunc(0.1*height);
    offsetx:=trunc(0.1*width);
    midliney:=height div 2;
  end;
end;

{*********** DrawCircles ****************}
procedure TForm1.drawcircles(r1,r2,d:extended);
{Draw circles of radii r1 and r2 with centers at distance d from each other}
var
  dr1,dr2,cxr1,cxr2:integer;
begin
  with image1,canvas do
  begin
    brush.color:=clwhite;
    brush.style:=BsSolid;
    rectangle(0,0,width,height);
    brush.style:=bsClear;
    pen.color:=clblack;
    dr1:=trunc(scale*r1);
    if dr1>midliney then setscale(r1,r2,d);
    dr2:=trunc(scale*r2);
    cxr1:=offsetx+trunc(scale*r1);
    cxr2:=offsetx+trunc(scale*(r1+d));
    ellipse(offsetx, midliney-dr1,
            cxr1+dr1, {offsetx+trunc(2*scale*r1),} midliney+dr1);
    ellipse(cxr2-dr2, midliney-dr2,
            cxr2+dr2, midliney + dr2);

    moveto(cxr1,midliney);
    lineto(cxr2,midliney);
    pen.color:=clred;
    ellipse(cxr1-3, midliney-3, cxr1+3, midliney+3);
    ellipse(cxr2-3, midliney-3, cxr2+3, midliney+3);
    update;
  end;
end;

{************ RadioBtnClick ************8}
procedure TForm1.RadioBtnClick(Sender: TObject);
{User clicked a button to calculate the assoiated parameter}
begin
  if not  TRadioButton(sender).checked then exit;
  oldR1:=r1edt.text;
  oldR2:=r2edt.text;
  OldDist:=Distedt.text;
  if sender = r1btn then r1edt.Text:='???'
  else if sender = r2btn then r2edt.Text:='???'
  else if sender = distbtn then distedt.text:='???'
  else areaedt.Text:='???';
  calculate;
  with TRadiobutton(sender) do
  begin
    onclick:=nil;
    checked:=false;
    application.processmessages;
    onclick:=RadioBtnClick;
  end;
end;

{************* Calculate ***********}
procedure TForm1.Calculate;
{perform the calculation of area of intersection, radius1, radius2 or center distance}
var
  r1,r2,d,Area:extended;
  r,x:extended;
  TestArea, diff, errordiff:extended;

         procedure embeddedError; {report unsolvable cases}
           begin
              x:=-1;
              Showmessage('No solution');
              If R1Btn.Checked then
              begin
                R2Edt.text:=floattostr(r);
                r1btn.checked:=false;
              end
              else
              begin
                R1Edt.text:=floattostr(r);
                r2btn.checked:=false;
              end;
            end;

    {-------------- Getsize -------------}
    function Getsize(r,d,area:extended; draw:boolean):extended;
    {compute a radius when that is the unknown}
    {a separate function because it is calulated twice - once to determine
     the solution and the appropriate scaling factor for drawing, and
     a second time to animate the solution.}
    var
      maxa, maxx:extended;
      testArea, diff, errordiff:extended;
      Tempresolution:extended;
    begin
      result:=-1;
      if (d<=r) then
      begin
        x:=r-d;
        if (area<=Pi*sqr(r-d)) then  tempresolution:=-resolution
        else  tempresolution:=+resolution;
      end
      else
      if d>=r then
      begin
        maxa:=pi*r*r;
        if area>maxa then {no solution}
        begin
          embeddederror;
          result:=x;
          exit;
        end
        else
        begin
          x:=d-r;
          tempresolution:= resolution;
        end;
      end
      else {d<r}
      begin
        maxa:=pi*r*r;
        if area>maxa then {no solution}
        begin
          embeddederror;
          exit;
        end
        else
        begin
          x:=d-r;
          tempresolution:= resolution;
        end;
      end;
      if x<0 then exit; {there was an error, so exit}
      errordiff:=1e6;
      maxx:=d+r;
      repeat
        testarea:=roundto(GetArea(r,x,d),-decimals); {intersection area for current guess}
        diff:=abs(testarea-area); {error value to be minimized}
        if  diff<=errordiff then
        begin
          errordiff:=diff; {a new minimum error}
          x:=x+tempresolution;
          testarea:=roundto(GetArea(r,x,d),-decimals); {intersection area for current guess}
          diff:=abs(testarea-area); {error value to be minimized}
          if animatebox.Checked and draw then
          begin
            If r1btn.checked then drawcircles(x,r,d)
            else drawcircles(r,x,d);
            application.processmessages;
          end;
        end;
      {loop until area difference starts increasing}
      until  (diff<1e-6) or (x>maxx) or (diff>errordiff);
      if (x<maxx) then
      begin
        if diff<1e-1 then result:=x  else result:=x -tempresolution;
      end
      else result:=-1;
    end;

    function valid(s:string):boolean;
    begin
      result:=strtofloatdef(s,0.0+high(int64))<> 0.0+high(int64);
    end;

    function validnumbers:boolean;
    begin
      result:= (areabtn.checked or valid(areaedt.text));
      if result then result:= (distbtn.checked or valid(distedt.text));
      if result then result:= (r1btn.checked or valid(r1edt.text));
      if result then result:= (r2btn.checked or valid(r2edt.text));
    end;

begin
  {initialize runtime measurement used to control re-drawing frequency}
  if not validnumbers  then exit;
  {AREA Calc}
  If AreaBtn.checked then
  begin {Area input are is empty or has "?"}
    r1:=strtofloat(R1Edt.text);  {convert text input to  numeric values}
    r2:=strtofloat(R2Edt.text);
    d:=strtofloat(distEdt.text);
    setscale(r1,r2,d);
    drawcircles(r1,r2,d);
    area:=GetArea(r1,r2,d);  {calculate the intersection area}
    areaEdt.text:=format('%6.*f',[decimals,Area]);     {Display the result}
  end
  else
  {DISTANCE Calc}
  If DistBtn.Checked then
  begin  {Calculate distance between centers}
    r1:=strtofloat(R1Edt.text); {convert text input to  numeric values}
    r2:=strtofloat(R2Edt.text);
    Area:=strtofloat(AreaEdt.text);
    d:=abs(r1-r2);     {Initial guess is the larger of the two radii}
    errordiff:=Pi*sqr(min(r1,r2))+0.001; {Largest error would be less than the
                           area of the largest intersection area plus a little}
    setscale(r1,r2,d);

    testarea:=GetArea(r1,r2,d); {get trial area for this distance}
    if testarea>=area then
    begin
      repeat
        testarea:=GetArea(r1,r2,d); {get trial area for this distance}
        //if testarea<area then d:=r1+r2+2*resolution;
        diff:=abs(testarea-area); {error}
        if diff<=errordiff then
        begin
          errordiff:=diff;    {save the new smaller error}
          d:=d+resolution; {get the next test distance}
          if animatebox.Checked then
          begin
            drawcircles(r1,r2,d);
            application.processmessages;
          end;
        end;
        {loop until distance exceeds max or difference starts increasing}
      until (diff>errordiff);
      d:=d-resolution; {back out the last increment}
      drawcircles(r1,r2,d);
      distEdt.text:=format('%6.*f',[decimals,d]); {Display distance result}
    end
    else
    begin
      distEdt.text:=oldDist; {display previous distance result}
      showmessage('No solution found');
    end;
  end
  else
  {RADIUS Calc}
  begin  {it had better be r1 or R2}
    d:=strtofloat(DistEdt.text);
    Area:=strtofloat(AreaEdt.text);
    If R1Btn.Checked then r:=strtofloat(R2Edt.text)
    else r:=strtofloat(R1Edt.text);

    x:=Getsize(r,d,area,false);
    if x<0 then exit;  {error, exit}
    setscale(x,r,d);

    if animatebox.Checked then x:=Getsize(r,d,area,true);{recalculate just to draw scaled images}

    if R1Btn.Checked  then
    begin
      R1Edt.text:=format('%6.*f',[decimals,x]); {Display distance result}
      drawcircles(x,r,d);
    end
    else
    begin
      R2Edt.text:=format('%6.*f',[decimals,x]); {Display distance result}
      drawcircles(r,x,d);
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
