Unit U_Elevator1;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {This is version 1 of an elevator simulator.  This version implements manual
  control of up to 4 elevators traveling across 2 to 8 floors with up/down Call
  buttons outside of the elevators and Floor button inside each car.

  A simple control strategy is implemented.  Elevators have enough internal
  intelligence to handle all floor and call buttons moving in one direction then
  those requests requiring travel in the opposite direction.  Calls are assigned
  by the scheduler to the first stopped car found.}


 { TODO : Animate customer arrivals/departures }

 { TODO : Elevator control parameters
             Minfloor, Maxfloor (or list of eligible floors)
             Home floor
             Idle delay before returning home
             Default door open time
             Elevator speed
             }

 { TODO : Generated customer script
          (arrival/destination distributions by floor and time of day)}

 { DONE :  Recognize floorbtn pushes as entered   }

 { DONE : If there is a stopped elevator at a floor when a
         call button is pushed, let that elevator handle it}

 { TODO : User slected call handling strategies (prioritize tests?):
            1. Lowest # stopped elevator. (current startegy)
            2. Closest stopped elevator.
            3  Closest that will stop here anyway and is moving in the right directon.
            4. Closest that will pass this floor moving in the right direction.
            5. Close moving in the right direction.
            6. Closest stopped that has been moving in the right direction.
            7. ???
          }

 { DONE : Bug - Handle calls to a floor with a stopped elevator  by that
          elevator}

 { DONE : Popup elevator panel beside the elevator }

 { TODO : Check for memory leaks }

 { TODO :  Add statistics:
              Case name
              total run time
              # passenegers
              mean, max, min wait times
              mean. max, min elevator utilization
              ???
           }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, CheckLst, shellAPI;

