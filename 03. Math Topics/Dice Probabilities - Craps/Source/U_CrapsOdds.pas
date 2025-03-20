unit U_CrapsOdds;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All
 other rights are reserved
 }
{
Craps is a dice game with scoring based sum of rolling 2 dice.
A game ends in a single roll if the player wins if he rolls a 7 or
11 (a Natural), or loses  if he rolls a 2, 3, or 12 (Craps).

If the first roll is one of the other possibilities, 4, 5, 6, 8, 9, or
10, that sum is called the "point". and the game continues with
additional rolls until the point is rolled again (a win) or a 7 is
rolled (a loss).

This program calculates the theoretical chances of winning or
losing for each of the eleven initial roll possible outcomes (2
through 12). It also has a page which simulates a million games
to veify that the theroretical results are valid.

}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ComCtrls, Grids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    WinBth: TButton;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid2: TStringGrid;
    Label3: TLabel;
    Label4: TLabel;
    Memo2: TMemo;
    LoseBtn: TButton;
    Memo3: TMemo;
    TabSheet4: TTabSheet;
    Memo4: TMemo;
    ExperimentBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure WinBthClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LoseBtnClick(Sender: TObject);
    procedure ExperimentBtnClick(Sender: TObject);
  public
    freq:array[2..12] of integer; {Number of ways each sum can occur}
    prob:array[2..12] of extended; {probability that each sum occurs on a single roll}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{Die sum frequencies}
{Sum: 2       3       4       5       6       7       8       9       10      11      12 }
{--------------------------------------------------------------------------------------- }
{Ways 1       2       3       4       5       6       5       4       3       2       1     total=36}
{Odds 1/36    1/18    1/12     1/9    5/36    1/6     5/36    1/9     1/12    1/18    1/36 }


