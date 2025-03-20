unit U_Puzzle15A;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{The 15 puzzle - scramble the sliders and put them back in sequence}
{Version 1.0 - no automatic solution} 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TBoardrec=record
     SliderIndex:integer;  {index of slider}
     col,row:Integer;
  end;

  TSliderBoard=class(TPanel)
    public
    Sidex,Sidey:integer;
    Board: array of  TBoardrec; {Slots for the sliders}
    Sliders:array of TPanel; {the sliders}
    Empty :integer; {index of the empty slot in the board array}
    Slotw:integer; {width & height of slider}
    UpdateMode:boolean;  {true=don't show animated moves}

    constructor create(panel:TPanel; newSideX,newSideY:integer);
    destructor destroy;
    procedure move(index:integer); {move index slider}
    procedure slideit(sender:Tobject); {slider onclick even handler}
    function canmove(index:integer):boolean; {check if move posible}
    procedure beginupdate;
    procedure endupdate;
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    SolveBtn: TButton;
    ScrambleBtn: TButton;
    SizeGrp: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure ScrambleBtnClick(Sender: TObject);
    procedure SizeGrpClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     SliderBoard:TSliderBoard;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  steps=20; {nbr of steps while moving a slider}

{********************* TSliderBoard.Create *************************}
constructor TSliderBoard.create(panel:TPanel;newsidex,newsidey:integer);
{Create s new sliderboard}
var
  i:integer;
begin
  sidex:=newsidex;
  sidey:=newsidey;
  setlength(sliders,sidex*sidey);
  setlength(board,sidex*sidey);
  inherited create(panel.owner);
  height:=panel.height;
  width:=panel.Width;
  if height>width then height:=width
  else width:=height;
  left:=panel.Left;
  top:=panel.Top;
  parent:=panel.parent;
  color:=panel.color;
  slotw:=width div sidex;
  for i:=1 to sidex*sidey-1 do
  begin
    sliders[i]:=TPanel.create(self);
    with sliders[i] do
    begin
      parent:=self;
      board[i-1].sliderindex:=i;
      board[i-1].col:=((i-1) mod sidex);
      board[i-1].row:=((i-1) div sidex);
      left:= board[i-1].col*slotw;
      top:=  board[i-1].row*slotw;
      width:=slotw;
      height:=slotw;
      caption:=inttostr(i);
      tag:=i;
      onclick:=slideit;
    end;
  end;
  empty:=sidex*sidey-1;
  board[empty].Sliderindex:=0;
  with board[empty] do
  begin
    col:=empty mod sidex;
    row:=empty div sidex;
  end;
  invalidate;
  updatemode:=false;
end;

{***************** TsliderBoard.Destroy ***************}
destructor TSliderBoard.destroy;
  var
  i:integer;
  begin
    for i:= 1 to high(sliders) do sliders[i].free;
    setlength(board,0);
    setlength(sliders,0);
    inherited;
  end;

{********************* TSliderBoard.SlideIt **************}
procedure TSliderBoard.slideit(sender:TObject);
{Onclick exit for slider - move to empty if adjacent}
var
  i,j:integer;
begin
  i:=TPanel(sender).tag;
  for j:=0 to high(board) do
  if board[j].sliderindex=i then break;
  if canmove(j) then move(j);
end;

{*********************** TSliderVBoard.Move *****************}
procedure TSliderBoard.move(index:integer);
{move slider at board[index] to empty slot}
var
  stepx,stepy:integer;
  destx,desty,i:integer;
begin
  destx:=board[empty].col*slotw;
  desty:=board[empty].row*slotw;
  with sliders[board[index].Sliderindex] do
  begin
    stepx:=(destx-left) div steps;
    stepy:=(desty-top) div steps;
    if not updatemode then
    for i:= 1 to steps do
    begin
      left:=left+stepx;
      top:=top+stepy;
      invalidate;
      sleep(10);
      application.processmessages;
    end;
    left:=destx;
    top:=desty;
    invalidate;
  end;
  board[empty].sliderindex:=board[index].sliderindex;
  board[index].sliderindex:=0;
  empty:=index;
end;

{******************** TSliderBoard.CanMove *****************}
function TSliderBoard.canmove(index:Integer):boolean;
{check to make sure the empty slot is adjacent to index slot}
var
  x,y:integer;
begin
  x:=board[index].col;
  y:=board[index].row;
  result:=false;
  if x=board[empty].col then
    if (y+1=board[empty].row)
      or (y-1=board[empty].row)
    then result:=true
    else
  else
  if y=board[empty].row then
    if (x+1=board[empty].col)
    or (x-1=board[empty].col)
    then result:=true;
end;

{********************* TSliderBoard.BeginUpdate ************}
procedure TSliderBoard.beginupdate;
{set update mode}
begin
  updatemode:=true;
end;

{******************** TSliderBoard.EndUpdate ***************}
procedure TSliderBoard.endupdate;
{reset update mode}
var
  i:integer;
begin
  updatemode:=false;
  for i:=1 to high(sliders) do sliders[i].invalidate;
end;

{****************** Form Methods ******************}

procedure TForm1.FormCreate(Sender: TObject);
var
  n:integer;
begin
  randomize;
  n:=sizegrp.itemindex+3;
  SliderBoard:=TSliderBoard.create(Panel1,n,n);
end;

procedure TForm1.ScrambleBtnClick(Sender: TObject);
{scramble the board by moving the empty space around}
var
  n,prev,i:integer;
begin
  sizegrp.enabled:=false;
  sliderboard.beginupdate;
  i:=0;
  prev:=-1; {keep prev move to eliminate reversals}
  with sliderboard do
  repeat
    n:=random(4);
    case n of
      0: {left}
         if (prev<>2) and (board[empty].col>0) then
         begin
            move(empty-1);
            inc(i);
            prev:=n;
         end;
      1: {up}
         if (prev<>3) and (board[empty].row>0) then
         begin
           move(empty-sidex);
           inc(i);
           prev:=n;
         end;
      2: {right}
         if (prev<>0) and (board[empty].col<sidex-1) then
         begin
           move(empty+1);
           inc(i);
           prev:=n;
         end;
      3: {down}
         if (prev<>1) and (board[empty].row<sidey-1) then
         begin
           move(empty+sidex);
           inc(i);
           prev:=n;
         end;
    end;
  until i>=100;
  sliderboard.endupdate;
  sizegrp.enabled:=true;
end;

procedure TForm1.SizeGrpClick(Sender: TObject);
{select a new board size}
var
  n:integer;
begin
  sliderboard.free;
  n:=sizegrp.itemindex+3;
  SliderBoard:=TSliderBoard.create(panel1,n,n);
end;

end.


