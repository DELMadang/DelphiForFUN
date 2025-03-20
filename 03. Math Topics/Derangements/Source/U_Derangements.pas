unit U_Derangements;
{Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A derangement is a permutation with no member in its natural location.  This
  propgram explores some properties of derangements}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Spin, StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    CalcChanceBtn: TButton;
    SpinEdit1: TSpinEdit;
    Memo2: TMemo;
    ShowDetailBtn: TButton;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    Label2: TLabel;
    procedure CalcChanceBtnClick(Sender: TObject);
    procedure ShowDetailBtnClick(Sender: TObject);
  end;

var Form1: TForm1;

implementation

{$R *.DFM}

uses Ucombos;

{************ Factorial **********}
function factorial(n:integer):int64;
var i:integer;
begin
  result:=1;
  for i:=2 to n do result:=i*result;
end;


{******************* CalcChanceBtnClick *********}
procedure TForm1.CalcChanceBtnClick(Sender: TObject);
{Calculate the number of derangements for the specified nbr}
var
  n:integer;
  p,d:extended;
begin
  with memo2 do
  begin
    clear;
    n:=spinedit1.value;
    p:=factorial(n);
    d:=round(factorial(n)/exp(1.0));
    lines.add(format( 'Out of %.0n permutations of %d numbers, %.0n are derangements,'
             +' i.e. arrangements with every digit out of place.  '
             +' The chance of a derangement is %.1n%%',[p,n,d,100*d/p]));
    lines.add(' ');
    lines.add('The surprising fact is that the number of derangements is always'
              + ' the nearest integer to number of'
              +' possible arrangements (N!, N factorial) divided by "e" the base of'
              +' the natural logartithms, approximately 2.71828.  So'
              +' the probabilitiy of a derangement of a randomly selected'
              +' permutation is always close to (N!/e)/N! or 1/e for any N.'    );
    lines.add(' ');
    if n=10 then
     lines.add('Since the chances of Max''s screwup being accidental are nearly 40%, it looks like his job is safe for another day.');
  end;
end;


{**************** ShowDetailBtnClick **********}
procedure TForm1.ShowDetailBtnClick(Sender: TObject);
{There may be a better way, but this procedure generates derangements simply by
 generating all permuations and discarding those that have a number int its
 correct location}
var
  n,i:integer;
  s:string;
  count:integer;
  derangement:boolean;
begin
  n:=spinedit1.value;
  memo2.clear;
  s:='';
  for i:=1 to n do s:=s+inttostr(i)+',';
  delete(s,length(s),1);
  memo2.lines.add('For natural order '+s);
  memo2.lines.add(' ');
  memo2.Lines.add('Derangements are: ');
  memo2.lines.add(' ');
  with combos do
  begin
    setup(n,n,permutations);
    count:=0;
    while (count<100) and getnextpermute do
    begin
      derangement:=true;
      for i:=1 to n do if selected[i]=i then
      begin
        derangement:=false;
        break;
      end;
      if derangement then
      begin
        inc(count);
        s:='';
        for i:=1 to n do s:=s+inttostr(selected[i])+',';
        delete(s,length(s),1);
        memo2.lines.add(format('%4d:     %s', [count,s]));
      end;
    end;
  end;
end;

end.
