unit U_PandigitalFractions;
 {Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{I recently received this email:

Dear Delphiforfun,

I have been investigating some variations on a classical problem involving
pandigital fractions and wonder if you have seen solutions.

Classical Problem -- I solved this one
If each of the first 9 letters represents a different number--1 through 9, the
smallest integer represented by: A/BC + D/EF + G/HI = 1; this assumes that the
denominators are two-digit numbers and NOT multiplied.

My Variations -- Need Verification of Solutions
I have modified the classical equation so that the denominators are multiplied
as follows: A/(B*C) + D/(E*F) + G/(H*I) and believe the smallest integral answer
is 2. Can you verify that?

For (A/B)*C + (D/E)*F + (G/H)*I, I think the smallest integral answer is 5.

For (A/B)^C + (D/E)^F + (G/H)^I. the smallest integral answer I have found is
1,100, but I suspect there is a smaller solution.

Regards, Jerry

Well Jerry, assuming that you are not a programmer and were doing this by hand,
1 correct out of 3 isn't bad!
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    Button3: TButton;
    Button4: TButton;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    Memo1: TMemo;
    Label2: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    a,b,c,d,e,f,g,h,i:extended;
    minx:extended;
    procedure assignvalues;
    procedure CheckAndShowValues(x:extended);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math,combo;

var maxerr:extended = 1e-32;

procedure TForm1.assignvalues;
{Assign permutaion values to variables just to shorten and clarify reading the
 evaluation code}
begin
  with combos do
  begin
    a:=selected[1];
    b:=selected[2];
    c:=selected[3];
    d:=selected[4];
    e:=selected[5];
    f:=selected[6];
    g:=selected[7];
    h:=selected[8];
    i:=selected[9];
  end;
end;

{****************** ShowValues *************}
procedure Tform1.CheckAndShowvalues(x:extended);
{Display solution if it is a new minimum}

begin
  If (abs(x-int(x))<maxerr) and (x<minx) then
  begin
    listbox1.items.add(
     format('f(%.0n,%.0n,%.0n,%.0n,%.0n,%.0n,%.0n,%.0n,%.0n)=%.0n',[a,b,c,d,e,f,g,h,i,x]));
    minx:=x;
  end;

end;

procedure TForm1.Button1Click(Sender: TObject);
{A/BC+D/EF+G/HI=?}
var x:extended;
begin
  listbox1.clear;
  minx:=1e6;
  combos.setup(9,9,Permutations);
  while combos.getnext do {for all permutaions}
  begin
    assignvalues;
    x:=a/(10*b+c)+d/(10*e+f)+g/(10*h+i);
    {Make sure that value is very close to an integer}
    CheckAndShowValues(x);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
  {A/(B*C)+D/(E*F)+G/(H*I)=? }
var x:extended;
begin
  listbox1.clear;
  minx:=1e6;
  combos.setup(9,9,Permutations);
  while combos.getnext do {for all permutaions}
  begin
    assignvalues;
    x:=a/(b*c)+d/(e*f)+g/(h*i);
    {Make sure that value is very close to an integer}
    CheckAndShowValues(x);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
 {(A/B)*C+(D/E)*F+(G/H)*I}
var x:extended;
begin
  listbox1.clear;
  minx:=1e6; {initalize smalest to a larg value}
  combos.setup(9,9,Permutations);
  while combos.getnext do {for all permutaions}
  begin
    assignvalues;
    x:=(a/b)*c+(d/e)*f+(g/h)*i;
    {Make sure that value is very close to an integer}
    CheckAndShowValues(x);
  end;
end;



procedure TForm1.Button4Click(Sender: TObject);
{(A/B)^C+(D/E)^F+(G/H)^I}
var x:extended;
begin
  listbox1.clear;
  minx:=1e6;
  combos.setup(9,9,Permutations);
  while combos.getnext do {for all permutaions}
  begin
    assignvalues;
    x:=power((a/b),c)+power((d/e),f)+power((g/h),i);
    {Make sure that value is very close to an integer}
    CheckAndShowValues(x);
  end;
end;

end.
