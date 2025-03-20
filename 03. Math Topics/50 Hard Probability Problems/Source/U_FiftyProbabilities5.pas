Unit U_FiftyProbabilities5;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Here are some probability problems selected from the book "Fifty Challenging Problems in
Probability" by Fredereck Mosteller, Dover Publications.

Problems are described on separate pages selectable by clicking on the problem titles.  The
buttons provide an analytical solution and an experimental simulation of the
selected problem.   The analytical solution derives the answer using the principles of probability
theory and which hopefully is confirmed by running a million simulated trials of the problem and
counting the number of successful outcomes.

This is Version 4.0 which has 4 of the 50 problems from the book.  More may be added in the future.
}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, dffutils, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    ExperimentalBtn: TButton;
    AnalyticalBtn: TButton;
    Memo2: TMemo;
    Showbox: TCheckBox;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    TabSheet16: TTabSheet;
    TabSheet19: TTabSheet;
    Memo1: TMemo;
    Memo3: TMemo;
    Prob16_17Grp: TRadioGroup;
    Memo4: TMemo;
    TabSheet18: TTabSheet;
    Memo5: TMemo;
    NbrCoinsEdt: TEdit;
    Label1: TLabel;
    NbrCoinsUD: TUpDown;
    TabSheet20: TTabSheet;
    Memo6: TMemo;
    StrategyGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure ExperimentalBtnClick(Sender: TObject);
    procedure AnalyticalBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Prob16_17GrpClick(Sender: TObject);
    procedure TabSheetEnter(Sender: TObject);
  public
    dir:string;
    list:TStringlist;  {String to hold trails results for display} 
    procedure RunProblem16(memo:TMemo);
    procedure RunProblem17(memo:TMemo);
    procedure RunProblem18(memo:TMemo);
    procedure RunProblem19(memo:TMemo);
    procedure RunProblem20(memo:TMemo);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  totTrials:integer=1000000;
  nbrtoshow:integer=10;

{************* Shuffle ************}
procedure shuffle(var deck:array of integer);
{Randomly rearrange a set of integers}
var
  i,n:integer;
  temp:integer;
begin
  i:= high(deck);  {start with I point to last location}
  while i>0 do
  begin
    n:=random(i+1); {pick a random slot <= to I}
    temp:=deck[i];  {swap current I integer with that random slot}
    deck[i]:=deck[n];
    deck[n]:=temp;
    dec(i);        {and decrement I by 1}
  end;
end;

