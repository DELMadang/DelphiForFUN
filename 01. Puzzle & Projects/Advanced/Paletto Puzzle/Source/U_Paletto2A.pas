unit U_Paletto2A;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    Introsheet: TTabSheet;
    Puzzle2Sheet: TTabSheet;
    Solver2Sheet: TTabSheet;
    RandomGrp: TRadioGroup;
    ProgressBox: TCheckBox;
    SearchBtn: TButton;
    PalettoSheet: TTabSheet;
    StockPileGrid: TStringGrid;
    PalettoBtn: TButton;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    Player1Lbl: TLabel;
    Player2Lbl: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Sizegrp: TRadioGroup;
    P1Rect: TShape;
    P2rect: TShape;
    Memo4: TMemo;
    PuzzleSearchgrid: TStringGrid;
    SolvedLbl: TLabel;
    Memo5: TMemo;
    PalettoGrid: TStringGrid;
    PuzzlePlayGrid: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PageControl1Change(Sender: TObject);
    procedure StockPileGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure StockPileGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure PalettoGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PalettoBtnClick(Sender: TObject);
    procedure StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SizegrpClick(Sender: TObject);
    procedure PuzzlePlayGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PuzzleSearchgridDrawCell(Sender: TObject; ACol,
      ARow: Integer; Rect: TRect; State: TGridDrawState);
  public

    n:integer;  {set to nbrcolors-1}
    board: array[0..7,0..7] of integer;
    neighbors:array [1..8] of integer; {count of colors of each neighbor}
    dragcolor:integer;  {color number 1 to 8}
    movecount, tilecount:integer;
    lastcolor:integer;
    nbrtrials:integer;
    function placecolor(c,r:integer):boolean;
    function validneighbors(c,r,i:integer):boolean;
    procedure Initboard(Grid:TStringgrid);
    procedure InitGrid2;
    procedure SetPalPlayerLabel;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses DffUtils;

var
  nbrcolors:integer=8;
  {These are offsets used for Puzzle 2 Search algorithm}

  ox:array[1..4] of integer= (-2,-1, 0, 0);
  oy:array[1..4] of integer= ( 0, 0,-1,-2);

  {Offsets for manual play of Puzzle 2}
  Px:array[1..12] of integer= (-1,-1,-1, 0, 0, 1, 1, 1,-2, 2, 0, 0);
  Py:array[1..12] of integer= ( 1, 0,-1, 1,-1, 1, 0,-1, 0, 0,-2, 2);

  colors, usedcounts:array of integer;
  colorchoices:array[1..11] of tColor=
                             (clred, clblue,clgreen,clyellow,
                              clLime,clMaroon,clAqua,clPurple, clMoneyGreen,
                              clTeal,clSkyBlue);

  iconInfo : TIconInfo;

{************ Procedure Shuffle **********8}
procedure shuffle(var deck:array of integer);
{randomly rearrange an arrange of integers}
var
  i,k:integer;
  temp:integer;
begin
  i:= high(deck);
  while i>0 do
  begin
    k:=random(i+1);
    temp:=deck[i];
    deck[i]:=deck[k];
    deck[k]:=temp;
    dec(i);
  end;
end;

{************* InitBoard *********}
procedure TForm1.Initboard(grid:TStringGrid);
var
  i,j:integer;
begin
  n:=nbrcolors-1;

  setlength(colors,n+1);
  setlength(usedcounts,n+1);
  with grid do
  begin
    rowcount:=n+1;
    colcount:=n+1;
  end;
  adjustgridsize(grid);
  for i:=0 to n do
  begin
    colors[i]:=i+1;
    usedcounts[i]:=0;
    for j:=0 to n do
    begin
      board[i,j]:=0;
      grid.Cells[i,j]:='0';
    end;
  end;
end;

