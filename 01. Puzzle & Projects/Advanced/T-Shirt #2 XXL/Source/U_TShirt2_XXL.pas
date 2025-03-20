unit U_TShirt2_XXL;
 {Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Back of shirt:
   "The smallest 3 digit number that equals to the sum
   of the cubes of its digits."
 Front of shirt:  ?????

 This program searches out n digit numbers that are equal to the sum
 of the nth powers of its digits.   Brute force works up to about 8 or 9.
 After that run times become excessive and we'll have to find a smarter way.

   A good source for advanced studies, also lists the 88 base 10 Armstrong numbers
        http://www.deimel.org/rec_math/rec_math.htm

    This XXL version aqdds a multisets processing button and a search that
   uses the BigInts unit to do a multiset search for values longer than 19 digits.
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ShellAPI, U_BigInts;

type
  TByteArray=array of byte;
  TForm1 = class(TForm)
    Memo1: TMemo;
    UpDown1: TUpDown;
    Label1: TLabel;
    Edit1: TEdit;
    Memo2: TMemo;
    Brute1Btn: TButton;
    Brute2btn: TButton;
    StopBtn: TButton;
    MultiSetsBtn: TButton;
    Countlbl: TLabel;
    BigIntsBtn: TButton;
    SearchAllBtn: TButton;
    StaticText1: TStaticText;
    procedure Brute1BtnClick(Sender: TObject);
    procedure Brute2btnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MultiSetsBtnClick(Sender: TObject);
    procedure BigIntsBtnClick(Sender: TObject);
    procedure SearchAllBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    public
      loopcount:int64;
      foundcount:integer;
      startTime: TDateTime;
      procedure initsearch(typestr:string);
      procedure updatestats;
    end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

{********************* Brute1BtnClick ***************}
procedure TForm1.Brute1BtnClick(Sender: TObject);
{Brute Force method - just try all n digit numbers and show those that
 meet condition }
var
  j:integer;
  m,mm,p,x:int64;
  tot:int64;
  done:boolean;
  start:int64;
begin
  if updown1.position>19 then
  begin
    showmessage('Maximum of 19 digits for this type of search, try "Big Numbers Search"');
    exit;
  end;
  screen.cursor:=crhourglass; {busy cursor}
  start:=1;
  p:=updown1.position-1;  {n-1, just for convenience}
  initsearch('Brute Force');
  for j:= 1 to p do start:=start*10; {compute "start", smallest n digit number}
  loopcount:=start;
  done:=false;
  starttime:=now;
  {loop from start to 10*start-1, all n digit numbers}
  while (tag=0) and (loopcount<start*10) and (not done) do
  begin
    m:=loopcount;
    tot:=0;
    while m>0 do {the heart of the matter}
    begin
      mm:=m mod 10; {get units digit}
      x:=mm;
      for j:=1 to p do x:=x*mm; {raise it to nth power}
      tot:=tot+x; {add it to total}
      if tot>loopcount then break;  {might as well stop checking if total gets too big}
      m:=m div 10; {divide by 10 to get next prior digit}
    end;
    if (m=0) and (tot=loopcount) then
    begin
      memo2.lines.add(inttostr(loopcount)+ format('  %6.1f seconds',[(now-starttime)*secsperday]));
      inc(loopcount);
      inc(foundcount);
    end
    else inc(loopcount);
    if (loopcount mod 4096)=0 then
    begin
     countlbl.caption:= format('%6d tested in %6.1f seconds',
                    [loopcount,(now-starttime)*secsperday]);
     application.processmessages;
    end;
  end;
  updatestats;
  screen.cursor:=crdefault; {normal cursor}
end;

{********************** Brute2BtnClick ***************}
procedure TForm1.Brute2btnClick(Sender: TObject);
{We really only use 10 values of the digits 0-9 the the nth power for
 the summing part. What if we just precalculate the 10 values and put them
 in a table and use them for summing?}
  var
    j,k,p:integer;
    m,mm:int64;
    tot:int64;
    done:boolean;
    start:int64;
    pwrs:array[0..9] of int64;
    starttime:TDateTime;
begin
  if updown1.position>19 then
  begin
    showmessage('Maximum of 19 digits for this type of search, try "Big Numbers Search"');
    exit;
  end;
  screen.cursor:=crHourglass; {busy cursor}
  start:=1;
  initsearch('Smarter Brute Force');
  p:=updown1.position-1;  {p=n-1 for convenience}
  {Calculate the values of 0 through 9 to the (P+1)th power}
  for j:=0 to 9 do pwrs[j]:=j;
  for j:= 1 to p do
  begin
    start:=start*10;
    for k:=0 to 9 do pwrs[k]:=pwrs[k]*k;
  end;
  loopcount:=start;
  done:=false;
  starttime:=now;
  tag:=0;
  {same brute force code as above except sum pwrs[n] instead of recalculating}
  while (tag=0) and (loopcount<start*10) and (not done) do
  begin
    m:=loopcount;
    tot:=0;
    while m>0 do
    begin
      mm:=m mod 10;
      tot:=tot+pwrs[mm];
      if tot>loopcount then break;
      m:=m div 10;
    end;
    if (m=0) and (tot=loopcount) then
    begin
       {done:=true;} {set done:=true to stop after 1st success}
       memo2.lines.add(inttostr(loopcount)+ format('%6.1f seconds',[(now-starttime)*secsperday]));
       inc(loopcount);
       inc(foundcount);
    end
    else inc(loopcount);
    if (loopcount mod 4096)=0 then
    begin
     countlbl.caption:= format('%6d tested in %6.1f seconds',[loopcount,(now-starttime)*secsperday]);
     application.processmessages;
    end;
  end;
  updatestats;
  screen.cursor:=crdefault; {normal cursor}
end;



{********************** MultisetsBtnClick ****************}
procedure TForm1.MultiSetsBtnClick(Sender: TObject);
{Here's the fastest search technique so far -
 it takes advantage of the fact that any permutation of N digits will have
 the same sum of Nth powers.  So there's really no need to check all of the
 permutations.  If we can generate the unique subsets that represent posible
 N digit numbers (called multisets), we can calculate the sums of powers and
 see if the digits in the sum exactly match the digits summed.
 If so, it's a solution!  (But it only works for values that fit in Int64, less
 than 20 digits long.)
 }
