unit U_SquareWheels;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Wheels do not have to be round to provide a smooth ride if the roadbed has the
 proper shape.  The is program illustrates how to design a road for square wheeels
 using inverted catenary curves!}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Spin, ComCtrls,shellAPI;

type
  TSquare=array[0..3] of TPoint;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Roadbtn: TButton;
    Rollbtn: TButton;
    Panel1: TPanel;
    Image1: TImage;
    Memo2: TMemo;
    StaticText1: TStaticText;
    Calcbtn: TButton;
    Button1: TButton;
    Memo3: TMemo;
    Memo4: TMemo;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    ArcEdt: TEdit;
    HEdt: TEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    RangeEdt: TEdit;
    CEdt: TEdit;
    Label2: TLabel;
    Memo5: TMemo;
    KleinsBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure RollbtnClick(Sender: TObject);
    procedure CalcbtnClick(Sender: TObject);
    procedure RoadbtnClick(Sender: TObject);
    procedure NewtonsBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure KleinsBtnClick(Sender: TObject);
  public
    dsquare:TSquare;
    startcenter:TPoint; {center of the initial square}
    squarecolor:TColor;
    squareside:integer;
    roadstart:integer;

    {Parameters for catenary curves for the "roadbed"}
    catwidth, catheight, C_Param, Arclength:Extended;
    woomsg:TStringlist;  {list of reward messages}


    first_entry:boolean; {flag to let multiple guesses show for CalcBtnbClick entries}
    procedure setupparams;
    procedure drawsquare(var center:TPoint; side:integer;angle:extended);
    procedure erasesquare;
    procedure drawroadbed(const Leftend:integer);
    procedure ShowRewardmessage;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

var
  msgvals:array[0..4] of string=('Woo!','Amazing!','Math Rules!','Hi Katy!',
                                'How ''bout that!') ;


{************ Formcreate *********}
procedure TForm1.FormCreate(Sender: TObject);
{initialization}
begin
  squarecolor:=$00FF0080; {Purple?}
  with image1 do
  begin
    picture.bitmap.height:=height;
    picture.bitmap.width:=width;
    canvas.font.size:=48;
    canvas.font.name:='arial';
  end;
  {Initialize text versions of numeric values to use local decimal separator}
  HEdt.text:='10'+decimalseparator+'355';
  ArcEdt.text:='25'+decimalseparator+'0';
  Rangeedt.text:='20'+decimalseparator+'0';
  CEdt.text:='20'+decimalseparator+'0';
  randomize;
  woomsg:=TStringlist.create;
  //panel1.doublebuffered:=true;  {seems to be automatic for TImage}
  pagecontrol1.activepage:=tabsheet1;
  first_entry:=true;
end;


{**************** DrawSquare *************}
procedure TForm1.drawsquare(var center:TPoint; side:integer;angle:extended);
{draw a square with a given location, size and orientation}
var
  h:integer;

  {----------- Rotaterect -----------}
  function rotaterect(r:TRect; c:TPoint; angle:extended):TSquare;
  var
    i:integer;
    sa,ca:extended;
    corners:TSquare;
  begin
    {translate rectangle center back to 0,0 origin in a temporary array}
    corners[0].x:=r.left-c.x;
    corners[0].y:=r.top-c.y;
    corners[1].x:=r.right-c.x;
    corners[1].y:=r.top-c.y;
    corners[2].x:=r.right-c.x;
    corners[2].y:=r.bottom-c.y;
    corners[3].x:=r.left-c.x;
    corners[3].y:=r.bottom-c.y;

    sa:=sin(angle);
    ca:=cos(angle);
    for i:= 0 to high(corners) do {rotate it and translate back}
    with corners[i] do
    begin
      result[i].x:=trunc(x*ca-y*sa)+c.x;
      result[i].y:=trunc(x*sa+y*ca)+c.y;
    end;
  end;{rotaterect}

begin {Drawsquare}
  with image1.canvas do
  begin
     h:=side div 2;
     with center do
     dsquare:=rotaterect(rect(x-h,y-h,x+h,y+h),center,angle);
     polygon(dsquare);
   end;
end; {drawsquare}

{*********** EraseSquare *******}
procedure TForm1.erasesquare;
begin
  with image1.canvas do
  begin
    pen.color:=clWhite;
    brush.color:=clwhite;
    polygon(dsquare);
    brush.color:=squarecolor;
    pen.color:=clblack;
  end;
end;

{********** ShowRewardmessage *********}
Procedure TForm1.ShowRewardMessage;
var
  i:integer;
  woostart:TPoint;
