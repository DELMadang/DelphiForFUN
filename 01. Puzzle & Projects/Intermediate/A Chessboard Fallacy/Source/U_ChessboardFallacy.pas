unit U_ChessboardFallacy;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Cut an 8 x 8  chessboard per instructions here and shift two pieces to make
 a new 7 x 9 board that contains only 63 squares!   Unlike some cutting puzzles,
 the angles are correct and the new pieces fit perfectly!}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ExtCtrls, ComCtrls;
  {arrange digits 1-9 so that each two consecutive integers considered as a
   two digit number is divisible by a number from 1-9}

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    ResetBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Oopsmemo: TMemo;
    OopsMemo2: TMemo;
    StatusBar1: TStatusBar;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    w:integer;
    pass:integer;
    m,b:single; {slope and intercept of diagonal line}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{***************8 FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  resetbtnclick(sender);
  pass:=1;
end;

{******************** Button1Click *************}
procedure TForm1.Button1Click(Sender: TObject);
{Draw the main cutline}
begin
  with image1, canvas do
  begin
    pen.color:=clred;
    moveto (width-7*w, height-8*w);
    lineto (width,height);
  end;
  button1.enabled:=false;
  button2.enabled:=true;
end;

{**************** Button2Click *************}
procedure TForm1.Button2Click(Sender: TObject);
{Shift the cutoff right hand triangle up and left}
var
  i,j:integer;
  topp:TPoint;
begin
  if pass=1 then {draw the fake image}
  begin
    with image1,canvas do
    begin {shift the large top right triangle up and over}
      brush.color:= clgreen;
      pen.color:=clblack;
      fillrect(clientrect);

      for i:=1 to 7 do {redraw a 7 x 9 baord}
      for j:=0 to 8 do
      begin
        if (i+j) mod 2 = 0 then brush.color:=clwhite
        else brush.color:=clblack;
        rectangle(width-w*i,height-w*j-w,width-w*(i+1),height-w*j);
      end;


      pen.color:=clred; {draw the cut, cheat a little}
      moveto (width-8*w, height-9*w);
      lineto (width-3,height);


      {put a border around the whole 7 x 9 board to limit coming floodfills}
      brush.color:=clred;
      framerect(rect(width-8*w,height-9*w,width-w,height));

      brush.color:=clgreen; {erase the top left small triangular hole}
      floodfill(width-8*w+2,height-9*w+4,clblack,fsSurface);
      update;

      brush.color:=clwhite; {Fill in the bottom right triangular piece}
      floodfill(width-w+2,height-5,clgreen,fsSurface);

      brush.color:=clblack;
      framerect(rect(width-8*w,height-9*w,width-w,height));

      pen.color:=clgreen;
      moveto(width-8*w,height-9*w);
      lineto(width-8*w,height-8*w);
    end
  end
  else {pass 2 - draw the real image}
  with image1,canvas do
  begin {the cut is steeper than 45 degrees, so when we slide over by
           one square, we really shift up by more than one square (1 1/7
           to be exact) So the final height of the new chessboard is 9 1/7
           units ,aking the area 7 X 9 1/7 = 64 units) }
    m:=8/7;
    b:=height-m*(width-w);
    brush.color:= clgreen;
    pen.color:=clblack;
    fillrect(clientrect);

    {draw top half}
    topp:=point(width-8*w, height-9*w - w div 7);
    polygon([topp,
             point(width-w,topp.y),
             point(width-w,height-w - w div 7)]);
    for i:=1 to 6 do
    begin  {vertical boundaries for squares}
      moveto(topp.x+i*w,topp.y);
      lineto(topp.x+i*w,round(m*(topp.x+(i-1)*w)+b));
    end;
    for i:=1 to 8 do
    begin  {horizontal boundaries for squares}
      moveto(width-w, topp.y+i*w);
      lineto(round(topp.y+((i+1)*w-b)/m),topp.y+i*w);
    end;
    {fill in top squares by referencing top right corners of squares
     since the truncated corners will be bottom-left}

     for j:=0 to 7 do
     for i:=j to 7 do
     begin
       If (i+j) mod 2 = 0 then brush.color:=clwhite
       else brush.color:=rgb(12,12,12); {almost black}
       if (j>0) or (i>0) then
       floodfill(topp.x+i*w-1,topp.y+j*w+1,clblack,fsborder);
     end;

    {now draw bottom half of the board}
    brush.color:=clgreen;
    polygon([point(width-8*w,height-8*w),
           point(width-8*w,height),
           point(width,height),
           point(width-7*w,height-8*w)]);

    topp.x:=width-7*w; topp.y:=height-8*w;
    b:=height-m*width;
    for i:=0 to 6 do
    begin  {verticals}
      moveto(topp.x+i*w,height);
      lineto(topp.x+i*w,round(m*(topp.x+i*w)+b));
    end;
    for i:=1 to 8 do
    begin  {horizontals}
      moveto(width-8*w, topp.y+i*w);
      lineto(round((topp.y+(i)*w-b)/m),topp.y+i*w);
    end;

    {fill in bottom half squares by referencing bottom left corners of squares
     since the truncated corners will be top-right}
    for j:=1 to 8 do
    for i:=0 to j do
    begin
      If (i+j) mod 2 = 1 then brush.color:=clwhite
      else brush.color:=rgb(12,12,12); {almost black}
      floodfill(topp.x+(i-1)*w+1,topp.y+j*w-1,clblack,fsborder);
    end;

    pen.color:=clred; {redraw the cut line}
    moveto (width-8*w, height-9*w - w div 7);
    lineto (width-w,height-w- w div 7);
  end;
  button2.enabled:=false;
  button3.enabled:=true;
