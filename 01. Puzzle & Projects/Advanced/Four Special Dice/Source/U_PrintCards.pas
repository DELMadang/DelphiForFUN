unit U_PrintCards;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, Printers, ShellAPI, uCardComponentV2, U_FourDice3;

type
  TForm2 = class(TForm)
    Memo3: TMemo;
    Image1: TImage;
    Label8: TLabel;
    SpinEdit5: TSpinEdit;
    Label9: TLabel;
    SpinEdit6: TSpinEdit;
    PreviewFrontBtn: TButton;
    PreviewbackBtn: TButton;
    PrtFrontBtn: TButton;
    PrtBackBtn: TButton;
    PrtBothBtn: TButton;
    CloseBt: TButton;
    PrintDialog1: TPrintDialog;
    StaticText1: TStaticText;
    procedure PreviewFrontBtnClick(Sender: TObject);
    procedure PreviewbackBtnClick(Sender: TObject);
    procedure PrtBtnClick(Sender: TObject);
    procedure PrtBothBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SpinEditChange(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure CloseBtClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ansrec:TAnswer;  {Set of solutions nodes to nodes}
    dicesides:integer;
    templist:TStringlist;
    procedure Createcards; {Create a deck with appropriate card values and backs}
    procedure drawcards(nbrcards:integer; showback:boolean;pagesize:TPoint; ccanvas:TCanvas);
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

{************** FormActivate **********}
procedure TForm2.FormActivate(Sender: TObject);

begin
   deck:=TDeck.create(self,point(10,10));
   templist:=TStringlist.create;
   createcards;
   drawcards(ansrec.count*dicesides,false, point(image1.width, image1.height), image1.canvas);
end;

{************** DrawCards *************}
procedure TForm2.drawcards(nbrcards:integer; showback:boolean;pagesize:TPoint; ccanvas:TCanvas);
var
  card:TCard;
  i:integer;
  scale:real;
  w,hh,newheight,newwidth:integer;
  offsetx,offsety:integer;
  CardBitmap: TBitmap;
  ResName: String;
  lft,tp:integer;
  spacing:integer;
begin
  ccanvas.brush.color:=clwhite;
  ccanvas.fillrect(rect(0,0,pagesize.x,pagesize.y));
  spacing:=pagesize.y div 200;
  if spacing<5 then spacing:=5;
  {desired scaled total sum of cards with 5 pixel margins covering 90% of canvas}
  w:=(9*pagesize.x div 10) div spinedit5.value + spacing;
  hh:=(9*pagesize.y div 10) div spinedit6.value + spacing;
  card:=deck.deckobj[0];

  if w/card.width< hh/card.height
  then scale:=w/card.width
  else scale:=hh/card.height;
  newwidth:=trunc(card.width * scale);
  newheight:=trunc(card.height * scale);
  {center the images}
  offsetx:=(pagesize.x - newwidth*spinedit5.value) div 2;
  offsety:=(pagesize.y - newheight*spinedit6.value) div 2;
  CardBitmap := TBitmap.Create;
  for i:= 0 to nbrcards-1 do
  begin
    card:=deck.deckobj[i];
    with card do
    begin
      showdeck:=showback;
      if not showdeck then
      begin
        {build the card name}
        case Suit of
          Hearts: ResName := 'H';
          Spades: ResName := 'S';
          Clubs:  ResName := 'C';
          Diamonds: ResName := 'D';
        end;
        ResName := ResName+IntToStr(Value);
      end
      else
      case DeckType of
        Standard1: ResName := 'STD1';
        Standard2: ResName := 'STD2';
        Fishes1: ResName := 'FISHES1';
        Fishes2: ResName := 'FISHES2';
        Beach: ResName := 'BEACH';
        //   Leaves1: ResName := 'LEAVES1';
        //   Leaves2: ResName := 'LEAVES2';
        Robot: ResName := 'ROBOT';
        //   Roses: ResName := 'ROSES';
        Shell: ResName := 'SHELL';
       // Castle: ResName := 'CASTLE';
        Hand: ResName := 'HAND';
      end;
      // load bitmap from resources
      CardBitmap.LoadFromResourceName(HInstance,ResName);
      //  with cardbitmap do canvas.floodfill(3,card.height div 2, clwhite,fsSurface);
      lft:=offsetx+(i mod spinedit5.value)*newwidth;
      tp:=offsety+(i div spinedit5.value)*newheight;
      ccanvas.copyrect(rect(lft,tp,lft+newwidth-spacing, tp+newheight-spacing),
                             cardbitmap.canvas,
                             rect(0,0,card.width,card.height));
    end;
  end;
  CardBitmap.Free;
end;

{************* PrtBtnClick ************}
procedure TForm2.PrtBtnClick(Sender: TObject);
{Print front or back depending on which button was clicked}
var showback:boolean;
begin
  if printdialog1.execute then
  begin
    with printer do
    begin
      begindoc;
        if sender=prtbackBtn then showback:=true else showback:=false;
        drawcards(ansrec.count*dicesides, showback,point(pagewidth,pageheight),printer.canvas);
      enddoc;
    end;
  end;
end;

{************ PreviewFrontBtnClick *********}
procedure TForm2.PreviewFrontBtnClick(Sender: TObject);
begin
  drawcards(ansrec.count*dicesides,false,point(image1.width, image1.height), image1.canvas);
end;

{************* PreviewBackBtnClick *****}
procedure TForm2.PreviewbackBtnClick(Sender: TObject);
{generate and preview a random set of card backs}
begin
  createcards;  {Recreate to get a new set of backs}
  drawcards(ansrec.count*dicesides,true, point(image1.width, image1.height), image1.canvas);
end;

{*********** PrtBothBtnClick **********}
procedure TForm2.PrtBothBtnClick(Sender: TObject);
begin
  if printdialog1.execute then
  begin
    with printer do
    begin
      begindoc;
      drawcards(ansrec.count*dicesides, false,point(pagewidth,pageheight),printer.canvas);
      newpage;
      drawcards(ansrec.count*dicesides, true,point(pagewidth,pageheight),printer.canvas);
      enddoc;
    end;
  end;
end;

{************** StaticText1Click *******}
procedure TForm2.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{**************** CreateCards *************}
procedure TForm2.CreateCards;
{Assign solution nodes in ansrec to cards and make random backs}
var
  ss:string;
  useddecks:array [TDecks] of boolean;
  dtype:TDecks;
  i,j:integer;
begin
  for i:=0 to  ord(high(useddecks))  do useddecks[Tdecks(i)]:=false;
  templist.clear;
  for i:= 1 to ansrec.count do
  begin
    {get a unique card back design for this set of cards}
    repeat
      dtype:=tdecks(random(ord(high(tdecks))))
      {castle, roses, and leaves are too dark for my taste}
    until (not useddecks[dtype]) and (not (dtype in [castle,roses,leaves1,leaves2]));
    useddecks[dtype]:=true;
    ss:=form1.graph[ansrec.ans[i]];
    templist.commatext:=ss;
    {make cards to match}
    with deck do
    begin
      for j:=0 to templist.count-1 do
      with  deckobj[(i-1)*dicesides+j] do
      begin
        decktype:=dtype;
        value:=strtoint({form1.}templist[j]);
      end;
    end;
  end;
end;

{*********** SpinEditChange **********}
procedure TForm2.SpinEditChange(Sender: TObject);
{Cards across ot cards down changed}
begin
  drawcards(ansrec.count*dicesides,false, point(image1.width, image1.height), image1.canvas);
end;

{************* FromDeActivate **********}
procedure TForm2.FormDeactivate(Sender: TObject);
begin
  templist.free;
  deck.free;
end;

{********** CloseBtnClick **********}
procedure TForm2.CloseBtClick(Sender: TObject);
begin
  close;
end;

end.