{************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,j:integer;
begin
  {Fill a grid with all possible sums when 2 dice are thrown}
  for i:= 2 to 12 do freq[i]:=0;
  with stringgrid1 do
  begin
    for i:=1 to 6 do
    begin
      cells[0,i]:=inttostr(i);
      cells[i,0]:=cells[0,i];
      for j:=1 to 6 do
      begin
        cells[i,j]:=inttostr(i+j);
        inc(freq[i+j]);
      end;
    end;
  end;
  {Report  frequency distribution of sums}
  with stringgrid2 do
  for i:=2 to 12 do
  begin
    cells[i-2,0]:=inttostr(i);
    cells[i-2,1]:=inttostr(freq[i]);
    prob[i]:=freq[i]/36;
  end;

  randomize;  {randomize 1st experimental result}
end;


{*************** WinBtnClick ******************}
procedure TForm1.WinBthClick(Sender: TObject);
{Display all ways of winning and the Chance (probability) of winning for each way}
var
  p,sum:extended;
  i:integer;
begin
  with memo2, lines do
  begin
    clear;
    add('Chance of throwing a "Natural"  (7 or 11 on first roll)');
    add(format('    Chance of 7: %d/%d = %6.4f',[freq[7],36,prob[7]]));
    add(format('    Chance of 11: %d/%d = %6.4f',[freq[11],36,prob[11]]));
    add(format('    Chance of either: %6.4f',[prob[7]+prob[11]]));
    add('');
    add('Chance of making a specific point (a second occurrence of the point before a 7)');
    add('    Chance of point times chance of rolling the point before 7 on a subsequent roll');
    add('');
    add('    For example, the chance that point = 4 is 3 out of 36 possible outcomes, (3/36).');
    add('    Once 4 is the point, we must roll another 4 before a 7 and there are 6 ways to roll a 7,');
    add('    so out of the 9 ways to roll a 4 or 7, only 3 of those will be a 4 and odds are 3/9 or 1/3.');
    add('    Rolling a 4 and then another 4 before a 7 are independent events, so probability of');
    add('    both events is the product of the two:  3/36 * (1/3) = 1/36');
    add('');

    sum:=0;
    for i:=4 to 10 do
    if i<>7 then
    begin
      p:=prob[i]*freq[i]/(freq[i]+freq[7]);
      add(format('    Chance of %d: (%d/%d)*(%d/(%d+%d)) = %6.4f',
         [i,freq[i],36,freq[i],freq[i],freq[7],
                  p]));
      sum:=sum+p;
    end;
    add(format('    Chance of win by making any point is sum of individual chances: %6.4f',[sum]));
    add('');
    add(format('Overall chance of winning (Natural or making point): %6.4f',[prob[7]+prob[11]+sum]));
  end;
end;




{**************** LoseBtnClick *************}
procedure TForm1.LoseBtnClick(Sender: TObject);
{Display all ways of losing and the Chance (probability) of losing for each way}
var
  p,sum:extended;
  i:integer;
begin
  with memo3, lines do
  begin
    clear;
    add('Chance of throwing craps"  (2, 3, or 12 on first roll)');
    add(format('    Chance of 2: %d/%d = %6.4f',[freq[2],36,prob[2]]));
    add(format('    Chance of 3: %d/%d = %6.4f',[freq[3],36,prob[3]]));
    add(format('    Chance of 12: %d/%d = %6.4f',[freq[12],36,prob[12]]));
    add(format('    Chance of 2, 3, or 12: %6.4f',[prob[2]+prob[3]+prob[12]]));
    add('');
    add('Chance of not making point (chance of a 7 before second occurrence of point)');
    add('    Chance of the point times chance of 7 before point');


    sum:=0;
    for i:=4 to 10 do
    if i<>7 then
    begin
      p:=prob[i]*freq[7]/(freq[i]+freq[7]);
      add(format('    Chance of not making  %d: (%d/%d)*(%d/(%d+%d)) = %6.4f',
         [i,freq[i],36,freq[7],freq[i],freq[7],
                  p]));
      sum:=sum+p;
    end;
    add(format('    Chance of not making any point: %6.4f',[sum]));
    add('');
    add(format('Overall Chance of losing (Craps or not making point): %6.4f',[prob[2]+prob[3]+prob[12]+sum]));
  end;

end;

{************** ExperimentBtnClick *************}
procedure TForm1.ExperimentBtnClick(Sender: TObject);
{Simulate playing a miilion games and report results}
var
  winners, losers:array[2..12] of integer;
  i,j,n:integer;
  d1,d2,sum:integer;
  w,L:extended;
  Wp,Lp,WTot,LTot:extended;
  TotWinners, TotLosers:integer;
begin
  n:=1000000;
  for i:=2 to 12 do
  begin
    winners[i]:=0;
    losers[i]:=0;
  end;

  for i:= 1 to n do
  begin
    d1:=random(6)+1;  {"Throw the dice}
    d2:=random(6)+1;
    sum:=d1+d2;  {add them up}
    case sum of  {calulate win or loss based on the sum}
      2,3,12: inc(losers[sum]); {Craps - losers}
      7,11: inc(winners[sum]);  {Naturals - winners}
      4,5,6,8,9,10: {Point, play on}
      begin
        repeat  {keep throwing}
          d1:=random(6)+1;
          d2:=random(6)+1;
        until (d1+d2=sum) or (d1+d2=7); {until point is repeated or 7 rolled}

        if d1+d2=sum then inc(winners[sum]) {point made  = winner}
        else inc(losers[sum]);  {7 rolled = loser}
      end;
    end;
  end;

  with memo4, lines do
  begin  {report results}
    clear;
    add(format('Results for %.0n games, (Observed vs, Calculated probabilities)',[0.0+n]));
    add('');
    Totwinners:=0;
    TotLosers:=0;
    Wtot:=0;
    Ltot:=0;
    for i:=2 to 12 do
    begin
      w:=winners[i];
      L:=losers[i];
      case i of  {calulate win or loss based on the sum}
        2,3,12: begin {Craps}  wp:=0.0; Lp:=prob[i]; end;
        7,11: begin inc(winners[sum]); {Naturals} wp:=prob[i]; lp:=0; end;
        4,5,6,8,9,10: {Point, play on}
        begin
          Wp:=prob[i]*freq[i]/(freq[i]+freq[7]);
          Lp:=prob[i]*freq[7]/(freq[i]+freq[7]);
        end;
      end;
      Wtot:=wtot+wp;
      Ltot:=LTot+Lp;


      add(format('  %2d was first roll %7.0n times  Won:%7.0n (%5.3f vs. %5.3f) Lost%7.0n (%5.3f vs. %5.3f)',
                    [i,w+L,w,w/N, Wp, L, L/N,Lp]));
      inc(TotWinners,winners[i]);
      inc(TotLosers, losers[i]);
    end;
    add('');
    add(format('Overall Winners: %8.0n (%5.3f vs %5.3f),  Losers %8.0n (%5.3f vs %5.3f',
             [0.0+totwinners, totwinners/N,wTot,0.0+totlosers,totlosers/N,LTot]));
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

