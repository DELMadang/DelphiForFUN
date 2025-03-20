unit UAnimate;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Simple animation of TSim class - uses TSim's callback procedure to intercept
 events and display them on screen}
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SimUnit, StdCtrls, Buttons, ComCtrls;

type
  TClassShape= class(TShape)
  {a job class waiting queue box}
    public
    CustClass:TCustomerClass;
    lbl:TLabel;
    cy:integer;
    nbrjobs:integer; {# of jobs currently waiting - used to determine where to
                       place then next job}
  end;

  TServershape=class(TShape)
  {a server box}
    public
    ServerNbr:integer;
    Server:TServer;
    Lbl:TLabel;
    cy:integer;
  end;

  TJob=class(TStaticText)
  {job animation display - wingding "smiley face" ('J' or 'K')}
    jobid:Tstatictext; {the job id text}
    public
    jobchar:char; {job class character}
    constructor create(Aowner:TComponent); override;
    procedure free;
  end;

  TAniForm = class(TForm)
    CloseBtn: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    Timebar: TTrackBar;
    Label3: TLabel;
    CompressTxt: TStaticText;
    SimTimeTxt: TStaticText;
    StaticText2: TStaticText;
    procedure CloseBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TimebarChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    classes:array of TClassShape;
    servers:array of TServerShape;
    nbrclasses,nbrservers:integer;
    moveincr:integer;
    joblist:TStringList;
    prevtime:TDateTime;
    animationSecs:single;
    timeformat:string;
    timecompression:single; {factor to convert real time to simulation time}
    Procedure Callback(Customer:TCustQueueObj);
    procedure movejob(job:TJob; p:TPoint);
    function getclassindex(cclass:char):integer;
    function getserverindex(s:Tserver):integer;
  end;

var
  AniForm: TAniForm;

implementation

uses U_DiscreteSim2;

var
  sleepamt:integer=0;
  offset:integer=20;

{$R *.DFM}

constructor TJob.create(Aowner:TComponent);
begin
  inherited;
  parent:=TWinControl(Aowner);
  left:=0;
  top:=0;
  {height:=50;}
  font.name:='wingdings';
  font.size:=14;
  font.style:=[fsbold];
  color:=claqua;
  caption:='K';
  jobid:=Tstatictext.create(Aowner);
  with jobid do
  begin
    autosize:=false;
    left:=self.width;
    top:=0;
    height:=14;
    width:=30;

    color:=clyellow;
    caption:='Job Id';
    font.size:=8;
    parent:=TWinControl(Aowner);
    borderstyle:=sbsSingle;
    
  end;

end;

procedure TJob.free;
begin
  jobid.free;
  inherited;
end;

{******************* FORMACTIVATE **************}
PROCEDURE TAniForm.Formactivate(Sender: Tobject);
Var
  h,w,i:Integer;
begin
  if nbrclasses>0 then for i:=0 to nbrclasses-1 do classes[i].free;
  if nbrservers>0 then for i:=0 to nbrservers-1 do servers[i].free;
  with sim do
  begin
    nbrclasses:=customerclasses.count;
    setlength(classes,nbrclasses);
    nbrservers:=servers.count;
    setlength(self.servers,nbrservers);
    h:=(height-100) div (nbrclasses+1);
    w:=(width-100) div 2;
    for i:=0 to nbrclasses-1 do
    begin
      classes[i]:=tClassShape.create(self);
      with classes[i] do
      begin
        parent:=self;
        shape:=StRoundrect;
        left:=50;
        top:= h*i+50;
        width:=w;
        height:=h;
        color:=ClTeal;
        Custclass:=CustomerClasses[i];
        Cy:= h*(i+1) div 2;
        nbrjobs:=0;
        Lbl:=Tlabel.create(self);
        with lbl do {label for the wait queue}
        begin
          parent:=self;
          left:=Classes[i].left+10;
          top:=Classes[I].top+10;
          caption:= Custclass.JobClassname;
          color:=clwindow;
          font.style:=[fsbold];
        end;
      end;
    end;
    h:=(height-100) div (nbrservers+1);
    for i:=0 to nbrservers-1 do
    begin
      self.servers[i]:=tServershape.Create(self);
      WITH self.servers[i] DO
      BEGIN
        parent:=self;
        shape:=StRoundrect;
        left:=self.width div 2 + 25;
        top:= h*i+50;
        width:=w;
        height:=h;
        color:=ClLime;
        self.servers[i].server:=TServer(sim.servers[i]);
        Cy:= top + H div 2;
        Lbl:=Tlabel.create(self);
        with lbl do  {label for the server}
        begin
          parent:=self;
          left:=self.servers[i].left+10;
          top:=self.servers[i].top+10;
          caption:=TServer(Sim.servers[i]).servername;
          color:=clwindow;
          font.style:=[fsbold];
        end;
      end;
    end;
  end;
  moveincr:=1;
  {release any jobs from previous run}
  if joblist.count>0
  then for  i:=0 to joblist.count-1 do TJob(joblist.objects[i]).free;
  joblist.clear;
  case form1.unitsgrp.itemindex of
    0: timeformat:='%7.3f  24-hour days'; {24 hr days}
    1: timeformat:='%7.3f  8-hour workdays';  {8 hr days}
    2: timeformat:='%7.3f  hours';    {hours}
    3: timeformat:='%7.2f  minutes';      {minutes}
    4: timeformat:='%7.0f  seconds';       {seconds}
  end;
  timebarchange(sender);
  prevtime:=now;
  animationsecs:=sim.currenttime*secsperday*sim.timefactor*timecompression;
