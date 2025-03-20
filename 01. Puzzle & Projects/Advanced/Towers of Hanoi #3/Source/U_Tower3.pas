unit U_Tower3;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Towers of Hanoi version 3 - with animated graphics}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

Const
  maxGraphicDisks=10;
type
  TDisk = class(TShape)  {the disks}
    Private
      nbr:integer;
      pegnbr:integer;
    Public
      Constructor Create(Aowner:TComponent); override;
      Procedure MoveToPeg(x,y, moveincr:integer);
  end;

  TTower = class ; {forward declaration so Tpeg.create can reference tower}

  TPeg = class(TObject) {the disks}
    Private
      pegnbr:integer;
      Disk:Array of TDisk;
      NbrDisks:integer;
      l,t,w,h:integer; {dimensions of pegbox}
      PegCenter:integer;
      constructor Create (AOwner:TTower; r:Trect; NewTotDisks:integer;
                          Fillit:boolean; newpegnbr:integer);
    public
      destructor destroy; override;
    end;

  TTower = class (TPanel)
    protected
      procedure paint;  override;

    private
      Peg:array[1..3] of TPeg;
      TotDisks:integer;
      Topmargin,PegHeight,PegWidth, Spacing:integer;
      PixelWidthPerDisk,MaxDiskWidth,DiskHeight:integer;
      dragdisk:TDisk;
      droppeg:integer;
      diskcolor:array of Tcolor;
      movecount:integer;
      MoveCountLbl:TLabel;
      constructor Create(Aowner:TComponent; NewnbrDisks:integer;
                         Imagerect:TRect);  reintroduce;
      procedure reset;
      procedure moveone(FromPeg,ToPeg:integer;moveincr:integer);
      procedure DragOverEvent(Sender, Source: TObject; X, Y: Integer;
                         State: TDragState; var Accept: Boolean);

      procedure DragDropEvent(Sender, Source: TObject; X, Y: Integer);

    public
      destructor destroy;  override;

    end;

  TForm1 = class(TForm)
    Label1: TLabel;
    SolveBtn: TButton;
    Memo1: TMemo;
    StopBtn: TButton;
    Image1: TImage;
    Panel1: TPanel;
    GraphicsOn: TCheckBox;
    ResetBtn: TButton;
    Memo2: TMemo;
    DisksUD: TUpDown;
    TrackBar1: TTrackBar;
    Label2: TLabel;
    Disksedt: TEdit;
    procedure SolveBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure DisksEdtChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
  public
    { Public declarations }
    nbrdisks:Integer;
    movecount:Int64;
    starttime:TDateTime;
    seconds,rate:double;
    tower:TTower;
    Moveincr:integer;
    Procedure MoveOne(A,C:integer);
    Procedure MoveStack(n, A,C,B:integer);
    Procedure MakeLabels(s:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses math, Results;

{********************* Moveone *******************}
Procedure TForm1.MoveOne(A,C:integer);
{set up animated move of the top disk from peg A to peg C}
{calls tower.moveone procedure}
var
  starttime, endtime:TDateTime;
  targettime:real;
Begin
  inc(movecount);
  If graphicson.checked then
  Begin
    targettime:= 60/(Trackbar1.position*secsperday); {target days per peg}
    starttime:=now;
    endtime:=starttime + abs(a-c)*targettime;
    tower.moveone(a,c,moveincr);
    moveincr:=max(1, trunc(moveincr*(now-starttime)/targettime));
    application.processmessages;
    While now<endtime do application.processmessages;
  end;
End;

{********************** MoveStack ***************}
Procedure TForm1.MoveStack(n, A,C,B:integer);
{Use recursive calls to move n pegs from Peg A to Peg C with Peg B as a spare}
  Begin
    if tag=1 then exit; {User signaled to stop}
    If (nbrdisks>MaxGraphicDisks) and (movecount mod 1000 =0)
    then application.processmessages; {Every 100 moves, give Windows a chance}
    If n=1 then
    Begin
       MoveOne(A,C); {If there's only one to move, move it}
    end
    else
    Begin
      MoveStack(n-1, A,B,C);  {Move n-1 pegs to peg B}
      MoveStack(1,A,C,B);     {Then move bottom peg to Peg C}
      MoveStack(n-1,B,C,A);   {Then move n-1 pegs from B back to Peg C}
    end;
  end;

{****************** SolveBtnClick ************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{show computer solution }
begin
  tag:=0; {Quit flag - set by stop button}
  If not graphicson.checked then screen.cursor:=crHourGlass;
  SolveBtn.enabled:=false;
  ResetBtn.enabled:=false;
  StopBtn.enabled:=true;
  movecount:=0;
  starttime:=time;
  If nbrdisks<=MaxGraphicDisks then Tower.reset;
  ResultsDlg.MovesLbl.Caption:='Number of moves:' ;
  ResultsDlg.timelbl.caption:='Number of Seconds: ';
  ResultsDlg.ratelbl.caption:='Moves per second: ';
  moveincr:=2;
  MoveStack(nbrdisks,1,3,2); {move nbrdisks from peg 1 to peg 3 using peg2 as the spare}
  If tag=0 then makelabels('Complete');
  SolveBtn.enabled:=true;
  ResetBtn.enabled:=true;
  StopBtn.enabled:=false;
  Screen.cursor:=CrArrow;
  ResultsDlg.showmodal;
end;

{******************** MakeLabels **************}
Procedure TForm1.MakeLabels(S:String);
{setup results display}
Begin
  ResultsDlg.MovesLbl.Caption:='Number of moves: '+floattostrf(movecount,ffnumber,9,0);
  seconds:=(time-starttime)*SecsPerDay;
  ResultsDlg.timelbl.caption:='Number of Seconds: '+floattostrf(seconds,ffnumber,6,1);
  If seconds>=0.5 then
  Begin
     rate:=movecount / seconds;
     ResultsDlg.ratelbl.caption:='Moves per second: '+floattostrf(rate,ffnumber,9,0);
  end
  else
   ResultsDlg.ratelbl.caption:='Moves per second: Need runtime of at least'
                   +#13+' 1/2 second to calculate rate';
End;

{***************** StopBtnCLick *************}
procedure TForm1.StopBtnClick(Sender: TObject);
{interrupt computer solution}
var
  years:single;
  s:string;
begin
  makelabels('Not Complete');
  Screen.cursor:=crArrow;
  ResultsDlg.EstSecsLbl1.visible:=true;
  ResultsDlg.EstsecsLbl2.visible:=true;
  ResultsDlg.EstSecsLbl1.caption:= 'Estimated time to complete: '
   + floattostrf((power(2,nbrdisks)-1)/Rate,ffnumber,8,1)+' seconds';
  years:=power(2,nbrdisks)/(365*24*3600);
  If years<=1 then s:=' year)' else s:=' years!)';
  ResultsDlg.EstSecsLbl2.caption:=
   'Est. time at 1 move per second: '
   +#13
   +floattostrf(Power(2,nbrdisks),ffnumber,20,0)
   +' seconds '+#13+'(That''s '
   +floattostrf(years,ffnumber,15,0)+s;
  SolveBtn.enabled:=true;
  StopBtn.enabled:=false;
  tag:=1; {Set quit flag}
end;


{******************* DisksEdtChange **************}
procedure TForm1.DisksEdtChange(Sender: TObject);
{set up a new number of disks }
begin
  nbrdisks:=disksUD.position;
  If nbrdisks>MaxGraphicDisks then
  Begin
    freeandnil(tower);
    graphicson.checked:=false;
  end
  else
  Begin
    if assigned(tower) then tower.free;
    tower:=TTower.create(self,nbrdisks,image1.boundsrect);
    graphicson.checked:=true;
  end;
end;

{***************** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  disksedtchange(sender);
  moveincr:=1;
end;

{***************** ResetBtnClick ***************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{reset the tower}
begin    tower.reset;  end;


{************************************************************}
{*********** Here begins all the graphics stuff *************}
{************************************************************}

{************************************************************************}
{************************** TTower methods ******************************}
{************************************************************************}

{***************************** TTower.create ****************************}
Constructor TTower.create(AOwner:TComponent; NewnbrDisks:integer; Imagerect:TRect);
Begin
  inherited Create(AOwner);
  Parent:=TWincontrol(Aowner);
  OnDragOver:=DragOverEvent;
  OnDragDrop:=DragDropEvent;
  doublebuffered:=true;
  TotDisks:=NewNbrDisks;
  Left:=Imagerect.left;
  Top:=ImageRect.top;
  Width:=Imagerect.right-imagerect.left;
  Height:=ImageRect.Bottom-Imagerect.top;

  Pegwidth:=width div 4;
  Spacing:=width*6 div 100;
  Pegheight:= height*9 div 10;
  TopMargin:= Height div 10;
  MaxDiskWidth:=Pegwidth-4;

  MoveCountLbl:=Tlabel.create(self);
  with MoveCountLbl do
  Begin
    parent:=self;
    top:= 0;
    canvas.font.size:=24;
    font.size:=24;
    left:=self.width-canvas.textwidth('0000');
    caption:='';
  end;
  reset; {create (or free and recreate) all pegs & disks}
  sendtoback; {put board behind disk images}
end;

{***************************** TTower.MoveOne *********************}
Procedure TTower.moveone(FromPeg,ToPeg:integer;moveincr:integer);
{animate move of top disk from frompeg to topeg}
var
  tempdisk:TDisk;
  i:integer;
Begin
  with peg[frompeg] do
  Begin
    tempdisk:=disk[nbrdisks];
    dec(nbrdisks);
  end;

  {disable all dragging during the move}
  for i:= 1 to 3 do
  with peg[i] do
  if nbrdisks>0 then disk[nbrdisks].dragmode:=dmmanual;

  with peg[topeg] do
  Begin
    inc(nbrdisks);
    disk[nbrdisks]:=tempdisk;
    with disk[nbrdisks] do
    Begin
      {MoveToPeg(pegcenter-width div 2, t+h-6 -nbrdisks*height, moveincr);}
      MoveToPeg(peg[frompeg].pegcenter-width div 2, 0, moveincr);  {up}
      MoveToPeg(pegcenter-width div 2, 0, moveincr);  {over}
      MoveToPeg(pegcenter-width div 2, t+h-6 -nbrdisks*height, moveincr);{down}
      pegnbr:=topeg;
    end;
  end;
  inc(Movecount);
  MovecountLbl.caption:=inttostr(movecount);
  invalidate;
  {enable all top disk dragging after the move}
  for i:= 1 to 3 do
  with peg[i] do
  if nbrdisks>0 then disk[nbrdisks].dragmode:=dmautomatic;
end;

{*************************** TTower.reset ************************}
Procedure ttower.reset;
{start over}
const
  maxcolors=12;
  colors:array[0..maxcolors-1] of TColor =
            (clred,clblue,clgreen,clyellow,
             clteal,clAqua,clLime, clNavy,
             clPurple,clMaroon,clOlive,clFuchsia);
var
  i,j,t,b,l,r:integer;
  usedcolors:array of boolean;
Begin
  {Set a random set of colors for disks - without duplicates}
  setlength(usedcolors, maxcolors);
  setlength(diskcolor, totdisks);
  for i:= 0 to maxcolors-1 do usedcolors[i]:=false;
  randomize;
  if totdisks<=maxcolors then {normal case}
  Begin
    for i:=0 to totdisks-1 do
    Begin
      j:=random(maxcolors);
      if usedcolors[j] then {find the next unused color}
      while usedcolors[j] do j:= (j+1) mod maxcolors;
      diskcolor[i]:=colors[j];
      usedcolors[j]:=true;
    end;
  end
  else for i:= 0 to totdisks-1 do diskcolor[i]:= colors[random(maxcolors)];

  {Set up peg box dimensions & create pegs}
  T:=TopMargin;
  B:=T+Pegheight;
  PixelWidthPerDisk:=Pegwidth div totdisks;
  DiskHeight:=Pegheight div (TotDisks+1);
  For i:= 1 to 3 do
  Begin
    L:=spacing + (i-1)*(Pegwidth+spacing);
    R:=L+Pegwidth;
    if assigned(Peg[i]) then peg[i].free;
    If i=1 then peg[1]:=TPeg.create(self, Rect(l,t,r,b),Totdisks,True,i)
    else peg[i]:=TPeg.create(self, Rect(l,t,r,b),Totdisks,False,i);
  end;
  movecount:=0;
  MoveCountLbl.caption:='';
  invalidate;
end;

{********************* TTower.DRagOverEvent *******************}
procedure TTower.DragOverEvent(Sender, Source: TObject; X, Y: Integer;
                                       State: TDragState; var Accept: Boolean);
{called when a disk is dragged over a tower}
var
  cx,cy,i:integer;
Begin
  accept:=false;
  droppeg:=0;
  If (source is Tdisk) then
  with source as TDisk do
  Begin
    {key from the center of the disk to determine which peg it may be on}
    cx:=x+width div 2;
    cy:=y+ height div 2;
    for i:= 1 to 3 do
    with peg[i] do
    Begin
      {must be in the peg box}
      If (l<cx) and (l+w>cx) and (t<cy) and (t+h>cy)
         and (TDisk(source).pegnbr<>i)
       then
      {and disk number must be smaller than the top disk
       on the potential drop peg}
      if (nbrdisks=0) or (nbr< disk[nbrdisks].nbr) then
      Begin
        accept:=true;
        droppeg:=i;
        break;
      end;
    end;
  end;
end;

{******************** TTOwer,DragDropEvent ******************}
procedure TTower.DragDropEvent(Sender, Source: TObject; X, Y: Integer);
{called when disk is dropped}
Begin
 if (source is tDisk) and (droppeg>0)
 then moveone(TDisk(Source).pegnbr,droppeg,2);
 droppeg:=0;
 freeandnil(dragdisk);
end;


{************************** TTower.Boardpaint *********************}
Procedure TTower.paint;
{This routine repaints the pegs, disks are owned by the tower and will be
 redrawn automatically}
var
  i:integer;
Begin
  For i:=1 to 3 do
  with canvas, peg[i] do
  Begin
    {horizontal peg line}
    pen.width:=8;
    moveto(pegcenter-maxdiskwidth div 2 - 4,height-4);
    lineto(pegcenter+maxdiskwidth div 2+ 4,height-4);

    {vertical peg line}
    moveto(pegcenter,height-4);
    lineto(pegcenter,24);
  end;
End;


{************************ TTower.free **********************}
destructor TTower.destroy;
var
  i:integer;
Begin
  for i:= 1 to 3 do peg[i].free;
  inherited ;
end;

{************************************************************}
{******************** TPeg methods **************************}
{************************************************************}

{******************* TPeg.create ****************************}
Constructor TPeg.Create(Aowner:TTower; r:Trect; NewTotDisks:integer;
                        fillIt:boolean; newpegnbr:integer);
var
  i:integer;
Begin
  inherited create;
  L:=R.left; W:=R.Right-R.Left; T:=R.Top; H:=R.Bottom-R.top;
  pegnbr:=newpegnbr;
  Setlength(disk,Newtotdisks+1);
  PegCenter:=L+ w div 2;
  If fillit then
  Begin
    NbrDisks:=NewTotDisks;
    For i:=1 to Nbrdisks do
    Begin
      disk[i]:=TDisk.create(Aowner);
      with disk[i] do
      Begin
        parent:=Aowner;
        nbr:=Nbrdisks+1-i;
        width:=nbr*aowner.pixelWidthPerDisk;
        height:=aowner.Diskheight;
        left:=pegcenter-width div 2;
        top:=t+H-6 -(i*aowner.diskheight);
        brush.color:=Aowner.diskcolor[i-1];
        pegnbr:=self.pegnbr;
      end;
    end;
    disk[nbrdisks].dragmode:=dmAutomatic; {make top disk draggable}
  end
  else nbrdisks:=0;
end;


{************************* Tpeg.free *********************}
destructor TPeg.destroy;
var
  i:integer;
Begin
  for i:=1 to nbrdisks do if assigned(disk[i]) then disk[i].free;
  inherited destroy;
end;

{************************************************************}
{******************** TDisk methods *************************}
{************************************************************}

{***************** Tdisk,Create ****************}
Constructor TDisk.create(aowner:TComponent);
Begin
  inherited ;
  shape:= stRoundRect;
end;

{******************** TDisk.MoveToPeg ***************}
Procedure TDisk.MoveToPeg(x,y:integer; moveIncr:integer);
{move a disk from current location to x,ym by moving up off of peg,
then horizontally, then down to top of new stack}
  var
    dy:real;
    dx:integer;
    startx,starty:integer;
    newx,newy:extended;
    intnewx,intnewy:integer;
    stopx:integer;
  begin
    stopx:=x;
    startx:=left;
    starty:=top;
    if moveincr=0 then moveincr:=2;
    if startx<>x then
    begin
      If stopx>startx then dx:=moveincr else dx:=-moveincr;
      dy:=(starty-y)/(startx-x)
    end
    else
    begin
      dx:=0;
      If y>starty then dy:=moveincr else dy:=-moveincr;
    end;
    newx:=startx;
    newy:=starty;
    intnewx:=trunc(newx);
    intnewy:=trunc(newy);
    while (intnewx<>stopx) or (intnewy<>y) do
    Begin
      newx:=newx+dx;
      newy:=newy+dy;
      intnewx:=trunc(newx);
      intnewy:=trunc(newy);
      If ((dx<0) and (intnewx<stopx)) or ((dx>0) and (intnewx>stopx))
      then intnewx:=stopx;
      If abs(trunc(newy)-y) < abs(dy) then intnewy:=y;
      left:=intnewx;
      top:=intnewy;
      update; invalidate;
      application.processmessages;
    end;
  end;



end.
