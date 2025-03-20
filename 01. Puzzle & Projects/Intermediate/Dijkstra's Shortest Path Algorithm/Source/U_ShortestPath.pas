unit U_ShortestPath;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, ShellAPI, UIntList, UTGraphSearch, Spin;

type
  TForm1 = class(TForm)
    GenerateBtn: TButton;
    DijkstraBtn: TButton;
    Memo1: TMemo;
    Image1: TImage;
    StaticText1: TStaticText;
    Verbosebox: TCheckBox;
    Label1: TLabel;
    Startpoint: TSpinEdit;
    Label2: TLabel;
    GoalPoint: TSpinEdit;
    procedure GenerateBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DijkstraBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    //procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    GraphList:TGraphList;
    procedure ShowDetail(s:string);  {procedure called by Dijkstra if "Verbose" box is checked}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** GenerateBtnClick ************}
procedure TForm1.GenerateBtnClick(Sender: TObject);
{make the graph list}
var
  key:string;
  i,j,n:integer;
begin
  graphlist.clear;
  with graphlist do
  begin
    {add 10 nodes}
    for i:=1 to 10 do
    begin
      key:=format('%2.2d',[i]);
      addnode(key) ;
    end;
    finalize;
    {Add edges}
    with image1.canvas, font do
    begin
     style:=[fsbold];
     color:=clred;
     size:=10;
   end;
    {random distances - adjusted to kind of balance random paths}
    n:=random(98)+1; addedge('01','02',n,n); Image1.canvas.textout(108,61,format('%2.2d',[n]));
    n:=random(98)+1;addedge('01','03',n,n); Image1.canvas.textout(182,56,format('%2.2d',[n]));
    n:=random(98)+1;addedge('02','04',n,n); Image1.canvas.textout(62,120,format('%2.2d',[n]));
    n:=random(98)+1;addedge('02','05',n,n); Image1.canvas.textout(116,115,format('%2.2d',[n]));
    n:=random(98)+1;addedge('03','06',n,n); Image1.canvas.textout(175,113,format('%2.2d',[n]));
    n:=random(49)+1;addedge('03','07',n,n); Image1.canvas.textout(242,101,format('%2.2d',[n]));
    n:=random(49)+50;addedge('03','10',n,n); Image1.canvas.textout(229,152,format('%2.2d',[n]));
    n:=random(98)+1;addedge('05','08',n,n); Image1.canvas.textout(85,179,format('%2.2d',[n]));
    n:=random(98)+1;addedge('05','09',n,n); Image1.canvas.textout(122,180,format('%2.2d',[n]));
    n:=random(98)+1;addedge('05','10',n,n); Image1.canvas.textout(168,161,format('%2.2d',[n]));
    n:=random(49)+1;addedge('04','10',n,n); Image1.canvas.textout(75,241,format('%2.2d',[n]));
    n:=random(98)+1;addedge('07','10',n,n); Image1.canvas.textout(254,171,format('%2.2d',[n]));
    n:=random(49)+1;addedge('09','10',n,n); Image1.canvas.textout(172,200,format('%2.2d',[n]));
  end;

  {now display nodes and edges}
  with memo1, lines do
  begin
    clear;
    add('Graph built with '+inttostr(Graphlist.count)
        +' nodes');
    for i:= 0 to Graphlist.count-1 do
    begin
      lines.add(graphlist[i]);
      with graphlist, TNode(objects[i]) do
      for j:=0 to nbradjacents-1 do
        lines.add('   Edge to: '+ strings[adjacents[j].ToNodeIndex]
                +' Distance: '+inttostr(adjacents[j].Weight));
    end;
  end;
end;

{********* FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
   GraphList:=TGraphlist.create;
   randomize;
end;

{********* ShoeDetail **********}
procedure TForm1.showdetail(s:string);
begin
  memo1.lines.add(s);
end;


{************ DijkstraClick ***********}
procedure TForm1.DijkstraBtnClick(Sender: TObject);
{Dijkstra goal search}
var
  path:TIntlist;
  i,j:integer;
  startstr,goalstr:string;
begin
  path:=TIntlist.create;
  path.sorted:=false;

  memo1.Clear;
  startstr:=format('%2.2d',[startPoint.Value]);
  goalstr:= format('%2.2d',[goalPoint.Value]);

  if not verbosebox.checked then graphlist.Dijkstra(startstr,goalstr,path)
  else graphlist.Dijkstra(startstr,goalstr,path, showdetail);
  memo1.lines.add('');
  memo1.lines.add(format('Shortest Path from %d to %d',[StartPoint.Value, GoalPoint.Value]));
  for i:=path.count-2 downto 0 do
  with graphlist do
  begin
     j:=path[i];
     memo1.lines.add('Total distance from start to node: '+ strings[j]+' is ' + inttostr(integer(path.objects[i])));
  end;
  path.free;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

(*
{Generate a graph with specific values - used for debugging}
procedure TForm1.Button1Click(Sender: TObject);
  var
  key:string;
  i,j,n:integer;
begin
  graphlist.clear;
  with graphlist do
  begin
    {add 10 nodes}
    for i:=1 to 10 do
    begin
      key:=format('%2.2d',[i]);
      addnode(key) ;
    end;
    finalize;
    {Add edges}
    with image1.canvas, font do
    begin
     style:=[fsbold];
     color:=clred;
     size:=10;
   end;
    {random distances - adjusted to kind of balance random paths}
    n:=9; addedge('01','02',n,n); Image1.canvas.textout(108,61,format('%2.2d',[n]));
    n:=2; addedge('01','03',n,n); Image1.canvas.textout(182,56,format('%2.2d',[n]));
    n:=50;addedge('02','04',n,n); Image1.canvas.textout(62,120,format('%2.2d',[n]));
    n:=89;addedge('02','05',n,n); Image1.canvas.textout(116,115,format('%2.2d',[n]));
    n:=95;addedge('03','06',n,n); Image1.canvas.textout(175,113,format('%2.2d',[n]));
    n:=14;addedge('03','07',n,n); Image1.canvas.textout(242,101,format('%2.2d',[n]));
    n:=63;addedge('03','10',n,n); Image1.canvas.textout(229,152,format('%2.2d',[n]));
    n:=2;addedge('05','08',n,n); Image1.canvas.textout(85,179,format('%2.2d',[n]));
    n:=54;addedge('05','09', n,n); Image1.canvas.textout(122,180,format('%2.2d',[n]));
    n:=73;addedge('05','10',n,n); Image1.canvas.textout(168,161,format('%2.2d',[n]));
    n:=41;addedge('04','10',n,n); Image1.canvas.textout(75,241,format('%2.2d',[n]));
    n:=43;addedge('07','10',n,n); Image1.canvas.textout(254,171,format('%2.2d',[n]));
    n:=39;addedge('09','10',n,n); Image1.canvas.textout(172,200,format('%2.2d',[n]));
  end;

  {now display nodes and edges}
  with memo1, lines do
  begin
    clear;
    add('Graph built with '+inttostr(Graphlist.count)
        +' nodes');
    for i:= 0 to Graphlist.count-1 do
    begin
      lines.add(graphlist[i]);
      with graphlist, TNode(objects[i]) do
      for j:=0 to nbradjacents-1 do
        lines.add('   Edge to: '+ strings[adjacents[j].ToNodeIndex]
                +' Distance: '+inttostr(adjacents[j].Weight));
    end;
  end;
end;
*)



end.
