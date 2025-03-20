unit U_HexBoards;
{Copyright © 2016, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

Interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, Dialogs, Graphics,
  Spin, jpeg;

type
  TPolygon= array of TPoint;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    GoBtn: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    FigureGrp: TRadioGroup;
    countGrp: TRadioGroup;
    DiameterEdt: TSpinEdit;
    Label1: TLabel;
    Image2: TImage;
    OrientationGrp: TRadioGroup;
    PuzzleBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure GoBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure PuzzleBtnClick(Sender: TObject);
  public
    hintlocs:array[0..5] of TPoint;  {location of the hint tile if 19 tole puzzle board}
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses Math;

{************* FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  with image1, canvas do
  begin
    brush.color:=clMoneyGreen;
    rectangle(clientrect);
  end;
end;

{************* GoBtnClick ************}
procedure TForm1.GoBtnClick(Sender: TObject);
{On the Image canvas, draw a hexaonal pattern of closely spaced circles or
  hexagons.  Starting with a single hexagon tile , 6 hexagon tiles of the same
  size can be packed around forming a latger hexagonal pattern with 7 tiles.  Each
  succeeding set of surrounding tiles will have 6 more than the preceeding set.
  The number of tiles in any such pattern will with N tiles per side will
  contain 3N^2-3N+1 tiles}

  var
    row,col:integer;
    w,h:integer;
    c:TPoint;
    x,y,yUp,yDown,xLeft,xRight, LeftX, Topy:integer;
    LongRowOrColLength, radius, diameter:integer;
    RowOffset, ColOffset:integer;
    index:integer;
    showhints:boolean;
  {------------ MakeHexagon -------------}
  function makehexagon(cx,cy,r,angle:integer):Tpolygon;
  {define a hexagon as a TPolygon instance with center at (cx,cy), radius "r"
  and one vertex at angle "angle" degrees from horizontal}
  var
    i:integer;
    a,a60:extended;
  begin
    setlength(result,6);
    a:=Pi*angle/180; {initial vertex angle}
    a60:=Pi/3; {60 degree angle step from center to next vertex}
    for i:=0 to 5 do
    with result[i] do
    begin
      x:=cx+round(r*cos(a));
      y:=cy+round(r*sin(a));
      a:=a+a60;
    end;
  end;

  {------------- DrawTile ----------}
   procedure Drawtile(x,y,angle:integer; s:string);
   {Draw circle or hexagon based on option set}
   var
     w,h:integer;
   begin
     with image1.Canvas do
     begin
       brush.Color:=rgb(250,250,221);
       if figuregrp.itemindex=0 {circles}
       then ellipse(x-radius, y-radius, x+radius, y+radius)
       else polygon(makehexagon(x,y,radius+4 {overlap a little},angle)); {one of the vertices is vertical}
       if showhints then
       begin  {These letters represent the 6 corners of the board found by
       assigning a unique letter to the each tile, displaying the letters
       temporarity ,selecting the letters corresponding to the known solution
       corner values, and replaceing the letters with the solution values.
       All other letters replace with blanks}
         case s[1] of
           'N': s:='16';
           'R': s:='3';
           'A': s:='10';
           'E': s:='18';
           'O': s:='15';
           'S': s:='9';
           else s:=' ';
         end;
         w:=textwidth(s);
         h:=textheight(s);
         textout(x-w div 2,y-h div 2, s);
       end;
     end;
   end;

begin {GoBtnClick}
  {set option to display hint values (or not)}
  if sender=PuzzleBtn then showhints:=true else showhints:=false;

  with image1,canvas do
  begin
    brush.color:=clMoneyGreen;
    rectangle(clientrect);
    w:=width;
    h:=height;
    c:=point(w div 2, h div 2);    {center of the board area}
    radius:=diameterEdt.value div 2;
    diameter:=2*radius;
    font.Height:=-radius;  {make the hint text equal to half the diameter of the tile}
    index:=0; {use this to generate andex value of each tile in case we need to display hints}
    LongRowOrColLength:= 2*Countgrp.itemindex+1; {# of rows and # of tiles in middle row}
    If orientationGrp.itemindex=0  then
    begin
      LeftX:=c.x-(LongRowOrColLength div 2)*diameter;
      for row := 0 to LongRowOrColLength div 2  do
      begin
        x:=leftX + row*radius;
        {vertical spacing = diameter reduced by circle or hexagon overlap (sin(60 degrees)}
        rowOffset:=trunc(0.866*row*diameter);
        yUp:= c.Y - rowOffset;
        yDown:=c.Y + rowOffset;
        for col:= 0 to LongRowOrColLength-row-1 do
        begin
          drawtile(x,yUp,30, char(ord('A')+index));
          inc(index);
          if row>0 then
          begin
            drawtile(x,yDown,30,char(ord('A')+index));{row 0 is the middle row, no need to redraw it!}
            inc(index);
          end;
          inc(x,diameter);  {move to next column}
        end;
      end;
    end
    else
    begin  {board rotated 30 degrees so long diagonal become the long vertical column}
      Topy:=c.y - (LongRowOrColLength div 2)*diameter;
      for col := 0 to LongRoworColLength div 2  do
      begin
        y:=TopY + col*radius;
        {horizontal spacing = diameter reduced by circle or hexagon overlap (sin(60 degrees)}
        colOffset:=trunc(0.866*col*diameter);
        xLeft:= c.x - colOffset;
        xRight:=c.x + colOffset;
        for row:= 0 to LongRowOrColLength-col-1 do
        begin
          drawtile(xleft,y,0,char(ord('A')+index)); {rotate hexagons back by 30 degrees to keep them upright}
          inc(index);
          if col>0 then
          begin
            drawtile(xright,y,0,char(ord('A')+index));{column 0 is the middle column, no need to redraw it!}
            inc(index);
          end;
          inc(y,diameter);  {move to next row}
        end;
      end
    end;
  end;
end;

procedure TForm1.PuzzleBtnClick(Sender: TObject);
begin
  Countgrp.Itemindex:=2; {select 19 tile version}
  GoBtnClick(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
