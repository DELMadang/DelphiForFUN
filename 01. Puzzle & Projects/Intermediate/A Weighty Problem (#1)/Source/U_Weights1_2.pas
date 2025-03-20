unit U_Weights1_2;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Draws a simple animated balance beam sv=cale and allow the user to procrive
"weighing" object of unknown weight by dragging the unknown weight one pan
of a scale and then draggin known weights on either pan under the scale balances.}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls;

type

  TScale=class(Timage) {Simple animation of balance beam scale}
    private
      theta:real; {<0 => left pan heavy, 0 => balanced, >0 => right pan heavy}
      basetriangle:array[1..3] of tpoint; {Scale base points}
      {dialrect:Trect;}{future dial image}
      pan1rect, pan2rect:Trect; {rectangle for current pan images}
      pan1tip,pan2tip:TPoint; {Current pan strings support points}
      halfbeam:integer; {length of beam from support point to end}
      leftweights,rightweights:TList; {list of known weights currently in each pan}
      leftweight, rightweight:integer; {total weight currently in each pan}
      leftunknown, rightunknown:Tstatictext; {location of unknown weight}
      onbalanced: procedure of object; {Callback to owner when scale is balanced}
      constructor create(owner:TCOmponent);
      procedure drawbase;
      procedure drawpan(var rr:Trect; p:TPoint; T:Tlist);
      Procedure drawbeam(angle:real);
      procedure drawscale(newangle:integer);
      procedure setsize(r:TRect);
      procedure DragOver(Sender, Source: TObject; X, Y: Integer;
                         State: TDragState; var Accept: Boolean);
      procedure DragDrop(Sender, Source: TObject; X, Y: Integer);
      procedure addweight(p:TstaticText);
      procedure removeweight(p:TStaticText; draw:boolean);
      function  sumweights(T:Tlist):integer;
      procedure recalcweights(draw:boolean);

  end;

  TForm2 = class(TForm)
    Memo1: TMemo;
    Image1: TImage;
    W1: TStaticText;
    Unknownweight: TStaticText;
    W2: TStaticText;
    UnknownWeightBtn: TButton;
    W3: TStaticText;
    W4: TStaticText;
    W5: TStaticText;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure WeightDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure WeightDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure UnknownWeightBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    nbrweights:integer;
    maxw:integer;
    scale:TScale;
    startw1, startunk:TPoint; {original locations for reset time}
    procedure balanced; {called when scale is balanced}
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}
uses math;

constructor TScale.create(owner:TComponent);
begin
  inherited;
  ondragover:=Dragover;
  onDragDrop:=DragDrop;
  leftweights:=TList.Create;
  rightweights:=TList.create;
  parent:=twincontrol(owner);
end;


{***************** SetSize ***************}
procedure TScale.setsize(r:Trect);
var  beamrect:TRect;
begin
  left:=r.left;
  top:=r.top;
  width:=r.right-r.left;
  height:=r.bottom-r.top;
  {with dialrect do  }  {future dial image}
  theta:=0;
  with basetriangle[1] do {define the base}
  begin
    x:=(width) div 2;
    y:=(height) div 3;
  end;
   with basetriangle[2] do
  begin
    x:=width div 3;
    y:=height-2;
  end;
   with basetriangle[3] do
  begin
    x:=2*(width div 3);
    y:=height-2;
  end;
  {Define the pans}
  pan1rect:=rect(0,0,width div 3, height div 3);
  pan2rect:=rect(0,0,width div 3, height div 3);
  {Define the beam, pans attach to ends of beam}
  beamrect:=rect(width div 5,basetriangle[1].y,
                 width-width div 5, basetriangle[1].y);
  pan1tip:=point(beamrect.left,beamrect.bottom);
  pan2tip:=point(beamrect.right,beamrect.bottom);
  halfbeam:=(beamrect.right-beamrect.left) div 2;
  rightunknown:=nil; leftunknown:=nil ;
  rightweights.clear; leftweights.clear;
  rightweight:=0; leftweight:=0;
