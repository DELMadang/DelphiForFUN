unit U_Interesting2013;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Spin;

type
    TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo2: TMemo;
    Panel1: TPanel;
    Case1Btn: TButton;
    Label1: TLabel;
    NbryearsUD: TSpinEdit;
    StartYearUD: TSpinEdit;
    NbrConsecUD: TSpinEdit;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel2: TPanel;
    Label10: TLabel;
    Case2ABtn: TButton;
    StartYear2UD: TSpinEdit;
    UniqueBox: TCheckBox;
    Label11: TLabel;
    RichEdit1: TRichEdit;
    Label3: TLabel;
    Memo1: TMemo;
    Label7: TLabel;
    Case2BBtn: TButton;
    Label8: TLabel;
    TermMultGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure Case1BtnClick(Sender: TObject);
    procedure Case2ABtnClick(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Case2BBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    terms, termsq:array[1..6] of integer;
    maxval, nbrcombos:integer;
    sign,key:string;
    keylist:TStringlist;  {a list of found solutions to eliminate reporting duplicates}
    counts:array[1..6] of integer;  {solution counts by nbr of terms}
    startyear:integer;

    function FindSolution2(var s:string):integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses mathslib, DFFUtils, UComboV2;


{***************** Case1BtnClick *******************}
procedure TForm1.Case1BtnClick(Sender: TObject);
var
  i,j,k:integer;
  n:integer;
  ok:boolean;
  s:string;
begin
  memo2.clear;
  memo2.lines.add(format('Searching for %d consecutive years from %d to %d with the same number of prime factors',
                  [Nbrconsecud.value, StartyearUD.value, startYearUD.value+NbryearsUD.value-1]));
  with primes do
  for i:=startYearUD.value  to StartYearUD.value+NbrYearsUd.value-1 do
  begin
    ok:=true;
    for j:=0 to NbrConsecUD.value-1 do
    begin
      getfactors(i+j);
      if uniquebox.Checked then
      for k:=2  to nbrfactors do
      begin {check the array of factors for duplicates}
        if factors[k]=factors[k-1] then
        begin
          OK:=false;
          break;
        end;
      end;
      if OK then
      begin
        if j=0 then n:=nbrfactors;
        if nbrfactors<>n then
        begin
          ok:=false;
          break;
        end
      end;
    end;
    if Ok then with memo2.lines do
    begin
      Add('');
      for j:=0 to NbrconsecUD.value-1 do
      begin
        getfactors(i+j);
        s:='';
        for k:=1 to nbrfactors do
        begin
          s:=s+inttostr(factors[k]);
          if k<nbrfactors then s:=s+', ';
        end;
        add(format('The %d prime factors in %d are %s',[n,i+j,s]));
      end;
    end;
  end;
  scrolltotop(memo2);
end;


var
  bitmask:array[1..6] of integer =  (1,2,4,8,16,32);
  maxmaxterms:integer=6;
  termMult:integer=1;  {Max termisize limited to TermMult*Startyear}

{************** Case2ABtnClick ***********}
procedure TForm1.Case2ABtnClick(Sender: TObject);
var
  i,n:integer;
  count:integer;
  loopcount:integer;
  starttime:TDateTime;
  s:string;
  primestotest:integer;
  maxterms:integer;
begin
  if Case2ABtn.Caption='Stop' then tag:=1
  else
  begin
    tag:=0;
    Case2ABtn.Caption:='Stop';
    memo2.clear;
    memo2.lines.add('Finding the shortest expression made up of sums and differences of prime '
     + 'squares and which evaluate to the given year. (1st 10 of each length from '
     + '1 to 6 are displayed)');

    keylist:=TStringlist.create;
    keylist.sorted:=true;
    startyear:= startyear2UD.value;
    termMult:=TermMultGrp.ItemIndex+1;
    maxval:=trunc(sqrt(termMult*startyear))+1;
    n:=maxval;
    while (n>=1) and (primes.prime[n]>maxval) do dec(n);
    PrimesToTest:=n;
    for i:=1 to maxmaxterms do
    begin
      terms[i]:=0;
      termsq[i]:=0;
      counts[i]:=0;  {to hold solution counts by size}
    end;
    loopcount:=0;
    starttime:=now;
    screen.Cursor:=crhourglass;
    with combos do
    for maxterms := 1 to maxmaxterms do
    begin
      setup(maxterms,primestotest,CombinationsRepeat);
      nbrcombos:=intpower(2,maxterms)-1;
      while getnext do
      begin
        inc(loopcount);
        if loopcount and $3F =0 then
        begin
          application.ProcessMessages;
          if self.tag<>0 then break;
        end;
        count:=FindSolution2(s);
        if (count>0) and (counts[count]<=10)
        then memo2.lines.add( inttostr(count)+' terms: '+s);
        if self.tag<>0 then break;
      end;
    end;

    keylist.free;
    for i:=1 to maxmaxterms do memo2.Lines.Add(format('%d terms: %.0n solutions',[i, 0.0+counts[i]]));
    memo2.lines.add(format('Runtime %.1f seconds',[(now-starttime)*secsperday]));
    scrolltotop(memo2);
  end;
  screen.Cursor:=crdefault;
  Case2ABtn.Caption:='Case 2A Search';
end;

{*********** Case2BBtnClick *************}
procedure TForm1.Case2BBtnClick(Sender: TObject);
{Find the smallest number requiring 6 terms}
var
  i,n:integer;
  solcount:integer;
  starttime:TDateTime;
  s, plural:string;
  loopcount:integer;
  primestotest:integer;
  maxterms:integer;
  statline:integer;  {line # for progress display}

    function allfilled:boolean;
    var
      i:integer;
    begin
      result:=true;
      for i:= 1 to maxmaxterms do if counts[i]=0 then
      begin
        result:=false;
        break;
      end;
    end;

begin
  if Case2BBtn.Caption='Stop' then  tag:=1
  else
  with memo2, lines do
  begin
    {initial setup things}
    self.tag:=0;
    Case2BBtn.Caption:='Stop';
    clear;
    add('Finding smallest Years requiring sum/difference of 1 through 6 terms');
    if termmultGrp.itemindex=0 then s:='' else s:=' two times ';
    add(format('Each term must be a prime square not greater than %s the year being tested.',[s]));
    add('');
    add(format('Starting year is %d and upper limit for testing is 10,000.',[startyearUD.value]));
    Statline:=count;
    add('');
    add('');

    keylist:=TStringlist.create;
    keylist.sorted:=true;
    startyear:= startyear2UD.value-1;
    termMult:=TermMultGrp.itemindex + 1;
    screen.Cursor:=crhourglass;
    starttime:=now;
    for i:=1 to maxmaxterms do counts[i]:=0;  {to hold solution counts by size}
    {in this case when count for a size is >0 then we no longer need to process
     that value for expressions with number of terms  because we have already
     found the smallest}
    repeat
      inc(StartYear);
      lines[statline]:='Testing year '+inttostr(startyear);

      maxval:=trunc(sqrt(termmult*startyear))+1;
      n:=maxval;
      while (n>=1) and (primes.prime[n]>maxval) do dec(n);
      PrimesToTest:=n;
      for i:=1 to maxmaxterms do
      begin
        terms[i]:=0;
        termsq[i]:=0;
      end;
      keylist.Clear;
      loopcount:=0;
      with combos do
      for maxterms:=1 to maxmaxterms do
      begin
        if self.tag<>0 then break;
        {setup to test all combinations of current set of terms}
        setup(maxterms,primestotest,CombinationsRepeat);
        nbrcombos:=intpower(2,maxterms)-1;
        while getnext do
        begin
          inc(loopcount);
          if loopcount and $33F =0 then
          begin
            application.ProcessMessages;
            if self.tag<>0 then break;   loopcount:=0;
          end;
          solcount:=FindSolution2(s);{search for a solution with current set of terms}

          if (solcount>0) then
          begin
            if  (counts[solcount]=1) then
            begin
              if solcount=1 then plural:='' else plural:='s';
              add(format('%d is first year requiring at least %d term%s',
                           [startyear,solcount,plural]));
              add('       '+ s);
            end;
            break;
          end;
        end;
        if solcount>0 then break;
      end;
      if solcount=0
      then if (self.tag=0) then add('No solution found for '+inttostr(startyear))
           else add('Search interupted by user');
    until (self.tag<>0) or allfilled or (startyear>10000);
    If startyear>=10000
    then add('Tested years up to 10,000 without filling all terminal counts');
    keylist.free;
    add(format('Runtime %.1f seconds',[(now-starttime)*secsperday]));
    scrolltotop(memo2);
  end;
  screen.Cursor:=crdefault;
  Case2BBtn.Caption:='Case 2B Search';
end;

{************* FindSolution2 *****************}
{Search solution for Case 2: sum/diff of primes squared = target Startyear}
 function TForm1.findsolution2(var s:string):integer;
 var
   i,k,n,index,sum:integer;
   ok:boolean;
   lastplus,lastminus:integer;
   signs: array[1..6] of char;
   maxterms:integer;
 begin
   (*
   with combos, primes do
   begin
     if selected[maxterms]> prime[nbrprimes] then
     begin
       n:=prime[nbrprimes];
       repeat
         n:=getnextprime(n);
       until   n>selected[maxterms];
     end;
   end;
   *)
   with combos do
   begin
     ok:=true;
     maxterms:=getr;
     for i:=1 to maxterms {maxterms} do
     begin
       n:=primes.prime[selected[i]];
       if (n>0) then
       begin
         //if  (not primes.IsPrime(n)) then ok:=false
         //else
         begin
           if terms[i]<>n then
           begin  {only fill in the terms which changed from the previous combination}
             terms[i]:=n;
             termsq[i]:=n*n;
           end;
         end;
       end;
     end;
   end;
   result:=0;
   s:='';
   if OK then
   begin
     {now evaluate the 2^6 arrangements of + and - operations and test each
      against this set of terms looking for a match with input year date}
     {number of ways to insert +- signs in maxterms items}

     for i:=0 to nbrcombos do
     begin
       sum:=0;
       ok:=true;
       lastplus:=0;
       lastminus:=0;
       for k:=1 to maxterms do
       begin
         if ((bitmask[k] and i)=0)
         then
         begin
           signs[k]:='+';
           sum:=sum+termsq[k];
           lastPlus:=termsq[k];
         end
         else
         begin
           signs[k]:='-';
           sum:=sum-termsq[k];
           lastMinus:=termsq[k];
         end;
         if lastplus=lastminus then ok:=false;
       end;

       if ok  and (sum=Startyear) then
       begin
         {prune redundant terms (+x-x ofsetting}
          key:='';
         {recreate the solution to get the string version rather than build
          solution string for all of the non-solutions}
         for k:=1 to maxterms do
         if terms[k]<>0 then
         begin
           inc(result);
            s:=s+format('%s %d (%d^2) ',[signs[k],termsq[k],terms[k]]);
            {only put term values <> 1 in the key to eliminate redundant reporting
             of expression where only the ordering of "1" terms differs}
            if terms[k]<>1 then key:=key+signs[k]+inttostr(terms[k]);
         end;
         if not keylist.find(key,index) then
         begin
           keylist.add(key);
           inc(counts[result]);
           break;
         end;
         application.ProcessMessages; {allow Stop check after each solution}
       end;
     end;
   end;
 end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Label7Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
   'http://delphiforfun.org/programs/Interesting_2013.htm'
   ,nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Label3Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open',
   'http://fullcomment.nationalpost.com/2012/12/31/'
   +'john-chew-jonathan-kay-how-is-2013-interesting-let-us-count-the-ways/',
   nil, nil, SW_SHOWNORMAL) ;

end;

end.
