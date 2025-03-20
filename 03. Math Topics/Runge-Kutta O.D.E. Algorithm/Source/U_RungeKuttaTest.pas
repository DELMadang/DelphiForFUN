unit U_RungeKuttaTest;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Tests 2 case from Borlands Numerical Methods Toolbox
  These are "quick and dirty" impelemntation with values hard coded, primary
  puirpoise was to ensure that calculated values match those returened from
  original Toolbox sample problems (they do)

  Simple animated graphics were also added "just for fun"
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, URungeKutta4, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Test1Btn: TButton;
    PendulumBtn: TButton;
    Image1: TImage;
    Memo2: TMemo;
    Memo3: TMemo;
    Test2Btn: TButton;
    Test1InfoMemo: TMemo;
    Test2InfoMemo: TMemo;
    PendulumInfoMemo: TMemo;
    StatusBar1: TStatusBar;
    procedure Test1BtnClick(Sender: TObject);
    procedure Test2BtnClick(Sender: TObject);
    procedure PendulumBtnClick(Sender: TObject);
  public
    {common values}
     valcount:integer;                   {number of frames displayed so far}
     LowerLimit, UpperLimit : Float;     { Limits over which to approximate X  }
     MaxNumReturn:integer;
     ReturnInterval:Float;
     CalcInterval:Float;
     Error : byte;                       { Flags if something went wrong  }
     xC:integer; {x center of imsage}

     {Test1 single equation values}
      InitialValue, InitialDeriv : Float; { Initial values at lower limit  }

     {Test2 - coupled system values }
     TestFuncs:TFuncVect;
     Initialvalues:TnVector;
     NUmEquations:integer;

     {Pendulum values}
     Len:integer; {Pendulum length in pixels}

     {Test1 functions}
     Function Test1UserFunc(T,X,XPrime:Float):Float; {Calc next x''}
     Function Test1CallBackFunc
                   (T,X,XPrime:Float):boolean; {Print/plot a point for time T}

     {Test2 functions}
     Function Test2UserFunc1(v:TNVector):Float; {Calc next x'' for equation #1}
     Function Test2UserFunc2(v:TNVector):Float; {Calc next x'' for equation #2}
     Function Test2CallBackFunc
                       (v:TNVector):boolean;{Print/plot values for time v[0].x}

    {Pendulum functions}
     Function PendulumFunc(T,X,XPrime:Float):Float; {Calc next x''}
     Function PendulumCallBackFunc
                     (T,X,XPrime:Float):boolean; {Print plot a point for time T}

  end;

var Form1: TForm1;

implementation

{$R *.dfm}
var   twopi:float=2*PI;
      halfpi:float=pi/2.0;

{*******************************************************}
{                       Test1 Code                      }
{*******************************************************}
{Check solution for initial value problem for an second-order ordinary
 differential equation using Runge-Kutta method (adapted from  Borland's Turbo
 Pascal Numerical Methods Toolbox, p 172)}

{********************** Test1UserFunc ***************}
Function TForm1.Test1UserFunc(T,X,XPrime:Float):Float;
{called for every point by RungeKutta2ndOrderIC with current
 Time, X,  and Xprime values.  Function must return the next
 2nd derivative (acceleration) value}
begin
  Result:=(9/2*sin(5*t) -32/2*x);
end;

{********************* Test1CallBackFunc ***************}
Function TForm1.Test1CallBackFunc(T,X,XPrime:Float):boolean;
{called once for each (ReturnInterval/CalcInterval) points,
  so CalcInterval should divide ReturnInterval evenly}
var
  xx,yy, basex,i:integer;
  cycle:float;
begin
  with form1 do
  begin
    memo1.lines.add(format('%4.2f  %15.12f  %15.12f ',[T, X,XPrime]));
    memo1.update;

    with image1, canvas do
    begin
       brush.color:=clWindow;
      pen.color:=clblack;
      fillrect(clientrect);
      brush.color:=clgreen;
      basex:=width div 2+trunc(30*x);
      {Draw floor and wall}
      moveto(0,200); lineto(300,200); lineto(300,0);
      {Draw force arrow}
      moveto(basex-50,170); lineto(basex,170); lineto(basex-10,180);
      moveto(basex-50,155); lineto(basex,155); lineto(basex-10,145);
      {draw mass}
      rectangle(basex,190,basex+50,140);
      {draw the spring}
      xx:=250-basex;
      {let's try 2 cycles}
      cycle:= xx div 2;
      moveto(basex+50,165);
      for i:= 0 to xx do
      begin
        yy:=165+trunc(20*sin(i*TwoPi/cycle));
        lineto(basex+50+i,yy);
      end;
    end;
    image1.update;
    sleep(trunc(500*ReturnInterval{upperlimit/numreturn}));
    inc(valcount);
    if T<=Upperlimit then result:=true else result:=false;
  end;
end;

{************************** Test1BtnClick *****************}
procedure TForm1.Test1BtnClick(Sender: TObject);
begin
  Valcount:=0;
  Lowerlimit:=0;
  UpperLimit:=2;
  InitialValue:=0.0;
  Initialderiv:=-2.5;
  {NumIntervals:=100;} CalcInterval:=0.02;
  MaxNumReturn:=10;
  {NumReturn:=10;} ReturnInterval:=0.2;
  Error:=0;

  with memo1, lines do
  begin
    clear;
    memo1.Lines.addstrings(Test1Infomemo.lines);
    add(' ');
    add('---------------------------------------------------------------------');
    add(' ');
    add('Lower Limit: '+ Floattostr(LowerLimit));
    add('Upper Limit: '+ Floattostr(UpperLimit));
    add('Value of X at '+Floattostr(lowerlimit) + ' : ' +Floattostr(Initialvalue));
    add('Value of X'' at '+Floattostr(LowerLimit)+ ' : ' +Floattostr(InitialDeriv));
    add('Number of intervals: ' +inttostr(trunc(Upperlimit/CalcInterval)));
    add(' ');
    add('   t    Value of X                Derivative of X     ' );
    RungeKutta2ndOrderIC( LowerLimit, UpperLimit, InitialValue, InitialDeriv,
                      ReturnInterval, CalcInterval, Error,
                      Test1UserFunc, Test1CallBackFunc);
    selstart:=0; sellength:=0;{move back to top of memo display}

    case Error of

    1 : add('The number of values to return must be greater than zero.');
    2 : begin
          add('The number of intervals must be greater than'
             + 'or equal to the number of values to return.');
        end;

    3 : add('The lower limit must be different from the upper limit.');
    end; { case }
  end;
end;


{*******************************************************}
{                       Test2 Code                      }
{*******************************************************}
{Check solution for initial value problem for a SYSTEM of COUPLED second-order
 ordinary differential equation using Runge-Kutta method (adapted from
 Borland's Turbo Pascal Numerical Methods Toolbox, p 203)}

{********************** Test2UserFunc1 ******************}
Function TForm1.Test2UserFunc1(V:TNVector):Float;
{exit to calculate next 2nd derivitaive (acceleration) value for 1st equation}
{V is an array of records, one for each equation 1..N, each containing current
 X and Xderiv variables values for that equation}
{Note: current Time is passed in v[0].x}
begin
  Result:=-9.8*V[1].x/0.6125 - 32/2*(V[1].x - V[2].x);
end;

{********************** Test2UserFunc2 ******************}
Function TForm1.Test2UserFunc2(V:TNVector):Float;
{exit to calculate next 2nd derivitaive (acceleration) value for 2nd equation}
{V is an array of records, one for each equation 1..N, each containing current
 X and Xderiv variables values for that equation}
{Note: current Time is passed in v[0].x}
begin
  Result:=-9.8*V[2].x/0.6125 + 32/2*(V[1].x - V[2].x);
end;

{****************** Test2CallBackFunc ******************}
Function TForm1.Test2CallBackFunc(V:TnVector):boolean;
{called once for each (NumIntervals div NumReturn) points,
  so NumReturn should divide NumIntervals evenly}
{V is an array of records, one for each equation 1..N, each containing current
 X and Xderiv variables values for that equation. Current Time is passed in v[0].x}
var
  xx,x1,yy, basex,i:integer;
  cycle:float;
  xscale:integer;
begin
  with form1 do
  begin
    memo1.lines.add(format('%4.2f  %15.12f  %15.12f  %15.12f, %15.12f ',
                       [v[0].x, v[1].x,v[1].XPrime,v[2].x,v[2].xPrime]));
    memo1.update;
  end;
  with image1, canvas do
  begin
    brush.color:=clWindow;
    pen.color:=clblack;
    fillrect(clientrect);
    brush.color:=clred;
    {Draw ceiling}
    moveto(0,20); lineto(300,20);
    {Draw pendulums}
    xscale:=500;
    xx:=trunc(xscale*v[1].x);
    moveto(100,20); lineto(100+xx,70); ellipse(100+xx-5,65,100+xx+5,75);
    xx:=trunc(500*v[2].x);
    moveto(200,20); lineto(200+xx,70); ellipse(200+xx-5,65,200+xx+5,75);
    {draw the spring}
    xx:=90+trunc(xscale*(v[2].x-v[1].x));
    {let's try 2 cycles}
    cycle:= xx div 4;
    x1:=105+trunc(xscale*v[1].x);
    moveto(x1,70);
    for i:= 0 to xx-5 do
    begin
      yy:=70+trunc(10*sin(i*TwoPi/cycle));
      lineto(x1+i,yy);
    end;
    lineto(195+trunc(500*v[2].x),70);
    image1.update;
    sleep(trunc(500*ReturnInterval {upperlimit/numreturn}));
    inc(valcount);
    if v[0].x<=Upperlimit{valcount<=Maxnumreturn} then result:=true else result:=false;
  end;
end;

{********************** Test2BtnClick ****************}
procedure TForm1.Test2BtnClick(Sender: TObject);
var  lowerlimitstr:string;
begin
  Valcount:=0;
  Lowerlimit:=0;
  LowerLimitStr:=FloatTostr(lowerlimit);
  UpperLimit:=2;
  CalcInterval:=0.01;
  MaxNumReturn:=20;  ReturnInterval:=0.1;
  NumEquations:=2;
  Error:=0;
  TestFuncs[1]:=Test2UserFunc1;
  TestFuncs[2]:=Test2UserFunc2;
  InitialValues[1].x:=0.01;
  InitialValues[1].xPrime:=0.0;
  InitialValues[2].x:=-0.01;
  InitialValues[2].xPrime:=0.0;

  with memo1, lines do
  begin
    clear;
    memo1.Lines.addstrings(Test2Infomemo.lines);
    add(' ');
    add('---------------------------------------------------------------------');
    add(' ');
    add('Lower Limit: '+ LowerLimitStr);
    add('Upper Limit: '+ FloatToStr(UpperLimit));
    with initialvalues[1] do
    begin
      add('Value of X at '+lowerlimitStr + ' : ' +Floattostr(x));
      add('Value of X'' at '+LowerLimitStr+ ' : ' +Floattostr(xPrime));
    end;
    with initialvalues[2] do
    begin
      add('Value of Y at '+lowerlimitStr + ' : ' +Floattostr(x));
      add('Value of Y'' at '+LowerLimitStr+ ' : ' +Floattostr(xPrime));
    end;
    add('Number of intervals: ' +inttostr(trunc(Upperlimit/CalcInterval)));
    add(' ');
    add('   t         Value of X            Derivative of X         '
                 +  ' Value of Y            Derivative of Y ' );
    {********************** CallBackSystem **********************}
    RungeKutta2ndOrderIC_System(LowerLimit, UpperLimit, InitialValues,
                      ReturnInterval, CalcInterval, Error,
                      NumEquations, TestFuncs, Test2CallBackFunc);
    selstart:=0; sellength:=0;{move back to top of memo display}
    case Error of

    1 : add('The number of values to return must be greater than zero.');
    2 : begin
          add('The number of intervals must be greater than'
             + 'or equal to the number of values to return.');
        end;

    3 : add('The lower limit must be different from the upper limit.');
    end; { case }
  end;
end;

{*******************************************************}
{                     Pendulum Code                     }
{*******************************************************}

{******************** PendulumFunc *********************}
Function TForm1.PendulumFunc(T,X,XPrime:Float):Float;
begin
  Result:=-9.81/1*sin(x); {G/L*Sin(Theta)}
end;

{********************** PendulumCallBackFunc *******************}
Function TForm1.PendulumCallBackFunc(T,X,XPrime:Float):boolean;
var  xx,yy:integer;
begin
    memo1.lines.add(format('%4.2f  %15.12f  %15.12f ',[T, X,XPrime]));
    memo1.update;
    with image1, canvas do
    begin
      brush.color:=clWindow;
      pen.color:=clblack;
      fillrect(clientrect);
      brush.color:=clblue;
      moveto(xC, 0);
      xx:=xc+trunc(Len*cos(x+halfpi));
      yy:=trunc(Len*sin(x+halfpi));
      lineto(xx,yy);
      ellipse(xx-8,yy-8,xx+8,yy+8);
    end;
    image1.update;
    sleep(trunc(1000*ReturnInterval));
    inc(valcount);
    if T<=Upperlimit then result:=true else result:=false;
  end;

{******************* PendulumBtnlcick ****************}
procedure TForm1.PendulumBtnClick(Sender: TObject);
begin
  Valcount:=0;
  Lowerlimit:=0;
  UpperLimit:=4;
  InitialValue:=-pi/8;
  Initialderiv:=0;
  {NumIntervals:=400;} CalcInterval:=0.01;
  MaxNumReturn:=100;    ReturnInterval:=0.04;
  Error:=0;
  xC:=image1.width div 2;
  Len:=image1.height div 2;
  with memo1, lines do
  begin
    clear;
    memo1.Lines.addstrings(PendulumInfoMemo.lines);
    add(' ');
    add('---------------------------------------------------------------------');
    add(' ');
    add('Lower Limit: '+ Floattostr(LowerLimit));
    add('Upper Limit: '+ Floattostr(UpperLimit));
    add('Value of X at '+Floattostr(lowerlimit) + ' : ' +Floattostr(Initialvalue));
    add('Value of X'' at '+Floattostr(LowerLimit)+ ' : ' +Floattostr(InitialDeriv));
    add('Number of intervals: ' +inttostr(trunc(Upperlimit/CalcInterval)));
    add(' ');
    add('   t          Value of X                Derivative of X     ' );
    RungeKutta2ndOrderIC(LowerLimit, UpperLimit, InitialValue, InitialDeriv,
                      ReturnInterval, CalcInterval, Error,
                      PendulumFunc, PendulumCallBackFunc);
    selstart:=0; sellength:=0;{move back to top of memo display}
    case Error of

    1 : add('The number of values to return must be greater than zero.');
    2 : begin
          add('The number of intervals must be greater than'
             + 'or equal to the number of values to return.');
        end;
    3 : add('The lower limit must be different from the upper limit.');
    end; { case }
  end;
end;

end.
