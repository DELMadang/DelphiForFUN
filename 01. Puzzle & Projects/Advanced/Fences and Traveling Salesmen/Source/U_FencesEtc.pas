unit U_FencesEtc;
   {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Basics - draw some circles on a board,
 then select a button to compute,
 a. Simple Path,
 b. Convex Hull,
 c. Shortest path
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Combo;
const
  maxpoints=100;
type

  TDrawtype=(DrawSimplePath, DrawHull, DrawShortpath, None);
  TPoints=array[1..maxpoints] of TPoint;
  TForm1 = class(TForm)
    PaintBox1: TPaintBox;
    SimplePathBtn: TButton;
    ConvexHullBtn: TButton;
    ResetAllBtn: TButton;
    Label1: TLabel;
    ShortBtn: TButton;
    PathLengthLbl: TLabel;
    ShortPathGrpBox: TGroupBox;
    CountLbl: TLabel;
    Label2: TLabel;
    Maxpathslbl: TLabel;
    Stopbtn: TButton;
    NbrpointsLbl: TLabel;
    ResetLinesBtn: TButton;
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SimplePathBtnClick(Sender: TObject);
    procedure ResetLinesBtnClick(Sender: TObject);
    procedure ResetAllBtnClick(Sender: TObject);
    procedure ConvexHullBtnClick(Sender: TObject);
    procedure ShortBtnClick(Sender: TObject);
    procedure StopbtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    NbrPoints:integer;
    NbrHullPoints:integer;
    Drawtype:TDrawType;
    Points:TPoints;
    HullPoints:Tpoints;

    {used for shortestpath}
    Combo:TComboset;
    ShortPath: array[1..maxpoints] of integer;
    minpath:integer;
    d:array[1..maxpoints,1..maxpoints] of integer; {pairwise distances between points}


    {used for simple and hull path length calculation}
    Procedure SetPathLength(P:TPoints; nbr:integer);

    {used for shortest path length calculation}
    Function GetFirstpath:integer;
    Function GetNextPath:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses math, UMakeCaption;


{********************* PaintBoxPaint ******************}
procedure TForm1.PaintBox1Paint(Sender: TObject);
{Drawing in a paintbiox must be repainted whenever the form is shown.  This does it}
var
  clsave:TColor;
  i:integer;
begin
  with paintbox1,canvas do
  Begin
    pen.color:=clblack;
    brush.color:=clgray;
    rectangle(0,0,width,height);
    clsave:=brush.color;
    brush.color:=clred;
    for i:= 1 to nbrpoints do
    with points[i] do ellipse(x-4,y-4,x+4,y+4);
    brush.color:=clsave;
    Case Drawtype of
       Drawsimplepath:
       Begin
         moveto(points[nbrpoints].x,points[nbrpoints].y);
         pen.color:=clblue;
         for i:= 1 to nbrpoints do with points[i] do lineto(x,y);
      end;
      DrawHull:
      Begin
        moveto(Hullpoints[nbrhullpoints].x,Hullpoints[nbrhullpoints].y);
        pen.color:=clgreen;
        for i:= 1 to nbrHullpoints do
        with Hullpoints[i] do lineto(x,y);
      end;
      DrawShortPath:
      Begin
        with points[shortpath[nbrpoints]] do moveto(x,y);
        pen.color:=cllime;
        for i:= 1 to nbrpoints do with points[shortpath[i]] do lineto(x,y);
      end;
    end; {case}
  end;
end;

{****************** PaintBoxMouseUp *****************************}
procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Add a point}
begin
  with paintbox1 do
  if nbrpoints<maxpoints then
  Begin
    inc(nbrpoints);
    nbrPointslbl.caption:=inttostr(nbrpoints)+' Points';
    points[nbrpoints].x:=x;
    points[nbrpoints].y:=y;
    if drawtype=drawsimplepath then SimplePathBtnClick(self)
    else if drawtype=drawHull then ConvexHullBtnClick(self)
    else drawtype:=none;
    invalidate;
  end;
end;

Procedure tform1.setpathlength(p:TPoints; nbr:integer);
{Used for simple and hull path length calculation}
var
  d:single;
  i:integer;
  prevx,prevy:integer;
begin
  with p[nbr] do
  Begin
    prevx:=x;
    prevy:=y;
  end;

  d:=0;
  for i:= 1 to nbr do
  with p[i] do
  Begin
    d:=d+sqrt((x-prevx)*(x-prevx)+(y-prevy)*(y-prevy));
    prevx:=x;
    prevy:=y;
  end;
  PathLengthLbl.caption:=format('Path length: %5.0n',[0.0+d]);
end;

Function TForm1.Getfirstpath:integer;
{Initialize shortest path length search}
Begin
  Drawtype:=DrawShortPath;
  combo.setup(nbrpoints,nbrpoints,permutations);
  maxpathsLbl.caption:=format('%15d',[combo.getcount]);
  minpath:=100000;
  result:=getnextpath;
