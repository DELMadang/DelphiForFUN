Unit UCombos;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Combo unit contains an TComboSet object which provides an array of combinations
  or permuations of 'r' of 'n' numbers.

 A single instance, Combos, is created at initialization time;  eliminating the
 need for users to create an instance in most cases.

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
        Subsets are in 'Selected' array. Getnext returns false when
        no more subsets are available.

        Note: GetNextCombo and GetNextPermute may be called directly
              for efficiency.  But do not mix calls to these two routines.

     Getcount - return number of subsets which will be returned.
  }

Interface
Const maxentries=100;

Type
 bytearray=array[1..maxentries] of byte;
 TCombotype=(Combinations,Permutations);
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
   Selected: bytearray;

   {Setup to retrieve R of N objects}
   Procedure Setup(newR, newN:word; NewCtype:TComboType);
   Function Getnext:boolean;
   Function GetNextCombo:Boolean;
   Function GetNextPermute:boolean;
   Function GetCount:int64;
   function GetR:integer;
  End;

  var
    combos:TComboSet;  {created at initialization time}

Implementation
  var
    count:int64;  {count of entries}

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
    if n>maxentries then n:=maxentries;
    r:=newr;
    if r>n then r:=n;
    Ctype:=newCtype;
    For i:= 1 to r do Begin selected[i]:=i; loops[i]:=0; End;
    selected[r]:=r-1;
    NumberOfSubsets:=(Factorial(n) div factorial(n-r));
    If Ctype=Combinations then NumberofSubsets:=trunc(numberofSubsets / factorial(r));
    count:=0;
  End;


  Function TComboset.getnextpermute:boolean;
  Var i,j,k:word;
      done:boolean;
      flag:boolean;
    Begin
      getnextpermute:=false;
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
            break; {k:=i;} {end loop}
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
        else Begin done:=true; getnextpermute:=true; End; {otherwise set for exit}
        If i=0 then Begin done:=true;  End; {If we get to 0, all done}
      End;
    End; {Getpermute}

    Function Tcomboset.getNextcombo:boolean;
    Var i,j:word;
        done:boolean;
    Begin
      getnextcombo:=false;
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
        else Begin done:=true; getnextcombo:=true; End; {otherwise set for exit}
        If i=0 then Begin done:=true;  End; {If we get to 0, all done}
      End;
    End;

   Function Tcomboset.getnext;
    Begin {Getnext}
      If Ctype=Combinations then getnext:=getnextcombo
      Else getnext:=getnextpermute;
      inc(count);
    End;

    function TComboset.Getcount:int64;
    begin result:=NumberOfSubsets;   end;

   function TComboset.GetR:integer;
   begin result:=r; end;

 Initialization
   combos:=TComboset.create;

 End.
