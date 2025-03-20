unit U_metronome2;
{Copyright  © 2005 - 2013 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem,  StdCtrls, ComCtrls, ExtCtrls, DFFUtils, shellAPI, Spin, IniFiles,
  Menus;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Bevel1: TBevel;
    Label1: TLabel;
    StartBtn: TButton;
    SoundGrp: TRadioGroup;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    BeatRate: TSpinEdit;
    PriorityGrp: TRadioGroup;
    Popup1: TPopupMenu;
    Open1: TMenuItem;
    Replace1: TMenuItem;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure StartBtnClick(Sender: TObject);
    procedure SoundGrpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
    procedure BeatRateChange(Sender: TObject);
    procedure BeatRateClick(Sender: TObject);
    procedure PriorityGrpClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure replacefile;
    procedure Open1Click(Sender: TObject);
    procedure Replace1Click(Sender: TObject);
  public
    clicksound:TMemorystream;
    freq,interval:int64;
    BeatsPerMinute, BeatsPerSecond:integer;
    dir:string;
    Procedure LoadInitData;
    Procedure SaveInitData;
    function ExtractBaseName(s:string):string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  clicknames:array of string;
  (*
  startnames:array [0..3] of string =('click1.wav',
                                    'click2.wav',
                                    'click3.wav',
                                    'Other');
  *)

{********** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
   SetmemoMargins(memo1, 20,20,20,20);
   reformatmemo(memo1);
  {In case default click files are not available}
  dir:=extractfilepath(application.exename);
  opendialog1.InitialDir:=dir;
  setlength(clicknames,Soundgrp.items.count);
  LoadInitData;

  {Get intial click sound setup and ready to play}
  clicksound:=TMemorystream.create;
  soundgrpclick(sender); {go load initial click wave file}
  {play sound one time to get playsound stuff initialized and make smoother start later}
  //PriorityGrpClick(sender);    {not working}
end;





{*********** StartBtnClick **********}
procedure TForm1.StartBtnClick(Sender: TObject);
var
  count1, count2, countdiff:int64;
  sleepcounts:int64;
begin
  if StartBtn.caption='Start' then
  begin
    tag:=0;
    StartBtn.caption:='Stop'; {Use next click  to stop metronome}
    queryperformancefrequency(freq);  {get timer counts per second}
    BeatsPerMinute:=Beatrate.Value;
    BeatsPerSecond:=BeatsPerMinute div 60;
    interval:=freq*60 div BeatsPerMinute; {calc timer counts per click}
    sleepcounts:=freq div 20;  {counts per 50 ms (50/1000) }
    queryperformancecounter(count1); {get start count}

    playsound(clicksound.memory,0, snd_memory+snd_async); {click}
    while tag=0 do {loop until stop flag is set}
    begin
      queryperformancecounter(count2); {check counter}
      countDiff:=count2-count1;
      if countDiff >= interval then {if "interval" counts have passed,}
      begin                             {it's time to click again}
        playsound(0,0,0);
        playsound(clicksound.memory,0, snd_memory+snd_async);
        count1:=count2;  {new start count = old start count}
      end
      else if countdiff> sleepcounts then sleep(50);
      application.processmessages;
    end;
  end
  else
  begin
    StartBtn.caption:='Start'; {Next button click will restart it}
    playsound(Nil,0,0);
    tag:=1;  {set stop flag to stop current metronome}
  end;
end;

{******** SoundGrpClick ************}
procedure TForm1.SoundGrpClick(Sender: TObject);
var
  fname:string;
  len:integer;
begin
  with soundgrp do
  begin
    fname:=clicknames[itemindex];
    if fileexists(fname) then
    begin
      playsound(0,0,0); {stop playing before overwriting the memory stream}
      clicksound.loadfromfile(fname)
    end
    else
    begin  {file not found, let user find one}
      showmessage('File '+fname+' not found. Click OK to continue');
      replacefile;
      if startBtn.Caption='Stop' then tag:=1;
    end;
  end;
end;

procedure TForm1.Replacefile;
begin
  with soundgrp do
  begin
    if opendialog1.execute then
    begin
      begin
        clicknames[itemindex]:=opendialog1.filename;
        items[itemindex]:= Extractbasename(opendialog1.filename);
      end;
      playsound(0,0,0);
      clicksound.loadfromfile(opendialog1.filename);
    end;
  end;
end;

{******* FormCloseQuery **********}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveInitData;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{user clicked close, stop the metronome and let him do it}
begin
  tag:=1; {stop flag set in case metronome is running}
  Canclose:=true;
end;

{******** PriorityGrpClick ***********}
procedure TForm1.PriorityGrpClick(Sender: TObject);
var
  r:longbool;
  MainThread: THandle;
begin
  (*  {not working}
  MainThread := GetCurrentThread;
  case PriorityGrp.ItemIndex of
    0: r:=setThreadPriority(Mainthread,NORMAL_PRIORITY_CLASS );
    1: r:=SetThreadPriority(MainThread,ABOVE_NORMAL_PRIORITY_CLASS);
    2: r:=setThreadPriority(MainThread,HIGH_PRIORITY_CLASS);
  end;
  if not r then showmessage('Program does not have "Set priority" permission');
 *)
end;

{************ BeatRateChange *************}
procedure TForm1.BeatRateChange(Sender: TObject);
{User type a new number}
var
  v:integer;
begin
  with BeatRate do
  if (strtointdef(text,-1)>0) then
  begin
    BeatsPerMinute:=value;
    BeatsPerSecond:=BeatsPerMinute div 60;
    v:=BeatsPerMinute;
    if (v<=maxValue) and (v>=minValue)
    then interval:=freq*60 div v; {In case user changed the rate }
  end;
end;

{************** BeatRateClick ***********}
procedure TForm1.BeatRateClick(Sender: TObject);
{SpinEdit clicked up or down arrow}
var
  v:integer;
begin
  with Beatrate do
  begin
    v:=value;
    BeatsPerMinute:=v;
    BeatsPerSecond:=BeatsPerMinute div 60;
    if (v<=maxValue) and (v>=minValue)
    then interval:=freq*60 div v; {In case user changed the rate }
  end;
end;



{************ LoadInitData ************}
Procedure TForm1.LoadInitData;
var
  Ini:TIniFile;
  i:integer;
begin
  Ini:=TIniFile.create(dir+'Metronome.ini');
  with Ini do
  begin
    clicknames[0]:=readstring('Names','File1',dir+'Click1.wav');
    clicknames[1]:=readstring('Names','File2',dir+'Click2.wav');
    clicknames[2]:=readstring('Names','File3',dir+'Click3.wav');
    clicknames[3]:=readstring('Names','File4','Unused');
    clicknames[4]:=readstring('Names','File5','Unused');
    for I := 0 to 4 do
    if clicknames[i]<>'Unused' then soundgrp.Items[i]:=extractbasename(clicknames[i]);
  end;
  ini.Free;
end;

{************ SaveInitData ***********}
Procedure TForm1.SaveInitData;
var
  ini:TInifile;
begin
  ini:=TInifile.Create(dir+'Metronome.ini');
  with ini do
  begin
    writestring('Names', 'File1',clicknames[0]);
    writestring('Names', 'File2',clicknames[1]);
    writestring('Names', 'File3',clicknames[2]);
    writestring('Names', 'File4',clicknames[3]);
    writestring('Names', 'File5',clicknames[4]);
  end;
  ini.Free;
end;

{************** ExtractBasename ***********}
Function TForm1.Extractbasename(s:string):string;
{Make a display name from the true file name by dropping directory and extension}
var  fname:string;
begin
  fname:=extractfilename(s);
  if (length(fname)>4) and (copy(uppercase(fname),length(fname)-3,4)='.WAV')
  then delete(fname,length(fname)-3,4);
  result:=fname;
end;

{************Open1Click **********}
procedure TForm1.Open1Click(Sender: TObject);
begin
  SoundGrpClick(sender);
end;

{*********** Replace1Click **********}
procedure TForm1.Replace1Click(Sender: TObject);
begin
  replacefile;
end;

 procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
