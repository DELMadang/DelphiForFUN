unit U_7Coins;
{Copyright  © 2000-2006, Gary Darby,  www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
 Place a coin on any free line of the 8 point start shown
(free line = no coins at either end) and slide it to
 one end.  Can you do this 6 more times so that 7 of the 8 star
 points are occupied?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, ShellAPI;

type
  TVertex=record
    x,y:integer;
    occupied:boolean;
    C1,C2:integer; {The indices of the 2 points that connect to this point}
  end;

  TCoinBoard=class(TPaintbox)
  private

  public
    {Vertex information}
    v:array[1..8] of TVertex;
    coincount:integer;
    center:TPoint;
    coin:TShape;
    movingcoin:integer;
    ShowItTime:boolean; {display coin being moved when this is true}
    moving:boolean;  {Set true while moving to let caller ignore clicks}
    constructor create(newPaintbox:TGraphicControl); reintroduce;
    procedure resize(newwidth, newheight:integer);   reintroduce;
    procedure reset;
    procedure paint(sender:Tobject);   reintroduce;
    function makemove:boolean;
    procedure movecoin(from,vnbr:integer);
    procedure XMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  end;

  TForm1 = class(TForm)
    MoveBtn: TButton;
    ResetBtn: TButton;
    Bevel1: TBevel;
    Timer1: TTimer;
    Panel1: TPanel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure MoveBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
  public
    coinboard:TCoinboard;
  end;

var
  Form1: TForm1;

implementation

uses U_msg;

{$R *.DFM}
const
  coinsize:integer=8;
  coincolor=clyellow;
{************************************************************}
{************************* TCoinBoard Methods ***************}
{************************************************************}

{*********************** Create ******************}
constructor TCoinBoard.create(newpaintbox:TGraphicControl);
var
  i:integer;
begin
  inherited create(newpaintbox.owner);
  parent:=newpaintbox.parent;
  top:=newpaintbox.top;
  left:=newpaintbox.left;
  height:=newpaintbox.height;
  width:=newpaintbox.width;
  coinsize:=width div 27;
  onmousedown:=xmousedown;
  onpaint:=paint;
  coin:=TShape.create(self);
  with coin do
  begin
    shape:=stcircle;
    parent:=self.parent;
    brush.color:=coincolor;
    visible:=false;
    width:=2*coinsize;
    height:=width;
  end;
  for i:=1 to 8 do
  begin
    v[i].C1:=(i+2) mod 8 + 1;
    v[i].C2:=(i+4) mod 8 + 1;
  end;
  resize(width,height);
  reset;
end;

function min(a,b:integer):integer;
{hardly worth including Math unit for this one little routine}
begin  if a<b then result:=a else result:=b; end;


{************************** Resize *****************}
procedure TCoinboard.resize(newwidth,newheight:integer);
{rescale the board to newwidth, newheight}
var
  i:integer;
  radius:integer;
  start,inc:single;

begin

  width:=min(newwidth,newheight);
  height:=width;
  coinsize:=width div 27;
  coin.width:=2*coinsize;
  coin.height:=coin.width;
  {define the vertex locations}
  center.x:=width div 2;
  center.y:=height div 2;
  radius:= (4*width) div 10;
  start:=- pi/8; {1/16 of a circle}
  inc :=2*start;
  for i:= 1 to 8 do
  with v[i] do
  begin
    x:=trunc(center.x-radius*cos(start));
    y:=trunc(center.y+radius*sin(start));
    start:=start+inc;
    occupied:=false;
  end;
  reset;

end;

{************************ Paint ******************}
procedure TCoinBoard.paint(Sender:Tobject);
{draw the coin board}
var
  i:integer;
begin
  canvas.brush.color:=clblue;
  canvas.fillrect(clientrect);
  {draw the lines}
  canvas.pen.width:=1;
  with canvas do
  for i:=1 to 8 do
  with v[i] do
  begin
    moveto(x,y);
    lineto(v[C1].x, v[C1].y);
  end;
  {draw coins/coin positions}
  canvas.Pen.width:=1;
  for i:=1 to 8 do
  with canvas, v[i] do
  begin
    if occupied
    then brush.color:=coincolor
    else brush.color:=color;

    if (i=movingcoin) and showittime then brush.color:=coincolor;
    ellipse(x-coinsize,y-coinsize,x+coinsize,y+coinsize);
    If brush.color=color then canvas.textout(x-4,y-5,inttostr(i));
  end;
end;

{********************* Reset ****************}
procedure TCoinBoard.reset;
var
  i:integer;
begin
  for i:= 1 to 8 do
  with v[i] do
  begin
    occupied:=false;
    {freelines:=2;}
  end;
  coincount:=0;
  movingcoin:=0;
  showItTime:=false;
  moving:=false;
  invalidate;  {force a redraw of the board}
end;

{********************** MoveCoin *****************}
procedure TCoinboard.movecoin(from,vnbr:integer);
{Animates moving a coin}
var
  i, steps:integer;
  xstep,ystep:single;
    coincenter:tpoint;

  begin
    moving:=true;
    with v[vnbr]  do
    begin
      coincenter.x:=v[from].x;
      coincenter.y:=v[from].y;
      steps:=40;
      xstep:=(x-coincenter.x)/steps;
      ystep:=(y-coincenter.y)/steps;
      coin.visible:=true;
      for i:= 0 to steps-1 do
      begin
        coin.left:=trunc(i*xstep)+coincenter.x-coinsize+self.left;
        coin.top:=trunc(i*ystep)+coincenter.y-coinsize+self.top;
        application.processmessages;
        {sleep(5);}
      end;
      coin.visible:=false;
      v[vnbr].occupied:=true;
      v[from].occupied:=false;
    end;
    invalidate;
    moving:=false;
  end;


 {***************** MakeMove ****************}
function TCoinboard.makemove:boolean;
{For computer solution, find a move to vertex with fewest
 available edges and make it}
var
  minlines,vnbr:integer;
  fromv:integer;
  start,f:integer;
begin
  result:=false;
  fromv:=0;
  begin
    if coincount=0 then minlines:=2 else minlines:=1;
   {find an unoccupied vertex with the minlines to it}
   start:=random(8)+1; {start search at a random vertex}
   vnbr:=start+1;
   while (fromv=0) and (vnbr <>start) do
   begin
     inc(vnbr);
     if vnbr>8 then vnbr:=1;
     f:=2;
     with v[vnbr] do
     if not occupied then
     begin
       if v[C1].occupied then dec(f);
       if v[C2].occupied then dec(f);
       if f=minlines
       then {we found a vertex to check}
       begin
         if (v[C1].occupied) and  (v[C2].occupied)
         then showmessage('System error #1 , Call Grandpa')
         else
         begin
           if minlines=1 then
           if v[c1].occupied then fromv:=c2
           else fromv:=c1
           else {2 to choose from}
           case random(1) of
             0: fromv:=C1;
             1: fromv:=C2;
           end;
           inc(coincount);
           movecoin(fromv, vnbr);
           result:=true;
         end;
       end;
      end;
    end;
  end;
end;

{*****************************************************}
{********************** Form Methods *****************}
{*****************************************************}

{************** FormCreate **************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  doublebuffered:=true;
end;

{******************** FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  windowstate:=wsmaximized;
  coinboard:=TCoinboard.create(bevel1);
end;

{************************ FormResize ******************}
procedure TForm1.FormResize(Sender: TObject);
{FOrm is beign resized, resize the board}
begin
If assigned(coinboard)
then coinboard.resize(width-coinboard.left- width div 27,
                      height-coinboard.top- statictext1.height - height div 27);
end;


{************************** MoveBtnClick **************}
procedure TForm1.MoveBtnClick(Sender: TObject);
{Find the best coin to move and move it}
begin
  {strategy is to move a coin to the vertex which has te fewest unoccupied
   lines running to it}
  if coinboard.moving  then exit;
  with coinboard do
  begin
    movingcoin:=0; {in case there was a pending user move - ignore it}
    if makemove then
    begin
      If coincount=7 then
      with msgdlg do
      begin
        msgLbl.caption:='We have a winner! '+#13+#13+'        ME!!!';
        showmodal;
        reset;
      end;
    end
    else
    begin
      msgdlg.MsgLbl.caption:='No solution possible from here. '
       +#13+' I can''t save you from every mess you make!';
      MsgDlg.showmodal;
      reset;
    end;
  end;
end;

{********************** ResetBtnLick ***************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  coinboard.reset;
end;

{*************************** MouseDown ****************}
procedure TCoinboard.xMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i,j, vnbr:integer;
  validmoves:integer;
begin
  if moving then exit;  {ignore clicks while mouse is moving}
  vnbr:=0;
  for i:= 1 to 8 do
  begin
    if (abs(v[i].x - x)<coinsize)  and (abs(v[i].y-y)<coinsize) {clicked on a coin spot}
    then
    begin
      if (not v[i].occupied) then  vnbr:=i  else beep;
      break;
    end;
  end;
  if vnbr>0 then
  begin
    if movingcoin=0 then {start a new move}
    with v[vnbr] do
    begin
      if not (v[C1].occupied)
        or  not (v[C2].occupied) then
      begin
        movingcoin:=vnbr;
        showittime:=true; {force immediate display of flashing coin image}
        invalidate; {repaint}
      end
      else beep;
    end
    else
    with v[vnbr] do
    begin  {complete the move}
      if (C1 <> movingcoin) and (C2<>movingcoin) then vnbr:=0;
      if vnbr>0 then
      begin
        inc(coincount);
        movecoin(movingcoin,vnbr);
        movingcoin:=0;
        {see how many possible valid moves are left}
        validmoves:=0;
        for j:=1 to 8 do
        with v[j] do
        begin
          if (not v[j].occupied) and (not (v[C1].occupied and  v[C2].occupied))
          then
          begin
            inc(validmoves);
            break;
          end;
        end;
        if validmoves=0 then
        with msgdlg do
        begin
          if coincount=4
          then msglbl.caption:='Congratulations!'
              +#13+#13+'You just LOST in the fewest moves possible!'
          else if coincount<7
          then msglbl.caption:='You lose!'
              +#13+#13+'Might as well give up'
          else msglbl.caption:='You win!'
                         +#13+#13+'Probably just luck though'
                         +#13+#13+'Bet you can''t do it again';
          showmodal;
          reset;
        end;
      end
      else beep;
    end;
  end;
end;

{************************ Timer1Timer ***************}
procedure TForm1.Timer1Timer(Sender: TObject);
{Here's a timer that flips every half second to flash a pending coin move}
begin
  with coinboard do
  begin
    showittime:=not showittime;
    invalidate; {force coinboard repaint}
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  timer1.enabled:=false;
  canclose:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
