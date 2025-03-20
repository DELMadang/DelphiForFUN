Unit Combo;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Combo contains an object which provides all combinations  or permuations
  of 'r' of 'n' numbers.

  Permuations are all subsets of r of n, combinations are the unique subsets.

  To use TComboset, call Combos.Setup(r,n,Combotype) where

    r - is subset size;
    n - is the size of the set to select from (current max is 20),

    Combotype is a Ctype variable specifying combinations or permutations.
       Combinations ==> return combinations (unique subsets)
       Permutations ==> return all subsets (permuations)

   Other procedures:

     GetNext - gets next combination or permutation based on Ctype passed to
               Setup.   Subsets are in placed in "Selected" array.  Returns
               false when no more subsets are available.

     GetNextCombo and GetNextPermute may be called directly for efficiency.
               Do not mix calls to these two routines without calling Setup to
               change search type.

     Getcount - returns number of subsets which will be returned.

     Note: Overloaded versions of GetNext, GetNextCombo, GetNextPermute are
           defined which return a copy values from "Selected" to a passed
           dynamic byte array of type TCombobytes

     An instance of TComboSet named Combos is created at initilaization time
     for use by calling programs.
     }

Interface

Type
 TComboBytes=array of byte;
 TCombotype=(Combinations,Permutations);
 TComboSet=class(TObject)
  private
   N:           word;
   R:           word;
   NumberOfSubsets:int64;
   Ctype: TComboType; {Generate Combinations or permutations}
   loops:    TComboBytes;  {for efficiency, truncate search at loops for
                             each position, eg if n=10, then leftmost
                             has 10 of 10, for each of these,next position
                             has 9, next 8, etc. }
   SkipAmt:int64;
   function getnextFullpermute:boolean;

   public
   Selected:    TComboBytes;

   {Setup to retrieve R of N objects}
   procedure Setup(newR, newN:word; NewCtype:TComboType);
   function  Getnext:boolean; overload;
   function  GetNextCombo:Boolean; overload;
   function  GetNextPermute:boolean; overload;
   function  GetCount:int64;

   function  GetNext(var x:TCombobytes):boolean; overload;
   function  GetNextCombo(var x:TComboBytes):Boolean; overload;
   function  GetNextPermute(var x:TComboBytes):boolean; overload;

  End;

  var
    combos:TComboSet; {pre-initialized instance}

Implementation
  uses sysutils, dialogs;

  {****************** Setup *****************}
  Procedure TComboset.Setup(newR, newN:word; NewCtype:TComboType);
    Function factorial(n:word):int64;
    {Compute factorial}
    Var k:int64;
        i:word;
    Begin
      k:= 1;
      For i:= 2 to n do k:= k*i;
      result:=k;
    End; {Factorial}

  Var i:word;

  Begin {Setup}
    n:=newn;
    r:=newr;
    if r>n then r:=n;
    Ctype:=newCtype;
    if newctype = permutations then
    begin
      setlength(selected,n);  setlength(loops,n);
      For i:= 0 to n-1 do Begin selected[i]:=i+1; loops[i]:=0; End;
    end
    else {combinations}
    begin
      setlength(selected,r);  setlength(loops,r);
      For i:= 0 to r-1 do Begin selected[i]:=i+1; loops[i]:=0; End;
      {selected[r-1]:=r-1;}
    end;
    numberofsubsets:=1;
    for i:= n downto n-r+1 do numberofsubsets:=numberofsubsets*i;
    {NumberOfSubsets:=(Factorial(n) div factorial(n-r));}
    If Ctype=Combinations then NumberofSubsets:=trunc(numberofSubsets / factorial(r));
    skipamt:=factorial(n-r);
  End;


    {******************* GetNextCombo ************}
    Function Tcomboset.getNextcombo:boolean;
    Var i,j:integer;
        done:boolean;
    Begin
      getnextcombo:=false;
      i:=r-1;                             {Start with last position}
      done := false;
      while not done do
      Begin
        j:=selected[i]+1;               {Increment the digit}
        if j<=n then                       {If j<= max}
        Repeat
            selected[i]:=j;                {then use it}
            inc(i);                        {and go to the next position}
            If i<=r-1 then j:=selected[i-1]+1; {Set initial trial number}
        Until (i>r-1) or (j>n);            {loop 'til all have been tried}
        if j>n then                      {if we didn't make it }
        Begin
          dec(i);                        {and try previous position}
        End
        else Begin done:=true; getnextcombo:=true; End; {otherwise set for exit}
        If i<0 then Begin done:=true;  End; {If we get to 0, all done}
      End;
    End;

  {************ GetNetxCombo (overloaded) *************}
  function TComboset.getnextcombo(var x:TComboBytes):boolean;
  var i:integer;
  begin
    result:=getnextpermute;
    if length(x) >= r then setlength(x,r);
    if result  then for i:= 0 to r-1 do x[i]:=selected[i]
  end;

  {**************** GetNextPermute ***********}
  function TComboset.GetNextPermute:boolean;
  var i:integer;
  begin
    for i:= 1 to skipamt do result:=getnextFullpermute;
  end;

  {**************** GetNextPermute (overloaded) ***********}

  function TComboset.GetNextPermute(var x:TComboBytes):boolean;
  var i:integer;
  begin
    for i:= 1 to skipamt do result:=getnextFullpermute;
    if length(x) <> r then setlength(x,r);
    if result then for i:=0 to r-1 do x[i]:=selected[i];
  end;

function TComboset.getnextFullpermute:boolean;
  var
    i,j,key,temp,rightmost:integer;
  begin
    {1. Find Key, the leftmost byte of rightmost in-sequence pair
        If none found, we are done}

    {  Characters to the right of key are the "tail"}
    rightmost:=high(selected);
    i:=rightmost-1; {Start at right end -1}
    while (i>=0) and (selected[i]>=selected[i+1]) do dec(i); {Find in-sequence pair}
    if i>=0 then  {Found it, so there is another permutation}
    begin
      result:=true;
      key:=selected[i];

      {2A. Find rightmost in tail that is > key}
      j:=rightmost;
      while (j>i) and (selected[j]<selected[i]) do dec(j);
      {2B. and swap them} selected[i]:=selected[j]; selected[j]:=key;

      {3. Sort tail characters in ascending order}
      {   By definition, the tail is in descending order now,
          so we can do a swap sort by exchanging first with last,
          second with next-to-last, etc.}
      inc(i); j:=rightmost; {point i to tail start, j to tail end}
      while j>i do
      begin
        if selected[i]>selected[j] then
        begin {swap}
          temp:=selected[i]; selected[i]:=selected[j]; selected[j]:=temp;
        end;
        inc(i); dec(j);
      end;
    end
    else result:=false; {else please don't call me any more!}
  end;

   {**************** GetNext **********}
   function Tcomboset.getnext:boolean;
    Begin {Getnext}
      If Ctype=Combinations then result:=getnextcombo
      Else result:=getnextpermute;
    End;

    function Tcomboset.getnext(var x:TComboBytes):boolean;
    Begin {Getnext}
      If Ctype=Combinations then result:=getnextcombo(x)
      Else result:=getnextpermute(x);
    End;

    {***************** GetCount ********}
    Function TComboset.Getcount:int64;
    Begin
      Getcount:=NumberOfSubsets;
    End;

 Initialization
   combos:=TComboset.create;

 End.
