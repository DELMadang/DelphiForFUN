unit U_X4X2;
 {Copyright 2000, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Test if x^4-X^2 is a multiple of 12 for all integer values of X > 1.
  We can't test them all, so test as many as possible - we might prove
  the proposition to be false, we can never prove it to be true by experimental
  methods.  Luckily mathematical methods can bail us out.
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Check32Btn: TButton;
    Label1: TLabel;
    Check64Btn: TButton;
    procedure Check32BtnClick(Sender: TObject);
    procedure Check64BtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses math;

{$R *.DFM}

procedure TForm1.Check32BtnClick(Sender: TObject);
{We're checking X^4-X^2 values so we can uses X values
 up to 4th root of maxinteger}
var i,stop,errcount:integer;
begin
  {power returns 4th root of highest possible value for i,(high(i))}
  {trunc converts it from a real nbr to the next lower integer}
  stop:=trunc(power(high(i),0.25));
  errcount:=0;
  For i := 2 to stop do
  if (i*i*(i*i-1)) mod 12 >0 then inc(errcount);
  showmessage('Done - all integers between 2 and '
              +inttostr(stop) +' checked, '+inttostr(errcount)
              +' were not multiples of 12');
end;

procedure TForm1.Check64BtnClick(Sender: TObject);
{Same thing as above, but with long integers}
var i,stop:int64;
    errcount:integer;
begin
  stop:=trunc(power(high(i),0.25));
  i:=2;
  errcount:=0;
  {DO loop control variable only operates on 32 bit integer values}
  {So we'll use a WHILE loop}
  While i<= stop do
  begin
    if (i*i*(i*i-1)) mod 12 >0 then inc(errcount);
    inc(i);
  end;
  showmessage('Done - all integers between 2 and '
              +inttostr(stop) +' checked, '+inttostr(errcount)
              +' were not multiples of 12');
end;

end.
