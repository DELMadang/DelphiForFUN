unit U_PrimePairSums;
{Copyright � 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
The object of this puzzle is to arrange the integers 1 through 16 into a 4x4
grid so that the sum of any two cells horizontally or vertically is prime.

There are 2992 solutions which can be generated by two buttons (1496 for each).
Since the only even prime  is 2 and the sum of adjacent cells will always be 3
or greater, all of the prime sums must be odd.  And, since the sum of two even
or two odd numbers is always even, it is  clear that each number must have
neighbors of the opposite parity.  If a row contains odd-even-odd-even numbers,
the row above or below this row must contain even-odd-even-odd numbers. The
effect is similar to a checkerboard with number of one parity on the black
squares and numbers of the other parity on the red squares.

The program takes advantage of this in the fiirst button by permuting the 8 odd
numbers "odd" positions and for each of those, permuting the 8 even numbers into
the "even" positions and then checking for prime pair sums.  For the second
button, the odd-even roles are reversed.   Note that if the effects of rotating
and mirroring are considered, the number of unique solutions is reduced by a
factor of 8.

This puzzle was adpated from "The Master Book of Mathematical Recreations",
Fred Schuh, Dover Publications.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ShellAPI;

type
  TInt8Array=array[1..8] of integer;
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    OddsFirstBtn: TButton;
    Label1: TLabel;
    Memo1: TMemo;
    EvensFirstBtn: TButton;
    Label2: TLabel;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure OddsFirstBtnClick(Sender: TObject);
    procedure EvensFirstBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    ints:array[1..16] of integer;
    nbrsolutions:integer;
    procedure FindSolutions(p1,p2:TInt8Array);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses mathslib;

{************ FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,c,r:integer;
begin
  for i:=0 to 15 do
  begin
    c:=i mod 4;
    r:=i div 4;
    stringgrid1.Cells[c,r]:=inttostr(i+1);
  end;
  with stringgrid1 do canvas.font:=font;
end;

var
  TopOdds:TInt8Array=(1,3,6,8,9,11,14,16); {sequential indices of odd # positions}
  TopEvens:TInt8Array=(2,4,5,7,10,12,13,15);{sequential indices of even # positions}

{************** OddsFirstBtnClick *************}
procedure TForm1.OddsFirstBtnClick(Sender: TObject);
begin
  findsolutions(TopOdds,TopEvens); {Odd in top-left}
end;

{************* EvensFirstBtnClick ***********}
procedure TForm1.EvensFirstBtnClick(Sender: TObject);
begin
  FindSolutions(TopEvens,TopOdds); {Exchange even-odd roles, even in top-left}
end;

var
  stringInts:array[1..16] of string=('1','2','3','4','5','6','7','8','9',
           '10','11','12','13','14','15','16');

{**************** FindSolutions ************}
procedure TForm1.FindSolutions(p1,p2:TInt8Array);
{Permute numbers into positions for that parity}
var
  i,j,k,c,r,n:integer;
  OK:boolean;
  ints8Odd, ints8Even:array[1..8] of integer;
  s:string;
  start:TDateTime;
begin
  screen.cursor:=crhourglass;
  nbrsolutions:=0;
  memo1.Clear;
  memo1.Clear;
  label1.Caption:='0 solutions';
  label2.Caption:='Run time: 0.0';
  start:=now;
   ok:=false;  {just to eliminate Compiler warning message}
  for i:=1 to 8 do ints8odd[i]:=(2*i-1); {odd numbers 1 - 15}
  repeat
    for i:=1 to 8 do
    begin
      ints[p1[i]]:=ints8odd[i]; {place odd numbers in "p1" positions}
      ints8even[i]:=2*i;  {reset the even numbers 2-16}
    end;

    repeat
      for j:=1 to 8 do  ints[p2[j]]:=ints8even[j]; {place even numbers in "p2" positions}
      {check for solution}
      for k:=1 to 16 do
      begin
        if k mod 4 >0 then {test horizontal adjacents, columns 1-3 + following col.}
        begin
          n:=ints[k]+ints[k+1];
          {test for nbon-prime values}
          ok := (n<>9) and (n<>15) and (n<>21) and (n<>25) and (n<>27);
          if not OK then break;
        end;
        if k<=12 then  {check vertical adjacents rows 1-3 + row below}
        begin
          n:=ints[k]+ints[k+4];
          ok := (n<>9) and (n<>15) and (n<>21) and (n<>25) and (n<>27);
          if not Ok then break;
        end;
      end;
      if Ok then    {solution found}
      begin
        inc(nbrsolutions);
        s:='';
        for i:=0 to 15 do
        begin
          c:=i mod 4; {get column and row for the number ints[i+1]}
          r:=i div 4;
          n:=i+1;
          stringgrid1.Cells[c,r]:=stringints[ints[n]];
          s:=s+stringints[ints[n]]+', ';  {making the string for display}
        end;
        delete(s,length(s),1); {remove extra ","}
        memo1.lines.add(s);
        label1.caption:=inttostr(nbrsolutions) + ' solutions found';
        label2.Caption:=format('Run time %6.1f seconds',
                        [(now-start)*secsperday]);
        application.ProcessMessages;
      end;
    until not nextpermute(Ints8Even);
  until not nextpermute(ints8Odd);{permute them}
  screen.cursor:=crdefault;
end;

{********** StringGrid1DrawCell **************8}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
{Do our own cell drawing to prevent highlighting of "selected"  cell}
  Rect: TRect; State: TGridDrawState);
begin
  with TStringgrid(sender) , canvas do
  begin
    rectangle(rect);
    with rect do textout(left+8,top+8,cells[Acol,arow]);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
