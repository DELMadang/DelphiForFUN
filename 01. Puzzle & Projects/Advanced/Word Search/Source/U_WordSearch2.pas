Unit U_WordSearch2;
{Copyright © 2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Our "Brain Games" daily calendar puzzles are usually pretty good, but the
author of the one included here thinks that "Cyclist" is the only answer (he
does not consider "Y" to be a vowel).

Fill in the parameters in the parameter boxes to check it out for yourself.

Future enhancements may include searches for puzzle variations which require
finding embedded or interlaced words from a given set  of letters.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, UDict, Spin, jpeg, Grids, DFFUtils,
  Inifiles, strutils;

type

  TFoundby=(P{Program}, U{User}, None);
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    UserModeGrp: TRadioGroup;
    Grid: TStringGrid;
    SaveBtn: TButton;
    LoadBtn: TButton;
    Search2Btn: TButton;
    Memo3: TMemo;
    StaticText1: TStaticText;
    FoundWordList: TListBox;
    GroupBox1: TGroupBox;
    AllowedRGrp: TRadioGroup;
    TargetWordlist: TListBox;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    MinLettersEdt: TSpinEdit;
    Label2: TLabel;
    MaxLettersEdt: TSpinEdit;
    Label3: TLabel;
    ColcountEdt: TSpinEdit;
    Label14: TLabel;
    RowCountEdt: TSpinEdit;
    Label15: TLabel;
    Label4: TLabel;
    IntroMemo: TMemo;
    Memo1: TMemo;
    Label5: TLabel;
    Label6: TLabel;
    Revisitbox: TCheckBox;
    ResetBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MaxLettersEdtChange(Sender: TObject);
    procedure MinLettersEdtChange(Sender: TObject);
    procedure Search2BtnClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure GridSizeChange(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure FoundWordMemoClick(Sender: TObject);
    procedure GridClick(Sender: TObject);
    procedure UserModeGrpClick(Sender: TObject);
    procedure SetModified(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure TargetWordlistClick(Sender: TObject);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridDblClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
  public
    boardsize:TPoint;
    expandedwordlist:TStringList; {stores target words if given}
                             {or all dictionary words of valid length}
    maxwordsize, minwordsize:integer;
    dir:string;
    modified:boolean;
    LoadFilename:string;
    TargetWordCount:integer;
    Celloffsetx, Celloffsety:integer;
    foundby:TFoundby;
    replaying:boolean;  {set true while redisplaying a found word}
    Procedure SetupDefaultCase;
    function checkModified:boolean;
    function GetNextCrookedPath(startpoint:TPoint;var partialword:string):boolean;
    function GetNextStraightPath(startpoint:TPoint;var partialword:string;
                                     Direction:Integer):boolean;
    function couldbeword(pdic:TDic;w:string; var isword:boolean):boolean;
    procedure zeropaths;
    procedure zeroboard;
    procedure ClearexpandedWordList;
    procedure ClearFoundWordList;
    procedure checkforword;
    procedure addfoundword(w:string; currlist:TStringlist);
    procedure replayword(wordlist:TListBox; itemnbr:Integer);
    procedure ResetHighlighting(list:TStringlist);
end;

var
  Form1: TForm1;

implementation

uses math, U_TargetDialog;
{$R *.DFM}

var
  offsets:array[1..8] of TPoint= ((x:-1;Y:-1),(x:-1;y:0),(x:-1;Y:1),
                                  (X:0;y:-1), (X:0;y:1),
                                  (x:1;y:-1),(x:1;y:0),(x:1;y:1));

  {"Paths" keeps track of whether a cell is in the current path}
  paths:array of array of integer;
  pathcount:integer;
  currentwordlist:TStringList;

{******** SetupDefaultcase **********}
Procedure TForm1.SetupDefaultCase;
var
  c,r:integer;
  data:array[0..4] of string;
begin
  {set up default GridSearch case}
  with  Grid do
  begin
    colcountedt.value:=5;
    rowcountedt.value:=5;

    data[0]:='YTVSB';
    data[1]:='HWRLJ';
    data[2]:='GAOIE';
    data[3]:='UNFCX';
    data[4]:='ZPDKM';
    for r:=0 to 4 do
    for c:=0 to 4 do cells[c,r]:=data[r][c+1]+' ';
    minlettersedt.value:=7;
    maxlettersedt.Value:=7;
    AllowedRGrp.ItemIndex:=0;
    setlength (paths,7);{+2 allows for sentinel border to simplify search}
    self.modified:=false;
    Usermodegrp.itemindex:=0;
    TargetWordcount:=0;
    GroupBox1.Caption:='Current puzzle: Default';
  end;
end;

{*************** FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  pubdic.loadLargeDic;
  expandedwordlist:=TStringlist.create;
  SetupDefaultcase;
  dir:=extractfilepath(application.exename);
  opendialog1.InitialDir:=dir;
  savedialog1.initialdir:=dir;
  currentwordlist:=TStringlist.Create;
  foundby:=None;  {no found words}
  replaying:=false; {not replating a found word}
end;

{************ MaxLettersEdtChange **********88}
procedure TForm1.MaxLettersEdtChange(Sender: TObject);
begin
  If MinLettersEdt.value >  MaxLettersEdt.value
  then MinLettersEdt.value :=  MaxLettersEdt.value ;
  maxwordsize:=maxlettersedt.Value;
end;

{*********** MinLettersEdtChange ************}
procedure TForm1.MinLettersEdtChange(Sender: TObject);
begin
  If maxlettersEdt.value<minLettersEdt.value
  then maxlettersEdt.value  := minlettersEdt.value;
  minwordsize:=minlettersedt.Value;
  setmodified(sender);
end;

{**************** CouldBeWord ************}
function TForm1.couldbeword(pdic:TDic;w:string; var isword:boolean):boolean;
{Test to see if the current partial word could be a word, i.e there is an
entry in the dictionary that begins with these letters}
var
  trialword:string;
  a,f,c:boolean;
  index,index2:integer;
  newlist:TStringlist;
  len:integer;
  w2:string;
begin
  result:=false;
  isword:=false;
  len:=length(w);
  w:=uppercase(w);
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
  if length(w)>0 then
  with  pdic do
  begin {build a new entry with all possible words starting with these three
          letters and in the allowed length range}
    setrange(w[1],minwordsize,w[1],maxwordsize);
    newlist:=TStringlist.create;
    expandedwordlist.insertobject(index,w,newlist);
    while (getnextword(trialword,a,f,c)) do
    with newlist do
    begin
      trialword:=uppercase(trialword);
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

{********************* TForm1.ZeroBoard ***********************}
procedure TForm1.zeroboard;
{Initialize the paths array marking borders inaccessable}
var
  i,j:integer;
begin
  for i:= low(paths) to high(paths) do
  begin
    setlength(paths[i],boardsize.y+2);
    for j:=low(paths[i]) to high(paths[i]) do
    {Put in guards for porters}
    if (i=low(paths)) or (i=high(paths)) or (j=low(paths[i])) or (j=high(paths[i]))
    then paths[i,j]:=maxint else paths[i,j]:=0;
  end;
  pathcount:=1;
  ClearexpandedWordList;
end;

{********************* TForm1.ZeroPaths ***********************}
procedure TForm1.zeroPaths;
{Initialize the paths array leaving borders inaccessable}
var
  i,j:integer;
begin
  for i:= low(paths)+1 to high(paths)-1 do
  for j:=low(paths[i])+1 to high(paths[i])-1 do
  paths[i,j]:=0;
  pathcount:=1;
end;

{************** ClearexpandedWordList ************}
procedure TForm1.ClearFoundWordList;
var i:integer;
begin
  with FoundWordList do
  for i:=0 to count-1 do if assigned(items.objects[i])
  then (TStringlist(items.objects[i]).free);
  foundwordlist.clear;
end;

{************** ClearexpandedWordList ************}
procedure TForm1.ClearexpandedWordList;
var i:integer;
begin
  for i:=0 to expandedwordList.count-1 do
  TstringList(expandedwordList.objects[i]).free;
  expandedwordList.clear;
end;



   {The function Borland forgot}
function lowcase(c:char):char;
begin
  if c in ['A'..'Z']
  then result:=char(ord(c) or $20)
  else result:=c;
end;

{********************* TForm1.GetNextCrookedPath *************************}
function TForm1.GetNextCrookedPath(startpoint:TPoint;var partialword:string):boolean;
{The heart of the recursive path search for new words }
var
  i,len:integer;
  nextpoint:Tpoint;
  isword:boolean;
  c:char;
  PathCountstring:string;
begin
  result:=false;
  if tag<>0 then begin result:=false; exit; end;
  for i:= 1 to 8 do {try all 8 possible move directions}
  begin
    nextpoint.x:=startpoint.x+offsets[i].x;
    nextpoint.y:=startpoint.y+offsets[i].y;
    pathcountString:=format('%2d',[pathcount]);
    if (paths[nextpoint.x,nextpoint.y]=0)or
    (revisitbox.checked and (paths[nextpoint.x,nextpoint.y]<=pathcount) )
    (*
    or (revisitbox.checked and (nextpoint.x>=0) and (nextpoint.y>=0)
        and (nextpoint.x<grid.ColCount) and (nextpoint.y<grid.rowcount)
        )*)
    then {we can visit}
    begin

      with nextpoint do  paths[x,y]:=pathcount; {mark as visited}
      {add lowercase character from grid to potential word}
      c:=char(ord(grid.cells[nextpoint.x-1,nextpoint.y-1][1]) {or $20});
      //pathstring:=pathstring  + char(ord(c)  {or $20});
      //with nextpoint do pathlocs.add(100*x+y);
      with nextpoint do currentwordlist.Add(c+format('%2d%2d',[x-1,y-1]));
      partialword:=partialword+c;
      len:=currentwordlist.count;
      {could it be a word?}
      if (len>=3) then   {we've gone three steps - check and see if any words start with these three}
      begin
        if (couldbeword(pubdic,partialword,isword)) and (tag=0) then {keep searching}
        begin
          {is it a word?}
          if isword then Addfoundword(partialword,currentwordlist);
          {continue searching}
          result:=GetNextCrookedPath(nextpoint,partialword);
        end;
      end
      else result:=GetNextCrookedPath(nextpoint,partialword);
      {make this node available again}
      with nextpoint do paths[x,y]:=0;
      with currentwordlist do delete(count-1);
      {and erase the last character}
      delete(partialword,length(partialword),1);
    end;
  end;
end;


{********************* TForm1.GetNextStraightPath *************************}
function TForm1.GetNextStraightPath(startpoint:TPoint;var partialword:string;
                               Direction:integer):boolean;
{The heart of the recursive straight path search for new words }
var
  i,len,index:integer;
  nextpoint:Tpoint;
  isword:boolean;
  c:char;

  function getDist(dir:integer):integer;
  {Return the maximum length word in the given current direction}
  begin
    with startpoint do
    case dir of
      1: {NW} result:=min(X, y);
      2: {W}  result:=x;
      3: {SW} result:=min(x, boardsize.Y-y+1);
      4: {N}  result:=y;
      5: {S}  result:=boardsize.Y-y+1;
      6: {NW} result:=min(boardsize.x-x+1,y);
      7: {E} result:=boardsize.X-x+1;
      8: {SE} result:=min(boardsize.X-x+1, boardsize.Y-y+1);
      else result:=0;
    end;
  end;


begin
  result:=false;
  if tag<>0 then begin result:=false; exit; end;
                   { Left, Right, Up, Down,
                    NorthEast, NorthWest, SouthEast,SouthWest}
  begin
    I:=direction;
    If (length(Partialword)=1)  and (GetDist(i)<minWordSize) then exit;
    nextpoint.x:=startpoint.x+offsets[i].x;
    nextpoint.y:=startpoint.y+offsets[i].y;
    if paths[nextpoint.x,nextpoint.y]=0 then {we can visit}
    begin
      with nextpoint do paths[x,y]:=pathcount; {mark as visited}
      {add lowercase character from grid to potential word}
      c:=grid.cells[nextpoint.X-1,nextpoint.Y-1][1];
      partialword:=partialword  + c;
      with nextpoint do currentwordlist.Add(c+format('%2d%2d',[x-1,y-1]));
      len:=length(partialword);
      {could it be a word?}
      if (len>=3) then   {we've gone three steps - check and see if any words start with these three}
      begin
        if TargetWordList.items.count = 0 then
        begin  {use dictionary to validate words}
          if (couldbeword(pubdic,partialword,isword)) and (tag=0) then {keep searching}
          begin
            {is it a word?}
            if isword then
            begin
              addfoundword(partialword,currentwordlist);
              {continue searching}
              result:=GetNextStraightPath(nextpoint,partialword, direction);
            end;
          end
          else result:=GetNextStraightPath(nextpoint,partialword,direction);
        end
        else {words must be from wordlist}
        with Targetwordlist do
        begin
          index:= items.indexof(partialword);
          if index>=0 then
          begin
            addfoundword(partialword,currentwordlist);
          end;
          result:=GetNextStraightPath(nextpoint,partialword,direction);
        end;
      end
      else result:=GetNextStraightPath(nextpoint,partialword, direction);
      with nextpoint do paths[x,y]:=0;    {make  this node available again}
      with currentwordlist do delete(count-1);
      delete(partialword,length(partialword),1);
    end;
  end;
end;

{************ Search2BtnClick **********}
procedure TForm1.Search2BtnClick(Sender: TObject);
var
  frompoint:TPoint;
  partialword:string;
  i, c,r, Dir:integer;
  ch:char;
  list:TStringlist;
begin
  {solve paths from a single starting point and increment starting point to next cell}
  screen.Cursor:=crhourGlass;
  with grid do boardsize:=point(rowcount,colcount);
  setlength(paths, boardsize.x+2);
  resetbtnclick(sender);
  //zeroboard;
  with grid do  {reset any highlighted letters in the grid}
  for c:=0 to colcount-1 do for r:=0 to rowcount-1 do Cells[c,r] := cells[c,r][1]+' ';
  grid.update;
  frompoint:=Point(1,1);
  //ClearexpandedWordList;
  //ClearFoundWordList;

  Foundby:=P;
  while frompoint.x<=boardsize.x do
  with frompoint do
  begin
    zeropaths; {can't revisit a cell within a single word}
    Currentwordlist.Clear;
    ch:=(grid.cells[x-1,y-1][1]);
    partialword:=ch;
    paths[x,y]:=pathcount; {mark as visited}
    currentwordlist.Add(ch+format('%2d%2d',[x-1,y-1]));
    if allowedrgrp.itemindex=0 {crookedpath}
    then GetNextCrookedPath(frompoint,partialword{, currentwordlist})
    else {straightpath - try all 8 directions from this point}
    for Dir:=1 to 8 do
    begin
      zeropaths; {can't revisit a cell within a single word}
      currentwordList.clear;
      currentwordlist.Add(ch+format('%2d%2d',[x-1,y-1]));
      GetNextStraightPath(frompoint,partialWord,{currentwordlist,} Dir);
    end;
    inc(y); {Move to next start point}
    if y>boardsize.y then
    begin
      y:=1;
      inc(x);
    end;
  end;
  if foundwordList.count>0
  then
  begin  {sort items}
    list:=tstringlist.create;
    with foundwordlist,items do
    begin
      for i:= 0 to count-1 do list.addobject(strings[i], TStringlist(objects[i]));
      list.sort;
      foundwordlist.Clear;
      for i:= 0 to list.count-1 do addobject(list.strings[i],TStringlist(list.objects[i]));
    end;
    list.Free;
  end
  else FoundWordList.Items.add('None found');
  currentwordlist.clear;
  screen.Cursor:=crDefault;
end;

{*********** GridDrawCell ***********}
procedure TForm1.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var c:char;
    blink:boolean;
begin
  with Grid, canvas do
  begin
    if  (usermodegrp.itemindex=1) and (gdfocused in state )
    then brush.color:=clSkyBlue  else brush.color:=clwindow;
    canvas.rectangle(rect);
    blink:=false;
    if (length(cells[acol,arow])>1) and (cells[acol,arow][2]='!')
    then
    begin
      //if font.color=clred then blink:=true;
      font.color:=clred;
    end
    else font.color:=clblack;
    if length(cells[acol,arow])>0
    then with rect do
    begin
      c:=cells[acol,arow][1];
      textout(left+CellOffsetX, top+CellOffsetY,c);
      //if blink then windows.beep(25,400);
    end;
  end;
end;

{************** ValidOffsets ***********}
function ValidOffsets(P1,P2:TPoint):boolean;
{Return true if the two passed point are connected in ant of the 8 directions}
var
  i:integer;
  xx,yy:integer;
begin
  result:=false;
  xx:=P1.X-p2.X;
  yy:=p1.Y-p2.Y;
  for i:=1 to 8 do
  with offsets[i] do
  if (xx=x) and (yy=y) then
  begin
    result:=true;
    break;
  end;
end;
{************ GridKeyPress ***************}
procedure TForm1.GridKeyPress(Sender: TObject; var Key: Char);

begin
  if upcase(Key) in ['A'..'Z'] then
  begin
    key:=upcase(key);
  end;
end;


var
  ok_keys:array[0..4] of word =(VK_Left, VK_Up, VK_Down, VK_Right,VK_Back);


{************* GridKeyDown **************}
procedure TForm1.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  OK:boolean;
  i:integer;
begin
  if replaying then exit;
  with Grid do
  begin
    if usermodegrp.itemindex=0 then
    begin
      if (key=VK_Return) or (Key=VK_Space)  then checkforWord;
    end
    else
    begin  {modify mode set}
      If CHAR(key) in ['a'..'z'] then key:=key and $DF; {make uppercase}
      OK:=true;
      if not (char(key) in ['A'..'Z']) then
      begin
        for i:=0 to high(OK_Keys) do
        if key=OK_Keys[i] then   {allow arrow keys, backspace, etc.}
        begin
          ok:=true;
          break;
        end;
        if not OK then key:=0;
      end;
    end;
  end;
end;

{************* GridKeyUp ************}
procedure TForm1.GridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if replaying then exit;
  if usermodegrp.itemindex=1 then {modify mode}
  if  (key=VK_TAB) or (char(key) in ['A'..'Z']) then
  with grid do
  begin {move selection to next logical cell}
    if col<colcount-1 then col:=col+1
    else If col=colcount-1 then
    begin
      col:=0;
      if row<rowcount-1 then row:=row+1
      else
      row:=0;
    end;
    key:=0;
  end;
end;

{***** GridSizeChange ********}
procedure TForm1.GridSizeChange(Sender: TObject);
var
  c,r,n:integer;

  procedure AdjustGridCellSize(Grid:TStringgrid; ccount, rcount:integer);
  begin
    with grid do
    begin
      defaultcolwidth:=(width-4-ccount) DIV (ccount) ;
      defaultrowheight:=(height-4 -rcount) DIV (rcount);
      font.Size := (min(defaultcolwidth,defaultrowheight)*9 div 10 -2) * 72
                                   div Font.PixelsPerInch;
      canvas.font.assign(font);
      cellOffsetx:=(defaultcolwidth-canvas.textwidth('X')) div 2;
      cellOffsety:=(defaultrowheight-canvas.textheight('ALX')) div 2;
    end;
  end;


begin
  if replaying then exit;
  with grid do
  begin
    colcount:=Colcountedt.Value;
    rowcount:=RowCountEdt.Value;
    adjustgridcellSize(grid, colcount, rowcount);
    for c:=0 to colcount-1 do for r:=0 to rowcount-1 do
    begin
      n:=length(cells[c,r]);
      if n<2 then cells[c,r]:=cells[c,r] + ' '; {make each cell 2 characters wide}
    end;
  end;
  setmodified(sender);
end;

{****************** TForm1.Checkmodified *****************}
function Tform1.CheckModified:boolean;
{Call before loading a new file to ensure chance to save old case}
var
  msg:string;
  r:integer;
begin
  result:=true;
  If modified then
  begin
    if loadfilename='' then msg:='Save new file first?'
    else msg:='Save file '+loadfilename+' first?';
    r:=messagedlg(msg,mtconfirmation,[mbyes,mbno,MBCANCEL],0);
    if r=mryes
    then
    begin
      savedialog1.filename:=loadfilename;
      saveBtnclick(self);
    end
    else if r=mrcancel then result:=false;
  end;
end;

{*********** SaveBtnClick ***********8}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  ini:TInifile;
  RowNbr, WordNbr:string;
  rowdata:string;
  c,r,i:integer;
begin
  if savedialog1.execute then
  begin
    ini:=TInifile.create(savedialog1.filename);
    loadfilename:=savedialog1.FileName;
    with grid, ini do
    begin
      writeInteger('Params','Colcount', Colcount);
      writeInteger('Params','Rowcount', Rowcount);
      for r:=0 to rowcount-1 do
      begin
        rowdata:='';
        for c:=0 to colcount-1 do rowdata:=rowdata+cells[c,r][1];
        Rownbr:=format('Row%2d',[r+1]);
        ini.writestring('Data',rowNbr, rowdata);
      end;
      writeInteger('Params','MinLetters',MinLettersEdt.value);
      writeinteger('Params','MaxLetters',MaxLettersEdt.value);
      writeinteger('Params','SolutionType',AllowedrGrp.itemindex);
      writebool('Params','Revisits', RevisitBox.checked);
      with Targetwordlist do
      begin
        if items.Count>0 then
        begin
          If (items.count<>Targetwordcount) then Targetwordcount:=items.count;
          writeinteger('TargetWords','Count',TargetWordCount);
          for i:=0 to TargetWordcount-1 do
          begin
            WordNbr:=format('Word%2d', [i+1]);
            ini.writestring('TargetWords',WordNbr, uppercase(items[i]));
          end;
        end;
      end;
      Writestring('Intro','Text', Intromemo.lines.Text);
    end;
    modified:=false;
    Groupbox1.caption:='Current Puzzle: '+extractfilename(loadfilename);
  end;
end;

{**************** LoadBtnClick ************}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  ini:TInifile;
  RowNbr, WordNbr:string;
  rowdata,w:string;
  c,r,i,n:integer;
  s:string;
  minw,maxw:integer;
begin
  if checkmodified then
  begin
    opendialog1.FileName:=loadfilename;
    if opendialog1.execute then
    begin
      loadfilename:=opendialog1.FileName;
      ini:=TInifile.create(opendialog1.filename);
      s:=extractfilename(opendialog1.FileName);
      n:=lastdelimiter('.',s);
      if n>0 then delete(s,n,length(s)-n+1);
      Groupbox1.Caption:='Current puzzle: '+s;
      with Grid, ini do
      begin
        Colcountedt.value:=readinteger('Params','Colcount', 0);
        Rowcountedt.value:=readinteger('Params','Rowcount', 0);
        RevisitBox.checked:=readbool('Params','Revisits', False);
        for r:=0 to rowcount-1 do
        begin
           Rownbr:=format('Row%2d',[r+1]);
           rowdata:=readstring('Data',Rownbr,' ');
           for c:=0 to colcount-1 do cells[c,r]:=rowdata[c+1];
        end;
        MinLettersEdt.value:=readInteger('Params','MinLetters',0);
        MaxLettersEdt.value:=readinteger('Params','MaxLetters',0);
        AllowedRGrp.itemindex:=readinteger('Params','SolutionType',0);
        TargetWordCount:=readinteger('TargetWords','Count',0);
        with Targetwordlist do
        begin
          clear;
          minW:=999;
          maxW:=0;
          if Targetwordcount>0 then
          begin
            for i:= 0 to Targetwordcount-1 do
            begin
              wordnbr:=format('Word%2d',[i+1]);
              w:=trim(readstring('TargetWords', wordnbr, ''));
              n:=length(w);
              if n>0 then
              begin
                items.add(w);
                minw:=min(n,minw);
                maxw:=max(n,maxw);
              end;
            end;
            TargetWordCount:=TargetWordList.count;
            minlettersedt.value:=minw;
            maxlettersedt.value:=maxw;
          end;
        end;
        ClearFoundWordlist;
        Foundby:=None;
        Foundwordlist.items.Add('Found words');
        IntroMemo.lines.Text:=readstring('Intro','Text', 'No descritpion available');
        movetotop(Intromemo);

      end;
    end;
  end;
  modified:=false;
  Usermodegrp.itemindex:=0;
end;

{************** Memo2Click ************}
procedure TForm1.FoundWordMemoClick(Sender: TObject);
var
  itemnbr:integer;
begin
  Resethighlighting(currentwordlist);
  if replaying then exit; {Ignore user clicks while a word is displaying}
  itemnbr:=foundwordlist.itemindex;
  replayword(foundwordlist,itemnbr);
end;

{************ Replayword *************}
procedure TForm1.replayword(wordlist:TListBox; itemnbr:Integer);
{Called when user clicks a word in FoundWordList, but could work for
 TargeWordlist once path stringlists are added to those words}
var
  i,c,r:integer;
begin
  if itemnbr>=0 then
  try
    ResetHighLighting(CurrentWordList); {in case user had a word highlighted}
    screen.cursor:=crHourglass;
    replaying:=true;
    with TStringList(wordlist.items.objects[itemnbr]) do
    for i:=0 to count-1 do
    begin
      c:=strtoint(copy(strings[i],2,2)){-1};
      r:=strtoint(copy(strings[i],4,2)){-1};
      with grid do
      begin
        Cells[c,r] := cells[c,r][1]+'!';
        application.processmessages;
        sleep(250);
       (* Cells[c,r] := cells[c,r][1];
        application.processmessages;
        sleep(250);
        Cells[c,r] := cells[c,r][1]+'!';
        application.processmessages;
        sleep(250);
        *)
      end;  
    end;
    except
      Showmessage('System error');
  end;
  sleep(2000);

  ResetHighlighting(TStringlist(wordlist.items.objects[itemnbr]));

   replaying:=false;
   screen.cursor:=crDefault;
end;

{************ ResetHighlighting **********8}
procedure TForm1.ResetHighlighting(list:TStringlist);
  var
    i,c,r:integer;
  begin
    with list do
    for i:=0 to count-1 do
    begin
      c:=strtoint(copy(strings[i],2,2)){-1};
      r:=strtoint(copy(strings[i],4,2)){-1};
      with grid do Cells[c,r] := cells[c,r][1]+' ';
   end;
 end;




{************ AddFoundWord *************}
procedure TForm1.addfoundword(w:string; currlist:TStringlist);
var
  list:TStringList;
begin
  if foundwordlist.Items.IndexOf(w)<0 then
  begin {need to create a new copy of the current list because we nee a unique
         path list for each word}
    list:=TStringlist.create;
    list.assign(currlist);
    Foundwordlist.items.addobject(w,list);
  end;
end;

{********** GridClick ************}
procedure TForm1.GridClick(Sender: TObject);
var
  s:string;
  dx,dy:integer;
  i:integer;
  index:integer;
  lastpoint:TPoint;
  nextletter:string;
begin
  if replaying then exit;
  If  usermodegrp.ItemIndex =0 then
  with grid do
  begin  {user is defining a word}
    nextletter:=cells[col,row][1]+format('%2d%2d',[col,row]);
    index:=currentwordlist.indexof(nextletter);
    if (index<0) or (RevisitBox.checked)  then {not revisiting a letter}
    with currentwordlist do
    begin
      if count>1 then
      begin
        lastpoint.x:=strtointdef(copy(strings[count-1],2,2),-1);
        lastpoint.y:=strtointdef(copy(strings[count-1],4,2),-1);
        if validoffsets(point(col,row),lastpoint) then
        begin
          currentwordlist.Add(nextletter);
          s:=cells[col,row];
          cells[col,row]:=s[1]+'!';
        end
        else beep;  {not adjacent}
      end
      else
      begin
        currentwordlist.Add(nextletter);
        s:=cells[col,row];
        cells[col,row]:=s[1]+'!';
        grid.update;
      end;
    end ;
    (*
    else
    if rightclick then
    begin {revisited letter}
      {cell was reclicked - clear from there to end of partial word}
      for i:=currentwordlist.count-1 downto index do
      begin
        s:=currentwordlist[i];
        dx:=strtointdef(copy(s,2,2),-1);
        dy:=strtointdef(copy(s,4,2),-1);
        s:=cells[dx,dy];
        s[2]:=' ';
        cells[dx,dy]:=s;
        currentwordlist.delete(i);
      end;
    end;
    *)
  end
  else
  begin {user is modifying the grid, click will just select a new cell}
        {no action required here?}
  end;

end;

procedure TForm1.GridDblClick(Sender: TObject);
var
  s:string;
  dx,dy:integer;
  i:integer;
  index:integer;
  lastpoint:TPoint;
  nextletter:string;
begin
  with grid do
  begin
    nextletter:=cells[col,row][1]+format('%2d%2d',[col,row]);
    index:=currentwordlist.indexof(nextletter);
    if index>=0 then {removing letters}
    with currentwordlist do
    begin {revisited letter}
      {cell was reclicked - clear from there to end of partial word}
      for i:=currentwordlist.count-1 downto index do
      begin
        s:=currentwordlist[i];
        dx:=strtointdef(copy(s,2,2),-1);
        dy:=strtointdef(copy(s,4,2),-1);
        s:=cells[dx,dy];
        s[2]:=' ';
        cells[dx,dy]:=s;
        currentwordlist.delete(i);
      end;
    end;
  end;  
end;

procedure TForm1.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  s:string;
  dx,dy:integer;
  i:integer;
  index:integer;
  lastpoint:TPoint;
  nextletter:string;
begin

  if replaying then exit;
  If  (usermodegrp.ItemIndex =0) then
  with grid do
  begin  {user is defining a word}
    nextletter:=cells[col,row][1]+format('%2d%2d',[col,row]);
    index:=currentwordlist.indexof(nextletter);
    if index<0 then {not revisiting a letter}
    with currentwordlist do
    begin
      if count>1 then
      begin
        lastpoint.x:=strtointdef(copy(strings[count-1],2,2),-1);
        lastpoint.y:=strtointdef(copy(strings[count-1],4,2),-1);
        if validoffsets(point(col,row),lastpoint) then
        begin
          currentwordlist.Add(nextletter);
          s:=cells[col,row];
          cells[col,row]:=s[1]+'!';
        end
        else beep;  {not adjacent}
      end
      else
      begin
        currentwordlist.Add(nextletter);
        s:=cells[col,row];
        cells[col,row]:=s[1]+'!';
        grid.update;
      end;
    end
    else
    if (ssright in shift) then
    begin {revisited letter}
      {cell was reclicked - clear from there to end of partial word}
      for i:=currentwordlist.count-1 downto index do
      begin
        s:=currentwordlist[i];
        dx:=strtointdef(copy(s,2,2),-1);
        dy:=strtointdef(copy(s,4,2),-1);
        s:=cells[dx,dy];
        s[2]:=' ';
        cells[dx,dy]:=s;
        currentwordlist.delete(i);
      end;
    end;
  end
  else
  begin {user is modifying the grid, click will just select a new cell}
        {no action required here?}
  end;

end;

{************* CheckForWord ********}
procedure TForm1.CheckForWord;
var
  w,s:string;
  i,x,y:integer;
  isword:boolean;
  c,r:integer;
    function isvalidword(w:string):boolean;
    var
      i:integer;
    begin
      result:=false;
      if Targetwordcount=0 then
      begin {find dictionary words}
        if couldbeword(pubdic,w,isword) and isword
        then result:=true;
      end
      else
      begin
        with targetwordlist do
        for i:=0 to items.Count-1 do
        begin
          if w=items[i] then
          begin
            result:=true;
            break;
          end;
        end;
      end;
    end;

begin
  If usermodegrp.itemindex=0 then {user checking word}
  with currentwordlist do
  begin
    w:='';
    for i:=0 to count-1 do w:=w+strings[i][1];
    if isvalidword(w) then
    begin
      if foundby<>U then
      begin
        Clearfoundwordlist;
        foundby:=U;
        with grid do
        begin
          for c:=0 to colcount-1 do
          for r:=0 to rowcount-1 do
          begin
            cells[c,r]:=cells[c,r][1];
          end;
        end;    
      end;
      with foundwordlist do
      if (count=1)  and (pos('Found', items[0])>0) then clear; {first user word found}
      for i:=0 to count-1 do   {remove current highlighting in the grid}
      begin
        x:=strtointdef(copy(strings[i],2,2),-1);
        y:=strtointdef(copy(strings[i],4,2),-1);
        s:=grid.cells[x,y];
        s[2]:=' ';
        grid.cells[x,y]:=s;
      end;
      addfoundword(w,currentwordlist); {and add the word to the foundlist}
      currentwordlist.clear;
    end
    else
    begin
      if messagedlg(w+ ' is not a word, clear selected and tryagain?',
                          mtconfirmation, [mbYes,Mbno],0)=mrYes then
      begin
        foundby:=U;
        currentwordlist.clear;
      end;
    end;
  end;
end;

{*********** UserModeGrpClick ***********}
procedure TForm1.UserModeGrpClick(Sender: TObject);
begin
   If usermodegrp.itemindex=1 {Turn cell editing on}
   then grid.Options:=grid.Options+[goediting, goTabs]
   else  grid.Options:=grid.Options-[goediting, goTabs]; {or turn it off}
   zeroboard;
   Clearfoundwordlist;
 end;

{********** FormCloseQuery}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose:= checkmodified;  {get user permisson to exit}
end;

{************ SetModified **********}
procedure TForm1.Setmodified(sender:TObject);
begin
  modified:=true;
  userModeGrp.itemindex:=1;
end;

{********** TargetWordListClick ************}
procedure TForm1.TargetWordlistClick(Sender: TObject);
var
  i,n:integer;
  list:TStringlist;
  minw,maxw,len:integer;
  s:string;
begin {Temporary until clicking target words implemented}
  if usermodeGrp.itemindex=0
  then showmessage('Replay for target words not yet implelemented.'
           + #13+'Use search button to find all target words and replay from there.'
           +#13+'To modify Target word list, set user mode to "Modify", then click here.')

  else
  with targetWorddlg do
  begin
    memo1.Clear;
    if targetwordlist.Items.count>0 then
    for i:=0 to TargetWordlist.count-1 do
    memo1.lines.add(targetwordlist.Items[i]);

    if TargetWorddlg.Showmodal=mrOK then
    begin
      TargetWordlist.Clear;
      //memo1.lines.sort;
      list:=tstringlist.create;
      list.text:=memo1.text;
      list.sort;
      minw:=999;
      maxw:=0;
      for i:=0 to list.count-1 do
      begin
        s:=uppercase(list[i]);
        TargetWordList.items.Add(s);
        len:=length(s);
        minw:=min(minw,len);
        maxw:=max(maxw,len);
      end;
      minlettersedt.Value:=minw;
      maxlettersedt.Value:=maxw;
      list.free;
      modified:=true;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;





procedure TForm1.ResetBtnClick(Sender: TObject);
var
  c,r:integer;
begin
  zeroboard;
  with grid do  {reset any highlighted letters in the grid}
  for c:=0 to colcount-1 do for r:=0 to rowcount-1 do Cells[c,r] := cells[c,r][1]+' ';
  grid.update;
  ClearexpandedWordList;
  ClearFoundWordList;
  Currentwordlist.clear;
end;

end.






