unit U_MagicSquare1;
{Finds magic squares of odd size using an algorithm
developed by Cornelius Agrippa around 1500 or De La Loubere - date unknown (by me)
as follows:
"Start with 1 in the middle of the top row; then go up
and left assigning numbers in increasing order to
empty cells; if you fall off of the square imagine
the same square as tiling the plane and continue; if a
cell is occupied, move down instead and
continue."}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, Grids, DFFUtils;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    StringGrid1: TStringGrid;
    CalcBtn: TBitBtn;
    IntEdit1: TEdit;
    Memo1: TMemo;
    SumLbl: TLabel;
    StaticText1: TStaticText;
    procedure CalcBtnClick(Sender: TObject);
    procedure IntEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Function isodd(n:integer):boolean;
Begin
  if n mod 2 =0 then result:=false
  else result:=true;
end;

procedure TForm1.CalcBtnClick(Sender: TObject);
var
  i,j,count,order,size:integer;
  oldi,oldj:integer;
  maxChars:integer;
begin
  order:=strtoint(intedit1.text);
  if (isodd(order)) and (order<=51) then
  begin
    with stringgrid1 do
    begin
      {initialize things}
      rowcount:=order;
      colcount:=order;
      for i:=0 to colcount-1 do
      for j:=0 to rowcount-1 do cells[i,j]:='';
      size:=order*order;
      {make font size bigger for small squares, smaller for big squares}
      if size<100 then font.size:=12 else font.size:=8;
      {now we have to adjust cell size appropriately for the font}
      canvas.font:=font;
      {A bit tricky here: 1st find # characters in the largest number}
      maxchars:=length(inttostr(size));
      {Then find pixel length of that many of a wide charcter (e,g,'W'}
      defaultcolwidth:=canvas.textwidth(stringofchar('W',maxchars))+ 4;
      defaultrowheight:=canvas.TextHeight('W')+4;
      if defaultcolwidth<defaultrowheight then defaultcolwidth:=defaultrowheight;
      adjustgridsize(stringGrid1);
      
      {make the grid size match the sum of the cells + grid lines sizes}
      i:=order div 2; {center of top row}
      j:=0;
      count:=0;
      repeat
        inc(count);
        cells[i,j]:=inttostr(count); {get next number}
        if count<size then
        Begin
          oldi:=i;
          dec(i);   {move up}
          if i<0 then i:=order-1; {loop around if necessary}
          oldj:=j;
          dec(j); {and left}
          if j<0 then j:=order-1; {loop around if necessary}
          if cells[i,j]<>'' then {occupied?}
          Begin
            i:=oldi;
            j:=oldj+1; {move down instead}
            if j>order then j:=0;
          end;
          if cells[i,j]<>'' then showmessage('Algorithm error');
        end;
      until count=size;
    end;
    {Sum is always (order^3+order) div 2}
    SumLbl.caption:='Sum of each row, col, and diagonal is '
                    +inttostr((size*order+order) div 2);
    Sumlbl.visible:=true;
  end
  else beep;
end;



procedure TForm1.IntEdit1KeyPress(Sender: TObject; var Key: Char);
{make sure only digits or backspace alpha keys are pressed}
begin
  If not (key in ['0'..'9',#8 {backsapace}]) then
  begin
    key:=#0;
    beep;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
   windowstate := wsMaximized; {make form full size}
end;

end.
