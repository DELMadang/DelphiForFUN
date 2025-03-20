unit U_LeastSquares;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {
 A program to find the best fit linear least squares  line for a given set of
 X,Y points. This is the unique line which minimizes the sum of squares of the
 differences between  the Y value for each X point and the Y value for the line
 at that X.  Whew!

New points may be pasted or entered in the data area.  Enter one X and one Y
value per line separated by at least one space character.

The Calculate button generates the slope (M) and intercept (B) for the least
squares line  as defined by the equation y = Mx + B.  The input points and the
best fit  line are displayed below.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  trealpoint = record
    x,y:extended;
  end;
  TRealPointArray=array of TRealPoint;
  TPointArray = array of TPoint;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo5: TMemo;
    Image1: TImage;
    Memo1: TMemo;
    CalcBtn: TButton;
    Label1: TLabel;
    EquationLbl: TLabel;
    RLbl: TLabel;
    R2Lbl: TLabel;
    procedure CalcBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Memo1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    data: TRealPointArray;
    scaleddata:TPointArray;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************* LinearLeastSquares *******************}
 procedure LinearLeastSquares(data: TRealPointArray; var M,B, R: extended);
 {Line "Y = mX + b" is linear least squares line for the input array, "data",
  of TRealPoint}
var
  SumX, SumY, SumX2, SumY2, SumXY: extended;
  Sx,Sy :extended;
  n, i: Integer;
begin
  n := Length(data); {number of points}
  SumX := 0.0;  SumY := 0.0;
  SumX2 := 0.0;  SumY2:=0.0;
  SumXY := 0.0;

  for i := 0 to n - 1 do
  with data[i] do
  begin
    SumX := SumX + X;
    SumY := SumY + Y;
    SumX2 := SumX2 + X*X;
    SumY2 := SumY2 + Y*Y;
    SumXY := SumXY + X*Y;
  end;

  if (n*SumX2=SumX*SumX) or (n*SumY2=SumY*SumY)
  then
  begin
    showmessage('LeastSquares() Error - X or Y  values cannot all be the same');
    M:=0;
    B:=0;
  end
  else
  begin
    M:=((n * SumXY) - (SumX * SumY)) / ((n * SumX2) - (SumX * SumX));  {Slope M}
    B:=(sumy-M*sumx)/n;  {Intercept B}
    Sx:=sqrt(Sumx2-sqr(sumx)/n);
    Sy:=Sqrt(Sumy2-sqr(Sumy)/n);
    r:=(Sumxy-Sumx*sumy/n)/(Sx*sy);
    //RSquared:=r*r;
  end;
end;

type

tScaleInfo=record
  ScaleX,ScaleY:extended;
  Offsetx,Offsety:integer;
end;

{************* Scalepoint *************}
function scalePoint(const x,y:extended; const scaleinfo:TScaleinfo):TPoint;
   begin
     with scaleinfo do
     begin
       result.x:=trunc(scalex*x+offsetx);
       result.y:=trunc(scaley*y+offsety);
     end;
   end;

{**************** Scale data array for plotting **************}
function ScaledataForPlot(const data:TRealPointArray;
                           imagewidth,imageHeight:integer;
                            var ScaledData:TPointArray):TScaleInfo;
{Function which converts real x,y coordinates to plot coordinates covering the
 range from 10% to 90% of the plot area define by parameters ImageWidth and
 ImageHeight.  I returns the scaling info in a TScaleInfo record which may be passed
 to the scalePoint function to scale additional points if necessary.}
var

  i:integer;
  maxx,minx,maxy,miny:extended;

begin
  setlength(ScaledData, length(data));
  with data[low(data)] do
  begin
    maxx:=x;
    minx:=x;
    maxy:=y;
    miny:=y;
  end;
  for i:=low(data)+1 to high(data) do
  with data[i] do
  begin
    if x>maxx then maxx:=x;
    if x<minx then minx:=x;
    if y>maxy then maxy:=y;
    if y<miny then miny:=y;
  end;
  with result do
  begin
    Scalex:=0.8*(imagewidth)/(maxx-minx);
    Scaley:=-0.8*(imageheight)/(maxy-miny);
    offsetx:=imagewidth div 10 - trunc(scalex*minx);
    offsety:=9*imageheight div 10 -trunc(scaley*miny);
  end;
  for i:=low(data) to high(data) do
    with data[i] do  scaleddata[i]:=scalePoint(x,y, result);
end;

var
  {initial sample data}
  samplex:array[0..4] of extended = (1,2,3,4,5);
  sampley:array[0..4] of extended =( 2.1, 3.9, 6.1, 7.9, 11.0);


