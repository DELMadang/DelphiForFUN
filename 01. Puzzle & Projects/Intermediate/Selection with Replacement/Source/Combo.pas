Unit Combo;
 {Copyright 2002-2004, Gary Darby, www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Combo unit contains an object which provides an array of combinations
  or permuations of 'r' of 'n' numbers.

  Permuations are all subsets selecting r of n, combinations are the
  unique subsets.

  To use the Comboset object, call Combos.Setup(r,n,Combotype) where

    r is subset size;

    n is the size of the set to select from (current max is 20),

    Ctype is a variable specifying combinations or permutations.
       Combinations ==> return combinations (unique subsets)
       Permutations ==> return all subsets (permuattions)

   Other procedures are:

     GetNext - gets next combination or permutation based on Ctype.
        Subsets are in 'selected' array. Getnext returns false when
        no more subsets are available.

        Note: GetNextCombo and GetNextPermute may be called directly
              for efficiency.  But do not mix calls to these two routines.

     Getcount - return number of subsets which will be returned.
  }

Interface

uses dialogs;
Const maxentries=100;

Type
 bytearray=array[1..maxentries] of byte;
 TCombotype=(Combinations,CombinationsWithRep, Permutations, PermutationsWithRep);
 TComboSet=class(TObject)
  private
   N:           word;
   R:           word;
   NumberOfSubsets:int64;
   Ctype: TComboType; {Generate Combinations or permutations}
   loops:    bytearray;  {for efficiency, truncate search at loops for
                             each position, eg if n=10, then leftmost
                             has 10 of 10, for each of these,next position
                             has 9, next 8, etc. }
   public
   Selected:    bytearray;

   {Setup to retrieve R of N objects}
   Procedure Setup(newR, newN:word; NewCtype:TComboType);
   Function Getnext:boolean;
   Function GetNextCombo:Boolean;
   Function GetNextComboWithRep:Boolean;
   Function GetNextPermute:boolean;
   Function GetNextPermuteWithRep:Boolean;
   Function GetCount:int64;
   function GetR:integer;
  End;

  var
    combos:TComboSet;  {created at initialization time}

