unit U_No_3_In_A_Row;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, ShellAPI, DFFutils;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    Image1: TImage;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure SearchBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  {if tic-tac-toe squares are numbered 1 to 9 from left to right and
   top to bottom, these 8 triplets represent the rows, columns and diagonals
   which must not be filled as the 6 X's are placed}
  rows:array[1..8, 1..3] of integer =((1,2,3),(4,5,6),(7,8,9),(1,4,7),
                                      (2,5,8),(3,6,9),(1,5,9),(3,5,7));

{************** SearchbtnClick **********}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  i,j,k,sum:integer;
  b, msg:string;
  ok:boolean;
begin
  memo1.Clear;
  memo1.Lines.add('All arrangements tested:');
  memo2.Clear;
  memo2.Lines.add('Solutions:');
  for i:= 1 to 511 do
  begin {generate all numbers up to 511  (511= nine 1's in binary '111111111')
         which contain six 1's and three 0's in their binary representaion}
    b:=inttobinarystring(i,9);
    sum:=0;
    for j:=1 to length(b) do  if b[j]='1' then inc(sum);
    if sum=6 then
    begin
      ok:=true;
      for j:=1 to 9 do if b[j]='1' then b[j]:='X';  {replace 1's with X's for display}
      for k:=1 to 8 do
      begin {check each row, column & diagonal in the grid for 3 X's}
        if (b[rows[k,1]]='X') and (b[rows[k,2]]='X') and (b[rows[k,3]]='X') then
        begin  {the X's in a line - reject this arrangement}
          ok:=false;
          break;
        end;
        if not OK then break; {this is not a solution, no need to check other rows}
      end;
      if ok then
      begin
        msg:='Yes';  {no 3 in a row, it's a solution!}
        with memo2.lines do
        begin
          add('      '+copy(b,1,3));
          add('      '+copy(b,4,3));
          add('      '+copy(b,7,3));
          add('      '+'----------------');
        end;
      end
      else  msg:='No';
      {list all arrangements with 6 X's and identify the winners}
        with memo1.lines do add(format('#%2d: %d=%s,%s,%s  %s',
               [count, i, copy(b,1,3),copy(b,4,3),copy(b,7,3), msg]));
    end;
  end;
  memo1.selstart:=0;
  memo1.sellength:=0;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
   nil, nil, SW_SHOWNORMAL) ;
end;

end.
