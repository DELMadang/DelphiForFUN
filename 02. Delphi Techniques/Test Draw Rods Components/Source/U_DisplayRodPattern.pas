unit U_DisplayRodPattern;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows,SysUtils, Classes, Graphics, Controls, StdCtrls , ExtCtrls, dialogs;

type
  TRodLengths=array of integer; {Array of lengths to cut from a rod}

  {tRod class defines and can draw a 3D subdivided rod with part length labels}
  {Requires a Timage passed to the Create constructor to provide size and
   location information}
  tRod=class(TImage)
    private
      Lengths:TRodLengths;
      Cumlengths:TRodlengths;
      X:TRodlengths;
      Y,ytop,ybottom:integer;
      leftstart:integer;

    public
      hwratio:single;  {ratio of rod diameter to length }
      rodcolor,BGcolor:TColor;
      Labels:boolean; {show part lengths to be cut as text over picture}
      openleft:boolean; {Open end on left, flase= open on right}

      {create the rod object}
      constructor create(proto:TImage;newrodcolor,newbgcolor:TColor); reintroduce;

      {assign a set of rod segment lengths}
      procedure setlengths(val:TRodLengths);

      procedure draw; {draw the rod}
  end;

  {*********** TDisplayPattern ***********}
  {Uses a TPanel as the prototype for size and location.
   Class will contain 2 tLabel controls and a TRod control
   derived from a TImage. The prototype panel must contain
   a TLabel with a "P" and the first letter of it caption, that Tlabel
   becomes the prototype for a Pattern message.
   A TLabel with "N" in it first caption letter will become the prototype
   for an "Number of prices required" message.  The timage in the protoype panel
   provides prototype for the rod }

  TDisplayPattern=class(TPanel)
  private
    PatternIdLbl:Tlabel;
    NbrToCutLbl:TLabel;
  public
    rod:TRod;
    constructor create(Proto:TPanel); reintroduce;
    {Display the pattern info}
    procedure makepattern(Newlengths:TRodlengths; PatternNbrmsg, NbrcutMsg:string);
  end;


implementation


{*********** TRod.Create ********}
constructor TRod.create(proto:TImage;newrodcolor,newBGColor:TColor);
begin
  inherited create(proto.owner);
  boundsrect:=proto.boundsrect;
  parent:=proto.parent;
  (*
  with picture do
  begin
    bitmap.height:=self.height;
    bitmap.width:=self.width;
  end;
  *)
  hwratio:=0.1;
  setlength(Lengths,0);
  setlength(CumLengths,0);
  setlength(x,0);
  bgColor:=newbgColor;
  rodcolor:=Newrodcolor;
  Labels:=true;
  Openleft:=true;
end;

{************ TRod.SetLengths ********}
procedure TRod.setlengths(val:TRodlengths);
var
  i:integer;
  sum:integer;
  maxx:integer;
  scale,scaledx:single;
  yreserved:integer;
begin
  setlength(Lengths, length(val));
  setlength(CumLengths, length(val));
  setlength(X, length(val));
  {load values}
  for i:=0 to high(val) do Lengths[i]:=val[i];
  {get cumulative sums}
  sum:=0;
  for i:=0 to high(val) do
  begin
    inc(sum,Lengths[i]);
    CumLengths[i]:=sum;
  end;
  {scale lengths}
  scaledx:=9*width div 10; {reserve 90% of width for the rod}
  leftstart:=width div 20; {starting 5% in from left end}
  maxX:=CumLengths[high(CumLengths)];
  scale:=scaledx/maxx; {pixels/unit}
  Y:=trunc(scale*hwratio*maxX); {desired height}
  {calculate space for labels if requested}
  if labels then yreserved:=canvas.textheight('0')+5
  else yreserved:=5;

  if y>height-yreserved then
  begin {not enough height, rescale using height}
    y:=height-yreserved-2; {vertical space to draw the rod}
    scale:=y/(hwratio*maxx);
  end;
  {convert cumulative lengths to pixrel values for faster drawing}
  for i:= 0 to high(x) do x[i]:=leftstart+trunc(scale*CumLengths[i]);
  ytop:=yreserved+2;   {top and bottom pixel coordinates for the rod}
  ybottom:=ytop+y-2;
end;

{**************** TRod.Draw **********}
procedure TRod.draw;
var
  i:integer;
  y2:integer;
  maxx:integer;
  prev:integer;
  s:string;