{*************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
  bmpColor : TBitmap;
  Icon:TIcon;
begin
  randomize;
  {create cursors for moving tiles to the board for game2}
   pagecontrol1.ActivePage:=Introsheet;
   bmpColor := TBitmap.Create;

   with Bmpcolor do
   begin {the cursor bitmap}
     height:= 24;
     width:=24;
   end;

    with iconInfo do
    begin
      fIcon := false;
      xHotspot := 12;
      yHotspot := 12;
      hbmMask :=  bmpcolor.handle;
      hbmColor := bmpColor.Handle;
    end;

    for i:=1 to nbrcolors do
    with bmpcolor,canvas do
    begin
       brush.color:=colorchoices[i];
       rectangle(0,0,height,width);
       Screen.Cursors[i] := CreateIconIndirect(iconInfo) ;
    end;
    bmpColor.Free;
    //setlength(board,8,8);  {board is used for the programmed puzzle solution search}
    //setlength(neighbors,9);
end;



{****************** PuzzlePlayGridMouseUp ***************}
procedure TForm1.PuzzlePlayGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

   {----------- ValidMove -----------}
    function ValidMove(cc,rr,Acolor:integer):boolean;
    {The tile being placed cannot match any immediate neighbor or the 2nd
     neighbor over in the horizontal and vertical directions}
    var
      i,c,r:integer;
    begin
      result:=true;
      for i:=1 to 12 do
      begin
        c:=cc+px[i];
        r:=rr+py[i];
        if (c>=0) and (c<=n) and (r>=0) and (r<=n)
        and (board[c,r]= acolor) then
        begin
          result:=false;
          break;
        end;
      end;

      if result then
      begin  {check that corners stay unique, new color cannot match any in place}
        if (((cc=0) and (r=0))
        or  ((cc=0) and (rr=n))
        or  ((cc=n) and (rr=0))
        or  ((cc=n) and (rr=n))
           )
        and
          ((board[0,0]=acolor)
          or (board[0,n]=acolor)
          or (board[n,0]=acolor)
          or (board[n,n]=acolor)
          )
         then result:=false;
      end;
    end;

var
    i:integer;
    acol, arow, acol2:integer;
    solved:boolean;
begin  {Puzzle 2}
  with TStringGrid(sender) do
  begin
    mousetocell(x,y,Acol,Arow);
    If (acol<0) or (arow<0) then exit;
    if board[acol,arow]>0 then
    with StockPileGrid do   {Clicked on filled grid cell}
    begin
      if dragcolor=0 then  {we aren't dragging anything}
      begin   {not dragging anything, pick up this tile}
        dragcolor:=board[acol,arow];
        screen.Cursor:=dragcolor;
        board[acol,arow]:=0;
        PuzzlePlayGrid.cells[acol,arow]:='0';
        PuzzlePlayGrid.update;
      end
      else
      begin
        acol2:=board[acol,arow]-1;
        cells[acol2,0]:=char(succ(ord(cells[acol2,0][1])));
      end
    end
    else
    if validmove(acol,arow,dragcolor) then
    begin
      board[acol,arow]:=dragcolor;
      cells[acol,arow]:=inttostr(dragcolor);
      update;
      dragcolor:=0;
      screen.cursor:=crdefault;
      solved:=true;
      for i:=0 to 7 do if  StockPileGrid.cells[i,0]<>'0' then
      begin
        solved:=false;
        break;
      end;
      if solved
      then showmessage('You did it!  Congratulations!');
    end
    else  beep;
  end;
end;

{******** SetPalPlayerLabel **********}
Procedure TForm1.SetPalPlayerLabel;
var s:string;
  begin
    if player1Lbl.visible then s:='Player 1'
    else s:='Player 2';
    memo5.Clear;
    memo5.lines.Add(s+': Click on one or more eligible cells of a '
          +'single color to take tiles.  Click an empty cell to end the turn.');
    scrolltotop(memo5);
  end;

{************* PalettoGridMouseUp ************}
procedure TForm1.PalettoGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Handle all clicks on the main board grid}

    {------------ UpdateScore ------------}
    procedure updatescore(grid:TStringgrid; acol,arow:integer);
    var
      i,j:integer;
      begin
        with grid do
        begin
          i:=board[acol,arow]-1;
          j:=strtointdef(cells[0,i],0);
          inc(j);
          cells[0,i]:=inttostr(j);
          if (j=nbrcolors) and (pagecontrol1.activepage=PalettoSheet)
          then
          begin
            Showmessage(inttostr(nbrcolors)+' same colored tiles captured. You win!');
            PalettoBtnClick(sender);
          end;
        end;
      end;

     {------------ OpenSides ---------}
    function opensides(c,r:integer):integer;
    {count opensides of  tile at (c,r)}
    begin
      result:=0;
      if (c=0) or (c=n) then inc(result);
      if (r=0) or (r=n) then inc(result);
      If (c>0) and (board[c-1,r]=0) then inc(result);
      If (c<n) and (board[c+1,r]=0) then inc(result);
      If (r>0) and (board[c,r-1]=0) then inc(result);
      If (r<n) and (board[c,r+1]=0) then inc(result);
    end;

    {------------ OrthogonallyConnected -----------}
    function orthogonallyconnected:boolean;
    {check the board}
    var
      T:array of array of integer;
      i,j:integer;
      topleft:TPoint;

         {........... Traceback ...........}
         procedure traceback(c,r:integer);
         {recursively identify all connected tiles}
         begin
           if (c<0) or (r<0) then exit;
           if (board[c,r]>0) and (T[c,r]=0) then
           begin
             T[c,r]:=1;
             if c>0 then traceback(c-1,r);
             if c<n then traceback(c+1,r);
             if r>0 then traceback(c,r-1);
             if r<n then traceback(c,r+1);
           end;
         end;


    begin   {OrthogonallyConnected}
      setlength(T,n+1,n+1);
      topleft.x:=-1;
      for i:= 0 to n do
      for j :=0 to n do
      begin
        T[i,j]:=0;
        if (board[i,j]<>0) and (topleft.x<0) then topleft:=point(i,j);
      end;
      {starting with topleft tile, recursively trace all connected tiles}
      {We will touch every tile that is connected to the top left tile}

      with topleft do traceback(x,y);
      {Every tile we visited now has value 1 in the T array}
      {Now look for any board tile not flagged in T}
      result:=true;
      for i:= 0 to n do
      begin
        for j:=0 to n do
        begin
          if (board[i,j]>0) and (T[i,j]=0) then
          begin {found a disconnected tile!}
            result:=false;
            break;
          end;
        end;
        if not result then break;
      end;
    end;

var
  acol, arow:integer;
  saveval:integer;
  firstclick:Boolean;
  s:string;
begin {GridMouseUp}
  with TStringGrid(sender) do
  begin
    mousetocell(x,y,Acol,Arow);
    If (acol<0) or (arow<0) then exit;
    begin {paletto game click}
      if board[acol,arow]>0 then
      begin
        {future clicks this turn must be of the first color clicked}
        if lastcolor=0 then
        begin
          lastcolor:=board[acol,arow];
          firstclick:=true;
        end
        else firstclick:=false;
        if board[acol,arow]=lastcolor then
        begin
          if (opensides(acol,arow) >=2) then
          begin  {clicked tile has at least 2 open sides}
            saveval:=board[acol,arow];
            board[acol,arow]:= 0; {remove tile for orthogonal test}
            if  OrthogonallyConnected then
            begin {and removing it will leave the board connected}
              board[acol,arow]:=saveval;
              SetPalPlayerLabel;
              if player1Lbl.visible
              then P1rect.Brush.color:=colorchoices[lastcolor]
              else P2rect.Brush.Color:=colorchoices[lastcolor];

              if movecount mod 2 =0 then updatescore(stringgrid3, acol,arow)
              else updatescore(stringgrid4, acol,arow);
              board[acol,arow]:=0;
              tstringgrid(sender).cells[acol,arow]:='0';
              inc(tilecount);
              if tilecount=nbrcolors*nbrcolors
              then
              begin
                if player1lbl.visible then s:='Player 1' else s:='Player 2';
               showmessage(s+', you took the last tile and are the winner.  Congratulations!!');
              end;
            end
            else
            begin  {orthogonal error,}
              beep;
              board[acol,arow]:=saveval; {invalid move, replace the tile}
              {in case first click is invalid, let the player choose another}
              if firstclick then lastcolor:=0;
            end;
          end
          else
          begin {open sides error}
            beep;
           if firstclick then lastcolor:=0;
          end;
        end;
      end
      else {clicked on an empty square, turn ends}
      begin
        inc(movecount);
        with Player1Lbl do visible:=not visible;
        Player2Lbl.visible:=not player1Lbl.visible;
        setPalplayerLabel;
        P1Rect.brush.color:=clwhite;
        P2Rect.brush.color:=clwhite;
        lastcolor:=0;
      end;
    end
  end;
end;

{***************** SearchBtnClick ************}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Puzzle2 solution search button clicked}
{Search proceeds from left to right and top to bottom, so we only need to
   check that the tile being placed does not match two neigbhors to the left
   and above the cell being filled}
