unit U_ScrambledLetterBlocks;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Grids
  {, udict };
  {dictionary usage removed for simplicity, 6 possible answers included in list}

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    Memo2: TMemo;
    Label1: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
  public
    letterstart:integer;
    selectedword:string;
    fullwordlist:TStringList;
    Dictionary:TStringList;
    function checksolved:boolean;
    function GetNextWord(partwordlist:TstringList):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************* Memo1Click ***********8}
procedure TForm1.Memo1Click(Sender: TObject);
{Select a letter group if click is in that area}
var
  index:integer;
begin
  with memo1 do
  begin
    index:=perform(em_Linefromchar,selstart,0);
    if (index>=letterstart) and (length(lines[index])>=3) then
    begin
      selstart:= perform(em_lineindex,index,0);
      sellength:=3;
      selectedword:=copy(lines[index],1,3);
    end;
  end;
end;


var
  lastparts:array[0..5] of  string = {last 3 characters of each of the 6 target words}
    ('LOW','REL','IFY','EMY','ITE','HAL');
  answers:array [0..5] of string = {answer words}
    ('AFTERGLOW','SCOUNDREL','DEMYSTIFY','ARCHENEMY','SNAKEBITE','BETROTHAL');

{************ FormActivate **********88}
procedure TForm1.FormActivate(Sender: TObject);
var
  i,r,c:integer;
begin
  with stringgrid1 do
  begin  {initialsize all cells with blanks or the last 3 characters of each word}
    for r:=0 to 5 do
    for c:=0 to 8 do
    if c<=5 then cells[c,r]:=' '
    else cells[c,r]:=lastparts[r,c-5];
  end;
  {find line where the initial and middle letter groups begin in the introduction memo}
  {Letter groups start immdeiately after the line beginning with "-" characters}
  letterstart:=-1;
  with memo1,lines do
  begin
    letterstart:=count;
    for i:=0 to count-1 do
    begin
      if (length(lines[i])>3) and (copy(lines[i],1,3)='---') then
      begin
        letterstart:=i+1;
        break;
      end;
    end;
  end;
  //pubdic.loadlargedic;
  Dictionary:=TStringlist.create;
  Dictionary.sorted:=true;
  for i:=0 to 5 do Dictionary.add(answers[i]);
  selectedword:='   ';
end;


{**************** Stringgrid1Click ***********8}
procedure TForm1.StringGrid1Click(Sender: TObject);
{Click on grid in first 6 columns drops a previously selected letter group
 there, first moving any letter group that is already there back to "available"
 list}
 var
  i,n,index:integer;
  s:string;
