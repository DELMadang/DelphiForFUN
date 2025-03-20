unit U_SixOfAKind2;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
In a popular club game, 6 dice are thrown and the
player wins if all six show the same number.  If you get
3 tries for $1 (rolling 6 dice each time) and the payoff
is $1,000, is it a fair game?

The program computes and displays theroectical and experimental results to
crosscheck each other.

Version 2 produces the same results as Version 1 but implements a shared
procedure to display results}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, shellAPI;

type
  TCaseRec = record {record naming the line item strings for case output displays}
    CaseName, Question, Answer, Because:string;
  end;

  TForm1 = class(TForm)
    Panel1:TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    StaticText1: TStaticText;
    Case1Btn:TButton;
    Case2Btn:TButton;
    Case3Btn:TButton;
    Case4Btn:TButton;
    procedure Case2BtnClick(Sender: TObject);
    procedure Case3BtnClick(Sender: TObject);
    procedure Case4BtnClick(Sender: TObject);
    procedure Case1BtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    Public
      trials:integer; {number of trials to run, currently 1,000,000}
      hits:integer;    {# of successful otucomes}
      buttonsPressed:boolean; {"first button click" flag}
      Winnings, MaxWinnings, MinWinnings:double;
      odds:double;
     LossString, MinLossString, MaxLossString:integer;
      Procedure InitButton; {Initial display area when 1st button is clicked}
      Procedure ShowResults(N:integer);
      procedure markwin(OK:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  {Tailored output messages for each case}
  casemsg:array[1..4] of TCaserec=
   ((Casename:'Case1: Six "1"s';
    Question:'We throw six dice, what is the probability of six "1"s?';
    Answer:'Answer:  1/6  x  1/6 x 1/6 x 1/6  x 1/6 x 1/6 = 0.000021';
    Because:'Because there is only one of the 6 possible results for each die that counts as success.'),
    (Casename:'Case 2:  Six of a Kind';
    Question:'We throw six dice, what is the probability of six any one number?';
    Answer:'Answer:  6/6  x  1/6 x 1/6 x 1/6  x 1/6 x 1/6 = 0.000129';
    Because:'Because the first die can be any number but the rest must match it.' ),
    (Casename:'Case 3:  1,2,3,4,5,6 in that order';
    Question:'We throw six dice one at a time so they that can be lined up from left to right.  What is the probability that they will read 1 2 3 4 5 6?';
    Answer:'Answer:  1/6  x  1/6 x 1/6 x 1/6  x 1/6 x 1/6 = 0.000021';
    Because:'Because for each roll there is only 1 of the 6 outcomes that counts as success.'),
    (Casename:'Case 4:  1,2,3,4,5,6 in any order';
    Question:'We throw six dice all at once. What is the probability of they show 1 2 3 4 5 6 any order?';
    Answer:'Answer:  6/6  x  5/6 x 4/6 x 3/6  x 2/6 x 1/6  = 0.015432';
    Because:'Because the first die can be any number but each one after that has one less choice.' )
   );


{*********** IntPower **********}
function intpower(a, b: int64): int64;
{ Integer "a" raised to power "b"}
var i: integer;
begin
  Result := 1;
  for i := 1 to b do Result := Result * a;
end;

{************ Factorial *********8}
function Factorial(n: int64): int64;
{result = product of integers from 1 to "n"}
var  i: integer;
begin
  Result := 1;
  for i := 2 to n do Result := Result * i;
end;


{*********** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  buttonspressed:=false;
  negcurrformat:=1;
end;

{*********** InitButton ***********}
Procedure TForm1.Initbutton;
{Called once, when the first button is clicked}
begin
  if not buttonspressed then
  begin
    buttonspressed:=true; {so we only do this once}
    memo1.clear;  {Clear the introductory text and }
    memo1.font.size:=8;  {reduce text size so that result items can fit on one line}
  end;
  trials:=1000000;
  hits:=0;
  minLossString:=trials;
  MaxLossString:=0;
  LossString:=0;
  maxwinnings:=0;
  minwinnings:=trials;
  winnings:=0;
end;


{*********** Case1BtnClick *********}
procedure TForm1.Case1BtnClick(Sender: TObject);
{Six "1"s}
var
 i,j, target:integer;
 OK:boolean;

begin
  Initbutton;
  odds:=intpower(6,6);
  for i:= 1 to trials do
  begin
    target:=0;{we generate #s from 0 to 5, so we'll check for 0}
    ok:=true;
    for j:=0 to 5 do if random(6) <> target then
    begin    {result did not equal target so this trial is a failure}
      OK:=false;
      break; {might as well stop testing for ths trial}
    end;
    Markwin(ok);
  end;
  Showresults(1); {1st case, Probability= 1/6^6}
end;

{********* Case2BtnClick ***********}
procedure TForm1.Case2BtnClick(Sender: TObject);
{Six of a kind}
var
 i,j,target:integer;
 OK:boolean;
begin
  InitButton;
  odds:=Intpower(6,5);
  for i:= 1 to trials do
  begin
    target:=random(6); {set a random target value}
    ok:=true;
    for j:=1 to 5 do if random(6) <> target then {check the next 5 tosses}
    begin   {result did not equal target so this trial is a failure}
      OK:=false;
      break; {might as well stop testing for ths trial}
    end;
    markwin(OK);
  end;
  showresults(2 {,1/IntPower(6,5)});
end;



{********** Case3BtnClick **********}
procedure TForm1.Case3BtnClick(Sender: TObject);
{1,2,3,4,5,6 in that order}
var
 i,j:integer;
 OK:boolean;
begin
  Initbutton;
  Odds:=Intpower(6,6);
  for i:= 1 to trials do
  begin
    ok:=true;
     {check if "Jth" value is J}
    for j:=0 to 5 do if random(6) <> j then
    begin {Jth value <> J}
      OK:=false;
      break;  {might as well stop testing for ths trial}
    end;
    MarkWin(OK);
  end;
  showresults(3);
end;



{************ Case4BtnClick ************}
procedure TForm1.Case4BtnClick(Sender: TObject);
{1,2,3,4,5,6 in any order}
var
 i,j,n:integer;
 found:array [0..5] of boolean;
 OK:boolean;
begin
  Initbutton;
  Odds:=intpower(6,6)/factorial(6);
  for i:= 1 to trials do
  begin
    for j:=0 to 5 do found[j]:=false;
    ok:=true;
    for j:=0 to 5 do
    begin
      n:=random(6);
      if found[n] then
      begin
        OK:=false;
        break; {might as well stop testing for ths trial}
      end
      else found[n]:=true;
    end;
    MarkWin(OK);
  end;
  showresults(4);
end;

{********* MarkWin *********}
procedure Tform1.markwin(OK:boolean);
{Check results of a game, OK=True ==>winner}
  begin
    winnings:=winnings-1;  {Subtract the $1 it costs to play}
    if OK then {a winner!}
    begin
      inc(hits); {All 6 results did match the target so add 1 to success count}
      if LossString< minlossstring then minlossstring:=lossstring;
      if LossString> maxlossstring then maxlossstring:=lossstring;
      LossString:=0;
      winnings:=winnings+odds;
      If winnings>maxWinnings then MaxWinnings:=winnings
    end
    else
    begin  {Loser :>( }
      inc(lossString);
      If winnings<minwinnings then MinWinnings:= winnings;
    end;
  end;

{************ ShowResults ***************}
Procedure TForm1.ShowResults(n:integer);
{Generalized routine to display results given the case number and the
 probability of success for any single trial}
 var P:double;
begin
  p:=1/odds;
  with memo1, lines do
  begin
    add(format('Case %d: Found %d hits in %.0n trials.  P=%.6f',[N, hits, trials+0.0, hits/trials]));
    add(format('Shortest loss string: %d, Longest loss string: %d',[MinLossString, MaxLossString]));
    add(format('At $1 per game and %.0n payout, final gain or loss is %.0m',[odds, Winnings]));
    add(Format('Max drawdown: %.0m, Max gain: %.0m',[minWinnings,maxwinnings]));
    add('');
  end;
  with memo2, lines, CaseMsg[n] do
  begin
    clear;
    add(Casename+#13);
    add(''); add(Question);
    add(''); add(Answer);
    add(''); add(Because);
    add('');
    add(format('%.0f wins per %.0n trials or about in 1 in %.2f.',[trials*p,trials+0.0,odds]));
    add(format('The fair value payout for winning on a $1 bet is %.2m.',[odds]));
  end;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