type
  Tdirection=(up, down, none);

  TCallBtn=class;  {forward declaration}

  TCallrec=record {used in Stops, array of scheduled calls waiting for each elevator}
    direction:TDirection; {waiting to go up or down?}
    callbtn:TCallbtn; {pointer to actual button so we can turn it off when we get there}
  end;

  {TCallBtn}
  TCallBtn=class(TImage)
  public
    pushed:boolean;
    floornbr:integer;
    direction:TDirection;
    darkImage, LitImage:TBitmap;
    constructor create(Aowner:TComponent; newright,base, fnbr,fheight:integer;
                  newdirection:TDirection;
                  b1,b2:TBitmap);  reintroduce;
                  {"reintroduce" just tells Delphi that we know that we have
                   redefined the parameter list for an existing method, so there
                   is no need to give a warning message to that effect}
    destructor destroy; override;
    {Similarly "override" tells Delphi that we know that we have defined a
     method with the same name and parameter list an existing method, so
     there is no need to give a warning message to that effect}

    procedure turnon;
    procedure turnoff;
  end;

  {TElevator TThread descendent so ekevators run independently}
  TElevator=class(TThread)
    image1,image2:TShape; {2 door halves}
    moving:boolean;  {true if moving}
    Direction:TDirection; {direction to move, up or down}
    number:integer; {Elevator number}

    {Dimensions}
    doorwidth:integer;
    doorheight:integer;
    leftside:integer;
    w:integer;   {door width while opening or closng doors}

    {Movement}
    incr:integer; {move step size in pixels}
    newtop:integer;
    dooropen:boolean;
    doorclosing:boolean;
    timedooropened:TDatetime;

    stops:array of TCallrec; {Array of pending calls with one entry for each floor }
    floorbtns:array of boolean; {Array of car buttons, one for each destination floor}
    floornumber:integer;
    minfloor, maxfloor:integer;
    floorbase:integer;
    floorheight:integer;

    constructor create(Aowner:TControl;
                       newnumber, newleftside, newwidth, newheight,
                       newminfloor, newmaxfloor,newfloorbase,
                       newfloorheight:integer;
                       mouseup:TMouseEvent);
    destructor destroy; override;
    procedure execute; override;
    procedure moveit;
    procedure opendoor;
    procedure opendoorstep;
    procedure closedoor;
    procedure closedoorstep;
    function DoorOpenTime:integer;
    function stopcount(dir:Tdirection; startfloor, stopfloor:integer):integer;
    function idle:boolean;
  end;


   {TFloor }
    TFloor=class(TObject)
    Upbutton:TCallBtn;
    DownButton:TCallBtn;
    floornbr:integer;
    constructor create(Aowner:TComponent; R:Trect; n,Fheight:integer;
                b1,b2,b3,b4:TBitmap);
    destructor  destroy;   override;
  end;

  {TForm}
  TForm1 = class(TForm)
    FloorEdit: TSpinEdit;
    Label1: TLabel;
    Image1: TImage;
    ElevEdit: TSpinEdit;
    Label2: TLabel;
    Timer1: TTimer;
    ElPanel: TPanel;
    ElLbl: TLabel;
    Label4: TLabel;
    ElButtonBox: TCheckListBox;
    CloseBtn: TButton;
    StaticText1: TStaticText;
    Memo1: TMemo;
    Label3: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FloorEditChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ElevEditChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure ElMouseUp(Sender: TObject; Button: TMouseButton;
                        Shift: TShiftState; X, Y: Integer);
    procedure StaticText1Click(Sender: TObject);
    procedure ElButtonBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    el:array of TElevator;
    floorheight:integer;
    b1,b2,b3,b4:TBitmap;    {up/down, light/dark call button images{}
    floor:array of TFloor;
    nbrfloors:integer;
    nbrelevators:integer;
    pendingIn:array of TCallrec; {pending call buttons}
    showingpanel:integer;
    procedure setupfloors;
    procedure CallBtnClick(Sender: TObject);
    procedure setupElevators(nfloors:integer);
    procedure scheduler;
    function  onElevator(sender:TObject; x,y:Integer):integer;
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

var
  defaultDooropentime:integer=5;
  DefaultFloorMoveIncrement:integer=2;
  DefaultDoorMoveIncrement:Integer=2;

  {In case Math uinit is not available}
  function min(a,b:integer):integer;
  begin
    if a<=b then result:=a else result:=b;
  end;
  function max(a,b:integer):integer;
  begin
    if a>=b then result:=a else result:=b;
  end;

  {******************* TElevator.create ********}
  constructor TElevator.create  (Aowner:TControl;
                       newnumber, newleftside, newwidth, newheight,
                       newminfloor, newmaxfloor,newfloorbase,
                       newfloorheight:integer; Mouseup:TMouseEvent);
  var j:integer;
  begin
    inherited create(true);
    number:=newnumber;
    incr:=2;
    moving:=false;
    doorwidth:=newwidth div 2;
    w:=doorwidth;
    direction:=up;
    freeonterminate:=false;
    minfloor:=newminfloor-1;
    maxfloor:=newmaxfloor-1;
    floorheight:=newfloorheight;
    floorbase:=newfloorbase-newheight;
    leftside:=newleftside;
    doorwidth:=newwidth div 2;
    doorheight:=newheight;
    dooropen:=false;
    doorclosing:=false;
    suspended:=false;
    
    setlength(stops,maxfloor+1);
    setlength(floorbtns, maxfloor+1);

    for j:=0 to maxfloor do
    begin
      stops[j].direction:=none;
      floorbtns[j]:=false;
    end;
    image1:=TShape.create(Aowner);
    with image1 do
    begin
      shape:=strectangle;
      left:=leftside;
      top:=floorbase;
      width:=doorwidth;
      height:=newheight;
      OnMouseup:=mouseUp;
      brush.color:=$4080ff;
      parent:=twincontrol(aowner);
    end;

    image2:=TShape.create(Aowner);
    with image2 do
    begin
      shape:=strectangle;
      left:=leftside+doorwidth;
      top:=floorbase;
      width:=doorwidth;
      height:=newheight;
      OnMouseUp:=MouseUp;
      brush.color:=$4080ff;
      parent:=twincontrol(aowner);
    end;
  end;

  {*********** TElevator.Destroy **********}
  destructor TElevator.destroy;
  begin
    freeandnil(image1);
    freeandnil(image2);
    inherited;
  end;

  {***************** TElevator.execute ***********}
  procedure TElevator.execute;
  {The elevator processing loop}
  var
    i:integer;
  begin
    while not terminated do  {we only get to execute one time, so
           must keep running until we're all done}
    begin
      newtop:=floorbase - floornumber*floorheight; {put back on exact boundary}
      while moving do
      begin
        if dooropen then closedoor;
        case direction of
        up: {if moving up}
          begin
            dec(newtop,incr);
            {are we at the next higher floor?}
            if newtop<=floorbase - (floornumber+1)*floorheight then
            begin {yes - stop}
              floornumber:=min(floornumber+1,maxfloor);
              if floornumber=maxfloor then direction:=down;
              newtop:=floorbase - floornumber*floorheight; {put back on exact boundary}
              if (stops[floornumber].direction=direction)
              or ((stops[floornumber].direction=down) and (stopcount(up, floornumber+1,maxfloor)=0))
              or (floorbtns[floornumber])
              then
              begin
                synchronize(opendoor);
                moving:=false;
                if terminated then exit;
                if stops[floornumber].direction in [up,down] then
                begin
                  stops[floornumber].callbtn.turnoff;
                  stops[floornumber].direction:=none;
                end;
                floorbtns[floornumber]:=false;
              end;
            end;
          end;
        down:
          begin
            inc(newtop,incr);
            {are we at the next lower floor?}
            if newtop>=floorbase - ((floornumber-1)*floorheight)  then
            begin {yes - stop}
               floornumber:=max(floornumber-1,minfloor);
              if floornumber=minfloor then direction:=up;
              newtop:=floorbase - floornumber*floorheight; {put back on exact boundary}
              if (stops[floornumber].direction=direction)
                or ((stops[floornumber].direction=up) and (stopcount(down, 0,floornumber-1)=0))
                or (floorbtns[floornumber])
               then
              begin
                synchronize(opendoor);
                moving:=false;
                if terminated then exit;
                if stops[floornumber].direction in  [up,down] then
                begin
                  stops[floornumber].callbtn.turnoff;
                  stops[floornumber].direction:=none;
                end;
                floorbtns[floornumber]:=false;
              end
            end;
          end;
        end; {case}
        if terminated then exit;
        if moving then synchronize(moveit); {move one step}
        sleep(20);
      end; {of moving loop}

      {not moving anymore}

      {Check Stops and Floorbtn array for next target}
      if terminated then exit;

      floorbtns[floornumber]:=false;
      If stops[floornumber].direction in  [up,down]
      then  {If the call was for the current floor, no action necessary, except
             turning off the call button}
      begin
        stops[floornumber].callbtn.turnoff;
        stops[floornumber].direction:=none;
      end;

      if {(length(stops)>0) and} (not dooropen) and (not doorclosing) then
      begin
        {check rest of array in our last direction}
        if direction=up then
        begin
          for i:=floornumber+1 to high(stops) do
          if (stops[i].direction=up)
          or ((i=high(stops)) and (stops[i].direction=down))
          or floorbtns[i] then
          begin
            moving:=true;
            break;
          end;
        end
        else
        if direction=down then
        for i:=floornumber-1 downto 0 do
        if (stops[i].direction=down)
        or ((i=0) and (stops[i].direction=up))
        or floorbtns[i] then
        begin
          moving:=true;
          break;
        end;

        {check rest of arrays in direction opposite to
         our last direction}
        if direction=down then
        begin
          for i:=floornumber+1 to high(stops) do
          if (stops[i].direction=up) or floorbtns[i] then
          begin
            moving:=true;
            direction:=up;
            break;
          end;
        end
        else
        if direction=up then
        for i:=floornumber-1 downto 0 do
        if (stops[i].direction=up) or floorbtns[i] then
        begin
          moving:=true;
          direction:=down;
          break;
        end;

        if not moving then
        begin  {see if we can change directions a satisfy a call}
          for i:=high(stops) downto 0 do
          if stops[i].direction in [up,down] then
          begin
            if floornumber<i then direction:=up
            else if floornumber>i then direction:=down;
            moving:=true;
            break;
          end;
        end;
      end;
      sleep(100);
    end;
  end;

{********* TElevator.moveit *********}
procedure TElevator.moveit;
{the synchronized update of teh elevator image}
begin
  image1.top:=newtop;
  image2.top:=newtop;
end;

{*************** TElevator.OpenDoorStep *****}
procedure TElevator.opendoorstep;
{Synchronized update of doors opening image}
begin
  image1.width:=w;
  image2.width:=w;
  image2.left:=image2.left+2;
  image1.Update; image2.Update;
  with TCustomForm(image1.Parent).canvas do
  begin
    pen.Width:=2;
    moveto(image1.Left+1,image1.top+1);
    lineto(image2.Left+1,image1.Top+1);
    moveto(image1.Left+1,image1.top+image1.height-1);
    lineto(image2.Left+1,image1.Top+image1.height-1);
  end;
  sleep(20);
end;

{***************** TElevator.CloseDoorStep ***********}
procedure TElevator.closedoorstep;
{Synchronized update of doors closing image}
begin
  image1.width:=w;
  image2.width:=w;
  image2.left:=image2.left-2;
  image1.Update; image2.Update;
  sleep(20);
end;

{************* TElevator.OpenDoor *****}
procedure Televator.opendoor;
var i:integer;
    n:integer;
  begin
    w:=doorwidth;
    while w>4 do
    begin
      dec(w,2);
      if terminated then exit;
      opendoorstep;
    end;
    dooropen:=true;
    timedooropened:=now;
    {build the mini elevator panel image}
    with TcustomForm(image1.parent).canvas do
    begin
      brush.color:=claqua;    {the panel}
      rectangle(image1.left+doorwidth-5, image1.top+5,
                image1.left+doorwidth+5, image1.top+image1.height-5);
      n:=high(floorbtns);
      for i:=0 to n do
      begin  {the buttons}
        if floorbtns[i] and (i<>floornumber)
        then brush.color:=clyellow else brush.color:=clgray;
        pen.color:=brush.color;
        ellipse(image1.left+doorwidth-2, image1.top+7 + (n-i)*6,
                image1.left+doorwidth+2, image1.top+11 + (n-i)*6);
      end;
    end;
  end;

{********** TElevator.closeDoor *********}
procedure Televator.closedoor;
  begin
    doorclosing:=true;
    while w<doorwidth do
    begin
      inc(w,2);
      if terminated then exit;
      synchronize(closedoorstep);
    end;
    dooropen:=false;
    doorclosing:=false;
  end;

{************* TElevator.DoorOpenTime ********}
function TElevator.DoorOpenTime:integer;
{Return the number of seconds doors have been open,
 return 0 if doors are closed}
begin
  if dooropen
  then result:=trunc((now-timedooropened)*secsperday)
  else result:=0;
end;

{***************** TElevator.StopCount ***************}
 function TElevator.stopcount(dir:Tdirection; startfloor, stopfloor:integer):integer;
 {count the number of stops in direction "dir" between startrfloor and stopfloor}
 var
   i:integer;
 begin
   result:=0;
   for i:=startfloor to stopfloor do
   if stops[i].direction=dir then inc(result);
 end;

 {*********** Televator.idle **************}
 function TElevator.idle:boolean;
 {elevator is idle if it is stopped and there are no pending actions}
 var i:integer;
 begin
   result:=true;
   for i:=minfloor to maxfloor do
   begin
     if (stops[i].direction in [up,down]) or floorbtns[i] then
     begin
       result:=false;
       break;
     end;
   end;
 end;


{************* TCallBtn.Create ***********}
constructor TCallBtn.create(Aowner:TComponent;
                         newright,base,fnbr,fheight:integer;
                         newdirection:TDirection; b1,b2:TBitmap);
begin
  inherited create(aowner);
  darkimage:=TBitmap.create;
  darkimage.assign(b1);
  litimage:=TBitmap.create;
  litimage.assign(b2);
  floornbr:=fnbr;
  picture.bitmap:=darkimage;
  pushed:=false;
  direction:=newdirection;
  if b1<>nil then
  begin
    top:=base - fnbr*Fheight-b1.height;
    height:=b1.height;
  end
  else
  begin
    top:=0;
    height:=0;
  end;
  left:=newright;
  parent:=TWinControl(aowner);
end;

 {************* TCallBtn.TurnOn ********}
 procedure TCallBtn.turnon;
 begin
   pushed:=true;
   picture.bitmap:=litimage;
 end;

{*********** TCallBtn.TurnOff *********}
 procedure TCallBtn.turnoff;
 begin
   pushed:=false;
   picture.bitmap:=darkimage;
end;


{*********** TCallBtn.Destroy ***********}
destructor TCallBtn.destroy;
begin
  darkimage.free;
  litimage.free;
  inherited;
end;


{**************** TFloor.Create ***************}
constructor TFloor.create(Aowner:TComponent; R:TRect; n,Fheight:integer;
                b1,b2,b3,b4:TBitmap);
begin
  inherited create;
  floornbr:=n;

  upbutton:=TCallBtn.create (Aowner,r.right,r.bottom,n,fheight,up, b1, b2);
  downbutton:=TCallBtn.create(Aowner,r.right,r.bottom,n,fheight,down, b3, b4);

  if b1<>nil then upbutton.top:=upbutton.top-b1.height-5;
  upbutton.turnoff;
  downbutton.turnoff;
end;

{*********** TFloor.Destroy **********}
destructor TFloor.destroy;
begin
  upbutton.destroy;
  downbutton.destroy;
  inherited;
end;

{********* TForm1.SetupElevators *******}
  procedure TForm1.setupelevators(nfloors:integer);
  var i:integer;
      elevatorwidth, elevatorheight:integer;
  begin
    if length(el)>0 then
    for i:=0 to high(el) do
    if assigned(el[i]) then
    with eL[i] do
    begin
      terminate;
      waitfor;
      free;
    end;

    nbrelevators:=elevEdit.value;
    setlength(el,nbrelevators);
    elevatorwidth:=image1.width div nbrelevators;
    elevatorheight:=7*floorheight div 8;
    elevatorwidth:=min(elevatorheight div 2, elevatorwidth);
    for i:=0 to nbrelevators-1 do
    begin
      el[i]:=Televator.create(self,
              i {elevator #},
              image1.left+10+(elevatorwidth+15)*i {left},
              elevatorwidth {width}, elevatorheight {height},
              1 {minfloor}, nfloors  {max floor},
              image1.top+image1.height - 2 {floorbase (of 1st floor)},
              floorheight {floor height}, ElMouseup);
    end;
  end;

{********** TForm1.FormActivate *******}
procedure TForm1.FormActivate(Sender: TObject);

begin
   doublebuffered:=true;
   b1:=TBitmap.create;
   b1.loadfromfile('ArrowUpDark2.bmp');
   b1.transparent:=true;
   b1.transparentmode:=tmAuto;

   b2:=TBitmap.create;
   b2.loadfromfile('ArrowUpLit2.bmp');

   b3:=TBitmap.create;
   b3.loadfromfile('ArrowDownDark2.bmp');

   b4:=TBitmap.create;
   b4.loadfromfile('ArrowDownLit2.bmp');

   FloorEditchange(sender); {set up initial floors and elevators}
   ElPanel.color:=$56C4E3;
   timer1.enabled:=true;
end;


{************** FloorEditChange ***********}
procedure TForm1.FloorEditChange(Sender: TObject);
{User changed the number of floors}
begin
   timer1.enabled:=false;
   Setupfloors;
   timer1.enabled:=true;
end;

{*********** SetupFloors ********}
procedure TForm1.SetupFloors;
var i:integer;
    R:TRect;

begin
  nbrfloors:=Flooredit.value;
  floorheight:=image1.height  div nbrfloors;
  setupelevators(nbrfloors);
  for i:= 0 to high(floor) do floor[i].destroy;
  setlength(floor,nbrfloors);
  setlength(PendingIn,nbrfloors);
  elbuttonbox.items.clear;

  with image1 do  R:=rect(left,top,left+width,top+height);
  for i:= nbrfloors-1 downto 0 do
  begin
    elbuttonbox.items.add(inttostr(i+1));
    PendingIn[i].direction:=none;
    If (i>0) and (i<nbrfloors-1) then
      floor[i]:=TFloor.create(self,R,i,floorheight,b1,b2,b3,b4)
    else If i=nbrfloors-1 then
      floor[i]:=TFloor.create(self,R,i,floorheight,nil,nil,b3,b4)
    else If i=0 then
      floor[i]:=TFloor.create(self,R,i,floorheight,b1,b2,nil,nil);

    floor[i].upbutton.onclick:=CallBtnClick;
    floor[i].downbutton.onclick:=CallBtnClick;

  end;
  invalidate;
end;

{************** CallBtnClick *************}
procedure TForm1.CallBtnClick(Sender: TObject);
{Call button click exit}
begin
  with TCallBtn(sender) do
  begin
    turnon;
    PendingIn[floornbr].direction:=direction;
    pendingIn[floornbr].callbtn:=TCallBtn(sender);
  end;
end;

{*************** FormPaint **************}
procedure TForm1.FormPaint(Sender: TObject);
{Draw the floors}
var
  i:integer;
begin
  with canvas do
  begin
    pen.width:=3;
    pen.color:=clblack;
    for i:=0 to nbrfloors-1 do
    begin
      moveto( 0, image1.top+image1.height-i*floorheight-2);
      lineto(image1.width,image1.top+image1.height-i*floorheight-2);
    end;
  end;
end;

{************* ElevEditChange ************}
procedure TForm1.ElevEditChange(Sender: TObject);
begin
  timer1.enabled:=false;
  setupelevators(nbrfloors);
  timer1.enabled:=true;
end;

{*************** Timer1Timer *************}
procedure TForm1.Timer1Timer(Sender: TObject);
var  i:integer;
{Close open elevator doors after default number of seconds}
{Also call the scheduler routine to control elevator movement}
begin
  for i:=0 to high(el) do
  with el[i] do
  if dooropentime>defaultdooropentime then
  begin
    closedoor;
    if i=showingpanel then elpanel.visible:=false;
  end;
  scheduler;
end;

{************* Scheduler **********}
procedure TForm1.Scheduler;
var
  i,j:integer;
begin
  for i:=0 to nbrfloors-1 do
  begin
    {first, check if there is an idel elevator at this floor}
    if  pendingIn[i].direction in [up,down]then
    begin
      for j:=0 to nbrelevators-1 do
      if el[j].idle and (el[j].floornumber=i)  then
      begin
        el[j].stops[i]:=pendingIn[i];
        pendingIn[i].direction:=none;
        break;
      end;
    end;

    {If no idle elevator here, search for one to handle the call}
    if  pendingIn[i].direction in [up,down]then
    begin
      for j:=0 to nbrelevators-1 do
      with el[j] do
      begin

        if (not moving) and (not dooropen) then
        begin
          stops[i]:=pendingIn[i];
          pendingIn[i].direction:=none;
          break;
        end;
      end;
    end;
  end;
end;

{********************** ElMouseUp ******************}
procedure TForm1.ElMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User clicked on floor/elevator image - check which elevator, if any,
 and display the elevator control panel}
var i,n:integer;
begin
  n:=onElevator(sender,x,y);
  if (n>=0) then
  begin
    with el[n] do
    if not moving then
    begin
      for i:=0 to high(floor) do  elButtonBox.checked[i]:=floorbtns[nbrfloors-1-i];
      if not dooropen then synchronize(opendoor);
    end;

    showingpanel:=n;
    elLbl.caption:='Elevator # '+inttostr(n+1);
    with elpanel do
    begin
      top:=el[n].image1.top-height div 2;
      if top<0 then top:=5;
      left:=el[n].leftside+2*el[n].doorwidth + 5;
      visible:=true;
    end;
  end;
end;

{********  OnElevator **********}
function  Tform1.onElevator(sender:TObject; x,y:Integer):integer;
{If point x,y is on an elevator image, return its number}
{Used when evaluating user clicks}
var i:integer;
begin
  result:=-1;
  for i:=0 to high(el) do
  with el[i] do
  begin
    if (sender=image1) or (sender=image2)
    or (
        (y>image1.top) and (y<Image1.top+image1.height) and
        (x>image1.left) and (x<(image2.left+image2.width))
       )
    then
    begin
      result:=i;
      break;
    end;
  end;
end;

{*************** CloseBtnClick ***********}
procedure TForm1.CloseBtnClick(Sender: TObject);
{A set of elevator buttons has been selected}
var i:integer;
begin
  elPanel.visible:= false;
  el[showingpanel].closedoor;
end;

{************** StaticText1Click ************}
procedure TForm1.StaticText1Click(Sender: TObject);
{ Browse to DFF homepage }
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

{************ ElButtonBocClick ************}
procedure TForm1.ElButtonBoxClick(Sender: TObject);
{An elevator floor button was pushed}
var
 i:integer;
begin
  with el[showingpanel] do
  for i:= 0 to high(floor) do
   elbuttonbox.checked[nbrfloors-1-i]:=floorbtns[i];

  with elbuttonbox do
  begin
    checked[itemindex]:= not checked[itemindex];
    el[showingpanel].floorbtns[nbrfloors-1-itemindex]:=checked[itemindex];
    invalidate;
  end;

end;

end.
