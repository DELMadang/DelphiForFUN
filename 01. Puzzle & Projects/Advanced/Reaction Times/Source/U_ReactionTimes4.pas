unit U_ReactionTimes4;
 {Copyright © 2001-2013, Gary Darby,  www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpos
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A reaction time measurement program
  An identified user (subject) must response as rapidly as possibl;e to a series
  of targets flashed on the screen.  Resulting times are recording in a data
  file for further analysis.  A second unit provides a form for the
  "examiner" to define additional tests.
}

{Version 3.2 adds
  . Ability to display both visual and audible  stimuli in the same trial
  . Ability to set minimum and maximum display times to define the valid
    response time range.  Response times less than "early" or greater than
    "late" time will not have statistics computed except that the count
     of such invalid responses during the trial will be recorded.
  . The "No cheating please" message is now optional.
  . Sound playback is now interrupted when the user responds.
  . Count of early ot late response times is now displayed at the end of
    each trial.
 }

{Version 4:  JPEG Image list support.   Images shown in sequence selected with
 an option to write a record for every image displayed (even if response was
 early or late).  This allow response times in the detail response file to be
 associated with specific images by their position in the file}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, filectrl, mmsystem, ShellAPI, UDFFRegistry,JPEG;

type
  Tmode=(done, timingreaction ,targetdelay, badclick);

  TForm1 = class(TForm)
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Administration1: TMenuItem;
    EditTrialDefinitions1: TMenuItem;
    LogonNewUser1: TMenuItem;
    StartPnl: TPanel;
    TrialPnl: TPanel;
    Trialdefsbox: TListBox;
    Label1: TLabel;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Label2: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Shape1: TShape;
    Memo2: TMemo;
    Image1: TImage;
    procedure StartBtnClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TrialDefsBoxChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure EditTrialDefinitions1Click(Sender: TObject);
    procedure LogonNewUser1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    {target drawing parameters}
    dotshape:TShapeType;
    dotsizexminpct, dotsizexmaxpct:integer;
    dotsizeyminpct, dotsizeymaxpct:integer;
    mindelay,maxdelay:integer;
    dotcolor:TColor;
    image:TImage;
    maxsamples:integer;
    fixedtarget:boolean;{true= same position, false= move it randomly each time}

    {performance variables}
    starttime:TDatetime;
    Cumtime, cumtime2,mintime,maxtime:double;
    freq, startcount:int64;  {performance counter frequency and startcount}
    goodcount, earlycount:integer;   {nbr of times subject clicked early}

    mode:TMode;  {current mode}
    Soundname:string; {name of file or resource}
    soundtype:integer;
    trialid, userId:string;
    trialdetail:array of real;
    workdir:string;{directory to save files if not to be saved in program directory}
    function drawAdot:boolean;
    procedure savedata;

  end;

var
  Form1: TForm1;

implementation

uses DFFUtils, U_ReactionTrialDefs4;

{$R *.DFM}

{*********************** StartBtnClick ***************}
procedure TForm1.StartBtnClick(Sender: TObject);
{Start a trial}

  procedure resettimes;
  begin
    earlycount:=0;
    goodcount:=0;
    cumtime:=0;
    cumtime2:=0;  {sum of squares of response times}
    maxtime:=0;
    mintime:=100;
    startpnl.visible:=false;
    application.processmessages;
  end;

var
  i:integer;
  t:tTrialDefObj;
