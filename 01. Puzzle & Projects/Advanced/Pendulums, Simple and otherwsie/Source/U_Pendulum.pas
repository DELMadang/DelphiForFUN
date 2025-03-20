unit U_Pendulum;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, URungeKutta4, ExtCtrls, ComCtrls, contnrs, OleCtrls
  ;

type

  TPend2Rec = record   {Data point for a double pendulum}
       x1,y1,x2,y2:float;
    end;

  TPend3Rec = record   {Data point for a forced pendulum}
       x1,y1:integer;
       xf:float;
    end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    SimpleSheet: TTabSheet;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    TimeLbl: TLabel;
    CycleLbl: TLabel;
    Memo1: TMemo;
    P1RunBtn: TButton;
    DegEdt: TEdit;
    LenEdt: TEdit;
    GravEdt: TEdit;
    DampEdt: TEdit;
    ShowValues: TCheckBox;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    MaxTimeEdt: TEdit;
    SampRateEdt: TEdit;
    PctToReturnEdt: TEdit;
    MaxTimeUD: TUpDown;
    SampRateUD: TUpDown;
    ReturnedSampRateUD: TUpDown;
    DegUD: TUpDown;
    LenUD: TUpDown;
    GravUD: TUpDown;
    DampUD: TUpDown;
    DoubleSheet: TTabSheet;
    Image2: TImage;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    StartP2Btn: TButton;
    Edit3: TEdit;
    Edit4: TEdit;
    GroupBox2: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    MaxTime2UD: TUpDown;
    SampRate2UD: TUpDown;
    ReturnedSampRate2UD: TUpDown;
    Grav2UD: TUpDown;
    Damp2UD: TUpDown;
    StatusBar1: TStatusBar;
    StartP2X2Btn: TButton;
    GroupBox3: TGroupBox;
    Label8: TLabel;
    Label10: TLabel;
    Label19: TLabel;
    Edit1: TEdit;
    P1TAngleUD: TUpDown;
    P1TLenUD: TUpDown;
    Edit2: TEdit;
    Edit10: TEdit;
    P1TMassUd: TUpDown;
    GroupBox4: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Edit8: TEdit;
    P1BAngleUD: TUpDown;
    Edit9: TEdit;
    P1BLenUD: TUpDown;
    Edit11: TEdit;
    P1BMassUD: TUpDown;
    Memo2: TMemo;
    ForcedSheet: TTabSheet;
    Edit15: TEdit;
    P3DampUd: TUpDown;
    Label28: TLabel;
    Image3: TImage;
    GroupBox5: TGroupBox;
    Label29: TLabel;
    Label30: TLabel;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    MaxTime3UD: TUpDown;
    SampRate3UD: TUpDown;
    ReturnedRate3UD: TUpDown;
    GroupBox6: TGroupBox;
    Label27: TLabel;
    Edit14: TEdit;
    FF_AmpUD: TUpDown;
    Edit19: TEdit;
    FF_FReqUD: TUpDown;
    StartP3Btn: TButton;
    Image4: TImage;
    P3RunTimeLbl: TLabel;
    P2RuntimeLbl: TLabel;
    GroupBox7: TGroupBox;
    P3RealTime: TCheckBox;
    P3ClearBtn: TButton;
    IntroSheet: TTabSheet;
    Panel1: TPanel;
    RichEdit1: TRichEdit;
    InfoBtn: TButton;
    Label21: TLabel;
    Label23: TLabel;
    Edit12: TEdit;
    Len3UD: TUpDown;
    Label24: TLabel;
    Edit13: TEdit;
    Grav3UD: TUpDown;
    Label25: TLabel;
    Button1: TButton;
    Button3: TButton;
    procedure P1RunBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StartP2BtnClick(Sender: TObject);
    procedure P2EdtChange(Sender: TObject);
    procedure P1EdtChange(Sender: TObject);
    procedure StartP2X2BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SheetExit(Sender: TObject);
    procedure StartP3BtnClick(Sender: TObject);
    procedure P3EdtChange(Sender: TObject);
    procedure SheetEnter(Sender: TObject);
    procedure P3RealTimeClick(Sender: TObject);
    procedure P3ClearBtnClick(Sender: TObject);
    procedure InfoBtnClick(Sender: TObject);
  public
    LowerLimit, UpperLimit : Float;     { Limits over which to approximate X  }
    InitialValue, InitialDeriv : Float; { Initial values at lower limit}
    CalcInterval:float;                 {Seconds between calcated points}
    ReturnInterval : float;             { Seconds between returned points}
    MaxIntervals : integer;             { Max Number of intervals  }
    MaxReturned: integer;
    Error : byte;                       { Flags if something went wrong  }

    cyclecount:integer;
    prevxprime:float;
    valcount:integer;
    Len:float; {Pendulum length in meters}
    Gravity:float;
    Damping:float;
    Mass:float;

    Amp:Float;
    Omega:float;
    xc2,yc2:integer;

    Scale:float; {pixels per meter}
    xc,yc:integer; {x,y center of imsage}
    xscale,yscale:float;
    base1,base2:integer;   {base points for two double pendulum case}
    PixelLen:integer; {Pendulum length in pixels}
    starttime:TDateTime;
    nextTime:float;
    stepinc:float;
    Initialvalues1, InitialValues2:TnVector;
    testfuncs1:TFuncVect;
    Numequations:integer;

    xdata2:array of Tpend2rec;
    xdata3:array of TPend3rec;
    lowlim,midlim, highlim:Float;
    procedure Rescale;
    function GetValues1:boolean;
    function PendulumFunc(T,X,XPrime:Float):Float;
    function Pend1Callback(T,X,XPrime:Float):boolean;

    {Sheet 2 - Double Pendulum}
    procedure drawDoublePendulum(base:integer;x1,y1,x2,y2:float);
    function getvalues2(which:integer):boolean;
    function Pend2UserFunc1(V:TNVector):Float;
    function Pend2UserFunc2(V:TNVector):Float;
    function Pend2UserCallback(V:TnVector):boolean; {plot one double pendulum}

    function Pend2ACallBack(V:TnVector):boolean; {accum data for 1st double pendulum}
    function Pend2BCallBack(V:TnVector):boolean; {plot 2 double pendulums}

    {Sheet 3 - Forced Pendulum}
    function getvalues3:boolean;
    function Pend3Func(T,X,XPrime:Float):Float;
    function Pend3CallBack(T,X,XPrime:Float):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{$R HelpText.Res}

 uses math, U_Info;
