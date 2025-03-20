unit U_CircleCoveringPoints2;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{We'll try several methods of finding the smallest circle which covers a
 given set of points}

(*

Source:  D. Jack Elzinga, Donald W. Hearn, "Geometrical Solutions for some minimax location problems,"
Transportation Science, 6, (1972), pp 379 - 394.

 From: http://www.eng.clemson.edu/~pmdrn/Dearing/location/minimax.pdf

Algorithm to find the minimum circle covering a set of points on a plane

1. Choose any two points, Pi and Pj

2. Construct the circle whose diameter is l2(Pi, Pj).
   If this circle contains all points, then the center of the circle is the optimal X.
   Else, choose a point Pk outside the circle.

3. If the triangle determined by Pi, Pj and Pk is a right triangle or an obtuse triangle,
   rename the two points oposite the right angle or the obstuse angle as Pi and Pj
   and go to step 2.
   Else, the three points determine an acute triangle. Construct the circle passing
   through the three points. (The center is the intersection of the perpendicular
   bisectors of two sides of the triangle.) If the circle contains all the points, stop,
   else, go to 4.

4. Choose some point Pl not in the circle, and let Q be the point among {Pi, Pj, Pk}
   that is greatest distance from Pl. Extend the diameter through the point Q to a line
   that divides the plane into two half planes. Let the point R be the point among
   {Pi, Pj, Pk}that is in the half plane opposite Pl. With the points Q, R, and Pl, go
   to step 3.
   *)
 {Version 2 - allow user to enter a set of of via keyboard}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, ShellAPI;

type
  TRealPoint=record
    x,y:extended;
    end;

  TCircle=record
    center:TrealPoint;
    radius:extended;
  end;

  TLine=record
    p1,p2:TRealPoint;
  end;

  TForm1 = class(TForm)
    Image1: TImage;
    ResetBtn: TButton;
    MethodGrp: TRadioGroup;
    Memo1: TMemo;
    ResultsLbl: TLabel;
    TimeLbl: TLabel;
    Memo2: TMemo;
    Loadbtn: TButton;
    SaveBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure LoadbtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Memo2Change(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    { Public declarations }
    points:array of TRealPoint;
    nbrpoints:integer;
    dmax:extended;
    scale,offsetx,offsety:extended;
    min:TRealpoint;
    modified:boolean;
    nodraw:boolean; {flag to prevent redrawing while memo2 is loaded}
    procedure drawshape;
    procedure addpoint(x,y:integer);
    function IsAcute(p1,p2,p3:integer; Var q1,q2:integer):boolean;
    function containsall(circle:TCircle):integer;
    function rebuildpoints(var errmsg:string):boolean;
    procedure checkmodified;
    function makerealpoint(x,y:integer):TRealpoint;
    function makeplotPoint(x,y:extended):TPoint;
    procedure rescalePoints;
    function needsrescale:boolean;
  end;

var
  Form1: TForm1;

implementation

uses math;
{$R *.DFM}

{******************* Local Routines *************}


procedure swap(var p1,p2:TRealPoint);
var
  temp:TRealPoint;
begin
  temp:=p1;
  p1:=p2;
  p2:=temp;
end;



function distance(p1,p2:TRealPoint):extended;
begin
  result:=sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y));
end;

