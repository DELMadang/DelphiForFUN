unit U_CoachsDilemma;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{"The Coaches Dilemma"  - from "the Puzzling Adventures of Doctor Ecco", Dennis
 Shasha, Dover Publications}

{"Yesterday my top-ranking tennis team members were all injured in a freak plane
 accident.  They will recover soon, but I need to prepare substitutes for
 tomorrow to play England's team.  I know who the 8 players of my substitute
 team will be, but I must rank them in a day."

 "So far, I've been able to get only one court to play on. I want to set up
 singles matches of one hour each among the players in such a way that I can
 figure out who is best, who is second best, and so on for all 8 players.
 I was going to use an old fashioned tennis ladder, but that always seems to
 take a week or so to sort itself out.  I need to do it all in 20 hours.  Dr.
 Ecco, can you tell me what to do?"

 Ecco though a few moments.  Then he asked "May we assume that if player X beats
 player Y and player Y beats player Z then X would defeat Z if they played?"

 "Well, that's not always true, but if you need to, then assume it.  Also you
 should know that the players are all in good shape and any one of them is
 capable of playing a few matches in a row."

 "Well, then Mr. McgGraw, I've got good news for you.  You can rank your eight
 players from best to worst in less than 20 hours, provided that each match
 lasts just one hour.  Here's how."
 }

 {Can you figure out how?}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Spin, ComCtrls, DFFUtils;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveBtn: TButton;
    ListBox1: TListBox;
    PlayerGrid1: TStringGrid;
    PlayerGrid2: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StringGrid3: TStringGrid;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    StringGrid6: TStringGrid;
    StringGrid7: TStringGrid;
    StringGrid8: TStringGrid;
    StringGrid9: TStringGrid;
    StringGrid10: TStringGrid;
    RestartBtn: TButton;
    NewBtn: TButton;
    StatusBar1: TStatusBar;
    Label4: TLabel;
    Label5: TLabel;
    MatchLbl: TLabel;
    Label7: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure PlayerGridClick(Sender: TObject);
    procedure PlayerGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                                 Rect: TRect; State: TGridDrawState);
    procedure NewBtnClick(Sender: TObject);
    procedure RestartBtnClick(Sender: TObject);
    procedure ShowRanks(W,L:char);
    procedure SolveBtnClick(Sender: TObject);
    procedure RankGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    list:TStringlist;
    count, longest:integer;
    p1rank,p2rank:integer;
    p1col,p2col:integer;
    players:array[0..7] of integer;
    pg:array[0..7] of TStringGrid;
    Matchcount:integer;
    minMatchcount:integer;
    matchover:boolean;
    noshow:boolean; {prevent display when calculating min Match count}
  end;

var
  Form1: TForm1;

implementation


{$R *.DFM}
(*
{**************** AdjustGridSize ***********}
 procedure adjustGridSize(grid:TStringGrid);
{Adjust borders of grid to just fit cells}
begin
  with grid do
  begin
    height:=(defaultrowheight+GridLineWidth)*rowcount+gridlinewidth+2 {+2 for border};
    width:=colcount*(defaultcolwidth+gridlinewidth)+gridlinewidth+2 {+2 for border};
  end;
end;
*)

{************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization}
var i:integer;
begin
  randomize;
  {load pointers to the rank tracking grids into an array to simplify handling}
  pg[0]:=stringgrid3;
  pg[1]:=stringgrid4;
  pg[2]:=stringgrid5;
  pg[3]:=stringgrid6;
  pg[4]:=stringgrid7;
  pg[5]:=stringgrid8;
  pg[6]:=stringgrid9;
  pg[7]:=stringgrid10;
  newbtnclick(sender);
  list:=TStringlist.create;
  for i:= 0 to high(pg) do adjustgridsize(pg[i]);
  adjustgridsize(playergrid1);
  adjustgridsize(playergrid2);

end;

