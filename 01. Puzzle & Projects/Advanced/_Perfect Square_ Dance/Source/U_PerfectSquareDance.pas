unit U_PerfectSquareDance;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{
 (From "Car Talk Puzzler" for October 19, 2008:
http://www.cartalk.com/content/puzzler/)

"RAY: Sally invited 17 guests to a dance party at her estate
in the Hamptons. She assigned each guest a number from 2
to 18, keeping 1 for herself.

At one point in the evening when everyone was dancing,
Sally noticed the sum of each couple's numbers was a
perfect square. Everyone was wearing their numbers on their
clothing.

The question is, what was the number of Sally's partner?

Here's a reminder: a perfect square is attained by squaring,
or multiplying by itself, an integer. So four is a perfect
square of two. Nine is a perfect square of three. Sixteen is a
perfect square of four. So these numbers are adding up to
either 4, 9, 16, 25, etc.

And the question is, with the information you have available
to you, what's the number of her partner?"
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    SolveBtn: TButton;
    possiblepairs: TListBox;
    Label1: TLabel;
    Verbose: TCheckBox;
    procedure StaticText1Click(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
  end;

var Form1: TForm1;

implementation
{$R *.DFM}

(*
{******* IsSquare ********}
function IsSquare(n:integer):boolean;  {test for "squareness: property}
var i:integer;
begin
  i:=trunc(sqrt(n)); {get the integer version of the square root of n}
  result:=i*i=n;  {result=true if i*i=n, false otherwise}
end;
*)

{******* IsSquare ********}
function IsSquare(n:integer):boolean;  {limited test for "squareness: property}
{Numbers to be tested are at most 35 (18+17) so we only need to check for a few values}
begin
  if (n=4) or (n=9) or (n=16) or (n=25) then result:=true
  else result:=false;
end;

{********* SolvebtnClick ***********}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i,j:integer;
  pairs, finalpairs, paircounts:array[1..18] of integer;
  onefound:boolean;
  passcount:integer;
begin
  with possiblepairs do
  begin
    clear;
    passcount:=0;
    for i:=1 to 18 do
    begin
      paircounts[i]:=0;
      finalpairs[i]:=0;
    end;
    repeat
      inc(passcount);
      if verbose.checked
      then
      begin
        items.add('');
        items.add(format('Pass %d looking for forced pairings',[passcount]));
      end;
      for i:=1 to 17 do  {check pairs using numbers that haven't already been paired}
      for j:=i+1 to 18 do
      begin
        if isSquare(i+j) and (finalpairs[i]=0)
        and (finalpairs[j]=0) then
        begin {i,j is a pair with square sum and neither # assigned to a final pair yet}
          if verbose.checked
          then items.add(format('%2d+%2d=%3d',[i,j,i+j]));
          inc(paircounts[i]); {count number of pairs in which i and j appear}
          inc(paircounts[j]);
          pairs[i]:=j; {save the other number of the pair for each #}
          pairs[j]:=i; {in case it is a unique pair                 }
        end;
      end;
      onefound:=false; {we'll stop the loop when this flag stays false}
      for i:=1 to 18 do {check pair counts for unique pairings}
      begin
        if (paircounts[i]=1) or (paircounts[pairs[i]]=1) then
        begin
          finalpairs[i]:=pairs[i]; finalpairs[pairs[i]]:=i;
          if verbose.checked
          then items.add(format('Unique final pairing! %2d+%2d=%3d',[i,pairs[i],i+pairs[i]]));
          onefound:=true;
        end;
        paircounts[i]:=0; {forget about past pairs, we'll recompute counts on the next loop}
        paircounts[pairs[i]]:=0;
      end;
    until not onefound;
    items.add('');
    items.add('Done - all possible unique pairings assigned:');
    for i:=1 to 18 do items.add(format('%2d+%2d=%3d',[i,finalpairs[i],i+finalpairs[i]]));
  end;
end;

{**************** StaticText1Click *********8}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
