unit U_RotatingSums;
{The digits 1-9 are arranged so that the first row added to the second row
 equals the bottom row --  583+146=729.

 Now if the grid is rotated clockwise through 90 degrees, you will see that
 the first two rows still add up to the last row -- 715+248=963.

 Can you find another combination of the digits 1-9 which has the same property?

 Source:  Math and Logic Puzzles for PC Enthusiasts,
 J. J.  Clessa.  Problem # 64.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveButton: TButton;
    StringGrid1: TStringGrid;
    procedure SolveButtonClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    board:array[1..3,1..3] of integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses U_Permutes;

{**************** SolveButtonClick ****************}
procedure TForm1.SolveButtonClick(Sender: TObject);
var
  i,j:integer;
  r1,r2,r3:integer; {intermediate sums for tests}
  s:array of integer;  {array of nbr in each permutation}
Begin
  initpermutes(9,9); {initialize permute routine to return 9 of 9}
  setlength(s,10);  {initialize array - size number to return +1}
  while getnextPermute(s) do {get a permutation}
  Begin
    r3:=100*s[7]+10*s[8]+s[9]; {get the last row as a number}
    r1:=100*s[1]+10*s[2]+s[3]; {get 1st row as nbr}
    If r1<r3 then   {if 1st not bigger then keep checking}
    Begin
      r2:=100*s[4]+10*s[5]+s[6]; {2nd row as number}
      if r1+r2=r3 then {if sum of 1st 2 rows = 3rd}
      Begin
        r3:=100*s[9]+10*s[6]+s[3]; {get 3rd column as a number}
        r1:=100*s[7]+10*s[4]+s[1]; {get 1st column as a number}
        If r1<r3 then  {keep checking}
        Begin
          r2:=100*s[8]+10*s[5]+s[2];  {get 2nd column as a number}
          if r1+r2=r3 then {if 1st + 2nd columns = 3rd then solution!}
          Begin
            for i:=0 to 2 do    {load up the display grid}
            for j:= 0 to 2 do
                stringgrid1.cells[i,j]:=inttostr(s[3*j+i+1]);
            showmessage('Solution found');
          end;
        end;
      end;
    end;
  end;
  Showmessage('No more solutions');
end;

procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
 {Selected cell of grid is normally drawn in a highlight color}
 {This drawcell exit is used to force all cells to be drawn in the same color}
begin
  with stringgrid1.Canvas do
  Begin
    Brush.Color := clWhite;
    font.color:=clblack;
    FillRect(Rect);
    textout(rect.left+2, rect.top+2, stringgrid1.cells[acol,arow]);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  {initiaize the display grid at form activate time}
  with StringGrid1 do
  Begin
    cells[0,0]:='5';
    cells[1,0]:='8';
    cells[2,0]:='3';
    cells[0,1]:='1';
    cells[1,1]:='4';
    cells[2,1]:='6';
    cells[0,2]:='7';
    cells[1,2]:='2';
    cells[2,2]:='9';
  end;
end;

end.
