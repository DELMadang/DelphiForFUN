unit U_wordladder;
{Copyright  © 2001-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }                         

 {Word Ladders transform one word to another one letter at a time with
 each intermediate letter arrangement forming a valid word}

 {This program is an auto-solver using the UDict component to extract
  word lists for checking.  Both depth-first and breadth-first solution
  searches are implemented}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellapi, ExtCtrls;

type
  TWordLadderForm = class(TForm)
    StaticText1: TStaticText;
    Bevel1: TBevel;
    StepsLbl: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StopBtn: TButton;
    FromEdt: TEdit;
    ToEdt: TEdit;
    DFSolveBtn: TButton;
    SolutionListBox: TListBox;
    MaxWordsEdt: TEdit;
    MaxLevel: TUpDown;
    BFSolveBtn: TButton;
    ListBox2: TListBox;
    Memo1: TMemo;
    LoadBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure DFSolveBtnClick(Sender: TObject);
    procedure BFSolveBtnClick(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    target:ansistring;
    solving:boolean;
    maxwords:integer;  {max steps in solution}
    wordlist:Tstringlist;  {list of all valid words of required length}
    
    function makeDFladder(w:ansistring;prevpos:integer):boolean;
    function makeBFLadder(w:ansistring;prevpos:integer):boolean;
    Procedure Solveit(Depthfirst:boolean);
  end;

var
  WordLadderForm: TWordLadderForm;

implementation

{$R *.DFM}

Uses UDict;

{local rotuines }

 function lettersdiff(w1,w2:ansistring; var changed:integer):integer;
 {result = number of w1 letters not matching corresponding position of w2}
 {changed = last position not matching}
      var
        i:integer;
      begin
        result:=0;
        {changed:=0;}
        for i:= 1 to length(w1) do
          if w1[i]<>w2[i] then
          begin
           inc(result);
           {if changed=0 then} changed:=i;
          end;
      end;


{******************** TForm1.FormCreate **************}
procedure TWordLadderForm.FormCreate(Sender: TObject);
begin
  wordlist:=TStringList.create;
  StopBtn.bringtofront;  {bring invisible stop button to front , over solve buttons}
end;

procedure TWordLadderForm.FormActivate(Sender: TObject);
begin
  If application.mainform=self then
   begin
     if not pubdic.dicloaded then  pubDic.Loadlargedic; {load the default loaded}
     caption:='Unscramble - Dictionary: '+ pubdic.dicname;
     loadbtn.visible:=true;
   end
   else
   begin
     caption:='Unscramble - Current Dictionary:'+pubdic.dicname;
     {loadbtn.visible:=false; } {08/04 might as well leave it visible}
   end;
end;

{******************  TForm1. MakeDFLadder *******************}
function TWordLadderForm.MakeDFLadder(w:ansistring;prevpos:integer):boolean;
{Make depth first ladder}
{make a list of all words matching input word in length with a single
 letter changed}
{ set score based on letters matching target word}
{ sort list with most matches first}
{process list -
  get next word
  if target word - done
  otherwise add word to ladder and make recursive call
  end of list - remove word & exit
 }

var
  list:TStringlist;
  i,n:integer;
  newword:ansistring;
  changedpos, dummy:integer;
begin
  result:=false;
  if length(w)=0 then exit;
  if SolutionListBox.items.count>=MaxLevel.position then exit;
  list:=Tstringlist.create;
  list.sorted:=true;
  SolutionListBox.items.add(w);
  newword:=lowercase(w);
  application.processmessages;
  for i:= 0 to wordlist.count-1 do
  begin
    newword:=wordlist[i];
    if (length(newword)>0) then
    begin
      if (lettersdiff(w,newword,changedpos)=1 ) {differs in one postion}
        and (changedpos<>prevpos) {don't change same position twice in a row}
        and (SolutionListBox.items.indexof(newword)<0) {not used yet}
      then
      begin
        n:=lettersdiff(newword,target,dummy);
        if n=1 then {hey - it's a solution!, Might as well stop here}
        begin
          result:=true;
          SolutionListbox.items.add(newword);
          list.free;
          exit;
        end
        else list.add(format('%2d%2d', [n, changedpos]) +newword);
      end;
    end;
  end;
  i:=0;
  while (tag=0) and (result=false) and (i<=list.count-1)do
  begin
    changedpos:=strtoint(copy(list[i],3,2));
    newword:=copy(list[i],5,length(list[i])-4);
    result:=makeDFLadder(newword,changedpos);
    inc(i);
  end;
  if not result then SolutionListBox.items.delete(SolutionListBox.items.count-1);
  list.free;  {delete temp list}
end;




{******************** TForm1.MakeBFLadder *********************}
function TWordLadderForm.makeBFLadder(w:ansistring;prevpos:integer):boolean;
{Breadth first search}
 {Initially - }
 {make a list of all words matching input word in length with a single
 letter changed, each list entry has an associated object containing the
 chain of words that got us to that word (just used to display the answer)}
{set score based on letters matching target word}
{sort list with best matches first}
{process list -
  get next word
  if target word - done
  otherwise add word to nextlevel list and add the current word to its
    prevwords list
  at end of list - assign nextlevel list to current level list and
  start search again }

var
  CurrentLevelList:TStringlist;
  NextLevelList:TStringList;
  i,j:integer;
  newword, currword, ww, msg:ansistring;
  n, changedpos, dummy, level:integer;
  currlist, nextlist:TStringList;
begin
  result:=false;
  SolutionListBox.clear;
  if length(w)=0 then exit;
  CurrentLevelList:=Tstringlist.create;
  Nextlevellist:=TStringList.create;
  nextlevellist.sorted:=true;
  nextlevellist.duplicates:=dupignore;
  newword:='00'+uppercase(w); {make the initial list}
  currentlevellist.addobject(newword,TStringlist.create);
  level:=0;
  while   (result=false) and (tag=0) and (currentlevellist.count>0)
      and (level<maxlevel.position) do
  with SolutionListbox do
  begin
    inc(level);
    if currentlevellist.count>1 then msg:=' words ' else msg:=' word ';
    items.add('Checking '+inttostr(currentlevellist.count)+ msg);
    items.add('   at level '+inttostr(level));
    itemindex:=items.count-1;

    application.processmessages;
    for i:= 0 to currentlevellist.count-1 do
    begin
      currword:=copy(currentlevellist[i],3,length(currentlevellist[i])-2);
      currlist:=TStringlist(currentlevellist.objects[i]);
      currlist.add(currword);
      for j:= 0 to wordlist.count-1 do
      begin
        newword:=wordlist[j];
        if (lettersdiff(currword,newword,ChangedPos)=1 ) {differs in one postion}
        then
        begin
          n:=lettersdiff(newword,target,dummy);
          if n<=1 then   {solution!}
          with SolutionListBox.items do
          begin
            {this word will produce a solution - we might as well call it solved
             now and saved detecting the solution when next level becomes current}
            result:=true;
            assign(currlist); {put solution in listbox}
            add(newword);     {add this word}
            break;
          end
          else
          begin
            ww:=format('%2d', [n])+newword;
            if    (currlist.indexof(newword)<0) {not a predecessor}
              and (currentlevellist.indexof(ww)<0) {not used yet at currentlevel}
            then
            begin
               nextlist:=TStringlist.create;
               nextlist.assign(currlist);
               NextLevelList.addobject(ww,nextlist);
            end;
          end;
        end;
      end;
      application.processmessages;
      if result or (tag<>0) then break;
    end;
    if not result then
    begin
      for j:=0 to currentlevellist.count-1
      do TStringlist(currentlevellist.objects[j]).free;
      CurrentLevelList.clear;
      currentlevellist.addstrings(nextlevellist);
      nextlevellist.clear;
    end;
  end;
end;



{******************* TForm1.Solveit ****************}
Procedure TWordLadderForm.Solveit(Depthfirst:boolean);
{Common wrapper code for Depth or Breadth first solution methods}

   procedure makefile(filename:ansistring; size:integer);
      var
        list:TStringlist;
        newword:ansistring;
        a,f,c:boolean;
      begin
        list:=TStringList.create;
        pubdic.setrange('a',size,'z',size);
        while pubdic.getnextword(newword,a,f,c) do
        begin
          if (length(newword)>0) and (not (a or f))
          then list.add(uppercase(newword))
        end;
        list.savetofile(filename);
        list.free;
      end;

var
  filename:ansistring;
  r: boolean;
begin

  if not solving then
  begin
    StopBtn.visible:=true;
    solving:=false;
    tag:=0;
    solving:=true;
    stepslbl.visible:=false;
    screen.cursor:=crHourGlass;
    If length(FromEdt.text)=length(ToEdt.text) then
    begin
      Target:=uppercase(ToEdt.text);
      SolutionListBox.clear;
      filename:=extractfilepath(application.exename)
                +'Words'+inttostr(length(FromEdt.text))
                +'.txt';
      if not fileexists(filename) then makefile(filename,length(FromEdt.text));
      if fileexists(filename) then
      begin
        wordlist.clear;
        wordlist.loadfromfile(filename);
        if depthfirst then R:=MakeDFLadder(uppercase(FromEdt.text),0)
        else r:=MakeBFLadder(uppercase(FromEdt.text),0);
        If not r then SolutionListBox.items.add('No solution found')
        else
        with SolutionListBox do
        begin
          Stepslbl.visible:=true;
          Stepslbl.caption:=inttostr(items.count)+' Steps';
          items.add(target);
        end;
      end
      else showmessage('Couldn''t build word list');
    end
    else showmessage('Start and End words must be the same length');
  end
  else tag:=1; {set stop flag}
  stopbtn.visible:=false;
  solving:=false;
  screen.cursor:=crDefault;
end;

{***************** TForm1.DFSolvedBtnClick **************}
procedure TWordLadderForm.DFSolveBtnClick(Sender: TObject);
begin
  Solveit(true); {call depth-first solve wrapper}
end;

{***************** TForm1.BFSolveBtnClick ***************}
procedure TWordLadderForm.BFSolveBtnClick(Sender: TObject);
begin
  Solveit(false); {Call breadth-first solve wrapper}
end;

procedure TWordLadderForm.ListBox2Click(Sender: TObject);
{select and prepare a sample puzzle}
var
  w:ansistring  ;
  p:integer;
begin
  w:=listbox2.items[listbox2.itemindex];
  p:=pos('-',w);
  If p>1 then
  begin
    fromEdt.text:=trim(copy(w,1,p-1));
    ToEdt.text:=trim(copy(w,p+1,length(w)-p));
    SolutionListBox.clear;
  end;
end;

procedure TWordLadderForm.StopBtnClick(Sender: TObject);
begin
   Tag:=1; {set a flag to gracefully stop solving}
end;

procedure TWordLadderForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  tag:=1;
  canclose:=true;
end;

procedure TWordLadderForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  tag:=1;
  action:=cahide;
end;

procedure TWordLadderForm.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



procedure TWordLadderForm.LoadBtnClick(Sender: TObject);
begin
  with DicForm.opendialog1 do
  begin
    initialdir:=extractfilepath(application.exename);
    if execute then
    begin
      pubdic.loadDicFromFile(filename);
      caption:='WordLadder - Current Dictionary:'+pubdic.dicname;
    end;
  end;
end;

end.