END;



{*********************** Callback *******************}
Procedure TAniform.callback(Customer:TCustQueueObj);
{procedure called for each simulator event so we can animate the event}
var
  job:TJob;
  m,n,index,w:integer;
  jobsperRow, row, col:integer;
  prevleft,prevtop:integer;  {position of previous job}
  simsecs:single;
  curtime:TDatetime;


   procedure shiftjobsup(index:integer);
   {shift jobs in job queue back and up after a job departs}
       var
         i:integer;
         p:TPoint;
         begin
          {shift all queued jobs right and up to fill empty slot}
          for i:=index+1 to joblist.count-1 do

          begin
            job:=TJob(joblist.objects[i]);
            if job.jobchar=customer.custclassobj.custidchar then
            begin
              p:=point(prevleft,prevtop);
              prevleft:=job.left;
              prevtop:=TJob(joblist.objects[i]).top;
              movejob(job,point(p.x,job.top)); {move left/right}
              movejob(job,point(job.left,p.y)); {move down}
            end;
         end;
       end;

      procedure updateSimclock(secs:single);
      var
        s:single;
      begin
        s:=secs/sim.timefactor;
        simtimetxt.caption:=format(timeformat,[s]);
      end;

begin
  if sim.tag<>0 then exit; {stopping}
  with sim, customer do
  begin
    curtime:=now;
    animationsecs:=animationsecs+(curtime-prevtime)*secsperday*timecompression;
    prevtime:=curtime;
    updateSimClock(animationsecs);
    simsecs:=sim.currenttime*sim.timefactor;
    If animationsecs<simsecs then {synchronize runtimes by waiting if necessary}
    begin
      repeat
        sleep(10);
        updateSimClock(animationsecs);
        application.processmessages;
        curtime:=now;
        animationsecs:=animationsecs+(curtime-prevtime)*secsperday*timecompression;
        prevtime:=curtime;
      until (sim.tag<>0) or (animationsecs>=simsecs);
      if moveincr>1 then dec(moveincr);
    end
    else If moveincr<10 then inc(moveincr);
    application.processmessages; {one more chance to update clock display, etc.}
    if sim.tag<>0 then exit;  {user hit stop while waiting for event}
    case eventtype of
    arrival:
      begin
        job:=TJob.create(self);
        job.jobid.caption:=custuniqueId;
        job.jobchar:=custclassobj.custidchar;
        n:=getclassindex(custclassobj.custidchar);
        with classes[n] do
        begin
          inc(nbrjobs);
          begin
            w:=(job.width+job.jobid.width+5);
            jobsperrow:=(width-5) div w;
            col:= (nbrjobs-1) mod jobsperrow;
            row:= (nbrjobs-1) div jobsperrow;
            movejob(job,point(job.left,top+25+row*(job.height+5))); {move down}
            movejob(job,point(left+20+(jobsperrow-col-1)*w,job.top)); {move left}
          end;
        end;
        joblist.addobject(custuniqueId,job);
      end;
    startprocess:
      begin
        n:=getclassindex(custclassobj.custidchar);
        m:=getserverindex(serverObj);
        index:=joblist.indexof(custuniqueid);
        If index>=0 then
        begin
          job:=TJob(joblist.objects[index]);
          prevleft:=job.left;  {save these before we move the job to the server}
          prevtop:=job.top;
          job.caption:='J'; {happy now!}
          with self.servers[m] do
            movejob(job,point(left+width div 2,cy));
          dec(classes[n].nbrjobs);
          shiftjobsup(index); {close up the waiting jobs display}
        end;
      end;
    departure, maxwaitexceeded:
      begin
        if eventtype=maxwaitexceeded then
        begin
          n:=getclassindex(custclassobj.custidchar);
          dec(classes[n].nbrjobs);
        end;
        index:=joblist.indexof(custuniqueid);
        if index>=0 then
        begin  {job - exit stage right}
          job:=TJob(joblist.objects[index]);
          prevleft:=job.left;  {save these before we removing the job}
          prevtop:=job.top;
          If eventtype=maxwaitexceeded then job.caption:='L'; {unhappy face}
          movejob(job,point(width-job.width-job.jobid.width-1,job.top));
          job.free;
          application.processmessages;
          if eventtype=maxwaitexceeded then shiftjobsup(index);
          joblist.delete(index);
        end;
      end;
    end;
  end;
