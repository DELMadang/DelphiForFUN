unit U_Scale2;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface
  uses Windows, classes, controls, comctrls, stdctrls, extctrls, graphics;

  type
  TOnCountWeighing=procedure(w:integer) of object;{exit called whenever scale make a weighing}

  TScale=class(Timage) {Simple animation of balance beam scale}
    {This is a specialized counterfeit scale that automatically weighs when the
     number of coins in each scale is equal.  A more generalized version would
     need something like "LockBeam" and "ReleaseBeam" methods to control weighings}
    private
      theta:real; {<0 => left pan heavy, 0 => balanced, >0 => right pan heavy}
      basetriangle:array[1..3] of tpoint; {Scale base points}
      {dialrect:Trect;}{future dial image}
      
      pan1tip,pan2tip:TPoint; {Current pan strings support points}
      halfbeam:integer; {length of beam from support point to end}
     
      leftweight, rightweight:integer; {total weight currently in each pan}
      onbalanced: procedure of object; {Callback to owner when scale is balanced}
    public
       leftweights,rightweights:TList; {list of known weights currently in each pan}
       pan1rect, pan2rect:Trect; {rectangle for current pan images}
      oncountweighing:TOnCOuntweighing;
      weighings:integer;
      constructor create(owner:TCOmponent); reintroduce;
      procedure drawbase;
      procedure drawpan(var rr:Trect; p:TPoint; T:Tlist);
      Procedure drawbeam(angle:real);
      procedure drawscale(newangle:integer);
      procedure setsize(r:TRect);
      procedure myDragOver(Sender, Source: TObject; X, Y: Integer;
                   State: TDragState; var Accept: Boolean); reintroduce;
      procedure myDragDrop(Sender, Source: TObject; X, Y: Integer); reintroduce;
      procedure addweight(p:TstaticText);
      procedure removeweight(p:TStaticText; draw:boolean);
      function  sumweights(T:Tlist):integer;
  end;

implementation

{***************************************}
{********* TScale Methods **************}
{***************************************}


constructor TScale.create(owner:TComponent);
begin
  inherited;
  leftweights:=TList.Create;
  rightweights:=TList.create;
  parent:=twincontrol(owner);
  onbalanced:=nil;
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
  //if newangle*theta<=0 then
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
  if (leftweight=rightweight) and  (leftweight<>0) and (assigned(onbalanced))
  then onbalanced;
end;

{**************** MyDragOver **************}
procedure TScale.MyDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{Yeah, we'll take it}
begin   accept:=true;  end;

{**************** MyDragDrop *****************}
procedure TScale.MyDragDrop(Sender, Source: TObject; X, Y: Integer);
{User dropped a coin on the scale, pan used depends on coin & location,
 position on pan depends on whether it is the unknown weight or how many
 known weights are already in the pan}
begin
  if source is tstatictext then
  with source as TStatictext do
  begin
    {known weight - place weights on inside of pan}
    if x>(self.width div 2) {dropping on right side of scale} then
    begin  {center coin in the right pan}
      left:=self.left+pan2rect.left+(pan2rect.right-pan2rect.left-width) div 2;
      {and on top of existing stack already on the pan}
      top:=self.top+pan2rect.bottom
           -(rightweights.count+1)*TStatictext(source).height-1;
   end
   else
   begin
     {Center coin in the left pan}
     left:=self.left+pan1rect.left+(pan1rect.right-pan1rect.left-width) div 2;

     top:=self.top+pan1rect.bottom

          -(leftweights.count+1)*TStatictext(source).height-1;
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
  for i:= 0 to t.count-1 do result:=result+TStatictext(t[i]).tag div 100;
end;

{************ AddWeight **********}
procedure TScale.addweight(p:TStaticText);
begin
  removeweight(p, false); {in case it's in left or right list already}
  {If weight is in the left half of scale image}
  if (p.left<left+width div 2) then
  begin
    leftweights.add(p);
    leftweight:=sumweights(leftweights)
  end
  else
  begin
    rightweights.add(p);
    rightweight:=sumweights(rightweights);
  end;
  if  leftweights.count=rightweights.count then
  begin
    inc(weighings);
    if assigned(OnCountWeighing) then OnCountweighing(weighings);
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
  index:=leftweights.indexof(p);
  if index>=0 then
  begin
    leftweights.delete(index);
    for i:=index to leftweights.count-1 do {move rest of weights back}
    with  Tstatictext(leftweights[i]) do top:=top+height+1; //left:=left+width+2;
    leftweight:=sumweights(leftweights);
  end
  else
  begin
    index:=rightweights.indexof(p);
    if index>=0 then
    begin
      rightweights.delete(index);
      for i:=index to rightweights.count-1 do {move rest of weights back}
      with  Tstatictext(rightweights[i]) do top:=top+height+1;
      rightweight:=sumweights(rightweights);
    end;
  end;
  if draw and (index>=0) then
  begin
    if (leftweights.count>0) and (leftweights.count=rightweights.count) then
    begin
      inc(weighings);
      if assigned(OnCountWeighing) then OnCountweighing(weighings);
    end;
    if leftweight>rightweight then drawscale(-1)
    else if leftweight=rightweight then
    begin
      drawscale(0);
    end
    else drawscale(+1);
  end;
end;




{************** End of TScale Methods *******}

end.
