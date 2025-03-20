unit U_PegBoard4Dot1;

interface

uses windows,classes, sysutils, extctrls, forms, graphics;

type
  PTMove=^TMove;
  TMove=record
     frompoint,topoint:TPoint;
  end;

 TOneMode=(None, OneAtHole);
 TOccupiedType=(Empty,Occupied, NotAvailable);
  TSmallArray = array[2..8,2..8] of byte;
  TBigArray=array[0..10,0..10] of TOccupiedType;
 TBoard= class(tObject)
    public
     pegcount:integer;{score of this board}
     totpegs:integer; {startinf nbr of pegs}
     solpegcount:integer; {maximum number of pegs in a solution}
     onemode:TOneMode;
     Target:TPoint;
     path:Tlist;  {used to keep track of the moves that got us here}
     totcount:int64;  {total moves tried}
     stop:boolean;  {stop flag}
     Onstatus: procedure of object;
     {b = board array 11X11 array with index levels 0,1,9 and 10 in each direction
     reserved as sentinels to speed search for valid moves}
     b:TBigArray;    {the board array, with sentinels}
     delayms:integer;
     image:Timage;
     boxw,boxh:integer;
     allowDiagonals:boolean;
     rowstart, rowend: array[0..10] of integer;
     bstart:TPoint; {target for "one left at starting hole" (one in  center) solution mode}
     constructor create;
     destructor destroy; override;
     function moves:boolean;  {recursive search for moves}
     function solved:boolean; {return true if one peg left in center}
     function canmove:boolean;  {return true if there is a move left}
     procedure makemove(const p1,p2,p3:TPoint);  {make a move}
     procedure unmakemove(const p1,p2,p3:TPoint); {reverse a move}
     procedure draw(imageloc:TImage);
     procedure drawslot(x,y:integer);
     procedure movepeg(frompoint,topoint:TPoint);
     procedure rebuildboard;
  end;



implementation

var
  pegborder:integer=4;

  {****************************************************}
{******************** TBoard methods ****************}
{****************************************************}

{****************** Create ****************}
constructor TBoard.create;
begin
  inherited;
  pegcount:=0;
  totcount:=0;
  path:=tlist.create;
  stop:=true;
end;

{******************* Destroy ****************}
destructor TBoard.destroy;
var
  i:integer;
begin
  for i:=0 to path.count-1 do dispose(PTMove(path[i]));
  path.free;
  inherited;
end;

{********************* MakeMove ****************}
procedure TBoard.makemove(const p1,p2,p3:TPoint);
{make a move}
var
  pmove:PTMove;
begin
  b[p1.x,p1.y]:=empty;
  b[p2.x,p2.y]:=empty;
  b[p3.x,p3.y]:=occupied;
  {save target of first move as "one left at start" target}
  if pegcount=totpegs then
  begin
    bstart := p3;
  end;
  dec(pegcount);
  new(PMove);
  path.add(pmove);
  pmove^.frompoint:=p1;
  pmove^.topoint:=p3;
  inc(totcount);
  if totcount and 131071 = 131071 then
  begin
    if assigned(Onstatus) then onstatus;
    application.processmessages;
  end;
end;

{********************** UnMakeMove *************}
procedure TBoard.UnMakemove(const p1,p2,p3:TPoint);
{retract a  move}
begin
  b[p1.x,p1.y]:=occupied;
  b[p2.x,p2.y]:=occupied;
  b[p3.x,p3.y]:=empty;
  inc(pegcount);
  dispose(PTMove(path[path.count-1]));
  path.delete(path.count-1);
end;

{******************* Solved ***********}
function Tboard.solved:boolean;
{Solved test}
begin {Solution = one peg left in the starting hole}
  result:=(pegcount<=solpegcount);
  if solpegcount=1 then
  begin
    (*
    if (onemode=oneinstart) and (b[bstart.x, bstart.y]<>occupied)
    then result:=false;
    if (onemode=oneincenter) and (b[5,5]<>occupied)
    then result:=false;
    *)
    if (onemode=OneAtHole) and (b[Target.X, target.Y]<>occupied) then result:=false;
  end;
end;


{****************** Moves ***************}
function TBoard.moves:boolean;
{Main solution search method}
{Check moves depth first - recursive function}
{Optimized for speed}
var
  i,j:integer;
  //order:TOrder;