begin
  with stringgrid1, memo1 do
  begin
    if (col<=5) then
    begin
      if (length(cells[col,row])>0) and (cells[col,row][1] in ['A'..'Z']) then
      begin  {there is already an entry in these columns}
        s:='';
        n:=3*(col div 3);
        for i:=n to n+2 do
        begin
          s:=s+cells[i,row]; {extract it}
          cells[i,row]:=' ';
        end;
        index:=letterstart;  {and put it back in the list of available word parts}
        while (s>lines[index]) and (index<lines.Count) do inc(index);
        if index<lines.Count then  lines.Insert(index,s) else lines.add(s);
      end
      else index:=-1;

      if (selectedword='   ') and (index>=letterstart) then
      begin {if no letters were selected from the list but letters were removed
             from the grid area clicked, then set removed grid letters into list
             and make them the selected letters}
        selstart:= perform(em_lineindex,index,0);
        sellength:=3;
        selectedword:=copy(lines[index],1,3);
        memo1.setfocus;
      end
      else
      begin  {otherwise inset selected word from list into the grid}
        n:=3*(col div 3);
        for i:=n to n+2 do cells[i,row]:=selectedword[i-n+1];
        for i:= letterstart to memo1.lines.Count-1 do
        if selectedword=lines[i] then
        begin
          lines.delete(i);
          break;
        end;
        selectedword:='   ';
      end;
    end;
    if CheckSolved then showmessage('Congratulations!'+#13+'You solved it!') ;
  end;
end;



{*********** CheckSolved **********}
  function TForm1.checksolved:boolean;
  {Count how many full valid words have been created}
  {Also update display of full invalid words and partial words.}
  var
    c,r,index:integer;
    nbrvalid,nbrinvalid,nbrpartial:integer;
    s:string;
    ok:boolean;
  begin
    nbrvalid:=0; nbrinvalid:=0; nbrpartial:=0;
    with stringgrid1 do
    for r:=0 to 5 do
    begin
      OK:=true;
      s:='';
      for c:=0 to 8 do
      begin
        if not (cells[c,r][1] in ['A'..'Z']) then
        begin
          inc(nbrpartial);
          ok:=false;
          break;
        end;
        s:=s+cells[c,r];
      end;
      if Ok then
      //if pubdic.lookup(s)
      if dictionary.find(s,index) {Use dictionary list instead of dictionary}
      then inc(nbrvalid) else inc(nbrinvalid);
    end;
    with memo2 do
    begin
      lines[2]:= format('%d valid words',[nbrvalid]);
      lines[3]:= format('%d invalid words',[nbrinvalid]);
      lines[4]:= format('%d partial words',[nbrpartial]);
    end;
    result:=nbrvalid=6;
  end;

(************ SearchbtnClick ************)
procedure TForm1.SearchBtnClick(Sender: TObject);
{Show the user a single word as a clue}
var
  Partwordlist:TStringlist; {A list of all available letter groups}
var
  i,j,index:integer;
  s,w:string;
begin
  Partwordlist:=TStringlist.create;
  Partwordlist.sorted:=true;

  fullwordlist:=TStringlist.create;  {Full word list reflects the stringgrid "words".}
  with stringgrid1 do
  for i:= 0 to rowcount-1 do
  begin
    begin
      s:='';
      for j:=0 to colcount-1 do s:=s+cells[j,i]; {s=contents of grid row "i"}
      //if not pubdic.Lookup(s) then
      if not dictionary.Find(s,index) then {Use dictionary list instead of dictionary}
      with memo1 do
      begin {row is not already a valid word}
        if  cells[0,i][1]<>' ' then
        begin {there are letters in positions 1-3, clear them out}
          w:=copy(s,1,3); {there are letters in positions 1-3, clear them out}
          cells[0,i]:=' '; cells[1,i]:=' ';cells[2,i]:=' ';
          index:=letterstart;  {and put the letters back into the list of available word parts}
          while (w>lines[index]) and (index<lines.Count) do inc(index);
          if index<lines.Count then  lines.Insert(index,w) else lines.add(w);
        end;
        if  cells[3,i][1]<>' ' then
        begin {there are letters in positions 4-6, clear them out}
          w:=copy(s,4,3);
          cells[3,i]:=' '; cells[4,i]:=' ';cells[5,i]:=' ';
          index:=letterstart;  {put letters back in the list of available word parts}
          while (w>lines[index]) and (index<lines.Count) do inc(index);
          if index<lines.Count then  lines.Insert(index,w) else lines.add(w);
        end;
        s:='';  {reload "s" with the cleaned up version}
        for j:=0 to colcount-1 do s:=s+cells[j,i];
      end;
      fullwordlist.add(s); {Add the row contents to fullwordlist}
    end;
  end;
  {Now build partwordlist with the available letter groups to be used in finding the
   next valid word}
  with memo1 do
  for i:=letterstart to lines.Count-1 do partwordlist.Add(lines[i]);
  screen.cursor:=crHourGlass;

  {Call getnextWord to find the next valid word}
  if not getnextword(partwordlist) then
  begin
    screen.cursor:=crdefault;
    showmessage('No word found');
  end;
  screen.cursor:=crDefault;
  partwordlist.free;
  fullWordList.free;
end;

(************* GetNextWord ************)
function TForm1.GetNextWord(partwordlist:TStringList):boolean;
{search for a partial word in FullWordList which can be completed using letter
 groups from PartWordList}
var
  i,j,k,c,r,index:integer;
  w1,w2,s,saves:string;

begin
  result:=false;
  if partwordlist.count>0 then
  begin
    for i:=partwordlist.count-1 downto 0  do
    begin
      w1:=partwordlist[i]; {get next w1, a candidate for the 1-3 letter positions}
      for j:=partwordlist.count-1 downto 0 do
      if j<>i then
      begin
        w2:=partwordlist[j];{get next w2, a candidate for the 4-6 letter positions}
        for k:=0 to fullwordlist.count-1 do
        {we'll pass w1 and w2 against all incomplete word candiates in fullwordlist}
        begin
          s:=fullwordlist[k];
          if s[1]=' ' then
          begin
            s:=w1+w2+copy(s,7,3);
            //if pubdic.Lookup(s) then
            if dictionary.find(s,index) then {Use dictionary list instead of dictionary}
            begin {it is a valid word!}
              if i>j then   {delete the two letter groiyps used from partialword list}
              begin {note that in order to keep the indices valid for second deletion,
                     we must delete the highest index first}
                partwordlist.delete(i);
                partwordlist.delete(j);
              end
              else
              begin
                partwordlist.delete(j);
                partwordlist.delete(i);
              end;
              saves:=fullwordlist[k]; {save the partial word from fullwordlist}
              fullwordlist[k]:=s; {put the completed word in fullwordlist}
              for r:=0 to fullwordlist.count-1 do
              begin {update the grid}
                s:=fullwordlist[r];
                for c:=0 to length(s)-1 do stringgrid1.cells[c,r]:=s[c+1];
              end;
              application.processmessages;
              //result:=getnextword(partwordlist);   {gets all words}
              result:=true;  {get only one word per entry}
              if result then break;
              {need to put things back where they were for version which searches
               for all solutions}
              partwordlist.add(w1);
              partwordlist.add(w2);
              fullwordlist[k]:=saves;
            end
          end;
        end;
        if result then break;
      end;
      if result then break;
    end;
    {Update the partial words in the memo lines to eliminate letter groups used
     to form the word found}
    with memo1 do
    for i:=lines.count-1 downto letterstart do
    begin
      if not partwordlist.find(lines[i],j) then lines.delete(i);
    end;
  end
  {finally always check if all solved for "find one word" version}
  ;//else
  begin
    if checksolved then
    begin
      screen.cursor:=crdefault;
      showmessage('Solution found!');
      result:=true;
    end;
  end;
end;

end.

