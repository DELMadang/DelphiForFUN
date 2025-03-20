unit U_PrintGridTest;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Test the PrintGrid procedure by printing a randomly filled string grid a
 number of times on a page with Printgrid determining the scaling based on the
 vertical space allocated for each.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, Printers, ExtCtrls, UPrintGrid, Spin, ShellAPI;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    PrintBtn: TButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    StaticText1: TStaticText;
    Memo1: TMemo;
    procedure PrintBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    public
      procedure FillGrid;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization stuff}
begin
  randomize;
  {drawcell exit needs canvas font set to grid font}
  with stringgrid1 do canvas.font:=font;
  Fillgrid; {fill initial grid with random values}
end;

{****************  FillGrid **************}
procedure TForm1.FillGrid;
{Fill the stringgrid with random 2 digit numbers}
var
  i,j:integer;
begin
  with stringgrid1 do
  begin
    for i:=0 to colcount-1 do
    for j:=0 to rowcount-1 do
      cells[i,j]:=format('%2.2d',[random(99)+1]);
    invalidate;  {force redraw now}
    application.processmessages;
  end;
end;

{************** Stringgrid1DrawCell ****************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Draw the grid cells (without the "selected" highlight}
var w,h:integer;
begin
  with tstringgrid(sender), canvas, rect do
  begin
    fillrect(rect); {clear the cell display}
    {calculate start to center the number
    in the available "white space" in the cell
    }
    w:=(defaultcolwidth-textwidth(cells[acol,arow]));
    h:=(defaultrowheight-textheight(cells[acol,arow]));
    {add half of the white space to left and top fpr display}
    textout(left+w div 2, top+h div 2, cells[acol,arow]);
  end;
end;

{************* PrintBtnClick **********}
procedure TForm1.PrintBtnClick(Sender: TObject);
{Print from 1 to 10 random stringgrids on a page, with scaling based on
 the number toi be printed}
var
  starty,spacing, gridprintheight:integer;
  i:integer;
begin
  with printer do
  begin
    begindoc;
      starty:=Yoffset; {Start at the physical minimum top of page offset}

      {"spacing" is the vertical pixels space allowed on the page for each grid}
      spacing:=(pageheight -2*Yoffset) div spinedit1.value;

      for i:=1 to spinedit1.value do
      begin
        {printed grid height = 1/N pageheight minus a little white space}
        gridprintheight:=spacing - 20;  {height = spacing  minus a little room for white space}
        {Print the stringgrid}
        printGrid(Stringgrid1,Xoffset,starty,pagewidth,gridprintheight);

        starty:=starty+spacing; {move to next print space}
        fillgrid;  {generate a new set of numbers}
      end;
    enddoc;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
                nil, nil, SW_SHOWNORMAL) ;
end;

end.
