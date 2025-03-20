unit U_TicTacToeMachine2;
  {Copyright  © 2002-2017, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
An artificial intelligence demonstration of a "machine" that learns to
play tic-tac-toe by trial and error.    This is a computer model of the
original machine, MENACE, invented by Donald Michie in 1961 using 300
matchboxes representing 300 board positions.  Each box contains colored
beads for each available cell.

The machine always plays first.  It plays by selecting a bead randomly from the
box representing the current board configurations. When it wins or draws it is
rewarded" by adding beads of the winning move colors to each box used.  Losses
are punished by confiscating the selected beads.

You may click avalaible cells to play against the machine or use the "Random"
button to train the machine.  It may take a few thousand random games to train
it well.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls, ShellAPI, Grids,DFFUtils;

type
  TweightArray=array[1..9] of integer;
  PWeightrec=^TWeightrec;
  TWeightrec=record  {a record saved with each board position containing more
                      info about the position}
    w,ww:TWeightArray;{array of weights (# of beads of each color) for possible moves}
    movelevel:integer; {which level are we at}
    transformNbr:integer; {rotation required to get to standard pattern}
    lastchoice:byte;   {the cell filled to get to this position}
  end;


  TForm1 = class(TForm)
    ResetBtn: TButton;
    Label1: TLabel;
    StartBtn: TButton;
    ResetWeightsBtn: TButton;
    Label3: TLabel;
    DebugPanel: TPanel;
    IntroBtn: TButton;
    Intro : TMemo;
    StaticText1: TStaticText;
    AdvancedBtn: TButton;
    Memo3: TMemo;
    Memo2: TMemo;
    StringGrid1: TStringGrid;
    Memo1: TMemo;
    Panel1: TPanel;
    AutoGrp: TRadioGroup;
    Label2: TLabel;
    AutoPlayBtn: TButton;
    Memo5: TMemo;
    Label6: TLabel;
    Verbose: TCheckBox;
    ResultLbl: TLabel;
    GameCount: TSpinEdit;
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure AutoPlayBtnClick(Sender: TObject);
    procedure ResetWeightsBtnClick(Sender: TObject);
    procedure IntroBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure AdvancedBtnClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure Memo3Click(Sender: TObject);
  public
    board:array[0..8] of TEdit; {array of TEdits visualizing the board}
    level:integer;    {current level}
    winlevel:integer;
    xwins, PrevXWins, Owins, PrevOWins, stopcount, totgames, PrevTotgames: integer;  {statistics}
    strkey:string[9]; {9 character string representation of board}
    playkey:string[9];
    Positions:TStringList; {list of 304 "matchbloxes" representing possible positions}
    listposition:integer;
    gameover:boolean;
    autoplay:boolean;
    playing:boolean; {true while playing back a generated game}
    moves:array[1..4] of integer; {positions list index values for current game}
    nbrmoves:integer; {how many moves in current game (X moves only)}
    procedure GenNext(key:string;templevel:integer); {Initialize positions list}
    function FindTransform(key:String;  {look for key in the list, allowing
                                         rotations and reflections}
                          var TformNbr, listposition:integer):boolean;
    function transform(s:string;t:integer):string; {var newweights:TWeightArray):string;} {get a new key after
                                                    transform "t"}
    function inversetransform(s:string;t:integer; {var newweights:TWeightArray ; }
                              var lastchoice:byte ):string; {reverse a transform}
    procedure makemove; {machine move maker}
    function winner(p:char):boolean; {check for 3 in a row for player "p"}
    procedure wrapup(p:char); {end of game total and adjust weights}
    procedure initweights; {initialize weights}
    procedure UpdateDisplayWeights;

    Procedure SetupFromBeadsdlg;
    Procedure StartnewGame(auto:boolean);
    Procedure ShowData;
    procedure showstats;
    function checkdup:boolean;
    function checkdups:boolean;
  end;

var Form1: TForm1;

implementation

{$R *.DFM}
Uses UBeadsDlg;
var

  {Boards are "rotated" or "flipped" to the same isomorphic configuration
   before play and transformed back for display.  Reduces the number of
   configuurations to check}
  transforms: array[0..7] of array[1..9] of integer =  {the 8 transforms}
     {identity}   ((1,2,3,4,5,6,7,8,9),   {"moveto" index values}
     {right90}     (7,4,1,8,5,2,9,6,3),
     {left90}      (3,6,9,2,5,8,1,4,7),
     {180}         (9,8,7,6,5,4,3,2,1),
     {Mirror}      (3,2,1,6,5,4,9,8,7),
     {Mirror+Left} (9,6,3,8,5,2,7,4,1),
     {Mirror+Right}(1,4,7,2,5,8,3,6,9),
     {mirror+180}  (7,8,9,4,5,6,1,2,3)
     );
   TransformNames:array[0..7] of string= 
   ('Identity', 'Rotate Right 90', 'Rotate Left 90', 'Rotate 180',
    'Mirror', 'Mirror + Left 90','Mirror + Right 90', 'Mirror + 180');
   spacer:char='~';  {indicator for blank space on the board}
    {initial bead counts of each availablr cell color for machines 1st 4 moves}
   initialweights:array[0..3] of integer{=(4,3,2,1)};
   winreward:integer;
   winbonusreward:integer;
   lossreward:integer;
   lossbonusreward:integer;
   tiereward:integer;



{************ CheckDups **********}
function Tform1.checkdups: boolean;
{Check for invalid move & give message}
{Should not occur - used for debugging}
begin
  result:=checkdup;
  if not result
  then showmessage('Dupe in playkey: '+playkey);
end;

{************** CheckDup ************}
function TForm1.checkdup:boolean;
{Check for invaid move attempt}
var
  i,j:integer;
begin
  result:=true;
  for i:=1 to length(playkey)-1 do
  for j:=i+1 to length(playkey) do
  if (playkey[i]<>spacer) and (playkey[j]=playkey[i])
  then result:=false;
end;

{**************** FormActivate **************}
procedure TForm1.FormActivate(Sender:TObject);
var
  i:integer;
  //c,r:integer;
  fname:string;
  c1,c3,c5,c7:integer;
begin
  randomize;
  //randseed:=2000; {make runs repeatable for debugging- any seed will do}
  level:=1;
  adjustgridsize(Stringgrid1);
  reformatmemo(Intro);
  Intro.bringtofront;
  intro.visible:=false;
  introbtnclick(sender);
  (*
  with stringgrid1 do
  for c:=0 to 2 do
  for r:=0to 2 do
  begin
    cells[c,r]:=' ';
  end;
  *)
  {generate all matchboxes for 1st mover, "X"}
  Positions:=TStringList.create;
  positions.sorted:=true;
  strkey:=stringofchar(Spacer,9);
  positions.duplicates:=dupignore;
  fname:=  extractfilepath(application.exename)+'Positions.str';
  {load positions if file exists}
  if fileexists(fname) then positions.loadfromfile(fname)
  else
  begin
    Gennext(strkey,0);  {recursive procedure that builds the list
                         of "matchboxes" (positions)}
    positions.savetofile(fname);
  end;
  positions.savetofile( extractfilepath(application.exename)+'Positionssorted.str');
  setupfrombeadsdlg;
  Initweights;
  {Add the "beads" to the "matchboxes"}
  {accumulate # of moves for each level for diplay}
  c1:=0; c3:=0; c5:=0; c7:=0;
  for i:=0 to positions.count-1 do
  begin
    with pweightrec(positions.objects[i])^ do
    case movelevel of
    1: inc(c1);
    3: inc(c3);
    5: inc(c5);
    7: inc(c7);
    end;
  end;
  with memo2.lines do
  begin
    add('The machine always makes odd numbered moves.');
    add('There is  '+ inttostr(c1) + ' move 1 pattrn');
    add('There are '+ inttostr(c3) + ' move 3 patterns');
    add('There are '+ inttostr(c5) + ' move 5 patterns');
    add('There are '+ inttostr(c7) + ' move 7 patterns');
  end;
end;

{*********** Initweights *************}
procedure TForm1.initweights;
  var
    i,j,v,n:integer;
    initialcount:integer;
    s, wstr,wwstr:string;
    P:Pweightrec;
  begin

    //if not autoplay then
    begin
      memo1.clear;
      memo1.lines.beginupdate;
    end;

    for i:= 0 to positions.count-1 do
    with positions do
    begin
      s:=strings[i];
      n:=0;
      {count the "O"s to determine level}
      for j:= 1 to 9 do  if s[j]='O' then inc(n);
      initialcount:=initialweights[n];
      if not assigned(objects[i]) then
      begin
        new(P); {make a new weightrec}
        objects[i]:=TObject(p);
      end;
      wstr:='';
      wwstr:='';
      with Pweightrec(objects[i])^ do
      begin
        for j:=1 to 9 do {Assign the initial bead count to each empty slot}
        begin
          if not (s[j] in ['O','X']) then  s[j]:=spacer;

          if s[j]=spacer then  v:=initialcount else v:=0;
          w[j]:=v;
          ww[j]:=v;
          wstr:=wstr+inttostr(v)+',';
        end;
        system.delete(wstr,length(wstr),1);
        wwstr:=wstr;
        lastchoice:=0; {initialize lastchoice variable}
        movelevel:=2*n+1;
      end;
      {if not autoplay then} memo1.lines.add(
         format('#%3d: %s (%s) (%s)',[i,strings[i],wstr, wwstr]));

    end;
    memo1.lines.endupdate;
    scrolltotop(memo1);
  end;{initweights}

{**************** Transform ****************}
function TForm1.transform(s:string;t:integer {var newweights:TWeightArray}):string;
{given a key and a transform, return the new key, rotated and/or mirrored}
var i:integer;
begin
  result:=s;
  for i:=1 to 9 do
  begin
    result[i]:=s[transforms[t,i]];
  end;
end;

{**************** InverseTransform ****************}
function TForm1.InverseTransform(s:string;t:integer; {var newweights:TWeightArray;} var lastchoice:byte): string;
{Reverse the previous transform t, return the new key}
var i:integer;
    lastchoiceIn:byte;
begin
  case t of
      1: {right90} t:=2; {left 90}
      2: {left90}  t:=1; {right 90}
   end; {all the other transformations are reflexive, i.e. T(T(s))=s}
  lastchoiceIn:=lastchoice;
  result:=s;
  for i:=1 to 9 do
  begin
    result[i]:=s[transforms[t,i]];
    //newweights[i]:=newweights[transforms[t,i]];
    if transforms[t,i]=lastchoiceIn
    then lastchoice:=i;
  end;
end;

{************** Winner *************}
function TForm1.winner(p:char):boolean;
{Check for three in a row}
var s:string;
begin
  s:=strkey;
  if (  (s[1]=p) and (s[2]=p) and (s[3]=p) )
    or ((s[4]=p) and (s[5]=p) and (s[6]=p) )
    or ((s[7]=p) and (s[8]=p) and (s[9]=p) )
    or ((s[1]=p) and (s[4]=p) and (s[7]=p) )
    or ((s[2]=p) and (s[5]=p) and (s[8]=p) )
    or ((s[3]=p) and (s[6]=p) and (s[9]=p) )
    or ((s[1]=p) and (s[5]=p) and (s[9]=p) )
    or ((s[3]=p) and (s[5]=p) and (s[7]=p) )
    then result:=true  else result:=false;
end;

{************* UpdateDisplayWeights ******}
Procedure TForm1.UpdateDisplayWeights;
  Var
    i,n,index:integer;
    wstr,wwstr,s:string;
  begin
    memo1.lines.beginupdate;
    for n:=1 to nbrmoves do
    begin
      index:=moves[n];
      with positions, pweightrec(positions.objects[index])^ do
      begin
        wstr:='';
        wwstr:='';
        for i:=1 to 9 do
        begin
          wstr:=wstr+inttostr(w[i])+',';
          wwstr:=wwstr+inttostr(ww[i])+',';
        end;
        system.delete(wstr,length(wstr),1);
        system.delete(wwstr,length(wwstr),1);
        s:=format('#%3d: %s (%s) (%s)',[index+1, strings[index],wstr,wwstr]);
        with memo1 do lines[index]:=s;
      end;
    end;
    memo1.lines.endupdate;
  end;

{**************** Wrapup *************}
procedure Tform1.wrapup(p:char);
{game over - adjust weight and reset board image for next game}
var
  i,n,reward, rewardlast, tnbr:integer;
  msg:string;
  wstr,wwstr:string;
begin
  case p of
    'X':
    begin
      msg:='X wins!';
      inc(xwins);
      reward:=winreward{+3};
      rewardlast:=winreward+winbonusreward;  {big reward at the last level for winning}
    end;
    'O':
    begin
      msg:='O wins';
      inc(OWins);
      reward:=lossreward{-1};
      rewardlast:=lossreward+lossbonusreward{-1000}; {big punishment for the losing move}
    end;
    else
    begin
     msg:='A draw!';
     reward:=tiereward{+1};
     rewardlast:=0;
    end;
  end;
  If not autoplay then ResultLbl.caption:= Msg; // {Old way- stops} showmessage(Msg);
  inc(totgames);

  for i:=1 to nbrmoves do {adjust weights}
  with PWeightrec(positions.objects[moves[i]])^ do
  begin
    if i<nbrmoves then ww[lastchoice]:=ww[lastchoice]+reward
    else ww[lastchoice]:=ww[lastchoice]+rewardlast;
    if ww[lastchoice]<0 then ww[lastchoice]:=0;  {don't let weights go negative}
    lastchoice:=0;
    tnbr:=transformnbr;
  end;

  if not autoplay then
  begin
    showstats;
    updatedisplayWeights;
  end;

  begin
    If stopcount-totgames<=100 then  {list the last 100 games of the run}
    with memo3,lines do
    begin
      add('');
      add(format('Game %d: Grid by row: %s, %s ',[totgames,strkey, msg]));
      add(format('Move sequence by target position : %s',[playkey]));
      add(format('Transform: %s: Target pattern #: %d',[transformnames[tnbr],moves[nbrmoves]]));
    end;
  end;
  gameover:=true;
end;


{************* Makemove ************}
 procedure TForm1.makemove;
 {Computer makes a move}
 var i,j,n,sum,psum,tnbr:integer;
     c,r:integer;
     listpsition,nextchoice:integer;
     newkey, wstr,wwstr, inversekey:string;
     prob:single;
     tempweights:TWeightArray;
     done:boolean;
 begin
   {
    1. Find the current board position in the list, (transform if necessary),
    2. Select a random move based on weight values for next moves that
       are contained with each list entry.
    3. set lastchoice in the list entry with the selected to indicate which weight to update and make the move
    4. If the game is over, call wrapup to update the "lastchoice" weight values for each move we made,
         (equivalent to adding or subtracting beads for each selected bead color)
    }
   application.processmessages;
   if level=9 then {fill in the last position}
   begin
     done:=false;
     for c:=0 to 2 do
     begin
       for r:=0 to 2 do
       begin
         i:=3*r+c+1;
         if strkey[i]=Spacer then
         begin
           strkey[i]:='X';
           playkey[level]:=inttostr(i)[1];  checkdups;
           if not autoplay then stringgrid1.cells[c,r]:='X';
           done:=true;
           break;
         end;
       end;
       if done then break;
     end;
   end
   else
   begin  {Look for board configuration in the positions list}
     application.processmessages;
                                                                //
     If not FINDTRANSFORM(strkey, tnbr, listposition) then
     begin
       showmessage('System error - position '+strkey +' not found in table');
       exit;
     end
     else
     with Pweightrec(positions.objects[listposition])^ do
     begin
       {Transform pattern back to one of the standard 300
        Equivalent to rotating and fliping the board)}
       newkey:=transform(strkey,tnbr );
       transformNbr:=Tnbr;

       if verbose.checked and (stopcount-totgames<=10) then
       with memo3.lines do
       begin
         add('');
         add(format('DBGGame %d: Grid by row: %s',[totgames+1,strkey]));
         add(format('DBGMove %d sequence by target position : %s',[level, playkey]));
         add(format('DBGTransform: %s:',[transformnames[tnbr]]));
         add(format('DBGTarget pattern #: %d %s',[listposition,newkey]));
       end;


       sum:=0;
       repeat
         for i:=1 to 9 do
         begin
           if newkey[i] =spacer then inc(sum,ww[i]);
           wstr:=wstr+inttostr(w[i]);
           wwstr:=wwstr+inttostr(ww[i]);
         end;
         {beads all removed (too many losses), reset to initial bead counts}
         if sum=0 then for j:=1 to 9 do ww[j]:= w[j];
       until sum>0;

       if sum>0 then
       begin
         n:=random(trunc(sum))+1;  { get a random value  from 1 up to the sum of beads}
         nextChoice:=0;
         psum:=0;
         while  psum<n do {and count beads up until we equal or exceed the value}
         begin
           inc(nextchoice);
           if nextchoice>9 then showmessage('Weights error');
           if newkey[nextchoice]=spacer then inc(psum,ww[nextchoice]);
         end;
         //if sum>0 then prob:=(psum+0.0)/(sum+0.0); {probability for display}
       end;
       if sum=0 then
       begin
         {Zero weights?  just move to next available cell}
         //prob:=1/(10-movelevel);
         for i:= 1 to 9 do
         if newkey[i]=Spacer then
         begin
           lastchoice:=i;
           break;
         end;
       end
       else lastchoice:=nextchoice;

       if tnbr>=0 then
       begin
         {make sure we have a valid location for the "X"}
         while (lastchoice<=9) and (newkey[lastchoice]<>spacer)
         do inc(lastchoice);
         if lastchoice<=9 then newkey[lastchoice]:='X'
         else
         begin
           showmessage('Cannot assign ''X'' to transformed key' + newkey);
           halt;
         end;
         strkey:=InverseTransform(newkey,tnbr,lastchoice);
       end
       else strkey:=newkey;
       playkey[level]:=inttostr(lastchoice)[1];  checkdups;

       newkey[lastchoice]:='X';
       inc(nbrmoves);
       moves[nbrmoves]:=listposition;
       (* Moved to Wrapup to display patterns once per game, not eery move}
       if {verbose.checked or }(not autoplay) then
       for n:=0 to positions.count-1 do
       with positions, pweightrec(positions.objects[n])^ do
       begin
         wwstr:='';
         for i:=1 to 9 do
         begin
           wstr:=wwstr+','+inttostr(w[i]);
           wwstr:=wwstr+','+inttostr(ww[i]);
         end;
         with memo1 do lines.add(format('# %d:%s (%s) (%s)',
                         [n+1, strings[n],wstr,wwstr]));
       end;
       *)
     end;
     if (not autoplay)then
     begin
       if winner('X') then strkey[level]:='X';
       for i:=1 to length(strkey) do {fill in the visual board}
       begin
         r:=(i-1)div 3;
         c:=(i-1) mod 3;
         if strkey[i]<>Spacer then  stringgrid1.Cells[c,r]:=strkey[i]
         else stringgrid1.cells[c,r]:=' ';
       end;
     end;
   end;
   if winner('X') then  {check if we won}
   begin
     winlevel:=level;
     wrapup('X');
   end
   else if level=9 then wrapup(Spacer)
   else inc(level);
 end;  {makemove}

{**************** GenNext **************}
procedure TForm1.GenNext(key:string;templevel:integer);
{Generates the 304 "Matchboxes" that make up the machine,
 normally one time only since psitions are saved in a file}

   procedure posadd(newkey:string);  {add non-winning positions to the list}
   begin
     strkey:=newkey;
     {no need to put winning positions in the list}
     if (not winner('O')) and (not winner('X')) then positions.add(newkey);
   end;

var
  ch:char;
  newkey:string;
  i,index, listpos:integer;
begin
  if templevel mod 2=1 then ch:='X' else if templevel>1 then ch:='O' else ch:=Spacer;
  for i :=1 to length(key) do
  begin
    if key[i]=Spacer then
    begin
      newkey:=key;
      newkey[i]:=ch;
      if templevel mod 2=0 then {save positions after "O" moves if we haven't already}
      begin
        index:=positions.indexof(newkey);
        if index<0 then {not found}
        begin
          if not FindTransform(newkey, index,listpos) {and if not saved rotated }
          then  posadd(newkey);         {or mirrored version, then add it}
        end;
      end;
      if templevel<6 then GenNext(newkey,templevel+1); {generate next level, up to 6}
    end;
    if templevel=0 then break;
  end;
end;

{****************** FindTransform ************}
function TForm1.FindTransform(key:String;
                          var tformNbr, listposition:integer):boolean;
{try all unique rotations & reflections looking for the match in "positions"list}
var
  i,j:integer;
  tempkey:string;
begin
  tempkey:=key;
  for i:=0 to 7 do
  begin
    for j:=1 to 9 do tempkey[j]:=key[transforms[i,j]];
    {debug - memo2.lines.add(tempkey);}
    result:=positions.find(tempkey,listposition);
    if result then
    begin
      tformNbr:=i;
      break;
    end;
  end;
  application.processmessages;
end;

{********** ResetBtnClick ****************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Reset games won/lost counters}
var i:integer;
begin
  totgames:=0;
  XWins:=0;
  OWins:=0;
  PrevTotgames:=0;
  PrevXwins:=0;
  PrevOwins:=0;
  showstats;
  gameover:=true;
end;

var cornerpairs:array [1..6] of tpoint=((X:1;y:3),(x:1;y:7),(x:1;y:9),
                                        (X:3;y:7),(x:3;y:9),(x:7;y:9));
                                        
{*************** StartNewGame *************}
procedure TForm1.startNewGame(auto:boolean);
{Start a new gane}
var i,c,r:integer;
begin
  level:=1;
  gameover:=false;
  autoplay:=auto;  {false for manual play}
  nbrmoves:=0;
  for i:= 0 to 8 do board[i].text:=' ';
  if not autoplay  {Don't clear the grid for each game if in autoplay mode}
  then for c:=0 to 2 do for r:=0 to 2 do stringGrid1.cells[c,r]:=' ' ;
  strkey:=stringofchar(spacer,9);
  PlayKey:=StrKey;
  //memo3.Clear;
  makemove;
end;

{************* AutoPlayBtnClick ************}
procedure TForm1.AutoPlayBtnClick(Sender: TObject);
{run a bunch of random games}
   {-------------- CheckO -----------}
   function CheckO(T1,T2:string):integer;
      var
        i,c,r,n:integer;
        s:string;
      begin
        n:=0;
        for  r:= 0 to 2 do    {check rows}
        begin
          i:=3*r+1;
          s:=copy(strkey,i,3);
          if s=spacer+T2 then n:=i
          else if s=T1+spacer+T1 then n:=i+1
          else if s=T2+spacer then n:=i+2;
          if n<>0 then break;
        end;
        if n=0 then
        for c:=0 to 2 do {check columns}
        begin
          i:=c+1;
          s:=strkey[i] +strkey[i+3] + strkey[i+6];
          if s=spacer+T2 then n:=i
          else if s=T1+spacer+T1 then n:=i+3
          else if s=T2+spacer then n:=i+6;
        end;
        if n=0 then {check diagonals}
        begin
          s:= strkey[1]+strkey[5]+strkey[9];
          if s=spacer+T2 then n:=1
          else if s=T1+spacer+T1 then n:=5
          else if s=T2+spacer then n:=9
          else
          begin
            s:= strkey[3]+strkey[5]+strkey[7];
            if s=spacer+T2 then n:=3
            else if s=T1+spacer+T1 then n:=5
            else if s=T2+spacer then n:=7;
          end;
        end;
        Result:=n;
      end;


var
  i,j,n:integer;
  wwstr,s:string;
  OK:boolean;


     procedure checkavail(index:char; var s:string);
     begin
       if strkey[ord(index) and $0F]=spacer then s:=s+index;
     end;


begin {AutoPlayBtnClick}
  AutoPlayBtn.enabled:=false;
  screen.cursor:=crHourglass;
  intro.visible:=false;
  playing:=false;  {Ignore playback clicks whole building}
  memo3.Clear; memo3.lines.add('Click a "Game" line to replay it');
  startnewgame(true); {initialze fields and place the first X}
  autoplay:=true;
  stopcount:=totgames+gamecount.value; {Last count in this run}
  for i:= 1 to gamecount.value do
  begin
    repeat
      n:=0;
      with autogrp do
      begin
        if (itemindex=3) or (itemindex=4)
        then n:=checkO('O','OO');  {complete the win}
        if (n=0) and ((itemindex=2) or (itemindex=4))
        then n:=checkO('X','XX'); {prevent the loss}

        if (n=0)
        and ((itemindex=1) or (itemindex=4))then  {Make a smart random move}
        begin
          If (level=2) then
          begin
            {{Move  1 was an edge and center available, take t!}
            if ((strkey[2]='X') or (strkey[4]='X')
            or (strkey[6]='X') or (strkey[8]='X'))
            and (strkey[5]=spacer)then n:=5
             (*
            {or move 1 was a corner, take the opposite corner}
            else if (strkey[1]='X')then n:=9
            else if  strkey[9]='X' then n:=1
            else if (strkey[3]='X')then n:=7
            else if  strkey[7]='X' then n:=3;
            *)
            (*
            {or move 1 was a corner, take the an adjacxent edge}
            else if (strkey[1]='X')then n:=2
            else if  strkey[9]='X' then n:=8
            else if (strkey[3]='X')then n:=2
            else if  strkey[7]='X' then n:=6;
            *)
             (*
            {or move 1 was a corner, take the a non-adjacxent edge}
            else if (strkey[1]='X')then n:=6
            else if  strkey[9]='X' then n:=2
            else if (strkey[3]='X')then n:=4
            else if  strkey[7]='X' then n:=6;
            *)


            {or move 1 was a corner, take the center}
            else if ((strkey[1]='X') or (strkey[3]='X')
            or (strkey[7]='X') or (strkey[9]='X'))
            and (strkey[5]=spacer)then n:=5

          end;
          if (n=0) and (level=4) then
          begin
            {X has two adjacent adges, take the ccrner between them}
            if  (strkey[2]='X') and (strkey[6]='X') and (strkey[3]=spacer) then n:=3
            else if(strkey[6]='X') and (strkey[8]='X') and (strkey[9]=spacer) then n:=9
            else if (strkey[2]='X') and (strkey[4]='X') and (strkey[1]=spacer) then n:=1
            else if (strkey[4]='X') and (strkey[8]='X') and (strkey[7]=spacer) then n:=7;

            (*
            {If X has opposite corners {and O has the center, take another corner}
            else if (strkey[1]='X') and (strkey[9]='X') {and (strkey[5]=spacer)} then n:=3
            else if(strkey[3]='X') and (strkey[7]='X') {and (strkey[5]=spacer)} then n:=1
            *)

            {If x has 2 corners, pick an edge}
            if n=0 then
            begin
              OK:=false;
              for j:=1 to high(cornerpairs) do
              with cornerpairs[j] do
              begin
                if (strkey[x]='X') and (strkey[y]='X') then
                begin
                  OK:=true;
                  break;
                end;
              end;
              if OK then n:=2;
            end;

            {If X has an edge and a non-adjacent corner, we need the adjaent corner on the
            same side as the non-adjamcent corner}
            if n=0 then

            if (strkey[2]='X') and (strkey[7]='X') and (strkey[1]=spacer) then n:=1
            else if(strkey[2]='X') and (strkey[9]='X') and (strkey[3]=spacer) then n:=3
            else if (strkey[4]='X') and (strkey[3]='X') and (strkey[1]=spacer) then n:=1
            else if (strkey[4]='X') and (strkey[9]='X') and (strkey[7]=spacer) then n:=7
            else if (strkey[6]='X') and (strkey[1]='X') and (strkey[3]=spacer) then n:=3
            else if(strkey[6]='X') and (strkey[7]='X') and (strkey[9]=spacer) then n:=9
            else if (strkey[8]='X') and (strkey[1]='X') and (strkey[7]=spacer) then n:=7
            else if (strkey[8]='X') and (strkey[3]='X') and (strkey[9]=spacer) then n:=9;
          end;

          if n=0 then{otherwise choose center or any available corner}
          begin
            if (random(2)=0) and (strkey[5]=spacer)
            then n:=5 {Check center first (25% of the time) }
            else
            begin  {Check corners 75% of the time}
              s:=''; {count available corners}
              checkavail('1',s); checkavail('3',s);
              checkavail('7',s); checkavail('9',s);
              if length(s)>0 then
              begin {randomly pick one of the available corners}
                n:=random(length(s))+1;
                n:=strtoint(s[n]);
              end;
            end;
          end;
          if n=0 then {still haven't found a spot}
          begin
            {Check edges}
            s:='';
            checkavail('2',s); checkavail('4',s);
            checkavail('6',s); checkavail('8',s);
            if length(s)>0 then
            begin
              n:=random(length(s))+1;
              n:=strtoint(s[n]);
            end

            else showmessage('Oops!  Found no place for an "O"');
          end;
        end;

        if (n=0) then
        repeat
         OK:=true;
          repeat
            n:=random(9)+1;
          until (strkey[n]=Spacer);{find an empty space for next "O"}
          playkey[level]:=inttostr(n)[1];
          if (not checkdup) then
          begin
             playkey[level]:=spacer;
             OK:=false;
           end;
         until OK;
      end;
      strkey[n]:='O';

      playkey[level]:=inttostr(n)[1]; checkdups;
      if winner('O') then wrapup('O')
      else
      begin
        inc(level);
        makemove;
      end;
    until gameover;
    If i<gamecount.value then startNewGame(True);
  end;
  {UpdateBoxDisplay}
  showstats;
  showdata;
  AutoPlayBtn.enabled:=true;
  screen.cursor:=crDefault;
  playing:=false;
end;


{******************* ResetWeightBtnClick ***********}
procedure TForm1.ResetWeightsBtnClick(Sender: TObject);
Var
  i,n:integer;
  wstr,wwstr:string;
begin
  memo1.lines.beginupdate;
  for n:=0 to positions.count-1 do
  with positions, pweightrec(positions.objects[n])^ do
  begin
    wstr:=''; wwstr:='';
    for i:=1 to 9 do
    begin
      ww[i]:=w[i];
      wstr:=wstr+inttostr(w[i])+',';
      wwstr:=wwstr+inttostr(ww[i])+',';
    end;
    system.delete(wstr,length(wstr),1);
    system.delete(wwstr,length(wwstr),1);
    with memo1  do lines[n] :=format('#%3d: %s (%s) (%s)',
                     [n+1, strings[n],wstr,wwstr]);
  end;
  memo1.Lines.EndUpdate;
end;


{******** IntroBtnClick **************}
procedure TForm1.IntroBtnClick(Sender: TObject);

  {-------------ClearGrid ----------}
  procedure cleargrid(ch:char);
  var c,r,n:integer;
  begin
    n:=0;
    with stringgrid1 do
    for r:=0 to 2 do for c:=0 to 2 do
    begin
      if ch=' ' then cells[c,r]:= ' '
      else
      begin
        inc(n);
        cells[c,r]:=inttostr(n);
      end;
    end;
  end;


begin  {IntroBtnClick}
  if intro.visible then
  begin
    intro.Visible:=false;
    cleargrid(' ');
  end
  else
  begin
    intro.Visible:=true;
    cleargrid('1');
  end;
end;


{******* AdvancedBtnClick **************}
procedure TForm1.AdvancedBtnClick(Sender: TObject);
begin
  If beadsdlg.showmodal=MrOK then
  begin
    SetupFromBeadsDlg;
    initweights;
  end
  else
  {reset dialog boxes with last good values}
  with beadsdlg do
  begin
    init1.value:=initialweights[0];
    init3.value:=initialweights[1];
    init5.value:=initialweights[2];
    init7.value:=initialweights[3];
    rewadd.value:=winreward;
    Lastwinbonus.value:=winbonusreward;
    TieAdd.value:=tiereward;
    LossSub.value:=-lossreward;
    LastLossBonus.value:=-lossbonusreward;
  end;
end;

{*************** SetUpFromBeadsDlg *********}
Procedure TForm1.SetupFromBeadsDlg;
begin
  with beadsdlg do
  begin
    initialweights[0]:=init1.value;
    initialweights[1]:=init3.value;
    initialweights[2]:=init5.value;
    initialweights[3]:=init7.value;
    winreward:=rewadd.value;
    winbonusreward:=Lastwinbonus.value;
    tiereward:=tieadd.value;
    lossreward:=-losssub.value;
    lossbonusreward:=-LastLossBonus.value;
  end;
end;

{******* ShowStata ********}
procedure TForm1.showstats;
var i,n,pg,px,po,pd:integer;
    s:string;
begin
  {produce results even wih no games run yet}
  if totgames=0 then n:=1 else n:=totgames;
  pg:=n-prevtotgames;
  pX:=XWins-PrevXwins;
  PO:=OWins-PrevOWins;
  with memo2,lines do
  begin
    clear;
    s:='Total games: %d '; s:= s+stringofchar('_',30-length(s));
    add(format(s+'This run: %d ', [totgames, pg]));
    s:='Machine wins %d (%d%%)'; s:= s+stringofchar('_',30-length(s));
    add(format(s+'This run: %d, (%d%%)',
         [XWins, trunc(100*XWins/n), PX, trunc(100*Px/pg)]));
    s:='Opponent wins %d (%d%%)'; s:= s+stringofchar('_',30-length(s));
    add(format(s+'This run %d (%d%%)',
         [OWins, trunc(100*OWins/n), PO, trunc(100*pO/Pg)]));
    i:=totgames-XWins-OWins;
    pd:=pg-px-po;
    s:='%d Draws {%D%%)'; s:= s+stringofchar('_',30-length(s));
    add(format(s +'This run: %d (%d%%)',
              [i, trunc(100*i/n), pd, trunc(100*pd/pg)]));

    prevtotgames:=totgames;
    PrevXwins:=XWins;
    PrevOWins:=OWins;
  end;
end;

{********** ShowData ********}
procedure TForm1.showdata;
var
  i,j:integer;
  wstr,wwstr:string;
begin
  UpdateDisplayWeights;
  (*
  memo1.clear;

  for i:=0 to positions.count-1 do
  begin
    with positions, pweightrec(positions.objects[i])^ do
    begin
      wstr:=inttostr(w[1]);
      wwstr:=inttostr(ww[1]);
      for j:= 2 to 9 do
      begin
        wstr:=wstr+inttostr(w[j]);
        wwstr:=wwstr+inttostr(ww[j]);
      end;
      with memo1 do lines.add(format('# %2d:%s (%s) (%s)',
      [i, strings[i],wstr,wwstr]));
    end;
  end;
  scrollToTop(memo1);
  *)
end;


{***********  StringGrid1Click **************}
procedure TForm1.StringGrid1Click(Sender: TObject);
var
  c,r,n:integer;
begin
  If autoplay then exit;

  with Stringgrid1 do
  begin
    if cells[col,row]=' ' then
    begin
      if level mod 2 =1
      then showmessage('Machine moves first, click Start button to begin a game')
      else cells[col,row]:='O';
      n:=3*row+col+1;
      strkey[n]:='O';  {update the key}
      playkey[level]:=inttostr(n)[1];
      if winner('O') then wrapup('O')
      else
      begin
        inc(level);
        makemove;
      end;
    end
    else messagebeep(MB_ICONEXCLAMATION);
  end;
end;

{************** StartBtnClick ***********}
procedure TForm1.StartBtnClick(Sender: TObject);
begin
  autoplay:=false;
  StartNewGame(false);
  intro.Visible:=false;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{**************** Memo3BtnClick ************}
procedure TForm1.Memo3Click(Sender: TObject);
{Display a rep;ay of the game  descrption clicked}
var
  n:integer;
  s,test:string;
  i,c,r:integer;
begin
   if playing then exit;
   playing:=true;
   n:=memolineclicked(memo3);{get the line number clicked}
   s:=trim(memo3.lines[n]);
   if length(s)>4 then
   begin  {click could have been on one of three lines, find the one
           with the move key (the one that starts with "Move"}
     test:=copy(s,1,4);
     if test='Move' then
     else if test='Tran' then dec(n,1)
     else if test='Game' then inc(n,1)
     else n:=-1;
   end;
   if n>0 then
   begin
     {clear grid}
     for r:=0 to 2 do for c:=0 to 2 do StringGrid1.cells[c,r]:=' ';
     s:=trim(memo3.lines[n]);
     n:=5;
     while (n<length(s)) and (not (s[n] in ['1'..'9'])) do inc(n);
     if n<length(s) then
     begin
       delete(s,1,n-1); {get the move locations}

       {Animate the solution on the stringgrid}
       for i:=1 to 9 do
       begin
         if s[i] in ['1'..'9'] then
         begin;
           n:=strtoint(s[i]);
           r:=(n-1) div 3; c:=(n-1) mod 3;
           if i mod 2 = 1 then StringGrid1.cells[c,r]:='X'
           else StringGrid1.cells[c,r]:='O';
           StringGrid1.Update;
           sleep(1000);
         end
         else break;
       end;
     end;
   end;
   playing:=false;
end;

end.
