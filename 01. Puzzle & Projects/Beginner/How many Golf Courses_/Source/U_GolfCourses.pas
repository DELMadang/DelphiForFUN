unit U_GolfCourses;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
A championship 18 hole golf course  has holes with a par scores of 3, 4,
or 5 strokes and a total par for the couse of 72 strokes (I think).

So how many different combinations of holes could there be that meet
these conditions?  (For extra credit, how many arrangements of each of
the possible combinations?)

For example: some of the  courses would have one par 3, sixteen par 4's
and one par 5 holes.  The par 3 could be at any of the 18 holes and the
par 5 at any of the remaining 17, for a total of 18X17 or 306 arrangements
of this combination.

In general if we have A par 3's and B par 4's then the number of
arrangements is the number of unique ways we could select A of the 18
holes times the number of unique ways we could select B from the
remaining 18-A holes.  Then the remaining 18-A-B holes are the par 5's of
course..  (A and B could represent the counts of any two par values,
answer will be the same)
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin;

type
  TIntArray=array[0..2] of integer;
  TForm1 = class(TForm)
    SolveBtn: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    HolesEdt: TSpinEdit;
    ParEdt: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure SolveBtnClick(Sender: TObject);
  public
    { Public declarations }
    values:TIntarray;
    nbrholes:integer;
    totpar:integer
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** Permutes **********}
function permutes(r,n:integer):int64;
{compute nbr of permutations of n things taken r at a time
 as n*(n-1)*(n-2)....*(n-r-1)}
var  i:integer;
begin
  if r=0 then result:=1
  else
  begin
    result:=n;
    for i:= 1 to r-1 do result:=result*(n-i);
  end;
end;

{*************** Combinations ***********}
function combinations(r,n:integer):int64;
{computer nbr of combinations of n things taken r at a time
 as permutes(r,n) divided by r! (i.e. r*(r-1)*(r-2)...*2)}
 var i:integer;
 begin
   result:=permutes(r,n);
   for i := 2 to r do result:=result div i;
 end;

{**************** SolveBtnClick **************}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  a,b,c:integer;
  p: real;
  pword:string; {"arrangement" (singular) or "arrangements" (plural)}
begin
  listbox1.clear;
  nbrholes:=holesedt.value;
  totpar:=paredt.value;
  {try all possible combinations of hole sizes checking for those that
   meet the conditions}
  for a:= 0 to nbrholes do
  for b:= 0 to nbrholes-a do
  begin
    c:=nbrholes-a-b;
    If (3*a+4*b+5*c=totpar) then
    begin
      p:=combinations(a,nbrholes)*combinations(b,nbrholes-a);
      if p=1 then pword:='arrangement' else pword:='arrangements';
      listbox1.items.add(format('%3d par three, %3d par four, %3d par five,'
      +' (with %1.0n %s)'  ,[a,b,c,p, pword]));
    end;
  end;
end;

end.
