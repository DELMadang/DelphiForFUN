unit U_Kirkman_Tabu3B;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
The Kirkman's Schoolgirl problem asks for  7 arrangements of 15 girls so that
they walk in 5 groups of 3 each day for a week with no girl in a group walking
with another girl more than once.  Since each girl will be in a group with 2
other girls for each of 7 days, this means that she will be paired with each of
the other 14 girls exactly once.

This program explores a specific method for finding solutions quickly and for
finding the 7 distinct cases that are cannot be converted to another of the 7 by
renaming or rearranging within group, rearranging groups within a day, or
rearranging order of the days within the week.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, Grids, Spin, ComCtrls, ExtCtrls, Ucombov2, dffUtils;

type
  TGroup=array[1..3] of byte;
  TDay=array[1..5] of TGroup;
  TBoard=array[1..7] of TDay;
  TGirls=array[0..14] of byte;
  TPairs=array[0..14,0..14] of integer;{contains the day of each pair of characters}
  TMapped=array[1..7] of integer;


  TIsoSave=record
    board:TBoard;
    normal:TBoard;
    MapToNorm:TGirls;
    MapfromNorm:TGirls;
    valid:boolean;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    SolveSheet: TTabSheet;
    UniqueSheet: TTabSheet;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    NewBtn: TButton;
    StringGrid1: TStringGrid;
    SearchBtn: TButton;
    StringGrid2: TStringGrid;
    StopBtn: TButton;
    TimingBtn: TButton;
    TenureBar: TTrackBar;
    IterBar: TTrackBar;
    Label4: TLabel;
    Label5: TLabel;
    SearchUniqueBtn: TButton;
    SaveUniqueBtn: TButton;
    Edit1: TEdit;
    Memo2: TMemo;
    Memo3: TMemo;
    StringGrid3: TStringGrid;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo4: TMemo;
    SeedGrp: TRadioGroup;
    Stop2Btn: TButton;
    PauseBox: TCheckBox;
    Memo5: TMemo;
    TabSheet1: TTabSheet;
    StringGrid4: TStringGrid;
    StringGrid5: TStringGrid;
    CheckIsoBtnC: TButton;
    Memo7: TMemo;
    Case1Lbl: TLabel;
    Case2Lbl: TLabel;
    SaveAllBtn: TButton;
    SaveDialog1: TSaveDialog;
    LoadBtn: TButton;
    Label12: TLabel;
    Panel1: TPanel;
    Label11: TLabel;
    ListBox1: TListBox;
    OpenDialog1: TOpenDialog;
    DisplayGrp: TRadioGroup;
    GroupBox1: TGroupBox;
    Button2: TButton;
    Label7: TLabel;
    Label10: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NewBtnClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure TimingBtnClick(Sender: TObject);
    procedure SearchUniqueBtnClick(Sender: TObject);
    procedure TenureBarChange(Sender: TObject);
    procedure IterBarChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SeedGrpClick(Sender: TObject);
    procedure CheckIsoBtnCClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure DisplayGrpClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  public
    conflictpairs:TPairs;
    CurrentBoard:TBoard;
    BestBoards:array[1..100] of TBoard;
    Bestboard:TBoard;

    uniquemappedpairs:array[1..10] of TPairs; {Only 7 exist, allow 10 for debugging}
    CurrentScore,bestscore:integer;  {current and best conflict scores}
    TabuTable:array[1..7] of TPairs;{table of next eligle iteration for each pair in each day}
    TabuTenure:integer; {Number of iterations that a move remains in Tabu state}
    MaxIter:integer;  {maximum iterations before giving up}
    StartRandSeed:integer; {first seed used for current or latest search for unique}

    solutions:array of tboard;
    names:array of string;
    Solutioncount:integer;
    Isosave:array[1..2] of TIsoSave;
    OldIsoDisplayIndex:integer;
    uniqueboards:array[1..10] of tboard; {Only 7 exist, allow 10 for debugging}
    uniquenames:array[1..10] of string;
    UniqueCount:integer;


    permutes55:array[1..120,1..5] of integer;{filled by formcreate with all 5 choose 5 permutations}
    starttime:TDatetime;
    runtime:extended;
    mintime:extended;
    totcount:integer;
    verbose:Boolean;  {global variable controlling dispay of intermediate results}

    {variables shared by CheckISo and Permutesgrp while seaching for
     unique solutions}
    day1:TDay;
    mapw:Tgirls;

    mappedDay, saveMappedDay :TMapped;


    case1,case2:TBoard;
    pairs1,pairs2:TPairs;



    {Convert "Board" to letters and display in "Grid"}
    procedure showboard(grid:TStringGrid; const board:TBoard);

    {Display current conflicttable while searching for a solution}
    procedure showconflict;

    {Return count of letter pairs occuring more than once in current "Board"}
    function  conflictscore(const board:TBoard):integer;

    {Step to next conflicting pair when searching for solution}
    function  findnextconflict(const board:TBoard; const w, startgrp:Integer;
                                 var foundgrp,sc1,sc2:integer):boolean;

    {Make a table mapping each letter pair to then day in which it occurs}
    procedure Buildpairs(const board:TBoard; var pairs:TPairs);

    {Normalize a board by mapping day 1 to 'ABCDEFGHUJKL' and then sort girls
     within group, groups with day, and days within the board}
    function  normalize(const board:TBoard; var map:TGirls):TBoard;

    {Performs the sort-only portion of the normalization process}
    procedure Sortcase(var board:TBoard);

    {Check a solution to see if it is isomorphic to and existing unique solution}
    function  isunique(var board:TBoard; var mapsto:integer):boolean;

    {Used in Unique solution search to see if Case1 and Case2 are isomorphic,
     i.e can be mapped to each other}
    function  checkIso:boolean;

    {Permute girls within a day's groups while searching for a soltuon;
     6 arrangments for 5 groups ==> 6^5 =7660 arrangmement to check}
    function  permutegroup(const group:integer;  var daygroups:TDay):boolean;

    {Check to make sure a the passed board is a valid solution, each girl paired
     with each other girl exactly once}
    function  validboard(board:TBoard):boolean;

    {Just a check used for debugging to ensure that a derived map
     really does map case1 to case2}
    function  validmap(const case1,case2:TBoard; const map:tGirls):boolean;

    {Remap "board" using "map" and returnt he new board}
    function  mapcase(const board:TBoard; const map:TGirls):TBoard;

    {Use in Isomorphic check page to hold loaded case information in Isosaves array}
    procedure InitCaseFromgrid(const i:integer; grid:TStringGrid);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{Global initialized variables}

