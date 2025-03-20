unit UCountDownTimer;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A TCountDown timer class that displays countdown times with one second resolution in
analog or digital form.

The fields and methods in the "Published" and "Public" sections are available to
the programmer.

Notes on some not-so-obvious features:

1.  A TPanel is passed to the Create constructor as a prototype for the timer.
    Location, size, font, etc. are inherited from the prototype.  This allows us
    many of the visual development advantages without the hassles involved with
    installed user components.

2. If an analog clock timer type is used (analogClock := true), the prototype panel
   height is compared to its width.  If height exceeds width by enough to display
   the timer in at least 6 point type, the times will be displayed in digital as
   well as analog form.

3. An "OnExpired" notify event exit is available to tell the user when time has
   counted down to 0.  By default, the OnExit event of the prototype is used as
   the OnExpired event.

}

interface
uses  Windows,Sysutils, controls, forms, classes,graphics, extctrls, mmsystem;

 type
 TrunMode=(Countup, CountDown);
 TCountDown=class(Tpanel)
    private
      Fstarttime:TDateTime;
      Fcurrenttime:TDateTime;
      FanalogClock:boolean; {determines whether the timer is analog or digital}
      FRunMode:TRunMode;
      FOnExpired:TNotifyevent;
      FOnTimerpop:TNotifyevent;
      fmtstr:string;
      FNoSound:boolean;  {true if no "click" wave file found or set by user}
      timer1:TTimer;
      Timerset:boolean;
      ClickSound:pointer;
      StartTOD:TDateTime;

      {analog clock fields}
      Image1:TImage; {the clock image for analog timer}
      Panel1:TPanel;  {the digital time display on analog timer}
      center:TPoint;
      shandlen, mhandlen, hhandlen:integer; {handlengths}
      lastsc,lastmn, lasthr:TPoint; {hand positions, used to erase before redrawing}
      textheight:integer;  {pixel height of area for text display below analog clock}


      function  GetRunning:boolean;
      procedure SetanalogClock(value:boolean);
      procedure Setnosound(value:boolean);
      procedure SetStartTime(value:TDateTime);
      procedure SetfontSize(p:TPanel; h:integer);
      procedure SetRunMode(value:TRunMode);
      procedure updatetimer;
      procedure timerpop(sender:TObject);

    published
      property  starttime:TDateTIme read FStarttime write SetStartTime;
      property  currenttime:TDateTime read FCurrenttime;
      property  running:boolean read Getrunning;
      property  runmode:TRunMode Read FRunmode write SetRunmode;
      property  analogClock:boolean read FanalogClock write SetanalogClock;
      property  Nosound:boolean read FNosound write SetNosound;
      property  onexpires:TNotifyevent read FonExpired write FOnExpired;
      property  onTimerPop:TNotifyevent read FonTimerPop write FOnTimerPop;

    public
      constructor Create(Prototype:Tpanel); reintroduce;
      destructor Destroy; override;
      procedure SetStartTimeHMS(H,M,S:integer);
      procedure startTimer;
      procedure stoptimer;
  end;

implementation

{$R ClickSound.res}


function GetResourceAsPointer(ResName: pchar; ResType: pchar;
                               out Size: longword): pointer;
 var    InfoBlock: HRSRC;
        GlobalMemoryBlock: HGLOBAL;
 begin
   InfoBlock := FindResource(hInstance, resname, restype);
   if InfoBlock = 0 then raise Exception.Create(SysErrorMessage(GetLastError));
   size := SizeofResource(hInstance, InfoBlock);
   if size = 0 then      raise Exception.Create(SysErrorMessage(GetLastError));
   GlobalMemoryBlock := LoadResource(hInstance, InfoBlock);
   if GlobalMemoryBlock = 0 then      raise Exception.Create(SysErrorMessage(GetLastError));
   Result := LockResource(GlobalMemoryBlock);
   if Result = nil then      raise Exception.Create(SysErrorMessage(GetLastError));
