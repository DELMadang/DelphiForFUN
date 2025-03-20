unit U_FourInARow1;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Version one of the Four-in-a-row (also called Connect4) game.  This version
  allow human vs human play}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

const
  {some fixed constants}
  nbrcols=7; {# of columns on the board}
  nbrrows=6; {# of rows on the board}
  sidewidth:integer=10; {pixel width of row dividers}
  player1color:TColor=clred;  {Player 1's chip colors}
  player2color:TColor=clyellow;  {Player 2's chip colors}
  boardcolor:TColor=clblue;   {Row divider color}
  lookahead:integer=4;  {Levels to look ahead when scoring}
  {User instruction messages}
  player1Lbl:string='Player 1:  Drag the red token over the selected column and release';
  player2Lbl:string='Player 2:  Drag the yellow token over the selected column and release';
type

  TForm1 = class(TForm)
    ResetBtn: TButton;
    Panel1: TPanel;
    Image1: TImage;
    NewChip: TShape;
    MoveLbl: TLabel;
    RandomBtn: TButton;
    Memo1: TMemo;
    RetractBtn: TButton;
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TokenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TokenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TokenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RandomBtnClick(Sender: TObject);
    procedure RetractBtnClick(Sender: TObject);
  public
    board:array [1..nbrcols, 1..nbrrows]of integer; {the playing board,
                                     0      ==> empty
                                     1 or 2 ==> # of player whose chip is here}
    moves:array[1..nbrcols*nbrrows] of TPoint; {record of moves in this game}
    player1:boolean; {True if current player is plaer #1, false otherwise}
    chipwidth:integer; {pixel width of token}
    Dragchip:boolean;  {true ==> chip is being dragged}
    movecount:integer;  {total moves in this game}
    gameover:boolean;  {true ==> game is over}
    procedure initialize;
    Procedure DrawChip(x:integer);
    procedure DropChip(x:integer);
    function FourInARow(col,row:integer):boolean;  {check for winning condition}
    function match(col,row,dc,dr:integer):integer;  {count matching tokens in
                                                     a specified directon}
    procedure changeplayers;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses UMakeCaption;


{************** Initialize *********}
procedure tform1.initialize;
{set up a new game }

       {local procedure DrawNewBoard}
       procedure DrawNewBoard;
      {Draw a clear board}
      var
        i,hinc:integer;
      begin
        with image1, canvas do
        begin
          chipwidth:=(panel1.width-(nbrcols+1)*sidewidth) div nbrcols;
          panel1.width:=nbrcols*(chipwidth+sidewidth)+sidewidth+2; {round width down}
          panel1.height:=(nbrrows+1)*chipwidth+sidewidth+2;  {and adjust the height}
          {Image is alligned to planel1, so it's size adjusts automatically}
          picture.bitmap.width:=width; {must set the new size for the drawing canvas}
          picture.bitmap.height:=height;
          brush.color:=clwindow;
          fillrect(clientrect);
          brush.color:=boardcolor; pen.color:=boardcolor;
          rectangle(rect(0,height-sidewidth,width,height)); {bottom bar}
          hinc:=(width-10) div nbrcols;
          for i:= 0 to nbrcols do rectangle(rect(i*hinc,chipwidth, {vertical bars}
                                            i*hinc+sidewidth,height-sidewidth));
        end;
        newchip.width:=chipwidth;
        newchip.height:=chipwidth;
        drawchip(chipwidth div 2);

       end;{Drawnewboard}

var i,j:integer;
begin
  for i:=1 to nbrcols do  for j:=1 to nbrrows do  board[i,j]:=0;
  movecount:=0;
  player1:=false;
  changeplayers; {set up initial player as player1}
  drawnewboard;
  tag:=1;
  gameover:=false;

end;

{**************** ResetBtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin initialize; end;

{***************** RetractBtnClick ***********}
procedure TForm1.RetractBtnClick(Sender: TObject);
var
  h,v:integer;
begin
  if movecount>0 then
  begin

    with image1.canvas, moves[movecount]  do
    begin
      board[x,y]:=0;
      brush.color:=clwindow;
      h:=sidewidth+(x-1)*(chipwidth+sidewidth);
      v:=y*chipwidth;
      fillrect(rect(h,v, h+chipwidth, v+chipwidth));
    end;
    dec(movecount);
    changeplayers;
    drawchip(chipwidth div 2);
  end;
end;


{******************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  makecaption('Fout In A Row #1',
            #169+' 2002, G. Darby, http://delphiforfun.org',self);
  Initialize;
  panel1.DoubleBuffered:=true;
  randomize;
end;

{************* ChangePlayers **********}
procedure TForm1.Changeplayers;
begin
  newchip.top:=0;
  player1:=not player1;
  if player1 then
  begin
    newchip.brush.color:=player1color;
    movelbl.caption:=Player1Lbl;
  end
  else
  begin
    newchip.brush.color:=player2color;
    movelbl.caption:=Player2Lbl;
  end;
end;


{************** DrawChip ***********}
procedure TForm1.drawchip(x:integer);
begin
  newchip.left:=x-chipwidth div 2;
  newchip.visible:=true;
end;

{********************** Match ******************}
function TForm1.match(col,row,dc,dr:integer):integer;
{Count how many match passed position moving in direction (dc,dr)}
var c,r,count, checkplayer:integer;
begin
  checkplayer:=board[col,row];
  c:=col+dc;
  r:=row+dr;
  count:=0;
  while (c>=1) and (c<=nbrcols) and (r>=1) and (r<=nbrrows) and
         (board[c,r]=checkplayer) do
  begin
    inc(c,dc); inc(r,dr);
    inc(count);
  end;
  result:=count;
end;


{********************** FourInARow *****************}
function TForm1.FourInARow(col,row:integer):boolean;
{Chck for 4 tokens in a row}
var  n:integer;
begin
  n:=1+match(col,row,-1,0)+match(col,row,+1,0);
  if n<4 then n:=1+match(col,row,0,-1)+match(col,row,0,+1);
  if n<4 then n:=1+match(col,row,-1,-1)+match(col,row,+1,+1);
  if n<4 then n:=1+match(col,row,-1,+1)+match(col,row,+1,-1);
  if n>=4 then result:=true else result:=false;
end;


{************** DropChip *************}
procedure TForm1.dropchip(x:integer);
var
  col, row, i:integer;
  msg:string;
begin
  col:=x div(chipwidth+sidewidth)+1 ;
  newchip.left:=sidewidth+(col-1)*(chipwidth+sidewidth);
  row:=1;
  while (row<=nbrrows) and (board[col,row]=0)
  do inc(row);
  if row=1 then exit; {column is full}
  dec(row);
  with newchip do
  for i:=1 to row+1 do
  begin
    top:=(i-1)*chipwidth;
    update; {show new image}
    sleep(100);
  end;
  if player1 then board[col,row]:=1
  else board[col,row]:=2;
  with image1.canvas do
  begin
    brush.color:=newchip.brush.color;
    with newchip do ellipse(left,top, left+width, top+height);
  end;
  inc(movecount);
  moves[movecount]:=point(col,row); {In case we want to allow retraction or replay later}
  if (movecount=nbrcols*nbrrows) or fourinarow(col,row) then
  begin
    if fourinarow(col,row) then
      if player1 then msg:='Player 1 is the winner!'
      else msg:='Player 2 is the winner!'
    else msg:='A draw!';
    Gameover:=true;
    newchip.visible:=false;
    Movelbl.caption:=msg+ ', Click "Reset" to start a new game';
  end;
end;

{********************** TokenMouseDown *****************}
procedure TForm1.TokenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if gameover then exit;
  DragChip:=true;
  newchip.top:=0;
  drawchip(newchip.left+x);
end;

{*********************** TokenMouseMove ****************}
procedure TForm1.TokenMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if dragchip
  then drawchip(newchip.left+x);
end;

{******************** TakenMouseUp *****************}
procedure TForm1.TokenMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if board[(newchip.left+x) div (chipwidth+sidewidth)+1,1]<>0 then
  begin
    newchip.left:=0;
    exit;
  end;
  dropchip(newchip.left+x);
  dragchip:=false;
  if not gameover then
  begin
    changeplayers;
    drawchip(chipwidth div 2);
  end
  else
  begin {This is the changeplayer procedure without overriding the winner msg}
    {Necessary  to keep player info in proper synch in case the user retracts
      moves after the game is over}
    newchip.top:=0;
    player1:=not player1;
    if player1 then newchip.brush.color:=player1color
    else newchip.brush.color:=player2color;
  end;


end;


{************** RandomBtnClick ***************}
procedure TForm1.RandomBtnClick(Sender: TObject);
var
  col,i:integer;
  x:integer;
  halfC:integer;
begin
  initialize;
  halfc:=chipwidth div 2;
  tag:=0;
  while (tag=0) and (not gameover) do
  begin
    col:=random(nbrcols);
    x:=halfC;
    Tokenmousedown(sender, mbLeft, [], x,0);
    for i:= 0 to col*(chipwidth+sidewidth) div 10 do
    begin
      tokenMouseMove(sender,[],HalfC+10,0);
      newchip.update;
      sleep(10);
    end;
    tokenMouseup(sender,mbleft,[],HalfC,0);
    application.processmessages;
    sleep(250);
  end;
end;



end.
