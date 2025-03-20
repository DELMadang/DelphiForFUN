unit U_Permutes;
{Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

  Function InitPermutes(NewR, NewN:integer):integer;
  Function GetNextPermute(var s:array of integer):boolean;

implementation

 var
    N,R:integer;
    x:array of integer;


Function InitPermutes(NewR,NewN:integer):integer;
  {Set up to select r of n integers}
  var
    i:integer;
  Begin
    n:=newN;
    r:=newR;
    result:=1;
    {Calculate result as N!/(N-R)!}
    for i:=1 to r do result:=result*(n-(i-1)); {This is N!/(N-R)!}
    setlength(x,R+1); {make an extra location and don't use 0th}
    for i:=1 to R do x[i]:=i; {initialize 1st output permutation}
  end;

  Function CanInc(p:integer; var newval:integer):boolean;
     {Tests to see if we can increment the integer at p}
     {If there is an integer greater than x[p] that is not used
      is a postion before p, then we can increment x[p] to that
      integer.  Set result to true if newval is a usable value,
      false otherwise}
     var
       i:integer;
     Begin
       if x[p]>=n then result:=false
       else
       Begin
         result:=false;
         newval:=x[p];
         {try all values > x[p] until we find an unused one,
          or run out of numbers}
         while (result=false) and (newval<n) do
         Begin
           inc(newval);
           result:=true;
           for i:= 0 to p-1 do
           if x[i]=newval then Begin result:=false;  break; end;
         end;
       end;
     end;

Function GetNextPermute(var s:array of integer):boolean;
  var
  i,j,incpos:integer;
  OK:Boolean;
  newval:integer;
  Begin
    result:=true;
   {find the position to increment starting with rightmost}
   incpos:=r;
   ok:=false;
   while (incpos>0) and (not OK) do
    {If we can increment this position, do it}
    if CanInc(incpos,newval) then Begin x[incpos]:=newval; ok:=true; end
    else dec(incpos);  {otherwise, back-up to previous position}

    If incpos>0 then
    {now reset the remainder to the smallest values possible}
    for j:= incpos+1 to r do
    Begin
      x[j]:=0;
      if CanInc(j,newval) then x[j]:=newval
      else result:=false;
    end
    else result:=false;

    for i:= 1 to r do s[i]:=x[i];
  end;

end.


