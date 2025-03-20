unit U_SquaresCubes5;
{Whew!  This could be a tough one.  }
{Find two  integers with the following properties:
 The square of the first equals the cube of the
second and together they contain all of the
digits 0 to 9 exactly once.}

{Since there are 10 digits in the results, there
must be 4 in the nbr to be cubed and 6 in the  nbr
to be squared.  4 digit numbers range from 10^3 to 10^4
so cubed values will range from 10^9 to 10^12, 10 to 13
digits.  6 digit numbers(10^5 to 10^6) squared will also
range from 11 to 13 digits.  Proof that no other lengths
can work:

Nbr digits  MinVal   MaxVal   Cubed       Nbr Digits
                              Min   Max   Min Max
   3        10^2     10^3     10^6  10^9    7  10
   4        10^3     10^4     10^9  10^12  10  13
   5        10^4     10^5     10^12 10^15  13  16

                              Squared     Nbr Digits
                              Min    Max   Min  Max
   5        10^4     10^5     10^8  10^10   9   11
   6        10^5     10^6     10^10 10^12  11   13
   7        10^6     10^7     10^12 10^14  13   15
 }

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

{$R *.DFM}

Uses Combo, math;

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  n,n2,n3:int64;
  solved:boolean;
  i:int64 ;
  j:integer;
  combo:TComboset;
  s:string;
  c:string;
begin
  {Find 2 numbers m and n such that m^2 = n^3 and together m and n
  contain all of 10 digits 0..9.}
  combo:=TComboset.create;
  i:=1233;   {start at smallest 4 digit # with 4 different digits}
  screen.cursor:=crHourGlass;
  solved:=false;
  {stop at largest with 4 different digits or when solved}
  while (i < 9876) and (not solved) do
  begin
    inc(i);
  {check to see if i has 4 different digits}
    s:=inttostr(i);
    c:='0123456789';
    {make an array of the unused digits}
    for j:= 1 to length(s) do c[ord(s[j])-ord(pred('0'))]:='_';
    {delete used numbers - from back to front to preserve valid indexing}
    for j:= 10 downto 1 do if c[j]='_' then delete(c,j,1);
    if length(c)=6 then {we deleted 4 different digits, keep checking}
    begin
      n3:=i*i*i;
      {init combo to get all 6 of 6 permutations}
      combo.setup(6,6,permutations);
      while combo.getnext do
      begin
        n:=0;
        for j:=1 to 6 do n:=n*10+ord(c[combo.selected[j]])-ord('0');
        n2:=n*n;
        if n2=n3 then
        begin
          showmessage (format('Found!  %4.0n squared = %6.0n cubed = %10.0n',
                       [0.0+n, 0.0+i, 0.0+n2]));
           {note: adding 0.0 above forces conversion to floating pt for formatting}
          solved:=true;
          break;
        end
        {since we generate values in order, if n2 gets
        bigger than n3, we can stop checking}
        else if n2>n3 then break;
      end;
    end;
  end;
  screen.cursor:=crDefault;
end;


end.
