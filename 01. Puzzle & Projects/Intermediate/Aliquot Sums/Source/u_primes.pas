unit u_primes;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface
  Const
    maxprimes=50000; {initial size of primes array}
    maxfactors=200;   {initial size of factors array}
    maxval=10000000000;     {10^10 - max prime to initialize}
  Type
  TPrimes=Class (TObject)
    Prime: Array of integer;  {Array of initialized primes - 0th entry is not used}
    nbrprimes, nbrfactors:integer;
    Factors:Array of int64; {array of factors - 0th entry is not used}

    Function GetNextprime(n:Int64):Int64;
    Function Isprime(n:int64):Boolean;
    Procedure Getfactors(n:int64);
    Constructor create;
    Destructor  destroy;  override;
  end;
  Var
    Primes:TPrimes;

  implementation

{*********************** GetNextPrime ********************}
Function TPrimes.Getnextprime(n:Int64):Int64;
Var
  nbr, stopval:int64;
  I: Integer;
  primefound: boolean;
Begin
  result:=-1;
  if n<Prime[nbrprimes]-1 then  {it's in the table already}
  Begin
    i:=1;
    while n>=Prime[i] do inc(i);
    result:=Prime[i];
    exit;
  end;
  nbr := n;
  primefound := False;
  While not primefound do
  Begin
    nbr := nbr + 1;
    stopval := trunc(Sqrt(0.0+nbr));
    For i := 1 To nbrprimes do
    Begin
      If (nbr Mod Prime[i] = 0) Then break; {its not prime so get next number}
      If (Prime[i] > stopval) Then    {it is prime}
      Begin
        result := nbr; { set the return value}
        primefound:=true;
        break;          { get us out of the loop}
      end;
    end;
  end;
 end;


 {************************* IsPrime *************************}
 Function TPrimes.Isprime(n:int64):Boolean;
 {Tests for primeness and returns true or false}
  var
   i:integer;
 begin
   i:=1;
   If n<=Prime[nbrprimes-1] then  {if it's prime. it's in the table already}
   begin
     while (i<nbrprimes) and (Prime[i]<>n) do inc(i);
     result:=Prime[i]=n;
   end
  {otherwise, backup by 1, get next prime and see if it equals our number}
   else result:=getnextprime(n-1)=n;
 end;

 {************************* GetFactors ******************}
 Procedure TPrimes.Getfactors(n:int64);
 {Returns prime factors}
 var
   stopval:int64;
   i:integer;
   nbr:int64;
 begin
   nbr:=n;
   nbrfactors:=0;
   stopval := trunc(Sqrt(0.0+nbr));
   i := 1;
   While (i < nbrprimes) And (Prime[i] <= stopval) do
   begin
     If nbr Mod Prime[i] = 0 Then {'we found a factor}
     begin
       inc(nbrfactors);
       If nbrfactors>=length(factors) then setlength(factors,length(factors)+maxfactors);
       factors[nbrfactors]:=Prime[i];
       nbr := nbr div Prime[i];  {and get the quotient as the new number}
       stopval := trunc(Sqrt(0.0+nbr));   { new stopvalue is sqrt of nbr}
     end
     Else inc(i);
   end;
   inc(nbrfactors);
   factors[nbrfactors]:=nbr;
 end;

{******************** Create ***********************}
Constructor TPrimes.Create;
{Calculate primes less than maxval using Sieve of Eratosthenes}
  var
    workprimes: array of integer;
    i,j:integer;
    nbr, stopval:integer;
begin
  inherited;
  setlength(workprimes,maxprimes+1);
  setlength(Prime, maxprimes+1);
  {showmessage('Max prime is '+inttostr(high(x)));}
  setlength(factors,maxfactors+1);
  {initialize array starting with 2,3,4,5, etc.}
  For i := 1 To maxprimes
  do workprimes[i] := i + 1;

  { now go through the array}
  For i := 1 To maxprimes div 2 Do
  begin
    {if # is greater than 0, then it's a prime}
    If workprimes[i] > 0 Then
    begin
      {go through the rest of the array zeroing out all multiples of this prime}
      j:=i + workprimes[i];
      While j <= maxprimes  do
      begin
        workprimes[j] := 0;
        j:= j + workprimes[i];
      end;
    end;
  end;
  {now "pack" the primes back to the beginning positions of the array}
  nbrprimes := 0;
  For i := 1 To maxprimes do
  begin
    If workprimes[i] > 0 Then
    begin
        inc(nbrprimes );
        Prime[nbrprimes] := workprimes[i];
    end;
  end;

   {Now calculate the rest of the primes up to maxval}
   { the hard way (trial and error)}
   stopval := trunc(Sqrt(0.0+maxval)); {largest prime factor we'll need}
   nbr := Prime[nbrprimes];
   While (nbr <= stopval) do
   begin
    nbr := Getnextprime(nbr);
    inc(nbrprimes);

    if nbrprimes>=length(Prime) then setlength(Prime,length(Prime)+maxprimes);
    Prime[nbrprimes] := nbr;
   end;
   setlength(prime,nbrprimes+1); {release unused memory at end of array}
 end;

 Destructor TPrimes.destroy;
   begin
     setlength(prime,0); {release memory}
     setlength(factors,0); {ditto}
     inherited;
   end;


 Initialization
   Primes:=TPrimes.create;
 Finalization
   Primes.Destroy;

end.