var
  pwrs:array[0..9] of int64;
  i,j,k,p,m:integer;
  tot,val, minval:int64;
  found:boolean;
  n, copyn:array of integer;

  function isSelected(var n:array of integer; m:integer):boolean;
  {is m in n?, if so erase it from n so we don't match it next time}
  var
    i:integer;
  begin
    result:=false;
    for i:= 0 to high(n) do
    if n[i]=m then
    begin
      result:=true;
      n[i]:=-1 ;
      break;
    end;
  end;


  function getnextmultiset(var n:array of integer):boolean;
  {Generate the next multiset from array N.  Size of multiset
   is determined by the size of dynamic array N.  The total
   set size to select from is assumed to be 10 (0-9)}
  var
    i,j,lim:integer;
    done:boolean;
  begin
    j:=high(n);
    done:=false;
    repeat
      if j>0 then lim:=n[j-1] else lim:=9;
      if n[j]< lim then
      begin
        inc(n[j]);
        for i:=j+1 to high(n) do n[i]:=0;
        done:=true;
      end
      else
      begin
        dec(j);
        if j<0 then done:=true;
      end;
    until done;
    result:=j>=0;
  end;

begin
  if updown1.position>19 then
  begin
    showmessage('Maximum of 19 digits for this type of search, try "Big Numbers Search"');
    exit;
  end;
  screen.cursor:=crHourglass; {busy cursor}
  p:=updown1.position;
  initsearch('Multisets');

  setlength(n,p);
  setlength(copyn,p);
  for j:=0 to 9 do pwrs[j]:=j;
  minval:=1;
  for j:= 1 to p-1 do
  begin
    minval:=minval*10;
    for k:=0 to 9 do pwrs[k]:=pwrs[k]*k; {do this p-1 times to get Pth powers}
    n[j]:=9;
  end;
  n[0]:=0;
  {the main loop}
  while (tag=0) and getnextmultiset(n) do
  begin
    for i:=0 to high(n) do copyn[i]:=n[i];
    tot:=0;   {get the sums of powers of the digits}
    for j:=0 to high(n) do
    tot:=tot+ pwrs[n[j]];
    if tot>=minval then {check it if it's an n digit number (no leading 0)}
    begin
      {see if all of the numbers in this power sum match the numbers in the mult-set}
      val:=tot;
      found:=true;
      for i:=1 to p do
      begin
        m:=val mod 10;
        if not isselected(copyn, m) then
        begin
          found:=false;
          break;
        end;
        val:=val div 10;
      end;
      if found then
      begin
        memo2.lines.add(inttostr(tot)+ format('  %8.1f seconds',[(now-starttime)*secsperday]));
        inc(foundcount);
     end;
    end;
    inc(loopcount);
    if (loopcount mod 4096)=0 then
    begin
     countlbl.caption:= format('%6d tested in %6.1f seconds',[loopcount,(now-starttime)*secsperday]);
     application.processmessages;
    end;
  end;
  updatestats;
  screen.cursor:=crDefault; {back to standard cursor}
end;



{************************ BigIntsBtnClick *****************}
procedure TForm1.BigIntsBtnClick(Sender: TObject);
{Here's where we try BigInt processing with multiset approach. Could let us get to
 that 39 digit number. Too bad it's sooooo sloooow, 20 times slower than using
 Int64}
var
  pwrs:array[0..9] of array [1..40] of TInteger;
  i,j,k,p:integer;
  tot:TInteger;
  found, done:boolean;
  starttime:TDateTime;
  maxreps:array [0..9] of integer;  {maximum occurences of a digit (0-9) before
                                     sum of powers gets too big}
  work:TInteger;
  {cn is an array of counts of occurrences of digits in the multiset.
      We don't really need the multisets, just counts of how many times
      each digit occurs.  Getnext generates counts in reverse order,
      i.e. cn[0] is the number of 9's in the set, cn[1] then number of 8's, etc.

   copycn is a reversed copy of cn used when checking if digits in sum match
      digits in the multiset.
  }
  cn,copycn:array[0..9] of integer;
  start:integer;

function getnext(var d:array of integer; var start:integer):boolean;
var
  xfr:integer;
begin
  result:=true;
  if d[start]>0 then
  begin
    dec(d[start]);
    inc(start);
    If start<=high(d) then
    begin
      inc(d[start]);
      exit;
    end
    else
    begin
      dec(start);
      xfr:=1+d[start];
      d[start]:=0;
      dec(start);
      while (start>=0) and (d[start]=0) do dec(start);
      if start>=0 then
      begin
        if start<high(d) then
        begin
          dec(d[start]);
          inc(start);
          inc(d[start],xfr+1);
          exit;
        end
        else result:=false;
      end
      else result:=false;
    end;
  end
  else result:=false;
end;

begin
  screen.cursor:=crHourglass; {set busy cursor}
  {initialization stuff}
  initsearch('Big Integer');
  p:=updown1.position; {p=nbr of digits in nbrs}
  for j:=0 to 9 do
  begin
    for k:=1 to 40 do pwrs[j,k]:=TInteger.create;
    pwrs[j,1].assign(j);
  end;
  {get the smallest possible sum of powers that contains p digits}
  {compute the pth power of digits 0-9}
  for k:=0 to 9 do for j:=1 to p-1 do pwrs[k,1].mult(k);
  for j:= 1 to p do
  begin
    for k:=0 to 9 do
    begin
      pwrs[k,j].Assign(pwrs[k,1]);
      pwrs[k,j].mult(j);
    end;
  end;
  work:=tinteger.create;

  {compute max repetitions for this power, before sum gets longers than original
   number}
  for i:= 1 to 9 do
  begin
    j:=0;
    work.assign(0);
    while (j<=p) and (length(work.digits)<=p) do
    begin
      work.add(pwrs[i,1]);
      inc(j);
    end;
    maxreps[i]:=j-1;
  end;
  maxreps[0]:=100; {no limit on max nbr of zeros in the number}
  work.free;
  starttime:=now;
  tot:=TInteger.create;
  cn[0]:=p;
  for i:=1 to 9 do cn[i]:=0;
  start:=0;

  {Start main testing loop - finally}
  while (tag=0) and getnext(cn,start) do
  begin
    done:=false;
    for j:=low(cn) to high(cn) do
    begin
      if (cn[j]>maxreps[9-j]) then
      begin
        done:=true;
        break;
      end;
    end;
    if not done then
    begin
      tot.assign(0);   {accumulate the sum of powers of the digits}
      for j:=0 to 9 do
      begin
        if cn[j]>0 then tot.add(pwrs[9-j,cn[j]]);
        if length(tot.digits)>p then
        begin
          done:=true;
          break;
        end;
      end;
    end;
    if not done then
    begin
      {If sum was too small (<p digits), all the rest will be even smaller, so stop}
      if length(tot.digits)<p then tag:=-1;

      {see if all of the numbers in this power sum match the numbers in the mult-set}
      found:=true;
      {we need cn to generate next counts, so copy it over, reversed so 9's
        count is in the 9th position, etc. }
      for i:=0 to 9 do copycn[9-i]:=cn[i];
      for i:=0 to p-1 do
      begin
        if copycn[tot.digits[i]]= 0 then {oh-oh, no match for this digit}
        begin  found:=false; break; end  {so stop checking}
        else dec(copycn[tot.digits[i]]); {reduce count for matched digit}
      end;
      {done checking!  Did we find one?}
      if found  then
      begin
        memo2.lines.add(tot.convertToDecimalString(true)
                   + format(' %8.1f seconds',[(now-starttime)*secsperday]));
        inc(foundcount);
      end;
    end;
    inc(loopcount);
    if (loopcount mod 4096)=0 then
    begin
     countlbl.caption:= format('%6d tested in %6.1f seconds',[loopcount,(now-starttime)*secsperday]);
     application.processmessages;
    end;
  end; {end main loop}
  updatestats;
  screen.cursor:=crDefault; {back to standard cursor}
  for j:=0 to 9 do  for k:=1 to 40 do pwrs[j,k].free;
  tot.free;
end;

{***************** SearchAllBtnClick *************}
procedure TForm1.SearchAllBtnClick(Sender: TObject);
var i:integer;
    starttime:TTime;
    cumcount:integer;
begin
  tag:=0;
  starttime:=now;
  cumcount:=0;
  for i:= 1 to 39 do
  begin
    If tag>0 then break;
    updown1.position:=i;
    if i<=19 then multisetsbtnclick(sender)
    else bigIntsBtnClick(Sender);
    cumcount:=cumcount+foundcount;
    memo2.lines.add('Time so far (hh:mm:s) '+ formatdatetime('hh:nn:ss', now-startTime)
                   + ', Total # found so far: '+ inttostr(cumcount));
  end;

end;

{******************** StopBtnClick *************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;{program loops will check for this value to abort processing}
end;

{*************** FormCloseQuery ****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   tag:=1; {stop any running calculations if users wants to close}
   canclose:=true;
end;

{*********************** InitSearch ****************}
procedure TForm1.initsearch(typestr:string);
{Common search initialzation stuff}
begin
  starttime:=now;
  loopcount:=0;
  foundcount:=0;
  tag:=0;
  memo2.lines.add('');
  memo2.lines.add(typestr+ ' search for numbers of size '+inttostr(updown1.position));
end;

{****************** UpdateStats *************}
procedure TForm1.updatestats;
  var  r:real;
{Display statistics at end of a search}
begin
  r:=(now-starttime)*secsperday;
  if r>0 then
    countlbl.caption:=format('%3d found, %6d tested in   %8.1f seconds, Rate: %8.1f',
                      [foundcount, loopcount,r, loopcount/r])
  else countlbl.caption:=format('%3d found, %6d tested in   %8.1f seconds',
               [foundcount, loopcount,r]);
  memo2.lines.add(countlbl.caption);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
