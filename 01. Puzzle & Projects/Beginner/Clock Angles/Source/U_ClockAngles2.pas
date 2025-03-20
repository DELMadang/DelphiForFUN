unit U_ClockAngles2;

{Copyright  © 2001-2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    LHA: TLabel;
    LMA: TLabel;
    LDa: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Image1: TImage;
    CountLbl: TLabel;
    NinetyLbl: TLabel;
    Label7: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    HourVal: TUpDown;
    MinuteVal: TUpDown;
    Memo1: TMemo;
    SearchBtn: TButton;
    PauseBox: TCheckBox;
    Edit3: TEdit;
    SecVal: TUpDown;
    ResetBtn: TButton;
    StaticText1: TStaticText;
    Memo2: TMemo;
    procedure ValClick(Sender: TObject; Button: TUDBtnType);
    procedure FormActivate(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button2Click(Sender: TObject);
  public
    center:TPoint;
    mhandlen,hhandlen:integer;
    dotloc,i:integer;
    lastmn,lasthr:TPoint;
    hourangle,minuteangle,difangle:single;
    oldangle:single;
    count:integer;
    procedure updatetime(m:extended);
    procedure computeangles;
    procedure adjustPositionDisplays;
    procedure timechanged;
    procedure drawtime(hourangle,minuteangle:single);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{*********** AdjsutPositionDisplays *********}
procedure TForm1.adjustPositionDisplays;
Begin
  if (secval.position>59) then
  begin
    secval.position:=secval.position - 60;
    minuteval.position:=minuteval.position +1;
  end
  else if (secval.position<0) then
  begin
    secval.position:=secval.position +60;
    minuteval.position:=minuteval.position -1;
  end;
  if (minuteval.position>59) then
  begin
    minuteval.position:=minuteval.position - 60;
    hourval.position:=hourval.position+1;
  end
  else if (minuteval.position<0) then
  begin
    minuteval.position:=minuteval.position+60;
    hourval.position:=hourval.position-1;
  end;
  if hourval.position<=0 then hourval.position:=hourval.position+12
  else if hourval.position>12 then hourval.position:=hourval.position-12;
end;

{*********** ComputeAngles **********8}
procedure TForm1.ComputeAngles;
var
  hour,minute,second:integer;
  hourtime,minutetime:single;
begin
  hour:=hourval.position mod 12;
  minute:=minuteval.position;
  second:=secval.Position;
  hourtime:=(hour+minute/60+second/3600)/12;
  hourangle:=hourtime*360;
  minutetime:=minute/60+second/3600;
  minuteangle:=minutetime*360;
  difangle:=(minuteangle-hourangle);
  if difangle>180 then difangle:=difangle-360;
  if difangle<= -180 then difangle:=difangle+360;
  lha.caption:=floattostrf(hourangle,ffgeneral,5,2);
  lma.caption:=floattostrf(minuteangle,ffgeneral,5,2);
  lda.caption:=floattostrf(difangle,ffgeneral,5,2);
end;

{*************** TimeChanged ***********}
procedure TForm1.TimeChanged;
{Update all displays}
begin
  adjustPositionDisplays;
  computeangles;
  drawtime(hourangle,minuteangle);
  sleep(20);
end;

{***************** DrawTime ****************}
procedure TForm1.drawtime(hourangle,minuteangle:single);
{Redraw the clock}
begin
  with image1.picture.bitmap{clock},canvas do
  begin
    {erase old hands}
    pen.width:=1;
    pen.color:=clwhite;
    moveto(center.x,center.y);
    lineto(lastmn.x,lastmn.y);
    pen.width:=3;
    moveto(center.x,center.y);
    lineto(lasthr.x,lasthr.y);
    {drawnew hands}
    pen.width:=1;
    pen.color:=clblack;
    moveto(center.x,center.y);
    lastmn.x:=trunc(center.x+mhandlen*cos((minuteangle-90)*pi/180));
    lastmn.y:=trunc(center.y+mhandlen*sin((minuteangle-90)*pi/180));
    lineto(lastmn.x,lastmn.y);
    pen.width:=3;
    moveto(center.x,center.y);
    lasthr.x:=trunc(center.x+hhandlen*cos((hourangle-90)*pi/180));
    lasthr.y:=trunc(center.y+hhandlen*sin((hourangle-90)*pi/180));
    lineto(lasthr.x,lasthr.Y);
   end;
   image1.update;
end;

{************** ValClick **************}
procedure TForm1.ValClick(Sender: TObject; Button: TUDBtnType);
{Hour or minute changed - update displays}
begin
  timechanged;
end;

{********** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
var i:integer;
begin
  countlbl.caption:='';
  pagecontrol1.activepage:=tabsheet1;
  with image1.picture.bitmap,canvas do
  begin
    width:=image1.width;
    height:=image1.height;
    center.x:=image1.picture.bitmap.width div 2;
    center.y:=height div 2;
    mhandLen:=3*width div 8;
    hhandlen:= width div 4;
    canvas.ellipse(0,0,width,height);
    dotloc:=9*width div 20;
    brush.color:=clblack;
    for i:= 1 to 12 do
      ellipse(trunc(center.x+dotloc*cos(2*pi*i/12)-3),
              trunc(center.y+dotloc*sin(2*pi*i/12)-3),
              trunc(center.x+dotloc*cos(2*pi*i/12)+3),
              trunc(center.y+dotloc*sin(2*pi*i/12)+3)  );
    pen.width:=1;
    lastmn:=center;
    lasthr:=center;
  end;
  timechanged;
  doublebuffered:=true;
end;

{*********** UpdateTime **********}
procedure Tform1.updatetime(m:extended);
 begin
    hourval.position:=trunc(m / 60);
    if hourval.position=0 then hourval.position:=12;
    minuteval.position:=trunc(m) mod 60;
    secval.position:=trunc(frac(m)*60);
    timechanged;
  end;

{**************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
var m,hour:integer;
    mintime,sectime:extended;
    rotation:integer;
    stopat:extended;
    timemsg:string;
begin
  searchbtn.enabled:=false;
  oldangle:=0;
  count:=0;
  tag:=0;
  rotation:=90;
  stopat:=rotation/5.5;
  for m:=0 to 12*60 do
  begin
    if stopat-m>=1 then updatetime(m)
    else
    begin {We are at the next 90 degree point, display it}
      updatetime(stopat);
      hour:=trunc(stopat/60);
      mintime:=stopat-60*hour;
      sectime:=frac(mintime)*60;
      mintime:=trunc(mintime);

      NinetyLbl.caption:=format('Exact time for right angle (HH:MM:SS.SS) is %2d:%2d:%5.2f',
           [hourval.position,  trunc(mintime) mod 60, sectime]);
      ninetylbl.visible:=true;
      inc(count);
      rotation:=rotation+180;
      stopat:=rotation/5.5;

      if count=1 then timemsg:='time' else timemsg:='times';
      countLbl.caption := format('Hands at 90 degrees %d %s',[count,timemsg]);
      if pausebox.Checked then
      begin
        tag:=0;
        repeat
          sleep(500);
          application.ProcessMessages;
        until tag<>0;
      end;
      ninetylbl.visible:=false;
    end;
    if tag>1 then break;
    if stopat>720 then
    begin
      updatetime(0);
      break;
    end;
    application.processmessages;
    If tag>1 then break;
  end;
  application.ProcessMessages;
  searchbtn.enabled:=true;
end;

{************** StaticText1Click ************}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin
  tag:=1;
end;

procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  tag:=2;
  application.processmessages;
  Hourval.position:=12;
  Minuteval.position:=0;
  Secval.position:=0;
  timechanged;
  countlbl.Caption:='';
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Canclose:=true;
  tag:=2;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  {The hour hand moves 360 degrees in 720 minutes (12 hours x 60 minutes per hour
   This is 0.5 degrees per minute}
  {The minute hand moves 360 degrees in 60 minutes or 6 degrees per minute.
   So each minute, the minute hand gains 5.5 degrees on the hour hand.
   How long will it take to gain 90 degrees?  Solve 5.5X=90 or x=90/5.5=16.363636 minutes}
   {For the 90 degree and when the minute hand is approaching the hours hand, we
   can compute the time until it is 270 degrees ahead of the hour hand.
   x:=270/5.5=49.090909 minutes.
   From here we can continue calculating the time to the larger angles:
   (90+360), (270+360), (90+720), (270+720) etc.  until we a time value larger
   than 12 hours (720 minutes).
   }

end;

end.
