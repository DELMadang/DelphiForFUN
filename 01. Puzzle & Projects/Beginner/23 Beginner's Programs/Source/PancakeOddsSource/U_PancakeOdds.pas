unit U_PancakeOdds;
{Copyright © 2014, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Puzzle from Marilyn Vos Savant in the 9/28/14 edition of Parade
magazine,

We have three pancake types;
* Type 0: Burned on both sides,
* Type 1: Burned on one side and OK on the other side;, and
* Type 2: OK on both sides.

You pick a pancake at random, and it is OK on the side you can
see (i.e. Type 1 or Type 2).   What are the odds that it is also OK on the other side (is a Type 2)?

Marilyn says that the other side is OK 2/3 of the time, but I
decided to simulate a million trial to prove it to myself.

This 25 line program resolves the issue.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  shellAPI, StdCtrls, ComCtrls, ExtCtrls, UDict, jpeg, xmldom, XMLIntf,
  msxmldom, XMLDoc;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    ShowSourceLbl: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure ShowSourceLblClick(Sender: TObject);
  public
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** SearchBtnClick ************}
 procedure TForm1.SearchBtnClick(Sender: TObject) ;
 {We'll randomly select a million pancakes and kee p 2 counts:
   1: The number with a good side showing and
   2: The number with good side showing that is also good on the hidden side
   The ratio of these two numbers is the solution we're looking for}

 Var  i,TopSideGood, BackSideGood:integer; {the variables}

 begin
   randomize;  {Make the test ressults random}
   TopSideGood:=0; {Initialize count of good sides seen}
   BackSideGood:=0; {Initialize count of back sides that are also good}
   for i:=1 to 1000000 do
   begin
     {Randomly pick a pancake that with a good side up}
     case random(3) of
       {0 = Type 0 (burned, burned) - ignore it}
       1: {Type 1: pancake selected - Good on one side}
          {50-50 chance that we see the good side, random(2) will return 0 or 1 equally}
          if random(2)=0 then inc(TopSideGood); {If random(2) is 0, count it as a good side seen}
       2: begin  {Type2 pancake selected: Good on both sides}
            inc(TopSideGood); {We always see a good side}
            inc(BackSideGood);  {Other side is always good also}
          end;
     end;
   end;{end of trials loop}
   with memo1.Lines do
   begin
     Add('----------------------------------------------');
     Add(format('In 1,000,000 trials, %.0n showed an OK side. ',[0.0+TopSideGood]));
     Add(format('Of these, %.0n (%.1f%%) were OK on the other side.',
                          [0.0+BackSideGood, 100*BackSideGood/TopSideGood]));
     Add(#13+'While it is true that we will draw equal numbers of Types 1 and 2 pancakes, '
         + ' half of the time we will be seeing the burned side of the Type 1''s and discard '
         +'without counting them thus counting twice as many Type 2''s  as Type 1''s');
   end;
 end;

{******** ShowSourceLblClick *****}
procedure TForm1.ShowSourceLblClick(Sender: TObject);
begin
  chdir(extractfilepath(application.exename));
  ShellExecute(Handle, 'open', 'PancakeOddsSource.htm',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