end;

   {************* Create ***********}
   constructor TCountDown.Create(Prototype:TPanel);
   var size:longword;
   begin
     inherited create(prototype.owner);
     parent:=prototype.parent;
     boundsrect:=prototype.boundsrect;
     brush.assign(prototype.brush);
     color:=prototype.color;
     borderstyle:=prototype.borderstyle;
     borderwidth:=prototype.borderwidth;
     bevelouter:=prototype.bevelouter;
     bevelinner:=prototype.bevelinner;
     if Assigned(prototype.onexit) then FonExpired:=prototype.onexit;
     FanalogClock:=false;
     timer1:=ttimer.create(self);
     timer1.ontimer:=Timerpop;
     timer1.enabled:=false;
     timer1.interval:=1000;
     ClickSound := GetResourceAsPointer('ClickSound', 'wave', size);
     Fnosound:=false;
     FStartTime:=1/86400;
     FCurrentTime:=FStartTime;
     FRunMode:=CountDown;
     timerset:=false;
   end;

   destructor TCountDown.destroy;
   begin
     if assigned(panel1) then panel1.free;
     if assigned(image1) then image1.free;
     timer1.free;
     //clicksound.free;
     inherited;
   end;

   {*************** SetRunning *************}
   function TCountDown.GetRunning:boolean;
   begin
     result:=Timer1.enabled;
   end;

   {************* SetNoSound ************}
   procedure TCountDown.SetNoSound(value:boolean);
   begin
     FNoSound:=value;
   end;

   {************* SetAnalogClock ************}
   procedure TCountdown.SetanalogClock(value:boolean);
   var dotloc:integer;
       i:integer;
       minheight:integer;
   begin
     FanalogClock:=value;
     if assigned(panel1) then freeandnil(panel1);
     if fAnalogClock then
     begin {set up the analog clock image}
       font.size:=6;
       font.style:=[fsbold];
       minheight:=-font.height;
       if height-width>minheight then
       begin
         textheight:= height-width;
         panel1:=TPanel.create(self);
         with panel1 do
         begin
           parent:=self;
           height:=textheight;
           align:=albottom;
           color:=self.color;
         end;
       end
       else
       begin
         width:=height;
         panel1:=nil;
       end;

       Image1:=TImage.create(self);
       image1.parent:=self;
       image1.align:=alClient;
       with image1.picture.bitmap,canvas do
       begin
         width:=image1.width;
         height:=image1.height;
         center.x:=image1.picture.bitmap.width div 2;
         center.y:=height div 2;
         shandlen:=3*width div 8;
         mhandLen:=width div 3;
         canvas.ellipse(0,0,width,height);
         dotloc:=9*width div 20;
         for i:= 1 to 12 do  {draw clock dots}
         ellipse(trunc(center.x+dotloc*cos(2*pi*i/12)-3),
              trunc(center.y+dotloc*sin(2*pi*i/12)-3),
              trunc(center.x+dotloc*cos(2*pi*i/12)+3),
              trunc(center.y+dotloc*sin(2*pi*i/12)+3)  );
         pen.width:=1;
         lastsc:=center;
         lastmn:=center;
         lasthr:=center;
       end;
     end
     else
     begin
       if assigned(image1) then freeandnil(image1);
       if assigned(panel1) then freeandnil(panel1);
     end;
   end;



   {*************** SetFontSize *************}
   procedure TCountdown.setfontSize(P:TPanel;H:integer);
   var
     str:string;
     tempcanvas:TCanvas;
     notused:HWnd;
   begin
     if h=0 then {no hour value needed}
     begin
       str:='00:00';
       fmtstr:='nn:ss';
     end
     else
     begin   {leave room for hours}
       str:='00:00:00';
       fmtstr:='hh:nn:ss';
     end;
     {We need a canvas to use textwidth and height functions but
      Canvas is not defined for Tpanel, so we'll make a temporary one
      and determine the foint size ther and the assign that font to
      our countdown timer}
     tempCanvas := TCanvas.Create;
     tempCanvas.Handle := GetDeviceContext(notUsed);
     tempcanvas.font.assign(font);
     with tempcanvas do
     begin
       font.size:=6;
       font.style:=[fsbold];
       {loop increasing font size until one of the dimensions
                    is too large}
       while (textwidth(str)<width) and (textheight(str)<height)
             and (font.size<100) do font.size:=font.size+2;
       font.size:=font.size-2;
     end;
     font.assign(tempcanvas.font);
     tempcanvas.free;
   end;

   {************ SetStartTime ************}
   procedure TCountDown.SetStartTime(value:TDateTime);
   var
     H,M,S,MS:word;
   begin
     decodetime(value, H,M,S,MS);
     setstarttimeHMS(H,M,S);
   end;

   {********* SetStartTimeHMS *************}
   procedure TCountDown.SetStartTimeHMS(H,M,S:integer);
   begin
     Fstarttime:=Encodetime(h,m,s,0);
     Fcurrenttime:=FStarttime;
     if not fanalogClock then
     begin  {digital timer}
       setfontSize(self,h);   {set time size & format, hour value determines whether to include HH:}
     end
     else
     begin {set up to draw initial analog clock}
      // if assigned(panel1) then freeandnil(Panel1);
       if h=0 then hHandLen:=0 else HHandLen:=width div 5;
       setfontSize(panel1,h);
       if font.size>12 then font.size:=12;
       panel1.caption:=formatdatetime(fmtstr,Fstarttime); {show initial time}
     end;
     updatetimer; {just to get the first time display}
     timerset:=true;
   end;

   procedure TCountdown.setrunmode(Value:TRunMode);
   begin
     FRunmode:=value;
   end;


