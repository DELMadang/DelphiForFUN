unit U_WordGrid_3LetterWords2;
{Copyright © 2013,2015 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, udict, Grids, Inifiles, DFFUtils;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo5: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label2: TLabel;
    StaticText1: TStaticText;
    Stringgrid1: TStringGrid;
    Label1: TLabel;
    SearchBtn: TButton;
    FindAllBtn: TButton;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    StopBtn: TButton;
    CreateRandomBtn: TButton;
    HideSolutionBox: TCheckBox;
    ForeignBox: TCheckBox;
    Memo2: TMemo;
    CreateGivenBtn: TButton;
    SolutionRowGrp: TRadioGroup;
    ColGrp: TRadioGroup;
    AllRowWordsBox: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    //procedure FormCreate(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure Stringgrid1KeyPress(Sender: TObject; var Key: Char);
    procedure ForeignBoxClick(Sender: TObject);
    procedure ColGrpClick(Sender: TObject);
    procedure CreateGivenBtnClick(Sender: TObject);
    procedure SolutionRowGrpClick(Sender: TObject);
    procedure HideSolutionBoxClick(Sender: TObject);
    procedure CreateRandomBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Stringgrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
  public
    bitmap1,bitmap2:TBitmap;
    w3List, AllWordList:TStringlist;
    Columns:integer;
    Solution:string;
    rownbr:integer;
    r2,r3:string;
    Solutiostring:string;
    dir:string;
    procedure setsolutionFromWord(s:string);
    procedure setsolutionFromGrid;

    procedure makelists;
    function makePuzzle(r1:string; rownbr:integer):boolean;

    {Functions for creating pizzles}
    Function Validgrid:boolean;
    function FillFirstRow(startindex:integer; var index:integer; var ExitStop:boolean):boolean;
    function FillSecondRow:boolean;
    function fillwithNonWords:boolean;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



  {************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);

  {------------ MakeDefaultCase ----------}
  procedure makedefaultcase;
  var  i:integer;
       R1,R2,R3:string;
  begin
    colgrp.ItemIndex:=2;
    colgrpclick(sender);
    HideSolutionBox.Checked:=true;
    stringgrid1.colcount:=7;
    adjustgridsize(stringgrid1);
    r1:='ATTESTS';
    r2:='CHARIOT';
    R3:='TYRANNY';
    solution:=r2;
    with stringgrid1 do                                                         for i:=1 to ColCount do
    begin
      cells[i-1,0]:=R1[I];
      cells[i-1,1]:=' ';
      cells[i-1,2]:=r3[i];
    end;
    makelists;
  end;

begin
  //reformatmemo(memo5);
  dir:=extractFileDir(application.ExeName);
  opendialog1.InitialDir:=dir;
  savedialog1.InitialDir:=dir;
  w3List:=TStringlist.create;
  AllWordList:=TStringlist.create;
  Pubdic.loadlargedic;
  //colgrp.ItemIndex:=2;
  //Colgrpclick(sender);
  //adjustgridsize(stringgrid1);
  randomize;
  makedefaultcase;
  stopbtn.bringtofront;
end;

{************* SetSolutionFromGrid *************}
procedure TForm1.setsolutionFromGrid;
{Save the "word" currently in the row specified by SolutionRowGrp.itemindex}
var i,r:integer;
begin
  r:=solutionRowgrp.ItemIndex;
  setlength(solution,colGrp.itemindex+5);
  with stringgrid1 do
  for i:=0 to colcount-1 do
  begin
    solution[i+1]:=cells[i,r][1];
    if hidesolutionbox.checked then solution[i+1]:=' ';
  end;
end;





procedure TForm1.setSolutionFromWord(s:string);
{Save the "word" currently in the row specied by SolutionRowGrp.itemindex}
var i,r:integer;
begin
  colgrp.ItemIndex:=length(s)-5;
  r:=solutionRowgrp.ItemIndex;
  solution:=s;
  if not hidesolutionbox.Checked then
  with stringgrid1 do
  for i:=0 to colcount-1 do cells[i,r]:=solution[i+1];
end;



{********** MakeLists *********}
procedure TForm1.Makelists;
  var
    w:string;
    a,f,c:boolean;
  begin
    w3list.Clear;
    PubDic.setrange('a',3,'z',3);
    while Pubdic.getnextword(w,a,f,c) do
    if (not a) and (Foreignbox.Checked or (not f)) then w3list.add(uppercase(w));
    w3list.sort;
    {Now, put all of the N letter words in a string array for quick checking}
    AllWordlist.clear;
    pubdic.setrange('a',Columns,'z',Columns);
    while pubdic.getnextword(w,a,f,c) do
    {ignore appreviations and foreign (use 'use foeign is checked'}
    if (not a) and (foreignBox.Checked or (not f)) then AllWordList.add(uppercase(w));
    AllWordList.sort;
  end;

{************* MakePuzzle ************}
function TForm1.MakePuzzle(R1:string; rownbr:integer):boolean;
var
  result1:boolean;
  startindex,index:integer;
  exitstop:boolean;
begin
  tag:=0;
  result:=false;
  If validgrid then  {check setup}
  begin
    stopbtn.visible:=true;
    startIndex:=random(AllWordList.Count-1);  {start at random point}
    //startindex:=10000;  {repeatable start for testing}
    index:=startindex;
    exitstop:=false;
    result:=false;
    repeat
      inc(index);
      result1:=FillFirstRow(startIndex,index, exitstop);
      if result1 then result:= FillSecondRow;
      application.processmessages;
      if tag<>0 then exitstop:=true;
      (*
      if result1 then
      begin
        memo1.lines.add(r2);
      *)
    until result or  exitstop;
    stopbtn.visible:=false;
    if (not result)then
    begin
      if (not AllRowWordsBox.checked) then
      begin
        result:=FillWithNonWords;
        if not result then label1.caption:='No puzzle created for this solution '
        else label1.caption:='No "dictionary word" puzzle found, "letter sets" were used';
      end
      else Label1.caption:='No set of "dictionary clue" words found';
    end
    else label1.Caption:='Puzzle created with words'
  end;
end;

{************ ValidGrid ********}
Function TForm1.Validgrid:boolean;
{Before starting to create a pauzzle ensures that there is a valid word in
 the specified solution row and also blanks out the other two rows}
var
  i:integer;
  s:string;
begin
  rownbr:=solutionrowgrp.itemindex;
  s:='';
  with stringgrid1 do
  begin
    if solution='' then
    for i:=0 to colcount-1 do s:=s+cells[i,rownbr]
    else s:=solution;
    if allwordList.find(s,i) then
    begin
      result:=true;
      If rownbr<>0 then for i:=0 to colcount-1 do cells[i,0]:=' ';
      If rownbr<>1 then for i:=0 to colcount-1 do cells[i,1]:=' ';
      If rownbr<>2 then for i:=0 to colcount-1 do cells[i,2]:=' ';
    end
    else result:=false;
    update;
  end;

end;


{********* FillFirstRow *************}
Function TForm1.FillFirstRow(startindex:integer; var index:integer;
                              var ExitStop:boolean):boolean;
{In creating a puzzle, the solution row is given and the task is to fill the
 other two rows with wod to form a valid solution.  This function fills the first
 (uppermost) row to start accomplishing this task.}
  var
    j,n,index2:integer;
    w3:string;
    ok:boolean;
    stop:boolean;
  begin
    {look for valid first word}
    result:=false;
    If index>=allwordlist.count then exitstop:=true;
    if exitStop then exit;
    j:=index;
    stop:=false;
    OK:=true;
    while not stop do {look for valid words to complete the puzzle}
    begin
      {Find a word for the first unfilled row that could work}
      r2:=AllWordList[j];
      ok:=true;
      for n:=1 to columns do
      begin
        if rownbr<>2 then
        begin
          if rownbr=0 then w3:=solution[n]+r2[n]
          else if rownbr=1 then w3:=r2[n]+solution[n];
          {check first 2 letters to see if it could be a 3 letter word}
          w3list.find(w3,index2);
          if (index2<0) or
          ((index2>=0) and (index2<w3list.count) and (copy(w3list[index2],1,2)<>w3)) then
          begin
            ok:=false;
            break;
          end;
        end
        else
        begin  {solution in row 3}
          w3:=r2[n];
          w3list.find(w3[1],index2); {scan 3 letter words that start with this letter}
          ok:=false;
          if index2>=0 then  {1st letter match}
          repeat
            w3:=w3list[index2]; {scan 3-letter words starting with this letter}
            If w3[3]<>solution[n] then inc(index2)
            else OK:=true; {3rd letter of this 3-letter word matches nth letter of solution}
          until OK or (w3[1]<>r2[n]) or (index2>=w3list.count);
        end;
        if not ok then break;
      end; {for i over column}

      if not OK then
      begin
        inc(j);
        {For debugging
        label1.caption:=format('SIndex=%d, Index=%d, J=%d',[startindex,index,j]);
        label1.update;
        }
        if j>=AllWordList.Count then j:=0; {loop around from random start point}
        if j=startindex+1 then
        begin
          exitstop:=true;
          stop:=true;
          OK:=false;
        end;
      end
      else stop:=true;
    end;
    index:=j;
    result:=OK
  end;

{************ FillSecondRow ************}
Function TForm1.FillSecondRow:boolean;
{In creating a puzzle, the solution row is given and the task is to fill then
 other two rows with wod to form a valid solution.  This fill the second (and final)
 row to accomplish this task}
var
    i,J,n,index:integer;
    w3:string;
    ok:boolean;
    stop:boolean;
    startIndex:integer;
Begin
    //If Ok then {there are one or more 3 letter words whose 1st 2 letters match
    //             each of the letters for the top two rows}
  stop:=false;
  result:=false;
  startIndex:=random(AllWordList.Count);  {start at random point}
  j:=startindex;
  while not stop do
  begin   {now look for a 3rd six lettter word which completes the six columns of 3 letter words}
    r3:=AllWordList[j];
    OK:=true;
    for n:=1 to columns do
    begin {check for valid 3 letter words}
      if rownbr=0 then w3:=solution[n]+r2[n]+r3[n]
      else if rownbr=1 then w3:=r2[n]+solution[n]+r3[n]
      else  w3:=r2[n]+r3[n]+solution[n];
      if not w3list.find(w3, index) then
      begin
        ok:=false;
        break;
      end;
    end;
    if Ok then
    begin  {found them!}
      solution:=uppercase(solution);
      r2:=uppercase(r2);
      r3:=uppercase(r3);
      with stringgrid1 do
      for i:=1 to columns do
      begin
        CASE  rownbr of
        0:
        begin
          if hideSolutionBox.Checked  then cells[i-1,0]:=' ' else cells[i-1,0]:=solution[i];
          cells[i-1,1]:=r2[i];
          cells[i-1,2]:=r3[i];
        end;
        1:
        begin
          if hideSolutionBox.Checked  then cells[i-1,1]:=' ' else cells[i-1,1]:=solution[i];
          cells[i-1,0]:=r2[i];
          cells[i-1,2]:=r3[i];
        end;
        2:
        begin
          if hideSolutionBox.Checked  then cells[i-1,21]:=' ' else cells[i-1,2]:=solution[i];
          cells[i-1,0]:=r2[i];
          cells[i-1,1]:=r3[i];
        end;
        end;
      end;

      result:=true;
      application.processmessages;
      stop:=true;
    end
    else
    begin;
      inc(j);
      if j>=AllWordList.Count then j:=0; {loop around from random start point}
      if j=startindex then
      begin
        result:=false;
        stop:=true;
      end;
    end;
  end;
end;

{************ FillWithNonWords **************}
function TForm1.fillwithNonWords:boolean;
{Called to create a puzzle only if no puzzle build with words can be found}
  var
    i,j:integer;
    w3:string;
    list:TStringlist;

  begin {the easier case, find any six 3 letter words to compete the puzzle with
          the given solution word}
    list:=TStringlist.create;
    result:=false;
    {make a list of 3 letter words for each 1st letter and choose a random one }
    //solution:=r1;
    for i:=1 to columns do
    begin

      list.clear;
      {Build a separate list of all 3 letter words with the letter at position
       i of the solution words row matching  postion i in the solution word}
      for j:=0 to w3list.count-1 do
      begin
        if w3list[j][rownbr+1]=solution[i]
        then list.add(w3list[j]);
      end;
      if list.count>0 then
      with stringgrid1 do
      begin
        w3:=uppercase(list[random(list.count)]); {Pick a random word from the list}

        case rownbr of
          0:
          begin
            cells[i-1,1]:=w3[2];
            cells[i-1,2]:=w3[3];
          end;
          1:
          begin
            cells[i-1,0]:=w3[1];
            cells[i-1,2]:=w3[3];
          end;
          2:
          begin
            cells[i-1,0]:=w3[1];
            cells[i-1,1]:=w3[2];
          end;
        end; {case}
        if hideSolutionBox.Checked
        then cells[i-1,rownbr]:=' ';// else cells[i-1,rownbr]:=w[i];
        result:=true;
      end
      else break;
    end;
    list.free;
  end;

{************** SearchBtnClick ************}
procedure TForm1.SearchBtnClick(Sender: TObject);
  var
  i,index,n,j:integer;
  fillrow,u1,u2:integer;
  w:string;
  w3:string;
  test2,test3:string;
  OK:boolean;
  findall:boolean;

begin
  {Check all 5, 6, or 7 letter words in the empty grid row,
   i.e the missing letters in each column complete valid three letter words
  -------------------------------------------------------}
  findall:=sender=findallbtn;  {search for all solutions and list them in Memo1  if true
                                otherwise find the first solution and post it in stringGrid1}
  memo1.Clear;
  hidesolutionbox.checked:=false;
  screen.cursor:=crHourGlass;
  {include capitalized words but not abbreviations or foreign as solutions}

  {if we find a blank row, make it the solution row}
  with stringgrid1 do
  for j:=0 to 2 do
  begin
    ok:=true;
    for i:=0 to colcount -1 do
    begin
      if length(cells[i,j])=0 then cells[i,j]:=' ';
      if cells[i,j]<>' ' then
      begin
        ok:=false;
        break;
      end;
    end;
    if ok then
    begin
      solutionrowgrp.itemindex:=j;
      break;
    end;
  end;
  fillrow:=solutionrowgrp.itemindex;
  WITH AllWordList, stringgrid1 DO
  begin
    n:=0;
    case fillrow of
      0: begin u1:=1; u2:=2;  end; {solution in 0,fill rows 1 and 2}
      1: begin u1:=0; u2:=2;  end; {solution in 1,fill rows 0 and 2}
      2: begin u1:=0; u2:=1;  end; {solution in 2,fill rows 0 and 1}
    end;
    test2:=cells[0,u1];
    test3:=cells[0,u2];
    for i:=1 to colcount-1 do
    begin
      if (trim(cells[i,u1])='')
      or (trim(cells[i,u2])='') then
      begin
        showmessage(format('To solve for row %d, rows %d and %d must be filled',
                        [fillrow,u1,u2]));
        exit;
      end;
      test2:=test2+cells[i,u1];
      test3:=test3+cells[i,u2];


    end;

    for j:=0 to count-1 do {for allwords}
    begin
      w:=AllWordList[j];
      inc(n);
      ok:=true;
      {check each letter of the word with the corresponding letters from rows 2 and 3}
      for i:=1 to Columns do
      begin
        case fillrow of
          0:  w3:=w[i]+test2[i]+test3[i];
          1:  w3:=test2[i]+w[i]+test3[i];
          2:  w3:=test2[i]+test3[i]+w[i];
        end;
        if not w3list.find(w3,index) then
        begin {not a word, stop checking}
          OK:=false;
          break;
        end;
      end;
      if OK then
      begin
        if findall then  memo1.lines.add(uppercase(w)) {found a solution - list it}
        else
        with stringgrid1 do
        begin
          solution:=w;
          hidesolutionbox.checked:=false;
          for i:=1 to colcount do cells[i-1,fillrow]:= upcase(w[i]);
          break; {single solution found, break out of search loop}
        end;
      end;
    end;
    if findall
    then memo1.Lines.Add(format('%d row length words were checked against %d  three letter words',
                              [n,w3list.count]));
  end;
  //else showmessage('No blank row to fill found in the grid'); ;
  screen.cursor:=crDefault;
end;

{************* StringGridKeyPress ************}
procedure TForm1.Stringgrid1KeyPress(Sender: TObject; var Key: Char);
begin
  with stringgrid1 do
  begin
    cells[col,row]:=upcase(key);
    if col< colcount-1 then col:=col+1
    else
    begin
      col:=0;
      if row =2 then row:=0 else row:=row+1;
    end;
  end;
  //Hidesolutionbox.checked;
  //solution:='       ';  {Entering any data removes any previously set solution}
end;

{********** ForeignBoxClick ***********}
procedure TForm1.ForeignBoxClick(Sender: TObject);
begin
  screen.cursor:=crhourglass;
  makelists;  {include or exclude foreign words}
  screen.cursor:=crdefault;
end;

{********** ColGrpClick *********}
procedure TForm1.ColGrpClick(Sender: TObject);
begin
  columns:=colgrp.ItemIndex+5;
  stringgrid1.ColCount:=columns;
  adjustgridsize(stringgrid1);
  makelists;
end;


{************* CreateBtnClick *************}
procedure TForm1.CreateGivenBtnClick(Sender: TObject);

    {----------- ClearGrid -------------}
    procedure Cleargrid;
    {clear non-posiion cells}
    var c,r:integer;
    begin
      with stringgrid1 do
      for r:=0 to 2 do
      if r<>solutionrowgrp.itemindex then
      for c:=0 to colcount-1 do cells[c,r]:=' ';
    end;

var
  j:integer;
  OK:boolean;
begin  {CreateBtnClick}
  memo1.clear;
  hidesolutionbox.checked:=false;
  cleargrid;
  screen.cursor:=crhourglass;
  rownbr:=solutionrowgrp.ItemIndex;
  if sender=createGivenbtn  then
  begin  {setup possible solution word}
    OK:=true; solution:='';
    with stringgrid1 do for j:=0 to colcount-1 do
    begin
      if (length(cells[j,rownbr])>0) and (cells[j,rownbr]<>' ')
      then  solution:=solution+cells[j,rownbr]
      else
      begin
        OK:=false;
        break;
      end;
    end;
  end
  else OK:=true; {call from create random btn, solution already set}
  if OK then
  begin
    OK:=Makepuzzle(solution,rownbr);
    if (not OK) and (sender<>CreateRandomBtn) then showmessage('No solution found')
    else savedialog1.FileName:='New_Puzzle';
  end
  else if sender <> createRandomBtn
  then showmessage(format('Row %d must contain a predefined solution word',[rownbr+1]));

  screen.cursor:=crDefault;
  CreateGivenBtn.tag:=ord(OK);
end;

{********** SolutonRowGrpClick ***********}
procedure TForm1.SolutionRowGrpClick(Sender: TObject);
begin
  //setsolutionfromGrid;
end;

{********** HideSolutionBoxClick *******}
procedure TForm1.HideSolutionBoxClick(Sender: TObject);
var i,r:integer;
begin
  r:=solutionRowgrp.ItemIndex;
  with stringgrid1 do
  for i:= 0 to colcount-1 do
  if not hidesolutionBox.Checked  then  cells[i,r]:=solution[i+1]
  else cells[i,r]:=' ';
end;



{**************** CreateRandomBtnCkick ***********}
procedure TForm1.CreateRandomBtnClick(Sender: TObject);
begin
  rownbr:=solutionrowgrp.ItemIndex;
  repeat
    setsolutionFromWord(allwordlist[random(allwordlist.Count)]);
    CreateGivenBtn.Tag:=0;
    createGivenBtnClick(sender);
  until (creategivenbtn.tag<>0)
end;


{**************** SaveBtnClick ***************}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  c,r:integer;
  s:string;
  ini:TInifile;
begin
  if savedialog1.execute then
  begin
    ini:=TInifile.create(savedialog1.filename);
    with ini do
    begin
      writeinteger('Params','Columns', colgrp.itemindex);
      writeinteger('Params','SolutionRow', SolutionRowGrp.itemindex);
      WriteBool('Params','Foreign', ForeignBox.checked);
      WriteBool('Params','HideSolution', HideSolutionBox.checked);
      WriteString('Params','Solution',Solution);
      with Stringgrid1 do
      for r:=0 to 2 do
      begin
        s:='';
        for c:=0 to colcount-1 do s:=s+cells[c,r][1];
        writestring('Data','Row'+inttostr(r),s);
      end;
      free;
    end;
  end;
end;

{************ LoadBtnlick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  c,r:integer;
  s:string;
  ini:TInifile;
begin
  if opendialog1.execute then
  begin
    savedialog1.FileName:=opendialog1.FileName;
    ini:=TInifile.create(opendialog1.filename);
    with ini do
    begin
      colgrp.ItemIndex:=readinteger('Params','Columns', 7);
      solutionRowGrp.itemindex:=readinteger('Params','SolutionRow', 2);
      ForeignBox.Checked:=readbool('Params','Foreign', false);
      HideSolutionbox.Checked:=readbool('Params','HideSolution', true);
      solution:=ReadString('Params','Solution','UnKnown');
      stringgrid1.ColCount:=colgrp.ItemIndex+5;

      with Stringgrid1 do
      for r:=0 to 2 do
      if (not hideSolutionbox.checked)
        or (HideSolutionbox.checked and (r<>solutionrowgrp.itemindex))
      then
      begin
        s:=readstring('Data','Row'+inttostr(r),'Unknown');
        for c:=0 to colcount-1 do cells[c,r]:= s[c+1];
      end
      else for c:=0 to colcount-1 do cells[c,r]:=' ';
      free;
    end;
  end;
end;

{************* StringGridDrawCell **************}
procedure TForm1.Stringgrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  IgnoreSelectedDrawCell(Sender,ACol, ARow,Rect,State);
end;

{************ StopBtnClick ********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
  StopBtn.visible:=false;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
