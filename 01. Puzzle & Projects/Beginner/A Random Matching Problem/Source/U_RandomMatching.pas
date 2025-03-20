unit U_RandomMatching;

{Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Here's a problem published by Marilyn vos
Savant in her "Ask Marilyn" column in Parade
magazine of July 25, 2004:

A clueless student faced a pop quiz - a list of 24
Presidents of the 19th century and another list of
their terms of office, but scrambled.  The object
was to match the President with his term.  He
had
to guess every time.  On average, how many
terms would he guess correctly?

This program simulates the quiz results by
checking and averaging scores for a large
number of  random matching trials.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ShellAPI, Spin;

type
  TForm1 = class(TForm)
    TrialsBtn: TButton;
    Memo1: TMemo;
    Showdetail: TCheckBox;
    TrialsBox: TRadioGroup;
    Memo2: TMemo;
    StaticText1: TStaticText;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    procedure TrialsBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
  n:array of integer;

{*********** Shuffle ********}
procedure shuffle;
var i,j,m:integer;
{Corrected 8/31/06 - only exchange with remainder of deck 0 thru i}
begin
  for i:=high(n) downto 1 do
  begin
    m:=random(i+1);{pick a random # of those that haven't been selected yet}
    {swap it with next unswapped position  as end of array}
    j:=n[i];
    n[i]:=n[m];
    n[m]:=j;
  end;
end;

procedure TForm1.TrialsBtnClick(Sender: TObject);
var
 i,j,count,tot, nbrloops:integer;
 nbr:integer; {size of trial sets}
begin
  randomize;
  memo1.clear;
  tot:=0; {clear grand total}
  case trialsbox.itemindex of
    0:  nbrloops:=100;
    1:  nbrloops:=1000;
    2:  nbrloops:=10000;
    3:  nbrloops:=100000;
  end;
  nbr:=spinedit1.value;
  setlength(n,nbr);
  for i:= 0 to high(n) do n[i]:=i; {initialize array of values}
  if showdetail.checked then memo1.lines.add('First 100 trial outcomes');
  screen.cursor:=crHourglass;  {show busy cursor}
  for i:= 1 to nbrloops do {run trials}
  begin
    for j:= 1 to 5 do shuffle;  {shuffle 5 times}
    count:=0;
    {those that end up in original position are matches}
    for j:=0 to high(n) do if n[j]=j then inc(count);
    {show first 100 outcomes if box is checked}
    If showdetail.checked and (i<=100) then memo1.lines.add(inttostr(count));
    inc(tot,count);  {accumulate grand total}
  end;
  memo1.lines.add(format('Average matches in %8d trials: %4.2n',[nbrloops,tot/nbrloops]));
  screen.cursor:=crdefault;  {reset cursor}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