Implementation
  var
    count:int64;  {count of entries}

  {******************* Setup **********************}
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


    (*  Replaced by a different methodology
    *)
    {************ CalcCount **************}
    function calccount(Const r,n:integer):integer;
    {recursively calculate count for CombinationsWithRep}
    begin
      if (n=1) then result:=1
      else if (r=1) then result:=n
      else result:= calccount(r,n-1) + calccount(r-1,n);
    end; {CalcCount}



  Var i:word;
      temp:int64;
  Begin {Setup}
    n:=word(newn);
    if n>maxentries then n:=maxentries;
    r:=newr;
    if r>n then r:=n;
    Ctype:=newCtype;
    // with repetition must start from 11111... not from 12345...
    if (cType=CombinationsWithRep) or (cType=PermutationsWithRep)
    then
    begin
      For i:= 1 to r-1 do begin selected[i]:=1; loops[i]:=0; end;
      selected[r]:=0;
    end
    else
    begin
      for i:= 1 to r do begin selected[i]:=i; loops[i]:=0; end;
      selected[r]:=r-1;
    end;
    Case Ctype of
      Permutations, Combinations:
      begin
        NumberOfSubsets:=(Factorial(n) div factorial(n-r));
        if ctype=combinations then NumberofSubsets:=trunc(numberofSubsets / factorial(r));
      end;
      PermutationsWithRep:
      begin
        numberofSubsets:=n;
         for i:=1 to r-1 do numberofsubsets:=numberofsubsets*n;
       end;
      CombinationsWithRep:
      begin
        temp:=1 ;
        for i:= n to n+r-1 do temp:=temp*i;
        numberofsubsets:=temp div factorial(r);

        temp:=calccount(r,n); {recursive calculation}
        if numberofsubsets<> temp then showmessage('Count calc error');
        
      end;
    end;
    count:=0;
  End;

  {****************** GetNextPermute ****number********}
  Function TComboset.getnextpermute:boolean;
  Var i,j,k:word;
      done:boolean;
      flag:boolean;
    Begin
      result:=false;
      i:=r;                             {Start with last position}
      done := false;
      while not done do
      Begin
        j:=selected[i]+1;               {Increment the digit}
        If loops[i]>n-i then j:=n+1;    {drop out after max number created}
        if (j<=n) then
        Repeat
          flag:=false;        {check rightmost numbers}
          for k:=1 to i do
          If selected[k]=j then
          Begin
            flag:=true;
            break; {end loop}
          End;

          if not flag then   {If it hasn't been used...}
          Begin
            selected[i]:=j;                {then use it}
            inc(loops[i]);                 {inc loop count}
            inc(i);                        {and go to the next position}
            If i<=r then j:=1; {Set initial trial number}
          End
          else inc(j);                   {Otherwise try next number}
        Until (i>r) or (j>n);            {loop 'til all have been tried}
        if j>n then                      {if we didn't make it }
        Begin
          selected[i]:=0;              {then reset this position}
          loops[i]:=0;
          dec(i);                        {and try previous position}
        End
        else Begin done:=true; result:=true; End; {otherwise set for exit}
        If i=0 then Begin done:=true;  End; {If we get to 0, all done}
      End;
    End; {Getpermute}


 {************************ GetNextCombo ****************}
    Function Tcomboset.getNextcombo:boolean;
    Var i,j:word;
        done:boolean;
    Begin
      result:=false;
      i:=r;                             {Start with last position}
      done := false;
      while not done do
      Begin
        j:=selected[i]+1;               {Increment the digit}
        if j<=n then
        Repeat
            selected[i]:=j;                {then use it}
            inc(i);                        {and go to the next position}
            If i<=r then j:=selected[i-1]+1; {Set initial trial number}
        Until (i>r) or (j>n);            {loop 'til all have been tried}
        if j>n then                      {if we didn't make it }
        Begin
          dec(i);                        {and try previous position}
        End
        else Begin done:=true; result:=true; End; {otherwise set for exit}
        If i=0 then Begin done:=true;  End; {If we get to 0, all done}
      End;
    End;

 {*************** GetNextPermuteWithRep ***********}
 function  TComboSet.getNextPermuteWithRep:boolean;
 var
   index:integer;
   OK:boolean;
 begin
     index:=r;
     OK:=false;
     repeat
       if selected[index]<N then
       begin
         inc(selected[index]);
         OK:=true;
       end
       else
       begin
         selected[index]:=1;
         dec(index);
       end;
     until (OK) or (index<1);
   if index<=0 then result:=false
   else result:=true;
 end;

{************** GetNextComboWithRep  *****************}
    Function Tcomboset.getNextcomboWithRep:boolean;          // new function
    Var i,j:word;
        done:boolean;
    Begin
      result:=false;
      i:=r;                             {Start with last position}
      done := false;
      while not done do
      Begin
        j:=selected[i]+1;               {Increment the digit}
        if j<=n then
        Repeat
            selected[i]:=j;                {then use it}
            inc(i);                        {and go to the next position}
            If i<=r then j:=selected[i-1]; {Set initial trial number}

        Until (i>r) or (j>n);         {loop 'til all have been tried}
        if j>n then dec(i)            {if we didn't make it, try previous position}
        else
        begin
          done:=true;
          result:=true;
        end; {otherwise
        set for exit}
        If i=0 then done:=true;  {If we get to 0, all done}
      End;
    End;

   {**************** GetNext *******************}
   Function Tcomboset.getnext;
   {Get the next arangements depending on type specified at setup time}
    Begin {Getnext}
      case Ctype of
        Combinations: result:=getnextcombo;
        Permutations: result:=getnextpermute;
        CombinationsWithRep: result:=getnextComboWithRep;
        PermutationsWithrep: result:=getnextPermuteWithrep;
        else result:=false;
      end;
      inc(count);
    End;

   {***************** GetCount ***********}
   function TComboset.Getcount:int64;
   begin result:=NumberOfSubsets;   end;


   {************* GetR ***********}
   function TComboset.GetR:integer;
   begin result:=r; end;

 Initialization
   combos:=TComboset.create;

 End.
