Unit U_SlidingCoins3;
 {Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Slide a Dime/Quarter or Quarter/Dime pair to get from initial to goal
 positions.  Can be done in 4 moves}
{Program is mainly an illustration of drag-drop with images}


{***$DEFINE DEBUG}  {remove *** to turn on debugging}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

const
  {coordinates}
  QHeight=60; {Size of Quarter}
  DHeight=30; {Size of Dime}
  YCenter=200; {center of coins}
  Halfw=(Qheight+Dheight) div 2;
  startleft=10;
  clCoincolor=ClBlue;
  clDraggedColor=ClAqua;

type
  TCoinval=(D,Q,E); {dime,quarter, empty}

  TCoin= class(Tshape)
  public
    cval:TCoinVal; {coin value}
    index:integer; {left to right index - to help identify clicks}
    function LogicalLeft:integer; {return the left edge for index if all were quarters}
    constructor create(Aowner:TComponent); override;
    procedure assign(Source:TCoin);  reintroduce;
    procedure makeEmpty; {set empty coin values}
    function GetDragImages:TDragImageList; override;

  end;

  TForm1 = class(TForm)
    ResetBtn: TButton;
    MoveEdt: TEdit;
    Label1: TLabel;
    SolveBtn: TButton;
    Panel1: TPanel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
                          State: TDragState; var Accept: Boolean);
    procedure ResetBtnClick(Sender: TObject);
    procedure CoinDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    coins:array[1..13] of TCoin;
    dragindex:integer;
    DragImages:TDragImageList; {coin images while dragging}
    moves:integer;
    {$IFDEF DEBUG}
      lastdebugmsg:string;
    {$ENDIF}
    procedure CoinMouseDown(Sender: TObject; Button: TMouseButton;
           Shift: TShiftState; X, Y: Integer);
    procedure CoinStartDrag(Sender: TObject;
              var DragObject: TDragObject);
    Procedure makemove(p:TPoint);
    procedure refresh;
    procedure DragEnded(Sender, Target: TObject; X, Y: Integer);
    procedure showsolved;
    function dropslot(x,y:integer):integer;
    procedure makecaption(leftSide, Rightside:string);
    {$IFDEF DEBUG}
    procedure debug(msg:string);
    {$ENDIF}
 end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

constructor TCoin.create;
begin
  inherited;
  ControlStyle := ControlStyle + [csDisplayDragImage];
  makeempty;
end;

{**************** TCoin.Assign ***************}
procedure TCoin.Assign(Source:TCoin);
{assign properties of source to self}
begin
  left:=source.left;
  top:=source.top;
  height:=Source.height;
  width:=Source.width;
  brush.color:=Source.Brush.color;
  shape:=source.shape;
  cval:=source.cval;
end;

{***************** TCoin.MakeEmpty *************}
procedure TCoin.MakeEmpty;
{set properties unique to an empty coin slot}
begin
  cval:=E;
  Height:=6;
  shape:=Strectangle;
  If width=qheight then brush.color:=clblack
  else brush.color:=clyellow;
  top:=ycenter+Qheight div 2 -height;
end;

{****************** TCoin.GetDragImages **********}
function TCoin.GetDragImages:TDragImageList;
 begin  result:=form1.DragImages; end;

{*************** TCoin.LogicalLeft **********}
function TCoin.LogicalLeft:integer;
begin  result:=(index-1)*qheight+startleft; end;


{*****************************************************}
{************** Form Methods **************************}
{*****************************************************}

{$IFDEF DEBUG}
procedure tform1.debug(msg:string);
begin
  with memo1, lines do
  if msg<>lastdebugmsg then lines.add(msg);
  lastdebugmsg:=msg;
end;
{$ENDIF}


{********************* TForm1.MakeCaption ******************}
procedure TForm1.makecaption(leftSide, Rightside:string);
var
  Metrics:NonClientMetrics;
  captionarea,spacewidth,nbrspaces:integer;
  b:TBitmap;
