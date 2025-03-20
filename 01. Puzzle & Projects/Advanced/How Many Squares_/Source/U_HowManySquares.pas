Unit U_HowManySquares;

{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Here's an investigation from the latest addition to my library of math & puzzle
books: "Challenging Math Problems", Terry Stickels, Dover Publications, 2015.

Problem #12 in the book shows 24 matchsticks formed into a 3x3 grid and asks
about the fewest sticks that can be removed to eliminate all complete squares
of any size.  Actually one solution is given and the real question is "What is
the minimum number matchsticks that need to be removed from a 4x4 gtid of 40
matchsticks to leave no squares of any size?"  This program will not tell you
directly, but will let you play around by adding and removing sticks from
various sized grids with feedback at each step about the number of squares
remaining.
}

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ShellAPI, UGeometry, DFFUtils, ComCtrls,
  Spin, inifiles;

type
  TDirection = (East,South, Unknown);  {short for Horizontal, Vertical }
  TEdge=record
    edgeLine:Tline;
    dir:Tdirection;
    exists:boolean;
    SqaresEdge:integer;
  end;

  TVertex=record
    H, V:TEdge;
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    StaticText1: TStaticText;
    Memo1: TMemo;
    StaticText2: TStaticText;
    CreateSheet: TTabSheet;
    CountLbl: TLabel;
    Memo4: TMemo;
    AddEdgesBtn: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    HeightEdt: TSpinEdit;
    WidthEdt: TSpinEdit;
    BuildBtn: TButton;
    CountBtn: TButton;
    ShowBtn: TButton;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Image1: TImage;
    procedure PageControl1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BuildBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure AddEdgesBtnClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CountBtnClick(Sender: TObject);
    procedure StaticText2Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
  public
    nbrwide,nbrhigh:integer;
    filename:string;
    modified:boolean;  {graph has been modified}
    cellsizex, cellsizey, cellsize:integer;
    Vertices:array of array of TVertex;
    BGColor:TColor;
    mhL:integer; {matchhead length}
    mhW:integer; {matchhead width}
    msW:integer; {matchstick width}
    sp:integer; {spacing}
    MHColor, MSColor:TColor;  {Head and stick colors}
    IniName:string;
    procedure Initgrid;
    procedure makeAllEdges(yes:boolean);
    procedure makeEdgeFrom(c,r:integer; nextdir:TDirection; Yes:Boolean; var edge:TEdge);
    procedure DrawAllEdges;
    procedure Drawedge(c,r:Integer; Direction:TDirection);
    function Nearedge(x,y:integer; var ClosestVertex:TPoint):TEdge;  {return the edge closest to clicked point}
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
uses math, U_savedlg, U_LoadDlg;

const
  ClLightgray=$00E7E7E7;

