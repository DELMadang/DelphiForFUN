unit U_Drawdice;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    DrawDiceBtn: TButton;
    procedure DrawDiceBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************ DrawDie *********}
procedure drawdie(image:TImage; LeftTop:TPoint; diesize, n :integer);
{Draw a single die at "lefttop" with side "diesize" and "n" dots}
var
  colwidth, rowheight:integer;
  dotleft,dottop,dotsize:integer;

    procedure drawdot(col,row:integer);
    {local procedure to draw a single dot}
    begin
      image.canvas.ellipse(lefttop.x+col*colwidth+dotleft,
                           lefttop.y+row*rowheight+dottop,
                           lefttop.x+col*colwidth+dotleft+dotsize,
                           lefttop.y+row*rowheight+dottop+dotsize);
    end;

begin  {drawdie}
  with image do {this will let us automatically refer to properties and
                 methods of image inside the following
                 Begin ... End structure without writing image. each time}
  begin
    {clear the image and draw the outine}
    canvas.brush.color:=clYellow;
    canvas.Pen.color:=clBlack;
    canvas.rectangle(rect(lefttop.x, lefttop.y, lefttop.x+diesize,lefttop.y+diesize));
    canvas.brush.color:=clblack; {set brush to dot color}
    {to draw the dots we will divide the die face into 3 rows and 3 columns and
     put dots in the proper rows and colums for each number}
    colwidth:=diesize div 3;  {column width, 1/3 of image width}
    rowheight:=diesize div 3; {row height, 1/3 of image height}
    dotleft:=colwidth div 4; {we'll put the left side of the dot 1/4 of the way
                              across the column}
    dottop:=rowheight div 4; {and the dot top 1/4 of the way down from the row top}
    dotsize:=colwidth div 2; {make the size of the dot equal 1/2 the column width}
    case n of      {draw a specific number by calling a "drawdot" procedure with
                    the column and row number for each dot in the number.
                    rows and columns are assumed to be numbered 0,1,2}
      1: drawdot(1,1); {draw a simgle dot in the middle column and row}
      2: begin         {draw 2 dots, top left and bottom righht}
           drawdot(0,0);
           drawdot(2,2);
         end;
      3: begin       {etc.}
           drawdot(0,0);
           drawdot(1,1);
           drawdot(2,2);
         end;
      4: begin
           drawdot(0,0);
           drawdot(0,2);
           drawdot(2,0);
           drawdot(2,2);
         end;
      5: begin
           drawdot(0,0);
           drawdot(0,2);
           drawdot(1,1);
           drawdot(2,0);
           drawdot(2,2);
         end;
      6: begin
           drawdot(0,0);
           drawdot(0,1);
           drawdot(0,2);
           drawdot(2,0);
           drawdot(2,1);
           drawdot(2,2);
         end;
    end; {case}
  end;
end;

{*********** DrawDiceBtnClick *********}
procedure TForm1.DrawDiceBtnClick(Sender: TObject);
var size, offset:integer;
begin
  image1.canvas.brush.color:=color;
  with image1 do canvas.fillrect(clientrect);
  size:=9*image1.height div 10; {make size 90% of height}
  offset:=image1.height div 20; {make offset 5% of height}
  drawdie(image1, point(offset,offset),size,random(6)+1); {draw 1st die}
  drawdie(image1, point(offset+image1.width div 2,offset),size,random(6)+1); {draw 2nd}
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  RANDOMIZE;  {start with a random seed so results do not repeat from run ro run}
              {for testing it is often a good idea not to set the random seed}
end;

end.
