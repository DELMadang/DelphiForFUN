unit U_Cards2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UCardComponentV2, ExtCtrls;

type

  TForm1 = class(TForm)
    ShuffleBtn: TButton;
    DealBtn: TButton;
    SelectDeckBtn: TButton;
    Label1: TLabel;
    procedure ShuffleBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DealBtnClick(Sender: TObject);
    procedure SelectDeckBtnClick(Sender: TObject);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CardMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer); 
  end;

var
  Form1: TForm1;

implementation

uses U_Select;

{$R *.DFM}



{Form methods}

procedure TForm1.ShuffleBtnClick(Sender: TObject);
begin
  if not assigned(deck)
  then deck:=TDeck.create(Application.mainform,point(10,10));
  Deck.shuffle;
end;



procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  deck:=TDeck.create(self, point(10,10));
  deck.shuffle;
  For i:=0 to 51 do
  with deck.deckobj[i] do
  begin
    dragmode:=dmautomatic; {allow dragging}
    onmousedown:=CardMouseDown;
    ondragover:=FormDragover;
    ondragdrop:=FormDragDrop;
  end;  
end;

procedure TForm1.DealBtnClick(Sender: TObject);
var
  card:TCard;
  i,j:integer;
begin
  for i:= 1 to 7 do
  Begin
    for j:= 1 to 4  do
    If Deck.getnextcard(card)
    then
    with card do
    Begin
      left:=100*j;
      top:=i*20;
      visible:=true;
      showdeck:=false;
      bringToFront;
    end;
  end;
end;

procedure TForm1.SelectDeckBtnClick(Sender: TObject);
var
  i:integer;
begin
  If OKBottomDlg.showmodal=mrOK
  then for i:=0 to 51 do
  with deck.deckobj[i] do decktype:=OKBottomdlg.newdecktype;
end;

procedure TForm1.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  accept:=true;
end;

procedure TForm1.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  p:TPoint;
begin
  p.x:=x;
  p.y:=y;
  If sender is TCard  then
  with sender as tcard do
  begin
    p.x:=p.x+left;
    p.y:=p.y+top;
  end;
  {p:=clienttoscreen(point(x,y));}
  If source is tcard
  then with source as tcard do
  begin
    top:=p.y;
    left:=p.x;
    bringtofront;
  end;
end;



procedure TForm1.CardMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  If (sender is TCard) and (button=mbright)
  then with tcard(Sender) do showdeck:=not showdeck;
end;

end.
