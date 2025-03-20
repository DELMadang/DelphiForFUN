unit URobo1;
{TrackEater - The robot eats the track as it follows it}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

const
  maxpoints=1000;   {maximum track length}

type
  TForm1 = class(TForm)
    Robo: TShape;
    StartBtn: TButton;
    procedure Paintbox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Paintbox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Paintbox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Drawing:boolean; {Flag set by mousedown, tested by Mousemove, reset by Mouseup}
    saved:array of TPoint; {saved track points}
    count:integer; {Current nbr of points}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
{Initialization}
begin
  drawing:=false;
  setlength(saved,maxpoints);
  count:=0;
  doublebuffered:=true;  {to prevent flicker}
end;

procedure TForm1.Paintbox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User pushed mouse button}
begin
  Drawing:=true;  {Set flag}
  canvas.moveto(x,y);   {move pen position to the point}
  canvas.pen.width:=8;  {make a fairly wide track}
  inc(count);
  saved[count]:=point(x,y);
end;

procedure TForm1.Paintbox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{Called when mouse moves}
begin
  If drawing then
  Begin
    canvas.lineto(x,y);  {draw a line segment}
    sleep(10);           {wait 10 ms}
    inc(count);          {save the new point}
    saved[count]:=point(x,y);
  end;
end;

procedure TForm1.Paintbox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Called when mouse button is released}
begin
  Drawing:=false;  {stop drawing}
  Robo.left:=saved[1].x-Robo.Width div 2;  {move robot to start point}
  Robo.top:=saved[1].y-Robo.Height div 2;
end;

procedure TForm1.StartBtnClick(Sender: TObject);
{Robot master clicked the start button}
var
  i:integer;
begin
  {Move the robot around the path}
  for i:= 2 to count do
  Begin
    Robo.left:=saved[i].x-Robo.width div 2;
    Robo.top:=saved[i].y-Robo.height div 2;
    application.processmessages;
    sleep(10);
  end;
  count:=0;
end;

end.
