unit U_WeighingWatermelons;
{Copyright © 2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
A farmer tells his son to select five wateremelons to take to market.
Because the watermelons  are sold by weight, they  must be put on a scale before
the trip to town, but the son make a small mistake and weighs  them in  (all
possible) pairs.   Here are the  weights he comes up with, in pounds:
20, 22, ,23, 24, 25, 26, 27, 28, 30, 31. How much does each of the watermelons weigh?
Puzzle Source: "Sit & Solve Brain Teasers", Derrick Niederman,  2011 Hallmark Gift Books
}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, dffutils;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    SearchBtn: TButton;
    Memo2: TMemo;
    Memo3: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    ShowBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
  public
  w:array of array of integer;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
  {These are the 10 combined weight results of weighing all 5 watermelons 2 at a time}
  pairweights:array[1..10] of integer=(20,22,23,24,25,26,27,28,30,31);

{************ FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  reformatmemo(memo1);  {Pretty up the text}
  reformatmemo(memo3);
end;

procedure TForm1.SearchBtnClick(Sender: TObject) ;
Var
 i,j,count:integer;
begin
  memo2.clear;
 (*
 To solve, we'll use the fact that the 2 lightest mellons have a combined
  weight of 20 lbs, and the two heaviest combine for 31 lbs
 If we label them A,B,C,D,E in increasing weight order, then comnbined weights
 reflect results from weighing A+B, A+C, A+D, A+E, B+C, B+D, B+E, C+D, C+E,
 and D+E.  With this naming, we know that A+B=20 lbs and D+E=31 lbs.  We also
 know that the sum of all the weighings (256 lbs) contains each of the melons
 weighed 4 times, so the total weight of the melons weighd once is 64 lbs and
 therefore the weight of melon C must be 64-20-31=13 lbs.

 Knowing this we can enumerate the individual possible weights for pairs AB
 and DE and then test each possible set of values to find the one that
 provides the 10 given pair weights.

 So, here we go.
 *)
  count:=0;
  setlength(w,12,5);  {i range(4) * j range (3) - 12 values to test}
  {get possibilities for 2 smallest watermellons (20 lbs).  B must not be
   greater than 13 (because C is 13 and A and B are the two lightest), so A
   must be at least 7 and not greater than 10}
  for i:=7 to 10 do
  begin
    {get possibilities for 2 largets watermellons (31 lbs).  D must not be
      less han 13 (because C is 13 and D and E are the two largets), so D
      must be at least 13 and not greater than 15 (if D were 16, E would be 15 and
      therefore not the largest). }
    for j:=13 to 15 do
    begin
      w[count,0]:=i; {A}
      w[count,1]:=pairweights[1]-i;  {B}
      w[count,2]:=13;{C}
      w[count,3]:=j; {D}
      w[count,4]:=pairweights[10]-j;    {E}
      memo2.lines.add(format('A:%D, B:%D, C:%D, D:%D, E:%D',
          [W[count,0],W[count,1],W[count,2],W[count,3],W[count,4]]));
      inc(count);
    end;
  end;
  showbtn.enabled:=true;
end;

{************ ShowBtnClick *********}
procedure TForm1.ShowBtnClick(Sender: TObject);
var
  i,j,k,n,sum:integer;
  OK:Boolean;
  weightfound:array[1..10] of boolean;
begin
  {now that all possible valid weight sets have been genererated in array W,
  we can check each each set to see if all of the 10 pair weights can be created
  by the 10 combinations}
  for n:=0 to high(w) do
  begin
    {We'll initialize flags as false in array WeightFound for the 10 pair weights
     and set the appropriate one to True when that weight is found.  If the flag
     is already True we we find that sum, then this potentional solution can be
     rejected. Also reject if a sum does not match any of the given pair weights}
    for i:=1 to 10 do weightfound[i]:=false;
    ok:=true;
    for i:=0 to 3 do {for all 1st melon choices of pairs}
    begin
      for j:=i+1 to 4 do {for all second melon choices}
      begin
        sum:=w[n,i]+w[n,j];
        for k:=1 to 10 do if pairweights[k]= sum then
        begin
          if weightfound[k] then OK:=false
          else weightfound[k]:=true;
          break;
        end
        else if k=10 then OK:=false; {checked all given weight pairs without a match
                                     so we have found an invallid sum}
        if not OK then break;
      end; {Loop on 2nd melon of the pair}
      if not OK then break;
    end; {Loop on 1st member of pair}
    if OK then with memo2 do  lines[n]:=lines[n]+' Solution!';
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
