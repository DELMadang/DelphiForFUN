unit U_AllKnightsTours;
{Copyright  © 2000-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



(*

This program checks for tours from all possible starting positions to each
valid ending position for that start.  I know of no way to "prove" that a tour
starting from one color square and ending on another square of the opposite color
is impossible.  So all we can do is testing a few (up to a million) possible
tours and see if a solution is found.  The algorithm used here is the Warnsdorf
which works well in most, but not all cases.  A future update may recognize
warnsdorf failures and try other, more robust, heuristics.

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, stdctrls, ComCtrls, ExtCtrls, Spin, Contnrs;

Const
  {These are the offsets from current locations to all 8 valid knight moves}
  Offsets: array[1..8] of Tpoint= ((x:-2;y:-1),(x:-2;y:+1),(x:-1;y:-2),(x:-1;y:+2),
                                   (x:+1;y:+2),(x:+1;y:-2),(x:+2;y:+1),(x:+2;y:-1)
                                  );
type

  TConstraint=record
    movenbr,col,row:integer;
  end;

  TStatsrec = record
    solved,notsolved,tried,nottried:integer;
    txt:string;
  end;


  TBoard=class(TStringGrid)
   Private
     b: array of array of integer;
     moves:array of TPoint;  {array of moves made}
     size:integer;  {board size}
     manualplay:boolean; {true=user plays}
     movecount:integer;  {nbr of moves made}
     totmoves:integer;  {total moves tried, counting moves taken back }
     delay:integer; {ms to wait between moves when autosolving}
     closedtour, movespecified:boolean;
     movetospecified:integer;
     endcol,endrow:integer;
     prevcol,prevrow:integer;
     constraintcount:integer;
     constraint:array of TConstraint;
     highmove:integer;
     minmove:integer;
     moveoffset:integer;
     {These next are used to display the moves in the order requested by
     the user even though we may be solving the board after rotations and/or
     in the reverse direction}
     reversed:boolean;  {the board is being solved in reverse direct}
     rotatedcount:integer;
     function displaycol:integer; {converts col to the user view}
     function displayrow:integer; {converts row to the userrow}
     function displaymovecount:integer;
     constructor create(Aowner:TComponent;
                       newsize:integer;
                       newlocrect:Trect );  reintroduce;
     procedure DrawAcell(Sender: TObject; ACol, ARow: Integer;
                          Rect: TRect; State: TGridDrawState);
     procedure Clicked(Sender:Tobject);
     function  IsValidMove(newcol,newrow:integer):boolean;
     procedure MakeMove(newcol,newrow:integer);
     function  Canundo:boolean;
     procedure UndoMove;
     function  PossibleMoves(newcol,newrow:integer):integer;
     function  SolveFrom(newcol,newrow:integer):boolean;

  end;

  Tf = class(TForm)
    StaticText1: TStaticText;
    OpenDialog1: TOpenDialog;
    Moveslbl: TLabel;
    Label12: TLabel;
    Gamelevel: TLabel;
    SolvingPanel: TPanel;
    Label1: TLabel;
    Speedbar: TTrackBar;
    StopBtn: TButton;
    stopallBtn: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    StartEdt: TEdit;
    Label4: TLabel;
    EndEdt: TEdit;
    Find1Btn: TButton;
    GroupBox2: TGroupBox;
    StringGrid1: TStringGrid;
    FindAllBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedbarChange(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FindAllBtnClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure stopallBtnClick(Sender: TObject);
    procedure Find1BtnClick(Sender: TObject);
  public

    board:TBoard;
    colvalue,rowValue:integer;
    adding:boolean;
    statsrec:TStatsrec;
    cells:array[0..2,0..2] of string;
    Procedure makeboard(newrotated:integer;newreversed:boolean);
    function bulksolve(newrotated:integer; newreversed:boolean):boolean;
    function TryAllWays(col1,row1,col2,row2:integer;
                            var statsrec:TStatsrec):boolean;
  end;
var
  f: Tf;

implementation

{$R *.DFM}
var
  maxmoves:integer=1000;


{****************** Rotate90 ***********}
function Rotate90(ntimes,size,col,row:integer):TPoint;
begin
  with result do
  case ntimes mod 4 of
    0: begin
         x:=col;
         y:=row;
       end;
    1: begin
         x:=size-1-row;
         y:=col;
       end;
    2: begin
         x:=size-1-col;
         y:=size-1-row;
       end;
    3: begin
         x:=row;
         y:=size-1-col;
       end;
  end; {case}
end;


{****************** TBoard Methods ********************}


{************** Create **************}
Constructor TBoard.create(Aowner:TComponent;
                       newsize:integer;
                       newlocrect:Trect
                       );
var   i,j:integer;
begin

   inherited create(Aowner);
   if Aowner is TWinControl
   then parent:=TWincontrol(Aowner);
   scrollbars:=ssNone;
   size:=newsize;
   colcount:=size; fixedcols:=0;
   rowcount:=size; fixedrows:=0;
   top:=newlocrect.top;
   left:=newlocrect.left;
   width:=newlocrect.right-left;
   defaultcolwidth:= (width-size) div size-1;
   defaultrowheight:=defaultcolwidth;
   width:=(defaultcolwidth+1)*size+3; {trim width to fit squares}
   height:=width;
   setlength(b,size,size);
   setlength(constraint, size*size+1);
   {initialize board to zeros}
   for i:= 0 to size-1 do for j:= 0 to size-1 do  b[i,j]:=0;
   setlength(moves,size*size+1);
   movecount:=0;
   totmoves:=0;
   highmove:=0;
   constraintcount:=0;
   moveoffset:=0;
   minmove:=1;
   OnDrawCell:=DrawACell;
   OnClick:=Clicked;
   canvas.font.size:=12;
   canvas.font.name:='Courier'; {fixed font size}
   doublebuffered:=true;
end;

var
  collbl:array[0..7] of char=('A','B','C','D','E','F','G','H');
  ROWLBL:ARRAY[0..7] OF CHAR=('1','2','3','4','5','6','7','8');

{************** DrawACell ****************}
procedure TBoard.DrawACell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
 {OnDrawcell exit}
var
  i,j:integer;
  s:string;
  offsetx,offsety:integer;
  txtsize:TSize;
begin
  i:=acol;
  j:=arow;
  with Sender as TBoard do
  begin
    {make chessboard coloring }
    if (i mod 2) = (j mod 2)  {odd row&column or even row&column}
    then Canvas.Brush.Color := clsilver
    else canvas.brush.color:=clblack;
    Canvas.FillRect(Rect);

    with canvas do
    begin
       if (i mod 2) = (j mod 2) then font.color:=clblack
      else font.color:=clwhite;
      {add cell labels};
      font.size:=8;
      with rect do textout(rect.left+1, rect.top+1,
                          collbl[i]+rowlbl[j]);



      if b[i,j]>0
      then
      begin
        font.style:=[fsbold];
        {If we solved starting from a user specified move other than move 1,
          moveoffset is the amount to adjust the internal move number used by
          the program to the external move numbers seen by the user.}
        //movenumber:= (b[i,j]+moveoffset-1) mod (size*size);



        {For large boards, use a smaller font}
        s:=cells[acol,arow]; {format('%3d',[movenumber mod (size*size) + 1]);}
        If size>8 then font.size:=10 else font.size:=12;
        txtsize:=textextent(s);
        with txtsize, rect do
        begin
          offsetx:=((right-left)-cx) div 2;
          offsety:=((bottom-top)-cy) div 2;
        end;
        textout(rect.left +offsetx , rect.top+offsety,s);
      end;
    end;
  end;
end;

{********* Clicked ********}
Procedure TBoard.clicked;
{User clicked a cell}
begin
  if not manualplay then exit;
  If isValidmove(col,row) then makemove(col,row)
  else if canundo then undomove
  else beep;
end;

{************* IsValidMove **************}
function TBoard.IsValidMove(newcol,newrow:integer):boolean;

  {There are 8 possible move positions
   relative to lastmove location. They are
    col   row
    ---   ---
     -2    +1
     -2    -1
     -1    -2
     -1    +2
     +1    +2
     +1    -2
     +2    +1
     +2    -1
   }
   {To be valid, col+newcol and row+newrow must match one of these
    and board must be unoccupied at that location}

var
  i,j:integer;
  test:Tpoint;
  OK:boolean;
  pcol,prow:integer;
begin
  If (newcol<0) or (newcol>=size) or (newrow<0) or (newrow>=size)
  then OK:=false   {target not even on the board}
  else
  If movecount=0 then OK:=true {1st move can be to anywhere}
  else
  begin   {get previous move}
    test.x:=moves[movecount].x-newcol;
    test.y:=moves[movecount].y-newrow;
    OK:=false;
    for i:=  1 to 8 do  {to be OK, it has to be to valid knight move location}
    if (test.x=offsets[i].x)  and (test.y=offsets[i].y) then
    begin
      OK:=true;
      break;
    end;
    {and location has to be unoccupied}
    If OK then
    begin
      if (b[newcol,newrow]<>0) then OK :=false
    end  ;
    if OK and movespecified then
    begin
      for j:=1 to Constraintcount do
      if constraint[j].movenbr>0 then
      with constraint[j] do
      begin
        movetospecified:=movenbr;
        endcol:=col-1;
        endrow:=row-1;
        if (movecount<movetospecified-1){not specified move, -1 because movecount hasn't been updated yet}
        then
        {this is not the specified move, so make sure that there is a valid next move from here}
        begin
          ok := false;
          if not ((newcol=endcol) and (newrow=endrow)) then
          for i:= 1 to 8 do
          begin
            pcol:=endcol+offsets[i].x;
            prow:=endrow+offsets[i].y;
            if (pcol>=0) and (pcol<size) and (prow>=0)and(prow<size) and (b[pcol,prow ]=0)
            then
            begin
              Ok:=true;
              break;
            end;
          end
          {attempt to move to a constrained location but not the correct move #}
          else OK:=false;
        end
        else if OK and (movecount=movetospecified-1) then
        begin
           if not ((newcol=endcol) and (newrow=endrow)) then OK:=false;
        end;
        if not OK then break;
      end;
    end;
  end;
  result:=OK;
end;



{*************** Solvefrom ***************}
Function TBoard.solvefrom(newcol,newrow:integer):boolean;
{generate all possible next moves, and count the number of next moves from
     each position.  Pick one with lowest value and move there}
    {If the lowest number of next moves is 0 and that would not be the
    last move then this is a bad path. Need to backtrack and try another path
    - continue until solved or all paths have been tried}
type
  TMoverec = record
    pcol,prow,nbrmoves:integer;
    distfromstart:single;
  end;
var
  possibles:array [1..8] of TMoveRec;
  i:integer;

  function dist(col,row:integer):single;
  begin
    result:=sqr(moves[1].x-col)+sqr(moves[1].y-row);
  end;

  {-------- Sortmoves ---------}
  Procedure sortmoves;
  {sort the possible moves by increasing next move count
   then by distance from staring position}
  var
    i,j:integer;

    procedure swap(i,j:integer);
      var Hrec:TMoverec;
      begin
        Hrec:=possibles[i];
        possibles[i]:=possibles[j];
        possibles[j]:=hrec;
      end;

  begin
    begin
      for i:= 1 to 7 do
      for j:= i+1 to 8 do
      If possibles[i].nbrmoves>possibles[j].nbrmoves
      then swap(i,j)
      else if (possibles[i].nbrmoves=possibles[j].nbrmoves) and
               (possibles[i].distfromstart>possibles[j].distfromstart)
      then swap(i,j);
    end;
  end; {Sortmoves}

  begin  {Solvefrom}
  {Update display and wait awhile}
  if delay>0 then
  begin
    application.processmessages;
    sleep(delay);
  end
  else if totmoves and $fff=0 then
  begin
    application.processmessages; {max speed}
  end;

  {Done?}
  result:=false;
  If movecount=size*size then
  begin
    result:=true;
  end;
  If not result then
  {If not, then generate next moves for all possible moves from here}
  begin
    If totmoves>maxmoves then exit;
    for i:= 1 to 8 do
    with possibles[i] do
    begin
      pcol:=newcol+offsets[i].x;
      prow:=newrow+offsets[i].y;
      nbrmoves:=PossibleMoves(pcol,prow);
      {if no moves possible from this location,
       then make sure it sorts to end of array.
       Not really necessary, just saves the time of
       checking and rejecting those cases
      }
      if nbrmoves=0 then nbrmoves:=size+1
      else distfromstart:=dist(pcol,prow);;
    end;
    {Sort them by increasing possible moves - Warnsdorff heuristic}
    sortmoves;
    {Now, run through all the possibilities
       - making recursive call for valid ones}
    {backtrack by calling undomove for paths that don't work}
    i:=1;
    while (i<=8) and (tag=0) do
    with possibles[i] do
    begin
      If isvalidmove(pcol,prow) then
      begin
        makemove(pcol,prow);
        inc(totmoves);
        if delay>0 then
        begin
          f.moveslbl.caption:='Total moves tried: '+inttostr(totmoves+1)
                          +' Highest move:'+inttostr(highmove);
          f.moveslbl.update;
        end;
        if solvefrom(pcol,prow) then
        begin
          result:=true;

          break;
        end
        else if not manualplay then begin undomove; {beep;} end;
      end;
      inc(i);
    end;
  end;
end;


{************** MakeMove ************}
Procedure TBoard.makemove(newcol,newrow:integer);
{make a move}
begin
  prevcol:=col;
  prevrow:=row;
  col:=newcol;
  row:=newrow;
  inc(movecount);   {count the move}
  if movecount>highmove then
  begin
    highmove:=movecount;
  end;
  {add move to moves array}
  with moves[movecount] do
  begin
    x:=col;
    y:=row;
  end;
  {fill in the move number to board and display}
  b[col,row]:=movecount;

  cells[displaycol,displayrow]:=inttostr(displaymovecount);
end;


{********** canUndo ********}
Function TBoard.Canundo:boolean;
begin
  result:=(b[col,row]=movecount); {can only undo last move}
end;

{********** UndoMove *************}
Procedure TBoard.UndoMove;
{undo a move}
begin
  If movecount>0 then
  with moves[movecount] do
  begin
    b[x,y]:=0;  {0 the board cell}
    col:=x;
    row:=y;
    cells[displaycol,displayrow]:=''; {blank the display cell}
    dec(movecount); {decrease the count}
    col:=prevcol;
    row:=prevrow;
  end;
end;

{************** Possiblemoves ***************}
Function TBoard.possiblemoves(newcol,newrow:integer):integer;
{ Return a count of valid moves from this location}
     function isEmpty(c,r:integer):boolean;
     begin
       result:=(c>=0) and (c<size) and (r>=0) and (r<size) and (b[c,r]=0);
     end;

var
  i,count:integer;
begin
  count:=0;
  If Isempty(newcol,newrow) then
  begin
    //makemove(newcol,newrow);  {make the trial move}
    for i:= 1 to 8 do  {count how many next moves exist}
      if isempty(newcol+offsets[i].x, newrow+offsets[i].y) then inc(count);
    //undomove;  {and undo the move}
  end;
  result:=count;
end;

    //reversed:boolean;  {the board is being solved in reverse direct}
   //  rotatedcount:integer;
function TBoard.displaycol:integer; {converts col to the user view}
//var
  //p:TPoint;
begin
   result:=col;
   case rotatedcount of
    3: begin
         result:=size-1-row;
       end;
    2: begin
         result:=size-1-col;
       end;
    1: begin
         result:=row;
       end;
  end; {case}
end;

function TBoard.displayrow:integer; {converts row to the userrow}
begin
    result:=row;
    case rotatedcount of
    3: result:=col;
    2: result:=size-1-row;
    1: result:=size-1-col;
  end; {case}
end;

function TBoard.displaymovecount:integer;
begin
  if reversed then result:=65-movecount else result:=movecount;
end;

{******************** Form Methods *******************}

{************ FormCreate **********}
procedure Tf.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  randomize;
  board:=nil;
  begin
    cells[0,0]:='Move';
    cells[1,0]:='Col';
    cells[2,0]:='Row';
    for i:=0 to 2 do for j:=1 to 2 do cells[i,j]:='0';
  end;
  with panel1 do
  board:=TBoard.create(self,8,rect(left,top,left+width,top+height));
  makeboard(0,false);
  solvingpanel.bringtofront;
  doublebuffered:=true;
end;

{****************** MakeBoard ***********}
Procedure Tf.makeboard(newrotated:integer; newreversed:boolean);
var i,j:integer;
begin
  with board do
  begin
    for i:= 0 to size-1 do for j:= 0 to size-1 do  b[i,j]:=0;
    setlength(moves,size*size+1);
    movecount:=0;
    totmoves:=0;
    highmove:=0;
    constraintcount:=0;
    moveoffset:=0;
    minmove:=1;
    canvas.font.size:=12;
    canvas.font.name:='Courier'; {fixed font size}
    rotatedcount:=newrotated;
    reversed:=newreversed;

    delay:=speedbar.max-speedbar.position;
    highmove:=1;
    parent:=self;

    {set up constraints}
    constraintcount:=2 {stringgrid1.rowcount-1};
    for i:=1 to size*size do constraint[i].movenbr:=0;
  end;
  for i:= 1 to 2 do
  begin
    with board.constraint[i] do
    begin
      movenbr:=strtoint(cells[0,i]);
      col:=strtoint(cells[1,i]);
      row:=strtoint(cells[2,i]);
    end;
  end;
end;

function quadrant(col,row:integer):integer;
{return quadrant for (col,row) indexed relative to 0}
begin
  if col<=3 then {quadrant is 1 or 3}
  begin
    if row<=3 then result:=1 else result:=3;
  end
  else
  begin
    if row<=3 then result:=2 else result:=4;
  end;
end;

(*
function shape(col,row:integer):integer;
var n:integer;
begin
  n:=4*(row mod 4)+(col mod 4);
  case n of
     0,6,9,15: result:=0;  {left diamond}
     1,7,8,14: result:=1; {right square}
     3,5,10,12: result:=2;  {right diamond}
     2,4,11,13:  result:=3;  {left square}
     else result:=-1;
  end;
end;
*)




{************* BulkSolve*************}
function Tf.Bulksolve(newrotated:integer; newreversed:boolean):boolean;
{Compute solution -
 Start at a location and try all paths - backtrack on those
 that don't work - until solution is found.

 Uses Warnsdorf heuristic - when a choice of moves is available,
  choose the one that has the fewest next moves
 }
var
  j:integer;
  startfound:boolean;
begin
  result:=false;
  if board.tag>1 then exit;  {user requested close}

  makeboard(newrotated,newreversed);

  board.manualplay:=false;
  board.closedtour:=false;
  board.movespecified:=true;


  {make a test for valid start & end points if both specified}
  board.moveoffset:=0;
  with board do
  begin
    startfound:=false;
    minmove:=100;
    for j:= 1 to constraintcount do
    with constraint[j] do
    begin
      if movenbr=1 then
      begin
        colvalue:=col;
        rowvalue:=row;
        startfound:=true;
        break;
      end
      else if movenbr<minmove then  {keep track of lowest constrained move number}
      begin
        minmove:=movenbr;
        colvalue:=col;
        rowvalue:=row;
      end;
    end;

    if not startfound then
    begin
      moveoffset:=minmove-1;
      for j:=1 to constraintcount do
      with constraint[j] do movenbr:=movenbr-moveoffset;
    end;
    for j:= 1 to constraintcount do
    with constraint[j] do
    if  movenbr>0 then
    begin
      movetospecified:=movenbr;
      endcol:=col;
      endrow:=row;

      if (movetospecified) mod 2 = 0 then
      if (colvalue + rowvalue - endcol - endrow) mod 2 = 0
      then
      begin
        showmessage('No solution possible'
                 + #13 +'Start and move '+inttostr(movenbr)+ ' must not be the same color');
        exit;
      end
      else
      else
      if (Colvalue+rowValue - board.endcol-board.endrow) mod 2 = 1
      then
      begin
        showmessage('No solution possible'
                 + #13 +'Start and move '+inttostr(movenbr)+' squares must be the same color');
        exit;
      end
      else
      if (ColValue=board.endcol+1) and (rowValue =board.endrow+1)
      then
      begin
        showmessage('No solution possible'
                 + #13 +'You know you can''t do that!!');
        exit;
      end
    end;
  end;
  with board do
  begin   {finally, try to solve}
    if tag>1 then exit;  {user requested close}
    moveslbl.caption:='';
    makemove(Colvalue-1, Rowvalue-1);
    result:=solvefrom(col,row);


  end;
end;

{***************** SpeedbarChange **********}
procedure Tf.SpeedbarChange(Sender: TObject);
{set new ms delay between moves}
begin
  with speedbar do board.delay:=max-position;
end;

{**************** StopbtnClick ***********}
procedure Tf.StopBtnClick(Sender: TObject);
{set stop flag}
begin
  board.tag:=1;
end;

{*************** FCormCloseQuery **************}
procedure Tf.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   board.tag:=2; {stop all, in case we're solving}
   canclose:=true;
end;


{************** FormActivate **************}
procedure Tf.FormActivate(Sender: TObject);
//var
//  i,j:integer;
begin
  opendialog1.initialdir:=extractfilepath(application.exename);
  speedbar.position:=900;
  board.Invalidate;
  with stringgrid1 do
  begin
    cells[0,0]:='1';
    cells[1,0]:='2';
    cells[0,1]:='3';
    cells[1,1]:='4';
  end;
  radiogroup1click(sender);  {initialize maxmoves counter}
end;

 function Tf.TryAllWays(col1,row1,col2,row2:integer;
                            var statsrec:TStatsrec):boolean;
 

        {------------- TryreverseSolve ----------}
     function tryreverseSolve(newstart,newend:TPoint):boolean;
     begin
       begin
         cells[1,1]:=inttostr(newend.x+1);
         cells[2,1]:=inttostr(newend.y+1);
         cells[1,2]:=inttostr(newstart.x+1);
         cells[2,2]:=inttostr(newstart.y+1);
       end;
       gamelevel.caption:=format('Tour #%d: Checking from %s to %s (reversed)',
                                 [statsrec.tried,
                                 collbl[newend.x]+rowlbl[newend.y],
                                 collbl[newstart.x],rowlbl[newstart.y]]);
       result:=bulksolve(0,true);
     end;

     {------------- TryRotateSolve ----------------}
     function TryRotateSolve(newStart,newEnd:TPoint):boolean;
     var
       i:integer;
       solved:boolean;
     begin
       for i:= 1 to 3 do
       begin
         newstart :=rotate90(1,8,newstart.x,newstart.y);
         newEnd   :=rotate90(1,8,newend.x,newend.y);
         cells[1,1]:=inttostr(newstart.x+1);
         cells[2,1]:=inttostr(newstart.y+1);
         cells[1,2]:=inttostr(newend.x+1);
         cells[2,2]:=inttostr(newend.y+1);
         gamelevel.caption:=format('Tour #%d: Checking from %s to %s (rotated %d)',
                    [statsrec.tried, collbl[newstart.x]+rowlbl[newstart.y],
                                 collbl[newend.x]+rowlbl[newend.y],90*i]);
         solved:=bulksolve(i,false);
         with memo1, lines do
           if i>0 then statsrec.txt:='after Rotate ' +inttostr(90*i) + ' degrees ';
         if solved then break
         else
         begin {rotate did not help}
           {try reverse direction}
           {swap start and end points}
           cells[1,1]:=inttostr(newend.x+1{col2+1});
           cells[2,1]:=inttostr(newend.y+1{row2+1});
           cells[1,2]:=inttostr(newstart.x+1{col1+1});
           cells[2,2]:=inttostr(newstart.y+1{row1+1});
           gamelevel.caption:=format('Tour #%d: Checking from %s to %s (rotated %d & reversed)',
                                 [statsrec.tried,
                                 collbl[newend.x]+rowlbl[newend.y],
                                 collbl[newstart.x]+rowlbl[newstart.y],
                                 90*i]);
           solved:=bulksolve(i,true);;
           if solved then
           begin
             statsrec.txt:=statsrec.txt+ '  Reverse direction';
             break;
           end;
         end;  {try reverse direction}
       end;
       result:=solved;
     end;

 VAR
   P1,P2:INTEGER;
   TRYMOVES:INTEGER;
   NEWSTART,NEWEND:TPOINT;

 begin {TryAllWays}
    p1:=(col1+row1) mod 2;
    p2:=(col2+row2) mod 2;
    board.tag:=0;
    result:=false;
    if p1 <> p2 then  {square colors must be different for a solution to exist}
    begin
      inc(statsrec.tried);  {try all except the quadrant 1 points which have the end
                    point same as start}

      gamelevel.caption:=format('Tour #%d: Checking from %s to %s',
                                 [statsrec.tried, collbl[col1]+rowlbl[row1],
                                  collbl[col2]+rowlbl[row2]]);

      {for better efficiency, start with a minimal search limit (10% of max)}
      {if a solution is found, we have avoided going to maxmoves limit for
       methods do not find a tour}
      trymoves:=maxmoves div 10;
      while (trymoves<=maxmoves) and (not result) do
      begin
        newstart:=point(col1,row1);
        newend:=point(col2,row2);
        result:=bulksolve(0,false); {try normal solve}

        statsrec.txt:='';
        if not result then
        begin  {normal search failed,  try in reverse direction}
          //newstart:=point(col2,row2);
          //newend:=point(col1,row1);
          result:=tryReverseSolve(newend,newstart);
        end;
        if not result then
        begin {finally try rotaions in forward and reverse directions}
          //newstart:=point(col1,row1);
          //newend:=point(col2,row2);
          result:=tryRotateSolve(newstart,newend);
        end;

        If not result then
        begin {put original start & end back in place for the next iteration}
          cells[1,1]:=inttostr(col1+1);
          cells[2,1]:=inttostr(row1+1);
          cells[1,2]:=inttostr(col2+1);
          cells[2,2]:=inttostr(row2+1);
        end;
        trymoves:=trymoves*10; {next try all save methods up to 100% of maxmoves}
      end; {while not solved}

      with memo1.lines do
        if result then
        begin
          inc(statsrec.solved);
          add(format('#%d: From %s to %s Solved in %d move attempts',
                                  [statsrec.tried,collbl[col1]+rowlbl[row1],
                                  collbl[col2] + rowlbl[row2],
                                   board.totmoves]));

          if statsrec.txt<>''
          then
          Add(format('          Solved  as %s to %s ' +statsrec.txt,
                       [collbl[strtoint(cells[1,1])-1]+rowlbl[strtoint(cells[2,1])-1]
                       ,collbl[strtoint(cells[1,2])-1]+rowlbl[strtoint(cells[2,2])-1]]));
        end
        else
        begin
          inc(statsrec.notsolved);
          add(format('#%d: From %s to %s Unsolved',
                                 [statsrec.tried,collbl[col1]+rowlbl[row1],
                                  collbl[col2] + rowlbl[row2]]));

        end;
    end {end <> start}
    else
    begin
      inc(statsrec.nottried);
      statsrec.txt:='Start and End locations must be of opposite colors';
    end;

  end;



{************* SearchBtnClick ***********}
procedure Tf.FindAllBtnClick(Sender: TObject);
var
  start,stop:integer;
  col1,row1,col2,row2:integer;
  offset:TPoint;

begin
  with statsrec do
  begin
    tried:=0; solved:=0; nottried:=0; notsolved:=0;
  end;
  radiogroup1click(sender);
  memo1.clear;
  speedbar.position:=speedbar.max;
  stopbtn.visible:=true;
  stopallbtn.visible:=true;
  board.tag:=0;
  {determine the quadrant to be solved and set offsets appropriately}
  with stringgrid1 do
  case cells[col,row][1] of
    '1': offset:= point(0,0);
    '2': offset:=point(4,0);
    '3': offset:=point(0,4);
    '4': offset:=point(4,4);
  end;

  for start:=0 to 15 do {Start at (1,1) through (4,4)}
  for stop:=0 to 63 do  {End at (1,1) through (8,8)}
  begin

    col1:=start mod 4 +offset.x;
    row1:=start div 4 +offset.y;

    col2:=stop mod 8 ;
    row2:=stop div 8 ;
    {Set up constraints}
    cells[0,1]:='1';
    cells[1,1]:=inttostr(col1 +1);
    cells[2,1]:=inttostr(row1 +1);
    cells[0,2]:='64';
    cells[1,2]:=inttostr(col2 +1);
    cells[2,2]:=inttostr(row2 +1);

    tryallways(col1,row1,col2,row2,statsrec);

    if board.tag>1 then break; {Closing program or StopAll button clicked}
  end; {over all start and stop locations}
  with statsrec, memo1.lines do
  begin
    showmessage(format('Tried %d, Solved %d, Not solved %d ',
                     [tried, solved,notsolved]));
    add('');
    add('-----------------------------');
    add(format('Tried %d, Solved %d, Not solved %d',
                           [tried, solved,notsolved]));
  end;
  stopbtn.visible:=false;
  stopallbtn.visible:=false;
  speedbar.position:=900;
end;


procedure Tf.RadioGroup1Click(Sender: TObject);
begin
  with radiogroup1 do maxmoves:=strtoint(items[itemindex]);
end;

procedure Tf.stopallBtnClick(Sender: TObject);
begin
  board.tag:=2;
end;

procedure Tf.Find1BtnClick(Sender: TObject);
var
  startloc, stoploc: TPoint;
  startcol,startrow,stopcol,stoprow:integer;
  //ntimes:integer;
  //q1:integer;

  function validloc(s:string; var col,row:integer):boolean;
  begin
    result:=false;;
    if length(s)=2 then
    begin
      if (s[1] in ['A'..'H']) and (s[2] in ['1'..'8']) then
      begin
        col:=ord(s[1])-ord('A');
        row:=strtoint(s[2])-1;
        result:=true;
      end
      else showmessage('Location '+s +' is not valid, must be column ''A'' to ''H'''
                     +#13+' followed by row ''1'' to ''8''');
    end
    else showmessage('Invalid location '+s+'. Must be column ''A'' to ''H'''
                    +#13+' followed by row ''1'' to ''8''');
  end;


begin
  If validloc(startedt.text,startcol,startrow) and validloc(Endedt.text,stopcol,stoprow) then
  begin
    Memo1.clear;
    startloc:=point(startcol,startrow);
    stoploc:=point(stopcol,stoprow);
    {set up constraints}
    cells[0,1]:='1';
    cells[1,1]:=inttostr(startloc.x+1);
    cells[2,1]:=inttostr(startloc.y+1);
    cells[0,2]:='64';
    cells[1,2]:=inttostr(stoploc.x+1);
    cells[2,2]:=inttostr(stoploc.y+1);
    if not tryallways(startloc.x,startloc.y, stoploc.x, stoploc.y, statsrec)
    then showmessage('No solution found after '+inttostr(maxmoves)+' move attempts');
  end;
end;

end.