begin
  with image1 do
  begin
    {cycle randomly through the reward messages}
    {By deleting each message after it is displayed we can ensure that all
     messages get displayed, but in a random order}
    if woomsg.count=0 then for i:=0 to high(msgvals) do woomsg.add(msgvals[i]);
    i:=random(woomsg.count); {decide which one to display}
    {center the message}
    woostart.x:=(width-canvas.textwidth(woomsg[i])) div 2;
    woostart.y:=(height-canvas.textheight(woomsg[i])) div 2;
    canvas.Textout(woostart.x,woostart.y,Woomsg[i]);
    {remove displayed message from the list}
    woomsg.delete(i);
  end;
end;


{************* RollBtnClick ***********}
procedure TForm1.RollbtnClick(Sender: TObject);
{Animate the square across the roadbed}
var
  p,incr:extended;
  center:TPoint;
  i:integer;
  
begin
  roadbtnclick(sender);
  p:=0;
  incr:=pi/88;
  center:=startcenter;
  while center.x<image1.width do
  begin
    drawsquare(center,Squareside,p);
    inc(center.x,1);
    with center, image1.canvas do
    begin
      pen.width:=2;
      moveto(max(startcenter.x,x-squareside),y);
      lineto(x,y);
      pen.width:=1;
    end;
    image1.update;
    p:=p+incr;
    sleep(9);
    application.processmessages;
    erasesquare;
  end;

  ShowRewardMessage;
end;



{**************** Drawroadbed ***********}
 procedure TForm1.drawroadbed(const Leftend:integer);

     {---------- Drawcat ----------}
      procedure Drawcat(const x:integer);
      var
        i:integer;
        r:integer;
        y:integer;
        f:extended;
      begin
        r:=trunc(catwidth/2);
        with image1.canvas do
        for i:=-r to r do
        begin
          f:=catheight+c_param-c_Param*cosh(i/c_Param);
          y:=image1.height-trunc(f);
          if i=-r then moveto(x+i,y) {1st time}
          else lineto(x+i,y);
        end;
      end;

  var  x:integer;
  begin {Drawroadbed}
    x:=leftend;
    while x<image1.width do
    begin
      drawcat(x);
      x:=x+trunc(catwidth);
    end;
    image1.canvas.brush.color:=clblack;
    image1.canvas.floodfill(5,image1.height-5,clwhite,fssurface);
    image1.canvas.brush.color:=squarecolor;
  end;

{********** SetUpParams *******}
procedure TForm1.setupparams;
begin
  squareside:=50;

  catheight:=trunc(sqrt(2)*(squareside/2)); {half diagonal of the square, 10.355 for now};
  catwidth:=44;  {values transferrred from Calculate catenary page}
  c_param:=25.0;

 {backup roadbed by 1.5 "bumps" so it is full width and wheel starts on top of it}
  roadstart:=50+squareside div 2 - 3*trunc(catwidth/2);

  {Square parameters}
  startcenter.x:=squareside+1;
  startcenter.y:=image1.height-(squareside div 2 + trunc(catheight));
end;

{************** RoadBtnClick *********}
procedure TForm1.RoadbtnClick(Sender: TObject);
begin
  with image1,canvas do
  begin {clear everything}
    brush.color:=clwhite;
    fillrect(clientrect);
    brush.color:=squarecolor;
  end;
  setupParams;
  drawroadbed(roadstart);
  drawsquare(startcenter, squareside, 0); {draw initial wheel}
  //dec(startcenter.y);  {move it up a pixel for actual rolling}
end;


{************* CalcbtnClick ***********}
procedure TForm1.CalcbtnClick(Sender: TObject);
var
  a,c,s,h:extended;
  //f1,f2,f1prime,f2prime,nextx,nextc:extended;
begin
  h:=strtofloat(Hedt.text);
  s:=strtofloat(arcedt.text);
  c:=strtofloat(cEdt.text);
  a:=strtofloat(rangeedt.text);

  with memo1.lines do
  begin
    If first_entry then clear;
    add(format('When C=%6.2f and A=%6.2f then',[c,a]));
    add(format('        Height = C*(cosh(A/C)-1) =%6.2f',[c*(cosh(a/c)-1)]));
    add(format('        Arc Len = C*sinh(A/C) =%6.2f',[c*sinh(a/c)]));
  end;
  first_entry:=false; {let multiple clicks on this button show up}
end;

