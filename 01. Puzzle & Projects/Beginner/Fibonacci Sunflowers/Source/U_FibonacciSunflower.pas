unit U_FibonacciSunflower;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved }
 
 {Just fooling around with Fibonacci sunflowers}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    DrawBtn: TButton;
    Memo1: TMemo;
    RotateRBox: TRadioGroup;
    StyleBox: TRadioGroup;
    procedure DrawBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    midx, midy:integer;
    procedure Circle(centerRadius,CenterAngle:real; r:integer);
  end;

var
  Form1: TForm1;

implementation
{$R *.DFM}

procedure TForm1.Circle(centerRadius,CenterAngle:real; r:integer);
{Draw a circle centered at CenterRadius, CenterAngle from image center,
 radius of cirdle drawn is r}
var
  x,y:integer;
begin
  with image1,canvas do
  begin
    x:=trunc(midx+CenterRadius*cos(CenterAngle));
    y:=trunc(midy+CenterRadius*sin(CenterAngle));
    ellipse(x-r,y-r,x+r,y+r);
  end;
end;

procedure TForm1.DrawBtnClick(Sender: TObject);
{Draw a sunflower}
var
  i,j,k,r:integer;
  phi,IncA:real;
begin
  r:=5;
  phi:=(1+sqrt(5.0))/2;
  case rotateRbox.itemindex of {set angle increment for center of seed}
    0: IncA:=2*Pi*Phi;
    1: IncA:=2*pi*(21/34);
    2: IncA:=2*pi*(34/55);
  end;
  midx:=image1.width div 2;
  midy:=image1.height div 2;
  image1.canvas.brush.color:=clwhite; {clear the image area}
  with image1 do canvas.rectangle(clientrect);
  image1.canvas.brush.color:=clyellow;
  for i:= 0 to 900 do  {Arbitrary big number of seeds to create}
  begin
    case stylebox.itemindex of
    0: circle(sqrt(i)*r,i*IncA,r); {fixed seed size moving outward by sqrt(i)}
    1: circle(i*r/22,IncA*i,trunc(r*(i/500))); {increasing seed size - just trial and error numbers}
    end;
    if i mod 16 = 0 then application.processmessages; {redraw once in a while}
  end;
end;

end.
