Unit U_MindYourABCDs;
{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{Place one of A, B, C, D into each of the 25 empty cells so that
the number of letters in each row and column areas is as
indicated by the numbers.  Identical letters cannot be next to
each other in the grid either horizontally or vertically.     }
{
This puzzle is based on the August 11, 2016 daily Mensa Calendar
Puzzle and aids solving by automatically updating the available letter
counts as letters are entered.  To play, enter one letter per cell.
Change a letter by typing over it which update counts apprptiately.
Remove a letter by selectinh it an using the "Del" key or entering a
space character. The puzzle is solved when all count cells are zero.

Hint: The "no duplicate adjacent cells" rule,requires a fixed
placement for any row or column with a count value 3 for that letter.

The "Solve" button displays moves made at a rate selected by the
user. The "Debug" radio button shows all placements attempted as well
as the successful placements.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids, UComboV2, dffutils, inifiles
  ;

type
  TPathObj = class(TObject)
    acol,aRow:integer;
  end;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    SolveBtn: TButton;
    Memo2: TMemo;
    DebugBox: TCheckBox;
    CrNbrGrp: TRadioGroup;
    SpeedGrp: TRadioGroup;
    ListBox1: TListBox;
    Label1: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure InitBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure UndoBtnClick(Sender: TObject);
    procedure DebugBoxClick(Sender: TObject);
    procedure CrNbrGrpClick(Sender: TObject);
    procedure SpeedGrpClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  public
    dir:string;
    casename:string;
    init:boolean;
    size:integer;
    cut:integer;
    PathList, Trylist:TStringList;
    debug:Boolean;
    solving: boolean; {true while program is searching for solution, false otherwise}
    CRNbr:integer; {Column/Row start number (0 or 1)}
    sleepMs:integer;
    savedspeed:integer; {saved in order to restore delay time after pause}
    procedure updatecounts(acol,arow,amt:integer; ch:char);
    procedure AddPathObj(pathkeyin:string; c,r:integer);
    procedure debugmessage(s:string);
    function postkey(keyIn:char):boolean;
    procedure Loadcase(CName:string);
    procedure Savecase(CName:string); 
  end;
var
  Form1: TForm1;

implementation

{$R *.DFM}



//const
var
  defSizeX:Integer=5;
  defsizeY:integer=5;
  defletters:integer=4;


var

  (*
  Topstr:string='12012112122212010211';
  TopDef:array[0..defletters-1{rows},0..defsizex-1] {columns} of integer =
                                       ((1,2,0,1,2),
                                        (1,1,2,1,2),
                                        (2,2,1,2,0),
                                        (1,0,2,1,1));
  LeftStr:string='10220311221011122120'
  LeftDef:array[0..defsizey-1{rows},0..defletters-1 {columns}] of integer =
                                       ((1,0,2,2),
                                        (0,3,1,1),
                                        (2,2,1,0),
                                        (1,1,1,2),
                                        (2,1,2,0));
  *)

  Topstr:string='20210021212112212102';
  TopDef:array of array of integer;
  (*
  CasenameLstring:='Default'(*
  TopDef:array of array of integer {[0..defletters-1{rows},0..defsizex-1] {columns} of integer =
                                       ((2,0,2,1,0),
                                        (0,2,1,2,1),
                                        (2,1,1,2,2),
                                        (1,2,1,0,2));
  *)
  LeftStr:string='01222021120202212120';
  LeftDef: array of array of integer;
  (*
  LeftDef:array[0..defsizey-1{rows},0..defletters-1 {columns}] of integer =
                                       ((0,1,2,2),
                                        (2,0,2,1),
                                        (1,2,0,2),
                                        (0,2,2,1),
                                        (2,1,2,0));

   *)

{*********** FormActivate **************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  PathList:=TStringlist.create;
  dir:=extractfilepath(application.exename);
  initbtnclick(sender);
  casename:='Puzzle 1';
  listbox1.itemindex:=0;
  listbox1click(sender);
  trylist:=Tstringlist.Create;
  with trylist do
  begin
    Duplicates:=DupIgnore;
    sorted:=true;
  end;
  solving:=false;
  CRNbrGrpClick(sender);
  SpeedGrpClick(sender);
  with stringgrid1 do Canvas.font.Assign(font);
end;

{*************InitBtnClick ***********}
procedure TForm1.InitBtnClick(Sender: TObject);
var
  acol,arow:integer;
begin

  size:=stringgrid1.rowcount;
  canvas.font.assign(stringgrid1.font);
  cut:=size div 2 -1;
  adjustgridsize(stringgrid1);
  stringgrid1.Invalidate;

  with stringgrid1, canvas do
  begin
    pen.color:= clblack;
    for acol:=0 to cut-1 do cells[acol,cut]:=char(ord('A')+acol);
    for arow:=0 to cut do cells[cut,arow]:=char(ord('A')+arow);

    for acol:=cut+1 to colcount-1 do
    for arow:=cut+1 to rowcount-1 do
    cells[acol,arow]:=' ';
  end;
  memo2.clear;
  solvebtn.caption:='Solve it for me';
end;


{****** SringGrid1DrawCell *************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with stringgrid1, canvas do
  begin
    if gdfocused in state then brush.Color:= clskyblue else brush.color:=color;
    if (acol<=cut) and (arow<=cut) then
    begin   {top left quad}
      pen.color:=color;
      rectangle(rect);
      pen.color:=clblack;

      if (acol=cut)and (arow<=cut)then
      begin {Vert letter labels}
        pen.width:=3;
        canvas.pen.color:=clBlack;
        canvas.font.color:=clblack;
        moveto(rect.Right, rect.Top);
        lineto(rect.right, rect.bottom);
        pen.width:=1;
        textout(rect.left+6, rect.top+4, cells[acol,arow]);
      end
      else if (acol<=cut)and (arow=cut)then
      begin  {horizontal letter lables}
        pen.width:=3;
        canvas.pen.color:=clBlack;
        canvas.font.color:=clblack;
        moveto(rect.Left, rect.bottom);
        lineto(rect.right, rect.bottom);
        pen.width:=1;
        textout(rect.left+6 , rect.top+4, cells[acol,arow]);
      end ;

    end
    else
    if (acol>cut) and (arow>cut) then
    begin
        canvas.pen.color:=clblack;
        canvas.pen.width:=3;
        canvas.Font.Color:=clred;
        textout(rect.left+6 , rect.top+4, cells[acol,arow]);
      end;



    if (acol>cut) or (arow>cut) then
    begin
      canvas.font.assign(font);
      canvas.pen.color:=clgray;
      //pen.width:=;
      with rect do
      begin
        rectangle(cellrect(acol,arow));
        textout(left+6 , top+2, cells[acol,arow]);
      end;
    end;
  end;
end;


{************ LoadDefBtnClick ***********}
procedure TForm1.LoadCase(Cname:string);
var
  acol,arow, r,c:integer;
  ini:TInifile;
begin
  Casename:=cname;
  ini:=TInifile.Create(dir+'MindABCDs.ini');
  with ini do
  begin
    defsizex:=readinteger(Casename,'DefSizeX', 5);
    defsizeY:=readinteger(Casename,'DefSizeY', 5);
    defLetters:=readinteger(Casename,'DefLetters',4);
    setlength(TopDef,defletters,defsizex);
    TopStr:=ReadString(Casename,'TopStr','12012112122212010211');  {puzzle 1}
    //TopStr:=ReadString(Casename,'TopStr','20210021212112212102'); {puzzle 2}
    for r:=0 to defletters -1 do for c:=0 to defsizex-1 do
    topdef[r,c]:=strtoint(topstr[r*defsizex+c+1]);

    Setlength(LeftDef,Defsizey,Defletters);
    LeftStr:=ReadString(Casename,'LeftStr','10220311221011122120'); {puzzle 1}
    //LeftStr:=ReadString(Casename,'LeftStr','01222021120202212120'); {puzzle 2}
    for r:=0 to defsizex -1 do for c:=0 to defletters-1 do
    leftdef[r,c]:=strtoint(leftstr[r*defletters+c+1]);
  end;
  ini.Free;
  //savecase(casename);   {One time only to save initials puzzles to ini file}
  with stringgrid1 do
  begin {initilize the grid}
    colcount:=defsizex+defletters;
    rowcount:=defsizey+defletters;
    initbtnclick(self);
    for arow:=0 to cut do
    for acol:=cut+1 to colcount-1 do cells[acol,arow]:=inttostr(TopDef[arow,acol-cut-1]);
    for arow:=cut+1 to rowcount-1 do
    for acol:=0 to cut do cells[acol,arow]:=inttostr(LeftDef[arow-cut-1,acol]);
    for arow:=cut+1 to rowcount-1 do for acol:=cut+1 to colcount-1
      do cells[acol,arow]:=' ';
  end;
end;

{************** SaveCase ************}
procedure TForm1.SaveCase(cName:string);
var
  ini:TInifile;
begin
  ini:=TInifile.Create(dir+'MindABCDs.ini');
  with ini do
  begin
    writestring(cName, 'TopStr',Topstr);
    writestring(cname,'LeftStr',leftstr);
  end;ini.Free;
end;


{************** PostKey *************}
function TForm1.postkey(keyIn:char):boolean;
{Simulate a keypress without restoring the previous move}
var
  key:char;
begin
  key:=upcase(keyIn);
  //stringGrid1KeyPress(Self,key);
  result:=key in ['A','B','C','D',' '];
  If result then
  with stringgrid1 do
  begin  {update available letter counts}
    cells[col,row]:=key;
    updatecounts(col,row,-1,key);
    addpathobj(key,col,row);
    update;
  end;

end;

{*************** SolveBtnClick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  c,r:integer;
  letter:char;
  combos:array of TComboset;

  {************** FillNext *********************}
  function FillNext(acol:integer):boolean;
  {Recursive routine to perform exhaustive, recursive search column by column}
  {apply permuted possible letters in the column in next valid position,
   retract on error}
  var
    c,r,n,i,k:integer;
    nbr,added,index,loc,sum:integer;
    indices:array of integer;
    s,permutedLetters:string;
    OK:boolean;
    w:char;
    reason:string;
    pathobj:TPathObj;

  begin {Fillnext}
    result:=false;

    application.ProcessMessages;
    with stringgrid1 do
    begin
      c:=acol+cut+1;

      {Build an array of the rows where the letters specified by counts are to be placed}
      setlength(indices,size-cut-1);
      s:='';
      trylist.clear;
      {The number of letters already filled in + the sum of the remaining counts
         for this column must = the number of letters to be fill (size - cut -1)}
      {Check that above condition is met and then just fill indices array with the
       row number of the blank cells}
      sum:=0;
      index:=0;
      for r:=0 to rowcount-1 do
      if r<=cut then
      begin
        n:=strtoint(cells[c,r]);
        sum:=sum+n;
        for i:=0 to n-1 do s:=s+char(ord('A')+r);
      end
      else
      begin
        if cells[c,r]=' ' then
        begin
          indices[index]:=r;  {The next row where a letter can be inserted}
          inc(index);
        end
      end;
      setlength(indices,index);
      {if all is OK, the sum and index will be equal}
      if index<>sum then
      begin  {build error message}
        s:='';
        for r:=0 to rowcount-1 do s:=s+cells[c,r];
        showmessage(format('Program error-Inconsistency in column %d (%s)',[c+CRNbr,s]));
        exit;
      end;

      with combos[acol] do
      begin {now permute them and fill in a trial arrangement}
        nbr:=length(s);
        setup(nbr,nbr,permutations);
        while getnext do
        begin
          //application.processmessages;
          if form1.tag<>0 then exit;
          OK:=true;
          added:=0;
          permutedletters:='';
          for K:=1 to nbr do
          begin
            permutedletters:=permutedLetters+s[selected[k]];
          end;

          {We have a permuted set with no adjecent duplicates}
          if  OK then
          begin
            {skip it if it is a duplicate of a permutation aready tried}
            {Ths will happen for letter set that has 2 or more occurrences of a letter value}
            if trylist.find(permutedletters,index) then
            begin
               OK:=false;
               reason:=' already checked' {duplicate permutation'};
            end
            else trylist.add(permutedletters);
          end;

          if OK then
          for k:=1 to nbr do  {for each letter in current permute}
          begin {check that it this letter is not the same as the letter above or below}
            w:=permutedletters[k]{s[selected[k]]};  {the next letter to place in location indices[k]}
            loc:=indices[k-1];
            if  OK then
            begin
              if ((loc>cut+1) and (cells[c,loc-1][1]=w)) or
                 ((loc<rowcount-1) and (cells[c,loc+1][1]=w)) or
                  ((acol>0) and (cells[c-1,loc][1]=w)) or
                  ((c<size-1) and (cells[c+1,loc][1]=w))
              then
              begin
                OK:=false;
                reason:='adjacent dup for this cell';
              end;
            end;
            if OK and  {check that the "count by column" field has at least one of this letter to place}
               (strtoint(cells[ord(w)-ord('A'),loc])  <=0) then
            begin
              ok:=false;
              reason:='column count = 0';
            end;
            if (not OK) then
            begin
              if added>0 then
              for i:=added downto 1 do  //undo btnclick(self)
              {no need to worry about storing the previous path entry}
              with pathlist do
              begin
                pathobj:=TPathobj(objects[count-1]);
                with pathobj do
                begin
                  updatecounts(acol,arow,+1,pathlist[count-1][1]);
                  stringgrid1.cells[acol,arow]:=' ';
                  if debug then debugmessage(format('Removed "%s" (%d,%d) from path',
                                              [pathlist[count-1],acol+CRNbr,arow+CRNbr]));
                  TPathobj(objects[count-1]).free;
                  pathlist.delete(count-1);
                end;
                update;
              end;
              added:=0;
              if debug then debugmessage(format('Permutation %s not OK in column %d',
                                  [permutedletters,  acol+CRNbr]));
              break;
            end
            else  {add this letter to the move list}
            with stringgrid1 do
            begin
              col:=c;
              row:=loc;
              if postkey(w)
              then inc(added);
              stringgrid1.Update;
            end;
          end;
          if OK then
          begin
            debugmessage(format('Letters %s placed OK in column %d',[permutedletters,acol+CRNbr]));
            //application.processmessages;
            if acol<size-cut-2 then
            begin   {more columns to fill}
              {*********************** Recusion occurs here! *************}
              result:=fillnext(acol+1);
              if form1.tag<>0 then exit;
              if not result then
              begin  {this column doesn't work, go on to the next permutation}
                if added>0 then
                for i:=added downto 1 do  //undobtnclick(self)
                {no need to worry about storing the previous path entry}
                with pathlist do
                begin
                  pathobj:=TPathobj(objects[count-1]);
                  with pathobj do
                  begin
                    updatecounts(acol,arow,+1,pathlist[count-1][1]);
                    stringgrid1.cells[acol,arow]:=' ';
                    TPathobj(pathlist.objects[count-1]).free;
                    pathlist.delete(count-1);
                  end;
                end;
              end;
            end
            else
            begin
              with stringgrid1 do
              begin
                col:=0;row:=0;
                w:='.';
                stringGrid1KeyPress(self, w);
              end;
              r:=messagedlg('Solution found!!!' +#13
                +'Continue searching?', mtconfirmation, [mbyes,mbno],0);
              if r=mrno then
              begin
                result:=true;
                form1.tag:=2;
                exit;
              end;
            end;
          end
          else if debug then debugmessage(format('Letter arrangement %s in column %d skipped - %s',
                                       [permutedletters,acol+CRNbr, reason]));;

        end; {combos loop}
      end;
    end;
  end; {FillNext}

begin  {SolveBtnClick}
  if solving then
  begin
    form1.tag:=1;
    solving:=false;
    SolveBtn.caption:='Solve it for me';
    screen.cursor:=crDefault;
    //application.processmessages;
    exit;
  end;

  {validate that it is a valid grid}
  {Build Candidate Objects for each Column}
  loadcase(casename);  {Refrsh the grid display} 
  solving:=true;
  Solvebtn.Caption:='Stop';
  SpeedGrp.itemindex:=1;
  SpeedgrpClick(sender);
  form1.tag:=0;
  screen.cursor:=crHourGlass;
  {Check for forced placements:
   3 letters in a row or column of 5 must be in 1, 3, and 5
             because  of the "no adjacents" rule}
  with stringgrid1 do
  begin
    setlength(combos,colcount);
    for c:= 0 to colcount-1 do combos[c]:=TComboset.create;
    for c:=cut+1 to colcount-1 do for r:=0 to cut do
    if strtoint(cells[c,r])=3 then
    begin
      letter:=cells[cut,r][1];
      col:=c;
      row:=cut+1; StringGrid1keypress(sender, letter);
      row:=cut+3; StringGrid1keypress(sender, letter);
      row:=cut+5; StringGrid1keypress(sender, letter);
      {If Column before or after a 3 letter column has 2 of that letter, it
              must have them in rows 2 and 4.  }
      If (c>cut+1) and (strtoint(cells[c-1,r])=2) then
      begin
        col:=c-1;
        row:=cut+2; StringGrid1keypress(sender, letter);
        row:=cut+4; StringGrid1keypress(sender, letter);
      end;
      If (c<colcount-1 ) and (strtoint(cells[c+1,r])=2) then
      begin
        col:=c+1;
        row:=cut+2; StringGrid1keypress(sender, letter);
        row:=cut+4; StringGrid1keypress(sender, letter);
      end;
      debugmessage('Letters forced by 3 duplicates in a column');
    end;

    for r:=cut+1 to rowcount-1 do for c:=0 to cut do
    if strtoint(cells[c,r])=3 then
    begin
      letter:=cells[c,cut][1];
      row:=r;
      col:=cut+1; StringGrid1keypress(sender, letter);
      col:=cut+3; StringGrid1keypress(sender, letter);
      col:=cut+5; StringGrid1keypress(sender, letter);
      {If Row above or below a 3 letter row has 2 of that letter, it
              must have them in columns 2 and 4.  }
      If (r>cut+1) and (strtoint(cells[c,r-1])=2) then
      begin
        row:=r-1;
        col:=cut+2; StringGrid1keypress(sender, letter);
        col:=cut+4; StringGrid1keypress(sender, letter);
      end;

      If (r<rowcount-1 ) and (strtoint(cells[c,r+1])=2) then
      begin
        row:=r+1;
        col:=cut+2; StringGrid1keypress(sender, letter);
        col:=cut+4; StringGrid1keypress(sender, letter);
      end;
      debugmessage('Letters forced by 3 duplicates in a row');
    end;
    FillNext(0);  {Starting column and letter}
   end;

   screen.Cursor:=crdefault;
   solving:=false;
   solvebtn.caption:='Solve it for me';
   showmessage('No more solutions');
end;

{*************** UpdateCounts ****************}
procedure TForm1.updatecounts(acol,arow, amt:integer; ch:char);
{reduce (or increase) the letter counts in column "acol" and
row"arow" and  position of letter "ch" by amount "amt". }
var
  index:integer;
  s:string;
  n:integer;
begin
  if debug then debugmessage(format('Update count (%d,%d) for char %s by %d',
                                     [acol+CRNbr, arow+CRNbr, ch, amt]));
  index:=ord(ch)-ord('A');
  with stringgrid1 do
  begin
     s:=cells[index,arow];
     n:=strtointdef(s,999);
    if n=999 then
    begin
      showmessage(format('Error - cell (%d,%d) not a valid number',
                                      [index+CRNbr,arow+CRNbr]));
      exit;
    end;

    cells[index, arow]:=inttostr(n+amt);
    s:=cells[acol,index];
    n:=strtointdef(s,999);
    if n=999 then
    begin
      showmessage(format('Error - cell (%d,%d) not a valid number',
                                     [acol+CRNbr,index+CRNbr]));
      exit;
    end;
    cells[acol,index]:=inttostr(n+amt);
    application.processmessages;
  end;

end;



{************* AddPathObj **********}
procedure TForm1.addpathobj(pathkeyin:string;c,r:integer);
{Add a move entry to the path list.  {PathkeyIn has current and previous
 letters in a 2 character string}
var PathObj:TPathObj;
begin
  pathobj:=TPathObj.create;
  with pathobj do
  begin
    acol:=c;
    arow:=r;
  end;
  Pathlist.addobject(pathkeyin,pathobj);
  if debug then debugmessage(format('Added "%s" (%d,%d) to path',
                                    [pathkeyin[1],c,r]));
end;


{************* StringGrid1KeyPress ***********}
procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
var
  previous:char;
  c,r:integer;
  OK:boolean;
begin
  if not solving then
  begin
    speedgrp.itemindex:=0;
    speedgrpclick(sender);
  end;
  key:=upcase(key);
  if key in ['A'..'D',' '] then
  with stringgrid1 do
  begin
    previous:=cells[col,row][1];
    if solving and (key=previous) then
    begin
      key:=#0 {'X'};  {No action reqired}
      exit;
    end
    else cells[col,row]:=' ';  {User entered 2nd letter in a cell] }
    if debug then debugmessage(format('Valid Key %s pressed at (%d,%d)',
                                [key, col+CRNbr,row+CRNbr]));
    if previous in ['A'..'D'] {and (countsbox.Checked or solving)}
    then
    begin
      updatecounts(col,row,+1,previous);
      if debug then debugmessage(format('Remove %s from (%d,%d)',[previous,col+CRNbr,row+CRNbr]));
    end;
    {we just added letter "key" to the grid, so reduce its avaiable count}
    If (key in ['A'..'D']) {and (countsbox.Checked or solving)} then
    begin
      updatecounts(col,row,-1,key);
      addpathobj(key,col,row);
      cells[col,row]:=key;
      update;
    end;
  end
  else if (key='.') or(key='X') then key:=' ';
  if not (key in ['A'..'D',' '])
  then key:=#0;
  {check for solution (i.e. all count fields = '0')}
  OK:=true;
  for c:=0 to cut do for r:=0 to cut do
  if (stringgrid1.cells[c,r+cut+1]<>'0')
  or (stringgrid1.cells[c+cut+1,r]<>'0') then
  begin
    OK:=false;
    break;
  end;
  if OK and (not solving) then showmessage('You did it!' +#13+ 'Congratulations!!');
end;

{************ StringGrid1KeyDown ***************}
procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Treat Delete key as space character}
begin
  if (key=VK_Delete) then key:=ord(' ');
end;

{*********** UndoBtnClick *************}
procedure TForm1.UndoBtnClick(Sender: TObject);
{Undo the last letter entered, put the previous letter back and update counts}
var
  letterToRemove, letterToAdd:char;
  c,r:integer;
begin
  with pathlist do
  begin
    letterToRemove:=strings[count-1][1];
    lettertoadd:=strings[count-1][2];
    with TPathobj(objects[count-1]) do
    begin;
      c:=acol;
      r:=arow;
    end;
    updatecounts(c,r,+1,lettertoremove);
    stringgrid1.cells[c,r]:=lettertoadd;
    //stringgrid1.Update;

    if debug then debugmessage(format('Removing move #%d ("%s")at (%d,%d) from '
        +'pathlist, restore "%s"',
        [pathlist.count,lettertoremove,c+CRNbr,r+CRNbr,lettertoadd]));
    objects[count-1].Free;
    pathlist.Delete(count-1);
  end;
end;

{************ DebugBoxClick ***************}
procedure TForm1.DebugBoxClick(Sender: TObject);
begin
  debug:=debugBox.checked;
end;

procedure Tform1.debugmessage(s:string);
{Display a message and sleep a while based SleepMS value}
begin
  memo2.lines.Add(s);
  //stringgrid1.update;
  sleep(sleepms);
end;


{**************** CRNbrGrpClicl *************}
procedure TForm1.CrNbrGrpClick(Sender: TObject);
{message grid locations are displayed as actual (CRNbr=0)
or with low index of 1 (CRNbr=+1).  This routine sets the user's choice}
begin
  CRNbr:= CRNbrGrp.itemIndex;
end;

{********* SpeedGrpClick ************}
procedure TForm1.SpeedGrpClick(Sender: TObject);
begin
  with speedgrp do
  begin
    Case speedgrp.itemindex of
      0:sleepms:=100;
      1:sleepms:=250;
      2:sleepms:=500;
      3:sleepms:=1000;
      4:sleepms:=2000;
      5:begin
         showmessage('Continue');
         speedgrp.ItemIndex:=savedSpeed;
        end;
    end;
    if speedgrp.itemindex<>5 then savedSpeed:=itemindex;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
procedure TForm1.ListBox1Click(Sender: TObject);
var
  s:string;
  n:integer;
begin
  with listbox1 do s:=Items[itemindex];
  n:=pos(':',s);
  if n>0 then
  begin
    //casename:=s;
    loadcase(s);
  end
  else showmessage('Puzzle name must preceed a ":" character');
end;

end.