function getcenter(p1,p2,p3:TRealPoint; var center:TRealPoint):boolean;
{given three points, return the coordinates of the center of the circle passing
 through them, return false if no such circle exists}
      var
        x,y:extended;
        ma,mb:extended;
      begin
        result:=true;
        ma:=0;  mb:=0; {stop compiler warnings about maybe not initialized}
        {we don't want infinite slopes,
         (or 0 slope) for line 1, since we'll divide by the  slope, "ma", below)}
        if (p1.x=p2.x) or (p1.y=p2.y) then swap(p1,p3);
        if (p2.x=p3.x) then swap(p1,p2);

        if p1.x<>p2.x then ma:=(p2.y-p1.y)/(p2.x-p1.x)
        else result:=false;
        if p2.x<>p3.x then mb:=(p3.y-p2.y)/(p3.x-p2.x)
        else result:=false;
        If (ma=0) and (mb=0) then result:=false;
        if ma=mb then result:=false;
        if result=true then
        begin
          x:=(ma*mb*(p1.y-p3.y)+mb*(p1.x+p2.x)-ma*(p2.x+p3.x))/(2*(mb-ma));
          if ma<>0 then  y:=-(x-(p1.x+p2.x)/2)/ma + (p1.y+p2.y)/2
          else y:=-(x-(p2.x+p3.x)/2)/mb + (p2.y+p3.y)/2;
          center.x:=x;
          center.y:=y;
        end;
      end;

  function getcircle(p1,p2,p3:TRealPoint; var circle:Tcircle):boolean;
  {Find the circle that circumscribes 3 points}
  begin
    result:=getcenter(p1,p2,p3, circle.center);
    with circle do
    if result then radius:=sqrt(sqr(p1.x-center.x)+sqr(p1.y-center.y))
    else radius:=0;
  end;


  function getangle(p1,p2,p3:TRealPoint):extended;
  {return absolute value of smaller angle between lines defined by
   points p1-p2 and  p2-p3}
  begin
     result:=arccos(ABS(((p1.x-p2.x)*(p2.x-p3.x) + (p1.y-p2.y)*(p2.y-p3.y)) /
      (sqrt(sqr(p1.x-p2.x)+sqr(p1.y-p2.y)) * sqrt(sqr(p2.x-p3.x) + sqr(p2.y-p3.y)))));
  end;

  function sameside(L:TLine; p1,p2:TrealPoint):extended;
  {check where 2 points lie in relation to a given line}
  {same side            => result>0
   opposite sides       => result <0
   a point on the line  => result=0 }
  var
    dx,dy,dx1,dy1,dx2,dy2:extended;
  begin
    dx:=L.p2.x-L.P1.x;
    dy:=L.p2.y-L.P1.y;
    dx1:=p1.x-L.p1.x;
    dy1:=p1.y-L.p1.y;
    dx2:=p2.x-L.p2.x;
    dy2:=p2.y-L.p2.y;
    result:=(dx*dy1-dy*dx1)*(dx*dy2-dy*dx2);
  end;


 {************************* TForm1 Methods *****************}

{**************** MakeRealPoint **************}
Function TForm1.makerealpoint(x,y:integer):TRealpoint;
{scale clicked plot point to real coordinates}
begin
  result.x:=(x-offsetx)/scale+min.x;
  result.y:=(y-offsety)/scale+min.y;
end;

{***************** MakePlotPoint *************}
function TForm1.makeplotPoint(x,y:extended):TPoint;
{Conver point from points array to a plot point}
begin
  result.x:=round((x-min.x)*scale +offsetx);
  result.y:=round((y-min.y)*scale+offsety);
end;



{************************** IsAcute *****************************}
 function TForm1.IsAcute(p1,p2,p3:integer; Var q1,q2:integer):boolean;
 {return true if triangle defined by points p1,p2,p3 is acute (no angle
 greater than 90 degrees, pi/2 radians) and return  0 in q1 and q2.
 If it's not acute, the triangle is right or obtuse,  return the 2 acute
 angle points in q1 and q2}
 var
   a1:extended;
 begin
   result:=false;
   a1:=getangle(points[p2],points[p1],points[p3]);
   if a1<pi/2 then {angle 1 is acute}
   begin
     a1:=getangle(points[p1],points[p2],points[p3]);
     if a1<pi/2 then  {second angle is acute}
     begin
       a1:=getangle(points[p1],points[p3],points[p2]);
       if a1<pi/2 then {3rd angle is acute - triangle is acute}
       begin
         q1:=0;
         q2:=0;
         result:=true;
       end
       else
       begin  {3rd angle right or obtuse, return other end points}
         q1:=p1;
         q2:=p2;
       end;
     end
     else
     begin {2nd angle right or obtuse}
       q1:=p1;
       q2:=p3;
     end;
   end
   else
   begin  {1st angle right or obtuse}
     q1:=p2;
     q2:=p3;
   end;
 end;

{**************** Image1MouseUp *****************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  savebtn.enabled:=true;
  addpoint(x,y);
  if nbrpoints>2 then drawshape
  else
  with image1.canvas do
  begin
    pen.color:=clred;
    ellipse(x-1,y-1,x+1,y+1);
  end;
end;

{**************** AddPoint **************}
procedure TForm1.addpoint(x,y:integer);
begin
  if nbrpoints>=length(points) then setlength(points, nbrpoints+25);
  points[nbrpoints]:=makerealpoint(x,y);
  with points[nbrpoints] do memo2.lines.add(format('%8.3f,%8.3f',[x,y]));
  inc(nbrpoints);
end;


{************************* ContainsAll *******************}
function Tform1.containsall(circle:TCircle):integer;
{returns -1 if all points in points array are less than radius units from center
 from given circle,  otherwise returns the point number of the first
 outside point found}
var
  i:integer;
  d:extended;
begin
  result:=-1;
  for i:=0 to nbrpoints-1 do
  with circle do
  begin
    d:=distance(points[i],center);
    if d>radius+1e-6 then
    begin
      result:=i;
      break;
    end;
  end;
end;

function TForm1.needsrescale:boolean;
{If any point scales to an off image plotpoint, then we need to rescale}
var
  i:integer;
  p:TPoint;
begin
  result:=false;
  for i:=0 to nbrpoints-1 do
  with points[i] do
  begin
    p:=makeplotpoint(x,y);
    if (p.x<=0) or (p.y<=0) or
       (p.x>=image1.width) or (p.y>=image1.height)
    then
    begin
      result:=true;
      break;
    end;
  end;
end;


procedure TForm1.rescalePoints;
var
  i:integer;
  max:TRealpoint;
  xscale,yscale:extended;


begin
  {now we can rescale if we need to}
  max:=points[0];
  min:=points[0];
  for i:= 1 to nbrpoints-1 do
  begin
    {find max and min to establish scaling}
    if points[i].x>max.x then max.x:=points[i].x;
    if points[i].x<min.x then min.x:=points[i].x;
    if points[i].y>max.y then max.y:=points[i].y;
    if points[i].y<min.y then min.y:=points[i].y;
  end;
  offsetx:= 0.25*image1.width;
  offsety:=offsetx;
  if max.x-min.x<>0 then xscale:=0.50*image1.width/(max.x-min.x)
  else begin xscale:=0.50*image1.width; offsetx:=xscale; end;
  If max.y-min.y<>0 then yscale:=0.50*image1.height/(max.y-min.y)
  else begin yscale:=0.50*image1.height; offsety:=yscale; end;
  if xscale<yscale then scale:=xscale else scale:=yscale;
end;

{************ DrawShape **********}
procedure TForm1.drawshape;
{Apply the selected algorithm, draw the resulting circle,
 display run statistics}
var
  d,d1, dmax:extended;
  i,j,k,r:integer;
  pii,pj,Pk,P1,Q:integer;
  e1,e2:integer;
  found:boolean;
  circle, circle0:TCircle;
  line1:TLine;
  start,stop,freq:int64;
  count:integer;
  //max:TRealpoint;

  p:TPoint;

begin
  If nbrpoints<3 then exit; {need at least 2 points}

  QueryPerformanceCounter(start);
  {find the 2 points with maximum distance between them}
  dmax:=0;
  pii:=0; pj:=0;  {just to get rid of compiler warning messages}
  for i:= 0 to nbrpoints-2 do
  for j:= i+1 to nbrpoints-1 do
  begin
    d:=distance(points[i],points[j]);
    if d>dmax then
    begin
      pii:=i;
      pj:=j;
      dmax:=d;
    end;
  end;
  found:=true; {default if not changed by algorithm}
  {select an alghorithm}
  case methodgrp.itemindex of
  0:   {Find the center and set radius for 1st two points}
  begin
    circle.center.x:=(points[pii].x+points[pj].x)/2.0;
    circle.center.y:=(points[pii].y+points[pj].y)/2;
    circle.radius:=distance(circle.center,points[Pii]);
  end;

  1:{Find the center and set radius to max distance form there to any point}
  begin
    circle.center.x:=(points[pii].x+points[pj].x)/2;
    circle.center.y:=(points[pii].y+points[pj].y)/2;
    dmax:=0;
    for i:= 0 to nbrpoints-1 do
    begin
      d:=distance(circle.center,points[i]);
      if d>dmax then dmax:=d;
    end;
    circle.radius:=dmax;
  end;

   2:
   begin
    {Find the third point that gives the  max triangle perimeter and
      circumscribe a circle around those 3 points}
      dmax:=0;
      pk:=-1;
      for i:= 0 to nbrpoints-1 do
      if (i<>pii) and (i<>pj) then
      begin
        d:=sqrt(sqr(points[pii].x-points[i].x)+sqr(points[pii].y-points[i].y))
        +sqrt(sqr(points[pj].x-points[i].x)+sqr(points[pj].y-points[i].y)) ;
        if d>dmax then
        begin
          dmax:=d;
          Pk:=i;
        end;
      end;
      if (Pk>=0)
      then found:=getcircle(points[pii],points[pj],points[Pk],circle)
      else found:=false;
    end;
    3:
    begin
      {Find the three points that give the  max triangle perimeter and
       circumscribe a circle around those 3 points}
      dmax:=0;
      pk:=-1;
      for i:= 0 to nbrpoints-3 do
      for j:=i+1 to nbrpoints-2 do
      begin
        d1:=distance(points[i],points[j]);
        for k:=j+1 to nbrpoints-1 do
        begin
          d:=d1+distance(points[i],points[k])
             +distance(points[j],points[k]);
          if d>dmax then
          begin
            dmax:=d;
            pii:=i;
            pj:=j;
            Pk:=k;
          end;
        end;
      end;
      if pk>=0
      then found:=getcircle(points[pii],points[pj],points[Pk],circle)
      else found:=false;
  end;

  4: {try circles around all triangles - looking for one that contains all points}
  begin
    {Find the three points that give the  max triangle perimeter and
     circumscribe a circle around those 3 points}
    circle.radius:=1e10; {set intial radius high}
    for pii:= 0 to nbrpoints-3 do
    for pj:=pii+1 to nbrpoints-2 do
    for pk:=pj+1 to nbrpoints-1 do
    begin
      if getcircle(points[pii],points[pj],points[Pk],circle0)
      then if (containsall(circle0)<0)
          and (circle0.radius<circle.radius) then circle:=circle0;
    end;
    if (circle.radius>0) and (circle.radius<1e10) then found:=true
    else found:=false;
  end;

  5:  {Elzinga-Hearn algorithm}
  begin
    {1. Choose any two points, Pi and Pj  }
    {We'll stick with the max distance pi and pj chosen above}

    found:=false;
    while not found do
    begin
      {2. Construct the circle whose diameter is l2(pi, pj).
       If this circle contains all points, then the center of the circle is
       the optimal X.}
      with circle do
      begin
        center.x:=(points[Pii].x+points[Pj].x)/2;
        center.y:=(points[Pii].y+points[Pj].y)/2;
        radius:=distance(points[Pii],center);
      end;
      Pk:=containsall(circle); {go check containment: Pk= -1 or an outside point}
      if Pk>= 0 then {Pk is a point outside the circle}
      begin
         {Else, choose a point Pk outside the circle. }
         {3. If the triangle determined by Pi, Pj and Pk is a right triangle or
         an obtuse triangle, rename the two points oposite the right angle or
         the obstuse angle as Pi and Pj and go to step 2.}
        count:=0;
        while (not found) and (count<1000){loop stopper for debugging} do
        begin
          inc(count);
          if isacute(Pii,Pj,Pk,e1,e2)
          then
          begin
            {Else, the three points determine an acute triangle.
             Construct the circle passing through the three points.
             If the circle contains all the points, stop, else, go to 4. }
            getcircle(points[pii],points[pj],points[Pk], circle);
            P1:=containsall(circle);
            if P1 >=0 then
            begin
              {4A. Choose some point Pl not in the circle, and let Q be the
               point among  (Pi, Pj, Pk) that is greatest distance from Pl.}
              dmax:=distance(points[P1],points[Pii]);
              Q:=Pii;
              d:=distance(points[P1],points[Pj]);
              if d >dmax then
              begin
                 Q:=Pj;
                 dmax:=d;
              end;
              If distance(points[P1],points[Pk])>dmax then Q:=Pk;
              {4B. Extend the diameter through the point Q to a line
               that divides the plane into two half planes.
               Let the point R be the point among  (Pi, Pj, Pk)that is in
               the half plane opposite Pl. With the points Q, R, and Pl, go
               to step 3. }
               line1.p1:=circle.center;
               line1.p2:=points[Q];
               if (Q<>Pii) and (sameside(line1,points[P1],points[Pii])<0) {<0=opposite sides}
               then  begin pj:=P1;  pk:=q;   end
               else
               if (Q<>Pj) and (sameside(line1,points[P1],points[Pj])<0)
               then  begin  pii:=P1;  pk:=q;  end
               else  begin  pii:=P1;  pj:=q; end;
            end
            else found:=true;
          end
          else
          begin  pii:=e1; pj:=e2; end;
        end;
        If count>=1000 then
        begin
          showmessage('System error - infinite loop');
          exit;
        end;
    end
    else found:=true;
    end;
  end;
  end; {case}
  {Whew!  Thought we'd never get here!}
  if found then
  begin
    queryPerformanceCounter(stop);
    QueryPerformanceFrequency(freq);

    resultsLbl.caption:='Algorithm # '+inttostr(methodGrp.itemindex+1)
                     +#13 + inttostr(nbrpoints) + ' points'
                     +#13 + format('Center (%8.3f,%8.3f)     Radius: %8.3f ',
                               [circle.center.x, circle.center.y, circle.radius]);

    r:=round(scale*circle.radius);
    with image1.canvas, circle do
    begin
      pen.color:=clblack;
      rectangle(clientrect);
      pen.color:=clblue;
      with center do p:=makeplotpoint(x,y);
      ellipse({round(offsetx+scale*(center.x-min.x)}p.x-r,
              {round(offsety+scale*(center.y-min.y)}p.y-r,
              {round(offsetx+scale*(center.x-min.x)}p.x+r,
              {round(offsety+scale*(center.y-min.y)}p.y+r);
      pen.color:=clred;
      for i:= 0 to nbrpoints-1 do
      with points[i] do
      begin
        p:=makeplotpoint(x,y);
        ellipse({round(offsetx+scale*(x-min.x))}p.x-1,
                    { round(offsety+scale*(y-min.y))}p.y-1,
                    { round(offsetx+scale*(x-min.x))}p.x+1,
                    { round(offsety+scale*(y-min.y))}p.y+1);
      end;
    end;
    TimeLbl.caption:=format('%6.0f microseconds',[1e6*(stop-start)/freq]);
  end
  else
  begin
    resultslbl.caption:='No solution found';
    beep;
  end;
  
  If needsrescale then rescalepoints;
end;

procedure TForm1.checkmodified;
begin
  if modified then
  begin
    if messagedlg('Save exitsting points first?',mtconfirmation,[mbYes,mbNo],0)=mryes
    then savebtnClick(self);
    modified:=false;
  end;
end;

{********************** ResetBtnClick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  checkmodified;
  nbrpoints:=0;
  dmax:=0;
  scale:=1.0;
  offsetx:=0; offsety:=0;
  min.x:=0;
  min.y:=0;
  setlength(points,25);
  resultsLbl.caption:='Click above or enter or select Data Entry mode to enter x,y coordinate pairs at right';
  timelbl.caption:='';
  with image1.canvas do rectangle(clientrect);
  memo2.Clear;
end;

{******************* FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  modified:=false;
  nodraw:=false;
  resetbtnclick(sender);
  with image1.canvas do rectangle(clientrect);
  opendialog1.initialdir:=extractfilepath(application.exename);
  savedialog1.initialdir:=extractfilepath(application.exename);

end;

const tab=chr(vk_tab);


{**************** RebuildPoints **************}
function TForm1.rebuildpoints(var errmsg:string):boolean;
{Convert memo2 string data into points array, return errmsg and false if
 problems are found}
var
  i,j:integer;
  err,allOK:boolean;
  xstr,ystr:string;
  line:string;
  x,y:extended;
  errcode:integer;
  p:TPoint;
  rescale:boolean;
begin
  nbrpoints:=0;
  allOK:=true;
  rescale:=false;
  with memo2 do
  for i:=0 to lines.count-1 do
  begin
    line:=lines[i];
    if trim(line)='' then lines.delete(i);
    if  i<=lines.count-1 then
    begin
      err:=false;
      line:=trim(line);
      if length(line)>0 then
      begin
        xstr:='';
        j:=1;
        while (j<=length(line)) and (line[j] in ['-','0'..'9','.']) do
        begin
          xstr:=xstr+line[j];
          inc(j);
        end;
        ystr:='';
        if (j<=length(line)) and (line[j] in [' ', ',',tab]) then
        begin
          inc(j);
          {remove extra blanks between x and y values}
          while (j<=length(line)) and (line[j] =' ') do delete(line,j,1);
          while (j<=length(line)) and (line[j] in ['-','0'..'9','.']) do
          begin
            ystr:=ystr+line[j];
            inc(j);
          end;
        end;
        {remove trailing blanks}
        while (j<=length(line)) and (line[j] =' ') do delete(line,j,1);
        if j<=length(line) then
        begin
          errmsg:='Invalid character '+line[j]+' in line '+inttostr(i+1)
                        + #13 + line
                        + #13 + 'Correct and try again';
          break;
        end;
      end;
      y:=0;
      val(xstr,x,errcode);
      if errcode<>0 then
      begin
        errmsg:='X value '''+xstr + ''' in line '+line+' not a valid real number.'
                    + #13 + 'Correct and try again';
        err:=true;
      end
      else
      begin;
        val(ystr,y,errcode);
        if errcode<>0 then
        begin
          errmsg:='Y value '''+ystr+ ''' in line '+line+' not a valid real number.'
                    + #13 + 'Correct and try again';
          err:=true;
        end;
      end;
      if not err  then
      begin
        points[nbrpoints].x:=x;
        points[nbrpoints].y:=y;
        p:=makeplotpoint(x,y);
        if (p.x<0) or (p.x>image1.width)
          or (p.y<0) or (p.y>image1.height) then
          rescale:=true;
        inc(nbrpoints);
      end
      else
      begin
        allOK:=false;
        break;
      end;
    end;
  end;
  result:=alloK;
  if allok and rescale then rescalepoints;
end;



{************* CalcBtnClick **********}
procedure TForm1.CalcBtnClick(Sender: TObject);
{No longer a button click, checks memo2 data and applies circle search if OK}
var
  msg:string;
begin
  if rebuildpoints(msg) then drawshape else resultslbl.caption:=msg;
end;

{*************** LoadBtnClick ***********}
procedure TForm1.LoadbtnClick(Sender: TObject);
begin
  checkmodified;
  If opendialog1.execute then
  begin
    nodraw:=true;
    memo2.lines.LoadFromFile(opendialog1.filename);
    nodraw:=false;
    calcbtnclick(sender);
  end;
end;

{*************** SaveBtnClick ***********8}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  If savedialog1.execute then
  begin
    memo2.lines.SavetoFile(savedialog1.filename);
    modified:=false;
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

{******* Memo2Change ************8}
procedure TForm1.Memo2Change(Sender: TObject);
{entered whenver user changes memo2 data}
var msg:string;
begin
  if nodraw then exit;  {don't redraw for each point while file is being loaded}
  If Rebuildpoints(msg) then drawshape
  else if memo2.lines.count>2 then resultslbl.caption:=msg
  else resultslbl.caption:='';
  modified:=true;
end;

{************ FormCloseQuesry ***********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Give user a chance to save data before exit}
begin
  checkmodified;
  canclose:=true;
end;

end.
