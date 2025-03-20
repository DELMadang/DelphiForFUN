unit U_SquaresCubes4;
{Pythagorean Triples problem}
{ Find the  smallest Pythogorean triangle whose
perimeter is a perfect square and  whose area is
a perfect cube.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Memo1: TMemo;
    procedure SolveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
Uses Math;

{$R *.DFM}

Function cubert(a:extended):integer;
Begin
  result:=trunc(power(a, 1/3));
  {If you don;t have the math unit available to get the
   power function, you can substitute
   result:= trunc(exp(ln(a)/3));
   }
   
end;

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  a,b,c,w:integer;
  area,perimeter,x:extended;
  solved:boolean;
  startcount,stopcount, freq:int64;
begin
  solved:=false;
  screen.cursor:=crhourglass;
  QueryPerformanceCounter(startcount);
  For a:=  3 to 1000 do
  {There's probably some better upper limit for b, but I don't know what it is,
   and a-1 is safe}
  for b:=  1 to a-1 do
  Begin
    {Check if a&b form 2 sides of a right triangle}
    w:=sqr(a)+sqr(b);
    c:=trunc(sqrt(w));
    If sqr(c) = w then {it is a Pythagorean triple}
    Begin
      perimeter:=a+b+c;
      x:=trunc(sqrt(perimeter));
      if sqr(x)=perimeter then {perimeter is a square}
      Begin
        area:=(a*b) div 2; {area of a right triangle is half the product odf the 2 short sides}
        x:=trunc(cubert(area));
        if x*x*x=area  {area is a cube!}
        then
        Begin
           QueryPerformanceCounter(stopcount);
           QueryPerformanceFrequency(freq);
           showmessage(' Found! '
                      {reverse a & b for printing so smallest # is first}
                      +' a=' + inttostr(b)
                      +', b=' + inttostr(a)
                      +', c=' + inttostr(c)
                      +#13#13  {new line characters}
                      +format('Run time was %6.1n milliseconds',
                             [(stopcount-startcount)*1000 /freq]));
           QueryPerformanceCounter(startcount);
        end;
      end;
    end; {Pyth. triple}
    If solved then break;
  end;  {a loop}
  screen.cursor:=crdefault;
end;

end.