var
  twopi:float=2*Pi;
  pidiv2:float=Pi/2.0;
  bgcolor:TColor=$ddffff;

{Common code - not pendulum specific}



{********************* FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
var rs: TResourceStream;
begin
   Pagecontrol1.activepage:=Introsheet;{make sure sintro is displayed first}
  {$IFDEF VER140}  {Delphi6?}
    SimpleSheet.doublebuffered:=true;
    DoubleSheet.doublebuffered:=true;
    ForcedSheet.doublebuffered:=true;
  {$ENDIF}

Begin
  {Load text from resource file}
  rs := TResourceStream.Create( hinstance, 'Intro', RT_RCDATA );
  try
    Richedit1.PlainText := False;
    rs.Position := 0;
    Richedit1.Lines.LoadFromStream(rs);
    with richedit1 do
    begin
      selstart:=0;
      sellength:=1000;
      defattributes.size:=12;
      defattributes.style:=defattributes.style+[fsbold];
      sellength:=0;
    end;  
  finally
    rs.free;
  end;
end;
  (* {replaced by code above}
  with richedit1 do
  begin
    if fileexists(extractfilepath(application.exename)+'Introduction.rtf')
    then lines.loadfromfile(extractfilepath(application.exename)+'Introduction.rtf');
  end;
  *)
end;

{***************** FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{User wants to close}
begin
  tag:=1; {in case it's running}
  canclose:=true;
end;

{***************** SheetExit **************}
procedure TForm1.SheetExit(Sender: TObject);
{we're leaving a page - reset labels and stop any running animation}
begin
  tag:=1;
  StartP2btn.caption:='Start';
  StartP2X2btn.caption:='Start 2 double pendulums';
  P1Runbtn.caption:='Start';
  StartP3Btn.caption:='Start';
end;


{*******************************************************}
{                                                       }
{                    Simple Pendulum                    }
{*******************************************************}

Function TForm1.PendulumFunc(T,X,XPrime:Float):Float;
{Called from Runge_Kutta4 at each calculated interval to do problem specific
 calculations}
{Computes acceleration based on time, angle, velocity}
begin
  Result:=-Damping*XPrime-Gravity/Len*sin(x); {G/L*Sin(Theta)}
end;

{*************************** Pend1Callback *****************}
Function TForm1.Pend1Callback(T,X,XPrime:Float):boolean;
{Called by Runge_Kutta4 with each returned point}
var
  xx,yy:integer;
  tm:TDatetime;
begin
  If showvalues.checked then
  begin
    memo1.lines.add(format('%4.2f  %15.12f  %15.12f ',[T, X,XPrime]));
    memo1.update;
  end;
  if xprime*prevxprime<0 then inc(cyclecount);
  prevxprime:=xprime;

  with image1, canvas do
  begin
    pen.color:=clblack;
    brush.color:=bgColor;
    fillrect(clientrect);
    brush.color:=clBlue;
    moveto(xC, 0);
    xx:=xc-trunc(PixelLen*cos(PiDiv2-x));
    yy:=trunc(PixelLen*sin(PiDiv2-x));
    lineto(xx,yy);
    ellipse(xx-8,yy-8,xx+8,yy+8);
  end;
  image1.update;
  {Calculate the millisecond difference between calculated time and real time}
  tm:=(nexttime-(now-starttime)*secsperday); {seconds running so far}
  {If real time is less, we're plotting faster than required,
   so we'll wait the difference}
  if tm>0 then sleep(trunc(1000*tm)) ;
  nexttime:=T+stepinc; {This is when the next plot should occur}
  inc(valcount);
  {Check for stop flag set once in a while}
  if valcount mod 8 = 0 then
  begin
   Timelbl.caption:=format('%6.1f seconds',[T]);
   CycleLbl.caption:=inttostr(cyclecount)+' half-cycles';
   application.processmessages;
  end;
  if (tag=0) then result:=true else result:=false;
end;

{********************** GetValues1 ***************}
function TForm1.GetValues1:boolean;
{Return true if all values look OK}
begin
  result:=true;
  Lowerlimit:=0;
  UpperLimit:=MaxTimeUD.position;
  Stepinc:=1/samprateUD.position;
  CalcInterval:=Stepinc;
  MaxIntervals:=round(Upperlimit*samprateUD.position);
  ReturnInterval:=1/ReturnedSamprateUD.position;
  MaxReturned:=round(UpperLimit*ReturnedSamprateUD.position);

  nexttime:=stepinc; {used by callback to control sleep time}

  InitialValue:=-pi*DegUD.position/180.0;
  Initialderiv:=0;
  Gravity:=GravUD.position/100;
  Len:=LenUD.position /100;
  Damping:=DampUD.position/100;

  {image scaling stuff}
  xc:=image1.width div 2;
  PixelLen:=trunc(0.75*image1.height*Len);
  Pend1Callback(0.0,initialvalue, initialderiv);
end;


{****************** P1RunBtnClick ***********}
procedure TForm1.P1RunBtnClick(Sender: TObject);
begin
if tag=0 then
begin
  tag:=1;
  P1runbtn.caption:='Start';
end
else
begin
  P1RunBtn.caption:='Stop';
  tag:=0;
  If GetValues1 then
  begin
    Valcount:=0;
    Error:=0;
    cyclecount:=0;
    prevxprime:=0.0;

    with memo1, lines do
    begin
        clear;
        add(' ');
        add('Simple Pendulum');
        add('X = angle in radians');
        add('X'' = angular velocity in radians per second');
        add('TiIme Upper Limit: '+ Floattostr(UpperLimit)+  ' seconds');
        add('Value of X at '+Floattostr(lowerlimit) + ' : ' +Floattostr(Initialvalue));
        add('Value of X'' at '+Floattostr(LowerLimit)+ ' : ' +Floattostr(InitialDeriv));
        add('Max Number of intervals: ' +inttostr(MaxIntervals));
        add(' ');
        add('   t    Value of X                Derivative of X     ' );
        starttime:=now;
        RungeKutta2ndOrderIC(LowerLimit, UpperLimit, InitialValue, InitialDeriv,
                          ReturnInterval, CalcInterval, Error,
                          PendulumFunc, Pend1Callback);
        case Error of

        1 : add('Return interval must be greater than zero.');
        2 : add('Return interval must be less than or equal to  Calc interval');
        3 : add('The lower limit must be different from the upper limit.');
        end; { case }
        tag:=1;
        P1RunBtn.caption:='Start';
      end;
    end;
  end;
end;

{**************** P1EdtChange ************}
procedure TForm1.P1EdtChange(Sender: TObject);
{called when pendulum length or angle changes to redraw initial config}
begin
  tag:=1;  {in case we're running}
  P1RunBtn.caption:='Start';
  GetValues1;
end;

{*******************************************************}
{                                                       }
{                    Double Pendulum                    }
{*******************************************************}

var
  G:float=9.81;
  m1,m2:float;
  L1,L2:float;
  intM1,intM2:integer; {integer version of Masses}

 {Double pendulum equations from http://www.myphysicslab.com/dbl_pendulum.html}
 {Or http://www.phy.davidson.edu/StuHome/chgreene/Chaos/Double%20Pendulum/theory.htm }

{********************** Pend2UserFunc1 ******************}
Function TForm1.Pend2UserFunc1(V:TNVector):Float;
{Called by Rutta_Kunge4 for each calculated point in a double pendulum}
{Calulate acceleration for the upper bob}
begin
  result:=-damping*v[1].xPrime + (-G*(2*m1+m2)*sin(v[1].x)-m2*G*sin(v[1].x-2*v[2].x)
           -2*sin(v[1].x-v[2].x)*m2*(sqr(v[2].xprime)*L2-sqr(v[1].xprime)
              *L1*cos(v[1].x-v[2].x)))
           /
           (l1*(2*m1+m2-m2*cos(2*(v[1].x-v[2].x))))

end;

{********************** Pend2UserFunc2 ******************}
Function TForm1.Pend2UserFunc2(V:TNVector):Float;
{Called by Rutta_Kunge4 for each calculated point in a double pendulum}
{Calculate acceleration for the lower bob}
begin
  result:=-damping*v[2].Xprime+(2*sin(v[1].x-v[2].x)*(sqr(v[1].xprime)
               *L1*(m1+m2)+G*(m1+m2)*cos(v[1].x)
       +sqr(v[2].xprime)*L2*M2*cos(v[1].x-v[2].x))) /
        (L2*(2*m1+m2-m2*cos(2*(v[1].x-v[2].x))));
end;

{****************** Pend2UserCallback ******************}
Function TForm1.Pend2UserCallback(V:TnVector):boolean;
{Plot the single double pendulum  called for each returned point}
var
  x1,x2,y1,y2:float;
  tm:TDateTime;
  runtm:float;
begin
  x1:=L1*cos(-PiDiv2+v[1].x);  y1:=L1*sin(-PiDiv2+v[1].x);
  x2:=x1+L2*cos(-PiDiv2+v[2].x);  y2:=y1+L2*sin(-PiDiv2+v[2].x);

  with image2, canvas do
  begin
    brush.color:=BgColor;
    fillrect(clientrect);
    pen.color:=clblack;
    brush.color:=clLime;
    {Draw ceiling}
    moveto(0,100); lineto(width,100);
    {Draw pendulums}
    DrawDoublePendulum(159,x1,y1,x2,y2);
    image2.update;
    {Calculate the millisecond difference between calculated time and real time}
    runtm:=(now-starttime)*secsperday;
    tm:=(nexttime-runtm); {seconds ahead of schedule}
    {If real time is less, we're plotting faster than required,
     so we'll wait the difference}
    if tm>0 then sleep(trunc(1000*tm)) ;
    nexttime:=v[0].x+stepinc; {This is when the next plot should occur}
    inc(valcount);
    if (v[0].x<upperlimit) and (self.tag=0) then result:=true
    else result:=false;
    if valcount>8
    then P2runtimelbl.caption:=format('%6.1f sec.',
                                     [v[0].x{, valcount/runtm}]);
    if valcount mod 8=0 then application.processmessages;
  end;
end;

{********************** DrawDoublePendulum **************}
 procedure TForm1.drawDoublePendulum(base:integer;x1,y1,x2,y2:float);
 {Graphics for a double pendulum}
  var
    xx1,yy1, xx2, yy2:integer;
  begin
    with image2, canvas do
    begin
      moveto(base,100);
      xx1:=base-trunc(xscale*x1);
      yy1:=100-trunc(xscale*y1);
      lineto(xx1,yy1);
      ellipse(xx1-IntM1,yy1-IntM1,xx1+IntM1,yy1+IntM1);
      xx2:=base-trunc(xscale*x2);
      yy2:=100-trunc(xscale*y2);
      lineto(xx2,yy2);
      ellipse(xx2-IntM2,yy2-IntM2,xx2+IntM2,yy2+IntM2);
    end;
  end;

{****************** Pend2ACallBack ******************}
Function TForm1.Pend2ACallBack(V:TnVector):boolean;
{for the first of two double pendulums  - just save the data to plot later}
begin
  result:=true;
  inc(valcount);
  with xdata2[valcount] do
  begin
    x1:=L1*cos(-PiDiv2+v[1].x);  y1:=L1*sin(-PiDiv2+v[1].x);
    x2:=x1+L2*cos(-PiDiv2+v[2].x);  y2:=y1+L2*sin(-PiDiv2+v[2].x);
  end;
end;

{****************** Pend2BCallBack ******************}
Function TForm1.Pend2BCallBack(V:TnVector):boolean;
{Called for a returned pooint for the second double pendulum - draw both}
var
  x1,x2,y1,y2:float;
  tm:TDateTime;
  runtm:float;
begin
  x1:=L1*cos(-PiDiv2+v[1].x);  y1:=L1*sin(-PiDiv2+v[1].x);
  x2:=x1+L2*cos(-PiDiv2+v[2].x);  y2:=y1+L2*sin(-PiDiv2+v[2].x);
  inc(valcount);
  with image2, canvas do
  begin
    brush.color:=BgColor;
    fillrect(clientrect);
    pen.color:=clblack;
    brush.color:=clLime;
    {Draw ceiling}
    moveto(0,100); lineto(width,100);
    {Draw pendulum1}
    if valcount>1 then with xdata2[valcount] do DrawDoublePendulum(base1,x1,y1,x2,y2)
    else  DrawDoublePendulum(base1,x1,y1,x2,y2);
    {Draw pendulum 2}
    DrawDoublePendulum(base2,x1,y1,x2,y2);
    image2.update;
    {Calculate the millisecond difference between calculated time and real time}
    runtm:=(now-starttime)*secsperday;
    tm:=(nexttime-runtm); {seconds ahead of schedule}
    {If real time is less, we're plotting faster than required,
     so we'll wait the difference}
    if tm>0 then sleep(trunc(1000*tm)) ;
    nexttime:=v[0].x+stepinc; {This is when the next plot should occur}
    if (v[0].x<upperlimit) and (self.tag=0) then result:=true
    else result:=false;
    if valcount>8
    then P2runtimelbl.caption:=format('%6.1f sec.', [v[0].x]);
    if valcount mod 8=0 then application.processmessages;
  end;
end;

{********************** GetValues2 ***************}
function TForm1.GetValues2(which:integer):boolean;
{Return true if all values look OK}
begin
  result:=true;
  Lowerlimit:=0;
  UpperLimit:=MaxTime2UD.position;
  Stepinc:=1/samprate2UD.position;
  CalcInterval:=StepInc;
  MaxIntervals:=round(Upperlimit*Samprate2UD.position);
  ReturnInterval:=1/ReturnedSamprate2UD.position;
  Maxreturned:=round(Upperlimit*ReturnedSampRate2UD.position);

  nexttime:=stepinc; {used by callback to control sleep time}

  Gravity:=Grav2UD.position/100;
  Damping:=Damp2UD.position/100;
  L1:=p1Tlenud.position/100;
  L2:=p1Blenud.position/100;
  m1:=P1TmassUD.position; IntM1:=trunc(m1);
  m2:=P1Bmassud.position; IntM2:=trunc(m2);
  InitialValues1[1].x:=-pi/180*p1TangleUD.position;
  InitialValues1[1].xprime:=0.0;
  InitialValues1[2].x:=-pi/180*p1BangleUD.position;
  InitialValues1[2].xprime:=0.0;

  xC:=image1.width div 2;
  TestFuncs1[1]:=Pend2UserFunc1;
  TestFuncs1[2]:=Pend2UserFunc2;
  Valcount:=0;
  NumEquations:=2;
  Error:=0;
  case which of
    1: Pend2UserCallback(Initialvalues1);
    2: Pend2BCallback(Initialvalues1);
  end;
  {some image scaling stuff}
  xscale:=10;
  xc:=image2.width div 2;
  {base locations for case where we draw 2 double pendulums}
  base1:=7*image2.width div 24; {1/4 not enough, 1/3 too much, split the difference}
  base2:=17*image2.width div 24;
end;

{************************* StartP2BtnClick ****************}
procedure TForm1.StartP2BtnClick(Sender: TObject);
{Check solution for initial value problem for a SYSTEM of COUPLED second-order
 ordinary differential equation using Runge-Kutta method }
 {Draw one double pendulum}
var msg:string;
begin
  startP2X2Btn.enabled:=false;
  if tag=0 then
  begin
    tag:=1;
    StartP2btn.caption:='Start';
  end
  else
  begin
    StartP2Btn.caption:='Stop';
    tag:=0;
    if getvalues2(1) then
    begin
       starttime:=now;
      {********************** CallBackSystem **********************}
      RungeKutta2ndOrderIC_System(
                                LowerLimit, UpperLimit, InitialValues1,
                                ReturnInterval, CalcInterval, Error,
                                NumEquations, TestFuncs1, Pend2UserCallback);
      case Error of

        1 : msg:='Return interval must be greater than zero.';
        2 : msg:='Return interval must be less than or equal to  Calc interval';
        3 : msg:='The lower limit must be different from the upper limit.';
        end; { case }
      if error<>0 then showmessage(msg);
      StartP2btn.caption:='Start';
      tag:=1;
    end;
  end;
  startP2X2Btn.enabled:=true;
end;

{************** P2EdtChange ************}
procedure TForm1.P2EdtChange(Sender: TObject);
{Called when any edit field on double pendulum page is modified}
begin
  tag:=1; {in case we're running}
  StartP2btn.caption:='Start';
  Getvalues2(1);
end;


{******************* StartP2X2BtnClick ****************}
procedure TForm1.StartP2X2BtnClick(Sender: TObject);
{Run two double pendulums with a small (.00001) difference in m2}
var msg:string;
begin
  StartP2btn.enabled:=false;
  if tag=0 then
  begin
    tag:=1;
    StartP2X2btn.caption:='Start 2 double pendulums';
  end
  else
  begin
    StartP2X2Btn.caption:='Stop';
    tag:=0;
    if getvalues2(2) then
    begin
      setlength(xdata2,maxReturned);
      starttime:=now;
      {********************** CallBackSystem **********************}
      RungeKutta2ndOrderIC_System(
                                LowerLimit, UpperLimit, InitialValues1,
                                ReturnInterval, CalcInterval, Error,
                                NumEquations, TestFuncs1, Pend2ACallBack);

      case Error of
        1 : msg:='Return interval must be greater than zero.';
        2 : msg:='Return interval must be less than or equal to  Calc interval';
        3 : msg:='The lower limit must be different from the upper limit.';
        end; { case }
      if error<>0 then showmessage(msg)
      else
      begin
        m2:=m2*1.0001;
        {L2:=0.9999*L2;}
        valcount:=0;
        {********************** CallBackSystem **********************}
        RungeKutta2ndOrderIC_System(
                                LowerLimit, UpperLimit, InitialValues1,
                                ReturnInterval, CalcInterval, Error,
                                NumEquations, TestFuncs1, Pend2BCallBack);
      end;
      setlength(xdata2,0);
      StartP2X2btn.caption:='Start 2 double pendulums';
      tag:=1;
    end;
  end;
  startP2btn.enabled:=true;
end;


{*******************************************************}
{                                                       }
{            Damped Forced Pendulum                     }
{*******************************************************}
{Forced chaotic pendulum page www.gre.ac.uk/~fi437/java/pendulum/penddes.html}


type
  TLine=record
     p1,p2:TPoint;
  end;

var  ampscale:float;
{**************** AngledLineFromLine **********}
function AngledLineFromLine(L:TLine; P:TPoint; Dist:extended; alpha:extended):TLine;
{compute a line fron point, P, on line, L, for a specified distance, dist
 at angle, alpha.  }
var theta, newangle:extended;
begin
  with L do
  begin
     if p1.x<>p2.x then {make sure slope is not infinite}
     theta:=arctan2((p2.y-p1.y),(p2.x-p1.x))
     else {vertical line}
     if p2.y>p1.y then theta:=pidiv2 else theta:=-pidiv2;
  end;
  with result do
  begin
    p1:=p;
    newangle:=theta+alpha;
    p2.x:=p.x-round(dist*cos(newangle));
    p2.y:=p.y-round(dist*sin(newangle));
  end;
end;


Function TForm1.Pend3Func(T,X,XPrime:Float):Float;
{Called from Runge_Kutta4 at each interval to do problem specific calculations}
{Compute acceleration based on time, angle, velocity}
begin
  Result:=-Damping*XPrime-Gravity/Len*sin(X)- Amp*cos(omega*T);
end;


{****************** Pend3Callback **************}
Function TForm1.Pend3CallBack(T,X,XPrime:Float):boolean;
{Called by Runge_Kutta4 with each returned point}
var
  xx,yy:integer;
  tm:TDatetime;
  i:integer;
  d:float;
  l1,l2:TLine;
  angle:float;
  fx,fy:float;
begin
  {Calculate the millisecond difference between calculated time and real time}
  tm:=(nexttime-(now-starttime)*secsperday); {seconds running so far}
  {If real time plotting is on and real run time is less than virtual run time
   then we're plotting faster than required, so we'll wait the difference}
  if p3realtime.checked and (tm>0) then
  repeat
    sleep(trunc(tm*1000));
    tm:=(nexttime-(now-starttime)*secsperday);
    application.processmessages;
  until tm<=0;
  inc(valcount);
  with image3, canvas do {draw the pendulum in its new position}
  begin
    pen.color:=clblack;
    brush.color:=BgColor;
    fillrect(clientrect);
    brush.color:=clBlue;
    moveto(0,yc); lineto(image3.width,yc);
    moveto(xC, yc);
    xx:=xc+trunc(PixelLen*cos(PiDiv2+x));
    yy:=yc+trunc(PixelLen*sin(PiDiv2+x));
    lineto(xx,yy);
    ellipse(xx-8,yy-8,xx+8,yy+8);
    If T>0 then
    begin
      {get force line}
      L1.p1:=point(xc,yc); L1.p2:=point(xx,yy);
      d:=-ampscale*cos(omega*T);
      angle:=pi/2;
      L2:=angledlinefromline(L1,l1.p2,d,angle);
      pen.width:=4;
      pen.color:=clgreen;
      lineto(l2.p2.x, l2.p2.y);
      pen.width:=1;
      pen.color:=clblack;
    end;
    image3.update;
  end;
  with image4, canvas do {update the position graph}
  begin
    {save the new point in case we have to redraw the chart}
    if valcount>high(xdata3) then
    begin
      valcount:=0;
      for i:=high(xdata3)-19 to high(xdata3) do
      with xdata3[i] do pixels[x1,y1]:=clblack;
    end;
    with xdata3[valcount]do
    begin
      xf:=x;
      if xf>highlim then
      repeat xf:=xf-twopi until xf<lowlim;
      if xf<lowlim then
      repeat xf:=xf+twopi until xf>lowlim;
      x1:=xc2+trunc((xf-midLim)*xscale);
      y1:=yc2+trunc(xprime*yscale);
      pixels[x1,y1]:=clred;
      if (y1>image4.height) or (y1<0) or (x1>image4.width) or (x1<0)
      then {we need to rescale & redraw the plot}
      begin
        fillrect(clientrect);
        moveto(0,yc2); lineto(width,yc2);
        moveto(xc2,0); lineto(xc2,height);
        textout(10,height-20,'Plot of angle vs. angular velocity');
        fx:=xscale;  fy:=yscale;
        if (y1>image4.height) or (y1<0) then yscale:=0.75*yscale;
        if (x1>image4.width) or (x1<0) then xscale:=0.75*xscale;
        fx:=xscale/fx;  fy:=yscale/fy;
        for i:=1 to valcount do
        with xdata3[i] do
        begin
          x1:=xc2+ trunc(fx*(x1-xc2));
          y1:=yc2+ trunc(fy*(y1-yc2));
          pixels[x1,y1]:=clblack;
        end;
      end;
      if valcount>20 then{change the color of the oldest point to black}
      with xdata3[valcount-20] do pixels[x1,y1]:=clblack;
      image4.update;
    end;
    if (p3realtime.checked) and (tm>0) then  sleep(trunc(1000*tm)) ;
    nexttime:={T}nexttime+stepinc; {This is virtual time when the next plot should occur}
  end;
  {Show run time and check for stop flag set once in a while}
  if valcount mod 8 = 0 then
  begin
    P3runtimelbl.caption:=format('%6.1f sec.',[T]);
    application.processmessages;
  end;
  if (tag=0) then result:=true else result:=false;
end;

{********************** GetValues3 ***************}
function TForm1.GetValues3:boolean;
{Get values for forced pendulum}
{Return true if all values look OK}
begin
  result:=true;
  Lowerlimit:=0;
  UpperLimit:=MaxTime3UD.position;
  Calcinterval:=1/samprate3UD.position;
  ReturnInterval:=1/ReturnedRate3UD.position;
  Stepinc:=ReturnInterval;

  MaxIntervals:=round(Upperlimit/stepinc);
  Maxreturned:=round(upperlimit*Returnedrate3UD.position)+3; {index 0 not used, need both endpoints}
  setlength(xdata3,maxreturned);
  valcount:=0;
  nexttime:=stepinc; {used by callback to control sleep time}

  InitialValue:=0;
  Initialderiv:=0;
  Error:=0;
  {Gravity and Length redundant here - G/L assumed to be 1.00}
  Gravity:=Grav3UD.position/100;
  Len:=Len3UD.position /100;
  Damping:=P3DampUD.position/100;
  Amp:=FF_AmpUD.position/100;
  ampscale:=50/amp;  {makes forve vector gfraphics 0 to 50 pixels in length}
  Omega:=FF_FreqUD.position*pi/180;

  {image scaling stuff}
  xc:=image3.width div 2;
  yc:=image3.height div 2;
  xscale:=25;
  yscale:=25;
  PixelLen:=trunc(3*image3.height div 8);
  starttime:=now;
  rescale;

  with image4, canvas do
  begin
    xc2:=width div 2;
    yc2:=height div 2;
    P3ClearBtnClick(self);
  end;
  Pend3CallBack(0.0,initialvalue, initialderiv);
end;

{****************** P3RunBtnClick ***********}
procedure TForm1.StartP3BtnClick(Sender: TObject);
{Start forced pendulum animation}
var msg:string;
begin
  if tag=0 then
  begin
    tag:=1;
    StartP3btn.caption:='Start';
  end
  else
  begin
    StartP3Btn.caption:='Stop';
    tag:=0;
    If GetValues3 then
    begin
      starttime:=now;
      RungeKutta2ndOrderIC(LowerLimit, UpperLimit, InitialValue, InitialDeriv,
                            ReturnInterval, CalcInterval, Error,
                            Pend3Func, Pend3CallBack);
      case Error of
          1 : msg:='Return interval must be greater than zero.';
          2 : msg:='Return interval must be less than or equal to  Calc interval';
          3 : msg:='The lower limit must be different from the upper limit.';
      end; { case }
      if error<>0 then showmessage(msg);
      tag:=1;
      StartP3Btn.caption:='Start';
    end;
    setlength(xdata3,0);
  end;
end;


{******************* P3EdtChange ************}
procedure TForm1.P3EdtChange(Sender: TObject);
{called when any edit field on forced pendulum page is changed}
begin
  tag:=1; {in case we're running}
  StartP3btn.caption:='Start';
  Getvalues3;
end;

{******************** Sheetenter **************}
procedure TForm1.SheetEnter(Sender: TObject);
{called when a sheet is entered to perofrm initialization}
begin
  if pagecontrol1.activepage=forcedsheet then
  begin
    starttime:=now-1/secsperday;
    getvalues3;
    setlength(xdata3, maxreturned);
  end;
end;

{***************** P3RealTimeClock *************}
procedure TForm1.P3RealTimeClick(Sender: TObject);
begin
  starttime:=now-nexttime/secsperday; {reset start time to make it look to be on schedule}
end;

{************** P3ClearBtnClick *********}
procedure TForm1.P3ClearBtnClick(Sender: TObject);
{Clear the graph}
begin
  with image4, canvas do
  begin
   brush.color:=BgColor;
   fillrect(clientrect);
   moveto(0,yc2); lineto(width,yc2);
   moveto(xc2,0); lineto(xc2,height);
   textout(10,height-20,'Plot of angle vs. angular velocity');
 end;
end;

{**************** Rescale *************}
procedure TForm1.Rescale;
{set chart scaling limits}
begin
  lowlim:=-10e6;
  highlim:=10e6;
  xscale:=0.8*image4.width/(4*pi);
  midlim:=(lowlim+highlim)/2;
  yscale:=25;
  p3clearbtnclick(self);
end;


procedure TForm1.InfoBtnClick(Sender: TObject);
{User clicked Info button}
begin
    Info.showmodal;
   (*
    if sender = button3 then
    begin
      image3.picture.bitmap.savetofile('Forcednew1.bmp');
      image4.picture.bitmap.savetofile('Forcednew2.bmp');
    end;
    *)
    if sender = infobtn then
    begin
      image2.picture.bitmap.savetofile('Doublenew.bmp');
    end;
end;

end.
