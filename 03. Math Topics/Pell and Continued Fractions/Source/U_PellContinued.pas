Unit U_PellContinued;
{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ComCtrls, UBigFloatV2, UBigIntsV2, ShellApi;

type

    {Class Pell implements continued fraction convergent calculation}
    TPell= class(Tobject)
      N:int64;
      a:array of integer;
      highcycle:integer;
      p,q:array of Tinteger; {Array of numberators, denominators for convergents}
      lastconvergent:integer;
      xSolve,ySolve:TInteger; {Solution to pell equartion for N, calculated by SetN}
      constructor create;
      destructor destroy;
      function setN(newN:int64):integer; {calculate partial quotients and solution to Pell}
      function GetNextConvergent(var nextP, NextQ:TInteger):boolean;
      function makepartialQuotients:integer;
    end;


  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    PellBtn: TButton;
    SqrtBtn: TButton;
    Memo2: TMemo;
    Label2: TLabel;
    SpinButton1: TSpinButton;
    NewValUpDown: TUpDown;
    NewValEdt: TEdit;
    StaticText1: TStaticText;
    procedure PellBtnClick(Sender: TObject);
    procedure SqrtBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure NewValUpDownChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure NewValEdtKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    SqrtOf:integer;
    BigP,BigQ:TInteger;
    BigRatio:TBigFloat;
    Pell:TPell;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************** TPell.create *******}
constructor TPell.create;
begin
  inherited;
  XSolve:=Tinteger.create;
  YSolve:=TInteger.create;
end;

{************* TPell.Destroy **********}
destructor TPell.destroy;
begin
  XSolve.free;
  YSolve.free;
  inherited;
end;

{************ TPell.Setn *************}
function TPell.setn(newn:int64):integer;
begin
  If newn>0 then
  begin
    N:=newN;
    setlength(A,500);
    highcycle:=MakepartialQuotients;
    lastconvergent:=0;
    result:=highcycle;
  end
  else result:=-1;
end;


{************ TPell.MakePartialQuotients *******}
function Tpell.makepartialQuotients:integer;
var
  i,last:integer;
  rx:extended;

  PP,QQ:array of int64;
  stop:integer;
  ai,r:integer;
