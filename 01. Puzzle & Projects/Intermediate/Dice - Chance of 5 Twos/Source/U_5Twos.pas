unit U_5Twos;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
A recent feedback email to DFF:
My local bar has a game. 5 dice in a cup. You have to roll 5 Two's in two shakes and you
can "farm".  i.e. Roll the first time, save any two's, pick up the remaining dice and roll
them.
What are the odds that five two's will be rolled this way?  The bet is $2 and the pot is
currently over $2,800.00
Just curious. Thanks.
}

{This program addresses the question in several ways - "just for fun"!}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellapi;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    SolSheet1: TTabSheet;
    SolSheet2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    StaticText1: TStaticText;
    TabSheet2: TTabSheet;
    Memo4: TMemo;
    TabSheet3: TTabSheet;
    Memo5: TMemo;
    SimBtn: TButton;
    ResetBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure SimBtnClick(Sender: TObject);
  public
    totruns, wincount:integer; {used by Simulate sheet to accumulate statistics}
    function p(m,n:integer):extended;
    procedure Solution1;
    procedure CheckPFunction;
  end;

var
  Form1: TForm1;

implementation
uses math;

{$R *.DFM}

{************ FormActivate **********}
 procedure TForm1.FormActivate(Sender: TObject);
begin
  Pagecontrol1.activepage:=tabsheet1;
  Solution1;
  CheckPfunction;
  resetbtnclick(sender);
  simbtnclick(sender);
end;

{********* C *********}
function C(const N,M:integer):integer;
{A simple "Choose" (Combinations) function for small numbers}
{without any error checking}
var
  i:integer;
  permutes, MFact:integer;
begin
  permutes:=N;
  for i:=N-1 downto (N-M+1) do permutes:=permutes*i;
  MFact:=M;
  for i:=M-1 downto 2 do MFact:=MFact*i;
  If (MFact=0) or (permutes=0) then result:=1 else result:=permutes div MFact;
end;

{************** P **************}
function TForm1.p(m,n:integer):extended;
{Rturn probability that a random throw of N dice will contain M twos}
begin
  result:=C(N,M)*intpower(1/6,m)*intpower(5/6,n-m);
end;

{********** Solution1 ************}
procedure TForm1.Solution1;
{Calculate a solution}
var
  i,j:integer;
  prob,sum:extended;
  twostr:string;
begin
  with memo2,lines do
  begin
    add('');{workaround for Delphi bug which adds 1st line a top of memo instead of at end}
    for j:=5 downto 1 do
    begin
      sum:=0.0;
      for i:=0 to j do
      begin
        prob:=p(i,j);
        {the little touches that improve the output grammer}
        if i=1 then twostr:='two' else twostr:='twos';
        append(format('Chance of rolling %d %s out of %d dice=%8.6f',[i,twostr,j,prob]));
        sum:=sum+prob;
      end;
      add(format('Sum = %8.6f (Sum should = 1.00)',[sum]));
      add('');
    end;

    add('');
    add('Now calculate chance of 5 twos in 2 rolls for each way that it could occur.');
    add('That is, 0 to 5 twos on first roll with 5 dice P(A,5), followed by rolling all non-two dice on');
    add('the 2nd roll P(5-A,5-A). The chance of both happening is product of the two probabilities; P(A,5)xP(5-A,5-A).');
    add('');
    sum:=0;
    for i:=0 to 5 do
    begin
      prob:=p(i,5)*p(5-i,5-i);
      if i=1 then twostr:='two' else twostr:='twos';
      if i<5 then
      add(format('Chance of rolling %d %s followed by rolling %d of %d twos on the 2nd throw=%8.6f',
                  [i,twostr,5-i,5-i,prob]))
      else add(format('Chance of rolling %d %s on first roll=%8.6f',[i,twostr,prob]));
      add(format('                About 1 in %d',[round(1/prob)]));
      sum:=sum+prob;
    end;

    add(format('Total chance of success is sum of the above ways that it could be done = %8.6f, about 1 in %d',[sum,round(1/sum)]));
    selstart:=0; selLength:=0;{A "trick" to force the display back to line 1}
  end;
 end;



{********** CheckPFunction *********}
procedure TForm1.checkPFunction;
{Verify the function P(M,N), the number of outcomes with M twos when N dice are
 thrown divided by the total number of possible outcomes}
var
  i:integer;
  M,N:integer;
  nums:array of integer;
  counts:array of integer;
  totcount:integer;
  twocount:integer;
  twostr,w1,w2:string;

  function getnext(var nums:array of integer):boolean;
  var
    i,j:integer;
  begin
    inc(nums[N]);
    if (nums[N]>6) then
    begin
      j:=N;
      while (j>1) and (nums[j]>6) do
      begin
        nums[j]:=1;
        dec(j);
        inc(nums[j]);
      end;
    end;
    if nums[1]>6 then result:=false else result:=true;
  end;

begin
  for N:=5 downto 1 do
  begin
    {generate all possible outcomes}
    memo4.Lines.add('');
    setlength(nums,N+1);
    setlength(counts,N+1);
    for i:=0 to N do counts[i]:=0;
    totcount:=0;
    for i:=1 to N-1 do nums[i]:=1;
    nums[N]:=0;
    while   getnext(nums) do
    begin
      twocount:=0;
      for i:=1 to N do if nums[i]=2 then inc(twocount);
      inc(counts[twocount]);
      inc(totcount);
    end;
    memo4.lines.add(format('For %d dice, there are %d outcomes',[n,totcount]));
    for M:=0 to N do
    begin
      if M=1 then twostr:='two' else twostr:='twos';
      if counts[m]=1 then
      begin
        w1:='was'; w2:='occurrence';
      end
      else
      begin
        w1:='were'; w2:='occurrences';
      end;

      memo4.lines.add(format('For %d %s out of %d dice, there %s %d %s. TestP = %d / %d = %8.6f, Error=%8.6f',
                             [M,twostr,N,w1,counts[m],w2,counts[M], totcount, counts[m]/totcount, counts[M]/totcount-p(m,n)]));
    end;
  end;
  memo4.selstart:=0; {force top line into view}
  memo4.sellength:=0;
end;

{************* SimBtnClick ***********}
procedure TForm1.SimBtnClick(Sender: TObject);
{Simulate 1,000,000 games to check theoretical results}
var
  i,j,n:integer;
  twocount:integer;
  nbrruns:integer;
begin
  nbrruns:=1000000;
  inc(totruns, nbrruns);
  for i:= 1 to nbrruns do
  begin
    twocount:=0;
    for j:= 1 to 5 do
    begin
      n:=random(6);
      if n<>2 then n:=random(6);
      if n<>2 then break;
      inc(twocount);
    end;
    if twocount=5 then inc(wincount);
  end;
  memo5.lines.add(format('Simulation of %.0n games has %.0n with 5 twos. Probability=%8.6f',
                  [0.0+totruns,0.0+wincount, wincount/totruns]));
end;

{*********** ResetBtnClick ************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Reset simulation run counts}
begin
  memo5.clear;
  totruns:=0;
  wincount:=0;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;





end.
