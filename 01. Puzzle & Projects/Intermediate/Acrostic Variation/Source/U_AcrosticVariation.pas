unit U_AcrosticVariation;
{Copyright © 2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{//$DEFINE Debug}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, strutils, dialogs, jpeg;

type

  TRulesrec=record {built for each horizontal/vertical intersection rule. Position
    numbers were assigned for each word position in each direction and the letter
    position within the word are specified.  For each rule, a list of the intersecting
    word pair which would meet the condition is attached to the rules record}
    hwordnbr, vwordnbr:integer;
    hletterpos,vletterpos: integer;
    HKey,VKey:string[2];
    candidates:TStringList;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Image1: TImage;
    Label6: TLabel;
    Memo1: TMemo;
    Memo7: TMemo;
    TabSheet2: TTabSheet;
    Image2: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Memo3: TMemo;
    SearchBtn: TButton;
    Intersectsmemo: TMemo;
    ResultsMemo: TMemo;
    PrePlacedmemo: TMemo;
    Words: TMemo;
    SortGrp: TRadioGroup;
    Label3: TLabel;
    PrintBtn: TButton;
    PrintDialog1: TPrintDialog;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SortGrpClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
  public
   NbrWords, NbrRules:integer;
   WordsByGridPos:array of smallint;
   rulesrecs:array of TRulesrec; {for each intersection rule horizontal word position, a
                            list of horizontal/vertical word pairs which would
                            satisfy each intersection rule}
   assignedList:TStringlist; {Name-Value list of all given words with indication
   of whether or not they have bneen assigned a location.  Used by CheckCandidates
   function to associate words with locations}
   originalruleslist:TStringlist;

   {variables for calculation timing and complexity}
   starttime:TDateTime;
   assignedCount, RetractedCount:integer;
   procedure BuildRulesRecs;
   function CheckCandidates(rulenbr:integer):boolean;
   procedure CleanupWordsList;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

 var delims:set of char = ['(',')',',',' ']; {deliminators for GetWord function}

 {*********** GetWord ***********}
 Function getword(var s,w:string):boolean;
   {destructive word retrieval: the returned word and the trailing deliniter  are
    deleted from the input string so that successive calls will return all words
    in the string}
   var i:integer;
   begin
     result:=false;
     trimleft(s);
     w:='';
     if length(s)=0 then exit;
     i:=1;
     while (i <=length(s)) and (s[i] in delims) do inc(i);
     delete(s,1,i-1);  {remove  any leading delimiters}
     i:=1;
     {scan for delimiter or end of string}
     while (i <=length(s))and not (s[i] in delims) do inc(i);
     if (i>1) and (i<=length(s)+1) then
     begin
       w:=ANSIUppercase(copy(s,1,i-1)); {extract the word}
       delete(s,1,i); {delete the wird and delimiter from the input string}
       result:=true;
     end;
   end;

{********** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  pagecontrol1.activepage:=Tabsheet1;
  assignedlist:=TStringlist.create;
  originalruleslist:=Tstringlist.create;
  originalruleslist.text:=intersectsmemo.lines.text;
  buildrulesrecs;
end;

{************ CheckCandidates *************}
function TForm1.checkcandidates(rulenbr:integer):boolean;
{Recursive function to check all candidates for a solution}
var
  i:integer;
  H,V:string;
  s,w1,w2:string;
begin
  result:=false;
  if rulenbr>=nbrrules then
  begin
    dec(assignedcount);  {we counted last pass as assigned, decrement it}
    with words, lines do
    for i:=0 to count-1 do
    lines[i] := lines[i]+'='+assignedlist.values[words.lines[i]];
    result:=true;
  end
  else
  {$ifdef debug}
       ResultsMemo.lines.add(format('Checking rule %d: %s',[rulenbr,intersectsmemo.lines[rulenbr]]));
  {$Endif}
  with rulesrecs[rulenbr] do
  if candidates.count>0 then
  for i:=0 to candidates.count-1 do
  begin
    s:=candidates[i];
    getword(s,w1);
    getword(s,w2);
    H:=assignedlist.values[w1];
    V:=assignedlist.values[w2];

    {$ifdef debug}
       ResultsMemo.lines.add(format('   Candidate(%s(%s),%s(%s))',[w1,H,w2,V]));
    {$Endif}
    if ((H=HKey) or (H='N') )
       and ((V=VKey) or (V='N'))
    then
    begin
      If h='N' then assignedlist.values[w1]:=HKey;
      If v='N' then assignedlist.values[w2]:=VKey;
      {$ifdef debug}
       ResultsMemo.lines.add(format('      Assigned(%s(%s),%s(%s) Moving to next rule',[w1,Hkey,w2,VKey]));
      {$Endif}
      inc(assignedCount);
      result:=checkcandidates(rulenbr+1);
      if not result then
      begin
        assignedlist.values[w1]:=H; {Restore previous values}
        assignedlist.values[w2]:=V;
        inc(retractedcount);
      end;
    end;
    if result then break; {solved, stop after 1st solution found}
  end;
end;

procedure TForm1.CleanupWordsList;
{Reset Words memo which may have had a previous solution appended to entries}
begin
  words.lines.text:=memo7.lines.text;
  
end;

{************ BuildRulesrecs ***********}
procedure TForm1.BuildRulesRecs;
var
  i,j,k:integer;
  s,w,w1,w2:string;
begin
  cleanupWordsList;
  nbrRules:=intersectsMemo.lines.count;
  if length(rulesrecs)= 0 then setlength(rulesrecs,nbrrules)
  else for i:=0 to high(rulesrecs) do rulesrecs[i].candidates.free;
  with intersectsmemo do
  for i:=0 to lines.count-1 do
  with rulesrecs[i] do
  begin
    rulesrecs[i].candidates:=TStringlist.create;
    s:=lines[i];
    getword(s,w);
    Hkey:=w;
    delete(w,1,1);
    hwordnbr:=strtointdef(w,0);   {Get the 1st word position number}
    getword(s,w);
    hletterpos:=strtointdef(w,0); {1st word position number}
    getword(s,w);
    VKey:=w;
    delete(w,1,1);
    vwordnbr:=strtointdef(w,0);   {Get the 2nd word position number}
    getword(s,w);
    vletterpos:=strtointdef(w,0); {2nd word position number}
    with words do {go through list of word and select pairs that meet
                    intersection criteria}
    for k:=0 to lines.count-1 do
    begin
      w1:=lines[k];
      for j:=0 to lines.count-1 do
      if j<>k then
      begin
        w2:=lines[j];
        if w1[hletterpos]=w2[vletterpos]
        then candidates.add(w1+','+w2);
      end;
    end;
    //{debug} memo3.lines.add(intersectsmemo.lines[i]+ ':'+inttostr(candidates.count));
  end;
  application.processmessages;
end;

{******** SearcBtnClick *************}
 procedure TForm1.SearchBtnClick(Sender: TObject) ;
 Var
   i,j:integer;
   s:string;
   R:boolean;
 begin
   {Strategy:
     We're going to go through the intersection rules list and put all of the
     words that could be in each position into the "Candidates" word lists
    regardless of whether it could cause conflicts later on.

    Then we'll use a depth first search to step through the Candidate word list
    for each rule until we get all of the words placed with no errors
   }

   {Build candidate lists}
   buildrulesrecs;
   {Initialize list of all words marked as unassigned}
   assignedlist.clear;
   with resultsmemo do
   begin
     lines.clear;
     lines.add('Searching');
     update;  {needed to force dispay update}
   end;
   with words do
   begin
     for i:=0 to lines.count-1 do
     begin
       s:=lines[i];
       assignedlist.add(lines[i]+'=N');
     end;
   end;
   {candidate lists built, now perform recursive search to find out which set
    satisfies the requirements}
   assignedcount:=0;
   retractedcount:=0;
   starttime:=now;
   screen.cursor:=crHourglass;
   r:=checkcandidates(0);
   with ResultsMemo do
   begin
     lines.clear;
     if not r then lines.add('No solution found') else lines.add('Solved!');
     lines.add(format('Run time: %.1f seconds',[secsperday*(now-starttime)]));
     lines.add(format('%d trail placements, %d retracted',[AssignedCount, RetractedCount]));
   end;
   screen.cursor:=crdefault;
 end;


{*************** SortGrpClick *************}
procedure TForm1.SortGrpClick(Sender: TObject);
{Sort rules in one of several ways to see effect on solve time}
var
  i,j:integer;
  HCi,HCj:integer;
  HCounts:array[1..10] of integer;
    {------ Swap ----------}
    procedure swap(i,j:integer);
    begin
      intersectsmemo.lines.exchange(i,j);
      BuildRulesRecs;
    end;

begin
  BuildRulesRecs; {Reset rulesrecs array befopre sorting}
  resultsmemo.clear;
  resultsmemo.lines.add('Search results:');
  case sortGrp.itemindex of
   0:  {Original order by (horizontal word position #}
    begin
      intersectsmemo.lines.text:=originalrulesList.text;
    end;
   1: {sort by decreasing number of candidate words for each location}
    begin
      for i:=0 to nbrrules-2 do
      for j:=i+1 to nbrrules-1 do
      begin
        if rulesrecs[i].candidates.count > rulesrecs[j].candidates.count
        then swap(i, j);
      end;
    end;
  2: {Sort rules by decreasing number of intersections in horizontals words}
   begin
     intersectsmemo.lines.text:=originalrulesList.text;  {reset rules back to original order}
     for i:=1 to 10 do Hcounts[i]:=0;
     with intersectsmemo do
     begin
       for i:=0 to nbrrules-1 do
       inc(hcounts[rulesrecs[i].HWordNbr]);
       for i:=0 to nbrrules-2 do
       for j:=i+1 to nbrrules-1 do
       begin
          hci:=HCounts[rulesrecs[i].HWordnbr];
          hcj:=Hcounts[rulesrecs[j].HWordnbr];
          if (HCi <= HCj) then swap(i, j);
       end;
     end;
   end;
 end; {case}
end;

{************ PageControl1Change ***********}
procedure TForm1.PageControl1Change(Sender: TObject);
{Improve indentification if currently selected tab}
var i:integer;
begin
  with TPageControl(sender) do
  begin
    for i:=0 to pagecount-1 do
    begin
      pages[i].borderwidth:=0;
      Pages[i].highlighted:=false;
    end;
    activepage.borderwidth:=2;
    activepage.highlighted:=true;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************ PrintBtnClick *************}
procedure TForm1.PrintBtnClick(Sender: TObject);
begin
  if Printdialog1.execute then print;
end;

end.
