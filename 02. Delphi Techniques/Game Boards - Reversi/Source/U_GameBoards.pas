unit U_GameBoards;
 {Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Here are three examples of ways to make and control the pieces on a game
 board. The sample game is Reversi}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, extctrls,
  Grids,StdCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StaticText1: TStaticText;
    Label1B: TLabel;
    ResetBtn1: TButton;
    ResetBtn2: TButton;
    ResetBtn3: TButton;
    Label2b: TLabel;
    Label3B: TLabel;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure ResetBtn1Click(Sender: TObject);
    procedure ResetBtn2Click(Sender: TObject);
    procedure ResetBtn3Click(Sender: TObject);
  public
    { Public declarations }
    panelsize:integer;
    offsetx,offsety:integer;
    boardcolor:TColor;

    {Board1 - an array of TPanels}
    board1:array [0..7,0..7]  of TPanel;
    turn1:integer;    {board1 currentplayer number 1 or 2}
    score1:array[1..2] of integer; {scores for board1}

    {Board2 - an array of TShapes on a TPanel}
    board2:array [0..7,0..7]  of TShape;
    turn2:integer;    {board2 currentplayer number 1 or 2}
    Board2BG:TPanel;
    score2:array[1..2] of integer; {scores for board2}

    {Board3 - a TStringgrid}
    board3:TStringgrid;
    turn3:integer;    {board3 currentplayer number 1 or 2}
    score3:array[1..2] of integer; {scores for board3}


    procedure panelclick(sender:TObject); {Board1 piece handling & drawing}
    procedure ShapeMouseUp(Sender: TObject;Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer); {Board2 piece handling & drawing}
    procedure Board3Select(Sender: TObject; ACol, ARow: Longint;  {Board3 piece handling}
                            var CanSelect: Boolean);

    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                           Rect: TRect; State: TGridDrawState); {Board3 piece drawing}
    procedure showlabel(lbl:TLabel; turn:integer; score:array of integer);
    procedure showWinner(lbl:TLabel; score:array of integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormActivate(Sender: TObject);
var
  col,row:integer;
begin
  panelsize:=20;
  offsetx:=50;
  offsety:=100;
  boardcolor:=clsilver;

  {Make Board1}
  for col:=0 to 7 do
  for row:=0 to 7 do
  begin
    board1[col,row]:=TPanel.create(self);
    with board1[col,row] do
    begin
      left:=offsetx+panelsize*col;
      top:=offsety+panelsize*row;
      width:=panelsize;
      height:=panelsize;
      color:=boardcolor;
      parent:=self;
      onclick:=Panelclick;
    end;
  end;
  resetBtn1click(sender); {make board1}
  label1.left:=offsetx;   {align the labels}
  label1b.left:=offsetx;


  {Make Board 2 - TShapes}
  Board2Bg:=TPanel.create(self);
  with board2BG do
  begin
    left:=offsetx + 9*panelsize - 1;
    top:=offsety-1;
    width:=8*panelsize+2;
    height:=width;
    color:=clgreen;
    bevelinner:=bvnone;
    bevelouter:=bvnone;
    parent:=self;
  end;
  for col:=0 to 7 do
  for row:=0 to 7 do
  begin
    board2[col,row]:=Tshape.create(self);
    with board2[col,row] do
    begin
      left:=panelsize*col;
      top:=panelsize*row;
      width:=panelsize;
      height:=panelsize;
      brush.color:=boardcolor;
      parent:=Board2BG;
      shape:=stCircle;
      onmouseup:=ShapeMouseUp;
    end;
  end;
  ResetBtn2click(sender);
  label2.left:=offsetx+9*panelsize;
  label2b.left:=label2.left;

  {Make Board3 - TStringgrid }
  Board3:=TStringGrid.create(self);
  with board3 do
  begin
    colcount:=8;
    rowcount:=8;
    left:=offsetx+18*Panelsize; {Move over two board widths to start}
    top:=offsety;
    parent:=self;
    fixedcols:=0;
    fixedrows:=0;
    DefaultColwidth:=panelsize;
    DefaultRowheight:=panelsize;
    width:=8*(panelsize+gridlinewidth)+3*gridlinewidth;
    height:=width;
    color:=clgreen;
    scrollbars:=ssnone;
    defaultdrawing:=false;
    OnDrawCell:=StringGridDrawCell;
    OnSelectCell:=Board3Select;
  end;
  ResetBtn3click(sender);
  label3.left:=board3.left;
  label3b.left:=label3.left;

end;

var
  offsets:array[0..8] of TPoint = ((x:0;y:0),   {Offsets of the 8 directions to check}
                                   (x:1;y:1),
                                   (x:1;y:0),
                                   (x:1;y:-1),
                                   (x:0;y:1),
                                   (x:0;y:-1),
                                   (x:-1;y:1),
                                   (x:-1;y:0),
                                   (x:-1;y:-1)
                                   );

   playername:array[1..2] of string=('Red','Blue');


{************ ValidPoint **********}
function validpoint(x,y:integer):boolean;
{True if point (x,y) indexes a cell on the board, false if not}
begin
  result:= (x>=0) and (x<=7) and (y>=0) and (y<=7);
end;

{************* Showlabel ************}
procedure TForm1.showlabel(lbl:TLabel; turn:integer; score:array of integer);
{common routine ised by each board to show scores and turn}
var s:string;
begin
  if turn>0 then s:=playername[turn]+'''s turn,' else s:='';
  lbl.caption:=s+' Score: Red. '+ inttostr(score[low(score)])+', Blue. '+inttostr(score[high(score)]);
end;

{********** ShowWinner **********}
procedure Tform1.showWinner(lbl:Tlabel; score:array of integer);
{common routine to display winner }
var
  s:string;
begin
   if score[low(score)]>score[high(score)] then s:='Red' else s:='Blue';
   lbl.caption:='Game over, winner is '+s+'!!';
end;

{************* PanelClick *****************}
procedure TForm1.PanelClick(Sender: TObject);
{OnClick event exit for Board1 pieces - make the move and adjust colors, etc.}
   {look for cell adjacent to clicked square that is opponent's color
    and has cell of our color inline in one of the eight possible directions}

   function validmove(frompoint:TPoint; turn:integer):boolean;
   {is is a valid click location? return true if yes}
   var
     i,j,xx,yy:integer;
     OK:boolean;
   begin
     i:=0;
     ok:=false;
     if board1[frompoint.x, frompoint.y].tag=0 then
     begin
       while (i<8) and (not OK) do {check all directions until we find 1st valid move}
       {moving will have to checkl all directions, but here we only need to find the
        one valid direction}
       begin
         inc(i); {next direction}
         ok:=true;
         j:=0;
         while OK do
         begin
           inc(j); {move in chosen direction}
           xx:=frompoint.x+j*offsets[i].x;
           yy:=frompoint.y+j*offsets[i].y;
           if validpoint(xx,yy)then
           begin {point is on the board}
             if board1[xx,yy].tag=0 then {if unused  - not a valid move}
             begin
               ok:=false;
               break;
             end
             else if (board1[xx,yy].tag=turn{+1}) {it is out color, so may be valid}
             then
             if (j>1) then break {if we have moved more than one square - it's valid}
             else
             begin  {correct end move color, but adjacent - not a valid move}
               ok:=false;
               break;
             end;
           end
           else ok:=false; {point niot on the the board, not a valiud move}
         end;
         if OK then break;{break if we have found a valid move}
       end;
     end;
     result:=OK;
   end;

   procedure makemove(frompoint:TPoint; turn:integer);
   {make all the moves triggered by click on "frompoint" cell}
   var
     i,j,k,xx,yy:integer;
     OK:boolean;
   begin
     i:=0;
     while (i<8)  do   {check all 8 directions}
     begin
       inc(i);
       OK:=true;
       j:=0;
       while OK do
       begin
         inc(j); {index of move length in current direction}
         xx:=frompoint.x+j*offsets[i].x; {point to test}
         yy:=frompoint.y+j*offsets[i].y;
         if validpoint(xx,yy) then
         begin
           if board1[xx,yy].tag=0 then {unoccupied --> no move this direction}
           begin
             ok:=false;
             break;
           end
           else if (board1[xx,yy].tag=turn{+1}) {this is our color}
           then
           if (j>1) then break {so if we have moved more than one sqaure, valid move}
           else
           begin {other, matching color was adjacent - no move}
             ok:=false;
             break;
           end;
         end
         else ok:=false;  {point not on board - no move}
       end;
       if OK then  {we have a valid move to make}
       begin
         for k:=0 to j-1 do {from clicked cell to just before the matching cell of our color}
         begin
           xx:=frompoint.x+k*offsets[i].x;
           yy:=frompoint.y+k*offsets[i].y;
           if board1[xx,yy].tag<>turn then inc(score1[turn]); {first move from this square}
           board1[xx,yy].tag:=turn; {set turn indicator}
           if k>0 then dec(score1[(turn) mod 2 +1]); {away from the clicked cell, reduce opponents count}
           case turn of {set color}
             1: board1[xx,yy].color:=clred;
             2: board1[xx,yy].color:=clblue;
           end;
         end;
       end;
     end;
   end;

var
  col,row:integer;
  s:string;
  OK:boolean;
begin {Panel1ckick}
  with tPanel(sender) do
  begin
    col:=(left-offsetx) div panelsize ; {get coordinates from clicked panel location}
    row:=(top-offsety) div panelsize;
    if validmove(point(col,row),turn1) then
    begin  {we can move, so make all the moves}
      makemove(point(col,row),turn1);

      if score1[1]+score1[2]=64 then {game over?}
      begin   {yes}
        if score1[1]>score1[2] then s:='Red' else s:='Blue';
        label1B.caption:='Game over, winner is '+s+'!!';
        showlabel(label1,0,score1);  {show final score only}
      end
      else
      begin {Game not over yet}
        turn1:=turn1 mod 2+1;  {other player's turn}
        {check for at least one move for the other player}
        ok := false;
        for col:=0 to 7 do for row:=0 to 7 do if validmove(point(col,row),turn1) then
        begin
          ok:=true;
          break;
        end;
        If not OK then {no valid move}
        begin
          label1B.caption:='No valid moves remaining for '+ playername[turn1];
          turn1:=turn1 mod 2 +1; {switch back to the player who clicked last}
        end
        else label1b.caption:='';
        showlabel(label1,turn1,score1); {show turn and score message}
      end;
    end;
  end;
end;


{********************* ShapeMouseUp *************}
procedure TForm1.ShapeMouseUp(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
{Make moves and color pieces for Board2 clicks}


   function makemoves(col,row:integer; moveit:boolean):integer;
   {make valid moves from col,row and return the number of cells added to turn2's color}
   {The count of pieces lost for the opponent is one less than the current player's gain}
   var  i,j,k, oppturn:integer;
        xx,yy:integer;
   begin
     result:=0;
     if board2[col,row].tag=0 then
     begin
       i:=0;
       while i<8 do
       begin
         inc(i);
         oppturn:=turn2 mod 2 + 1;  {opponents turn flag}
         xx:=col+offsets[i].x;
         yy:=row+offsets[i].y;
         if validpoint(xx,yy) and (board2[xx,yy].tag=oppturn) then
         begin  {this could be a valid move - check for my color in line before we find
                  a blank cell or the edge of the board}
           j:=1;
           repeat
             inc(j);
             xx:=col+j*offsets[i].x;
             yy:=row+j*offsets[i].y;
           until  (not validpoint(xx,yy)) or (board2[xx,yy].tag<>oppturn);
           if (j>1) and validpoint(xx,yy) and (board2[xx,yy].tag=turn2) then
           begin {it is a valid move}
             if moveit then  {If actually moving, not just checking then}
             for k:=0 to  j-1 do
             with board2[col+k*offsets[i].x,row+k*offsets[i].y] do
             begin
               tag:=turn2;
               case turn2 of
                 1: brush.color:=clred;
                 2: brush.color:=clblue;
               end;
             end;
             inc(result,j-1); {add number reversed to the result score}
           end;
         end;
       end;
       if result>0 then inc(result) {if we flipped any, then add 1 for the
                                     blank cell clicked to start this move}
     end;
   end;

var
  col,row:integer;
  n:integer;
  OK:boolean;
  s:string;
begin  {ShapeMouseUp}
  with tshape(sender) do
  begin
    col:=(left) div panelsize ; {get coordinates of piece clicked}
    row:=(top) div panelsize;
    n:=makemoves(col,row,true); {Make any moves}
    if n>0 then
    begin  {yes, we did make some moves}

      case turn2 of
        1:
        begin
          inc(score2[1],n);
          dec(score2[2],n-1);
        end;
        2:
        begin
          inc(score2[2],n);
          dec(score2[1],n-1);
        end;
      end;
      if score2[1]+score2[2]=64 then
      begin  {game over!}
        if score2[1]>score2[2] then s:='Red' else s:='Blue';
        label2B.caption:='Game over, winner is '+s+'!!';
        showlabel(label2,0,score2);
      end
      else
      begin
        turn2:=(turn2) mod 2+1;  {other player's turn}
        OK:=false;
        for col:=0 to 7 do
        begin
          for row:=0 to 7 do
          begin
            n:=makemoves(col,row,false);
            if n>0 then
            begin
              OK:=true;
              break;
            end;
            if OK then break;
          end;
        end;
        If not OK then
        begin
          label2B.caption:='No valid moves remaining for '+ playername[turn1];
          turn2:=turn2 mod 2 +1;   {flip back to current player }
        end
        else label2b.caption:='';
        showlabel(label2,turn2,score2);
      end;
    end;
  end;
end;

{*****************  Board3.Select *******************}
procedure TForm1.Board3Select(Sender: TObject; ACol, ARow: Longint;  {Board3 piece handling}
                            var CanSelect: Boolean);

  function makemoves(col,row:integer; MoveIt:boolean):integer;
     {make valid moves from col,row and return the number of cells added to turn3's color}
     {The count lost for the opponent is one less than the turn3 players gain}
     var  i,j,k, oppturn:integer;
          xx,yy:integer;
     begin
       result:=0;
       if board3.cells[col,row]='0' then
       begin
         i:=0;
         while i<8 do
         begin
           inc(i);
           oppturn:=turn3 mod 2 + 1; {opponents turn indicator}
           xx:=col+offsets[i].x;
           yy:=row+offsets[i].y;
           if validpoint(xx,yy) and (board3.cells[xx,yy]=inttostr(oppturn)) then
           begin  {this could be a valid move - check for my color in line before we hit
                    a blank cell or the edge of the board}
             j:=1;
             repeat
               inc(j);  {continue in current direction}
               xx:=col+j*offsets[i].x;
               yy:=row+j*offsets[i].y;
             until  (not validpoint(xx,yy)) or (board3.cells[xx,yy]<>inttostr(oppturn));
             if (j>1) and validpoint(xx,yy) and (board3.cells[xx,yy]=inttostr(turn3)) then {it is a valid move}
             begin
               if moveit then  {make actual move, otherwise just checking}
               for k:=0 to  j-1 do
                 board3.cells[col+k*offsets[i].x,row+k*offsets[i].y]:=inttostr(turn3);
               inc(result,j-1);
             end;
           end;
         end;
         if result>0 then inc(result)
       end;
     end;

var c,r, n:integer;
    OK:boolean;
    s:string;
begin
  with TStringgrid(sender) do
  begin
    canselect:=false;
    if cells[acol,arow]='0' then {empty cell amy be eligible}
    begin
      n:=makemoves(acol,arow,true);
      if n>0 then
      begin
        canSelect:=true;
        case turn3 of
          1:
          begin
            inc(score3[1],n);
            dec(score3[2],n-1);
          end;
          2:
          begin
            inc(score3[2],n);
            dec(score3[1],n-1);
          end;
        end;

        turn3:=turn3 mod 2+1;  {other player's turn}
        if score3[1]+score3[2]=64 then {game over}
        begin
          if score3[1]>score3[2] then s:='Red' else s:='Blue';
          label3B.caption:='Game over, winner is '+s+'!!';
          showlabel(label3,0,score3);
        end
        else
        begin  {game not over}
          {check if any valid moves for other player}
          for c:=0 to 7 do
          begin
            for r:=0 to 7 do
            begin
              n:=makemoves(c,r,false);
              if n>0 then
              begin
                OK:=true;
                break;
              end;
            end;
            if OK then break;
          end;
          If not OK then
          begin
            label3b.caption:='No plays available for '+playername[turn3];
            turn3:=turn3 mod 2 +1;  {switch back to other player}
          end
          else label3b.caption:='';
          showlabel(label3,turn3,score3);
        end;
      end;
    end;
  end;
end;


procedure TForm1.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw pieces for board3}
begin
  with Sender as TStringGrid, canvas  do
  begin
    Brush.Color := color;
    FillRect(Rect);
    case strtoint(cells[acol,arow]) of
      0: brush.color:=self.color;
      1: brush.color:=clred;
      2:brush.color:=clblue;
    end;
    pen.color:=clBlack;
    ellipse(rect.left+1,rect.top+1,rect.right-1,rect.bottom-1);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
                    nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.ResetBtn1Click(Sender: TObject);
{reset board1}
var col,row:integer;
begin
  {Make Board1 - TPanels}
  for col:=0 to 7 do
  for row:=0 to 7 do
  begin
    board1[col,row]:=TPanel.create(self);
    with board1[col,row] do
    begin
      left:=offsetx+panelsize*col;
      top:=offsety+panelsize*row;
      width:=panelsize;
      height:=panelsize;
      color:=boardcolor;
      parent:=self;
      onclick:=Panelclick;
    end;
  end;
  with  board1[3,3] do
  begin
    color:=clred;
    tag:=1;
  end;
  with  board1[4,4] do
  begin
    color:=clred;
    tag:=1;
  end;
  with  board1[4,3] do
  begin
    color:=clblue;
    tag:=2;
  end;
  with  board1[3,4] do
  begin
    color:=clblue;
    tag:=2;
  end;
  turn1:=1;
  score1[1]:=2;
  score1[2]:=2;
  showlabel(label1,turn1,score1);
  label1b.caption:='';
end;

procedure TForm1.ResetBtn2Click(Sender: TObject);
var  col,row:integer;
begin
  for col:=0 to 7 do for row:=0 to 7 do
  with board2[col,row] do
  begin
    brush.color:=boardcolor;
    tag:=0;
  end;
  with  board2[3,3] do
  begin
    brush.color:=clred;
    tag:=1;
  end;
  with  board2[4,4] do
  begin
    brush.color:=clred;
    tag:=1;
  end;
  with  board2[4,3] do
  begin
    brush.color:=clblue;
    tag:=2;
  end;
  with  board2[3,4] do
  begin
    brush.color:=clblue;
    tag:=2;
  end;
  score2[1]:=2;
  score2[2]:=2;
  turn2:=1;
  showlabel(label2,turn2,score2);
  label2b.caption:='';
end;

procedure TForm1.ResetBtn3Click(Sender: TObject);
var col,row:integer;
begin
  for col:=0 to 7 do for row:= 0 to 7 do board3.cells[col,row]:='0';
  board3.cells[3,3]:='1';
  board3.cells[3,4]:='2';
  board3.cells[4,4]:='1';
  board3.cells[4,3]:='2';
  score3[1]:=2; {set initial scores}
  score3[2]:=2;
  turn3:=1;
  showlabel(label3, turn3, score3);
  label3b.caption:='';
end;

end.
