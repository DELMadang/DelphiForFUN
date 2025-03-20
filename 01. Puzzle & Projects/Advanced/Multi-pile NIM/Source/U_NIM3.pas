unit U_NIM3;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A multi-pile version of NIM -
   players may as many tokens as desired from single row in a turn}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ComCtrls;

type

  TRowRec= record
    nbrtokens:integer;
    rowindex:integer; {which row to display tokens}
    tokens:TList;
  end;


  TForm1 = class(TForm)
    HumanRGrp: TGroupBox;
    TakeBtn: TButton;
    Label2:    TLabel;
    NewGameBtn: TButton;
    TypeRGrp:  TRadioGroup;
    Panel1: TPanel;
    PlayerGrp: TRadioGroup;
    PlayList: TListBox;
    RestoreBtn: TButton;
    StatusBar1: TStatusBar;
    procedure TakeBtnClick(Sender: TObject);
    procedure NewGameBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1Resize(Sender: TObject);
    procedure RestoreBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PlayerGrpClick(Sender: TObject);
    procedure TypeRGrpClick(Sender: TObject);
  public
    NextPlayer:char;
    laststickloses:boolean;
    WinningSticks:integer;  {1 for normal game, last stick loses}
                            {0 for misere game, last stick wins}
    board:array of Trowrec;  {nbr of sticks in each row}
    tokensize:integer;
    usedrows:integer; {non-zero rows for new game}
    {max:integer;}
    clickedrow:integer;
    gameover:boolean;
    player1move:boolean;
    clickedcol:integer; {index of latest token clicked on this move,
                          used when ctrl-click is used to select multiple tokens}
    player1, player2:string;
    procedure computermove;
    procedure restoregame;
    procedure setplayer;
    procedure setplayernames;
  end;

var
  Form1: TForm1;
  maxrows:integer=5;
implementation

uses math, {max and min functions require math unit}
     U_Setup;


{$R *.DFM}

{****************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization stuff}
var i:integer;
begin
  with setupdlg.boardgrid do
  begin
    randomize;
    rowcount:=maxrows+1;
    cells[0,0]:='Pile Nbr';
    cells[1,0]:='# of tokens';
    for i:=1 to maxrows do
    begin
      cells[0,i]:=inttostr(i);
      cells[1,i]:=inttostr(random(10));
    end;
  end;
  setlength(board,maxrows+1);
  for i:= 0 to maxrows-1 do   {create the lists to hold the tokens}
  with board[i] do tokens:=TList.create;
  typergrpclick(sender); {initialize playmode}
  restoregame;
end;


{********************* RestoreGame ***************}
procedure TForm1.Restoregame;
{Initialize game based on setupdlg.boardgrid values}
var
  i,j:integer;
  h,w:integer;
  max:integer;
begin
  usedrows:=0;
  max:=0;
  {free up any remaining old tokens}
  for i:=0 to maxrows-1 do
  with board[i] do
  begin
    for j:= 0 to tokens.count-1 do if tokens[j]<>nil then TShape(tokens[j]).free;
    tokens.clear;
  end;

  with setupdlg.boardgrid do
  begin
    for i:=0 to maxrows-1 do
    with board[i] do
    begin
      nbrtokens:=strtointdef(cells[1,i+1],8);
      if nbrtokens>max then max:=nbrtokens;
      rowindex:=usedrows;
      if nbrtokens>0 then usedrows:=i;
      for j:=0 to nbrtokens-1 do  {create tokens as TShape component}
      begin
        tokens.add(TShape.create(panel1));
        with Tshape(tokens[tokens.count-1]) do
        begin
          parent:=panel1;
          shape:=stCircle;
          brush.color:=clblue;
          onmousedown:= Shape1MouseDown ;
        end;
      end;
    end;
  end;
  h:=9*panel1.height div (10*(usedrows+1));
  w:=9*panel1.width div (10*max);
  if h>w then tokensize:=w else tokensize:=h;

  {set token sixe and location info}
  for i:=0 to maxrows-1 do
  with board[i] do
  for j:= 0 to tokens.count-1 do
  with TShape(Tokens[j]) do
  begin
    left:=tokensize div 2 + j*tokensize {+ 2};
    top:= tokensize div 2 + i*tokensize {+ 2};
    width:= tokensize-4;  {make actual height a width a few pixels smaller}
    height:=tokensize-4;
  end;
  clickedrow:=0;
  gameover:=false;
  playlist.clear;
  setplayernames;
  panel1.caption:='';
  if (Playergrp.itemindex>0) and (not gameover)
  then if ((playergrp.itemindex=1) and player1move)
          or ((playergrp.itemindex=2) and (not player1move))
          then computermove;
