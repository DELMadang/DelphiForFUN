unit U_CountdownTimerDemo;
{Copyright  © 2006, 2016  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MMSystem,  StdCtrls, ComCtrls, ExtCtrls, DFFUtils, shellAPI, UCountDownTimer,
  Spin;



type
  TForm1 = class(TForm)
    Memo1: TMemo;
    StaticText1: TStaticText;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StartBtnA: TButton;
    StopBtnA: TButton;
    SoundBoxA: TCheckBox;
    SetBtnA: TButton;
    HSpinEditA: TSpinEdit;
    MSpinEditA: TSpinEdit;
    SSpinEditA: TSpinEdit;
    PanelA: TPanel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    StartBtnD: TButton;
    StopBtnD: TButton;
    SoundBoxD: TCheckBox;
    SetbtnD: TButton;
    HSpinEditD: TSpinEdit;
    MSpinEditD: TSpinEdit;
    SSpinEditD: TSpinEdit;
    PanelD: TPanel;
    TimeExpiredA: TLabel;
    TimeExpiredD: TLabel;
    DirectionA: TRadioGroup;
    DirectionD: TRadioGroup;
    OnMinuteBeep: TCheckBox;
    procedure FormActivate(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure PanelDExit(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure SetBtnClick(Sender: TObject);
    procedure SoundBoxClick(Sender: TObject);

  public
    cTimerA, cTimerD:TCountDown;
    procedure TimerPopBeep(Sender:TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{********** FormActivate **********8}
procedure TForm1.FormActivate(Sender: TObject);
begin
  reformatmemo(memo1);
  SetmemoMargins(memo1, 20,15,10,0);
  CtimerA:=TCountDown.create(panelA);
  CtimerD:=TCountDown.create(panelD);
end;

{********** StartBtnClick **********}
procedure TForm1.StartBtnClick(Sender: TObject);
begin
  Soundboxclick(sender);
  if sender =StartBtnA then
  with Ctimera do
  begin
    TimeExpiredA.visible:=false;
    runmode:=TRunMode(directionA.itemindex);
    starttimer;
  end
  else
  with CTImerD do
  begin
    TimeExpiredD.visible:=false;
    runmode:=TRunMode(directionD.itemindex);
    if OnMinuteBeep.checked then OnTimerPop:=TimerPopBeep else OnTimerPop:=nil;
    starttimer;
  end;
end;

{************* TimerPopBeep **************}
procedure TForm1.TimerPopBeep(Sender:TObject);
{Test OnTimerPop exit by beeping on minute boundaries}
var
  H,M,S,MS:word;
begin
  if (sender=CTimerD) then
  with ctimerD do
  begin
    decodetime(currenttime, H,M,S,MS);
    If S=0 then beep; {minute boundary so beep}
  end;
end;

{*********** PanelDExit **********}
procedure TForm1.PanelDExit(Sender: TObject);
begin
  If sender=CtimerA
  then TimeExpiredA.visible:=true
  else TimeExpiredD.visible:=true;
end;

{************* StopBtnClick *********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  If sender=StopBtnA
  then ctimerA.stoptimer
  else CtimerD.stoptimer;
end;

{************ SetBtnClick ************}
procedure TForm1.SetBtnClick(Sender: TObject);
begin
  if sender=SetBtnA then
  with ctimerA do
  begin
    TimeExpiredA.visible:=false;
    analogClock:=true;
    nosound:=not SoundboxA.checked;
    setstarttimeHMS(HSpineditA.value,MSpinEditA.value,SSpinEditA.value);
  end
  else
  with ctimerD do
  begin
    TimeExpiredD.visible:=false;
    analogClock:=false;
    nosound:=not SoundboxD.checked;
    setstarttimeHMS(HSpineditD.value,MSpinEditD.value,SSpinEditD.value);
  end;
end;

{*************** SoundBoxCl1ck **********}
procedure TForm1.SoundBoxClick(Sender: TObject);
begin
  If (sender = SoundboxA) or (sender=StartBtnA)
  then ctimerA.nosound:= not SoundboxA.checked
  else ctimerD.nosound:= not SoundboxD.checked;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
