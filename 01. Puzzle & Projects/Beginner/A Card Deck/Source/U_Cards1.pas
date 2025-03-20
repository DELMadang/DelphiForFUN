unit U_Cards1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

Const

  suit:array[0..3] of string=('Hearts','Diamonds','Clubs','Spades');
  Cards:array[0..12] of string=
            ('Ace','2','3','4','5','6','7','8','9','10',
            'Jack','Queen','King');
type
  TDeck = class(Tobject)
    DeckObj:array [0..51] of integer;
    NextCard:integer;
    constructor create(Aowner:TComponent);
    Procedure shuffle;
    function getsuit(CardNbr:integer):String;
    function getCardVal(CardNbr:integer):string;
    function GetNextCard(var card:string):boolean;
  end;
  TForm1 = class(TForm)
    listbox1: TListBox;
    ListBox2: TListBox;
    ListBox3: TListBox;
    ListBox4: TListBox;
    ShuffleBtn: TButton;
    deckbox: TListBox;
    DealBtn: TButton;
    procedure ShuffleBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DealBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Handboxes:array [1..4] of TListBox;
  end;

var
  Form1: TForm1;
  Deck:TDeck;

implementation

{$R *.DFM}

{******************* Deck methods *****************888}
Constructor TDeck.create;
var i:integer;
  begin
    inherited create;
    for i:= 0 to 51 do deckobj[i]:=i; {initialize the deck}
  end;

Procedure tDeck.shuffle;
var
  i,j:integer;

  swap:integer;
begin
  randomize;
  {Corrected 8/31/06 - only exchange with remainder of deck 0 thru i}
  for i:= 51 downto 1 do
  Begin
    j:=random(i+1{52});  {get a random card}
    {exchange the current card with the randomly selected card}
    swap:=deckobj[i];
    deckobj[i]:=deckobj[j];
    deckobj[j]:=swap;
  end;
  Nextcard:=0; {Set nextcard to first card}
end;

Function TDeck.getsuit(Cardnbr:integer):string;
{return a suit 0-3}
begin
  result:=suit[deckobj[Cardnbr] div 13]
end;

Function TDeck.GetCardVal(CardNbr:integer):string;
{return a card value 0-12}
begin
  result:=cards[Deckobj[cardnbr] mod 13];
end;

function TDeck.GetNextCard(var card:string):boolean;
{pass a string beck representing next card}
begin
  If nextcard<=51 then
  Begin
    card:=getcardval(nextcard) + ' of '
                      + getsuit(nextcard);
    result:=true;
    inc(nextcard);
  end
  else result:=false;
end;


{*********************** Form methods *************************8}
procedure TForm1.FormCreate(Sender: TObject);
{Create the deck}
begin
  deck:=TDeck.create(self);
  Handboxes[1]:=Listbox1;
  Handboxes[2]:=Listbox2;
  Handboxes[3]:=Listbox3;
  Handboxes[4]:=Listbox4;

end;

procedure TForm1.ShuffleBtnClick(Sender: TObject);
{User clicked Shuffle button}
var
  i:integer;
  card:string;
begin
  Deck.shuffle; {shuffle the deck}
  for i:= 1 to 4 do handboxes[i].clear;  {Clear previous hands}
  deckbox.items.clear;
  For i:= 0 to 51 do   {Add shuffled cards to display}
    if deck.getnextcard(card)
    then deckbox.items.add(card);
  deck.nextcard:=0;
end;

procedure TForm1.DealBtnClick(Sender: TObject);
{User clicked Deal button - deal 4 hands of 7 cards each}
var
  card:string;
  i,j:integer;
begin
{Put the four Listboxes into an array just to make it easier to
 manipulate them}

  for i:= 1 to 4 do HandBoxes[i].clear;  {clear any previous hands}
  for i:= 1 to 7 do {for 7 rounds}
  Begin
    for j:= 1 to 4  do  {for 4 hands}
    If Deck.getnextcard(card)
    then
    Begin
      handboxes[j].items.add(card); {add a card}
      {take it out of the displayed deck}
      if card <> deckbox.items[0] then showmessage('System error')
      else deckbox.items.delete(0);
    end
  end;
end;

end.