end;


{************** TakeBtnClick ****************}
procedure TForm1.TakeBtnClick(Sender: TObject);
{User says to take some sticks}
var
  i,j:integer;
  player, tokenstr:string;
  take,row:integer;
begin
  take:=0;
  row:=-1;
  for i:=0 to maxrows-1 do
  with board[i] do
  begin
    j:=0;
    while j<tokens.count do
    if tokens[j]<>nil then
    with tshape(tokens[j]) do
    begin
      if brush.color=clsilver then
      begin
        tshape(tokens[j]).free;
        tokens.delete(j);
        row:=i;
        inc(take);
      end
      else inc(j);
    end;
    if row>=0 then break;
  end;
  if player1move then player:=player1 else player:=player2;
  if take=1 then tokenstr:=' token ' else tokenstr:=' tokens ';
  playlist.items.add(player+' takes '+inttostr(take)
             +tokenstr +'from row ' + inttostr(row+1));
  playlist.itemindex:=playlist.items.count-1;

  clickedrow:=0;

  {count tokens remaining to see if we're done}
  j:=0;
  for i:=0 to maxrows-1 do
  with board[i] do inc(j,tokens.count);
  if j=0 then
  begin
    if laststickloses then setplayer;
    if player1move then player:=player1 else player:=player2;
    Panel1.caption:=player + ' wins!';
    gameover:=true;
  end
  else
  begin
    setplayer;
    if (Playergrp.itemindex>0) and (not gameover) then computermove;
  end;
end;

{*************** Setplayer *********}
procedure Tform1.setplayer;
begin
  player1move:=not player1move;
  if player1move then humanrgrp.caption:='Your turn '+player1
  else humanrgrp.caption:='Your turn '+player2;
  application.processmessages;
end;

{************ NewGameBtnClick ***********}
procedure TForm1.NewGameBtnClick(Sender: TObject);
begin
  if setupdlg.showmodal=mrOK then restoregame;
end;

{************* Shape1MouseDown *****************}
procedure TForm1.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{On mouse down exit used by each token to select or deselect it for deletion}
var
  row:integer;
  i:integer;
  prevcol:integer;
  start,stop:integer;
begin
   row:= (tshape(sender).top+y-tokensize div 2) div tokensize;
   prevcol:=clickedcol;
   if not (ssshift in shift) then clickedcol:=board[row].tokens.indexof(sender);

   {if user clicked new row - reset previous row tokens}
   if (row<>clickedrow) and (clickedrow<>0) then
   with board[clickedrow] do
   for i:=0 to tokens.count-1 do
   if tokens[i]<>nil then tshape(tokens[i]).brush.color:=clblue;

   {handlle shift-click - multiple select/deselect}
   if (ssshift in shift) and (prevcol>=0) and (clickedcol>=0) then
   begin
     i:=board[row].tokens.indexof(sender);
     start:=min(prevcol,i);
     stop:=max(prevcol,i);
     for i:=start+1 to stop-1 do {end tokens have been or will be switched}
     with tshape(board[row].tokens[i]) do
        if brush.color<>clSilver then brush.color:=clsilver
        else brush.color:=clblue;
   end;

   {select or deselect clicked token}
   with tshape(sender) do
        if brush.color<>clSilver then brush.color:=clsilver
        else brush.color:=clblue;

   clickedrow:=row; {save clicked row}
end;

const maxbits=5; {max tokens in a row  = 2^maxbits -1}

{****************** ComputerMove ***************}
procedure tform1.computermove;
{The fun part of this program - use algorithm described by Martin Gardner
 to make "unsafe" positions "safe".}
var
  i,j:integer;
  row:integer;
  take:integer;
  n:integer;
  max:integer;
  singlecount:integer; {number of rows with a single token}
  multcount:integer;   {number of rows with more than one token}
  tokenstr:string;

begin {computermove}


  row:=-1;

  {code for  misere version}
  if laststickloses then
  begin
    {if only one row with token count >1 then
     reduce that row to 1 if number of rows with 1 token is odd
     or reduce to 0 of number of rows with 1 token is even,
     either way the idea is to leave an odd number of
     rows with a single token for your opponent.
     Since it is his turn and and last token loses, we are guaranteed to win!
     If we are not in that condition yet, leave row at -1 and next section
     wil calculate the move
    }
    singlecount:=0;
    multcount:=0;
    for i:=0 to maxrows-1 do
    with board[i] do
    if tokens.count=1 then inc(singlecount)
    else if tokens.count>1 then
    begin
      inc(multcount);
      row:=i;
    end;
    if multcount=1 then
    begin
      if singlecount mod 2 =1 then take:=board[row].tokens.count
      else take:=board[row].tokens.count-1;
    end
    else row:=-1;
  end;

  if row<0 then {either last token wins or last token loses but condition of
                 previous "close to end" test not met}
  begin
    {Original algorithm using Martin Gardner's description from "Hexaflexagons..."
     book removed}
    {revised code - thanks to Arne Vedo for this simpler, but equivalent,
      algorithm using XOR,  50 lines of code reduced to 15!}
    n:=board[0].tokens.count; {get "XOR product" of all counts}
    for i:=1 to maxrows-1 do n:=n xor board[i].tokens.count;

    if n>0 then
    begin {unsafe - make it safe}
      for i:=0 to maxrows-1 do
      begin
        {find the row with count matching leftmost bit of N}
        j:=n xor board[i].tokens.count;
        if j < board[i].tokens.count then
        begin
          row:=i;
          take:=board[i].tokens.count - j;
          break;
        end;
      end;
    end

    {back to original code}
    else {position is safe - best we can do is remove one token from longest row}
    begin
      max:=0;
      row:=-1;
      for i:=0 to maxrows-1 do
      begin
        if board[i].tokens.count>max then
        begin
          row:=i;
          max:=board[i].tokens.count;
        end;
      end;
      take:=1;
    end;
  end;

  if take=1 then tokenstr:=' token ' else tokenstr:=' tokens ';
  playlist.items.add('Computer takes '+inttostr(take)
             +tokenstr+'from row ' + inttostr(row+1));
  playlist.itemindex:=playlist.items.count-1;
  for i := 1 to take do
  with board[row] do
  begin
    n:=tokens.count-1;
    with tshape(tokens[n]) do  brush.color:=clsilver;
    application.processmessages;
    sleep(500);
    tshape(tokens[n]).free;
    tokens.delete(n);
    application.processmessages;
  end;
  n:=0;
  for i:=0 to maxrows-1 do
  with board[i] do n:=n+tokens.count;
  if n=0 then
  begin
    if laststickloses then panel1.caption:='Human wins!' else
    panel1.caption:='Computer wins again!';
    gameover:=true;
  end;
  setplayer;
end;


{***************** Panel1Resize ***************}
procedure TForm1.Panel1Resize(Sender: TObject);
begin
  {make sure board is initialized before trying to restore the game,
   an initial call to resize is made before this is true}
  if length(board)>0 then restoregame;
end;

{******************** ResttoreBtnClick **********}
procedure TForm1.RestoreBtnClick(Sender: TObject);
begin  restoregame;  end;

{************ Generate a test board - OK to delete this  *********}
procedure TForm1.Button1Click(Sender: TObject);
begin
  with setupdlg.boardgrid do
  begin
    cells[1,1]:='8';
    cells[1,2]:='13';
    cells[1,3]:='24';
    cells[1,4]:='30';
    cells[1,5]:='0';
  end;
  restoregame;
end;

{*************** SetPlayerNames ************}
procedure TForm1.setplayernames;
begin
  case playergrp.itemindex of
    0: begin {H vs H}
         player1:='Human #1';
         player2:='Human #2';
       end;
    1: begin {C vs H}
          player1:='Computer';
          player2:='Human';
        end;
    2: begin {H vs c}
         player1:='Human';
         player2:='Computer';
       end;
  end; {case}
  player1move:=false;
  setplayer;
end;

{**************** PlayerGrpClick **********}
procedure TForm1.PlayerGrpClick(Sender: TObject);
{player structure changed, restore the board}
begin  restoregame;  end;

{************** TypeRgrpClick ************}
procedure TForm1.TypeRGrpClick(Sender: TObject);
{Normal or misere (last token loses) mode changed - restore the game}
begin
  if typergrp.itemindex=1 then laststickloses:=true
  else laststickloses:=false;
  restoregame;
end;

end.

