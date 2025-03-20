Unit U_Sudoku41;
{Copyright © 2012, 2013  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


Interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, ShellAPI, Spin, ExtCtrls,
   dffutils, inifiles;

type

  TMode= (CreateCase, Play, Unknown); {current play mode}
  TPossibles=array[1..9] of boolean; {array of valid value flags for each cell}

  TRec=record
    Value:integer;
    NbrPossibles:integer;
    possibles:TPossibles;
  end;

  TTrialrec=record
    C,R:integer;
    Cell:Trec;
  end;

  TMoveRec=record {record format for tracking moves made}
    C,R,v:integer; {v = contents of cell[c,r] before the action}
    UserMove:boolean;
  end;

  TBoard= array [1..9,1..9] of TRec;

  TForm1 = class(TForm)
    Pagecontrol1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    StringGrid1: TStringGrid;
    HintBox: TCheckBox;
    LoadCaseBtn: TButton;
    SavecCaseBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    StaticText1: TStaticText;
    RestartBtn: TButton;
    Panel1: TPanel;
    Memo2: TMemo;
    PuzzlefileLbl: TLabel;
    VerboseBox: TCheckBox;
    Label1: TLabel;
    PageControl2: TPageControl;
    SolveSheet: TTabSheet;
    Randomsheet: TTabSheet;
    Memo1: TMemo;
    FillOneBtn: TButton;
    FillAllBtn: TButton;
    UndoBtn: TButton;
    UndoAllBtn: TButton;
    SearchBtn: TButton;
    RedoBtn: TButton;
    Modifysheet: TTabSheet;
    Memo3: TMemo;
    UniqueBox: TCheckBox;
    StatusLbl: TLabel;
    Memo4: TMemo;
    Modifygrp: TRadioGroup;
    StopBtn: TButton;
    MaxTriesSpinEdt: TSpinEdit;
    M1SpinEdt: TSpinEdit;
    M1Btn: TButton;
    M2SpinEdt: TSpinEdit;
    M2Btn: TButton;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Memo5: TMemo;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FillBtnClick(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure SaveCaseBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LoadCaseBtnClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure RedoBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure RestartBtnClick(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure CreateRandomClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure CreateBtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ModifygrpClick(Sender: TObject);
    procedure ModifysheetEnter(Sender: TObject);
    procedure PageControl2Change(Sender: TObject);
  public
    board, origboard: TBoard;
    mode:Tmode;
    solved, DeadEnd:boolean;
    undopath,redopath:array of TMoverec;
    nbrUndoMoves, nbrRedoMoves:integer;
    Usermovecount, ProgramMoveCount:integer; {count moves just to know who to congratulate when solved!}
    MinCell, MaxCell:TTrialrec;
    Modified:boolean;  {Puzzle has been created/changed and not saved}
    Puzzlename:string;
    positions:array [0..80] of integer;
    filledCount:integer;
    minpossibles:integer;
    Memo3LineCount:integer;
    procedure InitDefault;
    procedure InitCase(ClearMemo:Boolean);
    procedure fillPossibles(var board:Tboard; updategrid:boolean); overload;
    procedure fillPossibles(var board:Tboard); overload;
    procedure fillPossiblesfrom(var board:Tboard; c,r:integer);
    function checkcol(var board:TBoard; c,r:integer):integer;
    function checkrow(var board:TBoard; c,r:integer):integer;
    function checkBlock(var board:TBoard; c,r:integer):integer;
    function isValidMove(var board:TBoard; c,r, newval:integer):boolean;
    function loadcase(fname:string):boolean;
    Procedure Savecase(fname:string);
    procedure addMove(const newc, newr, newv:integer; NewUserMove:Boolean);
    function CheckModified:boolean;
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

var
defaultcase: array[1..9,1..9] of integer=((0,5,0,1,3,0,0,2,8),
                                          (0,8,1,0,0,9,0,0,6),
                                          (0,0,0,4,0,0,0,5,0),
                                          (0,0,0,5,0,0,0,0,9),
                                          (1,0,0,0,4,0,0,0,7),
                                          (5,0,0,0,0,3,0,0,0),
                                          (0,3,0,0,0,1,0,0,0),
                                          (9,0,0,3,0,0,6,8,0),
                                          (2,1,0,0,8,5,0,3,0));

procedure shuffle(var deck:array of integer);
  var
    i,n:integer;
    temp:integer;
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

{*********** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
begin
  randomize;
  savedialog1.InitialDir:=extractfilepath(application.ExeName);
  opendialog1.InitialDir:=savedialog1.InitialDir;
  Pagecontrol1.ActivePage:=Tabsheet1;
  PageControl2.ActivePage:=SolveSheet;
  Memo3LineCount:=Memo3.lines.count;
  for i:=1 to 5 do memo3.Lines.add('');  {add 5 extra lines for M2 run stats}
  reformatmemo(memo2);
end;

{********** InitDefault *************}
procedure TForm1.InitDefault;
var
  c,r:integer;
  s:string;
begin
  {Load default case}
  s:=puzzlename;  //extractfilepath(application.ExeName)+'default.txt';
  if not loadcase(s) then
  begin
    for r:=1 to 9 do for c:=1 to 9 do
    with board[c,r] do
    begin
      value:=defaultcase[r,c];
    end;
    Savecase('Default.txt');
  end;

  CheckboxClick(self); {get initial HintStatus}
  origboard:=board;
  Initcase(false);
end;


{********** FillBtnClick ************}
procedure TForm1.FillBtnClick(Sender: TObject);
{Fill one or all available cells whose value can be determined either because:
 1: it is the only valid value for that cell
 2: it is one of the multiple valid avaialble values and is the only value which can
    make a complete 1-9 set of values for a row, column, or block.}
var
  i,j,k,b:integer;
  changed:boolean;
  numcounts, countcol,countrow:array[1..9] of integer;
  colstart,rowstart:integer;  {block start locations}
  FillOne:Boolean;
begin
  Mode:=Play;
  if sender = FillOneBtn then FillOne:=true else FillOne:=false;
  repeat
    changed:=false;
    for i := 1 to 9 do
    begin
      for j:=1 to 9 do
      with board[i,j] do
      if (value=0)  then
      begin
        if nbrpossibles=1 then
        begin
          for k:=1 to 9 do
          if possibles[k] then
          IF ISVALIDMOVE(BOARD,I,J,K) THEN
          begin  {found the one possible value}
            if VerboseBox.checked then
            memo1.lines.add(format('Placing single choice %d at column %d, row %d',[k,i,j]));
            AddMove(i,j,value, False);
            value:=k;
            inc(ProgramMoveCount);
            fillpossibles(board,false);
            changed:=true;
            if fillone then break;
          end;
        end;
        if changed and fillone then break;  {end the row loop}
      end;
      if changed and fillone then break; {end the column loop}
    end;

    {column check}
    if not changed then
    begin {check if one of the possibles for this cell must be used because
             it is the only way to satisfy completness for a column}

      for i:=1 to 9 do {for each column}
      begin
        for k:=1 to 9 do numcounts[k]:=0; {initialize number occurrence counters}
        for j:=1 to 9 do {for each row}
        with board[i,j] do
        if value=0 then for k:=1 to 9 do if possibles[k] then
        begin
          inc(numcounts[k]);
          countrow[k]:=j;  {save the row number, j, for the location in column i
                            where k was a possible value.  If there turns out to
                            be only one occurrence of k in column i, then
                            board[i,j] value must be k.}
        end;
        for k:=1 to 9 do if numcounts[k]=1 then
        if isvalidmove(board,i,countrow[k],k) then
        begin
          changed:=true;
          if VerboseBox.checked then
          memo1.Lines.add(format('Placing only col choice %d at col %d, row %d',[k,i,countrow[k]]));
          addmove(i,countrow[k],board[i,countrow[k]].Value, False);
          board[i,countrow[k]].Value:=k;
          inc(programMovecount);
          fillpossibles(board,false);
          break;
        end;
        if fillone and changed then break;
      end;
    end;

    {Row check}
    if not changed then
    begin {check if one of the possibles for any row cell must be used because
             it is the only way to satisfy completness for the row}

      for j:=1 to 9 do {for each row}
      begin
        for k:=1 to 9 do numcounts[k]:=0; {initialize number occurrence counters}
        for i:=1 to 9 do {for each column}
        with board[i,j] do
        begin
          if value=0 then for k:=1 to 9 do if possibles[k] then
          begin
            inc(numcounts[k]);
            countcol[k]:=i;  {save the column number, i, for the location in row j
                            where k was a possible value.  If there turns out to
                            be only one occurrence of k in row j, then
                            board[i,j] value must be k.}
          end;
        end;
        {we have checkd all columns for block B, see if any possible occurred only once}
        for k:=1 to 9 do if numcounts[k]=1 then
        if isvalidmove(board,countcol[k],j,k) then
        begin
          changed:=true;
          if VerboseBox.checked then
          memo1.lines.add(format('Placing only row choice %d at column %d, row %d',[k,countcol[k],j]));
          addmove(countcol[k],j,board[countcol[k],j].Value, False);
          board[countcol[k],j].Value:=k;
          inc(programmovecount);
          fillpossibles(board,false);
          break;
        end;
        if changed and fillone then break;
      end; {Row check}
    end;

    {Block check}
    if not changed then
    begin {check if one of the possibles for any block cell must be used because
             it is the only way to satisfy completeness for the block}
      for B:=0 to 8 do
      begin
        colstart:=(B mod 3) * 3 +1;
        rowstart:=(B div 3) * 3 +1;

        for k:=1 to 9 do numcounts[k]:=0; {initialize number occurrence counters}
        for i:=colstart to colstart+2 do
        for j:=rowstart to rowstart+2 do
        with board[i,j] do
        if value=0 then for k:=1 to 9 do
        if isvalidmove(board,i,j,k) then
        begin
          inc(numcounts[k]);
          countcol[k]:=i; {save the column and row numbers numbers, [i,j],
                              for the location in in block B
                              where k was a possible value.  If there turns out to
                              be only one occurrence of k in block B, then
                              board[i,j] value must be k.}
          countrow[k]:=j;
        end;
        for k:=1 to 9 do if numcounts[k]=1 then
        begin
          changed:=true;
          if VerboseBox.checked then
          memo1.lines.add(format('Placing only block choice %d at column %d, row %d',
                             [k,countcol[k],countrow[k]]));

          addmove(countcol[k],countrow[k],board[countcol[k],countrow[k]].Value, False);
          board[countcol[k],countrow[k]].Value:=k;
          fillpossibles(board,false);
          inc(programmovecount);
          if changed and fillone then{} break;
        end;
        if changed and fillone then break;
      end; {Block check}
    end;
  until (not Changed) or (changed and fillone) or solved;
  if solved
  then if (usermovecount>0) then
      if  (programmovecount>0) then showmessage('We solved it, congratulations to us!!!')
      else showmessage('You solved it, congratulations to you!!!')
  else  showmessage('I solved it, congratulations to me!!!')
end;

{*********** HintBoxClick ***********}
procedure TForm1.CheckBoxClick(Sender: TObject);
begin
  if sender=Verbosebox then memo1.Clear;
  FillPossibles(board);
end;


{*********** LoadcaseBtnClick *********}
procedure TForm1.LoadCaseBtnClick(Sender: TObject);

begin
  if opendialog1.execute then
  begin
    if not loadcase(opendialog1.filename)
    then showmessage('File "'+opendialog1.FileName+'" not found');
    //memo1.clear;
  end;
end;


{************* RedoBtnClick ************}
procedure TForm1.RedoBtnClick(Sender: TObject);
begin
  {redo last "undone" move};
  if nbrredomoves<=0 then exit
  else
  begin
    if length(redopath)<=nbrredomoves then setlength(redopath, nbrredomoves+100);
    with redopath[nbrredomoves] do
    begin
      inc(nbrUndoMoves);
      undopath[nbrundomoves]:=redopath[nbrredomoves];
      undopath[nbrundomoves].v:=board[c,r].value;
      board[c,r].value:=v;
      if VerboseBox.checked then
      memo1.lines.add(format('Redo placing %d at column %d, row %d',[v,c,r]));
    end;
    fillpossibles(board,false);
    dec(nbrredomoves);
  end;
end;

{*********** RestartBtnClick ************}
procedure TForm1.RestartBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  for i:=1 to 9 do
  for j:=1 to 9 do board[i,j].value:=origboard[i,j].value;
  Initcase(true);
end;

{************ SaveCaseBtnClick *************}
procedure TForm1.SaveCaseBtnClick(Sender: TObject);
begin
  if savedialog1.execute then savecase(savedialog1.filename);
end;

{********* StringgridKeyPress ***********88}
procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
var
  c,r:integer;
  val:integer;
  ok:boolean;
begin
  with stringgrid1 do
  begin
    case key of
    '0'..'9',' ':
      begin
        r:=row+1;
        c:=col+1;
        if key=' ' then val:=0 else val:=strtoint(key);
        with board[c,r] do
        begin
          if ((val=0) or ((val>0) and (board[c,r].possibles[val]))) then
          begin
            Ok:=IsValidMove(board,c, r, val);
            if not OK
            then OK:= messagedlg('Move is leagal but will likely lead to a dead  end. Apply it anyway?',
                              mtconfirmation, [mbyes, mbno],0)=mryes;
          end
          else OK:=false;
          if OK then
          with memo1.Lines do
          begin
            addmove(c,r,board[c,r].value, true); {add to undoMoveList}
            board[c,r].value:=val;
            inc(userMovecount);
            if mode=createCase then
            begin
              origboard[c,r].Value:=val;
              modified:=true;
              if VerboseBox.checked then
              if val>0
              then add(format('Definition value %d placed at column %d, row %d',[val,c,r]))
              else add(format('Definition value removed from column %d, row %d',[c,r]));
            end
            else
            if VerboseBox.checked then
            if val>0
            then add(format('User placed %d at column %d, row %d',[val,c,r]))
            else add(format('User removed value at column %d, row %d',[c,r]));
            fillpossibles(board,false);
            if mode=createcase then
            Begin
               origboard[c,r].value:=val;
               modified:=true;
            end;
            if solved then
            if programMovecount=0 then showmessage('You solved it solo - double congratulations to you!!!')
            else showmessage('We solved it with some of my moves - congratulations to us both!!');
          end
          else beep;
        end;
      end;
      else beep;
    end;
  end;
end;

{************ UndoBtnClick *********8}
procedure TForm1.UndoBtnClick(Sender: TObject);
begin
  {Undo last move}
  if nbrundomoves<=0 then exit
  else
  begin
    (*
    if (sender=UndoAllBtn) *and undopath[nbrundomoves].UserMove
    then Showmessage('Last move was a user move, no program moves undone')
    else
    *)
    begin
      repeat
        with undopath[nbrundomoves] do
        begin
          inc(nbrRedomoves);
          if length(redopath)<=nbrredomoves then setlength(redopath,nbrredomoves+100);
          redopath[nbrredomoves]:=undopath[nbrundomoves];
          redopath[nbrredomoves].v:=board[c,r].value;
          if VerboseBox.checked then
          memo1.lines.add(format('Undo placing %d at column %d, row %d',[board[c,r].value,c,r]));
          board[c,r].value:=v;
          dec(nbrundoMoves);
        end;
      until (nbrUndoMoves=0)
            or (sender<>UndoAllBtn)
            or  (undopath[nbrundomoves+1].usermove);
      fillpossibles(board);
    end;
  end;
end;

{*************** StringgridDrawCell ************}
procedure  TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
                                      Rect: TRect; State: TGridDrawState);
var
  i:integer;
  s:string;
begin
  with stringgrid1,canvas do
  begin
    if  ((acol div 3 =1) and (arow div 3 <>1)) {color alternate 3x3 blocks}
    or  ((acol div 3 <>1) and (arow div 3 =1))
    then brush.Color:=clBtnFace else brush.Color:=clwhite;
    if  gdSelected in state then brush.color:=clskyblue;
    rectangle(rect);

    with rect, board[acol+1, arow+1] do
    begin   {fill the grid cell from the board array}
      if value>0 then
      with font do
      begin
        Size:=12;
        if (origboard[acol+1,arow+1].value>0) then
        begin
         Style:=[fsbold];
         color:=clmaroon;
        end
        else
        begin
          Style:=[];
          color:=clblack;
        end;
        textout(left+12,top+12,inttostr(value));
      end
      else {no value filled, show possibles}
      if hintbox.Checked then
      with font do
      begin
        s:='';
        for i:=1 to 9 do if possibles[i]
        then s:=s+inttostr(i)+',';
        if length(s)>0 then delete(s,length(s),1);
        Size:=8;
        Color:=clblue;
        Style:=[fsbold];
        if length(s)<=8 then textout(left+2,top+2,s)
        else
        begin
          textout(left+2,top+2,copy(s,1,8));
          textout(left+2,top+16,copy(s,9,length(s)-8));
        end;
      end;
    end;
  end;
end;


{*********** CreateBtnClick *************}
procedure TForm1.CreateBtnClick(Sender: TObject);
begin
 // panel2.Visible:=true;

end;

{************* CreateRandomClick *****************}
procedure TForm1.CreateRandomClick(Sender: TObject);
{Generate a random  puzzle}

    {----------------- GetNextValue --------------}
    function getnextvalue(c,r:integer; var board:TBoard):boolean;
    {recursive search to fill the board}
    var
      ii,jj,k:integer;
      checked:integer;
    begin
      result:=false;
      if c=10 then result:=true  {all cell filled OK!}
      else
      begin
        with board[c,r] do
        begin
          //fillpossiblesfrom(board,c,r);
          fillpossibles(board,false);
          if nbrpossibles>0 then
          begin
            checked:=0;
            for k:=1 to 9 do
            begin
              if possibles[k] then
              begin
                value:=k;
                //fillpossiblesfrom(board,c,r);
                fillpossibles(board,false);
                if r=9 then
                begin
                  jj:=1; {row 1 has been filled initially, search from row 2}
                  ii:=c+1;
                end
                else
                begin
                  jj:=r+1;
                  ii:=c;
                end;
                result:=getnextvalue(ii,jj,board);
                if result then
                begin
                  //origboard:=board;
                  stringgrid1.update;
                  break;
                end
                else
                begin
                 value:=0;
                 //fillpossiblesfrom(board,c,r{false});
                 fillpossibles(board,false);
                end;
                inc(checked);
                if checked>=nbrpossibles then break;
              end;
            end;
          end;
        end;
      end;
    end;

type tstatrec=record
        count:integer;
        //currentruntime:double;
        //cumtime:double;
      end;
var

  all: array [0..80] of integer;
  solutioncount:integer;
  msg:string;
  maxattempts, loopcount:integer;
  save:boolean;
  defaultquickval,origval:integer;
  OK:boolean;
  startTime,stime2:TDateTime;
  entrycount:integer;
  M2SpinEdtVal:integer;
  CheckingMessage:string;  {part of stop button message predefined to save time}
  stats:array[57..61] of TStatrec;

    {----------- GetNewSet ------------}
    procedure getnewset;
    {create a new set of 81 random values which validly fill the board}
      var
        i,j,k:integer;
        col1:array[0..8] of integer;
      begin
        for i:= 1 to 9 do for j:=1 to 9 do
        with board[i,j] do
        begin
          Value:=0;
          nbrpossibles:=9;
          for k:=1 to 9 do possibles[k]:=true;
        end;
        origboard:=board;
        for  i:= 0 to 8 do col1[i]:=i+1;
        shuffle(col1);
        for i:=0 to 8 do  board[1,i+1].value:=col1[i];
        fillpossibles(board,false);
        {we now have column 1 filled with values 1 to 9 in random order}

        if getnextvalue(2,1,board) then {generate the other 8 columns }
        begin
          {save board values as 1 dimensional array}
          for i:=0 to 8 do for j:=0 to 8 do
          with board[i+1,j+1] do
          begin
            k:=9*i+j;
            all[k]:=value;
            positions[k]:=k; {index of next rand entry in "all" array}
          end;
          shuffle(positions); {SHUFFLE IT}
        end;
      end;


    {------------ CountSolutionsFromBoard -------------}
    function CountSolutionsFrom(board:TBoard; var count:integer):boolean;
    {return the number of solutions for this board (up to 2)}
    var
      i,j,k:integer;
      checked:integer;
    begin
      result:=false;
      inc(entrycount);
      if entrycount and $fff =0  then
      begin
        application.ProcessMessages;  {in case of  Stop click}
        if not stopbtn.Visible then
        begin
          count:=-1;
          exit; {user clicked Stop button}
        end;
        entrycount:=0;
      end;
      if count>=2 then exit;

      i:=mincell.c;
      j:=mincell.r;
      if board[i,j].value<>0 then
      begin
        i:=0;
        j:=9;

        {find an empty cell}
        repeat
          inc(j);
          if j>9 then
          begin
            j:=1;
            inc(i);
          end;
        until (i>9) or (board[i,j].value=0);

        if i>9 then
        begin
          if solved
          then count:=count+1;
          result:=count=1;
        end;
      end
      else

      with board[i,j] do
      begin
        if value = 0 then
        begin
          checked:=0;
          k:=0;
          while (checked<nbrpossibles) and (k<9) do
          begin
            inc(k);
            if possibles[k] then
            begin
              inc(checked);
              value:=k;
              fillpossibles(board,false);
              result:=countsolutionsfrom(board,count);
              value:=0;
              {alternate plan - remove value from possibilities in other empty cells in row,
               column and block }
              fillpossibles(board,false);
            end;
          end;
        end;
      end;
    end;

    {-------------- GetNextBoard --------------}
    function getnextboard(target, startC, StartR:integer):boolean;
    {Recursive search which replaces  a filled cell with each other possible
     value and then ensures that the changed board has no solution.  If that is
     the case, then the cell can be safely cleared producing a puzzle with one
     fewer filled cells and a guaranteed unique solution!}
    var
      i,j,k:integer;
      ok:boolean;
      t:integer;
      cumtime:real;
        begin

          Memo5.lines[0]:=format('Searching with %d filled cells, (%d empty cells)',
                           [81-target, target]);
          memo5.update;
          t:=target-1;
            if (t>=57) and (t<=61) then
            begin
              with stats[t] do
              begin
                inc(count);
                cumtime:=(now-starttime)*secsperday;
                memo3.Lines[memo3linecount+t-57]:=format('%d cells, %d solves, Avg time: %0.1f seconds',[81-t, count, cumtime/count]);
                memo3.update;
              end;
           end;
          //memo3.lines.add(format('Entering Getnextboard with target empty = %d',[target]));
          if target > M2spinedtval then
          begin  {we're done!}
            result:=true;
            exit;
          end
          else
          begin
            result:=false;
            i:=startC;
            j:=startR;
            repeat
              inc(j);
              if j>9 then
              begin
                inc(i);
                j:=1;
              end;
              if i<=9 then
              begin
                {3. Find next filled cell}
                if board[i,j].value>0 then
                begin
                  {4. try alternative values for this cell
                  if no alternative value is solvable, then
                  solution is unque: restore real value for this cell & break.
                  }
                  origval:=board[i,j].value;
                  memo5.lines[1]:=format('Try removing %d from (%d,%d)',[origval, i,j]);
                  memo5.update;
                  ok:=true;

                  with board[i,j] do
                  begin
                    value:=0;

                    fillpossibles(board,false);
                    for k:=1 to 9 do
                    begin
                      if k<>origval then
                      begin
                        if possibles[k] then
                        begin
                          solutioncount:=0;
                          board[i,j].value:=k;  {try an alternate value}
                          fillpossibles(board,false);
                          countsolutionsFrom(board,solutioncount);
                          board[i,j].value:=0;
                          fillpossibles(board,false);
                          if solutioncount>0 then
                          begin  {original solution not unique, go to next board value}
                            ok:=false;
                            break;
                          end;
                        end;  {possibles[k]}
                      end; {k<> origvalue}
                    end; {for k:=1 to 9}

                    stopbtn.Caption:=CheckingMessage

                    +#13+Format('Run time: %.0f seconds',[(now-starttime)*secsperday])
                       +#13+inttostr(loopcount) +' boards checked'
                         +#13+ 'Click here to STOP testing';
                    stopbtn.update;

                  end;
                  result:=ok;
                  if OK then
                  begin
                    board[i,j].value:=0;  {found unique solution with this cell removed}
                    fillpossibles(board,true);
                    result:=getnextboard(target+1,i,j);  {Continue by removing the nect value}
                    exit;
                  end

                  else
                  begin
                    board[i,j].Value:=origval;
                    fillpossibles(board,false);
                  end;
                end;  {If not empty (board[i,j].value>0)}
              end;
              if  not stopbtn.visible then break;
            until i>9;
          end;
        end;
var
  i,j,k:integer;
  s,m:integer;
  plural:string;


begin  {CreateRandomClick}
  if not checkmodified then exit;
  stopbtn.bringtofront;
  Stopbtn.Visible:=true;
  save:=Hintbox.checked;
  Hintbox.checked:=false;
  for i:=57 to 61 do
  with stats[i] do
  begin
    count:=0;
  end;
  starttime:=now;

  PuzzleFileLbl.caption:='Puzzle: New - Unsaved';
  maxattempts:=MaxTriesSpinEdt.value;
  screen.Cursor:=crHourGlass;
  stringgrid1.update;
  if sender=m1Btn then
  begin
    //Method 1
    {Starting with an empty board, add random values back until there are is only
     a single solution}
    for loopcount:=1 to maxattempts do
    begin
      if not stopbtn.Visible then break;
      getnewset;
      Statuslbl.caption:=format('Checking board %d of %d attempts',[loopcount,maxattempts]);
      application.processmessages;
      for i:=1 to 9 do for j:=1 to 9 do board[i,j].value:=0;  {empty the board}
      fillpossibles(board,false);
      shuffle(positions); {SHUFFLE IT}
      origboard:=board;
      k:=0;
      repeat
        i:=positions[k] div 9 +1;
        j:=positions[k] mod 9 +1;
        origboard[i,j].value:=all[9*(i-1) +j-1];
        inc(k);
      until k=m1spinedt.value;
      fillpossibles(origboard, {true} false);
      board:=origboard;
      solutioncount:=0;
      entrycount:=0;
      countsolutionsfrom(board,{0,9,}solutioncount);


      if (solutioncount=1) or (solutioncount<0)
          or ((solutioncount>1) and (not uniquebox.checked)) then break;  {condition met, break}

      stopbtn.Caption:= inttostr(loopcount) +' boards checked'
                       +#13+ 'Click here to STOP testing';
      stopbtn.Update;
    end;

    case solutioncount of
      -1: msg:=('Method 1: Search interupted by user');
      0: msg:=format('Method 1: No solution found in %d random attempts for board'
                              +' with %d "filled cells"',[maxattempts,M1spinedt.value]);
      1: msg:=format('Method 1: There is a unique solution for this random board'
                    +' with  %d filled cells (%d empty cells initially',
                    [m1spinedt.value, 81-m1spinedt.value]);
      else  if uniquebox.checked then
      msg:=format('Method 1: Two or more solutions found for all boards in %d'
                 +' attempts in this trial ',[loopcount-1])
      else msg:=format('Method 1: Two or more solutions found for this board'
                      +' and unique solution not required',[])
    end
  end
  else if sender = M2Btn then
  begin
    {Method 2: Start with filled board and subtract until a non-unique
     configuration is generated}
    with memo3, lines do
    //for i:=count<memo3linecount+5 then for i:=memo3linecount +5 - count do lines.add('');
    for i:=memo3.lines.count-1 downto memo3Linecount do memo3.lines[i]:='';  {clear method2 run stats}
    loopcount:=0;

    while loopcount<=maxattempts do
    begin
      inc(loopcount);
      if not stopbtn.Visible then break;
      defaultquickval:=50;
      if  uniquebox.checked and (M2spinedt.value>defaultquickval)  then
      begin  {new with version 4.0  when number of empty cells requested is
              greater than 48 (fewer than 33 pre-filled cells}
        memo5.clear;
        for i:=0 to 4 do memo5.lines.add('');

        {Get a (quick) solution for 51 empty}
        M2SpinEdtVal:=m2spinedt.value; {save target value}
        CheckingMessage:=Format('Searching for %d filled, (%d empty) cells',[81-m2SpinEdtval, m2SpinEdtval]);
        m2spinedt.value:=defaultquickval;
        memo5.lines[0]:=format('Building initial grid with %d filled cells, (%d empty cells)',[81-defaultquickval, defaultquickval]);
         //randseed:=0;  {FOR TEST ONLY}
        
        repeat {fill an initial random board with easy to find default}
          getnewset;
          for k:=0 to defaultquickval-1 do
          begin
            i:=positions[k] div 9 +1;
            j:=positions[k] mod 9 +1;
            board[i,j].value:=0;
          end;
          fillpossibles(board,false);
          solutioncount:=0;
          countsolutionsfrom(board, solutioncount);
          inc(loopcount);
          stopbtn.Caption:=checkingmessage
          +#13 + Format('Run time: %.0f seconds',[(now-starttime)*secsperday])
                       +#13+inttostr(loopcount) +' boards checked'
                         +#13+ 'Click here to STOP testing';
          stopbtn.update;
        until solutioncount=1;
        stime2:=now;
        origboard:=board;
        stringgrid1.invalidate;
        M2Spinedt.value:=M2SpinEdtval; {restore the real target}
        OK:=getnextboard(defaultquickval+1,1,1);
        if OK then
        begin

          fillpossibles(board,false);
          solutioncount:=0;
          origboard:=board;
          stopbtn.Caption:=inttostr(loopcount) +' boards checked'
                           +#13+ 'Click here to STOP testing';
          countsolutionsfrom(board, solutioncount);
          break;
        end;
        if (not stopbtn.visible)  then break;
      end
      else
      begin {old "small" empty cells request}
        getnewset;  {fill a random board}
        Statuslbl.caption:=format('Checking board %d of %d',[loopcount,maxattempts]);
        application.processmessages;
        for k:=0 to M2spinedt.value-1 do
        begin  {empty requested number of cells randomly}
          i:=positions[k] div 9 +1;
          j:=positions[k] mod 9 +1;
          board[i,j].value:=0;
        end;
        fillpossibles(board);
        solutioncount:=0;
        origboard:=board;
        stopbtn.Caption:=inttostr(loopcount) +' boards checked'
                         +#13+ 'Click here to STOP testing';
        countsolutionsfrom(board, {1,0,} solutioncount);
        if (solutioncount=1) or (solutioncount<0)
            or ((solutioncount>1) and (not uniquebox.checked)) then break;  {condition met, break}
      end;
    end;
    if (not stopbtn.visible) then solutioncount:=-1;
    origboard:=board;  {save current status board}
    case solutioncount of

      -1: msg:='Method 2: Search interrupted by user';
      0: msg:=format('Method 2: No solution found in %d random attempts for board with %d "holes"',[maxattempts,M2spinedt.value]);
      1: msg:=format('Method 2: There is a unique solution for this random board with  %d empty cells (%d cells filled initially',[m2spinedt.value, 81-m2spinedt.value]);
      else if uniquebox.Checked
      then msg:=format('Method1: Two or more solutions found for all boards in %d attempts in this trial ',[loopcount-1])
      else msg:=format('Method 1: Two or more solutions found for this board and unique solution not required',[])
    end;
  end;
  screen.cursor:=crdefault;
  hintbox.checked:=save;  {restore the hintbox status}
  s:=round ((now-starttime)*secsperday);
  m:=s div 60;
  if m=1 then plural:='' else plural:='s';
  showmessage(msg+#13+ format(' Time: %d minute%s: %d seconds', [m, plural, s-60*m]));
  stopbtn.Visible:=false;
  modified:=solutioncount=1;
end;

{********** SearchBtnClick  *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  solutioncount:integer;
  DeadEndCount:integer;

    {----------- MakeNextMove ---------------}
    {Recursive depth first search for solution}
   function Makenextmove(var tempboard:TBoard; movecell:TTrialrec;
           newval,level:integer):integer;
   var
     i:integer;
     newmovecell:TTrialrec;
     msg:string;
     checked:integer;
   begin
     result:=0;
     if VerboseBox.checked then
     memo1.lines.add(format('Search level %d, adding %d at (%d.%d)',
                             [level, newval, movecell.c, movecell.r]));
     with movecell do tempboard[c,r].value:=newval;
     fillpossibles(tempBoard);
     stringgrid1.invalidate;
     application.processmessages;
     if solved then
     begin
       if deadendcount=1 then msg:='path was' else msg:='paths were';
       showmessage('Solution found!!!' + #13
                    + format(' %d "deadend" %s tried and backtracked',[deadendcount, msg]));
       inc(solutioncount);
       result:=solutioncount;
     end
     else
     if not deadend then
     begin
       with MinCell, cell do
       begin
         newmovecell.c:=c;
         newmovecell.R:=r;
         //addmove(c,r, newmovecell.cell.value,false);
         Newmovecell.Cell:=MinCell.cell;
         checked:=0;
         i:=0;
         while (i<9) and (checked<nbrpossibles) do
         begin
           inc(i);
           if possibles[i] then
           begin
             with newmovecell do
             addmove(c,r,tempboard[c,r].value,false);
             result:=makenextmove(tempboard,newmovecell,i,level+1);
             if solved then  exit;
             if VerboseBox.checked then
             memo1.lines.add(format('Search from level %d, backtracking by removing %d from (%d.%d)',
                             [level+1, newval, newmovecell.c, newmovecell.r]));
             with newmovecell do
             begin
               addmove(c,r,tempboard[c,r].value,false);
               tempboard[c,r].value:=0;
             end;
             fillpossibles(tempboard,false);
             inc(checked);
             //if checked>=nbrpossibles then break;
           end;
         end;
       end;
     end
     else
     begin
       inc(DeadEndCount) ;
     end;
   end;

var
  i:integer;
  newmovecell:TTrialrec;
  saveboard:TBoard;
begin  {SearchBtnClick}
  saveboard:=board;
  solutioncount:=0;
  DeadEndCount:=0;
  if not solved then FillBtnClick(sender);
  if not solved then
  begin
    with MinCell, cell do
    begin
      newmovecell.c:=c;
      newmovecell.R:=r;
      Newmovecell.Cell:=MinCell.cell;
      for i:= 1 to 9 do
      begin
        if possibles[i] then
        begin
          with newmovecell do  addmove(c,r,board[c,r].value,false);
          makenextmove(board, newmovecell,i,1);
          if solved then  exit;
          with newmovecell do
          begin
            addmove(c,r,board[c,r].value,false);
            board[c,r].value:=0;
          end;
          fillpossibles(board,false);
        end;
      end;
    end;
  end;
  if not solved then showmessage('No solution found. Cause is puzzle definition error (possible) or program bug (likely :>)');
end;



{********* StopBtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  stopbtn.Visible:=false;
  application.processmessages;
end;

{************ StringGrid1Click ***********}
procedure TForm1.StringGrid1Click(Sender: TObject);
var
  k:integer;
begin
  with stringgrid1, {do with} board[col+1, row+1] do
  begin
    if (value=0) and (nbrpossibles=1)and (hintbox.Checked) then
    begin
      for k:=1 to 9 do
      if possibles[k] then
      begin
        value:=k;
        addmove(positions[k] div 9 + 1, positions[k] mod 9 +1, k, true);
        fillpossibles(board);
        if solved
        then if ProgramMoveCount>0 then showmessage('We solved it, congratulations to us!!')
        else  if hintbox.checked then showmessage('You solved it without program moves, but using my hints. Congratulations to us both!!')
        else showmessage('You solved it without my hints. Double congratulations to you!!!');
        break;
      end;
    end;
  end;
end;


{***************************************************}
{                                                   }
{                Support Routines                   }
{                                                   }
{***************************************************}


{*********** AddMove ***********}
procedure TForm1.addMove(const newc, newr, newv:integer; NewUserMove:boolean);
{add a move to the undopath list}
begin
  inc(nbrundomoves);
  if length(undopath)<=nbrundomoves then setlength(undopath, nbrundomoves+100);
  with undopath[nbrundomoves] do
  begin
    c:=newc;
    r:=newr;
    v:=newv;
    Usermove:=NewUserMove;
  end;
end;

{********** Checkcol *************}
function TForm1.checkcol(var board:TBoard; c,r:integer):integer;
{turn off "Possibles" flags in cell[c,r] for all values found in column c}
var
  i:integer;
begin
  result:=0;
  begin
    For i:=1 to 9 do with board[i,r] do
    if value>0 then
    begin
      If board[c,r].possibles[value] then inc(result);
      board[c,r].possibles[value]:=false;
    end;
  end;
end;

{************ CheckRow **************}
function TForm1.checkrow(var board:TBoard; c,r:integer):integer;
{turn off "Possibles" flags in cell[c,r] for all values found in  row r}
var
  i:integer;
begin
  result:=0;
  begin
    For i:=1 to 9 do with board[c,i] do
    if value>0 then
    begin
      If board[c,r].possibles[value] then inc(result);
      board[c,r].possibles[value]:=false;
    end;
  end;
end;

{************ CheckBlock ***************}
function TForm1.checkBlock(var board:TBoard; c,r:integer):integer;
{turn off "Possibles" flags in cell[c,r] for all values found in  block which contains the cell}
var
  x,y,i,j:integer;
  v:integer;
begin
  result:=0;
  begin
    x:=((c-1) div 3)*3 + 1;
    y:= ((r-1) div 3)*3 +1;
    For i:=x to x+2 do for j:=y to y+2 do
    begin
      v:=board[i,j].value;
      if v>0 then
      begin
        If board[c,r].possibles[v] then inc(result);
        board[c,r].possibles[v]:=false;
      end;
    end;
  end;
end;


procedure TForm1.fillpossiblesfrom(var board:TBoard;  c,r:integer); 
  var
    i:integer;
    eliminated:integer;
  begin
  with board[c,r] do
  begin
    if board[c,r].value>0 then
    begin
       for i:=1 to 9 do possibles[i]:=false;
       nbrpossibles:=0;
    end
    else
    begin
      for i:=1 to 9 do possibles[i]:=true;
      {The tests below will turn off "possibles" entries for existing values in
       row, column, or block}
      eliminated:=checkrow(board,c,r);
      eliminated:=eliminated+checkcol(board,c,r);
      eliminated:=eliminated+checkblock(board,c,r);
      nbrpossibles:=9-eliminated;
      if value>0 then inc(filledcount)
      else if (nbrpossibles=0) then deadend:=true
      else
      if (nbrpossibles<0) and (nbrpossibles<minpossibles) then
    begin  {save info about the cell with the smallest # of valid moves}
        MinCell.c:=c;
        MinCell.r:=r;
        Mincell.cell:=board[c,r];
        MinPossibles:=nbrpossibles;
      end ;
    end;
  end;
end;  



{*********** FillPossibles ***************8}
procedure TForm1.fillPossibles(var board:Tboard);
begin
  fillpossibles(board,true);
end;

procedure TForm1.fillPossibles(var board:Tboard; updategrid:boolean );
{Called after every change to values in order to update the "possibles" list
 of valid values for each empty cell}
var
  c,r,eliminated,i:integer;

begin
  filledcount:=0;
  minpossibles:=10;
  deadend:=false;
  for c:=1 to 9 do for r:= 1 to 9 do
  //begin
  //fillpossiblesfrom(board, c,r);
  with board[c,r] do
  if value=0 then
  begin
    for i:=1 to 9 do possibles[i]:=true;
    {The tests below will turn off "possibles" entries for existing values in
     row, column, or block}
    eliminated:=checkrow(board,c,r);
    eliminated:=eliminated+checkcol(board,c,r);
    eliminated:=eliminated+checkblock(board,c,r);

    nbrpossibles:=9-eliminated;
    if value>0 then inc(filledcount)
    else if (nbrpossibles=0) then deadend:=true
    else if (nbrpossibles<minpossibles) then
    begin  {save info about the cell with the smallest # of valid moves}
      MinCell.c:=c;
      MinCell.r:=r;
      Mincell.cell:=board[c,r];
      MinPossibles:=nbrpossibles;
    end ;

   // with board[c,r] do
  //  if value>0 then inc(filledcount)
  //  else if (nbrpossibles=0) then deadend:=true;
  end
  else
  begin
    for i:=1 to 9 do possibles[i]:=false;
    nbrpossibles:=0;
    inc(filledcount);
  end;
  solved:=filledcount=81;
  if updategrid then stringgrid1.invalidate;
end;
(*
procedure TForm1.fillPossibles(var board:Tboard; updategrid:boolean );
{Called after every change to values in order to update the "possibles" list
 of valid values for each empty cell}
var
  c,r,eliminated,i:integer;

begin
  filledcount:=0;
  minpossibles:=10;
  deadend:=false;
  for c:=1 to 9 do for r:= 1 to 9 do
  //begin
  //fillpossiblesfrom(board, c,r);
  with board[c,r] do
  if value=0 then
  begin
    for i:=1 to 9 do possibles[i]:=true;
    {The tests below will turn off "possibles" entries for existing values in
     row, column, or block}
    eliminated:=checkrow(board,c,r);
    eliminated:=eliminated+checkcol(board,c,r);
    eliminated:=eliminated+checkblock(board,c,r);

    nbrpossibles:=9-eliminated;
    //if value>0 then inc(filledcount)
    //else if (nbrpossibles=0) then deadend:=true
    {else} if (nbrpossibles<minpossibles) then
    begin  {save info about the cell with the smallest # of valid moves}
      MinCell.c:=c;
      MinCell.r:=r;
      Mincell.cell:=board[c,r];
      MinPossibles:=nbrpossibles;
    end ;

   // with board[c,r] do
  //  if value>0 then inc(filledcount)
  //  else if (nbrpossibles=0) then deadend:=true;
  end
  else
  begin
    for i:=1 to 9 do possibles[i]:=false;
    nbrpossibles:=0;
    inc(filledcount);
  end;
  solved:=filledcount=81;
  if updategrid then stringgrid1.invalidate;
end;
*)

{************* InitCase **********8}
procedure TForm1.initcase(clearmemo:boolean);
begin
  fillpossibles(board);
  nbrRedoMoves:=0;
  nbrUndoMoves:=0;
  setlength(undopath,100);
  setlength(redopath,100);
  if clearmemo  then memo1.clear;
  solved:=false;
  mode:=Play;
  UserMoveCount:=0;
  ProgramMovecount:=0;
end;

 {*********** IsValidMove ************}
function TForm1.isvalidMove(var board:TBoard; c,r, newval:integer):boolean;
var
  saveval:integer;
  i,j:integer;
begin
  with board[c,r] do
  begin
    saveval:=value;
    if value>0 then
    begin  {temporarily remove any existing value in the target cell}
      value:=0;
      fillpossibles(board);
    end;
    result:=false;
    if (newval=0) or possibles[newval] then
    begin
      {did it leave a cell with no possibilities?}
      result:=true;
      value:=newval;
      fillpossibles(board);
      for i := 1 to 9 do
      begin
        for j:= 1 to 9 do
        with board[i,j] do
        begin
          if (value=0) and (nbrpossibles=0) then
          begin
            result:=false;
            break;
          end;
        end;
      end;
    end;
    value:=saveval;
    fillpossibles(board);
  end;
end;

{************* Loadcase **********}
function TForm1.loadcase(fname:string):boolean;
var
  i,j,n:integer;
  f:textfile;
  line:string;
  r:boolean;
begin
  result:=false;
  if not checkmodified then exit;
  r:=fileexists(fname);
  if r then
  begin
    result:=true;
    assignfile(f,fname);

    reset(f);
    for i:=1 to 9 do for j:=1 to 9 do
    begin
      board[i,j].value:=0;
      origboard[i,j].value:=0;
    end;
    while not eof(f) do
    begin
      readln(f,line);
      if length(line)>=3 then
      begin
        i:=strtoint(line[1]);
        j:=strtoint(line[2]);
        n:=strtoint(line[3]);
        board[i,j].value:=n;
        if (length(line)>3) and (line[4]='*')
        then origboard[i,j].value:=n;
      end;
    end;
    closefile(f);
    Initcase(false);
    //m1Btn.setfocus;
    puzzlename:=fname;
    PuzzlefileLbl.caption:= 'Puzzle: '+extractfilename(fname);
    modified:=false;
  end;
end;

{************ Savecase **********}
Procedure TForm1.Savecase(fname:string);
var
  f:textfile;
  i,j:integer;
  rec:string;
begin
  assignfile(f,fname);
  rewrite(f);
  for i:= 1 to 9 do for j:=1 to 9 do
  if (board[i,j].value>0) then
  begin
    if origboard[i,j].value>0then
    begin
      rec:=format('%d%d%d*',[i,j,origboard[i,j].value]);
      if ((origboard[i,j].value<>board[i,j].value) and (mode=play))
      then  showmessage('Warning - original value was modified, original value '
                         +#13+format('%d saved for column %d, row %d',
                         [origboard[i,j].value,i,j]));
    end
    else rec:=format('%d%d%d',[i,j,board[i,j].value]);
    writeln(f, rec);
  end;
  closefile(f);
  PuzzleFileLbl.caption:='Puzzle: '+extractfilename(fname);
  mode:=play;
  modified:=false;
end;


{************* Checkmodified *************8}
function TForm1.CheckModified:boolean;
var r:integer;
begin
  result:=true;
  if modified then
  begin
    r:=messagedlg('Save current puzzle first?', mtconfirmation,
                     [mbyes, mbno,mbcancel],0);
    if r=mryes then savecaseBtnClick(self)
    else if r=mrcancel then result:=false;
  end;
  if result=true then modified:=false; {reset modified unless user replied "cancel"}
end;

{************ FormCloseQuery ************8}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  {Allow close if puzzle was not modiied or was modified but the user replied
   Yes or No to the save case" question.  Disallow close only if user repied "Cancel"}
  canclose:=checkmodified;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{************ FormActivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
var
  ini:TInifile;
  inipath:string;
begin
   inipath:=extractfilepath(application.ExeName);
   ini:=tinifile.create(inipath+'sudoku.ini');
   with ini do
   begin
     Hintbox.Checked:=readBool('General','ShowHints',false);
     VerboseBox.Checked:=readbool('General','Verbose',true);
     maxtriesSpinEdt.Value:=readinteger('General','MaxTries', 100);
     m1SpinEdt.Value:=readinteger('General','M1Count', 30);
     m2SpinEdt.Value:=readinteger('General','M2Count', 50);
     Puzzlename:=readstring('General,','Puzzlename',inipath+'default.txt');
     free;
   end;
   InitDefault;
   adjustgridsize(stringgrid1);
end;

{************** FormClose *************8}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);

var
  ini:TInifile;
  ininame:string;
begin
  ininame:=extractfilepath(application.ExeName)+'sudoku.ini';
  ini:=tinifile.create(ininame);
  with ini do
  begin
     writebool('General','ShowHints',Hintbox.checked);
     Writebool('General','Verbose',verbosebox.Checked);
     Writeinteger('General','MaxTries', maxtriesSpinEdt.Value);
     WriteInteger('General','M1Count', m1spinedt.value);
     WriteInteger('General','M2Count', m2spinedt.value);
     Writestring('General','Puzzlename', Puzzlename);
     free;
  end;

end;

procedure TForm1.ModifygrpClick(Sender: TObject);
var
  i,j:integer;
begin
  if checkmodified then
  begin
    restartbtnclick(sender);
    hintbox.Checked:=false;
    with modifygrp do
    begin
      if (itemindex=0) or ((itemindex=1) and checkmodified) then
      for i:= 1 to 9 do for j:=1 to 9 do
      begin
        if itemindex=1  {new empty case}  then  origboard[i,j].Value:=0;
        board[i,j].Value:=origboard[i,j].value;
        modified:=true;
      end;
      initcase(true);
      mode:=createcase;
      if modifygrp.itemindex=1  {new empty case}
        then PuzzleFileLbl.caption:='Puzzle: New - Unsaved';
    end;
  end;
end;
{************* ModifySheetEnter *************}
procedure TForm1.ModifysheetEnter(Sender: TObject);
begin
  ModifyGrp.ItemIndex:=-1;  {so useemust click to select his option}
end;


procedure TForm1.PageControl2Change(Sender: TObject);
begin
  with memo5 do
  If Pagecontrol2.activepage = RandomSheet then
  begin
     Visible:=true;
     Clear;
     lines.add('Status:');
  end
  else Visible:=false;
end;

end.
