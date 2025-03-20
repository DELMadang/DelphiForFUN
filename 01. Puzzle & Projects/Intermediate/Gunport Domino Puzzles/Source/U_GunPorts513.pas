Unit U_GunPorts513;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
This puzzle is played on a board divided into square cells on which
dominoes are placed. A  "Gunport" is an unoccupied square
surrounded by the outside border or dominoes. Dominoes are 1
square x 2 squares in size and me be oriented horizontally or vertically,

The objective for the chosen board size is to  leave the maximum
number of gunports by placing dominoes on the board. The target
number of  gunports is given each size.  Define a domino by clicking
two adjacent squares.  Clicking a defined domino or a previously
selected single square will remove it.

Version 2: Users can now choose any board size from 3x3 to 10x10.  A
"Solve" button implements an LP (Linear Programming) search for a
solution to the current puzzle size.  The search algorithm used is the
4th version described in an excellent paper by Chlond and Bosch, "The
Gunport Problem" available at
http://archive.ite.journal.informs.org/Vol6No2/ChlondBosch/.

Options allow search for either the "first" or the "optimal" solution.
Note: "Optimal" may run for many hours for larger puzzle sizes.  The
"Eliminate Symmetries" checkbox speeds searches by eliminating
checking for some configuration representing rotations or mirroring of
the board. New solutions are added to a file of previously solved
puzzles which may be seen by clicking the "View all solutions" button.
Click any of the resulting puzzle size lines to view the solution.

Version 2.1 replace version 5.1 of the LPSolve solver with version 5.5.  This
shows significantly improved search performance on cases tested so far.
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Spin, LPSolve51, ComCtrls, DFFUtils, U_PresolveDlg51;

type
  Tboard=array of array of char;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    borderimage: TImage;
    Image1: TImage;
    Placedlabel: TLabel;
    RowsLbl: TLabel;
    Label1: TLabel;
    ColsLbl: TLabel;
    BoardLbl: TLabel;
    SolveBtn: TButton;
    ColsUD: TUpDown;
    ColsEdt: TEdit;
    TimeLbl: TLabel;
    EliminateSymmetries: TCheckBox;
    Timer1: TTimer;
    ViewBtn: TButton;
    SearchOptimum: TCheckBox;
    RowsEdt: TEdit;
    Rowsud: TUpDown;
    AllowSave: TCheckBox;
    ClearBtn: TButton;
    ClickLbl: TLabel;
    Button1: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure ChangeSizeKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SizeEdtChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure Memo1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ClearBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
  public

    board:Tboard;
    size:integer; {pixel width of a doimino}
    origsize:TPoint; {initial (max) image size used for rescaling boards}
    oneclicked:boolean;
    cols,rows:integer;
    nbrgunports, nbrdominoes:integer;
    starttime:TDatetime;
    Solutions:TStringlist;
    filename:string;
    LP:THandle;
    procedure drawboard;
    procedure emptyboard;
    procedure setsize(w,h:integer);
    function countgunports(board:TBoard; var DominoesPlaced:integer):integer;
    procedure savesolutions(filename:string);
    procedure loadSolutions(filename:string);
    procedure Updatesolutions(sizename:string);
    procedure Showconstraints;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  solvecodes:array[-5 .. 9] of string =
  ('UNKNOWNERROR','DATAIGNORED','NOBFP','NOMEMORY','NOTRUN',
   'OPTIMAL', {=  0}
    'SUBOPTIMAL','INFEASIBLE','UNBOUNDED','DEGENERATE','NUMFAILURE',
     'USERABORT','TIMEOUT','RUNNING','FUTURESTATUS');


procedure TForm1.FormCreate(Sender: TObject);
begin
  with borderimage, canvas do
  begin  {fill  the border rectangle}
    brush.color:=clBlack;
    rectangle(clientrect);
  end;
  with image1 do origsize:=point(width,height); {save initial screen size}
end;

{************ FormActivate ***********8}
procedure TForm1.FormActivate(Sender: TObject);
begin
  setsize(colsud.position, rowsud.position);
  solutions:=TStringList.Create;
  solutions.sorted:=true;
  solutions.duplicates:=dupIgnore;
  filename:=extractfilepath(application.exename)+'GunPortSolutions.stm';
  loadsolutions(filename);
  presolvedlg.okbtnclick(sender);
end;
        