var
  i,j:integer;
  r:boolean;
  msg:string;
  OK:boolean;
begin
  if searchbtn.caption='STOP' then
  begin {interrupt the search}
    tag:=1;
    searchbtn.caption:='Search';
    exit;
  end;
  tag:=0;
  nbrcolors:=8;
  Initboard(PuzzlePlayGrid);
  nbrtrials:=0;
  solvedlbl.Visible:=true;
  SearchBtn.Caption:='STOP';
  Solvedlbl.caption:='Searching';
  Solvedlbl.update;
  screen.Cursor:=crhourglass;
  if randomgrp.itemindex mod 2 =1 then
  begin {we will be showing colors}
    shuffle(colors);

    {option 2: place random but legal colors}
    board[0,0]:=colors[random(n)];
    PuzzleSearchGrid.cells[0,0]:=inttostr(board[0,0]);
    inc(usedCounts[board[0,0]-1]);
    i:=1;
    while i<=n do
    begin
      {for 1st row, color cannot match the 2 preceding neighbors
       or the top left corner}
      repeat
        j:=random(n);
        OK:= (colors[j]<>board[i-1,0]);
        if i>1 then OK:=OK and (colors[j]<>board[i-2,0]);
        OK:=OK and (colors[j]<>board[0,0]);
      until  OK;
      board[i,0]:=colors[j];
      PuzzleSearchGrid.cells[i,0]:=inttostr(board[i,0]);
      inc(usedCounts[colors[j]-1]);
      inc(i);
    end;
    r:=placecolor(0,1); {startsearch from row 1}
  end
  else r:=placecolor(0,0);

  {make a final transfer of values from board to grid}
  for i:=0 to n do
  for j:=0 to n do

  if randomgrp.itemindex=0
  then  PuzzleSearchGrid.cells[i,j]:=inttostr(board[i,j])
  else PuzzleSearchGrid.cells[i,j]:=inttostr(colors[board[i,j]-1]);
  if r then msg:='Solution' else msg:='No solution';
  solvedlbl.Caption:=format('%s found after %.0n trials',[msg,0.0+nbrtrials]);
  screen.cursor:=crdefault;
  searchbtn.caption :='Search';
