Unit U_Crosswords31;
{Copyright  © 2003-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Version 2 of a crossword puzzle generator
   User selectable wordlists
   Primary and secondary list capability, secondary used when necessary to fill entries
   User can add/change clues for a generated puzzle and save clues in wordlist
   User specifies puzzle size, min/max wordgths to use, and max # of words to generate
   Word Search puzzle generation (thanks to Charles Doumar for this code).
   Print preview and Print functions for generated puzzles.
   Puzzle images may saved and restored later to print extra copies.
 }

 {Version 3 adds
    Extended search option will generate up 1000 puzzles trying to use number of
       words specified.
    The inital word will be centered rather than starting in the top left corner
       to allow more flexibility in placing words
    Final puzzles are now centered on the board.
    Word list is displayed and may be changed by the user from withing the program.
}

{V3.1  adapts an idea from grandson Luke to insert partial versions of words used
 in Searchword puzzles to make the words harder to find.  He's a fiendish little
 devel!  Works best with longer searchwords including the included LukesPuzzle.txt
 with words from his homework assignment regarding their current class project,
 reading "The Odyssey".  In the 6th grade yet!}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, Spin, ComCtrls, shellapi, Menus, Inifiles, printers,
  ExtCtrls, DFFUtils;

type
  TDir=(West,North, South, East,NorthWest,SouthWest,SouthEast,NorthEast);
  TUsed=class(Tobject) {object attached to usedwords showing origin and direction}
    start:TPoint;
    direction:TDir;
  end;

  TSquare=record
    ch:char;
    cluenbr:integer;
  end;

  TClue = class(TObject)
    clue:string;
  end;

  TPuzzleType= (Crossword, Wordsearch);

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    N1: TMenuItem;
    Print1: TMenuItem;
    Exit1: TMenuItem;
    OpenWordsDLG1: TOpenDialog;
    SavePuzzleDlg: TSaveDialog;
    PrintDialog1: TPrintDialog;
    Openwordlist1: TMenuItem;
    PageControl1: TPageControl;
    PuzzleSheet: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    CountLbl: TLabel;
    BoardGrid: TStringGrid;
    MinWordSize: TSpinEdit;
    MaxWordSize: TSpinEdit;
    GenerateBtn: TButton;
    Maxwords: TSpinEdit;
    Hsizeedt: TSpinEdit;
    VSizeedt: TSpinEdit;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    StaticText1: TStaticText;
    CluesSheet: TTabSheet;
    Acrossgrid: TStringGrid;
    Label8: TLabel;
    Label9: TLabel;
    Downgrid: TStringGrid;
    OpenPuzzleDlg: TOpenDialog;
    SaveWordsDlg: TSaveDialog;
    Savewordlist1: TMenuItem;
    Savewordlistas1: TMenuItem;
    WordSearchBtn: TButton;
    OpenWordsdlg2: TOpenDialog;
    N2: TMenuItem;
    Intro: TTabSheet;
    Memo2: TMemo;
    Label10: TLabel;
    PrinterSetup1: TMenuItem;
    Printpreview1: TMenuItem;
    PreviewBtn: TButton;
    PrinterSetupDialog1: TPrinterSetupDialog;
    N3: TMenuItem;
    EnterchangeTitle1: TMenuItem;
    ExtendedBox: TCheckBox;
    Memo3: TMemo;
    Wordlistlbl: TLabel;
    PuzzleLbl: TLabel;

    procedure FormActivate(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
    procedure SizeedtChange(Sender: TObject);    procedure StaticText1Click(Sender: TObject);


    procedure FormCreate(Sender: TObject);
    procedure BoardGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);   {OnDrawCell exit}
    procedure CluesGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure Openwordlist1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Savewordlist1Click(Sender: TObject);
    procedure Savewordlistas1Click(Sender: TObject);
    procedure WordSearchBtnClick(Sender: TObject);
    procedure Printpreview1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure PrinterSetup1Click(Sender: TObject);
    procedure EnterchangeTitle1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  public
    board:array of array of Tsquare;
    hsize,vsize:integer; {horizontal and vertical board sizes}
    WordsClues:array [1..2] of Tstringlist;
    Words: array [1..2] of Tstringlist; {Words randomized and with clues attached as objects}
    Usedwords:Tstringlist;  {words used in a puzzle}
    wordcount:integer; {count of words placed in the puzzle}
    puzzlename:string;
    wordlistname: array[1..2] of string;
    cluenbr:integer;
    drawgray:boolean;
    clueschanged:boolean;  {flag to say clues have been modified}
    Currentpuzzletype:TPuzzletype;
    Doprintpreview:boolean;
    showdata:boolean; {flag to indicate that puzzle grid contents are to be drawn}
    TitleAsk:boolean;
    TitleStr:string;
    Titlefont:TFont;
    reloadwords:boolean;
    {array of X and y offsets for next letter for each direction}
     xoffset:array[tdir] of integer;
     yoffset: array[tdir] of integer;

    procedure setpuzzlename(const s:string);
    procedure LoadWordList;
    procedure setboardsize;
    function  getnextword(dir:TDir):boolean;
    procedure showboard(const pause:boolean);
    procedure addword(const dir:TDir; const w:string; const P:TPoint; Const UpdateUsed:boolean);
    function  findaword(maxsize:integer; ch:char; var loc:integer; findmax:boolean):string;
    procedure scramblewords;
    procedure fillCanvascell(pCanvas:TCanvas; acol,arow:integer;
                          rect:Trect; state:TGridDrawState; cell:string);
    procedure checkmodified; {check if memo1.text has been modified before overwriting}
    {function  PrintMemo(lines:TStrings;newfont:TFont; Arect:Trect; PCanvas:TCanvas;
                          var lastlinenbr, lastlineY:integer):boolean;}
    function  WS_CalculateOverlap(const X, Y: integer; const Len : integer;
                              const AWord: String; const dir:TDir): integer;
    function  WS_CanPlace(const AWord : String;const AWordLen:Integer;
                          const UpdateUsed:boolean): boolean;
    procedure WS_CreateWordFind;
    {procedure GridToCanvas(Grid:TStringgrid; newwidth:integer;
                          origin:TPoint; var newheight:integer; Pcanvas:TCanvas);}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses UPrintPreview,math;



