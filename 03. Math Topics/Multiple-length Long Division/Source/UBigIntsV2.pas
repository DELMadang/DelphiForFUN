unit UBigIntsV2;
{Copyright 2005, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Arbitarily large integer unit -
  Operations supported:
    Assign, Add, Subtract, Multiply, Divide, Modulo, Compare, Factorial
   (Factorial limited to max integer, run time would probably limit it
    to much less)
   All operations are methods of a Tinteger class and replace the value with the
    result.  For binary operations (all except factorial), the second operand is
    passed as a parameter to the procedure.
 }
 {additions by Hans Klein 2005(hklein@planet.nl)
        Procedures:
          pow(const exponent:Int64);
          square;
          sqroot;
          gcd(i2:tinteger);
          gcd(i2:Int64);
          shiftleft: fast multiplication by base;
          modpow(const e,m:Tinteger);
          invmod(I2:Tinteger);
        Functions:
          shiftright: fast division by base; result=remainder;
          isodd:boolean;
          IsProbablyPrime:boolean;
}

interface
  uses forms, dialogs,sysutils;

type
  TDigits=array of int64;
  TInteger=class(TObject)
    private
     sign:integer;
     fdigits:TDigits;
     base:integer;
     procedure trim;
     function getbasepower:integer;
   public
     property digits:TDigits read fdigits;
     constructor  create;
     procedure Assign(Const I2:TInteger); overload;
     procedure Assign(Const I2:Int64); overload;
     procedure Assign(Const I2:string);overload;
     procedure absadd( const i2:tinteger);
     procedure Add(const I2:TInteger);overload;
     procedure Add(const I2:Int64); overload;
     procedure abssubtract(const i2:Tinteger);
     procedure Subtract(const I2:TInteger);overload;
     procedure Subtract(const I2:Int64); overload;
     procedure mult(const I2:TInteger); overload;
     procedure mult(const I2:int64); overload;
     procedure divide(const I2:TInteger); overload;
     procedure divide(const I2:Int64); overload;
     procedure modulo(const i2:TInteger); overload;
     procedure modulo(const i2:Int64); overload;
     procedure Dividerem(const I2:TInteger; var remain:TInteger);
     procedure Olddividerem(const I2:TInteger; var remainder:TInteger);
     function  compare(I2:TInteger):integer; overload;
     function  compare(I2:Int64):integer; overload;
     function  abscompare(I2:TInteger):integer;
     procedure factorial;
     function  ConvertToDecimalString(commas:boolean):String;
     function  converttoInt64(var n:Int64):boolean;
     function  digitcount:integer;
     Procedure setsign(s:integer);
     function  getsign:integer;
     function  ispositive:boolean;
     procedure ChangeSign;
     procedure pow(const exponent:Int64);
     procedure modpow(const i2,m:Tinteger);
     procedure sqroot;
     procedure square;
     function  shiftright:integer;
     procedure shiftleft;
     procedure gcd(const i2:Tinteger) ;overload;
     procedure gcd(const i2:Int64) ; overload;
     function  isodd:boolean;
     function  IsProbablyPrime:boolean;
     procedure invmod(I2:Tinteger);
     procedure setdigitlength(const k:integer);
     function getlength:integer;

  end;

  {Caution - calculations with mixed basevalues are not allowed,
   changes to Baseval should be made before any other TInteger
   operations}
  Procedure SetBaseVal(const newbase:integer);
  Function Getbasepower:integer;


implementation
uses math;


var
  baseval:integer=1000; {1,000}
  basepower:integer;
  worki2,imult1,imult2, iadd3, isub3:TInteger;
  idiv2, idiv3, idivd3, idiv4, d, dq:Tinteger;
  i3,i4:TInteger;


Procedure setbaseval(const newbase:integer);
var n:integer;
begin
  baseval:=10;
  basepower:=1;
  n:=newbase;
  if n>10e6 then n:=trunc(10e6)   {validate new base value}
  else if n<10 then n:=10;
  while n>10 do
  begin
    inc(basepower);
    n:=n div 10;
    baseval:=baseval*10;
  end;

  {create, or re-create, work fields}
  if assigned(worki2) then worki2.free; worki2:=Tinteger.create;
  if assigned(imult1) then imult1.free; imult1:=Tinteger.create;
  If assigned(imult2) then imult2.free; imult2:=Tinteger.create;
  If assigned(isub3) then isub3.free; isub3:=Tinteger.create;
  If assigned(iadd3) then iadd3.free; iadd3:=Tinteger.create;
  If assigned(idiv2) then idiv2.free;  idiv2:=Tinteger.create;
  If assigned(idiv3) then idiv3.free;   idiv3:=Tinteger.create;
  If assigned(idivd3) then idivd3.free;   idivd3:=Tinteger.create;
  If assigned(idiv4) then idiv4.free;   idiv4:=Tinteger.create;
  If assigned(d) then d.free;   d:=Tinteger.create;
  If assigned(dq) then dq.free;   dq:=Tinteger.create;
  If assigned(i3) then i3.free;   i3:=Tinteger.create;
  If assigned(i4) then i4.free;   i4:=Tinteger.create;