begin
  y2:=y div 5;
  maxx:=x[high(x)];
  if length(x)>0 then
  with canvas do
  begin
    pen.color:=clblack;
    pen.width:=2;
    brush.color:=bgcolor;
    fillrect(clientrect);
    moveto(leftstart,ytop);
    lineto(maxx,ytop);
    moveto(leftstart,ybottom);
    lineto(maxx,ybottom);
    if openleft then
    begin
      arc(leftstart-y2,ytop,leftstart+y2,ybottom,leftstart,ytop,leftstart,ybottom);
      arc(maxx-y2,ytop,maxx+y2,ybottom,maxx,ybottom,maxx,ytop);
      brush.color:=rodcolor;
      floodfill(maxx,ytop+y div 2,clblack,fsborder);
      arc(leftstart-y2,ytop,leftstart+y2,ybottom,leftstart,ybottom,leftstart,ytop);
      for i:= 0 to high(x) do
          arc(x[i]-y2,ytop,x[i]+y2,ybottom,x[i],ybottom,x[i],ytop);
      brush.color:=cldkgray;
      floodfill(leftstart,ytop+y div 2,clblack,fsborder);
    end
    else
    begin
      arc(leftstart-y2,ytop,leftstart+y2,ybottom,leftstart,ytop,leftstart,ybottom);
      arc(maxx-y2,ytop,maxx+y2,ybottom,maxx,ybottom,maxx,ytop);
      brush.color:=rodcolor;
      floodfill(leftstart,ytop+y div 2,clblack,fsborder);
      for i:= 0 to high(x) do
          arc(x[i]-y2,ytop,x[i]+y2,ybottom,x[i],ytop,x[i],ybottom);
      brush.color:=ClLtgray;
      floodfill(maxx,ytop+y div 2,clblack,fsborder);
    end;
    brush.color:=bgcolor;
    if labels then
    begin
      prev:=leftstart;
      for i:=0 to high(x) do
      begin
        s:=inttostr(lengths[i]);
        textout((prev+x[i]-textwidth(s)) div 2,5,s);
        prev:=x[i];
      end;
    end;
  end;
end;

{*************** TDisplayPattern.create *********}
 constructor TDisplaypattern.create(Proto:TPanel);
 var
   i:integer;
   Lbl:Tlabel;
 begin
   inherited create(proto.owner);
   boundsrect:=proto.boundsrect;
   parent:=proto.parent;
   color:=proto.color;

   for i:=0 to proto.controlcount-1 do
   with proto.controls[i] do
   if proto.controls[i] is Tlabel then
   begin
     with TLabel(proto.controls[i]) do
     if (caption[1]='P') or (name[1]='P') then
     begin
       Lbl:=TLabel(proto.controls[i]);
       PatternIdLbl:=TLabel.create(proto.owner{nil});
       With PatternIdlbl do
       begin
         boundsrect:=Lbl.boundsrect;
         parent:=self;
       end;
     end
     else
     with TLabel(proto.controls[i]) do
     if (caption[1]='N') or (name[1]='N') then
     begin
       Lbl:=TLabel(proto.controls[i]);
       NbrToCutLbl:=TLabel.create(proto.owner{nil}{self});
       With NbrToCutLbl do
       begin
         boundsrect:=Lbl.boundsrect;
         parent:=self;
       end;
     end;
   end
   else if proto.controls[i] is TImage then
   begin
     rod:=TRod.create(TImage(proto.controls[i]),clSilver, color);
     rod.parent:=self;{oops, prototype panel can't be the parent for our rod}
   end;
   if not (assigned(rod) and assigned(PatternIdLbl) and assigned(NbrToCutLbl))
   then showmessage('TPatternDisplay creation failed: Prototype panel must contain '
   +'a TImage and 2 TLabel controls, one with caption or name beginning with "P" '
   +' the other with "N"');
 end;
 (*
 destructor TDisplayPattern.free;
 begin
   {
   rod.free;
   rod:=nil;
   patternidLbl.free;
   patternIdlbl:=nil;
   nbrtocutLbl.free;
   nbrtocutlbl:=nil;
   }
   inherited free;
 end;
 *)


 {*********** MakePattern ***********}
 procedure TDisplayPattern.makepattern(
                   Newlengths:TRodlengths; PatternNbrmsg, NbrcutMsg:string);
 {Display the pattern from lengths array and label info}
 begin

   patternIdLbl.caption:=PatternNbrMsg;
   NbrtoCutLbl.caption:=NbrCutmsg;
   rod.setlengths(Newlengths);
   rod.draw;

 end;

end.
