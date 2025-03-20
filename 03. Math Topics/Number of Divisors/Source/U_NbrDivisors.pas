unit U_NbrDivisors;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ An interesting experiment - lay out 13 cards of a single suit face down in
 order Ace, 2 ...Queen, King.  Starting with card 1, turn over every card.
 Then starting with card 2, turn over every 2nd card, then starting with card 3
 turn over every 3rd card, etc., until you turn over just the 13th card on the
 13th pass.

 Which cards will be face up?  Can you guess which cards would be face up if
 we had cards numbered 1 to 50?  Can you explain why?

 Hint: The title  of this program is related to the number of flips of any
 card.  What is special about the face up cards?
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, U_CardComponent, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    FlipBtn: TButton;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure FlipBtnClick(Sender: TObject);
  public
    cards:array[1..13] of TCard;
    nextcard:integer;
    procedure reset;
  end;

var Form1: TForm1;

implementation
{$R *.DFM}

{**************** Formcreate ***************}
procedure TForm1.FormCreate(Sender: TObject);
{initialization stuff}
var i:integer;
begin
   for i:=1 to 13 do  {make a set of cards}
   begin
     cards[i]:=TCard.create(self);
     with cards[i] do
     begin
       parent:=self;
       value:=i;
       suit:=hearts;
       decktype:=standard2;
       if i<=6 then   {need two rows, 1-6 in row 1}
       begin
        top:=220;
        left:=100+80 *(i-1);
       end
       else
       begin   {7 to 13 in row 2}
        top:=330;
        left:=80+80 *(i-7);
       end;
       showdeck:=true;
     end;
   end;
   reset;
end;

{****************** Reset **************}
procedure TForm1.reset;
{reset the cards and button caption}
var I:integer;
begin
  flipbtn.caption:=format('Flip cards, starting with card number %2d '
    +'and skipping %2d cards between flips',[1,0]);
  nextcard:=1;
  for i:=1 to 13 do cards[i].showdeck:=true;
end;

{***************** FlipBtnClick ***********}
procedure TForm1.FlipBtnClick(Sender: TObject);
{Flip a set of cards}
var i:integer;
    cardword:string;
begin
  if nextcard<=13 then {still cards to flip?}
  begin  {yup}
    screen.cursor:=crhourglass;
    for i:=1 to 13 do
    begin
      if i mod nextcard = 0 then
      with cards[i] do
      begin  {flip slowly (3 per second)}
        showdeck := not showdeck;
        update;
        sleep(333);
      end;
    end;
    screen.cursor:=crdefault;
    inc(nextcard);  {Set next starting card #}
    if nextcard=2 then cardword:='card' else cardword:='cards'; {for grammer's sake}
    if nextcard<=13 then
       flipbtn.caption:=format('Flip cards, starting with card number %2d '
      +'and skipping %2d '+cardword+' between flips',[nextcard,nextcard-1])
     else
     begin  {all flipped - change label and beep}
       flipbtn.caption:='Reset';
       messagebeep(MB_IconExclamation);
     end;
  end
  else reset; {user pushed button when it said "reset"}
end;

end.
