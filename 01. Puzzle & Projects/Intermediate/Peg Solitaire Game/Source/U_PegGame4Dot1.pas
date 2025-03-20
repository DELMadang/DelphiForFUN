Unit U_PegGame4Dot1;
{Copyright  © 2001, 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Peg solitaire solver - solves seven common cofigurations of a 33 hole
  7X7 board.  Moves are made by jumping a peg to an empty hole in any
  of the 4 major directions and removing the jumped peg.  The goal
  is to make the last move into the center hole.}

 {August 2001, Version 2.0 - allows user play}

 {March 2004, Version 2.1 - Add CrackerBarrel tringular version}

 {January 2007,  Version 3 - Add "Bart's Puzzle"}

 {April, 2010, Version 4: 1) Allow user specification of any row and column for one peg solutions
                          2) Save and reload custom puzzles }

{July  2010, Version 4.1 based on corrections provided by viewer Per Andersson.  (Thanks Per, nice job.)
Here is his email:

1) In manual mode it is possible to drag a hole and jump over a peg, just as if the hole was a normal peg.
To get around it I added an if-statement before "dragobject:=nil" in the procedure "TForm1.Image1StartDrag()"
    if board.b[dragstartx + 2, dragstarty + 2] <> Occupied  then Abort else dragobject:=nil; //new

2) When clicking on "Cracker Barrel" and changing puzzle size you have to choose
a different board and then back to Cracker Barrel" before the new size is displayed.
I added a call to LoadABoard() in TForm1.BoardgrpClick() as seen below:
     If  boardgrp.itemindex = 8 then
     begin
       crackerBarreldlg.showmodal;
       diagonals.checked:=true;
       targetXedt.text:='1';
       targetyedt.text:='1';
       LoadABoard(true); //new
     end

3) Another Cracker Barrel bug. It says "No moves remaining" even when a diagonal move can be made.

To solve it I added two more lines to the check in function "TBoard.canmove:boolean", so it now looks like:

      if    (b[i,j-1]=occupied) and (b[i,j-2]=empty)
        or  (b[i+1,j]=occupied) and (b[i+2,j]=empty)
        or  (b[i,j+1]=occupied) and (b[i,j+2]=empty)
        or  (b[i-1,j]=occupied) and (b[i-2,j]=empty)
        or  (AllowDiagonals and (b[i+1,j-1]=occupied) and (b[i+2,j-2]=empty)) //new
        or  (AllowDiagonals and (b[i-1,j+1]=occupied) and (b[i-2,j+2]=empty)) //new

Regards
Per

For Per's second bug fix (changing size for the Crackerbarrel puzzle), I added a new "Change size" button
only visible when a Crackbarrel puzzle is displayed because, at least in Delphi 7, clicks on an already selected
radio button in a RadioGroup are ignored, so there was no way to change size without selecting a different puzzle
type button and then re-clicking the  Cracker Barrel radio button.  The "Change size" button fixes that.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   StdCtrls, ExtCtrls, ComCtrls, shellAPI, u_PegBoard4Dot1, U_CrackerDlg;

