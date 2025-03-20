unit U_DiceProbabilities4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, shellapi, ExtCtrls, DFFUtils;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    SpinEdit4: TSpinEdit;
    Label4: TLabel;
    SumBtn: TButton;
    Memo2: TMemo;
    StaticText1: TStaticText;
    Label3: TLabel;
    SidesEdt: TSpinEdit;
    Label1: TLabel;
    ThrowsEdt: TSpinEdit;
    MatchesBtn: TButton;
    Memo1: TMemo;
    MatchGrp: TRadioGroup;
    Button1: TButton;
    Memo3: TMemo;
    procedure MatchesBtnClick(Sender: TObject);
    procedure SumBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    nbrsides,nbrdice, nbrtrials, nbrmatch:integer;
    nbrsets,tempnbrsets:integer;
    checkpartcount:integer;
    checkpart:array[1..10,1..10] of integer;
    function gettheoreticalmatches(const nbrsets, setsize, nbrdice:integer): integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************ Permutes **********}
function Permutes(n,count:integer):int64;
{Return count of number of permutations for "N" things taken "Count" at a time}
var
  i:integer;
begin
  result:=1;
  for i:=0 to count-1 do result:=result*(n-i);
end;

{********* Combos **********}
function combos(n,r:integer):int64;
begin
  result:=Permutes(n,r) div Permutes(r,r);
end;

{--------- Pow ---------}
function pow(x,n:integer):int64;
{Return "X" to the "n"th power}
var i:integer;
begin
  result:=1;
  for i:=1 to n do result:=result*x;
end;

{*********** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize; {make experimental results not exactly repeatable}
end;

{************ GetTheoreticalMatches *************}
function TForm1.gettheoreticalmatches(const nbrsets, setsize, nbrdice:integer): integer;
{Return number of unique combinations for "Nbrdice" throws producing "Nbrsets"
 set of "setsize" matching values (2 to 6).  Setsize 7 indicates request for full-house
 statistics)}
var
  i:integer;
  r, ToFill,avail,multiplier,n:integer;
  //s:string;
