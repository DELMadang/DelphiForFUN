unit U_Akerue4;

 {Copyright  © 2001, 2006. 2014, 2016 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{ToDo}
  {track high scores}
  {save/restore games}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls, Grids, mmsystem, ShellAPI, UDict, ComCtrls,
  Inifiles, UCountDownTimer, types, DFFUtils ;

type
  char=ansichar;
  TStatus=(starting, started, autosolving, complete, stopping);
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ScoreLbl: TLabel;
    MaxScorelbl: TLabel;
    DicGrp: TRadioGroup;
    BoardGrid: TStringGrid;
    NewWordEdt: TEdit;
    ListBox1: TListBox;
    Memo2: TMemo;
    MainMenu1: TMainMenu;
    Dictionaries1: TMenuItem;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    Memo1: TMemo;
    Options1: TMenuItem;
    TimeOption: TMenuItem;
    Set1: TMenuItem;
    Setdefaultdictionaries1: TMenuItem;
    WordSheet: TTabSheet;
    NewBtn: TButton;
    ReplayBtn: TButton;
    ValidWordDisplayList: TMemo;
    IgnorewordDisplayList: TMemo;
    Label1: TLabel;
    Label3: TLabel;
    StatusBar1: TStatusBar;
    WordActionLbl: TLabel;
    Memo3: TMemo;
    BoardSizeGrp: TRadioGroup;
    Sound1: TMenuItem;
    N1: TMenuItem;
    Colors1: TMenuItem;
    StaticText1: TStaticText;
    Panel1: TPanel;
    StartBtn: TMemo;
    {procedure FormCreate(Sender: TObject);}
    procedure Timer1Timer(Sender: TObject);
    procedure StartBtnClick(Sender: TObject);
    procedure BoardGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ShowallBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BoardSizeGrpClick(Sender: TObject);
    procedure BoardGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BoardGridDblClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ReplayBtnClick(Sender: TObject);
    procedure Set1Click(Sender: TObject);
    procedure BoardGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Setdefaultdictionaries1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1Click(Sender: TObject);
    procedure WordSheetEnter(Sender: TObject);
    procedure DicGrpClick(Sender: TObject);
    procedure SetDicnames;
    procedure SaveDicnames;
    procedure Sound1Click(Sender: TObject);
    procedure TimeOptionClick(Sender: TObject);
    procedure Colors1Click(Sender: TObject);
    procedure NewWordEdtChange(Sender: TObject);
  public
    cumfreqs:array['a'..'z'] of integer;
    boardsize:TPoint;  {rows and columns for current level}
    totfreqcount:integer;
    initialized:boolean;
    WordListbuilt:boolean;

    {array of letters used in current word}
    selectedletters: array [0..6, 0..6] of boolean;
    Score, WordCount, Maxscore: integer;

    AllWords:TStringList; {list to store words found by CalcAllWords procedure}
    UserWords:TStringlist; {list of valid words entered by the user}
    Expandedwordlist:TStringList;
    status:TStatus;
    highlightpoint:TPoint; {used during autosolve by OnDrawCell to highlight }
    invalidword:ANSIString;  {last word flagged as invalid - right click will add it
                          to added word list}
    mouseinput:boolean; {Input mode is mouse - set when first letter of a word
                         is entered.  False ==> keyboard input}
    programwords:integer;
    pathname,exepath:ANSIString;

    OKSound, InvalidSound, AddWordSound: pointer;
    timelimits:array[0..2] of integer;
    timelimit:integer;

    Dicname:array [0..2] of ANSIString;
    AddedWordList, IgnoredWordList:TStringList; {users changes for dictionary}
    Addedname, Ignoredname:array[0..2] of ANSIString;
    currentDicindex:integer;

    GameTimer:TCountdown;

    procedure Initialize;    {One time initialization}
    function couldbeword(pdic:TDic; w:ANSIString; var isword:boolean):boolean;
    function addtolist(w:ANSIString; list:TStringList):boolean;
    procedure reset; {reset items before solving}
    procedure clearselected;
    procedure savewordlists;


    procedure CalcAllWords; {Search for all words}
    procedure zeroboard;  {Clear out path tracking array}
    procedure zeropaths;
    procedure clearwordLists;
    Procedure setup; {Set up to start current game or replay it}
    {recursive search for all words}
    procedure getnextpath(startpoint:TPoint;var pathstring:ANSIString);
    {recursive search for word that could be formed}
    function IspathTo(w:ANSIString):boolean;

    Procedure TimeExpired(sender:TObject);
    procedure StartTimer;

    {Play wave sounds in response to clicks}
    procedure PlayOK;
    procedure PlayWordAdded;
    procedure PlayInvalid;
  end;

var
  Form1: TForm1;

implementation

uses U_TimeDlg, U_SelDicDlg;

{$R *.DFM}


const
  {number of occurrences per 1000 characters}
  letterfreqs:array['a'..'z'] of integer =
  { a  b  c  d  e   f  g  h  i j  k  l  m}
  (86,31,47,31,114,22,23,28,79,2,12,55,32,
  { n  o  p q  r  s  t  u  v  w x  y z}
   64,71,33,3,75,55,75,37,16,14,5,29,4);
  {
  (73,9,30,44,130,28,16,35,74,2,3,35,25,
  78,74,27,3,77,63,93,27,13,16,5,19,1);   }

  {word scores basd on length}
  scoring:array[3..10] of integer=(1,2,3,4,5,10,15,20);

var
  paths:array of array of integer;
  pathcount:integer;
  offsets:array[1..8] of TPoint=((x:-1;y:-1),(x:0;y:-1),(x:+1;y:-1),(x:+1;y:0),
                                 (x:+1;y:+1),(x:0;y:+1),(x:-1;y:+1),(x:-1;y:0)) ;
  frompoint:TPoint;
  lastpoint:TPoint;

  {The function Borland forgot}
function Makelowcase(c:ANSIchar):ANSIchar;
begin
  if c in ['A'..'Z'] then result:=char(ord(c) or $20)
  else result:=c;
end;

function GetResourceAsPointer(ResName: pchar; ResType: pchar;
                               out Size: longword): pointer;
 var    InfoBlock: HRSRC;
        GlobalMemoryBlock: HGLOBAL;
 begin
   InfoBlock := FindResource(hInstance, resname, restype);
   if InfoBlock = 0 then raise Exception.Create(SysErrorMessage(GetLastError));
   size := SizeofResource(hInstance, InfoBlock);
   if size = 0 then      raise Exception.Create(SysErrorMessage(GetLastError));
   GlobalMemoryBlock := LoadResource(hInstance, InfoBlock);
   if GlobalMemoryBlock = 0 then      raise Exception.Create(SysErrorMessage(GetLastError));
   Result := LockResource(GlobalMemoryBlock);
   if Result = nil then      raise Exception.Create(SysErrorMessage(GetLastError));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  {Some of the initialization stuff can't be doen until form activate time,
   so we'll just set a flag here}
  initialized:=false;
  Wordlistbuilt:=false;
  setmemomargins(memo1,20,20,20,20);
  reformatmemo(memo1);
end;

{********************* TForm1.Initialize *****************}
procedure TForm1.Initialize;
var
  n:integer;
  c:char;
  size: longword;
  ini:TInifile;
  ai,di:ANSIString;
begin
  {make an array of cumulative relative frequency values
   of letters as they appear in the English language.
   Used to generate random letter board}
   n:=0;
   for c:='a' to 'z' do
   begin
     n:=n+letterfreqs[c];
     cumfreqs[c]:=n;
   end;
   totfreqcount:=n;
   allwords:=TStringList.create; allwords.sorted:=true;
   Userwords:=TStringlist.create;   Userwords.sorted:=true;
   AddedwordList:=TStringlist.create;   AddedwordList.sorted:=true;
   IgnoredWordList:=TStringlist.create;   IgnoredwordList.sorted:=true;
   exepath:=extractfilepath(application.exename);
   ai:=exepath+'akerue.ini';
   di:=exepath+'dic.ini';
   (*
   if (fileexists(ai) and ((filegetattr(ai) and faReadOnly) >0))
      or (fileexists(di) and ((filegetattr(di) and faReadOnly) >0))
   then begin Pathname:=GetDFFCommonPath(true);  end
   else*) pathname:=exepath;

   statusbar1.panels[1].text:='Work Folder:'+pathname;
   ini:=Tinifile.create(pathname+'akerue.ini');
   with ini do
   begin
     DicGrp.itemindex:=ReadInteger('General','DicSize',1);
     Boardsizegrp.itemindex:=ReadInteger('General','BoardSize',1);
     timeOption.checked:=readBool('General','Timer',False);
     sound1.checked:=readBool('General','TimerSound',True);
     Timelimits[0]:=readinteger('General','SmallBoardTimeLimit',5);
     Timelimits[1]:=readinteger('General','MediumBoardTimeLimit',5);
     Timelimits[2]:=readinteger('General','LargeBoardTimeLimit',5);
     Colors1.checked:=readbool('General','ClassicColors',False);
     Dicname[0]:=readstring('DicNames','SmallDicname',exepath+'AkerueSmall.dic');
     Dicname[1]:=readstring('DicNames','MediumDicname',exepath+'AkerueMedium.dic');
     Dicname[2]:=readstring('DicNames','LargeDicname',exepath+'AkerueLarge.dic');
     savedicnames;
   end;
   ini.free;

   Addedname[0]:=pathname+'AddedSmall.txt'; Ignoredname[0]:=pathname+'IgnoredSmall.txt';
   Addedname[1]:=pathname+'AddedMedium.txt'; Ignoredname[1]:=pathname+'IgnoredMedium.txt';
   Addedname[2]:=pathname+'AddedLarge.txt'; Ignoredname[2]:=pathname+'IgnoredLarge.txt';
   ExpandedWordlist:=TStringlist.create;
   dicform.opendialog1.initialdir:=exepath;

   status:=complete;
   randomize;
   CurrentDicIndex:=-1;
   Dicgrp.itemindex:=1;
   SetDicnames;
   DicGrpClick(self);
   BoardSizegrp.itemindex:=1;
   Boardsizegrpclick(self);
   OKSound := GetResourceAsPointer('OkSound', 'wave', size);
   InvalidSound := GetResourceAsPointer('InvalidSound', 'wave', size);
   AddWordSound := GetResourceAsPointer('AddWordSound', 'wave', size);

   Gametimer:=TCountdown.create(Panel1);
   panel1.free;
   with gametimer do
   begin
     nosound:=not Sound1.checked;
     analogclock:=true;
     onExpires:=TimeExpired;
   end;

   timeoption.checked:=not timeoption.checked; {next call will put it back to initial value}
   Timeoptionclick(self);

   colors1.checked:=not colors1.checked; {next call will put it back to initial value}
   Colors1click(self);

   wordactionlbl.caption:='';
   PageControl1.activepage:=Tabsheet1;
   initialized:=true;
end;

procedure TForm1.Timeexpired(sender:TObject);
begin
  Showallbtnclick(sender);
end;



{********************* TForm1.FormActivate ******************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  //pubdic.inipathname:=pathname;
  dicname[0]:=pubdic.smalldic;
  DicName[1]:=pubdic.mediumdic;
  Dicname[2]:=pubdic.Largedic;
  if not initialized then Initialize; {one time initilization}
  timer1.enabled:=true; {Timer to generate letters randomly}
  timer1.interval:=50;
end;


{********************* TForm1.ClearSelected ***********************}
procedure TForm1.clearselected;
{in manual solving - clears array of letters
 used in current word - prevents reusing letters }
var
  i,j:integer;
begin
  for i:= 0 to boardsize.x-1 do
    for j:=0 to boardsize.y-1 do
     selectedletters[i,j]:=false;
end;


{********************* TForm1.reset ****************}
procedure TForm1.reset;

begin
  clearselected;
  listbox1.clear;
  score:=0;
  maxscore:=0;
  Scorelbl.caption:='Your Score:'+#13+'0 Words'+#13+'0 Points';
  MaxScorelbl.caption:='Program Score: '
                 +#13+  Inttostr(0)
            + ' Words, '+ #13+inttostr(0)+' Points';

  wordlistbuilt:=false;
  StartBtn.text:=StringofChar(' ',42)+'Start';
  StartBtn.OnClick:=StartBtnClick;
end;

{********************* TForm1.Timer1Timer *****************}
procedure TForm1.Timer1Timer(Sender: TObject);
{Timer runs selecting letters based on frequency distribution of letters in the
 English language}
var
  r:integer;
  c:char;
  i,j:integer;
  //s:ANSIString;
begin
  case status of
  complete:
    with boardgrid do
    begin
      i:=random(colcount); {pick a column}
      j:=random(rowcount); {pick  a row}
      r:=random(totfreqcount);  {pick a letter}
      c:='a';
      while (c<='z') and (cumfreqs[c]<r) do inc(c);
      cells[i,j]:=upcase(c);
    end;
  end; {case}
end;

{************** StartTimer ************}
procedure TForm1.StartTimer;
begin
  If Timeoption.checked then
  begin
    Gametimer.SetStarttimeHMS(0,timelimits[boardsizegrp.itemindex],0);
    Gametimer.startTimer;
    gametimer.visible:=true;
  end
  else gametimer.visible:=false;
end;


procedure TForm1.setup;
{Setup to start or replay a current board}
begin
  timer1.enabled:=false;  {stop letter generator timer if its running}
  score:=0;
  Scorelbl.caption:='Your Score:'+#13+'0 Words'+#13+'0 Points';
  setlength (paths,boardsize.x+2);{+2 allows for sentinel border to simplify search}
  frompoint:=point(1,1); {set initial frompoint}
  screen.cursor:=crhourglass;
  CalcAllwords;
  screen.cursor:=crdefault;
  listbox1.clear;
  wordlistbuilt:=true;
  replaybtn.visible:=false;
  newbtn.visible:=false;
  StartBtn.visible:=true;
  StartBtn.Text:='Enter your words, then click here to see the words you didn''t find';
  StartBtn.OnClick:=ShowAllBtnClick;
  newwordedt.setfocus;
  newwordedt.text:='';
  invalidword:='';
  WordactionLbl.caption:='';
  clearselected;
  status:=started;
  starttimer; {start game timer, if timer option is set}
end;


{********************* TForm1.StartBtnClick ****************}
procedure TForm1.StartBtnClick(Sender: TObject);
{Start manual solving mode}
begin
  setup;
end;

{********************* TForm1.BoardGridDrawCell **********************}
procedure TForm1.BoardGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw cells ourselves to prevent selected cell from being highlighted}
begin
  with Sender as TStringGrid, canvas do
  begin
    brush.color:=color;
    canvas.font.color:=TStringgrid(sender).font.color;
    Canvas.FillRect(Rect);
    font.style:=[fsbold];
    font.size:=14;
    textout(rect.Left+4,Rect.Top+4,cells[acol,arow]);
  end;

end;


{********************* TForm1.BoardGridDblClick *************}
procedure TForm1.BoardGridDblClick(Sender: TObject);
{Dbl click ==> try to enter this word & clear current word entry}
var
  len:integer;

    {********** validword **************}
    function validword(w:ANSIString):boolean;
      var
        a,f,c:boolean;
      begin
        result:=(pubdic.lookup(lowercase(w),a,f,c))
        and (not a) and (not f);
      end;

begin
  if invalidword<>'' then {user clicked a second time ==> accept word}
  begin
    Addedwordlist.add(invalidword);
    WordActionLbl.caption:='"'+invalidword + '" added to accepted words';
    NewWordEdt.text:=invalidword;
    invalidword:='';
  end;
  with newwordedt do
  begin
    len:=length(text);
    if (validword(text)) and (len>=3) then
    begin
      if addtolist(text,Userwords) then
      Begin
        if len>10 then len:=10;
        score:=score+scoring[len];
        wordcount:=listbox1.items.count;
        listbox1.items.text:=userwords.text;
        Scorelbl.caption:='Your Score: '
        +#13+Inttostr(wordcount)
        +' Words, '+#13+inttostr(score)+' Points';
        {make OK sound}
        PlayWordAdded;
      end
      else PlayInvalid;{make "allready on list" or invalid sound}
    end
    else  {make invalid word sound}
    begin
      PlayInvalid;
      invalidword:=newwordedt.text;
    end;
    newwordedt.text:='';
    clearselected;
  end;
  newWordEdt.setfocus;  {in case the next word is entered by keyboard}
end;


{***************** BoardGridMouseUp *****************}
procedure TForm1.BoardGridMouseUp(Sender: TObject; Button: TMouseButton;
{Replaces direct calls to Bordgrid SelectCell and BoardGrid DoubleClick exits
to make actions more responsive and easier to understand}
  Shift: TShiftState; X, Y: Integer);
var
  acol,arow:integer;
  canselect:boolean;
begin

   if (button=mbright) then
   begin
     Boardgriddblclick(sender);
   end
   else
   with boardgrid do
   begin
     acol:=x div defaultcolwidth;
     arow:=  y div defaultrowheight;
     BoardgridSelectCell(sender,acol,arow,canselect);
   end;
end;

{********************* TForm1.BoardGridSelectCell *****************}
procedure TForm1.BoardGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
{User clicked a letter}
var
  OK:boolean;
  i:integer;
begin
  if status<>started then exit;
  ok:=true;
  if  (length(newwordedt.text)>0) and (not mouseinput) then OK := false
  else
  begin
    if (length(newwordedt.text)>0) then
    begin
      if not selectedletters[acol,arow] then
      begin
        {If not first click then make sure that selected cell is adjacent to previous}
        OK:=false;
        for i:= 1 to 8 do
        if (lastpoint.x+offsets[i].x=acol) and (lastpoint.y+offsets[i].y=arow) then
        begin
          OK:=true;
          invalidword:='';
         
          break;
        end;

      end
      else
      if (lastpoint.x=acol) and (lastpoint.y=arow) then {reselected letter - check word}
      begin
        boardgriddblclick(sender);
        exit;
      end
      else OK:=false;
    end;
  end;
  if OK then
  begin
    if length(newwordedt.text)=0 then mouseinput:=true;
    newwordedt.text:=newWordedt.text+boardgrid.cells[acol,arow];
    selectedletters[acol,arow]:=true;
    lastpoint:=point(acol,arow);
    PlayOK;
  end
  else PlayInvalid;
end;


{********************* TForm1.ZeroBoard ***********************}
procedure TForm1.zeroboard;
{Initialize the paths array marking borders inaccessable}
var
  i,j:integer;
begin
  for i:= low(paths) to high(paths) do setlength(paths[i],boardsize.y+2);
  for i:= low(paths) to high(paths) do
  for j:=low(paths[i]) to high(paths[i]) do
  if (i=low(paths)) or (i=high(paths)) or (j=low(paths[i])) or (j=high(paths[i]))
  then paths[i,j]:=maxint else paths[i,j]:=0;
  pathcount:=1;
end;

{********************* TForm1.ZeroPaths ***********************}
procedure TForm1.zeroPaths;
{Initialize the paths array marking borders inaccessable}
var
  i,j:integer;
begin
  for i:= low(paths)+1 to high(paths)-1 do
  for j:=low(paths[i])+1 to high(paths[i])-1 do
  paths[i,j]:=0;
  pathcount:=1;
end;


{********************* TForm1.AddToList ***********************}
function Tform1.addtolist(w:ANSIString; list:TStringlist):boolean;
{add a word to a list if it's not already there}
var
  index:integer;
begin
  w:=uppercase(w);
  index:=list.indexof(w);
  if index<0 then
  begin
    list.add(w);
    result:=true;
  end
  else result:=false;
end;

{**************** CouldBeWord ************888}
function TForm1.couldbeword(pdic:TDic;w:ANSIString; var isword:boolean):boolean;
{Test to see if the current partial word could be a word, i.e there is an
entry in the dictionary that begins with these letters}
var
  trialword:ansistring;
  a,f,c:boolean;
  index,index2:integer;
  newlist:TStringlist;
  len:integer;
  w2:ANSIString;
begin
  result:=false;
  isword:=false;
  len:=length(w);
  if expandedwordList.find(copy(w,1,3),index) then
  begin
    with Tstringlist(expandedwordList.objects[index]) do
    begin
      if count=0 then exit
      else
      begin
        if find(w,index2) then
        begin
          result:=true;
          isword:=true;
        end
        else
        if (index2<count) and (copy(strings[index2],1,length(w))=w)
        then result:=true;
      end;
    end;
  end
  else
  with  pdic do
  begin  {build a new entry with all possible words starting with these three
          letters}
    setrange(ansichar(w[1]),length(w),ansichar(w[1]),10);
    newlist:=TStringlist.create;
    expandedwordlist.insertobject(index,w,newlist);
    while (getnextword(trialword,a,f,c)) do
    with newlist do
    begin
      w2:=copy(trialword,1,len);
      if w2=w
      then
      begin
        if (not a) and (not f)  then
        begin
          newlist.add(trialword);
          result:=true;
          if trialword=w then isword:=true;
        end;
      end
      else if w2>w then break;
    end;
  end;
end;

{********************* TForm1.GetNextPath *************************}
procedure TForm1.getnextpath(startpoint:TPoint;var pathstring:ANSIString);
{The heart of the recursive path search for new words }
var
  i,len:integer;
  nextpoint:Tpoint;
  isword:boolean;
  c:char;
begin
  if tag<>0 then exit;
  for i:= 1 to 8 do {try all 8 possible move directions}
  begin
    nextpoint.x:=startpoint.x+offsets[i].x;
    nextpoint.y:=startpoint.y+offsets[i].y;
    if paths[nextpoint.x,nextpoint.y]=0 then {we can visit}
    begin
      paths[nextpoint.x,nextpoint.y]:=pathcount; {mark as visited}
      {add lowercase character from grid to potential word}
      c:=char(ord(boardgrid.cells[nextpoint.x-1,nextpoint.y-1][1]) or $20);
      pathstring:=pathstring  + char(ord(c) or $20);
      len:=length(pathstring);
      {could it be a word?}
      if (len>=3) then   {we've gone three steps - check and see if any words start with these three}
      begin
        if (couldbeword(pubdic,pathstring,isword)) and (tag=0) then {keep searching}
        begin
          {is it a word?}
          if isword then  allwords.add(pathstring);
          {also if in
         {continue searching}
          getnextpath(nextpoint,pathstring);
        end;
      end
      else getnextpath(nextpoint,pathstring);
      {make this node available again}
      paths[nextpoint.x,nextpoint.y]:=0;
      {and erase the last character}
      delete(pathstring,length(pathstring),1);
    end;
  end;
end;

{********************* TForm1.Checkpathfrom *************************}
function TForm1.IspathTo(w:ANSIString):boolean;
{search for a path containing a specific word}


  function checkpathfrom(startpoint:TPoint; wfind:ansistring):boolean;
  {recursive search for a path containing next letter of a specific word}
  var
    i{,j}:integer;
    nextpoint:TPoint;
    c:char;
    r:boolean;
  begin
  result:=false;
  for i:= 1 to 8 do {try all 8 possible move directions}
  begin
    nextpoint.x:=startpoint.x+offsets[i].x;
    nextpoint.y:=startpoint.y+offsets[i].y;
    if paths[nextpoint.x,nextpoint.y]=0 then {we can visit}
    begin

      c:=ansichar(boardgrid.cells[nextpoint.x-1,nextpoint.y-1][1]) ;
      if c=wfind[1] then
      begin
        delete(wfind,1,1);
        if length(wfind)>0 then
        begin
          paths[nextpoint.x,nextpoint.y]:=pathcount; {mark as visited}
          r:=checkpathfrom(nextpoint,wfind);
          if r=true then  begin result:=r; exit; end;
          wfind:=c+wfind;
          paths[nextpoint.x,nextpoint.y]:=0; {mark as unvisited}
        end
        else
        begin
          result:=true;
          exit;
        end;
      end;
    end;
  end;
end;

var
  i,j:integer;
  r:boolean;
  testw:ANSIString;
begin

  {find next first letter of word}
  r:=false;
  for i:=1 to boardsize.x do
  begin
    for j:= 1 to boardsize.y do
    begin
      zeropaths;
      if  boardgrid.cells[i-1,j-1]=w[1]
      then
      begin
        testw:=w;
        delete(testw,1,1);
        paths[i,j]:=pathcount; {mark starting spot as used}
        r:=checkpathfrom(point(i,j),testw);
        if not r then paths[i,j]:=0; {that wasn't the right spot, reset path}
      end;
      if r then break;
    end;
    if r then break;
  end;
  result:=r;
end;


{************** ClearWordLists ************}
procedure TForm1.Clearwordlists;
var i:integer;
begin
  allwords.clear;
  userwords.clear;
  for i:=0 to expandedwordList.count-1 do
  TstringList(expandedwordList.objects[i]).free;
  expandedwordList.clear;
end;


{********************* TForm1.CalcAllWords ******************}
Procedure TForm1.CalcAllWords{(Sender:TObject; var Done:Boolean)};
{Idle time exit to calculate all possible words while user is thinking}
{Calculate the paths from one point on each entry, then increment the point}
var
  partialword:ANSIString;
begin
  {solve paths from a single starting point and increment starting point to next cell}
  zeroboard;

  clearwordlists;
  while frompoint.x<=boardsize.x do
  with frompoint do
  begin
    zeropaths;
    partialword:=MakeLowCase(ansichar(boardgrid.cells[x-1,y-1][1]));
    paths[x,y]:=pathcount; {mark as visited}
    getnextpath(frompoint,partialword);
    inc(y) ;
    if y>boardsize.y then
    begin
      y:=1;
      inc(x);
    end;
  end;
end;


{********************* TForm1.ShowAllBtnClick *************}
procedure TForm1.ShowallBtnClick(Sender: TObject);
{Show all unfound words}
var
  i:integer;
  index:integer;

begin
  status:=autosolving;
  timer1.enabled:=false;
  gametimer.stoptimer;
  gametimer.visible:=false;
  messagebeep(MB_Iconexclamation);
  StartBtn.text:=stringofchar(' ',43)+ 'Stop';
  StartBtn.OnClick:=StopBtnClick;
  maxscore:=0;
  programwords:=0;
  MaxScorelbl.caption:='Program Score: '
                 +#13 + '0 Words, '+ #13+'0 Points';
  tag:=0;
  memo2.visible:=false; {hide the score info sheet}
  screen.cursor:=crHourGlass;
  listbox1.items.add('-------------');
  listbox1.items.Add('Program Added:');
  listbox1.items.add('-------------');

  for i:=0 to allwords.count-1 do
  if not userwords.find(allwords[i],index)
  then
  begin
    maxscore:=maxscore+scoring[length(allwords[i])];
    inc(programwords);
    listbox1.items.add(allwords[i]);
  end;
  MaxScorelbl.caption:='Program Score: '
                + #13+Inttostr(programwords)
            + ' Words, '+ #13+inttostr(maxscore)+' Points';
  screen.cursor:=crDefault;
  status:=complete;
  StartBtn.visible:=false;
  NewBtn.visible:=true;
  replaybtn.visible:=true;
  memo2.visible:=true;
end;

{********************* TForm1.StopBtnClick ************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

{********************* TForm1.SizeGrpClick *************}
procedure TForm1.BoardSizeGrpClick(Sender: TObject);
var
  i,j,r:integer;
  c:char;
begin
  if status=autosolving then
  begin
    tag:=1;
    exit;
  end;
  newbtn.visible:=false;
  replaybtn.visible:=false;
  StartBtn.visible:=true;
  reset;
  case BoardSizegrp.itemindex of
    0:  boardsize:=Point(4,4);
    1:  boardsize:=Point(5,5);
    2:  boardsize:=Point(6,6);
  end;
  with boardgrid do
  begin
    colcount:=boardsize.x;
    rowcount:=boardsize.y;
    width:=colcount*defaultcolwidth+colcount*gridlinewidth+5; {+8 space for borders set by trial&error}
    height:=rowcount*defaultrowheight+rowcount*gridlinewidth+5;
    for i:=0 to colcount-1 do
    for j:=0 to rowcount-1 do
    begin
      r:=random(totfreqcount);
      c:='a';
      while (c<='z') and (cumfreqs[c]<r) do inc(c);
      cells[i,j]:=upcase(c);
    end;
  end;
  zeroboard;
  Timer1.enabled:=true; {start generating random letters again}
  timer1.interval:=50;
end;

{********************* TForm1.PlayOK ***************}
procedure  TForm1.PlayOK;
begin
   if sound1.checked then PlaySound(OKSound, 0,SND_MEMORY );
end;


{********************* TForm1.PlayWordAdded **********}
procedure  TForm1.PlayWordAdded;
begin
  {If sound1.checked then} PlaySound(AddWordSound, 0,SND_MEMORY );
end;

{********************* TForm1.Playinvalid ***********}
procedure  TForm1.PlayInvalid;
begin
  {If sound1.checked then} PlaySound(InvalidSound, 0, SND_MEMORY );
end;

{********************* TForm1.FormCloseQuery *****************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  ini:TInifile;
begin
  SaveWordlists;
  ini:=Tinifile.create(pathname+'akerue.ini');
  try
   with ini do
   begin
     WriteInteger('General','DicSize',DicGrp.itemindex);
     WriteInteger('General','BoardSize',Boardsizegrp.itemindex);
     writeBool('General','Timer',timeOption.checked);
     writeBool('General','TimerSound',sound1.checked);
     writeinteger('General','SmallBoardTimeLimit',Timelimits[0]);
     writeinteger('General','MediumBoardTimeLimit',Timelimits[1]);
     writeinteger('General','LargeBoardTimeLimit',Timelimits[2]);
     writebool('General','ClassicColors',Colors1.checked);
     writestring('DicNames','SmallDicname',Dicname[0]);
     writestring('DicNames','MediumDicname',Dicname[1]);
     writestring('DicNames','LargeDicname',Dicname[2]);
   end;
   except
   end;
   ini.free;
  canclose:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);

  function validword(w:ANSIString):boolean;
  {check the word against the list}
  var index:integer;
      up:ANSIString;
  begin
    up:=uppercase(w);
    if (allwords.find(w,index)
        or (addedwordList.find(up,index) and ispathto(up)
           )
       )
       and not(ignoredwordList.find(w,index))
    then result:=true
    else result:=false;
  end;

var
  len:integer;
begin
  if not wordlistbuilt then exit;
  NewWordEdt.SetFocus;
  If key=#13 then
  begin
    if invalidword<>'' then {user clicked a second time ==> accept word}
    begin
      {Need more checks - don't add word if it cannot be formed from connected letters}
      if ispathto(invalidword) then
      begin
        Addedwordlist.add(invalidword);
        WordActionLbl.caption:='"'+invalidword + '" added to accepted words';
        NewWordEdt.text:=invalidword;
      end
      else
      begin
        showmessage('Not added, no path to this word');
        playInvalid;
      end;
      invalidword:='';
    end;
    with newwordedt do
    begin
      len:=length(text);
      if validword(lowercase(text)) then
      begin
        if addtolist(text,UserWords) then
        Begin
          if len>10 then len:=10;
          score:=score+scoring[len];
          listbox1.items.text:=userwords.text;
          wordcount:=listbox1.items.count;
          Scorelbl.caption:='Your Score: '
          +#13+Inttostr(wordcount)
          +' Words, '+#13+inttostr(score)+' Points';
          {make OK sound}
          PlayWordAdded;
        end
        else PlayInvalid;{make "allready on list" or invalid sound}
      end
      else  {make invalid word sound}
      begin
        PlayInvalid;
        invalidword:=newwordedt.text;
      end;
      newwordedt.text:='';
      clearselected;
      key:=#0;
    end;
  end
  else invalidword:='';
end;

procedure TForm1.ReplayBtnClick(Sender: TObject);
begin
  setup;
end;

{************** Set1Clck ************}
procedure TForm1.Set1Click(Sender: TObject);
begin
  with timedlg do
  begin
    updown1.position:=timelimits[0];
    updown2.position:=timelimits[1];
    updown3.position:=timelimits[2];
    if showmodal=mrOK then
    begin
      timelimits[0]:=updown1.position;
      timelimits[1]:=updown2.position;
      timelimits[2]:=updown3.position;
    end;
  end;
end;

{************ SaveDicnames *********}
Procedure TForm1.SaveDicnames;
var
  ini:TInifile;
begin
  ini:=TIniFile.create(pathname+'Dic.ini');
  //showmessage('pathname='+pathname);
  ini.WriteString('Files','Small Dictionary',dicname[0]);
  ini.WriteString('Files','Medium Dictionary',dicname[1]);
  ini.WriteString('Files','Large Dictionary',dicname[2]);
  ini.free;
end;

{*************** SetDicnames *********}
Procedure TForm1.SetDicnames;
var
  ini:TInifile;
begin
  ini:=TIniFile.create(pathname+'Dic.ini');
  ini.writeString('Files','Small Dictionary',dicname[0]);
  ini.writeString('Files','Medium Dictionary',dicname[1]);
  ini.writeString('Files','Large Dictionary',dicname[2]);
  ini.free;
end;

{*************** SetDefaultDictionaries *******}
procedure TForm1.Setdefaultdictionaries1Click(Sender: TObject);
begin
  with SelDicDlg do
  begin
    SmallNameEdt.text:=DicName[0];
    MediumNameEdt.text:=DicName[1];
    LargeNameEdt.text:=DicName[2];

    if showmodal=mrOK then
    begin
      DicName[0]:=SmallNameEdt.text;
      DicName[1]:=MediumNameEdt.text;
      Dicname[2]:=LargeNameEdt.text;
      SaveDicnames;
   end;
  end;
end;

{*************** FormMouseUp ***********}
procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
  var
    ch:char;
begin
  if (button=mbright) and (invalidword<>'') then
  begin
    Addedwordlist.add(invalidword);
    WordActionLbl.caption:='"'+invalidword + '" added to accepted words';
    NewWordEdt.text:=invalidword;
    invalidword:='';
    ch:=#13;
    formkeypress(self,ch);

  end
  else if (sender=NewWordEdt) and (NewWordEdt.text='' ) then mouseinput:=false;
end;

{*********** ListBox1Click ************}
procedure TForm1.ListBox1Click(Sender: TObject);
begin
  with listbox1 do
  begin
    if itemindex > userwords.count+1 then
    begin
      ignoredwordList.add(items[itemindex]);
      WordactionLbl.caption:= '"'+items[itemindex] +'" added to Ignore words list';
      maxscore:=maxscore-scoring[length(items[itemindex])];
      dec(programwords);
      items.delete(itemindex);
      MaxScorelbl.caption:='Program Score: '
                + #13+Inttostr(programwords)
            + ' Words, '+ #13+inttostr(maxscore)+' Points';
    end;
  end;
end;

{************** WordSheetEnter ************8}
procedure TForm1.WordSheetEnter(Sender: TObject);
begin
  ValidwordDisplayList.text:=addedwordlist.text;
  Ignoreworddisplaylist.text:=Ignoredwordlist.text;
end;

{************ SaveWordLists *********}
procedure TForm1.SaveWordlists;
begin
  if currentDicindex>=0 then
  begin
    if fileGetAttr(addedname[currentdicindex]) and faReadonly=0 then
    begin
      if addedwordlist.count>0 then addedwordList.savetofile(addedName[CurrentDicIndex]);
      if ignoredwordlist.count>0 then IgnoredwordList.Savetofile(IgnoredName[CurrentDicIndex]);
    end;
  end;
end;

{************** DigGrpClick ***********}
procedure TForm1.DicGrpClick(Sender: TObject);
var
  n:integer;
begin
   If currentdicindex>=0 then Savewordlists; {in case words were added or deleted}
   n:=DicGrp.itemindex;
   case n of
     0: pubdic.loadSmallDic; {DicFromfile(dicname[n])}
     1: pubdic.loadMediumDic;
     2: pubdic.loadLargeDic;
   end;

   statusbar1.panels[0].text:='Current Dic. '+extractfilename(pubdic.dicname)
    +' '+inttostr(pubdic.getdicsize)+' words';
  currentDicIndex:=DicGrp.itemindex;
  if fileexists(AddedName[n]) then addedwordList.loadfromfile(addedname[n])
  else addedwordlist.clear;
  if fileexists(IgnoredName[n]) then IgnoredwordList.loadfromfile(Ignoredname[n])
  else IgnoredWordList.clear;

end;

procedure TForm1.Sound1Click(Sender: TObject);
begin
  sound1.checked:= not sound1.checked;
  Gametimer.nosound:=not sound1.checked;
end;

procedure TForm1.TimeOptionClick(Sender: TObject);
begin
  timeoption.checked:=not timeoption.checked;
  gametimer.visible:=timeoption.checked;
end;

procedure TForm1.Colors1Click(Sender: TObject);
begin
  Colors1.checked:=not colors1.checked;
  with boardgrid do
  if colors1.checked then
  begin
    color:=clBlue;
    font.color:=clYellow;
  end
  else
  begin
    color:=clWindow;
    font.color:=clblack;
  end;
end;

procedure TForm1.NewWordEdtChange(Sender: TObject);
begin
  //invalidword:='';
end;

end.
