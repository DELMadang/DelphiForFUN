unit U_MovegridRows;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Buttons, Grids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    DownBtn: TBitBtn;
    UpBtn: TBitBtn;
    DownPageBtn: TBitBtn;
    UpPageBtn: TBitBtn;
    TopBtn: TBitBtn;
    BottomBtn: TBitBtn;
    Label1: TLabel;
    TimingBtn: TButton;
    TimingBtn2: TButton;
    GordonBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UpBtnClick(Sender: TObject);
    procedure DownBtnClick(Sender: TObject);
    procedure UpPageBtnClick(Sender: TObject);
    procedure DownPageBtnClick(Sender: TObject);
    procedure TopBtnClick(Sender: TObject);
    procedure BottomBtnClick(Sender: TObject);
    procedure TimingBtnClick(Sender: TObject);
    procedure TimingBtn2Click(Sender: TObject);
    procedure GordonBtnClick(Sender: TObject);
  public
    temp:TStringlist;
  end;

  Procedure MoveGridRow(Grid:TStringGrid; Too:integer; Temp:TStringlist); overload;
  Procedure MoveGridRow(Grid:TStringgrid; Too:integer); overload;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*********** MovegridRow ******************}
Procedure MoveGridRow(Grid:TStringgrid; Too:integer; Temp:TStringList);
var
  from,n,step:integer;
begin
  with grid do
  begin
    from:=row;
    {Moving up: there must be at least one non-fixed row above the selected row}
    If (too<=from) and (too<fixedrows) then too:=fixedrows;
    {Moving down: There must at least one row below the selected row}
    If  (too>rowcount-1) then too := rowcount-1;
    if too>from then step:=+1
    else if too<from then step:=-1
    else exit;  {Too=from, no move so exit}
    n:=from;
    repeat {Loop to shift all intervening lines up or down}
      temp.assign(rows[n]);  {Save the row cells in Temp}
      rows[n].assign(rows[n+step]); {Move the previous row down one}
      rows[n+step].Assign(temp); {Reload the selected row in previous row location}
      inc(n,step);
    until n=too;
    row:=too;  {Keep the moved row as the one selected}
  end;
end;

procedure MovegridRow(Grid:TStringgrid; Too:integer);
{Overloaded version which dooes not require the user to allocate the
 temp stringlist required to hold the row while it is being swapped.
 Slightly slower, but delay will normally be unmeasurable.}
var
  temp:TStringlist;
begin
  temp:=TStringlist.create;
  MovegridRow(Grid,Too,Temp);
  temp.Free;
end;

{*************** FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  {fill the grid with some test data}
  With stringgrid1 do
  begin
    for i:=0 to colcount-1 do cells[i,0]:='Column '+inttostr(i+1);
    for i:=1 to rowcount-1 do
    begin
      cells[0,i]:=inttostr(i);
      objects[0,i]:=TObject(10*i);
      for j:=1 to colcount-1 do
      cells[j,i]:=stringofchar(char(ord(pred('A'))+i),4)+inttostr(j);
    end;

  end;
  temp:=Tstringlist.create;  {Create the temporary list for swapping rows}
end;

{************** UpBtnClick ***********}
procedure TForm1.UpBtnClick(Sender: TObject);
{Move selected row up one row}
begin
  with stringgrid1 do MoveGridRow(Stringgrid1,row-1,temp);
end;

{************ DownBtnClick **********}
procedure TForm1.DownBtnClick(Sender: TObject);
{Move selected row down one row}
begin
   with stringgrid1 do MoveGridRow(StringGrid1,row+1,temp);
end;

{************* UpPageBtnClick *********}
procedure TForm1.UpPageBtnClick(Sender: TObject);
begin
  with stringGrid1 do MoveGridRow(Stringgrid1,row-VisibleRowCount,Temp);
end;

{************* DownPageBtnClick **********}
procedure TForm1.DownPageBtnClick(Sender: TObject);
begin
  with stringGrid1 do MoveGridRow(Stringgrid1,row+VisibleRowCount,Temp);
end;

{*********** TopBtnClick ********}
procedure TForm1.TopBtnClick(Sender: TObject);
begin
  with stringGrid1 do MoveGridRow(Stringgrid1,0,Temp);
end;

{********** BottombtnClick *********}
procedure TForm1.BottomBtnClick(Sender: TObject);
begin
  with stringGrid1 do MoveGridRow(Stringgrid1,rowcount-1,Temp);
end;



{***************** TimingBtnClick **********}
procedure TForm1.TimingBtnClick(Sender: TObject);
var
  freq,start,stop:int64;
  i:integer;
  loops:integer;
begin
  movegridrow(Stringgrid1,0);
  loops:=100;
  queryperformancefrequency(Freq);
  queryperformancecounter(Start);
  for i:=1 to loops do
  begin
    with stringGrid1 do MoveGridRow(Stringgrid1,rowcount-1,Temp);
    with stringGrid1 do MoveGridRow(Stringgrid1,0,Temp);
  end;
  queryperformancecounter(stop);
  memo1.lines.add('Preallocated temp Stringlist');
  memo1.Lines.add(format('%d moves top,bottom,top, etc. = %f ms',
             [loops, 1000*(stop-start)/freq] ) );
 queryperformancecounter(Start);
 for i:=1 to loops do
  begin
    with stringGrid1 do MoveGridRow(Stringgrid1,rowcount-1);
    with stringGrid1 do MoveGridRow(Stringgrid1,0);
  end;
  queryperformancecounter(stop);
  memo1.lines.add('NO Preallocated Temp Stringlist');
  memo1.Lines.add(format('%d moves top,bottom,top, etc.= %f ms',
             [loops, 1000*(stop-start)/freq]));

   queryperformancecounter(Start);
  for i:=1 to loops do
  begin
    with stringGrid1 do MoveGridRow(Stringgrid1,row+1,Temp);
    with stringGrid1 do MoveGridRow(Stringgrid1,row-1,Temp);
  end;
  queryperformancecounter(stop);
  memo1.lines.add('Preallocated temp Stringlist');
  memo1.Lines.add(format('%d moves +1 row, -1 row, etc. = %f ms',
             [loops, 1000*(stop-start)/freq] ) );
 queryperformancecounter(Start);
 for i:=1 to loops do
  begin
    with stringGrid1 do MoveGridRow(Stringgrid1,row+1);
    with stringGrid1 do MoveGridRow(Stringgrid1,row-1);
  end;
  queryperformancecounter(stop);
  memo1.lines.add('NO Preallocated Temp Stringlist');
  memo1.Lines.add(format('%d moves +1 row, -1 row, etc.= %f ms',
             [loops, 1000*(stop-start)/freq]));

end;

{************* TimingBtn2Click **********}
procedure TForm1.TimingBtn2Click(Sender: TObject);
begin
  Memo1.lines.add('Hide grid during test');
  stringgrid1.visible:=false;
  TimingBtnClick(sender);
  stringgrid1.visible:=true;
end;

{********** GordonBtnClick **********}
procedure TForm1.GordonBtnClick(Sender: TObject);
var i:integer;
begin
  with stringgrid1, memo1, lines do
  begin
    Clear;
    add('Original row numbers x 10 were saved as objects in column 0.');
    add('Here is the list of those objects for the current row arrangement');
    add('Values displayed should be 10 x current column 0 cell values');
    for i:=1 to rowcount-1 do  add(format('%d',[Integer(stringgrid1.objects[0,i])]));
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
