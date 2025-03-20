unit U_MIssionaries;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org

{
A River Crossing Puzzle

Three cannibals and three missionaries need to cross
from the left bank to the right bank of a river.  There is a
boat that will only carry a maximum of two persons at a
time.   The cannibals and the missionaries share a
comon goal of reaching the village, so any member of
the party will cooperate by piloting the boat as
necessary.

However,  if there is ever a situation where the cannibals
outnuimber the missionaries on either bank, their
natural tendencies will take over and the outnumbered
missionaries will be eaten!

Can you figure out how to get them all cross?  Click
"Who is in the boat? " box to make each move.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    MoveList: TListBox;
    MoveGrp: TRadioGroup;
    SolutionsGrp: TRadioGroup;
    StaticText1: TStaticText;
    CLearMovesBtn: TButton;
    UndoBtn: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MoveGrpClick(Sender: TObject);
    procedure SolutionsGrpClick(Sender: TObject);
    procedure CLearMovesBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);

  public
    { Public declarations }
    valids:array of tPoint;
    visited:array[0..3,0..3,false..true] of boolean;
    savedsolutions:array of TStringlist;

    function solvefrom(p:TPoint):boolean;
    function  validmove(ix,iy:Integer;movestr:string):boolean;
    procedure setlists;
  end;

var  Form1: TForm1;

implementation

{$R *.DFM}

