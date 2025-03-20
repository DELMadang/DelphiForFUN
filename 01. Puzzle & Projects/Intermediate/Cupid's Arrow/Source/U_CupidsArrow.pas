unit U_CupidsArrow;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
 Selecting from the numbers 1 through 9, place one digit in each of the
circles representing points on Cupid's bow according to the following rule:

Each pair of digits connnectect by a black line must form a 2-digit
number that is evenly divisible by 7 or13,  For example 7 and 8
connected by a line would be appropriate because the number 78 is
divisible by 13.  You can consider the 2 digits in either order and no
digit may be used more than once.

"For every solution you find" said Cupid before flying off, "you win
someone's heart. If you can find a solution in which the numbers
connected by the blue lines qualify as well,  you will always be in
love!"

Adapted from "Wonder of Numbers", Clifford Pickover
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    SolveBtn: TButton;
    ListBox1: TListBox;
    Memo1: TMemo;
    C1: TShape;
    C2: TShape;
    C3: TShape;
    C4: TShape;
    C5: TShape;
    Label1: TLabel;
    StatusBar1: TStatusBar;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
  public
     p:array[1..5] of Tpoint; {Centers of the 5 points on the bow}
  end;

var Form1: TForm1;

implementation

{$R *.DFM}
uses UComboV2;

var
  {All edges, connected pairs of vertices,
   these connected vertices must contain numbers divisible by 7 or 13}
   edges: array[1..8,1..2] of integer= ((1,5),(2,5),(3,5),(4,5),(3,4),(2,3),(1,2),(4,1));

procedure TForm1.SolveBtnClick(Sender: TObject);
var
  ok:boolean;
  i:integer;
  msg:string;

    function isOK(i:integer):boolean;
    {check if numbers connected by edge are valid}
    begin
      with combos do
      if ((10*selected[edges[i,1]]+selected[edges[i,2]]) mod 7=0) or
          ((10*selected[edges[i,1]]+selected[edges[i,2]]) mod 13=0) or
          ((10*selected[edges[i,2]]+selected[edges[i,1]]) mod 7=0) or
          ((10*selected[edges[i,2]]+selected[edges[i,1]]) mod 13=0)
      then result:=true  else result:=false;
    end;

begin
   invalidate;  {force repaint to clear any numbers from image}
   listbox1.clear;
   listbox1.items.add('Click a solution to see the numbers in Cupid''s bow');
   combos.setup(5,9,permutations);
   {we will just check all ways to choose 5 of the 9 digits}
   with combos do
   while getnext do
   begin
     ok:=true;
     for i:=1 to 6 do if not isOK(i) then {check first 6 edges}
     begin
       OK:=false;
       break;
     end;
     if Ok then {1st 6 edges OK, check the bow string}
     begin
       if isOK(7) and isOK(8) then msg:=' (Bow string (blue) also satisfies condition)'
       else msg:='';
       listbox1.items.add(format('%d, %d, %d, %d, %d ',
              [selected[1],selected[2],selected[3],selected[4],selected[5]])+msg);
     end;
   end;
end;

procedure TForm1.FormActivate(Sender: TObject);

begin
  with c1 do p[1]:=point(left+ width div 2, top+height div 2);
  with c2 do p[2]:=point(left+ width div 2, top+height div 2);
  with c3 do p[3]:=point(left+ width div 2, top+height div 2);
  with c4 do p[4]:=point(left+ width div 2, top+height div 2);
  with c5 do p[5]:=point(left+ width div 2, top+height div 2);
end;

{**************** FormPaint **********}
procedure TForm1.FormPaint(Sender: TObject);
{draw Cupids Bow }
begin
  with canvas do
  begin
    pen.width:=3;
    pen.color:=clblack;
    arc(2*p[2].x-p[3].x,p[2].y,p[3].x,p[4].y,p[4].x,p[4].y,p[2].x,p[2].y); {the bow}

    with p[5] do moveto(x,y);  with p[1] do lineto(x,y);
    with p[5] do moveto(x,y);  with p[2] do lineto(x,y);

    with p[5] do moveto(x,y);  with p[3] do lineto(x,y);
    with p[5] do moveto(x,y);  with p[4] do lineto(x,y);

    pen.width:=1;
    pen.color:=clblue;
    with p[1] do moveto(x,y);  with p[2] do lineto(x,y);
    with p[4] do moveto(x,y);  with p[1] do lineto(x,y);
  end;
end;


{***************** ListBox1Click *************}
procedure TForm1.ListBox1Click(Sender: TObject);
{Show the solution clicked by the user}
var
  i:integer;
  line:string;
begin
  with canvas do
  if listbox1.itemindex>0 then
  begin  {show the numbers assigned to each vertex (circle)}
    with listbox1 do line:=items[itemindex];
    textout(p[1].x-4,p[1].y-6,line[1]);
    textout(p[2].x-4,p[2].y-6,line[4]);
    textout(p[3].x-4,p[3].y-6,line[7]);
    textout(p[4].x-4,p[4].y-6,line[10]);
    textout(p[5].x-4,p[5].y-6,line[13]);
  end;
end;

end.
