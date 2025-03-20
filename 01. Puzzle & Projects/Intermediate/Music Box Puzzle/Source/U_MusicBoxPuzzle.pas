unit U_MusicBoxPuzzle;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Grids, UIntList;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    ResetBtn: TButton;
    Memo1: TMemo;
    Grid: TStringGrid;
    HintGrp: TRadioGroup;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure GridKeyPress(Sender: TObject; var Key: Char);
    procedure HintGrpClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure GridDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  public
    {Valids contains a array of strings of allowable letters remaining for
     each of the 25 cells.  }
    valids:array[0..24] of string;

    {Called whenever the user attempts to change the contents of a cell to check
     the letter entered is in the "Valids" string for that cell}
    function addchar(acol,arow:integer; letter:char):boolean;

    {ReDoValidletters scans column, row and diagonals of cell[acol,arow]
     whenever the cell changes in order to update the string of valid characters
     valid for those cells. It calls UpdateValids to do the actual updating}
    procedure ReDoValidLetters(acol,arow:integer; letter,addsub:char);

    {UpdateValids  updates the string of valid characters for cell[acol,arow].
     It is called by ReDoValidLetters}
    procedure UpdateValids(acol,arow:integer; letter,addsub:char);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** FormCreate ****************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  with grid do canvas.font.name:=font.name;
  resetbtnclick(sender); {Initialize the grid}
end;

procedure TForm1.FormActivate(Sender: TObject);
begin  {make the grid ready to accept a letter keypress}
  Grid.SetFocus;
end;

{*********** GridKeyPress *************}
procedure TForm1.GridKeyPress(Sender: TObject; var Key: Char);
{If the user pressed one of the legal letters, pass it to  the "addchar" function}
begin
  with Grid do
  If upcase(key)  in ['M','U','S','I','C']
  then
  begin
     key:=upcase(key);
     addchar(col,row,key);
  end
  else key:=#0;
end;

{**************** GridMouseMove **************88}
procedure TForm1.GridMouseMove(Sender: TObject; Shift: TShiftState;
{Move the selected cell with mouse movement}
  X, Y: Integer);
var  c,r:integer;
begin
  with Grid do
  begin
    MouseToCell(x,y,c,r);
    col:=c;
    row:=r;
  end;
end;

{**************** GridDblClick **************}
procedure TForm1.GridDblClick(Sender: TObject);
{user double clicked  to clear a cell}
var
  ch:char;
begin
  with Grid do
  if (cells[col,row]<>'') then
  begin
    ch:=cells[col,row][1];
    cells[col,row]:=''; {clear the cell}
    {recalculate available letters for this and other cells}
    redovalidletters(col,row,ch,'+');
    invalidate;
  end;
end;

{************* HintGrpClick ************}
procedure TForm1.HintGrpClick(Sender: TObject);
{Update the hint displays}
begin
  {keep track of which hints were used :>) }
  HintGrp.tag:=Hintgrp.tag or hintgrp.itemindex;
  Grid.Invalidate; {force visual update for new hint type}
  Grid.SetFocus; {The hint click grabbed the focus from the grid, pass it back}
end;

{************ ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
{Initialize grid}
var i:integer;
begin
  for i:=0 to 24 do
  begin
    valids[i]:='MUSIC';
    Grid.cells[i mod 5, i div 5]:='';
  end;
  with Grid do
  begin
    cells[4,0]:='M'; addchar(4,0,'M');
    cells[4,1]:='U'; addchar(4,1,'U');
    cells[0,4]:='S'; addchar(0,4,'S');
    cells[2,4]:='I'; addchar(2,4,'I');
    col:=4; row:=4;  {select bottom right corner}
  end;
  hintgrp.tag:=0;
end;

{************ GridDrawCell ************8}
procedure TForm1.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
                              Rect: TRect; State: TGridDrawState);
var
  letter:string;
  x,y:integer;
begin
  with TStringgrid(sender), canvas do
  begin
    if gdSelected in state then brush.color:=clskyblue {this cell is selected}
    else brush.color:=clwhite;
    fillrect(rect);
    if cells[acol,arow]<>'' then
    begin {there is a letter, display it}
      letter:=cells[acol,arow];
      canvas.font.size:=24;
      canvas.font.name:='Calabri';
      x:=(rect.left+ rect.right - textwidth(letter)) div 2;
      y:=(rect.top+rect.bottom - textheight(letter)) div 2;
      textout(x,y,letter);
    end
    else
    begin {no letter. display the letters that could be placed here}
      font.Size:=8;
      case hintgrp.ItemIndex of
        1: textout(rect.left+1,rect.top+1,inttostr(length(valids[arow*5+acol])));
        2: textout(rect.left+1,rect.top+1,valids[arow*5+acol]);
      end;
    end;
  end;
end;

// Support routines

{************** AddChar ************8}
function TForm1.addchar(acol,arow:integer; letter:char):boolean;
{user wants to add "letter" to cell [acol,arow]}
var
  n,index:integer;
  msg:string;

  function solved:boolean;{check for solution}
  var c,r, count:integer;
  begin
    {Count the number filled cells}
    count:=0;
    with Grid do
    begin
      for c:=0 to 4 do
      for r:=0 to 4 do
      if cells[c,r]<>'' then inc(count);
    end;
    result:=count=25; {Solved if all cells filled}
  end;

