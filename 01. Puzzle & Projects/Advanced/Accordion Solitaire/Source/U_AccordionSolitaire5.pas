unit U_AccordionSolitaire5;
{Copyright © 2008, 2009  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{

In accordion solitaire, the objective is to compress a spread-out deck so that
only the topmost card is visible. Accordion is notoriously difficult to win
using the standard rules, but some options have been added which should make
victory attainable in one's lifetime.

The stack is compressed by moving cards from right to left, placing them on top
of other cards in the stack. To move a card within the stack, simply click on
the card and then click on the card the moved card will cover. The moved card
and the card it is placed upon must have the same suit or rank. The default
options allow a card to be placed on top of a card immediately to its left or a
card three cards to its left (there will be two cards between the moved card and
its destination). When a card is moved, all other cards which the card has are
moved along with it
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, UCardComponentV2, Grids, ExtCtrls, usearch5, Spin,
  ComCtrls, inifiles, DFFUtils;

type
  tmodalresult=low(integer)..high(integer);

  tMoveobj=class(Tobject)
    fromrank,torank,fromindex,toindex:integer;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Stopbtn: TButton;
    Howgrp: TRadioGroup;
    PlayBtn: TButton;
    Memo1: TMemo;
    ListBox3: TListBox;
    Play100Btn: TButton;
    randstart: TEdit;
    TryAll: TSpinEdit;
    GameLimit: TSpinEdit;
    ListBox4: TListBox;
    Memo2: TMemo;
    Endgame: TRadioGroup;
    Useprevious: TCheckBox;
    Manual: TTabSheet;
    Label11: TLabel;
    VNewBtn: TButton;
    VRandStart: TEdit;
    VUsePrevious: TCheckBox;
    UndoBtn: TButton;
    ListBox5: TListBox;
    ShowWinBtn: TButton;
    RedoBtn: TButton;
    ListBox6: TListBox;
    Label12: TLabel;
    SpinEdit1: TSpinEdit;
    RedoWinBtn: TButton;
    Label4: TLabel;
    TimeLimit: TSpinEdit;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    //procedure NewBtnClick(Sender: TObject);
    procedure PlayBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Play100BtnClick(Sender: TObject);
    procedure HowgrpClick(Sender: TObject);
    procedure StopbtnClick(Sender: TObject);
    procedure VNewBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure UsepreviousClick(Sender: TObject);
    procedure ShowWinBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    topleft:TPoint;
    topcards, moveslist,redolist:Tstringlist;
    source,dest:integer;
    getsource:boolean; {flag for manual play}
    silent:boolean;
    countt,sum, high, low, winners:integer; {game result stats}
    heuristics:boolean; {use any available heuristics when solving}
    filename:string;
    {Manual play variables}
    VDeck:TDeck;  {visual deck for manual play}
    cardinc:TPoint;
    cardsperrow:integer;
    positions:TStringlist;
    animate:boolean;

    {Autoplay procedures and functions}
    procedure new;
    procedure reset;
    procedure resetStats;
    procedure makedeck;
    function isvalidmove(const i1,i2:integer):boolean;
    function makemove(const index:integer; const show:boolean):boolean;
    procedure addpossible(const i,j:integer);
    procedure makemovelistfrom(const n:integer);
    procedure setrandseed;
    procedure playgame;
    procedure playendgame;
    procedure showmoveslist(listbox:TListbox);

    {Manual play procedures and functions}
    procedure cardclick(sender:TObject);
    procedure cardPaint(sender:TObject);
    procedure makevdeck;
    {adjust displayed card position after manual move}
    procedure adjustpositionsfrom(const index, direction:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  charsuit:array[Spades..Hearts] of char=('S','D','C','H');
  charval:array[1..13] of char=('A','2','3','4','5','6','7','8','9','T','J','Q','K');

{************** SetrandSeed *********8}
procedure TForm1.setrandseed;
var
  n:integer;
begin
  If pagecontrol1.activepage=manual then
  begin
    n:=strtointdef(vrandstart.text,0);
    if vuseprevious.checked then randseed:=n
    else
    begin
      vrandstart.text:=inttostr(randseed);
      randstart.text:=inttostr(randseed);
    end;
    makevdeck;
  end
  else
  begin {program play}
    n:=strtointdef(randstart.text,0);
    if useprevious.checked then randseed:=n
    else
    begin
      randstart.text:=inttostr(randseed);
      vrandstart.text:=inttostr(randseed);
    end;
    makedeck;
  end;
end;


{************ MakeDeck ***********}
procedure TForm1.makedeck;
var
  i:integer;
begin
  if assigned(deck) then deck.free;
  with topleft do deck:=TDeck.create(self,point(x,y));
  with deck do
  for i:=0 to 51 do deckobj[i].visible:=false;
end;

{************* MakeVDeck **********}
procedure TForm1.makeVdeck;
var
  i:integer;
begin
  if assigned(Vdeck) then Vdeck.free;
  with topleft do vdeck:=TDeck.create(self, point(x,y));
  positions.clear;
  for i:=0 to 51 do
  begin
    vdeck.DeckObj[i].parent:=manual;
    positions.Add(format('%2d',[i]));
  end;
end;

{********** ValChar *********}
function valchar(x:char):integer;
begin
  case x of
    'A':result:=1;
    '2'..'9': result:=ord(x)-ord('0');
    'T': result:=10;
    'J': result:=11;
    'Q': result:=12;
    'K': result:=13;
    else result:=0;
  end;
end;

{*********** SuitChar ***********}
function suitchar(x:char):TCardSuit;
begin
  case x of
    'S': result:=Spades;
    'H': result:=Hearts;
    'C': result:=Clubs;
    'D': result:=Diamonds;
  end;
end;


{********* FormCreate ********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  stopbtn.bringtofront;
  randomize;
  randstart.text:=inttostr(randseed);
  vrandstart.text:=inttostr(randseed);

  topcards:=TStringlist.create;
  moveslist:=TStringlist.create;
  redolist:=TStringlist.create;
  silent:=false;

  positions:=TStringlist.create;
  cardinc:=point(75,100); {Card to card spacing in rows (x) and columns (y)}
  cardsperrow:=13;
  opendialog1.InitialDir:=extractfilepath(application.exename);
  savedialog1.InitialDir:=opendialog1.InitialDir;
  topleft:=point (10, vuseprevious.Top+vuseprevious.Height+10);
  makedeck;
  makevdeck;
  setrandseed;
  reformatmemo(memo2);
end;

{************* ResetStats **********}
procedure TForm1.resetstats;
begin
  countt:=0;
  sum:=0;
  high:=0;
  low:=100;
  winners:=0;
  //memo1.clear;
end;


{************ New **********}
procedure TForm1.new;
var
  i:integer;
begin
  label2.caption:='Visible top cards of remaining piles';
  setrandseed;

  if randseed<>0 then  deck.NoShowShuffle
  else with listbox1 do
  for i:=0 to 51 do
  begin
    deck.deckobj[i].value:=valchar(items[i][1]);
    deck.deckobj[i].suit:=suitchar(items[i][2]);
  end;
  if not silent then listbox1.clear;
  reset;
end;

{********** AddPossible *********}
procedure TForm1.addpossible(const i,j:integer);
var
  n:integer;
begin
  n:=i shl 8 + j;
  moveslist.addobject(format('%5d',[n]), TObject(n));
end;

{************* MakeMoveList *********}
procedure TForm1.makemovelistFrom(const n:integer);
var
  i:integer;
begin
  begin
    for i:=moveslist.count-1 downto moveslist.count-4 do
    if i>=0 then
    if not isvalidmove(integer(moveslist.objects[i]) shr 8,integer(moveslist.objects[i]) and 255)
    then  moveslist.delete(i);

    for i:= n to topcards.Count-2 do
    if i>=0 then
    begin
      if isvalidmove(i+1,i) then addpossible(i+1,i);
      if (i<=topcards.count-4) and isvalidmove(i+3,i) then addpossible(i+3,i);
    end;
  end;                                                                                                                                  end;



(*
{*********** ShowMovesBtnClick *********}
procedure TForm1.ShowMovesBtnClick(Sender: TObject);

begin
  if not silent then showmoveslist(listbox2);
  label1.caption:=inttostr(listbox2.items.count)+' possible moves';
end;
*)


{************** MakeMove ********}
function TForm1.makemove(const index:integer; const show:boolean):boolean;
var
  i,j,k,n:integer;
begin
  result:=false;
  with moveslist do
  begin
    if index>=moveslist.count then exit;
    n:=Integer(objects[index]);
    i:=n shr 8;
    j:=n and 255;
    (* {for debugging}
    if (i>=topcards.count) or (j>=topcards.count) or (i<0) or (j<0) or (i<=j)
    then
    begin
       memo1.lines.add(format('Invalid index i:%d j:%d, topcards count=%d',[i,j,topcards.count]));
       exit;
    end;
    *)
    if not silent then
    begin
      listbox4.items.add(topcards[i]+' to '+topcards[j]);
    end;
    topcards[j]:=topcards[i];
    topcards.Objects[j]:=topcards.objects[i];
    topcards.delete(i);
    (*
    if show and (not silent) then
    with listbox3 do
    begin
      items[j]:=items[i];
      items.delete(i);
    end;
    *)
    result:=true;
    for k:=moveslist.count-1 downto index do moveslist.delete(k);
    while (moveslist.count>0)
    and (integer(moveslist.objects[moveslist.count-1]) shr 8>=topcards.count)
    do moveslist.delete(moveslist.count-1);

    makemovelistfrom(j);   {rebuild the moves that might have been affected by this move}
  end;
end;

{**************PlayBtnClick *********}
procedure TForm1.PlayBtnClick(Sender: TObject);
var
  starttime:TDatetime;
begin
  silent:=false;
  tag:=0;
  stopbtn.visible:=true;
  starttime:=now;
  memo1.lines.clear;
  with memo1.lines do
  begin
    add(''); add(''); add('');
  end;  
  new;

  playgame;
  stopbtn.Visible:=false;
  with memo1.lines do
  begin
    clear;
    add(format('Games: %d, Avg. piles left %.1f, High %d, Low: %d, Winners: %d',
       [countt,sum/countt,high,low, winners]));
    add(format('Search moves= %d, Run time = %.1f seconds',[tryall.value,(now-starttime)*secsperday]));
    add(' ');
  end;
end;

{************ Play100BtnClick ********}
procedure TForm1.Play100BtnClick(Sender: TObject);
var
  i:integer;
  starttime:TDateTime;
  ini:TInifile;
  runtime:extended;
  dstr:string;
  initialseed:string;
begin
  silent:=true;
  stopbtn.visible:=true;
  resetbtnclick(sender);
  starttime:=now;
  memo1.clear;
  memo1.lines.add('Games=0, Winners=0');
  memo1.lines.add('');
  memo1.lines.add('');
  for i:=1 to gamelimit.value do {play multiple games}
  begin
    new; {make a new deck}
    if i=1 then initialseed:=randstart.text;
    playgame;
     {in case it was set, no need to use the same key for all games}
    useprevious.checked:=false;
    with memo1 do
    begin
      lines[0]:=format('Games=%d, Winners=%d',[countt, winners]);
      lines[1]:='Game #'+inttostr(countt+1);
      lines[2]:='';
    end;
    if tag>0 then break;
  end;
  stopbtn.Visible:=false;
  with memo1.lines do
  begin
    runtime:=(now-starttime)*secsperday;
    clear;
    add(format('Games %d, Avg. piles left %.1f',[countt,sum/countt]));
    add(format('High %d, Low: %d, Winners: %d',[high,low,winners]));
    add('Starting random seed '+initialseed);
    add(format('BF SearchMoves %d, Run time = %.1f seconds',[tryall.value,runtime]));
    ini:=TInifile.create(extractfilepath(application.exename)+'AccordionSolitaire.ini');
  end;
  with ini do
  begin
    dstr:=formatdatetime('mmm dd, yyyy hh:nn am/pm',now);
    writeinteger('Stats '+ dstr,'Games',countt);
    writestring('Stats '+ dstr,'Initial Seed',initialseed);
    writeinteger('Stats '+ dstr,'Option',howgrp.itemindex);
    writefloat('Stats '+ dstr,'Avg Left',trunc(10*sum/countt)/10);
    writeinteger('Stats '+ dstr,'High',high);
    writeinteger('Stats '+ dstr,'Low',low);
    writeinteger('Stats '+ dstr,'Winners',winners);
    writeinteger('Stats '+ dstr,'BF Search',tryall.value);
    writefloat('Stats '+ dstr,'Run Secs',trunc(10*runtime)/10);
    free;
  end;
  silent:=false;
  resetbtnclick(sender);
end;


{*********** PlayGame **********}
procedure TForm1.playgame;
var  i,n:integer;
     {variables used in sweeper method}
     sweep:array[1..52] of integer;
     maxsweep:integer;
     sweeper:integer;
     movenbr:integer;
     frompos,fromval,topos,toval:integer;

begin
  if not silent then
  begin
    listbox3.clear;
    //listbox2.clear;
    listbox4.clear;
    listbox6.clear;
  end;

  tag:=0;

  label2.caption:='Final card piles';
  case howgrp.itemindex of
    0: { Random move}
    begin
      repeat
        if topcards.count<=TryAll.value then
        begin
          playendgame;
          break;
        end;
      until not makemove(random(moveslist.count),false)or (topcards.count=1);
      if not silent then
      with listbox3 do
      for i:=0 to topcards.count-1 do items.add(topcards[i]);
    end;

    1: {Highest value first}
    begin
      repeat
        if topcards.count<=TryAll.value then
        begin
          playendgame;
          break;
        end;
      until (moveslist.count=0) or (topcards.count=1) or (not makemove(moveslist.count-1,false));
      if not silent then
      with listbox3 do
      for i:=0 to topcards.count-1 do
      with topcards do items.add(format('%S',[strings[i]]));
    end;

    2,3: {"Sweepers"}
    begin
      If howgrp.ItemIndex = 3 then Heuristics:=true
      else Heuristics:=false;

      {find "sweeper" - card value with highest average position}
      for i:=1 to 52 do sweep[i]:=0;
      for i:= 0 to topcards.count-1 do
      begin
        n:=valchar(topcards[i][1]);
        inc(sweep[n],i);
      end;
      maxsweep:=0;
      for i:=1 to 52 do
      if sweep[i]>maxsweep then
      begin
        maxsweep:=sweep[i];
        sweeper:=i;
      end;


      (*
      {find "sweeper" - card value with highest lowest position}
      for i:=1 to 52 do sweep[i]:=0;
      for i:= topcards.count-1 downto 0 do
      begin
        n:=valchar(topcards[i][1]);
        inc(sweep[n]);
        if sweep[n]=4 then
        begin
          sweeper:=n;
          break;
        end;
      end;
      *)


      (*
      {try sweeper as the value occurring most often in the upper half of the deck}
      for i:=1 to 52 do sweep[i]:=0;
      for i:= 26 to topcards.count-1 do
      begin
        n:=valchar(topcards[i][1]);
        inc(sweep[n]);
      end;
      maxsweep:=0;
      for i:=1 to 52 do
      if sweep[i]>maxsweep then
      begin
        maxsweep:=sweep[i];
        sweeper:=i;
      end;
      *)


      if not silent then label1.caption:='Sweeper value='+charval[sweeper];
      repeat
        {look for sweeper move that does not overlay a sweeper value}
        movenbr:=-1;
        for i:=moveslist.count-1 downto 0 do
        begin
          n:=integer(moveslist.objects[i]);
          frompos:=n shr 8;
          fromval:=TCard(topcards.objects[frompos]).value;
          if fromval=sweeper then
          begin
            topos:=n and 255;
            toval:=TCard(topcards.objects[topos]).value;
            if toval<>fromval then
            begin
              movenbr:=i;
              break;
            end;
          end;
        end;

        if (movenbr<0) then  {no sweeper move made}
        for i:=moveslist.count-1 downto 0  do
        begin
          toval:=tcard(topcards.objects[integer(moveslist.objects[i]) and 255]).value;
          if toval<>sweeper then
          begin
            movenbr:=i;
            if makemove(movenbr,false) then break;
          end;
        end
        else makemove(movenbr,false);
        with topcards do
        if (count>1) and (count<=TryAll.value) then
        begin
          playendgame;
          break;
        end;
      until (moveslist.count=0) or (topcards.count<=tryall.value)
      or ((movenbr<0) and (not makemove(moveslist.count-1,false)));
      if not silent then
      with listbox3 do
      for i:=0 to topcards.count-1 do
      with topcards do items.add(format('%S',[strings[i]]));

      {Move highest positions first, but do  not overlay sweeper value}
    end;

    (*
    4:
    with form2 do
    begin
      tag:=0;
      topcards.assign(topcards);
      mr:=showmodal;
      form1.topcards.assign(topcards);
    end;
    *)
    else
    Begin
      Showmessage('Not yet');
    end;
  end;
  n:=topcards.count;
  inc(countt);
  inc(sum,n);
  if n>high then high:=n;
  if n<low then low:=n;
  If n=1 then inc(winners);
  application.processmessages;
end;

procedure TForm1.playendgame;
var
  i:integer;
  val:integer;
  ordsuit:TCardsuit;

begin
  case endgame.itemindex of
  0:
  begin
    showwinbtnclick(self);
  end;

  1:
    with form2 do
    begin
      tag:=0;
      silent:=form1.silent;
      topcards.assign(form1.topcards);
      formactivate(self);
      if length(newcards)>0 then
      begin
        form1.topcards.clear;
        {reinsert card objects stripped by usearch}
        for i:=1 to length(newcards) do
        begin
          val:=ord(newcards[i]) shr 2;
          ordsuit:=TCardsuit(ord(newcards[i]) and 3);
          with deck do
          form1.topcards.addobject(charval[val]+charsuit[ordsuit],deckobj[getcardnbr(ordsuit,val)]);
          //form1.topcards.addobject(inttostr(val)+charsuit[ordsuit],deckobj[getcardnbr(ordsuit,val)]);
        end;
      end;
      if not form1.silent then
      with form1.listbox4.items do
      begin
        add('Exh. moves');
        addstrings(pathlist);
      end;
    end;
  end; {case}
end;


{*********** ResetBtnClick **********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  resetstats;
  reset;
end;

{******** Reset ********}
procedure TForm1.reset;
var
  i:integer;
begin
  topcards.clear;
  if not silent then
  begin
    listbox1.clear;
    //listbox2.clear;
    listbox3.clear;
    listbox4.clear;
    listbox6.clear;
  end;

  with deck, listbox1  do
  for i:=0 to 51 do
  with deckobj[i] do
  begin
    rank:=i;
    if not silent then items.add(charval[value]+charsuit[suit]);
    topcards.addobject(charval[value]+charsuit[suit],deckobj[i]);
  end;
  moveslist.clear;
  makemovelistfrom(0);
  //showmoveslist(listbox2);
end;



{*********** Isvalidmove **********}
function TForm1.isvalidmove(const i1,i2:integer):Boolean;

var
  v1,v2:integer;
  s1,s2:TCardSuit;
  i:integer;
begin
  result:=false;
  if (i1>=0) and (i2>=0) and (i1<topcards.count) and (i2<topcards.count)
  and (i1>i2) then
  with topcards, deck  do
  begin

    v1:=TCard(objects[i1]).value;
    v2:=TCard(objects[i2]).value;

    s1:=TCard(objects[i1]).suit;
    s2:=TCard(objects[i2]).suit;
    if (v1=v2) or (s1=s2)
    then result:=true;
  end;
end;


{*********** ShowMovesList *********8}
procedure TForm1.showmoveslist(listbox:Tlistbox);
var
  i,j,k,n:integer;
begin
  listbox.clear;
  for k:=0 to moveslist.count-1 do
  begin
    n:=integer(moveslist.objects[k]);
    j:=n and 255;
    i:=n shr 8;
    if not silent then listbox.items.add(topcards[i]+' to '+topcards[j]);
  end;
end;

{************ HowGrpClick ********8}
procedure TForm1.HowgrpClick(Sender: TObject);
begin
  resetbtnclick(sender);
end;

{********* StopBtnClick ********}
procedure TForm1.StopbtnClick(Sender: TObject);
begin
  tag:=1;
  form2.tag:=1;
  stopbtn.visible:=false;
end;


{********** VNewBtnClick ********8}
procedure TForm1.VNewBtnClick(Sender: TObject);
var
  i:integer;
begin
  animate:=true;
  with listbox5 do
  for i:=1 to items.count-1 do
    if items.objects[i]<>nil then TMoveobj(items.objects[i]).free;
  listbox5.clear;
  listbox5.items.Add('Current moves');
  with redolist do
  for i:=0 to count-1 do
    if objects[i]<>nil then TMoveobj(objects[i]).free;
  redolist.clear;

  setrandseed;
  if randseed<>0 then vdeck.Noshowshuffle;
  
  for i:=0 to 51 do
  with vdeck,deckobj[i] do
  begin
    visible:=true;
    left:= topleft.x+(i mod cardsperrow)*cardinc.x;
    top:= topleft.y+(i div cardsperrow)*cardinc.y;
    onclick:=Cardclick;
    onpaint:=cardpaint;
    rank:=i;
    positions[i]:=format('%2d',[i]);
    showdeck:=false;
  end;
  getsource:=true;
end;


{************* AdjustPositionfrom **********}
procedure TForm1.adjustpositionsfrom(const index,direction:integer);
{Animate moving cards after a move or undo operaion}
var
  i,j,n:integer;
  startleft, newleft:integer;
begin
  If direction<0 then
  begin
    for i:=index+1 to positions.count-1 do
    begin
      n:=strtoint(positions[i]);
      with vdeck.deckobj[n] do
      begin
        startleft:=left;
        newleft:=topleft.x+(i mod cardsperrow)*cardinc.x;
        top:= topleft.y+(i div cardsperrow)*cardinc.Y;
        if (newleft<startleft) and animate then
        for j:=startleft downto newleft do
        begin
          left:=j;
          paint;
          application.processmessages;
        end
        else left:=newleft;
      end;
    end;
  end
  else
  begin {moving right, (undo)}
    for i:=positions.count-1 downto index do
    begin
      n:=strtoint(positions[i]);
      with vdeck.deckobj[n] do
      begin
        startleft:=left;
        newleft:=topleft.x+(i mod cardsperrow)*cardinc.x;
        top:= topleft.y+(i div cardsperrow)*cardinc.Y;
        if (startleft<newleft) and animate then
        for j:=startleft to newleft do
        begin
          left:=j;
          paint;
          application.processmessages;
        end
        else left:=newleft;
      end;
    end;
  end;
end;



{************** CardClick ************}
procedure Tform1.cardclick(sender:TObject);
{User clicked on a card}
   function isvalidvisualMove(source,dest:integer):boolean;
   begin
     with vdeck do

     if (deckobj[source].value=deckobj[dest].value)
        or (deckobj[source].suit=deckobj[dest].suit)
     then result:=true else result:=false;
   end;

var
  indexto,indexfrom:integer;
  moveobj:TMoveObj;
begin
  with tcard(sender) do
  if getsource then
  begin
    source:=rank;
    top:=top-4; {Jog the source card up}
    getsource:=false;
    paint;
  end
  else
  begin
    dest:=rank;
    getsource:=false;
    with vdeck.deckobj[source] do top:=top+4;  {jog the source card down}
    indexto:=positions.indexof(format('%2d',[dest]));
    indexfrom:=positions.indexof(format('%2d',[source]));
    if ((indexto=indexfrom-1) or (indexto=indexfrom-3))
       and isvalidvisualmove(source,dest) then
    with vdeck do
    begin
      moveobj:=tmoveobj.create;
      with moveobj do
      begin
        fromindex:=indexfrom;
        toindex:=indexto;
        fromrank:=source;
        torank:=dest;
      end;
      listbox5.items.addobject(format('%s%d',
             [charval[deckobj[source].value]+charsuit[deckobj[source].suit],
             indexto-indexfrom]),moveobj);
      positions.delete(indexfrom);
      positions[indexto]:=format('%2d',[source]);
      with vdeck.DeckObj[source] do
      begin
        left:=vdeck.deckobj[dest].left;
        top:=vdeck.deckobj[dest].top;
      end;
      vdeck.DeckObj[dest].visible:=false;
      adjustpositionsfrom(indexto,-1);
    end;
    getsource:=true;
  end;
end;

{********** Cardpaint **********}
Procedure TForm1.Cardpaint(sender:TObject);
var
  b:TBitmap;
begin
  with TCard(sender) do
  if rank=source then
  begin
    b:=TBitmap.create;
    b.Width:=width;
    b.Height:=height;
    b.canvas.brush.color:=clgray;
    b.canvas.fillrect(rect(0,0,width,height));
     b.canvas.copymode:=cmDstinvert;
     canvas.copymode:=cmDstinvert;
    canvas.draw(0,0,b);
    b.free;
  end;
end;

{******** UndoBtnClick *******}
procedure TForm1.UndoBtnClick(Sender: TObject);
var
  moveobj:TMoveobj;
  i,n:integer;
begin
  {ensure only one undo, redo at a time}
  undobtn.enabled:=false;  redobtn.enabled:=false;
  n:=Spinedit1.value;
  with listbox5,items do
  begin
    if n>count-1 then n:=count-1;
    If count>N then
    for i:=1 to n do
    begin
      moveobj:=TMoveobj(objects[count-1]);
      with moveobj do
      begin
        positions.insert(fromindex,format('%2d',[fromrank]));
        positions[toindex]:=format('%2d',[torank]);
        with vdeck.DeckObj[fromrank] do
        begin
          left:=topleft.x+(fromindex mod cardsperrow)*cardinc.x;
          top:= topleft.y+(fromindex div cardsperrow)*cardinc.Y;
        end;
        vdeck.DeckObj[torank].visible:=true;
        adjustpositionsfrom(toindex, +1);
      end;
      RedoList.addobject(items[count-1],moveobj);
      items.Delete(count-1);
    end;
  end;
  undobtn.enabled:=true; redobtn.enabled:=true;
end;



procedure TForm1.UsepreviousClick(Sender: TObject);
var
  check:boolean;
begin
  with TCheckbox(sender) do
  begin
    check:=checked;
    VUseprevious.checked:=check;
    useprevious.checked:=check;
    if not checked then setrandseed;
  end;
end;

procedure TForm1.ShowWinBtnClick(Sender: TObject);
var
  i,n:integer;
  fromval,toval:integer;
  fromsuit,tosuit:TcardSuit;
  s:string;
begin
  pagecontrol1.ActivePage:=manual;
  vuseprevious.checked:=true;
  vnewbtnclick(sender);
  application.processmessages;
  listbox6.clear;
  listbox6.items.add('Winning moves');
  animate:=false;
  with listbox4.items do
  for i:=0 to count-1 do
  if length(strings[i])=8 then
  begin
    s:=strings[i];
    listbox6.items.add(s);
    fromval:=valchar(s[1]);
    fromsuit:=suitchar(s[2]);
    toval:=valchar(s[7]);
    tosuit:=suitchar(s[8]);
    n:=vdeck.getcardnbr(fromsuit,fromval);
    cardclick(vdeck.deckobj[n]);
    sleep(50);
    n:=vdeck.getcardnbr(tosuit,toval);
    cardclick(vdeck.deckobj[n]);
    sleep(50);
    application.processmessages;
  end;
  animate:=true;
end;

{************ RedoBtnClick *************}
procedure TForm1.RedoBtnClick(Sender: TObject);
var
  moveobj:TMoveobj;
begin
  {ensure only one undo, redo at a time}
  undobtn.enabled:=false;  redobtn.enabled:=false;
  with redolist do
  if count>0 then
  begin
    moveobj:=TMoveobj(objects[count-1]);
    with moveobj do
    begin
      cardclick(vdeck.deckobj[fromrank]);
      sleep(50);
      cardclick(vdeck.deckobj[torank]);
    end;
    moveobj.free;
    delete(count-1);
  end;
  undobtn.enabled:=true;  redobtn.enabled:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.SaveBtnClick(Sender: TObject);
var
  i:integer;
  f:textfile;
begin
  If savedialog1.execute then
  begin
    filename:=savedialog1.filename;
    opendialog1.FileName:=filename;
    assignfile(f,filename);
    rewrite(f);
    for i:=0 to listbox1.items.count-1 do writeln(f,listbox1.items[i]);
    closefile(f);
    
  end;
end;

procedure TForm1.LoadBtnClick(Sender: TObject);
var
  i:integer;
  f:textfile;
  line:string;
begin
  If opendialog1.execute then
  begin
    filename:=opendialog1.filename;
    savedialog1.fileName:=filename;
    assignfile(f,filename);
    system.reset(f);
    listbox1.clear;
    while not eof(f) do
    begin
      readln(f,line);
      listbox1.Items.add(line);
    end;
    closefile(f);
    useprevious.checked:=true;
    randstart.text:='0';
  end;
end;

end.