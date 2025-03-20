unit U_HIP4;
{Copyright © 2001, 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A Delphi version of Martin Gardner's Game of Hip}
 {Verions 2 allows moves to be retracted}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellAPI, ComCtrls;

type

  tsquare=class(TObject)
     p:array[1..4] of tpoint;
     PointsOwnedBy:array[0..1] of integer;
   end;

  TPlayer=class(TObject)
    PlayerID:string;
    IsComputer:boolean;
    PointsOwned:array{[1..18]} of TPoint;
    NbrPoints:integer;
    cursor:integer;
    color:TColor;
    constructor create(newid:string; iscomp:boolean;
                       newcursor:integer; newcolor:TColor; newside:integer);
  end;


  TGameRec=record
    AIComputer, BIsComputer, AllowRetractions:boolean;
    boardsizeIndex:integer;
    //moves:array [0..49] of TPoint;
  end;

  TMoverec=record
    p:TPoint;
    movedby:integer;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Board: TImage;
    Label1: TLabel;
    Label2: TLabel;
    NewBtn: TButton;
    Player1Box: TCheckBox;
    Player2Box: TCheckBox;
    StartBtn: TButton;
    CanRetract: TCheckBox;
    SizeGrp: TRadioGroup;
    TieGameBtn: TButton;
    Memo1: TMemo;
    DoubleMoveBox: TCheckBox;
    Movelist: TListBox;
    Label3: TLabel;
    RetractBtn: TButton;
    ShowMoves: TCheckBox;
    Label5: TLabel;
    procedure BoardClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure BoardMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BoardMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
    procedure SizeGrpClick(Sender: TObject);
    procedure CanRetractClick(Sender: TObject);
    procedure TieGameBtnClick(Sender: TObject);
    procedure DoubleMoveBoxClick(Sender: TObject);
    procedure RetractBtnClick(Sender: TObject);
    procedure ShowMovesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    squarelist:TStringlist;
    ownedby:array of array {[0..5, 0..5]} of byte; {owner of points}
    tiegame:array[0..5, 0..5] of byte; {token positions for 6x6 tie game}
    currentplayer:byte;
    w,h,halfw,halfh:integer;
    Players:array[0..1] of TPlayer;
    gameover:boolean;
    Gamerec:TGamerec;
    NextTie:integer;
    PlayingTieGame:boolean; {flag set while displaying a tie game}
    hasMoved:Boolean; {flag set to true by getNextPlayer, set to false by boardclick}
    Moves:array of TMoverec;
    totmoves:integer;
    procedure drawboard;
    procedure makemove(i,j:integer);
    procedure retractmove2(const player,i,j:integer);  overload;
    procedure retractmove2; overload;
    procedure resetboard;
    procedure drawsquare(index:Integer);
    procedure computermove;
    procedure Getnextplayer(automove:boolean);
    function  pointInSquare(index:integer;pt:TPoint):boolean;
    procedure drawempty(i,j:integer);
    procedure SetRetractLabel;
    function GetPrevPlayer:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
{$R Cursors.res}

var
  side:integer=7; {may generalize to other sizes eventually but need to
                   handle the tie game  trick used for 6x6 when computer
                   is playing computer }


const
  dotrad=6; {dot radius}
  crRED=1;
  crBLUE=2;
  available=255;

  {the 3 unique 6x6 tie games}
  tiegamedata1:array[0..5, 0..5] of byte=((0,1,0,1,0,1),
                                          (1,1,1,1,0,0),
                                          (0,0,1,0,0,1),
                                          (1,0,0,1,0,0),
                                          (0,0,1,1,1,1),
                                          (1,0,1,0,1,0));

  tiegamedata2:array[0..5, 0..5] of byte=((0,1,0,0,0,1),
                                          (1,1,1,1,0,0),
                                          (1,0,1,0,0,1),
                                          (1,0,0,1,0,0),
                                          (0,0,1,1,1,1),
                                          (1,0,1,0,1,0));

  tiegamedata3:array[0..5, 0..5] of byte=((0,1,0,0,0,1),
                                          (1,1,1,1,0,0),
                                          (1,0,1,0,0,1),
                                          (1,0,0,1,0,1),
                                          (0,0,1,1,1,1),
                                          (1,0,0,0,1,0));

{******************** TPlayer.create  **************}
constructor TPlayer.create(newid:string; iscomp:boolean;
                           newcursor:integer; newcolor:TColor; Newside:integer);
begin
  inherited create;
  setlength(PointsOwned,newside*newside div 2 + 1);
  playerid:=newid;
  iscomputer:=iscomp;
  cursor:=newcursor;
  color:=newcolor;

end;

{****************** Local Routines *********}

{******************* valid ******************}
function valid(p:array of integer):boolean;
{returns true if numbers passed are all between 1 and side}
var
  i:integer;
begin
  result:=true;
  for i:= low(p) to high(p) do
  if (p[i]>side-1) or (p[i]<0) then
  begin
    result:=false;
    break;
  end;
end;

{******************** Swap ************}
procedure swap(var p1,p2:Tpoint);
{swap two points }
var
  p:TPoint;
begin
   p:=p1;
   p1:=p2;
   p2:=p;
end;

{****************** Makekey **************}
function makekey(var s:TSquare):string;
var
  i,j:integer;
begin
  with s do
  begin
    {sort points by x then y to get a uniques key}
    for i:=low(p) to high(p)-1 do
    for j:=i+1 to high(p) do
    begin
      if p[i].x>p[j].x then swap(p[i],p[j])
      else if (p[i].x=p[j].x) and (p[i].y>p[j].y) then swap(p[i],p[j]);
    end;
    result:=inttostr(p[1].x)+ inttostr(p[1].y)+','
                  + inttostr(p[2].x)+inttostr(p[2].y)+','
                  + inttostr(p[3].x)+inttostr(p[3].y)+','
                  + inttostr(p[4].x)+inttostr(p[4].y);
  end;
end;

{***************** PointsEqual ************}
function PointsEqual(p1,p2:TPoint):boolean;
begin
  if (p1.x=p2.x) and (p1.y=p2.y) then result:=true
  else result:=false;
end;

{*****************TFORM1 METHODS ****************}


{*************** FormCreate ****************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  screen.cursors[crRed]:=loadcursor(HInstance,'RED');
  screen.cursors[crBlue]:=loadcursor(HInstance,'BLUE');
  players[0]:=TPlayer.create('Player A', false, crRed, clRed,side);
  players[1]:=TPlayer.create('Player B', false, crBlue, clblue,side);
  sizegrpclick(sender);
  NextTie:=0;
  PlayingTieGame:=false;
end;


procedure Tform1.drawempty(i,j:integer);
var
  x1,y1,x2,y2:Integer;
begin
  with board, canvas do
  begin
    x1:=i*w+halfw-dotrad;
    y1:=h*j+halfh-dotrad;
    x2:=i*w+halfw+dotrad;
    y2:=h*j+halfh+dotrad;
    brush.color:=clwhite;
    ellipse(x1,y1,x2,y2)
  end;
end;

{******************** DrawBoard *************}
procedure tForm1.drawboard;
var
  i,j:integer;
  x1,y1,x2,y2:integer;
begin
   with board, canvas do
  begin
    pen.width:=1;
    picture.Bitmap.pixelformat:=pf24bit;
    brush.color:=$80F080;
    rectangle(clientrect);

    for i:= 0 to side-1 do
    for j:=0 to side-1 do
    begin
      if ownedby[i,j]=available
      then drawempty(i,j)
      else
      begin
        x1:=i*w+halfw-dotrad;
        y1:=h*j+halfh-dotrad;
        x2:=i*w+halfw+dotrad;
        y2:=h*j+halfh+dotrad;
        brush.color:=players[ownedby[i,j]].color;
        ellipse(x1,y1,x2,y2);
      end;
    end;
  end;
end;

{******************** DrawSquare ***********}
procedure TForm1.drawsquare(index:integer);
var
  s:TSquare;
begin
  s:=TSquare(squarelist.objects[index]);
  with Board, canvas, s do
  begin
    pen.width:=2;
    pen.color:=clblack;
    moveto(p[1].x*w+halfw,p[1].y*h+halfh);
    lineto(p[2].x*w+halfw,p[2].y*h+halfh);
    lineto(p[4].x*w+halfw,p[4].y*h+halfh);
    lineto(p[3].x*w+halfw,p[3].y*h+halfh);
    lineto(p[1].x*w+halfw,p[1].y*h+halfh);
    update;
  end;
end;


{************************** PointInSquare ******************}
 function TForm1.pointInSquare(index:integer;pt:TPoint):boolean;
 {return true if pt, the point passed, is in the squarelist[index] entry}
    var
      m:integer;
    begin
      result:=false;
      with TSquare(squarelist.objects[index]) do
      for m:= 1 to 4 do if PointsEqual(p[m],pt) then
      begin
       result:=true;
       break;
      end;
    end;

{****************** MakeMove *************}
procedure TForm1.MakeMove(i,j:integer);
{Assign point (i,j) to current player and check to see if he has completed
 a square (and therefore lost) }
var
  k:integer;
  pa:TSquare;
  x1,y1,x2,y2:integer;
  newpoint:Tpoint;
  msg:string;
  begin
    pa:=tsquare.create;
    with Board, canvas do
    begin
      x1:=i*w+halfw-dotrad;
      y1:=j*h+halfh -dotrad;
      x2:=i*w+halfw+dotrad;
      y2:=j*h+halfh +dotrad;
      ownedby[i,j]:=currentplayer;
      brush.color:=players[currentplayer].color;
      ellipse(x1,y1,x2,y2);
      {check for completed squares}

      with players[currentplayer] do
      begin
        inc(NbrPoints);
        PointsOwned[NbrPoints]:=point(i,j);
        newpoint:=point(i,j);
        {keep a record of totla moves for use in retracting  and possible replay}
        inc(totmoves);
        with moves[totmoves] do
        begin
          p:=point(i,j);
          movedby:=currentplayer;
          movelist.items.add(format('(Col,Row)(%d,%d) by %s',
           [p.x+1,p.y+1,char(ord('A')+currentplayer)]));
          movelist.itemindex:=movelist.Items.count-1;
        end;
        
        for k:= 0 to squarelist.count-1 do
        begin
          if pointInSquare(k,newpoint) then
          with TSquare(squarelist.objects[k]) do
          begin
            inc(PointsOwnedBy[currentplayer]);
            if PointsOwnedBy[currentplayer]=4 then
            begin
              drawsquare(k);
              msg:='Oh oh! - '+ playerid +' loses!';
              if players[0].iscomputer and players[1].iscomputer
              then msg:=msg+#13+'Click "Allow retractions" box to explore alternate outcomes';
              showmessage(msg);
              label1.caption:=players[(currentplayer+1) mod 2].playerid
                                    + ' wins!                        ';
              gameover:=true;
              Getnextplayer(false);
              exit;
            end;
          end;
        end;
        if (players[0].NbrPoints +players[1].NbrPoints=side*side) then
        begin
          showmessage('A tie game!');
          label1.caption:='Tie game!';
          Getnextplayer(false);  {In case user wants to play with retractions}
          gameover:=true;
          exit;
        end;
      end;
    end;
    pa.free;
  end;



(*
{****************** RertactMove *************}
procedure TForm1.RetractMove(const player,i,j:integer);
{Remove point assigned to passed player}
var
  k,m:integer;
  pa:TSquare;
  x1,y1,x2,y2:integer;
  oldpoint:Tpoint;
  begin
    pa:=tsquare.create;
    with Board, canvas do
    begin
      x1:=i*w+halfw-dotrad;
      y1:=j*h+halfh -dotrad;
      x2:=i*w+halfw+dotrad;
      y2:=j*h+halfh +dotrad;
      ownedby[i,j]:=available;
      brush.color:=clWhite;
      ellipse(x1,y1,x2,y2);
      {check for this point ownedby player}
      oldpoint:=point(i,j);
      with players[player] do
      begin
        for k:=1 to nbrpoints do
        if pointsequal(PointsOwned[k], oldpoint) then
        begin
          for m:=k to nbrpoints-1 do pointsowned[m]:=pointsowned[m+1];
          break;
        end;
        //if nbrpoints>0 then dec(nbrpoints);

        {now delete this point from any possible square where it is already
         marked as belonging to this player}
        for k:= 0 to squarelist.count-1 do
        if pointInSquare(k,oldpoint) then
         with TSquare(squarelist.objects[k]) do dec(PointsOwnedBy[player]);
        {and delete the move from the moves array}
        for k:=1 to totmoves do
        with moves[k] do
        if pointsequal(p, oldpoint) then
        begin
          p:=moves[totmoves].p;
          dec(totmoves);
          break;
          listbox1.items
        end;

        if nbrpoints>0 then dec(nbrpoints);
      end;
    end;
    drawboard;
    pa.free;
  end;
*)
procedure TForm1.RetractMove2(const player,i,j:integer);
{Remove point assigned to passed player}
var
  k,m:integer;
  pa:TSquare;
  x1,y1,x2,y2:integer;
  oldpoint:TPoint;
  OK:boolean;
  begin
    if player<>moves[totmoves].movedby then
    begin
      showmessage('Retract for wrong player, ignored');
      exit;
    end;
    oldpoint:=point(i,j);
    pa:=tsquare.create;
    with Board, canvas do
    begin
      x1:=i*w+halfw-dotrad;
      y1:=j*h+halfh -dotrad;
      x2:=i*w+halfw+dotrad;
      y2:=j*h+halfh +dotrad;
      ownedby[i,j]:=available;
      brush.color:=clWhite;
      ellipse(x1,y1,x2,y2);
      {check for this point ownedby player}
      ok:=false;
      with players[player] do
      begin
        for k:=nbrpoints downto 1 do
        begin
          if pointsequal(PointsOwned[k], oldpoint) then
          begin {found the point}
            OK:=true;
            if k<>nbrpoints {not removing last, replace with with last}
            then
            begin
              pointsowned[k]:=moves[totmoves].p;

              for m:=totmoves downto 1 do
              if pointsequal(moves[m].p,oldpoint) then
              begin
                moves[m].p:=moves[totmoves].p;
                movelist.items[m-1]:=movelist.items[totmoves-1];
                break;
              end;
            end;
            break;
          end;
        end;
        if not Ok then
        begin
          showmessage('System error, owned point not found, halted');
          halt;
        end
        else
        begin
           {now delete this point from any possible square where it is already
            marked as belonging to this player}
          for k:= 0 to squarelist.count-1 do
          if pointInSquare(k,oldpoint) then
           with TSquare(squarelist.objects[k]) do dec(PointsOwnedBy[player]);
          {and delete the move from the moves array}
          MoveList.items.delete(totmoves-1);
          movelist.itemindex:=movelist.Items.count-1;
          dec(totmoves);
          dec(nbrpoints);
        end;
      end;
    end;
    drawboard;
    pa.free;
    gameover:=false; {not sure if it's on, but we want it off now anyway}
  end;


procedure TForm1.RetractMove2;
{Retract latest move}
begin
  with moves[totmoves] do
  retractmove2(movedby, p.x, p.y);
end;






{******************* BoardClick ***************}
procedure TForm1.BoardClick(Sender: TObject);
{add a token for current point if it's available}
var
  i,j:integer;
  p:TPoint;
  prevplayer:integer;
begin
  HasMoved:=false;
  p:=mouse.cursorpos;
  p:=Board.screentoclient(p);
  i:=trunc(p.x*side / Board.width) ;
  j:=trunc(p.y*side / Board.height);
  if totmoves=0 then resetboard;

  if canretract.checked and gameover then
  begin
    {Get the player of the opposie color, not necessarily the player
     that made the previous play (i.e double move rukes game)}
    prevplayer:=moves[totmoves].movedby;
    if ownedby[i,j]=prevplayer then gameover:=false
    {User might have been trying to retract but accidentally clicked a blank or
     wrong colored dot - conform that he wants to restart}
    else gameover:=messagedlg('Start a new game?',mtconfirmation,[mbyes,mbno],0)=mrYes;
    if not gameover then drawboard; {get rid of the drawn square}
  end;
  if (gameover or (players[0].NbrPoints=0))
  then resetboard;
  if ownedby[i,j]=Available then
  begin
    makemove(i,j);
    If not gameover then Getnextplayer(true);
  end
  else
  begin
    if (canretract.checked)
    and (totmoves>0)
    and (ownedby[i,j]=moves[totmoves].movedby)
    then
    begin
      retractmove2(ownedby[i,j],i,j);
      Getnextplayer(false);
    end
    else beep;
  end;
end;

function TForm1.getPrevPlayer:integer;
{"Hasplayed" true ==> currentplayer has already made his move}
  begin
    if (totmoves>0) and (not hasmoved) then result:=moves[totmoves-1].movedby
    else result:=moves[totmoves].movedby;
  end;

procedure TForm1.SetRetractLabel;
var
  prevplayer:integer;
Begin
  prevplayer:=GetPrevPlayer;
  if (canretract.checked)
  and (prevplayer>=0)
  and (not players[prevplayer].iscomputer)  then
  begin
    label5.font.color:=players[prevplayer].color;
    label5.caption:=players[prevplayer].playerId +' may retact '
    +'any of her/his previous moves by clicking or use "Retract" button';
    label5.visible:=true;;
    with moves[totmoves] do
    retractbtn.caption:=format('Retract last: Col %d Row %d, by %s',
                               [p.x+1, p.Y +1, char(ord('A')+movedby)]); 
    retractbtn.visible:=true;
  end
  else
  begin
    label5.visible:=false;
    retractbtn.visible:=false;
  end;
end;


{********************* GetNextPlayer ******************}
procedure TForm1.Getnextplayer(automove:boolean);
{increments to next player and makes a move if it's computer and automove is true}
//var
  //nextplayer:integer;
  //prevplayer:integer;
var n:integer;
  begin

  {2 move after first rules}
  If doublemovebox.checked then
  begin
    n:=totmoves mod 4;
    if ((totmoves>0) and ((n=1) or (n=2))) then currentplayer:=1
    else currentplayer:=0;
  end
  else currentplayer:=(currentplayer+1) mod 2;
  Board.cursor:=players[currentplayer].cursor;
  HasMoved:=true;
  if not gameover then
  begin
    label1.font.color:=players[currentplayer].color;
    label1.caption:=inttostr(side*side-players[0].NbrPoints-players[1].NbrPoints)
                           + ' points remaining'
                           +#13+'It is '+players[currentplayer].playerId +'''s move';
  end;
  SetRetractLabel;
  application.processmessages;
  if  (not gameover)
     and automove and players[currentplayer].iscomputer
  then ComputerMove;
end;

{------------------- ComputerMove ----------------}
procedure TForm1.ComputerMove;
var
  i,j,k,n:integer;
  //nextplayer:integer;
  p:TPoint;

    function SafeMove(x,y:integer):boolean;
    {see if adding this point would complete a square}
    var
      i,j:integer;
      newpoint:Tpoint;
    begin
      i:=0;
      result:=true;
      newpoint:=point(x,y);
      while (i<squarelist.count) and (result) do
      with TSquare(squarelist.objects[i]) do
      begin
        if PointsOwnedBy[currentplayer]=3 then {this could complete a square}
        for j:=1 to 4 do if PointsEqual(p[j], newpoint)
        then result:=false;
        inc(i);
      end;
    end;


    procedure MakeRandomMove; {make a random move, non-losing if possible}
    var
      i,j{,k},startx,starty,x,y:integer;
      movemade:boolean;

      function checkmove:boolean;
      begin
        if (ownedby[x,y]=available) and SafeMove(x,y) then
        begin
          makemove(x,y);
          result:=true;
        end
        else result:=false;
      end;

    begin {MakeRandomMove}
      x:=random(side);  {get a random starting point}
      y:=random(side);
      startx:=x; starty:=y;
      //movemade:=false;
      repeat  {look for a move that won't complete a square}
        movemade:=checkmove;
        if not movemade then
        begin
          inc(y);
          if y>side-1 then {loop around back to top}
          begin
            y:=0;
            movemade:=checkmove;
            if not movemade then
            begin
              inc(x);
              if x>side-1 then x:=0;
            end;
          end;
        end;
      until ((x=startx) and (y=starty)) or movemade;
      if not movemade then {we didn't find any safe move}
      begin
        for i:= 0 to side-1 do
        begin
          for j:= 0 to side-1 do
          if ownedby[i,j]=available then
          begin
            makemove(i,j); {looks like we lost this one}
            movemade:=true;
            break;
          end;
          if movemade then break;
        end;
      end;
      if not movemade then
      begin
        showmessage('System error'); {shouldn't happen}
        gameover:=true;
      end;
    end;

begin {ComputerMove}
  if gameover then exit;

  if playingtieGame and players[0].iscomputer and players[1].iscomputer
  then {computers playing each other}
  Begin  {play a pre-deetermined the tie game}
    {pick a random nbr between 0 and nbr of moves remaining}

    n:=random(side*side div 2-players[currentplayer].NbrPoints)+1;
    k:=0;
    for i:= 0 to side-1 do
    begin
      for j:= 0 to side-1 do
      begin
        {count down that many positions - just to give the appearance
         of random play}
        if  tiegame[i,j]=currentplayer then inc(k);
        if k=n then {found the nth available  - put token there}
        begin
          makemove(i,j);
          tiegame[i,j]:=255; {mark it so we don't count it next time}
          break; {get out of the j loop}
        end;
      end;
      if k=n then break;  {if we've made the move, get out of the i loop}
    end;
  end
  else
  begin  {not replaying a tie game}
    //nextplayer:=(currentplayer+1) mod 2;
    if totmoves>0 then
    begin
    {if the human has already moved then try a symmetrical move}
    {if we can always make a symmetrical move, opponent will always form a
     square before we do}
      p:=moves[totmoves].p;
      //p:=players[nextplayer].pointsowned[players[nextplayer].NbrPoints];
      if (ownedby[side-1-p.x,side-1-p.y]=Available) and (safemove(side-1-p.x,side-1-p.y))
      then makemove(side-1-p.x,side-1-p.y)
      {oh-oh, couldn't make symetrical move, just try to find a safe one}
      else makerandommove;
      Board.update;
    end
    {else we're moving first - just make a random move and
     hope our opponent doesn't know the symmetrical move trick}
    else
    begin
      {
      if (players[currentplayer].nbrpoints=0)  and (side mod 2=1) and (ownedby[side div 2, side div 2]=available)
      then makemove(side div 2, side div 2)
      else}  makerandommove;
    end;
  end;
  sleep(100);  {pause a bit}
  if not gameover then Getnextplayer(true);
end;

{***************** ResetBoard *****************}
procedure Tform1.resetboard;
{reset board to initial condition}
var
  i,j:integer;
begin
  movelist.clear;

  setlength(moves,side*side+1);
  for i:=0 to side*side do  moves[i].movedby:=-1;
  totmoves:=0;  {total moves so far in the current game}
  hasmoved:=false;
  
  setlength(ownedby, side, side);
  for i:=0 to side-1 do for j:= 0 to side-1 do
  begin
    ownedby[i,j]:=Available;  {make all points available}
    if (side=6) and PlayingTieGame and (i<=5) and (j<=5) then
    case nextTie of
      0:tiegame[i,j]:=tiegamedata1[i,j]; {restore tie game 1 data}
      1:tiegame[i,j]:=tiegamedata2[i,j]; {restore tie game 2 data}
      2:tiegame[i,j]:=tiegamedata3[i,j]; {restore tie game 3 data}
    end;
  end;

  for i:= 0 to 1 do with players[i] do NbrPoints:=0;
  for i:=0 to squarelist.count-1 do
  with TSquare(squarelist.objects[i]) do
  begin
    PointsOwnedBy[0]:=0; {release point ownership}
    PointsOwnedBy[1]:=0;
  end;

  
  currentplayer:=1;
  Getnextplayer(false);
  drawboard;
  gameover:=false;
  if gameover then
  begin
    player1box.checked:=false;
    player2box.checked:=false;
  end;
end;

{************** NewBtnClick ****************}
procedure TForm1.NewBtnClick(Sender: TObject);
begin   resetboard; end;


{**************** CheckBox1Click *************}
procedure TForm1.CheckBoxClick(Sender: TObject);
begin
  //resetboard;
  If sender = player1box then players[0].iscomputer:=player1box.checked
  else players[1].iscomputer:=player2box.checked;;
  if players[0].iscomputer and players[1].iscomputer
  then canretract.checked:=false;
end;

{******************* StartBtnClick *************}
procedure TForm1.StartBtnClick(Sender: TObject);
{start a game}
begin
  resetboard;
  gameover:=false;
  If players[0].iscomputer then computermove;
end;

{***************** BoardMouseDown ***************}
procedure TForm1.BoardMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{For right mouse button click, draw all squares with corners on clicked point}
var
  p:TPoint;
  i,j,k:integer;
begin
  if button=mbright then
  begin
    p:=mouse.cursorpos;
    p:=Board.screentoclient(p);
    i:=trunc(p.x*side/Board.width) ;
    j:=trunc(p.y*side/Board.height);
    for k:= 0 to squarelist.count-1 do
    if pointinsquare(k,point(i,j)) then drawsquare(k);
  end;
end;

{***************** BoardMouseUp ******************}
procedure TForm1.BoardMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Erase boxes drawn by right mouse button down}
begin   if button=mbright then drawboard;end;



{************************ FormCloseQuery **********************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{In case 2 computers are playing each other when used clicks exit -
 tell them to cut it out so we can quit!}
begin   gameover:=true; end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************** SizeGrpClick ***************}
procedure TForm1.SizeGrpClick(Sender: TObject);
{Set the board size 5x5, 6x6, or 7x7}
var
  i,j,k,m:integer;
  s:TSquare;
  key:string;
  index:integer;
begin
  side:=sizeGrp.itemindex+5;
  with Board do
  begin
    w:=width div side;
    h:=height div side;
    halfw:=w div 2;
    halfh:=h div 2;
  end;
  if squarelist<>nil then {the first entry}
  begin
    for i:= 0 to squarelist.count-1 do TSquare(squarelist.Objects[i]).free;
    squarelist.free;
  end;
  {generate all squares}
  squarelist:=tstringlist.create;
  squarelist.sorted:=true;
  i:=-1;
  while i<=side-1 do
  begin
    j:=-1;
    inc(i);
    while j<= side-1 do
    begin
      inc(j);
      for k:= 1 to side-1 do
      for m:= -4 to 4 do
      with s do
      begin
        s:=TSquare.create;
        p[2].x:=i+k;
        p[2].y:=j+m;
        p[3].x:=p[2].x-m;
        p[3].y:=p[2].y+k;
        p[4].x:=p[3].x-k;
        p[4].y:=p[3].y-m;
        If valid([p[2].x,p[2].y,p[3].x,p[3].y,p[4].x,p[4].y]) then
        begin
           p[1]:=point(i,j);
           key:=makekey(s);
           if not squarelist.find(key,index) then
           begin
             squarelist.addobject(key,s);
           end;
        end
        else s.free;
      end;
    end;
  end;
  resetboard;

  drawsquare(0);
  drawsquare(side);
  drawsquare(2*side);
  drawsquare(3*side);
end;

{***************** CanRetractClick ***********8}
procedure TForm1.CanRetractClick(Sender: TObject);
{User turning retract flag on or off}
begin
  if canretract.checked then
  begin
    if players[0].iscomputer or players[1].iscomputer
    then
    begin
      player1box.checked:=false;
      player2box.checked:=false;
    end;
  end;
  SetRetractLabel;
end;

{************ TieGameBtnClick *************}
procedure TForm1.TieGameBtnClick(Sender: TObject);
{replay one of the 3 tied 6x6 games}
begin
  Player1Box.checked:=true;
  Player2Box.checked:=true;
  Sizegrp.itemindex:=1;
  PlayingTieGame:=true;
  StartBtnClick(sender);
  NextTie:=(NextTie+1) mod 3;
  PlayingTieGame:=false;
  tiegamebtn.caption:='Replay 6x6 Tie Game #'+inttostr(nextTie+1);
end;

{************* DoubleMoveBoxClick ***********}
procedure TForm1.DoubleMoveBoxClick(Sender: TObject);
{Reset option to play a double move version of the game}
begin
  resetboard;
end;


{********** RetractbrnClick ********888}
procedure TForm1.RetractBtnClick(Sender: TObject);
{Retract the last move made}
begin
  retractmove2;
  getnextplayer(false);
end;

{************* ShowMovesClick *************}
procedure TForm1.ShowMovesClick(Sender: TObject);
{turn movelist display on or off based on checkbox}
begin
  movelist.visible:=showmoves.checked; 
end;

end.