(*
{**************** AdjustGridSize ***********}
 procedure adjustGridSize(grid:TStringGrid);
{Adjust borders of grid to just fit cells}
begin
  with grid do
  begin
    height:=(defaultrowheight+GridLineWidth)*rowcount+gridlinewidth+2 {+2 for border};
    width:=colcount*(defaultcolwidth+gridlinewidth)+gridlinewidth+2 {+2 for border};
  end;
end;
*)

{***************** AddWord *************}
procedure TForm1.addword(const dir:TDir; const w:string; const p:TPoint;
                         const UpdateUsed:boolean);
{Insert the passed word, "w", into the board in direction "dir" starting at point "p"}
var i:integer;
    t:Tused;
begin
  case dir of
    East: for i:= 1 to length(w) do board[p.x+i-1,p.y].ch:=w[i];
    South: for i:= 1 to length(w) do board[p.x,p.y+i-1].ch:=w[i];
    SouthEast: for i:= 1 to length(w) do board[p.x+i-1,p.y+i-1].ch:=w[i];
    NorthEast: for i:= 1 to length(w) do board[p.x+i-1,p.y-i+1].ch:=w[i];
    North: for i:= 1 to length(w) do board[p.x,p.y-i+1].ch:=w[i];
    NorthWest: for i:= 1 to length(w) do board[p.x-i+1,p.y-i+1].ch:=w[i];
    SouthWest: for i:= 1 to length(w) do board[p.x-i+1,p.y+i-1].ch:=w[i];
    West: for i:= 1 to length(w) do board[p.x-i+1,p.y].ch:=w[i];
  end;
  t:=TUsed.create;
  t.direction:=dir;
  t.start:=p;
  if updateUsed then
  begin
    usedwords.addobject(w,t);
    inc(wordcount);
  end;  
  if not extendedbox.checked then
  begin
    countlbl.caption:=inttostr(wordcount);
    application.processmessages;
    showboard(updateused);
  end;
end;

{****************** LoadWordList *************}
procedure TForm1.LoadWordList;
{Load lists of candidate words and randomly shuffle them}
var i,j,k,n:integer;
    s:string;
  begin
    checkmodified;
    Statusbar1.panels[0].text:='Word file(s) - ';

    for j:=1 to 2 do
    begin
      words[j].clear;
      if wordlistname[j]<>'' then
      begin
        wordsclues[j].loadfromfile(wordlistname[j]);
        
        with wordsclues[j] do
        for i:=count-1 downto 0 do
        begin  {make sure each entry has at least an = sign so names entry will exist}
          strings[i]:=trim(strings[i]);
          if (strings[i]='') or (strings[i][1]='*') then delete(i)
          else
          begin
            n:=pos('=',strings[i]);
            if n=0 then
            begin
              strings[i]:=strings[i]+'=';
              n:=length(strings[i]);
            end;
            {deblank and make the word uppercase (but leave the clue alone)}
            s:='';
            for k:=n-1 downto 1 do
            begin
              if strings[i][k]<>' ' then s:=strings[i][k]+s
              else dec(n); {dropping a blank, so = sign will move back by 1}
            end;
            strings[i]:=Uppercase(s)+copy(strings[i],n,length(strings[i])-n+1);

          end;
        end;
        {separate words from clues into a separate list}
        with wordsclues[j] do  for i:=0 to count-1 do words[j].add(names[i]);

        scramblewords; {and scramble them up}

        {adjust maxwordsize to longest word in main list}
        maxwordsize.value:=maxwordsize.minvalue;
        if j=1 then with words[1] do
        for i:=0 to count-1 do
        if length(strings[i])>maxwordsize.value
        then maxwordsize.value:=length(strings[i]);

        {update status bar}
        if j=1 then
        begin
          statusbar1.panels[0].text:=statusbar1.panels[0].text
                                               + ' Primary: '
                                               + extractfilename(wordlistname[1]);
          memo1.lines.assign(words[1]);
          memo1.modified:=false;
          memo1.bringtofront;
        end
        else statusbar1.panels[0].text:=statusbar1.panels[0].text
                                        + ', Secondary: '
                                        + extractfilename(wordlistname[2]);
      end
      else if j=1 then
      begin
        statusbar1.panels[0].text:=statusbar1.panels[0].text
                                                  + ' Primary: None';
        memo1.clear;
      end
      else  statusbar1.panels[0].text:=statusbar1.panels[0].text
                                                  + ', Secondary: None';
    end;
    memo3.clear;
  end;

{************ CheckModified ********}
procedure TForm1.checkmodified;
{check to see if wordlist[1] (displayed in memo1) was modified, and give user
 a chance to save it}
 begin
   if memo1.modified then
   begin
     if messagedlg('Save word list first?', MTCONFIRMATION, [mbyes,mbno],0)=mryes
     then savewordlistas1click(self);
   end;
 end;

{**************** Scramblewords **************}
procedure Tform1.scramblewords;
var i,j,k:integer;
    t:string;
  begin
    for k:=1 to 2 do
    if words[k].count>0 then
    with words[k] do
    begin
      {scramble the list}
      for i:= count-1 downto 2 do
      {swap words from bottom up with words from top end of list}
      begin
        j:=random(i);
        t:=strings[i];
        strings[i]:=strings[j];
        strings[j]:=t;
      end;
    end;
  end;

{************* FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization}
begin
  SizeedtChange(sender);
  randomize;
  PageControl1.Activepage:=Intro;
  CluesSheet.tabvisible:=false;
end;

{************** SetBoardSize ***********}
procedure TForm1.setboardsize;
{set the size of the board array and clear it}
var i,j:integer;
begin
  hsize:=hsizeedt.value;  vsize:=vsizeedt.value;
  setlength(board,Hsize+2,Vsize+2);
  {clear board and place a semaphore border around the board to simplify border testing}
  for i:=0 to Hsize+1 do
  for j:=0 to Vsize+1 do
  begin
    board[i,j].ch:=' ';
    board[i,j].cluenbr:=0;
  end;
  wordcount:=0;
  maxwords.maxvalue:=words[1].count;
  maxwords.value:=min(maxwords.value,maxwords.maxvalue);
end;

{************* ShowBoard *******}
procedure TForm1.showboard(const pause:boolean);
{copy board contents to grid for display}
var i,j:integer;
begin
  for i:=0 to high(board)-2 do
  for j:= 0 to high(board[i])-2 do BoardGrid.cells[i,j]:=board[i+1,j+1].ch;
  Boardgrid.update;
  if pause then sleep(500);
end;

