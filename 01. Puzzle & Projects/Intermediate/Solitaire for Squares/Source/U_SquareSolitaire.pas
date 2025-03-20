unit U_SquareSolitaire;
{Copyright 2002, 2014  Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Solitaire for Squares -
   Drag each heart card onto a different spade so that that the sum of
   values for each pair is a perfect square.  (Squares are 4,9,16,25, etc. ).

  Jack has value 11, Queen has value 12, and King has value 13.

  How hard can it be?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UCardComponentV2, ComCtrls;

type
  TBoard=array[1..13] of integer;
  TForm1 = class(TForm)
    HintBtn: TButton;
    StatusBar1: TStatusBar;
    procedure HintBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormActivate(Sender: TObject);
  public
    board:TBoard; {array of spade slots, to be filled with heart card values}
    targetboard:TBoard;  {the filled solution board used to give hints}
    spadeset:array[1..13] of TCard; {the 13 spades}
    heartset:array[1..13] of TCard; {the 13 hearts}
    heartinplace:array[1..13] of boolean;{flag saying heart card is in place}
    moveincrement:integer; {pixels per step during hintmove displays}
    globalhint:boolean; {true if hint was given during game}
    function getnextmove(board:TBoard; n:integer):boolean;
    procedure resetboard;
  end;

var Form1: TForm1;

implementation

uses U_Intro;
{$R *.DFM}

{************* IsSquare ***********}
function issquare(n:integer):boolean;
{return true if n is the square of another integer}
var i:integer;
begin
  i:=trunc(sqrt(n));
  if i*i=n then result:=true
  else result:=false;
end;


{********************** GetNetxMove ****************}
function TForm1.getnextmove(board:TBoard; n:integer):boolean;
{recursive search to fill all 13 positions of a board so that
 the sum of each entry and it's positions is a square}
var
  newboard:TBoard;
  i:integer;
begin
  if n>13 then
  begin
    targetboard:=board;
    result:=true;
    exit;
  end;
  result:=false;
  newboard:=board;
  for i:=1 to 13 do
  begin
    if (board[i]=0) and (issquare(i+n)) then
    begin
      newboard[i]:=n;
      result:=getnextmove(newboard,n+1);
      if not result then newboard[i]:=0
      else break;
    end;
  end;
end;

{************ ResetBoard **********}
procedure TForm1.resetboard;
{Reset the board and display to initial state}
var i:integer;
begin
  for i:=1 to 13 do
  begin
    with spadeset[i] do
    if i<=7 then
    begin
      left:=10+(i-1)*(width+10);
      top:=10;
    end
    else
    begin
      left:=10+(i-8)*(width+10);
      top:=150;
    end;
    with heartset[i] do
    begin
      left:=5+(i-1)*50;
      top:=325;
      bringtofront;
    end;
    board[i]:=0;
    heartinplace[i]:=false;
  end;
  globalhint:=false;
end;

{********************** FormCreate ***************}
procedure TForm1.FormCreate(Sender: TObject);
{Initialization stuff}
var  i:integer;
     board:TBoard;
begin
  {create the cards}
  for i:=1 to 13 do
  begin
    heartinplace[i]:=false;
    spadeset[i]:=TCard.Create(self);
    with spadeset[i] do
    begin
      parent:=self;
      setcard(i,S);
      ondragover:=FormDragover;
      ondragdrop:=FormDragDrop;
      visible:=true;
    end;
    heartset[i]:=TCard.Create(self);
    with heartset[i] do
    begin
      parent:=self;
      setcard(i,H);
      dragmode:=dmautomatic; {allow dragging}
      ondragover:=FormDragover;
      ondragdrop:=FormDragDrop;
      visible:=true;
    end;
    board[i]:=0;
  end;
  {create the solution}
  getnextmove(board,1);
  doublebuffered:=true;
  moveincrement:=4; {start at 4 pixels per step for hint moves}
  resetboard;
end;

{***************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
{Show intro dialog}
begin  introDlg.showmodal;  end;


{******************* FormDragDrop ************}
procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
{Called when a dragged card is dropped}
var i,n:integer;
begin
  If (source is tcard) then
  with source as tcard do
  begin  {should only be a card that is beig dropped}
    if (sender is TCard) and  (Tcard(sender).suit=Spades)
    then
    begin {dropping it on the correct spade}
      if     (board[tcard(sender).value]=0)
         and (issquare(value+Tcard(sender).value)) then
      begin {Trying to drop a heart on an available spade and sum is square}
        top:=TCard(sender).top+20;
        left:=TCard(sender).left;
        bringtofront;
        if heartinplace[value] then
        {we moved from a spade, so we need to find that spot and mark it empty}
        for i:=1 to 13 do if board[i]=value then
        begin
          board[i]:=0;
          break;
        end;
        heartinplace[value]:=true;
        board[tcard(sender).value]:=value;
        n:=0;
        for i:=1 to 13 do if heartinplace[i] then inc(n);
        if n=13 then {all in place - we have a winner!}
        begin
          if globalhint
          then showmessage('Nice job, now can you do it with out hints?')
          else showmessage('You did it! Call Mom and let her know!');
          resetboard;
        end;
      end
      else beep;
    end
    else if (sender is TForm) or (sender is TCard) then
    begin {dropping on form or another heart card}
      if sender is tcard then
      begin  {if on a card, convert coordinates back to form based}
        x:=x+Tcard(sender).left;
        y:=y+Tcard(sender).top;
      end;
      left:=x;
      top:=y;
      heartinplace[value]:=false;
      {we may have moved the card off of a spade,
       if so, we need to update the board array to reflect that}
      for i:=1 to 13 do if board[i]=value then
      begin
        board[i]:=0;
        break;
      end;
    end;
  end;
end;

{***************** HintBtnClick ***************}
procedure TForm1.HintBtnClick(Sender: TObject);
  procedure movecard(c:TCard; topt:TPoint);
  var incr:integer;
  begin
    if topt.x<c.left then {moving left} incr:=-moveincrement
    else incr:=+moveincrement;
    while  abs(c.left-topt.x)>abs(incr) do
    begin c.left:=c.left+incr; c.update; end;
    if topt.y<c.top then {moving up} incr:=-moveincrement
    else incr:=+moveincrement;
    while  abs(c.top-topt.y)>abs(incr)
    do begin c.top:=c.top+incr; c.update; end;
    {put card in exact destination, since incr may not be exact}
    c.left:=topt.x;
    c.top:=topt.y;
    c.update;
  end;

  {------------ MoveHintCard -------------}
  procedure movehintcard(h,s:integer);
  var
    origpoint:Tpoint;
    time:single;
    starttime:TDateTime;
    distance:integer;
  begin
    with heartset[h] do
    begin
      origpoint:=point(left,top);
      starttime:=now;
      distance:=abs(spadeset[s].left-left)+abs(spadeset[s].top-top);
      movecard(heartset[h], point(spadeset[s].left, spadeset[s].top+20));
      time:=secsperday*(now-starttime);
      if (time>0) and (distance>0)
      {adjust so that cards move about 250 pixels/second}
      then moveincrement:=trunc(moveincrement*time*250/distance);
       if moveincrement=0 then moveincrement:=1;
      sleep(1000);  {wait a seccond}
      movecard(heartset[h], origpoint);    {and move it back}
    end;
  end;


var
  i:integer;
  hintgiven:boolean;
begin  {hintbtnclick}
  hintgiven:=false;
  {First, see if there is an unfilled slot with the
   heart card available}
  for i:=1 to 13 do
  begin
    if (board[i] = 0) and (heartinplace[targetboard[i]]=false)
    then
    begin
      movehintcard(targetboard[i],i);
      hintgiven:=true;
      globalhint:=true;
      break;
    end;
  end;
  {if that didn't work, look for an open slot with the card
   already placed incorrectly and move it}
  if not hintgiven then
  for i:=1 to 13 do
  begin
    if board[i] = 0 then
    begin
      movehintcard(targetboard[i],i);
      break;
      globalhint:=true;
    end;
  end;
end;


{***************** FormDragOver ***************}
 procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
 {Let the user try to drop card anywhere - dragdrop may reject the drop later}
 {Alternatively, we could perform drop eligibility tests here and provide
 user with visual feedback, via the dragcursor, about valid drop locations}
begin accept:=true; end;



end.
