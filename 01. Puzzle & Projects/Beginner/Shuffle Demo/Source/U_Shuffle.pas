unit U_Shuffle;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  shellAPI, StdCtrls, ExtCtrls, Spin, Dialogs;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    DealBtn: TButton;
    Memo1: TMemo;
    HandSizeEdt: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    NbrHandsEdt: TSpinEdit;
    Label3: TLabel;
    DeckSizeEdt: TSpinEdit;
    procedure StaticText1Click(Sender: TObject);
    procedure DealBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{*********** Shuffle ***********}
procedure shuffle(var deck:array of integer);
{Shuffle = randomly rearrange  an array of integers}
var  i,n,temp:integer;
begin
  i:= high(deck); {starting from the end of the deck}
  while i>0 do
  begin
    n:=random(i+1);  {pick a random card, "n",  at or below this card}
    temp:=deck[i];   {and swap card "i" with card "n"}
    deck[i]:=deck[n];
    deck[n]:=temp;
    dec(i);       {move to the next prior card}
  end;            {and loop}
end;


{************** DealBtnClick *************}
procedure TForm1.DealBtnClick(Sender: TObject);
var
  i,j:integer;
  HandSize, NumberOfHands:integer;
  DeckSize, CardstoDeal:integer;
  Deck:array of integer;
  Hand, S:string;
begin
  randomize;  {so decks will not repeat from run to run}
  Memo1.lines.add('Deal the Cards');
  {these could be input variables rather than fixed}
  HandSize:=HandSizeEdt.Value;
  NumberOfHands:=NbrhandsEdt.value;
  Decksize:=DeckSizeEdt.Value;
  CardsToDeal:=HandSize*NumberOfHands;
  if Decksize<cardsToDeal then
  begin
    DeckSize:=HandSize*NumberOfhands;
    Showmessage(
       format('Deck size increased to %d to match number of cards required',[decksize]));
    DecksizeEdt.value:=decksize;
  end;
  {deck size could be any number greater than or equal to the product
   of thse Handsize and Number of Hands.  Any leftover cards would make up the pile from
   which additional cards could be drawn later}
  Setlength(deck,decksize);

  for i:=0 to High(Deck) do Deck[i]:=i+1; {make the cards in order}

  for i:=1 to 3 do shuffle(deck);  {shuffle them 3 times}

  for i:=0 to NumberOfhands-1 do  {"deal" the cards}
  begin
    Hand:='';
    for j:=0 to Handsize-1 do hand:=hand+format(' %2d',[deck[i*HandSize+j]]);
    memo1.lines.Add(hand);
  end;
  if decksize>Cardstodeal then
  begin
    memo1.Lines.add('Undealt cards: ');
    for i:=cardstodeal to high(deck) do s:=s+' '+inttostr(deck[i]);
    memo1.Lines.Add(s);
  end;
  memo1.lines.add('');
end;

end.
