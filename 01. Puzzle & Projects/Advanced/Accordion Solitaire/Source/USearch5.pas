unit USearch5;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UCardComponentV2;

type
  TForm2 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    initialstate:string;
    topcards:Tstringlist;
    states, movesmadeList,pathlist:TStringlist;
    bestlength:integer;
    decodedcardsList,decodedmovesList:Tstringlist;
    silent:boolean;
    newcards:string;
    function makenextmove(const level:integer):boolean;
    function makemovelist(const s:string):string;
    function solvable(const cards:string):boolean;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses U_AccordionSolitaire5;

procedure TForm2.FormCreate(Sender: TObject);
begin
  States:=TStringlist.create;
  movesmadeList:=TStringlist.create; {The movepath for each entry in states list}
  pathlist:=TStringlist.create;
  Topcards:=TStringList.create;
  Decodedcardslist:=TStringlist.create;
  DecodedMoveslist:=TStringlist.create;
end;

function suit(const ch:char):integer;
  begin
    result:=ord(ch) and 3;
  end;

  function val(const ch:char):integer;
  begin
    result:=ord(ch) shr 2;
  end;

procedure TForm2.FormActivate(Sender: TObject);
var
  c:byte;
  s,moves:string;
  i:integer;
begin

  s:='';
  for i:=0 to topcards.count-1 do
  with TCard(topcards.objects[i]) do
  begin
    c:=value shl 2 or ord(suit);
    s:=s+char(c);
  end;
  initialstate:=s;
  {build initial moves list}
  states.clear;
  movesmadelist.clear;
  pathlist.clear;

  moves:=makemovelist(s);
  states.add(initialstate);
  movesMadeList.add(moves);
  pathlist.add('');  {no moves made yet, so no path, but we need an entry to
                      keep all three lists in sync}
  if length(moves)>0 then makenextmove(0); {level}
end;

{************ MakeMoveList ***********}
function TForm2.makemovelist(const s:string):string;
{make a list of possible moves for input string of cards}
var
  i,count{,ss,v,ss1,v1,ss3,v3}:integer;
  sr:string;
begin
  result:='';
  //sr:=s+s;  {max length is twice the number of cards}
  setlength(sr,2*length(s));
  count:=0;
  for i:=2 to length(s) do
  begin
    (*  {variables version used for debugging}
    ss:=ord(s[i]) and 3;
    v:=ord(s[i]) shr 2;
    ss1:=ord(s[i-1]) and 3;
    v1:=ord(s[i-1]) shr 2;
    if (ss=ss1) or (v=v1)
      then result:=result+char((i shl 2) or 1);
    if i>3 then
    begin
      ss3:=ord(s[i-3]) and 3;
      v3:=ord(s[i-3]) shr 2;
      if (ss=ss3) or (v=v3)
      then result:=result+char((i shl 2) or 3);
    end;
    *)

    if (suit(s[i])=suit(s[i-1])) or
       (val( s[i])=val(s[i-1])) then
    begin
      inc(count);
      sr[count]:=char((i shl 2 + 1))
    end;

    if (i>3) and ((suit(s[i])=suit(s[i-3])) or
       (val( s[i])=val(s[i-3]))) then
    begin
      inc(count);
      sr[count]:=char((i shl 2 + 3));
    end;
  end;
  result:=copy(sr,1,count);
end;



var
  suitTostr:array[0..3] of char =('S','D','C','H');
  valtostr:array[1..13] of char =('A','2','3','4','5','6','7','8','9','T','J','Q','K');

function decodecard(card:byte):string;
{Make a string representing card value}
begin
  result:= valtostr[card shr 2]+suittostr[card and 3];
end;


{********* IsValidMove ********8}
function isvalidmove(const c1,c2:byte):boolean;
begin
  if ((c1 shr 2)=(c2 shr 2))
     or ((c1 and 3)= (c2 and 3))
     then result:=true
     else result:=false;
end;

function TForm2.solvable(const cards:string):boolean;
var
  i,j:integer;
  val1,suit1:integer;
  ok:boolean;
begin
  {Heuristic #1}
  {look for a card that has no matching suit or value}
  {If found, the case is unsolvable}
  result:=true;
  for i:=1 to length(cards) do
  begin
    ok:=false;
    val1:=ord(cards[i]) shr 2;
    suit1:=ord(cards[i]) and 3;
    for j:=1 to length(cards) do
    if i<>j then
    begin
      if (ord(cards[j]) shr 2 = val1) or
          (ord(cards[j]) and 3 = suit1)
      then
      begin
        ok:=true;
        break;
      end;
    end;
    if not OK then break;
  end;
  result:=Ok;
end;


{************* MakeNextMove *********}
function tform2.makenextmove(const level:integer):boolean;
var
  i:integer;
  s, moves, cards, path:string;
  newmoves,newpath:string;
  decodemove:string;
  frompos,fromdist:integer;
  done:boolean;
  loopcount,movescount:integer;
begin
  screen.cursor:=crhourglass;
  bestlength:=100;
  result:=true;
  done:=false;
  loopcount:=0;
  movescount:=0;
  with states do
  repeat  {the search loop}
    inc(loopcount);

    s:=states[0];  {get next card state, a exposed top cards of a partial game}

    if movesmadelist.count>0 then
    begin
      moves:=movesmadelist[0];
      inc(movescount,length(moves));
      path:=pathlist[0]; //else path:='';
      {process each move in the list,
        for each: make a new cards list and moves list and add the state entry
        to the states list}
      for i:=length(moves) downto 1 do
      begin
        frompos:=ord(moves[i]) shr 2;
        fromdist:=ord(moves[i]) and 3;
        cards:=s;
        newcards:=cards;
        (*
         {for debugging}
        if not isvalidmove(ord(cards[frompos]), ord(cards[frompos-fromdist]))
        then showmessage('Invalid move');
        *)
        newcards[frompos-fromdist]:=newcards[frompos];
        decodemove:=decodecard(ord(cards[frompos])){+'_to_'}+ decodecard(ord(cards[frompos-fromdist]));
        newpath:=path+','+decodemove;
        system.delete(newcards,frompos,1);
        {update or make a new moves list}
        {add states entry for this move to the states list}
        newmoves:=makemovelist(newcards);

        if length(newcards)=1 then done:=true;
        if states.indexof(newcards)<0 then
        if (not form1.heuristics) or (form1.heuristics and solvable(newcards)) then
        begin  {This is a new state, save the entry at the end of the queues}
          states.add(newcards);
          movesmadelist.add(newmoves);
          pathlist.add(newpath);
        end;
        if loopcount and  1023 = 0 then
        begin
          form1.memo1.lines[2]:=format('%d States, %d Moves checked, %d Piles, %d States left',
                                   [loopcount,movescount, length(newcards),states.count]);
          application.processmessages;
        end;
      end;
    end;
    states.delete(0);  {delete the entry just processed}
    MovesMadeList.delete(0);
    pathlist.delete(0);
    if length(newcards)<bestlength then
    begin
      bestlength:=length(newcards);
    end;
  until done or (states.count<=1) or (tag<>0);
  screen.cursor:=crdefault;
  pathlist.commatext:=newpath;
  for i:=1 to pathlist.count-1 do
  {skip pathlist entry 0, the dummy entry added at start of search}
  begin
    s:=pathlist[i];
    pathlist[i]:=copy(s,1,2)+'_to_'+copy(s,3,2);
  end;

  if silent then
  begin
    modalresult:=mrOK;
    close;
  end;
end;

end.

