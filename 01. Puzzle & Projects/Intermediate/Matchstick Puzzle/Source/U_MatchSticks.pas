unit U_MatchSticks;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, Spin, Grids,Graphics, jpeg;

type
  TDir=(L,R,U,D);  {Left, Right, Up, Down}

  TMatchStickRec = record {defines a matchstick}
    HC, HR:integer;  {Lead location: column and Row}
    NbrSegs:integer; {# of segments in this match}
    Dir:TDir;        {Direction from head to tail}
  end;

  TMatchSegRec=record  {One for each segment }
    Burned:boolean; {This segment has been burned}
    Dir:TDir;  {Orientation of the Match}
    Headseg, Lastseg:boolean;
  end;

  TMatchSticks=array of TMatchStickRec;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Image2: TImage;
    Memo1: TMemo;
    Image1: TImage;
    Memo2: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
  public
    MatchSticks: TMatchSticks;
    MatchSegs:array of array of TMatchSegRec;
    NbrCells, NbrSticks:integer;
    Colsums, RowSums:array of TPoint; {x=current sum, y= targetsum}
    cellsize:integer;
    clBrown, clLtGreen:TColor;
    procedure drawgrid;
    procedure drawSticks;
    Procedure BuildSegmentRecords;
    Procedure LoadDefault;
    Procedure UpdateScores;
end;

var
  Form1: TForm1;

implementation

uses DFFUtils, ShowReward;

{$R *.DFM}

var
  Default: array[0..10] of TMatchstickRec =
           ((HC:0;HR:1;NbrSegs:2;Dir:U),   {Dir = direction fron head to tail of the match}
            (HC:0;HR:2;NbrSegs:4;Dir:D),
            (HC:1;HR:0;NbrSegs:5;Dir:D),
            (HC:1;HR:5;NbrSegs:4;Dir:R),
            (HC:2;HR:1;NbrSegs:2;Dir:R),
            (HC:2;HR:2;NbrSegs:3;Dir:D),
            (HC:3;HR:4;NbrSegs:3;Dir:U),
            (HC:4;HR:1;NbrSegs:4;Dir:D),
            (HC:5;HR:0;NbrSegs:4;Dir:L),
            (HC:5;HR:2;NbrSegs:2;Dir:U),
            (HC:5;HR:5;NbrSegs:3;Dir:U)
            );
 DefaultColSums:array [0..5]  of integer= (4,3,2,4,3,4);
 DefaultRowSums:array [0..5] of integer = (4,5,2,3,3,3);


function min(a,b:integer):integer;
begin
  if a<=b then result:=a else result:=b;
end;

{*********** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  reformatMemo(memo1);
  clBrown:=RGB(197,157,67);
  clLtGreen:=clGreen; //RGB(180,255,180);
  (*
  LoadDefault;
  BuildSegmentRecords;
  DrawSticks;
  Updatescores;
  *)
end;

{********** LoadDefault *********}
Procedure TForm1.LoadDefault;
var
  i:integer;
begin

  nbrcells:=length(DefaultColSums);
  with image1 do
  begin
    cellsize:=min(width, height) div (nbrcells+2);
    width:=cellsize*(nbrcells+2);
    height:=width;
    DrawGrid;
    //memo2.lines.add(format('    Image1 (W:%d,H:%d, Cellsize:%d)',[width,height,cellsize]));
  end;

  nbrsticks:=length(Default);
  setlength(Matchsticks,nbrsticks);
  setlength(ColSums,nbrcells);
  setlength(RowSums,nbrcells);
  setlength(MatchSegs, nbrcells, nbrcells);
  for i:= 0 to nbrcells-1 do
  begin
    ColSums[i].x:=0;
    ColSums[i].y:=DefaultColsums[i];
    RowSums[i].x:=0;
    RowSums[i].y:=DefaultRowSums[i];
  end;

  for i:=0 to nbrsticks-1 do
  begin
    matchsticks[i]:=  Default[i];
  end;
end;

{********* BuildSegmentrecords ********}
procedure TForm1.BuildSegmentRecords;
var
  i,j:integer;
  x,y:integer;
  stick:TMatchStickRec;

begin
  for i:=0 to nbrsticks-1 do
  begin
    stick:=matchsticks[i];
    with stick do
    begin
      with matchsegs[Hc,Hr] do
      begin  {initial segment}
        Burned:=false;
        matchsegs[Hc,Hr].dir:=stick.dir;
        lastseg:=false;
        headseg:=true;
      end;
      for j:=1 to Nbrsegs-1 do
      begin
        case dir of
          L: Begin x:=Hc-j; y:=Hr; end;
          R: Begin x:=Hc+j; y:=Hr; end;
          U: Begin x:=Hc; y:=Hr-j; end;
          D: Begin x:=Hc; y:=Hr+j; end;
        end;{case}

        with matchsegs[x,y] do
        begin
          Burned:=false;
          dir:=stick.dir;
          headseg:=false;
          if j=nbrsegs-1 then lastseg:=true else lastseg:=false;
        end;
      end;
    end;
  end;
end;

{*********** DrawGrid **********}
procedure TForm1.drawgrid;
var
  i,k:integer;
begin
  with image1, canvas do
  begin
    rectangle(clientrect);

    for i:=0 to nbrcells do
    begin
      k:=i*cellsize;
      if k>=width then dec(k);
      moveto(0,k);  lineto(width-1,k);
      moveto(k,0);  lineto(k,height-1);
      //if i=nbrcells then memo2.lines.add(format('Right x, Bottom Y =%d',[k]));
    end;
  end;
end;

{************** DrawSticks ************}
procedure Tform1.DrawSticks;
var
  stick:TMatchStickRec;
  x,y,cx,cy:integer;
  f1,f2:integer;
  i:integer;
  w:integer; {matchwidth width}

    {------------ DrawSegs ------------}
    procedure drawsegs(LRUD:TDir; x1,x2,y1,y2:integer);
    var j:integer;
      {.......... DrawLine ...........}
      procedure drawline(a,b,c,d:integer);
      begin {Draw a line from (a,b) to (c,d)}
        with image1.canvas do
        begin
          moveto(a,b);
          lineto(c,d);
        end;
      end;

    begin {Draw Segs - draw the stick portion of a match in any direction}
      with stick, image1,canvas do
      begin
        case LRUD of  {draw the short portion from the match head to the cell edge}
          L,R: begin drawline(x1,y1,x2,y1); drawline(x1,y2,x2,y2); end;
          U,D:begin drawline(x1,y1,x1,y2); drawline(x2,y1,x2,y2); end;
        end;
        { Erase a bit of the match head to open it to the stick segment so we
          can burn or unburn them with one operation }
        pen.Color:=clwhite;
        pen.width:=3;
        moveto(cx,cy);
        case LRUD of
          L: lineto(x+3 ,cy) ;
          R: lineto(x+cellsize -3,cy);
          U: lineto( cx,y+3);
          D: lineto(cx, y+cellsize-3);
        end;
        pen.Color:=clBlack;
        pen.width:=1;
        {draw the rest of the segments}
        for j:=0 to nbrsegs-2 do
        begin
          case LRUD of
            L: begin x1:=x2; dec(x2,cellsize); end;
            R: begin x1:=x2; inc(x2,cellsize); end;
            U: begin y1:=y2; dec(Y2,cellsize); end;
            D: begin y1:=y2; inc(Y2,cellsize); end;
          end;
          if j=nbrsegs-2 then
          begin  {The is the last segment of stick}
            case LRUD of  {so shorten it}
              L:inc(x2,f1);
              R:dec(x2,f1);
              U:inc(y2,f1);
              D:dec(y2,f1);
            end;
            case LRUD of  {And draw the end of the matchstick}
              L,R: drawline(x2,y1,x2,y2);
              U,D: drawline(x1,y2,x2,y2);
            end;
          end;
          case LRUD of  {draw the segment}
            L,R: begin drawline(x1,y1,x2,y1); drawline(x1,y2,x2,y2); end;
            U,D:begin drawline(x1,y1,x1,y2); drawline(x2,y1,x2,y2); end;
          end;
        end;
      end;
    end;
begin {Draw all match sticks}
  w:=cellsize div 10;
  with image1 do
  for i:=0 to nbrsticks-1 do
  begin
    stick:=matchsticks[i];
    with stick,image1, canvas  do
    begin
      {Draw match head}
      pen.Width:=1;
      x:=HC*CellSize;
      y:=HR*cellsize;
      cx:=x+cellsize div 2;
      cy:=y+cellsize div 2;
      f1:=cellsize div 7; //9; {closest offset from cell edge to matchhead}
      f2:=cellsize div 3; //f1+4; {offset from cell edge to narrow match head dimension}
      if dir in [L,R] then ellipse(rect(x+f1,y+f2,x+cellsize-f1,y+cellsize-f2))
      else  ellipse(rect(x+f2,y+f1,x+cellsize-f2,y+cellsize-f1));
      {Draw the segments: pass corner coordinates for the first (shortened)
        segment from end of match head to cell edge}
      case dir of
        L: drawsegs(L,x+f1+3, x, cy-w, cy+w);
        R: drawsegs(R,x+cellsize-f1-3, x+cellsize, cy-w, cy+w);
        U: drawsegs(U, cx-w, cx+w, y+f1+3, y);
        D: drawsegs(D, cx-w, cx+w, y+cellsize-f1-3, y+cellsize);
      end;
    end;
  end;
end;


{***************** Image1MouseUp ****************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  col,row:integer;
  stick:TMatchSegRec;
  cx,cy:integer;
begin
  col:=x div cellsize;
  row:=y div cellsize;
  if (col>nbrcells-1) or (row > nbrcells-1) then exit;
  stick:=MatchSegs[col,row];
  with stick, image1.Canvas do
  begin
    if burned then
    begin {"unburn" the stick for this location to the end of the stick}
      brush.Color:=clwhite;
      repeat
        cx:=(col*cellsize)+cellsize div 2;
        cy:=row*cellsize+ cellsize div 2;
        floodfill(cx,cy,clblack,fsBorder);
        matchsegs[col,row].burned:=false;
        if matchsegs[col,row].lastseg then break;
        Case dir of  {move to next row or column}
          L: dec(col);
          R: inc(col);
          U: dec(row);
          D: inc(row);
        end;
      until (col>=nbrcells) or (col<0) or (row>=nbrcells) or (row<0); {safety stop}
    end
    else {unburned}
    begin {burn the stick from here back to the match head}
      brush.Color:=clbrown;
      repeat
        cx:=(col*cellsize)+cellsize div 2;
        cy:=row*cellsize+cellsize div 2;
        floodfill(cx,cy,clblack,fsBorder); {Color the match segment}
        matchsegs[col,row].burned:=true;
        if matchsegs[col,row].headseg then break;
        Case dir of  {Move to previous row or column}
          L: inc(col);
          R: dec(col);
          U: inc(row);
          D: dec(row);
        end;
       until (col>=nbrcells) or (col<0) or (row>=nbrcells) or (row<0);
    end;
    brush.color:=clwhite;
  end;
  updatescores;
end;

{*********** UpdateScores *********}
Procedure TForm1.UpdateScores;
{Count burnt segment by row and column and display them color coded}
var
  c,r:integer;
  n1,n2:integer;
  solved:boolean;
  p:TPoint;
begin
  for r:=0 to nbrcells-1 do
  for c:=0 to nbrcells-1 do
  begin
    if r=0 then colsums[c].x:=0;
    if c=0 then rowsums[r].x:=0;
    if matchsegs[c,r].burned then
    begin
      inc(colsums[c].x);
      inc(rowsums[r].x);
    end;
  end;
  solved:=true;
  with image1, canvas do
  begin
    font.Size:=12;
    for c := 0 to nbrcells-1  do
    with colsums[c] do
    begin
      n1:=c*cellsize + 4;
      n2:=(nbrcells)*cellsize + 4;
      font.Style:=[];

      if x=y then font.Color:=clLtGreen else
      begin
        solved:=false;
        if x<y then font.Color:=clGray
        else font.Color:=clred;
      end;
      textout(n1,n2,inttostr(x));
      font.Color:=clBlack;
      font.Style:=[fsbold];
      textout(n1,n2+cellsize,inttostr(y));
    end;
    for r := 0 to nbrcells-1  do
    with rowsums[r] do
    begin
      N2:=r*cellsize + 4;
      N1:=(nbrcells)*cellsize + 4;
      font.Style:=[];

      if x=y then font.Color:=clLtGreen else
      begin
        solved:=false;
        if x<y then font.Color:=clGray
        else font.Color:=clred;
      end;
      textout(n1,n2,inttostr(x));
      font.Color:=clBlack;
      font.Style:=[fsBold];
      textout(N1+cellsize,N2,inttostr(y));
    end;
  end;
  if solved then
  begin
    p:=image1.clienttoscreen(point(0,0));
    reward.left:=p.x;
    reward.top:=p.y;
    reward.show;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormResize(Sender: TObject);
var
  newmaxh,newmaxw, r,b,wh:integer;
begin
  {Resize Image1 here}
  with image1  do
  begin
    r:=left+width;
    b:=statictext1.top-10;
    NewMaxH:=b - (memo1.top+memo1.height) -10;
    NewmaxW:=Memo1.width;
    WH:=min(NewmaxW, NewMaxH);
    width:=WH;
    height:=WH;
    picture.bitmap.width:=WH;
    picture.bitmap.height:=WH;
    Top:=B-wh;
    Left:=R-wh;
  end;
  //with image1 do memo2.lines.add(format('Image1 (L:%d,T:%d),(W:%d,H:%d)', [left,top,width,height]));
  LoadDefault;
  BuildSegmentRecords;
  DrawSticks;
  Updatescores;
end;

end.