begin
  If n>0 then
  begin
    setlength(PP,length(a));
    setlength(QQ,length(a));
    rx:=sqrt(0.0+N);
    a[0]:=trunc(rx);
    a[1]:=trunc(1/(rx-a[0]));
    PP[0]:=0;  PP[1]:=A[0];
    QQ[0]:=1;  QQ[1]:=n-A[0]*A[0];
    i:=2;
    last:=2*a[0];
    IF a[1]<>last then
    repeat
      PP[i]:=a[i-1]*QQ[i-1]-PP[i-1];
      QQ[i]:=(n-PP[i]*PP[i]) div QQ[i-1];
      a[i]:=(a[0]+PP[i])div QQ[i];
      inc(i);
    until (a[i-1]=last) or (i>high(a));
    if a[i-1]=last then
    begin
      result:=i-1;
      {Let's go ahead and compute the solution}
      {result is the partial quotient = to 2a[0].  r, cycle length is result-1)
      {if r is odd, p[r], q[r] is minimal solution,
      else if r is even,  p[2*r+1], q[2*r+1] is the minimal solution}
      r:=result-1;
      if (r) mod 2 = 0 then stop:=2*r+1 else stop:=r;
      setlength(p,stop+1); setlength(q,stop+1);
      for i:=0 to stop do
      begin
        p[i]:=Tinteger.create;
        q[i]:=TInteger.create;
      end;
      p[0].assign(a[0]);
      q[0].assign(1);
      p[1].assign(a[1]); p[1].mult(p[0]); p[1].add(1);
      q[1].assign(a[1]); q[1].mult(q[0]);
      for i:=2 to stop do
      begin
        ai:=i;
        if ai>result then ai:=(i-1) mod result +1;
        p[i].assign(a[ai]); p[i].mult(p[i-1]); p[i].add(p[i-2]);
        q[i].assign(a[ai]); q[i].mult(q[i-1]); q[i].add(q[i-2]);
      end;
      XSolve.assign(p[stop]);
      ySolve.assign(q[stop]);
    end
    else
    begin
      result:=-1;
      showmessage('no cycle found for '+inttostr(n));
    end;
  end
  else result:=-1;
end;

{************** TPell.GetNextConvergent *************}
function TPell.GetNextConvergent(var NextP,NextQ:TInteger):boolean;
var
  ai:integer;
begin
  if highcycle>0 then
  begin
    if lastconvergent>high(p) then
    begin
      setlength(p,length(p)+1);
      setlength(q,length(q)+1);
      p[high(p)]:=TInteger.create;
      q[high(q)]:=Tinteger.create;
    end;
    if lastconvergent=0 then
    begin
      p[0].assign(a[0]);
      q[0].assign(1);
    end
    else if lastconvergent=1 then
    begin
      p[1].assign(a[1]); p[1].mult(p[0]); p[1].add(1);
      q[1].assign(a[1]); q[1].mult(q[0]);
    end
    else
    begin
      ai:=lastconvergent;
      if ai>highcycle then ai:=(ai-1) mod highcycle + 1;
      p[lastconvergent].assign(a[ai]); p[lastconvergent].mult(p[lastconvergent-1]);
      p[lastconvergent].add(p[lastconvergent-2]);
      q[lastconvergent].assign(a[ai]); q[lastconvergent].mult(q[lastconvergent-1]);
      q[lastconvergent].add(q[lastconvergent-2]);
    end;
    nextp.assign(p[lastconvergent]);
    nextq.assign(q[lastconvergent]);
    inc(lastconvergent);
    result:=true;
  end
  else result:=false;
end;

{************* IsSquare ***********}
function isSquare(const N:Int64):boolean;
{returns true if N is a perfect square }
var i:integer;
begin
  i:=trunc(sqrt(0.0+N));
  if i*i=N then result:=true
  else result:=false;
end;

{************* FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Pell:=TPell.create;
  BigP:=TInteger.create;
  BigQ:=TInteger.create;
  BigRatio:=TBigFloat.create;
  sqrtof:=0;
end;

{**************** PellBtnClick ***********}
procedure TForm1.PellBtnClick(Sender: TObject);
{Solve diophantine}
var
  i:integer;
  d:int64;
  solved:boolean;
  s:string;
begin
  sqrtof:=0;  {for next sqrt button click to reinitialize}
  memo2.clear;
  bigP:=TInteger.create;
  bigq:=Tinteger.create;
  D:=NewValupdown.position;
  if not IsSquare(d) then
  begin
    if pell.setN(D)>0 then
    begin;
      bigP.assign(pell.xsolve); bigq.assign(pell.YSolve);
      bigP.mult(bigp); bigq.mult(bigq);
      bigq.mult(D);
      bigp.subtract(bigQ);
      if bigP.compare(1)=0 then  {x^2-dy^2=1}
      with pell do
      begin
        s:='Partial Quotients: ('+inttostr(a[0])+';[';
        for i:=1 to highcycle do s:=s+inttostr(a[i])+',';
        delete(s,length(s),1);
        s:=s+'])';
        memo2.lines.add(s);
        memo2.lines.add('Minimal solution is X='+ xsolve.converttodecimalstring(true));
        memo2.lines.add('                             Y='+ysolve.converttodecimalstring(true));
        memo2.lines.add('');

        memo2.lines.add('  '+xsolve.converttodecimalstring(true)+'^2 - '
                             +inttostr(d)+' * '
                             + ysolve.converttodecimalstring(true)+'^2 = 1');
      end
      else memo2.lines.add('No solution found for D='+inttostr(D));
    end;
  end
  else showmessage('No solution possible for N= perfect square');
end;


{************* NewvalUpDownChangingEx **************}
procedure TForm1.NewValUpDownChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  if not issquare(newvalue)
  then
  begin
    allowchange:=true;
    sqrtOf:=Newvalue;
    memo2.clear;
    pell.setn(Sqrtof);
  end
  else
  begin
    case direction of
      updUp: NewValEdt.text:=inttostr(newvalue+1);
      upddown:NewValEdt.text:=inttostr(newvalue-1);
    end;
    allowchange:=false;
  end;
end;

{*************** SqrtBtnClick ****************}
procedure TForm1.SqrtBtnClick(Sender: TObject);
var
  temp1,temp2:TBigFloat;
  allowchange:boolean;
begin
  if not issquare(NewVaLupdown.position) then
  begin
    temp1:=TBigfloat.create;
    temp2:=TBigfloat.create;
    if sqrtof=0 then {reinitialize}
               NewValUpDownChangingEx(Sender, AllowChange,
                                      NewValupdown.position,
                                      updNone);
    pell.getnextconvergent(BigP,Bigq);
    temp1.assign(Bigp); temp2.assign(Bigq);
    if pell.lastconvergent<2 then
    begin
      temp1.setsigdigits(2);
      temp1.divide(temp2,4);
      temp1.round;
      bigratio.assign(temp1);
    end
    else
    begin
      temp1.divide(temp2,100); temp2.assign(temp1); temp2.subtract(bigratio);
      {Add a couple of digits beyond the difference from previous estimate}
      temp1.setsigdigits(-temp2.exponent+3);
      bigratio.assign(temp1);
    end;
    memo2.lines.add('Estimate for sqrt('+inttostr(sqrtof)+') = '+bigp.converttodecimalstring(true)+'/'
                    +bigq.converttodecimalstring(true));
    memo2.lines.add('     '+bigratio.shownumber(normal));
    temp1.free; temp2.free;
  end
  else showmessage('No Continued Fraction solution possible for N = perfect square');;
end;

{************** StaticText1Clcik **********}
procedure TForm1.StaticText1Click(Sender: TObject);
{Open browser with home page of DelphiForFun.org  }
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{*************** NewValEdtKeyPress ***************}
procedure TForm1.NewValEdtKeyPress(Sender: TObject; var Key: Char);
{make sure that only numbers get entered for N}
begin
  If not (key in ['0'..'9']) then key:=#00;
end;

end.