end;

{************** DrawPan ***************}
procedure TScale.drawpan(var rr:Trect; P:TPoint; T:Tlist);
{Draw a pan defined by rectangle "rr" with with the top at point "P"
 We need a list, "T",  of associated weights so we can move then also}
var dx,dy,i:integer;
begin
  {get x and y move increments}
  dx:=p.x - ((rr.right+rr.left) div 2);
  dy:=p.y - rr.top;
  with rr do
  begin
    left:=left+dx;
    right:=right+dx;
    top:=top+dy;
    bottom:=bottom+dy;
  end;
  with canvas do {redraw the pan (and support strings)}
  begin
    pen.width:=3;
    moveto(rr.left,rr.bottom-10);
    lineto(rr.left+10, rr.bottom);
    lineto(rr.right-10, rr.bottom);
    lineto(rr.right,rr.bottom-10);
    pen.width:=1;
    lineto((rr.left+rr.right) div 2, rr.top);
    lineto(rr.left,rr.bottom-10);
  end;
  for i:=0 to t.count-1 do {now relocate the weights}
  with tstatictext(t[i]) do
  begin
    left:=left+dx;
    top:=top+dy;
  end;
  if (T=leftweights) and (leftunknown<>nil) then
  with leftunknown do
  begin
    left:=left+dx;
    top:=top+dy;
  end
  else
  if (T=rightweights) and (rightunknown<>nil) then
  with rightunknown do
  begin
    rightunknown.left:=rightunknown.left+dx;
    rightunknown.top:=rightunknown.top+dy;
  end;
end;

{**************** DrawBase ***********}
procedure TScale.drawbase;
{Draw the base of the scale **********}
var
 i:integer;
begin
  with canvas  do
  begin
    pen.width:=2;
    with basetriangle[3] do moveto(x,y);
    for i:=1 to 3 do  with basetriangle[i] do lineto(x,y);
    brush.color:=clLime;
    with basetriangle[1] do floodfill(x,y+5,clblack,fsborder);
    brush.color:=clwhite;
  end;
end;

{*************** DrawBeam *****************}
Procedure Tscale.drawbeam(angle:real);
{Draw the beam at the specified angle}
var
  rr:array[1..2] of tpoint;
begin
  rr[1].x:=trunc(basetriangle[1].x-halfbeam*cos(angle));
  rr[1].y:=trunc(basetriangle[1].y-halfbeam*sin(angle));
  rr[2].x:=trunc(basetriangle[1].x+halfbeam*cos(angle));
  rr[2].y:=trunc(basetriangle[1].y+halfbeam*sin(angle));
  with canvas do
  begin
    pen.width:=5;
    moveto(rr[1].x, rr[1].y);
    lineto(rr[2].x, rr[2].y);
  end;
  pan1tip:=rr[1];
  pan2tip:=rr[2];
end;

{**************** DrawScale ****************}
procedure TScale.drawscale(newangle:integer);
{Draw beam at specified angle, donp;t forget to move the pans and the
 weights in the pans also.  We'll make the move in about a second,
 10 steps with 1/10 second delay for each step}
var
  incr:real;
  i:integer;
  a:real;
begin
  if newangle*theta<=0 then
  begin
    a:=(newangle*pi/15.0);  {tilt 12 degrees}
    incr:=(a-theta)/10.0;
    for i := 1 to 10 do
    begin
      canvas.fillrect(clientrect);
      drawbase;
      drawbeam(theta+i*incr);
      drawpan(pan1rect,pan1tip,leftweights);
      drawpan(pan2rect,pan2tip,rightweights);
      sleep(100);
      update;
    end;
    theta:=a;
  end;
  if (leftweight=rightweight) and  (leftweight<>0) then onbalanced;
end;

