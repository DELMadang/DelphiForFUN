unit U_JumpFrogs;

{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
 Someone sent me the "Jumping Frogs" puzzle a while ago:
six frogs on seven lily pads which must exchange places, the
three on the left end up on the right and those on the right end
up on the left.  The rules are:

1. Frogs can move one space into the empty stone or jump
over one frog to land oh the empty stone.
2. Frogs cannot turn around and can only move or jump in the
direction they are facing.

Search the web for "Jumping Frogs Puzzle" to find online
playable versions.  The one that is an Excel XLS file uses
Flash and purported to be French but the language is
Portuguese (and if you save the file and check properties,
Author and Company appear to be Chinese characters).
Note that Vista and IE8 warned me me that the game wanted
to contact the Internet after I solved the puzzle.
I declined the offer.

This program is mainly a check of my GraphSearch unit to
see how many solutions exist. There appears to be only two
solutions, mirror images of each other.

You can try your hand at my simple graphics version by
clicking on the frog to move.  My version has the advantage
that you can undo the last move by clicking on the blank
space.
*)

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UComboV2, UTGraphSearch, DFFutils, ExtCtrls, Grids,
  jpeg;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Image3: TImage;
    Label1: TLabel;
    Image2: TImage;
    Memo1: TMemo;
    Memo2: TMemo;
    StringGrid1: TStringGrid;
    SolveBtn: TButton;
    ResetBtn: TButton;
    SearchTypeGrp: TRadioGroup;
    StaticText1: TStaticText;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure ResetBtnClick(Sender: TObject);
  public
    Graph:TGraphlist;
    startcount1, startcount2:int64; {used in computing solution search times}
    mode:string; {'Manual' or 'Auto', Set by SolveBtnClick, used by MakeMove}
    procedure MakeMove(from,too:integer);
    procedure Goalfound; {returns a list of nodes leading from start position to
                          target position}
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  frogs:string='LLL_RRR';

