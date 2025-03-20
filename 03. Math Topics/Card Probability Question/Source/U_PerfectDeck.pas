unit U_PerfectDeck;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellapi;

type
  TForm1 = class(TForm)
    StartBtn: TButton;
    Memo1: TMemo;
    Countlbl: TLabel;
    SeedEdt: TEdit;
    Label1: TLabel;
    StopBtn: TButton;
    ModeGrp: TRadioGroup;
    StaticText1: TStaticText;
    procedure StartBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
     deck:array[1..52] of integer;
     occurred: array[0..13,0..13] of boolean;
     tNbrofpairs: array[0..100] of int64;
     Nbrofpairs,Maxpairs:integer;

     procedure Shuffle;
     procedure ShowDeck(msg:string);
     function Score:integer;
     procedure ReportScore(count:integer);
     procedure SimSearch;
     procedure DepthSearch;
     procedure DeckSwap(const a,b:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************** Shuffle *******888}
procedure TForm1.shuffle;
{Shuffle the deck}
var
  i,j,temp:integer;
  begin
    for i:= 52 downto 2 do
    begin
      j:=random(i)+1;
      temp:=deck[i];
      deck[i]:=deck[j];
      deck[j]:=temp;
    end;
  end;



{************ Showdeck **********}
procedure TForm1.showdeck(msg:string);
var
  s:string;
  i:integer;
begin
  memo1.lines.add(msg);
  s:='';
  for i:=1 to 52 do s:=s+format('%2d,',[deck[i]]);
  memo1.lines.add(s);
  memo1.lines.add('');
end;

{*********** Score *******}
function TForm1.score:integer;
{Count pair matches in the current deck}
var
  i,j:integer;
  r,s:integer;
  p,q:integer;
begin
  result:=0;
  for i:=1 to 13 do for j:=1 to i do occurred[i,j]:=false;
  for i:=1 to 51 do
  begin
    p:=deck[i];
    q:=deck[i+1];
    if p<>q then
    begin
      {make r= max(p,q) and s:=min(p,q]}
      if q>p then
      begin
        r:=q;
        s:=p;
      end
      else
      begin
        r:=p; s:=q;
      end ;
      if occurred[r,s]=false then
      begin
        inc(result);
        occurred[r,s]:=true;
      end;
    end;
    if i<51 then
    begin
      q:=deck[i+2];
      if p<>q then
      begin
        if q>p then
        begin
          r:=q;
          s:=p;
        end
        else
        begin
          r:=p; s:=q;
        end ;
        if occurred[r,s]=false then
        begin
          inc(result);
          occurred[r,s]:=true;
        end;
      end;
    end;
  end;
end;

{************ ReportScore ********}
procedure TForm1.reportscore(count:integer);
begin
  showdeck('#'+inttostr(count)+': Deck with '+inttostr(Nbrofpairs) +' matches found!');
end;

{************ DeckSwap **********}
procedure TForm1.DeckSwap(const a,b:integer);
{swap two specified card positions in "Deck"}
  var temp:integer;
  begin
     temp:=deck[a];
     deck[a]:=deck[b];
     deck[b]:=temp;
   end;


{*********** StartBtnClick ***********}
procedure TForm1.StartBtnClick(Sender: TObject);
begin
  randomize;
  if modegrp.itemindex=0
  then  simsearch
  else  depthsearch;
end;



{************* SimSearch ************}
Procedure Tform1.simsearch;
{Generate random decks checking number of matches for each and displaying
 thse with 74 or more matches.}
var
  i,h,b,p,q,r,s:integer;
  count:int64;
  starttime:TDatetime;

begin
    randseed:=strtoint(seededt.text);
    memo1.lines.clear;
    application.processmessages;
    tag:=0;
    maxpairs:=0;

    for i:=0 to 100 do tNbrofpairs[i]:=0;

    for i:=1 to 52 do deck[i]:=(i-1) mod 13 +1; {make the deck}
    screen.cursor:=crHourGlass;
    count:=0;
    starttime:=now;
    repeat
      Nbrofpairs:=0;
      for h:=1 to 13 do for b:=1 to h do occurred[h,b]:=false;
      shuffle;
      for i:=1 to 51 do
      begin
        p:=deck[i];
        q:=deck[i+1];
        if p<>q then
        begin
          if q>p then
          begin
            r:=q;
            s:=p;
          end
          else
          begin
            r:=p; s:=q;
          end ;
          if occurred[r,s]=false then
          begin
            inc(Nbrofpairs);
            occurred[r,s]:=true;
          end;
        end;
        if i<51 then
        begin
          q:=deck[i+2];
          if p<>q then
          begin
            if q>p then
            begin
              r:=q;
              s:=p;
            end
            else
            begin
              r:=p; s:=q;
            end ;
            if occurred[r,s]=false then
            begin
              inc(Nbrofpairs);
              occurred[r,s]:=true;
            end;
          end;
        end;
      end;
      inc(tNbrofpairs[Nbrofpairs]);
      if Nbrofpairs>73 then showdeck('Deck with '+inttostr(Nbrofpairs) +' found!');;
      if nbrofpairs>maxpairs then maxpairs:=nbrofpairs;
      inc(count);
      if (count and (1048576-1))=0 then
      begin
        countlbl.caption:=format('Decks tested: %d, Run Seconds: %d, Max matches: %d',
                       [count, trunc((now-starttime)*secsperday), Maxpairs]);
        Seededt.text:=inttostr(randseed);
        application.processmessages;
      end;
    until (Nbrofpairs>=78) or (tag<>0) or (count=high(count));
    screen.cursor:=crdefault;
    memo1.lines.add(' Nbr of pairs    Nbr of occurrences');
    for i:=0 to 100 do
    if tNbrofpairs[i]>0
    then  memo1.lines.add(
    format('    %2d             %8d',[i,tNbrofpairs[i]]));
  end;



