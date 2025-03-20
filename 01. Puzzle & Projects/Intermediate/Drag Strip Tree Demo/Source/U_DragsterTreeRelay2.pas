unit U_DragsterTreeRelay2;

{This is a simulation of  drag strip "Christmas tree" starting lights.  Original
version tests reaction time of two :drivers" when the Green light appears.
The Relay version adds a page to let user specify a schedule for changing lights
on an external physical tree model by closing the appropriate relays on a circuit
board connected to the computer.}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ComCtrls, synaser, ShellAPI;

type

 TimeEventRec=record
   Eventtype:integer;  {+1:=On, -1:=off}
   RelayNbr:integer;
   Eventtime:single;
 end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Start1A: TShape;
    Start1B: TShape;
    Start1C: TShape;
    Go1: TShape;
    Foul1: TShape;
    PreStage1A: TShape;
    PreStage1B: TShape;
    Stage1A: TShape;
    Stage1B: TShape;
    Start2A: TShape;
    Start2B: TShape;
    Start2C: TShape;
    Go2: TShape;
    Foul2: TShape;
    PreStage2A: TShape;
    PreStage2B: TShape;
    Stage2A: TShape;
    Stage2B: TShape;
    AutoTimer2: TTimer;
    PageControl1: TPageControl;
    PlaySheet: TTabSheet;
    RelaySheet: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    StringGrid1: TStringGrid;
    StartBtn: TButton;
    CycleTimeEdt: TEdit;
    Label4: TLabel;
    CycleBox: TCheckBox;
    Timer1: TTimer;
    AutoTimer1: TTimer;
    Label1: TLabel;
    PreStage1Btn: TButton;
    Stage1Btn: TButton;
    AutoStage: TCheckBox;
    TreeTypeGrp: TRadioGroup;
    PreStage2Btn: TButton;
    Stage2Btn: TButton;
    Label2: TLabel;
    Time2Lbl: TLabel;
    Time1Lbl: TLabel;
    ActivateBtn: TButton;
    ResetBtn: TButton;
    RelayBox: TCheckBox;
    Edit1: TEdit;
    RelayDelayEdt: TLabeledEdit;
    StaticText1: TStaticText;
    procedure PreStageBtnClick(Sender: TObject);
    procedure StageBtnClick(Sender: TObject);
    procedure ActivateBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure AutoStageClick(Sender: TObject);
    procedure AutoTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);

    procedure PageControl1Change(Sender: TObject);
    procedure RelayBoxClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StaticText1Click(Sender: TObject); public
    prestaged1, prestaged2:boolean;
    staged1, staged2:boolean;
    staged :boolean; {both staged}
    StartLightsOn:integer;  {how many of the start lights are on?}
    Greenlight:boolean;
    Starttime:TDateTime;
    Stopflag:boolean;
    Events: Array [1..14] of TimeEventrec; {The schedule of events}
    nbrevents, nextevent:integer;
    {Relay driver additions}
    ser:TBlockSerial; {serial port interface class}
    relaydelay:integer; {default minimum time between successive relay operations}
    boardfound:boolean; {relay board is connected}
    procedure Turn(Nbr:integer;Onoff:boolean); {sedn command to turn relay on or off}
    procedure RunCycle; {Run through Tree cycle}
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  {Name the colors - in case we want to adjust the later it easiest to change
   them here in one location    }
  OffYellow:integer=$02C2D2;
  OffGreen:integer=clGreen;
  Offred:integer=$D5;
  Yellow:integer= clYellow;
  Green:integer=clLime;
  Red:integer=clRed;
  LF:char=char(13); {linefeed for relay commands}
  {Relay constants}
  Names:array[1..8] of string =('1(Prestage)','2(Stage)','3 (Yellow1)','4 (Yellow2)',
                                '5 (Yellow3)','6 (Green)','7 (Red)','8 (Unused)');
  OnTimes:array[1..7]of single=(0.0,5.0,10.0,11.0,12.0,13.0,21.0);
  OffTimes: ARRAY[1..7] OF SINGLE =(10.0,10.0,11.0,12.0,13.0,18.0,24.0);

