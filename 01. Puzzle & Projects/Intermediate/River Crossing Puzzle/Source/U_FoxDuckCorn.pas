unit U_FoxDuckCorn;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Fox, duck and bag of corn must cross the river meeting certain conditions.
  This graphic version allows user play as well as computer solution.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type

  Tmode=(autosolve, playing, stopping, gameover);

  TForm1 = class(TForm)
    SolveBtn: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Image1: TImage;
    Image2: TImage;
    RightFox: TImage;
    LeftDuck: TImage;
    LeftCorn: TImage;
    LeftFox: TImage;
    RightDuck: TImage;
    RightCorn: TImage;
    LeftBoat: TImage;
    RightBoat: TImage;
    TextInfo: TStaticText;
    ResetBtn: TButton;
    AboutBtn: TButton;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LeftsideClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Rightsideclick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    {Moves array - first index is "from" state, 2nd index is "to" state}
    moves:array[0..15] of array[0..15] of boolean;
    visited:array[0..15] of boolean;
    losers:array[0..15] of boolean;
    state:byte;
    mode:TMode; {current playmode}

    procedure reset;
    function makemove(from:integer; var path:TStringlist):boolean;
    procedure checkloser;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses U_About;

procedure TForm1.FormActivate(Sender: TObject);
begin
  panel1.color:=rgb(51,153,0);  {adjust background green of panel to match images}
  mode:=gameover;
  reset;
end;

{******************** Reset **********************}
procedure tform1.reset;
{reinitialize  the game states}

var
  i,j,k:integer;
  test,mask:byte;