{*********** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  reformatMemo(memo2);
  with stringgrid1 do
  begin
    height:=image3.height+2;
    width:=7*image3.Width+7;
    defaultrowheight:= image3.Height;
    defaultcolwidth:=image3.Width;
  end;
  graph:=TGraphlist.create;
  resetbtnclick(sender);
  mode:='Manual';
end;

{-------- Move ------}
  procedure TForm1.MakeMove(from,too:integer);
  {Make the move}
  var
    ch:char;
    i:integer;
    s:string;
  begin
    with stringgrid1 do
    begin
      ch:=cells[from,0][1];
      cells[from,0]:=cells[too,0];
      cells[too,0]:=ch;
      s:=cells[0,0]; {build the move string to display}
      for i:=1 to 6 do s:=s+cells[i,0];
      memo1.lines.add(s);
      if (mode[1]='M') and (s='RRR_LLL')
      then showmessage('You did it. Congratulations!!!');
    end;

  end;


{************ StringGrid1SelectCell ************}
procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
{User clicked to move or "unmove" a frog}
 var
   i:integer;
   s:string;
begin
  with stringgrid1,memo1 do
  begin
    case cells[acol,arow][1] of
      'L':
      begin
        {Check move or jump to the right}
        if (acol<6) and (cells[acol+1,arow]='_') then Makemove(acol,acol+1)
        else if (acol<5) and (cells[acol+2,arow]='_') then Makemove(acol,acol+2);
      end;
      'R':
      begin
        {Check move or jump to left}
        if (acol>0) and (cells[acol-1,arow]='_') then Makemove(acol,acol-1)
        else if (acol>1) and (cells[acol-2,arow]='_') then Makemove(acol,acol-2);
      end;
      '_' : {Clicking the blank space will undo a move}
      begin
        if Lines.count>1 then
        begin
          s:=lines[lines.count-2];
          for i:=1 to 7 do cells[i-1,0]:=s[i];
          Lines.Delete(lines.count-1);
        end;
      end;
    end;
  end;
end;

{********** StringGrid1DrawCell *************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw the proper frog type (or the space) in each cell when it changes}
begin
  with stringgrid1, canvas do
  begin
    brush.color:=rgb(102,204,255); {ligh blue}
    pen.Color:=brush.color;
    rectangle( rect); {Clear the cell rectangle}
    with rect do
    Case stringgrid1.cells[acol,arow][1] of
      'L': draw(Left, Top, image2.Picture.graphic); {Left side (right facing) frog}
           //stretchdraw(rect, image2.Picture.graphic); {Left side (right facing) frog}

      'R': draw(Left, Top, image3.Picture.graphic); {Right side (left facing) frog}
          //stretchdraw(rect, image3.Picture.graphic); {Left side (right facing) frog}
    end;
  end;
end;

{******* ResetBtnClick *********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i:integer;
begin
  memo1.clear;
  with stringgrid1 do
  for i:=0 to 6 do cells[i,0]:=frogs[i+1];
  memo1.lines.add('LLL_RRR');
end;

{************ SolveBtnClick ************}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  List:TStringList;
  s:string;
  i,j, index:integer;

  {--------- MakeEdge ---------}
  procedure makeEdge(i,j:integer);
    var
      s2:string;
      ch:char;
    begin
      s2:=s;
      ch:=s2[i];
      s2[i]:=s2[j];
      s2[j]:=ch;
      Graph.addedge(s,s2,1); {almost forgot, we must add one weight (1 in this
                              case) to make the graph unidirectional}
    end;


begin
  resetbtnclick(sender);
  application.ProcessMessages;
  mode:='Auto';
  queryperformancecounter(startcount1);
  List:=TStringList.create;  {list to hold the unique frog arrangements}
  List.Sorted:=true;
  graph.clear;
  memo1.Clear;
  with combos do
  begin
    setup(7,7,Permutations); {check all permutations of 7 things (6 frogs, 1 blank}
    while getnextpermute do
    begin
      s:='';
      for i:=1 to 7 do s:=s+frogs[selected[i]];
      {Add only the unique permutations of frogs to a list}
      if not list.Find(s,index) then list.add(s);
    end;
    //showmessage('There are '+inttostr(list.Count)+' unique frog arrangements');
  end;

  {Make a GraphList of paths from LLL_RRR to RRR_LLL when _ can be exchanged with an
  L one or two positions to its left or with an R one or two positions to the right.

  If x and y represent the remainder of unspecified letters, z represents a
  single R or L, then the move rules are:

  1: xL_y can change to x_Ly
  2: x_Ry can change to R_
  3: xLz_y can change to x_xLy
  4: x_zR<y can change to xRz_y
  }
  with Graph do
  begin
    for i:=0 to list.Count-1 do addnode(list[i]);

    for i:=0 to list.Count-1 do
    begin
      s:=list[i];
      {find the _ check against the 4 rules, and create edges for those that
      are satisfied}
      {The final graph will have "edges" connecting each position with the valid
       positions from there after a move}
      j:=1;

      {Find the blank space}
      while (j<=length(s)) and (s[j]<>'_') do inc(j);
      if s[j]='_' then
      begin  {if a rule is satisfied, then
        {Rule1} If (j>1) and (s[j-1]='L') then  makeedge(j-1,j);
        {Rule2} If (j>2) and (s[j-2]='L') then makeedge(j-2,j);
        {Rule3} If (j<length(s)) and (s[j+1]='R') then makeedge(j,j+1);
        {Rule4} If (j<length(s)-1) and (s[j+2]='R') then makeEdge(j,j+2);
      end
      else
      begin
        showmessage('System error: No blank in position '+s);
        exit;
      end;
    end;
    finalize;
    queryperformancecounter(startcount2);
    case SearchTypeGrp.itemindex of
      1:  {Breadth first search}
         MakePathsToBF('LLL_RRR','RRR_LLL', 140, GoalFound);
      0: {Depth first search - same result}
         MakePathsToDF('LLL_RRR','RRR_LLL', 140, GoalFound);
    end;
  end;
  Mode:='Manual';
end;

{********* GoalFound ********}
procedure TForm1.Goalfound;
{Called when a solution is found from the search}
var
  N:TNode;
  i,j:integer;
  s,sprev:string;
  from,too:integer;
  stopcount,freq:int64;
begin
  queryperformancecounter(stopcount);
  queryperformancefrequency(freq);
  memo1.lines.add('Solution search results');
  memo1.lines.add('------------------');
  with Graph do
  for i:=0 to q.count-1 do
  begin
    n:=TNode(q[i]);
    s:=graph[n.index];
    if i>0 then
    with stringgrid1 do
    begin
      for j:=1 to 7 do if s[j]<> sprev[j] then
         if s[j]='_' then from:=j-1 else too:=j-1;
      makemove(from, too);
      stringgrid1.Update;
      sleep(1000);
    end
    else memo1.Lines.add(s);
    sprev:=s;
  end;
  memo1.Lines.add(format('Graph build time: %6.3f milliseconds',
         [1000*(startcount2-startcount1) / freq]));
  memo1.Lines.add(format('Search time: %6.3f milliseconds',
           [1000*(stopcount-startcount2) / freq]));
end;

end.
