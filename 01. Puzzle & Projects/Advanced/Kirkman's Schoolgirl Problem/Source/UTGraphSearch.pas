unit UTGraphSearch;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {An Adjacency list Graph Object }


interface
  uses forms, classes, dialogs, sysutils, windows, contnrs;
 type
  tMethodCall = procedure of object;
  tFuncCall = function(const s:string; list:pointer):boolean;


  TGroup= class(tObject) {A node of the graph}
    nbradjacents:integer;
    index:integer; {where this node occurs in headnodes list}
    g:string;  {Group value}
    adjacents:array of integer;
    constructor create;
  end;


  {The adjacency graph object}
  TGraphList=class(TStringList) {list of head nodes}
   public
    QG:TObjectlist;  {lists to hold search results (groups and blocks)}
    finalized:boolean; {true=nodes have been sorted and ready for adding edges}
    stop:boolean;   {stop flag checked during searching}
    nodesSearched:int64;
    visited:array of boolean;
    BackTo20:boolean;

    constructor create;
    destructor destroy; override;
    procedure clear;   override;
    function  AddNode(key:string):boolean;
    function  DeleteNode(key:string):boolean;
    function  AddEdge(key1,key2:string; bothways:boolean):boolean;
    procedure finalize;
    procedure MakePathsToDF(GoalFound:TMethodcall); {depth first search}
    function  validgrp(const g:string):boolean;
   end;

   var
     pairs:array['A'..'O','A'..'O'] of boolean;

implementation

Uses combo, U_Kirkman1;

{******* UpdatePairs *********}

procedure  updatepairs(const g:string);
begin
  pairs[g[1],g[2]]:=true;
  pairs[g[1],g[3]]:=true;
  pairs[g[2],g[3]]:=true;
end;

{****** UndoPairs *********}
procedure undopairs(const g:string);
begin
  pairs[g[1],g[2]]:=false;
  pairs[g[1],g[3]]:=false;
  pairs[g[2],g[3]]:=false;
end;

{********** TGraphList.ValidGrp ***********}
function TGraphList.validgrp(const g:string):boolean;
var
    i,j,k:integer;
    g2:string;
     begin
       if pairs[g[1],g[2]] or pairs[g[1],g[3]] or pairs[g[2],g[3]]
       then result:=false
       else result:=true;
       if result then
       begin
         for i:=5*(QG.count div 5) to QG.count-1 do {make sure no repeated letters in current block}
         begin
           g2:=TGroup(QG[i]).g;
           for j:=1 to 3 do for k:=1 to 3 do if g[j]=g2[k] then
           begin
             result:=false;
             break;
           end;
           if not result then break;
         end;
       end;
     end;