{*********************** FindAWord **************}
function TForm1.findaword(maxsize:integer; ch:char; var loc:integer; findmax:boolean):string;
{search the words list for the largest word <= "maxsize" with character "ch"
 in postion "loc"}
 var
   i,j,k:integer;
   s, bestS:string;
   slen:integer;
begin
  result:='';
  slen:=0;
  for k:=1 to 2 do
  if slen=0 then
  with words[k] do
  begin
    for i:= 0 to count-1 do
    begin
      s:=strings[i];
      if (length(s)>slen) and (length(s)<=maxsize) and (length(s)<=maxwordsize.Value)
         and  (length(s)>=minwordsize.value)
      then
      begin
        if (loc=0) then
        begin
          {make sure it hasn't already been used}
          j:= usedwords.indexof(s);
          if j=-1 then
          begin
            bests:=s;
            slen:=length(s);
          end;
        end
        else if (loc>0) then
        begin
          for j:= loc-maxsize+length(s) to loc do
          begin
            if (J>=1) and (j<=length(s)) and (s[j]=ch)  then
            begin
              if usedwords.indexof(s)<0 then
              begin
                bests:=s;
                slen:=length(s);
                loc:=j;
              end;
            end;
          end;
        end;
      end;
      if ((not findmax) and (slen>0))
         or  (findmax and (slen=maxsize)) then break; {find 1st or longest based on findmax}
    end;
  end;
  if slen>0 then result:=bests else result:='';
end;



{*********** GetNextWord *********}
function TForm1.getnextword(dir:TDir):boolean;
{Recursive routine to generate the next word in the next direction}
var
  s:string;
  i,j,k,xx,yy:integer;
  u,b:integer; {upper and bottom, or left and right limits of word space found}
  p, pstop:TPoint;
  Testdir:Tdir;
begin
  result:=false;
  testdir:=dir;
  if (wordcount>=words[1].count) or (wordcount>=maxwords.value) then exit;
  if wordcount=0 then
  begin  {get the first word}
    i:=0;
    s:=findAword(hsize,' ',i,false);
    If s<>'' then
    begin
      if length(s)+5>hsize then addword(dir,s,point(hsize-length(s)+1,5), true)
      else addword(dir,s,point(5,5), True);
      result:=getnextword(South{V});
    end
    else result:=false;
  end
  else {after first}
  repeat
    with usedwords do
    case testdir of
    South:  {place a Vertical word}
      begin  {search horizontal words for an potential vertical word site}
        i:=count-1;
        s:='';
        while i>=0 do {try horizontal words from back to front of usedword list}
        begin
          if TUsed(objects[i]).direction=East{H} then
          begin
            {search up and down from each letter until we find a place that a word
            could fit}
            p:=TUsed(objects[i]).start;

            pstop:=point(p.x+length(usedwords[i])-1,p.y);
            with p do
            repeat
              xx:=x{-1};
              while (xx<=pstop.x)
              {** look for a place in the horizontal word that has space above and below it}
              and ((board[xx,y-1].ch<>' ')) or ((board[xx,y+1].ch<>' '))
                   do inc(xx);
              if (xx>=x) and  (xx<=pstop.x) then
              begin
                {look up and down and find highest starting cell and longest word
                that could fit here}
                x:=xx;
                {** start looking upwards as far as possible, cell and the one
                being checked and the one to the left and right must be empty }
                u:=y-1;
                while (u>0) and ((board[x-1,u].ch=' '))
                 and (board[x,u].ch=' ') and ((board[x+1,u].ch=' '))
                 and (board[x,u-1].ch=' ')
                 do dec(u);

                b:=y+1;  {** now look downwards the same way}
                while (b<=vsize{-1})
                 and ((board[x-1,b].ch=' '))
                 and (board[x,b].ch=' ')
                 and ((b=vsize{-1}) or (board[x,b+1].ch=' '))
                 and ((board[x+1,b].ch=' '))
                 do inc(b);
                inc(u);
                dec(b);
                j:=b-u+1; {length of word space}
                if j>=minwordsize.value then
                begin
                  k:=y-u+1; {** location of letter that must match}
                  {** Find and insert a word that has length up to length j,
                     and that has letter ch at posiition k }
                  s:=findaword(j,board[x,y].ch,k,false);
                  u:=y-k+1;  {recalc word start location, it might have changed when word was found}
                  if s<>'' then
                  begin
                    addword(South,s,point(x,u),true);
                    break;
                  end;
                end
                else s:='';
              end;
              if s='' then inc(x);
            until (s<>'') or (x>pstop.x);
          end;
          if s<>'' then break;
          dec(i);
        end;
        if (s<>'') then  result:=getnextword(East{H})
        else  testdir:=East{H};  {if we failed, try the other direction}
      end;
    {Note - horizontal logic below is the same a vertical logic with role of
     directional  x and y coordinates  swapped}
    East:
      begin  {search vertical words for an potential horizontal word site}
        i:=count-1;
        s:='';
        while i>=0 do {try vertical words from back to front of usedword list}
        begin
          if TUsed(objects[i]).direction=South{V} then
          begin
            {search left and right from each letter until we find a place that a word
            could fit}
            p:=TUsed(objects[i]).start;
            pstop:=point(p.x,p.y+length(usedwords[i])-1);
            with p do
            repeat
              yy:=y;
              while (yy<=vsize) and (yy<=y+length(usedwords[i])-1)
              and ({(x>0) and} (board[x-1,yy].ch<>' ')) or ((board[x+1,yy].ch<>' '))
                 do inc(yy);
              if (yy>=y) and (yy<=vsize) then
              begin
                {look left/right and find first possible starting cell and longesgt word
                that could fit here}
                y:=yy;
                u:=x-1;
                while (u>0) and ((board[u,y-1].ch=' '))
                 and (board[u,y].ch=' ') and ((board[u,y+1].ch=' '))
                 and (board[u-1,y].ch=' ')
                 do dec(u);

                b:=x+1;
                while (b<=hsize)
                 and ((board[b,y-1].ch=' ')) and (board[b,y].ch=' ')
                 and (board[b+1,y].ch=' ') and ((board[b,y+1].ch=' '))
                  do inc(b);

                inc(u);
                dec(b);

                j:=b-u+1; {length of word space}
                if j>=minwordsize.value then
                begin
                  k:=x-u+1; {loc of matching letter}
                  s:=findaword(j,board[x,y].ch,k,false);
                  u:=x-k+1;
                  if s<>'' then
                  begin
                    addword(East,s,point(u,y),true);
                    break;
                  end;
                end;
              end;
              if s='' then inc(y);
            until (s>'') or (y>pstop.y);  {continue searching this word if necessary}
          end;
          if s<>'' then break;
          dec(i);
        end;
        if (s<>'') then result:=getnextword(South{V})
        else testdir:=South; {if we failed, try the other direction}
      end;
    end;
  until (s<>'') or (testdir=dir);
end;

{************** GenerateBtnClick ***********}
procedure TForm1.GenerateBtnClick(Sender: TObject);
{Generate a crossword puzzle}
var i,j,k:integer;
    sortwords:Tstringlist;
    obj:TUsed;
    maxwordcount, targetwords:integer;
    maxloops:integer;
    coltop,collow,rowleft,rowright,vspan, hspan, newtop, newleft,move:integer;

    procedure addclue(n:integer; w:string; grid:Tstringgrid);
    begin
      with  grid do
      begin
        if row>=rowcount-1 then rowcount:=row+2;
        row:=row+1;
        fixedrows:=1;
        cells[0,row]:=inttostr(n);
        cells[1,row]:=w;
        {get clue from primary word list if word exisits a there}
        if wordsclues[1].indexofname(w)>=0
        then  cells[2,row]:=wordsclues[1].values[w]
        else  cells[2,row]:=wordsclues[2].values[w];
       end;
    end;

begin
  if generatebtn.caption='Stop' then
  begin
    tag:=1;
    generatebtn.caption:='Generate crossword';
    exit;
  end;

  memo1.bringtofront;
  CurrentPuzzleType:=Crossword;
  cluesSheet.tabvisible:=true;
  wordlistlbl.caption:='Primary wordlist words';
  showdata:=true;
  titleAsk:=false;
  titlestr:='';
  sortwords:=TStringlist.create;

  //show:=false;  {do not show boards as they are created}
  if extendedbox.checked then maxloops:=1000 else maxloops:=1;
  maxwordcount:=0;
  if reloadwords then words[1].assign(memo1.lines); {word list has been edited by user}
  memo1.onchange:=nil;
  memo1.lines.assign(words[1]);
  memo1.modified:=false;
  targetwords:=min(memo1.lines.count,maxwords.value);
  puzzlelbl.caption:='Crossword Puzzle';
  tag:=0;
  generatebtn.caption:='Stop';

  for k:=1 to maxloops do {run maxloops puzzles looking for one that uses the most words}
  begin
    if tag>0 then break;
    setboardsize;
    Scramblewords;
    if maxloops>1 then puzzlelbl.caption:='Crossword Puzzle #'+inttostr(k);
    application.processmessages;
    wordcount:=0;
    cluenbr:=0;
    drawgray:=false;
    //uselongest:=false;
    screen.cursor:=crHourGlass;
    if usedwords.count>0 then
      for i:=0 to usedwords.count-1 do TUsed(usedwords.objects[i]).free;
      usedwords.clear;
    getnextword(East); {recursive routine to add words to the puzzle}
    {now add clue numbers to words, starting from top left and working across
     and down}


    if wordcount>maxwordcount then
    begin
      {center the final puzzle in the frame}
      coltop:=1000;
      rowleft:=1000;
      collow:=0;
      rowright:=0;
      {find the total span in each direction}
      for i:=1 to hsize do {columns}
      for j:= 1 to vsize do  {rows}
      begin
        if (board[i,j].ch<>' ') then
        begin
          if (i<rowleft) then rowleft:=i;
          if (j<coltop) then coltop:=j;
        end;
        if (board[hsize-i+1,j].ch<>' ') and ((hsize-i+1)>rowright) then rowright:=hsize-i+1;
        if (board[i,vsize-j+1].ch<>' ') and ((vsize-j+1)>collow) then Collow:=vsize-j+1;
      end;

      vspan:=collow-coltop+1;
      newtop:=(vsize-vspan) div 2+1;

      if newtop<coltop then
      begin
        move:=coltop-newtop;
        for i:=1 to hsize do
        for j:=1 to vsize do
          if j+move <= vsize then board[i,j].ch:=board[i, j+move].ch
          else board[i,j].ch:=' ';
       {update usedwords object which has word starting location}
          for i:=0 to usedwords.count-1 do
          with Tused(usedwords.objects[i]) do
          {if start.y-move<=1 then} start.y:=start.y-move;
      end
      else
      if newtop>coltop then {movedown}
      begin
        move:=newtop-coltop;
        for i:=1 to hsize do
        for j:=vsize downto 1 do
         if j-move >=1 then board[i,j].ch:=board[i,j-move].ch
         else board[i,j].ch:=' ';
         {update usedwords object which has word starting location}
          for i:=0 to usedwords.count-1 do
            with Tused(usedwords.objects[i]) do
            {if start.y+move<=vsize then} start.y:=start.y+move;
      end;

      hspan:=rowright-rowleft+1;
      newleft:=(hsize-hspan) div 2+1;
      if newleft<rowleft then
      begin
        move:=rowleft-newleft;
        for i:=1 to hsize do
        for j:=1 to vsize do
          if i+move <= hsize then board[i,j].ch:=board[i+move,j].ch
          else board[i,j].ch:=' ';
        {update usedwords object which has word starting location}
          for i:=0 to usedwords.count-1 do
            with Tused(usedwords.objects[i]) do
            {if start.x+move<=hsize then} start.x:=start.x-move;
      end
      else
      if newleft>rowleft then {movedown}
      begin
        move:=newleft-rowleft;
        for i:=hsize downto 1 do
        for j:=1 to vsize do
         if i-move >=1 then board[i,j].ch:=board[i-move,j].ch
         else board[i,j].ch:=' ';
         {update usedwords object which has word starting location}
          for i:=0 to usedwords.count-1 do
            with Tused(usedwords.objects[i]) do
            {if start.x-move>=1 then} start.x:=start.x+move;
      end;
      countlbl.caption:=inttostr(wordcount)+' words used';
      countlbl.update;
      showboard(true);
      if (tag=0) and (wordcount=targetwords) then sleep(500);

      maxwordcount:=wordcount;
      if wordcount>=targetwords  then break;

    end;
  end;

  {now add clue numbers to words, starting from top left and working across
   and down}
  for i:=0 to usedwords.count-1 do
  begin
    obj:=tused(usedwords.objects[i]);
    sortwords.addobject(format('%2d%2d%s',[obj.start.y,obj.start.x,usedwords[i]]),obj);
  end;
  sortwords.sort;
  acrossgrid.rowcount:=1;
  downgrid.rowcount:=1;
  for i:= 0 to sortwords.count-1 do
  with TUsed(sortwords.objects[i])  do
  begin
     if board[start.x,start.Y].cluenbr=0 then
     begin
      inc(cluenbr);
      board[start.x,start.y].cluenbr:=cluenbr;
    end;
    if direction=East then addclue(cluenbr,copy(sortwords[i],5,length(sortwords[i])-4),acrossgrid)
    else addclue(cluenbr,copy(sortwords[i],5,length(sortwords[i])-4),downgrid);
  end;
  screen.cursor:=crDefault;
  sortwords.free;
  drawgray:=true;
  memo1.onchange:=memo1change;
  generatebtn.caption:='Generate crossword';
  //boardgrid.invalidate;  {force a redraw of the board to show numbers}
end;



{************* SizeEdtChange ************}
procedure TForm1.SizeedtChange(Sender: TObject);
{Board size changed - redraw it}
begin
  with boardgrid do
  begin
    rowcount:= VSizeEdt.value;
    colcount:= HSizeedt.value;
  end;
  adjustgridsize(boardgrid);
  setboardsize;
end;

{*************** StaticText1Click *************}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************ SetPuzzleName *********}
procedure Tform1.setpuzzlename(const s:string);
begin
  puzzlename:=s;
  statusbar1.panels[1].text:=s;
