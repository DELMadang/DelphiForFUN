unit U_WordSquares;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, shellapi;

type
  TForm1 = class(TForm)
    Lettergrid: TStringGrid;
    MakeBtn: TButton;
    Memo1: TMemo;
    WordSizegrp: TRadioGroup;
    ShowBtn: TButton;
    StatsGrid: TStringGrid;
    RestartBtn: TButton;
    StaticText1: TStaticText;
    procedure MakeBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure ShowBtnClick(Sender: TObject);
    procedure LettergridKeyPress(Sender: TObject; var Key: Char);
    procedure StatsGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure RestartBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    list:TStringlist;
    w:array of string;
    lcount:array['a'..'z'] of integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses UDict;


var
  wordsize:integer=4;

{**************** AdjustGridSize *************}
procedure AdjustGridSize(grid:TDrawGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;

{******** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  {we are drawing on the canvas which is not automatically assigned the
   grid font characteristics}
  LetterGrid.canvas.font:=LetterGrid.font;
  pubdic.loaddicfromfile(extractfilepath(application.exename)+'General.dic');
  with StatsGrid do
  begin
    cells[0,0]:='Letters -->';
    cells[0,1]:='Number to use:';
    cells[0,2]:='Used:';
    colwidths[0]:=canvas.textwidth(cells[0,1])+10;
  end;
  randomize;
end;


{************** MakeBtnClick **********8}
procedure TForm1.MakeBtnClick(Sender: TObject);
{Make a new puzzle}

      {++++ FindNextWords +++++}
      function findnextWords(n:integer):boolean;
      {Recursive word search for next word in the solution}
      var
       i:integer;
       testw:string;

                {----  WordOK -----}
                function  WordOK(const ww:string):boolean;
                {Function to check a single word to see if it qualifies with
                 previous words}
                var j:integer;
                begin
                  result:=true;
                  for j:=1 to n do
                  begin
                    {if jth letter of input is not the same as the n+1st letter
                     of word j-1 (words indexed relatitive to 0),then this word
                     is invalid}
                     {e.g. checking 3rd word (n=2) "AREA" when 1st word, w[0],
                      is "SHAM" and 2nd word, w[1], is "HIRE". Note index for
                      1st word is 0 and index for 2nd word is 1 so we check that
                      1st letter "A"  matches 3rd letter (n+1=3). It does so
                      check then 2nd letter "R" matches 3rd letter of word  #2.
                      It does so AREA is valid}
                    if ww[j]<>w[j-1,n+1] then
                    begin
                      result:=false;
                      break;
                    end;
                  end;
                end;

     begin {findnextWords}
       for i:=1 to 1000 do {try 1000 random words first so that different puzzle
                            could be created even the same starting word}
       begin
         testw:=list[random(list.count)];
         result:=wordOK(testw); {check the word}
         if result then break;
       end;
       if not result then  {no word found in 1000 random trys, so try all words}
       for i:=0 to list.count-1 do
       begin
         testw:=list[i];
         result:=wordOK(testw);
         if result then break;
       end;
       if result then
       begin
         w[n]:=testw;
         if n<wordsize-1 then result:=findnextwords(n+1);
       end;
     end; {findnextwords}


 var
   count, loopcount:integer;
   OK:boolean;
   s, testw:string;
   i,j:integer;
   ch:char;
begin {MakeBtnClick }
  {Adjust word array and display grid for current word size}
  if wordsizegrp.itemindex=0 then wordsize:=4
  else wordsize:=5;
  setlength(w,wordsize);
  with LetterGrid do
  begin
    colcount:=wordsize;
    rowcount:=wordsize;
    adjustgridsize(LetterGrid);
    for i:=0 to wordsize-1 do
    for j:=0 to wordsize-1 do  cells[i,j]:=' ';
  end;

  With pubdic do
  begin
    setrange('a',wordsize,'z',wordsize);
    count:=getwordcount;
    loopcount:=0;
    list:=TStringlist.create;
    list.sorted:=true;
    for i:=0 to count-1 do
    begin
      getwordbyNumber(i,testw);
      list.add(testw);
    end;
    OK:=false;
    while (loopcount<10000) and (not OK) do
    begin
      w[0]:=list[random(count)];
      OK:=FindNextWords(1);
      inc(loopcount);
    end;
    if OK then {solution  found}
    begin
     {count letters in words other than the first}
     for ch:='a'to'z' do lcount[ch]:=0;
     {cont letter frequencies skipping 1st word and 1st letter of each word}
     for i:=1 to wordsize-1 do
     for j:=2 to wordsize do inc(lcount[w[i,j]]);
     s:='';
     for ch:='a' to 'z' do
     if lcount[ch]=1 then s:=s+'1 '+uppercase(ch)+', '
     else if lcount[ch]>1 then s:=s+ inttostr(lcount[ch])+' '+ uppercase(ch)+'s, ';
     delete(s,length(s),1); {delete extra ',' at end of string}
     memo1.lines[memo1.lines.count-1]:=s;
     {fill in first word}
      for i:=0 to wordsize-1 do
      for j:=0 to wordsize-1 do
      if (i=0) or (j=0) then LetterGrid.cells[i,j]:=uppercase(w[i,j+1]);
      showbtn.enabled:=true;
      {fill in the "letters required" grid}
      with StatsGrid do
      begin
        colcount:=1;
        for ch:='a' to 'z' do
        if lcount[ch]>0 then
        begin
          colcount:=colcount+1;
          cells[colcount-1,0]:=upcase(ch);
          cells[colcount-1,1]:=inttostr(lcount[ch]);
          cells[colcount-1,2]:='0';
        end;
        adjustgridsize(StatsGrid);
      end;
    end
    else
    begin
      showmessage ('No square found, try again');
      showbtn.enabled:=false;
    end;
  end;
end;

{********** StringGridDrawCell **********}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw the current cell contents, do it this way because default drawing
 always highlights the selected cell which we don't want}
begin
  with tstringgrid(sender),canvas do
  begin
    rectangle(rect);
    textout(rect.left+8, rect.top+8, uppercase(cells[acol,arow]) );
  end;
end;

procedure TForm1.StatsGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with tstringgrid(sender),canvas do
  begin
    rectangle(rect);
    textout(rect.left+2, rect.top+2, cells[acol,arow] );
  end;

end;



{************** ShowBtnClick ***********}
procedure TForm1.ShowBtnClick(Sender: TObject);
{Display the solution}
var
  i,j:integer;
begin
  for i:=0 to wordsize-1 do
  for j:=0 to wordsize-1 do
  LetterGrid.cells[i,j]:=uppercase(w[i,j+1]);
end;

function LowCase(ch:char):char;
begin
  result:=char(ord(ch) or $20);
end;

procedure TForm1.LettergridKeyPress(Sender: TObject; var Key: Char);
{Process a usewr keypress on the puzzle}
var
  ch,cel:char;
  OK:boolean;
  i,j:integer;
  acol,arow,n:integer;
  s:string;
begin
  OK:=false;
  ch:=lowcase(key);  {make sure it's lowercase}
  if not (ch in ['a'..'z',' ']) then exit; {only allow ' ' and letters}
  if (ch<>' ') and (lcount[ch]=0) then exit; {only consider ' ' and letters in the words}
  with LetterGrid do if (col=0) or (row=0) then exit;  {can'y update the given word}
  with LetterGrid do
  begin
    cel:=lowcase(cells[col,row][1]);
    if cel<>' ' then
    begin  {erase the cell contents}
      if (col=row) and (lcount[cel]>0) then
      begin
        dec(lcount[cel]);
        cells[col,row]:=' ';
        ok:=true;
      end
      else
      if lcount[cel]>1 then
      begin
        dec(lcount[cel],2);
        cells[col,row]:=' ';
        cells[row,col]:=' ';
        ok:=true;
      end;
    end;
    If ch<>' ' then {we should have something to add}
    if ch<>cel then  {If it were = then nothing to change}
    begin
      if (col=row)  then
      begin
        inc(lcount[ch]);
        cells[col,row]:=upcase(ch);
        ok:=true;
      end
      else
      begin
        inc(lcount[ch],2);
        cells[col,row]:=upcase(ch);
        cells[row,col]:=uppercase(ch);
        ok:=true;
      end;
    end;
    if OK then  {we did make a change to the grid}
    begin
      {fill in the user feedback grid with letter counts}
      {multiple letters may have been added and others overwritten, so
       it's easiest just to check them all}
      for i:=1 to StatsGrid.colcount-1 do
      with LetterGrid do
      begin
        n:=0;
        for acol:=1 to colcount-1 do
        for arow:=1 to rowcount-1 do
        begin
          ch:=cells[acol,arow][1]; {get the letter}
          if StatsGrid.cells[i,0]=ch then inc(n);
        end;
        StatsGrid.cells[i,2]:=inttostr(n);
        with StatsGrid do if cells[i,2]<>cells[i,1] then OK:=false;
      end;

      if OK then {letter counts matched}
      begin
        {make sure that all words are in the word list, user's solution
         make be different than ours but still correct}
        for i:=1 to wordsize-1 do
        begin
          s:='';
          for j:=0 to wordsize-1 do s:=s+cells[i,j]; {extract the word from the grid}
          if not list.find(s,j) then
          begin
            OK:=false;
            break;
          end;
        end;
        if OK then {it is a solution, see if it is same ours}
        begin
          for i:=1 to wordsize-1 do
          begin
            for j:=1 to wordsize-1 do
            begin
              ch:=lowcase(cells[i,j][1]);
              if ch<>w[i,j+1]  then
              begin
                OK:=false;
                break;
              end;
            end;
            if not OK then break;
          end;
          if OK then showmessage('Solved, congratulations!')
          else showmessage('Solved, your solution is valid, but not the one I found'
                  +#13+'Congratulations!');
        end;
      end;
    end
    else beep;
  end;
end;



procedure TForm1.RestartBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  for i:=1 to wordsize-1 do for j:=1 to wordsize-1 do LetterGrid.Cells[i,j]:=' ';
  with StatsGrid do for i:=1 to colcount-1 do cells[i,2]:='0';
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
