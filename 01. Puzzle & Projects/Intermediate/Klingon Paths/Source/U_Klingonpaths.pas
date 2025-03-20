unit U_Klingonpaths;

{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {
Klingon Pathways is an implemention of the problem presented by Cliffors Pickover
in his book "Wonders of Numbers"  Oxfor university press, 2001.

"This grid of numbers is Klingon City and it's a tough place to live.
Each Klingon inhabiting this world carries a bomb on his hip as a testament to
his courage.  As a Klingon walks through the grid of squares, His bomb records
the number of each square visited; if the bomb is exposed to that number a
second time, the bomb explodes and the Klingon dies.

A Klingon can traverse squares horizontally or vertically, but not diagonally.
What is the longest path a Klingon can take without dying?"
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    SearchBtn: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    NewBtn: TButton;
    ResetBtn: TButton;
    PrintBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure NewBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
  public
    data:array[0..7,0..7] of integer;  {integer version of grid data}
    used:array [0..25] of boolean; {flags marking used values}
    count,maxcount:integer; {current and max path length counts}
    path,maxpath:array[0..25] of TPoint; {offsets to next square for each move}
    procedure makemovesfrom(col,row:integer; var count:integer); {recursive search}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses printers;

var
  {initial array values for testing}
  d:array[0..7, 0..7] of integer =
   ((6,6,0,6,5,7,16,17),
   (8,2,11,2,12,13,23,12),
   (18,15,18,6,7,3,10,10),
   (15,2,16,13,2,2,2,1),
   (24,17,20,4,3,2,4,13),
   (20,15,15,17,5,11,12,12),
   (2,3,1,20,18,4,5,6),
   (20,7,11,16,23,23,10,20));

{************* Formactivate ****************}
procedure TForm1.FormActivate(Sender: TObject);
var  i,j:integer;
begin
  with stringgrid1 do  {initialze grid with test data}
  for i:=0 to 7 do for j:=0 to 7 do cells[i,j]:=inttostr(d[i,j]);
  randomize;
end;

var  offsets:array[1..4] of TPoint =   {x,y offset for the four move directions}
      ((x:0;y:-1),(x:+1;y:0),(x:0;y:+1),(x:-1;y:0));

{****************** MakeMoveFrom **************}
procedure TForm1.makemovesfrom(col,row:integer;
                        var count:integer);
{Recursive routine to check all valid moves from position passed,
 if found, make the move and calls itself to find the next. After each move,
 check if it makes a new longest path, if so - save it for display purposes}

    function inrange(n:integer):boolean;
    begin result:=(n>=0) and (N<=7); end;

var  i,j,x,y:integer;
begin
  for i:=1 to 4 do   {try all 4 directions}
  begin
    x:=col+offsets[i].x;
    y:=row+offsets[i].y;
    if inrange(x) and inrange(y) 
        and (not used[data[x,y]]) then
    begin
      {this is a valid location - make the new move}
      inc(count);
      path[count]:=point(x,y);
      used[data[x,y]]:=true;
      makemovesfrom(x,y,count); {and make recursive call for next move}
      if count>maxcount then  {new longest path found}
      begin  {save max path info}
        maxcount:=count;
        maxpath:=path;
        listbox1.clear;  {and show the new longest solution}
        listbox1.items.add('Longest path: (Column, Row), Value');
        for j:=0 to count do
        with listbox1 do
        items.add(
        format('%2d  - (%2d,%2d), %2d',
          [j+1, path[j].x+1, path[j].y+1, data[path[j].x,path[j].y]]));
        stringgrid1.invalidate;  {force redraw of new path}
        application.ProcessMessages;
        sleep(1000);
      end;
      {retract the move before checking the next direction}
      used[data[x,y]]:=false;
      dec(count);
    end;
  end;
end;

{***************** SearchBtnClick ********************}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Search for a longest Klingon path}
var i,j,i1,i2:integer;

begin
  screen.cursor:=crhourglass;
  {preload data array as integers from stringgrid}
  for i:=0 to 7 do for j:=0 to 7 do
  begin
    data[i,j]:=strtoint(stringgrid1.cells[i,j]);
  end;
  for i:=1 to 25 do used[i]:=false; {Initialize all values as not visited}
  maxcount:=0;
  for i:=0 to 7 do for j:=0 to 7 do {try all starting points}
  begin
    path[0].x:=i; path[0].y:=j; {save initial positions}
    used[data[i,j]]:=true;
    count:=0;
    {initial call to recursive routine to find longest path}
    makemovesfrom(i,j,count);
    used[data[i,j]]:=false;
  end;
  screen.cursor:=crdefault;
end;

{^^^^^^^^^^^^^ ResetBtnClick **************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{reset path counts and redraw grid}
begin
  count:=0;
  maxcount:=0;
  stringgrid1.invalidate;
  listbox1.Clear;
end;

{*************** StringGrid1DrawCell **************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var i:integer;
{draw the cells with color for current longest path squares}
begin
  with stringgrid1,canvas do
  begin
    brush.color:=clwhite;
    if maxcount>0 then
    for i:= 0 to maxcount do
    begin
      if (maxpath[i].x=acol) and (maxpath[i].y=arow) then
      begin
        brush.color:=clSilver;
        break;
      end;
    end;
    fillrect(rect);
    textout(rect.Left+2, rect.Top+2,cells[acol,arow]);
  end;
end;

{****************** NewBtnClick *************}
procedure TForm1.NewBtnClick(Sender: TObject);
{Make a new random grid}
var i,j:integer;
begin
  for i:=0 to 7 do  for j:=0 to 7 do
  stringgrid1.Cells[i,j]:=inttostr(random(25)+1);
  resetbtnclick(sender);
end;

{******************* PrintBtnClick *****************}
procedure TForm1.PrintBtnClick(Sender: TObject);
{This is the simplest way I know to print a component containing a canvas}
{Save parameters and change as necessary to scale the component to print page size.
 Use PaintTo to print he component.
 Restore the parameters to original values
}

var w,h,dc,df:integer;

begin
  with stringgrid1 do {save and adjust grid sizes for printing}
  begin
    w:=width;
    h:=height;
    dc:=defaultcolwidth;
    df:=canvas.font.Height;
    width:=(printer.PageWidth -20) div 2; {print half page size}
    height:=width;
    defaultcolwidth:=width div 9; {make cells bigger}
    defaultrowheight:=defaultcolwidth;
    canvas.font.height:=3*defaultcolwidth div 4; {make font bigger}
    invalidate; {force redraw}
  end;
  with Printer do {print the grid to default printer}
  begin
    BeginDoc; Stringgrid1.PaintTo(Handle, 10, 10);   EndDoc;
  end;
  with stringgrid1 do  {restore grid values}
  begin
    width:=w;
    height:=h;
    defaultcolwidth:=dc;
    defaultrowheight:=dc;
    canvas.font.Height:=df;
  end;
end;

end.