type

  TMode=(done, solving, replaying);

  TForm1 = class(TForm)
    SolveBtn: TButton;
    Boardgrp: TRadioGroup;
    FreqLabel: TLabel;
    Image1: TImage;
    ResetBtn: TButton;
    Label2: TLabel;
    SolveGrp: TRadioGroup;
    StaticText1: TStaticText;
    Label3: TLabel;
    Diagonals: TCheckBox;
    ReplayPanel: TPanel;
    Label1: TLabel;
    ReplayBtn: TButton;
    Speedbar: TTrackBar;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    TargetXEdt: TLabeledEdit;
    TargetYEdt: TLabeledEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    LoadBtn: TButton;
    SaveBtn: TButton;
    NewCustomBtn: TButton;
    CrackerSizeBtn: TButton;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ReplayBtnClick(Sender: TObject);
    procedure SpeedbarChange(Sender: TObject);
    procedure BoardgrpClick(Sender: TObject);
    procedure Image1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure Image1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SolveGrpClick(Sender: TObject);
    procedure DiagonalsClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure NewCustomBtnClick(Sender: TObject);
    procedure TargetEdtChange(Sender: TObject);
    procedure CrackerSizeBtnClick(Sender: TObject);
  public
    board:TBoard;
    startcount, freq :int64;
    mode:TMode;
    boxw,boxh:integer;  {Image width and height div 6}
    dragstartx,dragstarty:integer;
    fname:string;
    modified:boolean;
    CurrentItemIndex:integer;
    function LoadABoard(newboard:boolean):boolean;
    procedure status;
    procedure moveSmallToBig(a:Tsmallarray);
    procedure moveBigToSmall(var a:TSmallArray);
    procedure solveit;
    Function CheckModified:boolean;
    procedure SavePuzzle(filename:string);
    procedure LoadPuzzle(filename:string);
  end;


var
  Form1: TForm1;

implementation

{$R *.DFM}


{note - these arrays are stored with row as the high level index
        which makes it easier to see the figure outline in the
        data display, but must be reversed when storing in the board
        array which has column as the high level index}
var


  crossarray:Tsmallarray=(      (2,2,0,0,0,2,2),
                                (2,2,0,1,0,2,2),
                                (0,0,1,1,1,0,0),
                                (0,0,0,1,0,0,0),
                                (0,0,0,1,0,0,0),
                                (2,2,0,0,0,2,2),
                                (2,2,0,0,0,2,2));

  plusarray:Tsmallarray=(       (2,2,0,0,0,2,2),
                                (2,2,0,1,0,2,2),
                                (0,0,0,1,0,0,0),
                                (0,1,1,1,1,1,0),
                                (0,0,0,1,0,0,0),
                                (2,2,0,1,0,2,2),
                                (2,2,0,0,0,2,2));

  fireplacearray:Tsmallarray=(  (2,2,1,1,1,2,2),
                                (2,2,1,1,1,2,2),
                                (0,0,1,1,1,0,0),
                                (0,0,1,0,1,0,0),
                                (0,0,0,0,0,0,0),
                                (2,2,0,0,0,2,2),
                                (2,2,0,0,0,2,2));

  upArrowArray:Tsmallarray=(    (2,2,0,1,0,2,2),
                                (2,2,1,1,1,2,2),
                                (0,1,1,1,1,1,0),
                                (0,0,0,1,0,0,0),
                                (0,0,0,1,0,0,0),
                                (2,2,1,1,1,2,2),
                                (2,2,1,1,1,2,2));

  pyramidArray:Tsmallarray=(    (2,2,0,0,0,2,2),
                                (2,2,0,1,0,2,2),
                                (0,0,1,1,1,0,0),
                                (0,1,1,1,1,1,0),
                                (1,1,1,1,1,1,1),
                                (2,2,0,0,0,2,2),
                                (2,2,0,0,0,2,2));

  diamondArray:Tsmallarray=(    (2,2,0,1,0,2,2),
                                (2,2,1,1,1,2,2),
                                (0,1,1,1,1,1,0),
                                (1,1,1,0,1,1,1),
                                (0,1,1,1,1,1,0),
                                (2,2,1,1,1,2,2),
                                (2,2,0,1,0,2,2));

  solitairearray:Tsmallarray=(  (2,2,1,1,1,2,2),
                                (2,2,1,1,1,2,2),
                                (1,1,1,1,1,1,1),
                                (1,1,1,0,1,1,1),
                                (1,1,1,1,1,1,1),
                                (2,2,1,1,1,2,2),
                                (2,2,1,1,1,2,2));

  trianglearray5:Tsmallarray=(  (0,1,1,1,1,2,2),
                                (1,1,1,1,2,2,2),
                                (1,1,1,2,2,2,2),
                                (1,1,2,2,2,2,2),
                                (1,2,2,2,2,2,2),
                                (2,2,2,2,2,2,2),
                                (2,2,2,2,2,2,2));
  trianglearray6:Tsmallarray=(  (0,1,1,1,1,1,2),
                                (1,1,1,1,1,2,2),
                                (1,1,1,1,2,2,2),
                                (1,1,1,2,2,2,2),
                                (1,1,2,2,2,2,2),
                                (1,2,2,2,2,2,2),
                                (2,2,2,2,2,2,2));

 BartsArray:Tsmallarray=(       (2,2,1,1,1,2,2),
                                (2,2,1,1,1,2,2),
                                (1,1,0,1,0,1,1),
                                (1,1,1,1,1,1,1),
                                (0,0,1,0,1,0,0),
                                (2,2,0,1,0,2,2),
                                (2,2,0,1,0,2,2)
                                );


 trianglearray7:Tsmallarray=(   (0,1,1,1,1,1,1),
                                (1,1,1,1,1,1,2),
                                (1,1,1,1,1,2,2),
                                (1,1,1,1,2,2,2),
                                (1,1,1,2,2,2,2),
                                (1,1,2,2,2,2,2),
                                (1,2,2,2,2,2,2));


 Customarray:Tsmallarray=(      (2,2,1,1,1,2,2),  {This array may get modified}
                                (2,1,1,1,1,1,2),
                                (1,1,1,1,1,1,1),
                                (1,1,1,0,1,1,1),
                                (1,1,1,1,1,1,1),
                                (2,1,1,1,1,1,2),
                                (2,2,1,1,1,2,2));

