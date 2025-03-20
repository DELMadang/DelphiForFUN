unit U_Select;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls, 
  Buttons, ExtCtrls, UCardComponentV2;

type
  TOKBottomDlg = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    TempCards:array [low(TDecks)..high(TDecks)] of TCard;
    newDecktype:TDecks;
    Procedure setdeck(Sender:TObject);
  end;

var
  OKBottomDlg: TOKBottomDlg;

implementation

{$R *.DFM}

procedure TOKBottomDlg.FormActivate(Sender: TObject);
var
  t,L:integer;
  i:TDecks;
begin
  t:=10;
  L:=10;
  for i:= low(TDecks) to high(TDecks) do
  Begin
    TempCards[i]:=TCard.create(self);
    with TempCards[i] do
    begin
      parent:=self;
      visible:=true;
      showdeck:=true;
      OnClick:=SetDeck;
      top:= t;
      left:= L;
      inc(L,80);
      If L>self.width-90 then
      begin
        L:=10;
        t:=t+100;
      end;
      Decktype:=i;
    end;
  end;
end;


procedure TOKBottomDlg.Setdeck(sender:Tobject);
begin
  newdecktype:=TCard(Sender).Decktype;
  modalresult:=mrOK;
end;


procedure TOKBottomDlg.FormDeactivate(Sender: TObject);
var
  i:TDecks;
begin
  for i:= low(TDecks) to high(TDecks) do TempCards[i].free;
end;

end.