{************ FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
var
  c,m:integer;
  validcount:integer;
begin
  {set up array of valid positions}
  setlength(valids,50);
  validCount:=0;
  for c:=0 to 3 do {for all #s of cannibals}
  for m:=0 to 3 do {and all #s of missionaries}
  if ((c<=m) and (3-c<=3-m)) {#of cannibals in each side must be <= # missionaries}
     or (m=0) or (m=3) {unless there are 0 missionaries}
  then
  begin
    valids[validcount].x:=c;
    valids[validcount].y:=m;
    inc(validcount);
  end;
  setlength(valids,validcount);
  setlists;
end;

{************** ValidMove ************}
function  TForm1.validmove(ix,iy:Integer; movestr:string):boolean;
  {validate manual move and make move if OK}
  var i:integer;
      boatleft:boolean;
      C,M:integer;
      BoatmsgL, BoatmsgR:string;
  begin
    {boat is on left bank for odd nuimbered moves}
    boatleft:=(movelist.items.count div 2) mod 2 =1;
    {Reconstruct where people are by extract quasi object (an integer actually)
     from latest move line}
    with movelist.items do
    if boatleft then
    begin
      C:=integer(objects[count-1]) div 10 - ix;
      M:=integer(objects[count-1]) mod 10 - iy;
    end
    else
    begin
      C:=integer(objects[count-1]) div 10 + ix;
      M:=integer(objects[count-1]) mod 10 + iy;
    end;

    result:=false;
    {valid range?}
    if (C<0) or (M<0) or (C>3) or (M>3)
    then
    begin
      showmessage('You can''t make that move - not enough of those types on boat side of the river');
      exit; {no - get out}
    end;

    {setup boat position messages}
    if boatleft then
    begin
      boatmsgL:='              ';
      boatmsgR:=', Boat      ';
    end
    else
    begin
      boatmsgR:='              ';
      boatmsgL:=', Boat     ';
    end;
    if boatleft then movestr:=movestr + '==>'
    else movestr:='<==' + movestr;
    {add move info to movelist}
    movelist.items.add('                         '+ movestr);
    {add line with status after the move}
    {Note "trick" of adding # of cannibals and missionaries on left bank as
     an object by casting integer 10Px+py as an object}
    movelist.items.addobject(inttostr(C)+'C, '+inttostr(M)+'M '+boatmsgL
                       +'                  '+inttostr(3-C)+'C, '
                       +inttostr(3-M)+'M '+boatmsgR, TObject(10*C+M) );
    {is it in the valid moves list?}
    for i:=0 to high(valids) do
    begin
      if (valids[i].x=C) and (valids[i].y=M) then
      begin
        result:=true;
        break;
      end;
    end;
    if result then
    begin  {we can make this move}
      {If nobody on left bank, we're done!}
      If 10*C+M=0 then showmessage('We have a winner!!!');
    end
    else
    begin
      showmessage('Yum, yum -- that missionary sure tasted good!  You lose!');
      setlists;
    end;
  end;

{************ SolveFrom ***********}
function TForm1.SolveFrom(p:TPoint):boolean;
{recursive routine to try all moves from state "p"}

  function  validautomove(px,py:Integer;movestr:string):boolean;
    var i:integer;
        boatleft:boolean;
        BoatmsgL, BoatmsgR:string;
    begin
      boatleft:=(movelist.items.count div 2) mod 2 =1;
      result:=false;
      {valid range?}
      if (px<0) or (py<0) or (px>3) or (py>3)
      then exit; {no - get out}
      {is it in the valid moves list?}
      for i:=0 to high(valids) do
      begin
        if (valids[i].x=px) and (valids[i].y=py) then
        begin
          result:=true;
          break;
        end;
      end;
      {if so, have we been here before?}
      if result and visited[px,py,not boatleft] then result:=false;
      if result then
      begin  {we can try this move}
        {setup boat position messages}
        if boatleft then
        begin
          boatmsgL:='              ';
          boatmsgR:=', Boat      ';
        end
        else
        begin
          boatmsgR:='              ';
          boatmsgL:=', Boat     ';
        end;
        {add move info to movelist}
        movelist.items.add('                         '+ movestr);
        movelist.items.addobject(inttostr(px)+'C, '+inttostr(py)+'M '+boatmsgL
                           +'                  '+inttostr(3-px)+'C, '
                           +inttostr(3-py)+'M '+boatmsgR, TObject(10*px+py) );
        {mark new state as visited - boat would be on the opposite bank}
        visited[px,pY,not boatleft]:=true;
        result:=solvefrom(point(px,py)); {recursive call to solve (depth first search)}
        if not result then
        begin   {backtracking -remove list entries and visited flag}
           movelist.items.delete(movelist.items.count-1);
           movelist.items.delete(movelist.items.count-1);
           visited[px,pY, not boatleft]:=false;
        end;
      end;
    end;


var
  n:integer;
  boatleft:boolean;
begin  {solvefrom}
  if (p.x=0) and (p.y=0)
  then {solved!}
  begin
    result:=false{true}; {true will stop after 1st solution is found}
    n:=length(savedsolutions);
    setlength(savedsolutions,n+1);
    savedsolutions[n]:=TStringlist.create;
    savedsolutions[n].assign(movelist.items);
  end
  else
  begin
    boatleft:=(movelist.items.count div 2) mod 2 =1;
    if boatleft then
    begin
      {move 1 missionary right?}
      result:=validautomove(p.x,p.y-1,'M==>');
      {move 2 missionaries right?}
      if not result then result:=validautomove(p.x,p.y-2,'MM==>');
      {move 1 cannibal  right?}
      if not result then result:=validautomove(p.x-1,p.y,'C==>');
      {move 2 cannibals right?}
      if not result then result:=validautomove(p.x-2,p.y,'CC==>');
      {move 1 of each  right?}
      if not result then result:=validautomove(p.x-1,p.y-1,'CM==>');
    end
    else
    begin
      {move 1 missionary left?}
      result:=validautomove(p.x,p.y+1,'<==M');
      {move 2 missionaries left?}
      if not result then result:=validautomove(p.x,p.y+2,'<==MM');
      {move 1 cannibal  left?}
      if not result then result:=validautomove(p.x+1,p.y,'<==C');
      {move 2 cannibals  left?}
      if not result then result:=validautomove(p.x+2,p.y,'<==CC');
      {move 1 of each  left?}
      if not result then result:=validautomove(p.x+1,p.y+1,'<==CM');
    end;
  end;
end;

{*********** SetLists ************}
procedure TForm1.setlists;
{Reset the lists}
var
  c,m,i:integer;
begin
  for c:=0 to 3 do
  for m:=0 to 3 do
  begin
    visited[c,m,false]:=false;
    visited[c,m,true]:=false;
  end;
  visited[3,3,true]:=true;
  MoveList.items.clear;
  Movelist.items.add(' Left Bank                            Right Bank');
  Movelist.items.addobject('3C, 3M, Boat  '
                  +  '                      0C, 0M',TObject(33));
  for i:=0 to high(savedsolutions) do savedsolutions[i].free;
  setlength(savedsolutions,0);
  solvebtn.visible:=true;
  Solutionsgrp.visible:=false;
end;

{********** SolveBtnClick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);
{search for solutions}
var i:integer;
begin
  SetLists;
  Solvefrom(point(3,3));
  if length(savedsolutions)>0 then
  with solutionsgrp do
  begin
    items.clear;
    for i:=1 to length(savedsolutions) do items.add('Solution '+inttostr(i));
    Solutionsgrp.visible:=true;
    solutionsgrp.itemindex:=0;
    solutionsgrpclick(sender);
  end;
  solvebtn.visible:=false;
end;


{****************** MoveGrpClick ***********}
procedure TForm1.MoveGrpClick(Sender: TObject);
{Make a move in resposne to user click}
begin
  if movegrp.itemindex=-1 then exit;
  case Movegrp.itemindex of
    0: validmove(1,0,'C');
    1: validmove(2,0,'CC');
    2: validmove(0,1,'M');
    3: validmove(0,2,'MM');
    4: validmove(1,1,'CM');
  end;
  movegrp.itemindex:=-1;
end;

{*************** SolutionsGrpClick **********}
procedure TForm1.SolutionsGrpClick(Sender: TObject);
{Display a solution}
begin
  Movelist.items.assign(savedsolutions[Solutionsgrp.itemindex]);
end;

{************* ClearMovesBtnClick ***********}
procedure TForm1.CLearMovesBtnClick(Sender: TObject);
begin  setlists; end;

{************ UndoBtnClick ***********}
procedure TForm1.UndoBtnClick(Sender: TObject);
{Take back the last move}
begin
  if movelist.items.count>2 then
  with movelist.items do
  begin
    delete(count-1);
    delete(count-1);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
