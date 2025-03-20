unit U_WordSquaresSearch;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
"Word Squares" are square word arrays which read
the same horizontally and vertically.  According
to Wikipedia, they have likely existed for more
than 2000 years.

Puzzles larger than 8x8 are rare and frequently
must include foreign or obscure words.  This
program, writtern as a programming exercise, uses
our 62,000 word dictionary, "Full.dic" as its basis and takes
a few minutes to search for squares of 8x8.  I
haven't had any luck finding 8x8 squares and have
not tried any larger sizes.

Program "DicMaint" found on DFF can be used to add additional words to Full.dic
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, UDict, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    Edit1: TEdit;
    StopPanel: TPanel;
    Label1: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StopPanelClick(Sender: TObject);
  public
    N:integer; {word length}
    square:array of string;  {the word square we're building}

    {lists to hold words starting with each letter position of the start word
     except no need to build a list for the 1st letter.  Also note that since
     this is a dynamic array starting with index value 0, the Kth letter of the
     source word is represented by list [K-2]}
    lists:array of TStringList;
    Loopcount:int64; {# of word tests made}
    foundcount:integer; {solution found count}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************ FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  pubdic.loadlargedic;
  StopPanel.top:=label1.Top;
  StopPanel.Left:=label1.Left;
end;

{*********** SearchBtnClick *************8}
procedure TForm1.SearchBtnClick(Sender: TObject);

  {----------- ShowSolution -----------}
  procedure showsolution;
  var i:integer;
  begin
    with memo1.Lines do
    begin
      add('');
      inc(foundcount);
      add('#'+inttostr(foundcount));
      for i:=1 to n do add(square[i]);
    end;
    application.processmessages;
  end;

  {---------- Col -----------}
  function col(const k:integer):string;
  {Return the first k characters of column k of the square}
  begin
    result:=copy(square[k],1,k);
  end;

  {--------- Row ---------}
  function row(const k:integer):string;
  {return the first k characters of row K of the square}
  var  i:integer;
  begin
    result:='';
    for i:=1 to k do result:=result+square[i,k];
  end;

  {------------- TryWord ------------}
  function tryword(k:integer):boolean;
  {Recursive search looking for words which will work in the word square}
  {K is current position  being processed. }
  var
    i:integer;
    r,c:string;
  begin {Tryword}
    if tag<>0 then begin result:=false; exit; end;
    inc(loopcount);

    with lists[k-2] do
    begin
      result:=true;
      for i:=0 to count-1 do
      begin
        result:=true;
        if (loopcount and $FFF) =0 then application.processmessages;
        square[k]:=strings[i];  {get the word to try}
        r:=row(k);
        c:=col(k);
        {prune the search here if the 1st K letters of the square's row and
         column do not match}
        if r=c then
        begin
          if k=n then showsolution {square completed!}
          else result:=tryword(K+1); {otherwise search words for next letter}
        end;
      end;
    end;
  end;

var
  i:integer;
  s,w:string;
  wordnbr:integer;
  abbrev,foreign,capital:boolean;
  ch:char;
  starttime:TDatetime;
begin  {SearchBtnClick}
  s:=edit1.text;
  foundcount:=0;
  tag:=0;
  {Dictionary lookup for root word does not have to be in the dictionary}
  //if pubdic.LookUp(s) then  
  begin
    {Initialization stuff}
    memo1.clear;
    n:=length(s);
    setlength(lists,n-1);
    setlength(square,n+1);
    square[1]:=s;
    for i:=0 to n-2 do
    begin
      lists[i]:=TStringlist.Create;
      lists[i].sorted:=true;
    end;

    { Now look for words beginning with the letters of our root word and of the
      same length and put them in lists 1 through N}
    with Memo1, lines do
    begin
      add('Check for word squares starting with '+s);
      screen.cursor:=crHourGlass;
      StopPanel.visible:=true;
      StopPanel.update;
      starttime:=now;
      loopcount:=0;

      {Initialize list of words of length N with one list for each letter
       in positions 2 through N}
      with Pubdic do
      For i:=0 to n-2 do
      begin
        ch:=s[i+2];
        setrange(ch,n,ch,n);
        while getnextword(W,wordnbr,abbrev,foreign,capital) do
        {no abbreviations or foreign words wanted}
        if (not abbrev) and (not foreign) then lists[i].add(uppercase(w));
        add(format('Check %d words starting with %s', [lists[i].count, ch]));
      end;
      add('');
    end;

    {Now call "Tryword" tofill in all words starting with the second letter
    looking for word  sets that read the same horizontally and  vertically}
    TryWord(2);

    {Wrap it up}
    screen.cursor:=crDefault;
    StopPanel.visible:=false;
    If foundcount=0 then memo1.lines.add('No solutions found');
    memo1.lines.Add('');
    memo1.Lines.add('Run time (HH:MM:SS) '+formatdatetime('hh:nn:ss', now-starttime));
    for i:=0 to n-2 do  lists[i].Free;
  end;
end;

{************ StopBtnClick *************}
procedure TForm1.StopPanelClick(Sender: TObject);
begin
  tag:=1; {form's tag property is tested within Tryword function which will stop
           the search if value becomes nonzero}
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