end;

{************ Formcreate **************}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  chdir(extractfilepath(application.exename));
  openwordsdlg1.initialdir:=extractfilepath(application.exename);
  openwordsdlg2.initialdir:=extractfilepath(application.exename);
  wordlistname[2]:='';
  wordlistname[1]:=extractfilepath(application.exename)+'Small.txt';
  for i:=1 to 2 do
  begin
    wordsclues[i]:=Tstringlist.create;
    words[i]:=TStringlist.create;
  end;
  usedwords:=Tstringlist.create;
  loadwordlist;
  with acrossgrid do
  begin
    colwidths[2]:=450;
    cells[0,0]:='Nbr.';
    cells[1,0]:='Word';
    cells[2,0]:='Clue';
    row:=0;
    rowcount:=1;
  end;
  with downgrid do
  begin
    colwidths[2]:=450;
    cells[0,0]:='Nbr.';
    cells[1,01]:='Word';
    cells[2,0]:='Clue';
    row:=0;
    rowcount:=1;
  end;
  titlefont:=tfont.create;
  with titlefont do
  begin
    name:='Arial';
    size:=14;
    style:=[fsbold];
  end;

  {set up X and Y offsets for next letter for each direction}
  xoffset[west]:=-1;  yoffset[west]:=0;
  xoffset[east]:=+1;  yoffset[east]:=0;
  xoffset[south]:=0;  yoffset[south]:=+1;
  xoffset[north]:=0;  yoffset[north]:=-1;
  xoffset[southwest]:=-1;  yoffset[southwest]:=+1;
  xoffset[southeast]:=+1;  yoffset[southeast]:=+1;
  xoffset[northwest]:=-1;  yoffset[northwest]:=-1;
  xoffset[northeast]:=+1;  yoffset[northeast]:=-1;

