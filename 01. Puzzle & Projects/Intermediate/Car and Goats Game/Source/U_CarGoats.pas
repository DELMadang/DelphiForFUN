unit U_CarGoats;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
You have a choice of one of 3 doors.  One of the doors has a
new car behind it, the other two have goats as prizes.

After you select a door, the host will open one of the other
doors revealing a goat.  You then have the choice of sticking
with your original choice or switching doors.

Assuming that it is more desirable to take home a car than a
goat, what should you do?  Does it make any difference?

Try a few dozen games, then click then select the strategy that you think is best
to see an explanation and the right to run additional cases 1000 at a time.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList;

type
  TPrize=(goat1, goat2, car);

  TDoor=class(TObject)  {three of these are defined in an array}
    selected:boolean; {player has selected this door}
    prize:TPrize; {the prize hidden behind this door}
    open:boolean;  {true ==> the door is open}
    shape:TShape;  {the door image}
    origheight:integer; {door height}
    procedure opendoor;  {animated door opening}
    procedure closedoor; {redraw the door as closed}
    procedure setprize(pic:TImage);
  end;


  TForm1 = class(TForm)
    Memo1: TMemo;
    Door1: TShape;
    Door2: TShape;
    SelectLbl: TLabel;
    BatchBtn: TButton;
    Memo2: TMemo;
    goatpic2: TImage;
    goatpic1: TImage;
    Door3: TShape;
    carpic: TImage;
    WinLoseLbl: TLabel;
    VoteGrp: TRadioGroup;
    procedure DoorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure BatchBtnClick(Sender: TObject);
    procedure VoteGrpClick(Sender: TObject);
  public
    switchgames, nonswitchgames:integer; {games played counters}
    switchwins, nonswitchwins:integer; {games won counters}
    doors:array[1..3] of tdoor;
    picorder:array[1..3] of integer; {pic nbrs for the 3 doors
                                      - used to reshuffle prizes for each game}
    busy:boolean; {set to true to ignore clicks while processing a click}
    doorselected:integer; {# of the door selected first - saves scanning to find it}
    procedure reset; {set up a new game}
    procedure updatestats; {refresh the displayed statistics}
  end;

var  Form1: TForm1;

implementation
uses U_ExplainDlg;
{$R *.DFM}

{*************** TDoor.OpenDoor ***************}
procedure tdoor.opendoor;
var i:integer;
begin
  open:=true;
  if prize=goat1 then with form1.goatpic1 do
  begin top:=shape.top; left:=shape.left; end
  else if prize=goat2 then with form1.goatpic2 do
  begin top:=shape.top; left:=shape.left; end
  else with form1.carpic do
  begin top:=shape.top; left:=shape.left; end;
  for i:= origheight div 2 downto 0 do
  begin
    shape.height:=2*i;
    shape.update;
  end;
end;

{**************** TDoor.CloseDoor *********}
procedure tdoor.closedoor;
begin
  open:=false;
  shape.height:=origheight;
end;

procedure TDoor.setprize(pic:TImage);
begin
  {pictures are defined with goatpic1.tag=0, goatpic2,tag:=1, carpic.tag:=2
   corresponding to TPrize types of goat1, goat2, car}
  prize:=TPrize(pic.tag);
  pic.top:=shape.top;  {move the picture behind the proper door}
  pic.left:=shape.left;
end;


{************ Shuffle *************}
procedure shuffle(var deck:array of integer);
{randomly shuffle prizes across doors}
var  i,n, temp:integer;
begin
  i:= low(deck);
  while i<high(deck) do
  begin
    n:=i +random(high(deck)-i+1);
    temp:=deck[i];
    deck[i]:=deck[n];
    deck[n]:=temp;
    inc(i);
  end;
end;




{******************TForm1.Activate **********}
procedure TForm1.FormActivate(Sender: TObject);
var i:integer;
begin
  randomize;
  doors[1]:=TDoor.create; doors[1].shape:=door1;
  doors[2]:=TDoor.create; doors[2].shape:=door2;
  doors[3]:=TDoor.create; doors[3].shape:=door3;
  for i:=1 to 3 do
  begin
    doors[i].origheight:=doors[i].shape.height;
    picorder[i]:=i;
  end;
  reset;
  doublebuffered:=true;
end;

{***************** TForm1.DoorMouseDown ************}
procedure TForm1.DoorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{User clicked a door}
 var
   i:integer;
   switched, won:boolean;
   clicked:TDoor;
  begin
    clicked:=doors[TShape(sender).tag]; {just a shorthand reference}
    if busy or clicked.open then exit; {ignore clicks while door is opening or on open door}
    busy:=true;
    if doorselected=0 then {this is the first click}
    begin
      clicked.selected:=true;
      doorselected:=clicked.shape.tag;
      {pick a random unselected goat door}
      i:=random(3)+1;
      while doors[i].selected or (doors[i].prize=car) do i:=random(3)+1;
      doors[i].opendoor;  {open that door}
      selectlbl.caption:='Click a door to make your final selection';
    end
    else {second click}
    begin
      if clicked.selected then switched:=false
      else
      begin {switched doors}
        switched:=true;
        doors[doorselected].selected:=false;{unselect the previous door}
        clicked.selected:=true; {and select the new one}
      end;
      {check for win or loss}
      if clicked.prize=car then won:=true else won:=false;
      if won then winloselbl.caption:='WINNER!'
      else winloselbl.caption:='LOSER!';
      winloselbl.visible:=true;
      clicked.opendoor;
      sleep(1000);  {wait a second before starting next game}
      winloselbl.visible:=false;
      if switched then
      begin
        inc(switchgames);
        if won then inc(switchwins);
      end
      else
      begin
        inc(nonswitchgames);
        if won then inc(nonswitchwins);
      end;
      updatestats;
      reset;
    end;
    busy:=false;
  end;

{********************* TForma1.UpdateStats **********}
procedure TForm1.updatestats;
var pct:real;
begin
  with memo2 do
  begin
    if nonswitchgames>0 then pct:=nonswitchwins/nonswitchgames*100 else pct:=0;
    lines[2]:=format('%4d games with NO SWITCH and won %d, (%4.1f%%)',
                     [nonswitchgames,nonswitchwins, pct]);
   if switchgames>0 then pct:=switchwins/switchgames*100 else pct:=0;
   lines[4]:=format('%4d games with SWITCH and won %d, (%4.1f%%)',
                     [switchgames,switchwins, pct]);
  end;
end;


{************** TForm1.reset *************}
procedure TForm1.reset;
{get ready for a new game}
var i:integer;
begin
  {randomly assign the 3 prizes to doors}
  shuffle(picorder);
  for i:=1 to 3 do
  with doors[i] do
  begin
    case picorder[i] of
      1: setprize(goatpic1);
      2: setprize(goatpic2);
      3: setprize(carpic);
    end;
    closedoor; {make sure doors are closed and not selected}
    selected:=false;
  end;
  selectlbl.caption:='Click a door to start';
  doorselected:=0;
end;

{***************TForm1.BatchBtnClik **************}
procedure TForm1.BatchBtnClick(Sender: TObject);
{same as mouse down procedure except we'll select doors randomly,
  and skip the animation}
var
  i,j:integer;
  switched,won:boolean;
  clicked:TDoor;
begin
  busy:=true;
  screen.cursor:=crHourglass;
  for j:= 1 to 1000 do
  begin
    clicked:=doors[random(3)+1]; {pick a door}
    clicked.selected:=true;
    doorselected:=clicked.shape.tag;
    {pick a random unselected goat door}
    i:=random(3)+1;
    while doors[i].selected or (doors[i].prize=car) do i:=random(3)+1;
    doors[i].open:=true;  {mark door as open}
    {get another closed door randomly }
    i:=random(3)+1;
    while doors[i].open do i:=random(3)+1;
    clicked:=doors[i];
    if clicked.selected then switched:=false {we picked the same one}
    else
    begin {we are switching}
      switched:=true;
      {in theory - unselect one and select the other, but not really necessary here
      doors[doorselected].selected:=false;
      clicked.selected:=true;
      }
    end;
    if clicked.prize=car then won:=true else won:=false;
    if switched then
    begin
      inc(switchgames);
      if won then inc(switchwins);
    end
    else
    begin
      inc(nonswitchgames);
      if won then inc(nonswitchwins);
    end;
    reset;
  end;
  updatestats;
  busy:=false;
  screen.cursor:=crdefault;
end;

{************TForm1.VoteGrpClick **************}
procedure TForm1.VoteGrpClick(Sender: TObject);
{user selected a best strategy - show explanation and make batch button visible}
begin
  with explaindlg do
  begin
    if VoteGrp.itemindex=1 then
    begin
       line1:='You''re correct!';
       caption:='YES!!';
    end
    else
    begin
      line1:='Sorry, that''s not right.';
      caption:='Darn...';
    end;
    showmodal;
  end;
  batchBtn.visible:=true;
end;

end.