{*************** GetNextNumber ***********}
function getnextnbr(lineIn:string; nextstart:integer; var val:extended):integer;
{Scan a string for a floating point value followed by at least one space character}
{If valid number is found, return +1 in result field, put the value in "val", and delete
 the number string from "line".  If the input string is empty, return result=0. If an
 error is encountered in coverting the number, show an error message and return -1
 as the result}
var
 j:integer;
 line,s:string;

begin
  result:=1;
  j:=1;
  line:=copy(lineIn,nextstart,length(linein)-nextstart+1);
  line:=trim(line)+' ';
  if length(line)=1 then result:=0
  else
  begin
    {eliminate "commas" and add a stopper}
    line:=stringreplace(line,thousandSeparator,'',[rfreplaceall]);
    while (j<length(line)) and (line[j] <> ' ') {in ['0'..'9','-','e','E', decimalseparator])} do inc(j);
    s:=copy(line,1,j-1);
    val:=strtofloatdef(s,1e300);
    If val=1e300 then
    begin
      showmessage(format('The string %s in position %d of line %s is not a valid number, line will be ignored',
                  [s, j+nextstart, lineIn]));
      result:=-1;
    end;
    if result>0 then result:=j+nextstart;
    //else line:='';
  end;
end;

{************ FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  memo1.Clear;
  setlength(data, length(samplex));

  for i:=low(samplex) to high(samplex) do
  begin
    data[i].x:=samplex[i];
    data[i].Y:=sampley[i];
    memo1.Lines.add(format('%6.1f,%6.1f',[samplex[i],sampley[i]]));
  end;

end;

{*********** Memo1Exit ************}
procedure TForm1.Memo1Exit(Sender: TObject);
{When user clicks elsewhere after editing  Memo1, revalidate and reload the data}
var
  i,j,n, nextstart:integer;
  line:string;
  val:extended;
  temp:TRealPoint;
begin
  n:=0; {n = count of data points}
  setlength(data, memo1.Lines.count);
  with memo1 do
  for i:=0 to lines.Count-1 do
  begin
    line:=trim(lines[i]);
    nextstart:=1;
    nextstart:= getnextnbr(line, nextstart, val);
    if nextstart>0 then
    begin
      data[n].x:=val;  {X is valid, save it and try Y}
      if getnextnbr(line, nextstart, val)>0 then
      begin
        data[n].Y:=val; {get y}
        Lines[i]:=format('%6.1f,%6.1f',[data[n].x,data[n].y]);
        inc(n);
      end;
    end
    else if nextstart<0 then lines[i]:= 'Err. '+lines[i] ;
  end;
  setlength(data,n);
  {sort array by x coordinate, in case we want to "connect the dots" later }
  for i:= low(data) to high(data)-1 do
  for j:=i+1 to high(data) do
  if data[i].x > data[j].x then
  begin
    temp:=data[i];
    data[i]:=data[j];
    data[j]:=temp;
  end;
end;

{*************** CalcBtnClick *********}
procedure TForm1.CalcBtnClick(Sender: TObject);
var
  i:integer;
  M,B,R:extended;
  p:TPoint;
  Scaleinfo:TScaleInfo;
  op:string;
  xzero,xmax:extended;
begin
  LinearLeastSquares(data,M,B, R);
  ScaleInfo:=ScaledataforPlot(Data, image1.Width, image1.Height, ScaledData);

  with image1,canvas do
  begin
    rectangle(clientrect);
    brush.color:=clblack;

    for i:=low(scaleddata) to high(scaleddata) do
    with scaledData[i] do
    begin
      ellipse(x+4,y+4,x-4,y-4);
      (*  {connect the dots}
      if i=low(data) then  moveto(x,y)
      else lineto(x,y);
      *)
    end;
    brush.color:=clWhite;
    pen.color:=clred;
    pen.width:=3;
    with scaleinfo do
    begin
      xzero:=-offsetx/scalex;
      p:=scalepoint(xzero, m*xzero+B, scaleinfo);
      moveto(p.x,p.y);
      xmax:=(image1.Width-offsetx)/scalex;
      p:=ScalePoint(xmax,m*xmax+B,ScaleInfo);
    end;
    lineto(p.x,p.y);
    pen.color:=clblack;
    pen.width:=1;
  end;
  if B<0 then op:='-' else op:='+';
  Equationlbl.caption:=format('Best fit line Y=%6.1fX %s %6.1f',[M,op,abs(B)]);
  RLbl.caption:=format('Correlation Coefficient (R)= %6.4f',[r]);
  R2Lbl.caption:= format('R Squared = %6.4f',[r*r]);
end;


end.