{************* ShowRanks ***********}
procedure TForm1.showranks(W,L:char);
{Update display of player ranks that have been determined so far}
{The most complex part of the program is here}

   {******* local procedure Insert *******}
   procedure insert(p:tstringgrid;c:integer;v:string);
   {insert player "v" in grid "p" and column "c"}
   var i:integer;
   begin
     for i:=6 downto c do p.cells[i+1,0]:=p.cells[i,0];
     p.cells[c,0]:=v;
   end;
   {****** local procedure   DeleteRow *******}
   procedure deleterow(r:integer);
   {delete data in row (grid #) "r" and b=move all following grids up}
   var i,j:integer;
   begin
     for i:=r to 6 do  with pg[i] do {move data up up grid from "r to the end}
        for j:=0 to 7 do cells[j,0]:=pg[i+1].cells[j,0];
     for j:=0 to 7 do with pg[7] do cells[j,0]:=' '; {and blank out the last grid}
   end;

   {********* local procedure   IncludesRow *******}
   function includesrow(n:integer):integer;
   {If every element of grid "n" is included in some other grid, then
    return number of that grid, otherwise return -1}

   var i,j,k:integer;
       test:array[0..7] of string;
   begin
     result:=-1;
     with pg[n] do for j:=0 to 7 do test[j]:=cells[j,0]; {save the players}
     for i:=0 to 7 do  {for all grids}
     with pg[i] do
     if i<>n then  {except the input grid}
     begin
       k:=0;
       for j:=0 to 7 do  {for all players}
       begin
         if cells[j,0]=' ' then break
         {we'll take advantage of the players being ranked, so matches, if they
          exist will be in the same order}
         else if cells[j,0]=test[k] then inc(k);{if it matches, move to the next player}
       end;
       if (k>7) or (test[k]=' ') then {we matched them all}
       begin
         result:=i;  {so set succes result}
         break;
       end;
     end;
   end;


var i,j,k,n:integer;
    ii,jj,kk,index:integer;
    brk:boolean;
    before, after:string;
    match,m1,m2:integer;
    L1,L2:string;
    list1, list2:Tstringlist;
begin   {showranks}
  
  {first we'll find a place to put the winner and loser pair in a grid}
  for i:= 0 to 7 do {we'll loop until that happens}

  with pg[i] do
  begin
    if cells[0,0]=' ' then  {found a blank row, add winner,loser pair}
    begin
      cells[0,0]:=w;
      cells[1,0]:=L;
      if includesrow(i)>=0 then {this was a redundant match. just ignore it}
      begin
        deleterow(i);
        exit;
      end else
      break;
    end;
    brk:=false;
    for j:=0 to 6 do
    begin  {if the winner is last in a list, we can just tack the loser on}
      if (cells[j,0]=W) and (cells[j+1,0]=' ') then
      begin
        (cells[j+1,0]:=L);
        brk:=true;
      end
      else {if loser is first in a row, we can insert the winner at the beginning}
      if (cells[j,0]=L) and (j=0) then
      begin
        for k:= 6 downto 0 do cells[k+1,0]:=cells[k,0];
        cells[0,0]:=W;
        brk:=true;
      end;
      if brk then break;
    end;
    if brk then break;
  end;

  {now make a pass looking for x W y in one row and x L y in another.
   if found, we can insert L after the W  and W before the L in each.
   If the two are identical, then we can eliminate the second one by moving
   the lower grids up}
  before:=' '; after:=' '; ii:=0; jj:=0;
  for i:=0 to 7 do
  with pg[i] do
  begin
    for j:=1 to 6 do
    begin
      if cells[j,0]=W then
      begin
        if before=' ' then
        begin
          before:=cells[j-1,0];
          after:=cells[j+1,0];
          jj:=j;  ii:=i;
        end
        else
        begin
          if (cells[j-1,0]=before) and (cells[j+1,0]=after) and (i<>ii) then
          begin
            insert(pg[i],j+1,L);
            insert(pg[ii],jj,W);
          end;
        end;
      end
      else
      if cells[j,0]=L then
      begin
        if before=' ' then
        begin
          before:=cells[j-1,0];
          after:=cells[j+1,0];
          jj:=j;  ii:=i;
        end
        else
        begin
          if (cells[j-1,0]=before) and (cells[j+1,0]=after) and (i<>ii) then
          begin
            insert(pg[i],j,W);
            insert(pg[ii],jj+1,L);
          end;
        end;
      end
    end;
  end;

   {Check pairs in each row}
   {If same two players are found in another row, any players
    between may be inserted into this row}
   m1:=-1; m2:=-1;
   for i:=0 to 7 do
   with pg[i] do
   if cells[0,0]<>' ' then
   begin
     brk:=false;
     for j:=0 to 6 do
     begin
       L1:=cells[j,0];
       L2:=cells[j+1,0];
       for k:=0 to 7 do
       if k<>i then
       with pg[k] do
       begin
         match:=0;
         for jj:=0 to 7 do
         begin
           if cells[jj,0]=' ' then break;
           if (cells[jj,0]=L1) then
           begin
             inc(match);
             m1:=jj;;
           end;
           if (cells[jj,0]=L2) then
           begin
             inc(match);
             m2:=jj;
           end;
         end;
         if (match=2) and (m2-m1>1) then
         begin  {both letter found and there are intervening letters}
           for jj:=m2-1 downto m1+1 do insert(pg[i],j+1,pg[k].cells[jj,0]);
           brk:=true;
           break;
         end;
       end;
       if brk then break;
     end;
    end;

   {check pairs of  players X,Y against other rows identifying
    all players >X and all players <Y.  If the intersection is
    a single player, we can insert that player between X and Y}
   list1:=TStringlist.create;
   list1.sorted:=true;
   list2:=TStringlist.create;
   list2.sorted:=true;
   for i:=0 to 7 do
   with pg[i] do
   if cells[0,0]<>' ' then
   begin
     brk:=false;
     for j:=0 to 6 do
     begin
       L1:=cells[j,0];
       L2:=cells[j+1,0];
       list1.clear;
       list2.clear;
       for k:=0 to 7 do
       if k<>i then
       with pg[k] do
       begin
         for jj:=0 to 7 do
         begin
           if cells[jj,0]=' ' then break;
           if (cells[jj,0]=L1) then for kk:=jj+1 to 7 do
            if not list1.find(cells[kk,0],index) then list1.add(cells[kk,0]);
           if (cells[jj,0]=L2) then for kk:=0 to jj-1 do
            if not list2.find(cells[kk,0],index) then list2.add(cells[kk,0]);
         end;
         {now is there a single comm element in list1 and list2?}
         if (list1.count>0) and (list2.count>0) then
         begin {boths lists have players}
           match:=0;
           for jj:=0 to list1.count-1 do
           if list2.find(list1[jj],index) then
           begin
             inc(match);
             if match=1 then L1:=list1[jj]
             else if match>1 then break;
           end;
           if match=1 then
           begin
             insert(pg[i],j+1,L1);
             brk:=true;
             break;
           end;
         end;
         if brk then break;
       end;
       if brk then break;
     end;
    end;
    list1.free;
    list2.free;

   {Finally, eliminate any rows that are "contained" in another row}
   for i:=0 to 7 do
   with pg[i] do
   if cells[0,0]<>' ' then
   begin
     n:=includesRow(i);
     if n>=0 then deleterow(i);
   end;

end;


{****************** PlayerGridClick ************}
procedure TForm1.PlayerGridClick(Sender: TObject);
{User selects two players, one from each of two grids, to define a match to be
 played}
var w,L:char;
    n:integer;
begin
  If matchover then restartbtnclick(sender);
  with Tstringgrid(sender) do
  if (col<>p1col) and (col<>p2col) then  {make sure it's a new column}
  begin
    if sender=playergrid1 then
    begin     {save first player}
      p1col:=col;
      playergrid1.repaint;
    end
    else
    begin  {save second player}
      p2col:=col;
      playergrid2.repaint;
    end;

    if (p1col>=0) and (p2col>=0) then {2 players selected}
    begin
      p1rank:=players[p1col];
      p2rank:=players[p2col];
      inc(Matchcount); matchlbl.caption:=inttostr(matchcount);
      if p1rank>p2rank then
      begin
        w:=char(ord('A')+p1col);
        L:=char(ord('A')+p2col);
      end
      else
      begin
        w:=char(ord('A')+p2col);
        L:=char(ord('A')+p1col)
      end;
      listbox1.items.add('Match '+inttostr(Matchcount)+': Player '+w
                             + ' over Player '+ L);
      screen.cursor:=crHourglass;
      application.processmessages;
      showranks(w,L);
      with listbox1 do itemindex:=items.count-1;
      sleep(500);  {show the players selected in bold for a second}
      screen.cursor:=crDefault;
      p1col:=-1;
      p2col:=-1;
      playergrid1.repaint;
      playergrid2.repaint;
      if pg[0].cells[7,0]<>' ' then
      begin
        n:=minMatchcount;
        if (Matchcount<=n) then  showmessage('Ranking complete with minimum # of Matches!'
                                       +#13+'Good job!!')
        else if (n<20) then showmessage('Ranking completed in under 20 gemaes'
                                 +#13+'But I can do it in '+inttostr(n)+'!')
        else showmessage('OK, but I''m sure you can do better, try again');
        matchover:=true;
      end;
    end;
  end;
end;


{***************** PlayergridDrawCell  ***********}
procedure TForm1.PlayerGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{draw the players selected for current Match in bold font style}
begin
  with Tstringgrid(sender) do
  if ((sender=playergrid1) and (acol=p1col))
    or ((sender=playergrid2) and (acol=p2col)) then
    canvas.font.style:=[fsbold]
     else canvas.font.style:=[];
  with TStringgrid(sender) do
   canvas.textout(rect.left+4, rect.top+4,cells[acol,arow]{char(ord('A')+acol)});
end;

{**************** RankGridDrawCell **********}
procedure TForm1.RankGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw the cells ourselves to avoid  the highlighted drawing of selected cell}
begin
  with TStringgrid(sender), canvas do
  begin
    fillrect(rect);
    textout(rect.left+4, rect.top+4,cells[acol,arow]);
  end;
end;

{****************** NewBtnClick **************}
procedure TForm1.NewBtnClick(Sender: TObject);
{start a new match with 8 players with random rankings}

  {********** local procedure   Swap *******}
   procedure swap(var m,n:integer);
   var t:integer;
   begin
     t:=m;
     m:=n;
     n:=t;
   end;

var  i,r:integer;
begin
  {Corrected 8/31/06 - only exchange with remainder of deck 0 thru i}
  for i:= 0 to 7 do  players[i]:=i; {player # = rank intitially}
  {now shuffle the ranks}
  for i:= 7 downto 1 do
  begin
    r:=players[random(i+1 {8})]; {Pick a random player to swap with player i}
    swap(players[i],players[r]);   {and swap them}
  end;
  noshow:=true;
  solvebtnclick(sender);
  minMatchcount:=Matchcount;
  noshow:=false;
  restartbtnclick(sender);
end;

{*************** RestartBtnClick ***************}
procedure TForm1.RestartBtnClick(Sender: TObject);
{reset stats but retain the current players}
var i,j:integer;

begin
  for i:= 0 to 7 do
  begin
    playergrid1.cells[i,0]:=char(ord('A')+i);
    playergrid2.cells[i,0]:=char(ord('A')+i);
    for j:=0 to 7 do pg[i].cells[j,0]:=' ';
  end;
  p1col:=-1;
  p2col:=-1;
  Matchcount:=0;  matchlbl.caption:=inttostr(matchcount);
  listbox1.clear;
  matchover:=false;
end;

{******************* SolveBtnCLick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);
{auto solve the problem in minimum number of Matches}

   {********** local function Beats ***********}
   function beats(PL1,PL2:string):boolean;
   {return true if player PL1 beats player PL2, false otherwise}
   begin
     if players[ord(PL1[1])-ord('A')]>players[ord(PL2[1])-ord('A')] then result:=true
     else result:=false;
   end;

   var
  i:integer;
  {t:integer;} {default sleep time after rank display} 
  list:array [0..8] of Tstringlist;
  worklist:TStringList;

  {************ local procedure  UpdateDisplay ******}
  procedure updatedisplay(n,t:integer);
  {show list n on grid n}
   var i:integer;
   begin
     if noshow then exit;
     for i:= 0 to list[n].count-1 do pg[n].cells[i,0]:=list[n][i];
     for i:= list[n].count to 7 do  pg[n].cells[i,0]:=' ';
     application.processmessages;
     sleep(t);
   end;

    {************ local procedure  Merge********}
    procedure merge(i,j:integer;P3:Tstringlist);
    {Merge 2 sorted lists, list[i] and list[j], into one sorted list in P3}

    begin
      P3.clear;
      while (list[i].count>0) and (list[j].count>0) do
      begin
        inc(Matchcount);  matchlbl.caption:=inttostr(matchcount);
        if beats(list[i][0],list[j][0]) then  {find the higher ranking player}
        begin
          listbox1.items.add('Match '+inttostr(Matchcount) +':  Player '+list[i][0]
                             + ' over '+ ' Player '+list[j][0]);

          P3.add(list[i][0]); {put the winner onto the new list}
          list[i].delete(0);  {an delete him from the old list}
          {updatedisplay(8,0);}
        end
        else
        begin  {j won - do the same}
          listbox1.items.add('Match '+inttostr(Matchcount) +':  Player '+list[j][0]
                             + ' over '+ ' Player '+list[i][0]);
          P3.add(list[j][0]);
          list[j].delete(0);
          {updatedisplay(8,0);}
        end;
        with listbox1, items do itemindex:=count-1; {force last item added into view}
      end;

      {any unprocessed items when one on e the list is empty, just get tacked
       onto the end of the new list}
      if list[i].count>0 then
      while list[i].count>0 do
      begin
        p3.add(list[i][0]);
        list[i].delete(0);
        {updatedisplay(i,0);   updatedisplay(8,t);}
      end
      else while list[j].count>0 do
      begin
        p3.add(list[j][0]);
        list[j].delete(0);
        {updatedisplay(j,0);   updatedisplay(8,t);}
      end;
      {updatedisplay(i,0); updatedisplay(j,t);}
    end;

begin
  Matchcount:=0;  matchlbl.caption:=inttostr(matchcount);
  listbox1.clear;
  for i:=0 to 8 do  {initialize players 8 files, one player each}
  begin
    list[i]:=Tstringlist.create;
    list[i].add(char(ord('A')+i));
    {updatedisplay(i,0);}
  end;
  worklist:=list[8];

  {now make 4 list with 2 players each by playing 4 Matches}
  listbox1.items.add('Form 4 sorted lists of 2 players each');
  for i:=0 to 3 do
  begin
    merge(2*i, 2*i+1,worklist);
    list[i].assign(worklist);
    {updatedisplay(i,t);}
  end;

  {now make 2 files with 4 players each by merging pairs of files}
  listbox1.items.add('Form 2 sorted lists of 4 players each');
  for i:=0 to 1 do
  begin
    merge(2*i, 2*i+1, worklist);
    list[i].assign(worklist);
    {updatedisplay(i,t);}
  end;

  {and make the final list}
  listbox1.items.add('Form final sorted list of 8 players');
  merge(0, 1, worklist);
  list[0].assign(worklist);
  updatedisplay(0,0);
  worklist.clear;
  {updatedisplay(8,0);}

  for i:=0 to 8 do list[i].free;
  matchover:=true;
 end;

end.