{**************** DragOver **************}
procedure TScale.DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{Yeah, we'll take it}
begin   accept:=true;  end;

{******************* DragDrop *****************}
procedure TScale.DragDrop(Sender, Source: TObject; X, Y: Integer);
{User dropped a weight on the scale, pan used depends on weight x location,
 position on pan depends on whether it is the unknown weight or how many
 known weights are already in the pan}
begin
  if source is tstatictext then
  with source as TStatictext do
  begin
    if name[1]='U' then {unknown weight - place on outside of pan}
    begin
      if x>(self.width div 2) {drop on right side} then
      begin
        {left side at right of pan - 10 for pan lip-width of weight+scale image.left}
        left:=pan2rect.right-10-width+self.left;
        {top at pan bottom-weight height- 2 pixels to set on top of pan bottom}
        top:=pan2rect.bottom-height+self.top-2;
      end
      else
      begin {unknown on left pan}
        left:=pan1rect.left+10+self.left;;
        top:=pan1rect.bottom-height+self.top-2;
      end;
    end
    else
    begin {known weight - place weights on inside of pan}
      if x>(self.width div 2) {drop on right side} then
      begin
        left:=pan2rect.left+10+self.left+rightweights.count*(width+2); ;
        top:=pan2rect.bottom-height+self.top-2;
      end
      else
      begin
        left:=pan1rect.right-10-width+self.left-leftweights.count*(width+2);
        top:=pan1rect.bottom-height+self.top-2;
      end;
    end;
    bringtofront;
    addweight(TStatictext(source));
  end;
end;

{*************** SumWeights ***********}
function TScale.sumweights(T:Tlist):integer;
{Add up weights in a weight list, weight values are kept in the "tag" property}
var i:integer;
begin
  result:=0;
  for i:= 0 to t.count-1 do result:=result+TStatictext(t[i]).tag;
  if (T=rightweights) and (rightunknown<>nil) then result:=result+rightunknown.tag
  else
  if (T=leftweights) and (leftunknown<>nil) then result:=result+leftunknown.tag
end;

{************ AddWeight **********}
procedure TScale.addweight(p:TStaticText);
begin
  removeweight(p, false); {in case it's in left or right list already}

  if (p.left>left) then
  {If weight is in the left half of scale image}
  if (p.left<left+width div 2) then
  begin
    if p.name[1]<>'U' {Unknown} then leftweights.add(p) else leftunknown:=p;
    leftweight:=sumweights(leftweights)
  end
  else if (p.left<left+width) then
  begin
    if p.name[1]<>'U' {Unknown} then rightweights.add(p) else rightunknown:=p;
    rightweight:=sumweights(rightweights);
  end;
  {redraw the  scale image}
  if leftweight>rightweight then drawscale(-1)
    else if leftweight=rightweight then
    begin
     drawscale(0);
     {if (leftweight<>0)  then onbalanced;}
    end
    else drawscale(+1);

end;

{****************** RemoveWeight *******************}
procedure TScale.removeweight(p:tStaticText; draw:boolean);
{If a weight is in either right or left list of weights, remove it
 and redraw the scale if requested (variable "draw" is true) }
var i, index:integer;
begin
  if p.name[1]='U' then {Unknownweight?}
  begin
    leftunknown:=nil;
    rightunknown:=nil;
    recalcWeights(false);
  end
  else
  begin
    index:=leftweights.indexof(p);
    if index>=0 then
    begin
      leftweights.delete(index);
      for i:=index to leftweights.count-1 do {move rest of weights back}
        with  Tstatictext(leftweights[i]) do left:=left+width+2;
      leftweight:=sumweights(leftweights);
    end
    else
    begin
      index:=rightweights.indexof(p);
      if index>=0 then
      begin
        rightweights.delete(index);
        for i:=index to rightweights.count-1 do {move rest of weights back}
        with  Tstatictext(rightweights[i]) do left:=left-width-2;
        rightweight:=sumweights(rightweights);
      end;
    end;
  end;
  if draw then
  begin
    if leftweight>rightweight then drawscale(-1)
    else if leftweight=rightweight then
    begin
      drawscale(0);
      {if  (leftweight<>0) then onbalanced;}
    end
    else drawscale(+1);
  end;
end;

{**************** RecalcWeights *************}
Procedure tscale.recalcweights(draw:boolean);
{Used in case weights change and we needd to redraw scale}
begin
  leftweight:=sumweights(Leftweights);
  rightweight:=sumweights(rightweights);
  if draw then
  if leftweight>rightweight then drawscale(-1)
    else if leftweight=rightweight then drawscale(0)
    else drawscale(+1);
end;

{************** End of TScale Methods *******}


{********************************************}
{********** Form Routines *******************}
{********************************************}
{****************** FormCreate *************}
procedure TForm2.FormCreate(Sender: TObject);
{Create the Tscale object ***********}
begin
  scale:=TScale.create(self);
  scale.onbalanced:=balanced;{callback to this procedure when scale is  balanced}
  doublebuffered:=true;
  startw1:=point(w1.left, w1.top);
  startunk:=point(unknownweight.left, unknownweight.top);
  randomize;
end;

{**************** FormActivate **************}
procedure TForm2.FormActivate(Sender: TObject);
{Hide unneeded weights and draw initila scale image}
begin
  scale.setsize(image1.boundsrect);
  if nbrweights<5 then w5.visible:=false else w5.visible:=true;
  if nbrweights<4 then w4.visible:=false else w4.visible:=true;
  if nbrweights<3 then w3.visible:=false else w3.visible:=true;
  if nbrweights<2 then w2.visible:=false else w2.visible:=true;
  w1.left:=startw1.x; w1.top:=startw1.y;
  w2.left:=w1.left+42; w2.top:=w1.top;
  w3.left:=w2.left+42; w3.top:=w1.top;
  w4.left:=w3.left+42; w4.top:=w1.top;
  w5.left:=w4.left+42; w5.top:=w1.top;
  unknownweight.left:=startunk.x; unknownweight.top:=startunk.y;
  maxw:=trunc((intpower(3,nbrweights)-1)/2);
  unknownweightbtnclick(sender);
  scale.drawscale(0);
end;

{**************** WeightDragOver ************}
procedure TForm2.WeightDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
{Small moves look like we're dropping on ourself}
begin   accept:=true; end;

{**************** WeightDragDrop ***************}
procedure TForm2.WeightDragDrop(Sender, Source: TObject; X,
  Y: Integer);
{Treat drop on ourself as dropping on the scale if we are over the scale,
 otherwise just update position coordinates}
begin
  if source is TStatictext then with TStatictext(source) do
  if sender is tstatictext then
  begin
    left:=left+x;
    top:=top+y;
    {if we dropped it on itself, but we are over the scale image,
    count it a dropping on the scale}
    if (left>scale.left) and (left<scale.left+scale.width)
        and (top>scale.top) and (top<scale.top+scale.height)
    then scale.addweight(tstatictext(source));
  end
  else if sender is tform then
  begin
    left:=x;
    top:=y;
    scale.removeweight(TStatictext(source),true);{in case it moved from scale to form}
  end;
end;

{**************** UnknownWeightBtn ************}
procedure TForm2.UnknownWeightBtnClick(Sender: TObject);
{geneate a new unknown weight}
begin
  unknownweight.tag:=random(maxw)+1;
  unknownweight.caption:='?';

  unknownweight.color:=(64+random(192)) shl 16+ (64+random(192)) shl 8
                       + (64+random(192));
  scale.recalcweights(true);                     
end;

Procedure TForm2.balanced;
{Called from scale object when the scale is balanced}
begin
  unknownweight.caption:=inttostr(unknownweight.tag);
  showmessage('Yes!  The veil of ignorance has once again been lifted through your '
               +'skill and perseverance!');
end;


end.