end;

Function getBasepower:integer;
begin
  result:=basepower;
end;

  constructor TInteger.create;
  begin
    inherited;
    base:=baseval; {base in Tinteger in case we want to handle other bases later}
    sign:=+1;
  end;

  {************ ShiftRight ***********}
  function Tinteger.shiftright:integer;
  {Divide value by baseval and return the remainder}
  var c,i:integer;
  begin
    result:=fDigits[0];
    c:=high(fdigits);
    for i:=0 to c-1 do fdigits[i]:=fdigits[i+1];
    setlength(fdigits,c);
    trim;
  end;

  {********** ShiftLeft *********}
  procedure Tinteger.shiftleft;
  {Multiply value by base}
  var c,i:integer;
  begin
    c:=high(fdigits);
    setlength(fdigits,c+2);
    for i:=c downto 0 do
    fdigits[i+1]:=fdigits[i];
    fdigits[0]:=0;
    trim;
  end;

  {*************** SetDigitLength **********}
  Procedure TInteger.SetDigitLength(const k:integer);
  {Expand or contract the number of digits}
  begin
    setlength(fdigits,k);
  end;

  {*********** GetLength **********}
  function TInteger.getlength:integer;
  {Return the number of digits for this base}
  begin result:=length(fdigits); end;

  {************** Subtract ************}
  procedure Tinteger.Subtract(const I2:TInteger);
  {Subtract by negating, adding, and negating again}
  begin
  i2.ChangeSign;
  add(i2);
  i2.ChangeSign;
  end;

  {************* Subtract (64 bit integer)}
  procedure Tinteger.Subtract(const I2:Int64);
     begin
       isub3.assign(i2);
       isub3.ChangeSign;
       add(isub3);
     end;

{********* DigitCount ************}
 function TInteger.digitcount:integer;
{ Return count of base 10 digits in the number }
var n:int64;
begin
  result:=(length(digits)-1)*getbasepower;
  n:=digits[high(digits)];
  while n >0 do
  begin
    inc(result);
    n:=n div 10;
  end;
end;

{************* SetSign ************}
Procedure TInteger.setsign(s:integer);
{Set the sign of the number to match the passed integer}
begin
  if s>0 then  sign:=+1
  else if s<0 then sign:=-1
  else sign:=0;
end;

{************** GetSign *********}
function TInteger.getsign:integer;
begin  result:=sign; end;

{*********** IsPositive ***********}
function TInteger.ispositive:boolean;
begin result:=sign > 0; end;

{************** ChangeSign **********}
  procedure Tinteger.ChangeSign;
  begin
  sign:=-sign
  end;

{******** Square *********}
  procedure Tinteger.square;
  begin
  mult(self)
  end;