begin
  b:=TBitmap.create;  {to get a canvas}
  metrics.cbsize:=sizeof(Metrics);
  if SystemParametersInfo(SPI_GetNonCLientMetrics, sizeof(Metrics),@metrics,0)
  then  with metrics   do
  begin
    b.canvas.font.name:=Pchar(@metrics.LFCaptionFont.LfFaceName);
    with metrics.LFCaptionFont, b.canvas.font do
    begin
      height:=LFHeight;
      if lfweight=700 then style:=[fsbold];
      if lfitalic<>0 then style:=style+[fsitalic];
    end;
    {subtract 3 buttons + Icon + some border space}
    captionarea:=clientwidth-4*iCaptionwidth-4*iBorderWidth;;
    {n = # of spaces to insert}
    spacewidth:=b.canvas.textwidth(' ');
    nbrspaces:=(captionarea-b.canvas.textwidth(Leftside + Rightside)) div spacewidth;
    if nbrspaces>3 then caption:=LeftSide+stringofchar(' ',nbrspaces)+RightSide
    else caption:=LeftSide+' '+RightSide;
  end;
  b.free;
end;

{***************** TForm1.FormCreate ***************}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  b:TBitmap;
begin
  {required for form to show drag images}
  ControlStyle := ControlStyle + [csDisplayDragImage];
  for i:=low(coins) to high(coins) do  coins[i]:=tCoin.create(self);
  resetBtnClick(sender); {make initial images}
  doublebuffered:=true;

  {make drag images}
  DragImages:=TDragIMageList.create(self);
  DragImages.width:=dheight+qheight;
  DragImages.height:=qheight;
  b:=tBitmap.create; {dime+ quarter}
  b.width:=dheight+qheight;
  b.height:=qheight;

  with b.canvas do
  begin
    ellipse(0,(Qheight-dheight) div 2,dheight,Halfw);
    ellipse(dheight,0, dheight+qheight,Qheight);
  end;
  DragImages.Add(b,nil);

  b:=TBitmap.create;  {quarter+dime}
  b.width:=dheight+qheight;
  b.height:=qheight;
  with b.canvas do
  begin
    ellipse(0,0,qheight,qheight);
    ellipse(qheight,(Qheight-dheight) div 2,
            dheight+qheight,halfw);
  end;
  DragImages.Add(b,nil);
end;

{********************* TForm1.DropSlot ************}
function Tform1.DropSlot(x,y:integer):integer;
  var
    tempx,n:integer;
    m,max:integer;

    function closest(x:integer):integer;
    var i:integer;
    begin
      i:=0;
      repeat
        inc(i);
        if i=1 then m:=0 else m:=coins[i].left-coins[i-1].width div 2;
        max:=coins[i].left+coins[i].width div 2;
      until (x>=m) and (x<=max);
      result:=i
    end;

  begin
    tempx:=x-halfw; {set x to left side of dragimage}
    n:= closest(tempx);
    if ((coins[n].cval=E) and (coins[n+1].cval=E))
    or ((n=dragindex+1) and (coins[n+1].cval=E))
    or ((n=dragindex-1) and (n>1) and (coins[n].cval=E))
    then result:=n
    else result:=-1;
  end;

{****************** TForm1.CoinMouseDown *****************}
procedure TForm1.CoinMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Get ready to drag a pair of coins}
var
  leftmost,closest:integer;