end;



{************* PlaceColor *************}
function TForm1.PlaceColor(c,r:integer):boolean;
{for recursive solution search for Puzzle 2}
var
  i:integer;
begin
  if tag=1 then exit;
  inc(nbrtrials);
  if board[c,r]=0 then
  for i:= 1 to nbrcolors do
  begin
    if validneighbors(c,r,i) then
    begin
      board[c,r]:=i;  {try this color}
      inc(usedcounts[i-1]);
      if progressbox.Checked then
      begin
         PuzzleSearchGrid.cells[c,r]:=inttostr(i);
        if nbrtrials and $FFF=0 then
        begin
          solvedLbl.caption:=format('%.0n',[0.0+nbrtrials]);
          application.ProcessMessages;
        end;
      end;
      if c<n then result:=placecolor(c+1,r)
      else if r<n then result:=placecolor(0,r+1)
      else
      begin
        result:=true;
        exit;
      end;
      if result  then break;
      board[c,r]:=0;
      dec(usedcounts[i-1]);
      if progressbox.Checked then PuzzleSearchGrid.cells[c,r]:='';
    end;
  end;
end;


{*********** ValidNeighbors **************}
function TForm1.validneighbors(c,r,i:integer):boolean;
{Called by PlacePiece function to see if a tile with color "i" can be placed at(c,r)}
var
  j:integer;
  cx,ry,cx2,color:integer;
begin
  if  (usedcounts[i-1]>=nbrcolors) or
      (((c=0) or (c=n)) and ((r=0) or (r=n))) {a corner}
  and ((board[0,0]=i) or(board[0,n]=i) or (board[n,0]=i) or (board[n,n]=i))
  then
  begin   {duplicate corners not alowed}
    result:=false;
    exit;
  end;

  result:=true;
  for j:=0 to nbrcolors do neighbors[j]:=0;
  for j:=1 to 4 do
  begin  {Left,right,up,down must all be different and not = trial value "i"}
    cx:=c+ox[j];
    ry:=r+oy[j];
    if (cx>=0) and (cx<=n) and (ry>=0) and (ry<=n) then
    begin  {adjacent is in bounds}
      color:=board[cx,ry];
      if (color>0) then inc(neighbors[color]);
      if (color=i) or (neighbors[color]>1) then
      begin
        result:=false;
        break;
      end
    end;
  end;
  if result then
  begin    {one more check}
    cx:=c-1; ry:=r-1;
    cx2:=c+1;
    if  (ry>=0) then
    begin {Neither upper diagonal can = the candidate value}
      if ((cx>=0) and (board[cx,ry]=i))
      or ((cx2<=n) and (board[cx2,ry]=i))
      then result:=false;
    end;
  end;
