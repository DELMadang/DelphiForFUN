unit U_CoinSearc;

{A progam to illustrate the use of depth first and breadth first searches
of a puzzle whose solution space is represented as an adjacency list graph}

{The puzzle: start with 3 dimes and 2 quarters arranges as DQDQD.  Change
 configuration to DDDQQ by sliding DQ or QD pairs left or right to an
 unoccupied space.
}

{The solution space for this puzzle can be represented as a string of D,Q, and E
 characters reachable by making valid moves from the starting
 configuration - I started with 11, but wider could be tried.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, contnrs, ComCtrls, UTGRaphSearch;

type
   (*
  tMethodCall = procedure of object;

  TNode= class(tObject) {A node of the graph}
    adjacents:array of integer;
    nbradjacents:integer;
    index:integer; {where this node occurs in headnodes list}
    constructor create;
  end;

  {The adjacency graph object}
  TGraphList=class(TStringList) {list of head nodes}
   public
    Q:TList;  {list to hold search results}
    maxlen:integer;  {maximum key length}
    finalized:boolean;
    constructor create;
    function AddNode(key:string; node:TNode):boolean;
    function AddEdge(key1,key2:string):boolean;
    procedure finalize;
    procedure MakePathsToDF(nodenbr:integer; {depth first search}
                            goal:String;
                            maxdepth:integer;
                            GoalFound:TMethodcall);
    procedure MakePathsToBF(nodenbr:integer; {breadth first search}
                            goal:String;
                            maxdepth:integer;
                            GoalFound:TMethodcall);
   end;

   *)

  TForm1 = class(TForm)
    MakeNodesBtn: TButton;
    DFSearchBtn: TButton;
    Memo1: TMemo;
    BFSearchBtn: TButton;
    MaxlenUpDown: TUpDown;
    MaxLenEdt: TEdit;
    MaxDepthUD: TUpDown;
    MaxDepthEdt: TEdit;
    Label1: TLabel;
    StopBtn: TButton;
    procedure MakeNodesBtnClick(Sender: TObject);
    procedure DFSearchBtnClick(Sender: TObject);
    procedure BFSearchBtnClick(Sender: TObject);
    procedure MaxlenUpDownClick(Sender: TObject; Button: TUDBtnType);
    procedure FormCreate(Sender: TObject);
    procedure MakeHeadNodes(newMaxLen:integer); {make the head node nodes}
    procedure MakeAdjacents(nodenbr:Integer);
    procedure StopBtnClick(Sender: TObject); {add adjacent node info}
  private
    { Private declarations }
  public
    { Public declarations }
    list:TGraphList; {the solution space list}
    procedure ShowSolution;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses combo;




procedure TForm1.MakeHeadNodes(newmaxlen:integer);
var
  i,j, k:integer;
  key:string;
  valid:boolean;
  temp:TNode;
begin
  with List do
  begin
    if count>0 then for i:= 0 to count-1 do TNode(objects[i]).free;
    clear;
    sorted:=false;
    maxlen:=newmaxlen;
    {Generate all possible valid nodes}
    combos.setup(5,maxlen, combinations);
    while combos.GetNextCombo do {get 5 coin positions}
    with combos do
    begin
      {now generate all combinations of 2 of these 5 positions to hold Q's,
       other 3 will be D's}
      for i:= 1 to 4 do
      for j:= i+1 to 5 do
      begin
        key:=StringOfChar('E',maxlen);
        for k:= 1 to 5 do key[selected[k]]:='D';
        key[selected[i]]:='Q';
        key[selected[j]]:='Q';
        valid:=false;
        {if there is no valid DQ or QD pair then this can't be
         a valid configuration}
        for k:=1 to maxlen-1 do
        begin
          if ((key[K]='Q') and (key[K+1]='D'))
             or ((key[K]='D') and (key[K+1]='Q'))
          then
          begin
            valid:=true;
            break;
          end;
        end;
        if valid then
        begin
          {temp:=TNode.create;}
          addnode(key);
          {addobject(key,temp);}
        end;
      end;
    end;
    finalize;{sort;}
  end;
end;


procedure TForm1.makeadjacents(nodenbr:integer);
{after the headnodes are built, this routine
 complete adjacency array}
{2 nodes are adjacent of we can get from one to the other by a single
 move.  In this version, we'll generate all adjacents from a given node.
 Alternatively, we could pass all nodes to a test that returns true/false
 reflecting adjacency
}

var
  key,temp:string;
  i, j, K:integer;
  node:TNode;


begin
  node:=TNode(list.objects[nodenbr]);
  key:=list.strings[nodenbr];
  {make sure that it has at least one DQ or QD pair}
  for i:= 1 to length(key)-1 do
  begin
    if  ((key[i]='D') and (key[i+1]='Q')) or
        ((key[i]='Q') and (key[i+1]='D'))
    then
    {try all moves}
    for j:= 1  to length(key) - 1 do
    if (key[j]='E') and (key[J+1]='E') then
    {foun a place to receive coins, make the new config}
    begin
      temp:=key;
      temp[j]:=key[i];
      temp[j+1]:=key[i+1];
      temp[i]:='E';
      temp[i+1]:='E';
      k:=-1;
      {if it's valid, then add it to adjacency list}
      if list.find(temp,k) then
      begin
        List.addedge(key,temp);
      end
      else
      begin
         showmessage('Error, valid key '+temp+' not found on headnodes');
         exit;
      end;
    end;
  end;
end;


procedure TForm1.MakeNodesBtnClick(Sender: TObject);
var
  i:integer;
  adj,totadjacents,maxadjacents,minadjacents:integer;
begin
  screen.cursor:=crHourGlass;
  MakeHeadNodes(maxlenUpDown.position);
  memo1.clear;
  memo1.lines.add(inttostr(list.count)+' nodes generated in adjacency list');

  {fill in all the adjacents}
  totadjacents:=0;
  maxadjacents:=0;
  minadjacents:=high(integer);
  for i:=0 to list.count-1 do
  begin
    makeadjacents(i);
    adj:=TNode(list.objects[i]).nbradjacents;
    totadjacents:=totadjacents+adj;
    if adj>maxadjacents then maxadjacents:=adj;
    if adj<minadjacents then minadjacents:=adj;
  end;
  memo1.lines.add('Average edges per node:'+format('%f6',[totadjacents/list.count]));
  memo1.lines.add('Maximum edges from any node:'+inttostr(maxadjacents));
  memo1.lines.add('Minimum edges from any node:'+inttostr(minadjacents));
  screen.cursor:=crDefault;
end;

procedure TForm1.showsolution;
var
  i:integer;
begin
  memo1.lines.add('----------------');
  with list do
  for i:= 0 to Q.count-1 do
  memo1.lines.add(list[TNode(Q[i]).index]);
end;


procedure TForm1.DFSearchBtnClick(Sender: TObject);
var
  index:integer;
  temp:TNode;
  i,j,k:integer;
  s,start:string;
begin

  If list.count=0 then
  begin
    showmessage('Generate graph nodes first');
    exit;
  end;
  screen.cursor:=crHourGlass;
  stopbtn.visible:=true;
  stopbtn.bringtofront;
  memo1.clear;
  list.stop:=false;
  {generate all starting positions}
  for k:=0 to maxlenUpDown.Position-5 do
  begin
    start:='';
    start:=Stringofchar('E',k);
    start:=start+'DQDQD';
    for i:=length(start)+1 to maxlenupDown.position
    do start:=start+'E';
    memo1.lines.add('');
    memo1.lines.add('Checking Solutions for '+start);
    
    for i:=0 to maxlenUpDown.Position-5 do
    begin
      {make a goal position key}
      s:='';
      s:=Stringofchar('E',i);
      s:=s+'QQDDD';
      for j := length(s)+1 to maxlenUpDOwn.Position do s:=s+'E';
      {search for paths to goal}
      if not list.stop then
      list.MakepathsToDF(start,s,maxdepthUD.position,Showsolution);

      {alternate goal}
      s:='';
      s:=stringofChar('E',i);
      s:=s+'DDDQQ';
      for j := length(s)+1 to maxlenUpDown.position do s:=s+'E';
      if not list.stop then
      list.MakepathsToDF(start,s,MaxDepthUD.Position,ShowSolution);
    end;
  end;
  screen.cursor:=crDefault;
  stopbtn.visible:=false;
  stopbtn.sendtoback;
end;

{BreadthFirst search}
procedure TForm1.BFSearchBtnClick(Sender: TObject);
var
  index:integer;
  temp:TNode;
  i,j,k:integer;
  s,start:string;
begin
   If list.count=0 then
  begin
    showmessage('Generate graph nodes first');
    exit;
  end;
  screen.cursor:=crHourGlass;
  stopbtn.visible:=true;
  stopbtn.bringtofront;
  memo1.clear;
  list.stop:=false;
   {generate all starting positions}
  for k:=0 to maxlenUpDown.Position-5 do
  begin
    start:='';
    start:=Stringofchar('E',k);
    start:=start+'DQDQD';
    for i:=length(start)+1 to maxlenupDown.position
    do start:=start+'E';
   {find it}
    memo1.lines.add('');
    memo1.lines.add('Checking Solutions for '+start);
    {search for solutions from  node temp}

    for i:=0 to maxlenUpDown.position-5 do
    begin
      s:='';
      s:=Stringofchar('E',i);
      s:=s+'QQDDD';
      for j := length(s)+1 to maxlenUpDown.position do s:=s+'E';
      if not list.stop then
        list.MakepathsToBF(start,s,MaxDepthUD.position,Showsolution);
      s:='';
      s:=stringofChar('E',i);
      s:=s+'DDDQQ';
      for j := length(s)+1 to maxlenUpDown.position do s:=s+'E';
      if not list.stop then
      list.MakepathsToBF(start,s,MaxDepthUD.position,ShowSolution);
    end;
  end;
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
  stopbtn.sendtoback;
end;

procedure TForm1.MaxlenUpDownClick(Sender: TObject; Button: TUDBtnType);
begin
  if list.count>0 then
  begin
    showmessage('Graph was cleared');
    list.clear;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  List:=TGraphList.create;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
  list.stop:=true;
  stopbtn.visible:=false;
  stopbtn.sendtoback;
end;

end.