{********** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
   doublebuffered:=true;
   pagecontrol1.ActivePage:=introsheet;
   IniName:=changefileExt(application.ExeName, '.ini');
end;

{*********** PageControl1Change ***********}
procedure TForm1.PageControl1Change(Sender: TObject);
begin
   if pagecontrol1.activepage=CreateSheet then AddEdgesBtnClick(sender);
end;

{**********  InitGrid **********}
procedure TForm1.Initgrid;
var
  nbr:integer;
begin
  BGcolor:=$00FEFAE0;       //clSkyBlue; //$00FEFAEE; //ClMoneyGreen;
  MSColor:=ClWhite;
  MHColor:=ClRed;
  {not resetting "vertices" array length messes up setting of array values when size decreases}
  setlength(vertices,0,0);

  with Image1, canvas  do
  begin
    brush.Color:=BGColor;
    fillrect(clientrect);
    nbrwide:=Widthedt.Value ;
    nbrhigh:=HeightEdt.Value;
    nbr:=max(nbrwide, nbrhigh);
    mhL:=Image1.width div nbr div 6;  {scaled length of match stick head}
    MhW:=mhl div 4; {Matchhead width}
    MSW:=max(MhW div 2, 1); {make sure that matchstick is at least 1 pixel wide}
    sp:=MhW;
    cellsizex:=(Image1.width) div nbr-mhw-sp;  {leave room for  matchstick in last row or column}
    cellsizey:=(Image1.height) div nbr-mhw-sp;
    cellsize:=min(cellsizex,cellsizey);
    setlength(vertices, cellsize*(nbrwide+1), cellsize*(nbrhigh+1));
    pen.color:=clLightGray;
  end;
end;

{************ MakeAllEdges ************}
procedure TForm1.makeAllEdges(yes:boolean);
var
  c,r:integer;
 begin
   initgrid;
   for c:=0 to nbrwide do
   for r:=0 to nbrhigh do
   with vertices[c,r] do
   begin
     if c<nbrwide then makeedgeFrom(c,r,East,yes,H);
     if r<nbrhigh then makeedgeFrom(c,r,South,yes,V);
   end;
 end;

 {************* MakeEdgeFrom ***************}
  procedure TForm1.makeEdgeFrom(c,r:integer;nextdir:TDirection;
                                Yes:boolean; var Edge:TEdge);
  var
    p:TPoint;
  begin
    with Edge do  {Build  edgeline on vertex (c,r)for direction "NextDir"}
    begin {set true or false for edges except last column or row always false}
      p:=point(c*cellsize,r*cellsize);
      p.x:=p.x+mhw + sp; {move matches over and down from cell border}
      p.y:=p.y+mhw + sp;

      Dir:=nextdir;
      Exists:=Yes;
      If  (c<nbrwide) and (nextdir=East)
      then Edgeline:=line(p, point(p.x+cellsize{-(mhw+sp)},p.y))
      else if (r<nbrhigh) and (nextdir=South)
      then edgeline:=line(p, point(p.x,p.Y+cellsize{-(mhw+sp)}))
      else
      begin
        dir:=Unknown;
        exists:=not yes;
      end;
    end;
  end;

{*********** BuildBtnClick *********}
procedure TForm1.BuildBtnClick(Sender: TObject);
begin
  makeAllEdges(false); {True makes all matchstrcks}
  Drawalledges;
  CountBtnClick(sender);
end;

{*********** DrawAllEdges ************}
procedure TForm1.drawAllEdges;
var
  c,r:integer;
begin
  with image1, canvas do rectangle(Clientrect);
  for c:=0 to nbrwide do
  for r:=0 to nbrhigh do
  with vertices[c,r] do
  begin
     drawedge(c,r,H.dir);
     drawedge(c,r,V.dir);
  end;
end;

{*********** DrawEdge **************}
Procedure TForm1.drawedge(c,r:integer; direction:TDirection);

begin
  with image1, canvas, Vertices[c,r] do
  begin
    brush.Color:=BGcolor;
    pen.width:=1;
    if (direction=East) then
    with h,edgeLine do
    begin
      {clear previous grayline or match}
      brush.Color:=BgColor;
      fillrect(rect(p1.X+sp, p2.Y-mhw, p2.X-sp, p2.Y+mhw)); {erase old}
      //image1.Update; {for debugging}
      if exists then
      begin {horizontal match}
        pen.color:=clblack;
        brush.Color:=MHColor{clred}; {Used so existing squares can be identified by changing colors}
        ellipse(p2.x-mhL-mhw{15}, p2.Y-mhW , p2.x-mhw{15},p2.y+mhW);
        brush.Color:=MSColor{clwhite};
        rectangle(rect(p1.X+2*sp,p1.Y-MsW,p2.X-mhl{+sp},p2.Y+MsW));
      end
      else
      begin
        pen.Width:=3;
        pen.Color:=clLightGray;
        moveto(p1.X+4, p1.y);
        lineto(p2.X,p2.y);
        //image1.update;  {for debugging}
      end;

    end
    else if (direction=South) then
    with v,edgeLine do
    begin
      fillrect(rect(p1.X-mhw, p1.Y+ sp,p2.X+mhl, p2.Y-sp)); {erase old}
      if exists then
      begin     {vertical match}
        pen.color:=clBlack;
        brush.Color:=MHColor{clred};
        ellipse(p2.x-mhw, p2.Y-mhL-mhw{15}, p2.x+mhw, p2.y-mhw{15});
        pen.color:=clblack;
        brush.color:=MSColor {clwhite};
        rectangle(rect(p1.X-msw, p1.Y+2*sp, p2.X+msw, p2.Y-mhl{+sp}));
      end
      else
      begin
        pen.Width:=3;
        pen.Color:=clLightGray;
        moveto(p1.X, p1.y);
        lineto(p2.X,p2.y);
      end;
    end;
  end;
end;

{************** AddEdgesBtnClick ***********}
procedure TForm1.AddEdgesBtnClick(Sender: TObject);
begin
  makeAllEdges(true);
  DrawAllEdges;
  countbtnclick(sender);
end;

{************* NearEdge ************}
function TForm1.Nearedge(x,y:integer; Var ClosestVertex:TPoint):TEdge;
var
  c,r:integer;
  closestDist:integer;
  closestdir:TDirection;
  dist:integer;
  p:TPoint;

    function CheckForNewShortEdge(var E:TEdge):boolean;
    {check if the distance of the clicked point is closest so far from edge "E"}

    begin
      result:=false;
      with E, edgeline do
      begin
        {get perpendicular distance from point "P" to edge"E"}
        {Return large number if no intersection}
        dist:=5000;
        if  (dir=East) and (P.x>=P1.x) and (p.x<=p2.x)
        then dist:= abs(p.y-p1.y)
        else
        if (dir=South) and (P.y>=P1.y) and (p.y<=p2.y)
        then dist:= abs(p.x-p1.x);
        // dist:=perpdistance(edgeLine,p);
        if dist<closestdist then
        begin
          closestDist:=dist;
          closestdir:=dir;
          Result:=true;
        end;
      end;
    end;

begin {NearEdge}
  p:=point(x,y);
  closestdist:=5000;
  closestvertex:=point(-100,-100);
  for c:=0 to nbrwide do
  for r:=0 to nbrhigh do
  with vertices[c,r] do
  begin
    if checkfornewshortedge(H) then closestvertex:=point(c,r);
    if checkfornewshortedge(V) then closestvertex:=point(c,r);
  end;
  if closestVertex.x>=0
  then with vertices[closestvertex.x, closestvertex.y] do
  begin
    if closestdir=east then
    begin
      h.exists:=not h.exists;
      with result do
      begin
        edgeLine:=h.edgeline;
        dir:=h.dir;
        exists:=h.exists;
      end
    end
    else
    begin
      v.exists:=not V.exists;
      with result do
      begin
        edgeLine:=v.edgeline;
        dir:=v.dir;
        exists:=v.exists;
      end;
    end;
  end
  else result.dir:=unknown;
end;


{***********Image1MouseDown *************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  E:TEdge;
  VPoint:TPoint;
begin
  //memo4.clear;  {cleared to display results during debugging}
  e:=nearedge(x,y, VPoint);
  with E do
  begin
    if dir<>Unknown then
    with edgeLine do
    begin
      if (p1.x>=0) and (p1.y>=0)
      then with Vpoint do
      begin
        Drawedge(x,y,dir);
        countbtnclick(sender);
       end;
    end;
  end;
end;


{************* CountBtnClick ***************}
procedure TForm1.CountBtnClick(Sender: TObject);
{Count squares of all sizes with currently defined edges
 In a NbrWide x Nbrhigh grid, let M=min(nbrwide, nbrhigh)
 There may be squares of sizes: {1x1, 2x2,  ... MxM}
var
  c,r:integer;
  M,N,count:integer;
  emptyedges:integer;
  winscore:integer;
  msg:string;
  b:TBitmap;
  saverect:Trect;

  {----------- IsSquare -----------}
  function IsSquare(C,R,Size:integer):boolean;
  {return true if (c,r) is the top left corner of a square of size "size"}
  var
    k:integer;
  begin
    result:=true;
    {check corners}
    if (vertices[C,R].V.exists) {top left corent}
    and (vertices[C,R].H.exists)
    and (vertices[c,R+size-1].V.exists) {bottom left corner}
    and (vertices[c,R+size].H.exists)
    and (vertices[C+size,R].V.exists) {top right corner}
    and (vertices[C+size-1,R].H.exists)
    then
    begin
      for k:=1 to size-1 do {now check the in between edges}
      begin
        if (vertices[C,R+k].V.exists) {left edge}
        and (vertices[C+K,R].H.exists) {top edge}
        and (vertices[c+size,R+k].V.exists) {right edge}
        and (vertices[c+K,R+size].H.exists) {bottom edge}
        then  {keep checking}
        else
        begin  {any not exists on an edge = no square}
          result:=false;
          break; {stop the search}
        end;
      end;
    end
    else result:=false; {missing corner stick, stop the search}
  end;

  procedure DrawSquare(c,r,n:integer);
  var
    x,y:integer;
  begin
    with image1.canvas do
    begin
      //(*
      for y:=0 to N-1 do
      for x:=0 to N-1 do
      begin
        (*
        DrawEdge(c+x,r,East); {top of square}
        DrawEdge(c,r+y,South); {left side}
        DrawEdge(c+N,r+y,South); {right side}
        DrawEdge(c+x,r+N,East);  {botton}
        *)

        brush.color:=clwhite;
        rectangle(c*cellsize+2*sp, r*cellsize+2*sp,
                 (c+x+1)*cellsize+2*sp, (r+y+1)*cellsize+2*sp);
        brush.color:=BGColor;
      end;
    end;
  end;

begin {CountBtnClick}
  if (sender = ShowBtn) then
  begin
    if showBtn.caption ='Stop' then
    begin
      showbtn.caption:='Show Squares';
      screen.Cursor:=crDefault;
      exit;
    end
    else
    begin
      showbtn.caption:='Stop';
      screen.cursor:=crHourglass;
    end;
  end;
  Count:=0;
  emptyedges:=0;
  M:=min(nbrwide,nbrhigh);
  //if nbrwide<nbrhigh then M:=nbrwide else m:=nbrhigh;

  saverect:=rect(0,0,image1.Width-1, image1.height-1);

  begin
    b:=TBitmap.create;
    b.width:=Image1.Width;
    b.height:=image1.Height;
  end;

  {Save the start image as an easy way to erase squares highlighting}
  b.canvas.copyrect(saverect, image1.canvas,saverect);

  {highlight squares by columns within rows}
  for r:=0 to M do
  for c:=0 to M do
  with vertices[c,r] do
  begin

    for N:=1 to M do
    if isSquare(c,r,N) then
    begin
      inc(count);
      if (sender = ShowBtn) and (Showbtn.caption='Stop')
      then
      with image1, canvas  do
      begin
        DrawSquare(c,r,N);
        image1.Update;
        Sleep(1500);
        {erase high lighted square by puuting the "before" image back}
        image1.canvas.copyrect(saverect, b.canvas,saverect);
        image1.Update;
      end;
    end;
    application.ProcessMessages;
  end;
  for c:=0 to nbrwide do
  for r:=0 to nbrhigh do
  with vertices[c,r] do
  begin
    if (r<>nbrhigh) and  (not v.exists) then inc(emptyedges);
    if (c<>nbrwide) and (not h.exists) then inc(emptyedges);
  end;

  CountLbl.caption:=format('%d matches removed leaving %d total squares',[emptyedges,count]);
  msg:='';
  if (count=0) and (nbrwide = nbrhigh)  then
  begin
    //winscore:=nbrwide*(nbrwide+1) div 2; {Smallest # of sticks removed to solve}
    winscore:= ceil( nbrwide*(nbrwide+0.5)/2);
    if  (emptyedges=winscore)
    then msg:='Winner with fewest possible removals,  Congrats!!'
    else if emptyedges>winscore then msg:= 'All squares removed but you can do better.'
    else msg:='You''ve located a programming bug, please print the screen and send it to me!';
  end;
  countlbl.Caption:= countlbl.Caption +#13 + msg;
  showbtn.caption:='Show Squares';
  screen.Cursor:=crdefault;

end;



{*********** SaveBtnClick ************}
procedure TForm1.SaveBtnClick(Sender: TObject);
 var
  c,r:integer;
  Ini:TInifile;
  edges:string;
begin
  with Ini do
  begin
    Ini:=tinifile.create(Ininame);
    readsections(SaveDlg.Listbox1.items); {Load the kist of previously saved grids}
    If SaveDlg.showmodal= mrOK then {Go let the user choose or enter name for save}
    begin
      Writeinteger(SaveDlg.GridName, 'GridWide', nbrwide);
      Writeinteger(SaveDlg.GridName, 'GridHigh', nbrhigh);
      for c:=0 to nbrwide do
      for r:=0 to nbrhigh do
      with vertices[c,r] do
      begin
        if h.exists then edges:='H' else edges:='_';
        if v.exists then edges:=edges+'V' else edges:=edges+'_';
        ini.writestring(SaveDlg.GridName, format('%1d%1d',[c,r]),edges);
      end;
    end;
    ini.Free;
  end;
end;


{************* LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  c,r:integer;
  Ini:TInifile;
  edges:string;
  HV:string;
begin
  with Ini do
  begin
    Ini:=tinifile.create(Ininame);
    readsections(LoadDlg.Listbox1.items);
    If LoadDlg.showmodal= mrOK then
    begin
      nbrwide:=ReadInteger(LoadDlg.GridName, 'GridWide', nbrwide);
      nbrhigh:=ReadInteger(LoadDlg.GridName, 'GridHigh', nbrhigh);
      WidthEdt.Text:=inttostr(nbrwide);
      HeightEdt.Text:=inttostr(nbrhigh);
      MakeAlledges(false);
      for c:=0 to nbrwide do
      for r:=0 to nbrhigh do
      with vertices[c,r] do
      begin
        HV:=readstring(LoadDlg.GridName,format('%1d%1d',[c,r]),'__');
        if HV[1]='H' then makeedgefrom(c,r,East,true, TEdge(H));
        if HV[2]='V' then makeedgefrom(c,r,South,true, V);
      end;
      DrawAllEdges;
      CountBtnClick(sender);
    end;
    ini.Free;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.oeis.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

