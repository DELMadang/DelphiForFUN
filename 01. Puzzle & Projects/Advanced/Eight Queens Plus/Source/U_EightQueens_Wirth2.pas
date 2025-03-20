unit U_EightQueens_Wirth2;
 {Copyright  © 2002-2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 { Eight Queens problem asks you to arrange 8 chess queens on an 8x8 chessboard
   so that no queen threatens another.
   This program finds all 92 solutions using the Wirth algorithm.  It also
   finds the largest set of solutions that can co-exist on the board without
   overlapping each other and the smallest set of solutions which completely
   cover the board}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ComCtrls;

type
  tsolution=array[1..8] of byte;
  tboard= array[1..8] of TSolution;

  TForm1 = class(TForm)
    WirthBtn: TButton;
    ListBox1: TListBox;
    CoexistingBtn: TButton;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StopBtn: TButton;
    CoveringBtn: TButton;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Label1: TLabel;
    procedure WirthBtnClick(Sender: TObject);  {Find all solutions}
    procedure CoexistingBtnClick(Sender: TObject);  {Find co-existing solutions}
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StopBtnClick(Sender: TObject);
    procedure CoveringBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  public
    Grow:array[1..8] of boolean;
    ColPlusRow:array[2..16] of boolean;
    ColMinusRow:array[-7..+7] of boolean;
    solution:Tsolution;
    solutions:array[1..92] of Tsolution;
    maxlevel, minlevel:integer;
    coveredcount:integer;
    solutionnbrs:array[1..92] of integer;
    count:integer;
    procedure Search (column: integer);
    Procedure Initialize;
    procedure ShowSolution;
    function place(level:integer; board:TBoard):boolean;

    function gethighestcount(b:TBoard):integer;
    procedure addsolution(var board:TBoard; n:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* Search ************}
 procedure TForm1.Search (column: integer);
 {Apply Wirth solution search algorithm }

         {*********** SetQueen ***********}
        procedure SetQueen (row, column: integer);
          begin
            gRow[row] := false;
            ColPlusRow[column + row] := false;
            ColMinusRow[column - row] := false;
          end;

        {************ RemoveQueen **********}
        procedure RemoveQueen (row, column: integer);
          begin
            gRow[row] := true;
            ColPlusRow[column + row] := true;
            ColMinusRow[column - row] := true;
          end;


  var
    row: integer;
    rowFlag,plusFlag,minusFlag: Boolean;
  begin
    for row := 1 to 8 do
    begin
      rowFlag := gRow[row];
      plusFlag := ColPlusRow[column + row];
      minusFlag := ColMinusRow[column - row];
      if rowFlag and plusFlag and minusFlag then
      begin
        Solution[column] := row;
        SetQueen(row, column);
        if column < 8 then Search(column + 1)
        else ShowSolution;
        RemoveQueen(row, column);
      end;
    end;
  end;    {Search}



{************ Initilaize *********}
Procedure TForm1.Initialize;
var i:integer;
begin
  for i:=low(gRow) to high(Grow) do grow[i]:=true;
  for i:=low(ColPlusRow) to high(ColPlusRow) do ColPlusRow[i]:=true;
  for i:=low(ColMinusRow) to high(ColMinusRow) do ColMinusRow[i]:=true;

  (* Uncomment these lines to check solutions for EightQueensPlus
  {exclude main diagonals from solutions}
  ColPlusRow[9]:=false; ColMinusRow[0]:=false;
  *)

  listbox1.clear;
  listbox1.items.add('Rows by column');
end;

{********* Showsolution *********}
procedure TForm1.showsolution;
var  i:integer;
     s:string;
begin
  s:='';
  for i:=1 to 8 do s:=s+inttostr(solution[i]);
  listbox1.items.add(inttostr(listbox1.items.count)+': '+s);
  solutions[listbox1.items.count-1]:=solution; {save solutions}
end;

{************** WirthBtnClick *********}
procedure TForm1.WirthBtnClick(Sender: TObject);
begin
  Initialize;
  Search(1);
end;

{************** Place **************}
function TForm1.place(level:integer; board:TBoard):boolean;
{Recursive search for the largest set of non-overlapping solutions}
var
  c,i,j,k,n:integer;
  s:string;
begin
  result:=false;
  if tag<>0 then exit;
  for j:= low(solutions) to high(solutions) do
  if solutions[j,1]>0 then
  begin
    result:=true;
    for c:=1 to 8 do if board[c,solutions[j,c]]<>0
    then
    begin
      result:=false;
      break;
    end;
    if result then
    begin
      for c:=1 to 8 do board[c,solutions[j,c]]:=level;
      stringgrid1.cells[0,level]:=inttostr(j)+' fits';
      solutionnbrs[level]:=j;
      if level>maxlevel then
      begin
        for i:=1 to 8 do for k:=1 to 8 do
          stringgrid2.cells[i-1,k-1]:='';
        for c:=1 to level do
        begin
          stringgrid1.cells[1,c]:=stringgrid1.cells[0,c];
          {s:=inttostr(c);}
          n:=solutionnbrs[c];
          for i:= 1 to 8 do stringgrid2.cells[i-1,solutions[n,i]-1]:=inttostr(n);
        end;
        maxlevel:=level;
      end;
      application.processmessages;
      if level<8 then result:=place(level+1,board);
      if not result then
      begin
         for c:=1 to 8 do board[c,solutions[j,c]]:=0;
         stringgrid1.cells[0,level]:='';
      end;
    end;
  end;
end;

{************** CoexistingBtnClick *********}
procedure TForm1.CoexistingBtnClick(Sender: TObject);
{Start the search for the largest set of non-overlapping solutions}
var  board:TBoard;
     i,j:integer;
begin
  WirthBtnclick(sender);
  WirthBtn.enabled:=false;
  Coveringbtn.enabled:=false;
  tag:=0;
  maxlevel:=0;
  stringgrid1.colcount:=2;
  stringgrid1.cells[0,0]:='Current';
  stringgrid1.cells[1,0]:='Best so far';
  with stringgrid1 do for i:=1 to rowcount-1 do cells[0,i]:='';
  screen.cursor:=crhourglass;
  for i:=1 to 8 do for j:= 1 to 8 do board[i,j]:=0;
  place(1,board);  {Start the recursive search}
  WirthBtn.enabled:=true;
  Coveringbtn.enabled:=true;
  screen.cursor:=crdefault;
end;

{************** FormCloseQuery **********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{User wants to quit - set the stop flag }
begin  tag:=1; canclose:=true; end;

{************* StopBtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
{Set the stop flag}
begin   tag:=1; end;

{************ ClearBoard *********}
procedure clearboard(var b:TBoard);
{Zero the board}
var i,j:integer;
begin
  for i:=1 to 8 do
  for j:=1 to 8 do b[i,j]:=0;
end;

{************ AddSolution *************}
procedure TForm1.addsolution(var board:TBoard; n:integer);
{Add solution N to board}
var i:integer;
begin
  for i:=1 to 8 do  board[i,solutions[n,i]]:=n;
end;

{*********** GetHighestCount *************}
function Tform1.gethighestcount(b:TBoard):integer;
{find the solution which would contribute the most to a covering}
var  i,j:integer;
     count:integer;
     maxindex,maxcount:integer;
begin
  maxindex:=0;
  maxcount:=0;
  for i:=low(solutions) to high(solutions) do
  begin
    count:=0;
    for j:= 1 to  8 do if b[j,solutions[i,j]]=0 then inc(count);
    if count>maxcount then
    begin
      maxcount:=count;
      maxindex:=i;
    end;
  end;
  result:=maxindex;
end;

{*********** FilledCount ********}
function filledcount(b:TBoard):integer;
{Count the number of squares that are occupied on the board}
var i,j:integer;
begin
  result:=0;
  for i:=1 to 8 do for j:=1 to 8 do if b[i,j]>0 then inc(result);
end;

type tn=array[1..92] of integer; {this just makes it easy to save solution sets}

{*********** CoveringBtnClick ************}
procedure TForm1.CoveringBtnClick(Sender: TObject);
{search for the minimal covering set of solutions}
var  board:TBoard;
     i,j,n:integer;
     solutionnbrs:tn;
     solcount:integer;
     bestsolutionnbrs:tn;
     bestsolcount:integer;
begin
  WirthBtnclick(sender);
  tag:=0;
  bestsolcount:=999;
  for i:= low(solutions) to high(solutions)-8 do
  begin
    clearboard(board);
    addsolution(board, i);
    solcount:=1;
    solutionnbrs[solcount]:=i;
    while filledcount(board)<64 do
    begin
      n:=gethighestcount(board);
      addsolution(board,n);
      inc(solcount);
      solutionnbrs[solcount]:=n;
    end;
    if filledcount(board) =64 then
    begin
      if solcount<bestsolcount then
      begin
        bestsolcount:=solcount;
        bestsolutionnbrs:=solutionnbrs;
      end;
    end;
  end;
  stringgrid1.cells[0,0]:='Best set';
  stringgrid1.colcount:=1;
  with stringgrid1 do for i:=1 to rowcount-1 do cells[0,i]:='';
  with stringgrid2 do
  for i:=1 to bestsolcount do
  begin
    for j:=1 to 8 do
    cells[j-1,solutions[bestsolutionnbrs[i],j]-1]:=inttostr(bestsolutionnbrs[i]);
    stringgrid1.cells[0,i]:=inttostr(bestsolutionnbrs[i])
  end;
  screen.cursor:=crdefault;
end;

{************** Listbox1Click **********}
procedure TForm1.ListBox1Click(Sender: TObject);
{Display the solution clicked by user}
var
  s, ix:string;
  i,j,n:integer;
begin
  for i:= 0 to 7 do for j:= 0 to 7 do stringgrid2.cells[i,j]:='';
  with listbox1 do
  if itemindex>0 then
  begin
    s:=items[itemindex];
    delete(s,1,length(s)-8);
    ix:=inttostr(itemindex);
    for i:=1 to 8 do
    begin
      n:=strtoint(s[i]);
      stringgrid2.cells[i-1,n-1]:=ix;
    end;
  end;
end;

end.