{********** Trim ***********}
  procedure TInteger.trim;
  {eliminate leading zeros}
  var
    i:integer;
  begin
    i:=high(fdigits);
    while (i>0) and (fdigits[i]=0) do dec(i);
    setlength(fdigits,i+1);
  end;

  {**************** GatBasePower *******}
  function TInteger.getbasepower:integer;
  var n:integer;
  begin
    if base=baseval then result:=basepower
    else
    begin
      result:=0;
      n:=base;
      while n>1 do
      begin
        inc(basepower);
        n:=n div 10;
      end;
    end;
  end;

  {************* Assign **********}
  procedure TInteger.Assign(Const I2:TInteger);
  {Assign - TInteger}
  var
    i:integer;
  begin
    if i2.base=base then
    begin
      setlength(fdigits,length(i2.fdigits));
      for i:=low(i2.fdigits) to high(i2.fdigits) do fdigits[i]:=i2.fdigits[i];
      sign:=i2.sign;
      trim;
    end
    else
    begin
      showmessage('Bases conversions not yet supported');
    end;
  end;

  {************ Assign (int64)***********}
  procedure TInteger.Assign(Const I2:Int64);
  {Assign - int64}
  var
    i:integer;
    n:int64;
  begin
    setlength(fdigits,20);
    n:=i2;
    i:=0;
    repeat
      fdigits[i]:=n mod base;
      n:=n div base;
      inc(i);
    until n=0;
    if i2<0 then sign:=-1
    else if i2=0 then sign:=0
    else if i2>0 then sign:=+1;
    setlength(fdigits,i);
    trim;
  end;

  {************* Assign   (String type *********}
  procedure TInteger.Assign(const i2:string);
  {Convert a  string number}
  var
    i,j:integer;
    zeroval:boolean;
    n:int64;
    pos:integer;
  begin
    n:= length(I2) div getbasepower + 1;
    setlength(fdigits,n);
    for i:=0 to n-1 do fdigits[i]:=0;
    sign:=+1;
    j:=0;
    zeroval:=true;
    n:=0;
    pos:=1;
    for i:=length(i2) downto 1 do
    begin
      if i2[i] in ['0'..'9'] then
      begin
        n:=n + pos*(ord(i2[i])-ord('0'));
        pos:=pos*10;
        if pos>base then
        begin
          fdigits[j]:= n mod base;
          n:= n div base;
          pos:=10;
          inc(j);
          zeroval:=false;
        end
        else
      end
      else if i2[i]='-' then sign:=-1;
    end;
    fdigits[j]:=n;  {final piece of the number}
    if zeroval and (n=0)then sign:=0;
    trim;
  end;

  {************ Add *********}
  procedure TInteger.Add(Const I2:TInteger);
  {add - TInteger}
  begin
    if sign<>i2.sign then abssubtract(i2)
    else absadd(i2);
  end;

{**************** AbsAdd ***************}
 procedure tinteger.absadd( const i2:tinteger);
 {add values ignoring signs}
 var
    i:integer;
    //I3:Tinteger;
    n, carry:int64;
  begin
    //I3:=TInteger.create;
    I3.assign(self);
    setlength(fdigits, max(length(fdigits),length(i2.fdigits))+1); {"add" could grow result by two digit}
    i:=0;
    carry:=0;
    while i<min(length(i2.fdigits),length(i3.fdigits)) do
    begin
      n:=i2.fdigits[i]+i3.fdigits[i]+carry;
      fdigits[i]:= n mod base;
      if n >= base then carry:=1 else carry:=0;
      inc(i);
    end;
    if length(i2.fdigits)>length(i3.fdigits) then
    while i<{=}length(i2.fdigits) do
    begin
      n:=i2.fdigits[i]+carry;
      fdigits[i]:= n mod base;
      if n >= base then carry:=1 else carry:=0;
      inc(i);
    end
    else
    if length(i3.fdigits)>length(i2.fdigits) then
    begin
      while i<{=}length(i3.fdigits) do
      begin
        n:=i3.fdigits[i]+carry;
        fdigits[i]:= n mod base;
        if n >= base then carry:=1 else carry:=0;
        inc(i)
      end;
    end;
    fdigits[i]:=carry;
    trim;
    //i3.free;
  end;

  {************* Add (int64) ********}
  procedure TInteger.add(Const I2:Int64);
  {Add - Int64}
  //var
    //I3:TInteger;
  begin
    //I3:=TInteger.create;
    IAdd3.assign(I2);
    Add(IAdd3);
    //I3.free;
  end;

  (*
  procedure TInteger._Subtract(const I2:TInteger);
  {Subtract}
  begin
    if sign<>i2.sign then absadd(I2)
    else abssubtract(i2);
  end;
*)


{*************** AbsSubtract *************}
procedure TInteger.abssubtract(const i2:Tinteger);
{Subtract values ignoring signs}
var
    c:integer;
    i3:TInteger;
    i,j,k:integer;
  begin {request was subtract and signs are same,
         or request was add and signs are different}
    c:=abscompare(i2);
    i3:=TInteger.create;
    if c<0 then {abs(i2) larger, swap and subtract}
    begin
      i3.assign(self);
      assign(i2);
    end
    else if c>=0 then {self is bigger} i3.assign(i2);
    for i:= 0 to high(i3.fdigits) do
    begin
      if fdigits[i]>=i3.fdigits[i] then fdigits[i]:=fdigits[i]-i3.fdigits[i]
      else
      begin  {have to "borrow"}
        j:=i+1;
        while(j<=high(fdigits)) and (fdigits[j]=0) do inc(j);
        if j<=high(fdigits) then
        begin
          for k:=j downto i+1 do
          begin
            dec(fdigits[k]);
            fdigits[k-1]:=fdigits[k-1]+base;
          end;
          fdigits[i]:=fdigits[i]-i3.fdigits[i];
        end
          else showmessage ('Subtract error');
      end;
    end;
    i3.free;
    trim;
  end;

(*
  procedure TInteger._Subtract(const I2:Int64);
  {subtract - TInteger}
  var
    I3:Tinteger;
  begin
    i3:=TInteger.create;
    i3.assign(i2);
    subtract(i3);
    i3.free;
  end;
*)


{*************** Mult  (Tinteger type) *********}
  procedure TInteger.Mult(const I2:TInteger);
  {Multiply - by Tinteger}
  var
    n:int64;
    i,j:integer;
  begin
    imult1.assign(0);
    for i:=0 to high(i2.fdigits) do
    begin
      n:=i2.fdigits[i];
      imult2.assign(self);
      imult2.mult(n);
      setlength(imult2.fdigits,length(imult2.fdigits)+i);
      if i>0 then
      begin
        for j:= high(imult2.fdigits) downto i
        do imult2.fdigits[j]:=imult2.fdigits[j-i];
        for j:= i-1 downto 0
        do imult2.fdigits[j]:=0;
      end;
      imult1.add(imult2);
    end;
    assign(imult1);
    sign:=sign*i2.sign;
  end;


 (* rerwrite - not any faster
{*************** Mult  (Tinteger type) *********}
  procedure TInteger.NewMult(const I2:TInteger);
  {Multiply - by Tinteger}

    procedure product(var x: TInteger;
                          y: TInteger; k: integer);
    var carry, i:integer;
        m, temp: int64;
    begin
      m := y.getlength;
      {x.assign(0);} carry := 0;
      if length(x.fdigits)<m then setlength(x.fdigits,m);
      for i := 0 to m - 1 do
      begin
        temp := y.fdigits[i]*k + carry;
        x.fdigits[i] := temp mod baseval;
        carry := temp div baseval
      end;
      if carry>0 then
      if length(x.fdigits)<=m then
      begin
        setlength(x.fdigits,m+1);
        x.fdigits[m] := carry
      end;
    end;


  var
    n:int64;
    i,j:integer;
  begin
    worki2.assign(i2);
    imult1.assign(0);
    imult2.assign(self);
    assign(0);
    for i:=0 to high(i2.fdigits) do
    begin
      n:=worki2.fdigits[i];
      product(imult1, imult2, n);
      imult2.shiftleft;
      add(imult1);
    end;
    {assign(imult1);}
    sign:=sign*i2.sign;
  end;
*)

  procedure TInteger.Mult(const I2:int64);
  {Multiply - by int64}
  var
    n,d:int64;
    carry:int64;
    i:integer;
  begin
    carry:=0;
    for i:=0 to high(fdigits) do
    begin
      n:=fdigits[i]*i2;
      d:=n mod base + carry;
      carry:=n div base;
      while d>=base do
      begin
       d:=d-base;
       inc(carry);
      end;
      fdigits[i]:=d;
    end;
    if carry<>0 then
    begin
      i:=high(fdigits)+1;
      setlength(fdigits,length(fdigits)+carry div base + 1);
      while carry>0 do
      begin
        fdigits[i]:=carry mod base;
        carry:=carry div base;
        inc(i);
      end;
    end;
    trim;
  end;

{************ Divide *************}
procedure TInteger.divide(const I2:TInteger);
{Divide - by TInteger}
begin
  If i2.compare(0)=0 then exit;
  {IDiv3 holds the remainder (which we don't need)}
  dividerem(I2,idiv3);
end;

{************* Divide (Int64) **********}
procedure TInteger.divide(const I2:Int64);
{Divide - by Int64}
begin
  idiv2.assign(i2);
  divide(idiv2);
end;

{***************** Modulo *************}
procedure Tinteger.modulo(const i2:TInteger);
{Modulo (remainder after division) - by Tinteger}
var
  i3:TInteger;
begin
  i3:=TInteger.create;
  dividerem(i2,i3);
  assign(i3);
  i3.free;
end;

{************ Modulo (Int64) ************}
procedure TInteger.modulo(const I2:Int64);
{Modulo - by Int64}
var
  i3:Tinteger;
begin
  i3:=TInteger.create;
  i3.assign(i2);
  modulo(i3);
  i3.free;
end;


procedure TInteger.Olddividerem(const I2:TInteger; var remainder:TInteger);
{Divide - by TInteger and return remainder as well}
{Slow - replaced by DivideRem }
var
  i3:TInteger;
  q:int64;
  i,size:integer;
  d:array of int64;
  pos:integer;
  signout:integer;
  done:boolean;
begin
  if sign<>i2.sign then signout:=-1 else signout:=+1;
  sign:=+1;
  i2.sign:=+1;
  if i2.compare(0)=0 then exit;
  if compare(i2)>=0 then
  begin
    i3:=TInteger.create;
    setlength(i3.fdigits, length(i2.fdigits));
    pos:=high(fdigits);
    i3.assign(fdigits[pos]);
    dec(pos);
    size:=-1;
    q:=0;
    if pos=-1 then{1 digit number}
    begin
      while i3.compare(i2)>=0 do
      begin
        inc(q);
        i3.subtract(i2);
      end;
      inc(size);
      setlength(d,1);
      d[0]:=q;
    end
    else
    while pos>=0 do
    begin
     done:=not ((pos>=0) and (i3.compare(i2)<0));
      while not done do { do}
      begin
        i3.mult(base);
        i3.add(fdigits[pos]);
        dec(pos);
        if (pos>=0) and (i3.compare(i2)<0) then
        begin
          inc(size);
          if size>length(d)-1 then setlength(d,length(d)+10);
          d[size]:=0;
        end
        else done:=true;
      end;
      q:=0;
      while i3.compare(i2)>=0 do
      begin
        inc(q);
        i3.{_}subtract(i2);
      end;
      inc(size);
      if size>length(d)-1 then setlength(d,length(d)+10);
      d[size]:=q;
    end;

    setlength(fdigits, size+1);
    for i:= size downto 0 do
    fdigits[size-i]:=d[i];
    remainder.assign(i3);
    sign:=signout;
    remainder.sign:=signout;
    trim;
    i3.free;
  end
  else
  begin
    remainder.assign(self);
    assign(0);
  end;
end;


{**************** Dividerem ***************}
procedure TInteger.dividerem(const I2:TInteger; var remain:TInteger);
    (*
    This version is based on a paper "Multiple-length Division Revisited: a Tour
    of the Minefield", by Per Brinch Hansen, Software - Practice and Experience,
    Vol 24(6), June 1994.

    Efficient implementation of long division
    *)
    {Product}
    procedure product(var x: TInteger;
                          y: TInteger; k: integer);
    var carry, i:integer;
        m, temp: int64;
    begin
      // multiple-length division revisited
      m := y.getlength;
      x.assign(0); carry := 0;
      if length(x.fdigits)<=m then setlength(x.fdigits,m+1);
      for i := 0 to m - 1 do
      begin
        temp := y.fdigits[i]*k + carry;
        x.fdigits[i] := temp mod baseval;
        carry := temp div baseval
      end;
      (*if m <= x.getlength{w} then*) x.fdigits[m] := carry
      //else if carry <> 0 then showmessage('Product Overflow');
    end;

    procedure quotient(var x: TInteger;
                        y: TInteger; k: integer);
      var i, m: integer;
          temp,carry:int64;
      begin
        m := y.getlength;
        x.assign(0); carry := 0;
        setlength(x.fdigits,m);
        for i := m - 1 downto 0 do
        begin
          temp := carry*baseval + y.fdigits[i];
          x.fdigits[i] := temp div k;
          carry := temp mod k
        end;
      end;

      procedure remainder(var x: TInteger;
                              y: TInteger; k: integer);
      var carry:int64;
          i, m: integer;
      begin
        m := y.getlength;
        x.assign(0); carry := 0;
        setlength(x.fdigits,M);
        for i := m - 1 downto 0 do
              carry := (carry*baseval + y.fdigits[i]) mod k;
        x.fdigits[0] := carry
      end;

      function trial(r, d: TInteger;
                     k, m: integer): int64;
      var d2,r3:int64;
          km: integer;
      begin
        {2 <= m <= k+m <= w}
        km := k + m;
        if length(r.fdigits)<km+1 then setlength(r.fdigits,km+1);
        r3 := (r.fdigits[km]*baseval + r.fdigits[km - 1])*baseval
                + r.fdigits[km - 2];
        d2 := d.fdigits[m -1]*baseval + d.fdigits[m -2];
        result := min(r3 div d2, baseval - 1)
      end;

      function smaller(r, dq: TInteger;
                        k, m: integer): boolean;
      var i, j: integer;
      begin
        {0 <= k <= k+m <= w}
        i := m; j := 0;
        while i <> j do
        if r.fdigits[i + k] <> dq.fdigits[i]
        then j := i else dec(i);
        result := r.fdigits[i + k] < dq.fdigits[i]
      end;

    procedure difference(var r: TInteger;
                                 dq: TInteger; k, m: integer);
    var borrow, diff, i: integer;
    begin
    {0 <= k <= k+m <= w}
      if length(r.fdigits)<m+k+1 then setlength(r.fdigits,m+k+1);
      if length(dq.fdigits)<m+1 then setlength(dq.fdigits,m+1);
      borrow := 0;
      for i := 0 to m do
      begin
        diff := r.fdigits[i + k] - dq.fdigits[i]
                                 - borrow + baseval;
        r.fdigits[i + k] := diff mod baseval;
        borrow := 1 - diff div baseval
      end;
      if borrow <> 0 then Showmessage('Difference Overflow');
    end;

      procedure longdivide(x, y: TInteger;
                         var q, r: TInteger; const n, m: integer);
      var f, k: integer;
          qt:int64;
      begin
        {2 <= m <= n <= w}
        f := baseval div (y.fdigits[m - 1] + 1);

        product(r, x, f);
        //r.assign(x); r.mult(f);
        product(d, y, f);
        //d.assign(y); d.mult(f);
        q.assign(0);
        setlength(q.fdigits,n-m+1);
        for k := n - m downto 0 do
        begin
          {2 <= m <= k+m <=n <= w}
          qt := trial(r, d, k, m);
          product(dq, d, qt);
          //dq.assign(d); dq.mult(qt);
          if length(dq.fdigits)<M+1 then setlength(dq.fdigits,M+1);
          if smaller(r, dq, k, m) then
          begin
            qt := qt - 1;
            product(dq, d, qt)
            //dq.assign(d); dq.mult(qt);
          end;
          if k>high(q.fdigits) then setlength(q.fdigits,k+1);
          q.fdigits[k] := qt;
          difference(r, dq, k, m)
        end;
        idiv4.assign(r);
        quotient(r,idiv4, f);
        r.trim;
      end;

    procedure division(x, y: TInteger;
                         var q, r: TInteger);
    var m, n, y1: integer;
    begin
      m := y.getlength;
      if m = 1 then
      begin
        y1 := y.fdigits[m - 1];
        if y1 >0 then
        begin
          quotient(q, x, y1);
          remainder(r, x, y1)
        end
        else Showmessage('Division Overflow');
        end
        else
        begin
          n := x.getlength;
          if m > n then
          begin
            q.Assign(0); r := x
          end
          else {2 <= m <= n <= w}
          longdivide(x, y, q, r, n, m)
        end
      end;

  var signout:integer;

  begin
    if sign<>i2.sign then signout:=-1 else signout:=+1;
    sign:=+1;
    i2.sign:=+1;
    if i2.compare(0)=0 then exit;
    if compare(i2)>=0 then  {dividend>=divisor}
    begin
      idivd3.assign(self);
      division(idivd3,i2,self,remain);
      remain.trim;
      trim;
      sign:=signout;
      remain.sign:=signout;
    end
    else
    begin
      remain.assign(self);
      assign(0);
    end;
  end;

{**************** Compare ************}
function TInteger.compare(i2:TInteger):integer;
{Compare - to Tinteger}
{return +1 if self>i2, 0 if self=i2 and -1 if self<i2)}
begin
  if (sign<0) and (i2.sign>0) then result:=-1
  else if (sign>0) and (i2.sign<0) then result:=+1
  else {same sign} result:=abscompare(i2);
end;

{****************** Compare (Int64) *********}
function TInteger.compare(i2:Int64):integer;
{Compare - to int64}
{return +1 if self>i2, 0 if self=i2 and -1 if self<i2)}
var
  i3:TInteger;
begin
  i3:=TInteger.create;
  i3.assign(i2);
  if (sign<0) and (i3.sign>0) then result:=-1
  else if (sign>0) and (i3.sign<0) then result:=+1
  else {same sign} result:=abscompare(i3);
  i3.free;
end;

{************* AbsCOmpare *************}
function TInteger.abscompare(i2:Tinteger):integer;
{compare absolute values ingoring signs - to Tinteger}
var
  i:integer;
begin
  result:=0;
  if length(fdigits)>length(i2.fdigits) then result:=+1
  else if length(fdigits)<length(i2.fdigits) then result:=-1
  else {equal length}
  for i:=high(fdigits) downto 0 do
  begin
    if fdigits[i]>i2.fdigits[i] then
    begin
      result:=+1;
      break;
    end
    else
    if fdigits[i]<i2.fdigits[i] then
    begin
      result:=-1;
      break;
    end;
  end;
end;

{*********** Factorial *******}
procedure TInteger.factorial;
{Compute factorial - number must be less than max integer value}
var
  n:int64;
  i:integer;
begin
  n:=0;
  if (compare(high(integer))>=0) or (sign<0) then exit;
  if compare(0)=0 then
  begin  {0! =1 by definition}
    assign(1);
    exit;
  end;
  for i:= high(fdigits) downto 0 do
  begin
    n:=n*base+fdigits[i];
  end;
  dec(n);
  while n>1 do
  begin
   mult(n);
   dec(n);
   {provide a chance to cancel long running ops}
   if (n mod 64) =0
   then application.processmessages;
  end;
end;

{************** ConvertToDecimalStirng ********}
Function TInteger.ConvertToDecimalString(commas:boolean):string;
  var
    i:integer;
    n:int64;
    c:byte;
    count:int64;
    b:integer;
  begin
    result:='';
    b:=getbasepower;
    if length(fdigits)=0 then assign(0);

    count:=0;  {digit count used to put commas in proper place}
    for i:=0 to high(fdigits) do
    begin
      n:=fdigits[i];
      repeat
        c:=n mod 10;
        n:=n div 10;
        inc(count);
        result:=char(ord('0')+ c) + result;
        if commas and(count mod 3=0) then result:=ThousandSeparator+result;
      until (count mod b =0) or ((i=high(fdigits)) and (n=0));
    end;

    if result[1]=',' then delete(result,1,1); {might have put in one comma too many}
    if result='' then result:='0'
    else if sign<0 then result:='-'+result;
    if result='-0' then result:='0';
  end;


  {********* ConvertToInt64 **********}
  function TInteger.converttoInt64(var n:Int64):boolean;
  var i:integer;
  begin
    result:=false;
    if high(fdigits)<=20 then
    begin
      n:=0;
      for i :=high(fdigits) downto 0  do n:=Base*n+fdigits[i];
      result:=true;
    end;
  end;

  {********* Pow **************}
  procedure Tinteger.pow(const exponent:Int64);
  {raise self to the "exponent" power}
  var i2:tinteger;
      n:int64;
      s:integer;
  begin
    n:=exponent;
    s:=sign;
    if ((s<0) and not(odd(n))) then s:=1;
    sign:=1;
    i2:=TInteger.create;
    i2.Assign('1');
    if(n>=1) then
    if n=1 then i2.assign(self)
    else
    begin
      repeat
        if (n mod 2)=1 then i2.mult(self);
        n:=n div 2;
        mult(self);
      until(n=1) ;
      i2.mult(self);
    end;
    assign(i2);
    sign:=s;
    i2.Free;
  end;


procedure Tinteger.modpow(const i2,m:Tinteger);
{self^I2 modulo m}
var ans,rest,two,e:Tinteger;hulp:integer;
begin
  rest:=Tinteger.create;
  ans:=tinteger.create;
  two:=tinteger.create;
  e:=tinteger.create;
  ans.Assign('1');
  two.assign(2);
  e.assign(i2);
  hulp:=e.compare(1);
  if hulp>=0 then
  if hulp=0 then
  begin
    modulo(m);
    ans.assign(self);
  end
  else
  begin
    repeat
      e.dividerem(two,rest);
      if rest.compare(1)=0 then
      begin
      ans.mult(self);
      //here I went wrong(not altogether, amounts to the same)
      ans.modulo(m);
      end;
      //mult(self);
      square;
      modulo(m);
    until(e.compare(1)=0) ;
    ans.mult(self);
    //here I went wrong I wrote ans.square and that is somethingdifferent
    ans.modulo(m);
  end;
  assign(ans);
  rest.free;
  ans.free;
  two.free;
  e.free;
end;





(*
{*********** SqRoot **********}
procedure Tinteger.sqroot;
{square root}
var a,af,m,hulp:Tinteger;k:integer;
begin
a:=tinteger.create;
af:=tinteger.create;
m:=tinteger.create;
hulp:=tinteger.create;
k:=0;a.assign('0');
af.assign('1');m.assign('1');
while (compare(m)=1) do
  begin
  k:=k+1;
  m.shiftleft;
  m.shiftleft;
  //m.mult(base*base)
end;
while (k>0) do
  begin
  k:=k-1;
  m.shiftright;
  m.shiftright;
  //m.divide(base*base);
  a.shiftleft;
  //a.mult(base);
  af.subtract(1);
  af.shiftleft;
  //af.mult(base);
  af.add(1);
  hulp.Assign(af);
  hulp.mult(m);
  while (compare(hulp)>=0) do
    begin
    subtract(hulp);
    a.add(1);
    af.add(2);
    hulp.Assign(af);
    hulp.mult(m);
    end;
  end;
assign(a);
//remainder in self
a.free;
af.free;
m.free;
hulp.free;
end ;
*)

procedure Tinteger.sqroot;
{square root}
var a,af,m,hulp:Tinteger;k:integer;
begin
a:=tinteger.create;
af:=tinteger.create;
m:=tinteger.create;
hulp:=tinteger.create;
k:=0;a.assign('0');
af.assign('1');m.assign('1');
while (compare(m)=1) do
  begin
  k:=k+1;
  {m.shiftleft;
  m.shiftleft;
  //m.mult(base*base)}
  m.mult(100);
end;
while (k>0) do
  begin
  k:=k-1;
  {m.shiftright;
  m.shiftright;
  //m.divide(base*base);}
  m.divide(100);
  {a.shiftleft;
  //a.mult(base);}
  a.mult(10);
  af.subtract(1);
  {af.shiftleft;
  //af.mult(base);}
  af.mult(10);
  af.add(1);
  hulp.Assign(af);
  hulp.mult(m);
  while (compare(hulp)>=0) do
    begin
    subtract(hulp);
    a.add(1);
    af.add(2);
    hulp.Assign(af);
    hulp.mult(m);
    end;
  end;
assign(a);
//remainder in self
a.free;
af.free;
m.free;
hulp.free;
end ;

{****************** GCD ***************}
procedure Tinteger.gcd(const I2:tinteger);
{greatest common divisor}
var i3,i4:tinteger;
begin
i3:=tinteger.create;
i4:=tinteger.create;
if compare(i2)=1
then
i3.assign(i2)
else
begin
i3.assign(self);
assign(i2)
end;
repeat
modulo(i3);
if compare(0)=1 then
begin
i4.assign(self);
assign(i3);
i3.assign(i4)
end
until compare(0)=0;
assign(i3);
i3.free;
i4.free;
end;

{*************** GCD (Int64) ***********}
procedure Tinteger.gcd(const I2:int64);
var h:tinteger;
begin
  h:=tinteger.create;
  h.Assign(i2);
  gcd(h);
  h.free;
end;

{*********** IsOdd *********}
function Tinteger.isodd:boolean;
{Return true if seld is an odd integer}
begin
  result:=(fdigits[0] mod 2)=1
end;

{************** IsProbablyPrime ***********}
function Tinteger.IsProbablyPrime:boolean;
//miller rabin probabilistic primetest with 10 random bases;
var i2,i3,i4,n_1,one:tinteger; base,lastdigit,j,t,under10:integer;probableprime:boolean;s:int64;

function witness(base:integer;e,n:tinteger):boolean;
var it,h:tinteger; i:integer;
begin
it:=tinteger.create;
h:=tinteger.create;
it.assign(base);
it.modpow(e,n);
witness:=true;
for i:=1 to t do
begin
h.assign(it);
h.square;
h.modulo(n);
if h.compare(one)=0 then
   if it.compare(one)<>0 then
    if it.compare(n_1)<>0 then
    witness:=false;
    it.assign(h);
    end;
   if it.compare(one)<>0 then witness:=false;
it.free;
h.free;
end;

begin
  i2:=tinteger.create;
  i3:=tinteger.create;
  i4:=tinteger.create;
  one:=tinteger.create;
  n_1:=tinteger.create;
  one.assign(1);
  n_1.assign(self);
  n_1.subtract(1);
  i2.assign(self);
  probableprime:=true;
  lastdigit:=i2.shiftright mod 10;
  under10:=compare(10);
  if under10=-1 then
  if (lastdigit<>2) and (lastdigit<>3) and (lastdigit<>5) and (lastdigit<>7) then
  begin
    probableprime:=false ;
  end;
  if under10>=0 then
  begin
    if (lastdigit<>1) and (lastdigit<>3) and (lastdigit<>7) and (lastdigit<>9) then
          probableprime:=false;
    if probableprime then
    begin
      t:=0;
      i3.assign(n_1);
      //i3.subtract(1);
      repeat
      if not(i3.isodd) then
      begin
        inc(t);
        i3.divide(2)
      end;
      until i3.isodd ;

      i2.assign(self);
      j:=1;
      if compare(1000000)>0 then s:=1000000 else i2.converttoInt64(s);
      s:=s-1 ;
      while (j<11) and probableprime do
      begin
        repeat
          base:=random(s);
        until base>1 ;
        probableprime:=witness(base,i3,i2);
        inc(j);
      end;
    end;
  end;
  i2.free;
  i3.free;
  i4.free;
  n_1.free;
  one.free;
  IsProbablyPrime:=probableprime;
end;

{************ InvMod **********}
procedure Tinteger.invmod(I2:Tinteger);
{calculates the number n such that n*self=1 mod I2, result in self}
var  r,q,fn,fv,h,n,m:Tinteger;
begin
  r:=tinteger.create;
  q:=tinteger.create;
  fn:=tinteger.create;
  fv:=tinteger.create;
  h:=tinteger.create;
  n:=tinteger.create;
  m:=tinteger.create;

  n.assign(self);
  m.Assign(I2);
  r.assign(1);
  fv.assign(0);
  fn.assign(1);
  repeat
    q.assign(m);
    q.dividerem(n,r);
    if r.compare(0)>0 then
    begin
      m.assign(n);
      n.assign(r);
    end;
    h.assign(fn);
    fn.mult(q);
    fv.Subtract(fn);
    fn.assign(fv);
    fv.assign(h);
  until(r.compare(0)=0);
  h.add(i2);
  h.modulo(i2);
  assign(h);
  r.free;
  q.free;
  fn.free;
  fv.free;
  h.free;
  n.free;
  m.free;
end;

Initialization
  SetbaseVal(1000);
  randomize;
end.
