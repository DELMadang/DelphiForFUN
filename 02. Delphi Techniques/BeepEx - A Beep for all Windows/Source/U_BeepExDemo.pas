unit U_BeepExDemo;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Bleeper unit downloadable (part of BleepInt) from
 http://www.torry.net/pcspeaker.htm  }

{2007 update - added minor and chromatic scales, but program could probably be
 rewritten to eliminate Beepex calls since that procedure only adds support for
 Windows 95, 98 and ME}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls,ShellAPI,ExtCtrls,Bleeper;

type
  {each entry in the tune array defines a tone value and a multiplier for the
   note duration 1 = 16th note}
  TTuneArray=array [0..24,0..1] of integer;
  TForm1 = class(TForm)
    BleepBtn: TButton;
    TimeBar: TTrackBar;
    FreqBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    FreqEdt: TEdit;
    TimeEdt: TEdit;
    MajorBtn: TButton;
    StaticText1: TStaticText;
    Memo1: TMemo;
    BeepVer: TRadioGroup;
    MinorBtn: TButton;
    ChromaticBtn: TButton;
    Button1: TButton;
    StopBtn: TButton;
    procedure FreqBarChange(Sender: TObject);
    procedure TimeBarChange(Sender: TObject);
    procedure BleepBtnClick(Sender: TObject);
    procedure MajorBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure MinorBtnClick(Sender: TObject);
    procedure ChromaticBtnClick(Sender: TObject);
    {public}
    Procedure PlayScale(const scalesteps:array of integer);
    procedure PlayTUNE(tune:TTuneArray);
    procedure Button1Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;
  MajorScaleSteps:array[1..8] of integer=(0,2,4,5,7,9,11,12);
  MinorScaleSteps:array[1..8] of integer=(0,2,3,5,7,8,10,12);
  ChromaticScaleSteps:array[0..12] of integer = (0,1,2,3,4,5,6,7,8,9,10,11,12);
  HappyBirthday:TTuneArray =
   ((0,3),(0,1),(2,4),(0,4),(5,4),(4,8),
   (0,3),(0,1),(2,4),(0,4),(7,4),(5,8),
   (0,3),(0,1),(12,4),(9,4),(5,4),(4,4),(2,8),
   (10,3),(10,1),(9,4),(5,4),(7,4),(5,12));


implementation

{$R *.DFM}

uses math;

{************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
{Initialize freq and duration displays}
begin
  freqbarchange(sender);
  timebarchange(sender);
  stopbtn.BringToFront;
end;

{***************** FreqBarChange *************}
procedure TForm1.FreqBarChange(Sender: TObject);
begin  FreqEdt.text:=inttostr(FreqBar.position)+' hz'; end;

{****************** TimeBarChange ***********}
procedure TForm1.TimeBarChange(Sender: TObject);
begin TimeEdt.text:=inttostr(Timebar.position)+' ms'; end;

{*************** BleepbtnClick *****************}
procedure TForm1.BleepBtnClick(Sender: TObject);
begin
  if beepver.itemindex=0 then Windows.Beep(freqbar.position, timebar.position)
  else  BeepEx(freqbar.position, timebar.position);
end;

{********* PlayScale *************}
Procedure TForm1.PlayScale(const scalesteps:array of integer);
{Play an array of semitone values with base value determined by "freqbar"}
var i:integer;
    freq:integer;
begin
  stopbtn.visible:=true;
  tag:=0;
  for i:=low(scalesteps) TO high(scalesteps) do
  begin
    freq:=trunc(freqbar.position*power(2,scalesteps[i]/12));
    FreqEdt.text:=inttostr(Freq)+' hz';
    application.processmessages;
    if tag>0 then break;
    if BeepVer.itemindex =0
    then Windows.Beep(freq, timebar.position)
    else BeepEx(freq, timebar.position);
  end;
  if tag=0 then
  for i:=high(scalesteps) downto low(scalesteps) do
  begin
    freq:=trunc(freqbar.position*power(2,scalesteps[i]/12));
    FreqEdt.text:=inttostr(Freq)+' hz';
    application.processmessages;
    if tag>0 then break;
    if BeepVer.itemindex =0
    then Windows.Beep(freq, timebar.position)
    else BeepEx(freq, timebar.position);
  end;
  stopbtn.visible:=false;
end;

{************ PlayTune **********}
procedure TForm1.PlayTUNE(tune:TTuneArray);
var i:integer;
    freq,duration:integer;
Begin
  tag:=0;
  stopbtn.visible:=true;
  for i:= low(tune) to high(tune) do
  begin
    freq:=trunc(freqbar.position*power(2,tune[i,0]/12));
    FreqEdt.text:=inttostr(Freq)+' hz';
    application.processmessages;
    if tag>0 then break;
    duration:=timebar.position*tune[i,1] div 4; {time for a quarter note}
    BeepEx(freq,duration);
    sleep(20);  {slight pause between notes}
  end;
  stopbtn.visible:=false;
end;


{********* MajorBtnClick **************}
procedure TForm1.MajorBtnClick(Sender: TObject);
{Play a major scale using base frequency and duration fron trackbars}
{This is an equal tempered scale.
 With 12 steps, each step "n" is 2^(n/12) times the base frequency.
 The major scale uses step values 0,2,4,5,7,9,11,12
 Tone step increments: whole,whole,half,whole,whole,whole,half}
begin
  Playscale(Majorscalesteps);
end;

procedure TForm1.MinorBtnClick(Sender: TObject);
{Play a minor scale using base frequency and duration fron trackbars}
{This is an equal tempered scale.
 With 12 steps, each step "n" is 2^(n/12) times the base frequency.
 The minor scale uses step values 0,2,3,5,7,8,10,12
 Tone step increments: whole,half,whole,whole,half,whole,whole}
begin
  Playscale(MinorscaleSteps);
end;

procedure TForm1.ChromaticBtnClick(Sender: TObject);
{Play a chromatic scale using base frequency and duration fron trackbars}
{This is an equal tempered scale.
 With 12 steps, each step "n" is 2^(n/12) times the base frequency.
 The chromatic scale uses all 13 step values}

begin
  PlayScale(ChromaticScaleSteps);
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  playtune(HappyBirthday);
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

end.