{*************** NetonsBtnClick ***********}
procedure TForm1.NewtonsBtnClick(Sender: TObject);
{Iterative search for solution by successive approximation using newton's method}
var
  a,c,s,h:extended;
  f1,f1prime,f2,f2prime:extended;
  dx,nextc,nexta:extended;
  n:integer;

      {-------- Cat ----------}
      function cat(x,c:extended):extended;
      {return catenary height}
      begin
        result:=c*(cosh(x/c)-1);
      end;

      {------------ Arclen ------}
      function arclen(x,c:extended):extended;
      {return arc length}
      begin
        result:=c*sinh(x/c);
      end;

begin
  memo1.clear;
  first_entry:=true;
  h:=strtofloat(Hedt.text);     {target height}
  s:=strtofloat(arcedt.text);   {target arc length}

  a:=strtofloat(rangeedt.text); {estimated x at end of curve}
  c:=strtofloat(cEdt.text);  {estimated C-parameter}
  {validate esrtimates}
  if c<0 then c:=-c;
  if c=0 then c:=1;
  a:=strtofloat(rangeedt.text);
  if a<0 then a:=-a;
  if a<0 then a:=1;

  with memo1.lines do
  begin
    add(format('Initial Guesses: A=f%6.2f  C=%6.2f',
                            [a,c]));
    add(format('Initial Error: Height error=f%6.2f  Arc Len Error=%6.2f',
                            [cat(a,c)-h,arcLen(a,c)-s]));
    add('------------------------------------------');
    n:=0;
    dx:=0.01;
    {Start the iterative loop}
    repeat
      f1:=cat(a,c)-h;
      {estimate derative - change in height for a small change in c}
      f1prime:=(cat(a,c+dx)-h-f1)/dx; {estimate derative by difference for small change in c}
      nextc:=c-f1/f1prime; {next guess for C parameter}
      if nextc<0 then c:=c+1 else c:=nextc;

      f2:=arclen(a,c)-s;
      {estimate derative - change in arclength for a small change in endpoint}
      f2prime:=(arclen(a+dx,c)-s-f2)/dx;
      nexta:=a-f2/f2prime; {next guess for width}
      if nexta<0 then a:=a+1 else a:=nexta;
      inc(n);
      if n<100 then
      begin
        add(format('#%2d Height error(f1)=%6.3f  f1''=%6.3f  Arclen error(f2)=%6.3f f2''=%6.3f ',[n,f1,f1prime,f2, f2prime]));
        add(format('         nexta=%6.3f, nextc=%6.3f',[a,c]));
      end;
    until ((abs(f2)<dx) and (abs(f1)<dx)) or (n>1000);
    if n<=1000 then
    begin
      f1:=cat(a,c)-h;
      f2:=arclen(a,c)-s;
      add('------------------------------------------');
      add(format('Solved in %d iterations: A=%6.3f, C=%6.3f',[n,a,c]));
      add(format('Final: Height error=f%6.2f  Arc Len Error=%6.2f',[f1,f2]));
      cEdt.text:=format('%6.2f',[c]);
      RangeEdt.text:=format('%6.2f',[a]);
    end
    else showmessage('No solution found');
  end;
end;



var
  derivstrings: array[1..23] of string =
  ('Derivation (thanks to Hans Klein)',
  '-----------------------------------------------',
  'Given s=c*sinh(a/c) and h=c*cosh(a/c)-c=c(cosh(a/c)-1)',
  '',
  'By definition, sinh(x)=(e^x-e^-x)/2 and cosh(x)=(e^x+e^-x)/2',
  'If we let e^(a/c)=u  {Eq 1}  we have',
  'sinh(a/c)=(u-1/u)/2 and multiply by (u/u) we get (u^2-1)/(2u)',
  'Similarly cosh(a/c)=(u+1/u)/2=(u^2+1)/(2u)',
   '',
   'The system now becomes:',
   's=c*(u^2-1)/(2u) {Eq 2}',
   'h=c*((u^2+1)/(2u)-1)',
    '',
    'then s/h=[(u^2-1)/(2u)]/[((u^2+1)/(2u)-1)]',
    'Multiplying nominator and denominater of the right hand side by 2u we',
    'get s/h = (u^2-1)/(u^2+1-2u) = (u^2-1)/((u-1)^2) = ((u+1)(u-1))/((u-1)^2) = (u+1)/(u-1).',
    'So h(u+1)=s(u-1)',
    'hu+h=su-s',
    '(h-s)u=-(h+s)',
    'u=(s+h)/(s-h)',
     '',
     'Having calculated u, with {Eq 2} we can calculate that c=2u*s/(u^2-1)',
     'Also e^(a/c)=u {Eq 1}by definition which implies that a/c=ln(u) so a=c*ln(u).');

{*************** KleinsBtnClick ***********}
procedure TForm1.KleinsBtnClick(Sender: TObject);
{Analytical solution derived by Hans Klein}
var
  i:integer;
  h,s,u,c1,c,a:extended;
begin
  h:=strtofloat(Hedt.text);
  s:=strtofloat(arcedt.text);
  u:=(s+h)/(s-h);
  c:=(2*u*s)/(u*u-1);
  { or c:=(s*s-h*h)/(2*h);}
  a:=c*ln(u);
  memo1.clear;
  first_entry:=true;
  memo1.lines.add(format('For H=%6.2f and S=%6.2f, C=%6.3f and  A=%6.3f',[h,s,c,a]));
  memo1.lines.add('');
  for i:=1 to high(derivstrings) do memo1.lines.add(derivstrings[i]);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
 ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