end;

{*************** FillCanvasCell ****************}
procedure Tform1.FillCanvasCell(PCanvas:TCanvas; acol,arow:integer;
                          rect:Trect; state:TGridDrawState; cell:string);
{Common drawcell procedure used for preview and printer canvas drawing}

var savesize:integer;
    offsetx,offsety:integer;
  begin
    with Pcanvas do
    begin
      savesize:=font.size;
      PCanvas.Font.Height:=GetDeviceCaps(pCanvas.Handle, LOGPIXELSY)*10 div 72;

      if drawgray and (board[acol+1,arow+1].ch=' ') then brush.color:=clltgray
      else brush.color:=clWhite;
      fillrect(rect);
      if showdata then{put text in the cell}
      begin
        //font.name:='Arial';
        offsetx:=(rect.right-rect.left-textwidth(cell)) div 2+2;
        offsety:=(rect.bottom-rect.top-textheight(cell)) div 2+2;
        textout(rect.left+offsetx, rect.top+offsety, board[acol+1, arow+1].ch);
      end;
      if (board[acol+1,arow+1].cluenbr<>0) then
      begin
        pCanvas.Font.Height :=GetDeviceCaps(pCanvas.Handle,LOGPIXELSY)*8 div 72;
        font.name:='Smallfonts';
        textout(rect.left,rect.top,inttostr(board[acol+1,arow+1].cluenbr));
        font.size:=savesize;
      end;
    end;
  end;

{****************** BoardgridDrawCell **************}
procedure TForm1.BoardGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Fill puzzle cell with the appropriate letter (if any), and add clue numbers
 in top left corner}
begin
  if sender is TStringgrid then
  with sender as Tstringgrid  do  fillCanvasCell(canvas,Acol,Arow,Rect,State,Cells[acol,arow])
  else if sender is TList then
  with Tstringgrid(TList(sender)[0])  do
       fillCanvasCell(TCanvas(Tlist(sender)[1]),Acol,Arow,Rect,State,boardgrid.Cells[acol,arow]);
end;

{************** CluesGridSetEditText *************}
procedure TForm1.CluesGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
  var n:integer;
begin
  with TstringGrid(sender) do
  begin
     n:=wordsclues[1].indexofname(cells[1,arow]);
     if n>=0
     then Wordsclues[1].Strings[n]:=Wordsclues[1].names[n]+'='+cells[2,arow]
     {Delphi bug updating value using following line -
        setting value to empty deletes the list entry altogether!}
     {then Wordsclues[1].values[cells[1,Arow]]:=cells[2,arow]}
     else
     begin
       n:=wordsclues[2].indexofname(cells[1,arow]);
       if n>=0 then Wordsclues[2].strings[n]:=Wordsclues[2].names[n]+'='+cells[2,arow];
      {Wordsclues[2].values[cells[1,Arow]]:=cells[2,arow]; }
    end;
  end;
  clueschanged:=true;
end;

{************** OpenWordList1Click *************}
procedure TForm1.Openwordlist1Click(Sender: TObject);
var
  i,mr:integer;
