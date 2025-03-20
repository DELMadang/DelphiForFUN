unit USetPartition;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
  A class defintion which will calculate "set partition" information.
  A set partition is a collection of disjoint subsets of a set of distinct
  objects which together include all of the members of the set exactly once

  An instance of TPartitionClass named DefPartiton is created at initilaizion
  time.  Before using an instance call PartitionInit with the new set size.
  Calls to GetNextpartition with return a TPartiton record (described below)
  as a parameter and a result value of true until all set partitoins have been
  retrieved.

  Calls to PartitionCount will return the "Bell number", the total number of set
  partitions for the current set size as a 64 bit integer (accurate up about
  10^20 (set sizes up to approximately 25).

  TPartition
  ----------

  Each partition is returned as TPartiton record, a square array of integers,
  with each row representing a subset and column as elements of the subsets.
  Unused elements of the array in the right and bottom portions of the array
  are set to  -1.

  So, for example, if the set if {1,2,3,4} and the particular set partition
  returned is {1},{2,3},{4} then the partition array after a call to
  GetNextpartition would contain"

    1,-1,-1,-1
    2,3,-1,-1
    4,-1,-1,-1
   -1,-1,-1,-1

   If sets contain other than in-order integers, the returned partition array
   subsets may be used to index the actual set members.

*)

interface

type
  Tpartition=array of array of integer;
  TPartitionClass= class(Tobject)
    private
      RG:array of integer;
      subsetcount:array of integer;
      function GetnextRG:boolean;
    public
      Setsize:integer;
      {PartitionCount:integer;} {the total number of partitionings}
      constructor create(NewSetSize:integer);
      procedure PartitionInit(NewSetsize:integer);
      function GetNextpartition(var P:Tpartition):boolean;
      function partitioncount:int64;
      function stirling2(N,K:integer):int64;
  end;

  var
    Defpartition:TPartitionClass;

implementation

{****************** Create *****************}
constructor TPartitionClass.create(newsetsize:integer);
begin
  inherited create;
  PartitionInit(newsetsize);
end;

{************ PartitionInit **************}
procedure TpartitionClass.PartitionInit(newsetsize:integer);
var i:integer;
begin
  setsize:=newsetsize;
  setlength(rg,setsize);
  setlength(subsetCount,setsize);
  for i:=0 to high(rg)-1 do rg[i]:=0;
  rg[high(rg)]:=-1;
end;


{***************** GetNextRG *****************}
function TPartitionClass.GetnextRG:boolean;
(*Get next "restricted growth" array, an array of subset indices for
 partitioning a set

 For example:  if the set is {1,2,3,4} and RG is [0,0,1,2] then
 the partitioning is {1,2}, {3}, {4}

 The RG arrays are characterized by the fact that for each element rg[i],
   rg[i] <= 1+ max(rg[0], rg[1], rg[2].., rg[i-1]
*)

var
  x,i,mx,incpos:integer;
begin
  result:=false;
  incpos:=high(rg);
  If incpos=0 then
  begin
    if rg[0]<0 then
    begin
      result:=true;
      rg[0]:=0;
    end
  end;
  while (incpos>0) and (not result) do
  begin
    x:=rg[incpos]+1; {get potential next value for rg[incpos]}
    mx:=0;
    for i :=0 to incpos-1 do
    begin  {get the max rg value to the left of incpos}
      if rg[i]>mx then mx:=rg[i];
    end;
    if x<=mx+1 then
    begin   {if its less than max+1 of anything to the left, then use it and
             set everything to the right to 0}
      rg[incpos]:=x;
      for i:=incpos+1 to high(rg) do rg[i]:=0;
      result:=true;
    end
    else dec(incpos); {otherwise back up one position}
  end;
end;


{*********************** GetNextPartition *************}
function TPartitionClass.GetNextpartition(var P:Tpartition):boolean;
var
  i,j:integer;
begin
  setLength(P,setsize,setsize);
  for i:= 0 to setsize-1 do  {initialize the partition record}
  begin
    for j:=0 to setsize-1 do p[i,j]:=-1;
    subsetcount[i]:=-1;
  end;
  if getnextrg then  {get the next restrictred growth array}
  begin
    result:=true;
    for i:= 0 to setsize-1 do
    begin  {elements of RG tell us the subset numbers to which each element belongs}
      inc(subsetcount[rg[i]]);
      p[RG[i],subsetcount[rg[i]]]:=i;
    end;
  end
  else result:=false;
end;




{******************** PartitionCount **************}
function TPartitionClass.partitioncount:int64;
{Based on the following a Bell triangle descritpion found at
 http://www.pballew.net/Bellno.html

 "The numbers can be constructed by using the Bell Triangle, a name suggested
 to Martin Gardner by Jeffrey Shallit.  Start with a row with the number one.
 Afterward each row begins with the last number of the previous row and
 continues to the right adding each number to the number above it to get the
 next number in the row."
}
var
  r,c:integer;
  n:int64;
  bell:array of array of int64;
begin
  setlength(bell,setsize,setsize);
  bell[0,0]:=1;
  for r:=1 to setsize-1 do
  begin
    bell[0,r]:=bell[r-1,r-1];
    for c:= 1 to r do bell[c,r]:=bell[c-1,r]+bell[c-1,r-1];
  end;
  result:=bell[setsize-1,setsize-1];
end;






function TPartitionClass.stirling2(N,K:integer):int64;
{Calculates the Stirling number of type 2 - the number of ways a set of size N
 can be split into K subsets.

 Calculated recursively as the number of ways we can split sets of size N-1 into
 K-1 subsets plus K times the # of ways a set of size N-1 can be split into K
 subsets.
}

begin
  if (k=0) or (N<k) then result:=0
  else if (n=1) or (n=k) then result:=1
  else result:=stirling2(n-1,k-1)+ k*stirling2(n-1,k);
end;


(*
{Original recusive version of partitioncount function  - too slow for SetSize>10}
function TPartitionClass.partitioncount:int64;
var
  i:integer;
  n:int64;
begin
  result:=0;
  for I:= 1 to setsize do
  begin
    n:=stirling2(setsize,i);
    result:=result+n;
  end;
end;
*)


initialization {create a default partition class instance}
  DefPartition:=TPartitionClass.create(1);
finalization   {free it when program exits}
  Defpartition.free;

end.
