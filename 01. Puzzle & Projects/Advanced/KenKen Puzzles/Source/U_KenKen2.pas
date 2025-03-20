unit U_KenKen2;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
 KenKen puzzles are similar to Sudoku except with a little math
involved.  The board is divided into sections called "cages".
Each cage has an operator and a target value in the upper
corner.  The numbers filled into the cell in the cage must combine
in any order using the given operation to form the target value.
The values to use are in the range of 1 through the number of
columns (or rows) in the puzzle.  Each unique value(for example
1,2,3,4,5 in the 5x5 puzzle), must occur exactly once in each row
and column. .

Use mouse or arrow keys to select cells and enter a value for
each one.

The "Check"  button will validate the case defintion and the
values entered.   When all cells have been filled, it will be called
after every number entered.  Prior to that you can click the
button anytime to check progress so far.
}

interface

uses
  types,Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Grids, ComCtrls, DFFUtils, math, Ucombov2;


type
  TCellrec=record
    x,y:integer;
    border:string[4];
    v:integer;
    Candidates:array of byte;
  end;

  TCagerec=record
    cagerecnbr:integer;  {index of current record in the cagerecs array}
    CCells:array of TCellrec;

    Value:integer;
    Operator:char;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    BoardGrid: TStringGrid;
    Memo2: TMemo;
    LoadBtn: TButton;
    CheckBtn: TButton;
    SolveBtn: TButton;
    Label1: TLabel;
    Verbosebox: TCheckBox;
    ErrLbl: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BoardGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure LoadBtnClick(Sender: TObject);
    procedure BoardGridKeyPress(Sender: TObject; var Key: Char);
    procedure CheckBtnClick(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
  Public
    path:string; {default path to cases}
    casefilename:string;
    PuzzleSize:integer;
    nbrcagerecs:integer;
    Cagerecs:array of TCagerec;
    modified,complete:boolean;
    keypresscount:integer;
    xoffset, yoffset:integer;
    usersolve:boolean;  {=true except for computer solve mode}
    function loadcase(filename:string):boolean;
    function fillcagerecs:integer;
    procedure ErrorCheck(showMsg:boolean);
    procedure makeCageOutline;
    procedure resetboard(size:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var opvals: set of char=['+', '-', 'x', '/', '='];


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
    {Next line overestimates width when DPI scaling factor is > 1}
    {repeat width:=width+1 until fixedcols+visiblecolcount=colcount; }
    width:=w+(colcount+1)*gridlinewidth+1;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;

{********** FormActivate ********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  reformatmemo(memo2);
  path:=extractfilepath(application.ExeName);
  OpenDialog1.InitialDir:=path;
  casefilename:='No puzzle loaded';
  If fileexists(path+'aarp1.txt')  then  Loadcase(path+'aarp1.txt');

end;

{************** BoardGridDrawCell ************}
procedure TForm1.BoardGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  s,ss:string;
  ch:char;

     procedure drawline(x1,y1,x2,y2:integer);
     {draw a border line}
     begin
       with boardgrid, canvas do
       begin
         if (x1=0) and (x2=0) then
         begin {left edge}
           moveto(2,y1);
           lineto(2,y2);
         end
         else if (x1=x2) and (x2>width-32) then
         begin {right edge}
           moveto(x1-1,y1);
           lineto(x2-1,y2);
         end
         else if (y1=0) and (y2=0) then
         begin  {type edge}
           moveto(x1,2);
           lineto(x2,2);
         end
         else if (y1=height) and (y2=height) then
         begin  {bottom edge}
           moveto(x1,height-2);
           lineto(x2,height-2);
         end;
         moveto(x1,y1);
         lineto(x2,y2);
       end;
     end;

begin
  with boardgrid, canvas do
  begin
    if gdselected in state then brush.Color:=clMoneyGreen else brush.color:=clwhite;
    with rect do
     fillrect(rect);
    pen.color:=clred;
    pen.Width:=2;
    s:=cells[acol,arow];
    with rect do
    begin
      if length(s)>1 then
      begin
        ss:=copy(s,7,length(s)-6)+s[6];
        font.Size:=9;
        textout(Left+2, Top+2, ss);
      end;
      if (length(s)>0) and (s[1]<>' ') then
      begin
        font.Size:=14;
        ch:=s[1];
        textout(left+xoffset, top+yoffset,ch);
      end;
      {draw borders}
      if s[2]='1' then drawline(left,top,right,top); {draw top border}
      if s[3]='1' then drawline(right,top,right,bottom); {draw right border}
      if s[4]='1' then drawline(left,bottom,right,bottom); {draw bottom border}
      if s[5]='1' then drawline(left,top,left,bottom); {draw left border}
    end;
  end;
end;


{*********** LoadBtnClick **********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  if opendialog1.execute
  then Loadcase(opendialog1.filename);
end;



{************ BoardGridKeyPress ************8}
procedure TForm1.BoardGridKeyPress(Sender: TObject; var Key: Char);
var
  s:string;
begin
  if  (key=' ') or ((key in ['1'..'9']) and (strtoint(key)<=puzzlesize)) then
  with boardgrid do
  begin
    errlbl.Visible:=false;
    s:=cells[col,row];
    if s[1]=' ' then inc(keypresscount)
    else if key=' ' then dec(keypresscount);  {count 1st time numbers entered for each cell}
    delete(s,1,1);
    cells[col,row]:=key+s;
    {If all numbers have been entered, start checking automatically after each entry}
    if keypresscount>=puzzlesize*puzzlesize then ErrorCheck(false);
  end;
end;



 {************ ResetBoard **********}
procedure TForm1.resetboard(size:integer);
{initialize the grid}
var
  c,r:integer;
begin
  Puzzlesize:=size;
  with boardgrid do
  begin
    rowcount:=puzzlesize;
    colcount:=puzzlesize;
    for r:= 0 to puzzlesize-1 do
    for c:=0 to puzzlesize-1 do
    cells[c,r]:=' ';
    adjustgridsize(boardgrid);
    keypresscount:=0;
    with Canvas do
    begin
      Font.Name:='Arial';
      font.size:=12;
      {calculate offsets to center the number text in cells}
      xoffset:=(defaultcolwidth-textwidth('8')) div 2;
      yoffset:=(defaultrowheight-textheight('8')) div 2;
    end;
  end;
  usersolve:=true;
end;

{************ Loadcase ***********}
function TForm1.loadcase(filename:string):boolean;
{Load a puzzle}
var
  f:textfile;
  line:string;
  n,c,r:integer;
  error:boolean;
  nbrcells, sumcells:integer;
begin
  if fileexists(filename) then
  begin
    result:=true;
    sumcells:=0;
    casefilename:=filename;
    label1.Caption:='Current puzzle: '+extractfilename(casefilename);
    assignfile(f,filename);
    reset(f);
    repeat
      readln(f,line);
    until (trim(line)<> '') and (line[1]<>'{');
    n:=strtointdef(line,0);
    if (n>=4) and (n<=9) then
    begin
      resetboard(n);
      nbrcagerecs:=0;
      setlength(cagerecs,10);
      error:=false;
      sumcells:=0;
      while (sumcells<puzzlesize*puzzlesize) and  (not eof(f)) do
      begin
        {get a cage definition line}
        repeat
          readln(f,line)
        until (length(line)>0)
        and (line[1]<>'{');
        stringreplace(line,' ','',[rfreplaceall]);
        stringreplace(line,')(','),(',[rfreplaceall]); {in case commas missing}

        n:=2;
        inc(nbrcagerecs);
        if nbrcagerecs>=length(cagerecs) then setlength(cagerecs,length(cagerecs)+10);
        with cagerecs[nbrcagerecs-1] do
        begin
          setlength(ccells,10);

          nbrcells:=0;
          while n<=length(line) do
          begin
            {Extract column and row}
            c:=strtointdef(line[n],0)-1;
            r:=strtointdef(line[n+2],0)-1;
            if (c=-1) or (r=-1) then
            begin
              showmessage('Error in line' +line);
              error:=true;
              break;
            end;
            with ccells[nbrcells] do
            begin
              x:=c;
              y:=r; {add the cell to the cage}
              border:='1111'; {default, draw full border of cell}
              v:=0;
            end;
            inc(nbrcells);
            if nbrcells>=length(ccells) then setlength(ccells,length(ccells)+10);
            inc(n,6);  {move to next cell}
          end;
          setlength(ccells,nbrcells);
          inc(sumcells,nbrcells);
          operator:=' ';

          {Now get the value and operator line}
          repeat
            readln(f,line)
          until (trim(line)<>'') and (line[1]<>'{');
          line:=trim(lowercase(line)); {in case the x for multiplication is input as X}
          n:=pos(' ',line);
          if n>0 then
          begin
            value:=strtointdef(copy(line,1,n-1),-1);  {Convert value}
            IF Line[length(line)] in opvals then {check for valid operator}
              operator:=line[length(line)];
          end;
          if (value<=0) or (operator=' ') then
          begin
            showmessage('Error 2 in line '+line);
            error:=true;
            break;
          end;
        end;
      end;
      if error then result:=false
      else  makecageoutline;
    end
    else showmessage('First data line must be the puzzle size 4 to 9, found '+line);
    setlength(cagerecs, nbrcagerecs);
    closefile(f);
    if sumcells<>puzzlesize*puzzlesize then  showmessage('Error, cages do not define all cells');
  end
  else result:=false;
  if result then errLbl.visible:=false;
end;

{************ MakecageOutline ***********}
 procedure TForm1.makecageOutline;
 var
   i,j,k:integer;

  begin  {no error, let's define the cage outline}
    for i:=0 to nbrcagerecs-1 do
    with cagerecs[i] do
    begin
      {Check each cell against the others in the cage}
      {border is a 4 character string of 0's and 1's, representing top,right,
       bottom and left border lines, 1 = draw it, 0 = no draw}
      for j:=0 to high(ccells)-1 do
      for k:= j+1 to high(ccells) do
      begin
        {check cell k to right of cell j}
        if (ccells[j].y=ccells[k].Y) and (ccells[j].x+1 = ccells[k].x) then
        begin
          ccells[j].border[2]:='0';
          ccells[k].border[4]:='0';
        end;
        {check cell k to below cell j}
        if (ccells[j].y+1=ccells[k].Y) and (ccells[j].x = ccells[k].x) then
        begin
          ccells[j].border[3]:='0';
          ccells[k].border[1]:='0';
        end;
        {check cell k to left of cell j}
        if (ccells[j].y=ccells[k].Y) and (ccells[j].x = ccells[k].x+1) then
        begin
          ccells[j].border[4]:='0';
          ccells[k].border[2]:='0';
        end;
      end;
      boardgrid.cells[ccells[0].x, ccells[0].y] := ' '+ccells[0].border+operator+inttostr(value);
      for j:=1 to high(ccells) do
      boardgrid.cells[ccells[j].x, ccells[j].y] := ' '+ccells[j].border
    end;
    boardgrid.setfocus;
    boardgrid.invalidate;
  end;

{************ FillCagerecs *********}
function TForm1.fillcagerecs:integer;
{Transfer values from grid to cagerecs}
{Returns count of cells defined in cages, should = # of cells in the puzzle}
var
  i,j:integer;
begin
  result:=0;  {count to make sure that all cells belong to a cage}
  with boardgrid do
  for i:=0 to high(cagerecs) do
  with cagerecs[i] do
  for j:=0 to high(ccells) do
  with ccells[j] do
  begin
    v:=strtointdef(cells[x,y][1],0);
    inc(result);
  end;
end;

{*********** CheckBtnClick ***********8}
procedure TForm1.CheckBtnClick(Sender: TObject);
begin
  Errorcheck(True);
end;


procedure TForm1.ErrorCheck(showmsg:boolean);
var
  i,j:integer;
  op:char;
  sum,product,v1,vcount,totvcount:integer;
  errflag:boolean;


    {----------- NoDups -----------}
    function NoDups:boolean;
    {check for duplicate values in aby row or column}
    var
      i,j,n:integer;
      existsc, existsr:array of boolean;
    begin
      setlength(existsc, puzzlesize+1); {flags for values in a column}
      setlength(existsr, puzzlesize+1); {flags fdor values in a row}
      result:=true;
      with boardgrid do
      begin

        for i:= 0 to puzzlesize-1 do {check columns and rows in one double loop}
        begin
          for j:=1 to puzzlesize do begin existsc[j]:=false; existsr[j]:=false; end;
          for j:=0 to puzzlesize-1 do
          begin
            n:=strtointdef(cells[i,j][1],0);

            if (n>0) and existsc[n] then {dup error in column}
            begin
              if showmsg then showmessage('Duplicate error in column '+inttostr(i+1));
              result:=false;
              break;
            end
            else existsc[n]:=true;
            n:=strtointdef(cells[j,i][1],0);
            if  (n>0) and existsr[n] then {dup error in row}
            begin
              if showmsg then  showmessage('Duplicate error in row '+inttostr(i+1));
              result:=false;
              break;
            end
            else existsr[n]:=true;
          end;
        end;
      end;
    end;



  procedure error(s:string);
  begin
    if showmsg then showmessage(s)
    else errlbl.visible :=true;
    errflag:=true;
  end;

begin
  errlbl.visible:=false;
  if nodups then  {no duplicate values in any row or column}
  begin
    errflag:=false;
    totvcount:=0; {count of # of value filled in (to recogonize solve state)}
    if fillcagerecs=puzzlesize*puzzlesize then
    begin  {all cells belong to a cage}
      for i:=0 to high(cagerecs) do
      with cagerecs[i] do
      begin
        op:=operator;
        vcount:=0;
        for j:=0 to high(ccells)  do {check cage size for operators}
        with ccells[j] do
        begin
          if v>0 then inc(totvCount);
          case op of
          '=':
            if length(ccells)>1 then
            begin
              error('= must be a single cell cage');
              break;
            end
            else
            if j=0 then
            begin
              if (v>0) and (v<>value) then
              begin
                error(format(
                  'Single value at (%d,%d) should be %d, not %d',[x+1,y+1,value, v]));
                break;
              end;
            end;
          '+':
            begin
              if j=0 then sum:=0;
              inc(sum,v);
              if j=high(ccells) then
              begin
                if vcount=j+1 then {all sums are filled in}
                begin
                  if sum<>value then error(format(
                   'Sum for cage at (%d,%d) is %d, shpould be %d',[ccells[0].x+1, ccells[0].y+1, sum,value]));
                end;
              end;
            end;
          '-':
            begin
              if (j=0) then v1:=v
              else
              begin
                if j<>high(ccells) then error(format(
                  'For cage at (%d,%d), - operation must include exactly two cells',[x,y]))
                else
                if (v1>0) and (v>0) then
                begin
                  if abs(v1-v)<>value then  error(format(
                  'For cage at (%d,%d), the positive difference must be %d, it is %d',[x,y,value, abs(v1-v)]));
                  break;
                end;
              end;
            end;
          '*':
            begin
              if v>0 then inc(vcount);
              if j=0 then product:=1;
              product:=product*v;
              if j=high(ccells) then
              begin
                if vcount=j+1 then {all sums are filled in}
                begin
                  if product<>value then error(format(
                   'Product for cage at (%d,%d) is %d, shpould be %d',[ccells[0].x+1, ccells[0].y+1, sum,value]));
                end;
              end;
            end;
          '/':
            begin
              if (j=0) then v1:=v
              else
              begin
                if j<>high(ccells) then error(format(
                  'For cage at (%d,%d), divide operation must include exactly two cells',[x,y]))
                else
                if (v1>0) and (v>0) then
                begin
                  if (v1 div v<>value) and (v div v1<>value) then  error(format(
                  'For cage at (%d,%d), the qutient of larger/smaller must be %d, it is ',
                        [x,y,value, max(v1,v) div min(v1,v)]));
                  break;
                end;
              end;
            end;
          end; {case}
        end;
        //if not errflag then inc(totvcount,length(ccells));
      end;  {i loop}
    end
    else error('Cells in cages not equal to total cells');
    if (usersolve) and (not errflag) and (totvcount>=puzzlesize*puzzlesize) then
      showmessage('You did it!  Congratulations!');
  end
  else errLbl.visible:=true;;
end;




type
  TBoardArray=array of array of byte;


procedure TForm1.SolveBtnClick(Sender: TObject);

  {--------- IsValidCandidate -----------}
  function IsvalidCandidateSet(Cage:TCagerec; k:integer):boolean;
  {check candidate K to make sure that is does not contain duplicate values
   in the same row or column}
  var
    i,j:integer;
  begin
    with cage do
    begin
      result:=true;
      for i:=0 to high(ccells)-1 do
      begin
        for j:=i+1 to high(ccells) do
        if (ccells[i].Candidates[k]=ccells[j].Candidates[k])
        and ( (ccells[i].x=CCells[j].x) or (ccells[i].y=CCells[j].y) )
        then
        begin
          result:=false;
          break;
        end;
        if not result then break;
      end;
    end;
  end;


  {------------- CageHasCorner ----------}
  function CageHasCorner(cage:TCagerec):boolean;
  {used for testing whether cage can contain duplicate values (if it has a
   corner, it can)}
  var
    i,j:integer;
  begin
    with cage do
    begin
      result:=false;
      for i:=0 to high(ccells)-1 do
      begin
        for j:=i+1 to high(ccells) do
        begin
          {cage has a corner if there two cells where neither row nor column are equal}
          if  (ccells[i].x<>ccells[j].x) and (ccells[i].y<>ccells[j].y)
          then
          begin
            result:=true;
            break;
          end;
        end;
        if result then break;
      end;
    end;
  end;

  {----------- CheckNext ------------}
  function checknext(var b:TBoardArray; nextcage,nextcandidate:integer):boolean;
  {Recursive depth first search for a solution}
  var
    i,k,m:Integer;

       {optional displays of intermediate search results}
       procedure debug(msg:string; showboard:boolean);
       {display used at checknext entry, show board values also}
       var
         i,j:integer;
         s:string;
       begin
         if verbosebox.checked then
         begin
           memo2.lines.add(format('%s Cage #: %d, Candidate #: %d',
                            [msg,nextcage,nextcandidate]));
           s:='Candidate: ';
           with cagerecs[nextcage] do
           for i:= 0 to high(ccells) do
           with ccells[i] do s:=s+' '+inttostr(candidates[nextcandidate]);
           memo2.lines.add(s);
           if showboard then
           begin
             memo2.lines.add('Board at entry time');
             for i:=0 to puzzlesize-1 do
             begin
               s:='';
               for j:=0 to puzzlesize-1 do s:=s+inttostr(b[j,i]);
               Memo2.lines.add(s);
             end;
           end;
         end;
       end;


  begin
    errlbl.visible:=false;
    result:=true;
    if nextcage>high(cagerecs)
    then exit;
    debug('Entered: ',true);
    with cagerecs[nextcage]  do
    begin
      if nextcandidate>high(ccells[0].candidates) then
      begin
        result:=checknext(b,nextcage+1, 0);
      end
      else
      begin
        for i:= 0 to high(ccells) do
        with ccells[i] do b[x,y]:=candidates[nextcandidate];
        {check that there are no duplicates in cage rows or columns}
        for i:=0 to high(ccells) do
        begin
          //for j:=0 to puzzlesize-1 do
          with ccells[i] do
          begin
            for k:=0 to puzzlesize-2 do
            begin
              for m:=k+1 to puzzlesize-1 do
              if ((b[x,k]>0) and (b[x,k]=b[x,m]) )
               or((b[k,y]>0) and (b[k,y]=b[m,y]) ) then
              begin
                result:=false;
                break;
              end;
              if not result then break;
            end;
            if not result then break;
          end;
          if not result then break;
        end;
        if not result then
        begin
          {undo moves for this candidate}
          for i:= 0 to high(ccells) do
          with ccells[i] do b[x,y]:=0;
          {and try the next candidate}
          debug('Dups, undo', false);
          if nextcandidate<high(ccells[0].candidates) then
          result:=checknext(b,nextcage,nextcandidate+1);
        end
        else
        begin
          debug('Fit OK for',false);
          result:=checknext(b,nextcage+1,0);
          if not result then
          begin
            {undo moves for this candidate}
            for i:= 0 to high(ccells) do
            with ccells[i] do b[x,y]:=0;
            debug('Next cage failed, try another candidate ',false);
            if nextcandidate<high(ccells[0].candidates) then
              result:=checknext(b,nextcage,nextcandidate+1);
             //else exit; {no more candidates, backtrack} ;
          end;
        end
      end;
    end;
  end;
var
  i,j,k:integer;
  sum,product:integer;
  hascorner,solved:boolean;
  r,n:integer;
  s1,s2:integer;
  count:integer;
  s:string;
  b:tBoardArray;
  key:char;
begin
  errlbl.Visible:=false;
  usersolve:=false;
  {reset any grid values apready filled in}
  for i:=0 to high(cagerecs) do with cagerecs[i] do
  for j:=0 to high(ccells) do
  with ccells[j] do
  begin
    s:=boardgrid.cells[x,y];
    delete(s,1,1);
    boardgrid.cells[x,y]:=' '+s;
  end;
  screen.Cursor:=crhourglass;

  for i:=0 to high(cagerecs) do
  with cagerecs[i], combos do
  begin
    count:=0;
    case operator of
    '=':
      with ccells[0] do
      begin
        setlength(candidates,1);
        candidates[0]:=value;
        count:=1;
      end;
    '+':
      with combos do
      begin
        r:=length(ccells);
        n:=puzzlesize;
        hascorner:=cagehascorner(cagerecs[i]);
        if not hascorner then setup(r,n,permutations)
        {cages with a corner may contain duplicate values}
        else setup(r,n,permutationsWithRep);
        k:=getcount;
        {set candidates lengths to max that we can find}
        for j:=0 to high(ccells) do with ccells[j] do setlength(candidates,k);
        while getnext do
        begin
          sum:=0;
          for j:=1 to r do sum:=sum+selected[j];
          if sum=value then
          begin
            for k:=0 to high(ccells) do
            with ccells[k] do candidates[count]:=selected[k+1];
            if (not hascorner) or
            (hascorner and isvalidcandidateSet(cagerecs[i],count))
            then inc(count); {no need to erase values, just don't count it}
          end;
        end;
      end;
    '-':
      begin
        if length(ccells)<>2 then showmessage('Minus operator with more than two cells?')
        else
        begin
          setup(2,puzzlesize,permutations);
          k:=getcount;
          setlength(ccells[0].candidates,k);
          setlength(ccells[1].candidates,k);
          while getnextpermute do
          if abs(selected[1]-selected[2])=value then
          begin
            ccells[0].candidates[count]:=selected[1];
            ccells[1].Candidates[count]:=selected[2];
            inc(count);
          end;
        end;
      end;
     'x':
     with combos do
      begin
        r:=length(ccells);
        n:=puzzlesize;
        hascorner:=cagehascorner(cagerecs[i]);
        if not hascorner then setup(r,n,permutations)
        {cages with a corner may contain duplicate values}
        else setup(r,n,permutationsWithRep);
        k:=getcount;
        {set candidates lengths to max that we can find}
        for j:=0 to high(ccells) do with ccells[j] do setlength(candidates,k);
        while getnext do
        begin
          product:=1;
          for j:=1 to r do product:=product*selected[j];
          if product=value then
          begin
            for k:=0 to high(ccells) do
            with ccells[k] do candidates[count]:=selected[k+1];
            if (not hascorner) or
            (hascorner and isvalidcandidateSet(cagerecs[i], count ) )
            then inc(count); {no need to erase values, just don't count it}
          end;
        end;
      end;
    '/':
      begin
        if length(ccells)<>2 then showmessage('Divide operator with more than two cells?')
        else
        begin
          combos.setup(2,puzzlesize,permutations);
          k:=getcount;
          setlength(ccells[0].candidates,k);
          setlength(ccells[1].candidates,k);
          while getnextpermute do
          begin
            s1:=max(selected[1], selected[2]);
            s2:=min(selected[1], selected[2]);
            if ((s1 div s2)*s2=s1) {it divides}
            and ((s1 div s2) =value) then
            begin
              ccells[0].candidates[count]:=selected[1];
              ccells[1].Candidates[count]:=selected[2];
              inc(count);
            end;
          end;
        end;
      end;
    end;
    for k:=0 to high(ccells) do setlength(ccells[k].candidates,count);
  end;  {cagerecs loop}
  {display candidates for debugging}

  if verbosebox.checked then
  begin
    memo2.clear;
    with memo2 do
    for i:=0 to high(cagerecs) do
    with cagerecs[i] do
    begin
      lines.add(format('Cage at (%d,%d) operation %s, Target %d',[ccells[0].x, ccells[0].y,
                   operator, value]));
      lines.add('Candidates:');
      for j:=0 to high(ccells[0].candidates) do
      begin
        s:='';
        for k:=0 to high(ccells) do s:=s+inttostr(ccells[k].candidates[j])+',';
        delete(s,length(s),1);
        lines.add(s);
      end;
    end;
  end;

  setlength(b,puzzlesize,puzzlesize);
  solved:=checknext(b,0,0);
  screen.cursor:=crdefault;
  if solved then
  begin
    memo2.lines.add('Solved');
    usersolve:=false;
    for i:=0 to high(cagerecs) do
    with cagerecs[i] do
    begin
      for j:=0 to high(ccells) do
      with ccells[j] do
      begin
        with boardgrid do
        begin
          col:=x;
          row:=y;
          key:=inttostr(b[x,y])[1];
          boardGridkeypress(boardgrid,key);
          boardgrid.Update;
          sleep(100);
        end;
      end;
      sleep(400);
    end;
  end
  else memo2.lines.add('Not solved, check puzzle definition');
  usersolve:=true;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
