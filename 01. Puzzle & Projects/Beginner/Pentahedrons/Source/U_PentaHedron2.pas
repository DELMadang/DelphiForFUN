unit U_PentaHedron2;
  {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ The city fathers recently decided that the square pyramidal stack of civil war
 cannonballs in front of the courthouse might come tumbling down and bowl over
 some of the kiddies that loved to play there,   But it would be OK if they
 were laid some arrangement flat on the ground.

 By a miraculous coincidence, when the stack was disassembled,  they could be
 laid out flat to form a perfect square!  How many cannonballs were in the stack?
}

{This version adds 3D graphic images of the pyramids as they are generated}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Image1: TImage;
    Memo1: TMemo;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    procedure drawlayer(sleft,sbottom,incr,balls:integer);
    procedure drawpyramid(b,hincr:integer);
  end;

var  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.SolveBtnClick(Sender: TObject);
var i,sum,n:integer;
begin
  sum:=1;
  for i:= 2 to 100 do
  begin
    sum:=sum+i*i;
    n:=trunc(sqrt(sum));
    drawpyramid(i,11);
    with image1, canvas do
    begin
     brush.color:=clwindow;
     font.size:=10;
     textout(10,10,
         'A stack with '+Inttostr(i)+' balls on each side of the lowest '
             +' layer would contain ' +inttostr(sum)+ ' balls');
      update;  {update the display}
    end;
    if n*n=sum then  {solved!}
    begin
      with image1.canvas do
      begin
        textout(10,10, 'Solved!, There were '+inttostr(sum)
           + ' balls arranged in a square pyramid '+inttostr(i)
           + ' layers high.');
        textout(10,30,'No wonder they were concerned! (Layed out flat they made a '+inttostr(n)+' by '
           + inttostr(n)+' square)' );
      end;
      break;  {break out of the loop}
    end;
    sleep(1000);
  end;
end;

{*************  DrawPyramid ******************}
procedure TForm1.drawpyramid(b,hincr:integer);
{Draw all layers of a square pyramid with b balls in the bottom layer}
var  i:integer;
begin
  with image1.canvas do rectangle(clientrect);
  for i:= 0 to b-1 do drawlayer(trunc(45+i*6.46),trunc(300-10.5*i), hincr,b-i);
end;

procedure TForm1.drawlayer(sleft,sbottom,incr, balls:integer);
{draw one layer of a square pyramid}
var
  i,n:integer;
  backleft, backtop,bx,by:integer;
begin
  with image1, canvas do
  begin
    brush.color:=claqua;
    {draw rows from back to front}
    for n:=balls downto 1 do
    begin
      backleft:=trunc(sleft+ 2.5*n);
      backtop:=trunc(sbottom-6.5*n);
      bx:=backleft; by:=backtop;
      for i:= 1 to balls do
      begin
        ellipse(bx,by,bx+incr,by+incr);
        bx:=trunc(backleft+11*i);
        by:=trunc(backtop+1.3*i);
      end;
    end;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  doublebuffered:=true; {prevent blinking during image updates}
end;

end.
