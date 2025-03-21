unit U_Drawdice;

interface

uses
  SysUtils,
  Classes,
  Types,

  Graphics,
  Controls,
  Forms,
  StdCtrls,
  ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    DrawDiceBtn: TButton;
    procedure DrawDiceBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure DrawDie(image: TImage; LeftTop: TPoint; diesize, n: Integer);
var
  colwidth, rowheight: Integer;
  dotleft, dottop, dotsize: Integer;

  procedure DrawDot(col, row: Integer);
  begin
    image.Canvas.Ellipse(lefttop.x+col*colwidth+dotleft,
                         lefttop.y+row*rowheight+dottop,
                         lefttop.x+col*colwidth+dotleft+dotsize,
                         lefttop.y+row*rowheight+dottop+dotsize);
  end;

begin
  with image do
  begin
    {clear the image and draw the outine}
    Canvas.Brush.Color := clYellow;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(Rect(lefttop.x, lefttop.y, lefttop.x+diesize,lefttop.y+diesize));
    Canvas.Brush.Color := clblack; {set brush to dot color}

    {to draw the dots we will divide the die face into 3 rows and 3 columns and
     put dots in the proper rows and colums for each number}
    colwidth := diesize div 3;  {column width, 1/3 of image width}
    rowheight := diesize div 3; {row height, 1/3 of image height}
    dotleft := colwidth div 4;  {we'll put the left side of the dot 1/4 of the way across the column}
    dottop := rowheight div 4; {and the dot top 1/4 of the way down from the row top}
    dotsize := colwidth div 2; {make the size of the dot equal 1/2 the column width}

    case n of
    1:
      begin
        {draw a simgle dot in the middle column and row}
        DrawDot(1, 1);
      end;
    2:
      begin
        {draw 2 dots, top left and bottom righht}
        DrawDot(0, 0);
        DrawDot(2, 2);
      end;
    3:
      begin
        {etc.}
        DrawDot(0, 0);
        DrawDot(1, 1);
        DrawDot(2, 2);
      end;
    4:
      begin
        DrawDot(0, 0);
        DrawDot(0, 2);
        DrawDot(2, 0);
        DrawDot(2, 2);
      end;
    5:
      begin
        DrawDot(0, 0);
        DrawDot(0, 2);
        DrawDot(1, 1);
        DrawDot(2, 0);
        DrawDot(2, 2);
      end;
    6:
      begin
        DrawDot(0, 0);
        DrawDot(0, 1);
        DrawDot(0, 2);
        DrawDot(2, 0);
        DrawDot(2, 1);
        DrawDot(2, 2);
      end;
    end;
  end;
end;

procedure TForm1.DrawDiceBtnClick(Sender: TObject);
var
  size, offset: Integer;
begin
  image1.Canvas.Brush.Color := color;
  with image1 do
    Canvas.FillRect(ClientRect);

  size := 9*image1.height div 10; {make size 90% of height}
  offset := image1.height div 20; {make offset 5% of height}

  DrawDie(image1, Point(offset, offset), size, random(6)+1); {draw 1st die}
  DrawDie(image1, Point(offset+image1.width div 2, offset), size, random(6)+1); {draw 2nd}
end;

initialization
  Randomize;
end.