begin
  If clueschanged then
  begin
    mr:=messagedlg('Currrent word clues have changed, save files?',mtConfirmation,
                    [mbyes,mbno,mbcancel],0);
    if mr=mrcancel then exit
    else if mr=mryes then
    for i:=1 to 2 do
    if wordlistname[i]<>''
    then wordsclues[i].savetofile(wordlistname[i]);
  end;
  for i:= 1 to 2 do
  begin
    wordsclues[i].clear;
    words[i].clear;
  end;
  openwordsdlg1.title:='Select primary word file';
  if OpenWordsDlg1.execute then
  begin
    wordlistname[1]:=OpenWordsDlg1.filename;
    if messagedlg('Open a secondary word file also?',mtconfirmation,[mbyes,mbno],0)=mryes
    then
    begin
      Openwordsdlg2.filename:=wordlistname[2];
      if openwordsdlg2.execute then wordlistname[2]:=openwordsdlg2.filename
      else wordlistname[2]:='';
    end
    else wordlistname[2]:='';
    loadwordlist;
  end;
end;

{************* FormCloseQuery ************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var mr:integer;
begin
  If clueschanged then
  begin
    checkmodified;
    mr:=messagedlg('Word clues changed, save file?',mtConfirmation,
                    [mbyes,mbno,mbcancel],0);
    if mr=mrcancel then begin canclose:=false; exit end
    else if mr=mryes then Savewordlist1Click(sender);
  end;
  canclose:=true;
end;

{*************** SaveWordList1Click ***********}
procedure TForm1.Savewordlist1Click(Sender: TObject);
var i:integer;
begin
  for i:=1 to 2 do
    if wordlistname[i]<>'' then wordsclues[i].savetofile(wordlistname[i]);
  clueschanged:=false;
  memo1.modified:=false;
end;

{************ SaveWordlistAs1Click **************}
procedure TForm1.Savewordlistas1Click(Sender: TObject);
var i:integer;
begin
  for i:=1 to 2 do
  if wordlistname[i]<>'' then
  begin
    savewordsdlg.filename:=wordlistname[i];
    If savewordsDlg.execute then
    begin
      wordlistname[i]:=savewordsdlg.filename;
    end
  end;
  savewordlist1click(sender);
end;


{*********************************************}
{* Word Search code  added by Charles Doumar *}
{*********************************************}

{****************** WordSearchBtnClick **************}
procedure TForm1.WordSearchBtnClick(Sender: TObject);
var i : integer;
begin
  memo3.bringtofront;{let memo3 show through}
  memo3.clear;
  wordlistlbl.caption:='Wordsearch words';
  showdata:=true;
  TitleAsk:=false;
  Titlestr:='';
  currentpuzzletype:=WordSearch;
  CluesSheet.tabvisible:=false;
  screen.cursor:=crhourglass;
  setboardsize;
  scramblewords;
  wordcount:=0;
  if usedwords.count>0 then
  for i:=0 to usedwords.count-1 do TUsed(usedwords.objects[i]).free;
  usedwords.clear;
  WS_CreateWordfind;
  screen.cursor:=crdefault;
  {make top of list visible}
  memo3.selstart:=0;   memo3.sellength:=1;
end;



{******************** WS_CalculateOverlap *************}
Function Tform1.WS_CalculateOverlap(const X, Y: integer; const Len : integer;
                                 const AWord: String; const dir:TDir): integer;

var
 WordLengthMinus1,
 i,
 dx,
 dy,
 TempX,
 TempY : integer;
 AChar : Char;

begin
  Result := 0;
  dx := XOffset[Dir];
  dy := YOffset[Dir];
  Tempx := x;
  Tempy := y;
  WordLengthMinus1 := Len - 1;
  {if word is too large to fit on board then exit}
  if {(WordLengthMinus1 < 0) or}
     (TempY + WordlengthMinus1 * DY > VSize) or
     (TempY + WordLengthMinus1 * DY < 1) or
     (TempX + WordLengthMinus1 * DX > HSize) or
     (TempX + WordLengthMinus1 * DX < 1) then
   begin
     Result := -1;
     exit;
   end;
  {check board to see if word will actually work}
  For i := 1 to Len do
  begin
    aChar := Board[TempX,TempY].ch;
    {count number of matched letters}
    if aWord[i] = aChar then
      Inc(Result)
    else if aChar <> ' ' then
      begin
        {cannot place on board so exit}
        Result := -1;
        exit;
      end;
    {update next board position to check}
    TempX := TempX + DX;
    TempY := TempY + DY;
  end;
end;
var
  {weighted set of directions to favor inserted words in up/left, left,
  and dow/right over right}

  weighteddirs:array[0..16] of TDir=
            (East,  {normal left to right}
             South, {down}
             North,North, {up}
             West,West,   {backwards}
             Southeast,SouthEast, {down & left}
             Southwest,Southwest, {down & right}
             NorthEast,NorthEast,NorthEast, {up and right}
             NorthWest,NorthWest,NorthWest,Northwest  {up and left}
            );

{************* WS_CanPlace ***************}
function TForm1.WS_CanPlace(const AWord : String;
                            const AWordLen:Integer;
                            const updateUsed:boolean): boolean;
var
  WordLen,
  BestOverlap,
  CurOverlap,
  FirstX,
  FirstY,
  CurX,
  CurY : Integer;
  BestDir,
  FirstDir,
  CurDir : TDir;
  BestP : TPoint;
begin
  WordLen := AWordLen;
  //FirstDir := TDir(random(1+ord(high(TDir))));
  {Pick a direction try first weighted in the more difficult directions}
  if updateused then firstdir:= weighteddirs[random(length(weighteddirs))]
  else firstdir:=TDir(random(ord(high(TDir))+1)); {no need to weight "fakewords"}
  FirstX := random(HSize)+1;
  FirstY := random(VSize)+1;
  CurX := FirstX;
  CurY := FirstY;
  CurDir := FirstDir;
  BestOverlap := -1;
  Repeat;
    Repeat;
      CurOverlap := WS_CalculateOverlap(CurX,CurY,WordLen,AWord,CurDir);
      if (CurOverlap > BestOverlap) {and (CurOverlap < WordLen)} then
      begin
        {update best solution found}
        BestOverlap := CurOverlap;
        BestP.X := CurX;
        BestP.Y := CurY;
        BestDir := CurDir;
      end;
       {get next direction}
       inc(CurDir);
       if CurDir > High(TDir) then
       CurDir := Low(TDir);
      {until tried all directions}
      until CurDir = FirstDir;
    {get next X position}
    inc(CurX);
    if CurX > (HSize) then
    begin
      CurX := 1;
      {get next Y Position}
      inc(CurY);
      if CurY > (VSize) then
      CurY :=1;
    end;
    {until tried all board positions}
  until (CurX=FirstX) and (CurY=FirstY);
  if BestOverlap = -1 then
   begin
     {could not place word}
     Result := False;
     exit;
   end
   else
   begin
     {able to place word on board}
     Result := True;
     addword(BestDir,AWord,BestP,updateused);
   end;
end;

{**************** WS_CreateWordFind ************}
procedure TForm1.WS_CreateWordFind;
const
  AsciiPrintable = 32;
VAR i,j,k,AWordLen,
    targetcount:integer;
TotalLettersUsed,Guess,freqstart : INTEGER;
AWord : String;
UsedLetterFreq : Array[AsciiPrintable..255] of integer;
Fakewords:TStringlist;
n:integer;
ch:char;

begin
  {setup tracking variables}
  FillChar(UsedLetterFreq,sizeof(UsedLetterFreq),0);
  TotalLettersUsed := 0;
  targetcount:=min(maxwords.value, words[1].count);
  for i:= 0 to words[1].count-1 do
  begin
    aWord := Words[1].strings[i];
    AWordLen := Length(aword);
    if (AWordLen<=maxwordsize.Value) and (AWordLen>=minwordsize.value)
    then  if WS_CanPlace(aword,AWordLen,true) then
    begin
      {able to place word on board}
      sleep(100);

      memo3.lines.add(aword);
      inc(TotalLettersUsed,AWordLen);
      {update ASCII word freq table
      this is not the same the board frequency since some words may overlap spots}
      for j := 1 to AWordLen do
      begin
        k := ord(Aword[j]);
        if (k >= low(UsedLetterfreq)) and (K <= high(usedletterfreq)) then
        inc(UsedLetterFreq[k]);
      end;
      If usedwords.count>=targetcount {Maxwords.value} then break;
    end;
  end;
  usedwords.sort;
  for i:=0 to usedwords.count-1 do
    memo3.lines.strings[i]:=usedwords.strings[i];
  memo3.lines.insert(0,'--------------------------------------');
  memo3.lines.insert(0,'Word List');


 {MAKE A FAKEWORDS LIST, same as usedwords except 1st or last letter changed}
 fakewords:=TStringlist.create;
 fakewords.assign(usedwords);
 for i:=0 to fakewords.count-1 do
 begin
   aword:=fakewords[i];
   if length(aword)>3 then
   begin
      n:=length(aword); {we'll change 1st ot last letter}
     repeat
       ch:=char(ord('A')+random(26));
     until ch<>aword[n];
     aword[n]:=ch;
     fakewords[i]:=aword;
     {also make atruncated version of longer words which will let us add more
     {because they are shoirter}
     if n>5 then
     begin
       n:= n div 2;
       aword:=copy(aword,1,n);
       repeat
          ch:=char(ord('A')+random(26));
       until ch<>aword[n];
       aword[n]:=ch;
       fakewords.add(aword);
     end;
   end;
 end;
 {Try to fit the fakewords in before filling the grid with random letters}
 for i:= 0 to fakewords.count-1 do
 begin
   aWord := fakeWords.strings[i];
   AWordLen := Length(aword);
   if (AWordLen<=maxwordsize.Value) and (AWordLen>=minwordsize.value)
   then  WS_CanPlace(aword,AWordLen,false);
 end;
 fakewords.free;




  {if no words placed, reset letter freq}
  if totallettersUsed <= 0 then
  begin
    TotalLettersUsed := 26;
    for i := ord('A') to ord('Z') do
      UsedLetterFreq[i] := 1;
  end;
  FreqStart := AsciiPrintable;
  {determine first used letter to speed up search a little}
  while UsedLetterFreq[FreqStart] = 0 do
    inc(FreqStart);
  {find empty board spots ...}
  For i := 1 to HSize do
   for j := 1 to VSize do
   if (board[i,j].ch = ' ') or (board[i,j].ch='') then
   begin
     Guess := Random(TotalLettersUsed)+1;
     {fill empty spot with random letters, but only choose letters actually
      used by placed words}
     for k := FreqStart to 255 do
     begin
       dec(guess,UsedLetterFreq[k]);
       if guess <= 0 then
     begin
         Board[i,j].ch := Chr(k);
         break;
       end;
     end;
   end;
  showboard(true);
end;

{************* Printpreview1Click ***************}
procedure TForm1.Printpreview1Click(Sender: TObject);
var
  r : TRect;
  newheight:integer;
  showgrid:boolean;
  origin:TPoint;
  newwidth:integer;
  list:TStringList;
  i:integer;
  linestr:string;
  lastCharDisplayed:integer;
  L:array[1..5] of tpoint;
  cellsize:extended;
  end1,end2:TPoint;
  //scale:extended;

  procedure swap(var a,b:TPoint);  var t:TPoint;   begin t:=a; a:=b; b:=t; end;

begin

  with printpreview do
  begin
    list:=Tstringlist.create;
    if not titleAsk then TitleStr:= InputBox('Title Box', 'Enter title (optional)', titlestr);
    setpuzzlename(titlestr);
    titleask:=true;
    Newjob;

    origin.x:= XInch(2.0);
    origin.y:= YInch(1.0);
    list.Add(TitleStr);

    with origin do
    MemoOut(rect(x,y,x+xinch(5),y+yinch(0.5)),list, titlefont, LastCharDisplayed, true);
    list.clear;
    origin.y:=YInch(1.5);
    newwidth:= xinch(4);
    if currentpuzzletype=crossword then
    begin
      showdata:=false;
      showgrid:=true;
    end
    else
    begin
      showdata:=true;
      showgrid:=false;
    end;
    StringGridOut(BoardGrid,newwidth, origin, showgrid,showdata,newheight);
    canvas.brush.color:=clWhite;
    showdata:=true;

    If currentpuzzletype=Crossword then
    begin {crosswords}
      with list, acrossgrid do
      begin
        clear;
        add('Across');
        add('--------');
        for i:=1 to rowcount-1 do
        begin
          linestr:=cells[0,i]+'. ';
          linestr:=linestr+cells[2,i];
          add(linestr);
        end;
        with list, Downgrid do
        begin
          add('');
          add('');
          add('Down');
          add('--------');
          for i:=1 to rowcount-1 do
          begin
            linestr:=cells[0,i]+'. ';
            linestr:=linestr+cells[2,i];
            add(linestr);
          end;
        end;
      end;
    end
    else list.assign(memo3.lines);

    {Now show the text data}
    r.left:=Xinch(0.5);
    r.top:=origin.y+newheight+YInch(0.5);
    r.right:=xinch(3.75);
    r.bottom:=Xinch(10.5);
    while list.count>0 do
    begin
      MemoOut(r,list, memo3.font,
              LastCharDisplayed, true);
      if list.count>0 then
      begin
        if r.left=Xinch(0.5) then
        begin
          r.left:=XInch(4.0);
          r.right:=xinch(8.0);
        end
        else
        begin
          newpage;
          r.left:=XInch(0.5);
          r.right:=xinch(3.75);
          r.top:=xinch(0.5);
        end;
      end;
    end;

    {now print solution on a separate page}
    newpage;
    list.clear;
    list.add(titleStr+ '   (Solution)');
    origin.x:=XInch(2.0);
    origin.y:=YInch(1.0);
    with origin do
    MemoOut(rect(x,y,x+xinch(5),y+yinch(0.5)),list, titlefont, LastCharDisplayed, true);
    Origin.y:=Yinch(1.5);
    if currentpuzzletype=crossword then
    begin
      newwidth:= xinch(4);
      StringGridOut(BoardGrid,newwidth, origin, showgrid,showdata,newheight);
    end
    else
    with canvases[currentpage] do
    begin
      newwidth:=xinch(4);
      StringGridOut(BoardGrid,newwidth, origin, showgrid,showdata,newheight);
      pen.color:=clred;
      pen.width:=2;
      //scale:=newheight/boardgrid.height;
      cellsize:=newheight/vsize;

      dec(origin.x,xoff);
      dec(origin.y,yoff);

      for i:=0 to usedwords.count-1 do
      with TUsed(usedwords.objects[i]) do
      begin
        end1:=start;
        end2.x:=start.x+(length(usedwords[i])-1)*xoffset[direction];
        end2.y:=start.y+(length(usedwords[i])-1)*yoffset[direction];
        case direction of
          East,West:
          begin
            If direction=west then swap(end1,end2);
            L[1].x:=origin.x+round(cellsize*(end1.x - 1 + 0.10));
            L[1].y:=origin.y+round(cellsize*(end1.y - 1 + 0.10))+end1.x;
            L[2].x:=origin.x+round(cellsize*(end2.x - 1 + 0.90));
            L[2].y:=origin.y+round(cellsize*(end2.y - 1 + 0.10))+end1.x;
            L[3].x:=origin.x+round(cellsize*(end2.x - 1 + 0.90));
            L[3].y:=origin.y+round(cellsize*(end2.y - 1 + 0.90))-end1.x;
            L[4].x:=origin.x+round(cellsize*(end1.x - 1 + 0.10));
            L[4].y:=origin.y+round(cellsize*(end1.y - 1 + 0.90))-end1.x;
          end;
          South, North:
          begin
            If direction=North then swap(end1,end2);
            L[1].x:=origin.x+round(cellsize*(end1.x - 1 + 0.10))+end1.y;
            L[1].y:=origin.y+round(cellsize*(end1.y - 1 + 0.10));
            L[2].x:=origin.x+round(cellsize*(end2.x - 1 + 0.10))+end1.y;
            L[2].y:=origin.y+round(cellsize*(end2.y - 1 + 0.90));
            L[3].x:=origin.x+round(cellsize*(end2.x - 1 + 0.90))-end1.y;
            L[3].y:=origin.y+round(cellsize*(end2.y - 1 + 0.90));
            L[4].x:=origin.x+round(cellsize*(end1.x - 1 + 0.90))-end1.y;
            L[4].y:=origin.y+round(cellsize*(end1.y - 1 + 0.10));
          end;

          SouthEast,NorthWest:
          begin
            If direction=NorthWest then swap(end1,end2);
            L[1].x:=origin.x+round(cellsize*(end1.x - 1 ));
            L[1].y:=origin.y+round(cellsize*(end1.y - 1 + 0.50));
            L[2].x:=origin.x+round(cellsize*(end1.x - 1 + 0.50));
            L[2].y:=origin.y+round(cellsize*(end1.y - 1));
            L[3].x:=origin.x+round(cellsize*(end2.x - 1 + 1.00));
            L[3].y:=origin.y+round(cellsize*(end2.y - 1 + 0.50));
            L[4].x:=origin.x+round(cellsize*(end2.x - 1 + 0.500));
            L[4].y:=origin.y+round(cellsize*(end2.y - 1 + 1.00));
          end;
          NorthEast,SouthWest:
          begin
            If direction=NorthEast then swap(end1,end2);
            L[1].x:=origin.x+round(cellsize*(end1.x - 1 + 0.50));
            L[1].y:=origin.y+round(cellsize*(end1.y - 1 ));
            L[2].x:=origin.x+round(cellsize*(end1.x - 1 + 1.00));
            L[2].y:=origin.y+round(cellsize*(end1.y - 1 + 0.50));
            L[3].x:=origin.x+round(cellsize*(end2.x - 1 + 0.50));
            L[3].y:=origin.y+round(cellsize*(end2.y - 1 + 1.00));
            L[4].x:=origin.x+round(cellsize*(end2.x - 1 ));
            L[4].y:=origin.y+round(cellsize*(end2.y - 1 + 0.50));
          end;

        end; {case}
        L[5]:=L[1];  {back to start point}
        polyline(L); {outline the word}
      end;
    end;
    list.free;
    if (Sender = PrintPreview1) or (sender=previewbtn) then
    begin
      PrintPreview.Preview;
      PrintPreview.showmodal;
      application.processmessages;
    end
    else  PrintPreview.printBtnclick(sender);
  end;
end;


{************** Exit1Click ***********}
procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

{************** PrinterSetupClick **********}
procedure TForm1.PrinterSetup1Click(Sender: TObject);
begin
  printersetupdialog1.execute;
end;

{*************** EnterChangeTitleClick *************}
procedure TForm1.EnterchangeTitle1Click(Sender: TObject);
begin
  TitleStr:= InputBox('Title box', 'Enter puzzle title (optional)', TitleStr);
  setpuzzlename(titlestr);
  titleask:=true;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  reloadwords:=true;
  maxwords.maxvalue:=memo1.lines.count;
end;

end.


