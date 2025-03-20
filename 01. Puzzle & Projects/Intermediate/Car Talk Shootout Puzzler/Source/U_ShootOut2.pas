unit U_ShootOut2;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A solution using simulation to solve a puzzle adapted from the following
 Car Talk puzzler found at:
(http://www.cartalk.com/content/puzzler/transcripts/200704/index.html)

Three men who are mutual enemies decide to settle things with a shootout.  Al is a poor shot
only hitting his target 1/3 of the time.  Bob hits his target 2/3 of the time and Charlie hits what
he aims at 100% of the time.

To even the odds a bit, Al is given first shot. Bob is next, if he's still alive. He's followed by
Charlie, if he's still alive.  They will continue shooting like this, in this order, until two of them are
dead.

The question is: At whom should Al aim his first shot to maximize his chances of surviving?

Select a strategy below and press the button to see the results or  1,000,000  shootouts (made
possible by the use of paintballs instead of real bullets of course :>).

Assuming Al's need for revenge was stronger than his need to survive, what would be the
best strategy to ensurse that he maximizes the number of hits on his opponents?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellAPI, ComCtrls, DFFUtils;

const
  nbrshooters=3;

type
  TShooterRec=record  {characteristics of a "shooter"}
    names:string;   {his name}
    odds:extended;  {how accurate is he}
    alive:boolean;  {current state of health (true=alive, false=dead)}
    wincounts:integer;  {total nbr of games won for this set of shootouts}
    nbrhits:integer;    {total nbr of opponents "killed" in this set}
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    Memo1: TMemo;
    ShootSheet: TTabSheet;
    StrategyGrp: TRadioGroup;
    Button1: TButton;
    Memo2: TMemo;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    A_Edt: TEdit;
    Label2: TLabel;
    B_Edt: TEdit;
    Label3: TLabel;
    C_Edt: TEdit;
    VersionGrp: TRadioGroup;
    procedure SolveBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VersionGrpClick(Sender: TObject);
    procedure EdtOddsChange(Sender: TObject);
  public
    Rec:array[0..nbrshooters-1] of TShooterrec;  {Describes the shooters}
    target:integer;
    nbrgames, totalshots, longestgame, shortestgame:integer;
    showdetail:boolean;
    oddschanged:boolean;  {User manually chnaged accuracy probabilities}
    list:TStringlist;
    procedure TakeAShot(shooter, shotnbr:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{*********** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;  {initialize random number generator}
  rec[0].names:='Al';
  rec[1].names:='Bob';
  rec[2].names:='Carl';
  versionGrpClick(sender);
  list:=TStringlist.create;
  pagecontrol1.ActivePage:=Introsheet;
end;


{************** VersionGrpClick *********8}
procedure TForm1.VersionGrpClick(Sender: TObject);
begin
  case Versiongrp.itemindex of
  0:
    Begin
      rec[0].odds:=1/3;
      rec[1].odds:=2/3;
      rec[2].odds:=1.0;
      A_Edt.Text:='0.3333';
      B_Edt.Text:='0.6667';
      C_Edt.Text:='1.0000';
    end;
  1:
    Begin
      rec[0].odds:=0.3;
      rec[1].odds:=1.0;
      rec[2].odds:=0.5;
      A_Edt.Text:='0.3';
      B_Edt.Text:='1.0';
      C_Edt.Text:='0.5';
    end;
  end; {case}
  oddschanged:=false;
end;

{******************* SolveBtnClick ************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{User clicked the solve button}
var
  i,j:integer;

begin {SolvebtnClick}
  if oddschanged then
  begin
    for i:=0 to nbrshooters-1 do
    with rec[i] do
    begin
      case i of
        0: rec[0].odds:=StrtoFloatdef(A_Edt.text,-1);
        1: rec[1].odds:=StrtoFloatdef(B_Edt.text,-1);
        2: rec[2].odds:=StrtoFloatdef(C_Edt.text,-1);
      end;
      if (odds<0) or (odds>1.0) then
      begin
        showmessage(format('Invalid Accuracy probability for %s, must be between 0.0 and 1.0'
                  +#13 + 'Value set to 0.5 assumed',[rec[i].names]));
        rec[i].odds:=0.5;
      end;
    end;  
  end;

  nbrgames:=1000000;  {run 1,000,000 contests}
  memo2.clear;
  list.clear;
  list.add('First 100 games');
  list.add('----------------');
  for i:=0 to nbrshooters-1 do
  with rec[i] do
  begin
    wincounts:=0;
    nbrhits:=0;
  end;

  totalshots:=0;
  longestgame:=0;
  shortestgame:=100;

  {Loop to play a number of games of the selecgted strategy}
  for i:=1 to nbrgames do
  begin
    if i<=100 then showdetail:=true {set flag to display 1st 100 games}
    else showdetail:=false;
    {bring everyone back to life at the start of this game}
    for j:=0 to nbrshooters-1 do rec[j].alive:=true;
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
    add(format('%.0n games, Avg game length: %4.1f',[0.0+nbrgames, totalshots/nbrgames]));
    add(format('        Shortest: %d, Longest %d',[shortestgame,longestgame]));
    add('');
    for i:=0 to nbrshooters-1 do
    with rec[i] do
    begin
      add(format('%s wins %6.1f %% of the time',[Names,wincounts*100/nbrgames]));
      add(format('       %6.3f avg kills per game',[nbrhits/nbrgames]));
    end;
    add('');

    for i:=0 to list.count-1 do  add(list[i]);

    movetotop(memo2);
  end;
end;


  {**************** TakeAShot **************}
  procedure TForm1.takeAshot(shooter, shotnbr:integer);
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
            if (strategygrp.itemindex=3) and (shotnbr=1) then
            begin
              hit:=false;
              break
            end
            else
            if rec[i].alive then
            {not 1st shot or not 1st shooter}
            case strategygrp.itemindex of
              0,3:{Shoot at best living shooter}
                if rec[i].odds>maxodds then
                begin
                  target:=i;
                  maxodds:=rec[i].odds;
                end;
              1:
                if rec[i].odds<minodds then
                begin
                  target:=i;
                  minodds:=rec[i].odds;
                end;
              2: inc(count);
            end; {case}
          end;

          if (strategygrp.itemindex =2) then
          begin
            n:=random(count); {get a random nbr from this count}
            {choose the nth alive opponent}
            count:=0;
            for j:=0 to nbrshooters-1 do {now find that random entry again}
            if (j<>shooter) and (rec[j].alive)
            then
            if (count=n) then
            begin {and shoot at him}
              target:=j;
              break;
            end
            else inc(count);
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






procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.EdtOddsChange(Sender: TObject);
begin
  Oddschanged:=true;
end;

end.
