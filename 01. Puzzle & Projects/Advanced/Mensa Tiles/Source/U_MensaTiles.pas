unit U_MensaTiles;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A Mensa Tiles puzzle program,  User or computer can solve problems.

A set of tiles, each with a 1 to 5 digit number and totalling 25 digits are
provided or input.  Each tile is oriented vertically or horizontally.  The
objective is to arrange the tiles on a 5X5 grid so that the 5 numbers that
appear horizontally in the rows match the 5 numbers read vertically by column.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, inifiles, StdCtrls, ComCtrls, ExtCtrls;

type

  {A tile class derived from TstringGrid}
  TTileObj = class(TStringgrid)
   private
    constructor create(Aowner:TForm); reintroduce;
   public
    tilenbr:integer;{for speed - the position of this tile in the TTile array}
    moveto:TPoint;  {top/left coordinates of this tile when it is placed
                     on the board}
  end;

  TTiles= Array of TTileObj;  {Array of input tiles}

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    SetUpSheet: TTabSheet;
    PlaySheet: TTabSheet;
    PlayGrid: TStringGrid;
    HTileGrid: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    VTilegrid: TStringGrid;
    SaveBtn: TButton;
    LoadBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label3: TLabel;
    SolveBtn: TButton;
    ResetBtn: TButton;
    Introsheet: TTabSheet;
    Image1: TImage;
    Panel1: TPanel;
    Memo1: TMemo;
    Label4: TLabel;
    Memo2: TMemo;
    StopBtn: TButton;
    HintBtn: TButton;
    Label5: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure DragOverProc(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure DragDropProc(Sender, Source: TObject; X, Y: Integer);
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure DrawCellProc(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure SolveBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure PlaySheetDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PlaySheetDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StopBtnClick(Sender: TObject);
    procedure HintBtnClick(Sender: TObject);
  public
    {Public declarations }
    dragging:boolean;
    offsetx, offsety:integer;
    savecolor:TColor;
    filename:string;
    board:array of array of char;
    tiles:TTiles;
    modified:boolean;
    tilesOK:boolean; {tiles are 1-5 chars long and 25 characters in total}
    Solutionfound:boolean;
    procedure tryfits(N:integer);  {recursive tile search procedure}
    function  tilefits(i,j,n:integer):boolean;
    procedure addtile(i,j,n:integer);
    procedure removetile({i,j,}n:integer);
    procedure solved;
    procedure loadfile(fname:string);
    procedure savefile(fname:string);
    procedure inittile(dir:char;t:TTileobj; newleft, newtop:integer; s:string);
    procedure movetile(i:integer);
  end;

var   Form1: TForm1;

const boardsize=5;

implementation

{$R *.DFM}

{******************* TTileObj.Create ************}
constructor ttileObj.create(Aowner:TForm);
{Create a tile}
begin
  inherited create(Aowner);
  visible:=false;
  parent:=TForm(Aowner);
  defaultcolwidth:=24;
  defaultrowheight:=24;
  dragmode:=dmmanual;
  defaultdrawing:=false;
  scrollbars:=ssNone;
  moveto.x:=-1; moveto.y:=-1; {target location when solved}
  tilenbr:=-1;
end;

{****************** FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization stuff}
begin
  {doublebuffered:=true;}
  setlength(board, boardsize,boardsize);
  pagecontrol1.activepage:=Introsheet;
  modified:=false;
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=opendialog1.initialdir;
  {Move the Stop button in behind the Solve button so it will be
   hidden until we brig it back on top (while searching for a solution)}
  {This could be done at design time, except it is then hard for the programmer
   to detect that it exists at all!}
  stopbtn.top:=solvebtn.top;
  stopbtn.left:=solvebtn.left;
  stopbtn.sendtoback;
  randomize;
end;

{****************** TryFits **************}
procedure TForm1.tryfits(N:integer);
{Recursive search for solution path }
var i,j:integer;
begin
 if tag<>0 then exit;
 with tiles[N] do
  begin
    i:=0;
    j:=0;
    while (i<=boardsize-colcount) and (j<=boardsize-rowcount) do
    begin
      if tilefits(i,j,N)   then
      begin
         addtile(i,j,N);
         if N<high(tiles) then
         begin
           tryfits(N+1);
           {remove the tile to continue search unless it's solved!}
           if not solutionfound then removetile(N);
         end
         else
         begin
          {solved;}
          solutionfound:=true;
          break;
        end;
      end;
      inc(j);
      if j>boardsize-rowcount then
      begin
        j:=0;
        inc(i);
      end;
    end;
  end;
end;

{***************** Tilefits ****************}
function TForm1.tilefits(i,j,n:integer):boolean;
{Test if tile N will fit on the board with topleft corner at [i,j]}
{'Fit' means spaces are not occupied and the diagonal slots are
 empty or match the values on this tile}
var   c,r:integer;
begin
  result:=true;
 if (i>=0) and (j>=0) and (n>=0) then
  with tiles[n] do
  begin
    for c:= 0 to colcount-1 do
    begin
      for r:=0 to rowcount-1 do
      if (i+c < boardsize) and (j+r<boardsize) then
      begin
        if (board[i+c,j+r]=' ') and
           ((board[j+r,i+c]=' ') or (board[j+r,i+c]=cells[c,r][1]{tile[c,r]}))
        then
        else
        begin
          result:=false;
          break;
        end;
      end
      else result:=false;
      if result=false then break;
    end;
  end;
end;

{******************* Addtile ***********}
procedure TForm1.addtile(i,j,n:integer);
{Add tile N to the board at [i,j] }
var   c,r:integer;
begin
  with tiles[n] do
  begin
    for c:= 0 to colcount-1 do for r:=0 to rowcount-1
     do board[i+c,j+r]:=cells[c,r][1];
    moveto.x:=i;
    moveto.y:=j;
  end;
end;

{*************** RemoveTile ***************}
procedure TForm1.removetile({i,j,}n:integer);
{remove a previously added tile , used when backtracking}
var   c,r:integer;
      i,j:integer;
begin
  if n>=0 then
  with  tiles[n] do
  if (moveto.x>=0) and (moveto.y>=0) then
  begin
    i:=moveto.x; j:=moveto.y;
    for c:= 0 to colcount-1 do for r:=0 to rowcount-1 do  board[i+c,j+r]:=' ';
    moveto.x:=-1;
    moveto.y:=-1;
  end;
end;

 procedure TForm1.Movetile(i:integer);
 {animated tile move for tile i}
 var
 incr:integer;
  r:Trect;
  p:tpoint;
begin
  with tiles[i] do
  begin
    r:=playgrid.cellrect(moveto.x, moveto.y); {get pixel coordinates from
                                               target column and row}
    {cellrect coordinates are relative to playgrid, so need to adjust them to
     page coordinates}
    p.x:=playgrid.left+r.left;
    p.y:=playgrid.top+r.top;
    {Move horizontally a couple of pixels at a time}
    incr:=2;  if left>p.x then incr:=-incr;
    if application.mainform.tag=0 then  {tag>0 ==> user wants to stop, so skip animation}
    while abs(left-p.x)>abs(incr) do
    begin
      left:=left+incr;
      sleep(5); {wait 5 milliseconds}
      update;   {show the move}
    end;
    left:=p.x; {position exactly}
     application.processmessages;
    {Now move vertically}
    incr:=2; if top > p.y then incr:=-incr;
    if application.mainform.tag=0 then  {tag>0 ==> user wants to stop, so skip animation}
    while abs(top-p.y)>abs(incr) do
    begin
      top:=top+incr;
      sleep(5);
      update; {Show the move}
    end;
    top:=p.y;
    application.processmessages;
  end;
end;


{************** Solved *********}
Procedure TForm1.solved;
{called when the solution is found - animate moving the tiles
 onto the board}
var   i:integer;
begin
  for i := 0 to high(tiles) do {move tiles to final resting place}
  with tiles[i] do movetile(i);
end;


{**************** DragOverProc ******************}
procedure TForm1.DragOverProc(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{if the mouse is positioned over the playgrid, then we want to accept
 only if the tile will fit at its current location without overlappeing
 other tiles already placed (except that it can overlap itself).
 Other wise allow dropping}
var
  g, g2:TGridCoord;
begin
  accept:=false;
  if (source is ttileobj) and ((sender=playgrid) or (sender=source))
  then
  begin
    {is cursor over playgrid}
    if sender=playgrid then
    begin
      g:=playgrid.mousecoord (x,y);
    end
    else
    with sender as ttileobj do
    begin
      g:=mousecoord(x,y);
      g2:=playgrid.mousecoord(left-playgrid.left,top-playgrid.top);
      g.x:=g.x+g2.x;
      g.y:=g.y+g2.y;
    end;
    if (g.x<0) or (g.y<0)  {we're not over the playgrid}
    then accept:=true
    else  {we are over playgrid - make sure that entire tile wil fit}
    with source as ttileobj do
    if (g.x+ colcount<= playgrid.ColCount) and (g.y+rowcount<=playgrid.rowcount)
    then accept:=true;
  end;
end;

{******************** DragDropProc ****************}
procedure TForm1.DragDropProc(Sender, Source: TObject; X,
  Y: Integer);
{Called when a tile is dropped on the playgrid}
var
  xx,yy:integer;
  rr:TRect;
  g,g2:TGridCoord;
  AllOn, issolved:boolean;
  i,j:integer;
begin
  if (source is tTileObj) and (Sender is TStringgrid)
  then with source as tTileObj do
  begin
    if sender=playgrid then   g:=playgrid.mousecoord (x,y)
    else
    with sender as ttileobj do
    begin
      g:=mousecoord(x,y);
      g2:=playgrid.mousecoord(left-playgrid.left,top-playgrid.top);
      g.x:=g.x+g2.x;
      g.y:=g.y+g2.y;
    end;
    with playgrid do  rr:=cellrect(g.x,g.y);
    xx:=playgrid.left;
    yy:=playgrid.top;
    left:=rr.left+xx;
    top:=rr.top+yy;
    moveto.x:=g.x;
    moveto.y:=g.y;
    {check to see if all tiles are on the playgrid and if so,
     if the puzzle is solved}
    for i:=0 to boardsize-1 do for j:=0 to boardsize-1 do board[i,j]:=' ';
    i:=0; allOn:=true; issolved:=true;

    while (i<high(tiles)) and (allon) do
    with tiles[i] do
    begin
      if (left<playgrid.left) or (top<playgrid.top)
         or (left>playgrid.left+playgrid.width)
         or (top>playgrid.top+playgrid.height)
      then allon:=false
      else
      begin
        if tilefits(moveto.x,moveto.y,i) then addtile(moveto.x,moveto.y,i)
        else issolved:=false;
        inc(i);
      end;
    end;
    if allon then
    begin
      if issolved then showmessage('Congratulations!  You are ready for Mensa!')
      else Showmessage('Not yet, don''t give up though');
    end;
  end;
end;


{***************** LoadBtnCLick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
{Call loadfile when clicked}
var    r:integer;
begin
  r:=mryes;
  if modified then
  begin
    r:=messagedlg('Save current set of tiles first?',mtconfirmation,
                            [mbYes,MbNo, mbcancel],0);
    if r=mrYes then  savebtnclick(sender);
  end;
  if (r<>mrcancel) and opendialog1.execute then loadfile(opendialog1.filename);
  pagecontrol1.selectnextpage(true);
end;

{*************** SaveBtnClick **************}
procedure TForm1.SaveBtnClick(Sender: TObject);
{Call savefiel when clicked }
begin
  if savedialog1.execute then savefile(savedialog1.filename);
end;

{**************** Savefile ************}
procedure TForm1.savefile(fname:string);
{Save the current set of tiles }
var
  ini:TInifile;
  i:integer;
begin
  filename:=fname;  {save filename}
  ini:=TInifile.create(fname);
  with ini do
  begin
    with HTilegrid do
    begin
      writeinteger('Horizontals','Count',rowcount);
      for i:=0 to rowcount-1 do
        writestring('Horizontals','Nbr'+inttostr(i),cells[0,i]);
    end;
    with VTilegrid do
    begin
      writeinteger('Verticals','Count',rowcount);
      for i:=0 to rowcount-1 do
        writestring('Verticals','Nbr'+inttostr(i),cells[0,i]);
    end;
  end;
  ini.free;
  modified:=false;
end;

{************* Loadfile *************}
procedure TForm1.loadfile(fname:string);
{Load a set of tiles }
var
  ini:TInifile;
  i,count:integer;

begin
  filename:=fname;
  ini:=TInifile.create(fname);
  with ini do
  begin
    with hTileGrid do
    begin
      count:=readinteger('Horizontals','Count',0);
      for i:=0 to count-1 do
        cells[0,i]:=readstring('Horizontals','Nbr'+inttostr(i),'');
    end;

    with vTileGrid do
    begin
      count:=readinteger('Verticals','Count',0);
      for i:=0 to count-1 do
        cells[0,i]:=readstring('Verticals','Nbr'+inttostr(i),'');
    end;
  end;
  ini.free;
  modified:=false;
end;

{*************** InitTile *****************}
procedure TForm1.inittile(dir:char;t:TTileobj; newleft, newtop:integer;s:string);
{fill in event exits, values, and location information for a tile}
var
  j:integer;
  begin
    with t do
    begin
     ondragdrop:=DragdropProc;
     ondragover:=DragoverProc;
     ondrawcell:=DrawCellProc;
     onmousedown:=TileMouseDown;
     parent:=playsheet;
     if dir='H' then
     begin
       colcount:=length(s);
       rowcount:=1;
       for j:=1 to length(s) do cells[j-1,0]:=s[j];
     end
     else
     begin
       rowcount:=length(s);
       colcount:=1;
       for j:=1 to length(s) do cells[0,j-1]:=s[j];
     end;
     left:=newleft;
     top:= newtop;
     width:=(defaultcolwidth+1)*colcount;
     height:=(defaultrowheight+1)*rowcount;
   end
 end;

{*************** PageControl1Changing ************}
procedure TForm1.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
  var
    i:integer;
    s:string;
    sum:integer;
    r:integer;
begin
  {Leaving a tabsheet, if it's SetupSheet then make sure tiles are valid.}
  If pagecontrol1.activepage=setupsheet then
  begin
    tilesOK:=true;
    sum:=0;
    for i:=0 to htilegrid.rowcount-1 do
    with htilegrid do
    begin
      s:=trim(cells[0,i]);
      if length(s)>5 then
      begin
        showmessage('Horizontal tile '+ cells[0,i] + 'exceeds 5 characters');
        TilesOK:=false;
      end;
      sum:=sum+length(s);
    end;
    for i:=0 to vtilegrid.rowcount-1 do
    with vtilegrid do
    begin
      s:=trim(cells[0,i]);
      if length(s)>5 then
      begin
        showmessage('Vertical tile '+ cells[0,i] + 'exceeds 5 characters');
        TilesOK:=false;
      end;
      sum:=sum+length(s);
    end;
    if sum <> 25 then
    begin
      showmessage('Total number of digits on all tiles must be 25, found '+inttostr(sum));
      tilesOK:=false;
    end
    else
    if modified then
    begin
      r:=messagedlg('Save current set of tiles first?',mtconfirmation,
                            [mbYes,MbNo, mbcancel],0);
      if r=mrYes then  savebtnclick(sender);
    end;
  end;
end;

{******************* PageControlChange **************}
procedure TForm1.PageControl1Change(Sender: TObject);
{When entering the playsheet, build a new set of tiles based on
 SetupSheet tile definitions}
var
  i,j:integer;
  s:string;
  lasttop:integer; {top of lowest horizontal tile}
  nbrtiles:integer;
begin
   if Pagecontrol1.activepage=Playsheet then
   if tilesOK then
   begin
     {drawtiles for dragging}
     if length(tiles)>0  {free old tiles}
     then for i:=0 to high(tiles) do  with tiles[i] do free;
     setlength(tiles,htilegrid.rowcount+vtilegrid.rowcount); {maxsize}
     nbrtiles:=0;
     lasttop:=0;{used as top point for vertical tiles, move down as
                 horizontal tiles are added}
     with htilegrid do
     for i:= 0 to rowcount-1 do
     if trim(cells[0,i])<>'' then
     begin
       s:=trim(cells[0,i]);
       tiles[nbrtiles]:=TTileObj.create(self);
       tiles[nbrtiles].visible:=false;
       inc(nbrtiles);
       with tiles[nbrtiles-1] do
       begin
         inittile('H',tiles[nbrtiles-1],pagecontrol1.left+20,pagecontrol1.top+30*(i+1),s);
         tilenbr:=nbrtiles-1;
         lasttop:=top;
       end;
     end;
     with vtilegrid do
     for i:= 0 to rowcount-1 do
     if trim(cells[0,i])<>'' then
     begin
       s:=trim(cells[0,i]);
       if s<>'' then
       begin
         tiles[nbrtiles]:=TTileObj.create(self);
         tiles[nbrtiles].visible:=false;
         inc(nbrtiles);
         with tiles[nbrtiles-1] do
         begin
           tilenbr:=nbrtiles-1;
           inittile('V',tiles[nbrtiles-1],pagecontrol1.left+30*(i+1),lasttop+50,s);
         end;
       end;
     end;
     setlength(tiles,nbrtiles);
     for i:= 0 to nbrtiles-1 do tiles[i].visible:=true;
     for i:=0 to boardsize-1 do for j:=0 to boardsize-1 do board[i,j]:=' ';
     tag:=0;
     solutionfound:=false;
   end
   else showmessage('Tile set is invalid - return to Setup page and make corrections');
   application.processmessages;
end;

{************ DrawCellProc ***************}
procedure TForm1.DrawCellProc(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw cells ourselves to get rid of selected cell coloring}
begin
  with sender as TStringgrid do
    canvas.textout(rect.left+4,rect.top+4,cells[acol,arow]);
end;

{******************* SolveBtnClick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Solve button on playsheet was clicked }
begin
  pagecontrol1change(sender); {reset the page}
  screen.cursor:=crhourglass;
  tag:=0;  {Stop flag, stop solving if >0}
  stopbtn.bringtofront;
  resetbtn.enabled:=false;
  setupsheet.enabled:=false;
  introsheet.enabled:=false;
  tryfits(0);  {Start recursive solution search}
  screen.cursor:=crdefault;
  if (tag=0) and solutionfound then solved
  else showmessage('No solution found for this set of tiles');
  stopbtn.sendtoback;
  resetbtn.enabled:=true;
  setupsheet.enabled:=true;
  introsheet.enabled:=true;
end;

{******************** HintBtnClick ***********}
procedure TForm1.HintBtnClick(Sender: TObject);
{Move a random tile into its proper place}
begin
  pagecontrol1change(sender); {reset the page}
  screen.cursor:=crhourglass;
  tryfits(0);  {Start recursive solution search}
  if not solutionfound then showmessage('No solution possible for this set of tiles')
  else
  begin
    solutionfound:=false;
    movetile(random(length(tiles)));
  end;
  screen.cursor:=crdefault;
end;

{************* ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Rebuil;d tile display, just as we did when playsheet was opened}
begin   pagecontrol1change(sender); end;

{******************* PlaySheetDragOver ******************}
procedure TForm1.PlaySheetDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
{allow a tile to be dropped back on the sheet, outside of the playgrid}
begin   accept:=true; end;

{************ PlaySheetDragDrop ************}
procedure TForm1.PlaySheetDragDrop(Sender, Source: TObject; X, Y: Integer);
{Drop a tile back on the Playsheet page}
begin
  if source is ttileobj then
  with source as ttileobj
  do
  begin
    left:=x;
    top:=y;
    moveto.x:=-1;
    moveto.y:=-1;
  end;
end;

{************ TileMouseDown *****************}
procedure TForm1.TileMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Used to start dragging when the mouse moves on the tile with a button down}
begin
  if sender is ttileobj then TTileobj(sender).begindrag(false);
end;

{********************* GridKeyPress ****************}
procedure TForm1.GridKeyPress(Sender: TObject; var Key: Char);
{set modified flag to warn user to save before leaving}
begin  modified:=true  end;

{********************** FormCloseQuery *************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{set flag to stop any solving process and allow close}
begin
  tag:=1;
  canclose:=true;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
{set flag to stop solving or showing animation}
begin   tag:=1; end;


end.