DefaultCustomarray:Tsmallarray=((2,2,1,1,1,2,2), {Original and default custom array}
                                (2,1,1,1,1,1,2),
                                (1,1,1,1,1,1,1),
                                (1,1,1,0,1,1,1),
                                (1,1,1,1,1,1,1),
                                (2,1,1,1,1,1,2),
                                (2,2,1,1,1,2,2));




{********************** MoveSmallToBig *****************}
procedure TForm1.MovesmallToBig(a:Tsmallarray);  {local data move routine - takes one
                          of the seven board definition arrays as a parameter}
     var  i,j:integer;
          holefound:boolean;
     begin
       board.totpegs:=0;
       for j:= 0 to 10 do
       begin
         board.rowstart[j]:=2;
         holefound:=false;
         for i:= 0 to 10 do
         with board do
         begin
           if (i>=2) and (i<=8) and (j>=2) and (j<=8)
           then
           begin
              b[j,i]:=TOccupiedtype(a[i,j]);
              if b[j,i]=occupied then inc(totpegs);
              holefound:=true;
           end
           else
           begin
             b[j,i]:=NotAvailable;
             if not holefound then rowstart[j]:=i;
           end;
         end;
       end;
       board.pegcount:=board.totpegs;
       {now find row ends}
       with board do
       for j:=2 to 8 do
       begin
         rowend[j]:=8;
         for i := 8 downto 2 do
         if b[j,i]<>NotAvailable then
         begin
           rowend[j]:=i;
           break;
         end;
       end;
     end;

{**************** MoveBigToSmall **************}
procedure TForm1.MoveBigToSmall(var a:Tsmallarray);  {local data move routine - takes one
                          of the seven board definition arrays as a parameter}
     var  i,j:integer;
     begin
       for i:= 0 to 10 do
       for j:= 0 to 10 do
       with board do
       begin
         if (i>=2) and (i<=8) and (j>=2) and (j<=8)
         then a[i,j]:=Byte(b[j,i]);
       end;
     end;