end;

{***************** StringGridDrawCell ***************}
procedure TForm1.StringGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw cells colors depending on value in the cell}
{Draws tiles for either of the 2 "play" grids: Palettogrid and PuzzlePlayGrid}
begin
  with TstringGrid(sender), canvas do
  begin
    if cells[acol,arow]='0' then canvas.brush.color:=clWhite
    else  canvas.brush.color:=colorchoices[board[acol,arow]];
    canvas.rectangle(rect);
  end
end;

{************ PuzzleSearchgridDrawCell *************}
procedure TForm1.PuzzleSearchgridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
{Draw cells with numbers or colors depending on search option set}
  var k:integer;
begin
  if pagecontrol1.activepage=Solver2Sheet then
  with TstringGrid(sender), canvas do
  begin
    k:=strtointdef(cells[acol,arow],0);
    case randomgrp.itemindex of
    0,1:
       begin
         brush.color:=clwhite;
         rectangle(rect);
         if randomgrp.itemindex=0
         then textout(rect.left+4,rect.top+4,cells[acol,arow])
         else textout(rect.Left+4,rect.Top+4,inttostr(colors[k-1]));
       end;
    2,3:
       begin   {draw a colored square}
         if k>0 then
         begin
           if randomgrp.ItemIndex=2 then brush.color:=colorchoices[k] {the kth choice}
           else brush.color:=colorchoices[colors[k-1]]; {the color indexed by kth randomized choice}
         end
         else brush.color:=clWhite;
         rectangle(rect);
       end;
    end;
  end

end;
(*
{**************** RotateGrid ************}
procedure Tform1.rotategrid(t:integer);
var
  temp:array of array of string;
  i,j,k:integer;
begin
  setlength(temp,n+1,n+1);
  for k:=0 to t do
  begin
    for j:=0 to n do
    for i:= 0 to n do
    temp[n-j,i]:=PuzzlePlayGrid.cells[i,j];
    for i:=0 to n do
    for j:=0 to n do
    PuzzlePlayGrid.cells[i,j]:=temp[i,j];
  end;
end;
*)

{********** PageControl1Change ************}
procedure TForm1.PageControl1Change(Sender: TObject);
begin
  solvedlbl.visible:=false;

  If pagecontrol1.activepage=PalettoSheet then
  begin
    sizegrpclick(sender);
    initboard(PalettoGrid);
    palettobtnclick(sender);
  end
  else If pagecontrol1.activepage=Puzzle2Sheet then
  begin
    nbrcolors:=8;
    initboard(PuzzlePlayGrid);
    initgrid2;
  end
  else If pagecontrol1.activepage=Solver2Sheet then
  begin
    nbrcolors:=8;
    initboard(PuzzlePlayGrid);
    solvedlbl.visible:=false;
  end
end;

{*********** InitGrid2 **********}
procedure TForm1.Initgrid2;
var
  i:integer;
begin
  nbrcolors:=8;
  n:=nbrcolors-1;
   with StockPileGrid do
  for i:=0 to n do
  begin
    cells[i,0]:=inttostr(nbrcolors);
    cells[i,1]:=inttostr(i);
  end;
  StockPileGrid.invalidate;

end;

{***************** StockPileGridDrawCell **************}
procedure TForm1.StockPileGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var k:integer;

begin
  with TStringgrid(sender), canvas do
  begin
    brush.Color:=color;
    if Arow=0 then
    begin
      rectangle(rect);
      textout(rect.left+4,rect.top+4,cells[acol,Arow]);
    end
    else
    begin
      k:=strtointdef(cells[acol,arow],-1);
      if k>=0 then brush.Color:=colorchoices[k+1];
      rectangle(rect);
    end;
  end;
 end;

{************** StockPileGridMouseUp **************}
procedure TForm1.StockPileGridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ACol, ARow: integer;
  k:integer;
  r:Trect;
begin
  with TStringgrid(sender) do
  begin
    if dragcolor>0 then
    begin

      acol:=dragcolor-1;  {drag column nbr is 1 less than the drag color number}
      r:=cellRect(Acol,1); {the rectangle containing the color}
      {move the mouse to the center of this rectangle}
      with r do mouse.cursorpos:=clienttoscreen(point((left+right) div 2, (top+bottom) div 2));
      k:=strtoint(cells[Acol,0]); {the number of tiles in the pile}
      inc(k);  {add the dropped tile back to count}
      cells[Acol,0]:=inttostr(k); {save it}
      screen.cursor:=crDefault;
      dragcolor:=0;

    end
    else
    begin
      MouseToCell(X, Y, ACol, ARow);
      k:=strtoint(cells[Acol,0]);
      dec(k);
      cells[Acol,0]:=inttostr(k);
      dragcolor:=Acol+1;
      screen.cursor:=acol+1;
    end;
  end;
