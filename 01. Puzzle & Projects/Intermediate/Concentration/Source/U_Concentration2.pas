unit U_Concentration2;
 {Copyright  © 2004, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {The game of concentration, from face down cards, draw two at a time trying to
  find matching pairs.  When found, they are removed from the deck.  With 2 players,
  the player with the most matches after all are matched, wins.
 }

 {Version 2, Advanced Concentration, optionally requires 3 cards to be matched
 before they are removed.  It alos allows matching either by value and suit
 (the default) or by value only.
 } 

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, UCardComponentV2, shellAPI;

type

  TForm1 = class(TForm)
    Label1: TLabel;
    NewGameBtn: TButton;
    PlayerGrp: TRadioGroup;
    PairsEdt: TSpinEdit;
    Label2: TLabel;
    StaticText1: TStaticText;
    TurnLbl: TLabel;
    Label4: TLabel;
    Score1Lbl: TLabel;
    Score2Lbl: TLabel;
    CardsGrp: TRadioGroup;
    MatchTypeGrp: TRadioGroup;
    procedure NewGameBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure CardsGrpClick(Sender: TObject);
  public
    nbrcards:integer;
    nbrplayers:integer;
    guesses, matches: array[1..2] of integer;
    cardup:array[1..2] of TCard;   {pointer to the cards already turned face up (if any)}
    cardsup:integer;
    cardstomatch:integer;  {2 or 3 cards version}
    playernbr:integer;
    procedure CardMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  end;

var Form1: TForm1;

implementation

{$R *.DFM}

{************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  cardsgrpclick(sender);
  newgamebtnclick(sender);  {Set up initial game}
end;

{***************** NewGameBtnClick ***********}
procedure TForm1.NewGameBtnClick(Sender: TObject);
var
  i,j,index:integer;
  col, row, offsetx, offsety:integer;
  tempdeck:TDeck;
begin
  {initialize game paramters and labels}
  nbrcards:=cardstomatch*pairsedt.value;  {must be multiple of 2 or 3}
  nbrplayers:=playergrp.itemindex+1;
  playernbr:=1;
  score2lbl.visible:=nbrplayers=2;
  score1lbl.caption:='0';
  score2lbl.caption:='0';
  for i:=1 to 2 do
  begin
    guesses[i]:=0;
    matches[i]:=0;
  end;
  for i:=1 to 2 do CardUp[i]:=nil;
  offsetx:=10; offsety:=10;

  {create and shuffle a deck}

  if assigned(deck) then deck.free;
  deck:=TDeck.create(Application.mainform,point(10,10),nbrcards);

  {create a temporary full deck to pick from}
  tempdeck:=TDeck.create(Application.mainform,point(10,10),52);
  tempdeck.shuffle;

  {set up the pairs/triplets}
  with deck do
  begin
    
    for i:=0 to nbrcards div cardstomatch - 1 do
    begin  {set up initial part of cards}
      with deckobj[i] do
      begin
        onmouseup:=CardMouseup;   {set mouseup exit for each card}
        value:=tempdeck.deckobj[i].value;
        suit:=tempdeck.deckobj[i].suit;
      end;
      {Duplicate the card in the 2nd half of the deck( or 2nd and 3rd thirds)}
      for j:=1 to cardstomatch-1 do
      begin
        index:=i+j*(nbrcards div cardstomatch);
        deckobj[index].onmouseup:=CardMouseup;
        deckobj[index].value:=deckobj[i].value;
        if matchtypegrp.itemindex=0
        then deckobj[index].suit:=deckobj[i].suit
        else deckobj[index].suit:= tCardsuit(random(4));
      end;
    end;
    tempdeck.free;
    shuffle;
    for i:=0 to nbrcards-1 do
    begin
      row:=i div 10;  {draw 10 cards per row}
      col:= i mod 10;
      with deckobj[i] do  {position the card}
      begin
        top:=offsety+row*(height+5);
        left:=offsetx+col*(width+5);
      end;
    end;
  end;
  cardsup:=0;
end;

{*************** CardMouseUp **************}
procedure TForm1.CardMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{called when player clicks a card}
var
  winner:string;
  {"match" = boolean flag set when a pair is found, used to keep same player for next turn}
  match:boolean;
  msg:string;
  i:integer;
begin
  If (sender is TCard)
  then with tcard(Sender) do
  if showdeck then   {it's face down, so click is valid}
  begin
    if button=mbleft then showdeck:=not showdeck; {show the card}
    if cardsup=cardstomatch-1 then  {we have required nbr of cards}
    begin
      inc(guesses[playernbr]);
      match:=true;
      for i:=1 to cardstomatch-1 do
      begin
        if (value<>cardup[i].Value)
        or ((matchtypegrp.itemindex=0) and (suit<>cardup[i].suit)) then
        begin
          match:=false;
          break;
        end;
      end;
      if match then
      begin  {match!}
        match:=true;
        inc(matches[playernbr]);
        if matches[1]+matches[2]=nbrcards div cardstomatch then {game over}
        begin
           {update displayed score first}
           if playernbr=1 then score1lbl.caption:=inttostr(matches[1])+' of ' + inttostr(guesses[1])
           else  score2lbl.caption:=inttostr(matches[2])+' of ' + inttostr(guesses[2]);
           If nbrplayers = 1
           then showmessage('Game over'
                            +#13+'You found all card sets in '+inttostr(guesses[1])
                            +' Guesses!')
           else
           begin
             if matches[1]<matches[2] then winner:='Winner is Player 2'
             else if matches[2]<matches[1] then winner:='Winner is Player 1'
             else winner:='Tie score - no winner!';
             showmessage('Game over'+#13+winner);
           end;
           newgamebtnclick(sender);
        end;

        for i:=1 to cardstomatch-1 do
        begin
          if cardup[i]<>nil then
          begin
            cardup[i].visible:=false;
            TCard(sender).visible:=false;
          end;
        end;
        sleep(nbrcards*100);
      end
      else
      begin  {required #face up but no match}
        match:=false;
        sleep(nbrcards*100);
        for i:=1 to cardstomatch-1 do cardup[i].showdeck:=true;
        TCard(sender).showdeck:=true;
      end;
      for i:=1 to 2 do cardup[i]:=nil;  {set no cards face up}
      cardsup:=0;
      if playernbr=1 then score1lbl.caption:=inttostr(matches[1])+' of ' + inttostr(guesses[1])
      else  score2lbl.caption:=inttostr(matches[2])+' of ' + inttostr(guesses[2]);
      msg:='';
      if nbrplayers=2 then {if 2 players, adjust playernbr, unless a matrch was found}
      if not match then playernbr:=(playernbr) mod 2 +1
      else msg:=' plays again';
      turnlbl.caption:='Player '+inttostr(playernbr)+msg;

    end
    else
    begin
      inc(cardsup);
      cardup[cardsup]:=TCard(sender);
    end;
  end;
end;


{************ CardsGrpClick ************}
procedure TForm1.CardsGrpClick(Sender: TObject);
begin
  with cardsgrp do
  if itemindex=0 then
  begin
    cardstomatch:=2;
    pairsedt.maxvalue:=20 {max nbr of pairs}
  end
  else
  begin
    cardstomatch:=3;
    if pairsedt.value>13 then pairsedt.Value:=13;
    pairsedt.maxvalue:=13;{max nbr of triples}
  end;
  newgamebtnclick(sender);
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin  {Browser link to DFF home page}
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

