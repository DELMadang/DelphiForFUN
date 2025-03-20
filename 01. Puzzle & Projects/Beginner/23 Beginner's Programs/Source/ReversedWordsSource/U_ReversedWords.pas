unit U_ReversedWords;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Here's a simple program that performs quite a sophisticated test.  The puzzle
is from the Mensa Puzzle-A-Day Calendar for September 23, 2009.

It presents the text listed below requiring us to find the word that meets the
requirements given and whose letters appear consecutively but in reverese
order.

Ohter similar puzzles could be solved by pasting text over the memo below and
adjusting the word length appropriately.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, StrUtils, Spin, UDict;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Memo1: TMemo;
    ListBtn: TButton;
    Memo2: TMemo;
    ListBox1: TListBox;
    WordLength: TSpinEdit;
    Label1: TLabel;
    ListBox2: TListBox;
    ValidWordBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure ListBtnClick(Sender: TObject);
    procedure ValidWordBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  {characters to remove from text}
  removes:set of char = [' ', '''', '.', '-', ',',
                        char($A){Line feed}, char($D){Carriage return}];

{*********** ListBtnClick **********}
procedure TForm1.ListBtnClick(Sender: TObject);
var
  i,n:integer;
  s:string;
begin
  n:=wordlength.value;
  s:=reversestring(memo2.Text); {reverse the string}
  {remove punctuation, etc.}
  for i:=length(s) downto 1 do if s[i] in removes then delete(s,i,1);
  {Extract N character substrings as possible words}
  listbox1.Clear;
  for i:= 1 to length(s)-n-1 do listbox1.items.add(copy(s,i,n));
end;

{********* ValidwordBtn ***********}
procedure TForm1.ValidWordBtnClick(Sender: TObject);
var
  i:integer;
  s:string;
  //abbrev, foreign, caps:boolean; {characteristics of returned words}
begin
  If not pubdic.dicloaded then PubDic.loadlargedic;
  listbox2.Clear;
  with PubDic, listbox1 do
  if dicloaded then
  for i:=0 to items.count-1 do
  begin
    s:=lowercase(items[i]);
    if isvalidword(s) and lookup(s) then listbox2.Items.add(s);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