end;

{************ PalettoBtnClick ***********}
procedure TForm1.PalettoBtnClick(Sender: TObject);
(*
Aim of the Game

The game is won by the player who either takes all 6 pieces of any color or whoever takes the last piece from the board.

How to Play

Players take turns. In each turn a player chooses a color, then removes any number of same-colored pieces (not necessarily all) from the board and puts them in front of him.

A piece may be removed from the board if
 •there are no adjacent pieces on two sides (at start only the corner pieces may be taken – see Fig. 2),
•and all remaining pieces are still connected horizontally and vertically after the move (Fig. 3).
*)

var
  i,j:integer;
  deck:array of integer;
  c1,c2,c3,c4:integer;
  OK:boolean;
  count:integer;
begin
  setlength(deck, nbrcolors*nbrcolors);
  n:=nbrcolors-1;
  for i:=0 to nbrcolors*nbrcolors-1 do deck[i]:=i mod nbrcolors + 1;
  count:=0;
  screen.cursor:=crHourglass;
  repeat
    shuffle(deck);
    c1:=deck[0];
    c2:=deck[n];
    c3:=deck[n*nbrcolors];
    c4:=deck[nbrcolors*nbrcolors-1];
    if (c1<>c2) and (c1<>c3) and (c1<>c4)
       and (c2<>c3) and (c2<>c4) and (c3<>c4) then OK:=true
     else OK :=false;
     if OK then
     begin
       if (i=high(deck)) and (deck[i-1]=deck[i]) then OK:=false
       else
       for i:= 0 to high(deck)-1 do
       begin
         {<>next}
         if ((i mod nbrcolors)<nbrcolors-1) and (deck[i+1]=deck[i]) then ok:=false
         else
         if (i < high(deck)-nbrcolors) and (deck[i+nbrcolors]=deck[i]) then ok:=false;
         if not OK then break;
       end;
     end;
     inc(count);
   until OK;
   screen.cursor:=crdefault;
   label1.caption:=format('%.0n',[0.0+count]);
   for i:= 0 to n do
   for j:= 0 to n do
   begin
     board[i,j] := deck[nbrcolors*i+j];
     PalettoGrid.cells[i,j]:=inttostr(board[i,j]);
   end;

  for j:= 0 to n do
  begin
    with stringgrid3 do
    begin
      cells[0,j]:='0';
      cells[1,j]:=inttostr(j+1);
    end;
    with stringgrid4 do
    begin
      cells[0,j]:='0';
      cells[1,j]:=inttostr(j+1);
    end;
  end;

  (*
  randomgrp.ItemIndex:=3;
  searchbtnclick(sender);
  PuzzlePlayGrid.update;
  *)
  movecount:=0;
  tilecount:=0;
  lastcolor:=0;
  Player1lbl.visible:=true;
  SetPalPlayerlabel;
end;

{******************* StringGrid3DrawCell *************}
procedure TForm1.StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var k:integer;
begin
  with TStringgrid(sender), canvas do
  begin
    brush.Color:=color;
    if Acol=0 then
    begin
      rectangle(rect);
      textout(rect.left+4,rect.top+4,cells[acol,Arow]);
    end
    else
    begin
      k:=strtointdef(cells[acol,arow],-1);
      if k>=0 then brush.Color:=colorchoices[k];
      rectangle(rect);
    end;
  end;
end;

{************** FormDestroy ***********}
procedure TForm1.FormDestroy(Sender: TObject) ;
var
  i:integer;
 begin
    for i:=1 to nbrcolors do DestroyIcon(Screen.Cursors[i]) ;
 end;


{************* SizegrpClick *********8}
procedure TForm1.SizegrpClick(Sender: TObject);
{Change size of Paletto board}
begin
  if Sizegrp.itemindex=0 then nbrcolors:=6
  else nbrcolors:=8;
  Initboard(PalettoGrid);
  stringgrid3.rowcount:=nbrcolors;
  stringgrid4.rowcount:=nbrcolors;
  PalettoBtnClick(sender);  {set up a new game}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;





end.