end;

Function TForm1.GetNextPath:integer;
var
  i,dist:integer;
Begin
  if combo.getnextpermute then
  Begin
    shortpath[1]:=combo.selected[1];
    {Initialize total path length (d) with distance from last point to first point}
    with combo do dist:=d[selected[nbrpoints],selected[1]];
    for i:= 2 to nbrpoints do
    Begin
      shortpath[i]:=combo.selected[i];
      with points[shortpath[i]] do
      Begin
        dist:=dist+d[shortpath[i],shortpath[i-1]];
        if dist>minpath then break;  {quit if path is not shortest}
      end;
    end;
    result:=dist;
  end
  else result:=0;
end;

{****************** FormCreate ****************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  nbrpoints:=0;
  DrawType:=None;
  Combo:=TComboset.create; {initialize permutations}
  doublebuffered:=true;  {stop flicker on repaints}
  makecaption('Fences & Traveling Salesmen',
               #169+' 2002, G. Darby, DelphiForFun.org',self);
end;

{********************* FormCloseQuery *******************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{User clicked close button}
begin
  stopbtnclick(sender);
  canclose:=true;
end;

{************************************************************}
{*************** Button Methods *****************************}
{************************************************************}

{****************** SimplePathBtnClick ********************}
procedure TForm1.SimplePathBtnClick(Sender: TObject);
{A simple path connects all point without any crossings}
{Plan:  Pick the lowest point and calculate the angle of
 a line from there to each other point.  Sort by angle and
 use that list as the order in which to draw the path}
var
  i,j,maxi,maxx,maxy:integer;
  tana:single;
  hold:single;
  holdp:TPoint;
  angles:array[1..maxpoints] of single;
begin
  if nbrpoints<2 then exit;
  {Find max y coordinate (lowest point}
  maxi:=1;
  for i:= 2 to nbrpoints do
    if points[i].y>points[maxi].y then maxi:=i;
  {Compute angle from this point to every other point}
  maxx:=points[maxi].x;
  maxy:=points[maxi].y;
  for i:= 1 to nbrpoints do
  Begin
    if points[i].x-maxx<>0
    then tana:=(points[i].y-maxy)/(points[i].x-maxx)
    else tana:=0;
    Angles[i]:=arctan(tana);
  end;
  {OK, now sort points by ascending (or descending) angle}
  for i:= 1 to nbrpoints do
  for j:=i+1 to nbrpoints do
  if angles[j]<angles[i] then
  Begin
    hold:=angles[j];
    angles[j]:=angles[i];
    angles[i]:=hold;
    holdp:=points[j];
    points[j]:=points[i];
    points[i]:=holdp;
  end;
  {Finally set the flag to tell paint to connect the points}
  Drawtype:=DrawSimplePath;
  setpathlength(points,nbrpoints);
  paintbox1.repaint;
end;


{********************* ConvexHullBtnClick ****************}
procedure TForm1.ConvexHullBtnClick(Sender: TObject);
{A Convex hull traces the path a piece of string would
 take if wrapped around the points if they were pegs}
{Plan:  Pick the lowest point (biggest y value) and
 make it first point.  Calculate the included angle one of this
 line to every other point - choose the point with the
 biggest included angle (smallest external angle), draw the line there and repeat
 until back to starting point. }

var
  i,mini,maxi:integer;
  holdp:TPoint;
  angle:single;
  minangle, prevmin :single;
  done:boolean;
  used:array[1..maxpoints] of boolean;

  function getangle(p1,p2:TPoint):single;
  Begin
    if p1.x=p2.x
    then if p1.y>p2.y then result:=0.5*pi
         else
         if p1.y<p2.y then result:=-0.5*pi
         else result:=0
    {arctan2 returns angle corrected for quadrant, so it runs from 0 to 2Pi}
    else result:=arctan2((p1.y-p2.y),(p2.x-p1.x));
    if result<0 then result:=result+2*pi;
  end;

begin
  if nbrpoints<2 then exit;
  {Find the smallest angle relative to horizontal from each hull point to all others
   that is also greater than the previous minimum angle found, i.e. as we move
   around the boundary, the angle turned must keep increasing to maintain convexity}

  {find lowest point (biggest y) - guaranteed to be on boundary - could also use
   any other extreme dimension}
  maxi:=1;
  for i:= 2 to nbrpoints do if points[i].y>points[maxi].y
  then maxi:=i;

  hullpoints[1]:=points[maxi]; {make it the starting point}
  {also swap it into position 1}
  holdp:=points[1];
  points[1]:=points[maxi]; points[maxi]:=holdp;

  nbrhullpoints:=1;
  prevmin:=0;
  done:=false;
  for i:=1 to nbrpoints do used[i]:=false;
  {used[1]:=true;} {oops - first point must remain in test as a stopper when
                     we finish the loop}
  repeat
    mini:=1;
    minangle:=10.0; {Initialize to any number > 2*Pi since we'll rotate 2Pi radians
                     in making the hull}
    for i:= 1 to nbrpoints do
    if not used[i] then
    Begin
      angle:=getangle(hullpoints[nbrhullpoints],points[i]);
      {Looking for the smallest of the available angles that are still
       greater than previous angle}
      if (angle>prevmin) and (angle<minangle) then
      Begin  {save the angle and the point number}
        mini:=i;
        minangle:=angle;
      end;
    end;
    If (minangle>prevmin) then
    Begin
      prevmin:=minangle;
      inc(nbrhullpoints);
      hullpoints[nbrhullpoints]:=points[mini];
      if mini=1 then done:=true
      else used[mini]:=true;
    end
    else done:=true;
  until done;
   {Finally set the flag to tell paint to connect the hull points}
    dec(nbrhullpoints);{first point was added again at end - not necessary}
    Drawtype:=DrawHull;
    setpathlength(Hullpoints, nbrhullpoints);
    paintbox1.invalidate;
end;


procedure TForm1.ShortBtnClick(Sender: TObject);
{It is believed to impossible to solve this problem in practical terms
 i.e there are n! paths connecting n points and no known shortcut algorithm
 to ensure that we have the shortest without searching them all. (I have
 recently read of tests for optimality for specific solutions but have checked
 into it yet.)

 We should have no problem up to 10 points (3.6 million paths), probably
 can't do 15 points (1.3 trillion paths) with the practical limit somewhere
 in between.  We'll start with exhaustive search and then later work on
 smarter techniques that may converge faster}
 var
  i,j, x1,x2,y1,y2:integer;
  pathlength:integer;
  count:integer;
  mindist, dist, lowdistindex:integer;
  temppoints: array[1..maxpoints] of TPoint;
  used: array [1..maxpoints] of boolean;
begin
  If nbrpoints<2 then exit;
  Drawtype:=drawshortpath;
  tag:=0; {reset stop flag}
  count:=0;
  {Rather than juggle the points for each path, we'll just keep an array
   of point numbers and use those as pointers into the points array
   to draw a path}
  ShortpathGrpBox.visible:=true;
  PathLengthLbl.visible:=true;
  screen.cursor:=crHourGlass;

  {enhancement - sort the points so that each is near its closest neighbors}
    temppoints[1]:=points[1];
    used[1]:=true;
    for i := 2 to nbrpoints do used[i]:=false;
    for i:= 2 to nbrpoints do
    begin
      x1:=temppoints[i-1].x;
      y1:=temppoints[i-1].y;
      mindist:=high(integer);
      for j:=2 to nbrpoints do
      if not used[j] then
      begin
        x2:=points[j].x;
        y2:=points[j].y;
        dist:=trunc(sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)));
        if dist<mindist then
        begin
          mindist:=dist;
          lowdistindex:=j
        end
      end;
      used[lowdistindex]:=true;
      temppoints[i]:=points[lowdistindex];
    end;
    for i:= 1 to nbrpoints do points[i]:=temppoints[i];



  {set an array of distances between each pair of points to save calc time}
  for i:= 1 to nbrpoints do
  for j:= i to nbrpoints do
  begin
    x1:=points[i].x;
    y1:=points[i].y;
    x2:=points[j].x;
    y2:=points[j].y;
    d[i,j]:=trunc(sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)));
    d[j,i]:=d[i,j];
  end;



  minpath:=getfirstpath;
  Setpathlength(points,nbrpoints);
  Paintbox1.invalidate;
  application.processmessages;
  repeat
    pathlength:=getnextpath; {returns 0 when no more paths}
    if (pathlength>0) and (pathlength<minpath) then
    Begin
      minpath:=pathlength;
      PathLengthLbl.caption:=format('Path length %5.0n',[0.0+minpath]);
      paintbox1.invalidate;
      application.processmessages;
    end;
    inc(count);
    if count mod 10000 = 0 then
    Begin
      countlbl.caption:=format('%12.0n',[0.0+count]);
      application.processmessages;
      if tag=1 then pathlength:=0; {stop button was hit}
    end;
  until pathlength=0;
  ShortPathGrpBox.visible:=false;
  screen.cursor:=crDefault;
end;

procedure TForm1.StopbtnClick(Sender: TObject);
begin    tag:=1;  end;

{*************** ResetLinesClick *******************}
procedure TForm1.ResetLinesBtnClick(Sender: TObject);
begin
  DrawType:=None;
   PathLengthLbl.caption:='0';
  repaint;
end;

{********************* ResetAllBtnClick **************}
procedure TForm1.ResetAllBtnClick(Sender: TObject);
begin
  resetlinesbtnclick(Sender);
  nbrpoints:=0;
  repaint;
end;


end.