begin
  result:=true;
  if stop then  exit;
  if solved then
  begin
    if assigned(onstatus) then onstatus;
    exit;
  end
  else
  begin
    //order:=orders[random(24)];

    for i:= 2 to 8  do  {check all peg locations  - 0,1,9,and 10 are "sentinal"
                       index slots to avoid range testing of each i,j, value}
    for j:= rowend[i] {8} downto rowstart[i] {2} do
    begin
      If b[i,j]=occupied then
      begin  {check all 4 directions}
          {1. North}
          if  (b[i,j-1]=occupied) and (b[i,j-2]=empty)
          then
          begin
            makemove(point(i,j), point(i,j-1), point(i,j-2));
            if not moves then unmakemove(point(i,j), point(i,j-1), point(i,j-2))
            else  exit;
          end;
          {2. East}
          if  (b[i+1,j]=occupied) and  (b[i+2,j]=empty)
          then
          begin
            makemove(point(i,j), point(i+1,j),point(i+2,j));
            if not moves then unmakemove(point(i,j), point(i+1,j),point(i+2,j))
            else  exit;
          end;
          {3. South}
          if    (b[i,j+1]=occupied) and (b[i,j+2]=empty)
          then
          begin
            makemove(point(i,j), point(i,j+1),point(i,j+2));
            if not moves then unmakemove(point(i,j), point(i,j+1),point(i,j+2))
            else  exit;
          end;
          {4. West}
          if   (b[i-1,j]=occupied) and (b[i-2,j]=empty)
          then
          begin
            makemove(point(i,j), point(i-1,j),point(i-2,j));
            if not moves then unmakemove(point(i,j), point(i-1,j),point(i-2,j))
            else exit;
          end;
          if allowdiagonals then
          begin
            {right/up}
            if   (b[i+1,j-1]=occupied) and (b[i+2,j-2]=empty)
            then
            begin
              makemove(point(i,j), point(i+1,j-1),point(i+2,j-2));
              if not moves then unmakemove(point(i,j), point(i+1,j-1),point(i+2,j-2))
              else exit;
            end;
            {left/down}
            if   (b[i-1,j+1]=occupied) and (b[i-2,j+2]=empty)
            then
            begin
              makemove(point(i,j), point(i-1,j+1),point(i-2,j+2));
              if not moves then unmakemove(point(i,j), point(i-1,j+1),point(i-2,j+2))
              else exit;
            end;
         end;
      end;
    end;
    result:=false;
  end;
end;

function TBoard.canmove:boolean;
{return true if at least one move left}
var
  i,j:integer;
begin
  result:=false;
  for i:= 2 to 8  do
  begin
    for j:= 8 downto 2 do
    begin
      if b[i,j]=occupied then  {check all 4 directions}
      begin
        if    (b[i,j-1]=occupied) and (b[i,j-2]=empty)
          or  (b[i+1,j]=occupied) and  (b[i+2,j]=empty)
          or  (b[i,j+1]=occupied) and (b[i,j+2]=empty)
          or  (b[i-1,j]=occupied) and (b[i-2,j]=empty)
          or  (AllowDiagonals and (b[i+1,j-1]=occupied) and (b[i+2,j-2]=empty))
          or  (AllowDiagonals and (b[i-1,j+1]=occupied) and (b[i-2,j+2]=empty))
        then
        begin
          result:=true;
          break;
        end;
      end;
    end;
    if result then break;
  end;
end;

{********************** Draw ***************}
procedure TBoard.draw(imageloc:Timage);
{Draw the current board }
var
  i,j:integer;
begin
  image:=imageloc;
  boxw:=image.width div 7;
  boxH:=image.height div 7;
  image.width:=boxw*7;
  image.height:=boxH*7;
  with image, canvas do
  for i:=2 to 8 do
  for j:=2 to 8 do
  begin
    brush.color:=clyellow;
    rectangle((i-2)*boxw,(j-2)*boxh,(i-1)*boxw,(j-1)*boxh);
    case b[i,j] of
      empty:
        begin
          brush.color:=clblack;
          ellipse((i-2)*boxw+8,(j-2)*boxh+8,(i-1)*boxw-8,(j-1)*boxh-8);
        end;
      occupied:
        begin
          brush.color:=clred;
          ellipse((i-2)*boxw+4,(j-2)*boxh+4,(i-1)*boxw-4,(j-1)*boxh-4);
        end;
    end;
  end;
  application.processmessages;
end;


procedure TBoard.drawslot(x,y:integer);
{draw image of slot contets, x & y zero based}
begin
  case b[x+2,y+2] of
    occupied:
      with image, canvas do
      begin
        brush.color:=clred;
        ellipse((x)*boxw+4,(y)*boxh+4,(x+1)*boxw-4,(y+1)*boxh-4);
      end;
    empty:
      with image, canvas do
      begin
        brush.color:=clyellow;
        rectangle((x)*boxw,(y)*boxh,(x+1)*boxw,(y+1)*boxh);
        brush.color:=clblack;
        ellipse((x)*boxw+8,(y)*boxh+8,(x+1)*boxw-8,(y+1)*boxh-8);
      end;
    notavailable:
      with image, canvas do
      begin
        brush.color:=clyellow;
        rectangle((x)*boxw,(y)*boxh,(x+1)*boxw,(y+1)*boxh);
      end;
  end;
  application.processmessages;
end;


