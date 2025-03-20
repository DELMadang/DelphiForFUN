unit U_BigIntTest;
{Copyright  © 2001-2015, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Spin, ShellAPI, ExtCtrls, ComCtrls, UBigIntsV5;

type
  Tbigints = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Long1Edt: TEdit;
    Long2Edt: TEdit;
    AddBtn: TButton;
    MultBtn: TButton;
    FactorialBtn: TButton;
    SubtractBtn: TButton;
    DivideBtn: TButton;
    ModBtn: TButton;
    ComboBtn: TButton;
    XtotheYBtn: TButton;
    Long3Edt: TEdit;
    ModPowBtn: TButton;
    SqRootBtn: TButton;
    SquareBtn: TButton;
    CopyBtn: TButton;
    ProbPrimeBtn: TButton;
    GCDBtn: TButton;
    InvModBtn: TButton;
    YthRootBtn: TButton;
    FastMultBtn: TButton;
    FloorBtn: TButton;
    Button12: TButton;
    Memo2: TMemo;
    Memo1: TMemo;
    StaticText1: TStaticText;
    DivRemBtn: TButton;
    ToInt64Btn: TButton;
    RandomBtn: TButton;
    RandomOfSizeBtn: TButton;
    NextPrimeBtn: TButton;
    ToHexBtn: TButton;
    FromHexBtn: TButton;
    Button1: TButton;
    TimeLbl: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Verbosebox: TCheckBox;
    Label3: TLabel;
    OverLoadTextGrp: TGroupBox;
    BaseEdt: TSpinEdit;
    Memo3: TMemo;
    OverloadGrp: TGroupBox;
    OverAddBtn: TButton;
    OverModBtn: TButton;
    OverSubtreactBtn: TButton;
    OverMultBtn: TButton;
    OverDivBtn: TButton;
    Memo4: TMemo;
    Memo5: TMemo;
    IncBtn: TButton;
    DecBtn: TButton;
    AllocLbl: TLabel;
    procedure OverAddBtnClick(Sender: TObject);
    procedure OverMultBtnClick(Sender: TObject);
    procedure FactorialBtnClick(Sender: TObject);
    procedure OverSubtractBtnClick(Sender: TObject);
    procedure DivideBtnClick(Sender: TObject);
    procedure ModBtnClick(Sender: TObject);
    procedure ComboBtnClick(Sender: TObject);
    procedure powerbtnClick(Sender: TObject);
    procedure modpowbtnClick(Sender: TObject);
    procedure rootbtnClick(Sender: TObject);
    procedure squareButtonClick(Sender: TObject);
    procedure copyButtonClick(Sender: TObject);
    procedure primetestclick(Sender: TObject);
    procedure gcdClick(Sender: TObject);
    procedure invbuttonClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure YthRootBtnClick(Sender: TObject);
    procedure FastMultBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ModTypeGrpClick(Sender: TObject);
    procedure DivRemBtnClick(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure FloorBtnClick(Sender: TObject);
    procedure ToInt64BtnClick(Sender: TObject);
    procedure RandomBtnClick(Sender: TObject);
    procedure RandomOfSizeBtnClick(Sender: TObject);
    procedure NextPrimeBtnClick(Sender: TObject);
    procedure ToHexBtnClick(Sender: TObject);
    procedure FromHexBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure VerboseboxClick(Sender: TObject);
    procedure BaseEdtChange(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure SubtractBtnClick(Sender: TObject);
    procedure MultBtnClick(Sender: TObject);
    procedure OverDivBtnClick(Sender: TObject);
    procedure OverModBtnClick(Sender: TObject);
    procedure Memo4Click(Sender: TObject);
    procedure IncBtnClick(Sender: TObject);
    procedure DecBtnClick(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
    freq:int64;  {performace counter frequncy}
    start,stop:int64;
    verbose:boolean;
    procedure getxy(var i1,i2:TInteger);
    procedure showdigits(int:TInteger; header:string; memo:TMemo);
    procedure addmemoLine(s:string);
  end;

var
  bigints: Tbigints;

implementation
{$R *.DFM}
uses  math;

procedure TBigInts.showdigits(int:TInteger; header:string; memo:TMemo);
  var s:string;
      i:integer;
  begin
    s:=header;
    for i:=0 to high(int.digits) do s:=s+inttostr(int.digits[i])+', ';
    delete(s,length(s)-1,2);
    memo.lines.add(s);
    alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
  end;

procedure TBigInts.AddMemoLine(s:string);
begin
  memo1.lines.add(s);
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;


procedure CreateInt(x:TInteger);
begin
   x.create(0);
end;


procedure TBigInts.getxy(var i1,i2:TInteger);
  begin
    memo1.Clear;
    i1.assign(long1edt.text);
    if verbose then showdigits(i1,'X digits  are: ', memo1);
    i2.assign(long2Edt.text);
    if verbose then showdigits(i2,'Y digits are: ', memo1);
  end;


procedure Tbigints.IncBtnClick(Sender: TObject);
var
 i1:Tinteger;
begin
  {$IF compilerversion>15}
  memo1.clear;
  addmemoline('X value has been incremented');
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  i1.add(1); //Inc(i1);
  long1edt.text:=I1.converttodecimalstring(True);
  {$IFEND}
end;

{************ DecBtnClick *************}
procedure Tbigints.DecBtnClick(Sender: TObject);
var
  i1:Tinteger;
begin
  {$IF compilerversion>15}
  memo1.clear;
  memo1.lines.add('X value has been decremented');
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  Dec(i1);
  long1edt.text:=I1.converttodecimalstring(True);
  {$IFEND}
end;

procedure Tbigints.FormCreate(Sender: TObject);
begin
  queryperformancefrequency(freq);
  {$IF compilerversion >15}
  OverloadTextGrp.visible:=true;
  OverloadGrp.visible:=true;
  Memo3.visible:=true;
  {$IFEND}
end;

procedure Tbigints.AddBtnClick(Sender: TObject);
{addition}
var
  i1,i2,i3:Tinteger;
  n:int64;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  GetXY(i1,i2);
  i1.add(i2);
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  if i2.ConvertToInt64(n) then
  begin
    i3:=TInteger.create(0);
    i3.assign(long1edt.text);
    i3.Add(n);
    if i1.compare(i3)<>0 then addmemoline('Error! Int64 result='+i3.converttodecimalstring(true));
    i3.free;
  end;
  i1.free;
  i2.free;
end;

procedure Tbigints.OverAddBtnClick(Sender: TObject);
{addition}
var
  i1,i2,i3:Tinteger;
  n:int64;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  GetXY(i1,i2);
  {$IF compilerversion > 15}
    i3:=TInteger.create(0);
    i3:=i1+i2;
  {$IfEnd}
  i1.add(i2);
  {$IF compilerversion > 15}
  If i1 <> I3 then showmessage(format('Overloaded operator error "x + y = " %s',[i3.converttodecimalstring(true)]));
  I3.free;
  {$IFEND}
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  if i2.ConvertToInt64(n) then
  begin
    i3.assign(long1edt.text);
    i3.Add(n);
    if i1<>i3 then addmemoline('Error! Int64 result='+i3.converttodecimalstring(true));
  end;
  i1.free;
  i2.free;
end;


procedure Tbigints.SubtractBtnClick(Sender: TObject);
{Subtraction}
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
  {$IF compilerversion > 15}
    i3:=TInteger.create(0);
    i3:=i1-i2;
  {$IfEnd}
  i1.subtract(i2);
  {$IF compilerVersion>15}
    If i1 <> I3 then showmessage(format('Overloaded "-" operator error, result %s is incorrect',[i3.converttodecimalstring(true)]));
    i3.free;
  {$IfEnd}
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  i1.free;
  i2.free;
end;


procedure Tbigints.OverSubtractBtnClick(Sender: TObject);
{Subtraction}
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
  {$IF compilerversion > 15}
    i3:=TInteger.create(0);
    i3:=i1-i2;
  {$IfEnd}
  i1.subtract(i2);
  {$IF compilerVersion>15}
    If i1 <> I3 then showmessage(format('Overloaded "-" operator error, result %s is incorrect',[i3.converttodecimalstring(true)]));
    i3.free;
  {$IfEnd}
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  i1.free;
  i2.free;
end;

procedure Tbigints.MultBtnClick(Sender: TObject);
{Multiply}
var
  i1,i2:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  GetXY(i1,i2);
  QueryPerformanceCounter(start);
  i1.mult(i2);
  QueryPerformanceCounter(stop);
  timelbl.caption:=format('Mult Execution Time: %6.2F microseconds',[1e6*(stop-start)/freq]);
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  i1.free;
  i2.free;
end;

procedure Tbigints.OverMultBtnClick(Sender: TObject);
{Multiply}
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  GetXY(i1,i2);
  {$IF compilerversion > 15}
    i3:=TInteger.create(0);
    i3:=i1*I2;
  {$IfEnd}
  QueryPerformanceCounter(start);
  i1.mult(i2);
   QueryPerformanceCounter(stop);
  {$IF compilerVersion>15}
    If i1 <> I3 then showmessage(format('Overloaded "*" operator error, result %s is incorrect',[i3.converttodecimalstring(true)]));
    i3.free;
  {$IfEnd}


  timelbl.caption:=format('Execution Time: %6.2F microseconds',[1e6*(stop-start)/freq]);
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  i1.free;
  i2.free;
end;



{************ OverDivideBtnClick *************}
procedure Tbigints.OverDivBtnClick(Sender: TObject);
{divide}
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
   {$IF compilerversion > 15}
    i3:=TInteger.create(0);
    i3:=i1 div i2;
  {$IfEnd}
  i1.divide(i2);
  {$IF compilerVersion>15}
    If i1 <> I3 then showmessage(format('Overloaded "Div" operator error, result %s is incorrect',[i3.converttodecimalstring(true)]));
    i3.free;
  {$IfEnd}
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  i1.free;
  i2.free;
end;



procedure Tbigints.DivideBtnClick(Sender: TObject);
{divide}
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
  {$IF compilerversion > 15}
  i3:=TInteger.create(0);
  i3:=i1 div i2;
  {$IfEnd}
  i1.divide(i2);
  {$IF compilerVersion>15}
    If i1 <> I3 then showmessage(format('Overloaded "Div" operator error, result %s is incorrect',[i3.converttodecimalstring(true)]));
    i3.free;
  {$IfEnd}
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.converttoDecimalString(true));
  i1.free;
  i2.free;
end;

(*
procedure Tbigints.FastMultBtnClick(Sender: TObject);
{Fast Multiply}
var
  i1,i2:Tinteger;

begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);

  QueryPerformanceCounter(start);
  i1.Fastmult(i2);
  QueryPerformanceCounter(stop);
  //timelbl.caption:=format('Execution Time: %6.2F microseconds',[1e6*(stop-start)/freq]);
  if verbose then showdigits(i1,'Result digits are:', memo1);
  addmemoline(i1.ConverttoDecimalString(true));
  i1.free;
  i2.free;
end;
*)

procedure Tbigints.FastMultBtnClick(Sender: TObject);
{fastmult speed test}
{multiply two random large  numbers together with mult and fast mult and
compare results and times}
{x and y contain the number of random digits in each operand}
var
  n1,n2,i:integer; {number of integers}
  s1,s2:string;
  i1,i2:Tinteger;
  if1,if2:TInteger;
  time1,time2:extended; {time units for display, based on time2 value}
  m:integer; {multiplier for units for time display}
  units:string;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  getxy(i1,i2);
  If (i1.compare(maxint)>0) or (i2.compare(maxint)>0) then
  begin
     i1.Free;
     i2.Free;
     showmessage(format('X and Y (# of digits in random numbers to multiply) must be less than %d for FastMult', [maxint]));
     exit;
  end;
  n1:=strtoint(long1edt.text);
  if n1<=0 then n1:=1;
  n2:=strtoint(long2Edt.text);
  if n2<=0 then n2:=1;
  if n1+n2 >500000 then {reduce proportionately }
  begin
    n1:=trunc(n1*(500000/(n1+n2)));
    n2:=trunc(n2*(500000/(n1+n2)));
  end;
  If n2>250000 then n2:=250000;

  if1:=TInteger.create(0);
  if2:=TInteger.create(0);
  s1:='';
  for i:=1 to n1 do s1:=s1+char(ord('0')+random(10));
  s2:='';
  for i:=1 to n2 do s2:=s2+char(ord('0')+random(10));
  i1.assign(s1);
  i2.assign(s2);
  screen.cursor:=crHourglass;
  QueryPerformanceCounter(start);
  i1.mult(i2);
  //i1.square;
  QueryPerformanceCounter(stop);
  time1:=(stop-start)/freq;
  if1.assign(s1);
  if2.assign(s2);
  QueryPerformanceCounter(start);
  if1.Fastmult(if2);
  //if1.fastsquare;
  QueryPerformanceCounter(stop);
  time2:=(stop-start)/freq;
  screen.cursor:=crDefault;
  with memo1 do
  begin
    clear;
    if time2>1 then begin m:=1; units:='seconds' end
    else if time2>0.001 then begin m:=1000; units:='milliseconds'; end
    else begin m:=1000000; units:='microseconds'; end;
    lines.add(format('Multplying %d digit random  by %d digit random using Mult and FastMult',[n1,n2]));
    if i1.compare(if1)<>0 then lines.Add('Results differ')
    else
    begin
      lines.add('Results agree');
      lines.add(format('%d digits in result',[i1.digitcount]));
    end;
    lines.add(format('Mult Execution Time: %6.2F %s',[m*time1,units]));
    lines.add(format('FastMult Execution Time: %6.2F %s',[m*time2,units]));
  end;
  i1.free;
  i2.free;
  if1.free;
  if2.free;
end;


procedure Tbigints.FactorialBtnClick(Sender: TObject);
{Factorial}
var
  i1:Tinteger;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  if i1.compare(3000)>0
  then
  begin
    showmessage('Input truncated to 3000');
    i1.assign(3000);
  end;

  i1.factorial;
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;



{************* DivideRemBtnClick **************}
procedure Tbigints.DivRemBtnClick(Sender: TObject);
{Important div and mod paper
     http://www.cs.uu.nl/~daan/download/papers/divmodnote.pdf  }
{Compare 3 different definitions of divide with remainder}
var
  i1,i2,remT,remF,RemE:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  remT:=TInteger.create(0);
  remF:=TInteger.create(0);
  remE:=TInteger.create(0);
  memo1.clear;

  i1.assign(long1edt.text);
  i2.assign(long2edt.text);
  i1.divideremTrunc(i2, remT);
  {#9=Tab, used aliign output}
  addmemoline('DivideRemTrunc:'+#9#9+'Q='+i1.converttoDecimalString(true));
  i1.assign(long1edt.text);
  i1.divideremFloor(i2, remF);
  addmemoline('DivideRemFloor:'+#9#9+'Q='+i1.converttoDecimalString(true));
  i1.assign(long1edt.text);
  i1.divideremEuclidean(i2, remE);
  addmemoline('DivideRemEuclidiean:'+#9+'Q='+i1.converttoDecimalString(true));
  addmemoline('DivideRemTrunc:'+#9#9+'R='+remT.converttoDecimalString(true));
  addmemoline('DivideRemFloor:'+#9#9+'R='+remF.converttoDecimalString(true));
  addmemoline('DivideRemEuclidean'+#9+'R='+remE.converttoDecimalString(true));
  i1.free;
  i2.free;
  remT.free;
  remF.free;
  remE.free;
end;




procedure Tbigints.ModBtnClick(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
  i1.modulo(i2);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.OverModBtnClick(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
   {$IF compilerversion > 15}
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
    i3:=TInteger.create(0);
    i3:=i1 mod i2;
  i1.modulo(i2);
    If i1 <> I3 then showmessage(format('Overloaded "mod" operator error, result %s is incorrect',[i3.converttodecimalstring(true)]));
    i3.free;
  
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
  {$IfEnd}
end;


procedure Tbigints.ComboBtnClick(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  i3:=TInteger.create(0);
  Getxy(i1,i2);
  if (i1.compare(1000)<=0) and (i2.compare(1000)<=0) then
  begin
    if i1.compare(i2)<0 then i1.assign(0)
    else if i1.compare(i2)=0 then i1.assign(1)
    else
    begin
      i3.assign(i1); i3.subtract(i2);
      i1.factorial;
      i2.factorial;
      i3.factorial;
      i1.divide(i2);
      i1.divide(i3);
    end;
    memo1.text:=i1.converttoDecimalString(true);
  end
  else showmessage('No calculation - numbers for combinations limited to 1000');
  i1.free;
  i2.free;
  i3.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;



procedure Tbigints.Memo4Click(Sender: TObject);
var
  i1,i2:Tinteger;
   s:string;
begin
  {$IF compilerversion>15}
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  Getxy(i1,i2);
  If i1=i2 then s:='true' else s:='false';   addmemoline('Equal: x =y is ' +s);
  If i1<>i2 then s:='true' else s:='false';   addmemoline('Not Equal: x <>y is ' +s);
  If i1>i2 then s:='true' else s:='false';   addmemoline('Greater than: x > y is ' +s);
  If i1>=i2 then s:='true' else s:='false';   addmemoline('Greater than or equal : x >= y is ' +s);
  If i1<2 then s:='true' else s:='false';   addmemoline('Less than: x < y is ' +s);
  If i1<=i2 then s:='true' else s:='false';   addmemoline('Less than or equal : x <= y is ' +s);
  i1.free;
  i2.free;
  {$IFEnd}
end;

procedure Tbigints.powerbtnClick(Sender: TObject);
var i1:tinteger;e:integer;
begin
i1:=TInteger.create(0);
i1.assign(long1edt.text);

e:=strtoint(long2Edt.text);
if e>100
then
begin
  showmessage('Exponent truncated to 100 for this test');
  e:=100;
  long2edt.Text:='100';
end;
i1.pow(e);
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;


procedure Tbigints.modpowbtnClick(Sender: TObject);
var g,e,m :Tinteger;
begin
  g:=TInteger.create(0);
  e:=TInteger.create(0);
  m:=TInteger.create(0);
  g.assign(long1edt.text);
  e.assign(long2edt.text);
  m.assign(long3edt.text);
  g.modpow(e,m);
  memo1.text:=g.ConvertToDecimalString(true);
  g.free;
  e.free;
  m.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;


procedure Tbigints.rootBtnClick(Sender: TObject);
var i1:tinteger;
begin
i1:=TInteger.create(0);
i1.assign(long1edt.text);
i1.sqroot;
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.squareButtonClick(Sender: TObject);
var i1:tinteger;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  i1.square;
  memo1.text:=i1.ConvertToDecimalString(true);
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
  i1.free;
end;

procedure Tbigints.copyButtonClick(Sender: TObject);
var line,s:string;
    i:integer;
begin

  s:='';
  for i:=0 to memo1.lines.count-1 do
  begin
    line:=Memo1.Lines[i];
    if (length(line)>0) and (line[1] in ['0'..'9','-',',','.']) then s:=s+line;
  end;
  long1edt.text:=s;
end;

procedure Tbigints.primetestClick(Sender: TObject);
var i1:tinteger;r:boolean;
begin
   memo1.text:='testing..';
   application.processmessages;
   i1:=TInteger.create(0);
   i1.assign(long1edt.text);
   r:=i1.IsProbablyPrime;
   if r then memo1.text:='prime' else memo1.text:='not prime';
   I1.free;
   alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.gcdClick(Sender: TObject);
var i1,i2:tinteger;
begin
i1:=TInteger.create(0);
i2:=TInteger.create(0);
Getxy(i1,i2);
i1.gcd(i2);
memo1.text:=i1.ConvertToDecimalString(true);
i1.free;
i2.free;
alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;


procedure Tbigints.invbuttonClick(Sender: TObject);
var i1,i2:tinteger;
begin
 i1:=TInteger.create(0);
 i2:=TInteger.create(0);
 Getxy(i1,i2);
 i1.invmod(i2);
 memo1.text:=i1.ConvertToDecimalString(true);
 i1.free;
 i2.free;
 alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure Tbigints.YthRootBtnClick(Sender: TObject);
var i1:Tinteger;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  i1.Nroot(strtoint(long2edt.text));
  memo1.text:=i1.ConvertToDecimalString(true);
  i1.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;







(*
procedure Tbigints.ModFBtnClick(Sender: TObject);
var
  i1,i2,rem:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  rem:=TInteger.create(0);
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.divideremFloor(i2,rem);
  memo1.text:=rem.converttoDecimalString(true);
  i1.free;
  i2.free;
  rem.free;
end;
*)

(*
procedure Tbigints.ModEBtnClick(Sender: TObject);
var
  i1,i2,rem:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  rem:=TInteger.create(0);
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.divideremEuclidean(i2,rem);
  memo1.text:=rem.converttoDecimalString(true);
  i1.free;
  i2.free;
  rem.free;
end;
*)
procedure Tbigints.ModTypeGrpClick(Sender: TObject);
begin
  //SetModuloType(ModTypeGrp.itemindex);
end;




procedure Tbigints.Button12Click(Sender: TObject);
var i1,i2,i3:tinteger;
begin
 i1:=TInteger.create(0);
 i2:=TInteger.create(0);
 i3:=TInteger.create(0);
 i1.assign(long1edt.text);
 i3.assign(i1);
 i2.assign(long2edt.text);
 i1.invmod(i2);
 i1.mult(i3);
 i1.modulo(i2);
 memo1.text:=i1.ConvertToDecimalString(true);
 i1.free;
 i2.free;
 alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.FloorBtnClick(Sender: TObject);
var
  i1,i2,i3:Tinteger;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  i3:=TInteger.create(0);
  i1.assign(long1edt.text);
  i2.assign(long2Edt.text);
  i1.divideremFloor(i2,i3);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  i2.free;
  i3.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.ToInt64BtnClick(Sender: TObject);
var
  i1:Tinteger;
  n:int64;
  i,L:integer;
  s:string;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  if i1.converttoInt64(n) then
  begin
    {we'll punctuate it, just for fun}
    s:=inttostr(n);
    L:=length(s);
    for i:=L-3 downto 1 do
    if (L-i) mod 3 =0 then insert(',',s,i+1);
    memo1.text:=s;
  end
  else memo1.text:='Failed';
  i1.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

{**************** RandombtnClick ***********}
procedure Tbigints.RandomBtnClick(Sender: TObject);
var
  i1,i2:Tinteger;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  i2:=TInteger.create(0);
  i2.random(i1);
  memo1.text:=i2.converttoDecimalString(true);
  i1.free;
  i2.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

{************** RandomOfSizeBtnClick *************}
procedure Tbigints.RandomOfSizeBtnClick(Sender: TObject);
var
  i1:Tinteger;
  n:int64;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  if i1.compare(200)>0 then
  begin
    showmessage('Maximum length for testing is 200, X set to 200');
    i1.assign(200);
    long1edt.Text:='200';
    memo1.text:=i1.converttoDecimalString(true);
  end;
  i1.converttoint64(n);
  i1.randomofsize(n);
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

{************** NextPrimeBtnClick **************}
procedure Tbigints.NextPrimeBtnClick(Sender: TObject);
var
  i1:Tinteger;
begin
  screen.cursor:=crhourglass;
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  i1.Getnextprime;
  memo1.text:=i1.converttoDecimalString(true);
  i1.free;
  screen.cursor:=crdefault;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;

procedure Tbigints.ToHexBtnClick(Sender: TObject);
var
  i1:Tinteger;
begin
  i1:=TInteger.create(0);
  i1.assign(long1edt.text);
  memo1.Text:=i1.ConverttoHexstring;
  i1.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;


procedure Tbigints.FromHexBtnClick(Sender: TObject);
var
  i1:Tinteger;
begin
  i1:=TInteger.create(0);
  if i1.assignHex(long1edt.text)
  then   memo1.Text:=i1.Converttodecimalstring(true)
  else memo1.Text:='Invalid hex strring in X as input';
  i1.free;
  alloclbl.caption:=format('Allocated memory: %d',[allocmemsize]);
end;
procedure Tbigints.Button1Click(Sender: TObject);
var
  i1,i2:Tinteger;
  Longint:int64;
begin
  i1:=TInteger.create(0);
  i2:=TInteger.create(0);
  memo1.clear;

  with memo1.lines do
  begin
    i1.assign('1');
    i2.assign($80000000);
    i1.mult(i2);
    add('*i2: '+i1.converttoDecimalString(true));
    add('');

    i1.assign(1);
    longInt:=$80000000;
    i1.mult(Longint);
    add('Longint=$80000000: '+inttostr(longint));
    addmemoline('*Longint: '+i1.converttoDecimalString(true));
    add('');

    i1.assign(1);
    i1.mult($80000000);
    add('*$80000000: '+i1.converttoDecimalString(true));
    add('');
  end;

  i1.free;
  i2.free;
end;
procedure Tbigints.VerboseboxClick(Sender: TObject);
begin
  verbose:=verbosebox.Checked;
end;

procedure Tbigints.BaseEdtChange(Sender: TObject);
begin
  SetbaseVal(trunc(intpower(10,BaseEdt.value)));
end;

end.
