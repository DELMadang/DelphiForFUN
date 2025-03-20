Unit U_Flipit2;
{Copyright  © 2001, 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Objective is to turn all tokens with white side
up.  Each click will turn over the clicked token
plus up to 4 adjoining adjoining tokens located
directly above, below, left or right of the
clicked token.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Spin, ComCtrls, ExtCtrls;

var boardsize:integer=4;
type
  Flagrec= array[0..9,0..9] of boolean;
  Tmode=(play,build);
  TBoard=class(TObject)
     constructor create(newsize:integer);
     destructor destroy;  override;
   public
     b:Flagrec{int64}; {64 bits representing 64 board positions, bit present = white side}
     size:byte; {# of rows and columns}
     score:byte;{score of this board}
     path:array of TPoint;  {used to keep track of the moves that got us here}
     procedure init;
     procedure assign(boardin:TBoard);
     function GetTokenColor(col,row:integer):char; {return 'B' or 'W 'for this col & row}
     procedure flipOne (c,r:integer);
     Procedure flipit(col,row:integer);
     Function Solveit0(var maxdepthtosearch:integer):TBoard;
  end;

  TForm1 = class(TForm)
    DrawGrid1: TDrawGrid;
    SolveBtn: TButton;
    ListBox1: TListBox;
    NewBoardBtn: TButton;
    ResetBtn: TButton;
    Memo1: TMemo;
    MovesLbl: TLabel;
    StopBtn: TButton;
    ModeBtn: TButton;
    Instruction: TLabel;
    SizeEdit: TSpinEdit;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    New2Btn: TButton;
    NbrMovesEdit: TSpinEdit;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1Click(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure NewBoardBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure ModeBtnClick(Sender: TObject);
    procedure SizeEditChange(Sender: TObject);
    procedure New2BtnClick(Sender: TObject);
  public
    { Public declarations }
    board:TBoard;
    saveboard:TBoard; {save the current board here in case replay is requested}
    Moves:integer;
    MaxDepthToSearch:integer;
    mode:TMode;
    procedure UpdateLabels;
    procedure reset;
    procedure Setplaymode;
  end;

var Form1: TForm1;

implementation
{$R *.DFM}

uses math, combo;

{*********************************************}
{*********** TBoard Methods ******************}
{*********************************************}

constructor TBoard.create(newsize:integer);
{create a board}
begin
  inherited create;
  size:=newsize;
  init;
end;

destructor TBoard.destroy;
begin
  setlength(path,0);
  inherited;
end;

{************ Init **********}
procedure TBoard.init;
{Initialize the board}
var i,j:integer;
begin
  For i:=0 to 9 do for j:=0 to 9 do b[i,j]:=true;
  score:=size*size;
  setlength(path,0)
end;

{***************** Assign ************}
procedure tboard.assign(boardIn:TBoard);
{assign boardin property values to self}
var i:integer;
begin
  size:=boardIn.size;
  b:=boardin.b;
  score:=boardin.score;
  setlength(path,length(boardin.path));
  if length(path)>0
  then for i:= 0 to high(boardin.path) do path[i]:=boardin.path[i];
end;

{****************** FlipOne **************}
procedure TBoard.flipOne (c,r:integer);
  {flip one token}
  begin
    b[c,r]:=not b[c,r];
    if b[c,r] then inc(score) else dec(score);
  end;


{************* FlipIt ****************}
Procedure TBoard.flipit(col,row:integer);
{Flip the token at a particular column and row}
{Plus the ones above, below, left and right - if they exist}
begin
    flipone(col,row);
    if col<size-1 then flipone(col+1,row);
    if col>0 then flipone(col-1,row);
    if row<size-1 then flipone(col,row+1);
    if row>0 then flipone(col,row-1);
end;

{****************** Solveit0 **************}
Function TBoard.Solveit0(var maxdepthtosearch:integer):TBoard;
{try generating all possible solution - since order of moves does not matter }
var
  i,j,k:integer;
  n:Flagrec;
  savescore,r,c:integer;
  solved:boolean;
  count:int64;
begin
  n:=b; {get the starting board configuration}
  savescore:=score;
  solved:=false;
  form1.moveslbl.visible:=true;
  for i:= 1 to min(maxdepthtosearch, size*size) do
  begin
    if solved then break;
    combos.setup(i,size*size, combinations);
    count:=0;
    while (combos.getnextcombo) and (not solved) and (maxdepthtosearch>0) do
    begin
      b:=n; {get the starting board configuration}
      score:=savescore;
      inc(count);
      if count mod 65536 {2048} =0 then
      begin
        form1.instruction.caption:='Checking '+inttostr(count)
         +' games of length '+inttostr(i);
        application.processmessages;
      end;
      for j:=1 to i do {flip the selected bits}
      begin
        r:=(combos.selected[j]-1) div size;
        c:=(combos.selected[j]-1) mod size;
        flipit(c,r);
        if score=size*size then
        begin
          solved:=true;
          setlength(path,j);
          for k:=0 to j-1 do
          with path[k] do
          begin
            y:=(combos.selected[k+1]-1) div size;
            x:=(combos.selected[k+1]-1) mod size;
          end;
          break;
        end;
        if solved then break;
      end;
    end;
  end;
  b:=n;
  score:=savescore;
  if solved then result:=self else result:=nil;
end;

{***************** GetBoardColor *************}
function TBoard.GetTokenColor(col,row:integer):char;
{ Return the value of a board position, B=black, W=white}
begin
  if b[col,row] then result:='W' else result:='B';
end;

{*********************************************}
{************ TForm Methods ******************}
{*********************************************}

{************  DrawGridDrawCell *******************}
procedure TForm1.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw a black or white token in this grid position}
begin
   with DrawGrid1.canvas do
   begin
     brush.color:=clgreen;
     fillrect(rect);
     If board.GetTokenColor(acol,arow)='W' then brush.color:=clwhite
     else brush.color:=clblack;
     ellipse(rect);
   end;
end;

{**************** FormCreate ******************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  boardsize:=sizeedit.Value;
  with drawgrid1 do
  begin
    colcount:=boardsize;
    rowcount:=boardsize;
    defaultcolwidth :=width div  colcount -2;
    defaultrowheight:=height div rowcount -2;
  end;
  board:=TBoard.create(boardsize);
  saveboard:=TBoard.create(boardsize);
  board.init;
  newboardbtnclick(sender);
  saveboard.assign(board);
  moves:=0;
  updatelabels;
  stopbtn.bringtofront;  {a big stop button, normally invisible but set to back at
                          design time to ease viewing other components}
  mode:=play;
end;

{************** DrawGridClick ********************}
procedure TForm1.DrawGrid1Click(Sender: TObject);
{User clicked to make a move}
begin

  with drawgrid1 do
  if mode=play then
  begin
    board.flipit(col,row);
    inc(moves);
    updatelabels;
  end
  else
  begin
    board.flipOne(col,row);
    saveboard.flipone(col,row);
  end;
  drawgrid1.invalidate;
end;


{*************** SolvebtnClick ****************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Auto-solve}
var
  solution:TBoard;
  i:integer;
begin
  moves:=0;
  updatelabels;
  setplaymode;
  listbox1.clear;
  screen.cursor:=crHourGlass;
  stopbtn.visible:=true;
  MaxDepthToSearch:=20;
  application.processmessages;
  solution:=board.SolveIt0(MaxDepthToSearch); {get the solution}
  screen.cursor:=crdefault;
  stopbtn.visible:=false;;
  If solution<>nil then {solution found}
  Begin
    {set up to display solution and animate moves}
    listbox1.items.add('Solved in '+inttostr(length(solution.path))+' moves');
    with solution do
    for i:= 0 to high(path) do
    begin
      listbox1.items.add('Move '+inttostr(i+1)+': (Col:'+inttostr(path[i].x+1)
                          +'  Row:'+inttostr(path[i].y+1)+')');
      board.flipit(path[i].x,path[i].y);
      inc(moves);
      updatelabels;
      drawgrid1.invalidate;
      application.processmessages;
      sleep(500);
    end;
    If solution<>board then solution.free;
  end
  else showmessage('No solution found');
end;



{**************** NewBoardBtnClick ***************}
procedure TForm1.NewBoardBtnClick(Sender: TObject);
var
  i, flips :integer;
begin
  setplaymode;
  with board do
  begin
    init; {clear the board}
    {and make a large random nbr of valid moves - ensures board has a solution}
    flips:=900+random(9);
    for i:= 1 to flips do flipit(random(size),random(size));
  end;
  reset;
  listbox1.clear;
end;

{******************* ResetBtnClick *******************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  setplaymode;
  board.assign(Saveboard);
  reset;
end;

{*********************** StopBtnClick ****************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  MaxDepthToSearch:=0;
end;

{****************** ModeBtnClick ****************}
procedure TForm1.ModeBtnClick(Sender: TObject);
begin
  if mode=play then
  begin
    mode:=build;
    instruction.caption:='Click to flip single tokens'
              +#13+'Caution - boards created in this manner may be unsovable!'
              +#13+'Press button again to re-enter play mode';
    Modebtn.caption:='Enter Play mode';
    board.init;    {clear board and saveboard}
    saveboard.init;
    drawgrid1.invalidate;
  end
  else setplaymode;
end;

{********************** UpdateLabels ******************}
procedure TForm1.updatelabels;
begin
  moveslbl.visible:=true;
  moveslbl.caption:='Moves: '+inttostr(moves);
end;

{**************** Reset *******************}
procedure TForm1.reset;
begin
  moves:=0;
  drawgrid1.invalidate;
  saveboard.assign(board);
  updatelabels;
end;

{****************** SetPlayMode ****************]}
procedure TForm1.Setplaymode;
begin
  mode:=play;
  instruction.caption:='Click token to flip';
  Modebtn.caption:='Enter Build mode';
end;

{***************** SizeEditChnage **********}
procedure TForm1.SizeEditChange(Sender: TObject);
{make a new board size}
begin
  board.free;
  saveboard.free;
  formcreate(sender);
end;

{*************** New2BtnClick **********}
procedure TForm1.New2BtnClick(Sender: TObject);
{Make a new random board that can be solved in he specified number of moves
 (or less)}
var
  i, nbrmoves :integer;
  tries, movesmade, n:integer;
  movefound:boolean;
  movesused:array of boolean;
begin
  setplaymode;
  with board do
  begin
    init; {clear the board}
    nbrmoves:= nbrmovesedit.value;
    movesmade:=0;
    setlength(movesused, size*size);
    for i:= 0 to high(movesused) do movesused[i]:=false; {keep track to moved made}
    for i:= 1 to nbrmoves do
    begin
      movefound:=false;
      tries:=0; {we'll try 100 times to find a random move}
      while (tries<100) and (not movefound)do
      begin
        n:=random(size*size);
        if not movesused[n] then
        begin
          movefound:=true;
          movesused[n]:=true;
          flipit(n mod size{column}, n div size{row});
          inc(movesmade);
        end;
        inc(tries);
      end;
    end;
    if movesmade<>nbrmoves
    then
    begin
      showmessage('Only '+inttostr(movesmade)+ ' moves found.');
      nbrmovesedit.value:=movesmade;
    end;
  end;
  reset;
  listbox1.clear;
end;

end.

