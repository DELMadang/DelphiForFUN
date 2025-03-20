unit U_Shuffletest;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A viewer recently pointed out that the existing shuffle procedure used in
 DFF programs is statistically invalid.  Shuffling cosnists of exchanging each
 card in a deck one time with another randomly selected card.  My current version
 selects the random card from anywhere in the deck.  The proposed "correct"
 procedure select the random card only from those that have not yet been
 exchanged.

 Being of curious mind, I had to convince myself that it makes a difference.
 The bottom line is that it does for a single shuffle of and unshuffled deck.
 If the deck is shuffled 3 or 4 times, the methods are equally random.

 I'm still trying to rationalize the observed results.  The old method, on average,
 is slightly more likely to leave cards that start toward the end of the deck
 still toward the end of the deck after shuffling.

 The program starts with an ordered decked and shuffles a specified number of
 times.  The the long run, for a valid methodoligy, the card value for any
 position in the deck is equally likely to be any card, so the expected value of
 of the card in any position is the mean value of all the cards.   After each shuffle,
 we'll plot the  mean card value for each card position vs. the positions and
 should see the chart  move toward a straight line at the mean card value.
 We'll also display a measure of how the observed mean values vary from the
 expected means. The sum of the squared differences between the observed mean
 values and the expected value across all card positions.  This should approach
 zero the number of shuffles increases, and does for the corrected procedure.

 Most of the ideas for this program came from an old Pascal program to illustrate
  his excellent discussion of right and wrong ways to shuffle; Check
  http://www.merlyn.demon.co.uk/pas-rand.htm#Shuf }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, TeeProcs, TeEngine, Chart, StdCtrls, Spin, Series,ShellAPI;

type
  Tdeck=array of integer;

  TForm1 = class(TForm)
    StartBtn: TButton;
    Chart1: TChart;
    SpinEdit1: TSpinEdit;
    StopBtn: TButton;
    Countlbl: TLabel;
    Series2: TLineSeries;
    Series1: TLineSeries;
    VarLbl: TLabel;
    Label1: TLabel;
    SpinEdit2: TSpinEdit;
    Label2: TLabel;
    ListBox1: TListBox;
    ShowVarBox: TCheckBox;
    MeanLbl: TLabel;
    Memo1: TMemo;
    ShowDetailbox: TCheckBox;
    ResetBox: TCheckBox;
    StaticText1: TStaticText;
    procedure StartBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    GoodDeck, BadDeck:TDeck;
    goodtots,badtots:TDeck;
    procedure Oldshuffle(var deck:TDeck);
    procedure Newshuffle(var deck:TDeck);
  end;

var
  Form1: TForm1;
  nbrcards:integer=50;

implementation

{$R *.DFM}


{Shuffle both ways and test result for uniformity}

(*
for i:= 51 downto 0 do
  Begin
    j:=random(52);  {get a random card}
    {exchange the current card with the randomly selected card}
    swap:=deckobj[i];
    deckobj[i]:=deckobj[j];
    deckobj[j]:=swap;
  end;

It should be

  for i:= 51 downto 1 do  // no need to do last card *******
  Begin
    j:=random(i + 1);  {get a random card} // see below ****
    {exchange the current card with the randomly selected card}
    swap:=deckobj[i];
    deckobj[i]:=deckobj[j];
    deckobj[j]:=swap;
  end;
*)

{************* FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
begin
   randomize;
   {Stop button should be invisible but in front of startbtn}
   stopbtn.visible:=false;
   stopbtn.bringtofront;
end;

{*********** OldShuffle ********8}
procedure TForm1.oldshuffle(var deck:TDeck);
var i,j,swap:integer;
begin
  for i:= high(deck) downto  0 do {work from back to front of deck}
  Begin
    {get a random card from anywhere in the deck}
    j:=random(nbrcards);  {j = random card position (<=nbrcards)}
    swap:=deck[i];  {exchange card in position "i" with random position}
    deck[i]:=deck[j];
    deck[j]:=swap;
  end;
end;

{*********** NewShuffle *********8}
Procedure TForm1.Newshuffle(var deck:Tdeck);
var i,j,swap:integer;
begin
  for i:= high(deck) downto 1 do
  begin
    {get a random card in the range of those that have not yet been shuffled}
    j:=random(i + 1); {j = random position (<=i)}
    {exchange card in position "i" with random position}
    swap:=deck[i];
    deck[i]:=deck[j];
    deck[j]:=swap;
  end;
end;


{************ StartBtnClick **********}
procedure TForm1.StartBtnClick(Sender: TObject);
{Shuffle decks both ways multiple times and plot mean
 card value in each position}
var
  i,count:integer;
  mean,meanB,MeanG:extended;
  VarG,VarB:extended;
  s:string;
begin
  Nbrcards:=spinedit1.value;
  setlength(GoodTots,nbrcards);
  setlength(GoodDeck,nbrcards);
  setlength(BadTots,nbrcards);
  setlength(BadDeck,nbrcards);
  for i:= 0 to nbrcards-1 do
  begin
    goodtots[i]:=0;
    badtots[i]:=0;
    gooddeck[i]:=i;
    baddeck[i]:=i;
  end;
  chart1.leftaxis.maximum:=nbrcards;
  count:=0;
  tag:=0; {stop flag}
  stopbtn.visible:=true; {to let use interrupt test}
  mean:=(nbrcards-1)/2; {card values range forn 0 to nbrcards-1}
 
  listbox1.clear;
  while  (tag=0) and (count<spinedit2.value) do
  begin
    inc(count);
    //if count mod 4 =0 then {test multiple shuffles per reset}
    if resetbox.checked then {reset decks between shuffles if requested}
    for i:= 0 to nbrcards-1 do
    begin
      gooddeck[i]:=i;
      baddeck[i]:=i;
    end;
    oldshuffle(baddeck);
    for i:=0 to high(baddeck) do inc(badtots[i],baddeck[i]);
    newshuffle(gooddeck);
    for i:=0 to high(gooddeck) do inc(goodtots[i],gooddeck[i]);
    {shuffles complete, plot and accumulate stats}
    series1.clear;
    series2.clear;
    varb:=0;
    VarG:=0;
    s:='';
    for i:=0 to nbrcards-1 do
    begin
      meanB:=badtots[i]/count;
      meanG:=goodtots[i]/count;
      series1.addy(meanB);
      series2.addy(meanG);
      VarB:=VarB+sqr(meanb-mean);
      VarG:=varG+sqr(meanG-mean);
      if showdetailbox.checked then s:=s+','+inttostr(baddeck[i]);
    end;
    if showDetailbox.checked  and (count<=100)then
      listbox1.Items.add(s);
    if showVarbox.checked  and (count<=100)then listbox1.Items.add(
             format('%4d:  Variance: Old:%5.1f  New: %5.1f',[count, varB, VarG]));
    meanlbl.caption:=format('Mean card value: %4.1f',[mean]);
    countlbl.caption:='After '+inttostr(count)+ ' shuffles';
    Varlbl.caption:=format('Variance from expected: Old:%5.1f  New: %5.1f',[varB, VarG]);
    application.processmessages;
  end;
  stopbtn.visible:=false;
end;

{******* StopBtnClick *******}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

{************* FormCloseQuery *****8}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1;
  canclose:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
