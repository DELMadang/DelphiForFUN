unit U_SquareWordGrids3;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Generates, allows user play, and solves Square Word Grids with multiple dictionaries
  and grid sizes.  Displaying a slected number of properly placed  letters proved
  clues for the user trying to complete the puzzle given the set of letters to use.

  Program "DicMaint" found on DFF can be used to add additional words to Full.dic
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, UDict, ComCtrls, dffutils, Spin, Grids, UComboV2,
  Inifiles
  ;

type
  TCaserec=record
    casename:string;
    Size:integer;
    Fillletters:string;
    GridLetters:string;
    PreFillCount:integer;
    Solution:string;
    DicIndex:integer;
    OrigHintCount:integer;
  end;

  TGrid=array of array of char;

  TListrec= record
    Dir:char;  {R=Row, C=Column}
    colRowNbr:integer;
    nbrwords:integer;
    wordlist:TStringlist;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    IntroPage: TTabSheet;
    PlayPage: TTabSheet;
    Label4: TLabel;
    SolutionMemo: TMemo;
    SearchBtn: TButton;
    GenBtn: TButton;
    Grid: TStringGrid;
    UserPlayGrp: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Prefill: TSpinEdit;
    Unused: TEdit;
    ResetBtn: TButton;
    StopPanel: TPanel;
    DicGrp: TRadioGroup;
    Sizegrp: TRadioGroup;
    Memo2: TMemo;
    SetCurrentBtn: TButton;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Memo1: TMemo;
    CurrentLbl: TLabel;
    Debug: TCheckBox;
    Duplicates: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopPanelClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SearchBtnClick(Sender: TObject);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure genBtnClick(Sender: TObject);
    procedure DicGrpClick(Sender: TObject);
    procedure PrefillChange(Sender: TObject);
    procedure SizegrpClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure SetCurrentBtnClick(Sender: TObject);
    procedure UnusedKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LoadBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
  public
    N:integer; {word length}
    square:array of string;  {the word square we're building}
    userMode:boolean;  {true if user is entering a case manually}
    {lists to hold words starting with each letter position of the start word
     except no need to build a list for the 1st letter.  Also note that since
     this is a dynamic array starting with index value 0, the Kth letter of the
     source word is represented by list [K-2]}
    lists:array of TStringList;
    Loopcount:int64; {# of word tests made}
    foundcount:integer; {solution found count}
    CurrentCase:TCaserec;
    solutioncount:integer;
    deck:array of integer;
    modified:boolean;
    NewCaseName:string;
    inifilename:string;
    ColWords,RowWords:array of TStringList;
    collocs, rowlocs:array of integer;
    ColRowWords:array of TListrec;
    stopflag:boolean;
    UsedWords:TStringlist;  {List of words added during program solving}
    starttime:TDateTime;

    procedure SetupCase(Rec:TCaserec);
    procedure SetupgridLetters(var caserec:TCaserec; NewDeck:boolean);
    procedure setbusy(L,T:integer);
    procedure SetUnbusy;
    function  IsBusy:boolean;
    procedure ResetAll;
    function checkmodified:boolean;
    procedure savecase;
    procedure loadcase;
    function  getnextNormalWord(var w:string):boolean;
    Function PlaceNextWord(Level:integer; board:TGrid):boolean;
    procedure UpdateTimeLabel;
  end;

var
  Form1: TForm1;

implementation

uses U_PuzzleDlg;

{$R *.DFM}

var
  Defaultrec:TCaseRec = (Casename:'Default'; Size:3; FillLetters:'AAENRTUY';
                         GridLetters:'..B......';
                         Solution:'TUBERAANY';
                         DicIndex:0;
                         OrigHintCount:1;);
  {preload what is usually random pre-fills to control default letter order}
  Defaultdeck:array[0..8] of integer=(9,4,7,8,1,5,6,2,3);

{********* CheckModified **********}
function TForm1.Checkmodified:boolean;
{Call before loading a new file to ensure chance to save old case}
{return Result true if not modified
                    or modified and user saved case
                    or modified but user did not want case saved}
var
  msg:string;
  r:integer;
begin
  result:=true;
  if modified then
  begin
    msg:='Save current case first?';
    r:=messagedlg(msg,mtconfirmation,[mbyes,mbno,MBCANCEL],0);
    if r=mrcancel then result:=false
    else
    begin
      modified:=false;
      if r=mryes then
      begin
        savecase;
        newcasename:='Unsaved';
      end;
    end;
  end;
end;

{************ FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  randomize;
  reformatmemo(Memo2);
  pubdic.LoadmediumDic;
  inifilename:=extractfilepath(application.ExeName)+'PuzzleFile.ini';

  {setup up initial case}
  Currentcase:=Defaultrec;
  {set up and load the pre-fill order}
  setlength(deck,9);
  for i:=0 to high(deck) do deck[i]:=defaultdeck[i];
  SetupgridLetters(currentcase,false);
  currentcase.casename:='Default';
  SetupCase(currentcase);
  usermode:=false;
  modified:=false;                         
  prefill.Enabled:=true;

  //currentLbl.Caption:='Current Puzzle: '+currentcase.casename;

  setmemomargins(memo2,20,20,20,20);
  pagecontrol1.activepage:=Intropage;
end;

{******* FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
 //Grid.SetFocus;  {set up for user to solve}
end;

{************ StopBtnClick *************}
procedure TForm1.StopPanelClick(Sender: TObject);
begin
  tag:=1; {form's tag property is tested within Tryword function which will stop
           the search if value becomes nonzero}
  stopflag:=true;
end;

{********* GridDrawCell **************}
procedure TForm1.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  n:integer;
begin  {just to turn off "select" highlighting}
  ignoreSelectedDrawCell(sender,Acol,Arow,Rect,State);
  {might as well center th letters while we're here}
  with TStringGrid(sender), canvas  do
  begin
    if gdfocused in State then brush.color:=clskyblue else brush.color:=color;;
    rectangle(rect);
    n:=textwidth(cells[acol,arow]);
    with rect do textout(left+(defaultcolwidth-n) div 2, top+2, cells[acol,arow]);
  end;
end;

{******** Incgrid **********}
procedure IncGrid(Grid:TStringgrid);
{Move the cursor forward by 1 cell}
begin
  with grid do
  begin
    if col<colcount-1 then col:=col+1
    else
    begin
      col:=0;
      if row<rowcount-1 then row:=row+1
      else
      row:=0;
    end;
  end;
end;

{************ DecGrid ***********}
procedure DecGrid(Grid:TStringGrid);
{Back up the grid cursor by one cell}
begin
  with grid do
  begin
    if col>0 then col:=col-1
    else
    begin
      col:=colcount-1;
      if row>0 then row:=row-1
      else
      row:=rowcount-1;
    end;
  end;
end;

{************ GridKeyDown *************}
procedure TForm1.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  s:string;
begin
  If IsBusy then exit;
  with grid do
  begin
    IF CHAR(key) in ['a'..'z'] then  key:=key and $20;
    // memo2.Lines.add(format('Key down: key= %d, (C:%d, R:%d) cell=%s',[key,col,row,cells[col,row]]));
    IF (KEY=VK_DELETE) or (char(key)=' ') then
    begin
      if length(unused.text)<sqr(sizegrp.itemindex+3) then
      begin
        s:=Unused.text+cells[col,row];
        sortstrup(s);
        unused.Text:=s;
      end;
      cells[col,row]:=' ';
    end
    else
    if (key=VK_RETURN) or (key=VK_TAB) or (key=VK_RIGHT) then
    begin
      IncGrid(grid);
      key:=0;
    end
    else If (key=VK_Left) or (key=VK_Back) then
    begin
      Decgrid(grid);
      key:=0;
    end
    else {ignore  other keys if not letter or arrow}
    if not (char(key) in ['A'..'Z'])
       and (not (key in [VK_UP,VK_Down]))
    then key:=0;
  end;
end;

{************** GridKeyPress *************8}
procedure TForm1.GridKeyPress(Sender: TObject; var Key: Char);
var
  n,c,r:integer;
  s:string;
  OK:boolean;
begin
  If IsBusy then exit;
  {Only allow adding letters to the grid that are in Unused letters box}
  s:=Unused.Text;
  n:=Pos(upcase(key),S);
  if n>0 then
  with grid do
  begin
    delete(s,n,1);
    {if replacing a character then put it back in Unused character set}
    if (length(cells[col,row])>0) and (cells[col,row][1] in ['A'..'Z'])
    then
    begin
      S:=S+cells[col,row];
      sortstrup(s);
    end;
    cells[col,row]:=upcase(key); {add the pressed character}
    if usermode then prefill.Value:=prefill.Value+1;
    Unused.text:=s;
    if (s='') and (not usermode) then
    with currentcase do
    begin  {all squares filled, check for solution}
      OK:=true;
      for c:=0 to size-1 do
      begin
        for r:=0 to size-1 do
        begin
          if grid.cells[c,r]<> solution[size*r+c+1] then
          begin
            OK:=false;
            break;
          end;
        end;
        if not OK then break;
      end;
      if OK then showmessage('You solved it! '+#13+'   Congratulations!');
    end;
    incGrid(grid);
  end
  else beep;
  if not usermode then key:=#0;
end;



{------------ GetNextNormalWord ---------}
function TForm1.getnextNormalWord(var w:string):boolean;
var a,c,f:boolean;
begin
  result:=false;
  while pubdic.getnextword(w,a,c,f) do
  begin
    if (not a) and (not c) and (not f) then
    begin
      result:=true;
      break;
    end;
  end;
end;

{***************** PlaceNextWord ****************}
function TForm1.PlaceNextWord(level:integer; Board:TGrid):boolean;

var
  nextboard:TGrid;
    {--------- BoardIsOK ---------}
    Function BoardIsOK(dir:char; colrownbr:integer;w:string):boolean;
    var
      c,r:integer;
    begin

      if (not duplicates.Checked) and (usedwords.indexof(w)>=0) then
      begin
        result:=false;
        exit;
      end;
      
      result:=true;
      If dir='R' then
      begin {"row" level, check column words to make sure there is a
             word that could work for each column (word [osition) for the word
             in this row}
        r:=colrownbr;
        {check for conflicts with existing column words}

        for c:=0 to currentcase.size-1 do
        begin

          {check for conflicts with existing column words}
          if (nextboard[c,r]<>' ') and (w[c+1]<> nextboard[c,r]) then
          begin
            result:=false;
            break;
          end;
        end; {End of checking all columns for row R}
      end
      else
      begin
        {"column" level, check row words to make sure there is a
             word that could work for each column (word [osition) for the word
             in this row}
        c:=colrownbr;
        for r:=0 to currentcase.size-1 do {for each row}
        begin
          {check for conflicts with existing row words}
          if (nextboard[c,r]<>' ') and (w[r+1]<> nextboard[c,r]) then
          begin
            result:=false;
            break;
          end;
        end; {end of checking all rows  words for column C fit}
      end;
    end;

var
  c,r,i,mb:integer;
  w,s, solv:string;
  offset:string;
begin
  application.processmessages;
  result:=false;
  if stopflag then exit;

  with currentcase do
  if level>2*size-1 then
  with solutionmemo.Lines do
  begin {we found it!}
    inc(solutioncount);
    updatetimelabel;
    add('');
    add('Solution #'+inttostr(solutioncount));
    solv:='';
    for r:=0 to size-1 do
    begin
      s:='';
      for c:=0 to size-1 do
      begin
        grid.Cells[c,r]:=board[c,r];
        s:=s+board[c,r];
      end;
      add(s);
      solv:=solv+s;
    end;
    if messageDlg('We found a solution! Save as solution??',mtconfirmation,[mbyes,mbno],0)= mryes
    then
    begin
      if solution<>'' then mb:=messagedlg('Replace current saved solution?',
                               mtconfirmation,[mbyes,mbno],0)   else mb:=mrno;

      if (solution='') or (mb=mryes) then
      begin
        solution:=solv;
        modified:=true;
      end;
    end;

    stopflag:=false;
    if messageDlg('Continue searching?',mtconfirmation,[mbyes,mbno],0)= mrno
    then stopflag:=true;
  end
  else
  with currentcase do
  with colrowwords[level] do
  begin
     setlength(nextboard,size,size);
    for i:=0 to nbrwords-1 do
    begin
      {copy board to nextboard}
      for c:=0 to size-1 do
      for r:=0 to size-1 do nextboard[c,r]:=board[c,r];

      w:=wordlist[i];
     //  n:=0;
     //  while n<>rowlocs[r]do inc(n);
      //with rowwords[colrownbr] do

      if boardIsOK(dir, colrownbr,W) then
      with solutionmemo,lines do
      begin
        offset:=stringofchar(' ',2*level);
        if dir='C' then {fill in a column word}
        begin
          for r:=0 to size-1 do nextboard[colrownbr, r]:=w[r+1];
          if debug.Checked then (format('%s Level %d: Trying %s in col %d',[offset,level,w,colrownbr]));
        end
        else {fill in a row word}
        begin
          for c:=0 to size-1 do nextboard[c,colrownbr]:=w[c+1];
          offset:= stringOfChar(' ',2*level);
          if debug.checked then add(format('%s Level %d: Trying %s in row %d',[offset, level,w,colrownbr]));
        end;
        if not duplicates.checked then usedwords.Add(w);

        result:=PlaceNextWord(level+1, nextboard);

        if not result then
        begin
          if not duplicates.checked then with usedwords do delete(count-1);
          offset:= stringOfChar(' ',2*level);
          if dir='C' then {remove in a column word}
          begin
             if debug.checked then add(format('%s Level %d: Removing %s in col %d',[offset, level,w,colrownbr]));
             for r:=0 to size-1 do nextboard[colrownbr,r]:=board[colrownbr,r]
          end
          else {remove in a row word}
          begin
            if debug.checked then add(format('%s Level %d: Removing %s in row %d',[offset,level,w,colrownbr]));
            for c:=0 to size-1 do nextboard[c,colrownbr]:=board[c,colrownbr];
          end;
        (*
          for c:=0 to currentcase.size-1 do
          begin
            index:=c div size + r mod size;
            if not (gridletters[index] in ['A'..'Z']) then board[c,r]:=' '
            else board[c,r]:=gridletters[index];
          end;
          *)
        end;
      end;
    end;
  end;
end;

procedure TForm1.updatetimelabel;
          var
            s:string;
            h,m,sec,x:word;
          begin
            if solutioncount<>1 then s:='s' else s:='';  {Plural fix for grammer}
            decodetime(now-starttime,h,m,sec,x);
            label4.Caption:=format('%d solution'+s+' found, Run time: %d minutes, %d seconds ',
                                          [solutioncount, 60*h+m,sec])  ;
          end;


{************** SearchBtnClick ***************}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  list:TStringList;
  N:integer;
  letters, testLetters:string;
  i,j,c,r:integer;
  w:string;
  OK:boolean;
  rows:array of string;
  s:string;
  //seconds:integer;

  board:TGrid; {Current board state during program solving}



     {------------ SortList ------------}
     procedure SortList(var words:array of TStringlist; var loc:array of integer);
     var
       i,j:integer;
       temp:TstringList;
       temploc:integer;
     begin
       for i:=0 to high(words)-1 do
       for j:=i+1 to high(words) do
       if words[i].count>words[j].Count then
       begin
         //need to keep track of row and column in separate arrays for checkng later
         temp:= words[i]; temploc:=loc[i];
         words[i]:=words[j]; loc[i]:=loc[j];
         words[j]:=temp; loc[j]:=temploc;
       end;
     end;


begin  {SearchBtnClick}
  if isbusy then exit;
  {count letters placed in grid plus letters in edit area.  Must equal NxN for NxN grid}
  {Make list of all possible N letter words}
  if usermode and  (messagedlg('End manual entry mode and set as current pzzle?',
                     mtconfirmation, [mbyes,mbno], 0)=mryes)
  then setcurrentbtnclick(sender);
  if usermode then exit;
  Setupcase(currentcase);
  with currentcase do
  if  (length(solution)=size*size) then
  begin
    r:=messagedlg('Solution already exists, search anyway?',mtconfirmation,[mbYes,mbNo],0);
    if r=mrno then
    begin
      with grid do
      begin
        for r:=0 to size-1 do
        for c:=0 to size-1 do
        begin
          cells[c,r]:= solution[r*size+c+1];
          if length(cells[c,r])=0 then cells[c,r]:=' ';
        end;
      end;
      unused.Text:='';
      exit;
    end;
  end;

  solutioncount:=0;
  with solutionmemo do
  begin
    clear;
    sendtoback;
  end;
  starttime:=now;
  label4.caption:=format('%d solutions found',[solutioncount]);
  tag:=0;
  stopflag:=false;
  With GenBtn do SetBusy(left, top);
  N:=currentcase.size;
  letters:=Currentcase.fillletters;

  with Grid, currentcase do  {add the hint letters}
  for i:= 1 to length(GridLetters) do
  if (gridletters[i] in ['A'..'Z'])
  then letters:=letters+gridletters[i];

  if length(letters)<> N*N
  then showmessage(format('There must be %d letters in grid + letters area',[N*N]))
  else
  with currentcase do
  begin
    {build a list of all possible words}
    setlength(rows,size);
    sortstrUp(letters);
    list:=TStringList.create;
    pubdic.Setrange('a',size,'z',size);
    while getnextNormalWord(w) do  {check all words of the correct length}
    begin
      OK:=true;
      testletters:=letters;
      w:=uppercase(w);
      for i:=size downto 1 do
      begin
        n:=pos(w[i],testletters);
        if n=0 then
        begin  {this word has a letter not in the list of all letters}
          OK:=false; {so reject it}
          break;
        end
        else delete(testLetters,n,1);
      end;
      if OK then list.add(w);
    end;
    if debug.Checked then
    Solutionmemo.lines.add(format('%d words before pruning',[list.Count]));
    {prune the list against the hints and delete words that could not possibly fit}
    with currentcase do
    begin
      setlength(ColWords,size);
      setlength(rowWords,size);
      setlength(collocs,size);
      setlength(rowlocs,size);
      setlength(ColRowWords,2*size);
    end;

    if not duplicates.checked then Usedwords:=TStringlist.Create;
    for i:=0 to size-1 do
    begin
      ColWords[i]:=TStringList.create;
      RowWords[i]:=TStringList.create;
    end;
    For  i:= 0 to list.Count-1 do
    with grid, currentcase do
    begin
      w:=list[i];
      for c:=0 to size-1 do
      begin {for each column}
        OK:=true;
        for r:=0 to size-1 do
        begin  {for each letter in the word}
          if (cells[c,r]<>' ') and (cells[c,r]<>w[r+1])
          then  {filled grid letters must match the word letters somewhere
                 on the grid }
           begin
            OK:=false;
            break;
          end;
        end;
        if OK then ColWords[c].add(w); {Found a place where this word could fit, break}
      end;
      begin {Check row words}
        for r:=0 to size-1 do
        begin {For reach row}
          OK:=true;
          for c:=0 to size-1 do
          begin {For each letter in the word}
            if (cells[c,r]<>' ') and (cells[c,r]<>w[c+1])
            then  {tobe OK filled grill letters must match word letters}             begin
              OK:=false;
              break;
            end;
          end;
          if OK then RowWords[r].add(w);
        end;
      end;
    end;

    {Sort each wordlist by increasing length}
    for i:=0 to size-1 do
    begin
      collocs[i]:=i;
      rowlocs[i]:=i;
    end;
    sortlist(ColWords,colLocs);
    sortlist(RowWords,rowlocs);
    //colrowlist.clear;
    {build
    {Merge the two lists into one }
    i:=0; j:=0;
    repeat
      with colrowwords[i+j] do
      //If colwords[i].Count <= rowwords[j].count then
      begin
        dir:='C';
        colrownbr:=collocs[i];
        nbrwords:=colwords[i].count;
        wordlist:=colwords[i];
        inc(i);
      end;
      //else
      //begin
      with colrowwords[i+j] do
      begin
        dir:='R';
        colrownbr:=rowlocs[j];
        nbrwords:=rowwords[j].count;
        wordlist:=rowwords[j];
        inc(j);
      end;
    until (i>currentcase.size-1) and (j>currentcase.size-1);




    //for k:=0 to lst.count-1 do
    //begin
      if debug.checked then
      for i:=0 to 2*size-2 do
      with  solutionmemo,lines do
      begin
        with colrowwords[i] do
        if dir='C' then
        add(format('Col %d, %d words',[colrownbr,nbrwords]))
        else add(format('Row: %d.  %d words',[colrownbr,nbrwords]));
      end;
      setlength(board,size,size);
      for r:=0 to size-1 do
    for c:=0 to size-1 do
    begin
      board[c,r]:=grid.cells[c,r][1];
    end;
    
    if PlaceNextWord(0, board) then
    begin
      updatetimelabel;
      showmessage('Solved!');
    end;  
    for i:=0 to currentcase.size-1 do
    begin
      ColWords[i].free;
      RowWords[i].free;
    end;
    if not duplicates.checked then Usedwords.Free;
  end;
  MoveToTop(SolutionMemo);
  SetUnBusy;
end;

{********** ResetAll **********}
procedure TForm1.ResetAll;

  var
    c,r:integer;
    save:TNotifyEvent;
  begin
    N:=sizegrp.itemindex+3;
    Unused.Text:='';
    usermode:=false;
    SetCurrentBtn.visible:=false;
    for c:=0 to N-1 do for r:=0 to N-1 do grid.cells[c,r]:=' ';
    with prefill do
    begin
      save:=onchange;
      onchange:=nil;
      value:=0;
      onchange:=save;
    end;
  end;

{************ GenBtnClick ***********}
procedure TForm1.genBtnClick(Sender: TObject);
{Generate a new random puzzle}
var
  N,start,row,c,r:integer;
  s:string;
  Test:TGrid;
  list:TStringlist;
  OK:boolean;
  loopcount:integer;

   {------------ PossibleSolution -------------}
   function PossibleSolution(row:integer):boolean;
   {check if Test array columns  0 through row have words in List starting
   with thos letters}
   var
     r,c,index:integer;
     w,listW:string;
     LenW:integer;
   begin
     result:=true;
     for c:=0 to N-1 do
     begin
       w:=test[c,0];
       for r:=1 to row do w:=w+test[c,r];
       list.find(w,index);
       if index<list.Count then
       begin
         listW:=list[index];
         LenW:=row+1;;
         if (length(ListW)>=LenW) and (copy(listw,1,lenW)<> w) then
         begin
           result:=false;
           break;
         end;
       end
       else result:=false;
     end;
   end;

   {--------- GetNextRow -----------}
   function getnextrow(next,row:integer):boolean;
   var
     c:integer;
     tempstart:integer;
     saveTest:TGrid;
   begin
     result:=false;
     setlength(savetest,N,N);
     application.processmessages;
     if tag>0 then exit;
     next:=random(list.Count);
     tempstart:=next;
     if row=N then
     begin
       result:=true;
       exit;
     end
     else
     repeat
       for c:=1 to N do test[c-1,row]:=list[next][c];
       if possibleSolution(row)
       then
       begin
         savetest:=test;
         result:=getnextrow(next,row+1);
         if not result then test:=savetest;
       end;
       if not result then
       begin;
         if next=list.count-1 then next:=0
         else inc(next);
       end;
     until result or (next=tempstart);
   end;

begin {GenBtnClick}
  if isbusy then exit;

  list:=TStringList.create;
  resetAll;
  N:=currentcase.Size;

  {for this task, we'll take a random word of length N and then
  check it as a possible top row of the grid (i.e. try all N length words that
  start with the letters of the top row word.  For each word added  as a row candidate,
  we'll trim the search spoace by making sure that there is at least one word
  that begins with  the column leters built so far}

  {1. Build a sorted list of N letter words}
  list.clear;
  with pubdic do
  begin
    setrange('a',N,'z',N);
    while getnextNormalWord(s) do list.add(uppercase(s));
  end;
  list.sort;
  setlength(Test,n,n);
  tag:=0;
  with GenBtn do Setbusy(left,top);

  loopcount:=0;
  repeat
    start:=random(list.count);
    row:=0;
    OK:=getnextrow(start,row);
    application.processmessages;
    inc(loopcount);
    if loopcount and $f=0 then
    begin
      if messagedlg(format('No solution after trying %d start words.  Keep looking?',[loopcount]),
                    mtconfirmation, [mbYes,mbNo],0)=mrNo then tag:=1;
    end;
  until OK or (tag<>0);

  screen.cursor:=crDefault;
  If not OK then Showmessage('No solution found');
  if OK then
  with currentcase do
  begin
    gridletters:='';
    size:=N;
    solution:='';
    for c:=0 to N-1 do
    for r:=0 to N-1 do
    begin
      solution:=solution+test[c,r];
    end;
    setupgridletters(Currentcase, true);
  end;
  setupcase(currentcase);
  list.free;
  SetUnBusy;
  grid.SetFocus;
end;

{********* DicGrpClick **********}
procedure TForm1.DicGrpClick(Sender: TObject);
{select a different dictionary}
begin
  If isBusy then exit;
  case DicGrp.itemindex of
    0:pubdic.LoadmediumDic;
    1:pubdic.loadlargedic;
  end;
  setunbusy;
end;

{***** PrefillChange ***********}
procedure TForm1.PrefillChange(Sender: TObject);
{User change the number of cell to pre-fill. Reinitialize the case}
begin
  If isbusy then exit;
  if not usermode then
  begin
    setupgridletters(currentcase, false);
    setupcase(currentcase);
  end
  else exit;
end;


{******* SizeGrpClick ***********}
procedure TForm1.SizegrpClick(Sender: TObject);
var
   c,r:integer;
begin
  If isbusy then exit;
  N:=Sizegrp.ItemIndex+3;
  currentcase.Size:=N;
  with grid do
  begin
    rowcount:=n;
    colcount:=n;
    adjustgridsize(grid);
  end;
  with grid do
  for c:=0 to colcount-1  do
  for r:=0 to rowcount-1 do  cells[c,r]:=' ';
  Prefill.MaxValue:=N*N;
  Prefill.MinValue:=0;
end;


{************ SetUpCase **********}
procedure TForm1.SetupCase(Rec:TCaserec);
var
  C,R:integer;
  ch:char;

  function lettercount(s:string):integer;
  var i:integer;
  begin
    result:=0;
    for i:=1 to length(s) do if s[i] in ['A'..'Z'] then inc(result);
  end;


begin  {SetupCase}
  with rec do
  begin

    fillletters:=uppercase(fillletters);
    sortstrup(fillLetters);
    gridletters:=uppercase(gridletters);
    if (size>=3) and (size<=5)
    and (length(fillletters)+lettercount(GridLetters)=size*size)
    then
    begin
      Unused.text:=FillLetters;
      //size:=sizegrp.ItemIndex+3;
      with Grid do
      begin
        colcount:=size;
        rowcount:=size;
        //setlength(board,size,size);
        for r:=0 to size-1 do
        for c:=0 to size-1 do
        begin
          ch:=gridletters[size*r+c+1];
          if  ch='.' then cells[c,r]:=' '
          else cells[c,r]:=ch;
          //board[c,r]:=cells[c,r][1];
        end;

      end;


      sizegrp.ItemIndex:= size-3;
      currentcase:=rec;
      solutionmemo.sendtoback;
      label4.Caption:='0 solutions found';
      Solutionmemo.Clear;

      CurrentLbl.Caption:='Current Puzzle: '+casename;
    end
    else showmessage('Error in puzzle definition Size must be 3, 4, or 5 and GridLetters + FillLetters must be Size*Size');
  end;
end;

procedure swap(var a,b:integer);
var temp:integer;
begin
  temp:=a;
  a:=b;
  b:=temp;
end;

{********** SetupGridLetters *************}
procedure TForm1.setupGridLetters(var caserec:TCaseRec; NewDeck:boolean);
{Called when prefill spin edit is clicked}
  var
    i,j,c:integer;
  begin
    with caserec do
    if length(solution)=size*size then
    begin  {has been solved}
      if newdeck then
      begin
        setlength(deck,size*size);
        for i:=0 to size*size-1  do deck[i]:=i+1;
        shuffle(deck);
        {rebuild the entire letter set and modify the deck to get origial prefills last}
        for i := 1 to length(gridletters) do if gridletters[i] in ['A'..'Z']
        then
        begin {find i in deck and swap that position to end of deck}
          j:=-1;
          repeat inc(j) until deck[j]=i;
          swap(deck[high(deck)],deck[j]);
        end;
      end;
      fillLetters:='';
      gridletters:=solution;

      for i:=0 to length(solution) -PreFill.value-1 do
      begin
        c:=deck[i];
        fillletters:=fillletters+gridletters[c];
        gridletters[c]:='.'
      end;
      sortstrup(fillletters);
    end
    else showmessage('Cannot pre-fill, solution not yet calculated');
  end;

{******** SetBusy ***********}
procedure TForm1.setbusy(L,T:integer);
  begin
    with stopPanel do
    begin
      top:=T;
      Left:=L;
      visible:=true;
    end;
    screen.cursor:=crHourGlass;

  end;

{************ SetUnBusy **********}
procedure TForm1.SetUnbusy;
  begin
    stopPanel.visible:=false;
    screen.cursor:=crdefault;
  end;

{********** IsBusy **********}
function Tform1.IsBusy:boolean;
begin
  result:=StopPanel.visible;
end;

{************ FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=true;
end;

{*********** ResetBtnClick ********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  if isbusy then exit;
  prefill.value:=currentcase.origHintcount;
  Setupcase(currentcase);
  usermode:=false;
  setCurrentBtn.visible:=false;
end;

{*************** SetCurrentBtnClick **********}
procedure TForm1.SetCurrentBtnClick(Sender: TObject);
 var
   c,r:integer;
   //prefillcount:integer;
   ch:char;
   newcase:TCaserec;
begin
  If isbusy then exit;
  if not checkmodified then exit;
  with newcase, grid do
  begin
    size:=Sizegrp.ItemIndex+3;
    fillletters:=unused.text;
    gridletters:='';
    prefillcount:=0;
    for r:=0 to colcount-1  do
    for c:=0 to rowcount-1 do
    begin
      if (length(cells[c,r])>0) and (cells[c,r][1] in ['A'..'Z'])
      then
      begin
        ch:=cells[c,r][1];
        inc(prefillcount);
      end
      else
      begin
        ch:='.';
        cells[c,r]:=' ';
      end;
      gridletters:=gridletters+ch;
    end;
    if  length(unused.text) + prefillcount = size*size then
    begin
      modified:=true;
      currentcase:=newcase;
      setupcase(currentcase);
      usermode:=false;
      SetcurrentBtn.Visible:=false;
      modified:=true;
    end
    else showmessage(format('There must be %d unused letters + prefilled grid letters'
                         +#13 +'You have defined %d letters, correct and retry',
                         [size*size, length(unused.text)+prefillcount]));
  end;
end;


{************ UnusedKeyDown *********}
procedure TForm1.UnusedKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  c,r:integer;
begin
  If not usermode then
  begin
    if messagedlg('Do you want to manually enter a new puzzle?',
    mtConfirmation, [mbYes, mbNo], 0) = mryes then
    if checkmodified then
    begin
      usermode:=true;
      prefill.Value:=0;
      prefill.Enabled:=false;
      if length(unused.text)<>1 then unused.Text:='';
      SetCurrentBtn.Visible:=true;
      showmessage(format('Enter %d letters here, then enter into the grid letters from this set '
               +'to be pre-filled.',[sqr(sizegrp.itemindex+3)]));
      with grid do
      for c:=0 to colcount-1 do
      for r:=0 to rowcount-1 do cells[c,r]:=' ';
    end;
  end;
end;


{************** LoadBtnClick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  if isbusy then exit;
  loadcase;
end;

{********** SaveBtnClick *************}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  if isbusy then exit;
  savecase;
end;

{*********** LoadCase **********}
Procedure TForm1.loadcase;
var
  ini:TInifile;
  msg:string;
  i:integer;
  tempcase:TCaserec;
  //prefillcount:integer;
begin
  if checkmodified then
  begin
    ini:=TInifile.create(inifilename);

    with Ini  do

    with puzzledlg, puzzlelist do
    begin
      readsections(Puzzlelist.items);
      itemindex:=items.indexof(currentcase.casename);
      if itemindex<0 then itemindex:=0;

      if (puzzledlg.showmodal=mrOK) //and (items[itemindex]<> currentcase.casename)
      then with tempcase do
      begin
        casename:=items[itemindex];
        size:=readinteger(casename,'Size', 3);
        FillLetters:=readstring(casename, 'FillLetters',' ');
        GridLetters:=readstring(casename,'GridLetters', ' ');
        Solution:=readstring(casename,'Solution',' ');
        dicindex:=readinteger(casename, 'Dictionary', 1);
        duplicates.checked:=readBool(casename,'Duplicates',true);
        dicgrp.itemindex:=dicindex;
        OrigHintcount:=0;
        for i:=1 to length(gridletters) do  if gridletters[i]in ['A'..'Z'] then inc(OrigHintCount);
        prefillcount:=origHintCount;
        msg:='';
        if (length(FillLetters)+prefillcount<>size*size)
        then msg:=format('Must be %d Fill letters (%s)+grid letters (%s)',[size*size, fillLetters, GridLetters]);
        if (msg='') and  (length(GridLetters)<>size*size)
        then msg:=format('Must be %d dots and grid letters (%s)',[size*size, GridLetters]);
        if (msg='') and (length(Solution)>0) and (length(GridLetters)<>size*size)
        then msg:=format('If solution exists, it m contain %d letters(%s)',[size*size, solution]);
        if msg<>'' then
        begin {error found}
          showmessage('Error in puzzle '+casename +'. Not loaded'
                      +#13 + msg);
        end
        else
        begin
          currentcase:=tempcase;
          sizegrp.itemindex:=size-3;
          usermode:=true; {to keep prefill change exit from calling setupgridletters}
          prefill.value:=prefillcount;
          usermode:=false;
          setupgridletters(tempcase, true);
          setupcase(tempcase);
        end;
      end;
    end;
  end;
end;

{************ Savecase *************}
procedure TForm1.savecase;
var
  ini:TInifile;
  r:integer;
begin
  ini:=TInifile.create(inifilename);

  with Ini, currentcase  do
  begin
    if length(solution)=0
    then r:=messagedlg('Solution not known, save anyway?', mtconfirmation,mbyesnocancel,0)
    else r:=mryes;
    if r=mryes then
    begin
      casename:=inputbox('Save current puzzle','Enter puzzle name', casename);
      writeinteger(Casename,'Size', size);
      writestring(Casename, 'FillLetters', FillLetters);
      writestring(casename, 'GridLetters', gridletters);
      writestring(casename, 'Solution',solution);
      writeinteger(casename,'Dictionary',dicgrp.itemindex);
      writebool(casename,'Duplicates',duplicates.checked);
    end;
    if r<> Mrcancel then  modified:=false;
  end;
  ini.free;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.



