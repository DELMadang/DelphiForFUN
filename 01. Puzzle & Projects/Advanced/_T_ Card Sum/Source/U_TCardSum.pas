unit U_TCardSum;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Variation of Puzzle #383 from H.E. Dudeney -  Amusements in Mathematics, Dover
 Publications

 Select the Ace through 9 of any suit from a deck of cards and arrange them
 in a 5X5 T shape like this sample:  1 2 9 7 8
                                         3
                                         4
                                         5
                                         6
  Notice that the sum of the digits in the crossbar (1+2+9+7+8=27) is the same
  as the sum of the cards in the upright (9+3+4+5+6=27).   How many unique
  solutions are there?  Unique in this variation means that no set of 5 numbers
  may be repeated in any row or column.   Dudeney's original counted each
  permutation of the digits as unique
 }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, U_CardComponent, ComCtrls, Grids, Spin, mmsystem;

type

  TSlot = record
    p:TPoint;
    occupiedby:TCard;
    end;

  TForm1 = class(TForm)
    RowLbl: TLabel;
    ColLbl: TLabel;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    StringGrid1: TStringGrid;
    ShowSolutionBtn: TButton;
    Shownbr: TSpinEdit;
    StatusLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ShowSolutionBtnClick(Sender: TObject);
  public
    cards:array[1..9] of Tcard;  {array of card images}
    cardSlots:array[1..9] of TSlot; {slot descriptor records for cards}
    dragflag:boolean;  {true ==> a card is being dragged}
    slotfrom:integer;  {where the dragged card came from}
    midw,midh:integer; {half of card width and height}

    {Solutions are 5 character strings, the intersecting card value followed
     by 4 card values in crossbar or upright}
    SolutionList:TStringList; {list of solutions already displayed, used to
                               check for repeats so user doesn't get credit twice}
    Allsolutions:TStringList; {All 18 solutions}
    solutioncounts:array[1..9] of integer; {# of solutions found by intersecting card value}

    {Card moving procedures}
    procedure CardMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CardMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CardMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure movecardtoslot(c:Tcard; slot:integer);
    procedure movecardtohome(c:Tcard);

    function updatesums:boolean; {update crossbar and upright sum labels, return true
                                    if T is full and sums are equal}
    procedure ComputeSolutions; {Called from FormCreate to find all 18 solutuions}
    function IsNewSolution(intersecting:integer; a:array of integer;
                            var SolutionNbr:integer):boolean; {test for new solution}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses combo;

const
  Ttopleft:Tpoint=(x:330;y:10);
  HomeTopLeft:TPoint=(x:10;y:240);

{**************** AdjustGridSize *************}
procedure adjustGridSize(grid:TStringGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;

{**************** FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
{Initialization stuff}
var i:integer;
begin
  solutionlist:=TStringList.create;
  allsolutions:=TStringlist.create;
  {create the cards}
  for i:=1 to 9 do
  begin
    cards[i]:=TCard.create(self);
    with cards[i] do
    begin
      parent:=self;
      onmousedown:=Cardmousedown;
      onmousemove:=CardMouseMove;
      onmouseup:=CardMouseUp;
      setcard(i,D);
      with Ttopleft do
      if i<=5
      then cardslots[i].p:=point(x+(I-1)*(width+4),y)
      else cardslots[i].p:=point(x+2*(width+4),y+(i-5)*(height+4));
      movecardtoslot(cards[i],i);
    end;
  end;

  dragflag:=false;
  midw:=cards[1].width div 2;
  midh:=cards[1].height div 2;
  updatesums; {show the new sum labels}
  computesolutions; {find all 18 solutions}
  with stringgrid1 do
  begin
    colwidths[0]:=100;
    cells[0,0]:= 'Intersection Card -->';
    for i:=0 to 4 do
    begin
      cells[i+1,0]:=inttostr(2*i+1);
      cells[i+1,1]:=inttostr(solutioncounts[2*i+1]);
      cells[i+1,2]:='0';
    end;
    cells[0,1]:='# Solutions';
    cells[0,2]:='# Found';
  end;
  adjustgridsize(stringgrid1);
  allsolutions.sort;
end;

{************* MoveCardToSlot ***********}
procedure TForm1.movecardtoslot(c:Tcard; slot:integer);
{move card to an empty slot on the the T}
begin
  with cardslots[slot] do
  begin
    c.left:=p.x;
    c.top:=p.y;
    occupiedby:=c;
  end;
end;

{**************** MoveCardToHome **********}
procedure TForm1.movecardtohome(c:Tcard);
{Move card to a fixed position, not on the T, based on card value}
begin
  with c do
  begin
    top:=HomeTopleft.y;
    left:=Hometopleft.x+30*(value-1);
  end;
end;

{******************** Formpaint ***********}
procedure TForm1.FormPaint(Sender: TObject);
{redraw the rectangles around the card slots on the T}
var
  i:integer;
begin
  self.Canvas.brush.color:=clblack;
  self.canvas.pen.style:=psdash;
  for i:=1 to 9 do
  with cardslots[i]  do
    self.canvas.framerect(rect(p.x-2,p.y-2,p.x+2*midw+2,p.y+2*midh+2));
end;

{***************** CardMouseDown **************}
procedure TForm1.CardMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Get ready to move a card}
var
  i:integer;
begin
  dragflag:=true;
  {move mouse to center of card for dragging}
  with tcard(sender) do
  mouse.cursorpos:=point(self.left+left+midw,self.top+top+midh);
  slotfrom:=0;
  {if card being dragged from a slot, mark the slot as available}
  for i:=1 to 9 do
  with cardslots[i] do
  if occupiedby=sender then
  begin
    occupiedby:=nil;
    slotfrom:=i;
    break;
  end;
end;

{***************** CardMouseMove **********}
procedure TForm1.CardMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
{If being dragged. move the card}
begin
  If dragflag then
  with sender as TCard do
  begin
    left:=left+x-midw;
    top:=top+y-midh;
  end;
end;

{*************** UpdateSuns **********}
function TForm1.UpdateSums:boolean;
{update sum labels and return true if T is full and sums are equal}
var
  j:integer;
  sum1,sum2:integer;
  fullT:boolean;
begin
    fullt:=true; {are all positions occupied? flag}
    sum1:=0;
    for j:=1 to 5 do
    with cardslots[j] do if occupiedby<> nil then
    with occupiedby do sum1:=sum1+value
    else fullT:=false;
    rowlbl.caption:='Crossbar sum is '+inttostr(sum1);
    if cardslots[3].occupiedby<>nil then sum2:=cardslots[3].occupiedby.value
    else sum2:=0;
    for j:=6 to 9 do
    with cardslots[j] do if occupiedby<> nil then
    with occupiedby do sum2:=sum2+value
    else fullT:=false;
    collbl.caption:='Upright sum is '+inttostr(sum2);
    if fullt and (sum1=sum2) then result:=true
    else result:=false;
end;

{******************** CardMouseUp *************}
procedure TForm1.CardMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{if being dragged, drop the card on an empty position in the T,
 or in its off-T home resting place}
var
  i:integer;
  carddropped:boolean;
  a:array[1..4] of integer;
  n:integer;
  solutionnbr:integer;
begin
  if dragflag then
  with sender as TCard do
  begin
    dragflag:=false;
    carddropped:=false;
    for i:=1 to 9 do
    with cardslots[i] do
    if (abs(left- p.x)<midw) and (abs(top-p.y)<midh)
    then
    begin
      if slotfrom>0 then
      begin
        with cardslots[slotfrom] do
        begin
          occupiedby:=cardslots[i].occupiedby;
          if occupiedby<>nil then
          begin
            occupiedby.left:=p.x;
            occupiedby.top:=p.y;
          end;
        end;
        occupiedby:=nil;
      end;
      if (occupiedby=nil)
      then
      with tcard(sender) do
      begin  {drop card on cardslot}
        left:=p.x;
        top:=p.y;
        occupiedby:=TCard(sender);
        carddropped:=true;
        break;
      end
      else
    end;
    if not carddropped then movecardtohome(Tcard(sender));
    if UpdateSums then {sums were equal}
    begin
      for i:=6 to 9 do a[i-5]:=cardslots[i].occupiedby.value;
      n:=cardslots[3].occupiedby.value;
      if IsNewSolution(n, a, solutionnbr) then
      begin
        statuslbl.caption:='New solution found!'+#13+'(#'+inttostr(solutionnbr)+' of 18)';
        with stringgrid1 do cells[n div 2+1,2] :=
                            inttostr(strtoint(cells[n div 2+1,2])+1);
        if fileexists('toot.wav') then playsound('toot.wav',0,snd_nowait)
        else messagebeep(mb_iconexclamation);;
      end
      else if solutionNbr>0
      then
      begin
        statuslbl.caption:='This solution, (#'
          +inttostr(solutionnbr) +'), has already been displayed';
        beep;
      end
      else statuslbl.caption:='Not a solution, sums not equal';
    end
    else statuslbl.caption:='Not a solution, sums not equal';
  end;
end;

{*************** ComputeSolutions *************}
procedure TForm1.ComputeSolutions;
{find all 18 solutions and put them in the allsolutions list}
var
  i,sum:integer;
  n:integer;
  s1,s2:string;
  OK:boolean;

begin
  for i:=1 to 9 do solutioncounts[i]:=0; {keep solution counts  in and array
                                          indexed by intersecting card value}
  with combos do
  begin
    setup(4,9,combinations); {get 4 of 9 combinations}
    {we're going to select all possible ways to select 4 of 9 cards and
     see which of them could form a solution row}
    while getnextcombo do
    begin
      {add up the 4 numbers in this combination}
      sum:=selected[1];
      for i:= 2 to 4 do sum:=sum+selected[i];
      {Since the sum of all 9 numbers is 45, the sum of any eight, (excluding
       the number that will appear where the row and column intersect) will
       range from 36 (45-9) to 44 (45-1).  The sum of the 4 row numbers must
       equal the sum of the 4 column numbers so the sum of all eight must be
       divisible by 2.  This means that the number at the intersection must be
       odd, i.e. 1,3,5,7 or 9 since only 45 - an odd number will be even.
       Thus the sum of the 4 row numbers must be 18, 19, 20, 21, or 22.
       }
      if (sum>=18) and (sum<=22) then
      begin
        {calculate the intersection number for this sum and make sure that it
        is not in the combination selected}
        n:=(22-sum)*2+1;
        ok:=true;
        {if n is not in selected then this may be a solution, unless it
         it is the column matching a row that has previously been selected}

        s1:='';
        for i:=1 to 4 do {if the card which should be intersecting is already
                          in the 4 cards selected, this cannot be a solution}
        begin
          s1:=s1+inttostr(selected[i]);
          if selected[i]=n then
          begin
            Ok:=false;
            break;
          end;
        end;

        If OK then
        begin
          {still not a solution if
          it is the column matching a row that has previously been selected}

          {Build a string with the intersection number plus the other 4 digits
           that are not in the selected combo}
          s2:='';
          for i:=1 to 9 do
          if (i<>n) and (pos(char(ord('0')+i),s1)=0) then s2:=s2+inttostr(i);
          if (allsolutions.indexof(inttostr(n)+s1)>=0) then OK:=false
          else allsolutions.add(inttostr(n)+s2);
         {it's not, so we have found a solution}
        end;
        if OK then
        begin
          inc(solutioncounts[n])
        end;
      end;
    end;
  end;
end;


{**************** IsNewSolution *************}
function Tform1.IsNewSolution(intersecting:integer;
                                 a:array of integer;
                                 var solutionnbr:integer):boolean;
{search to see if s (a string made up pf the intersecting cad values plus the
 values of card in array "a" is the upright of a  solution,
 if not, check if the intersecting card together with the other 4 cards is a
 solution}
 var
   i,j:integer;
   t:integer;
   s,s2:string;
   n:integer;
begin
  result:=false;
  {is it a possible solution based on sums?}
  {It is if 45 + intersecting digit = 2* sum(other 4 digits)}
  n:=intersecting;
  solutionNbr:=0;
  for i:=low(a) to high(a) do n:=n+a[i];
  if 2*n<>45+intersecting then exit;

  {Sums OK, now check to make sure it has not already been found}
  {first sort the 4 digits of a in ascending order}
  for i:= low(a) to high(a)-1 do for j:= i+1 to high(a) do if a[i]>a[j] then
  begin  t:=a[i]; a[i]:=a[j]; a[j]:=t; end;
  s:=inttostr(intersecting);
  {build a string, s2, of the other 4 cards}
  for i:=low(a) to high(a) do s:=s+inttostr(a[i]);
  s2:=s[1];
   for i:=1 to 9 do
  if (i<>intersecting) and (pos(char(ord('0')+i),s)=0) then s2:=s2+inttostr(i);
  {if neither set of intersecting card plus the other 4 cards is in the solution
   list then this must be a new one}
  if solutionlist.indexof(s)<0 then
  begin
    if solutionlist.indexof(s2)<0 then
    begin
      result:=true;
      solutionlist.add(s2);
    end;
  end;

  solutionnbr:=allsolutions.indexof(s)+1;
  if solutionnbr <=0 then solutionnbr:=allsolutions.indexof(s2)+1;
end;

{************** ShowSolutionBtnClick *************}
procedure TForm1.ShowSolutionBtnClick(Sender: TObject);
{user asked to see a specific solution}
var
  s:string;
  i,j:integer;
begin
  s:=allsolutions[shownbr.value-1];
  movecardtoslot(cards[strtoint(s[1])],3);
  for i:=2 to 5 do movecardtoslot(cards[strtoint(s[i])],i+4);
  j:=0;
  for i:=1 to 9 do if pos(char(ord('0')+i),s)=0 then
  begin
    inc(j);
    if j=3 then inc(j);
    movecardtoslot(cards[i],j);
  end;
  updatesums;
  if shownbr.value<18
  then shownbr.value:=shownbr.value+1
  else shownbr.value:=1;
  {Add to user solution list if not there, so user doesn't get credit for this one}
  if solutionlist.IndexOf(s)<0 then solutionlist.Add(s);
end;

end.
