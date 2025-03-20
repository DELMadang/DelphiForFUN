unit U_NIM;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{The game of NIM - an introduction to game trees and the minimax solution
 algorithm.

 A brief introduction:

 .  In NIM a number of sticks are laid out on a surface and two players take
 turns removing 1, 2 or 3 sticks at each turn.  The player who takes the
 last stick loses.

 .  A game tree is a representation of the valid "board" configurations for a
 two player, alternating turn game with no board positions repeated.   The root
 of the tree is the original board.  Each node is linked to its "children",
 the valid board configurations that can be reached in a single move.  If we
 call the player who moves first Player A, and the other player, Player B, and
 assign a level number of 1 to the root node and level numbers to a node's
 children that is are greater than its parent, then Player A moves will be from
 an odd numbered level and Player B's will be from even numbered levels.

 Each branch of the tree terminates in a leaf node which has no further moves
 and represents a win for one of the two players or a draw.

 . The Minimax solution algorithm introduces the concept of "value" for a board
 configuration for Player A with higher values representing moves more likely
 top result in a win.  When examining a Player A non-terminal node, values
 are chosen as the maximum value of its children.  When examining a Player B
 non-terminal node we assume that Player B will choose the move which is optimum
 for hin, which is the worst choice for Player A, that is, he will choose the
 child node with minimum value as his next move.

 Applying this algorithm recursively, we can determine the optimum move for
 either player from any starting board.

 Although it is not the case for all games, for NIM we can afford to analyze the
 entire game tree and assign payoff values only for the terminal (leaf) nodes.
 We'll assign +1 if the node represent a winning position for Player A
 (i.e. it's at an even level) and -1 if it is a winning position for Player B
 (an odd level).
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ComCtrls;

type

  TNode= class(TObject)
     Sticks:integer; {how many sticks remain}
     level:integer; {what level are we at}
     highchildindex:integer; {the child number of the best move from this node}
     procedure assign(n:TNode);
  end;

  TForm1 = class(TForm)
    NbrSticks: TSpinEdit;
    Label1: TLabel;
    TakeGrp: TGroupBox;
    H1Takes:   TSpinEdit;
    TakeBtn: TButton;
    Label2:    TLabel;
    PlayList:  TListBox;
    NewGameBtn: TButton;
    SuggestBtn: TButton;
    DebugBox: TListBox;
    Image1: TImage;
    Panel1: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure TakeBtnClick(Sender: TObject);
    procedure NewGameBtnClick(Sender: TObject);
    procedure SuggestBtnClick(Sender: TObject);
  public
    FirstNode:TNode;
    CurrentNode:TNode;
    NextPlayer:char;
    y1,y2,x1,incr:integer;  {stick drawing parameters}
    procedure newgame;
    procedure drawboard;
    function search(B:TNode):integer;
  end;

var
  Form1: TForm1;

implementation

uses UMakeCaption;

{$R *.DFM}

procedure TNode.assign(n:TNode);
begin
  sticks:=n.sticks;
  level:=n.level;
end;

{********************* NewGame ***************}
procedure TForm1.newgame;
{Initialize a new game}
begin
  if assigned(currentnode) then currentnode.free;
  NextPlayer:='1';
  takegrp.caption:='Player '+nextplayer;
  firstnode.sticks:= NbrSticks.value;
  currentnode:=TNode.create;
  CurrentNode.assign(firstnode);

  playlist.clear;
  {$IFDEF DEBUG}
  with debugbox do
  begin
    visible:=true;
    left:=image1.left; top:=image1.top;
    clear;
    items.add('Debug display at exit from recursive Search');
    items.add('L=Level, P=Player Nbr, S=Sticks, V=Value');
    bringtofront;
  end;
  {$ENDIF}

  with image1 do {a simple image of the sticks}
  begin
    if currentnode.sticks>1
    then incr:=8*width div (10* (currentnode.sticks-1)) {distance between sticks}
    else incr:= 0;
    x1:=width div 10;  {1st stick distance from left}
    y1:=height div 10; {stick top end}
    y2:= 9*height div 10; {stick bottom end}
  end;
  drawboard;
  takegrp.visible:=true;
end;


{****************** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
{Initialization stuff}
begin
  firstnode:=TNode.create;
  firstnode.level:=1;
  newgame;
  makecaption('NIM',#169+' 2002, G.  Darby, www.delphiforfun.org', self);
end;

{************** TakeBtnClick ****************}
procedure TForm1.TakeBtnClick(Sender: TObject);
{User says to take some sticks}
begin
  {Make the next board position}
  with currentnode do
  begin
    inc(level);
    if h1takes.value>sticks then h1takes.value:=sticks; {can't take more than remain}
    sticks:=sticks-h1Takes.value;
  end;
  drawboard; {draw it}
  Playlist.items.add('Player '+nextplayer +' takes '+inttostr(h1Takes.value)
                     + ', Remaining: ' +inttostr(currentnode.sticks));
  if currentnode.sticks=0 then
  begin
    showmessage('Player '+nextplayer+' took last stick and loses!');
    takegrp.visible:=false;
  end
  else
  begin
   if nextplayer='1' then nextplayer:='2' else nextplayer:='1';
   takegrp.caption:='Player '+nextplayer;
 end;
end;

{******************** NewGameBtnClick *************}
procedure TForm1.NewGameBtnClick(Sender: TObject);
begin  newgame;  end;

{***************** DrawBoard **********}
procedure TForm1.drawboard;
{draw a simple image of the sticks}
{stick parameters are set in Newgame procedure}
var i:integer;
begin
  with image1, canvas do
  begin
    pen.width:=1;
    pen.color:=clBlack;
    rectangle(clientrect);
    pen.width:=4;
    pen.color:=clblue;
    for i:= 0 to currentnode.sticks-1 do
    begin
       moveto(x1+i*incr,y1);
      lineto(x1+i*incr,y2);
    end;
  end;
end;


{*********************** Search ***********************}
{*************   Tthe meat in this sandwich! **************}
{recursive minimax search of children of passed node to determine node values}
function TForm1.search(B:TNode):integer;
{Evaluates the payoff for node B for  player Player.  Returns the payoff and
 sets property highchildindex in TNode to the index of the highest child }
var
  C:TNode;  {temporary child node}
  value, temp:integer;
  i:integer;
begin
  if b.sticks=0
  then
  begin {computer the payoff of this leaf for player 1}
    if  b.level mod 2 =1 {player 1's turn}
    then  result:=+1  {and no sticks left, that's good}
    else {player2 level} result:=-1 {that's bad}
  end
  else
  begin
    {initialize minimum or maximum value for children}
    if b.level mod 2 =1 {player1} then value:=-1000000 else value:=1000000;
    c:=TNode.create;  {make a child}
    c.level:=b.level+1;
    for i:= 1 to 3 do
    begin
      c.sticks:=B.sticks-i;
      if c.sticks>=0 then {search until all sticks are gone}
      if b.level mod 2 =1 {player1} then
      begin  {find the max value of children}
        temp:=search(C);  {recursive call for 2's turn}
        if temp>value then
        begin
          value:=temp;
          b.highchildindex:=i;
        end;
      end
      else
      begin  {player 2, find min value of children}
        temp:=search(C); {recusive call for player 1's turn}
        if temp<value then
        begin
           value:=temp;
           b.highchildindex:=i;
        end;
      end;
    end;
    c.free;
    result:=value;
  end;
  {$IFDEF debug}
  Debugbox.items.add(stringofchar('_',offset)
                    + 'L:'+ inttostr(b.level)
                    + ', P:'+ inttostr(2- b.level mod 2)
                    + ', S:'+ inttostr(b.sticks)
                    + ', V:' + inttostr(result));
  {$ENDIF}
end;

{******************* SuggestBtnClick *************}
procedure TForm1.SuggestBtnClick(Sender: TObject);
var
  bestindex:integer;
  stickword:string;
begin
   search(currentnode);
   bestindex:=currentnode.highchildindex;
   stickword:=' stick';
   if bestindex>1 then stickword:=stickword+'s';
   PlayList.items.add('For Player '+nextplayer+': I suggest taking '
   + inttostr(bestindex) +stickword);
   h1takes.value:=bestindex; {make suggestion the default amount for next move}
end;

end.

