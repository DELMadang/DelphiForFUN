unit U_Trominoes;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{A 6x6 grid was tiled using only the two "tromino" shapes
and their rotations. (Four orientations for the "L" shape and two for
the "I").   Use as many of each tromino as needed.   The locations of
the tromino dots are shown on the grid but without the outlines.  Can 
you add thickened lines to complete the tiling?
}

//Source: "Mensa "Puzzle Calendar" for May 5, 2014.

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids, jpeg;

type
  TTromino = record  {Tromino defined as a 2x2 or 3x1 or 1x3 2-dimensioned string array}
    T:array of array of String;
  end;


  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Grid: TStringGrid;
    Search: TButton;
    Image1: TImage;
    procedure StaticText1Click(Sender: TObject);
    procedure DefaultBtnClick(Sender: TObject);
    procedure SearchClick(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
  public
    trominoes:array [1..6] of Ttromino; {The 6 rotated tromino shapes}
    procedure maketrominoes;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const
  dotsize=6;  {pixel radius of tromino dot}
  w=2;{pixel offset from cell boundary to tromino wall}
  w2=2*w; {offset used to close tromino walls across cells}


  {Dots on trominoes lie on these predefined dots on the board}
  defaultcase:array [0..5, 0..5] of string =
      (('D','D',' ',' ','D','D'),
       (' ',' ',' ','D',' ',' '),
       ('D',' ','D',' ',' ','D'),
       ('D',' ',' ',' ','D',' '),
       (' ',' ',' ','D',' ','D'),
       (' ','D','D',' ','D',' '));

{*********** FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  maketrominoes; {define the trominoes}
  DefaultBtnClick(Sender); {draw the initial grid}
end;


{********* MakeTrominoes **********}
procedure TForm1.MakeTrominoes;
{define the 6 possible trominoes}
var
  r,c:integer;
begin
  with trominoes[1] do
  begin
    setlength(T,2,2);  {rows x columns, one entry for each cell}
    {Define the default blank cell in the tromino T[1] as ' ', the "dot cell with
     a 'D', the undefined corner as '_'.   The second character is the tromino
     number being defined, and the edges (T[3] through T[6]  contain 4 characters
     reprpesenting top, right,bottom, and left in that order using  '1' to
     indicate that this edge is to be drawn and '0' for no draw}
    T[0,0]:='D11001'; T[0,1]:=' 11110'; T[1,0]:=' 10111'; T[1,1]:='_10000';
  end;
  with trominoes[2] do
  begin
    setlength(T,2,2);  {rows x columns}
    T[0,0]:=' 21011'; T[0,1]:='D21100'; T[1,0]:='_200000'; T[1,1]:=' 20111';
  end;
  with trominoes[3] do
  begin
    setlength(T,2,2);  {rows x columns}
    T[0,0]:='_30000'; T[0,1]:=' 31101'; T[1,0]:=' 31011'; T[1,1]:='D30110';
  end;
  with trominoes[4] do
  begin
    setlength(T,2,2);  {rows x columns}
    T[0,0]:=' 41101'; T[0,1]:='_40000'; T[1,0]:='D40011'; T[1,1]:=' 41110';
  end;
  with trominoes[5] do
  begin
    setlength(T,3,1);  {the "I" shaped tromino}
    T[0,0]:='D51101'; T[1,0]:=' 50101'; T[2,0]:='D50111';
  end;
  with trominoes[6] do
  begin
    setlength(T,1,3);  {the horizontal version of the "I" tromino}
    T[0,0]:='D61011'; T[0,1]:=' 61010'; T[0,2]:='D61110';
  end;
end;

{********** DefaultBtnClick *********8}
Procedure TForm1.DefaultBtnClick(Sender: TObject);
{no longer a button, but called to drawn the grid with just the dots in place}
Var
  c,r:integer;
begin
  {fill the grid}
  for r:=0 to 5 do
  for c:=0 to 5 do
  begin
    grid.cells[c,r]:= defaultcase[r,c]+'00000';
    grid.update;
  end;
end;

{********* SearchBtnClick *********8}
procedure TForm1.SearchClick(Sender: TObject);
{Place trominoes from left to right and top to bottom using a recursive search}

    {---------- Fits -----------}
    function fits(x,y,ii:integer):boolean;
    {Returns true if tromino ii can be place with top-left corner at cell location x,y}
    var
      c,r,rr,cc:integer;
      tri:TTromino;
    begin {see if tromino "ii" can be placed with topleft at grid.cells[x,y]}
      result:=false;
      tri:=Trominoes[ii];
      c:=x;
      r:=y;
      with grid, tri do
      begin
        if (cells[c,r][2]<>'0') and (tri.t[0,0][1]<>'_') then exit; {top left already occupied and we need to use it}
        for rr:=0 to high(t) do
        for cc:=0 to high(t[0]) do
        begin
          if (c+cc >=colcount) or (r+rr>=rowcount) then exit; {ran out of room}
          if (t[rr,cc][1]<>'_') and (cells[c+cc,r+rr][2]<>'0') then exit; {already occupied}
          if (t[rr,cc][1]<>'_') and (t[rr,cc][1]<> cells[c+cc, r+rr][1]) then exit;  {Dots don't match}
        end;
        result:=true;
      end;
    end;

    {--------- Place ---------}
    procedure place(x,y,ii:integer);
    var
      c,r,cc,rr:integer;
      tri:TTromino;
    begin {Place trimono "ii" at top-left grid.cells[x,y]}
      tri:=Trominoes[ii];
      c:=x;
      r:=y;
      with grid, tri do
      begin
        for rr:=0 to high(t) do
        for cc:=0 to high(t[0]) do
        if t[rr,cc][1]<>'_' then cells[c+cc,r+rr]:=t[rr,cc];
      end;
      grid.update;
      sleep(1000);
    end;

    {---------- Remove ----------}
    procedure remove(x,y,ii:integer);
    var
      c,r,cc,rr:integer;
      tri:TTromino;
    begin {reset cell occupied by trimono "ii" at grid.cells[x,y] to empty}
      tri:=Trominoes[ii];
      c:=x;
      r:=y;
      with grid, tri do
      begin
        for rr:=0 to high(t) do
        for cc:=0 to high(t[0]) do
        if t[rr,cc][1]<>'_' then cells[c+cc,r+rr]:= cells[c+cc,r+rr][1]+'00000';
      end;
      grid.update;
      sleep(1000);
    end;

    {------------ PlaceNext -----------}
    function Placenext(x,y:integer):boolean;
    {Recursive function to find a tromino to fit at column x and row y}

    var
      i,newx, newy:integer;
      s:string;
      savexy:TPoint;
      tryx:integer;
      OK:boolean;
      pass:integer;
    begin
      with grid do
      begin
        if (y>=rowcount) then
        begin  {solved}
          result:=true;
        end
        else
        begin
          result:=false;
          s:=cells[x,y];
          pass:=1;
          if s[2]='0' then
          begin
            for i:=1 to 6 do
            begin  {try all 6 trominoes}
              {special case for reversed "L" tromino without a top-left cell used
               then pass "Fits" function the column to the left of the free cell}
              if (x>0) and (trominoes[i].T[0,0][1]='_') then tryx:=x-1
              else tryx:=x;
              if Fits(tryX,y,i) then
              begin
                place(tryx,y,i);
                savexy:=point(x,y);
                newx:=x; newy:=y;
                repeat
                  newx:=newx+1;
                  if newx>=colcount then
                  begin
                    newx:=0;
                    newy:=newy+1;
                  end;
                until (newy>=rowcount) or (cells[newx,newy][2]='0');
                result:=placenext(newx,newy);
                if not result then
                begin
                  remove(tryx,y,i); {retract placement}
                  x:=savexy.x;
                  y:=savexy.y;
                end;
              end;
            end;
          end
          else
          begin
            showmessage('Program error: tried to fill a filled cell');
            exit;
          end;
        end;
      end;
    end;
begin {Searchbtnclick}
 defaultbtnclick(sender);
 if placeNext(0,0) then
 begin
   showmessage('Solved!');
   grid.Update;
 end;
end;


procedure TForm1.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  {Draw the 'Dot' if present and if cell [2] is not '0' then draw "edges" based
   on last 4 chars of cell}
var
  i:integer;
  s:string;
  walls:string;
  cx,cy:integer;
begin
  with grid, canvas do
  begin
    brush.color:=clwhite;
    rectangle(rect);
    s:=cells[acol,arow];
    walls:=copy(s,3,4);
    if length(s)<> 6 then exit;
    if s[2]<>'0' then {cell occupied by a tromino, draw it}
    begin
      pen.color:=clblack;
      pen.width:=3;
      with rect do
      begin
        (* {original version to draw trominoes but  did not know how to close the corners}
        if s[3]<>
        '0' then
        begin  {topwall}
          //if s[4]
          moveto(left, top+w);
          lineto(right-w, top+w);
        end;
        if s[4]<>'0' then
        begin  {right wall}
          moveto(right-w, top+w);
          lineto(right-w, bottom-w);
        end;
        if s[5]<>'0' then
        begin  {bottom wall}
          moveto(left, bottom-w);
          lineto(right,bottom-w);
        end;
        if s[6]<>'0' then
        begin  {left wall}
          moveto(left+w, top);
          lineto(left+w, bottom);
        end;
        *)

        {Revised version draw each unique portion of the outline for a particular cell.
         Works much better}
        if walls='1011' then {these 4 digits represent the top, right bottom and left lines to draw for the current cell}
                             {'1' = draw it, '0' = no drawing}
        begin
          moveto(right+w2,top+w); lineto(left+w,top+w); lineto(left+w,bottom-w); lineto(right+w2,bottom-w);
        end
        else if walls='1100' then
        begin
          moveto(left-w2,top+w); lineto(right-w,top+w); lineto(right-w,bottom+w2);
          moveto(left,bottom-w); lineto(left+w,bottom-2);  {replace the little segment we cleared on entry}
        end
        else if walls='1001' then
        begin
          moveto(left+w,bottom+w2); lineto(left+w,top+w); lineto(right+w2,top+w);
        end
        else if walls='0111' then
        begin
          moveto(left+w,top-w2); lineto(left+w,bottom-w); lineto(right-w,bottom-w); lineto(right-w,top-w2);
        end
        else if walls='1101' then
        begin
          moveto(left+w,bottom+w2); lineto(left+w,top+w); lineto(right-w,top+w); lineto(right-w,bottom+w2);
        end
        else if walls='0110' then
        begin
          moveto(left-w,bottom-w); lineto(right-w,bottom-w); lineto(right-w,top-w2);
          moveto(left, top+w); lineto(left+w,top+w); lineto(left+w, top); {replace the segment we cleared on entry}
        end

        else if walls='0011' then
        begin
          moveto(left+w,top-w2); lineto(left+w,bottom-w); lineto(right+w2,bottom-w);
        end
        else if walls='1110' then
        begin
          moveto(left-w2,top+w); lineto(right-w,top+w); lineto(right-w,bottom-w); lineto(left-w2,bottom-w);
        end
        else if walls='0101' then
        begin
          moveto(left+w,top-w2); lineto(left+w,bottom+w2); moveto(right-w,top-w2); lineto(right-w,bottom+w2);
        end

        else if walls='1010' then
        begin
          moveto(left-w2,top+w); lineto(right+w2,top+w); moveto(left-w2,bottom-w); lineto(right+w2,bottom-w);
        end;

      end;
      pen.color:=clsilver;
      pen.width:=1;
    end;
    if s[1]='D' then
    with rect do
    begin
      cx:=(left+right)div 2;
      cy:=(top+bottom) div 2;
      pen.color:=clblack;
      brush.color:=clblack;
      ellipse(cx-dotsize, cy-dotsize, cx+dotsize, cy+dotsize);
      brush.color:=color;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