begin {addchar}
  with Grid do
  begin
    if cells[acol,arow]<>'' then cells[acol,arow]:='';
    index:=arow*5+acol;
    n:=pos(letter, valids[index]); {find the letter in valid letters array for this cell}
    if n>0 then
    begin {letter can be added in this location}
      result:=true;
      RedoValidLetters(acol,arow,letter,'-'); {take the letter away from in-line cells}
      Cells[acol,arow]:=letter;
      if solved then
      begin
        case hintgrp.ItemIndex of
          0:
            if hintgrp.tag = 0 then  msg:='Congratualtions!!!'
            else msg:='Good. You finished the puzzle without hints.'+
            #13+'Now try solving without using hints at all :>)';
          1: msg:='You solved it!  (Now try it without any hints :>)';
          2: msg:='You did it, but really, it''s too easy with letter choices showing.'
                  +#13+'Try it with just the valid letter counts shown';
        end;
        showmessage(msg);
      end;
    end
    else
    begin
      result:=false;
      beep;
    end;
    invalidate; {force all cells to be redrawn}
  end;
end;


{************ ReDoValidLetterts ************}
procedure TForm1.ReDoValidLetters(acol,arow:integer; letter,addsub:char);
{ReDoValidletters scans column, row and diagonals of cell[acol,arow]
 whenever the cell changes in order to update the string of valid characters
 valid for those cells. It calls UpdateValids to do the actual updating}
var
 c,r:integer;
begin
  {add or remove letter from valids for row arow, column acol and the left and rght diagonals}
  for c:=0 to 4 do {fix row}
  if c<>acol then UpdateValids(c, arow, letter, addsub);

  for r:=0 to 4 do  {fix col}
  if r<>arow then UpdateValids(acol, r, letter, addsub);

  {down-left diagonal}
  c:=acol+1; r:=arow+1;
  while (c<=4) and (r<=4) do
  begin
    UpdateValids(c, r, letter, addsub);
    inc(c); inc(r);
  end;
  c:=acol-1; r:=arow-1;
  while (c>=0) and (r>=0) do
  begin
    UpdateValids(c, r, letter, addsub);
    dec(c); dec(r);
  end;

  {down-right diagonal}
  c:=acol+1; r:=arow-1;
  while (c<=4) and (r>=0) do
  begin
    UpdateValids(c, r, letter, addsub);
    inc(c); dec(r);
  end;
  c:=acol-1; r:=arow+1;
  while (c>=0) and (r<=4) do
  begin
    UpdateValids(c, r, letter, addsub);
    dec(c); inc(r);
  end;
end;

{************ UpdateValids **********}
procedure TForm1.UpdateValids(acol,arow:integer; letter, addsub:char);
{adjust the valid letters for cell {acol,arow] based on a new letter having been
 added to a cell in line with it (or erased from cell[c,r] if addsub-'-')}

  function CanAddLetter(acol,arow:integer;letter:string):boolean;
   {check row, column, and diagonals to make sue that the letter does not
    already exist in a cell.  Return true if not found, false if found.
    It is called because a letter has been removed from a cell in line with
    this one, but that may or may not mean that the letter is now valid for
    this cell.  It depends on whether the letter is already used in some other
    direction in line with this cell.}
  var
    c,r:integer;
  begin
    with Grid do
    begin
      result:=true;
      for c:=0 to 4 do {check row}
      if cells[c,arow]=letter then result:=false;
      if result then
      for r:=0 to 4 do  {fix col}
      if cells[acol,r]=letter then result:=false;

      {down-left diagonal}
      c:=acol+1; r:=arow+1;
      if result then
      while (c<=4) and (r<=4) do
      begin
        if cells[c,r]=letter then result:=false;
        inc(c); inc(r);
      end;
      c:=acol-1; r:=arow-1;
      if result then
      while (c>=0) and (r>=0) do
      begin
        if cells[c,r]=letter then result:=false;
        dec(c); dec(r);
      end;

      {down-right diagonal}
      c:=acol+1; r:=arow-1;
      if result then
      while (c<=4) and (r>=0) do
      begin
        if cells[c,r]=letter then result:=false;
        inc(c); dec(r);
      end;
      c:=acol-1; r:=arow+1;
      if result then
      while (c>=0) and (r<=4) do
      begin
        if cells[c,r]=letter then result:=false;
        dec(c); inc(r);
      end;
    end;
  end;

var
  n:integer;
  index2:integer;
begin   {updateValids}
  index2:=5*arow+acol;
  n:=pos(letter,valids[index2]);
  if (addsub='-') and (n>0) then
  begin
    delete(valids[index2],n,1);
  end
  else {trying to a a letter to valids string, need additional checking first}
  if (addsub='+') and (n=0) and canAddLetter(acol,arow,letter)
  then valids[index2]:=letter+valids[index2];
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;
end.