begin
   t:=TTrialDefObj(trialdefsbox.items.objects[trialdefsbox.itemindex]);
   with t do
  begin  {get target generation values}
    if audible then
    begin
      if resourcename='User1' then
      begin
        soundtype:=SND_FILENAME;
        soundname:='User1.wav';
      end
      else
      begin
        SoundType:=SND_RESOURCE;
        Soundname:=resourcename;
      end;
    end;
    if visual then
    begin
      dotshape:=Targetshape;
      if targetshape<>stsquare then
      begin
        dotsizexminpct:=XMinSize;
        dotsizexmaxpct:=XMaxSize;
        dotsizeyminpct:=YMinSize;
        dotsizeymaxpct:=YMaxSize;
        fixedtarget:=fixedtargetposition;

        dotcolor:=targetcolor;
      end
      else
      with imagelist do
      begin
        for i:=0 to count-1 do
        begin
          if fileexists(strings[i]) then
          begin
            if assigned(Timage(objects[i])) then TImage(objects[i]).free;
            Imagelist.objects[i]:= TImage.Create(Image1.owner);
            with timage(imagelist.objects[i]) do
            begin
              parent:=image1.parent;
              autosize:=true;
              visible:=false;
              OnMouseDown:=image1Mousedown;
              picture.loadfromfile(strings[i]);
              left:=(panel1.width-width) div 2;
              top:=(panel1.height-height) div 2;
            end;
          end;
        end;
      end;
    end;
    maxsamples:=nbrsamples;
    self.mindelay:=mindelay;
    self.maxdelay:=maxdelay;
    timer1.Interval:=1000*maxdelay;
    panel1.color:=backgroundcolor;
    trialid:=trialdefid;
  end;
  setlength(trialdetail, maxsamples+1);
  resettimes;
  DrawADot;{draw the first target. after that, user response triggers the next}
end;

{************************ DrawADot **********************}
function TForm1.drawAdot{(calibration:boolean)}:boolean;
{wait a bit and draw a target}
var
  dotsizex,dotsizey:integer;
  xrange,yrange,x,y:integer;
  Time:TDatetime;
  t:TTrialDefObj;
  usecount:integer;
begin
  result:=true;
  with trialdefsbox do t:=TtrialDefObj(items.objects[itemindex]);
  with trialdefsbox, t, panel1 do
  begin
    mode:=targetdelay;
    if visual then
    begin  {visual stimuli}
      dotsizex:=(dotsizexminpct+random(dotsizexmaxpct-dotsizexminpct))*width div 100;
      dotsizey:=(dotsizeyminpct+random(dotsizeymaxpct-dotsizeyminpct))*height div 100;
      //with panel1 do
      If fixedtarget then
      begin {fixed location - set coordinates to center the target}
        x:=(width-dotsizex) div 2;
        y:=(height-dotsizey) div 2;
      end
      else
      begin {random location - set coordinates to keep target on the screen}
        XRange:=width-dotsizex;
        YRange:=height-dotsizey;
        x:=random(Xrange);
        y:=random(yRange);
      end;
      if dotshape<>stsquare then
      with shape1 do
      begin
        left:=x;
        top:=y;
        width:=dotsizex;
        height:=dotsizey;
        brush.color:=dotcolor;
        shape:=dotshape;
      end;
    end;
    {Wait for a random amount of time befire displaying the next stimulus}
    Time:=now+(mindelay+random(1000*(maxdelay-mindelay))/1000)/secsperday {- overheadtime};
    repeat
      sleep(10); {reduce CPU usage in the wait loop}
      application.processmessages; {wait for delay time to elapse}
    until now>=Time;
    if audible
    then playsound(pchar(soundname),0,SoundType+Snd_Async);
    if visual then
    begin
      If dotshape<>stsquare then shape1.Visible:=true
      else
      with t.imagelist do
      if count >0 then
      begin    {we have images to display}
        {select which image to display}
        usecount:=goodcount;
        if form2.writealldetail.checked then inc(usecount,earlycount);
        image:= TImage(objects[usecount mod count]); {wrap around if necessary}
        image.Visible:=true; {show it}
      end
      else
      begin
        showmessage('No images in the image display list. Trial aborted');
        result:=false;
        mode:=done;
        exit;
      end;
    end;
    application.processmessages;
    QueryPerformanceCounter(startcount); {start timing the response time}
    mode:=timingreaction;
    timer1.enabled:=true; {start a timer for max wait time seconds}
  end;
end;