{************ TGroup.Create *********}
constructor TGroup.create;
begin
  inherited create;
  setlength(adjacents,5); {we'll start with room for 5, then add 5 at a time}
  nbradjacents:=0;
  index:=0;{this serves as a link back to key info, could use key field instead}
  g:='   ';
end;

{************* TGraphlist.create *****}
constructor TGraphList.create;
begin
  inherited;
  QG:=TObjectlist.create;  QG.OwnsObjects:=false;
  finalized:=false;
end;

{*********** TGraphlist.destroy ******}
destructor TGraphList.destroy;
var
  i:integer;
begin
  {free all nodes}
  for i:= 0 to count-1 do objects[i].free;
  QG.free;
  inherited;
end;

{********** TGraphlist.clear *********}
procedure TGraphList.clear;
vaR I:INTEGER;
begin
  for i:=0 to count-1 do
  begin
    TGroup(objects[i]).free;
    delete(i);
  end;
  finalized:=false;
  inherited;
end;

{**************** TGraphList.Addnode **********}
function TGraphList.AddNode(key:string):boolean;
{add a new node}
var
  node:TGroup;
begin
  if not finalized then
  begin
    node:=TGroup.create;
    addobject(key,node);
    result:=true;
  end
  else result:=false;
end;

{************** TGraphList.DeleteNode ********}
function TGraphList.DeleteNode(key:string):boolean;
{add a new node}
var  i:integer;
begin
  if not finalized then
  begin
    i:=indexof(key);
    if i>=0 then
    begin
      objects[i].Free;
      delete(i);
      result:=true;
    end
    else result:=false;
  end
  else result:=false;
end;

{*************** TGraphList.AddEdge ***********}
function TGraphList.AddEdge(key1,key2:string; bothways:boolean):boolean;
{add an edge to a node}
var
  k1,k2:integer;
  j:integer;
  found:boolean;
  node1,node2:TGroup;
begin
  if not finalized then
  begin
    showmessage('Node must be added and list finalized before edges are added');
    result:=false;
    exit;
  end;
  result:=true;
  If find(key1,k1) and find(key2,k2)
  then
  begin
    node1:=TGroup(objects[k1]);
    with node1 do
    begin
      found:=false;
      for j:=0 to nbradjacents-1 do
      if adjacents[j]=k2 then
      begin
        found:=true;
        break;
      end;
      if not found then
      begin
        inc(nbradjacents);
        if nbradjacents>length(adjacents)
        then setlength(adjacents,length(adjacents)+5);
        adjacents[nbradjacents-1]:=K2;
      end;
    end;
    if bothways then
    begin
      node2:=TGroup(objects[k2]);
      with node2 do
      begin
        found:=false;
        for j:=0 to nbradjacents-1 do
        if adjacents[j]=k1 then
        begin
          found:=true;
          break;
        end;
        if not found then
        begin
          inc(nbradjacents);
          if nbradjacents>length(adjacents)
          then setlength(adjacents,length(adjacents)+5);
          adjacents[nbradjacents-1]:=K1;
        end;
      end;
    end; {bothways}
  end;
end;

{*********** TGraphList.finalize **********}
procedure TGraphlist.finalize;
{sort nodes and fill in index values}
var
  i:integer;
begin
  sort;
  for i:= 0 to count-1 do
  with TGroup(objects[i]) do
  begin
    index:=i;
    g:=strings[i];
  end;
  finalized:=true;
end;

{**************** TGraphList.MakepathstoDF ****************}
procedure TGraphList.MakePathsToDF(GoalFound:TMethodCall);
{depth first search for goal}
var
  i,j:integer;
  nodenbr:integer;
  ch1,ch2:char;
  g:string;

     function NoOverlap(s1,s2:string):boolean;
     var
       i,j:integer;
     begin
       result:=true;
       if s1>s2 then result:=false
       else
       for i:=1 to length(s1)-1 do for j:=1 to length(s2) do
       if s1[i]=s2[j] then
       begin
         result:=false;
         break;
       end;
     end;



 procedure dfs(const v:integer); {recursive depth first search}
 var
   temp:TGroup;
   i:integer;
   g:string;
 begin
   If stop then exit;  {stop flag was set}
   inc(nodesSearched);
   temp:=TGroup(objects[v]);  {get the node}
   QG.add(temp);
   updatepairs(strings[temp.index]);   {add it to the queue}
   visited[temp.index]:=true;
   if  (QG.count=30)then  {solved!}
   begin
     GoalFound;
     {let's back up 2 blocks to continue - (there is no way to rearrange the
      final 2 blocks to get a new solution)}
      BackTo20 :=true;
      visited[temp.index]:=false; {unvisit the node}
      undopairs(temp.g);
      QG.delete(QG.count-1);    {delete temp}
      exit;
   end
   else
   begin  {not at max depth}
     if  (QG.count mod 5 =0) then {start of block, must start with "A"}
     begin
       {get a new starting node}
       if qg.count>0 then temp:= TGroup(QG[QG.count-1]);
       for i:= 0 to count-1 do
       begin
         g:=strings[i];
         if g[1]='A' then
         begin
            if (not visited[i]) and validgrp(g) then
            begin
              dfs(I); {recurse to get second group}
              if stop then exit;
              break;
            end;
         end
         else break; {we ran  out of "Axx"s to try as first group in a block}
       end;
     end
     else
     begin {not start of a block}
       temp:= TGroup(QG[QG.count-1]);
       with temp do      {iterate through adjacents recursively}
       begin
         for i:= 0 to nbradjacents-1 do
         begin
           if stop then exit;
           if (not visited[adjacents[i]]) and validgrp(strings[adjacents[i]])
           then dfs(adjacents[i]); {recurse with next potential node}
           if BackTo20
           then if QG.count>20 then break
                else  BackTo20:=false;
         end;
       end;
     end;
   end;
   {if stop then exit;}
   if QG.count>1 then
   begin
     visited[temp.index]:=false; {unvisit the node}
     undopairs(temp.g);
     QG.delete(QG.count-1);    {delete temp}
   end;
   if nodessearched mod 16384 = 0 then
   begin
     form1.label1.caption:=format('Nodes searched  %10.0n',[nodessearched+0.0]);
     application.processmessages;
   end;
 end;

begin {MakePathsToDF}
  {initialize pairs array};
  for ch1:='A' to 'O' do for ch2:='A' to 'O' do pairs[ch1,ch2]:=false;
  {make all groups}
  combos.setup(3,15,combinations);
  while combos.getnext do
  with combos do
  begin
    g:='   ';
    for i:=1 to 3 do g[i]:=char(ord('A')-1+selected[i]);
    addnode(g);
  end;
  {remove the first block and 1st group of 2nd block as valid groups}
  for i:=0 to 4 do
  begin
    g:='   ';
    for j:=0 to 2 do g[j+1]:=char(ord('A')+i*3+j);
    deletenode(g);
    updatepairs(g);
  end;

  {create adjacencies}
  finalize;
  for i:=0 to count-2 do
  begin
    for j:=i+1 to count-1 do
    begin
      if noOverlap(strings[i],strings[j]) then addedge(strings[i],strings[j],false);
    end;
  end;
  {if not finalized then exit;  }
  setlength(visited,0);   {reset 'visited' array}
  setlength(visited,count);
  QG.clear;


  {shortcut cheat - mark BEH &  BEI as visited - saves several million node searches}
  find('BEH',nodenbr);
  visited[nodenbr]:=true;   {eliminate BEJ}
  visited[nodenbr+1]:=true; {eliminate BEI}


  find('ADG', nodenbr);
  stop:=false;
  nodessearched:=0;
  BackTo20:=false;
  dfs(nodenbr);  {start recursive  search}
end;

end.
