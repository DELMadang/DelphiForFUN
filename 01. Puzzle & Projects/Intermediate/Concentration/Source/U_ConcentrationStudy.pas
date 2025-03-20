unit U_ConcentrationStudy;
 {Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A short study to experimentally calculate the expected length of the game
  of Concentration if player plays with perfect memory.  i.e. the locations of
  all cards examined is remembered.  We'll simulate that here by assuming that
  unmatched cards that have been turned over remain face-up.
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, U_CardComponent, ExtCtrls, Spin, shellAPI;

type

  TForm1 = class(TForm)
    StartBtn: TButton;
    PairsEdt: TSpinEdit;
    Label2: TLabel;
    StaticText1: TStaticText;
    Memo1: TMemo;
    Label3: TLabel;
    GamesEdt: TSpinEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Edit5: TEdit;
    procedure StartBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var Form1: TForm1;

implementation

{$R *.DFM}


{***************** StartBtnClick ***********}
procedure TForm1.StartBtnClick(Sender: TObject);
{Play the requested number of games and keep statistics}
var
   i,j,n:integer;
   faceupcards,facedowncards:TList;
   card1,card2:TCard;
   mingame, maxgame:integer;
   nbrcards:integer;
   guesses, matches: integer;
   totguesses, totgames:integer;



   function matchesfaceup(const card:TCard):integer;
   {local function to test whether a card matches one in the fasce up list}
   var
     i:integer;
     card2:TCard;
   {return the card number in the faceup list that matches then card passed}
   {return -1 if no match}
   begin
     result:=-1;
     for i:= 0 to faceupcards.count-1 do
     with faceupcards do
     begin
       card2:=TCard(items[i]);
       if (card2.suit=card.suit) and (card2.value=card.value) then
       begin   {match found - get out!}
         result:=i;
         break;
       end;
     end;
   end;

begin
  {initialize game paramters and labels}
  nbrcards:=2*pairsedt.value;  {must be multiple of 2}

  {create and shuffle a deck}
  if assigned(deck) then deck.free;
  deck:=TDeck.create(Application.mainform,point(10,10),nbrcards);

  {duplicate 1st half of cards in 2nd half positions to ensure pairs}
  with deck do
  begin
    for i:=0 to nbrcards-1 do deckobj[i].visible:=false;
    for i:=0 to nbrcards div 2-1 do
    begin
      {Duplicate the card in the 2nd half of the deck}
      deckobj[i+nbrcards div 2].value:=deckobj[i].value;
      deckobj[i+nbrcards div 2].suit:=deckobj[i].suit;
    end;
    totgames:=0;
    totguesses:=0;
    mingame:=1000;
    maxgame:=0;
    faceupcards:=TList.create; {cards we have seen - perfect memeory!}
    facedowncards:=TList.create;  {cards we have never seen}
    screen.cursor:=crHourglass;
    for i:=1 to gamesedt.value do
    begin
      noshowshuffle;
      faceupcards.clear;
      facedowncards.clear;
      for j:=0 to nbrcards-1 do facedowncards.add(deckobj[j]);
      matches:=0;
      guesses:=0;
      while matches<nbrcards div 2 do
      begin
        inc(guesses);

        {If the second card we selected last time happened to match one we had
         already seen, both cards aere now in the face up pile - check for
         that possibility first}
        n:=-1;
        with faceupcards do
        if (count>1) then
        begin
          with faceupcards do n:=matchesfaceup(TCard(items[count-1]));
          if n<count-1 then
          begin  {match of two face up cards found!}
            delete(n);
            delete(count-1);
            inc(matches);
          end
          else n:=-1;
        end;

        if (n=-1) then {the previous faceup card test had no match}
        begin
          {Pick a facedown card}
          with facedowncards do card1:=items[count-1];
          {If a card in the the face up list matches then match that card}
          n:=matchesfaceup(card1);
          if n>=0 then {match found}
          begin
            faceupcards.delete(n);
            with facedowncards do delete(count-1);
            inc(matches);
          end
          else
          begin {no match with face up}
            {Put that card in the face up pile, and pick a second card
             from the face down pile and see if it matches}
            faceupcards.add(card1);
            with facedowncards do delete(count-1);
            with facedowncards do card2:=items[count-1];
            if (card1.suit=card2.suit) and (card1.value=card2.value) then
            begin
                {It does, so increment matches and remove both cards}

              with facedowncards do delete(count-1);
              with faceupcards do delete(count-1);
              inc(matches);
            end
            else
            begin
              {If not, move it to the face up pile}
              faceupcards.add(card2);
              with facedowncards do delete(count-1);
            end;
          end;
        end;
      end;
      inc(totguesses,guesses);
      inc(totgames);
      if guesses<mingame then mingame:=guesses;
      if guesses>maxgame then maxgame:=guesses;
    end;
    edit1.text:=inttostr(totgames);
    edit2.text:=floattostr(totguesses/totgames);
    edit3.text:=floattostr(totguesses/totgames/nbrcards*2);
    edit4.text:=inttostr(mingame);
    edit5.text:=inttostr(maxgame);
    screen.cursor:=crdefault;
  end;
  faceupcards.free;
  facedowncards.free;
end;

{************** FormActivate **********}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
