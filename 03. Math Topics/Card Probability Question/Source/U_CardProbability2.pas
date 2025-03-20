unit U_CardProbability2;
{Copyright © 2006, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Given two card rank values, the question is:  What is the
probability that there are one or more occurrences of the two
values being adjacent or with only one intervening card in a
well shuffled standard 52 card deck?

This program finds the answer  experimentally.  The matching
procedure is to move through a shuffled deck from cards 1 trough 50,
checking each card against the two cards following for a
match against the two test values, checked in either order.
The card in position 51 is, of course, only checked against
card 52 for a match in either order.

If at least 1 match is found, the trial counts as a success.

There is an option to only test against the adjacent card and not against the
2nd card in order to check the probability of selected ranks adjoining each other.

----------------------------------
October 2009:  Version 2 of the program adds adjustable deck size by
specifying the number of suits in the deck and the number of card values per
suit.  It also adds an analytical solution providing exact probabilities.  These
confirm the earlier experimental results.

The algorithm used is based on C code from Mark Rickert.  A hidden button, Button2, invokes
my line-for-line translation of his C code.  It only handles the "adjacent or
intervening card" case and does not consider cases where the 2 card values are
the same but those are fairly simple extensions.
For testing, Ctrl C toggles visibility of Button2.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, shellAPI, dffutils{,UBigIntsV3};

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Label2: TLabel;
    SpinEdit2: TSpinEdit;
    Memo2: TMemo;
    Memo3: TMemo;
    Label4: TLabel;
    HitGrp: TRadioGroup;
    StaticText1: TStaticText;
    Label5: TLabel;
    Label6: TLabel;
    NbrSuitsEdt: TSpinEdit;
    NbrvaluesEdt: TSpinEdit;
    StatsBtn: TButton;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    SpinEdit3: TSpinEdit;
    GoBtn: TButton;
    ResetBtn: TButton;
    Memo4: TMemo;
    Button2: TButton;

    procedure GoBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure HitGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure NbrSuitsEdtChange(Sender: TObject);
    procedure NbrvaluesEdtChange(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure StatsBtnClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    public
    Decksize:Integer;
    NbrSuits:integer;
    Nbrvalues:integer;
    CardVal1, cardval2:integer;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses math;


var
  successes:integer=0; {Count of successes since last reset}
  tottrials:integer=0; {Total trial since last reset}

{*********** GoBtnClick ************}
procedure TForm1.GoBtnClick(Sender: TObject);
{Run the specified number of trials}
var
  i:integer;
  //v1,v2:integer; {the two ranks to check}
  deck:array[1..52] of integer; {the "card" deck, ranks only}
  count,nbrtrials:integer;
  cursuccess:integer;  {nbr of matches within a single shuffle}
  s:string;

      procedure shuffle;
      {Shuffle the deck}
      var
        i,j,temp:integer;
        begin
          for i:= Decksize {52} downto 1 do
          begin
            j:=random(i)+1;
            temp:=deck[i];
            deck[i]:=deck[j];
            deck[j]:=temp;
          end;
        end;

begin
  for i:=1 to Decksize{52} do deck[i]:=(i-1) mod Nbrvalues{13} +1; {make the deck}
  nbrtrials:=spinedit3.value;
  inc(tottrials,nbrtrials);
  memo3.clear;
  screen.Cursor:=crHourGlass;
  for count:= 0 to (nbrtrials-1)  do
  begin
    for i:=1 to Decksize{52} do deck[i]:=(i-1) mod Nbrvalues{13} +1; {make the deck}
    shuffle;
    cursuccess:=0;
    for i:=1 to Decksize-1 {51} do {for each of 1st 51 cards}
    begin
      {check both values against next card}
      if ((deck[i]= Cardval1) and (deck[i+1]=CardVal2))
        or ((deck[i]= Cardval2) and (deck[i+1]=Cardval1))
      then
      begin
        inc(cursuccess);
        break;
      end
      {else if we're checking for one intervening and we are in 1st 50 cards}
      else if (hitgrp.itemindex=1) and (i<=Decksize-2 {50}) and
      (
        ((deck[i]= Cardval1) and (deck[i+2]=Cardval2))  {check both values against 2nd card down}
        or ((deck[i]= CardVal2) and (deck[i+2]=cardval1))
      )
      then
      begin
        inc(cursuccess);
        break;
      end;
    end;
    {If any matches, then  it was a success}
    if cursuccess>0 then inc(successes);
    {display 1st 50 trials}
    if count<=50 then
    begin
      s:=inttostr(deck[1]);
      for i:=2 to Decksize {52} do s:=s+','+inttostr(deck[i]);
      s:=s+' Matches: '+inttostr(cursuccess);
      if cursuccess>0 then s:=s+', Success!';
      memo3.lines.add(s);
      memo3.lines.add('');
    end;
  end;  {end trials loop}
  screen.Cursor:=crDefault;
  memo2.Clear;
  memo2.lines.Add('Nbr trials ='+inttostr(tottrials));
  memo2.lines.Add('Nbr successes ='+inttostr(successes));
  memo2.lines.add(format('Probability of success: %6.3f',[successes/tottrials]));
end;

{********* FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  reformatmemo(memo1);
  cardval1:=spinedit1.value;
  cardval2:=spinedit2.value;
  resetbtnclick(sender);
end;
{********** ResetBtnClick ********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  tottrials:=0;
  successes:=0;
  memo2.Clear;
  memo2.lines.Add('Nbr trials = 0');
  memo2.lines.add('Nbr Successes = 0');
  memo2.lines.add('Probability of success = 0.00');
  memo4.Clear;
  memo4.Lines.add('Analytical results here');
  NbrSuits:=NbrSuitsEdt.Value;
  NbrValues:=NbrvaluesEdt.Value;
  Decksize:=NbrSuits*Nbrvalues;
end;

{******* HitGrpClick ********}
procedure TForm1.HitGrpClick(Sender: TObject);
{Success definition changed - reset stats}
begin
  resetbtnclick(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.NbrSuitsEdtChange(Sender: TObject);
begin
  with TSpinedit(sender)do if text='' then exit;
  NbrSuits:=NbrSuitsEdt.value;
  Decksize:=nbrsuits*nbrvalues;
  resetbtnclick(sender);
end;

procedure TForm1.NbrvaluesEdtChange(Sender: TObject);
begin
  with TSpinedit(sender) do if text='' then exit;
  Nbrvalues:=NbrvaluesEdt.value;
  Decksize:=nbrsuits*nbrvalues;
  with spinedit1 do
  begin
    MaxValue:=nbrvalues;
    if value>maxvalue then value:=maxvalue;
  end;
  with spinedit2 do
  begin
    MaxValue:=nbrvalues;
    if value>maxvalue then value:=maxvalue;
  end;
  Resetbtnclick(sender);
end;

procedure TForm1.SpinEdit1Change(Sender: TObject);
begin
  with TSpinedit(sender) do if text='' then exit;
  cardval1:=spinedit1.Value;
  resetbtnclick(sender);
end;


procedure TForm1.SpinEdit2Change(Sender: TObject);
begin
  with TSpinedit(sender) do if text='' then exit;
  cardval2:=spinedit2.Value;
  resetbtnclick(sender);
end;



{******** GetCombocount ***********}
function GetComboCount(n,r:Integer):int64;
{Converted from a C version submitted by Mark Rickert}
  var
    c:int64;   {long long c;}
    i:integer;  {int i;}
  begin
    result:=0;
    if n<r then exit; //  if (n < r)  return 0LL;
    c:=1;   // c = 1LL;
    for i:=1 to r do  //  for (i = 1; i <= r; i++)
    begin         // {
      c:= c*n; dec(n);  //	c *= (long long) n--;
      c:= c div i; //	c /= (long long) i;
    end;          //    }
    result:=c;    //    return c;
  end;

(* {The old, SLOW, way}
{**************** GetComboCount *************}
procedure GetCombocount(Const r,n:integer; var ccount:TInteger);
{Return number of combinations -- n things taken r at a time
 without replacement}
{Return number of combinations -- n things taken r at a time
 without replacement}
  var
    work:TInteger;
  begin
    work:=TInteger.create;
    if (r>0) and (r<n) then
    begin
      ccount.assign(N);
      ccount.factorial;
      work.assign(r); work.factorial;
      ccount.divide(work);
      work.assign(n-r); work.factorial;
      ccount.divide(work);
    end
    else if r=n then ccount.assign(1)
    else ccount.assign(0);
    work.Free;
  end;
*)

{************ StatsBtnClick ***********8}
procedure TForm1.StatsBtnClick(Sender: TObject);
{calculate exact probability}
var
  r,n:integer;
  i,j,k:integer;
  x:array of integer;
  mask:array of integer;
  incpos:integer;
  Count1,Count2:Int64;
  noNeighborscount, nosolutionCount, totSolutionCount:int64;
  checkdist:integer;
begin
  cursor:=crHourglass;

  {enumerate the distributions of the "nbrsuits" values of cardval1 across the
   "decksize" cards}
  n:=decksize;
  r:=nbrsuits;
  setlength(mask, decksize+1);
  setlength(x,r+1);
  for i:= 1 to r do x[i]:=i;
  dec(x[r]); {so that the 1st time though we select 1st combo}

  count1:=GetComboCount(n,r);
  count2:=GetComboCount(n-r,r);
  {Enumerate combinations of ways to distribute r suits of value1 across the
   N cards in the deck}
  if hitgrp.itemindex=0 then checkdist:=1 else checkdist:=2;
  totsolutioncount:=0;
  for i:= 1 to count1 do
  begin
    {find the position to increment starting with rightmost}
    incpos:=r;
    {Count down until we find one that is not at max}
    while x[incpos]>=n-r+incpos do dec(incpos);
    {Increment that one}
    inc(x[incpos]);
    {And set rest from there to end to previous nbr + 1}
    for j:=incpos+1 to r do x[j]:=x[j-1]+1;

     {X  array of positions for vaule1 has been built}

    {Now build an array with all of the positions filled by value1 and its
     neighboring positions marked as unavailable, then count the non-neighbor
     positions.  The number of ways that we can distribute
     2nd card value across those positions is the number of non-solution outcomes.
     }
    If cardval1=cardval2 then
    begin  {the equal value case}
      {we'll just count solutions in this "equal rank" case}
      for j:=1 to nbrsuits-1 do {if any two postions are "neighbors" then it's a solution}
      begin
        if x[j+1]=x[j]+1 then
        begin
          inc(totSolutionCount,count2);
          break;
        end;
        if (hitgrp.itemindex=1) and (x[j+1]= x[j]+2) then
        begin
          inc(totSolutionCount, count2);
          break;
        end;
      end;
    end
    else
    begin
      for j:=1 to decksize do mask[j]:=0;
      for j:=1 to nbrsuits do

      begin  {mark the position of card value and its neighbors}
        for k:=x[j]-checkdist to x[j]+checkdist do
        if (k>=1) and (k<=decksize) then mask[k]:=1;
      end;
      noNeighborscount:=0;  {COunt the positions which are in neighbors of valeu1}
      for j:=1 to decksize do if mask[j]=0 then inc(noNeighborscount);
      {The numer of negative outsome is the number ways that we can place the
       2nd cards in these non-neighbor positions}
      nosolutioncount:=GetComboCount(noneighborscount,nbrsuits);
      inc(totSolutionCount, count2-nosolutioncount);
    end;
  end;

  with memo4 do
  begin
    clear;
    lines.add('Successful / Total possible = Probability');
    lines.add(format(' %.0n / %.0n = %.6f',
            [totSolutionCount+0.0, count1*count2+0.0, TotSolutionCount/(count1*count2)]));
  end;
  cursor:=crdefault;
end;


(*
procedure TForm1.Button2Click(Sender: TObject);
var
  i:integer;
  Suits:integer;
  //Ranks:integer;
  Deck:integer;
  Min_Mask:int64;
  Max_Mask:int64;
  Neighbor_mask:int64;
  Zeros:array[0..15] of byte;
  count:int64;


  function countzeros(n:byte):integer;
  var
    i:integer;
  begin
    result:=0;
    for i:=0 to 7 do if (1 shl i) and n >0 then inc(result);
  end;




  procedure next_card(const N:integer; const prev_card, all_cards:int64);
  var
    new_card,neighbor_bits:int64;
    i, non_neighbor_count:integer;


  //void next_card(int n, unsigned long long prev_card, unsigned long long all_cards)
//{
//    unsigned long long new_card, neighbor_bits;
//    int i, non_neighbor_count;
begin
  if n<nbrsuits then   //if (n < SUITS)
  begin  // {
    if n=0 then //	if (n == 0)
	    new_card:=min_mask  //  new_card = MIN_MASK;
	  else  //else
	    new_card:=prev_card shl 1; //  new_card = prev_card<<1;
    while	new_card<= max_mask do //.for( ; new_card <= MAX_MASK; new_card <<= 1)
    begin // {
      next_card(n+1, new_card, all_cards or new_card); // next_card(n+1, new_card, all_cards | new_card);
      new_card:= new_card shl 1;
    end //	}
  end //  }
  else //  else
  begin  //{
	  neighbor_bits := all_cards or neighbor_mask; // neighbor_bits = all_cards | NEIGHBOR_MASK;
	  non_neighbor_count:=0;  //non_neighbor_count = 0;
	  for i:= 0 to 15 do // for (i = 0; i < 16; i++)
    begin  //{
	    inc(non_neighbor_count, zeros[neighbor_bits and 15]);// non_neighbor_count += zeros[neighbor_bits & 0x0fLL];
	    neighbor_bits:=neighbor_bits shr 4; // neighbor_bits >>= 4;
	  end;
	  count:= count +GetComboCount(deck-Suits, suits)-GetComboCount(non_neighbor_count,suits);  //  count += combin(DECK-SUITS, SUITS) - combin(non_neighbor_count, SUITS);
  end;//  }
end; //}



begin
  Suits:=nbrsuits;
  //Ranks:=NbrValues;
  Deck:=Decksize;
  Min_mask:=5;
  Max_mask:=Min_mask shl (Deck-1);
  Neighbor_Mask:=(int64(3) or ($7fffffffffffffff Xor ((1 shl (Deck+2))-1)));
  For i:=0 to 15 do zeros[i]:=countzeros(i);
  count:=0;
  next_card(0,0,0); //    next_card(0, 0LL, 0LL);
  memo2.clear;
  // printf("probability = %lld / %lld = ", count, combin(DECK, SUITS)*combin(DECK-SUITS, SUITS));
  memo2.lines.add(format('Probability %d / %d = ',
            [count, GetComboCount(deck,suits)*GetComboCount(deck-suits,suits)]));

  // printf("%lf\n", (double) count / (double) (combin(DECK, SUITS)*combin(DECK-SUITS, SUITS)));
  memo2.lines.add(format('%.6f', [count/(GetComboCount(deck,suits)*GetComboCount(deck-suits,suits))]));
end; // }
*)

{Mark Rickert's C code translated to Delphi }
{Button2 visibility can be toggled on or off by pressing Ctrl C keys}
procedure TForm1.Button2Click(Sender: TObject);
var
  Deck: array of integer;
  count:int64;

      //
      // sets and clears neighbor bits
      // each suit gets a different bit so we don't have to worry about clearing a bit that was set by a different card
      //
      Procedure Toggle_Neighbors(n,card:integer);  //void toggle_neighbors(int n, int card)
      var //{
        i,bit:integer;  //  int i, bit;
      begin
         bit:=1 shl n;  // bit = 1 << n;
         for i:= max(0,card-2) to min(decksize, card+2) do // for (i = max(0, card-2); i <= min(DECK, card+2); i++)
         begin //{
           deck[i]:=deck[i] xor bit;  //	deck[i] ^= bit;
         end;  //}
       end; //}

      //
      // computes all ways to arrange the first rank throughout the deck
      // there are DECK choose SUITS ways to do this
      // for each arrangement, calculate the number of positions (non_neighbor_count) that are at least three away from the nearest first rank card
      // the second rank cards can be distributed among these positions to NOT provide a solution
      // there are non_neighbor_count choose SUITS ways to do this
      // therefore, the number of solutions for a given arrangement is (DECK-SUITS choose SUITS) - (non_neighbor_count choose SUITS)
      //
      // n is the number of cards placed so far
      // prev_card is the suit of the previously placed card (-1 means we're just starting)
      //
      procedure Next_Card( n, prev_card:integer); //void next_card(int n, int prev_card)
      var //{
        new_card:integer; // int new_card;
        i, non_neighbor_count: integer;  //int i, non_neighbor_count;
      begin
        if n<nbrsuits then  //if (n < SUITS)
        begin  //{
          for new_card:= prev_card+1 to Decksize-1 do  //for (new_card = prev_card + 1; new_card < DECK; new_card++)
          begin //{
            toggle_neighbors(n,new_card);  //toggle_neighbors(n, new_card);
            next_card(n+1, new_card);    //next_card(n+1, new_card);
            toggle_neighbors(n,new_card);  //toggle_neighbors(n, new_card);
          end; // }
        end //}
        else
        begin  //{
          non_neighbor_count := 0;  //non_neighbor_count = 0;
          for i:=0 to decksize-1 do  //for (i = 0; i < DECK; i++)
          begin  //{
            if deck[i]=0    //if (deck[i] == 0)
            then inc(non_neighbor_count); // 	non_neighbor_count++;
          end; //}
          count:=count+getcombocount(Decksize-nbrsuits, nbrsuits) - getcombocount(non_neighbor_count,nbrSuits); //  count += combin(DECK-SUITS, SUITS) - combin(non_neighbor_count, SUITS);
        end; //}
      end;  //}
      
  var totcount:int64;
       //void main(void)
  begin  //{
    setlength(deck, decksize);
    count:=0;
    next_card(0,-1);  // next_card(0, -1);	// 0 cards placed, last card position was -1
    totcount:= getcombocount(DECKSize, NbrSUITS)*getcombocount(DECKSize-NbrSUITS, NbrSUITS);
    memo4.Lines.Clear;
    memo4.lines.add(format('Probability: %d / %d',[count,totcount ])); //printf("probability = %lld / %lld = ", count, combin(DECK, SUITS)*combin(DECK-SUITS, SUITS));
    memo4.Lines.add(format('%.6f',[count/totcount])); //printf("%lf\n", (double) count / (double) (combin(DECK, SUITS)*combin(DECK-SUITS, SUITS)));
  end; //}



procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If  (ssCtrl in shift) and (key=ord('C')) then button2.Visible:=not button2.Visible;
end;

end.

(*

#include <stdio.h>
#include <stdlib.h>

#define SUITS 4
#define RANKS 13
#define DECK (SUITS * RANKS)

// 38769062856 / 52677670500 = 0.735968

long long count = 0;
int deck[DECK] = {0};

//
// returns n choose r (combinations of n things taken r at a time)
//
long long combin(int n, int r)
{
    long long c;
    int i;

    if (n < r)
	return 0LL;

    if (r > n/2)
	r = n - r;

    c = 1LL;
    for (i = 1; i <= r; i++) {
	c *= (long long) n--;
	c /= (long long) i;
    }
    return c;
}

//
// sets and clears neighbor bits
// each suit gets a different bit so we don't have to worry about clearing a bit that was set by a different card
//
void toggle_neighbors(int n, int card)
{
    int i, bit;

    bit = 1 << n;
    for (i = max(0, card-2); i <= min(DECK, card+2); i++) {
	deck[i] ^= bit;
    }
}

//
// computes all ways to arrange the first rank throughout the deck
// there are DECK choose SUITS ways to do this
// for each arrangement, calculate the number of positions (non_neighbor_count) that are at least three away from the nearest first rank card
// the second rank cards can be distributed among these positions to NOT provide a solution
// there are non_neighbor_count choose SUITS ways to do this
// therefore, the number of solutions for a given arrangement is (DECK-SUITS choose SUITS) - (non_neighbor_count choose SUITS)
//
// n is the number of cards placed so far
// prev_card is the suit of the previously placed card (-1 means we're just starting)
//
void next_card(int n, int prev_card)
{
    int new_card;
    int i, non_neighbor_count;

    if (n < SUITS) {
	for (new_card = prev_card + 1; new_card < DECK; new_card++) {
	    toggle_neighbors(n, new_card);
	    next_card(n+1, new_card);
	    toggle_neighbors(n, new_card);
	}
    }
    else {
	non_neighbor_count = 0;
	for (i = 0; i < DECK; i++) {
	    if (deck[i] == 0)
		non_neighbor_count++;
	}
	count += combin(DECK-SUITS, SUITS) - combin(non_neighbor_count, SUITS);
    }
}

void main(void)
{
    next_card(0, -1);	// 0 cards placed, last card position was -1
    printf("probability = %lld / %lld = ", count, combin(DECK, SUITS)*combin(DECK-SUITS, SUITS));
    printf("%lf\n", (double) count / (double) (combin(DECK, SUITS)*combin(DECK-SUITS, SUITS)));
}


*)