end;

{******************** Button3Click *************}
procedure TForm1.Button3Click(Sender: TObject);
{Move the small triangle to th hole in the top left corner of board}
var  i,j:integer;
begin
  with image1,canvas do
  if pass=1 then {redraw everything the way we want the viewer to think
                  things look - a 7x9 chessboard}
  begin
    brush.color:= clgreen;
    pen.color:=clblack;
    fillrect(clientrect);

    for i:=1 to 7 do
    for j:=0 to 8 do
    begin
      if (i+j) mod 2 = 0 then brush.color:=clwhite
      else brush.color:=clblack;
      rectangle(width-w*i,height-w*j-w,width-w*(i+1),height-w*j);
    end;

    pen.color:=clred;
    brush.color:=clwhite;
    polygon([point(width-8*w+1,height-9*w),
             point(width-8*w+1,height-8*w),
             point(width-7*w-3,height-8*w)]);

    pen.color:=clred;
    moveto (width-8*w, height-9*w);
    lineto (width-w,height-w);
    oopsmemo.visible:=true;
    oopsmemo.bringtofront;
  end
  else  {OK, the joke is over,  draw the final board the way it really is
         -  a 7 x 9 1/7 chessboard with 64 squares, some of them chopped up}
  begin
    {erase the lower triangle}
    {First outline it in green}
    pen.color:=clgreen;
    moveto(width-w,height-w-w div 7);
    lineto(width-w, height);
    brush.color:=clgreen;
    floodfill(width-w+1,height-2,clgreen,fsborder);

    {fill in the upper triangle}
    pen.color:=clred;
    brush.color:=clwhite;
    moveto(width-8*w,height-9*w - w div 7);
    lineto(width-8*w,height-8*w);
    floodfill(width-8*w+1,height-8*w-1,clgreen, fsSurface);
    brush.color:=rgb(12,12,12);
    pen.color:=clblack;
    moveto(width-8*w,height-9*w);
    lineto(width-8*w+round(w/7/m),height-9*w);
    floodfill(width-8*w+1,height-9*w-1,clwhite, fsSurface);

    pen.color:=clred; {redraw the cut line}
    moveto (width-8*w, height-9*w - w div 7);
    lineto (width-w,height-w- w div 7);

    oopsmemo2.visible:=true;
    oopsmemo2.bringtofront;
  end;
  button3.enabled:=false;
  if pass=1 then pass:=2 else pass:=1;
end;

{****************** ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  w:=42;
  with image1,canvas do
  begin
    brush.color:= clgreen;
    pen.color:=clblack;
    rectangle(clientrect);
    for i:=0 to 7 do
    for j:=0 to 7 do
    begin
      if (i+j) mod 2 = 0 then brush.color:=clwhite
      else brush.color:=clblack;
      rectangle(width-w*i,height-w*j,width-w*(i+1),height-w*(j+1))
    end;
  end;
  oopsmemo.visible:=false;
  oopsmemo2.visible:=false;
  button1.enabled:=true;
end;

{************** Buttojn5click **************}
procedure TForm1.Button5Click(Sender: TObject);
{temp - save images}
begin
  image1.picture.bitmap.savetofile('Chess'+inttostr(trunc(frac(now)*secsperday))
                                    +'.bmp');
end;

end.
