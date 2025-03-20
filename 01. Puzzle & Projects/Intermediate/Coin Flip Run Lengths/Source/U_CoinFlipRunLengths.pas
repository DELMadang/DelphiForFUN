unit U_CoinFlipRunLengths;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Grids, ExtCtrls;

type
  TCoinSides=(H,T);

  TRunsArray=array[1..10] of integer;  {array of run counts of length (1 to 10)}

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    ThrowNBtn: TButton;
    StringGrid1: TStringGrid;
    ThrowAllBtn: TButton;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Label2: TLabel;
    Label3: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ThrowNBtnClick(Sender: TObject);
    procedure ThrowAllBtnClick(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
  public
    NbrCoinsPerTrial:integer;
    Nbrtrials:integer;
    n:array of integer;
    headruns,tailruns,either:TRunsArray;
    r,p:extended;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  with stringgrid1 do
  begin
    cells[0,0]:='Run';
    cells[0,1]:='Length (N)';

    for i:=1 to 3 do
    begin
      case i of
      1: begin
           cells[2*i-1,0]:='Heads';
           cells[2*i,0]:='Heads';
        end;
      2: begin
           cells[2*i-1,0]:='Tails';
           cells[2*i,0]:='Tails';
        end;
      3: begin
           cells[2*i-1,0]:='Either';
           cells[2*i,0]:='Either';
        end;
      end;
      cells[2*i-1,1]:='Expected';
      cells[2*i,1]:='Observed';
    end;
    for i:=2 to 11 do cells[0,i]:=inttostr(i-1);
    Radiogroup1Click(sender);
  end;
  randomize;
  NbrCoinsPertrial:=100;
end;

{********* Trial *********}
procedure trial(NbrCoins, RunLength:integer; var  HRuns, TRuns:TRunsArray);
  var
    i:integer;
    n:array of integer;
    counts:array[H..T] of integer;
  begin
    for i:=1 to 10 do
    begin
      HRuns[i]:=0;
      TRuns[i]:=0;
    end;
    setlength(N,Nbrcoins+2);
    for i:=1 to NbrCoins do n[i]:=random(2); {flip all the coins}
    n[0]:=n[1]; {start the count on the first run by forcing an increment}
    n[nbrcoins+1]:=(n[nbrcoins]+1) mod 2; {force the last flip to look like a break}
    counts[H]:=0;  {current length of heads run}
    counts[T]:=0;  {current length of tails run}
    for i:=1 to nbrcoins+1 do
    begin
      if (n[i]=n[i-1]) then
      begin
        inc(counts[TCoinSides(n[i])]) {the current run continues}
      end
      else {we had a break in a run}
      if i>1 then
      begin
        if (counts[H]>9) then counts[H]:=10;
        if counts[T]>9 then counts[T]:=10;
        if counts[H]>0 then inc(Hruns[counts[H]])
        else if counts[T]>0 then inc(Truns[counts[T]]);
        counts[H]:=0;  {reset current length of heads run}
        counts[T]:=0;  {reset current length of tails run}
        inc(counts[TCoinsides(n[i])]);
      end;
    end;
  end;




{************** ThrowNBtnClick *************}
procedure TForm1.ThrowNBtnClick(Sender: TObject);
{Runs of length N when throwing N coins at a time}
var
  i,j:integer;
  HCount,TCount:TRunsArray;

begin
  label1.caption:='Mean number of runs of length N per 100 trials when a coin is flipped N times per trial';
  setlength(n,NbrCoinsPerTrial+1);
  for i:=1 to 10 do
  begin
    headruns[i]:=0;
    tailruns[i]:=0;
  end;
  for i:= 1 to 10 do
  begin
    for j:=1 to nbrtrials do
    begin
      trial(i,i,hcount, tcount);
      inc(headruns[i],hcount[i]);
      inc(tailruns[i],tcount[i]);
    end;
 end;
  r:=2;
  for i:=1 to 10 do
  with stringgrid1 do
  begin
    cells[2,i+1]:=format('%6.1f',[headruns[i]*100/nbrtrials]);
    cells[4,i+1]:=format('%6.1f',[tailruns[i]*100/nbrtrials]);
    cells[6,i+1]:=format('%6.1f',[(headruns[i]+tailruns[i])*100/nbrtrials]);
    r:=2*r;
    p:=2/r;
    cells[1,i+1]:=format('%6.3f',[100*p]); {Expected runs per 100}
    cells[3,i+1]:=cells[1,i+1]; {Tails expected value same as for Heads}
    cells[5,i+1]:=format('%6.3f',[200*p]); {"either" probability is twice as large}
  end;
end;




{********** ThrowAllBtnClick ************}
procedure TForm1.ThrowAllBtnClick(Sender: TObject);
{Runs of length N when thowing "NbrCoinsPerTrial" coins}
{Probabilities of runs on length N are 1/4 of those when
 N coins are thrown at a time because the preceding and
 followimng coin values must be non matching (THT for heads runs
 of length 1, THHT for length 2, THHHT for length 3, etc.
}




var
  i,j:integer;
  HCount,TCount:TRunsArray;
begin
  label1.caption:='Mean number of runs of length N when a coin is thrown 100 times';
  setlength(n,nbrCoinsperTrial+1);
  for i:=1 to 10 do
  begin
    headruns[i]:=0;
    tailruns[i]:=0;
    either[i]:=0;
  end;
  for i:=1 to nbrtrials do
  begin
    {Throw 100 coins and coins runs of each length}
    Trial(NbrCoinspertrial, 10, HCount, TCount);
    for j:=1 to 10 do
    begin
      inc(headruns[j],HCount[j]);
      inc(tailruns[j], TCount[j]);
      inc(either[j],Hcount[j]+TCount[j]);
    end;
  end;


  r:=4*2; {because strings of length N+2 are checked, probabilites are 1/4 of
           strings of length N, e.g. heads strings of length one must have
           pattern THT, and have probability of 1/8 instead of 1/2 etc. }
  for i:=1 to 10 do
  with stringgrid1 do
  begin
    cells[2,i+1]:=format('%6.1f',[headruns[i]/nbrtrials]);
    cells[4,i+1]:=format('%6.1f',[tailruns[i]/nbrtrials]);
    cells[6,i+1]:=format('%6.1f',[(headruns[i]+tailruns[i])/nbrtrials]);
    r:=2*r;
    p:=2/r;
    cells[1,i+1]:=format('%6.3f',[100*p]);
    cells[3,i+1]:=cells[1,i+1];  {Tails expected same a for Heads}
    cells[5,i+1]:=format('%6.3f',[200*p]); {Prob of either is twice as large}
  end;
end;



procedure TForm1.RadioGroup1Click(Sender: TObject);
var
  i:integer;
begin
  nbrTrials:=1;
  for i := 1 to radiogroup1.itemindex do Nbrtrials:=10*Nbrtrials;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
