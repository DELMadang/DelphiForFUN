unit U_RecurringQuotient;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  i,k:integer;
  {array to hold counts, position in array is the quotient}
  Counts:array[1..10000] of integer;
  cnt, maxcnt,maxq:integer;
  sum,int,d:integer;
begin

  for i:=1 to 10000 do Counts[i]:=0; {initialize counts to 0}
  {loop over all 5 digit numbers}
  for i:= 10000 to 99999 do
  Begin
    sum:=0;
    int:=i;
    while int>0 do
    Begin
      k:=int mod 10;
      sum:=sum+k;
      int:= int div 10;
    end;
    if i mod sum=0 then inc(Counts[i div sum]);
  end;
  maxcnt:=0;
  cnt:=0;
  for i:=1 to 10000 do
  Begin
    If Counts[i]>0 then inc(cnt);
    if Counts[i]>maxcnt then
    Begin
      maxcnt:=Counts[i];
      maxq:=i;
    end;
  end;
  label1.caption:='Quotient '+inttostr(maxq)
                +' occurs  most fequently ('
                +inttostr(maxcnt) +' times)';

  label2.caption:='Number of 5 digit numbers exactly divisible by sum of digits is '+inttostr(cnt);
end;

end.