{************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  with stringGrid1 do
  begin
    cells[1,0]:='On at:';
    Cells[2,0]:='Off at:';
    for i:=1 to 7 do
    begin
      cells[0,i]:=names[i];
      cells[1,i]:=floattostr(ontimes[i]);
      cells[2,i]:=floattostr(offtimes[i]);
    end;
  end;
  boardfound:=false;
  Pagecontrol1.ActivePage:=PlaySheet;
end;


{********* PreStageBtnbClick *********}
procedure TForm1.PreStageBtnClick(Sender: TObject);
{Turn on "pre-staged" lights for car 1 or 2 depending on which button was clicked}

begin
  if sender=PreStage1Btn then
  begin
    Stage1Btn.enabled:=true;
    //Turn(P1,True);
    Prestage1A.brush.color:=yellow;
    PreStage1B.brush.color:=yellow;
    prestaged1:=true;
  end
  else
  begin
    Stage2Btn.enabled:=true;
    //Turn(P2,true);
    Prestage2A.brush.color:=yellow;
    PreStage2B.brush.color:=yellow;
    prestaged2:=true;
  end;
end;

{************ StageBtnClick *************}
procedure TForm1.StageBtnClick(Sender: TObject);
{Turn on "staged" lights for car 1 or 2 depending on which button was clicked}
begin
  if sender=stage1Btn then
  begin
    //Turn(S1,true);
    Stage1A.brush.color:=yellow;
    Stage1B.brush.color:=yellow;
    staged1:=true;
  end
  else
  begin
    //Turn(S2,true);
    Stage2A.brush.color:=yellow;
    Stage2B.brush.color:=yellow;
    staged2:=true;
  end;
  If Staged1 and Staged2 then
  begin {all staged lights are on, if autostage box was checked, then simulate
         a click of the activate button}
    staged:=true;
    if autostage.checked then
    begin
      sleep(2000);
      Activatebtnclick(sender); {simulate "Activate" button click}
      autostage.Checked:=false; {we can reset autostage flag now that we have checked it}
    end
    else ActivateBtn.enabled:=true;
  end;
end;


{******** ActivateBtnClick *************8}
procedure TForm1.ActivateBtnClick(Sender: TObject);
{For manually activating the start ight sequence}
begin
  If staged then
  case treetypegrp.itemindex of {set time to first start timer pop}
    0: timer1.interval:=500; {SportsmanStart: 1/2 second}
    1: timer1.interval:=400;     {ProStart: 0.4 second}
  end; {case}
  StartLightsOn:=0; {Initialize the count of starting lights
                    (large yellow + green light}
  timer1.enabled:=true;   {start the timer to control start lights}
end;


{************* ResetBNtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
{reset all the lights and switches for the next "race"}
begin
  {reset switches}
  stage1Btn.enabled:=false; {These also start disabled until prestage is complete}
  stage2Btn.enabled:=false;
  if pagecontrol1.activepage<>Relaysheet then
  begin
    prestage1btn.Enabled:=true;  {Autostage mught have disabled these}
    prestage2btn.Enabled:=true;
    treetypegrp.Enabled:=true;
  end;
  ActivateBtn.enabled:=false;
  StartLightsOn:=0;
  Staged:=false;
  //Autostage.checked:=false; {reset it later, not here}
  prestaged1:=false; prestaged2:=false;
  staged1:=false; staged2:=false;
  Greenlight:=false;
  time1lbl.caption:='';
  time2lbl.caption:='';

  {reset lights}
  //Turn(All, False);
  prestage1A.brush.color:=OffYellow;
  prestage1B.brush.color:=OffYellow;
  prestage2A.brush.color:=OffYellow;
  prestage2B.brush.color:=OffYellow;
  Stage1A.brush.color:=OffYellow;
  Stage1B.brush.color:=OffYellow;
  Stage2A.brush.color:=OffYellow;
  Stage2B.brush.color:=OffYellow;
  start1A.brush.color:=OffYellow;
  start1B.brush.color:=OffYellow;
  start1C.brush.color:=OffYellow;
  start2A.brush.color:=OffYellow;
  start2B.brush.color:=OffYellow;
  start2C.brush.color:=OffYellow;
  Go1.brush.color:=OffGreen;
  Go2.brush.color:=OffGreen;
  Foul1.brush.color:=OffRed;
  Foul2.brush.color:=OffRed;
end;


{*********** Timer1Timer ************}
procedure TForm1.Timer1Timer(Sender: TObject);
{Timer1 popped - turn on next lights based on current start lights-on count}
begin
  case treetypegrp.itemindex of
    0: begin {SportsmanStart: 3 rows of yellow's then green all 1/2 second apart}

         case StartlightsOn of
         0: begin
              //turn(Y1,True);
              Start1a.brush.color:=Yellow;
              Start2a.brush.color:=Yellow;
              Timer1.interval:=500; {1/2 second delay between lights}
            end;
         1: begin
              //Turn(Y2,True);
              Start1b.brush.color:=Yellow;
              Start2b.brush.color:=Yellow;
            end;
         2: begin
              //Turn(Y3,True);
              Start1c.brush.color:=Yellow;
              Start2c.brush.color:=Yellow;
            end;
         3: begin
              starttime:=now;
              //Turn(G,true);
              if foul1.Brush.Color<>red then
              begin
                //Turn(G1,True);
                go1.brush.color:=green;
              end;

              if foul2.Brush.color<>red then
              begin
                //turn(G2,True);
                go2.brush.color:=Green;
              end;
              Greenlight:=true;
              timer1.enabled:=false;
            end;
         end;
         inc(StartLightsOn);
       end;

    1: begin {ProStart:All yellow lights on for .4 seconf, then green}
         case StartlightsOn of
         0: begin  {all yellow lights on}
              //Turn(Y1,true);
              Start1a.brush.color:=Yellow;
              Start2a.brush.color:=Yellow;
              //Turn(Y2,true);
              Start1b.brush.color:=Yellow;
              Start2b.brush.color:=Yellow;
              //Turn(Y3,true);
              Start1c.brush.color:=Yellow;
              Start2c.brush.color:=Yellow;
              StartLightsOn:=3;
              //turnonrelay(1,2);
            end;

         3: begin  {3 yellows on, turn on green}
              timer1.enabled:=false; {turn timer off}
              if Foul1.brush.color<>red then
              begin
                //Turn(G1,true);
                Go1.brush.color:=Green;
              end;
              If foul2.brush.color<>red then
              begin
                //Turn(G2,true);
                Go2.brush.color:=Green;
              end;
              greenlight:=true;
              starttime:=now;  {save start time for reaction time measurement}
            end;
         end;
       end;
  end; {case}
end;


{********** AutoStageClick **********}
procedure TForm1.AutoStageClick(Sender: TObject);
{Automate the start sequence by simulating prestage and stage buttons for each
 carb using timers to set a random time that the button click exits are called}
begin
  If autostage.checked then
  begin
    resetbtnclick(sender);
    prestage1btn.Enabled:=false;
    prestage2btn.Enabled:=false;
    autotimer1.interval:=2000+random(3000);
    autotimer2.interval:=2000+random(3000);
    autotimer1.enabled:=true;
    autotimer2.enabled:=true;
  end;
end;

{************* AutoTimer ***********}
procedure TForm1.AutoTimer(Sender: TObject);
{common exit for timer pops for the two timers that are simulating prestage and
 staged events for the two cars.}
begin
  If sender =autotimer1 then
  begin
    if not prestaged1 then
    {It is time to prestage car 1 and set the timeer time for the stage event}
    begin
      autotimer1.interval:=2000+random(2000);
      prestagebtnclick(prestage1Btn)
    end
    else
    begin
      {otherwise, it is time to turn on stage lights for car 1 and stop this timer}
      autotimer1.enabled:=false;
      stagebtnclick(stage1btn);
    end;
  end
  else
  begin {car 2, same prestage and stage logic as for car 1}
    if not prestaged2 then
    begin
      autotimer2.interval:=2000+random(2000);
      prestagebtnclick(prestage2Btn)
    end
    else
    begin
      stagebtnclick(stage2btn);
      autotimer2.enabled:=false;
    end;
  end
end;

{************ FormKeyPress ************8}
procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
var
  time:TDatetime;
begin
  time:=now-starttime;
  If upcase(key)='Q' then
  begin
    if not greenlight then
    begin
      //Turn(R1,True);
      Foul1.Brush.color:=red;
      time1lbl.caption:='Foul!!!';
    end
    else time1lbl.caption:=format('Reaction: %6.3f seconds',[time*secsperday]);
  end
  else
  If upcase(key)='P' then
  begin
    if not greenlight then
    begin
      //Turn(R2,True);
      Foul2.Brush.color:=red;
      time2lbl.caption:='Foul!!!';
    end
    else
    begin
      time2lbl.caption:=format('Reaction: %6.3f seconds',[time*secsperday]);
    end
  end;
end;







{************** StartBtnClick **********}
procedure TForm1.StartBtnClick(Sender: TObject);
{Start Relay driver simulation}
var

  NextOn, NextOff:integer;
  cycletime:extended;
  nexttime:TDateTime;
  i,j:integer;
  temp:TimeEventrec;

  {---------- LoadTimesfromgrid -------}
  procedure LoadTimesFromGrid;
  var
    i:integer;
  begin
     with stringGrid1 do
    for i:=1 to rowcount-1 do
    begin
      names[i]:=cells[0,i];
      ontimes[i]:=strtofloatdef(cells[1,i],0);
      offtimes[i]:=strtofloatdef(cells[2,i],0);
    end;
  end;

  {------------------ MakeEvent --------------}
  function makeevent(newEventtype,newrelaynbr:integer; newEventtime:single):TimeEventRec;
  begin
    with result do
    begin
      Eventtype:=newEventType;
      RelayNbr:=NewRelayNbr;
      Eventtime:=NewEventTime;
    end;
  end;

begin {StartBtnClick}
  memo2.Clear;

  With StartBtn do
  begin
    if caption='Stop' then
    begin
      stopflag:=true;
      caption:='Start';
    end
    else
    Begin
      if relaybox.Checked then ser.SendString('reset'+lf);
      relaydelay:=strtointdef(relaydelayedt.text,100);
      if relaydelay<10 then relaydelay:=10;
      {merge on and off times to make a queue of event record in increasing time order}
      NextOn:=1;
      NextOff:=1;
      Nextevent:=1;
      stopflag:=false;
      loadtimesfromgrid;
      tag:=0;
      repeat
        If (NextOn<=high(Ontimes)) and (ontimes[nexton]<=offtimes[nextoff])
        then
        begin
          Events[nextevent]:=makeevent(+1,Nexton,ontimes[Nexton]);
          inc(nexton);
          inc(nextevent);
        end
        else
        If (NextOff<=high(Offtimes)) and
         (offtimes[nextoff]<=ontimes[nexton])
           or (nexton>high(ontimes))
        then
        begin
          Events[nextevent]:=makeevent(-1,Nextoff,offtimes[Nextoff]);
          inc(nextoff);
          inc(nextevent);
        end;
      until   (NextOn>high(Ontimes)) and (Nextoff> high(Offtimes));
      nbrevents:=nextevent-1;
      {sort events by relay nbr within action time}
      for i:=1 to nbrevents-1 do
      for j:=i+1 to nbrevents do
      if (events[j].eventtime<events[i].Eventtime)
         or ((events[j].eventtime=events[i].Eventtime) and (events[j].relaynbr<events[i].RelayNbr))
      then  {swap}
      begin
        temp:=events[j];
        events[j]:=events[i];
        events[i]:=temp;
      end;
      (*  {display entire relay cycle schedule - used for debigging}
      for i:=1 to nbrevents do
      with events[i] do
      begin
        if eventtype>0 then s:='On' else s:='Off';
        memo2.Lines.add(format('#%d %s at %6.1f',[relaynbr,s,eventtime]));
      end;
      *)
      caption:='Stop';
      if cyclebox.Checked then
      begin
        resetbtnclick(sender);
        starttime:=now;
        cycletime:=trunc(strtofloatdef(cycletimeedt.Text,0.0)*60);
        if cycletime<events[nbrevents].Eventtime
        then
        begin
          cycletime:=events[nbrevents].eventtime+10;
          cycletimeedt.Text:=format('%5.1f',[cycletime/60]);
        end;
        nexttime:=now+cycletime/secsperday;
        while not stopflag do
        begin
          runcycle;
          while now<nexttime do
          begin
            sleep(1000); //1000*(nexttime-now)/secsperday));
            application.processmessages;
            if stopflag {or (tag>0)} then break;
          end;
          nexttime:=nexttime+cycletime/secsperday;
        end;
      end
      else runcycle;
      caption:='Start';
    end;
  end;
end;

{************ RunCycle ************}
Procedure TForm1.RunCycle;

var
  starttime,stoptime:TDatetime;
begin
  nextevent:=1;
  starttime:=now;
  repeat
    with events[nextevent] do turn(Relaynbr,eventtype>0);
    inc(nextevent);
    if nextevent<=high(events) then
    begin
      stoptime:=starttime+events[nextevent].eventtime/secsperday;
      while (now<stoptime) and (not stopflag) do
      begin {delay until time for the next event, allowing delay to be interrupted}
        sleep(100);
        application.processmessages;
      end;
    end;
  until (nextevent>high(events)) or stopflag {or (tag>0)};
end;

{*********** Turn **************}
procedure TForm1.Turn(Nbr:integer;Onoff:boolean);
{Turn relay number "Nbr" on or off }
var
  c:TColor;
  nbrstr:string;
  onoffstr:string;
  s:string;
  m1,m2:string;
  delay:integer;
begin
  if relaybox.Checked then
  begin  {actual relay code}

    nbrstr:=inttostr(nbr-1);
    if onoff then
    begin
      onoffstr:='on ';
    end
    else
    begin
      onoffstr:='off ';
    end;
    delay:=relaydelay;
    s:='relay '+onoffstr +nbrstr + LF;  {the relay command to send}
    ser.sendstring(s);  {send it!}
    memo2.lines.add(s); {display the command}
    sleep(delay);
  end;

  {simulation of relay code on the program dusplay}
  case nbr of
    1:
    begin
      If OnOff then c:=yellow else c:=offyellow;
      Prestage1A.brush.color:=c;
      PreStage1B.brush.color:=c;
      Prestage2A.brush.color:=c;
      PreStage2B.brush.color:=c;
      m1:='1 (Pre-Staged)';
    end;
    2:
    Begin
      If OnOff then c:=yellow else c:=offyellow;
      Stage1A.brush.color:=c;
      Stage1B.brush.color:=c;
      Stage2A.brush.color:=c;
      Stage2B.brush.color:=c;
      m1:='2 (Staged)';
    end;
    3:
    begin
      If OnOff then c:=yellow else c:=offyellow;
      Start1a.brush.color:=c;
      Start2a.brush.color:=c;
      m1:='3 (Yellow 1)';
    end;
    4:
    begin
      If OnOff then c:=yellow else c:=offyellow;
      Start1b.brush.color:=c;
      Start2b.brush.color:=c;
      m1:='4 (Yellow 2)';
    end;
    5:
    begin
      If OnOff then c:=yellow else c:=offyellow;
      Start1c.brush.color:=c;
      Start2c.brush.color:=c;
      m1:='5 (Yellow 3)';
    end;
    6:
    begin
      If OnOff then c:=green else c:=offgreen;
      go1.brush.color:=c;
      go2.brush.color:=c;
      m1:='6 (Go!)';
    end;
    7:
    begin
      If OnOff then c:=red else c:=offred;
      foul1.Brush.Color:=c;
      foul2.Brush.Color:=c;
      m1:='7 (Foul)';
    end;
  end; {case}
  if onoff then m2:=' on' else m2:=' off';

  memo2.lines.add(timetostr(now)+': Simulate relay '+m1 + m2);
  application.processmessages;
end;

{************** PageControlChange ***********}
procedure TForm1.PageControl1Change(Sender: TObject);
{Setup display depending on which sheet is active}
begin
  if Pagecontrol1.activepage=RelaySheet then
  begin
    resetbtnclick(sender);
    Stage1Btn.enabled:=false;
    AutoStage.enabled:=false;
    TreeTypeGrp.enabled:=false;
    Stage2Btn.enabled:=false;
    Label1.Enabled:=false;
    Label2.enabled:=false;
    Time2Lbl.enabled:=false;
    Time1Lbl.enabled:=false;
    ActivateBtn.enabled:=false;
    ResetBtn.enabled:=false;
    PreStage1Btn.enabled:=false;
    PreStage2Btn.enabled:=false;
  end
  else
  begin
    PreStage1Btn.enabled:=true;
    Stage1Btn.enabled:=true;
    AutoStage.enabled:=true;
    TreeTypeGrp.enabled:=true;
    PreStage2Btn.enabled:=true;
    Stage2Btn.enabled:=true;
    label1.Enabled:=true;
    Label2.enabled:=true;
    Time2Lbl.enabled:=true;
    Time1Lbl.enabled:=true;
    ActivateBtn.enabled:=true;
    ResetBtn.enabled:=true;
    resetbtnclick(sender);
  end;
end;

{************ RelayBoxClick ********}
procedure TForm1.RelayBoxClick(Sender: TObject);
{allocate connection to the relay board and connect to it}
var
  s:string;
begin
  if relaybox.checked then
  begin
    ser:=TBlockSerial.Create;
    //ser.RaiseExcept:=True;
    boardfound:=false;
    RelayDelayEdt.visible:=true;
    ser.connect(edit1.text);
    if ser.lasterror<> sOK then
    with ser do
    begin
      if lasterror=2 then s:='Relay board not detected at specified port'
      else s:=ser.geterrordesc(ser.lasterror);
       showmessage(s);
       relaybox.checked:=false;
       boardfound:=false;
    end
    else
    begin
      Memo2.lines.add('Relay board connected');
      boardfound:=true;
      sleep(100);
    end;
  end
  else
  begin
    ser.free;
    RelayDelayEdt.visible:=false;
    if boardfound then memo2.Lines.add('Relay board disconnected');
  end;
end;

{****** FormCloseQuery ***************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Allow relay display cycles to be interuppted}
begin
  canclose:=true;
  stopflag:=true;
end;

{************* FoemClose ***********8}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If relaybox.Checked then ser.Free;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
