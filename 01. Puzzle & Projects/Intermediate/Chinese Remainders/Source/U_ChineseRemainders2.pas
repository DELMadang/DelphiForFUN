unit U_ChineseRemainders2;
{Copyright  © 2001-2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{Fooling around with "Chinese Remainder" problems}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls, DFFUtils, shellapi;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    StringGrid1: TStringGrid;
    Answerlbl: TLabel;
    Intromemo: TMemo;
    SelectionBox: TComboBox;
    Memo4th: TMemo;
    Memo7th: TMemo;
    Mensamemo: TMemo;
    MensaMemo2: TMemo;
    mensamemo3: TMemo;
    StaticText1: TStaticText;
    procedure SolveBtnClick(Sender: TObject);
    procedure StringGrid1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure SelectionBoxChange(Sender: TObject);
    procedure StringGrid1SetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure StaticText1Click(Sender: TObject);
  public
    //procedure AdjustGridSize;
    procedure deleterow(r:integer);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SolveBtnClick(Sender: TObject);
{Search for a solution}
var
  dividedby:array of integer;
  remainders: array of integer;
  i,N:integer;
  errcode, valcount:integer;
  solved:boolean;
begin
  setlength(dividedby,stringgrid1.rowcount-1);
  setlength(remainders,stringgrid1.rowcount-1);
  errcode:=0;
  i:=1;
  valcount:=0;
  {Here's a bunch of code to check for errors in string grid values
   as we convert them to integers}
  with stringgrid1 do
  while (errcode=0) and (i<=rowcount-1) do  {for each row}
  begin
    begin
      if (errcode=0) and (length(cells[0,i])>0) then
      begin    {convert divisor}
        inc(valcount);
        val(cells[0,i],dividedby[i-1],errcode);
        if errcode<>0 then
        begin  {select cell in error}
          row:=i; col:=0;
        end
        else
        begin   {convert remainder}
          val(cells[1,i],remainders[i-1],errcode);
          if errcode<>0 then
          begin  {select cell in error}
            row:=i;  col:=1;
          end;
        end;
      end;
      inc(i);
    end;
  end;

  {Now find solution}
  n:=0; {N is trial solution}
  solved:=false;
  setlength(dividedby,valcount);
  setlength(remainders,valcount);
  if (errcode=0) then
  while (not solved) and (n<1000000) do
  begin
    solved:=true;
    inc(n);
    for i:=low(dividedby) to high(dividedby) do
    begin
      if dividedby[i]<>0 then
      begin
        if n mod dividedby[i] <> remainders[i] then
        begin  {this isn't the solution - so stop checking this number}
          solved:=false;
          break;
        end;
      end
      else solved:=false;
    end;
  end
  else showmessage(' Error in input ');
  if solved then answerlbl.caption:=' Solution is '+inttostr(n)+' '
  else answerLbl.caption:=' No solution below 10,000,000 found ';
  answerLbl.visible:=true;
end;

(*
procedure TForm1.adjustGridSize;
{Adjust borders of grid to just fit cells}
var
  h:integer;
begin
  with stringgrid1 do
  begin
    h:=(defaultrowheight+GridLineWidth)*rowcount+gridlinewidth+2 {+2 for border};
    if (h<height) or ((h>height) and (h+top<Solvebtn.top-5))
    then height:=h;
    width:=colwidths[0]+colwidths[1]+3*gridlinewidth+2 {+2 for border};
  end;
end;
*)

procedure TForm1.deleterow(r:integer);
{Delete a row from the data grid}
var  i:integer;
begin
  with stringgrid1 do
  if r>1 then {don't delete the last data row}
  begin
    for i:= r+1 to rowcount-2 do rows[i]:=rows[i+1];
    rowcount:=rowcount-1;
  end;
end;

procedure TForm1.StringGrid1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{check for Ins or Del key pressed}
begin
  with stringgrid1 do
  begin
    if key=vk_insert then rowcount:=rowcount+1
    else if (key=vk_delete) then deleterow(row);
    if (key=vk_insert) or (key=vk_delete) then adjustgridsize(stringgrid1);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  with stringgrid1 do
  begin
    cells[0,0]:=' N divided by ';
    cells[1,0]:=' Has remainder';
    AdjustGridSize(stringgrid1);
  end;
  SelectionBox.itemindex:=0;
end;

procedure TForm1.SelectionBoxChange(Sender: TObject);
{change the display and set up a sample problem if selected}
var
  i:integer;
begin
  for i:=1 to controlcount-1 do
      if controls[i] is tmemo then tMemo(controls[i]).visible:=false;
  answerlbl.visible:=false;
   with SelectionBox, stringgrid1 do
   begin
      case itemindex of
      1: {Intro}
        begin
          intromemo.visible:=true;
          rowcount:=10;
        end;
      2: {4th}
        begin
          memo4th.visible:=true;
          rowcount:=4;
          cells[0,1]:='3'; cells[1,1]:='2';
          cells[0,2]:='5'; cells[1,2]:='3';
          cells[0,3]:='7'; cells[1,3]:='2';
          adjustgridsize(stringgrid1);
        end;
      3: {7th}
        begin
          memo7th.visible:=true;
          rowcount:=7;
          cells[0,1]:='6'; cells[1,1]:='1';
          cells[0,2]:='5'; cells[1,2]:='1';
          cells[0,3]:='4'; cells[1,3]:='1';
          cells[0,4]:='3'; cells[1,4]:='1';
          cells[0,5]:='2'; cells[1,5]:='1';
          cells[0,6]:='7'; cells[1,6]:='0';
          adjustgridsize(stringgrid1);
        end;
      4: {Mensa calendar, 2001}
        begin
          mensamemo.visible:=true;
          rowcount:=4;
          cells[0,1]:='6'; cells[1,1]:='5';
          cells[0,2]:='5'; cells[1,2]:='4';
          cells[0,3]:='4'; cells[1,3]:='3';
          adjustgridsize(stringgrid1);
        end;
      5: {Mensa calendar, 2003}
        begin
          mensamemo2.visible:=true;
          rowcount:=5;
          cells[0,1]:='8'; cells[1,1]:='1';
          cells[0,2]:='9'; cells[1,2]:='4';
          cells[0,3]:='10'; cells[1,3]:='1';
          cells[0,4]:='12'; cells[1,4]:='1';
          adjustgridsize(stringgrid1);
        end;
        6: {Mensa calendar, 2010}
        begin
          mensamemo3.visible:=true;
          rowcount:=7;
          cells[0,1]:='2'; cells[1,1]:='1';
          cells[0,2]:='3'; cells[1,2]:='2';
          cells[0,3]:='4'; cells[1,3]:='3';
          cells[0,4]:='5'; cells[1,4]:='4';
          cells[0,5]:='6'; cells[1,5]:='5';
          cells[0,6]:='7'; cells[1,6]:='0';
          adjustgridsize(stringgrid1);
        end;
      end;


    end;
end;

procedure TForm1.StringGrid1SetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  answerlbl.visible:=false;  {data changed - hide previous solution}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
