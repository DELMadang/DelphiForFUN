unit URobo2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

const
  maxpoints=1000;
  sleepms=20;  {milliseconds (ms) delay between points}

type
  TForm1 = class(TForm)
    Robo: TShape;
    ResetBtn: TButton;
    StartBtn: TButton;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Drawing:boolean;
    StartPoint:TPoint;
    saved:array of TPoint;
    count:integer;
    freq:int64;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses mmsystem, {to get to queryperformance functions}
     math; {to get to max function}

procedure TForm1.FormActivate(Sender: TObject);
{Called when the form is activated - do initialization stuff}
begin
  drawing:=false;
  setlength(saved,maxpoints); {initialize saved array size}
  count:=0;  {set saved point count to 0}
  doublebuffered:=true; {prevent ficker}
  resetbtnclick(sender);
  {Get timer counts/sec for use in cointrolling speed later}
  queryperformancefrequency(freq);
  freq:=freq div 1000; {convert it to counts per ms}
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 {Called when user presses the mouse}
begin
  Drawing:=true;
  {Set up for drawing}
  canvas.moveto(x,y);
  canvas.pen.width:=8;
  canvas.pen.color:=clRed;
  {increment counter and save the starting point}
  inc(count);
  saved[count]:=point(x,y);
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{User moved mouse}
begin
  If drawing then
  begin
    canvas.lineto(x,y);
    sleep(sleepms);
    inc(count);
    if count>length(saved) then setlength(saved,length(saved)+maxpoints);
    saved[count]:=point(x,y);
  end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User released the button}
begin
  Drawing:=false;
  Robo.left:=saved[1].x-robo.Width div 2;
  Robo.top:=saved[1].y-Robo.Height div 2;
end;


procedure TForm1.ResetBtnClick(Sender: TObject);
{Called to reset the track}
begin
  if count>0 then  {erase the track}
  begin
    canvas.pen.color:=color; {Set brush to form color}
    invalidate; {This forces the form to be repainted - only it will be erasing}
    count:=0;
  end;
  {Move the robot back out of the drawing area}
  Robo.left:=9*width div 10;  {90% across}
  Robo.top:= height div 4;    {1/4 from the top}
end;

procedure TForm1.StartBtnClick(Sender: TObject);
{User clicked start}
var
  i:integer;
  drawtime:integer;
  startcount,stopcount:int64;
begin
  for i:= 2 to count do
  begin
    {put center of robo on the point}
    Robo.left:=saved[i].x-Robo.width div 2;
    Robo.top:=saved[i].y-Robo.height div 2;

    queryperformanceCounter(startcount);{Get time before we repaint}
    application.processmessages;
    queryPerformanceCounter(stopcount);{Get time after repaint}
    drawtime:=(stopcount-startcount) div freq;  {Compute ms to repaint}
    sleep(max(0,sleepms-drawtime));   {wait whatever time is left, if any}
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
{Called eveytime anything visual changes on the form}
var
  i:integer;
begin
  {Redraw the track which got erased when windows erased everything to repaint}
  If count>0 then
  begin
    canvas.moveto(saved[1].x,saved[1].y);
    for i:=1 to count do canvas.lineto(saved[i].x,saved[i].y);
  end;
end;

end.
