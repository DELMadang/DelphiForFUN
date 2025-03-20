unit U_SpringMass2;
 {Copyright  © 2000-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A simple animated spring-mass demo with initial consditions,
  gravity, and damping}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, ComCtrls, ShellAPI;

type
  Float=single;

  TSpring=class(tPanel)
    private
      Image:TImage;
    public
      K:Float;   {spring constant}
      M:Float;   {mass}
      G:Float;   {gravity}
      A:Float;   {acceleration}
      x:Float;   {displacement}
      v:Float;   {velocity}
      C:Float;   {damping}
      X0:Float;  {initial displacement}
      //F0:Float;  {initial force}
      V0:Float;  {initial velocity}


      XEnd:Float; {resting displacement G*M/K}
      InitiallyConstrained:Boolean;
      Timeinc:Float;
      Scale:float;
      Stype:integer;  {spring type, 0 - pull only, 1= push/pull}
      delay:integer; {ms wait between frames while animating}
      pts:array of TPoint; {points drawn, used to erase spring}
      step:integer;  {pixel increment while drawinga spring}
      wraps:integer; {nbr of coils in spring}
      drawColor:TColor;
      constructor create (Aowner:TPanel; r:Trect); reintroduce;
      procedure drawspring(Len:float);
      procedure erasespring;
      procedure redrawinitial;
      function Setup({newF0,}newV0,newX0,newC,newK,newM, newG, newTimeInc:Float;
                      newconstraint:boolean;
                      Nbrloops,newStep,newdelay:integer;
                      newcolor:TColor):boolean;
      procedure animate;
      procedure sizechanged(sender:TObject);
      function GetMaxAmp:float;
  end;


  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    Label2: TLabel;
    V0Edt: TEdit;
    Label4: TLabel;
    DampEdt: TEdit;
    Label5: TLabel;
    SpringEdt: TEdit;
    Label6: TLabel;
    MassEdt: TEdit;
    Label8: TLabel;
    GravityEdt: TEdit;
    ConstraintRgrp: TRadioGroup;
    X0Edt: TEdit;
    TypeRgrp: TRadioGroup;
    StartBtn: TButton;
    Memo2: TMemo;
    TimeScaleGrp: TRadioGroup;
    Label1: TLabel;
    TimeIncEdt: TEdit;
    StopBtn: TButton;
    Memo3: TMemo;
    StaticText1: TStaticText;
    Displaybox: TCheckBox;
    procedure StartBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure X0EdtChange(Sender: TObject);
    procedure DampEdtChange(Sender: TObject);
    procedure SpringEdtChange(Sender: TObject);
    procedure MassEdtChange(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure EdtKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure GravityEdtChange(Sender: TObject);
    procedure ConstraintRgrpClick(Sender: TObject);
    procedure TypeRgrpClick(Sender: TObject);
    procedure TimeIncEdtExit(Sender: TObject);
    procedure TimeScaleGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure V0EdtChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    spring1:TSpring;
    timescale:float;
    timeinc:float;
    function setup:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

const
  {we'll just use constants for these for now}
  nbrloops=4;   {wiggles in the spring}
  resolution=2; {pixel step when drawing spring}
var
  delayms:integer=10;   {ms delay bewteen frames while animating}

{****************** TSpring.Create *****************}
Constructor TSpring.create(Aowner:TPanel;R:TRect);
begin
  inherited create(Aowner);
  parent:=Aowner;
  color:= Aowner.color;
  left:=r.left;
  top:=r.top;
  width:=r.right-R.left;
  height:=aowner.height-{ r.bottom-}r.top-2;
  doublebuffered:=true;
  borderstyle:=bsNone;
  bevelinner:=bvnone;
  bevelouter:=bvnone;
  onresize:=SizeChanged;
  timeinc:=1;
  image:=TImage.create(self);
end;

{********************** TSpring.DrawSpring ***************}
procedure TSpring.drawspring(Len:float);
{draw a spring an mass image with height Len}
var
  inc:Float;
  cyclelength,cyclewidth:integer;
  i,startx,starty:integer;
  halfheight,PixelLen:integer;
begin
  if wraps=0 then exit;
  halfheight:=height div 2;
  pixelLen:=halfheight+trunc(Len*scale);
  cyclelength:=pixelLen div wraps;
  cyclewidth:=width div 4;
  if (step<=0) or (cyclelength<=0)  then exit;
  setlength(pts, pixelLen div step);
  inc:=step*2*pi/cyclelength;   {GDD}
  startx:=width div 2;
  starty:=0;
  image.canvas.moveto(startx,starty);
  image.canvas.pen.color:=drawColor;
  for i := low(pts) to high(pts)-1 do
  with pts[i] do
  begin
    x:=startx+trunc(cyclewidth*sin(i*inc));
    y:=starty+step*i;
    image.canvas.lineto(x,y)
  end;
  {make the final point back in the center of the weight}
  with pts[high(pts)],image,canvas do
  begin
    x:=width div 2;
    y:=pts[high(pts)-1].y;
    lineto(x,y);
    lineto(x,y+2);
    brush.color:=clblue;
    fillrect(rect(2,y+2,width-2,y+width-2));
  end;
end;

{*********************** TSpring.EraseSpring ****************}
procedure TSpring.erasespring;
{with double buffering - fillrect might be faster and not cause flicker}
var
  i:integer;
begin
  if length(pts)=0 then exit;
  with  image.canvas do
  begin
    pen.color:=color;
    moveto(pts[0].x,pts[0].y);
    for i := 1 to high(pts) do
    with pts[i] do lineto(x,y);
    with pts[high(pts)] do
    begin
      lineto(width div 2,y);
      brush.color:=color;
      fillrect( rect(2,y,width-2,y+width-2));
    end;
  end;
end;

{*************** TString.RedrawInitial **********}
procedure TSpring.redrawInitial;
{Draw unconstrained spring position whenever mass, gravity,
 or spring constant changes}
begin
  if not initiallyconstrained then
  begin
    erasespring;
    x:=g*m/k;
    drawspring(x);
  end;
end;


{**************** GetMaxAmp ***********}
function TSpring.getmaxamp:float;
var
  tt,aa,vv,cc,xx:float;
  maxamp:float;
begin
  aa:=a;
  vv:=v0;
  tt:=0;
  If initiallyconstrained then maxamp:=abs(X0+xend)else maxamp:=0;
  xx:=maxamp;
  cc:=c*sqrt(4*k*m);  {scaled damping factor}
  {calculate 1/4 cycle or until motion stops}
  while tt<=0.5{2}*pi/sqrt(k/m){/4} do
  begin
    vv:=vv+aa*tt;
    xx:=xx+vv*tt;
    if xx>maxamp then maxamp:=xx;
    //aa:=G-(cc*vv+k*(abs(xx)-xend))/m;
    if stype=0 then    {for a floppy spring use this}
    begin
      if x>xend then aa:=G-(cc*vv)/m -k*(xx)/m
      else aa:=G-cc*vv/m; {no spring effect when spring is compressed}
    end
    else
    begin
      {For a stiff spring (K acts in both directions}
      aa:=G-(cc*vv+k*(xx))/m;
    end;
    if (abs(vv)<0.01) and (abs(aa)<0.01) then break;
    tt:=tt+0.01;
  end;
  result:=maxamp;
end;


{****************** TSpring.Setup ********************}
function TSpring.Setup(newV0,newX0,newC,newK,newM, newG, newtimeinc:Float;
                        newconstraint:boolean;
                        Nbrloops,newStep,newdelay:integer;
                        newcolor:TColor):boolean;
{Set up a case for drawing}
var
  maxamp1:float;
begin
  V0:=newV0;
  X0:=newX0;
  c:=newC;
  K:=newK;
  m:=NewM;
  G:=newG;
  TimeInc:=newTimeInc;
  result:=true;
  if (m<=0) or (K<=0) then
  begin
    result:=false;
    MessageDlg('Mass and Spring constant should be positive.', mtError, [mbOK], 0);
    exit
  end;

  if (c<0) or (c>1) then
  begin
    result:=false;
    MessageDlg('Damping factor range is from 0 to 1', mtError, [mbOK], 0);
    exit
  end;

  if (g<0) then
  begin
    result:=false;
    MessageDlg('Graviy must not be negative.', mtError, [mbOK], 0);
    exit
  end;
  step:=newstep;
  delay:=newdelay;
  Xend:=G*M/K; {where the spring will come to rest realtive to the unweighted spring}
  initiallyconstrained:=newconstraint;
  v:=V0;
  if initiallyconstrained then x:=xend+x0  else x:=xend;
  a:=0;
  maxamp1:=getmaxamp;
  scale:= (0.4*height/maxamp1);  {pixels per spring unit}
  wraps:=nbrloops;
  if length(pts)>0 then erasespring;
  drawcolor:=newcolor;
  drawspring(x);
  application.processmessages;
end;

var tab:char=#09;

{****************** TSpring.Animate *******************}
Procedure TSpring.Animate;
{Loop and draw the action}
var i:integer;
    cc:float;
    time:float;
begin
  if initiallyconstrained then
  begin
    erasespring;
    drawspring(x0+xend); {draw the weight with initial displacement}
  end;
  application.processmessages;
  sleep(1000);   {sleep 1 second before starting}
  tag:=0;
  form1.Memo2.Clear;
  form1.memo2.lines.add('Time'+tab+'A'+tab+'V'+tab+'X');
  cc:=c*sqrt(4*k*m);  {scaled damping factor}
  time:=0.0;
  {Continue if weight is not within a pixel of resting position
   or it is still moving or accelerating significantly}
  form1.memo2.lines.add(format('%8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
  while (tag=0) and ((abs(x-xend)>0.1) or (abs(v)>0.01) or (abs(a)>0.01))
  do
  begin
    {accelerate/decelerate velocity by one time unit's worth}
    v:=v+a*timeinc;
    {change distance for one time unit}
    x:=x+v*timeinc;
    time:=time+timeinc;

    {damping force, cc,  proportional to velocity}
    {spring constant force, K,  proportional to displacement}
    {acceleration determined by gravity, damping, and spring forces}

    if stype=0 then    {for a floppy spring use this}
    begin
      if x>xend then a:=G-(cc*v+k*(x))/m
      else a:=G-cc*v/m; {no spring effect when spring is compressed}
    end
    else
    begin
      {For a stiff spring (K acts in both directions}
      a:=G-(cc*v+k*(x))/m;
    end;
    if (abs(v)>0.5) or (abs(a)>0.5) then
    begin
      with form1, memo2 do
      if (displaybox.checked) and (lines.count<2000)
      then lines.add(format('%8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
      erasespring;
      i:=trunc(x*scale); {get pixel length for plotting}
      if height div 2 +i<0 then
      begin  {spring is trying to fly away}
        drawspring(-height div 2); {draw it a top}
        break;                     {and break the loop}
      end;
      drawspring(x);
      sleep(delay);
    end;
    application.ProcessMessages;
  end;
  form1.memo2.lines.add(format('*End* %8.2f %8.2f %8.2f %8.2f',[time,a,v,x-xend]));
end;

{**************** TSpring.Sizechanged ***********}
procedure TSpring.sizechanged(sender:Tobject);
{needed when resize is implemented to keep the image
 filling the panel}
begin
  image.free;
  image:=TImage.create(self);
  with image do
  begin
    parent:=self;
    left:=1; top:=1;
    width:=self.width-2;
    height:=self.height-2;
    canvas.brush.color:=color;
    canvas.fillrect(image.clientrect);
  end;
  if wraps>0 then drawspring(0);
end;


{******************* TForm1 Methods *****************}

{*************** StartBtnClick ******************}
procedure TForm1.StartBtnClick(Sender: TObject);
{user clicked Start button}
var
  omega:float;
begin
  if setup then
  begin
    panel2.enabled:=false;
    panel2.sendtoback;
    cursor:=crhourglass;
    Memo3.clear;
    with spring1, memo3.lines do
    begin
      omega:=sqrt(k/m)/(2*pi);
      add(format('Osc. Freg: %6.2f Hz',[omega]));
      add(format('Period: %5.1f sec.c',[1/omega]));
    end;  
    spring1.Animate;
    cursor:=crdefault;
    panel2.enabled:=true;
    panel2.bringtofront;
  end;
end;

{^^^^^^^^^^^^^ StopBtnClick **************}
procedure TForm1.StopBtnClick(Sender: TObject);
{User clicked stop button}
begin
  panel2.enabled:=true;
  panel2.bringtofront;
  spring1.tag:=1;
end;

{**************** FormCloseQuery ****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Stop spring if running and allow program close}
begin
  spring1.tag:=1;
  canclose:=true;
end;



{******************* X0EdtChange *************}
procedure TForm1.X0EdtChange(Sender: TObject);
{Set initial weight position}
begin
  constraintrgrp.itemindex:=1;
  if TEdit(sender).text='-' then exit;
  constraintrgrpclick(sender);
end;

procedure TForm1.V0EdtChange(Sender: TObject);
var
  x:float;
begin
   spring1.V0:=StrToFloat(V0Edt.text);
end;



{****************** DampEdtChange **************}
procedure TForm1.DampEdtChange(Sender: TObject);
var x:Float;
begin
  if TEdit(sender).text<>'-' then
  begin
    x:=StrToFloat(DampEdt.text);
    spring1.C:=x;
    if (x>=0) and (x<=1) and (spring1.k>0)  then spring1.redrawinitial;   {redraw  spring if valid}
  end;
end;

{*************** SpringEdtChange ***************}
procedure TForm1.SpringEdtChange(Sender: TObject);
var x:Float;
begin
  If TEdit(sender).text<>'-' then
  begin
    x:=StrToFloat(SpringEdt.text);
    spring1.K:=x;
    if (x>0) and (x>0) then spring1.redrawinitial; {redraw  spring if valid}
  end
  ;
end;

{************** MassEdtChange ****************}
procedure TForm1.MassEdtChange(Sender: TObject);
begin
  If TEdit(sender).text<>'-' then
  begin
    spring1.m:=strtofloat(massedt.text);
    spring1.redrawInitial;
  end;
end;

{****************** GravityEdtChange *************}
procedure TForm1.GravityEdtChange(Sender: TObject);
var x:Float;
begin
  If TEdit(sender).text<>'-' then
  begin
    x:=StrToFloat(GravityEdt.text);
    spring1.G:=x;
    if x>0 then spring1.redrawInitial; {redraw  spring if valid}
  end;
end;

procedure TForm1.TimeIncEdtExit(Sender: TObject);
var x:Float;
    errmsg:string;
begin
  errmsg:='';
  x:=1;
  try
    x:=StrToFloat(Timeincedt.text);
    except
    on eConvertError do
       errmsg:='Time increment per calc loop must be between 0.01 and 1.0';
  end;
  if (errmsg='') and ((x<0.009) or (x>1.0)) then  errmsg:='Time increment per calc loop must be between 0.01 and 1.0';
  if errmsg=''
  then timeinc:=(round(100.0*x)) /100.0
  else showmessage(errmsg);
  timeincedt.text:=format('%5.2f',[timeinc]);
end;


{**************** EdtKeyPress **************}
procedure TForm1.EdtKeyPress(Sender: TObject; var Key: Char);
{Validate numeric entry for floating point number entries}
const backspace=#8; {backspace character}
begin
  If sender is TEdit then
  Begin
    if Key in [backspace, '0'..'9'] then exit;
    if key in ['.',','] then key:=decimalseparator;
    if (Key = decimalseparator) and (Pos(decimalseparator, TEdit(sender).Text) = 0)
    then exit;
    if (Key = '-') and (TEdit(sender).SelStart = 0)
     and (pos('-',TEdit(sender).text)=0) then  exit;
    Key := #0;
    beep;
  end;
end;


{*************** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
{Make the spring object}
begin
   spring1:=TSpring.create(panel1,rect(100,10,150,panel1.height-50));
   V0Edt.text:='30'+decimalseparator+'0';
   DampEdt.text:='0'+decimalseparator+'05';
   SpringEdt.text:='5'+decimalseparator+'0';
   MassEdt.text:='15'+decimalseparator+'0';
   GravityEdt.text:='9'+decimalseparator+'81';
   TimeIncEdt.text:='1'+decimalseparator+'0';

  stopbtn.top:=panel2.top+startbtn.top;
  stopbtn.left:=panel2.left+startbtn.left;

  timescalegrpclick(sender);
  timeincedtexit(sender);
end;

{***************** EdtKeyUp ***************}
procedure TForm1.EdtKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Keep a valid number in the field by change a blank to 0}
begin
  with TEdit(sender) do if text='' then text:='0';
end;

{***************** Setup ****************}
function TForm1.Setup:boolean;
begin
  typergrpclick(self);
  delayms:=trunc(1000*timescale*timeinc);
  result:=spring1.Setup(strtofloat(V0Edt.text),
                strtofloat(X0Edt.text),
                strtofloat(DampEdt.text),
                strtofloat(SpringEdt.text),
                strtofloat(Massedt.text),
                strtofloat(GravityEdt.text),
                strtofloat(timeincedt.text),
                constraintrgrp.itemindex=1,
                Nbrloops,resolution,delayms,clBlack);
end;

{*************** FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization stuff}
begin   setup;  end;

{**************** ConstraintRGrpClick **************}
procedure TForm1.ConstraintRgrpClick(Sender: TObject);
{Set initial constraint property in Tspring object}
begin
  spring1.InitiallyConstrained:=constraintRgrp.itemindex=1;
  setup;
  {spring1.redrawinitial;}
end;

{*************** TypeRGrpClick ^^^^^^^^^^^^^}
procedure TForm1.TypeRgrpClick(Sender: TObject);
{Set spring type property in TSpring object}
begin
  spring1.stype:=Typergrp.itemindex;
end;



procedure TForm1.TimeScaleGrpClick(Sender: TObject);
begin
  timescale:=1/round(intpower(2.0,timescalegrp.itemindex));
  delayms:=trunc(1000*timescale*timeinc);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
