unit U_Threadstest1;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Using the TThread class to explore elevators operating as separate processes}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, ComCtrls, ShellAPI;

type
  Tdirection=(up,down);
  t=class(tcontrol)
  end;

  TElevator=class(TThread)
    image1,image2:TShape; {2 halves of the elevator}
    moving:boolean;        {true if moving}
    Direction:TDirection;  {up or down}
    number:integer;        {elevator number}

    doorwidth:integer;
    doorheight:integer;
    leftside:integer;
    w:integer;
    incr:integer;
    newtop:integer;
    dooropen:boolean;

    {floor related}
    floornumber:integer;
    minfloor, maxfloor:integer;
    floorbase:integer;
    floorheight:integer;

    timedooropened:TDatetime;

    constructor create(Aowner:TControl;
                       newnumber, newleftside, newwidth, newheight,
                       newminfloor, newmaxfloor,newfloorbase,
                       newfloorheight:integer);
    destructor destroy; override;
    procedure execute; override;
    procedure moveit;
    procedure opendoor;
    procedure opendoorstep;
    procedure closedoor;
    procedure closedoorstep;
    function DoorOpenTime:integer;
  end;



  TForm1 = class(TForm)
    Button0: TButton;
    Button1: TButton;
    FloorEdit: TSpinEdit;
    Label1: TLabel;
    Image1: TImage;
    ElevEdit: TSpinEdit;
    Label2: TLabel;
    Button3: TButton;
    Button2: TButton;
    Timer1: TTimer;
    Label3: TLabel;
    OpenEdit: TSpinEdit;
    StaticText1: TStaticText;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure FloorEditChange(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ElevEditChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure OpenEditChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    el:array of TElevator;
    floorheight:integer;
    b1,b2,b3,b4:TBitmap;    {up/down, light/dark call button images{}
    nbrfloors:integer;
    testbutton:array[0..3] of TButton;  {pointers to elevator test buttons}
    procedure setupfloors;
    procedure setupElevators;
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

var  {some default elevator control values}
  defaultDooropentime:integer=5;
  DefaultFloorIncrement:integer=2;
  DefaultDoorIncrement:Integer=2;

{In case you don't have the math unit available}
function min(a,b:integer):integer;
begin
  if a<=b then result:=a else result:=b;
end;

{********************************************}
{*********** TElevator Methods *************}
{********************************************}

  {******************* TElevator.create ********}
  constructor TElevator.create(Aowner:TControl;
                       newnumber, newleftside, newwidth, newheight,
                       newminfloor, newmaxfloor,newfloorbase,
                       newfloorheight:integer);
  begin
    inherited create(true);
    number:=newnumber;
    moving:=false;
    doorwidth:=newwidth div 2;
    w:=doorwidth;
    direction:=up;
    incr:=defaultFloorIncrement;
    freeonterminate:=false;
    minfloor:=newminfloor-1;
    maxfloor:=newmaxfloor-1;
    floorheight:=newfloorheight;
    floorbase:=newfloorbase-newheight;
    leftside:=newleftside;
    doorwidth:=newwidth div 2;
    doorheight:=newheight;
    dooropen:=false;
    image1:=TShape.create(Aowner);
    with image1 do
    begin
      shape:=strectangle;
      left:=leftside;
      top:=floorbase;
      width:=doorwidth;
      height:=newheight;
      parent:=twincontrol(aowner);
      brush.color:=$4080ff;
    end;

    image2:=TShape.create(Aowner);
    with image2 do
    begin
      shape:=strectangle;
      left:=leftside+doorwidth;
      top:=floorbase;
      width:=doorwidth;
      height:=newheight;
      parent:=twincontrol(aowner);
      brush.color:=$4080ff;
    end;
  end;

  {*********** TElevator.Destroy **********}
  destructor TElevator.destroy;
  begin
    image1.free;
    image2.free;
    inherited destroy;
  end;


  {***************** TElevator.execute ***********}
  procedure TElevator.execute;
  begin
    while not terminated do  {we only get to execute one time, so
           must keep running until we're all done}
    begin
      newtop:=image1.Top;
      while moving do
      begin
        if dooropen then closedoor;
        case direction of
        up: {if moving up}
          begin
            dec(newtop,incr);
            {are we at the next higher floor?}
            if newtop<=floorbase - ((floornumber+1)*floorheight)then
            begin {yes - stop}
              if floornumber<maxfloor-1 then inc(floornumber)
              else direction:=down;
              opendoor;
              if terminated then exit;
              {PauseAtFloor;}
              moving:=false;
            end;
          end;
        down:
          begin
            inc(newtop,incr);
            {are we at the next lower floor?}
            if newtop>=floorbase - ((floornumber)*floorheight)  then
            begin {yes - stop}
              if floornumber>minfloor then dec(floornumber)
              else direction:=up;
              opendoor;
              if terminated then exit;
              {pauseAtfloor;}
              moving:=false;
            end;
          end;
        end; {case}
        if terminated then exit;
        if moving then synchronize(moveit); {move one step}
        sleep(10);
      end;
      {not moving anymore}
      if not suspended then suspend;
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
  image2.left:=image2.left+DefaultDoorIncrement;
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
  image2.left:=image2.left-DefaultDoorIncrement;
  image1.Update; image2.Update;
  sleep(20);
end;

{************* TElevator.OpenDoor *****}
procedure Televator.opendoor;
  begin
    w:=doorwidth;
    while w>4 do
    begin
      dec(w,DefaultDoorIncrement);
      if terminated then exit;
      synchronize(opendoorstep);
    end;
    dooropen:=true;
    timedooropened:=now;
  end;


{********** TElevator.closeDoor *********}
procedure Televator.closedoor;
  begin
    while w<doorwidth do
    begin
      inc(w,DefaultDoorIncrement);
      if terminated then exit;
      synchronize(closedoorstep);
    end;
    dooropen:=false;
  end;

{*************** TElevator,DoorOpenTime *******}
function TElevator.DoorOpenTime:integer;
begin
  if dooropen
  then result:=trunc((now-timedooropened)*secsperday)
  else result:=0;
end;

{********************************************}
{**************TForm Methods ****************}
{********************************************}

{********* TForm1.SetupElevators *******}
  procedure TForm1.setupelevators;
  var i:integer;
      elevatorwidth, elevatorheight:integer;
      nbrelevators:integer;
  begin
    if length(el)>0 then
    for i:=0 to high(el) do
    if assigned(el[i]) then
    with el[i] do
    begin
      terminate;
      if not suspended then waitfor;
      free;
    end;
    {hide test buttons, we'll turn some of them back on below}
    for i:=0 to 3 do testbutton[i].visible:=false;

    nbrelevators:=elevEdit.value;
    setlength(el,nbrelevators);
    elevatorwidth:=image1.width div nbrelevators;
    elevatorheight:=3*floorheight div 4;
    elevatorwidth:=min(elevatorheight div 2, elevatorwidth);
    for i:=0 to nbrelevators-1 do
    begin
      el[i]:=Televator.create(self,
              i {elevatopr #}, image1.left+15+(elevatorwidth+15)*i {left},
              elevatorwidth {width}, elevatorheight {height},
              1 {minfloor}, Flooredit.value  {max floor},
              image1.top+image1.height - 10 {floorbase (of 1st floor)},
              floorheight {floor height});
      testbutton[i].visible:=true;
    end;
  end;

{********** TForm1.FormActivate *******}
procedure TForm1.FormActivate(Sender: TObject);
begin
   {Set up elevator buttons}
   testbutton[0]:=button0;
   testbutton[1]:=button1;
   testbutton[2]:=button2;
   testbutton[3]:=button3;

   FloorEditchange(sender); {set up initial floors and elevators}

   OpenEditchange(sender);  {Set default door open time}

   doublebuffered:=true;
end;

{********** ButtonClick *****}
procedure TForm1.ButtonClick(Sender: TObject);
{Move elevator corresponding to button's "tag" property value}
var  t:integer;
begin
  t:=tbutton(sender).Tag;
  with el[t] do
  begin
    moving:=not moving;
    resume;
  end;
end;

{************** FloorEditChnage ***********}
procedure TForm1.FloorEditChange(Sender: TObject);
begin
   Setupfloors;
end;

{*********** SetupFloors ********}
procedure TForm1.SetupFloors;
{called initially and whenever nbr of floors changes}
begin
  nbrfloors:=Flooredit.value;
  floorheight:=image1.height  div nbrfloors;
  setupelevators;
  invalidate;
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
      moveto( 0, image1.height-i*floorheight-2);
      lineto(image1.width,image1.height-i*floorheight-2);
    end;
  end;
end;

{************* ElevEditChnage ************}
procedure TForm1.ElevEditChange(Sender: TObject);
{Called whenever the number of elevators changes}
begin
  setupelevators;
end;

{************** Timer1Timer *************}
procedure TForm1.Timer1Timer(Sender: TObject);
var  i:integer;
{Close open elevator doors after defaukt number of seconds}
begin
  for i:=0 to high(el) do
  with el[i] do
  if dooropentime>defaultdooropentime then closedoor;
end;

{***************** OpenEdit1Chnage *********}
procedure TForm1.OpenEditChange(Sender: TObject);
begin
  DefaultDoorOpenTime:=OpenEdit.value;
end;

{***************** StaticText1Click ***********}
procedure TForm1.StaticText1Click(Sender: TObject);
{Browse delphiforfun website}
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
