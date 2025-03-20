unit U_FourInARow2C;
{Copyright  © 2002-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Version 3 adds Minimax solution capabilities to version 1 -
 a minimax procedure with alpha-beta pruning is also included.
 Also board size and winning line count can be changed by user}

interface

{***$DEFINE DEBUG}  {remove *** to define DEBUG and generate debug code}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Comctrls, Spin, ShellAPI, jpeg;

var
  nbrcols : integer=7;
  nbrrows:integer=6;
  winnbr:integer=4;
  sidewidth:integer=10;
  nbrplayers:integer;
  Playercolor:array[1..3] of TColor= (clred, clyellow, clgreen);
  PlayerLbl:array[1..3] of string=
          ('Player 1:  Drag the red token over the selected column and release',
           'Player 2:  Drag the yellow token over the selected column and release',
           'Player 3:  Drag the green token over the selected column and release'
           );
  boardcolor:TColor=clblue;
  LookAheads: array [1..3] of integer=(4,4,4);


const
  winnerval=+100000;

type
  TPlayerGenus=(Human, Computer);
  TRows=array of integer;
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    BoardImage: TImage;
    Label1: TLabel;
    IntroPanel: TPanel;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    MoveLbl: TLabel;
    Panel1: TPanel;
    Image1: TImage;
    NewChip: TShape;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    OpponentGrp: TRadioGroup;
    IQGrp1: TRadioGroup;
    IQGrp2: TRadioGroup;
    StaticText2: TStaticText;
    IQGrp3: TRadioGroup;
    MaxsecsSpin: TSpinEdit;
    StopBtn: TButton;
    ResetBtn: TButton;
    SuggestBtn: TButton;
    RetractBtn: TButton;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    ColsEdit: TSpinEdit;
    RowsEdit: TSpinEdit;
    WinEdit: TSpinEdit;
    ABPruneBox: TCheckBox;
    ShowDebugBtn: TButton;
    Timer1: TTimer;
    StaticText3: TStaticText;
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure TokenMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TokenMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TokenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SuggestBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StopBtnClick(Sender: TObject);
    procedure RetractBtnClick(Sender: TObject);
    procedure IQGrpClick(Sender: TObject);
    procedure OpponentGrpClick(Sender: TObject);
    procedure ColsEditChange(Sender: TObject);
    procedure RowsEditChange(Sender: TObject);
    procedure WinEditChange(Sender: TObject);
    procedure DebugBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    //procedure ShowDebugBtnClick(Sender: TObject);
    procedure MaxsecsSpinChange(Sender: TObject);
    {procedure NbrPlayersGrpClick(Sender: TObject);}
  public
    { Public declarations }

    board:array of array of integer; {the playing board, colums by rows,
                                     each cell contains 0:empty,
                                     1:Player A, 2:Player B}
    openrows:TRows; {global array of lowest open row for each board column}
    moves:array of TPoint;
    CurrentPlayer:byte;
    chipwidth:integer;
    Dragchip:boolean;
    remember:integer;  {array of best column moves to make,
                                           set by minimax score function, ties
                                           for best scoree all entered and one
                                           selected randomly}
    movecount, totmoves:integer;  {current and max move counts}
    gameover:boolean;
    thinking:boolean; {true while evaluating positions - mousedown ignores
                       attempts to drag tokens around while we're thinking}
    lookahead:integer;  {# of moves to lookahead for current player}
    origwidth, origheight: integer; {Original board height and width, used
                                     when board column or row conuts change}
    maxmoves:array[1..3] of integer; {# of random moves at start of game for each
                                      player based on IQ}
    runtime:integer;  {think time in seconds incremented by a timer while MinMax
                       procedures are running - to exit MonMax if limit exceeded}
    maxsecs:integer;  {maximum think time in seconds per computer move}

    procedure initialize;
    Procedure DrawChip(x:integer);
    procedure DropChip(x:integer);

    function FourInARow(col,row:integer):boolean;
    procedure changeplayers;
    function score(player:integer):integer;
    function Minimax(player, searchlevel:integer;
                     {$IFDEF DEBUG} Node:TTReeNode; {$ENDIF}
                                    lastmove:TPoint):integer;
    function MinimaxAB(player, searchlevel:integer; Alpha,beta:integer;
                     {$IFDEF DEBUG} Node:TTReeNode; {$ENDIF}
                                    lastmove:TPoint):integer;
    procedure Movetocol(col:integer);
    function SetIQ(n:integer):integer;
    procedure computermove;
    procedure suggestmove;
    function MaxRandomMoves:integer;
  end;

var   Form1: TForm1;

implementation

{$R *.DFM}
Uses U_FourInARowDebug;

var
  sevencols:array[0..6] of integer=(3,2,4,1,5,0,6);
  fourcols:array[0..3] of integer=(2,1,3,0);
  trycols:array of integer;

 {***************  SetIQ **************}
   function TForm1.SetIQ(n:integer):integer;
   begin
     case n of
       0: result:=3;
       1: result:=4;
       2: result:=6;
       3: result:=8;
       4: result:={9}10;
       5: result:={10}12;  {12 probably too many for current implementation}
       else result:=4;
     end;
   end;

{************** Initialize *********}
procedure TForm1.initialize;
{set up a new game }

       {local procedure DrawNewBoard}
       procedure DrawNewBoard;
      {Draw a clear board}
      var
        i,hinc:integer;
        c1,c2:integer;
      begin
        with image1, canvas do
        begin
          panel1.width:=origwidth;
          panel1.height:=origheight;
          c1:=(panel1.width-(nbrcols+1)*sidewidth) div nbrcols;
          c2:=(panel1.height-sidewidth) div (nbrrows+1);
          if c1>c2 then chipwidth:=c2 else chipwidth:=c1;
          panel1.width:=nbrcols*(chipwidth+sidewidth)+sidewidth+2; {round width down}
          panel1.height:=(nbrrows+1)*chipwidth+sidewidth+2;

          picture.bitmap.width:=width;
          picture.bitmap.height:=height;
          brush.color:=clwindow;
          fillrect(clientrect);
          brush.color:=boardcolor; pen.color:=boardcolor;
          rectangle(rect(0,height-sidewidth,width,height));
          hinc:=(width-10) div nbrcols;
          for i:= 0 to nbrcols do rectangle(rect(i*hinc,chipwidth,
                                            i*hinc+sidewidth,height-sidewidth));
        end;


        newchip.width:=chipwidth;
        newchip.height:=chipwidth;
        CurrentPlayer:=nbrplayers; {So changeplayers call can switch it back to 1}
        changeplayers;
        drawchip(chipwidth div 2);
       end;{Drawnewboard}

var i,j:integer;
begin
  {listbox1.Clear; }
  setlength(board,nbrcols,nbrrows);
  setlength(moves,nbrcols*nbrrows+1);
  setlength(trycols,nbrcols);
  totmoves:=nbrcols*nbrrows;

  for i:=0 to nbrcols-1 do for j:=0 to nbrrows-1 do  board[i,j]:=0;

  movecount:=0;
  gameover:=false;
  thinking:=false;
  tag:=0;

  drawnewboard;

  if opponentgrp.itemindex<0
  then movelbl.caption:='To start, select opponents (Human or Computer) by clicking a button in the  box at right';

  Lookaheads[1]:=SetIQ(IQGrp1.itemindex);
  Lookaheads[2]:=SetIQ(IQGrp2.itemindex);
  maxmoves[1]:=IQGrp1.items.count-Iqgrp1.itemindex-1;
  maxmoves[2]:=IQGrp2.items.count-IQGrp2.itemindex-1;
  maxmoves[3]:=IQGrp3.items.count-IQGrp3.itemindex-1;

  maxsecs:=maxsecsSpin.value;
   {windeit random moves at start of game might let opponent win easily!}
  for i:=1 to 3 do if maxmoves[i]>=winedit.value then maxmoves[i]:=winedit.value-1;
  {optional - try columns fron center outward for 4 or 7 column game}
  if nbrcols= 7 then for i:=0 to nbrcols-1 do trycols[i]:=sevencols[i]
  else if nbrcols= 4 then for i:=0 to nbrcols-1 do trycols[i]:=fourcols[i]
  else for i:=0 to nbrcols-1 do trycols[i]:=i;
end;

{******************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  origwidth:=panel1.width;
  origheight:=panel1.height;
  Initialize;
  panel1.DoubleBuffered:=true;
  randomize;
  {$IFDEF DEBUG} showdebugbtn.visible:=true;  {$ENDIF}
  //IntroDlg.showmodal;
end;

{************* ChangePlayers **********}
procedure TForm1.Changeplayers;
begin
  newchip.top:=0;
  inc(currentplayer);
  If currentplayer> nbrplayers then currentplayer:=1;
  newchip.brush.color:=Playercolor[currentplayer];;
  if (not gameover) then movelbl.caption:=PlayerLbl[currentplayer];
end;

{************** DrawChip ***********}
procedure TForm1.drawchip(x:integer);
begin
  newchip.left:=x-chipwidth div 2;
  newchip.visible:=true;
end;

{********************** FourInARow *****************}
function TForm1.FourInARow(col,row:integer):boolean;
{Check for "winnbr" tokens in a row, return true if so}

    {Local function  ***** Match ******************}
    function match(col,row,dc,dr:integer; var checkplayer:integer):integer;
    {Count how many tokens match the passed position moving in direction (dc,dr)}
    var c,r,count:integer;
    begin
      checkplayer:=board[col,row];
      c:=col+dc;
      r:=row+dr;
      count:=1;
      while (c>=0) and (c<=nbrcols-1) and (r>=0) and (r<=nbrrows-1) and
             (board[c,r]=checkplayer) do
      begin
         if (checkplayer=0) and (board[c,r]<>0) then checkplayer:=board[c,r];
        inc(c,dc); inc(r,dr);
        inc(count);
      end;
      result:=count;
    end; {match}

var  n:integer;
     player:integer;
begin {FourInaRow}
  result:=false;
  player:=board[col,row];
  if player=0 then exit;
  n:=match(col,row,-1,0,player)+match(col,row,+1,0,player)-1;
  if n<winnbr then n:=match(col,row,0,-1,player)+match(col,row,0,+1,player)-1;
  if n<winnbr then n:=match(col,row,-1,-1,player)+match(col,row,+1,+1,player)-1;
  if n<winnbr then n:=match(col,row,-1,+1,player)+match(col,row,+1,-1,player)-1;
  if n>=winnbr then result:=true;
end;

{************** DropChip *************}
procedure TForm1.dropchip(x:integer);
{move the newchip into it's final resting place at the bottom of a column}
var
  col, row, i:integer;
  msg, id:string;
begin
  col:=x div(chipwidth+sidewidth) ;
  newchip.left:=sidewidth+(col)*(chipwidth+sidewidth);
  row:=0;
  while (row<nbrrows) and (board[col,row]=0)
  do inc(row);
  if row=0 then exit; {sorry, this column is full}
  dec(row);
  with newchip do
  for i:=1 to row+1 do
  begin
    top:=i*chipwidth;
    update; {show new image}
    sleep(100);
  end;
  board[col,row]:=currentplayer;
  with image1.canvas do
  begin
    brush.color:=newchip.brush.color;
    with newchip do ellipse(left,top, left+width, top+height);
  end;
  inc(movecount);
  moves[movecount]:=point(col,row);
  if (movecount=nbrcols*nbrrows) or fourinarow(col,row) then
  begin
    if fourinarow(col,row) then
    begin
    with opponentgrp do
    if ((currentplayer=1) and ((itemindex =2) or (itemindex =3)))
    or ((currentplayer=2) and ((itemindex =1) or (itemindex=3)))
    then id:=' (Computer) ' else id:= ' (Human) ';
      if CurrentPlayer=1 then msg:='Player 1'+id+'is the winner'
      else if CurrentPlayer=2 then msg:='Player 2'+id+'is the winner'
      else msg:='Player 3'+id+'is the winner';
    end
    else msg:='A draw!';
    Gameover:=true;
    newchip.visible:=false;
    Movelbl.caption:=format('%s in %d moves! Click "Reset" to start a new game',[msg,movecount]);
  end;
end;



{***************** MoveToCol ***********}
procedure TForm1.Movetocol(col:integer);
{Simulate dragging token to a specific column}
var  i:integer;
     halfc:integer;
begin
  dragchip:=true;
  halfc:=chipwidth div 2;
  for i:= 0 to col*(chipwidth+sidewidth) div 10 do
  begin
    tokenMouseMove(self,[],HalfC+10,0); {simulate drag 10 pixels right}
    newchip.update;
    sleep(10);
  end;
  dragchip:=false;
end;

{******************* FormCloseQuery ***************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Stop any solving and let application close}
begin
  tag:=1;
  canclose:=true;
end;

{******************* Score ***************}
function Tform1.score(player:integer) : longint;
{Return a score for "player" for current board}

    {Local procedure ------ Count ---------}
    function count(player:integer; i,j,di,dj : longint) : longint;
    var c : longint;
    begin
      c := 0;
      while (i<nbrcols) and (j<nbrrows)and
            (i>=0) and (j>=0) and (board[i,j]=player) and (c <winnbr) do
      begin
        i := i+di;
        j := j+dj;
        inc(c);
      end;
      if c = winnbr then count := winnerval else
      count := c;
    end;

    {Local procedure --------- Sum ------------}
    function Sum(player:integer):longint;
    {count tokens in a row for this player}
    var i,j : longint;
        total : longint;
    begin  {sum}
      total := 0;
      for i := 0 to nbrcols-1 do
      for j := 0 to nbrrows-1 do
      if board[i,j] = player then
      begin
        total := total +   {Check 4 directions:}
             count(player, i,j,0,1) +
             count(player, i,j,1,0) +
             count(player, i,j,1,1) +
             count(player, i,j,1,-1);
        if total > winnerval then break;
      end;
      result := total;
    end; {sum}

var s:integer;
begin {score}
  s := sum(player mod 2 +1); {get sum for other player}
  if s  >= winnerval then result := -winnerval  {next guys wins, make score a large
                                               negative for us}
  else result := sum(player)-s;  {otherwise:  our score minus his score}
end; {score}


{************************ Minimax ******************}
function tform1.Minimax(player, searchlevel:integer;
                        {$IFDEF DEBUG} Node:TTreeNode; {$ENDIF}
                        lastmove:TPoint):integer;
{Evaluates the payoff for player Player.  Returns the payoff and
      and sets the column in global field "remember" for level 1 caller}

var
  value, temp:integer;
  i:integer;
  {$IFDEF DEBUG} newnode:TTreeNode; {$ENDIF}
  c,r:integer;
  first:boolean;
  win:boolean;
begin
  application.ProcessMessages;
  if (tag=1) or (not thinking)  then begin result:=0; exit; end; {user wants to stop}

  win:=FourInARow(lastmove.x, lastmove.y);
  if (searchlevel>=lookahead) or win or (movecount=totmoves){boardfull}
     or (runtime>maxsecs) {run time exceeded}
  then
  begin {compute the payoff of this leaf}
    if searchlevel=1 then remember:=lastmove.x;
    if win then result:=-(winnerval-searchlevel){last move was a win for the
                                                 other guy, we get a large negative}
    else result:=-score(player)+searchlevel;
    {$IFDEF DEBUG} debug.treeview1.items.addchild(node,'Last Level:'
                    +inttostr(searchlevel) +' Score: '+inttostr(result));
    {$ENDIF}
  end
  else
  begin
    first:=true;  {first time through switch}
    value:=winnerval;
    for i := 0 to nbrcols-1 do
    begin
      c:=trycols[i];    {maybe trying columns from center toward edges
                          rather than left to right}
      if (openrows[c] >=0) and (tag=0) then {there is an open row in this column
                                             and stop flag is not set}
      begin
        {make a trial move to evaluate its value}
        r:=openrows[c];
        board[c,r] := player;
        dec(openrows[c]); {one less row now available in this column}

        {$IFDEF DEBUG} newnode:=debug.treeview1.items.addchild(node,'Level:'
                       +inttostr(searchlevel)+', Col:'+inttostr(c+1));
        {$ENDIF}
        //begin
        {Knuth's "Negmax" minimax variation changes sign at each level}
        temp:= -Minimax(player mod 2+1, searchlevel+1,
                     {$IFDEF DEBUG} newnode, {$ENDIF} point(c,r));
        if first then
        begin
          value:=temp;
          first:=false;
          {$IFDEF DEBUG} newnode.text:=newnode.text+ ', Score:'+inttostr(temp)
                              + ', New MinMax:'+inttostr(value);
          {$ENDIF}
          if searchlevel=1 then remember:=c;
          (*
          application.processmessages;
           if tag=1  then begin break{result:=value; exit;} end; {user wants to stop}
          *)
        end
        else
        if value<temp then
        begin
          value:=temp;
          if searchlevel=1 then remember:=c;
          {$IFDEF DEBUG}newnode.text:=newnode.text+ ', Score:'+inttostr(temp)
                                 + ', MinMax:'+inttostr(value);
          {$ENDIF}
        end;
        {$IFDEF DEBUG}else newnode.text:=newnode.text+ ', Score:'+inttostr(temp)
                               + ', MinMax: No change';;
        {$ENDIF}
        //end;

        inc(openrows[c]); {and mark the row as available again}
        board[c,openrows[c]] := 0; {retract the move}
      end;
    end;
    result:=value;
  end;
end;


{************************ MinimaxAB **************}
function tform1.MinimaxAB(player, searchlevel:integer; alpha, beta:integer;
                        {$IFDEF DEBUG} Node:TTreeNode; {$ENDIF}
                        lastmove:TPoint):integer;
{Evaluates the payoff for "Player" using alpha-beta pruning. Returns the payoff and
 and sets the column in global field "remember" for level 1 caller}

var
  temp:integer;
  i:integer;
  {$IFDEF DEBUG} newnode:TTreeNode; {$ENDIF}
  c,r:integer;
  first:boolean;
  win:boolean;
begin
  application.processmessages; {check for stop flag}
  if tag=1 then begin result:=0; exit; end; {user wants to stop}
  win:=FourInARow(lastmove.x, lastmove.y);   {winning position?}
  if (searchlevel>=lookahead) or win or (movecount=totmoves){boardfull}
  or (runtime>maxsecs) {max run time exceeded}
  then
  begin {compute the payoff of this leaf}
    if searchlevel=1 then remember:=lastmove.x;
    if win then result:=-(winnerval-searchlevel) {win for other guy, so a loss for us}
    else result:=-(score(player)-searchlevel); {reduce scores by level so
                                  for example, immediate win give higher score
                                  than a loss on the next move}
    {$IFDEF DEBUG} debug.treeview1.items.addchild(node,'Leaf:'
                    +inttostr(searchlevel) +' Score: '+inttostr(result));
    {$ENDIF}
  end
  else
  begin
    first:=true;  {first time through switch}
    for i := 0 to nbrcols-1 do
    begin
      c:=trycols[i]; {may be trying columns from center toward edges
                      rather than left to right}
      {change to c:=i to search columns in order left to right}
      if (openrows[c] >=0) and (tag=0) then {there is an open row in this column
                                             and stop flag is not set}
      begin
        {make a trial move to evaluate its value}
        r:=openrows[c];
        board[c,r] := player;
        dec(openrows[c]); {one less row now available in this column}

        {$IFDEF DEBUG} newnode:=debug.treeview1.items.addchild(node,'Level:'
                       +inttostr(searchlevel)+', Col:'+inttostr(c+1));
        {$ENDIF}

        {Knuth's "Negmax" minimax variation changes sign at each level, alpha
         and beta swap roles at each level}
        temp:= -MinimaxAB(player mod 2+1, searchlevel+1, -beta, -alpha,
                   {$IFDEF DEBUG} newnode, {$ENDIF} point(c,r));
        if first then
        begin
          alpha:=temp;
          first:=false;
          {$IFDEF DEBUG} newnode.text:=newnode.text+ ', Score:'+inttostr(temp)
                              + ', New MinMax:'+inttostr(alpha);
          {$ENDIF}
          if searchlevel=1 then remember:=c;
        end
        else
        if temp>alpha then
        begin
          alpha:=temp;
          if searchlevel=1 then remember:=c;
          {$IFDEF DEBUG}newnode.text:=newnode.text+ ', Score:'+inttostr(temp)
                                 + ', MinMax:'+inttostr(alpha);
          {$ENDIF}
        end
        {$IFDEF DEBUG}else newnode.text:=newnode.text+ ', Score:'+inttostr(temp)
                               + ', MinMax: No change';
        {$ELSE} ;
        {$ENDIF}
        {Retract the move}
        inc(openrows[c]); {and mark the row as available again}
        board[c,openrows[c]] := 0;

        if alpha>=beta then
        begin
          {$IFDEF DEBUG} newnode.text:=newnode.text+ ', Pruned: A='+
                         inttostr(alpha) + ', B='+inttostr(beta);
          {$ENDIF}
          break;
        end;
      end;
    end;
    result:=alpha;
  end;
end;

function  TForm1.MaxRandomMoves:integer;
{Return the number of random moves that the current player will make at the
 start of a game - more random moves for dumber players}
 {Implement to keep computer games from being exactly repeatable}
 begin
   result:=maxmoves[currentplayer];
 end;

{***************** ComputerMove ***********}
procedure tform1.computermove;
{Program finds a move and does it}
var  halfc:integer;
begin
  movelbl.caption:='Thinking...'+inttostr(runtime);
  movelbl.caption:='Thinking... 0';
  halfc:=chipwidth div 2;
  thinking:=true;
  suggestmove;
  if (tag=0) and thinking then
  begin
    movelbl.caption:='Moving...';
    movelbl.update;
    Tokenmousedown(image1, mbLeft, [], halfc,0); {simulate mousedown}
    tokenMouseup(image1,mbleft,[],halfC,0); {drop token}
    application.processmessages;
  end;
  thinking:=false;
end;

{***************** SuggestMove *************}
procedure TForm1.suggestmove;
{Use minimax procedure to get a suggested next move.
 Called by SuggestBtnClick and by Computermove procedures}
var
  i,j,m:integer;
  {$IFDEF DEBUG}node:TTreenode;{$ENDIF}
begin
  with opponentgrp do if itemindex<0 then itemindex:=0;
  setlength(openrows,nbrcols);
  if gameover then initialize;
  tag:=0;  {reset stopflag}
  {$IFDEF DEBUG}
  with debug do treeview1.items.clear;
  {$ENDIF}
  screen.cursor:=crhourglass;
  drawchip(chipwidth div 2); {reset the token image}
  for i:=0 to nbrcols-1 do
  begin
    openrows[i]:=-1;
    for j:=nbrrows-1 downto 0 do if board[i,j]=0 then
    begin
      openrows[i]:=j;
      break;
    end;
  end;
  {$IFDEF DEBUG} node:=debug.Treeview1.items.add(nil,'Game Tree Root'); {$ENDIF}

  lookahead:=lookaheads[currentplayer];
  m:=maxrandomMoves;
  if m<2 then m:=2;
  if (movecount +1) div nbrplayers < m then
  begin
    thinking:=true;
    remember:=random(nbrcols);
    {debug code}{listbox1.items.add('#'+inttostr(movecount)+', P='+inttostr(currentplayer)
         +', m='+inttostr(m)+',col='+inttostr(remember+1));  }
  end
  else
  begin
    runtime:=0;
    timer1.Enabled:=true;
    if abprunebox.checked
    then Minimaxab(currentPlayer,1,-maxint, maxint,
              {$IFDEF DEBUG} node, {$ENDIF} point(0,0))
    else Minimax(currentPlayer,1,{$IFDEF DEBUG} node, {$ENDIF} point(0,0));
    timer1.enabled:=false;
  end;
  if (tag=0) and (thinking)  then movetocol(remember);
  screen.cursor:=crdefault;
end;


{*********************************************}
{              Button Click Procedures        }
{*********************************************}


{*************** SuggestBtnClick ****************}
procedure TForm1.SuggestBtnClick(Sender: TObject);
begin
  If thinking then exit;
  thinking:=true;
  suggestmove;
  thinking:=false;
end;


{**************** ResetBtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  stopbtnclick(sender);
  opponentgrpclick(sender); {initialize and set uop ot make 1st move}
end;

{***************** StopBtnClick ***********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
  movelbl.caption:='Stopped.  Press reset to start a new game';
end;

{******************* RetractBtnClick ************}
procedure TForm1.RetractBtnClick(Sender: TObject);
{Take a move  back}
var  L,T:integer;
begin
  if thinking then exit;
  If movecount>0 then
  begin
    with moves[movecount], image1.canvas do
    begin
      board[x,y]:=0;
      brush.color:=clwindow;
      L:=sidewidth+(x)*(chipwidth+sidewidth);
      T:=chipwidth*(y+1);
      fillrect(rect(L,T,L+chipwidth,T+chipwidth));
    end;
    drawchip(chipwidth div 2); {redraw the token image}
    dec(movecount);
    gameover:=false; {in case there was a winner, not any more}
    changeplayers;
  end;
end;

{************** DebugBtnClick *************}
procedure TForm1.DebugBtnClick(Sender: TObject);
begin   Debug.showmodal; end;

{***************** LeftIQBtnClick *************}
procedure TForm1.IQGrpClick(Sender: TObject);
{User set player IQ }
begin
  if sender=IqGrp1 then lookaheads[1]:=Setiq(IQGrp1.itemindex)
  else if sender=IQGrp2 then lookaheads[2]:=Setiq(IQGrp2.itemindex)
  else if sender=IQGrp3 then lookaheads[3]:=Setiq(IQGrp3.itemindex);

end;

{***************** OpponentGrpClick ***************}
procedure TForm1.OpponentGrpClick(Sender: TObject);
{User selected opponents}
var i:integer;
begin
  if opponentgrp.itemindex>=0 then {ignore the  reset case (index=-1)}
  with opponentgrp do
  begin
    i:=itemindex;
    if i=4 then
    begin
      nbrplayers:=3;
      IQgrp1.visible:=false;
      IQgrp2.visible:=false;
      SuggestBtn.enabled:=false;
    end
    else
    begin
       nbrplayers:=2;
       IQgrp3.visible:=false;
       suggestbtn.enabled:=true;
    end;
    initialize;
    If (opponentgrp.itemindex=2) or (opponentgrp.itemindex=3) then computermove; {computer plays first}
  end;
end;

{************ ColsEditChange ***************}
procedure TForm1.ColsEditChange(Sender: TObject);
{User resizing board}
begin
  nbrcols:=colsedit.value;
  initialize;
end;

{*************** RowsEditChange ********}
procedure TForm1.RowsEditChange(Sender: TObject);
{User resizing board}
begin
  nbrrows:=rowsedit.Value;
  initialize
end;

{************** inEditChange *************}
procedure TForm1.WinEditChange(Sender: TObject);
{User changed number to line up to win}
begin
   winnbr:=winedit.value;
   initialize;
end;

{********************** TokenMouseDown *****************}
procedure TForm1.TokenMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Get ready to drag a chip}
begin
  if gameover or thinking then exit;
  DragChip:=true;
  newchip.top:=0;
  drawchip(newchip.left+x);
end;

{*********************** TokenMouseMove ****************}
procedure TForm1.TokenMouseMove(Sender: TObject; Shift: TShiftState; X,
 Y: Integer);
{drag a chip horizontally}
begin
  if dragchip then drawchip(newchip.left+x);
end;

{******************** TakenMouseUp *****************}
procedure TForm1.TokenMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Drop the chip in its new column and see if it makes a winner}
begin
  if board[(newchip.left+x) div (chipwidth+sidewidth),0]<>0 then
  begin
    newchip.left:=0;
    exit;
  end;
  with opponentgrp do  if itemindex<0 then itemindex:=0;

  dropchip(newchip.left+x);
  dragchip:=false;
  changeplayers;
  if (tag=0) and (not gameover) then
  begin
    drawchip(chipwidth div 2);
    with opponentgrp do
    //if itemindex<0 then itemindex:=0
    //else
    if ((currentplayer=1) and ((itemindex =2) or (itemindex =3)))
    or ((currentplayer=2) and ((itemindex =1) or (itemindex=3)))
    then computermove;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  inc(runtime);
  movelbl.caption:='Thinking...'+inttostr(runtime);
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;


procedure TForm1.MaxsecsSpinChange(Sender: TObject);
begin
  maxsecs:=maxsecsSpin.value;
end;

end.