{*******   SetSize  ***********}
procedure TForm1.setsize(w,h:integer);
{setup parameters to track and display an hxw board}
{Note: board is dimesioened as columns x rows, but external nemnclature is rows x columns}
   var
     dx,dy:integer;
   begin
     cols:=w;
     rows:=h;
     setlength(board,cols,rows);
     with origsize do
     begin
       dx:=x div w;
       dy:=y div h;
       if dx<dy then size:=dx else size:=dy;
     end;
     with borderimage do
     begin {make the black border around the board image}
       width:=size*cols+64;
       height:=size*rows+64;
       picture.bitmap.height:=height;
       picture.bitmap.width:=width;
       application.processmessages;
     end;
     with image1 do
     begin
       width:=size*cols;
       height:=size*rows;
       picture.bitmap.height:=height;
       picture.bitmap.width:=width;
       application.processmessages;
     end;
     emptyboard;
     {Calculate optimum results (most gunports)}
     if (cols mod 3 =0) or (rows mod 3 = 0) then nbrgunports:=cols*rows div 3
     else if (cols mod 3) = (rows mod 3) then nbrgunports:=(cols*rows-4) div 3
     else nbrgunports:=(cols*rows-2) div 3;
     nbrdominoes:=(cols*rows-nbrgunports) div 2;
     Boardlbl.caption:=format('Board size: %dx%d (Objective: %d dominoes, %d gunports)',
                           [rows, cols, nbrdominoes, nbrgunports]);
   end;





