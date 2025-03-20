unit UBigFloatV2;

 {Copyright  © 2003-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


interface

uses
  Forms, Sysutils, Dialogs, UBigIntsV2;

type
    TView=(normal,Scientific);

    TBigFloat= class(tobject)
    {Numbers will be converted internally to a decimal number between -1 and +1
    and a power of 10 required to reproduce the original value. (.xxxxxx * 10^exponent).
     xxxxxx is a TInteger type, arbitrarily large integer. }
      decpart:TInteger;
      sigdigits:integer; {how many significant digits too show}
      exponent:integer;  {restrict exponents to integers}

    constructor create;
    procedure SetSigdigits(newsigdigits:integer);
    destructor destroy; override;
    function getnumber(s:string):boolean;
    function shownumber(View:TView):string;
    procedure assign(A:TBigFloat); overload;
    procedure assign(A:TInteger); overload;
    procedure assign(N:Int64); overload;


    procedure add(B:TBigFloat);
    procedure absadd(B:TBigFloat);
    procedure subtract(B:TBigFloat); overload;
    procedure subtract(B:int64); overload;

    procedure mult(B:TBigFloat);
    procedure divide(B:TBigFloat; maxsig:integer); overload;
    procedure divide(B:TInteger; maxsig:integer);  overload;
    procedure sqrt;
    procedure split(var ldp,rdp:integer);
    procedure round;
    function intpart:int64;
 end;

implementation

uses math;

{************* Create ***********}
Constructor TBigFloat.create;
begin
  inherited;
  sigdigits:=16; {default significant digits}
  decpart:=TInteger.create;  {Tinteger version of digits in the number}
  exponent:=0;
end;

{*************** SetSigdigits **********}
procedure TBigFloat.SetSigdigits(newSigdigits:integer);
{change the max number of digits to display}
begin  sigdigits:=newsigdigits;  end;

{************* Destroy **************}
Destructor TBigFloat.destroy;
begin
  decpart.free;
  inherited destroy;
end;

{***************** GetNumber ***************}
function TBigFloat.getnumber(s:string):boolean;
{Convert a string representation of a floating point number into internal format}
var
  i:integer;
  decimalfound:boolean;
  eFound:boolean;
  nStr,expStr:string;
  error:string;
  sign:integer;
begin
  decimalfound:=false;
  efound:=false;
  NStr:='';
  ExpStr:='';
  error:='';
  result:=true;
  sign:=+1;
  s:=trim(s); {remove leading  & trailing blanks}
  for i:=1 to length(s) do
  begin
    case s[i] of
     '0'..'9':
     begin
       if not efound then
       begin
         nstr:=nstr+s[i];
         if decimalfound then dec(exponent)
       end
       else  expstr:=expstr+s[i];
     end;
     '+','-':
     begin
       if (i=1) or ((i>1) and (upcase(s[i-1])='E')) then
       begin
         if (i=1) and (s[i]='-') then sign:=-1 {nstr:='-'}
         else if (i>1) and  (s[i]='-') and (upcase(s[i-1])='E') then expstr:='-'
       end
       else error:='Misplaced + or - sign';
     end;
     'e','E': eFound:=true;
     '.':  decimalfound:=true;
     ',',' ':  begin end;
     else
     begin
       error:='Invalid character in number';
     end;
    end;
    if error<>'' then
    begin
      showmessage(error);
      result:=false;
      break;
    end;
  end;
  {convert nStr bigInt and expStr to integer}
  if length(expstr)>0 then exponent:=exponent+strtoint(expstr);
  while (length(nstr)>0) and (nstr[1]='0') do delete(nstr,1,1);
  exponent:=exponent+length(nstr);
  if sign<0 then nstr:='-'+nstr;
  decpart.assign(nstr);
end;

{****************** ShowNumber **********}
function TBigFloat.shownumber(view:TView):string;
{Build a string representation of the number in Normal or Scientific format}
var s,ss:string;
    i,n:integer;
    sign:integer;
begin
  s:=decpart.converttodecimalstring(false);

  if s[1]='-' then
  begin
    delete(s,1,1);
    sign:=-1;
  end
  else sign:=+1;

  if view=scientific  then
  begin
    if length(s)>sigdigits then delete(s,sigdigits+2,length(s)-sigdigits-1);
    if sign<0 then result:='-' else result:='';
    result:=result+s[1];
    delete(s,1,1);
    if length(s)=0 then s:='0';
    result:=result+ '.' + s;
    n:= pos('.',result);
    if n>0 then
         while (length(result)>N+1) and (result[length(result)]='0')
         do delete(result,length(result),1);
    result:=result+ ' E ' + inttostr(exponent-1)
  end
  else
  begin {normal}
    if length(s)>sigdigits then delete(s,sigdigits+1,length(s));
    if max(length(s),abs(exponent))>sigdigits then result:='****' else
    begin
      If sign<0 then  ss:='-' else ss:='';
      if exponent>0 then
      begin
        if exponent<length(s) then insert('.',s,exponent+1)
        else while length(s)<exponent do s:=s+'0';
      end
      else
      begin
        for i:= 1 to -exponent do s:='0'+s;
        s:='0.'+s;
      end;
      result:=ss+s;
      n:= pos('.',result);
      if n>0 then
         while (length(result)>n+1) and (result[length(result)]='0')
         do delete(result,length(result),1);
    end;
  end;
end;

{******************* Assign ****************}
procedure TBigFloat.assign(A:TBigFloat);
{assign "A" to "self"}
begin
  decpart.assign(a.decpart);
  {if a.sigdigits>sigdigits then } sigdigits:=a.sigdigits;
  exponent:=a.exponent;
end;

{******************* Assign ****************}
procedure TBigFloat.assign(A:TInteger);
{assign "A" to "self"}
begin
  decpart.assign(a);
  sigdigits:=a.digitcount;
  exponent:=a.digitcount;
end;

{******************* Assign ****************}
procedure TBigFloat.assign(N:Int64);
{assign "A" to "self"}
var a:TInteger;
begin
  a:=TInteger.create;
  a.assign(N);
  assign(a);
  a.free;
end;



{********************* Split *******************}
procedure TBigfloat.split(var ldp,rdp:integer);
{count digits to left and right of implied decimal point}

{ Examples:
  .12345 E -2 = .0012345;   Ldp:=0, Rdp=7
  .12345 E 2  = 12.345;     Ldp=2, Rdp=3
  .12345 E 8  = 12345000.   LDp=8, Rdp=0
 }
begin
  if exponent>=0 then
  begin
    ldp:=exponent;
    rdp:=decpart.digitcount-ldp;
  end
  else
  begin
    rdp:=decpart.digitcount-exponent;
    ldp:=0;
  end;
end;

{****************** Add **************}
procedure TBigFloat.add(B:TBigFloat);
var
  i:integer;
  ldp1,rdp1:integer;
  ldp2,rdp2:integer;
begin

  split(ldp1,rdp1);  {count digits left and right of decimal point}
  b.split(ldp2,rdp2);

  {align on "virtual" decimal points by adding extra 0's to the one with
   fewest digits to the right of the decimal point (by multiplying by 10)}
  if rdp1>rdp2 then for i:=1 to rdp1-rdp2 do  b.decpart.mult(10)
  else
  if rdp2>rdp1 then  for i:=1 to rdp2-rdp1 do decpart.mult(10);
  rdp1:=max(rdp1,rdp2); {The new number of digits to the right of the dec. pt
                         after lining up the dec. pts on the two numbers}
  decpart.Add(b.decpart);  {Now add them!}
  {The new exponent is the new number of points top the left of the decimal
   point, which is total digits minus the number of digits to the right of d.p.}
  exponent:=decpart.digitcount-rdp1;
end;

{****************** AbsAdd **************}
procedure TBigFloat.absadd(B:TBigFloat);
var  s1,s2:integer;
begin
  s1:=decpart.getsign; decpart.setsign(+1);
  s2:=b.decpart.getsign; b.decpart.setsign(+1);
  add(b);
  decpart.setsign(s1);
  b.decpart.setsign(s2);
end;

{*************** Subtract ***************}
procedure TBigFloat.subtract(B:TBigFloat);
{subtract B by changinging its sign and adding}
begin
   b.decpart.changesign;
   add(b);
   b.decpart.changesign;
end;

{*************** Subtract ***************}
procedure TBigFloat.subtract(B:Int64);
{subtract B by changinging its sign and adding}
var temp:TBigFloat;
begin
   temp:=TBigFloat.create;
   temp.assign(B);
   subtract(temp);
   temp.free;
end;

{****************** Mult **************}
procedure TBigFloat.mult(B:TBigfloat);
{multiply two numbers}
var n,i,k,start:integer;
begin
  {maybe just multiply the two fractional parts and add the exponents?}
  n:=decpart.digitcount+b.decpart.digitcount;
  decpart.mult(b.decpart);
  {new exponent is sum of the exponents plus the increase in digit count}
  inc(exponent,b.exponent+decpart.digitcount-n);
  {trim the length? keeps the product from growing indefinitely in loops (eq in divide op)  }
  if n>2* sigdigits then
  with decpart do
  begin
    k:=0;
    start:=(n-3*sigdigits) div getbasepower;
    if start>0 then
    begin
      for i:= start to high(digits) do
      begin
        digits[k]:=digits[i];
        inc(k);
      end;
      setdigitlength(k);
    end;
  end;
end;

(*

{************************ Divide ****************}
procedure TBigFloat.divide(B:TBigfloat; maxsig:integer);
{divide by b}
var
  maxBigFloat, top, bottom:TBigFloat;
  GuessB, Testvalue,diff:TBigFloat;
  half:TBigFloat;
  count:integer;
  savesign1,savesign2:integer;
begin
  if b.decpart.compare(0)=0 then
  begin
    showmessage('Can''t divide by 0');
    exit;
  end;
  if decpart.compare(0)=0 then exit;  {0 divided by anything is still 0!}

  MaxBigFloat:=TBigFloat.create; MaxBigFloat.Setsigdigits(maxsig);
  maxbigfloat.getnumber('1E'+inttostr(exponent-b.exponent+1));
  top:=TBigFloat.create; Top.Setsigdigits(maxsig);
  Bottom:=TBigFloat.create;  Bottom.Setsigdigits(maxsig);

  Testvalue:=TBigFloat.create; Testvalue.setsigdigits(maxsig);
  Diff:=TBigFloat.create; Diff.setsigdigits(maxsig);
  Guessb:=TBigFloat.create; GuessB.setsigdigits(maxsig);
  half:=TBigFloat.create; half.SetSigdigits(maxsig);
  half.getnumber('0.5');
  savesign1:=decpart.getsign; decpart.setsign(+1);
  savesign2:=b.decpart.getsign; b.decpart.setsign(+1);

  count := 0;
  Top.assign(MaxBigFloat);
  Bottom.getnumber('0');
  repeat;
    GuessB.assign(top);
    Guessb.add(bottom);
    guessb.mult(half);
    TestValue.assign(GuessB);
    Testvalue.mult(b);
    Diff.assign(testvalue);
    diff.subtract(self);
    if Diff.decpart.ispositive then top.assign(GuessB) else bottom.assign(GuessB);
    inc(count);
    {application.processmessages;} {to allow tag to be set in  case divide is to be aborted}
  until (count > 1000) or (Diff.exponent < -maxsig-2) {or (application.tag<>0)};
  assign(guessb);
  if count>1000 then  showmessage('Warning - accuracy may be lost in divide operation');
  maxBigFloat.free;  top.free;  bottom.free;
  GuessB.free;  Testvalue.free; diff.free;
  half.free;
  if savesign1=savesign2 then decpart.setsign(+1) else decpart.setsign(-1);
end;
*)


{************************ Divide ****************}
procedure TBigFloat.divide(B:TBigfloat; maxsig:integer);
{divide by b}
var
  maxBigFloat, top, bottom:TBigFloat;
  GuessB, Testvalue,diff:TBigFloat;
  half:TBigFloat;
  count:integer;
  savesign1,savesign2:integer;
begin
  if b.decpart.compare(0)=0 then
  begin
    showmessage('Can''t divide by 0');
    exit;
  end;
  if decpart.compare(0)=0 then exit;  {0 divided by anything is still 0!}

  MaxBigFloat:=TBigFloat.create; MaxBigFloat.Setsigdigits(maxsig);
  maxbigfloat.getnumber('1E'+inttostr(exponent-b.exponent+1));
  top:=TBigFloat.create; Top.Setsigdigits(maxsig);
  Bottom:=TBigFloat.create;  Bottom.Setsigdigits(maxsig);

  Testvalue:=TBigFloat.create; Testvalue.setsigdigits(maxsig);
  Diff:=TBigFloat.create; Diff.setsigdigits(maxsig);
  Guessb:=TBigFloat.create; GuessB.setsigdigits(maxsig);
  half:=TBigFloat.create; half.SetSigdigits(maxsig);
  half.getnumber('0.5');
  savesign1:=decpart.getsign; decpart.setsign(+1);
  savesign2:=b.decpart.getsign; b.decpart.setsign(+1);

  count := 0;
  Top.assign(MaxBigFloat);
  Bottom.getnumber('0');
  repeat;
    GuessB.assign(top);
    Guessb.add(bottom);
    guessb.mult(half);
    TestValue.assign(GuessB);
    Testvalue.mult(b);
    Diff.assign(testvalue);
    diff.subtract(self);
    if Diff.decpart.ispositive then top.assign(GuessB) else bottom.assign(GuessB);
    inc(count);
    application.processmessages;
  until (count > 2000) or (Diff.exponent < -maxsig-2) or (application.tag<>0);
  assign(guessb);
  if count>1000
  then  showmessage('Warning - accuracy may be lost in divide operation');
  maxBigFloat.free;  top.free;  bottom.free;
  GuessB.free;  Testvalue.free; diff.free;
  if savesign1=savesign2 then decpart.setsign(+1) else decpart.setsign(-1);
end;

procedure TBigFloat.divide(B:TInteger; maxsig:integer);
var  FloatB:TBigFloat;
begin
  floatb:=TBigfloat.create;
  floatb.assign(b);
  floatb.setsigdigits(maxsig);
  divide(floatb, maxsig);
  floatb.free;
end;


procedure TBigFloat.sqrt   ;
(*
   a and b are given by the recurrence relations
     a[i]=a[i-1]+N*b[i-1]
     b[i=[a[i-1]+b [i-1]
   with a[1]=b[1]=1. The error obtained using this method is   1/(2b^2)
*)
var
  a1,b1:TInteger;
  a2,b2:TInteger;
  errlim:Integer;
  savesigdigits:integer;
begin
  if length(decpart.digits)>0 then
  begin
    savesigdigits:=sigdigits;
    errlim:=sigdigits ;
    a1:=TInteger.create;  b1:=TInteger.create;
    a2:=TInteger.create;  b2:=Tinteger.create;
    a1.assign(1); b1.assign(1);
    repeat
      a2.assign(b1); a2.mult(self.decpart); a2.add(a1);
      b2.assign(a1); b2.add(b1);
      a1.assign(a2);  b1.assign(b2);
    until b2.digitcount>errlim;
    assign(a2); setsigdigits(savesigdigits); divide(b2,sigdigits);
    a1.free; a2.free; b1.free; b2.free;
  end;
end;


{******************** Round ***************}
procedure TBigFloat.round;
{round number to specified nbr of significant digits}
var
  i,n:integer;
  r:TBigFloat;
  s:string;
  signchar:char;
begin
  if decpart.digitcount>sigdigits then
  begin
    s:=decpart.converttodecimalstring(false);
    {if exponent <0 put that many 0's in front of it}
    signchar:='+';
    if s[1]='-' then
    begin
      signchar:='-';
      delete(s,1,1);
    end;
    If exponent<0 then for i:= 1 to -exponent do s:='0'+s;
    delete(s,sigdigits+2,length(s));
    n:=10-strtoint(s[sigdigits+1]);
    decpart.assign(signchar+s);
    if n<=5 then
    begin
      {get rid of those pesky extra digits}
      r:=TBigfloat.create;
      If exponent>=0 then r.getnumber(inttostr(n)+'E'+inttostr(-sigdigits-1+exponent))
      else r.getnumber(inttostr(n)+'E'+inttostr(-sigdigits-1));
      {showmessage(r.shownumber(scientific));}
      absadd(r);
      r.free;
    end;
  end;
end;

function tbigfloat.intpart:int64;
var s:string;
    n:integer;
begin
  s:=shownumber(normal);
  n:=pos('.',s);
  if n=0 then n:=length(s)+1;
  result:=strtoint(copy(s,1,n-1));
end;


end.
