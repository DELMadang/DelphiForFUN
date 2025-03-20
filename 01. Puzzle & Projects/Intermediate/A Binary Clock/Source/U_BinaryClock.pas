unit U_BinaryClock;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A simple binary clock using simulated LEDs (Light Emitting Diodes)}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    Timer1: TTimer;
    procedure ClockMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    currenttime:TTime;
    oldss:word; {previous seconds value, used to detect when time seconds changes}
    bkgcolor, LEDcolor:TColor;  {clock colors}
    cellwidth,cellheight:integer;  {size of LED area}
    offsetx,offsety:integer;
    radius:integer;
    LED:array[0..5, 0..3] of boolean; {the lights 6 columns, 4 lights per column}
    TwelveHrFormat:boolean;  {true ==>  hour range is 0 to 12}
    LW,LH:integer; {letter width and height used to adjust position of H H M M S S label}
    ShowHMS, ShowBin:boolean;  {Show HHMMSS,  8421 labels}
    Synchclock:boolean;  {keep clock syncronized with system clock}
    procedure updatetime;
  end;

var  Form1: TForm1;

implementation

uses U_Config;

{$R *.DFM}

{********************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
{initialize clock fields with default values and start the clock}
begin
  ledcolor:=clred;
  bkgcolor:=color;
  currenttime:=time;
  timer1.enabled:=true;
  canvas.pen.color:=bkgcolor;
  formresize(sender);
  font.color:=clWhite;
  font.style:=[fsbold];
  TwelveHrFormat:=true;
  SHowHMS:=true;
  SHowBin:=false;
  Synchclock:=true;
  with configdlg do
  begin {copy initial parameters values to the dialog box}
    bkgcolor.brush.color:=self.bkgcolor;
    ledcolor.brush.color:=self.ledcolor;
    lblcolor.brush.color:=self.font.color;
    timeedt.text:=formatdatetime('hh:nn:ss',currenttime);
    BinLblBox.checked:=ShowBin;
    HMSLblbox.checked:=ShowHMS;
    realtime.checked:=SynchClock;
    if twelveHrFormat then hhformat.itemindex:=0 else hhformat.itemindex:=1;
  end
end;

{*********************** Updatetime *************}
procedure Tform1.updatetime;
{Called initially and every second from Timer1 to update display fields}

  procedure  makebinary(val:integer; var bin:array of boolean);
  var n:integer;
  begin
    for n:= 3 downto 0 do
    begin
      bin[n]:= val mod 2 =1;
      val :=val div 2;
    end;
  end;

var  hh,mm,ss,ms:word;
begin
  if synchclock then currenttime:=now; {synchronize with system clock if option set}
  decodetime(currenttime,hh,mm,ss,ms);
  if oldss<>ss then
  begin
    oldss:=ss;
    with canvas do
    begin
      if twelvehrformat
      then if  hh>12 then hh:=hh-12
           else if hh=0 then hh:=12;
      currenttime:=currenttime+1/secsperday;
      makebinary(hh div 10,led[0]); {Hours to binary}
      makebinary(hh mod 10,led[1]);
      makebinary(mm div 10,led[2]); {Minutes to binaay}
      makebinary(mm mod 10,led[3]);
      makebinary(ss div 10,led[4]); {Seconds to binary}
      makebinary(ss mod 10,led[5]);
    end;

    (*
    {#1}
    repaint;
    *)

    (*
    {#2}

    invalidate;
    update;
    *)

    (*
    {#3}
    Invalidatergn(handle,0,false);
    update;
    *)

    (*
    {#4}
    formpaint(self);
    update;
    *)

    {#5}
    formpaint(self);


  end;
end;

{************* ClockMouseDown ***************}
procedure TForm1.ClockMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{ Left button - start or stop clock
  Right button - configure clock }
begin
 if button=mbright then
 begin
   timer1.enabled:=false;   {stop the clock}
   if configdlg.showmodal=mrOK then {run the dialog}
   with configdlg do
   begin  {load clock parameters from dialog fields}
     self.bkgcolor:=bkgcolor.brush.color;
     self.color:=bkgcolor.brush.color;
     self.ledcolor:=ledcolor.brush.color;
     self.font.color:=lblcolor.brush.color;
     currenttime:=strtotime(timeedt.text);
     ShowBin:=BinLblBox.checked;
     ShowHMS:=HMSLblbox.checked;
     twelveHrFormat:= (hhformat.itemindex=0);
     synchclock:=realtime.checked;
     if synchclock then timer1.enabled:=true; {start clock if it is showing real time}
     updatetime;  {make binary version of new time value for display}
   end;
 end
 else timer1.enabled:=not timer1.enabled; {left button, start or stop the clock}
end;

{***************** Timer1Timer *************}
procedure TForm1.Timer1Timer(Sender: TObject);
{Update time display once per second}
begin   updatetime;  end;


{***************** FormPaint ****************}
procedure TForm1.FormPaint(Sender: TObject);
{Update the clock display}
var i,j:integer;
begin
  with canvas do
  for i:= 0 to 5 do
  for j:= 0 to 3 do
  begin
    if led[i,j] then brush.color:=ledcolor
    else brush.color:=clblack;
    ellipse(offsetx+i*cellwidth-radius, offsety+j*cellheight-radius,
              offsetx+i*cellwidth+radius, offsety+j*cellheight+radius);
  end;
  canvas.brush.color:=bkgcolor;
  if ShowHMS then
  begin
    with canvas do textout(offsetx-LW,            offsety+4*cellheight-LH,'H');
    with canvas do textout(offsetx+cellwidth-LW,  offsety+4*cellheight-LH,'H');
    with canvas do textout(offsetx+2*cellwidth-LW,offsety+4*cellheight-LH,'M');
    with canvas do textout(offsetx+3*cellwidth-LW,offsety+4*cellheight-LH,'M');
    with canvas do textout(offsetx+4*cellwidth-LW,offsety+4*cellheight-LH,'S');
    with canvas do textout(offsetx+5*cellwidth-LW,offsety+4*cellheight-LH,'S');
  End;
  if ShowBin then
  begin
    with canvas do textout(offsetx+6*cellwidth-LW,offsety-LH,'8');
    with canvas do textout(offsetx+6*cellwidth-LW,offsety+cellheight-LH,'4');
    with canvas do textout(offsetx+6*cellwidth-LW,offsety+2*cellheight-LH,'2');
    with canvas do textout(offsetx+6*cellwidth-LW,offsety+3*cellheight-LH,'1');
  end;
end;

{************** FormResize **************}
procedure TForm1.FormResize(Sender: TObject);
{Recalculate clock display parameters when form size changes}
var rx,ry:integer;
begin
  cellwidth:=clientwidth div 7;
  cellheight:=clientheight div 5;
  offsetx:=cellwidth div 2;
  offsety:=cellheight div 2;
  rx:=clientwidth div 50;
  ry:=clientheight div 50;
  if rx>ry then radius:=ry else radius:=rx;
  font.height:=cellheight div 2;
  LW:=canvas.textWidth('H') div 2;
  LH:=canvas.textheight('H') div 2;
end;

end.