end;

{******************* GetClassIndex **********}
function TAniform.getclassindex(cclass:char):integer;
{find the classes entry for this class}
var  i:integer;
begin
  result:=-1;
  for i:= 0 to nbrclasses-1 do
  if cclass=classes[i].custclass.custidchar then
  begin
    result:=i;
    break;
  end;
end;

{********************** GetServerIndex *************}
function TAniform.getserverindex(s:Tserver):integer;
{find the server entry for this sewrver}
var  i:integer;
begin
  result:=-1;
  for i:= 0 to nbrservers-1 do
  if s=servers[i].server then
  begin
    result:=i;
    break;
  end;
end;

{******************** MoveJob **************}
procedure Taniform.movejob(job:TJob; p:TPoint);
{animate moving a job from its current location to point P}
  var
    dx,dy:integer;
    startx,starty:integer;
    newx,newy:integer;
    stopx,stopy:integer;
  begin
    with job do
    begin
      stopx:=p.x;
      stopy:=p.y;
      startx:=left;
      starty:=top;
      If stopx>startx then dx:=moveincr else dx:=-moveincr;
      If stopy>starty then dy:=moveincr else dy:=-moveincr;
      newy:=starty;
      while newy<>stopy do
      Begin
        newy:=newy+dy;
        If ((dy<0) and (newy<stopy)) or ((dy>0) and (newy>stopy))
        then newy:=stopy;
        top:=newy;
        jobid.top:=newy;
        application.processmessages;
      end;
      newx:=startx;
      while newx<>stopx do
      Begin
        newx:=newx+dx;
        If ((dx<0) and (newx<stopx)) or ((dx>0) and (newx>stopx))
        then newx:=stopx;
        left:=newx;
        jobid.left:=newx+width;
        application.processmessages;
      end;
    end;
  end;

{************* CloseBtnClick ***********}
procedure TAniForm.CloseBtnClick(Sender: TObject);
begin  {sim.tag:=1;} end;



procedure TAniForm.FormClick(Sender: TObject);
begin
  {sim.tag:=1;}
end;

procedure TAniForm.FormCreate(Sender: TObject);
begin
  joblist:=TStringList.create;
  nbrclasses:=0;
  nbrservers:=0;
end;

{****************** FormCloseQuery *************}
procedure TAniForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{User wants to stop animation }
begin
  sim.callback:=nil;
  {sim.tag:=1;}
  canclose:=true;
end;

procedure TAniForm.TimebarChange(Sender: TObject);
{user moved the time compression trackbar - update the displayed value}
vaR i:integer;
begin
  timecompression:=1;
  for i:= 1 to timebar.position-1 do timecompression:=timecompression*10;
  Compresstxt.caption:=floattostr(Timecompression);
end;

end.
