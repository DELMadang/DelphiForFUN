unit U_Weights1;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TWeightArray=array of integer;
  TForm1 = class(TForm)
    NbrWeightsUD: TUpDown;
    Edit1: TEdit;
    SearchBtn: TButton;
    ListBox1: TListBox;
    ScaleBtn: TButton;
    Panel1: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    StatusBar1: TStatusBar;
    Label3: TLabel;
    procedure SearchBtnClick(Sender: TObject);
    procedure ScaleBtnClick(Sender: TObject);
    public
      maxmaxw:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math, combo, U_Weights1_2;

{************** Getvalue *************}
function Getvalue(nbr:integer; weights:TweightArray):integer;
{returns to "nbr"th value from all possible weighing values that can be
 achieved with the weights in the "weights" array}
 { we treat "nbr" as a mask representing  an equation of the form:
   f1*a op1 f2*b op2 f3*c op3 ....,etc.
   where each fi is a 0 or 1 multiplier, each opi is + or - operation.
  }
var
  i,a,v,mask:integer;
begin
  v:=0;
  mask:=1;
  for i:= high(weights) downto 1 do
  begin
    {Should this weight be included?}
    if nbr and mask >0 then a:=weights[i] else a:=0;
    {move bit to sign position}
    mask:=mask shl 1; {move to next operator position}
    if nbr and mask >0 then a:=-a; {is this a subtraction?}
    v:=v+a; {add term to value}
    mask:=mask shl 1; {move to next multiplier position}
  end;
  result:=v;
end;

(*
function factorial(n:integer):integer;
{compute n factorial - recursive version}
begin
  if n<=1 then result:=1
  else result:=n*factorial(n-1);
end;
*)

Function factorial(n:word):integer;
{Compute n factorial: non-recursive}
    Var k:integer;
        i:word;
    Begin
      k:= 1;
      For i:= 2 to n do k:= k*i;
      result:=k;
    End; {Factorial}

{************** C ************}
function c(r,n:integer):integer;
{return the number of combinations of n things taken r at a time}
begin
  result:=factorial(n) div (factorial(r)*factorial(n-r));
end;

{**************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Search for best weight set}
var
  i,nbrweights,w:integer;
  ww:array of boolean;
  max, maxw:integer;
  weights:TWeightArray;
  s:string;
begin
  listbox1.clear;
  nbrweights:=nbrweightsud.position;
  {The maximum number of consecutive integer weights is the number of ways we can
   add and subtract each number of weights up to all weights
   FOR EXAMPLE: with 3 weights, (a,b,c) arranged in descending order,
   max possible weighings are a, b, c, a+b, a-b, a+c, a-c, b+c, b-c, a+b+c,
   a+b-c, a-b+c, a-b-c.  So we only need to check for weights up to 13 and 1 to 13
   is the maximum range of consecutive weights that can be determined.
   The equation for this number turns out to be the sum for i:= 1 to nbrweights
   of combos(i,n)*2^(i-1), where combos(i,n) is the number of combinations of
   n things taken i at a time.  If we denote this as maxw(N), we can take
   advantage of the fact that each increase in number of weights triples the
   number of unknown weights that can be determined.  (Weight "d" could be
   appended to each of the 13 equations above with a multiplier of +1, 0, or -1.
   In addition, d could be used alone, So maxw can also be defined recursively as
   maxw(n)=3*maxw(n-1)+1, this is equivalent to (3^n-1)/2 }

  max:=0;
  for i:=1 to nbrweights do max:=max+c(i,nbrweights)*(1 shl (i-1));

  {set up to generate all valid weight combinations}
  combos.setup(nbrweights, trunc(intpower(3,nbrweights-1)) ,combinations);
  setlength(weights,nbrweights+1);
  setlength(ww,max+1);
  maxmaxw:=0;
  screen.cursor:=crhourglass;
  repeat
    for i:= 1 to max do ww[i]:=false; {array of possible contigous weighing values}
    for i:=1 to nbrweights do weights[i]:=combos.selected[i-1]; {assign weights}
    {we may have to search much higher than "max" to find the max consecutive
     values available from this weight combination, in fact each weight will
     increase the number of numbers checked by a factor of four, so 2^(2*n) will
     do it.  Getvalue checks equations using a virtual equation of the form
     a op b op c with one bit in the passed number representing each of the
     entities, a one bit for a, b, or c indicates the presence of that variable,
     a one bit in the op positions indicates that the operation is subtraction.
     The number of entities in equations for n weights  is 2n-1 so to get the
     all 2n-1 bit turned on, we need to check numbers up to 2^2n }
    for i:= 1 to (1 shl (2*nbrweights)) do {get all possible results using these n weights}
    begin
      w:=getvalue(i,weights);
      if (w>0) and (w<=max) then ww[w]:=true; {marked this value as possible}
    end;
    s:=inttostr(weights[1]);
    for i:=2 to nbrweights do s:=s+',' +inttostr(weights[i]);
    maxw:=0;
    while ((maxw+1)<=high(ww)) and ww[maxw+1] do inc(maxw);
    if maxw>=maxmaxw then
    begin
      listbox1.items.add('Weights '+s + ' generate from 1 to '+inttostr(maxw));
      listbox1.itemindex:=listbox1.items.count-1;
      listbox1.update;
      maxmaxw:=maxw;
      if maxmaxw=max then break;
    end;
  until not combos.getnext; {get a set of weights to test}
  screen.cursor:=crdefault;
end;

{************* ScaleBtnClick ***************}
procedure TForm1.ScaleBtnClick(Sender: TObject);
begin
  form2.nbrweights:=nbrweightsUD.position;
  form2.showmodal;
end;

end.