{*********** StartTimer **********}
 procedure TCountDown.startTimer;
 begin
    {in case the user tries to start the clock before setting it}
   if not timerset then setstarttimeHMS(0,0,0);
   StartTOD:=Now;
   timer1.enabled:=true;
 end;

 procedure TCountdown.stoptimer;
 begin
   timerset:=false;
   timer1.enabled:=false;
 end;

procedure TCountDown.Updatetimer;
var
  s,m,h,ms:word;
  stime,mtime,htime:extended;
  sangle,mangle,hangle:extended;
begin
  if Fnosound=false then PlaySound(ClickSound, 0,SND_MEMORY );
  if fanalogclock then  {Clock is analog}
  with image1.picture.bitmap{clock},canvas do
  begin
    {erase old hands}
    pen.width:=1;
    pen.color:=clwhite;
    moveto(center.x,center.y);
    lineto(lastsc.x,lastsc.y);
    moveto(center.x,center.y);
    lineto(lastmn.x,lastmn.y);
    pen.width:=3;
    moveto(center.x,center.y);
    lineto(lasthr.x,lasthr.y);
    decodetime(Fcurrenttime,h,m,s,ms);

    {drawnew hands}
    pen.width:=1;
    pen.color:=clblack;
    stime:=s/60;
    sangle:=stime*360;
    if sangle<0.01 then sangle:=0;

    mtime:=(m+stime)/60;
    mangle:=mtime*360;
    if mangle<0.01 then mangle:=0;

    h:=h mod 12;
    htime:=(h+mtime)/12;
    hangle:=htime*360;
    if hangle<0.01 then hangle:=0;

    moveto(center.x,center.y);
    lastsc.x:=trunc(center.x+shandlen*cos((sangle-90)*pi/180));
    lastsc.y:=trunc(center.y+shandlen*sin((sangle-90)*pi/180));
    lineto(lastsc.x,lastsc.y);

    moveto(center.x,center.y);
    lastmn.x:=trunc(center.x+mhandlen*cos((mangle-90)*pi/180));
    lastmn.y:=trunc(center.y+mhandlen*sin((mangle-90)*pi/180));
    lineto(lastmn.x,lastmn.y);

    pen.width:=3;
    moveto(center.x,center.y);
    lasthr.x:=trunc(center.x+hhandlen*cos((hangle-90)*pi/180));
    lasthr.y:=trunc(center.y+hhandlen*sin((hangle-90)*pi/180));
    lineto(lasthr.x,lasthr.Y);
    if assigned(panel1)
    then panel1.caption:= formatdatetime(fmtstr,currenttime);
  end
  else caption:= formatdatetime(fmtstr,currenttime);
  application.processmessages;
end;

{************** TimerPop ***********}
procedure tcountdown.timerpop(sender:TObject);
{Called once per second while timer is running}
var
  delta:TDatetime;
begin
  Delta:=now-StartTOD;
  if frunmode=countdown then
  begin
    FCurrentTime:=FStarttime-Delta;
    if FCurrenttime>=0.999/86400 then {> 1 second}
    Fcurrenttime:=Fcurrenttime - 1/86400; {reduce time by 1 second}
    updatetimer;
    if abs(Fcurrenttime) <= 0.5/86400 then  {Within 1/2 second of zero}
    begin
      timer1.enabled:=false;  {stop the timer}
      timerset:=false;
      If Assigned(FOnExpired) then FOnExpired(self); {Take onExpired exit if defined}
      If Assigned(FOnTimerpop) then FOnTimerpop(self); {Take onTimerPop exit if defined}

    end;
  end
  else
  begin
    FCurrentTime:=FStartTime+Delta;
    Fcurrenttime:=Fcurrenttime + 1/86400; {increase time by 1 second}
    updatetimer;
    If Assigned(FOnTimerPop) then FOnTimerPop(self); {Take onExpired exit if defined}

  end;
  application.processmessages;
end;

end.
