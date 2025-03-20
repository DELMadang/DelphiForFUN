unit U_RobotRooms;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{"Robot Rooms" implements an algorithm for exactly covering a
rectangular area with random rectangles meeting certain size
and shape constraints.  The authors' 2001 paper "Data Set
Generation for Rectangular Placement Problems",  C.L.
Valenzuela and P.Y. Wang, is available at

http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.39.3218

The algorithm from the paper provides basis for this program which generates
random arrangement of rectangular rooms for an investigation of intelligent
robot behavior.  It includes a method for adding "doorways" connecting adjacent
rooms.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TIdRect=record   {"Rectangle" object}
    Id:string;
    Left,top,right,bottom:integer;
    W,H,Area:integer;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    DoorsBtn: TButton;
    Image1: TImage;
    Edit1: TEdit;
    NbrRectsUD: TUpDown;
    Label1: TLabel;
    WidthEdt: TEdit;
    WidthUD: TUpDown;
    Label2: TLabel;
    HeightEdt: TEdit;
    HeightUD: TUpDown;
    Label3: TLabel;
    Label4: TLabel;
    Edit4: TEdit;
    AspectUD: TUpDown;
    Edit5: TEdit;
    AreaUD: TUpDown;
    Label5: TLabel;
    GenBtn: TButton;
    Memo1: TMemo;
    Edit6: TEdit;
    DoorSizeUD: TUpDown;
    Label6: TLabel;
    Label7: TLabel;
    RandSeedEdt: TEdit;
    UserandSeedBtn: TButton;
    DebugBox: TCheckBox;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Panel1: TPanel;
    Memo2: TMemo;
    RefPaperLink: TStaticText;
    procedure StaticText1Click(Sender: TObject);
    procedure DoorsBtnClick(Sender: TObject);
    procedure GenBtnClick(Sender: TObject);
    procedure SizeChange(Sender: TObject);
    procedure RefPaperLinkClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure UserandSeedBtnClick(Sender: TObject);
  public
    rects:array of TIdRect; {Array of currently defined rectangles}
    TargetNbrRects:integer; {Number ot generate}
    Nbrrects:integer;       {Current number of rectangles generated}
    AspectRatio:double;     {Rho: Rectangles satisfy  1/Rho<=Height/Width<=Rho}
    AreaRatio:double;       {Upsilon:  Largest area/Smallest area <= Upsilon}
    mindoorsize:integer;     {Door size}

    procedure drawrects;  {redraw all rectangles}
    function getparams:boolean; {get paramters from form}
    procedure addrect(NewId:String;R:Trect); {Add a rectangle}
    procedure GetLargestAreaRect(var newindex, newarea:integer); {Get largest ares rectangle}

    {Split rectangle "index" at location "value" ,  in direction "dir" ('V' or 'H'}
    procedure SplitRects(dir:char; index, value:integer);

    procedure DebugIt(s:string); {Display intermediate values}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;


  function overlap(P1,P2:TPoint):TPoint;
  {P1 & P2 represent the end points of  2 horizontal or 2 vertical lines}
  {Returns the overlap coordinates (X's or Y's) repesenting the overlap segment.
   P1 contains left and right  or top and bottom values for 1st line,
   P2 contains left and right or top and bottom values for 2nd line}
  begin
    if p1.x<=p2.X then
    begin
      if p1.y<=p2.X then result:=point(0,0)
      else
      if p2.y<=p1.Y then result:=point(p2.X,p2.y)
      else result:=point(p2.x,p1.y);
    end
    else
    begin
      if p1.x>p2.Y then result:=point(0,0)
      else if p1.y>p2.Y then result:=point(p1.X, p2.y)
      else result:=point(p1.X,p1.Y);
    end;
  end;




{*********** Drawrects ********}
procedure TForm1.drawrects;
{redraw all rectangles}
var
  i,a,b:integer;
begin
  with image1, canvas do
  for i:=low(rects) to nbrrects-1 do
  with rects[i] do
  begin
    rectangle(left,top,right,bottom);
    a:=Textwidth(id);
    b:=textheight(id);
    if (a<W) and (b<H)  {skip text if room is too small}
    then textout((right+left-a) div 2, (bottom+top-b) div 2,id);
  end;
  update;
end;

{************* GetParams **********}
function TForm1.getParams:boolean;
begin
  with image1 do
  begin
    width:= WidthUD.position;
    picture.bitmap.width:=width;
    height:=Heightud.position;
    picture.bitmap.height:=height;
    canvas.Rectangle(clientrect);
  end;
  nbrrects:=0;
  TargetNbrRects:=NbrrectsUD.position;
  AspectRatio:=AspectUD.position;
  AreaRatio:=AreaUD.position;
  result:=true;
end;

procedure TForm1.addrect(NewId:String;R:Trect);
var
  idRect:TIdRect;
begin

  if nbrrects<TargetNbrRects then
  begin
    with idrect do
    begin
      id:=newId;
      left:=r.left;
      top:=r.Top;
      right:=r.Right;
      bottom:=r.Bottom;
      W:=right-left;
      H:=bottom-top;
      Area:=W*H;
    end;
    rects[nbrrects]:=IdRect;
    inc(nbrrects);
    drawrects;
  end;
end;

{
Algorithm 3 Controlling the Area Ratio
Input the parameters n,  Rho, Upsilon , H, and W
while n rectangles not yet generated do
let m be the area of the largest rectangle in the current set choose a rectangle
 R from all subrectangles whose areas are greater than 2m

randomly choose a vertical or horizontal slicing direction
randomly choose a cutting position within the legal
range of slicing positions (Corollary 3 or 4)
perform the cut on R, generating two subrectangles
replace R in the list with the two subrectangles
end while }



{*************** GetLargestArearect *************}
procedure TForm1.GetLargestAreaRect(var newindex, newarea:integer);

  var i:integer;
  begin
    newarea:=0;
    for i:=0 to nbrrects-1 do
    with rects[i] do
    begin
      if area>newarea then
      begin
        newarea:=area;
        newindex:=i;
      end;
    end;
  end;

  {************ SpliRects *************}
  procedure TForm1.SplitRects(dir:char; index, value:integer);
  var
    x,y:integer;
    work1,work2:TIdRect;
  begin
    case dir of
    'V':
      begin
        x:=value;
        work1:=rects[index];
        with work1 do
        begin
          right:=x;
          W:=right-left;
          Area:=W*H;
        end;
        work2:=rects[index];
        with work2 do
        begin
          id:=inttostr(nbrrects+1);
          left:=x;
          W:=right-left;
          Area:=W*H;
        end;
      end;
      'H' :
      begin
        y:=value;
        work1:=rects[index];
        with work1 do
        begin
          bottom:=y;
          H:=bottom-top;
          Area:=W*H;
        end;
        work2:=rects[index];
        with work2 do
        begin
          id:=inttostr(nbrrects+1);
          top:=y;
          H:=bottom-top;
          Area:=W*H;
        end;
      end;
    end; {case}
    rects[index]:=work1;
    rects[nbrrects]:=work2;
    inc(nbrrects);
    drawrects;
  end;


  procedure TForm1.DebugIt(s:string);
  begin
    if debugbox.checked then memo1.lines.add(s);
  end;


{************ GenBtnClick ***************}
procedure TForm1.GenBtnClick(Sender: TObject);
var
  i:integer;
  clist:array of integer;
  listsize:integer;
  maxX, minX, MaxY, minY:integer;
  x,y:integer;
  index, M:integer;



var j:integer;
  a,b,c,r:integer;
  OKFlag:integer;
begin
  memo1.clear;
  if sender=UseRandSeedBtn then randseed:=strtointdef(RandSeedEdt.text,0)
  else RandSeedEdt.Text:=inttostr(randseed);
  If getparams then
  begin
    setlength(rects, targetnbrrects);
    nbrrects:=0;
    addrect(inttostr(nbrrects+1),image1.clientrect); {make initial rectagle}

    {THE LOOP}
    while nbrrects<TargetNbrrects do
    begin
      getlargestarearect(index,m); {"index  of the largest and its area "m"} 
      setlength(clist,100);
      listsize:=0;
      {get a list of rectangles with area>2m/Rho}
      {randomly select one of those}
      for i:=0 to nbrrects-1 do
      with rects[i] do
      begin
        if (area>2*m / arearatio) then
        begin
          If (2*H/aspectratio <= W) and (W <= 2*aspectratio*H)
          then OKFlag:=1 else OKFlag:=0;
          If (2*W/aspectratio <= H) and (H <= 2*aspectratio*W)
          then inc(OKFlag,2);
          if OKFlag>0 then
          begin
            dec(OKflag);
            {OKFlag was 1,2,or 3, now:
              0: Vert OK
              1: Horiz OK
              2: eith direction OK}
            {Encode OKFlag and rectangle index into a single value}
            clist[listsize]:=10*i+OKFlag;
            inc(listsize);
          end;
        end;
      end;
      {The list of all rectangles eligible for splitting has been built, now choose one}
      if listsize>0 then
      begin {there is at least one rectangle which can be split}
        i:=random(listsize);
        j:=clist[i] div 10;
        OKFlag:= clist[i] mod 10;

        if OKFlag=2 then OKFlag := random(2); {Can split either V or H, choose one}
        case OKFlag of
          0: {Vertical split line}
          Begin
            {Let m denote the area of the rectangle having the maximum area in a
            list of n rectangles with aspect ration Rho and area ratio Upsilon
            . Select any rectangle R[j] where area (R[j]>2m/Upsilon. and slice it
             vertically at position x where
             max(H[j]/rho, W[j]-H[j]/Rho, m/(upsilon*H[j]) <= x <= min(H[j]*Rho, W[j]-H[j]/Rho, W[j]/2).
             The resulting set of n+1 rectangles has aspect ratio Rho and area2
             ratio Upsilon.
            }

            with rects[j],memo1.lines do
            begin
              DebugIt(format('#%d:Split rect %d (V) Left=%d, Top=%d, W=%d, H=%d, Area=%d',
                           [nbrrects+1,j,Left, Top, W,H,M]));
              a:=trunc(H/Aspectratio);
              b:=trunc(W-H*Aspectratio);
              c:=Trunc(m/(Arearatio*H));
              minX:=max(max(a,b) ,c );
              DebugIt(format(' H/Rho=%d, W-H*Rho=%d, m/(H*Ups)=%d, Min=%d',[a,b,c, minx]));

              a:=trunc(H*AspectRatio);
              b:=trunc(W-H/Aspectratio);
              c:=trunc(W/2);

              maxX:=min(min(a,b),c);
              DebugIt(format(' H*Rho=%d, W-H/Rho=%d, W/2=%d, Maxx=%d ',[a,b,c, maxX]));
              r:=minx+random(maxx-minx);
              x:=left+r;
            end;
            if maxx>=minx then SplitRects('V', j, x) else showmessage('bad x?');
            debugit(format(' Split vertically at %d+$d', [left,r]));
          end {Vertical split}
          else
          begin {Split horizontally}
            {
            Let m denote the area of the rectangle having  the maximum area in a list
            of n rectangles with aspect ratio Rho and area ratio Upsilon
            . Select any rectangle R[j= where area (R[j])>2m/Upsilon,
              and slice it horizontally at position y where max(W[j]/Rho, H[j]-W[j]*Rho,
             (m/(Upsilon*W[j]))<=y<=min(W*Rho,H-W/Rho,H[j]/2).
             The resulting set of n + 1 rectangles has aspect ratio rho and area ratio upsilon
            }
            with rects[j] do
            begin
              DEBUGIT(' ');
              DebugIt(format('#%d: Split rect %d (H)Left=%d, Top=%d, W=%d, H=%d, Area=%d',
                           [nbrrects+1,j,Left,Top,W,H,M]));

              a:=trunc(W / Aspectratio);
              b:=trunc(H-W*Aspectratio);
              c:=Trunc(m/(Arearatio*W));
              minY:=max(max(a,b),c);
              DebugIt(format(' W/Rho=%d, H-W*Rho=%d, m/(W*Ups)=%d, MinY=%d',[a,b,c, miny]));
              a:=trunc(W*AspectRatio);
              b:=trunc(H-W/Aspectratio);
              c:=trunc(H/2);
              maxY:=min(min(a,b),c);
              DebugIt(format(' W*Rho=%d, H-W/Rho=%d, H/2=%d, Maxy=%d ',[a,b,c, maxy]));
              r:=miny+random(maxy-miny);
              Y:=top+r;
            end;
            if maxy>=miny then SplitRects('H', j,y) else showmessage('bad y?');
            debugit(format(' Split horizontally at %d+%d', [top,r]));
          end; {horizontal split}
        end; {choose direction case}
      end
      else
      begin
        showmessage('No split meeting requirements is possible');
        break;
      end;
    end;
  end;
end;

{************* SizeChange **********}
procedure TForm1.SizeChange(Sender: TObject);
{Board dimensions changed, orget existing rectangles and redraw board}
begin
  nbrrects:=0;
  drawrects;
end;



{************ FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  UserandSeedBtnClick(UseRandSeedBtn); {Draw initial rectangle display}
  doorsBtnClick(sender); {add the doorways}
end;

{********* UseRandSeedBtnClick ************}
procedure TForm1.UseRandSeedBtnClick(Sender: TObject);
{Button to draw rectangles using provided random seed}
begin
  GenBtnClick(sender);
end;

{*************** DoorsBtnClick *********}
procedure TForm1.DoorsBtnClick(Sender: TObject);
{Add doors to the set of rectangles, centered on each side}
var
  i,j:integer;
  temp:TIdrect;
  Line1,Line2,door:TPoint;
  offsetx,offsety:integer;
begin
  //memo1.clear;
  drawrects;
  mindoorsize:=doorsizeud.position;
  {sort rects by increasing top y coordinates }
  for i:=low(rects) to high(rects)-1 do
  for j:=i+1 to high(rects) do
  begin
    if (rects[i].top>rects[j].Top)
       or ((rects[i].top=rects[j].top) and (rects[i].left>rects[j].Left)) then
    begin
      temp:=rects[i];
      rects[i]:=rects[j];
      rects[j]:=temp;
    end;
  end;
  {check top and bottom rectangle edges for overlap}
  for i:=low(rects) to high(rects)-1 do
  begin  {for all rectangles (except the last}
    with rects[i] do Line1:=point(left,right);
    for j:=i+1 to high(rects) do
    begin  {check against the rest of the rectangle array}
      if (rects[i].top=rects[j].bottom) or
         (rects[i].bottom=rects[j].top) then
      {these two tops and/or bottoms edges are co-linear (i.e. inline)}
      with rects[j] do
      begin    {but do they overlap}
        Line2:=point(left,right);
        door:=overlap(line1,line2);
        if door.y-door.x>mindoorsize then
        {Yes they do and overlap is large enough for a doorway}
        with image1, canvas do
        begin {this is a valid door way, print and draw it}
          debugit(format('East-West Door between %s and %s from %d to %d',
                         [rects[i].Id,rects[j].Id, door.x, door.Y]));
          {draw the horizontal doorways}
          offsetx:=trunc((door.x+door.y -mindoorsize)) div 2;
          pen.color:=clwhite;
          pen.width:=3;
          if  rects[i].top=rects[j].bottom then offsety:=trunc(rects[i].top)
          else offsety:=trunc(rects[i].bottom);
          moveto(offsetx,offsety);
          lineto(offsetx+mindoorsize,offsety);
          pen.color:=clblack;
          pen.width:=1;
          update;
        end;
      end;
    end;
  end;

  {now for vertical edges, sort by  increasing tops within increasing left sides}
  for i:=low(rects) to high(rects)-1 do
  for j:=i+1 to high(rects) do
  begin
    if (rects[i].left>rects[j].left)
     or ((rects[i].left=rects[j].left) and (rects[i].top>rects[j].top))then
    begin
      temp:=rects[i];
      rects[i]:=rects[j];
      rects[j]:=temp;
    end;
  end;

  for i:=low(rects) to high(rects)-1 do
  begin  {for all rectangles (except the last}
    with rects[i] do Line1:=point(top,bottom);
    for j:=i+1 to high(rects) do {from there on down the list}
    begin
      if (rects[i].left=rects[j].right) or
         (rects[i].right=rects[j].left) then
      with rects[j] do {left or right ends are colinear}
      begin            {but do they overlap?}
        Line2:=point(top,bottom);
        door:=overlap(line1,line2); {check and see}
        if door.y-door.x>=mindoorsize then
        with image1, canvas do   {yes and overlap is large enought for the doorway}
        begin
          debugit(format('North-South Door between %s and %s from %d to %d',
                       [rects[i].Id,rects[j].Id, door.x, door.Y]));
          {draw the vertical door ways}
          offsety:=trunc((door.x+door.y -mindoorsize)) div 2;
          pen.color:=clwhite;
          pen.width:=3;
          if  rects[i].left=rects[j].right then offsetx:=trunc(rects[i].left)
          else offsetx:=trunc(rects[i].right);
          moveto(offsetx,offsety);
          lineto(offsetx, offsety+mindoorsize);
          update;
          pen.color:=clblack;
          pen.width:=1;
        end;
      end;
    end;
  end;
end;

{************* RefPaperLink ************}
procedure TForm1.RefPaperLinkClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open','http://citeseerx.ist.psu.edu/viewdoc/summary?doi=10.1.1.39.3218  ',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
