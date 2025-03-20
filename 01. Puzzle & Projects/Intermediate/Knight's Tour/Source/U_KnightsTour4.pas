unit U_KnightsTour4;
{Copyright  © 2000-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



(*

From an arbitrary  starting position on a chessboard, trace a route by
a standard knight that covers every square on the board exactly
once.  Knights jump 2 squares  horizontally or vertically and 1 square
in the  other direction at each turn.

If "Make Closed Tour" is checked, the 64th move of a solution
could make a valid move to the initial position (move #1).

New in Version 2 -
In "Autosolve" mode, the "Use Constraints" radio button will
incorporate  contraints defined on the "Constraints" page, attempting
to land on specific squares for specific move numbers.  This
experimental algorithm may result in lengthy searches for some
constraint combinations.

May, 2007:  Version 3 adds user defined board sizes from 
4x4 to 12x12.  It looks like all have soluion except the 4x4 
and closed tours exist for all even sizes > 4x4.   Also, the 
board is now resized as the form is resized.

-----------------------------------------
September 6, 2007:  The "Warnsdorf" heuristic (select the 
next move that has the fewest moves from there on), fails 
in a few cases to find a constraint solutiuon in reasonable 
time.  For example, starting at (Col 2, Row 3)

----------------------------------------
February 22, 2009:  Version 4 extends the prograsm to 
handle  rectangular board sizes which are not square.

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

  TBoard=class(TStringGrid)
   Private
     b: array of array of integer;
     moves:array of TPoint;  {array of moves made}
     sizex,sizey:integer;  {board size}
     maxsize:integer;  {The larger of sizex, sizey}
     manualplay:boolean; {true=user plays}
     movecount:integer;  {nbr of moves made}
     totmoves:integer;  {total moves tried, counting moves taken back }
     delay:integer; {ms to wait between moves when autosolving}
     closedtour, movespecified:boolean;
     movetospecified:integer;
     endcol,endrow:integer;
     constraintcount:integer;
     constraint:array of TConstraint;
     highmove:integer;
     minmove:integer;
     moveoffset:integer;
     constructor create(Aowner:TComponent;
                       newsizex,newsizey:integer;
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

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TourSheet: TTabSheet;
    ConstraintSheet: TTabSheet;
    Typergrp: TRadioGroup;
    SolvingPanel: TPanel;
    Label4: TLabel;
    Speedbar: TTrackBar;
    StopBtn: TButton;
    Memo1: TMemo;
    SolveBtn: TButton;
    PlayBtn: TButton;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    ClosedTourBox: TCheckBox;
    DelBtn: TButton;
    EditBtn: TButton;
    LoadBtn: TButton;
    SaveBtn: TButton;
    Panel2: TPanel;
    MoveNbrEdit: TSpinEdit;
    ColEdit: TSpinEdit;
    RowEdit: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    AddBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Moveslbl: TLabel;
    StaticText1: TStaticText;
    Label3: TLabel;
    Label5: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    ShowOneBox: TCheckBox;
    SizeEdtX: TSpinEdit;
    Label12: TLabel;
    Label1: TLabel;
    SizeEdtY: TSpinEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure SpeedbarChange(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TypergrpClick(Sender: TObject);
    procedure EndChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClosedTourBoxClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PageControl1Resize(Sender: TObject);
    procedure SizeEdtXChange(Sender: TObject);
  public
    board:TBoard;
    colvalue,rowValue:integer;
    adding:boolean;
    Procedure makeboard;
    function destunique(c,r:string; forrow:integer):boolean;
    function IsValidConstraint(m,c,r:integer):boolean;
    function DoMore:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



{****************** TBoard Methods ********************}

Constructor TBoard.create(Aowner:TComponent;
                       newsizex,newsizey:integer;
                       newlocrect:Trect
                       );
var   i,j:integer;
begin
   inherited create(Aowner);
   if Aowner is TWinControl
   then parent:=TWincontrol(Aowner);
   scrollbars:=ssNone;
   sizex:=newsizex;
   sizey:=newsizey;
   colcount:=sizex; fixedcols:=0;
   rowcount:=sizey; fixedrows:=0;
   top:=newlocrect.top;
   left:=newlocrect.left;
   width:=newlocrect.right-left;
   height:=newlocrect.Bottom-top;
   if sizex>=sizey then
   begin
     defaultcolwidth:= (width-sizex) div sizex-1;
     defaultrowheight:=defaultcolwidth;
     maxsize:=sizex;
   end
   else
   begin
     defaultrowheight:= (height-sizey) div sizey-1;
     defaultcolwidth:=defaultrowheight;
     maxsize:=sizey;
   end;
   {set constarin max values}
   width:=(defaultcolwidth+1)*sizex+3; {trim width to fit squares}
   height:=(defaultrowheight+1)*sizey+3;
   setlength(b,sizex,sizey);
   setlength(constraint, sizex*sizey+1);
   {initialize board to zeros}
   for i:= 0 to sizex-1 do for j:= 0 to sizey-1 do  b[i,j]:=0;
   setlength(moves,sizex*sizey+1);
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
end;

procedure TBoard.DrawACell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
 {OnDrawcell exit}
var
  i,j:integer;
  s:string;
  movenbr:integer;
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
    if b[i,j]>0
    then
    with canvas do
    begin
      font.style:=[fsbold];
      if (i mod 2) = (j mod 2) then font.color:=clblack
      else font.color:=clwhite;
      {If we solved starting from a user specified move other than move 1,
        moveoffset is the amount to adjust the internal move number used by
        the program to the external moce numbers seen by the user.}
      movenbr:= (b[i,j]+moveoffset-1) mod (sizex*sizey);
      s:=format('%3d',[movenbr mod (sizex*sizey) + 1]);
      {For large boards, use a smaller font}
      If (sizex>8) or (sizey>8) then font.size:=10 else font.size:=12;
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

Procedure TBoard.clicked;
{User clicked a cell}
begin
  if not manualplay then exit;
  If isValidmove(col,row) then makemove(col,row)
  else if canundo then undomove
  else beep;
end;

Function TBoard.IsValidMove(newcol,newrow:integer):boolean;

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
  If (newcol<0) or (newcol>=sizex) or (newrow<0) or (newrow>=sizey)
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
    If OK and (b[newcol,newrow]<>0) then OK :=false;

    {12/20/02 - add code for closed tours - move must not make the starting
     position unreachable unless it is the last move}

    if closedtour and OK  and ((newcol<>0) or (newrow<>0))
          and (movecount<{movetospecified }sizex*sizey-1)
    then
    begin
      b[newcol,newrow]:=1; {temporarily mark current candidate as occupied}
      ok:=false;
      for i:= 1 to 8 do  {make sure a valid move exists from 1st square even if
                          current candidate is occupied}
      begin
        pcol:=moves[1].x+offsets[i].x;
        prow:=moves[1].y+offsets[i].y;
        if (pcol>=0) and (pcol<sizex) and (prow>=0)and(prow<sizey) and (b[pcol,prow ]=0)
        then
        begin
          Ok:=true;
          break;
        end;
      end;
       b[newcol,newrow]:=0; {mark candidate as available again}
    end;

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
            if (pcol>=0) and (pcol<sizex) and (prow>=0)and(prow<sizey) and (b[pcol,prow ]=0)
            then
            begin
              Ok:=true;
              break;
            end;
          end;
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

Procedure TBoard.makemove(newcol,newrow:integer);
{make a move}
begin
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
  cells[col,row]:=inttostr(movecount);
end;

Function TBoard.Canundo:boolean;
begin
  result:=(b[col,row]=movecount); {can only undo last move}
end;

Procedure TBoard.UndoMove;
{undo a move}
begin
  If movecount>0 then
  with moves[movecount] do
  begin
    b[x,y]:=0;  {0 the board cell}
    cells[x,y]:=''; {blank the display cell}
    dec(movecount); {decrease the count}
  end;
end;

Function TBoard.possiblemoves(newcol,newrow:integer):integer;
{ Return a count of valid moves from this location}
var
  i,count:integer;
begin
  count:=0;
  If isvalidmove(newcol,newrow) then
  begin
    makemove(newcol,newrow);  {make the trial move}
    for i:= 1 to 8 do  {count how many next moves exist}
      if isvalidmove(newcol+offsets[i].x, newrow+offsets[i].y) then inc(count);
    undomove;  {and undo the move}
  end;
  result:=count;
end;


Function TBoard.solvefrom(newcol,newrow:integer):boolean;
{generate all possible next moves, and count the number of next moves from
     each position.  Pick one with lowest value and move there}
    {If the lowest number of next moves is 0 and that would not be the
    last move then this is a bad path. Need to backtrakc and try another path
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
               (possibles[i].distfromstart<possibles[j].distfromstart)
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
  else if totmoves and $0000fff=0 then
  begin
    update;
    sleep(1);
    application.processmessages; {max speed}
  end;

  {Done?}
  result:=false;
  If movecount=sizex*sizey then
  begin
    if form1.showOnebox.checked or (not form1.domore) then result:=true;
  end;
  If not result then
  {If not, then generate next moves for all possible moves from here}
  begin
    result:=false;
    If manualplay then exit;
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
      if nbrmoves=0 then nbrmoves:=maxsize+1
      else distfromstart:=dist(pcol,prow);;
    end;
    {Sort them by increasing possible moves - Warnsdorff heuristic}
    sortmoves;
    {Now run through all the possibilities
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
        form1.moveslbl.caption:='Total moves tried: '+inttostr(totmoves+1)
                        +' Highest move:'+inttostr(highmove);
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

{******************** Form Methods *******************}

{************ FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  board:=nil;
  makeboard;
  solvingpanel.bringtofront;
end;

{****************** MakeBoard ***********}
Procedure TForm1.makeboard;
var i:integer;
begin
  if assigned(board) then Board.free;
  with Panel1 do {Panel1 is used just to supply a board size}
  board:=TBoard.create(self,sizeEdtx.value,sizeEdty.value,
                       rect(left,top,left+width,top+height));
  with board do
  begin
    MoveNbrEdit.maxvalue:=sizex*sizey;
    ColEdit.maxvalue:=sizex;
    RowEdit.maxvalue:=sizey;
  end;  
  board.delay:=speedbar.max-speedbar.position;
  board.highmove:=1;
  board.parent:=TourSheet;
  {set up constraints}
  board.constraintcount:=stringgrid1.rowcount-1;
  for i:=1 to board.sizex*board.sizey do board.constraint[i].movenbr:=0;
  for i:= 1 to stringgrid1.rowcount-1 do
  with stringgrid1 do
  begin
    with board.constraint[i] do
    begin
      movenbr:=strtoint(cells[0,i]);
      col:=strtoint(cells[1,i]);
      row:=strtoint(cells[2,i]);
    end;
  end;
  typergrpclick(self);
end;

{***************** PlayBtnClick *************}
procedure TForm1.PlayBtnClick(Sender: TObject);
begin
  if board.manualplay then
  begin
    if assigned(board) then freeandnil(board);
    Makeboard;
  end;
  board.manualplay:=true;
end;


{************* SolveBtnClick *************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Compute solution -
 Start at a random location and try all paths - backtrack on those
 that don't work - until solution is found.

 Uses Warnsdorf heuristic - when a choice of moves is available,
  choose the one that has the fewest next moves
 }
var
  j:integer;
  startfound:boolean;
begin
  makeboard;
  board.manualplay:=false;
  board.closedtour:=closedtourbox.checked;
  {make a test for valid start & end points if both specified}
  board.moveoffset:=0;
  with board do
  if movespecified then
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
  begin
    with speedbar do position:=(max+min) div 2;
    solvingpanel.visible:=true;
    totmoves:=0;
    moveslbl.caption:='Total moves tried: 0';
    {makemove(random(size),random(size));}

    makemove(Colvalue-1, Rowvalue-1);
    If solvefrom(col,row) then showmessage('Solved!')
    else {if not manualplay then} showmessage('No solution found');
    solvingpanel.visible:=false;
  end;
  board.manualplay:=true;
end;

function TForm1.DoMore:Boolean;
{Ask user if he wants to stop after a solution  is found}
var p:TPoint;
begin
  p:=memo1.clienttoscreen(point(0,memo1.height div 3));
  result:=messagedlgpos('Solution found, continue search?',mtConfirmation,
      [mbyes,mbno],0,p.x,p.y)=mryes;
end;

{***************** SpeedbarChange **********}
procedure TForm1.SpeedbarChange(Sender: TObject);
{set new ms delay between moves}
begin
  with speedbar do board.delay:=max-position;
end;

{**************** StopbtnClick ***********}
procedure TForm1.StopBtnClick(Sender: TObject);
{set stop flag}
begin
  board.tag:=1;
end;

{*************** FCormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   board.tag:=1; {in case we're solving}
   canclose:=true;
end;



{************** TypeRgrpClick ***************}
procedure TForm1.TypergrpClick(Sender: TObject);
begin
  with typergrp, board do
  case itemindex of
    0:
      begin  { No restictions}
        movespecified:=false;
        colvalue:=1; rowvalue:=1;
      end;
    1:
      begin {use constraints}
        movespecified:=true;
      end;
   end;
end;

{************* EndChange *************}
procedure TForm1.EndChange(Sender: TObject);
begin
  typergrp.itemindex:=2;
end;

{************** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  with stringgrid1 do
  begin
    cells[0,0]:='Move';
    cells[1,0]:='Col';
    cells[2,0]:='Row';
  end;
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
 (*
 makeconstraint(4,7,7);
 makeconstraint(5,5,8);
 makeconstraint(9,1,8);
 makeconstraint(13,4,1);
 makeconstraint(14,2,2);
 makeconstraint(24,5,7);
 makeconstraint(32,1,1);
 makeconstraint(34,4,4);
 makeconstraint(36,1,5);
 makeconstraint(40,8,8);
 makeconstraint(44,8,4);
 makeconstraint(54,6,4);
 makeconstraint(64,6,2);
 *)
end;

{************* ClosedTourBoxClick **********}
procedure TForm1.ClosedTourBoxClick(Sender: TObject);
begin
  board.closedtour:=closedtourbox.checked;
end;

function TForm1.IsValidConstraint(m,c,r:integer):boolean;
{If not 1st constraint then it must agree in parity with 1st constraint}
{Must be reachable from next lower constraint and be able to reach next
 higher constraint (if any)}
 var
   i:integer;
   m2,c2,r2:integer;
   msg:string;
 begin
   with board do
   begin
     msg:='';
     if c>sizex then msg:='Column too large, ';
     if r>sizey then msg:=msg+'Row too large, ';
     If m>sizex*sizey then msg:=msg+' Move # too large, ';
     if msg<>'' then
     begin
       result:=false;
       showmessage( msg+#13
                   +format('Constraint (%d,%d,%d), not added', [m,c,r]));
       exit;
     end;
   end;  

   result:=true;
   with stringgrid1 do
   for i:= 1 to rowcount-1 do
   if (i<>row) and (trim(cells[0,i])<>'') then
   begin
     m2:=strtoint(cells[0,i]);
     if m2<>m then {different move nbr?}
     begin
       c2:=strtoint(cells[1,i]);
       r2:=strtoint(cells[2,i]);
       {parity of difference of move numbers must be the same as parity of
        differences of sums of (column+row)}
       if abs(m2-m) mod 2 <> (abs(c+r-C2-r2)) mod 2 then result:=false;
       if not result then
       begin
         showmessage(format('Constraint for move nbr %2d '
             +'(%2d,%2d) not consistent with constraint for move nbr %s'
             +'(%s,%s)',[m,c,r,cells[0,i],cells[1,i], cells[2,i]]));
         break;
       end
       else
       begin
         if (abs(c-c2)>2*abs(m-m2)) or  (abs(r-r2)>2*abs(m-m2))
          then {can't get there from here}
         begin
           result:=false;
           showmessage(format('Moves  %2d  and %s are too far apart' ,[m,cells[0,i]]));
           break;
         end ;
       end;
     end;
   end;
 end;

{***************** DestUnique *************}
function Tform1.destunique(c,r:string; forRow:integer):boolean;
{return true if the input column and row are unique (and not for row "forRow")}
var
  i:integer;
begin
  result:=true;
  with stringgrid1 do
  begin
    for i:= 0 to rowcount-1 do
    begin
      if (i<>forrow) and (cells[1,i]=c) and (cells[2,i]=r)
      then
      begin
        result:=false;
        break;
      end;
    end;
  end;
end;

{*************** AddBtnClick **************}
procedure TForm1.AddBtnClick(Sender: TObject);
{add a new constraint}
var
  i:integer;
  mr:integer;
begin
  adding:=true;
  with stringgrid1 do
  begin
    rowcount:=rowcount+1;
    fixedrows:=1;
    row:=rowcount-1;

    if IsValidConstraint(movenbredit.value,coledit.value,rowedit.value)  then
    begin
      if destunique(inttostr(coledit.value), inttostr(rowedit.value),row) then
      begin
        mr:=mryes;
        for i:= 1 to row-1 do
        begin
          if cells[0,i]= movenbredit.text then
          begin
            mr:=messagedlg('Move '+cells[0,row]+' already defined.  Replace it?',
                               mtConfirmation, [mbyes,mbno],0);
            if mr =mrYes then
            begin
              row:=i;
              rowcount:=rowcount-1; {remove the last (blank) row}
            end
            else showmessage('Duplicate move, add request ignored');
            break; {break out of loop}
          end;
        end;
      end
      else
      begin
        mr:=mrno;
        showmessage('This destination is already defined, cannot be added');
      end;
    end
    else mr:=mrno;

    if mr=mrYes then
    begin
      cells[0,row]:=inttostr(movenbredit.value);
      cells[1,row]:=inttostr(coledit.value);
      cells[2,row]:=inttostr(rowedit.value);
    end
    else rowcount:=rowcount-1;
    adding:=false;
  end;
end;

{*************** StringGrid1Click *************}
procedure TForm1.StringGrid1Click(Sender: TObject);
begin
  if not adding then
  with stringgrid1 do
  begin
    movenbredit.value:=strtointdef(cells[0,row],0);
    coledit.value:=strtointdef(cells[1,row],0);
    rowedit.value:=strtointdef(cells[2,row],0);
  end;
end;

{**************** EditBtnClick **********}
procedure TForm1.EditBtnClick(Sender: TObject);
begin
  if IsValidConstraint(movenbredit.value,coledit.value,rowedit.value)  then
  if destunique(inttostr(coledit.value), inttostr(rowedit.value),stringgrid1.row) then
  with stringgrid1 do
  begin
    cells[0,row]:=inttostr(movenbredit.value);
    cells[1,row]:=inttostr(coledit.value);
    cells[2,row]:=inttostr(rowedit.value);
  end;
end;

{************** DeleteBtnClick ***********}
procedure TForm1.DelBtnClick(Sender: TObject);
var i:integer;
begin
  if messagedlg('Delete selected row?', mtconfirmation, [mbyes,mbno],0)=mryes
  then with stringgrid1 do
  begin
    for i:=row to rowcount-1 do rows[i]:=rows[i+1];   {move rows up by one row}
    rowcount:=rowcount-1; {reduce row count}
  end;
end;

{************* LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  f:file of TConstraint;
  c:TConstraint;
begin
  if opendialog1.execute then
  begin
    assignfile(f,opendialog1.filename);
    reset(f);
    stringgrid1.rowcount:=1;
    with stringgrid1 do
    while not eof(f) do
    begin
      read(f,c);
      if c.movenbr=0 then
      begin
        if (sizeEdtx.value<>c.col) or (SizeEdty.value<>c.row)
        then showmessage('Board size changed to match constraints');
        sizeedtx.value:=c.col;
        Sizeedty.value:=c.row;
      end
      else
      with c do
      if isvalidconstraint(movenbr,col,row) then
      begin
        rowcount:=rowcount+1;
        cells[0,rowcount-1]:=inttostr(c.movenbr);
        cells[1,rowcount-1]:=inttostr(c.col);
        cells[2,rowcount-1]:=inttostr(c.row);
      end;
    end;
    closefile(f);
  end;
end;

{****************** SaveBtnClick ************}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  f:file of TConstraint;
  c:TConstraint;
  i:integer;
begin
  if savedialog1.execute then
  begin
    assignfile(f,savedialog1.filename);
    rewrite(f);
    {save 1st record with movenbr of 0 to hold sizex and sizey}
    c.movenbr:=0;
    c.col:=board.sizex;
    c.row:=board.sizey;
    write(f,c);
    {Write remainder of conmstraints}
    with stringgrid1 do
    for i:=1 to rowcount-1 do
    begin
      c.movenbr:=strtoint(cells[0,i]);
      c.col:=strtoint(cells[1,i]);
      c.row:=strtoint(cells[2,i]);
      write(f,c);
    end;
    closefile(f);
  end;
end;


{************** PagecontrolResize ***********8}
procedure TForm1.PageControl1Resize(Sender: TObject);
{adjust board size when form is resized}
begin
    with panel1 do
  begin
    if width>height then width:=height;
    if top+height >typergrp.top then
    begin
      height:=typergrp.top-10-top;
      width:=height;
    end;
  end;
  makeboard;
end;

procedure TForm1.SizeEdtXChange(Sender: TObject);
begin
  makeboard;
end;

end.
