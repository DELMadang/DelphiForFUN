unit U_SixOfAKind;
{Copyright © 2010, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
In a popular club game, 6 dice are thrown and the
player wins if all six show the same number.  If you get
3 tries for $1 (rolling 6 dice each time) and the payoff
is $1,000, is it a fair game?

The program computes and displays theroectical and experimental results to
crosscheck each other.
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Panel1:TPanel;
    Memo1: TMemo;
    Memo2: TMemo;
    StaticText1: TStaticText;
    Case1Btn:TButton;
    Case2Btn:TButton;
    Case3Btn:TButton;
    Case4Btn:TButton;
    procedure Case2BtnClick(Sender: TObject);
    procedure Case3BtnClick(Sender: TObject);
    procedure Case4BtnClick(Sender: TObject);
    procedure Case1BtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    Public
      trials, hits:integer;
      buttonsPressed:boolean;
      Procedure InitButton;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Procedure TForm1.Initbutton;
begin
  if not buttonspressed then
  begin
    buttonspressed:=true;
    memo1.clear;
    memo1.font.size:=8;  {so basic results can display on one line}
  end;
  trials:=1000000;
  hits:=0;
end;

{*********** Case1BtnClick *********}
procedure TForm1.Case1BtnClick(Sender: TObject);
{Six "1"s}
var
 i,j, target:integer;
 OK:boolean;
begin
  Initbutton;

  for i:= 1 to trials do
  begin
    target:=0;
    ok:=true;
    for j:=0 to 5 do if random(6) <> target then
    begin
      OK:=false;
      break;
    end;
    if OK then inc(hits);
  end;

  memo1.Lines.add(format('Case 1: Found %d hits in %.0n trials.  P=%.6f',[hits, trials+0.0, hits/trials]));
  with memo2, lines do
  begin
    clear;
    add('Case1: Six "1"s');
    add('');
    add('We throw six dice, what is the probability of six "1"s?');
    add('');
    add('Answer:  1/6  x  1/6 x 1/6 x 1/6  x 1/6 x 1/6 = 0.000024');
    add('Because there is only one of the 6 possible results for each die that counts as success.');
    add('(24 wins per million trials, or   1 in 46,656)');
  end;
end;

{********* Case2BtnClick ***********}
procedure TForm1.Case2BtnClick(Sender: TObject);
{Six of a kind}
var
 i,j,target:integer;
 OK:boolean;
begin
  InitButton;
  for i:= 1 to trials do
  begin
    target:=random(6);
    ok:=true;
    for j:=1 to 5 do if random(6) <> target then
    begin
      OK:=false;
      break;
    end;
    if OK then inc(hits);
  end;
  memo1.Lines.add(format('Case 2: Found %d hits in %.0n trials.  P=%.6f',[hits, trials+0.0, hits/trials]));
  with memo2, lines do
  begin
    clear;
    add('Case 2:  Six of a Kind');
    add('We throw six dice, what is the probability of six any one number?');
    add('Answer:  6/6  x  1/6 x 1/6 x 1/6  x 1/6 x 1/6 = 0.000128');
    add('(Because the first die can be any number but the rest must match it.)');
    add('(128 wins per million trials, or 1 in 7766)');
  end;
end;

{********** Case3BtnClick **********}
procedure TForm1.Case3BtnClick(Sender: TObject);
{1,2,3,4,5,6 in that order}
var
 i,j:integer;
 OK:boolean;
begin
  Initbutton;
  for i:= 1 to trials do
  begin
    ok:=true;
    for j:=0 to 5 do if random(6) <> j then
    begin
      OK:=false;
      break;
    end;
    if OK then inc(hits);
  end;
  memo1.Lines.add(format('Case 3: Found %d hits in %.0n trials.  P=%.6f',[hits, trials+0.0, hits/trials]));
  with memo2, lines do
  begin
    clear;
    add('Case 3:  1,2,3,4,5,6 in that order');
    add('We throw six dice one at a time so they that can be lined up from left to right.  What is the probability that they will read 1 2 3 4 5 6?');
    add('Answer:  1/6  x  1/6 x 1/6 x 1/6  x 1/6 x 1/6 = 0.000024');
    add('(Because for each roll there is only 1 of the 6 outcomes that counts as success.)');
    add('(24 wins per million trials, or   1 in 46,656)');
  end;
end;

{************ Case4BtnClick ************}
procedure TForm1.Case4BtnClick(Sender: TObject);
{1,2,3,4,5,6 in any order}
var
 i,j,n:integer;
 found:array [0..5] of boolean;
 OK:boolean;
begin
  Initbutton;
  for i:= 1 to trials do
  begin
    for j:=0 to 5 do found[j]:=false;
    ok:=true;
    for j:=0 to 5 do
    begin
      n:=random(6);
      if found[n] then
      begin
        OK:=false;
        break;
      end
      else found[n]:=true;
    end;
    if OK then inc(hits);
  end;
  memo1.Lines.add(format('Case 4: Found %d hits in %.0n trials.  P=%.6f',[hits, trials+0.0, hits/trials]));
  with memo2, lines do
  begin
    clear;
    add('Case 4:  1,2,3,4,5,6 in any order');
    add('We throw six dice all at once. What is the probability of they show 1 2 3 4 5 6 any order?');
    add('Answer:  6/6  x  5/6 x 4/6 x 3/6  x 2/6 x 1/6  = 0.015432');
    add('(Because the first die can be any number but each one after that has one less choice.)');
    add('(15,432 wins per million trials or about in 1 in 65)');
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  buttonspressed:=false;
end;

end.