var
  zero:Integer=0;
  zeroarray:Tpairs;

  gvals:array[1..6] of TGroup =  {3 of 3 permutations}
          ((1,2,3),(1,3,2),(2,1,3),(2,3,1),(3,1,2),(3,2,1));

  Initmapped:TMapped=(-1,-1,-1,-1,-1,-1,-1);

  alpha:string[15]='ABCDEFGHIJKLMNO';

  {Initial default cases for Isomorphism testing page}

  {unique case #3 from fas seed}
  defaultcase1:array[1..7] of string=
       ('ABCDEFGHIJKLMNO',
        'ADIBHLCKMEGNFJO',
        'AEKBIOCJNDHMFGL',
        'AFNBGKCDLEHOIJM',
        'AGMBEJCFHDKOILN',
        'AHJBDNCGOELMFIK',
        'ALOBFMCEIDGJHKN');

  {mapped case4 from fast seed}
  defaultcase2:array[1..7] of string=
       ('ABCDEFGHIJKLMNO',
        'ADJBLOCHMEIKFGN',
        'AEGBDMCKOFILHJN',
        'AFMBINCGLDHKEJO',
        'AHLBFKCENDGOIJM',
        'AIOBEHCFJDLNGKM',
        'AKNBGJCDIELMFHO');

   comparecount:integer;

   fastseed:integer = -882106621;
   fastseedstr:string; {will be filled in formcreate}

{************ FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);

  procedure Initgrid(grid:Tstringgrid);
  {Initialize row and column labels for a lineup of girls}
  var i:integer;
  begin
    with grid do
    begin
      for i:=1 to 7 do cells[0,i]:='Day '+inttostr(i);
      for i:=1 to 5 do cells[i,0]:='Group '+inttostr(i);
    end;
  end;

var
  i,j:integer;
begin
  reformatmemo(memo1);
  pagecontrol1.activepage:=IntroSheet;
  randomize;
  //randseed:=1000; {make results repeatable for debugging}
  label5.caption:='Random seed for this run = '+inttostr(randseed);
  edit1.text:=inttostr(randseed);
  initgrid(stringgrid1);
  initgrid(stringgrid3);
  initgrid(stringgrid4);
  initgrid(stringgrid5);

  with stringgrid2 do
  for i:=1 to 15 do
  begin
    cells[i,0]:=char(ord('A')+i-1);
    cells[0,i]:=cells[i,0];
  end;
  Tenurebarchange(sender);
  Iterbarchange(sender);

  for i:=0 to 14 do  for j:=0 to 14 do  zeroarray[i,j]:=0;
  i:=0;
  with combos do
  begin
    setup(5,5,permutations);
    while getnext do
    begin
      inc(i);
      for j:=1 to 5 do permutes55[i,j]:=selected[j];
    end;
  end;
  Savedialog1.Initialdir:=extractfilepath(application.exename);

  {Load default initial cases for Isomorphism page}
  with stringgrid4 do {this is unique3}
  for i:=1 to 7 do
  for j:=1 to 5 do cells[j,i]:=copy(defaultcase1[i],3*(j-1)+1,3);
  case1Lbl.Caption:='Case1 - Default';
  InitcaseFromGrid(1,stringgrid4);

  with stringgrid5 do
  for i:=1 to 7 do
  for j:=1 to 5 do cells[j,i]:=copy(defaultcase2[i],3*(j-1)+1,3);
  case2Lbl.Caption:='Case2 - Default';
  InitCaseFromGrid(2,stringgrid5);

  {Initialize arrays to hold "unique search" results for saving to a file}
  setlength(solutions,100);
  setlength(names,100);

  {Initialize fast random seed }
  fastseedstr:=format('%.0n',[fastseed+0.0]);
  seedgrp.items[1]:='Start with '+fastseedstr+' (fast)';
end;

{************ Shuffle *************}
procedure shuffle(var deck:array of char);
{randomly rearrange an array of characters}
var
  i,n:integer;
  temp:char;
begin
  i:= high(deck);
  while i>0 do
  begin
    n:=random(i+1);
    temp:=deck[i];
    deck[i]:=deck[n];
    deck[n]:=temp;
    dec(i);
  end;
end;

{**************** CopyFromTo ************}
procedure CopyFromTo(const board1:TBoard; Var board2:TBoard);
{Copy board1 to board2}
begin
  move (board1,board2, sizeof(board1));
end;

{************** NewbtnClick **********}
procedure TForm1.NewBtnClick(Sender: TObject);
{make a new random case}
var
  w,i,j,k,day:integer;
  girls:array[1..15] of char;
  girlptr:integer;
begin
  for i:=1 to 15 do girls[i]:=char(ord('A')-1+i);
  for day:=1 to 7 do
  begin
    shuffle(girls);
    girlptr:=1;
    for j:=1 to 5 do
    with stringgrid1 do
    begin
      k:=girlptr;
      if sender = newbtn then cells[j,day]:=girls[k]+','+girls[k+1]+','+girls[k+2];
      inc(girlptr,3);
      currentboard[day,j,1]:=ord(girls[k])-ord('A');
      currentboard[day,j,2]:=ord(girls[k+1])-ord('A');
      currentboard[day,j,3]:=ord(girls[k+2])-ord('A');
    end
  end;
  for w:=1 to 7 do
  for i:=0 to 14 do
  for j:=0 to 14 do  tabutable[w,i,j]:=0;
  Currentscore:=conflictscore(currentboard);
  if sender=newbtn then
  begin
    memo2.clear;
    memo2.lines.add('Initial Conflict score='+inttostr(Currentscore));
    showconflict;
  end;
  copyFromTo(currentboard,Bestboard);
  Bestscore:=currentscore;
end;

{************** ConflictScore ***************}
function TForm1.conflictscore(const board:TBoard):integer;
{count how many times girls are paired more than once}
var
  g,day:integer;
  g1,g2,g3:byte;

  I1, I2:integer;
begin
  move(zeroarray,conflictpairs, sizeof(conflictpairs)); {fast initialization}
  for day:=1 to 7 do
    for g:=1 to 5 do
    begin
      g1:=board[day,g,1];
      g2:=board[day,g,2];
      g3:=board[day,g,3];
      inc(conflictpairs[g2,g1]);  inc(conflictpairs[g1,g2]);
      inc(conflictpairs[g3,g1]);  inc(conflictpairs[g1,g3]);
      inc(conflictpairs[g3,g2]);  inc(conflictpairs[g2,g3]);
    end;
  result:=0;
  for I1:=0 to 14 do
  for I2:=I1 to 14 do
  if conflictpairs[I1,I2]>1
  then result:=result+conflictpairs[I1,I2]-1;
end;


{************* FindNextConflict *************}
function TForm1.findnextconflict(const board:TBoard; const w, startgrp:Integer; var foundgrp,sc1,sc2:integer):boolean;
var
  grp,g1,g2,g3:integer;
begin
  result:=false;
  for grp:= startgrp to 5 do
  begin
    g1:=board[w,grp,1];
    g2:=board[w,grp,2];
    if conflictpairs[g1,g2]>1
    then
    begin
      sc1:=1;
      sc2:=2;
      foundgrp:=grp;
      result:=true;
      break;
    end;
    g3:=board[w,grp,3];
    if ((g1<g3) and (conflictpairs[g1,g3]>1)) or
       ((G1>g3) and (conflictpairs[g3,g1]>1))
    then
    begin
      sc1:=1;
      sc2:=3;
      foundgrp:=grp;
      result:=true;
      break;
    end;
    if ((g2<g3) and (conflictpairs[g2,g3]>1)) or
       ((G2>g3) and (conflictpairs[g3,g2]>1))
    then
    begin
      sc1:=2;
      sc2:=3;
      foundgrp:=grp;
      result:=true;
      break;
    end;
  end;
end;    {findnextconflict}

{*************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
{2nd attempt - evaluate all 90 possible swaps and pick the best score that is
 not tabu or reduces the cost}
var
  work:TBoard;
  workscore:integer;
  icount:integer;
  w,grp1,fndgrp,fndgrp1:integer;
  k:integer;
  moved:boolean;
  sc1,sc2:integer;

     {------------- Trymove ---------------}
     function trymove(const s1,s2:integer; forcedmove:boolean):boolean;
     {forcedmove=false: make a move which improves currentscore }
     {forcedmove=true: make a move which does not violate tabutenure, even if it does not
                       improve currrent score}

     var
       temp:byte;
        begin
          {swap points s1 and s2};
          temp:=work[w,fndgrp,s1];
          work[w,fndgrp,s1]:=work[w,fndgrp1,s2];
          work[w,fndgrp1,s2]:=temp;
          workscore:=conflictscore(work);
          if (workscore<currentscore) or forcedmove
          then
          begin
            result:=true;
            {put it in the table in both orders so we don;t need to test order
             each time we want to check an entry}
            tabutable[w,work[w,fndgrp,s1],work[w,fndgrp1,s2]]:=icount+tabuTenure;
            tabutable[w,work[w,fndgrp1,s2],work[w,fndgrp,s1]]:=icount+tabuTenure;
          end
          else
          begin {no move found}
            result:=false;
            {undo the trial move from the work board}
            temp:=work[w,fndgrp,s1];
            work[w,fndgrp,s1]:=work[w,fndgrp1,s2];
            work[w,fndgrp1,s2]:=temp;
          end;
       end; {trymove}



begin {SearchBtnClick}
  iCount:=0;
  Tenurebarchange(sender);
  IterbarChange(sender);
  if sender=searchbtn then screen.cursor:=crHourGlass;
  tag:=0;

  while (BestScore>0) and (icount<maxiter) and (tag=0) do
  begin
    copyfromto(currentboard,work);
    if icount and $ff=0 then application.processmessages;
    moved:=false;
    while (not moved)and (tag=0) and (icount{trycount}<maxiter) do
    begin
      inc(icount);
      for w:=1 to 7 do  {for all days}
      begin
        for grp1:=1 to 5 do {for all groups on that day}
        begin
          fndgrp:=grp1;
          if findnextconflict(work,w,grp1,fndgrp,sc1,sc2) then
          begin {found a pair of  girls that are paired more than once across days}
            for fndgrp1:=fndgrp+1 to 5 do {for the rest of the groups}
            begin
              for k:=1 to 3 do {for each of the girls in thos groups}
              begin
                {Try swapping the first girl with a girl in another group on this day}
                 moved:=trymove(sc1,k,false);
                if not moved then trymove(sc2,k,false); {if that failed, try swapping the other girl}
                if moved then break;
              end;
              if moved then break;
            end;
          end;
          if moved then break;
        end;
        if moved then break;
      end;
      if not moved then  {no move found that improved the conflict score}
      {then make the first non-tabu move we find regardless of the score}
      for w:=1 to 7 do
      begin
        for fndgrp:=1 to 4 do
        begin
          for sc1 :=1 to 3 do
          begin
            for fndgrp1 := fndgrp+1 to 5 do
            begin
              for sc2:=1 to 3 do
              begin
                 {if the current iteration count > than the iteration count when
                  this pair became eligible for swapping then make the move}
                 if tabutable[w,work[w,fndgrp,sc1],work[w,fndgrp1,sc2]]<icount
                 then moved:=trymove(sc1,sc2,true);
                 if moved then break;
              end;
              if moved then break;
            end;
            if moved then break;
          end;
          if moved then break;
        end;
        if moved then break;
      end;
      if moved then
      begin
        copyfromto(work,currentboard);
        currentscore:=workscore;
        if currentscore<bestscore then
        begin
          copyfromto(currentboard,bestboard);
          bestscore:=currentscore;
          if sender = searchbtn
          then memo2.lines.add(format('New conflict score:%d, Iterations:%d',[bestscore, Icount]));
          application.processmessages;
        end;
      end;
    end;
  end; {while bestscore>0}
  if (Bestscore=0) and (sender=searchbtn) then
  begin
    memo2.lines.add('Solved!');
    showboard(Stringgrid1, bestboard);
    bestscore:=conflictscore(bestboard);
  end;
  if sender=searchbtn then
  begin
    showconflict;
    screen.cursor:=crdefault;
  end;
end;

{************* ShowBoard **********}
procedure TForm1.showboard(Grid:TStringgrid; const board:TBoard);
var
  day,g,k:integer;
  s:string;
begin
  for day:=1 to 7 do
  begin
    for g:=1 to 5 do
    with grid do
    begin
      s:='';
      for k:=1 to 3 do s:=s+char(Ord('A')+board[day,g,k]);
      cells[g,day]:=s;
    end;
  end;

end;

{************ ShowConflict **********}
procedure TForm1.Showconflict;
var
  i,j:integer;
  sum:integer;
begin
  sum:=0;
  with stringgrid2 do
  begin
    for i:=0 to 14 do
    for j:=i to 14 do
    begin
      cells[i+1,j+1]:=inttostr(conflictpairs[i,j]);
      if conflictpairs[i,j]>1 then inc(sum,conflictpairs[i,j]-1);
    end;
  end;
  label1.caption:='Conflict score='+inttostr(sum);
end;

{******** StopBtnClick *************8}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;{set stop flag}
end;

{*************** TimingBtnClick **********8}
procedure TForm1.TimingBtnClick(Sender: TObject);

begin
  totcount:=0;
  solutioncount:=0;
  starttime:=now;
  tag:=0;
  memo2.lines.clear;
  while (solutioncount<100) and (tag=0) do
  begin
    inc(totcount);
    newbtnclick(sender);
    searchbtnclick(sender);
    if bestscore=0 then
    begin
      inc(solutioncount);
      memo2.lines.add(format('Total tried:%d, Solved:%d, Time: %6.1f secs.',
         [totcount,solutioncount, (now-starttime)*secsperday]))
    end;
  end;
end;

{**************** Buildpairs ******************}
procedure TForm1.Buildpairs(const board:TBoard; var pairs:TPairs);
{ for each letter pair, save the day # where it occurs}
var
  j,k:integer;
  w,g:integer;
  a,b:integer;
begin
  for w:=1 to 7 do
  for g:=1 to 5 do
  begin
    for j:=1 to 2 do for k:=j+1 to 3 do
    begin
      {both ways - just in case}
      a:=board[w,g,j];
      b:=board[w,g,k];
      pairs[a,b]:=w;
      pairs[b,a]:=w;
    end;
  end;
end;



{---------- Swap ---------}
procedure swap(var a,b:byte);
{Swap 2 girls (bytes) }
var
  temp:byte;
begin
  temp:=a;
  a:=b;
  b :=temp;
end;

{----------- SwapGroups ---------}
procedure swapgroups(var a,b:TGroup);
{Swap 2 groups}
var
  temp:TGroup;
begin
  temp:=a;
  a:=b;
  b :=temp;
end;

{------------- SwapRows ----------}
procedure swaprows(var a,b:TDay);
{Swap 2 days {5 groups, 15 girls}
var
  temp:TDay;
begin
  temp:=a;
  a:=b;
  b :=temp;
end;

{************ Normalize **********}
function TForm1.normalize(const board:TBoard; var map:TGirls):TBoard;
var
  work:TBoard;
  i,d,g,k:integer;
  mapline:TGirls;
begin
   copyfromto(board,work);
  {map line1 to alpha}
    i:=-1;
    for g:=1 to 5 do
    for k:= 1 to 3 do
    begin
      inc(i);
      mapline[work[1,g,k]]:=i;
    end;

    {now remap}
    d:=0;
    repeat
      inc(d);
      g:=0;
      repeat
        inc(g);
        k:=0;
        repeat
          inc(k);
          work[d,g,k]:=mapline[work[d,g,k]];
        until k=3;
      until g=5;
    until d=7;
   sortcase(work);
   for i:=0 to 14 do map[mapline[i]]:=i;
   copyfromto(work,result);
 end;


{************ SortCase ************}
procedure TForm1.sortcase(var board:TBoard);
var
  work:TBoard;
  d,d2,g,g2,k,m:integer;
begin
   copyfromto(board,work);

    {now sort the letters within groups in alpha sequence}
    for d:=1 to 7 do
    for g:=1 to 5 do
    begin
      for k:=1 to 2 do
      for m:=k+1 to 3 do
      begin
        if work[d,g,k]>work[d,g,m] then swap(work[d,g,k],work[d,g,m]);
      end;
    end;

    {sort the groups within a day by the 1st letter of the group}
    for d:=1 to 7 do

    for g:=1 to 4 do
    for g2:=g+1 to 5 do
    begin
      if work[d,g,1]>work[d,g2,1] then swapgroups(work[d,g], work[d,g2]);
    end;

    {finally sort the rows by the 2nd letter of the 1st group}
    for d:=1 to 6 do
    for d2:=d+1 to 7 do
    if work[d,1,2]>work[d2,1,2] then swaprows(work[d], work[d2]);
    copyfromto(work,board);
  end;


 

{********************** PermuteGroup **************}
function Tform1.permutegroup(const group:integer;  var daygroups:TDay):boolean;
   var
     m,k,d:integer;
     g:tgroup; { 1..3] of integer;}
     gp:integer; {current group permutation nbr 1..6: (ABC,ACB,BAC,BCA,CAB,CBA)}
     phi1,phi2:byte;  {defined here for easier debugging}

begin
  if tag<>0 then
  begin
    result:=true;
    exit;
  end;
  result:=false;
  g:=daygroups[group];
  gp:=1;
  while (gp <=6) and (not result) do {permute girls within the group(6 permtations of 3 girls)}
  begin
    {map 1st, 2nd and 3rd values in permuted string to corresponding letters in
     same case1 group}
    result:=true;
    for k:=1 to 3 do mapw[day1[group,k]]:=g[gvals[gp,k]];
    if (group<5)  {we've not yet permuted all 5 groups in the day}
    then result:=permutegroup(group+1, daygroups) {recursive call to permute next group}
    else {all 5 groups a next permute}
    begin {time to check it against each of the case 1 days}
      savemappedday:=mappedday;

      for d:=2 to 7 do
      begin
        for m:=1 to 5 do
        begin
          {check 2 pairs in group "m", if 2 pairs map OK, then the third pair must}
          for k:= 1 to 2 do
          begin
            inc(comparecount);
            {map case1 groups to days of occurrence if transformed by mapw}
            phi1:=mapw[case1[d,m,k]];
            phi2:=mapw[case1[d,m,k+1]];
            {all mappings of this day's pairs must map to the same day if it is isomorphic}
            if mappedDay[d]<0 then
            begin
               mappedDay[d]:=pairs2[phi1,phi2]; {1st mapping }
            end
            else if mappedDay[d]<>pairs2[phi1,phi2] then {does it map to the same day?}
            begin
              result:=false;  {nope - this cannot be the right mapping}
              break;
            end;
            if not result then break;
          end;
          if not result then
          begin
            mappedDay:=savemappedday;{retract mappings that might have been set}
            break; {incorrect mapping -  might as well stop checking}
          end;
        end;  {for m:=}
      end; {for d :=}
    end;
    if result then break; {good mapping found - exit}
    inc(gp);
  end;
end;

{************ CheckIso ************88}
function TForm1.checkISO:boolean;
{Check to see if 2 solutions are isomorphic}
var k,g,d:integer;
    start:integer;
    day:integer; {current day being checked}
    day2:TDay;
    OK:boolean;
    s:string;

    function groupToStr(g:TGroup):string;
    var
      i:integer;
    begin
      result:='';
      for i:=1 to 3 do
      result:=result+char(ord('A')+g[i]);
    end;

begin
  day1:=case1[1]; {load 1st day's groups into day1}
  OK:=false;
  start:=2;
  comparecount:=0;
  (*
  {algorithm assumes that both cases are normalized, if not and case1 day 1
   happened to map to case2 day 1, I think that mapping would not be found
   without this check.  Need to run more tests, but starting at day 1 does slow
   the algorithm down by 10%-15%}
  for g:=1 to 5 do for k:=1 to 3 do if case1[1,g,k]<> case2[1,g,k] then
  begin
    start:=1; {if first days are not equal, allow for day 1 mapping to day 1}
    break;
  end;
  *)
  {try mapping each day of case2 to 1st day of case1}
  for day:=start to 7 do {for each day} {swapped to inner loop}
  //for k:=1 to high(permutes55) do
  begin  {for all 120 (5!) permutations of 5 groups in a day}
    //for day:=start to 7 do {for each day}
    for k:=1 to high(permutes55) do {swapped to outerloop}
    begin
      FillChar(mapw[0],sizeof(mapw), 0);
      for g:=1 to 5 do day2[g]:=case2[day,permutes55[k,g]];
      //for d:=2 to 7 do mappedDay[d]:=-1;
      mappedday:=initmapped;
      mappedday[1]:=day;
      {each group of 3 girls can be permuted in 6 ways}
      {check all 7660 (6^5) permutations of girls within the 5 permuted groups}
      OK:=permutegroup(1 , day2);
      if ok then
      begin
        if verbose then
        begin
          with memo7.Lines do
          begin
            add('Mapping found for Normal;ized Case1 to Normalized Case2');
            add(format('Day 1,Case 1 mapped to permtutation %d of day %d of case 2',[k,day]));
            s:='';
            for g:=1 to 5 do
            begin
              s:=s+' '+grouptostr(day2[g]);
            end;
            add('Day groups ='+ s);
            add('Mapping:');
            add('ABC DEF GHI JKL MNO');
            s:='';
            for d:=0 to 14 do
            begin
              s:=s+char(ord('A')+mapw[d]);
              if d mod 3=2 then s:=s+' ';
            end;
            add(s);
            for d:=1 to 7 do
            add(format('Day %d mapped to day %d',[d,mappedday[d]]));
            add('');
            Add(format('Checked %.0N pairs of girls in finding this map',[comparecount+0.0]));
          end;
        end;
        break;
      end;
      if OK then break;
    end;
    if OK then break;
    application.ProcessMessages;
  end;
  result:=OK;
end;

{**************** IsUnique ************}
function TForm1.isunique(var board:TBoard; var mapsto:integer):boolean;
{Test a board to see if it is a new unique board and add it to the uniqueboards
 array if so}
var j:integer;
    OK:boolean;
    map:TGirls;
begin
  result:=false;
  copyfromto(board,case1);
  {sortcase}normalize(case1,map);
  buildpairs(case1,pairs1);
  OK:=false;
  {check solution i against each unique solution (j)}
  for j:= 1 to uniquecount do {for each solution already found to be unique}
  begin
    copyfromto(uniqueboards[j],case2);
    pairs2:=uniquemappedpairs[j];
    OK:=CheckIso;
    If OK then break;
  end;

  copyfromto(case1,board);
  runtime:=(now-starttime)*secsperday;
  if (uniquecount=0) or (not OK) then
  begin {found a new unique case}
    inc(uniquecount);
    copyfromto(case1,uniqueBoards[uniquecount]);
    buildpairs(case1,uniqueMappedPairs[uniquecount]);
    result:=true;
    mapsto:=0;
  end
  else if OK  then  mapsto:=j;
end;

{***************** SearchUniqueBtnClick ***********8}
procedure TForm1.SearchUniqueBtnClick(Sender: TObject);
var
  mapsto:integer;
begin
  verbose:=false;
  case  seedgrp.itemindex of
    2:  randomize;
    0:  randseed:=strtointdef(edit1.text,0);
    1:  randseed:=fastseed;
  end;
  startrandseed:=randseed;
  edit1.text:=inttostr(randseed);
  label5.caption:='Random seed for this run = '+inttostr(randseed);
  totcount:=0;
  solutioncount:=0;
  uniquecount:=0;
  starttime:=now;
  tag:=0;
  memo3.lines.clear;
  screen.cursor:=crHourGlass;

  while (uniquecount<7) and (tag=0) do
  begin
    inc(totcount);
    newbtnclick(sender);
    searchbtnclick(sender);
    if bestscore=0 then
    begin
      inc(solutioncount);
      if length(solutions)<solutioncount then
      begin
        setlength(solutions, length(solutions)+100);
        setlength(names,length(solutions));
      end;

      if isunique(bestboard,mapsto) then
      begin
        memo3.lines.add(format('Tot:%d, Solved:%d, Unique: %d, Total Time: %6.1f secs.',
         [totcount,solutioncount, uniquecount, runtime]));
        showboard(stringgrid3,uniqueboards[uniquecount]);
        names[solutioncount]:='#U'+inttostr(uniquecount);
      end
      else
      begin  {not unique}
        if pausebox.checked then
        begin
          showboard(stringgrid3,bestboard);
          if (uniquecount<7) then showmessage('Click OK to continue');
        end;
        names[solutioncount]:='Case #'+ inttostr(solutioncount)+' mapped to #U'+inttostr(mapsto);
        memo3.lines.add(format('Solution #%d maps to unique #%d, %4.1n secs.',[solutioncount,mapsto,runtime]))
      end;
      label4.caption:=format('Total tested:%d  Solutions found:%d  Unique found: %d',
                              [totcount,solutioncount,uniquecount]);
      copyfromto(bestboard, solutions[solutioncount]);

    end;
    if (sender=button2) and (runtime>mintime) then break;
  end;
  screen.cursor:=crDefault;
end;

{****************** TenurebarChange ***********}
procedure TForm1.TenureBarChange(Sender: TObject);
begin
  label2.caption:='Tabu tenure = ' + inttostr(10*Tenurebar.position);
  tabutenure:=10*tenurebar.position;
end;

{************** IterbarChange ***************}
procedure TForm1.IterBarChange(Sender: TObject);
begin
  label3.caption:='Max iterations per case = '+inttostr(1000*Iterbar.position);
  maxIter:=1000*IterBar.position;
end;

{*********** SaveUniquebtnClick **********}
procedure TForm1.SaveBtnClick(Sender: TObject);

       {----------- Savecases ------------}
       procedure Savecases(const f:textfile;
                           const count:integer;
                           const boards:array of TBoard;
                           const names:array of string);
       var
         i:integer;
         d,g,k:integer;
         s:string;

       begin  {savecases}
          for i:=1 to count do
          begin
            writeln(f,names[i]);
            for d:=1 to 7 do
            begin
              s:='';
              for g:=1 to 5 do
              begin
                for k:=1 to 3 do s:=s+char(ord('A')+boards[i][d,g,k]);
                s:=s+' ';
              end;
              writeln(f,s);
            end;
            writeln(f,'');
          end;
        end; {savecases}


var
  f:textfile;
  fname:string;
begin
  if savedialog1.execute then
  begin
    fname:=savedialog1.filename;
    assignfile(f,fname);
    rewrite(f);
    if sender = Saveuniquebtn
    then savecases(f,uniquecount, uniqueboards, uniquenames)
    else {save all} savecases(f, solutioncount, solutions, names);
    closefile(f);
  end;
end;

{************ SeedgrpClick **********88}
procedure TForm1.SeedGrpClick(Sender: TObject);
var
  n:integer;
begin
  case seedgrp.itemindex of
  2: begin
       edit1.text:='';
       Label5.caption:='Randomseed ';
     end;
  0: begin
       n:=strtointdef(edit1.text,0);
       randseed:=n;
       Label5.caption:='Randomseed is '+inttostr(n);
     end;
  1: begin
       edit1.text:=fastseedstr;
       randseed:=fastseed;
       Label5.caption:='Randomseed is '+edit1.text;
     end;
  end;
end;

{************** LoadBoardFromGrid **********}
procedure loadboardfromgrid(var board:TBoard; const grid:TStringgrid);
var
  i,j,k:integer;
  s:string;
begin
  for i:=1 to 5 do
  for j:=1 to 7 do
  begin
    s:=uppercase(grid.cells[i,j]);
    for k:=1 to 3 do board[j,i,k]:=ORD(S[K])-ord('A');
  end;
end;

{************** LoadGridFromBoard **********}
procedure loadGridFromBoard(var grid:TStringgrid; const board:TBoard);
var
  i,j,k:integer;
  s:string;
begin
  for i:=1 to 5 do
  for j:=1 to 7 do
  begin
    s:='';
    for k:=1 to 3 do s:=s+char(Ord('A')+board[j,i,k]);
    grid.cells[i,j]:=s;
  end;
end;

{************* ValidBoard *************}
function  TForm1.validboard(board:TBoard):boolean;
{Return true if the board is a valid solution}
begin
  result:=conflictscore(board)=0;
end;

{************* Validmap **********}
function TForm1.validmap(const case1,case2:TBoard; const map:tGirls):boolean;
 {test if mapping case1 to a temporary case by applying the mapping "Map" to
 days of case1, produce a case which, when normalized = case2}
var
  temp:TBoard;
  d,g,k:integer;
begin
  result:=true;
  for d:=1 to 7 do
  for g:=1 to 5 do
  for k:= 1 to 3 do
  temp[d,g,k] := map[case1[d,g,k]];
  if validboard(temp) then
  begin
    sortcase(temp);
    for d:=1 to 7 do
    begin
      for g:=1 to 5 do
      begin
        for k:= 1 to 3 do
        begin
          if temp[d,g,k]<>case2[d,g,k] then
          begin
            result:=false;
            break;
          end;
        end; {for k loop}
      end;  {for g loop}
      if not result then break;
    end; {for d loop}
  end
  else result:=false;;
end;

{************* MapCase ***********8}
function TForm1.mapcase(const board:TBoard; const map:TGirls):TBoard;
var
  d,g,k:integer;
begin
  for d:=1 to 7 do
  for g:=1 to 5 do
  for k:=1 to 3 do
  result[d,g,k]:=map[board[d,g,k]];
end;


{************ CheckIsoBtnClick ***********}
procedure TForm1.CheckIsoBtnCClick(Sender: TObject);
var

  OK:boolean;
  i:integer;
  s:string;
begin
  verbose:=true;
  memo7.clear;
  copyfromto(Isosave[1].normal,case1);
  buildpairs(case1,pairs1);
  copyfromto(Isosave[2].normal,case2);
  buildpairs(case2,pairs2);
  displaygrp.itemindex:=1;  {set display to normalized version}
  begin
    ok:=checkiso;

    with memo7.lines do
    if OK and validmap(case1,case2,mapw) then
    begin
      add('Case1 ==> Case2 Mapping');
      s:='';
      for i:=0 to 14 do
      begin
        s:=s+char(ord('A')+i)+'--->'+char(ord('A')+mapw[i])+'   ';
        if i mod 3 =2 then
        begin
          add(s);
          s:='';
        end;
      end;
      add(''); add('Click "As read" radio button for mappings back to that state');
    end
    else add('Cases are distinct (no mapping exists)');
  end;
end;

{*************** LoadBtnClick *********8}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  f:textfile;
  line:string;
begin
  If opendialog1.execute then
  begin
    listbox1.clear;
    assignfile(f,opendialog1.filename);
    reset(f);
    while not eof(f) do
    begin
      readln(f,line);
      if pos('#',line) >0 then listbox1.Items.add(line);
    end;
    panel1.Visible:=true;
    closefile(f);
  end;
end;

{************** InitCasefromGrid *************8}
procedure TForm1.InitCaseFromgrid(const i:integer; grid:TStringGrid);
var
  OK:boolean;
  save:boolean;
begin
  loadboardfromgrid(isosave[i].board,grid);
  with isosave[i] do
  if validboard(board) then
  begin
    valid:=true;
    normal:=normalize(board,maptonorm);
    copyfromto(normal,case1);
    buildpairs(case1,pairs1);
    copyfromto(board,case2);
    buildpairs(case2,pairs2);
    save:=verbose;
    verbose:=false;
    ok:=checkiso;
    verbose:=save;
    if OK and validmap(case1,case2,mapw)
    then  mapfromnorm:=mapw
    else valid:=false;
  end
  else valid:=false;
end;

{************* Listbox1Click ************8}
procedure TForm1.ListBox1Click(Sender: TObject);
var
i:integer;
loadedcount:integer;


      {------------ Loadcase -------------}
      procedure loadcase(index:integer);
      var
        f:textfile;
        line:string;
        i,j:integer;
      begin
        assignfile(f,opendialog1.filename);
        reset(f);

        while not eof(f) do
        begin
          readln(f,line);
          if line=listbox1.items[index] then
          begin  {found the entry}
            inc(loadedcount);
            if loadedcount=1 then
            begin
              with stringgrid4 do
              for i:=1 to 7 do
              begin
                readln(f,line);
                for j:=1 to 5 do
                cells[j,i]:=copy(line,4*(j-1)+1,3);
              end;
              case1Lbl.Caption:='Case1 - '+listbox1.Items[index];
              InitCasefromGrid(1,stringgrid4);
            end
            else
            with stringgrid5 do
            begin
              for i:=1 to 7 do
              begin
                readln(f,line);
                for j:=1 to 5 do
                cells[j,i]:=copy(line,4*(j-1)+1,3);
              end;
              case2Lbl.Caption:='Case2 - '+listbox1.Items[index];
              InitCasefromGrid(2,stringgrid5);
              break;
            end;
          end;
        end;
        closefile(f);
      end;

begin {listbox1click}
  with listbox1 do
  begin
    loadedcount:=0;
    if selcount>=2 then
    begin
      for i:=0 to items.count-1 do
      begin
        if selected[i] then Loadcase(i);
        if loadedcount=2 then break;
      end;
    end;
  end;
end;

{***************** DisplayGrpClick ***********}
procedure TForm1.DisplayGrpClick(Sender: TObject);
var
  i,n:integer;
  newmap1,newmap3:TGirls;
  s:string;

begin
  with displaygrp do
  begin
    if itemindex=0 then
    begin
      showboard(stringgrid4, isosave[1].board);
      showboard(stringgrid5, isosave[2].board);
    end
    else
    begin
      showboard(stringgrid4, isosave[1].normal);
      showboard(stringgrid5, isosave[2].normal);
    end;
    if itemindex<>oldIsoDisplayIndex then
    if itemindex=0 then
    begin
      with memo7.lines do
      begin
        {1. Case1 Normal to case1 "as read"}
        {Each line maps to the same line}
        s:='';
        for i:= 0 to 14 do
        begin
          n:=isosave[1].maptoNorm[i];
          newmap1[i]:=n;
          s:=s+char(ord('A')+n);
          if i mod 3=2 then s:=s+' ';
        end;
        add('');
        add('Mapping Normalized solution back to "As read" in 2 steps');
        add('');
        add('1. Map Normalized Case1 back to "As read" Case1.');
        add('');
        add('ABC DEF GHI JKL MNO');
        add(s);

        {2. Map Case2 normal to case2 "as read"}
        {Again each line maps to same line}
        s:='';
        for i:= 0 to 14 do
        begin
          n:=isosave[2].mapToNorm[i];
          newmap3[i]:=n;
          s:=s+char(ord('A')+n);
          if i mod 3=2 then s:=s+' ';
        end;
        add('');
        add('2. Map Normalized Case2 Norm to "As read" Case2.');
        add('');
        add('ABC DEF GHI JKL MNO');
        add(s);
      end;
    end;
    oldIsoDisplayIndex:=itemindex;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.Button2Click(Sender: TObject);
var

  loops:integer;
begin
  mintime := 60;
  loops:=0;
  repeat
    inc(loops);
    searchuniquebtnclick(sender);
    if (tag=0) and (runtime<mintime) then
    begin
      label7.caption:=format('Best time %4.1f, Seed= %d',[runtime,startrandseed]);
      mintime:=runtime;
    end;
    if tag=1 then break;
    label10.caption:=inttostr(loops)+ ' solutions checked so far';
  until loops>100;


end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1; {to stop any running process which checks tag value}
  canclose:=true;
end;

end.