begin

  for i:= 0 to 15 do
  begin
    visited[i]:=false;
    losers[i]:=false;
    for j:= 0 to 15 do moves[i,j]:=false;
  end;
  {mark valid moves}
  for i:=0 to 15 do
  begin
    {the boat can always move so
     flip high order bit (the boat)  by itself  }
    if i>=8 then
    begin
      test:=i-8;  {retain the fox, duck corn bits}
      moves[i,i-8]:=true;
    end
    else
    begin
      {set compliment (invert the bits) for testing}
      test:=7-i;  {for boat on left bank  test bit compliments }
      moves[i,i+8]:=true; {allow boat only move (turn left bank high bit on)}
    end;
    {now check the other 3 bits (any one can be flipped) }
    mask:=$01;
    for k:= 0 to 2 do
    begin
      if (test and mask)>0 {bit is on}
      then
      begin
        j:=test-mask; {turn it off in J}
        If i>=8 then moves[i,j]:=true
        else moves[i,15-j]:=true; {left bank, re-compliment}
      end;
      mask:=mask shl 1; {shift the bit left one position}
    end;
  end;
  {now let's disallow valid but losing states}
  {8=boat, 4=fox, 2=duck, 1=corn}
  {losers are binary 011x (fox & duck on right bank without the boat, 6&7)
                     0x11 (duck and corn on right bank without the boat, 3&7),
                     100x,(fox & duck on left bank without the boat, 8&9),
                     1x00 (duck and corn on left bank without the boat, 8&12),
                     00x1 {corn on the right bank  withpout the fox or boat
                          (wild birds come and eat the corn, 1&3)
                     }
  {mark losers as invalid}
  losers[1]:=true;
  losers[3]:=true;
  losers[6]:=true;
  losers[7]:=true;
  losers[8]:=true;
  losers[9]:=true;
  losers[12]:=true;

  {make left side images visible and right side invisible}
  with panel1 do for i:=0 to controlcount-1 do
  if panel1.controls[i] is TImage then
  with controls[i] as Timage do
  begin
    if uppercase(copy(name,1,4))='LEFT' then visible:=true
    else if uppercase(copy(name,1,4))='RIGH' then visible:=false;
  end;
  mode:=playing;
  textinfo.caption:='Click an object to move it across the river';
  state:=0; {initial play state}
end;

{********************** MakeMove ***********************}
function TForm1.makemove(from:integer; var path:TStringlist):boolean;
{Used in autosolve mode}
{recursive search for next unvisited state from "from"}
{add found states to "path" stringlist}
{return true when state 15 is reached (everbody on the right bank)}

var
  j:integer;
begin
  j:=-1;
  result:=false;
  while (j<15) and (not result) do
  begin
    inc(j);
    if (not visited[j]) and not(losers[j])
       and  (moves[from,j]) then
    begin
      visited[j]:=true;
      path.add(format('%2d',[j]));
      if j=15 then result:=true
      else
      begin
        result:=makemove(j,path);
        if not result then
        begin
          visited[j]:=false;
          path.delete(path.count-1);  {backtrack}
        end;
      end;
    end;
  end;
end;

{*************** SolvebtnClick ******************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Solve the puzzle}
var
 path:tstringlist;
 i,j:integer;
 direction:string;
 prevn,n:byte;
begin
  reset;
  mode:=autosolve;

  {depth first search}
  path:=TStringlist.create;
  path.add('00');
  {make recursive call to make moves from state 0 to solve the puzzle}
  if makemove(0,path) then {solution found}
  with textinfo do
  begin
    prevn:=0;
    for i:= 1 to path.count-1 do
    if mode=autosolve then
    begin
      n:=strtoint(path[i]);
      if prevn>n then direction :='left' else direction:='right';
      leftboat.visible:=not leftboat.visible;  {boat always moves}
      rightboat.visible:=not rightboat.visible;
      if abs(n-prevn)=8 then
      begin
        caption:='Move boat to '+direction+' bank';
      end
      else if abs(n-prevn)=12 then
      begin
        caption:='Move fox to '+direction+' bank';
        leftfox.visible:=not leftfox.visible;
        rightfox.visible:=not rightfox.visible;
      end
      else if abs(n-prevn)=10 then
      begin
        caption:='Move duck to '+direction+' bank';
        leftduck.visible:=not leftduck.visible;
        rightduck.visible:=not rightduck.visible;
      end
      else if abs(n-prevn)=9 then
      begin
        caption:='Move corn to '+direction+' bank';
        leftcorn.visible:=not leftcorn.visible;
        rightcorn.visible:=not rightcorn.visible;
      end;
      prevn:=n;
      for j:= 1 to 250 do {honor reset btn clicks while showing move}
      begin
        application.processmessages;
        if mode<>autosolve then break;
        sleep(10);
      end;
      application.processmessages;
    end;

    caption:='That''s it!'
  end
  else caption:='No solution found';
  mode:=playing;
end;

{*********************** CheckLoser *****************}
procedure TForm1.checkloser;
{actually checks for losing and winning moves}
begin
  textinfo.caption:='';
  case state of
      1: Textinfo.caption:='You left the corn unguarded on the right bank and the crows ate it';
      3,12: Textinfo.caption:='Oh, oh - you left the duck alone with the corn and he ate it all!';
      6,7,8,9: Textinfo.caption:='Poor Daffy!  You left him unguarded for the fox to eat.';
   end;
   with textinfo do
   if caption<>'' then
   begin
     mode:=gameover;
     caption:=caption+'  You lose!';
   end
   else
   case state of
     15:
       begin
        caption:='All acrossed safely.  Congratulations!';
        mode:=gameover;
       end;
     11,13: caption:='That corn on the right bank has attracted the crow''s interest';
     5: caption:='The crows are still interested but too nervous with that fox around';

   end;
 end;


procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  reset;
end;

{**************** Leftsideclick ************}
procedure TForm1.LeftSideClick(Sender: TObject);
{handles clicks on left side images}
begin
  if not (mode in [playing,gameover])
  then reset;
  if mode<>playing then exit;
  if sender is timage then
  with sender as timage do
  {is boat on the left side also?}
  if state<=8 then
  begin
    state:=state+8;
    leftboat.visible:=false;
    rightboat.visible:=not leftboat.visible;
    visible:=false;
    if sender = leftfox then
    begin
      rightfox.visible:=true;
      state:=state or $04;
    end
    else if sender = leftduck then
    begin
      rightduck.visible:=true;
      state:=state or $02;
    end
    else if sender = leftcorn then
    begin
      rightcorn.visible:=true;
      state:=state or $01;
    end;
    checkloser;
  end;
end;

procedure TForm1.RightSideClick(Sender: TObject);
{handles clicks on right side images}
begin
  if not (mode in [playing, gameover])
  then reset;
  if mode<>playing then exit;
  if sender is timage then
  with sender as timage do
  {is boat on right side also?}
  if state>8 then
  begin
    state:=state-8;  {turn off 8 bit}
    leftboat.visible:=true;
    rightboat.visible:=not leftboat.visible;
    visible:=false;
    if sender = rightfox then
    begin
      leftfox.visible:=true;
      state:=state -4 {and $0C}; {turn off 4 bit}
    end
    else if sender = rightduck then
    begin
      leftduck.visible:=true;
      state:=state -2 {and $0D}; {turn off 2 bit}
    end
    else if sender = rightcorn then
    begin
      leftcorn.visible:=true;
      state:=state -1 {and $0E}; {turn off 1 bit}
    end;
    checkloser;
  end;
end;

procedure TForm1.AboutBtnClick(Sender: TObject);
begin
  AboutBox.showmodal
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  reset;
  canclose:=true;
end;

end.