{************* FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;  {make each execution unique}
  Prob16_17GrpClick(sender);
  dir:=extractfilepath(application.exename);
  pagecontrol1.ActivePage:=Introsheet;
  list:=TStringlist.create;
end;

{*************** ExperimentalBtnClick *************}
procedure TForm1.ExperimentalBtnClick(sender:TObject);
var i:integer;
begin
  list.clear;
  {NbrToShow cal be used by RunPromxx procedures to add trial results to "list"}
  If showbox.checked then nbrtoshow:=10 else nbrtoshow:=0;

  {Run the problem on the currently selected tabsheet}
  if Pagecontrol1.activepage=tabsheet16 then
  begin
    if prob16_17grp.itemindex=0 then Runproblem16(memo2)
    else RunProblem17(memo2);
  end
  else
  if Pagecontrol1.activepage=tabsheet18 then RunProblem18(memo2)
  else if Pagecontrol1.activepage=tabsheet19 then RunProblem19(memo2)
  else if Pagecontrol1.activepage=tabsheet20 then RunProblem20(memo2)

  else Showmessage('Select a problem page first');

  if showbox.checked and (list.count>0)then
  begin
    memo2.Lines.Add('-----------------------------');
    for i:=0 to list.count-1 do memo2.lines.add(list[i]);
    movetotop(memo2);
  end;
end;

{**************** AnalyticalBtnClick **************}
procedure TForm1.AnalyticalBtnClick(Sender: TObject);
begin
  with memo2,Lines do
  begin
    clear;
    if Pagecontrol1.activepage=tabsheet16 then
    begin
      if prob16_17grp.itemindex=0
      then loadfromfile(dir+'Prob16_Analysis.txt')
      else loadfromfile(dir+'Prob17_Analysis.txt');
    end
    else if pagecontrol1.activepage=tabsheet18
    then loadfromfile(dir+'Prob18_Analysis.txt')
    else if pagecontrol1.activepage=tabsheet19
    then loadfromfile(dir+'Prob19_Analysis.txt')
    else if pagecontrol1.activepage=tabsheet20
    then loadfromfile(dir+'Prob20_Analysis.txt')
    else showmessage('Select a problem page first');
  end;
end;

{*************** Problem16_17grpClick ************}
procedure TForm1.Prob16_17GrpClick(Sender: TObject);
begin
  with memo1,lines  do
  begin
    //clear;
    add('Eight tennis players (call them A,B,C,D,E,G,F,H) are randomly assigned to start'
            +' positions in a ladder tournament.  Initially, position 1 plays position 2,'
            +' position 3 plays 4, 5 plays 6 and 7 plays 8.  Second round has 2 matches:'
            +' winner of (1,2) match plays winner of (3,4), and winner (5,6) plays winner(7,8).'
            +' The winners of the two 2nd round matches play each other in the final match.');

    add('-----------------------------------------------------------------------------------------');
     add('');

    If Prob16_17Grp.itemindex=0 then
    begin   {Problem 16}
      add('Problem 16: Player A wins against any of the others. Player B always beats any '
        + 'opponent except player A. What is the probability that player B wins the '
        + '2nd place trophy in the final match?');
    end
    else
    begin   {Problem 17}
      add('Problem 17: Assume that the players are of equal skill levels so each has a 50-50 chance of winning any particular match.'
         + '  A and B happen to be twins.  What is the probablity that they will play each other'
         + ' in some match during the tournament?');
    end;
  end;
  memo2.clear;
end;

{*********** RunProblem16 *************}
procedure TForm1.RunProblem16(memo:TMemo);
var
  i, match, n:integer;
  players1:array[0..7] of integer; {Round 1}
  players2:array[0..3] of integer; {Round 2}
  players3:array[0..1] of integer; {Round 3}
  runnerupcount:integer;
  s:string;
begin
  //Memo.Clear;

  {If Nbrtoshow>0 then we'll save the tournament results to be displayed in a
   stringlist so we can show the total resuls first, then the details for the
   frst NbrToShow tournaments.}
  If nbrtoshow>0 then list.add(format('First %d tournaments:',[nbrtoshow]));

  for i:=0 to 7 do players1[i]:=i;
  runnerupcount:=0;
  for i:=1 to totTrials do
  begin
    {Shuffle to assign starting positions}
    shuffle(players1);
    {play matches}
    {Round 1 results}
    s:='Round 1:';
    if i<=nbrtoshow then
    with list do
    begin
      add('-----------------------');
      add('Tournament #' +inttostr(i));
    end;
    for match:=0 to 3 do
    begin
      n:=2*match; {short id}
      if (players1[n]=0)
      or (players1[n+1]=0) then players2[match]:=0
      else
      if (players1[n]=1)
      or (players1[n+1]=1) then players2[match]:=1
      else players2[match]:=players1[n+random(2)];
      if i<=nbrtoshow then s:=s+format('%s&%s,  ',
           [char(ord('A')+players1[n]), char(ord('A')+players1[n+1])]);
    end;

    if i<=nbrtoshow then List.add(s);
    {Round2 matches}
    s:='Round 2:';
    for match:=0 to 1 do
    begin
      n:=2*match;
      if (players2[n]=0)
      or (players2[n+1]=0) then players3[match]:=0
      else
      if (players2[n]=1)
      or (players2[n+1]=1) then players3[match]:=1
      else players3[match]:=players2[n+random(2)];
      if i<=nbrtoshow then s:=s+format('    %s  &   %s     ',
           [char(ord('A')+players2[n]), char(ord('A')+players2[n+1])]);
    end;

    if i<=nbrtoshow then List.add(s);
    {Final round}
    if (players3[0]=1) or (players3[1]=1) then inc(runnerupcount);
    if i<=nbrtoshow then List.add(
        format('Round 3:        %s          &        %s     ===>"B" Runner-up count=%d  ',
           [char(ord('A')+players3[0]), char(ord('A')+players3[1]),runnerupcount]));
  end;

  with memo,lines do
  begin
    add('Problem 16:');
    add(format('In %.0n simulated tournaaments, there were %.0n runner-up wins by player B.  P=%.3f  (%.1f%%)',
    [0.0+totTrials,0.0+runnerupcount, runnerupcount/totTrials, 100*runnerupcount/totTrials]));
    add('');
  end;
end;

{************** RunProblem17 *************}
Procedure TForm1.RunProblem17(memo:TMemo);
  var
  i, match, n:integer;
  players1:array[0..7] of integer; {Round 1}
  players2:array[0..3] of integer; {Round 2}
  players3:array[0..1] of integer; {Round 3}
  TotHitcount:integer;
  Met:boolean;
  Winnerindex:integer;
  s:string;
begin
  memo.Clear;
  {If Nbrtoshow>0 then we'll save the trial results to be displayed in a
   stringlist so we can show the total resuls first, then the details for the
   frst NbrToShow tournaments.}
  If nbrtoshow>0 then list.add(format('First %d tournaments:',[nbrtoshow]));

  for i:=0 to 7 do players1[i]:=i;
  tothitcount:=0;
  for i:=1 to totTrials do
  begin
    shuffle(players1);   {Shuffle to assign starting positions}
    met:=false;
    {play matches}
    {Round1 results}
    s:='Round 1:';
    if i<=nbrtoshow
    then
    with list do
    begin
      add('-----------------------');
      add('Tournament #' +inttostr(i));
    end;
    for match:=0 to 3 do
    begin
      n:=2*match; {n = position # of 1st player in match "Match"}
      If (players1[n]+players1[n+1]=1) {A&B play each other iff sum=1}
      then
      begin
        Met:=true;
        inc(tothitcount);
      end;
      winnerindex:=n+random(2); {winner is in postition n or n+1}
      players2[match]:=players1[winnerindex];
      if i<=nbrtoshow then s:=s+format('%s&%s,  ',
           [char(ord('A')+players1[n]), char(ord('A')+players1[n+1])]);
    end; {end Match 1 loop}

    if i<=nbrtoshow then
    begin
      If met then s:=s+ format('A&B meet! ===> Total met count=%d',[tothitcount]);
      list.add(s);
    end;
    {Round2 matches}
    If not met then
    begin  {Only need to analyze if A and B have not played each other yet}
      s:='Round 2:';
      for match:=0 to 1 do
      begin
        n:=2*match;
        If players2[n]+players2[n+1]=1 {A and B played each other}
        then
        begin
           met:=true;
          inc(tothitcount);
        end;
        {determine the winner}
        winnerindex:=n+random(2); {winner is in postition n or n+1}
        players3[match]:=players2[winnerindex];
        if i<=nbrtoshow then s:=s+format('    %s  &   %s     ',
             [char(ord('A')+players2[n]), char(ord('A')+players2[n+1])]);
      end;

      if i<=nbrtoshow then
      begin
        If met then s:=s+ format('A&B meet! ===> Total met count=%d',[tothitcount]);
        list.add(s);
      end;
      if not met then
      begin
        {Final round}
        If players3[0]+players3[1]=1 {A and B played each other}
        then
        begin
          met:=true;
          inc(tothitcount)
        end;
        if i<=nbrtoshow then
        begin
          If met then s:=format('A&B meet! ===> Total met count=%d',[tothitcount])
          else s:='';
          list.add(
          format('Round 3:        %s          &        %s   %s ',
             [char(ord('A')+players3[0]), char(ord('A')+players3[1]),s]));
        end;
      end;
    end; {Round 17 match loop}
  end; {Total match loop}


  with Memo.lines do
  begin
    add('Problem17:');
    add(format('In %.0n simulated tournaments, A & B met %.0n times.  P=%.3f  (%.1f%%)',
       [0.0+totTrials, 0.0+tothitcount, Tothitcount/totTrials, 100*Tothitcount/totTrials]));
    add('');
    (*
    if showbox.Checked then
    begin
      add(format('First %d tournaments:',[nbrtoshow]));
      for i:=0 to list.count-1 do add(list[i]);
    end;
    scrolltotop(memo);
    *)
  end;
end;

{*************** RunProblem18 *************}
procedure TForm1.RunProblem18(memo:TMemo);
var
  i,n:integer;
  nbrhits :integer;
  nbrsuccesses:integer;
  Targetheads:integer;
  s:string;
  coin:char;
begin
  nbrsuccesses:=0;
  NbrCoinsUD.position:=2*(NbrCoinsUD.position div 2);
  TargetHeads:=NbrCoinsUD.Position div 2;
  {If Nbrtoshow>0 then we'll save the tournament results to be displayed in a
   stringlist so we can show the total resuls first, then the details for the
   frst NbrToShow tournaments.}
  If nbrtoshow>0 then list.add(format('First %d trials throwing %d coins looking for %d Heads',
         [nbrtoshow, 2*Targetheads, targetheads]));
  for i:=1 to totTrials do
  begin
    nbrhits:=0;
    //setlength(s, 3*targetheads); {make it long ehough to hold 2*targetheads plus
    //                              some room for spaces}
    s:='';
    for n:=1 to 2*targetheads do
    begin
      if random(2)=0 then
      begin
        inc(nbrhits);
        coin:='H';
      end
      else coin:='T';
      if i<=nbrtoshow then
      begin
        s:=s+coin;
        if n mod 10 = 0 then s:=s+' ';
      end;
    end;
    if nbrhits=Targetheads then inc(nbrsuccesses);
    if i<=nbrtoshow then
    begin
      list.add(s);
      list.add('Number of heads='+inttostr(nbrhits));
    end;
  end;
  with memo, lines do
  begin
    scrolltotop(memo);
    add(format('After %.0n simulated trials, probability of %d heads in %d throws is %6.4f',
               [0.0+tottrials, TargetHeads,2*targetHeads,nbrsuccesses/tottrials]));
  end;

end;

{*************** RunProblem19 ************}
procedure TForm1.RunProblem19(memo:TMemo);
var
  i,j,n:integer;
  nbrhits :integer;
  nbrsuccesses:array[1..3] of integer;
  sixword:string;  {'six' for singular and 'sixes' for plural}
begin
  {(a) roll 6 dice and count the number with 1 or more 6's}
  {(b) roll 12 and count # with 2 or more 6's}
  {(c) roll 18 and count # with 3 or more (6's}

  for i:=1 to 3 do nbrsuccesses[i]:=0;
  {If Nbrtoshow>0 then we'll save the trial results to be displayed in a
   stringlist so we can show the total resuls first, then the details for the
   frst NbrToShow tournaments.}
  If nbrtoshow>0 then list.add(format('First %d trials throwing 6, 12, or 18 dice looking for 1, 2, or 3 or more sixes',
         [nbrtoshow]));
  for i:=1 to totTrials do
  begin
    for n:=1 to 3  do
    begin
      nbrhits:=0;
      for j:=1 to 6*n do if random(6)=5 then inc(nbrhits);
      if nbrhits>=n then inc(nbrsuccesses[n]);
      if i<=nbrtoshow then
      begin
        if nbrhits=1 then sixword:='six' else sixword:='sixes';
       list.add(format('Trial %d-%d: Throwing %d dice produced %d %s',
               [i,n, 6*n, nbrhits, sixword]));
      end;
    end;
  end;
  with memo, lines do
  for n:=1 to 3 do
  begin
    add(format('Probability of %d or more 6''s in %.0n throws is %6.3f',
                [n,0.0+totTrials,nbrsuccesses[n]/tottrials]));
  end;

end;

type
  TShooterRec=record  {characteristics of a "shooter"}
    names:string;   {his name}
    odds:extended;  {how accurate is he}
    alive:boolean;  {current state of health (true=alive, false=dead)}
    wincounts:integer;  {total nbr of games won for this set of shootouts}
    nbrhits:integer;    {total nbr of opponents "killed" in this set}
  end;




{*************** RunProblem20 ************}
procedure TForm1.RunProblem20(memo:TMemo);
var
  showdetail:boolean;
  nbrshooters:integer;
  rec:array[0..2] of TShooterrec;
  i,j,n:integer;
  nbrhits :integer;
  nbrsuccesses:array[1..3] of integer;
  target:integer;
  totalshots, longestgame, shortestgame:integer;

      {**************** TakeAShot **************}
      procedure takeAshot(shooter, shotnbr:integer);
      {Recursive routine to take shot according to chosen strategy and
       choose the next shooter based on "next surviving shooter" round robin
       rule.  Stop when only one person is left alive}
      var
        i,j:integer;
        nextshooter:integer;
        hit:boolean;
        s:string;
        count,n:integer;
        maxodds, minodds:extended;
        nbrgames:integer;
      begin
        nextshooter:=-1;
        hit:=false;
        {Find max and min odds of alive contestants}
         target:=-1;
        maxodds:=0.0;
        minodds:=2.0;
        hit:=(random<=rec[shooter].odds);
        target:=-1;
        count:=0;
        for i:= 0 to nbrshooters-1 do
        if i<>shooter then
        begin
          {strategy 3: first shooter deliberately misses on his first shot}
          if (strategygrp.itemindex=1) and (shotnbr=1) then
          begin
            hit:=false;
            break
          end
          else
          if rec[i].alive then
          begin
          {not 1st shot or not 1st shooter}
          {Shoot at best living shooter}
              if rec[i].odds>maxodds then
              begin
                target:=i;
                maxodds:=rec[i].odds;
              end;
          end;
        end;

        if hit and (target>=0) then
        begin
          rec[target].alive:=false;
          inc(rec[shooter].nbrhits);
        end;
        {get next shooter}
        for j:=1 to nbrshooters-1 do
        begin  {find the next shooter who is alive}
          n:=(shooter+j) mod nbrshooters;
          if  rec[n].alive then
          begin
            nextshooter:=n;
            break;
          end;
        end;

        if showdetail then
        begin
          if ((strategygrp.itemindex=3) and (shotnbr=1))
          {message for 1st shot of strategy 3}
          then list.add('Shot #'+inttostr(shotnbr)+': '
                        + rec[shooter].names+' shoots into air,')
          else
          begin {message for every other case}
            if hit then s:=' and hits!' else s:=' and misses.';
            list.add('Shot #'+inttostr(shotnbr)+': '
                     + rec[shooter].names+' shoots at '+ rec[target].names + s);
          end;
        end;

        if nextshooter<0 then
        {no nextshooter, game over}
        begin
          if showdetail then
          begin
            list.add('Winner is '+rec[shooter].names);
            list.add(' ');
          end;

          inc(rec[shooter].wincounts);  {add to shooters win count}
          inc(totalshots,shotnbr);  {accumulate total shots}
          if shotnbr>longestgame then longestgame:=shotnbr;
          if shotnbr<shortestgame then  shortestgame:=shotnbr;
        end
        else {the "recursive" part , routine calls itself!}
        takeashot(nextshooter, shotnbr+1);
      end;



begin
   nbrshooters:=3;
   totalshots:=0;
   longestgame:=0;
   shortestgame:=1000;

   for i:=0 to nbrshooters-1 do
   with rec[i] do
   begin
     wincounts:=0;
     nbrhits:=0;
     case i of
     0: begin
          names:='Al';
          odds:=0.3;
        end;
     1: begin
          names:='Bob';
          odds:=1.0;
        end;
     2: begin
          names:='Carl';
          odds:=0.5;
        end;
      end;
    end;
  memo.Clear;
  {Loop to play a number of games of the selecgted strategy}
  for i:=1 to TotTrials do
  begin
    if i<=nbrtoshow then showdetail:=true {set flag to display 1st 100 games}
    else showdetail:=false;
    {bring everyone back to life at the start of this game}
    for j:=0 to nbrshooters-1 do
    with rec[j] do
    begin
     alive:=true;
     
    end;
    Takeashot(0,1); {start the game, "TakeAshot" will call itself to finish the game}
  end;
  {Display summary data}
  with memo2.lines do
  begin
    add('');
    with strategygrp do
    if itemindex<3 then add('Strategy '+items[itemindex])
    else add('Strategy 4. Al deliberately misses on his first shot, then each shoots at best remaining shooter');
    add('');
    add(format('%.0n games, Avg game length: %4.1f',[0.0+tottrials, totalshots/tottrials]));
    add(format('        Shortest: %d, Longest %d',[shortestgame,longestgame]));
    add('');
    for i:=0 to nbrshooters-1 do
    with rec[i] do
    begin
      add(format('%s wins %6.1f %% of the time',[Names,wincounts*100/tottrials]));
      add(format('       %6.3f avg kills per game',[nbrhits/tottrials]));
    end;
    add('');

    for i:=0 to list.count-1 do  add(list[i]);

    movetotop(memo2);
  end;

end;




procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;






procedure TForm1.TabSheetEnter(Sender: TObject);
begin
  memo2.Clear;
end;

end.
