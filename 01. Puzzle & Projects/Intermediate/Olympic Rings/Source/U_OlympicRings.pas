unit U_OlympicRings;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Olympic ring puzzle -
   The five Olympic rings overlap to create 9
   separate  areas.  Assign the digits 1 through
   9 to the areas so that the numbers in each
   circle sum to the same value.
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, UMakeCaption;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Solvebtn: TButton;
    Memo1: TMemo;
    PrintBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure SolvebtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  public
    procedure drawrings;
    procedure drawcircle(c:TPoint;radius:integer; rcolor:TColor);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  {an array of values to display in the 9 ring areas,
   letters initially, then solution values}
  fields:array[1..9] of char =('A','B','C','D','E','F','G','H','I');

procedure TForm1.drawcircle(c:TPoint;radius:integer; rcolor:TColor);
{draw one ring}
begin
  with image1.canvas do
  begin
    pen.color:=rcolor;
    brush.style:=bsclear;
    ellipse(c.x-radius,c.y-radius,c.x+radius,c.y+radius);
  end;
end;

procedure Tform1.drawrings;
{draw all five rings and label the areas}
var
  radius,topy,bottomy,x:integer;
  c1,c2,c3,c4,c5:TPoint;
begin
  with image1, canvas do
  begin
    brush.style:= bsSolid;
    fillrect(clientrect);
    font.style:=[fsBold];
    pen.width:=8;
    radius:=height div 3-10;
    topy:= height div 3;   {top row y}
    bottomy:= 2*height div 3; {bottom row y}
    x:=width div 6; {ring 1}
    c1:=point(x,topy);
    drawcircle(c1,radius,clblue);
    textout(c1.x-5,c1.y-5,fields[1]);
    x:=2* width div 6; {ring 2}
    c2:=point(x,bottomy);
    drawcircle(c2,radius,clyellow);
    textout((c1.x+c2.x) div 2-5,
            (c1.y+c2.y) div 2-5, fields[2]);
    textout(c2.x-5,c2.y-5,fields[3]);
    x:=3*width div 6;  {ring 3}
    c3:=point(x,topy);
    drawcircle(c3,radius,clblack);
    textout((c3.x+c2.x) div 2-5,
            (c3.y+c2.y) div 2-5, fields[4]);
    textout(c3.x-5,c3.y-5,fields[5]);
    x:=4*width div 6;  {ring 4}
    c4:=point(x,bottomy);
    drawcircle(c4,radius,clgreen);
    textout((c3.x+c4.x) div 2-5,
            (c3.y+c4.y) div 2-5, fields[6]);
    textout(c4.x-5,c4.y-5,fields[7]);
    x:=5*width div 6; {ring 5}
    c5:=point(x,topy);
    drawcircle(c5,radius,clred);
    textout((c5.x+c4.x) div 2-5,
            (c5.y+c4.y) div 2-5, fields[8]);
    textout(c5.x-5,c5.y-5,fields[9]);

     {This is cool!}
    {draw the arcs to get the interlocked rings effect!}
    {arc stop and stop coordinates determined by eyeball}
    {drawing from ring 4 back down to ring 1 eliminates artifacts}
    pen.color:=clgreen;
    arc(c4.x-radius, c4.y-radius, c4.x+radius, c4.y+radius,
        c4.x+radius, c4.y-radius div 2, c4.x,c4.y-radius);
    pen.color:=clblack;
    arc(c3.x-radius, c3.y-radius, c3.x+radius, c3.y+radius,
        c3.x+radius, c3.y+radius div 2, c3.x+radius,c3.y-radius div 2 );
    pen.color:=clyellow;
    arc(c2.x-radius, c2.y-radius, c2.x+radius, c2.y+radius,
        c2.x+radius, c2.y-radius div 2, c2.x,c2.y-radius);
    pen.color:=clblue;
    arc(c1.x-radius, c1.y-radius, c1.x+radius, c1.y+radius,
        c1.x+radius, c1.y+radius , c1.x+radius,c1.y-radius);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
{draw inital image}
begin
  makecaption('Olympic Puzzle',#169+' 2002, G. Darby, www.delphiforfun.org',self);
  drawrings;
end;

procedure TForm1.SolvebtnClick(Sender: TObject);
{A not very elegant, but striaghtforawrd solution technique:
 Just try all 9 values for each of the 9 variables, making
 sure that each set tested has unique values}
 {The equations to be solved are
  a+b=b+c+d=d+e+f=f+g+h=h+i
  or, by elimination,
    a=c+d
    b+c=e+f
    d+e=g+h
    f+g=i
  }

var
  a,b,c,d,e,f,g,h,i:integer;
  r:integer;
  pos:TPoint;
begin
  r:=mrOK;
  for a:=1 to 9 do
   for b:=1 to 9 do
   begin
     if b=a then continue; {skip duplicates}
     for c:=1 to 9 do
     begin
       if (c=b) or (c=a) then continue; {skip duplicates}
       for d:=1 to 9 do
       begin
         if (d=c) or (d=b) or (d=a) then continue;
         for e:=1 to 9 do
         begin
           if (e=d) or (e=c) or (e=b) or (e=a) then continue;
           for f:=1 to 9 do
           begin
             if (f=e) or (f=d) or (f=c) or (f=b) or (f=a) then continue;
             for g:=1 to 9 do
             begin
               if (g=f) or (g=e)
               or (g=d) or (g=c) or (g=b) or (g=a) then continue;
               for h:=1 to 9 do
             begin
               if (h=g) or (h=f) or (h=e)
               or (h=d) or (h=c) or (h=b) or (h=a) then continue;
               for i:= 1 to 9 do
               begin
                 if r=mrcancel then break;
                 if (i=h) or (i=g) or (i=f) or (i=e)
                 or (i=d) or (i=c) or (i=b) or (i=a) then continue;
                 if (a=c+d) and (b+c=e+f) and (d+e=g+h)
                 and(f+g=i)then
                 begin
                    fields[1]:=char(ord('0')+a);
                    fields[2]:=char(ord('0')+b);
                    fields[3]:=char(ord('0')+c);
                    fields[4]:=char(ord('0')+d);
                    fields[5]:=char(ord('0')+e);
                    fields[6]:=char(ord('0')+f);
                    fields[7]:=char(ord('0')+g);
                    fields[8]:=char(ord('0')+h);
                    fields[9]:=char(ord('0')+i);
                    drawrings;
                    pos:=clienttoscreen(point(solvebtn.left,solvebtn.top));
                    r:=messagedlgpos('Solution found.'
                                +#13+'Press OK to continue search',
                                 mtInformation,
                                 [mbOK,mbcancel],0,
                                 pos.x,pos.y);

                 end;
               end;
             end;
           end;
         end;
       end;
     end;
   end;
 end;
end;

procedure TForm1.PrintBtnClick(Sender: TObject);
{simplest way to print - print the entire form}
var i:integer;
begin
   {clean up some stuff for printing}
   memo1.color:=clwhite;
   color:=clwhite;
   if fields[1]='A' {blank out letters for printing, but not solutions}
   then for i:= 1 to 9 do fields[i]:=' ';
   drawrings;
   solvebtn.visible:=false;
   printbtn.visible:=false;
   print;
   {and put it back the way it was}
   memo1.color:=clyellow;
   color:=clBtnFace;
   If fields[1]=' '
   then for i:=1 to 9 do fields[i]:=char(ord(pred('A'))+i);
   drawrings;
   solvebtn.visible:=true;
   printbtn.visible:=true;
end;

procedure TForm1.Button1Click(Sender: TObject);
{temprary button provedure to save image for the web page}
begin
  image1.Picture.bitmap.pixelformat:=pf24bit;
  image1.picture.savetofile('olympicrings.bmp');
end;

end.