{************** DepthSearch **********}
procedure TForm1.depthsearch;
{Systematic pair swap "hill climbing" search}
var
  i,j,k:integer;
  newscore:integer;
  starttime:TDateTime;
  count:int64;
  solncount:integer;
  list:TStringlist;
  index:integer;
  s:string;

begin
  {List save solutions so we can check that obly unique solutions are counted}
  list:=TStringlist.create; list.sorted:=true;
  for i:=1 to 52 do deck[i]:=(i-1) mod 13 +1; {make the deck}

  {Initialization stuff}
  tag:=0;
  screen.cursor:=crHourGlass;
  starttime:=now;
  count:=0;
  solncount:=0;
  randomize;
  shuffle;
  nbrofpairs:=score;

  {start search}
  repeat
    for i:=1 to 51 do
    begin
      for j:=i+1 to 52 do
      begin
        DeckSwap(i,j);
        newscore:=score;
        {Note: if we only allow swaps which increase the score, deck will reach
         a configration with 77 matches which cannot reach 78 by this method.
         Therefore the following test is ">="  rather than strictly ">"}
        if (newscore>=nbrofpairs) or (newscore>=78) then
        begin
          nbrofpairs:=newscore;
          if newscore>=78 then
          begin
            s:='';
            for k:=1 to 51 do s:=s+format('%2d',[deck[1]]);
            if not list.find(s,index) then {make sure that it's unique}
            begin
              inc(solncount); {count solutions}
              reportscore(solncount);
              countlbl.caption:=format('Decks tested: %d, Run Seconds: %6.1f, Max matches: %d',
                   [count, (now-starttime)*secsperday, nbrofpairs]);
              Seededt.text:=inttostr(randseed);
              shuffle;
              nbrofpairs:=score;
            end;
          end;
        end
        else
        begin
          DeckSwap(i,j);   {swap them back}
        end;
        inc(count);
        if solncount>=1000 then break;
      end;
      if solncount>=1000 then break;
    end;
    
    {If the deck is not reshuffled periodically, it will reach a state where
     no solutions are found unless swaps are allowed for scores matching current score,
     which they are in this version}
    //shuffle;
    //nbrofpairs:=score;
    application.processmessages;
  until (solncount>=1000) or (tag<>0);
  screen.cursor:=crdefault;
  list.free;
end;


(*
{************** DepthSearch **********}
procedure TForm1.depthsearch;
{Random pair swap hill climbing search}
var
  i,j,k:integer;
  newscore:integer;
  starttime:TDateTime;
  count:int64;
  solncount:integer;
  list:TStringlist;
  index:integer;
  s:string;





begin
  {List save solutions so we can check that obly unique solutions are counted}
  list:=TStringlist.create; list.sorted:=true;


  for i:=1 to 52 do deck[i]:=(i-1) mod 13 +1; {make the deck}

  tag:=0;
  screen.cursor:=crHourGlass;
  starttime:=now;
  count:=0;
  solncount:=0;
  randomize;
  shuffle;
  nbrofpairs:=score;
  repeat
    i:=random(52)+1;
    repeat j:=random(52)+1 until i<>j;
      Deckswap(i,j);
      newscore:=score;
      if (newscore>nbrofpairs) or (newscore>=78) then
      begin
        nbrofpairs:=newscore;
        if newscore>=78 then
        begin
          s:='';
          for k:=1 to 51 do s:=s+format('%2d',[deck[1]]);
          if not list.find(s,index) then
          begin
            inc(solncount);
            reportscore(solncount);
          end;
          shuffle;
          nbrofpairs:=score;
        end;
      end
      else
      begin
        Deckswap(i,j);   {swap them back}
      end;
      inc(count);
    if (count and  $FFFF)=0 then
    begin
      countlbl.caption:=format('Decks tested: %d, Run Seconds: %6.1f, Max matches: %d',
                   [count, (now-starttime)*secsperday, nbrofpairs]);
      Seededt.text:=inttostr(randseed);
      application.processmessages;
    end;
    if (now-starttime)*secsperday>2 then
    begin
      shuffle;
      nbrofpairs:=score;
      starttime:=now;
    end;
  until (solncount>=1000) or (tag<>0);
  score;
  if nbrofpairs>78 then reportscore(solncount);
  screen.cursor:=crdefault;
  list.free;
end;
*)



procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