begin
  If sender is TCoin then
  with sender as tcoin do
  begin
    If cval=E then exit;
    {find closest adjoining coin}
    leftmost:=index;
    if (x<width div 2) {it was on the left hand side}
        and (index>low(coins)) {and not first}
    then leftmost:=index-1;
    If (leftmost=high(coins))
    or ((coins[leftmost+1].cval=E) and (leftmost>low(coins)))
    then  dec(leftmost);
    closest:=leftmost+1;
    {make sure a valid coin pair has been selected}
    If (coins[leftmost].cval<>coins[closest].cval) and
       (coins[leftmost].Cval<>E) and (coins[closest].Cval<>E)
    then
    begin
      coins[leftmost].brush.color:=clDraggedColor;
      coins[closest].brush.color:=clDraggedColor;
      {update those images before showing drag image}
      application.processmessages;

      {move the cursor to the top center of the coin pair - the hotspot}
      mouse.cursorpos:=point(coins[leftmost].left+self.left+halfw,
                             self.top+ycenter-qheight div 2);

      coins[leftmost].begindrag(true,0);
      {$IFDEF DEBUG} debug('Mousedown begin drag '+inttostr(leftmost)); {$ENDIF}
    end;
  end;

end;

{******************* TForm1.CoinStartDrag ***************}
procedure TForm1.CoinStartDrag(Sender: TObject; var DragObject: TDragObject);
var
  hotx,hoty:integer;
begin
  hotx:=halfw;
  hoty:=0;
  if TCoin(Sender).width=dheight {dime is on left}
  then DragImages.setdragimage(0,hotx,hoty)
  {else quarter is on left}
  else DragImages.setdragimage(1,hotx,hoty);
  dragindex:=TCoin(sender).index;
  {$IFDEF DEBUG} debug('Startdrag , dragindex='+inttostr(dragindex)); {$ENDIF}
end;

{**************** TForm1.FormDragOver *****************}
procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);

var tempx:integer;
    r:integer;
begin
  if sender=source then accept:=false
  else
  begin
   {since we're using the same exit for dragging over coins or the form,
    we need to adjust coin X coordinate to look like form X coordinate}
   {If sender is TCoin then tempx:=x+TCoin(sender).left
   else} tempx:=x;
   r:=dropslot(tempx,y);
   accept:=r>=0;
   {$IFDEF DEBUG}
   debug('Dragover, x='+inttostr(tempx)+ ',Dindex='+inttostr(dragindex)+', Dslot='+inttostr(r));
   {$ENDIF}
   mouse.cursorpos:=point(tempx,self.top+ycenter-Qheight div 2);
  end;
end;

{*********************** TForm1.CoinDragDrop *************}
procedure TForm1.CoinDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  t:integer;
  i, L1:integer;
  tempx:integer;
  check:string;
