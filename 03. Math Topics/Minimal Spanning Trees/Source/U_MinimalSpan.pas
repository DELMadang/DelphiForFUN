unit U_MinimalSpan;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A program which allows the user to interactively define the node and edges of a graph
and then finds the Minimalo Spanning Tree using Kruska's algorithm.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ShellAPI,  StdCtrls, Menus,  UGeometry, DFFUtils, UTGraphSearch;

type

  TForm1 = class(TForm)
    Image1: TImage;
    VertexMenu: TPopupMenu;
    EdgeMenu: TPopupMenu;
    Changeweight1: TMenuItem;
    Delete1: TMenuItem;
    EdgeStart: TMenuItem;    DeleteVertex1: TMenuItem;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    KruskalsBtn: TButton;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Movevertex1: TMenuItem;
    Memo2: TMemo;
    PrimsBtn: TButton;
    ClearBtn: TButton;
    ResetBtn: TButton;
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DeleteVertex1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Changeweight1Click(Sender: TObject);
    procedure EdgeStartClick(Sender: TObject);

    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Load1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure KruskalsBtnClick(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Movevertex1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PrimsBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
  public
    GraphList:TGraphlist;
    nextVertexNbr:char;
    StartVertex:TNode;   {start mnnode for edge creation }
    vertex1:TNode;  {last node clicked}

    SelectedEdge:TEdge;
    mouseuppoint:TPoint;

    lastdragpoint:TPoint;  {last node drag image position while making an edge}
    ScreenMouseUpPoint:TPoint; {use to reposition mouse when MoveVertex is clicked}
    filename:string;
    MakingEdge:boolean;
    MovingVertex:boolean;
    modified:boolean;  {graph has been modified}
    highlights:boolean; {Image may have highlighted lines, use to tell when to reset lines}
    function Onvertex(x,y:integer; var vertex:TNode):boolean;
    function Onedge(x,y:integer; var edge:TEdge):boolean;
    function makenewvertex(x,y:integer):string;
    procedure makeedgetohere;
    procedure drawimage;
    function checkmodified:boolean; {save if modified and user says OK,
                                     return false if user says cancel}
    procedure Setfilename(const newname:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var nodesize:integer=5;


function TForm1.Onvertex(x,y:integer; var vertex:TNode):boolean;
var
  i:integer;
  v:TNode;
begin
  result:=false;
  with graphlist do
  for i:=0 to count-1 do
  begin
    v:=TNode(objects[i]);
    if (v.x-nodesize<x) and  (x<v.x+nodesize)
       and (v.y-nodesize<y) and  (y<v.y+nodesize)
    then
    begin
      vertex:=v;
      result:=true;
      break;
    end;
  end;
end;

{***************** OnEdge ****************}
function TForm1.Onedge(x,y:integer; var Edge:TEdge):boolean;
begin
  if graphlist.closetoedge(x,y,10, Edge) {click within 10 pixels of an edge?}
  then result:=true
  else result:=false;
end;

{************** MakeNewVertex *************}
function TForm1.makeNewVertex(x,y:Integer):string;
var index:integer;
begin
  if graphlist.addnode(nextvertexnbr,x,y) then
  begin
    graphlist.find(nextvertexnbr,index);
    nextvertexnbr:=succ(nextvertexnbr);
    drawimage;
    modified:=true;
  end;
end;


{***************** Image1MouseUp **************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
begin
  mouseuppoint:=point(x,y);
  p:=image1.clienttoscreen(point(x,y));
  ScreenMouseUpPoint:=p;  {save it in case we need it for MoveVertex}
  if highlights then
  begin
    graphlist.resetallhighlight;
    drawimage;
    highlights:=false;
  end;
  if movingvertex then
  begin
    graphlist.moveNode(graphlist[vertex1.index],point(x,y));
    drawimage;
    movingvertex:=false;
    image1.cursor:=crdefault;
    modified:=true;
  end
  else if onvertex(x,y,vertex1) then
  begin
    if makingedge then
    begin
      if (vertex1<>startvertex) then
      begin
        makeedgetohere;
      end;
      makingedge:=false;
    end
    else vertexmenu.popup(p.x,p.y);
  end
  else
  if onEdge(x,y, selectededge)
  then edgemenu.popup(p.x,p.y)
  else makeNewVertex(x,y);
end;

{************* CheckModified ***********}
function TForm1.checkmodified: boolean;
{Check if graph has been modified and give user a chance to save it if so}
var
  mr:integer;
begin
  result:=true;
  if modified then
  begin
    mr:=messagedlg('Save current graph first?',mtconfirmation,[mbyes,mbno,mbcancel],0);
    if mr=mrcancel then result:=false
    else modified:=false;
    if mr=mryes then saveas1click(self);
  end;
end;


{*************** ResetBtnClick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  if checkmodified then
  begin
    nextvertexnbr:='A';
    if assigned(Graphlist) then Graphlist.free;
    Graphlist:=TGraphlist.create;
    drawimage;
    setfileName('');
    makingedge:=false;
    movingVertex:=false;
    image1.cursor:=crdefault;
    statictext2.caption:='Current graph file: None';
  end;
end;

{*************** ClearBtnClick ************}
procedure TForm1.ClearBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  with graphlist do
  for i:= 0 to graphlist.count-1 do
  with TNode(graphlist.objects[i]) do
  for j:=0 to nbradjacents-1 do adjacents[j].highlight:=false;
  drawimage;
end;

{*************** DrawImage ***********}
procedure TForm1.drawimage;
var
  i,j:integer;
  temp,temp2:TNode;
  L,L2:TLine;
begin
  with image1, canvas, graphlist  do
  begin
    If not makingedge then fillrect(clientrect);
    if count>0 then
    begin
      pen.color:=clblack;
      for i:=0 to count-1 do  {draw all edges first and then draw vertices over
                               the intersections}
      begin
        temp:=TNode(objects[i]);  {Get a vertex}
        with temp do
        begin
          L.p1.x:=temp.x; L.p1.y:=temp.y;
          if nbradjacents>0 then  {draw the edges}
          for j:=0 to nbradjacents-1 do
          begin
            if adjacents[j].highlight then pen.width:=3 else pen.width:=1;
            temp2:=TNode(objects[adjacents[j].tonodeIndex]);
            moveto(temp.x,temp.y);
            lineto(temp2.x,temp2.y);
            {decide whyere to draw the weight value}
            L.p2.x:=temp2.x; L.p2.y:=temp2.y;
            L2:=AngledLineFromLine(L,
                                   point((L.p1.x+L.P2.x) div 2,(L.p1.y+L.P2.y) div 2),
                                   8, Pi/2);
            with L2.p2 do textout(x-4,y-7,inttostr(adjacents[j].weight));
          end;
        end;
      end;
      pen.width:=1;  {reset pen width}
      for i :=0 to count-1 do  {now draw the vertices}
      begin
        temp:=TNode(objects[i]); {get vertex location}
        with temp do
        begin
          ellipse(x-nodesize,y-nodesize,x+nodesize,y+nodesize);
          textout(x-4,y-7,strings[i]); {add node name}
        end;
      end;
    end;
  end;
end;

{**************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
  s:string;
begin
  nodesize:=10;
  resetbtnclick(self);
  s:=extractfilepath(application.exename);
  opendialog1.initialdir:=s;
  savedialog1.initialdir:=s;
  if fileexists(s+'Default.gra') then
  with graphlist do
  begin
    setfilename(s+'Default.gra');
    loadgraph(filename);
    for i:= 0 to count-1 do
    if succ(strings[i][1])>nextvertexnbr then nextvertexnbr:=succ(strings[i][1]);
  end
  else filename:='';
  drawimage;
  modified:=false;
  setMemoMargins(memo1,10,10,10,10);
  reformatMemo(memo1);
end;

{************* DeleteVertex **********}
procedure TForm1.DeleteVertex1Click(Sender: TObject);
begin
  {delete a vertex and all edges connected to it}
  with graphlist do deletenode(strings[vertex1.index]);
  drawimage;
  modified:=true;
end;

{************* Delete1Click **********}
procedure TForm1.Delete1Click(Sender: TObject);
{Delete an edge}
begin
  {delete this edge}
  graphlist.deleteedge(selectededge);
  drawimage;
  modified:=true;
end;

{************** ChangeWeight ***********}
procedure TForm1.Changeweight1Click(Sender: TObject);
var
  s:string;
  i:integer;
begin
  with graphlist, selectededge do
  begin
    s:=InputBox('Edge weight', 'enter new weight for edge from '
                              +strings[fromnodeindex] +' to '
                              + strings[tonodeindex], inttostr(weight));
   weight:=strtoint(s);
    with TNode(objects[fromnodeIndex]) do
    begin
      for i:=0 to nbradjacents-1 do
      with adjacents[i] do
      begin
        if tonodeindex=selectededge.tonodeindex then
        begin
          weight:=selectededge.weight;
          break;
        end;
      end;
    end;
  end;
  drawimage;
  modified:=true;
end;


{************* EdgeStartClick **********}
procedure TForm1.EdgeStartClick(Sender: TObject);
begin
  startvertex:=vertex1;
  makingedge:=true;
  lastdragpoint:=point(-1,-1);
end;

{*********** MakeEdgeToHere **********}
procedure TForm1.makeedgetohere;
begin
  if startvertex<>vertex1
  then
  begin
    graphlist.addedge(startvertex,vertex1,5);
    makingedge:=false;
    drawimage;
    modified:=true;
  end;
end;

{************ Image1MouseMove ************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if makingedge then
  with image1.canvas do
  begin
    if lastdragpoint.x>=0 then
    with lastdragpoint do  {erase the previous drag image}
    begin
      pen.color:=clwhite;
      ellipse(x-nodesize,y-nodesize,x+nodesize,y+nodesize);
    end;
    pen.color:=cllime;
    if (abs(x-startvertex.x)>2*nodesize) or (abs(y-startvertex.y)>2*nodesize)
    then ellipse(x-nodesize,y-nodesize,x+nodesize,y+nodesize);

    drawimage;
  end
  else if movingVertex then
  begin
    graphlist.movenode(graphlist[vertex1.index],point(x,y));
    drawimage;
  end;
  lastdragpoint:=point(x,y);
end;

{************* Load1Click ***********}
procedure TForm1.Load1Click(Sender: TObject);
{Load a graph from a stream}
var i:integer;
begin
  if checkmodified then
  If opendialog1.execute then
  with graphlist do
  begin
    nextvertexnbr:='A';
    loadgraph(opendialog1.filename);
    {set next available vertex nbr}
    for i:= 0 to count-1 do
    if succ(strings[i][1])>nextvertexnbr then nextvertexnbr:=succ(strings[i][1]);
    setfilename(opendialog1.filename);
    drawimage;
    modified:=false;
  end;
end;

{*************** SaveAs1click **********}
procedure TForm1.SaveAs1Click(Sender: TObject);
{Save a graph to a file stream}
begin
  if saveDialog1.execute then
  begin
    graphlist.savegraph(savedialog1.filename);
    setfilename(savedialog1.filename);
    modified:=false;
  end;
end;

{*************** Save1Click **********}
procedure TForm1.Save1Click(Sender: TObject);
{save a graph using current file name or ask user if no current name}
begin
  if filename<>'' then
  begin
    graphlist.savegraph(filename);
    modified:=false;
  end
  else saveas1click(sender);
end;

{*********** SetFileName **********}
procedure TForm1.SetFileName(const newname:string);
begin
  filename:=newname;
  if newname<>'' then statictext2.caption:='Current graph file: '+filename
  else statictext2.caption:='No graph file open';
end;

type
  Tspantree=record
    dad:integer;
    v1,v2:integer;
  end;

{************* KruskalsBtnClick ***********}
procedure TForm1.KruskalsBtnClick(Sender: TObject);
{Find the minimal span tree by sorting the edges by increasing weight and node
numbers. We then process the edges connecting them into "trees" as we go.
Initially the are as many trees as there are nodes.  A linked list of indices of
"parent" nodes is maintgained as we go, so for each edge, we can chase the links
back to the root of that tree.  At each  step, if the two nodes for an edge
do not belong to the same tree, we join the two trees together
and increment the count of nodes connected.  When all the nodes have been connected
this way, we can stop because we have found the set of nodes with smallest weights which
form a single tree.}

var
  parent:array of integer {TSpantree};
  nbrnodes:integer;
  list:TStringlist;
  totweight:integer;
  connected:array of boolean;
  i,j,k:integer;
  connectedcount:integer;
  newweight:integer;
  w:string;
  n1,n2:integer;
  weight:integer;

  {SAMETREE COMBINES TREES}
  function sametree(n1,n2:integer):boolean;
  {is there a path from n1 to n2?}
  {Every node belongs to a tree , even if it consists entirely of that node.
   This function maintains a linked list of indices of preceding nodes in each tree
   and scans back through the tree to the root node for each of the
   input nodes, n1 and n2, If the roots are the same, return true.  If not,
   the make node1 the parent  ("dad") of node2 so the two trees are now joined
   into one}
  var
    i,j:integer;
  begin
    i:=n1;
    while parent[i]>=0 do  i:=parent[i];
    j:=n2;
    while parent[j]>=0 do j:=parent[j];
    if i<>j then parent[j]:=i;  {separate tress,  combine them}
    result:= i=j;
  end;

  procedure swap(var a,b:integer);
  var t:integer;
  begin
    t:=a;
    a:=b;
    b:=t;
  end;


begin
  graphlist.resetallhighlight;
  highlights:=false;
  memo2.clear;
  list:=tstringlist.Create;
  totweight:=0;
  nbrnodes:=GRAPHLIST.COUNT;
  setlength(connected,nbrnodes);
  for k:=0 to nbrnodes-1 do connected[k]:=false;
  //memo2.lines.add(inttostr(nbrnodes)+' nodes');
  for i:=0 to graphlist.count-1 do
  with graphlist, Tnode(objects[i]) do
  begin
    if nbradjacents >0 then
    for j:=0 to nbradjacents-1 do
    with adjacents[j] do
    begin
      {MAKE LIST OF EDGE INFO BY WEIGHT,NODE1,NODE2}
      n1:=fromnodeindex;
      n2:=tonodeindex;
      if n2<n1 then swap(n1,n2);
      list.add(format('%3d%2d%2d',[weight,n1,n2]));
      inc(totweight,weight);
    end;
  end;
  list.sort;
  with memo2.lines do
  begin
    add(inttostr(Graphlist.count) +' vertices');
    add(inttostr(list.count)+' edges');
    add('Total weight: '+inttostr(totweight));
    add('-------------------');
    add('Minimal Spanning tree (Kruskal''s Algorithm):');
  end;
  connectedcount:=1;
  newweight:=0;
  setlength(parent,nbrnodes);
  for i:=0 to nbrnodes-1 do parent[i]{.dad}:=-1;
  for i:= 0 to list.count-1 do
  begin
    w:=list[i];
    n1:=strtoint(copy(w,4,2));
    n2:=strtoint(copy(w,6,2));
    if (not sametree(n1,n2))   {if they weren't in the same tree, function sametree
                                combined them and returned false}
    then
    begin   {accumulate the sum of weight for the minimal span tree, highlight the
             edge for the graphics, and increment the count of nodes connected}
      weight:=strtoint(copy(w,1,3));
      inc(newweight,weight);
      with graphlist do
      begin
        memo2.lines.add(format('(Connect %2s to %2s, Weight %d)',[strings[n1],strings[n2],weight]));
        SetHighlight(strings[n1],strings[n2],true);
        drawimage;
        image1.update;
        sleep(1000);
      end;
      inc(connectedcount);
    end;
    if connectedcount>=nbrnodes then break;
  end;
  if connectedcount<nbrnodes-1 then {not connected}
  memo2.lines.add('Graph is not connected, no spanning tree exists')
  else
  with memo2.lines do
  begin

    add('      Edges: '+inttostr(connectedcount-1));
    add('      Weight: '+inttostr(newweight));
  end;
  drawimage;
  highlights:=true;
  list.free;
end;

{********** MoveVertex  *******}
procedure TForm1.MoveVertex1Click(Sender: TObject);
begin
  {Move mouse back to the vertex}
  mouse.CursorPos:=ScreenMouseUpPoint;
  MovingVertex:=true;
  image1.cursor:=crhandpoint;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************* FormCloseQuery **********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
{Let user save a changed graph first}
begin
  if checkmodified then canclose:=true else canclose:=false;
end;


{************** PrimsbtnClick *************}
procedure TForm1.PrimsBtnClick(Sender: TObject);
{Find minimal spanniong tree using Prim's Algorithm}
{starting at any node, add nodes to the tree by finding a node
 not already in the tree which is connected to a node in the tree and
 has the smallest weight value of all such nodes}

 procedure gettotweight(var ecount,totweight:integer);
 var i,j:integer;
 begin
   ecount:=0;
   totweight:=0;
   for i:=0 to graphlist.count-1 do
   with TNode(graphlist.objects[i]) do
   begin
     for j:=0 to nbradjacents-1 do
     begin
       inc(ecount);
       inc(totweight,adjacents[j].weight);
     end;
   end;
 end;

var
  i,j,ix,n:integer;
  list:TStringlist;
  smallestweight:integer;
  nearestnode, treenode:integer;
  adjlistnode, adjlistindex:integer;
  ecount,totweight:integer;
begin
  graphlist.resetallhighlight;
  highlights:=false;
  memo2.clear;
  gettotweight(ecount,totweight);
  with memo2.lines do
  begin
    add(inttostr(Graphlist.count) +' vertices');
    add(inttostr(eCount)+' edges');
    add('Total weight: '+inttostr(Totweight));
    add('-------------------');
    add('Minimal Spanning tree (Prim''s Algorithm):');
  end;
  list:=tstringlist.Create;   {list to to keep track of which nodes are in the tree}
  list.sorted:=true;
  list.addobject(graphlist[0], graphlist.objects[0]);
  ecount:=0;
  totweight:=0;
  while list.count<graphlist.count do
  begin
    smallestweight:=maxint;
    nearestnode:=-1;
    {find the nearest edge(based of weight values), not already in the tree}
    for i:=0 to graphlist.count-1 do {for each node}
    with TNode(graphlist.Objects[i]) do
    begin
      for j:=0 to nbradjacents-1 do {for each adjacent node}
      with adjacents[j] do
      begin
        if (weight<smallestweight) then {this could be a nearest node edge}
        begin
          {it is a nearest candidate if fromnode is in the tree and tonode is not}
          if (list.find(graphlist[fromnodeindex],ix)) and (not list.Find(graphlist[tonodeindex],ix)) then
          begin
            {keep track of the fields we'll need if this turns out to be the nearest}
            smallestweight:=weight;
            nearestnode:=tonodeindex;
            treenode:=fromnodeindex;
            adjlistnode:=i;  {save i & j, the location of the edge so we can highlight it later}
            adjlistindex:=j;
          end
          else
          {or if tonode is already in the tree and from node is not}
          if (list.find(graphlist[tonodeindex],ix)) and (not list.Find(graphlist[fromnodeindex],ix)) then
          begin
            {keep track of the fields we'll need if this turns out to be the nearest}
            smallestweight:=weight;
            nearestnode:=fromnodeindex;
            treenode:=tonodeindex;
            adjlistnode:=i; {save i & j, the location of the edge so we can highlight it later}
            adjlistindex:=j;
          end;
        end;
      end;
    end;
    if nearestnode>=0 then {we have found the nearest node}
    begin {add that node to the tree}
      list.addobject(graphlist[nearestnode], graphlist.objects[0]);
      TNode(graphlist.objects[adjlistnode]).adjacents[adjlistindex].highlight:=true;
      with graphlist do
      begin
        memo2.lines.add(format('Connect %s to %s, Weight %d',
                       [strings[treenode], strings[nearestnode],smallestweight]));
        inc(ecount);
        inc(totweight,smallestweight);
        drawimage;
        image1.update;
        sleep(1000);
      end;
    end
    else
    begin
      memo2.lines.add('Graph is not connected, no spanning tree exists');
      break;
    end;
  end;
    with memo2.lines do
  begin

    add('      Edges: '+inttostr(ecount));
    add('      Weight: '+inttostr(totweight));
  end;
  drawimage;
  highlights:=true;
  list.free;
end;




end.
