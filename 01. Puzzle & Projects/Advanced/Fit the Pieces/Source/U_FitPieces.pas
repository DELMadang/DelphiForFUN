unit U_FitPieces;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Grids, ucomboV2;

type
  string2=string[2];

  TBlock=class(TStringgrid)
    public
    rank:integer;
    positiononboard:integer; {<0 if not on board yet, 0..7 on board if in place}
    solutionlocation:integer;
    homex,homey:integer;  {home location for this block}
    constructor create(proto:TStringgrid);
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    HintBtn: TButton;
    Board: TStringGrid;
    SGH1: TStringGrid;
    SGV1: TStringGrid;
    SGH2: TStringGrid;
    SGH3: TStringGrid;
    SGV2: TStringGrid;
    SGV3: TStringGrid;
    SGH4: TStringGrid;
    SGV4: TStringGrid;
    Memo2: TMemo;
    ResetBtn: TButton;

    procedure StaticText1Click(Sender: TObject);
    procedure BoardDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BoardDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SGDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure BoardDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure HintBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
  public
    Block:array[0..7] of TBlock;
    Given:array[0..7] of string;
    Hintcount:integer;
    procedure makecase( NewBlock:array of string2; newsolution:array of integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{data to draw outlines}
type tdrawshape=(E, L,T,R,B);

var
 // drawshape: array [0..4, 0..3] of TDrawshape=
 //             ((E,L,T,B),(E,R,L,L),(T,B,R,R),(L,T,B,E),(R,T,B,E));

{Default Puzzle data}
  {The text strings 4 horizontal & 4 vertical}
  DefaultBlock:array[0..7] of string2= ('OB','ET','CR','AD','DE','DO','OT','RY');
  {Solution array contains the block numbers locations(as defined by Blockmap)
   for each block of the blocks defined above.  Entries 0 to 3 are for horizontal
   blocks, 4 through 7 for vertical blocks}
  DefaultSolution:array[0..7] of integer=(2,3,1,0,4,5,6,7);

{Blockmap}
  {identifies the 8 blocks numbered 0 to 7 which may fit at each of the 20 cells
   onthe board. The first dimension is column data and second dimension is row
   data so what appear on each line below indicates status for each row in a column.
   The 3rd dimension allows one field for the block index and one field to indicate
   the offset to get from that cell to the start (left ot top) of the block.
   Offset values for that field are 0 for the head cell and -1 for the 2nd cell }
  Blockmap:array[0..4,0..3,0..1] of integer=(
                                             ((-1,-1),(1, 0),(7, 0),(7,-1)),
                                             ((-1,-1),(1,-1),(2, 0),(3, 0)),
                                             (( 4, 0),(4,-1),(2,-1),(3,-1)),
                                             (( 0, 0),(5, 0),(5,-1),(-1,-1)),
                                             (( 0,-1),(6, 0),(6,-1),(-1,-1))
                                             );



{************ TBlock,create **********}
constructor TBlock.create(proto:TStringgrid);
begin
  inherited create(proto.owner);
  parent:=proto.parent;
  left:=proto.left;
  top:=proto.top;
  width:=proto.width;
  height:=proto.height;
  defaultcolwidth:=proto.defaultcolwidth;
  defaultrowheight:=proto.defaultrowheight;
  rowcount:=proto.rowcount;
  colcount:=proto.colcount;
  defaultdrawing:=false;
  font.assign(proto.font);
  dragmode:=dmAutomatic;
  ondrawcell:=proto.OnDrawCell;
  options:=proto.Options;
  scrollbars:=proto.ScrollBars;
  proto.free;
end;

{*********** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
var i:integer;

Begin
  {Create an array of horizontal and vertical blocks for ease of access}
  {TBlock is a TString derivative with a few extra fields}
  Block[0]:=TBlock.create(SGH1);
  Block[1]:=TBlock.create(SGH2);
  Block[2]:=TBlock.create(SGH3);
  Block[3]:=TBlock.create(SGH4);
  Block[4]:=TBlock.create(SGV1);
  Block[5]:=TBlock.create(SGV2);
  Block[6]:=TBlock.create(SGV3);
  Block[7]:=TBlock.create(SGV4);
  for i:=0 to 7 do
  begin  {fill in the extra fields}
    with Block[i] do
    begin
      canvas.font.assign(font); {assign the big font to the canvas}
      positionOnboard:=-1; {mark it as off the board}
      SolutionLocation:=-1; {no solution location yet}
      rank:=i;  {it's index (0 to 7}
      homex:=left;  {"home base" when block is off the board}
      homey:=top;
    end;
  end;
  Makecase(DefaultBlock, Defaultsolution); {Define the inital puzzle}
end;


{************ Makecase **************}
procedure TForm1.makecase( NewBlock:array of string2; NewSolution:array of integer);
var
  i:integer;
begin
  for i:=0 to 7 do
  begin
    with Block[i] do
    begin
      cells[0,0]:=NewBlock[i][1];
      if i<4 then cells[1,0]:=NewBlock[i][2]
      else cells[0,1]:=NewBlock[i][2];;
      solutionlocation:=newsolution[i];
    end;
  end;
end;


{********* BoardDrawCell ***********}
procedure TForm1.BoardDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw block outlines on the board}
var
  nl,nr,nt,nb:integer;
  shapedef:TDrawshape;
  blkindex,offset:integer;
begin
  with Board, canvas,  rect do
  begin
    pen.width:=1;
    Pen.color:=clBlack;
    brush.style:=bsSolid;
    nl:=left+1;
    nr:=right-1;
    nt:=top+1;
    nb:=bottom-1;
    if acol=0 then inc(nl) else if acol=4 then dec(nr);
    if arow=0 then inc(nt) else if arow=3 then dec(nb);
    blkindex:=blockmap[acol,arow,0];
    offset:=blockmap[acol,arow,1];
    if blkindex<0 then shapedef:=E
    else if blkindex<=3 then
    begin
      if offset=0 then shapedef:=L else shapedef:=R;
    end
    else if offset=0 then shapedef:=T else shapedef:=B;

    case shapedef {drawshape[acol,arow]} of
      E: begin
           brush.color:=TForm(parent).color;
           fillrect(rect);
           brush.color:=clWhite;
         end;
      L: begin
           moveto(right,nt);
           lineto(nl,nt); lineto(nl,nb); lineto(right, nb);
         end;
       R: BEGIN
           MOVETO(left,nT);
           LINETO(nR,nT); LINETO(nR,nB); LINETO(left, nB);
         END;
       T: BEGIN
           MOVETO(nL,bottom);
           LINETO(nl,nt); LINETO(nR,nT); LINETO(nR, bottom);
         END;
       B: BEGIN
           MOVETO(nL,top);
           LINETO(nL,nb); LINETO(nR,nb); LINETO(nR, top);
         END;
    end; {case}
  end;  {with}
end;

{************ BoardDragOver *************}
procedure TForm1.BoardDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  r,c:integer;
begin
  accept:=false;
  if source is TBlock then
  with source as TBlock do
  begin
    TStringgrid(sender).mousetocell(x,y,c,r);
    if (positionOnBoard<0) and
     (((rowcount=1) and (blockmap[c,r,0]>=0) and (blockmap[c,r,0]<=3)) {Horiz. on horiz.}
       or ((colcount=1) and (blockmap[c,r,0]>=4)))  {Vert on Vert}
    then accept:=true;
  end;
end;

{******************* SGH1DrawCell ***************}
procedure TForm1.SGDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{we'll draw the cell text ourselves so we don't get the "selected cell" highlighting}
begin
  with Tblock(sender), rect do canvas.textout(left+8, top+8, cells[acol,arow])
end;

{************ BoardDragDrop ***********}
procedure TForm1.BoardDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  c,r:integer;
  i:integer;
  offsetx,offsety:integer;
  rect:TRect;
  pronoun:string;
  solved:boolean;
begin
  if source is TBlock then
  with source as TBlock do
  begin
    with TStringgrid(sender) do
    begin
      mousetocell(x,y,c,r); {get column and row in target grid}
      offsetx:=left+1;
      offsety:=top+1;
    end;

    if blockmap[c,r,0]<=3 then {horizontal}  c:=c+blockmap[c,r,1] {get left col of block}
    else  {vertical}  r:=r+blockmap[c,r,1]; {get top row of block}

    {move the block to the board}
    rect:=TStringgrid(sender).cellrect(c,r);
    left:=rect.Left+offsetx;
    top:=rect.Top+offsety;
    TBlock(source).positiononboard:=blockmap[c,r,0];
    TBlock(source).invalidate;

    {check if  solution reached}
    solved:=true;
    for i:=0 to 7 do
    begin
      if  (Block[i].positiononboard<> Block[i].solutionlocation)
      then
      begin
        solved:=false;
        break;
      end;
    end;
    {I wonder if anyone will ever notice thius subtlety}
    If hintcount>0 then pronoun:='we' else pronoun:='you';
    if solved then showmessage('Congratualtions, '+pronoun+' did it!!');
  end;
end;

{************** FormDragOver ***********88}
procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  accept:=true;
end;

{********* FormDragDrop ************}
procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  with source as TBlock do
  begin
    left:=homex;
    top:=homey;
    positiononboard:=-1;
  end;
end;

{************ HintBtnClick **********}
procedure TForm1.HintBtnClick(Sender: TObject);
var
  i,n:integer;
  badcount,unplacedcount:integer;

        {--------- RemoveBlock ----------}
        procedure removeblock(grid:TBlock);
        begin
          with grid do
          begin
            positionOnBoard:=-1;
            left:=homex;
            top:=homey;
          end;
        end;

        {---------- AddBlock ---------}
        procedure addblock(grid:TBlock);
        var
          c,r:integer;
          rect:Trect;
          done:boolean;
        begin
          with grid do
          begin
            positionOnBoard:=solutionlocation;
            done:=false;
            for c:=0 to 4 do
            begin
              for r:=0 to 3 do
              if blockmap[c,r,0]=solutionlocation then
              begin
                rect:=board.cellrect(c,r);
                left:=board.Left+rect.Left;
                top:=board.Top+rect.Top;
                done:=true;
                break;
              end;
              if done then break;
            end;
          end;
        end;

begin
  {count incorrectly placed blocks}
  inc(hintcount);
  badcount:=0; unplacedcount:=0;
  for i:=0 to 7  do
  begin
    with Block[i] do
    if (positiononboard>=0)
    then if (positiononboard <>solutionlocation) then inc(badcount) else
    else inc(unplacedcount);
  end;
  {if BadCount >0, select a random one to remove}
  If Badcount>0 then
  begin
    n:=random(Badcount)+1;
    badcount:=0;
    for i:=0 to 7 do
    begin  {run down the list again, looking for the nth incorrectly placed block}
      with Block[i] do
      if (positiononboard>=0) and (positiononboard <>solutionlocation) then inc(badcount);
      if badcount=n then
      begin
        removeblock(Block[i]);
        break;
      end;
    end;
  end
  else
  if unplacedcount>0 then
  begin {if badcount is 0, then move a random block not placed yet to the correct
         board location}
    n:=random(unplacedcount)+1;
    unplacedcount:=0;
    for i:=0 to 7 do
    begin  {run down the list again, looking for the nth incorrectly placed block}
      with Block[i] do
      if (positiononboard<0) then inc(unplacedcount);
      if unplacedcount=n then
      begin
        addblock(Block[i]);
        break;
      end;
    end;
  end
  {If there are none to add, the puzzle is already solved!}
  else showmessage('No more hints.  Puzzle is solved!');
end;

{************ ResetBtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i:integer;
begin
  {resetblocks;}
  for i:=0 to 7 do
  begin
    with Block[i] do
    begin
      positiononboard:=-1;   {mark it as off the board}
      solutionLocation:=-1;
      left:=homex;
      top:=homey;
    end;
  end;
  hintcount:=0;
  makecase(DefaultBlock, DefaultSolution);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

