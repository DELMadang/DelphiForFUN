unit U_ThreeNPlus1;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    SeatchBtn: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Memo2: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure SeatchBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************ GetCycleLength ************}
function GetCycleLength(NN: integer): int64;
{Evaluate the "3n+1" cycle for input NN and return the length of the cycle}
var k: integer;
    N: int64;
begin
  k := 1;
  N:=NN;
  while N > 1 do
  begin
    if odd(N) then N := 3*N + 1
    else N := N div 2 ;
    inc(k);
  end;
  result := k;
end;

{*************** GetMaxCycleLength ***********}
procedure GetMaxCycleLength(i, j: integer; var max, maxn:integer);
{Find the cycle lengths for all integers between i and j inclusive and reutrn
 the length and value for the longest cycle}
var k: integer;
   low,high:integer;
   curCL: int64;

begin
  max := 0;
  maxn:=0;
  if j<i then
  begin
    low:=j;
    high:=i;
  end
  else
  begin
    low:=i;
    high:=j;
  end;

  for k:=low to high do
  begin
    curCL := GetCycleLength(k);
    if curCL > max then
    begin
      max := curCL;
      maxn:=k
    end;
  end;
end;

{********* SearchBtnClick **************}
procedure TForm1.SeatchBtnClick(Sender: TObject);
{Find the maximum cycle length between two input values and display result}
var
  low,high:integer;
  max, maxn:integer;

begin
  low:=strtointdef(edit1.text,0);
  high:=strtointdef(edit2.text,0);
  GetMaxCycleLength(low,high, max, maxn);
  Memo2.Clear;
  memo2.lines.add(format('Between %d and %d the max cycle length is %d for N=%d',
                        [low,high,max,maxn]));
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