{************************* Image1MouseDown *******************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  rt:double;
  endcount:Int64;
  timeOk, writeall, AllDone:boolean;
  t:tTrialDefObj;
  msg, msg2:string;
begin
  If mode = targetdelay then
  begin
    timer1.enabled:=false;
    mode:=timingReaction;  {early click}
    queryperformancecounter(startcount);  {make sure that time records as early}
  end;
  if (mode=timingreaction) then
  begin
    queryperformanceCounter(endcount);
    timer1.enabled:=false;
    rt:=(endcount-startcount)/Freq; {response time in seconds}
    mode:=targetdelay;
    with trialdefsbox do t:= TtrialDefObj(items.objects[itemindex]);
    {Stop/Hide stimulus object}
    If t.audible then playsound(nil,0,0);; {stop any playing file}
    if dotshape<>stSquare then shape1.visible:=false else image.visible:=false;
    {Is time in range?}
    If ((rt>=form2.earlyClickTime+0.01) and (rt<=form2.lateClickTime-0.01))
    then timeOK:=true else
    begin
      timeok:=false;
      {adjust times to standard "out of bounds" times}
      if rt<form2.EarlyClickTime+0.01 then rt:=form2.EarlyClickTime
      else rt:=form2.LateClickTime;
    end;
    {Write all detail?}
    Writeall:=form2.WriteAllDetail.checked;
    {Was this the last sample to process?}
    If ((not writeall) and (goodcount+1>=maxsamples))
       or (writeall and (earlycount+goodcount+1>=maxsamples))
    then Alldone:=true else Alldone:=false;

    if timeOK then
    begin
      if writeall then trialdetail[earlycount+goodcount]:=rt
      else trialdetail[goodcount]:=rt;
      inc(goodcount);

      {Accumulate total stats}
      if rt<mintime then mintime:=rt;
      if rt>maxtime then maxtime:=rt;
      cumtime:=cumtime+rt;
      cumtime2:=cumtime2+rt*rt;
    end
    else
    begin {invalid response time (early or late)}
      if writeall then trialdetail[earlycount+goodcount]:=rt;
      inc(earlycount);
      {If early, may give "No Cheating" msg}
      if (rt<=form2.EarlyClickTime) and (form2.earlygrp.itemindex=1)
      then Showmessage('No cheating please!');
    end;
    if AllDone then
    begin
      if goodcount>0
      then msg:=floattostrF(cumtime/goodcount,ffGeneral,6,3)+' seconds'
      else msg:='N/A';
      If earlycount=0 then msg2:=''
      else msg2:=#13+inttostr(earlycount)+' early/late samples are not inluded in these stats.';

      showmessage('For '+inttostr(goodcount)+ ' samples with responses, your mean reaction time was '
       +msg
       +#13+'Longest time: ' + floattostrf(maxtime,ffgeneral,6,3)+' seconds'
       +#13+'Shortest time: '+floattostrf(mintime,ffgeneral,6,3)+' seconds'
       +msg2);
      savedata; {save the results to a file}
      mode:=done;
      startpnl.visible:=true;
    end
    else DrawADot;
  end;
end;

{********************* SaveData *******************}
procedure TForm1.savedata;
{Append trial results to a file}
var
  rec:string;
  f:textfile;
  nowstr, filename:string;
  i:integer;
  d:string;
  count:integer;
begin
  case form2.Delimiter.itemindex of
      0: d:=', ';
      1: d:=' ';
      2: d:=';';
      3: d:='*';
      else d:='?';
    end;
  nowstr:='"'+datetimetostr(now)+'"';
  If form2.SumryBox.checked then
  begin
    {make a comma delimited text record}
    rec:=format('%*s%s%*s%s%*s%s%2d%s%6.3f%s%6.3f%s%7.4f%s%7.4f%s%2d',
                             [length(userid),userid,d,length(trialid),
                             ansiquotedstr(trialid,'"'),d,
                              length(nowstr),nowstr,d,goodcount,d,maxtime,d,
                              mintime,d,cumtime,d,cumtime2,d,earlycount]);
    filename:={workdir+}form2.sumrynameedt.text;
    assignfile(f,filename);
    if not fileexists(filename) then
    begin {If no file, make one}
      rewrite(f);
      {write a line of column headers}
      writeln(f,'User,Trial_Id,Date_Time,Samples,Longest,Shortest,Total,Sum_Squares,Early_Late_count');
      closefile(f);
    end;
    append(f);
    writeln(f,rec);
    closefile(f);
  end;
  if form2.detailbox.checked then
  begin
    nowstr:='"'+datetimetostr(now)+'"';
    {make a comma delimited text record}
    rec:=format('ID%s%*s%s%*s%s%*s',
                             [d,length(userid),userid,d,
                              length(trialid),trialid,d,
                              length(nowstr),nowstr]);
    filename:=form2.detailnameedt.text;
    assignfile(f,filename);
    if not fileexists(filename) then
    begin {If no file, make one}
      rewrite(f);
      {write a line of column headers}
      closefile(f);
    end;
    append(f);
    writeln(f,rec);
    count:=goodcount;
    if form2.writealldetail.checked then inc(count,earlycount);
    for i:=0 to count-1 do
    if trialdetail[i]>0 then writeln(f,format('%6.3f',[trialdetail[i]]));
    closefile(f);
  end;
end;

{************************** Timer1Timer ******************}
procedure TForm1.Timer1Timer(Sender: TObject);
begin  {max time timer popped without a user response, ignore this point}
  timer1.enabled:=false;
  if mode=timingreaction then Image1mousedown(sender,mbleft,[],0,0);
end;

{******************* FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
{Start up stuff}
var
  i:integer;
begin
  mode:=done;
  windowstate:=wsmaximized;
  trialdefsbox.itemindex:=0;
  queryPerformancefrequency(freq);
  form2.LoadCases;
  FreeAndClear(trialdefsbox);
  with form2.trialsbox do
  for i:= 0 to items.count-1 do
  with TTrialDefObj(items.objects[i]) do
     if active then trialdefsbox.items.addobject(items[i],items.objects[i]);

  trialdefsbox.itemindex:=0;
  trialdefsboxchange(sender);
  LogonNewUser1Click(sender);
  startpnl.Visible:=true; {StartPnl simulates a button }
  if paramcount>0 then workdir:=Includetrailingbackslash(paramstr(1))
  else
  begin
    workdir:=GetWorkdir;
  end;
  randomize;
end;


{***************** TrialBoxDefsChange ****************}
procedure TForm1.TrialDefsBoxChange(Sender: TObject);
begin
  memo1.clear;
  if trialdefsbox.itemindex>=0 then
  with trialdefsbox , TTrialDefObj(items.objects[itemindex]) do
  memo1.lines.add(description);
end;

{************************ FormResize ****************}
procedure TForm1.FormResize(Sender: TObject);
{Set up the controls sizes based on form size}
begin
  with trialpnl do
  begin
    left:=0;
    top:=0;
    {make trial selection panel use all unclaimed height}
    trialdefsbox.height:=height-label1.height-30;
  end;
  with panel1 do {set the image area to fill right side}
  begin
    top:=0;
    left:=trialpnl.width;
    height:=form1.clientheight-statictext1.height-statictext2.height;
    width:=form1.clientwidth-left;
  end;
  with startpnl do {center the start "button"}
  begin
    left:=(panel1.width-width) div 2;
    top:=(panel1.height-height) div 2;
  end;
end;

{********************* EditTrialDefinitons1Click ***************}
procedure TForm1.EditTrialDefinitions1Click(Sender: TObject);
var i:integer;
begin
  form2.showmodal;
  FreeAndClear(TrialDefsBox);
  with form2.trialsbox do
  for i:= 0 to items.count-1 do
  with TTrialDefObj(items.objects[i]) do
     if active then trialdefsbox.items.addobject(items[i],items.objects[i]);

  trialdefsbox.itemindex:=0;
  trialdefsboxchange(sender);
end;

{****************** LogonNewUser1Click ***************}
procedure TForm1.LogonNewUser1Click(Sender: TObject);
begin
  Userid:=InputBox('User Logon','Enter name or Id',Form2.DefaultName.text);
  If userid='' then
  begin
    showmessage('User name required to play!' );
    close;
  end;
end;

{******************* FormKeyDown ******************}
procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Preview all key presses - if timing then treat keypress like a mouse click}
begin
  Image1mousedown(sender,mbleft,[],0,0);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