begin
  If sender is TCoin then tempx:=x+TCoin(sender).left
  else tempx:=x;
  t:=dropslot(tempx,y);
  {$IFDEF DEBUG} debug('DragDrop, x='+inttostr(tempx)+', dropslot='+inttostr(t));
  {$ENDIF}
  if (t>0) then
  begin
    if t=dragindex+1 then {overlapped, move it first}
    with TCoin(source) do
    begin
      coins[t+1].assign(coins[dragindex+1]);
      coins[t+1].index:=t+1;
      coins[t+1].left:=coins[t].left+coins[dragindex].width;
      coins[t+1].brush.color:=clCoinColor;
      L1:=coins[t].left;
      coins[t].assign(coins[dragindex]);
      coins[t].left:=L1;
      coins[t].index:=t;
      coins[t].brush.color:=clCoinColor;
    end
    else
    begin
      L1:=coins[t].left;
      coins[t].assign(coins[dragindex]);
      coins[t].left:=L1;
      coins[t].index:=t;
      coins[t].brush.color:=clCoinColor;
      coins[t+1].assign(coins[dragindex+1]);
      coins[t+1].index:=t+1;
      coins[t+1].left:=coins[t].left+coins[t].width;
      coins[t+1].brush.color:=clCoinColor;
    end;
    if (dragindex<>t) and (dragindex<>t+1) then coins[dragindex].makeempty;
    if (dragindex<>t-1) and (dragindex<>t) then coins[dragindex+1].makeempty;
    {We might have moved a small/big over  small/small empty slots,
    so readjust left coordinates in case}
    for i:=t+2 to high(coins) do
    begin
      coins[i].left:=coins[i-1].left+coins[i-1].width;
    end;
  end;
  refresh;
  {check if solved {look for DDDQQ}
  check:='';
  for i:= low(coins) to high(coins) do
  begin
    case coins[i].cval of
      D: check:=check+'D';
      Q: check:=check+'Q';
    end;
  end;
  if (check='QQDDD') or (check='DDDQQ') then showsolved;
end;

{***************** TForm1.refresh ****************}
procedure TForm1.refresh;
{re-sort coins array by left to right and renumber}
var
  i:integer;
begin
  for i:=2 to high(coins) do
  begin
    if (coins[i-1].cval=E) and (coins[i].cval=E) then
    begin
      if coins[i-1].width=dheight
      then coins[i].width:=qheight
      else coins[i].width:=dheight;
      coins[i].makeempty;
    end;
    coins[i].left:=coins[i-1].left+coins[i-1].width;
  end;
  inc(moves);
  MoveEdt.text:=inttostr(moves);
end;

{*************** TForm1.MakeMove **********************}
Procedure TForm1.makemove(p:TPoint);
{Auto-move coins p.x  and p.x+1 to p.y and p.y+1 locations}
var
  i:integer;
  start1,start2:integer;
begin
  start1:=coins[p.x].left;  {save location to put empties back here later}
  start2:=coins[p.x+1].left;

  {move down}
  for i:= 0 to qheight do
  begin
    with coins[p.x] do top:=top-1;
    with coins[p.x+1] do top :=top-1;
    {no need to process message for every loop - too slow}
    if i mod 2=0 then application.processmessages;
  end;
  {move left or right}
  if p.y>p.x then {right}
  for i:= coins[p.x].left+1 to coins[p.y].left do
  begin
    coins[p.x].left:=i;
    coins[p.x+1].left:=i+coins[p.x].width;
    if i mod 2=0 then application.processmessages;
  end
  else {left}
  for i:= coins[p.x].left+1 downto coins[p.y].left do
  begin
    coins[p.x].left:=i;
    coins[p.x+1].left:=i+coins[p.x].width;
    if i mod 2=0 then application.processmessages;
  end;
  {move up}
  for i:= 0 to qheight do
  begin
    coins[p.x].top:=coins[p.x].top+1;
    coins[p.x+1].top:=coins[p.x+1].top+1;
    if i mod 2=0 then application.processmessages;
  end;
  {put coin info in new place}
  coins[p.y].assign(coins[p.x]);
  coins[p.y+1].assign(coins[p.x+1]);
  coins[p.x].makeempty;
  coins[p.x].left:=start1;
  coins[p.x+1].makeempty;
  coins[p.x+1].left:=start2;
  refresh; {renumber and resort coin array}
end;

{******************* TForm1.ResetBtnClick ****************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Reset coins to initial configuration}
var
  nextleft,i,n:integer;
begin
  nextleft:=startleft;
  for i:=low(coins) to high(coins) do
  with coins[i] do
  begin
    parent:=self;
    left:=nextleft;
    index:=i;
    onMouseDown:=coinMouseDown;
    onstartdrag:=CoinStartDrag;
    (*
    OnDragOver:= FormDragOver;
    OnDragDrop:=CoinDragDrop;
    *)
    OnEndDrag:=DragEnded;
    if (i>5) then
    begin
      if i mod 2 =1 then
      width:=Dheight
      else width:=qheight;
      MakeEmpty;
    end
    else
    begin
      brush.color:=clCoinColor;
      shape:=stcircle;
      case i mod 2 of
      1: begin
           top:=ycenter-DHeight div 2;
           width:=DHeight;
            height:=DHeight;
            cval:=D;
         end;
      0: begin
          top:=ycenter-QHeight div 2;
          width:=qHeight;
          height:=qHeight;
          cval:=Q;
        end;
      end; {case}
    end;
    nextleft:=nextleft+width;
  end;
  moves:=0;   {reset moves}
  moveEdt.text:='0';
  n:=startleft;
  with canvas do
  begin
    pen.width:=1;
    pen.color:=clblack;
    while n<coins[high(coins)].left+qheight do
    begin
      moveto(n,ycenter+10+dheight);
      lineto(n,ycenter+dheight+20);
      n:=n+dheight;
    end;
  end;
  memo1.clear;
end;

(********************* TForm1.ShowSolved *****************)
procedure TForm1.Showsolved;
  begin
    If moves>4
    then application.messagebox('(It can be done in fewer moves though)','Solved!',
                               mb_OK+MB_IconExclamation)
    else if moves=4 then application.messagebox('Yes - you are good','Solved!',
                               mb_OK+MB_IconExclamation)
    else showmessage('Cheating again?');
  end;

{****************** TForm1.SolveBtnClick **********}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  sol:array [0..1] of array [1..5] of tpoint;
  i,j:integer;
begin
  {set up solutions}
  sol[0,1]:=point(1,6); sol[0,2]:=point(3,8);  sol[0,3]:=point(6,10);
  sol[0,4]:=point(9,6);  sol[0,5]:=point(5,9);
  sol[1,1]:=point(3,6); sol[1,2]:=point(1,8);  sol[1,3]:=point(6,10);
  sol[1,4]:=point(9,6);  sol[1,5]:=point(5,9);
  resetbtnclick(sender);
  sleep(500);
  j:=random(2); {pick a solution to display}
  for i:= 1 to 5 do  MakeMove(sol[j,i]);
  Showsolved;
end;
{4-move solution: (1,8),(3,10),(9,6),(5,9)}

{************* TForm1.DragEnded ******************}
 procedure TForm1.DragEnded(Sender, Target: TObject; X, Y: Integer);
 begin
   If (target=nil) then {drag failed, restore images}
   begin
      coins[dragindex].brush.color:=clCoinColor;
      Coins[dragindex+1].brush.color:=clCoinColor;
      dragindex:=0;
   end;
end;

{***************** TForm1.ForActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  windowstate:=wsmaximized;
  makecaption('Sliding Coins Puzzle', #169+'2001 G. Darby, www.DelphiForFun.com');
  application.processmessages;
  {$IFDEF DEBUG} memo1.visible:=true; {$ENDIF}
  resetbtnclick(sender);
end;


(*
procedure TForm1.Button1Click(Sender: TObject);
{Generate and save bmp images of start and end configurations}
var
  b:TBitmap;
  fpath:string;
  x,i:integer;
begin

  fpath:=extractfilepath(application.exename);
  b:=TBitmap.create;
  b.height:=70;
  b.width:=230;
  b.pixelformat:=pf24bit;
  x:=10;
  b.canvas.brush.color:=clblue;
  for i:=1 to 5 do
  begin
    if i mod 2 =1 then
    begin
      b.canvas.ellipse(x,20,x+30,50);
      x:=x+30;
    end
    else
    begin
      b.canvas.ellipse(x,5,x+60,65);
      x:=x+60;
    end
  end;
  b.savetofile(fpath+'StartImage.bmp');
  b.free;


  b:=TBitmap.create;
  b.height:=70;
  b.width:=230;
  b.pixelformat:=pf24bit;
  x:=10;
  b.canvas.brush.color:=clblue;
  for i:=1 to 5 do
  begin
    if i <=3 then
    begin
      b.canvas.ellipse(x,20,x+30,50);
      x:=x+30;
    end
    else
    begin
      b.canvas.ellipse(x,5,x+60,65);
      x:=x+60;
    end
  end;
   b.savetofile(fpath+'EndImage.bmp');
end;
*)


end.