{*************** Image1Click **********8}
procedure TForm1.image1Click(Sender: TObject);
   {Board cells contents:
      'R': right cell of a horizontal domino
      'L': left cell of a horizontal domino
      'U': top cell of a vertical domino
      'D': lower cell of a vertical domino
      'E': empty (avaialble) cell
      'X': Clicked cell that represent half of a domino being built}

    {============ ClearX ============}
    procedure clearx;
   {cells with 'X' are single cell clicks which may represent either half of
    a domino being added}
   var
     c,r:integer;
   begin
     for c:=0 to cols-1 do
     begin
       for r:=0 to rows-1 do
       begin
         if board[c,r]='X' then board[c,r]:='E';
       end;
     end;
   end;

   {============== SetNeighbor =========}
   procedure setneighbor(newc,newr:integer);
   {If the user clicked a cell adjoining a previously clicked cell
    the add the domino}
   var
     N, dominoesplaced:integer;
   begin
     if (newc>0) and (board[newc-1,newr]='X') then
     begin
       board[newc,newr]:='R';
       board[newc-1,newr]:='L';
     end
     else
    if (newc<cols-1) and (board[newc+1,newr]='X') then
     begin
       board[newc,newr]:='L';
       board[newc+1,newr]:='R';
     end
     else
     if (newr>0) and (board[newc,newr-1]='X') then
     begin
       board[newc,newr]:='D';
       board[newc,newr-1]:='U';
     end
     else
     if (newr<rows-1) and (board[newc,newr+1]='X') then
     begin
       board[newc,newr]:='U';
       board[newc,newr+1]:='D';
     end;

     N:= CountGunports(board, DominoesPlaced);
     PlacedLabel.caption:=inttostr(dominoesPlaced)+' Dominoes placed';
     If N=nbrgunports
     then
     begin
       drawboard;  {draw the last domino}
       showmessage('You solved it!'+#13+'Congratulations!');
       Updatesolutions(format('%2dx%2d',[rows,cols]));
     end;

   end;

var
  c,r:integer;
  p,q:TPoint;
begin  {Image1Click}
  if solvebtn.caption='Stop' then exit;
  q:=mouse.CursorPos;
  p:=image1.screentoclient(q);
  c:=p.X div size;
  r:=p.Y div size;
  if board[c,r]='E' then
  begin  {clicked on an empty square}
    if not oneclicked then
    begin  {start a new domino definition}
      board[c,r]:='X';
      oneclicked:=true;
    end
    else  {there's an 'X' on the board somewhere and user clicked an empty cell}
    begin
      setneighbor(c,r); {if it adjoined the X cell, add the domino}
      if board[c,r]='E' then {domino was not added because}
      begin {the 'X' cell was not a neighbor of the clicked cell, clear it}
        clearx;
        board[c,r]:='X'; {mark the clicked cell as the start of a new domino}
      end;
    end;
  end
  else
  begin  {cell is occupied, clear the 'X' or the entire domino}
    if board[c,r]<>'X'  then
    begin
      case board[c,r] of
        'L':board[c+1,r]:='E';
        'R':board[c-1,r]:='E';
        'U':board[c,r+1]:='E';
        'D':board[c,r-1]:='E';
      end;
      board[c,r]:='E';
      setneighbor(c,r); {If the cell just enpties is adjacent to the "X" square,
                         then add tha approriate domino}
    end
    else if oneclicked then clearx;
  end;
  drawboard;
end;

{*********** DrawBoard *********}
procedure TForm1.drawboard;
{Draw the board image and the dominoes based on contents of board array}
var
  c,r:integer;
  p:TPoint;
  ofs:integer;
begin
  ofs:=4;
  with image1, canvas do
  begin
    brush.color:=clwhite;
    rectangle(clientrect);
    brush.color:=clblack;
    font.color:=clwhite;
    for c:=0 to cols-1 do
    begin
      moveto(size*c, 0);
      lineto(size*c,height);
      for r:=0 to rows-1 do
      begin

      end;
    end;
    for r:=0 to rows-1 do
    begin
      moveto(0,size*r);
      lineto(width, size*r);
    end;
    for c:=0 to cols-1 do
    for r:=0 to rows-1 do
    begin
      p:=point(size*c,size*r);
      case board[c,r] of
        'X':
        begin
          rectangle(p.x+ofs,p.y+ofs,p.x+size-ofs,p.Y+size-ofs);
        end;
        'U':
        begin
          rectangle(p.x+ofs,p.y+ofs,p.x+size-ofs,p.Y+2*size-ofs);
        end;
        'L':
        begin
          rectangle(p.x+2,p.y+ofs,p.x+2*size-ofs,p.Y+size-ofs);
        end;
      end;
      //textout(p.X+ size div 2,p.Y+size div 2,board[c,r]);  {for debugging}
    end;
  end;
end;

{********* EmptyBoard *********}
 procedure Tform1.emptyboard;
 {Remove all dominoes and redraw empty board}
 var
   c,r:integer;
 begin
   placedlabel.caption:='0 Dominoes placed';
   for c:=0 to cols-1 do
   for r:=0 to rows-1 do board[c,r]:='E';
   drawboard;
 end;

{*************** CountGunPorts ************}
function TForm1.countgunports(board:TBoard; var DominoesPlaced:integer):integer;
{Count the gunports (empty cells not adjoined by an empty cell)
 Since we're checking anyway, also return the number of dominoes placed}
       var c,r:integer;
           n:integer;
           totempty:integer;
       begin
         result:=0;
         totempty:=0;
         for c:=0 to cols-1 do
         for r:=0 to rows-1 do
         begin
           n:=0;
           if board[c,r]='E' then
           begin {all 4 neighbors must be "out of bounds" or occupied}
             if (c=0) or
                ((c>0) and (board[c-1,r]<>'E'))
             then inc(n);
             if (c=cols-1) or
                ((c<cols-1) and (board[c+1,r]<>'E'))
             then inc(n);
             if (r=0) or
             ((r>0) and (board[c,r-1]<>'E'))
             then inc(n);
             if (r=rows-1) or
                 ((r<rows-1) and (board[c,r+1]<>'E'))
             then inc(n);
             if n=4 then inc(result);
             inc(totempty);
           end;
         end;
         DominoesPlaced:=(cols*rows - totempty) div 2;
       end;





procedure TForm1.ChangeSizeKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //if key=VK_RETURN then ChangeSizeClick(Sender);
end;


var loopcount:integer;
    opname:array[1..3] of string = ('<=','>=','=');


{********** CheckStop ***********}
function checkstop(lp: THandle; userhandle: Pointer): integer; stdcall;
{LPSOlve callback  user-abort function}
begin
   inc(loopcount);
   if (loopcount and $FFFF)=0 then
   begin  {let the timer pop, stop button, or exit messages be processed}
     application.ProcessMessages;
     result:=form1.solvebtn.tag;
     loopcount:=0;
     exit;
   end;
   result:=0;    {keep running}
end;


{************** SolveBtnClick **************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{The Solver - setup equations and run LPSolve linear programming solver
 to try to find a solution}
var

  h,v,m:array of array of integer;
  fhr,thr,fhc,thc:integer;  {Ranges for symmetry constraints}
  p,n:integer;
  s, name, sizename:string;
  op:integer;
  rh:Integer;
  nvars:integer;
  //LP:THandle;
  c,r:integer;
  count:integer;
  i:integer;
  PColData:PFloatArray;
  dominoesfound:integer;
  swapped:boolean;
  ss:string; {word string}

  {============= Setcoeff ===========}
  procedure Setcoeff(var s:string; level,r,c,coeff:integer);
  {Leve;=0=Horizontal portion of s}
  {r,c= row and column to set cooeff}
  var
    index:integer;
    fill:string;
  begin
   // index:=3*(rows*cols*level+(r-1)*cols+c)-1;
   index:=9*((r-1)*cols+c-1)+3*level+2;
    fill:=format('%2d',[coeff]);
    s[index]:=fill[1];
    s[index+1]:=fill[2];
  end;

  {============= AddConstraint ===========}
  procedure addConstraint(name:string);
    begin
      if str_add_constraint(lp,PChar(s),op, rh) then
      begin
        inc(count);
        set_row_name(lp,count,pchar(name+inttostr(count)));
        {for debugging}
       // memo1.Lines.add(name);
       // n:=3*rows*cols;
       // memo1.lines.add(format('%s - %s, - %s',
       //   [copy(s,1,n), copy(s,n+1,n),copy(s,2*n+1,n)]))
      end
      else showmessage('Invalid constraint '+name+': '+ s + opname[op]+ inttostr(trunc(rh)));
    end;


begin   {solvebtnclick}
  with solvebtn do
  begin
    if caption='Stop' then  {we are solving}
    begin
      tag:=1;  {Set stop flag}
      caption:='Search for solution';
      exit;
    end;
  end;
  {Not solving, so setup and strat}
  solvebtn.Tag:=0;
  solvebtn.caption:='Stop';

  nvars:=3*cols*rows;;
  count:=-1;
  memo1.clear;
  lp := make_lp(0,nvars);
  emptyboard;
  if (rows mod 3 >0) and (cols mod 3 = 0) then
  begin  {swap cols and rows for search}
    i:=cols;
    cols:=rows;
    rows:=i;
    swapped:=true;
  end
  else swapped:=false;
  if (lp <> 0) then
  begin

  {Set column names}
  {we have  3 binary variables for each of the rows*cols cells on the board:
      {1st rows* cols columns: 1 ==> horizontal domino starts here}
      {2nd rows* cols columns: 1 ==> vertical domino starts here}
      {3rd rows* cols columns: 1 ==> monomino exists here (cell with no monomimo neighbore}

   n:=0;
   {H set}
  for r:=1 to rows do
  for c:=1 to cols do
  begin
    //n:=(r-1)*cols+c;
    inc(n);
    s:=format('H%2d_%2d',[r,c]);
    if not set_col_name(lp,n,pchar(s))
    then showmessage('Set column name failed for '+ s);
    set_binary(lp,n,True);
    {V set}
    inc(n);
    s:=format('V%2d_%2d',[r,c]);
    if not set_col_name(lp,n,pchar(s))
    then showmessage('Set column name failed for '+ s);
    set_binary(lp,n,True);
    {M set}
    inc(n);
    s:=format('M%2d_%2d',[r,c]);
    if not set_col_name(lp,n,pchar(s))
    then showmessage('Set column name failed for '+ s);
    set_binary(lp,n,True);
  end;

  (*
  {V set}
  for r:=1 to rows do
  for c:=1 to cols do
  begin
    inc(n);
    s:=format('V%2d_%2d',[r,c]);
    if not set_col_name(lp,n,pchar(s))
    then showmessage('Set column name failed for '+ s);
    set_binary(lp,n,True);
  end;

  {M set}
  for r:=1 to rows do
  for c:=1 to cols do
  begin
    inc(n);
    s:=format('M%2d_%2d',[r,c]);
    if not set_col_name(lp,n,pchar(s))
    then showmessage('Set column name failed for '+ s);
    set_binary(lp,n,True);
  end;

  *)
  setlength(h,rows+1, cols+1);
  setlength(v,rows+1,cols+1);
  setlength(m,rows+1,cols+1);
  p:=nbrgunports;

  {Compute ranges for symmetry constraints}
  fhr:=rows div 2;
  if rows mod 2 =0 then thr:=fhr+1 else thr:=fhr+2;
  fhc:=cols div 2;
  if cols mod 2 =0 then thc:=fhc+1 else thc:=fhc+2;


  {Set Objective function
   Maximize sum(m[r,c]) for r:=1..rows, c:=1..cols}
  s:='';
  (*
  for r:=1 to rows*cols do s:=s+'  0'; {h values}
  for r:=1 to rows*cols do s:=s+'  0'; {v values}
  for r:=1 to rows*cols do s:=s+'  1'; {m values}
  *)
  for r:=1 to rows*cols do s:=s+'  0  0  1'; {h,v,m values}
  if  str_set_obj_fn(lp, pchar(s)) then
  begin
    set_row_name(lp,0,pchar('SumMono'));
    //memo1.lines.add('Objective:' );
    //memo1.lines.add(s);
    set_maxim(lp);
  end;

  {Set constraints}

  //Interior cells
  rh:=1;   op:=EQ;
  for r:=2 to rows-1 do  for c:=2 to cols-1 do
  begin
    s:='';
    for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
    Setcoeff(s,0,r,c-1,1);  {Only one of left/right half of a horizontal domino,}
    Setcoeff(s,0,r,c,1);
    Setcoeff(s,1,r-1,c,1); {or top/bottom half of a vertical domino, }
    Setcoeff(s,1,r,c,1);
    Setcoeff(s,2,r,c,1);   {or a monomino, may occupy a cell}
    addconstraint('Interior');
  end;

  // Edge cells top row
  rh:=1;   op:=EQ;
  for c:=2 to cols-1 do
  begin
    s:='';  for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
    Setcoeff(s,0,1,c-1,1);
    Setcoeff(s,0,1,c,1);
    Setcoeff(s,1,1,c,1);
    Setcoeff(s,2,1,c,1);
    AddConstraint('TopRow');
  end;

  // Edge cells bottom row
  rh:=1; op:=EQ;
  for c:=2 to cols-1 do
  begin
    s:='';
    for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
    Setcoeff(s,0,rows,c-1,1);
    Setcoeff(s,0,rows,c,1);
    Setcoeff(s,1,rows-1,c,1);
    Setcoeff(s,2,rows,c,1);
    AddConstraint('LastRow');
  end;

  //Edge cells leftmost colimn
  rh:=1; op:=EQ;
  for r:=2 to rows-1 do
  begin
    s:='';
    for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
    Setcoeff(s,0,r,1,1);
    Setcoeff(s,1,r-1,1,1);
    Setcoeff(s,1,r,1,1);
    Setcoeff(s,2,r,1,1);
    addConstraint('LeftCol');
  end;

  //Edge cell rightmost column
  rh:=1; op:=EQ;
  for r:=2 to rows-1 do
  begin
    s:='';
    for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
    Setcoeff(s,0,r,cols-1,1);
    Setcoeff(s,1,r-1,cols,1);
    Setcoeff(s,1,r,cols,1);
    Setcoeff(s,2,r,cols,1);
    AddConstraint('RightCol');
  end;

  //Corners
    // Cell[1,1]
    rh:=1; op:=EQ;
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      Setcoeff(s,0,1,1,1);
      Setcoeff(s,1,1,1,1);
      Setcoeff(s,2,1,1,1);
      AddConstraint('(1,1,)');
    end;

    //cell[1,cols]
    rh:=1; op:=EQ;
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      Setcoeff(s,0,1,cols-1,1);
      Setcoeff(s,1,1,cols,1);
      Setcoeff(s,2,1,cols,1);
      AddConstraint('(1,Cols)');
    end;

    //Cell[rows,1]
    rh:=1; op:=EQ;
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      Setcoeff(s,0,rows,1,1);
      Setcoeff(s,1,rows-1,1,1);
      Setcoeff(s,2,rows,1,1);
      AddConstraint('(Rows,1)');
    end;

    //Cell[rows,cols]
    rh:=1; op:=EQ;
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      Setcoeff(s,0,rows,cols-1,1);
      Setcoeff(s,1,rows-1,cols,1);
      Setcoeff(s,2,rows,cols,1);
      AddConstraint('(Rows,Cols)');
    end;

    //No horizontally adjacent monoiminoes
    rh:=1;  op:=LE;
    for r:=1 to rows do for c:=1 to cols-1 do
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      Setcoeff(s,2,r,c,1);
      Setcoeff(s,2,r,c+1,1);
      AddConstraint('HMono<=1');
    end;

    //No vertically adjacent monominoes
    rh:=1;  op:=LE;
    for r:=1 to rows-1 do for c:=1 to cols do
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      Setcoeff(s,2,r,c,1);
      Setcoeff(s,2,r+1,c,1);
      AddConstraint('VMono<=1');
    end;

    {Eliminate symmetries}
    If Eliminatesymmetries.checked then
    begin
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      for c:=1 to cols do for r:=1 to rows do
        if r<=fhr then  Setcoeff(s,2,r,c,1)
        else if r>=thr then Setcoeff(s,2,r,c, -1);
      op:=LE; rh:=0;
      AddConstraint('VertSym');

      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      for r:=1 to rows do for c:=1 to cols do
        if c<=fhc then Setcoeff(s,2,r,c,1)
        else if c>=thc then Setcoeff(s,2,r,c, -1);
      op:=LE; rh:=0;
      AddConstraint('HorizSym');
    end;

    if searchoptimum.checked then
    begin {Place specified number of monominoes }
      s:='';
      for i:=1 to nvars do s:=s+'  0';  {initialize all to 0}
      for r:=1 to rows do for c:=1 to cols do Setcoeff(s,2,r,c,1);
      op:=EQ; rh:=P;
      AddConstraint('TotMono');
    end;

    {Solve it!}
    starttime:=now;
    timer1.enabled:=true;
    loopcount:=0;
    screen.Cursor:=crhourglass;
    set_Break_at_first(lp,true);
    set_presolve(lp, PresolveDlg.presolvevalues{, 1000});
    (*
           presolve_Rows              {1}
          +Presolve_Cols             {2}
          +Presolve_LinDep           {4}
          +PRESOLVE_AGGREGATE        {8}
          +PRESOLVE_SPARSER         {16}
          //+PRESOLVE_SOS             {32}
          +presolve_reduceMIP       {64}
          +PRESOLVE_ELIMEQ2        {256}
          +PRESOLVE_IMPLIEDFREE    {512}
          +PRESOLVE_REDUCEGCD     {1024}
          +PRESOLVE_PROBEFIX      {2048}
          +PRESOLVE_PROBEREDUCE   {4096}
          +PRESOLVE_ROWDOMINATE   {8192}
          +PRESOLVE_COLDOMINATE  {16384}
          +PRESOLVE_MERGEROWS    {32768}
         // +PRESOLVE_IMPLIEDSLK   {65536}
         // +PRESOLVE_COLFIXDUAL  {131072}
         // +PRESOLVE_BOUNDS      {262144}
         // +PRESOLVE_DUALS       {524288}
         // +PRESOLVE_SENSDUALS  {1048576}
           ,1000);
    *)
    put_abortfunc(lp,checkstop,0);
    i:=solve(lp);
    timer1.enabled:=false;
    if i<>0 then
    begin
      showmessage('Not solved, Code='+solvecodes[i]);
    end
    else
    with memo1.lines do
    begin

      if not get_ptr_variables(lp,PcolData) then
      showmessage('Get_variables failed')
      else
      begin
          if swapped then
          begin  {swap cols and rows back after search}
            i:=cols;
            cols:=rows;
            rows:=i;
         end;

        add('');
        nvars:=get_nColumns(lp);
        dominoesfound:=0;
        for i:=0 to nvars-1 do  {display variable values}
        if pcoldata^[i]>0 then
        begin
          s:=get_col_name(lp,i+1);
          if (s[1]='H') or (s[1]='V') then inc(dominoesfound);
        end;

        sizename:=format('%2dx%2d',[rows,cols]);
        add('Solution for '+sizename +' found');
        if dominoesfound<>nbrdominoes
        then
        begin
          add(format('Suboptimal found: %d dominoes, %d ports',
                     [dominoesfound, cols*rows-2*dominoesfound]));
          add(format('Optimal should be: %d dominoes, %d ports',
                     [nbrdominoes, nbrgunports]));
        end
        else add(format('Optimal solution: %d dominoes, %d ports',
                     [nbrdominoes, nbrgunports]));
        emptyboard;
        placedlabel.caption:=inttostr(nbrdominoes)+' Dominoes placed';
        add('Dominoes are:');
        for i:=0 to nvars-1 do  {display variable values}
        if pcoldata^[i]>0 then
        begin
          name:=get_col_name(lp,i+1);
          s:=get_col_name(lp,i+1);
          if (s[1]='H') or (s[1]='V') then
          begin
            if swapped then
            begin
              if s[1]='H' then s[1]:='V' else s[1]:='H';


              ss:=copy(s,2,2);
              s[2]:=s[5];
              s[3]:=s[6];
              s[5]:=ss[1];
              s[6]:=ss[2];
            end;
            add(format('     %s ',[s]));
            r:=strtoint(copy(s,2,2));
            c:=strtoint(copy(s,5,2));
            if s[1]='H' then
            begin
              board[c-1,r-1]:='L';
              board[c,r-1]:='R';
            end
            else
            begin
              board[c-1,r-1]:='U';
              board[c-1,r]:='D';
            end
          end;
        end;
        drawboard;
        updatesolutions(sizename);
        //ShowConstraints;
      end;
    end;
    movetotop(memo1);
    datetimetostring(s,'HHH:NN:SS.ZZZ',now-starttime);
    Timelbl.caption:= 'Run time (HHH:MM:SS) '+s + ',  Presolve='+inttostr(Presolvedlg.presolvevalues);
  end;
  solvebtn.tag:=0;
  solvebtn.caption:='Search for solutions';
  screen.Cursor:=crDefault;
  delete_lp(lp);
end;

procedure TForm1.showconstraints;
var
  nvars,i,r,c,nrows:integer;
  s:string;
  PColData:PFloatArray;
  rowdata:array[0..1000] of real;
  sum:real;
begin
  with memo1, lines do
  begin
    add('Solved');
        add('Optimum variable values are:');
        nvars:=get_nColumns(lp);
        get_ptr_variables(lp,PcolData);
        for i:=0 to nvars-1 do  {display variable values}
        begin
          add(format('        %s = %.3f',[get_col_name(lp,i+1),PcolData^[i]]));
        end;
        add('');
        {display objective equation}
        for r:=0 to 0 do
        begin
          s:=get_row_name(lp,r);
          add(s);
          nrows:=get_nRows(lp);
          get_row(lp,r,@rowData);
          s:=format('         %.3f * %s ',[rowData[1],get_col_name(lp,1)]);

          for i:= 2 to nvars do
          s:=s+ format(' + %.3f * %s ',[rowData[i],get_col_name(lp,i)]);
          s:=s+' = ???';
          add(s);

          sum:=PcolData^[0]*rowData[1];
          s:=format('         %.3f * %.3f ',[rowData[1],PcolData^[0]]);
          for i:= 2 to nvars do
          begin
            s:=s+ format(' + %.3f * %.3f ',[rowData[i],PcolData^[i-1]]);
            sum:=sum+rowData[i]*PcolData^[i-1];
          end;
          s:=s +  ' = ' + format(' %.3f',[sum]);
          add(s);
        end;
      end;
  end;

{************ Updatesolutions *********}
procedure TForm1.UpdateSolutions(sizename:string);
{Save the current board configuration as a solution in the "Solutions" list}
   var
     j:integer;
     c,r:integer;
     index:integer;
     s:string;
   begin
     if allowsave.Checked then
     begin
       if not solutions.find(sizename,index)
       then index:=solutions.addobject(sizename,Tstringlist.create)
       else
       begin {already exists, ask about replacing it}
         memo1.Lines.add('Saved solution:');
         with TStringlist(solutions.objects[index]) do
         for j:=0 to count-1 do
         begin
           s:=format('  %s ',[strings[j]]);
           memo1.lines.add(s);
         end;

         if messagedlg('Solution already saved, replace it?',mtconfirmation,
             [mbyes,mbno],0)=mrno then index:=-1
         else TStringlist(solutions.objects[index]).clear;
       end;
       movetotop(memo1);
       if index>=0 then
       begin
         for c:=0 to cols-1 do
         for r:=0 to rows-1 do
         begin
           s:='';
           if board[c,r]='U' then s:='V'
           else if board[c,r]='L' then s:='H';
           if s<>'' then
           begin
             s:=s+format('%2d_%2d',[r+1,c+1]);
             if index>=0
             then TStringlist(solutions.objects[index]).add(trim(s));
           end;
         end;
         saveSolutions(filename);
       end;
     end;
   end;


{************ SaveSolutions ***********}
procedure TForm1.savesolutions(filename:string);
{Save solutions list to file}
var
  i:integer;
  str:TFileStream;
  s:string;
  len:integer;
begin
  str:=TFileStream.create(filename, fmCreate);
  with str do
  begin
    s:=solutions.text;
    len:=length(s);
    writebuffer(len,sizeof(len));
    writebuffer(s[1],len);
    for i:=0 to solutions.count-1 do
    begin
      s:=TStringlist(solutions.objects[i]).text;
      len:=length(s);
      writebuffer(len,sizeof(len));
      writebuffer(s[1],len);
    end;
  end;
  str.free;
end;

{************* LoadSolutions ***********8}
procedure TForm1.Loadsolutions(filename:string);
{Load saved solutions fiel into "Solutions" list}
var
  i:integer;
  str:TFileStream;
  s:string;
  len:integer;
begin
  str:=TFilestream.create(filename, fmOpenRead);
  with str do
  begin
    solutions.clear;
    readbuffer(len,sizeof(len));
    setlength(s,len);
    readbuffer(s[1], len);
    solutions.text:=s;
    for i:=0 to solutions.count-1 do
    begin
      readbuffer(len,sizeof(len));
      setlength(s,len);
      readbuffer(s[1], len);
      solutions.objects[i]:=TStringlist.create;
      TStringlist(solutions.objects[i]).text:=s;
    end;
  end;
  str.free;
end;

{************** SizeEdtChange **********}
procedure TForm1.SizeEdtChange(Sender: TObject);
{Update board size when number of rows or columns changes}
var
  s:string;
  n,errcode:integer;
begin
  s:=TEdit(Sender).text;
  if length(s)>0 then
  begin
    val(s,n,errcode);
    if (errcode=0) then setsize(colsud.position,rowsud.position);
  end;
end;


{********* Timer1Timer ************}
procedure TForm1.Timer1Timer(Sender: TObject);
{One second timer pop used while soling to update run time display}
var
  s:string;
begin
  datetimetostring(s,'HH:NN:SS',now-starttime);
  Timelbl.caption:= 'Run time (HH:MM:SS) '+s;
  timelbl.update;
end;

{**************** ViewBtnClick **************}
procedure TForm1.ViewBtnClick(Sender: TObject);
{Display a list of all saved solutions **********}
var
  i,r,c:integer;
  msg:string;
  {========= GetBoardSize =========}
  procedure getboardsize(s:string; var r,c:integer);
  {Extract board size row and columsn from a rrxcc srtring}
  begin
    r:=strtointdef(copy(s,1,2),0);
    c:=strtointdef(copy(s,4,2),0);
  end;

  {=============== GetNbrDominoes =======}
  function getnbrdominoes(r,c:integer):integer;
  {return the optimal number of dominoes for an rxc board}
  var
    g:integer;
  begin
     if (c mod 3 =0) or (r mod 3 = 0) then g:=c*r div 3
     else if (c mod 3) = (r mod 3) then g:=(c*r-4) div 3
     else g:=(c*r-2) div 3;
     result:=(c*r-g) div 2;
  end;


begin  {ViewBtnCLick}
  memo1.clear;
  memo1.lines.add('All saved solutions. Click a size to view.');
  with solutions do
  begin
    for i:=0 to count-1 do
    begin
      getboardsize(strings[i],r,c);
      if (r>0) and (c>0) then
      begin
        if getnbrdominoes(r,c)<>Tstrings(objects[i]).Count
        then  msg:=format('%s (Suboptimal: %d instead of %d were placed)',
         [strings[i],Tstrings(Objects[i]).count, getnbrdominoes(r,c)])
         else msg:=strings[i];
       memo1.lines.add(msg);
      end;
    end;
  end;
  movetotop(memo1);
end;

{************* Memo1Click ************}
procedure TForm1.Memo1Click(Sender: TObject);
var
  i,j:integer;
  r,c:integer;
  n:integer;
  s:string;
begin
  with memo1, lines do
  if count>1 then
  begin
    if (length(lines[0])>3) and (copy(lines[0],1,3)='All')
    then  {Saved solutions are displayed, replay the one that was clicked}
    begin
      emptyboard;
      {get clicked line}
      i:=clickedmemoLine(Memo1);
      s:=uppercase(strings[i]);
      n:=pos('X',s);

      if n>0 then
      begin
        colsud.position:=strtoint(copy(s,n+1,2));
        rowsud.position:=strtoint(copy(s,1,n-1));
        {get moves and display domonoes on the board)}
        with TStringlist(solutions.objects[i-1]) do
        begin
          placedlabel.caption:=inttostr(count)+ ' Dominoes placed';
          for j:=0 to count-1 do
          begin
            s:=trim(strings[j]);
            r:=strtoint(copy(s,2,2))-1;
            c:=strtoint(copy(s,5,2))-1;
            if s[1]='H' then
            begin
              board[c,r]:='L';
              board[c+1,r]:='R';
            end
            else
            begin
              board[c,r]:='U';
              board[c,r+1]:='D';
            end;
          end;
        end;
        drawboard;
      end;
    end;
  end;
end;



{************** Mdemo1KeyUp ************}
procedure TForm1.Memo1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 {Process "Delete" key to remoe a saved solution}
var
  n:integer;
begin
  If key=vk_delete then
  begin
    n:=clickedMemoLine(memo1);
    memo1.Lines.delete(n);
    TStringlist(solutions.objects[n-1]).free; {free the list of solution dominoes}
    solutions.delete(n-1);
    savesolutions(filename); {update the file}
  end;
end;

{************ ClearBtnBoard *********}
procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  emptyboard;
end;

{************* FormCloseQuery **********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Allow user to exit even if solution search is running}
begin
  solvebtn.tag:=1;
  canclose:=true;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Presolvedlg.showmodal;
end;

end.