{************************* MovePeg **********************}
procedure TBoard.movepeg(frompoint,topoint:TPoint);
{animate a peg move}
var
  boxw,boxh,dx,dy:integer;
  i:integer;
  peg:Tshape;
  fromx,fromy,tox,toy:integer;

  procedure drawempty(i,j:integer);
  begin
    with image, canvas do
   begin
     brush.color:=clyellow;
     rectangle((i)*boxw,(j)*boxh,(i+1)*boxw,(j+1)*boxh);
     brush.color:=clblack;
     ellipse((i)*boxw+8,(j)*boxh+8,(i+1)*boxw-8,(j+1)*boxh-8);
   end;
 end;

  procedure drawpeg(i,j:integer);
  begin
    with image, canvas do
    begin
      brush.color:=clred;
      ellipse((i)*boxw+pegborder,(j)*boxh+pegborder,(i+1)*boxw-pegborder,(j+1)*boxh-pegborder);
    end;
  end;

begin
  boxw:=image.width div 7;
  boxH:=image.height div 7;
  {make points 0 based}
  fromx:=frompoint.x-1;
  fromy:=frompoint.y-1;
  tox:=topoint.x-1;
  toy:=topoint.y-1;
  dx:=(tox-fromx)*boxw;
  dy:=(toy-fromy)*boxh;
  peg:=tshape.create(image.owner);
  with peg do
  begin
    width:=boxw-2*pegborder;
    height:=boxh-2*pegborder;
    parent:=image.parent;
    shape:=stcircle;
    brush.color:=clred;
    left:=image.left+pegborder;
    top:=image.top+pegborder;
  end;
  with image, canvas do
  begin
     if  dy=0 then
     begin   {horizontal - move up, over, and down}
       drawempty(fromx, fromy);
       peg.left:=image.left+4+boxw*fromx;
       peg.top:=image.top+4+boxh*fromy;
       for i:= 1 to 12 do
       begin
         If i<=4 then
         begin
           peg.left:=peg.left+dx div 12;
           peg.top:=peg.top-boxw div 8;
         end
         else if i<=8 then  peg.left:=peg.left+dx div 12
         else
         begin
           peg.left:=peg.left+dx div 12;
           peg.top:=peg.top+boxw div 8;
         end;
         update;
         if stop then break;
         sleep(delayms);
       end;
       if not stop then
       begin
         drawempty(fromx+dx div (2*boxw),fromy);
         drawpeg(tox,toy);
       end;
     end
     else
     if fromx=tox then
     begin
      {vertical move - right, up/down, left}
       drawempty(fromx, fromy);
       peg.left:=image.left+4+boxw*fromx;
       peg.top:=image.top+4+boxh*fromy;
       for i:= 1 to 12 do
       begin
         if i<=4 then
         begin
           peg.left:=peg.left+boxw div 8;  {angle over half a peg}
           peg.top:=peg.top+dy div 12;
         end
         else if i<=8 then  peg.top:=peg.top+dy div 12
         else
         begin
           peg.left:=peg.left-boxw div 8;
           peg.top:=peg.top+dy div 12 ;
         end;
         update;
         if stop then break;
         sleep(delayms);
       end;
       if not stop then
       begin
         drawempty(fromx,fromy+dy div (2*boxH));
         drawpeg(tox,toy);
       end;
     end
     else  {diagonal move}
     begin
       drawempty(fromx, fromy);
       peg.left:=image.left+4+boxw*fromx;
       peg.top:=image.top+4+boxh*fromy;
       for i:= 1 to 16 do
       begin
         if i<=4 then
         begin {move down}
           peg.top:=peg.top+dy div 12;
         end
         else if i<=12 then
         begin  {then move diagonally}
           peg.left:=peg.left+ dx div 12;
           peg.top:=peg.top+dy div 12;
         end
         else peg.left:=peg.left+ dx div 12; {horizontally to final spot}
         update;
         if stop then break;
         sleep(delayms);
       end;
       if not stop then
       begin
         drawempty(fromx+dx div (2*boxw) ,fromy+ dy div (2*boxH));
         drawpeg(tox,toy);
       end;
     end; {diagonal move}
  end;
  peg.free;
  application.processmessages;
  sleep(4*delayms);
end;

{************ RebuildBoard **********}
procedure TBoard.rebuildboard;
{reconstruct the board from the path by applying moves in reverse order from
 end of list}
var
  i,j:integer;
begin
  for i:= 2 to 8 do
  for j:= 2 to 8 do
  begin
    drawslot(i-2,j-2);
    application.processmessages;
  end;
  for i:= path.count-1 downto 0 do
  with pTmove(path[i])^ do
  begin    {adjust "move" data to 1-7 range}
    b[frompoint.x{+1},frompoint.y{+1}]:=occupied;
    b[topoint.x{+1},topoint.y{+1}]:=empty;
    b[(frompoint.x+topoint.x) div 2{+1}, (frompoint.y+topoint.y) div 2{+1}]:=occupied;
    drawslot(frompoint.x-2,frompoint.y-2);
    drawslot(topoint.x-2,topoint.y-2);
    drawslot((frompoint.x+topoint.x) div 2-2, (frompoint.y+topoint.y) div 2-2);
    application.processmessages;
  end;
  sleep(1000);
end;

end.
