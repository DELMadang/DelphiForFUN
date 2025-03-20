unit U_CarTalk_ReversedAges;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

//  "Car Talk" Puzzler March 29, 2008:
{

Flipping Ages


RAY:  This was sent in many weeks ago by Wendy
Gladstone, and as usual I tweaked it a little bit.

She writes: "Recently I had a visit with my mom and we
realized that the two digits that make up my age when
reversed resulted in her age.  For example, if she's 73,
I'm 37. We wondered how ften this has happened over
the years but we got sidetracked with other topics and
we never came up with an answer.

"When I got home I figured out that the digits of our
ages have been reversible six times so far. I also figured
out that if we're lucky it would happen again in a few
years, and if we're really lucky it would happen one
more time after that. In other words, it would have
happened 8 times over all. So the question is, how old
am I now?"
}



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
end;
var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  son,diff,mom,count,i:integer;
  ages:array[1..10] of TPoint;
begin
  for diff:=10 to 50 do {loop on possible age differences}
  begin
    count:=0;  {reset Nbr of reversals for this age difference}
    for son:=1 to 100-diff do {for all reasonable son's ages}
    begin
      mom:=son+diff;
      {"age div 10" will be the leftmost and "age mod 10" will be the rightmost digit}
      if (son mod 10 = mom div 10) and (son div 10=mom mod 10) then
      begin  {save the ages, in case this is the solution case}
        inc(count);  {count the reversals}
        ages[count]:=point(son,mom); {save the ages}
      end;
    end;
    if count=8 then { a solution!}
    begin
      memo2.lines.add(format('Age diff:%d, Reversals:%d',[diff,count]));
      for i:=1 to count do  {display the 8 flipped age values}
      with memo2, ages[i] do
      if i<>6 then lines.add(format('Son:%d, Mom:%d',[x,y]))
      else {flag the 6th age, the solution}
      lines.add(format('Son:%d,  Mom:%d  <==== Solution!',[x,y]));
    end;
  end;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
