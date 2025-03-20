unit U_RollCall2;
{Copyright  © 2005,2008 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 (*
 One very simple type of solitaire game known as “Hit or Miss” (also known as
 “Frustration,” “Harvest,” “Roll-Call,” “Talkative”, and “Treize”) is played
 as follows: take a standard deck of 52 playing cards — four sets of cards
 numbered 1 through 13 (suits do not matter in this game) which have been
 shuffled — and start counting through the deck 1, 2, 3, . . . , and so on.
 When your count reaches 13, start over at 1. Each time you count, look at the
 top card of the deck and do one of two things: if the number you count matches
 the value of the top card, discard it from the deck; if it does not match it,
 move that card to the bottom of the deck. You win the game if you are able to
 remove all cards from the deck (which may take a very long time).
 *)

(*January, 2008:  A revised version (V2) answers a viewer's question about the
  probability of "zero strike" or "one strike" games. (A "Strike" is a pass through
  the remaning deck with no matches.)
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellAPI, DFFUtils, ComCtrls;

type
  TDeck = array[1..52] of integer;
  TForm1 = class(TForm)
    PlayBtn: TButton;
    Modegrp: TRadioGroup;
    GamesGrp: TRadioGroup;
    ResetBtn: TButton;
    Memo2: TMemo;
    StaticText1: TStaticText;
    Memo3: TMemo;
    Memo4: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo1: TMemo;
    TabSheet2: TTabSheet;
    Memo5: TMemo;
    TabSheet3: TTabSheet;
    Memo6: TMemo;
    GroupBox1: TGroupBox;
    Zerobox: TCheckBox;
    OneBox: TCheckBox;
    Allbox: TCheckBox;
    Longbox: TCheckBox;
    procedure PlayBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Memo4Click(Sender: TObject);
  public
    GamesPlayed:int64;
    GamesWon:int64;
    GamesLost:int64;
    MoralVictories:int64;
    totGamesPlayed:int64;
    totGamesWon:int64;
    totGamesLost:int64;
    totMoralVictories:int64;
    totcyclestowin:integer;
    totcyclestolose:integer;
    tottotstrikes,minminstrikes,maxmaxstrikes:integer;
    MaxNoMoveCycles:integer;
    losingcardsleft:Tdeck;
    savedeck: array [0..100] of TDeck;
    totStrikeDist:array[0..100] of integer; {Distribution of strikes to end of winning game}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** PlayBtnClick ***********}
procedure TForm1.PlayBtnClick(Sender: TObject);
var
  i,j,k:integer;
  s:string;

  NewmaxNoMoveCycles:integer;
  deck, startdeck :TDeck;

  swapto:integer;
  temp:integer;
  nomovecycles:integer;
  cardsLeft:integer;
  nextguess:integer;
  nextcard:integer;
  cyclecount:integer;
  cyclestowin:integer;
  cyclestolose:integer;
  cardmoved:boolean;
  startcount,endcount:int64;  {timing counter values}
  freq:int64;  {counts per second}
  strikecount, totstrikes, minstrikes, maxstrikes:int64;
  StrikeDist:array[0..100] of integer; {Distribution of strikes to end of winning game}
  gamesadded:integer;
  sum:int64;
begin
  case modegrp.itemindex of
    0: NewMaxNoMoveCycles:=2;
    1: newMaxNoMoveCycles:=3;
    else newMaxNoMoveCycles:=13;
  end;

  If MaxNoMoveCycles<>newMaxNoMoveCycles then resetbtnclick(self);
  maxNoMoveCycles:=newMaxNoMoveCycles;

  Gamesplayed:=100;
  case Gamesgrp.itemindex of
    0: GamesPlayed:=1000;
    1: GamesPlayed:=10000;
    2: GamesPlayed:=100000;
    3: GamesPlayed:=1000000;
  end;

  GamesWon:=0;
  GamesLost:=0;
  MoralVictories:=0;
  cyclestowin:=0;
  cyclestolose:=0;
  minstrikes:=1000000;
  maxstrikes:=0;
  totstrikes:=0;
  gamesadded:=0;
  screen.cursor:=crHourGlass;
  memo4.clear;
  memo4.lines.add('Winning games with selected strike counts');
  memo4.lines.add('Click a game deck to replay it below');
  memo3.clear;
  memo2.visible:=false;
  memo3.visible:=true;
  QueryPerformanceFrequency(freq);
  QueryPerformanceCounter(startcount);


  for i:=0 to high(strikedist) do
  begin
   strikedist[i]:=0;
   if i>0 then losingcardsleft[i]:=0;
  end;

  for j:=0 to 3 do
    for k:=1 to 13 do
      startdeck[j*13+k]:=k;

  for i:=1 to GamesPlayed do
  begin
    {set up a new game}
    {1. make a deck}
    deck:=startdeck;

    

    for k:= 1 to 3 do
    {2. shuffle the deck (3 tmes) }
    for j:=52 downto 1 do
    begin
      swapto:=random(j-1)+1; {select random card 1 to j-1}
      temp:=deck[j]; {exchange the two cards}
      deck[j]:=deck[swapto];
      deck[swapto]:=temp;
    end;

    {2a. Deck is destroyed as we run, so save it in case we want to display winners}
    savedeck[0]:=deck;

    {3. initialize counters, etc}
    nomovecycles:=0;
    cardsleft:=52;
    nextguess:=1;
    nextcard:=1;
    cyclecount:=0;
    cardmoved:=false;
    strikecount:=0;

    {4. play a game}
    while (cardsleft>0) and (nomovecycles<maxnomovecycles)  do
    begin
      If deck[nextcard]=nextguess then {good guess}
      begin   {delete the card}
       for j:=nextcard to cardsleft-1 do deck[j]:=deck[j+1];
       {next line (move statement) is no faster at deleting a card than loop above!}
       // move(deck[nextcard+1],deck[nextcard],(cardsleft-nextcard)*sizeof(integer));
        dec(cardsleft);
        cardmoved:=true;
        nomovecycles:=0;
      end
      else
      begin
        inc(nextcard);
      end;
      inc(nextguess); {our next guess}
      If nextguess>13 then nextguess:=1;
      if nextcard>cardsleft then  {ran out of cards}
      begin
        if not cardmoved then
        begin
          inc(nomovecycles);
          if ((cardsleft mod 13) = 0) and (not cardmoved)
          then nomovecycles:=maxnomovecycles;
          inc(strikecount);
        end;
        nextcard:=1;   {start over}

        cardmoved:=false;
        inc(cyclecount);
      end;
    end; {loop until out of cards or max no match cycles reached}
    if cardsleft=0 then {A winner! }
    begin
      inc(gameswon);
      inc(cyclestowin,cyclecount);
      if (gamesadded<100) and
         ((allbox.checked)
          or ((strikecount=0) and zerobox.checked)
          or ((strikecount=1) and onebox.checked)
          or ((strikecount>=50) and longbox.checked)
         )
      then
      begin
        inc(gamesadded);
        savedeck[gamesadded]:=savedeck[0];
        memo4.lines.add('    ');
        memo4.lines.add(format('#%3d - Deck for win with %d strikes, %d cycles:',
                               [gamesadded, strikecount,cyclecount]));
        s:=inttostr(savedeck[gamesadded,1]);
        for k:=2 to 52 do s:=s+', '+inttostr(savedeck[gamesadded,k]);
        memo4.lines.add(s);

      end;
      if strikecount<minstrikes then minstrikes:=strikecount;
      if strikecount>maxstrikes then maxstrikes:=strikecount;
      inc(totstrikes, strikecount);
      inc(strikedist[strikecount]);
    end
    else
    begin
      if cardsleft<10 then inc(Moralvictories);
      inc(Gameslost);
      inc(cyclesToLose,cyclecount);
      inc(losingcardsleft[cardsleft]);
    end;
  end;
  with memo4 do Perform(EM_LineScroll,0,-Lines.Count); {Scroll to top of memo}
  screen.cursor:=crDefault;
  inc(totGamesPlayed,GamesPlayed);
  inc(totgamesWon,GamesWon);
  inc(totGamesLost,GamesLost);
  inc(TotMoralVictories,MoralVictories);
  inc(TotcyclesToWin,CyclesToWin);
  inc(TotcyclesToLose,CyclesToLose);
  inc(tottotstrikes,totstrikes);
  sum:=0;

  for i:=0 to high(totStrikeDist) do
  begin
    inc(totstrikeDist[i],strikedist[i]);
    inc(sum,strikedist[i]);
  end;
  {$IFDEF Debug}
     if sum<>gameswon then showmessage(inttostr(sum) +' should be '+inttostr(gameswon));
  {$ENDIF}
  if minstrikes<minminstrikes then minminstrikes:=minstrikes;
  if maxstrikes>maxmaxstrikes then maxmaxstrikes:=maxstrikes;
  QueryPerformanceCounter(Endcount);


  memo1.clear;
  memo5.clear;
  memo6.clear;
  pagecontrol1.activepage:=tabsheet1;
  with memo1,lines do
  begin
    add('This run');
    add(format('     Games played: %.0n',[0.0+Gamesplayed]));
    add(format('     Games won: %.0n (%.1f%%)',[0.0+Gameswon, 100*gameswon/gamesplayed]));
    add(format('     Games lost: %.0n (%.1f%%)',[0.0+gameslost, 100*gameslost/gamesplayed]));
    add(format('     Losses with < 10 cards left: %.0n',[0.0+moralVictories]));
    add(format('     Avg. game length: %5.1f cycles',[(cyclestowin+cyclestolose)/Gamesplayed]));
    if gameswon>0 then
    add(format('     Avg. win game length: %5.1f cycles',[cyclestowin/GamesWon]));
    If gameslost>0 then
    add(format('     Avg. loss game length: %5.1f cycles',[cyclestolose/(GamesLost)]));

    if gameswon>0 then
    begin
      add       ('     Min strikes to win: '+inttostr(minstrikes));
      add(format('     Avg strikes to win: %5.1f',[totstrikes/Gameswon]));
      add       ('     Max strikes to win: '+inttostr(maxstrikes));
    end;
    add(format('     Time per game %5.0f microseconds',[1000000.0*(endcount-startcount)/freq/gamesplayed]));
  end;
  with memo5, lines do
  begin
    add('Since last reset');
    add(format('     Total Games played: %.0n',[0.0+totGamesplayed]));
    add(format('     Total Games won: %.0n  (%.1f%%)',[0.0+totGameswon, 100*totgameswon/totgamesplayed]));
    add(format('     Total Games lost: %.0n  (%.1f%%)',[0.0+totGameslost, 100*totgameslost/totgamesplayed]));

    add(format('     Total Moral Wins: %.0n',[0.0+totMoralVictories]));

    if totgameswon>0 then
    begin
      //add(format('     Avg. cycles to win: %5.1f',[totcyclestowin/totGamesWon]));
      //if totgameslost>0 then add(format('     Avg. cycles to lose: %5.1f',[totcyclestolose/totgameslost]));
      add(format('     Avg. game length: %5.1f cycles',[(totcyclestowin+totcyclestolose)/totGamesplayed]));
    if gameswon>0 then
    add(format('     Avg. win game length: %5.1f cycles',[totcyclestowin/totGamesWon]));
    If gameslost>0 then
    add(format('     Avg. loss game length: %5.1f cycles',[totcyclestolose/(totGamesLost)]));

      if totgameswon >0 then
      begin
        add(format('     Min strikes to win: %.0n',[0.0+minminstrikes]));
        add(format('     Avg strikes to win: %5.1f',[tottotstrikes/totGameswon]));
        add(format('     Max strikes to win: %.0n',[0.0+maxmaxstrikes]));
      end;
      
    end;
  end;


  with memo6, lines do
  begin
    add(Format('Distribution of strike counts for %.0n winning games',[0.0+totgameswon]));
    sum:=0;
    for i:=0 to maxmaxstrikes do
    begin
      add(format('#%3d: %.0n',[i,0.0+totstrikedist[i]]));
      inc(sum,totstrikedist[i]);
    end;
    {$IFDEF Debug}
      if sum<>totgameswon
      then showmessage('Strike distribution sum error');
    {$ENDIF}
  end;

end;

{************* ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i:integer;
begin
  totGamesPlayed:=0;
  totGamesWon:=0;
  totGamesLost:=0;
  totMoralVictories:=0;
  totcyclestowin:=0;
  totcyclestolose:=0;
  tottotstrikes:=0;
  minminstrikes:=1000000;
  maxmaxstrikes:=0;
  for i:=0 to high(totstrikedist) do totstrikedist[i]:=0;
  memo1.clear;
  gameswon:=0;
  memo1.clear;
  memo2.visible:=true;
  memo3.visible:=false;
  memo3.clear;
  memo4.clear;
  memo5.clear;
  memo6.clear;
end;


{*****************  FormActivate ********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;  {initialize random number generator}
  resetbtnclick(sender);
  setmemomargins(memo2,10,10,10,10);
  reformatmemo(memo2);
  memo2.bringtofront;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************** Memo4.click ************}
procedure TForm1.Memo4Click(Sender: TObject);
{User Clicked on a winning game to see it replayed}
var
  winnbr:integer;
  deck:TDeck;
  nextcard,nextguess:integer;
  Nomovecycles:integer;
  cardsleft:integer;
  cardmoved:boolean;
  cyclecount:integer;
  s:string;
  index, j:integer;
begin
  if gameswon>0 then
  with memo4 do
  begin
    j:=caretpos.y;
    index:=j;
    while (index>j-4) and (length(lines[index])>0) and (lines[index][1]<>'#') do dec(index);
    If (length(lines[index])>0) and (lines[index][1]='#') then
    begin
      winnbr:=strtoint(copy(lines[index],2,3));
      deck:=savedeck[winnbr];

      {now replay this game displaying each move}
      cardsleft:=52;
      nomovecycles:=0;
      cardmoved:=false;
      nextguess:=1;
      nextcard:=1;
      cyclecount:=0;
      memo3.clear;
      memo3.lines.add('Replaying game #'+inttostr(winnbr));
      memo3.lines.add('Turned card vs. Player guess');

      while (cardsleft>0) and (nomovecycles<maxnomovecycles) do
      with memo3 do
      begin
        s:=inttostr(deck[nextcard])+' vs. '+inttostr(nextguess);
        If deck[nextcard]=nextguess then {good guess}
        begin   {delete the card}
          for j:=nextcard to cardsleft-1 do deck[j]:=deck[j+1];
          dec(cardsleft);
          cardmoved:=true;
          nomovecycles:=0;
          s:=s+' Matched, deleted, '+inttostr(cardsleft)+' left' ;
          lines.add(s);
        end
        else
        begin
         inc(nextcard);
         memo3.lines.add(s);
        end;
        if cardsleft>0 then {no need to do this if we have already won}
        begin
          inc(nextguess); {our next guess}
          If nextguess>13 then nextguess:=1;
          if nextcard>cardsleft then  {ran out of cards}
          begin
            if not cardmoved then inc(nomovecycles);
            nextcard:=1;   {start over}
            cardmoved:=false;
            inc(cyclecount);
            memo3.lines.add('Start cycle #'+inttostr(cyclecount+1));
          end;
        end;
      end;
      if cardsleft>0 then showmessage('System error - "winning" game isn''t!');
      with memo3 do Perform(EM_LineScroll,0,-Lines.Count); {Scroll to top of memo}
    end;
  end;

end;


end.