begin
  r:=1;
  avail:=nbrdice;
  for i:= 1 to nbrsets do
  begin
    if setsize<=6 then
    begin
      r:=r*(Nbrsides+1-i)*combos(avail,setsize);
      dec(avail,setsize);
      ToFill:=nbrdice-nbrsets*setsize;
    end
    else
    begin {full house}
      r:=r*(nbrsides+1-i)*combos(avail,2);
      dec(avail,2);
      r:=r*(nbrsides+1-i-1)*combos(avail,3);
      dec(avail,3);
      ToFill:=avail;
    end;
  end;
  r:=r div Permutes(nbrsets,nbrsets);   {This is the number of unique matching sets}

  {Test for the case where there is one group of "setsize" to fill
   and there is only only 1 unused number.  Then the last "setsize" dice will
   containset the only remaining unused number and therefore create an extra
   set, violating the "nbrsets" constraint!  Therefore the result for this
   case must be 0}
  If (tofill=setsize) and (nbrsets=Nbrsides-1) then
  begin
     r:=0;
     tofill:=0;
  end;

  {Calculate the unique permuations of the remaining dice which did not meet the
   target condition.  There are problems with this algorithm then number of
   "leftover" mice exceeds 4 (e.g. looking for one pair when 7 dice are thrown.}
  multiplier:=0;
  //s:='';
  begin
    if tofill >0 then
    begin
      multiplier:=Permutes(NbrSides-nbrsets,tofill);
      if setsize=7 then dec(multiplier,nbrsets);  {full house has used extra set of values}
      //s:=inttostr(multiplier)+'+';
    end;
    for i:= tofill-1 downto 1 do
    begin
      if (tofill +1 - i) <> setsize
      then
      begin
        if i=2 then n:=tofill else n:=1;
        n:=n*permutes(Nbrsides-nbrsets,i);
        //s:=s+inttostr(n)+'+';
        inc(multiplier,n);
      end;
    end;
  end;
  if multiplier=0 then multiplier:=1;
  result:=r*multiplier;
  //if length(s)>0 then delete(s,length(s),1);
  if  (nbrdice>=5) and
    (nbrsets=1) and ((setsize=2)  or (setsize=3)) then
    {subtract fullhouse stats from one pair or 3-of-a-kind outcomes}
    result:=result-gettheoreticalmatches(1, 7, nbrdice);
end;


{*************** MatchesBtnClick ************}
procedure TForm1.MatchesBtnClick(Sender: TObject);
{Report analytical and experimantal dice throw results for input conditions}
var
  i,j:integer;
  d:array[0..5] of integer;
  cumcount:integer;
  success:array[1..10] of integer; {success counts  for sets (1 pair, 2 pair, etc)}
  theory:integer;
  totoutcomes, totmatches:integer;
  cumprob:integer;
  err:boolean;
  plural:string;
  s:string;

    function fullhouse:boolean;
    {return true if throw was a full house}
    var j,pairs,threes:integer;
    begin
      pairs:=0;
      threes:=0;
      for j:=0 to nbrsides-1 do
      if d[j]=2 then  inc(pairs)
      else if d[j]=3 then  inc(threes);
      result:= (pairs=1) and (threes=1);
    end;

begin
  nbrsides:=SidesEdt.value;
  nbrdice:=ThrowsEdt.value;
  nbrmatch:=matchgrp.itemindex+2;
  err:=false;

  if nbrmatch<=6 then
  begin
    nbrsets:=nbrdice div nbrmatch;
    if nbrsets=0 then
    begin
      showmessage(format('No %d-of-a-kind matches possible throwing %d dice',
                          [nbrmatch,nbrdice]));
      err:=true;
    end;
  end
  else
  if nbrdice<5 then
  begin
    showmessage('No Full house matches possible throwing less than 5 dice');
    err:=true;
  end
  else nbrsets:=1;
  if not err  then
  begin
    totoutcomes:=pow(nbrsides,nbrdice);
    nbrtrials:=1000000;
    for i:= 1 to 10 do success[i]:=0;

    {Generate experimental results}
    for i:= 1 to nbrtrials do
    begin
      for j:= 0 to nbrsides-1 do  d[j]:=0;
      for j:=1 to nbrdice do inc(d[random(Nbrsides)]);
      totmatches:=0;
      if nbrmatch<=6 then
      begin
        for j:=0 to nbrsides-1 do if d[j]=nbrmatch then  inc(totmatches);
        if ((nbrmatch=2) or (nbrmatch=3)) and (totmatches=1) and fullhouse
        then dec(totmatches); {don't count 1 pair or 3-kind if throw was fullhouse}
      end
      else {check for full house} if fullhouse then inc(totmatches);
      if totmatches>0 then inc(success[totmatches]);
    end;
    MEMO1.LINES.ADD('');
    cumcount:=0; cumprob:=0;
    memo1.lines.add('*************');
    memo1.Lines.add(format('Results for %s when rolling %d dice',
          [ matchgrp.items[nbrmatch-2], nbrdice]));
    plural:='occurrence';
    for i:= 1 to nbrsets do
    with memo1.Lines do
    begin
      s:=format('For %d %s of %s per trial',
               [i, plural, matchgrp.items[nbrmatch-2], nbrdice]);
      if (i=1) and (nbrdice>=5) and ((nbrmatch=2) or (nbrmatch=3))
      then  s:=s+' (excluding "full house" results)';
      add(s);
      plural:='occurrences'; {now set plural message text after first usage}
      theory:=gettheoreticalmatches(i,nbrmatch,nbrdice);
      add(format('     Theory (Possible outcomes): %d / %d = %6.4f',
                          [theory, totoutcomes, theory/totoutcomes]));
      add(format('     Observed (1,000,000,random trials):  %d / %d = %6.4f',
                          [success[i], nbrtrials, success[i]/nbrtrials]));

      inc(cumcount,success[i]);
      cumprob:=cumprob+theory;
    end;

    if nbrsets>1  then
    with memo1.lines do
    begin
       add(format('For one or more occurences of %s per trial',
                       [matchgrp.items[nbrmatch-2], nbrdice]));
      add(format('     Theory (Possible outcomes): %d / %d = %6.4f',
                          [cumprob, totoutcomes, cumprob/totoutcomes]));
      add(format('     Observed (1,000,000,random trials):  %d / %d = %6.4f',
                          [cumcount, nbrtrials, cumcount/nbrtrials]));
    end;
  end;
end;

{************ SumBtnClick *************}
procedure TForm1.SumBtnClick(Sender: TObject);
{Sum of dots trials}
var
  i,j:integer;
  nbrdice, nbrtrials, targetsum:integer;
  sum:integer;
  totoutcomes:integer;
  success, SuccessT:integer; {successful outcome counts}
  s:array[0..5] of integer;
  n:integer;

  {----------- GenNext ------------}
  procedure gennext;
     {Generate the next permutation of the digits in array "s"}
     var i:integer;
     begin
       for i:=nbrdice-1 downto 0 do
       begin
         inc(s[i]);
         if s[i]>nbrsides then
         begin
           s[i]:=1;
         end
         else break;
       end;
     end;

   {------------- Sumdigits ---------}
   function sumdigits:integer;
   {Sum the digits in array "s"}
     var i:integer;
     begin
       result:=0;
       for i:=0 to nbrdice-1 do result:=result+s[i];
     end;

begin
  nbrsides:=Sidesedt.Value;
  nbrdice:=ThrowsEdt.value;
  targetsum:=spinedit4.value;
  if (targetsum<nbrdice) or (targetsum>nbrsides*nbrdice)
  then showmessage(format('Sum %d is not possible with %d dice',[targetsum,nbrdice]))
  else
  begin
    {Theoretical probability}
    {count number of dice throw combinations which match target sum}
    successT:=0;
    totoutcomes:=0;
    for i:=0 to nbrdice-1 do s[i]:=1;
    repeat
      n:=sumdigits;
      if n=targetsum then inc(successT);
      inc(totoutcomes);
      gennext;
    until n >=nbrsides*nbrdice;
    nbrtrials:=1000000;
    success:=0;
    for i:= 1 to nbrtrials do
    begin
      sum:=0;
      for j:=1 to nbrdice do inc(sum, random(Nbrsides)+1);
      if sum=targetsum then inc(success);
    end;

    memo2.lines.add('*************');
    memo2.Lines.add(format('Results for Sum of Dots = %d when rolling %d %d-sided dice',
          [ targetsum, nbrdice, nbrsides]));
    memo2.lines.add(format('     Theory (Possible outcomes): %d / %d = %6.4f',
                          [successT, totoutcomes, successT/totoutcomes]));
    memo2.lines.add(format('     Observed (1,000,000 random trials):  %d / %d = %6.4f',
                          [success, nbrtrials, success/nbrtrials]));
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



procedure TForm1.Button1Click(Sender: TObject);
  var
  i,j,k:integer;
  d:array[0..5] of integer;
  cumcount:integer;
  OnePair, twopair, threekind, fourkind, fivekind, fullhouse, straight, nostraight:integer;
  outcomes:array[1..5] of integer;
  n:integer;
  s:string;
  nostraightdetail:array[1..100] of string;
begin
  sidesedt.value:=6;
  throwsedt.value:=5;
  nbrsides:=SidesEdt.value;
  nbrdice:=ThrowsEdt.value;
  nbrtrials:=1000000;
  onepair:=0;
  twopair:=0;
  threekind:=0;
  fourkind:=0;
  fivekind:=0;
  fullhouse:=0;
  straight:=0;
  nostraight:=0;

  {Generate experimental results}
  for i:= 1 to nbrtrials do
  begin
    for j:= 0 to nbrsides-1 do  d[j]:=0;
    s:='';
    for j:=1 to 5 do
    begin
      n:= random(Nbrsides);
      inc(d[n]);
      if nostraight<100 then
      s:=s+inttostr(n+1)+' ';  {may display some of these later}
    end;
    for k:=1 to 5 do outcomes[k]:=0;
    for j:=0 to nbrsides-1 do
    for k:=1 to 5 do
    if d[j]=k then inc(outcomes[k]);
    {Each index of outcome contains the number of time that sets of "index values
     occur.  So outcomes[1]=3 means 3 unique values, etc.}
    if (outcomes[1]=3) {and (outcomes[2]=1)} then inc(onepair)
    else if {(outcomes[1]=1) and} (outcomes[2]=2) then inc(twopair)
    else if (outcomes[1]=2) and (outcomes[3]=1) then inc(threekind)
    else if {(outcomes[1]=1) and} (outcomes[4]=1) then inc(fourkind)
    else if {(outcomes[1]=0) and} (outcomes[5]=1) then inc(fivekind)
    else if (outcomes[2]=1) and (outcomes[3]=1) then inc(fullhouse)
    else if (outcomes[1]=5) then
    begin
      {5 different values, if missing a "1" or a "6", must be a straight}
      if (d[0]=0) or (d[5]=0) then inc(straight) else
      begin
        inc(nostraight); {5 different values includin "1" and "6"}
        if nostraight<100 then nostraightdetail[nostraight]:=s;
      end;
    end;
  end;

  with memo1, lines do
  begin
    clear;
    cumcount:=0;
    add('*************');
    add('All Results when rolling 5 dice');

    add(format('One pair: %d (%6.4f)',[onepair, onepair/nbrtrials]));
    inc(cumcount, onepair);

    add(format('Two pair: %d (%6.4f)',[twopair, twopair/nbrtrials]));
    inc(cumcount, twopair);

    add(format('Three kind: %d (%6.4f)',[threekind, threekind/nbrtrials]));
    inc(cumcount, threekind);

    add(format('Full House: %d (%6.4f)',[fullhouse, fullhouse/nbrtrials]));
    inc(cumcount, fullhouse);

    add(format('Four kind: %d (%6.4f)',[fourkind, fourkind/nbrtrials]));
    inc(cumcount, fourkind);

    add(format('Five kind: %d (%6.4f)',[fivekind, fivekind/nbrtrials]));
    inc(cumcount, fivekind);

    add(format('Straight: %d (%6.4f)',[Straight, straight/nbrtrials]));
    inc(cumcount, straight);

    add(format('Others: %d (%6.4f)',[Nostraight, Nostraight/nbrtrials]));
    inc(cumcount, nostraight);

    add(format('Sum of probabilities (1,000,000,random trials):  %d / %d = %6.4f',
                          [cumcount, nbrtrials, cumcount/nbrtrials]));

    add('');
    add('********');
    add('First 100  "Others" rolls (5 unique values, but no straight)');
    for i:=1 to 100 do lines.add(nostraightdetail[i]);
    movetotop(memo1);
  end;
end;

end.