{******************* Tform1.LoadABoard **********}
Function tform1.loadABoard(newboard:boolean):boolean;
{copy set of data defining a figure into the board array}
begin
  result:=true;
  if newboard then
  begin
    if (currentItemindex=9) and
    (boardgrp.itemindex<>9) then if not checkModified then
    begin
      result:=false;
      exit;
    end;
    if assigned (board) then board.free;
    board:=tboard.create;
    board.onstatus:=status;
    speedbarchange(self);
    replaypanel.visible:=false;
    memo1.clear;
  end;

  diagonals.visible:=true;

  case boardgrp.itemindex of
    0: {cross} movesmalltobig(crossarray);
    1: {plus}  MoveSmallToBig(plusarray);
    2: {fireplace} MoveSmallToBig(fireplacearray);
    3: {uparrow} MoveSmallToBig(uparrowarray);
    4: {diamond} MoveSmallToBig(diamondarray);
    5: {pyramid} MoveSmallToBig(pyramidarray);
    6: {solitaire} MoveSmallToBig(solitairearray);
    7: {Bart's} MoveSmallToBig(BartsArray);
    8: {triangle - "Cracker barrel" Puzzle}
      begin
        case crackerBarreldlg.Psize.itemindex of
          0: MoveSmallToBig(trianglearray5);
          1: MoveSmallToBig(trianglearray6);
          2: MoveSmallToBig(trianglearray7);
        end;
        board.AllowDiagonals:=true;
        diagonals.checked:=true;
      end;
    9: {custom}
      begin
        MoveSmallToBig(Customarray{customarray});
        diagonals.visible:=true;
      end;
  end;

  with board do
  case solvegrp.itemindex of
    0: solpegcount:=4;
    1: solpegcount:=3;
    2: solpegcount:=2;
    3: solpegcount:=1;
    (*
    4: begin
         solpegcount:=1;
         if boardgrp.itemindex<=7 then onemode:=oneincenter
         else onemode:=oneinstart;
      end;
    *)  
    4: begin
         solpegcount:=1;
       end;
  end; {case}
  board.allowdiagonals:=diagonals.checked;
  board.draw(image1);
end;

{************************ TForm1.Status ******************}
procedure TForm1.status;
{output periodic status updates - called as TBoard.OnStatus}
var
  n:int64;
begin
   queryperformancecounter(n);
   freqlabel.caption:=(format('%8.0n moves per second,     %12.0n moves tried '{, %6.0n'},
       [board.totcount*freq/(n-startcount), 0.0+board.totcount {, allocmemsize+0.0}]));
end;

{****************** SolveIt **************}
procedure TForm1.solveit;
var
  r:boolean;
  begin
    mode:=solving;
    solvebtn.caption:='Stop';
    screen.cursor:=crHourglass;
    r:=board.moves;   {recursive search for solution, returns true if solved}
    screen.cursor:=crdefault;

    if r and (not board.stop) then
    with board, memo1 do
    begin
      clear;
      lines.add('Moves to solve');
      lines.add('(Col,Row) to (Col,Row)');
      lines.add('----------------------');
      replaypanel.visible:=true;
      replaybtnclick(nil);
    end
    else Memo1.lines.add('No solution found');
    status;
    mode:=done;
    solvebtn.caption:='Solve it';
  end;

{******************** TForm1.SolveBtnLCick **************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Compute a solution}
var
  OK:boolean;
begin
  if (mode = solving) or (mode=replaying)  then {STOP was clicked}
  begin
    board.stop:=true;
    application.processmessages;
    resetbtnclick(sender);
    exit;
  end;
  {otherwise set up auto-solve}
  if board.pegcount<=1
  then
  begin
    {make a new board}
    if not  LoadABoard(true)  then exit;
  end
  else {resetboardcounts}
  begin
    replaypanel.visible:=false;
    board.stop:=false;
  end;
  Memo1.clear;
  OK:=true;
  {set up solution critria}
  board.onemode:=none;

  with board do
  case solvegrp.itemindex of
    0: solpegcount:=4;
    1: solpegcount:=3;
    2: solpegcount:=2;
    3: solpegcount:=1;
    (*
    4: begin
         solpegcount:=1;
         case boardgrp.itemindex  of
           0..6:
           begin
             //onemode:=oneincenter
             onemode:=oneatpoint;
             Target:=point(5,5);
           end;
           7: onemode:=oneinstart;
         end;
       end;
     *)
    4: begin
         solpegcount:=1;
         onemode:=oneatHole;
         target.x:=strtointdef(TargetXedt.Text,-1)+1;
         target.y:=strtointdef(targetYEdt.Text,-1)+1;
         if (target.x=0) or (target.Y=0) then
         begin
           showmessage('Enter the target column and row first');
           OK:=false;
         end;
       end;
  end; {case}
  queryperformancefrequency(freq);
  queryperformancecounter(startcount);
  if OK then solveit;
end;

Function TForm1.CheckModified:Boolean;
var r:integer;
begin
  result:=true;
  if modified then
  begin
    R:=MessageDlg('Custom puzzle has been modified. Save it first?',mtconfirmation,
                  [Mbyes, mbno, mbCancel],0);
    If r=mrcancel then result:=false
    else if r= mryes then
    if savedialog1.execute then Savepuzzle(Savedialog1.filename)
    else result:=false;
    modified := not result;   {If user canceled (result=false) then leave "modified" at true}
  end;
end;


{***************** FormCreate ****************}
procedure TForm1.FormCreate(Sender: TObject);
{initialization stuff}
begin
  doublebuffered:=true; {prevent flicker}
  currentItemindex:=boardgrp.itemindex;
  Opendialog1.InitialDir:=extractfilepath(application.ExeName);
  Savedialog1.InitialDir:=Opendialog1.initialdir;
  modified:=false;
  loadaboard(true);  {make a new board}
  boxw:=image1.width div 7;
  boxh:=image1.height div 7;
  {load drag cursors}
  screen.cursors[crDrag]:=LoadCursor(HInstance, 'PEGDROP');
  screen.cursors[crNoDrop]:=LoadCursor(HInstance, 'PEGNODROP');
  mode:=done;
  //fname:=extractfilepath(application.exename)+'SavedGame.stm';
  //if fileexists(fname) then PauseBtn.visible:=true;
  boardgrpclick(sender);
end;

{******************** FormCloseQuery *****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{set flag to let solving stop if user clicks close}
begin
  if assigned(board) then board.stop:=true;
  canclose:=true;
end;

{******************** Speedbarchange ***************}
procedure TForm1.SpeedbarChange(Sender: TObject);
{Controls speed of animations}
begin
  with Speedbar do  board.delayms:=max-position;
end;

{******************** Boardgroupclick *************}
procedure TForm1.BoardgrpClick(Sender: TObject);
{New puzzle selected}

begin
  if not loadAboard(true)  {load a new board}
  then exit;
  if  mode<>done then
  begin
    board.stop:=true;
    application.processmessages;
  end;
  memo1.clear;
  panel1.visible:=false;
  {Can't let the user replay after he's selected a different board}
  replaypanel.visible:=false;
  diagonals.checked:=false;
  CrackerSizeBtn.visible:=false;
  If  boardgrp.itemindex = 8 then
  begin
    crackerBarreldlg.showmodal;
    diagonals.checked:=true;
    targetXedt.text:='1';
    targetyedt.text:='1';
    LoadABoard(true);
    CrackerSizebtn.visible:=true;
  end
  else
  begin
    targetXedt.text:='4';
    targetyedt.text:='4';
    if boardgrp.itemindex=9 then panel1.visible:=true;
  end;
  currentItemIndex:=boardGrp.Itemindex;
end;

procedure TForm1.CrackerSizeBtnClick(Sender: TObject);
begin
  BoardGrpClick(sender);
end;


{******************* ResetBtnCick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin

  board.stop:=true;
  application.processmessages;
  if not loadaboard(true) then exit;
  mode:=done;
  solvebtn.caption:='Solve it';

  freqlabel.caption:='';
end;

{*************** ReplayBtnCick ***************}
procedure TForm1.ReplayBtnClick(Sender: TObject);
{replay the moves after puzzle is solved}
var i:integer;
begin
  if mode=replaying then  exit;
  if board.path.count>0 then
  with board do
  begin
    mode:=replaying;
    rebuildboard;
    board.stop:=false;
    solvebtn.caption:='Stop';
    mode:=replaying;

    with memo1 do for i:= lines.count-1 downto 3 do lines.delete(i);
    i:=0;
    if path.count-1>0 then
    repeat
      with pTmove(path[i])^ do
      begin
        memo1.lines.add(format('%2d) From ('+inttostr(frompoint.x-1)+','+inttostr(frompoint.y-1)
                + ') to ('+ inttostr(topoint.x-1)+','+inttostr(topoint.y-1)+')',[i+1]));
        movepeg(point(frompoint.x-1,frompoint.y-1),
                                      point(topoint.x-1,topoint.y-1));
      end;
      if board.stop then break;
      inc(i);
    until i>path.count-1;
    mode:=done;;
    solvebtn.caption:='Solve it';
    if board.stop then loadaboard(false);
  end;
end;

{************ SavePuzzle ***********}
procedure TForm1.Savepuzzle(filename:string);
var
  f:textfile;
  i,j:integer;
begin
  assignfile(f,filename);
  rewrite(f);
  for i:= low(CustomArray) to high(CustomArray) do
  begin
    for j:=low(CustomArray[i]) to high(CustomArray[i]) do write(f,CustomArray[j,i],' ');
    writeln(f);
 end;
 writeln(f,SolveGrp.itemindex:2, targetxedt.text:2, targetyedt.text:2);
 closefile(f);
end;

{*********** LoadPuzzle ************}
procedure TForm1.Loadpuzzle(filename:string);
var
  f:textfile;
  i,j:integer;
  x,y:string[2];
begin
  if fileexists(filename) then
  begin
    assignfile(f,filename);
    reset(f);
    for i:= low(CustomArray) to high(CustomArray) do
    begin
      for j:=low(CustomArray[i]) to high(CustomArray[i]) do read(f,CustomArray[j,i]);
      readln(f);
    end;
 end;
 if not eof(f) then
 begin
   readln(f,i,x,y);
   SolveGrp.itemindex:=i;
   targetxedt.text:=x;
   targetyedt.text:=y;
 end;  
 closefile(f);
 loadAboard(true)
end;

{******************** StaticText1Click ******************}
procedure TForm1.StaticText1Click(Sender: TObject);
{Browse DelphiForFun homepage}
begin
     ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;


{**************** SolvegrpClick *************}
procedure TForm1.SolveGrpClick(Sender: TObject);
begin
  resetbtnclick(sender);
end;

{******************** DiagonalsClick *************}
procedure TForm1.DiagonalsClick(Sender: TObject);
begin
  board.allowdiagonals:=diagonals.checked
end;


{***************** Image1StartDrag *************}
procedure TForm1.Image1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  p:TPoint;
begin
  p:=image1.screentoclient(mouse.cursorpos);
  dragstartx:=p.x div boxw;
  dragstarty:=p.y div boxh;
   dragobject:=nil;
  if board.b[dragstartx +2, dragstarty+2] <> Occupied
  then abort;
end;

{***************** Image1DragOver ****************}
procedure TForm1.Image1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  nx,ny,dx,dy:integer;
begin
   nx:=x div boxw;  {column}
   ny:=y div boxh;  {row}
   dx:=nx-dragstartx;
   dy:=ny-dragstarty;
   if (board.b[nx+2,ny+2]=empty) {we are over an empty cell}
   then
   begin
      if  (
            ( (dx=0) {vertical move}
               and (abs(ny-dragstarty)=2)
               and (board.b[nx+2,(dragstarty+ny) div 2+2]= occupied)
             )
      or    (
              (dy=0)  {horizontal move}
                and (abs(nx-dragstartx)=2)
                and (board.b[(dragstartx+nx) div 2 +2, ny+2]= occupied)
             )
      or    ( board.allowdiagonals
              and (   ((dx=2) and (dy=-2)
                     )
                    or
                    (  (dx=-2) and (dy=2)
                     )
                )
             and (board.b[dragstartx+ dx div 2 +2, dragstarty + dy div 2 +2]= occupied)
           )
         )
     then accept:=true
     else  accept:=false;
   end
   else accept:=false;
end;

{******************* Image1DragDrop ******************}
procedure TForm1.Image1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  nx,ny:integer;
  midx,midy:integer;
  msg:string;
begin
  with board do
  begin
    nx:=x div boxw;
    ny:=y div boxh;
    midx:=(nx+dragstartx) div 2;
    midy:=(ny+dragstarty) div 2;
    board.makemove(point(dragstartx+2,dragstarty+2),
                   point(midx+2,midy+2),
                   point(nx+2,ny+2));
    drawslot(nx,ny);
    drawslot(dragstartx, dragstarty);
    drawslot(midx,midy);
    with pTmove(path[path.count-1])^ do
    begin
      {adjust "move" data from 2-8 range back to to 1-7 range}
      Memo1.lines.add('From ('+inttostr(frompoint.x-1)+','+inttostr(frompoint.y-1)
                + ') to ('+ inttostr(topoint.x-1)+','+inttostr(topoint.y-1)+')');
    end;
    if not canmove then
    begin
      if solved then msg:='Congratulations!' else
      begin
        if pegcount>solpegcount+2 then msg:='That''s pitiful!'
        else if pegcount>solpegcount+1 then msg:='Not bad'
        else msg:='Almost made it!'
      end;
     showmessage('No moves remaining - you have ' +inttostr(pegcount) +' pegs left'
              +#13+msg);
    end;
  end;
end;


{**************** Image1MouseUp ****************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var
  bx,by:integer;
begin
  if button=mbright then
  begin
    if  boardgrp.itemindex<>9 then
    begin
      {save it in CustomArray (so reset can restore it)}
      MoveBigToSmall(CustomArray);
      boardgrp.itemindex:=9;
    end;
    modified:=true;
    bx:=x div boxw + 2;
    by:=y div boxh + 2;
    with board do
    case b[bx,by] of
      empty: begin
               {b[bx,by]:=occupied;}
                CustomArray[by,bx]:=byte(occupied);
               inc(pegcount);
             end;
      occupied: begin
                 { b[bx,by]:=Notavailable;   }
                  CustomArray[by,bx]:=byte(NotAvailable);
                  {dec(pegcount);  }
                end;
      NotAvailable: Begin
                      {b[bx,by]:=empty; }
                      CustomArray[by,bx]:=byte(empty);
                    End;
    end;
    movesmalltobig(CustomArray);
    board.drawslot(bx-2,by-2);
  end;
end;


{************* LoadBtnCLick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  If checkmodified then
  begin
    If opendialog1.execute then
    begin
      loadPuzzle(opendialog1.filename);
      savedialog1.filename:=opendialog1.filename;
    end;
  end;
end;

{************ SaveBtnClick ********}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  if Boardgrp.itemindex=9 then {redundant test?}
  begin
    if savedialog1.execute then
    begin
      savepuzzle(savedialog1.filename);
      modified:=false;
    end;
  end;
end;

{************* NewCustomBtnClick ***********8}
procedure TForm1.NewCustomBtnClick(Sender: TObject);
begin
  If (currentitemindex=9) and checkmodified then
  begin
    CustomArray:=DefaultCustomArray;
    loadAboard(true);
  end;
end;

{*********** TargetEdtChange *******}
procedure TForm1.TargetEdtChange(Sender: TObject);
begin
  if solvegrp.itemindex=9 then
  begin
    resetbtnclick(sender);
    modified:=true;
  end;
end;






end.
