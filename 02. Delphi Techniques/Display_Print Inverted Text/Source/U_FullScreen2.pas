unit U_FullScreen2;
{Copyright  © 2004-2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Display transformed text in full screen mode}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TDirection=(up,down);
  TFullscreen = class(TForm)
    memo1: TMemo;
    Timer1: TTimer;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ScrollBox1MouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    lineheight,externalLeading:integer;
    topmargin:integer;
    avgcharwidth:integer;
    Leftmargin, RightMargin:integer;
    paused:boolean;
    inverted:boolean;
    sleeptime:integer;
    direction:TDirection;
    scrollcount:integer;
    procedure scroll2(newdirection:TDirection);
    procedure pauseit(yes:boolean);
  end;

var
  Fullscreen: TFullscreen;

implementation

uses U_TestMirroredText2;

{$R *.DFM}

{************** FormKeyUp *************}
procedure TFullscreen.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then
  begin
    timer1.enabled:=false;
    hide;
  end
  else if (  (key=ord('s')) or (key=ord('S')) )
  then  {pause or start} pauseit(not paused)
  else if (  (key=ord('c')) or (key=ord('C')) )
  then
  begin  {change direction}
    if direction=up then direction := down else direction:=up;
  end
  else if (  (key=ord('t')) or (key=ord('T')) )
  then
  begin  {top of form}
    with scrollbox1.vertscrollbar do
    if inverted then position:=range else position:=0;
    direction:=down;
    pauseit(true);
  end
  else if (key=VK_UP) then scroll2(up)
  else if (key=VK_DOWN) then scroll2(down);
end;



{************ Scroll2 **********}
procedure TFullscreen.scroll2(newdirection:TDirection);
      {------------- Scroll -------------}
      procedure scroll(newdirection:TDirection);
      begin
        {keep hitting the same arrow key to speed up}
        if (direction=newdirection) then
        Begin
          sleeptime:= sleeptime div 2;
          if sleeptime<=0 then  sleeptime:=1;
        end
        else
        begin  {slow down or reverse direction}
          sleeptime:=2*sleeptime;
          if (sleeptime>256) then
          begin
            sleeptime := 256;
            scrollcount:=0;
          end;
        end;
        timer1.interval:=sleeptime;
        if paused then  {start scrolling up on up/down arrow}
        begin
          pauseit(false);
          timer1.interval:=sleeptime;
        end;
      end; {scroll}

begin   {scroll2}
  with scrollbox1.vertscrollbar do
  if newdirection=up then
    {users wants to:
     1. slow down (if moving down)
     2. or speed up  (if moving up)
     3. or change direction to up (if stopped and direction had been down- last button right)
     }
  begin
    inc(scrollcount);
    scroll(up);
    if paused and (direction=down) then direction:=up;
    if (scrollcount=0) or (position=0) then  pauseit(true)
    else if (position<range) and (scrollcount=1)
         then if direction=up then direction:=down
         else direction:=up;
  end
  else
  begin {left button or down arrow}
    {users wants to:
     1. slow down (if moving up)
     2. or speed up  (if moving down)
     3. or change direction to  down (if stopped and direction had been up- last button left)
     }
    if position>=range-height then begin pauseit(true); exit; end;
    if paused and (direction=up) then direction:=down;
    scroll(down);
    dec(scrollcount);
    if (scrollcount=0) or (position>=range-height) then pauseit(true);
  end;
end;



{*********** Timer1Timer **********}
procedure TFullscreen.Timer1Timer(Sender: TObject);
var
  incr:integer;
begin
  if not paused then
  with scrollbox1,vertscrollbar do
  begin
    if direction=up then incr:=-1 else incr:=+1;

    if not inverted
    then {right-side up} scrollbox1.vertscrollbar.position:=scrollbox1.vertscrollbar.position+incr
    {else upside down, scroll opposite direction}  else position:=position-incr;

    if ((direction=down) and
        ((not inverted) and (position>=range-height)) {position only goes to range height}
          or ((inverted) and (position<=0))
       )
       or
       ((direction=up) and
        ((not inverted) and (position<=0))
          or ((inverted) and (position>=range-height))
       )
    then pauseit(true);
  end;
end;

{************ Pauseit **********}
procedure tfullscreen.pauseit(yes:boolean);
begin
  if yes then
  begin
    paused:=true;
    timer1.enabled:=false;
    scrollcount:=0;
    sleeptime:=100;
  end
  else
  begin
    paused:=false;
    timer1.enabled:=true;
  end;
end;

{*********** FormActivate  ************}
procedure TFullscreen.FormActivate(Sender: TObject);
begin
  sleeptime:=100;
  timer1.enabled:=false;
  timer1.interval:=sleeptime;
  paused:=true;
  direction:=down;
  if form1.modegrp.itemindex mod 2 =0 then inverted:=false else inverted:=true;
  scrollcount:=0;
end;

{*************** ScrollBox1MouseUp **************}
procedure TFullscreen.ScrollBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button=mbright then scroll2(up)
  else  scroll2(down);
end;



procedure TFullscreen.ScrollBox1MouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  scroll2(down);
end;

procedure TFullscreen.ScrollBox1MouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  scroll2(up);
end;

end.
