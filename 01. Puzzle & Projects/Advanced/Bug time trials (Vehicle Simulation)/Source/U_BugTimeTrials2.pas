unit U_BugTimeTrials2;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ComCtrls, ShellAPI, UCountDownTimer;

type


  TForm1 = class(TForm)
    Head: TShape;
    ResetBtn: TButton;
    Label11: TLabel;
    VBar: TTrackBar;
    Label1: TLabel;
    AngleBar: TTrackBar;
    VLabel: TLabel;
    ALabel: TLabel;
    Memo1: TMemo;
    Body: TShape;
    Shape4: TShape;
    Shape3: TShape;
    Shape8: TShape;
    Shape7: TShape;
    Shape9: TShape;
    Shape10: TShape;
    StartLbl: TLabel;
    EndLbl: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape5: TShape;
    Shape6: TShape;
    StartBtn: TButton;
    Panel1: TPanel;
    StaticText1: TStaticText;
    DistanceLbl: TLabel;
    MsgLbl: TLabel;
    BugSizeGrp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormResize(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure BugSizeGrpClick(Sender: TObject);
  public
    { Public declarations }
    start1x,start1y:integer;
    start2x,start2y:integer;
    theta,radius:extended;
    turnIncrement, speedIncrement:integer;
    SaveV, SaveA:integer;
    circlerect:Trect;
    oldwidth,oldheight:integer;
    shapes:array[1..12] of TShape;
    cs:array[1..12] of tpoint;  {centers of shapes}
    Drawpath, erasepath:boolean;
    Timer:TCountDown;
    origHead, OrigBody:TRect;
    procedure Showpath;
    procedure startrun;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math, UGeometry;

{************ FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  doublebuffered:=true;
  with body do origbody:=rect(left,top,width,height);
  with head do orighead:=rect(left,top,width,height);
  {scale bug}
  BugSizeGrpClick(sender);
  shapes[1]:=shape1;
  shapes[2]:=shape2;
  shapes[3]:=shape3;
  shapes[4]:=shape4;
  shapes[5]:=shape5;
  shapes[6]:=shape6;
  shapes[7]:=shape7;
  shapes[8]:=shape8;
  shapes[9]:=shape9;
  shapes[10]:=shape10;
  shapes[11]:=body;
  shapes[12]:=HEAD;
  for i:= 1 to 12 do
  with cs[i], shapes[i] do
  begin
    x:=left+width div 2;
    y:=top+ height div 2;
  end;
  oldwidth:=width;
  oldheight:=height;
  drawpath:=false;
  Timer:=TCountdown.create(Panel1);
  Panel1.free;
  with timer do
  begin
    runmode:=countup;
    analogclock:=false;
    setstarttimeHMS(0,0,0);
    nosound:=true;
  end;
  //windowstate:=wsmaximized;
  {scale bug}

end;



type
  TGaterec= record
    line:TLine;
    crossed:boolean;
  end;

function sign(x:extended):integer;
begin
  if x<0 then result:=-1
  else result:=1;
end;

{************** StartRun *******}
procedure TForm1.StartRun;
{The run loop}
var
  dd,dt,v,dx,dy:extended;
  cx,cy,cx2,cy2:extended; {centers of body and head}
  d2:extended; {distance between center of body and center of}
  dtheta:extended;
  starttime,currtime:TDateTime;
  HeadOffset,BodyOffset:integer;
  radius:extended;
  i,j:integer;
  d:extended;
  Bugline:TLine;
  gates:array[0..4] of TGaterec;
  SinTheta,CosTheta:extended;
  crossed,cheat,MoveOK:boolean; {used in checking for finish or valid move }
  bodyr, headr:extended;
  distance:extended;

  procedure revertbug;
  {undo a bug move if it collidied with something}
  begin
    

    {If vbar.position>=0 then vbar.position:=-2 else vbar.position:=+2; }
    vbar.position:=-2*sign(vbar.position);  {reverse slowly}

    anglebar.Position:=0;
    cx:=cx - dx; {move bug centers back to where they were beofre last update}
    cy:=cy + dy;
    turnincrement:=0;
    speedincrement:=0;
  end;


begin
  showpath;
  timer.setStartTimeHMS(0,0,0);
  distance:=0;   {total distance traveled}
  with shapes[11] do
  begin
    cx:= left+width div 2 {cs[11].x};  {Get bug centers}
    cy:= top+ height div 2 {cs[11].y}
  end;
  with shapes[12] do
  begin
    cx2:= left+width div 2 {cs[11].x};  {Get bug centers}
    cy2:= top+ height div 2 {cs[11].y}
  end;

  d2:=sqrt(sqr(cx-cx2)+sqr(cy-cy2));  {distance between centers}
  {define the gate and finish lines}
  for i :=0 to 4 do
  with gates[i] do
  begin
    with shapes[2*i+1] do line.p1:=point(left+width,top+height div 2);
    with shapes[2*i+2] do line.p2:=point(left,top+height div 2);
    crossed:=false;
  end;

  {predefine radii for efficiemcy}
  bodyr:={body}shapes[11].width/2;
  headr:={head}shapes[12].width/2;

  starttime:=now;
  tag:=0;
  timer.startTimer;
  while tag=0  do
  begin
    sleep(10);  {sleep 10 milliseconds to slow the loop down}
    {Update speed and turn angle}
    vbar.position:=vbar.position+speedincrement;
    anglebar.position:=anglebar.position+turnincrement;

    if tag<>0 then break;
    currtime:=now;
    dt:=(currtime-starttime)*secsperday; {delta t, elapsed time since last loop}
    starttime:=currtime;
    v:=vbar.position;  {get new velocity}
    dd:=v*dt;  {distance moved = velocity* dt}
    distance:=distance+abs(dd);  {accumulate total distance}
    radius:=Body.width; {assumed vehicle length from pivot point to rear wheels}

    {Using the distance traveled by the bug as a good estimate of the arc length
     when the vehicle is turning and for small turning angles.  If we draw the
     triangle N1,N2,T where N1 is the starting position of the bug's nose, N2
     is the ending position of the nose and T is the Tail position at the end
     of the move, then N1N2 is the line of length "dd", r line TN2, the length of the
     bug, angle TN1N2 is  anglebar.position (the angle of the wheels, call it
     alpaha for brevity) and angle N1TN2 is the desired "dt" change in theta.
     By the law of sines, sin(alpha)/r=sin(dt)/dd or sin(dt)=sin(alpha)*dd/r.
     Since dt is a very small angle, dt and sin(dt) are nearly equal so we
     we can use dt=sin(alpha)*dd/r.  The minus sign in the equation below reflects
     the fact that right turns need to be negative angles but are represented
     in the anglebar slider as positive values.
    }
    dtheta:=-sin(DegToRad(anglebar.position))*dd/radius;
    theta:=theta+dtheta;
    vlabel.caption:='Speed='+inttostr(vbar.position);
    d:= radtodeg(theta) ;
    {keep reported angle between -180 and +180}
    while d>180 do d:=d-360;
    while d<=-180 do d:=d+360;
    ALabel.caption:='Turn angle='+inttostr(anglebar.position)
                    +', Direction='+format('%5.0f',[d]);
    cosTheta:=cos(theta);
    sintheta:=sin(theta);
    dx:=dd*costheta;   {change in x coordinate}
    dy:=dd*sintheta;   {change in y coordinate}
    cx:=cx + dx; {new x}
    cy:=cy - dy; {new y}

    {now calculate center for the the "head" to at angle theta}

    cx2:=cx+d2*costheta;
    cy2:=cy-d2*sintheta;

    {collision detection}
    for i:=1 to 10 do {check against gate posts}
    with shapes[i] do
    begin
      if (sqrt(sqr(cs[i].x-cx)+sqr(cs[i].y-cy))<(body.width +shapes[i].width) div 2)
         or
         (sqrt(sqr(cs[i].x-cx2)+sqr(cs[i].y-cy2))<(head.width +shapes[i].width) div 2)
      then
      begin {collision - beep,and reverse direction}
        beep;
        revertbug;  {move the bug back from the intersection}
        break;
      end;
    end;

    {check against edges of area, need to avoid resize call which resets the bug}
    with clientrect do
    if  (cx+bodyr>=right) or (cx2+headr>=right)
       or (cy+bodyr>=bottom-statictext1.height) or (cy2+headr>=bottom-statictext1.height)
       or (cx-bodyr<=left) or (cx2-headr<=left)
       or (cy-bodyr<=top) or (cy2-headr<=top)
    then
    begin
      beep;
      Revertbug;  {MOVE THE BUG BACK FROM THE INTERSECTION}
    end  {can't let the bug actually go out of bounds or resize event
          will be triggered}
    else
    begin
      {Check if bug intersects a gate line}
      bugline.p1:=point(trunc(cx-CosTheta*bodyr),trunc(cy+Sintheta*bodyr));
      bugline.p2:=point(trunc(cx2+Costheta*headr),trunc(cy2-Sintheta*headr));
      for i:=0 to 4 do
      with gates[i] do
      begin
        if linesintersect(line, bugline) then
        begin
          crossed:=true;
          if i=4 then {gate[4] (the 5th gate) represents the finish line}
          begin
            tag:=1;
            timer.stoptimer;
            cheat:=false;
            for j:=0 to 3 do if not gates[j].crossed then
            begin
              cheat:=true;
              break;
            end;
            if not cheat then  MsgLbl.caption:='Finished!'
            else
            begin
              with timer do starttime:=currenttime+600/secsperday; {10 minute penalty}
              msglbl.caption:='Missed a gate, 10 minute penalty';
            end;
          end;
        end;
      end;


      Body.left:=round(cx - BodyR);
      Body.top:=round(cy - BodyR);
      Head.left:=round(cx2-HeadR) ;
      Head.top:=round(cy2-HeadR);
      distanceLbl.caption:=format('%6.0f pixels traveled',[distance]);
    end;  {moveOK}
    {process messages to update screen and check if "tag" property was changed}
    application.ProcessMessages;
  end;  {until tag<>0}
end;

{************ ResetBtnClick *******}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Reset everything for next race}
begin
  tag:=1;
  application.processmessages; {let it stop if running}
  {Move the bug back to home base}
  Head.left:=start1x;
  Head.top:=start1y;
  Body.left:=start2x;
  Body.top:=start2y;
  turnincrement:=0;
  speedincrement:=0;
  theta:=Pi/2;   {initial direction (up)}
  vbar.position:=0;
  Anglebar.position:=0;
  timer.stoptimer;
  timer.setstarttimeHMS(0,0,0);
  distancelbl.caption:='0 pixels traveled';
  msglbl.Caption:='';
  application.processmessages;
end;

{*********** FormCloseQuery ********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1;  {Set flag to stop the run }
  canclose:=true;
end;

{**************** FormKeyDown **********}
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  turn:integer;
begin
  if (key=vk_up) or (key=vk_down) or (key=vk_left) or (key=vk_right)
  then
  begin
    if (key=vk_down) or (key=vk_up) then
    begin
      if key=vk_down then speedincrement:=-1
      else speedincrement:=+1;
      turnincrement:=0;
    end
    else
    begin
      if key=vk_left then turnincrement:=-1 {1}
      else if key=vk_right then turnincrement:=1 {+1 }
      else turnincrement:=0;
      speedincrement:=0;
    end;
    key:=0;
  end
  else
  begin
    if (key=ord('Z')) or (key=ord('z')) or (key=VK_CLEAR) then
    begin    {VK_Clear is 5 key on the number pad when numLock is off}
      turnincrement:=0;
      anglebar.position:=0;
      key:=0;
    end;
  end;
end;

{************ FomKeyUp **********}
procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  speedincrement:=0;
  turnincrement:=0;
  key:=0;
end;

{************* FormPaint ********}
procedure TForm1.FormPaint(Sender: TObject);
begin
  with canvas do
  begin
    pen.width:=3;
    if erasepath  then pen.color:=color
    else pen.color:=clblack;
    if drawpath then
    begin
      brush.style:=bsclear;
      ellipse(circlerect);
    end;
    with shapes[9] do moveto(left+width,top+height div 2);
    with shapes[10] do lineto(left,top+height div 2);
  end;
end;


{************ ShowPath *********}
procedure TForm1.showPath;
{flash the course path 5 times}
var
  i:integer;
begin
  drawpath:=true;
  for i:=1 to 3 do
  with canvas do
  begin
    erasepath:=false;
    repaint;
    sleep(250);
    erasepath:=true;
    repaint;
    sleep(250);
  end;
  drawpath:=false;
  erasepath:=false;
  repaint; {redraw the finish line only}
  invalidate;
end;


{****** FormResize *******}
procedure TForm1.FormResize(Sender: TObject);
var
  i:integer;
  scale,xscale,yscale:extended;


begin  {Form changed size, major adjustment of positions and sizes required}
  with canvas do
  begin
    erasepath:=true;
    repaint;
    erasepath:=false;
  end;

  resetbtnclick(sender);  {reset all back to starting positions}
  xscale:=width/oldwidth;   {Change in form widtht}
  yscale:=height/oldheight;  {Change in form heght}
  scale:=min(xscale,yscale);
  {rescale all the shapes}
  with origbody do
  begin
    top:=top+round(top*(scale-1)/2);
    left:=left+round(left*(scale-1)/2);
    width:=round(width*scale);
    height:=round(height*scale);
  end;
  with orighead do
  begin
    top:=top+round(top*(scale-1)/2);
    left:=left+round(left*(scale-1)/2);
  end;
  for i:=1 to 12 do
  with shapes[i] do
  begin
    {Adjust height and width by scale}
    width:=round(width*scale);
    height:=round(height*scale);
    {adjust top and left by 1/2 of (scale-1)}

    top:=top+round(top*(scale-1)/2);
    left:=left+round(left*(scale-1)/2);

    if i=11 then {shapes[11] is the bug body, if we rescale we might need to move
             the body up so that is does not intersect the finish line }
    begin
      top:=shapes[9].top-height;
    end;
    if i=12 then
    begin {reposition the head so that 1/4 of it overlaps the body}
      top:=shapes[11].top-2*height div 3;
    end;
    with cs[i] do   {move the centers}
    begin
      x:=left+width div 2;
      y:=top+ height div 2;
    end;
    cs[12].x:=cs[11].x;  {make sure centers are aligned}
  end;
  {Move "Start" and "End" labels}
  with shapes[1] do
  begin
    StartLbl.top:=top+height+5;
    StartLbl.left:=left;
  end;
  with shapes[9] do
  begin  {Reposition the end label}
    EndLbl.top:=top+height+5;
    EndLbl.left:=left;
  end;
  BugSizegrpclick(sender);  {Resize the newly scaled bug}
  {Move Countdown timer}
  with timer do
  begin
    left:=shapes[3].left+shapes[3].Width div 2 -width div 2;
    top:=shapes[1].top;
    distanceLbl.left:=left;
    distancelbl.top:=top+height+10;
  end;




  {Define the circle that defines the course to be run}
  circlerect:=rect(shape1.left+(shape2.left+shape1.width-shape1.left) div 2,
                   shape3.top+(shape4.top+shape3.height-shape3.top) div 2,
                   shape5.left+(shape6.left+shape5.width-shape5.left) div 2,
                   shape7.top+(shape8.top+shape7.height-shape7.top) div 2);
  {Save form size so we know how to rescale if size changes again}
  oldwidth:=width;
  oldheight:=height;

  repaint;
  {Save initial location of bug for "Reset" button}
  start1x:=Head.left;
  start1y:=Head.top;
  start2x:=Body.left;
  start2y:=Body.top;
  resetbtnclick(sender);

end;


procedure TForm1.StartBtnClick(Sender: TObject);
begin
  resetbtnclick(sender);
  startrun;
end;


{************* BugSizeGrp ***********}
procedure TForm1.BugSizeGrpClick(Sender: TObject);
var scale:extended;
begin
  scale:=(8+bugsizegrp.itemindex)/10; {80%, 90%, or 100% of full size bug}
  with body do
  begin    {must scale from original size, not current scaled size}
    width:=trunc(scale*origbody.right);   {right is orig width}
    height:=trunc(scale*origbody.bottom); {bottom is origheight}
    left:=trunc(origbody.left+(1-scale)*width/2);
    top:=origbody.top; {body top at same height}
  end;

  with head do
   begin
     width:=trunc(scale*orighead.right);   {right is orig width}
     height:=trunc(scale*orighead.bottom); {bottom is origheight}
     left:=trunc(orighead.left+ (1-scale)*width/2);
     top:=trunc(orighead.top+(1-scale)*height/2);
   end;
  start1x:=Head.left;
  start1y:=Head.top;
  start2x:=Body.left;
  start2y:=Body.top;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
