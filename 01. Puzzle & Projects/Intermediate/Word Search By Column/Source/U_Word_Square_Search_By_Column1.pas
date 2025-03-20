unit U_Word_Square_Search_By_Column1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, udict, Grids, DFFUtils, shellAPI;

type
  tgrid=array[1..5] of string;
  TForm1 = class(TForm)
    Memo1: TMemo;
    SearchBtn: TButton;
    Memo2: TMemo;
    StringGrid1: TStringGrid;
    PossiblesBtn: TButton;
    Memo3: TMemo;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure PossiblesBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    grid:TGrid;
    goodwords:array[1..5] of string;
    possibles:TStringlist;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


var
  defaultgrid:TGrid= ('ABGTW','UARLP','APTLA','SIILC','PESHN');


{************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
var
c,r:integer;
begin
  with pubdic do
  begin {set up th dictionary for 5 letter words}
    loadlargedic;
    setrange('a',5,'z',5);
  end;

  for r:=1 to 5 do
  begin
    grid[r]:=defaultGrid[r];
    for c:=1 to 5 do stringgrid1.cells[c-1,r-1]:=grid[r,c];
  end;

  possibles:=tstringlist.create; {List of all valid words that can be formed}
  possibles.sorted:=true;
end;

{************** PossiblesBtnClick ****************}
procedure TForm1.PossiblesBtnClick(Sender: TObject);

    {----------GetNextLetters -----------}
    procedure getnextletters(var w:string);
    {recursive procedure to generate all possible 5 letter words choosing one
     letter from each column in successive rows}
    var
      i,col,index:integer;
    begin
      If length(w)=5 then
      begin  {it's a word}
        with possibles do
        if  pubdic.lookup(w)
        {add this word if it is not already there}
        then if not possibles.find(w,index) then possibles.add(w);
      end
      else
      begin
        col:=length(w)+1;
        for i:=1 to 5 do
        begin
          w:=w+grid[col,i];
          getnextletters(w);
          delete(w,col,1);
        end;
      end;
    end;

var
  i,c,r:integer;
  w:string;
begin

  {make a stringlist of all 5 letter words starting with the initial word letters}
  {Grid will be emptied druing the search so restore it here incase of 2nd click}
  for r:=1 to 5 do  grid[r]:=defaultGrid[r];
  possibles.clear;
  memo2.Clear;
  screen.Cursor:=crHourGlass;
  w:='';
  getnextletters(w); {generate possibles - all candidate words}
  screen.Cursor:=crDefault;
  memo2.clear;
  for i:=0 to possibles.count-1 do memo2.lines.add(possibles[i]);
  showmessage(format('The "Possible words" list has %d words',[possibles.count]));
  searchbtn.enabled:=true;
end;

{************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  w:string;


     {------------ FindSolution *********}
     function FindSolution(var g:TGrid; wordNbr:integer):boolean;
     {Recursive search function to find the set of 5 words which use
      all available letters with letter positions 1-5 of each word
      coming from rows 1-5 respectively}
     var
       i,j:integer;
       first,ch:char;
       index:integer;
       savegrid:TGrid;
       ok:boolean;
     begin
       if wordnbr=6 then  {5 good words found = solution!}
       with memo1.lines do
       begin
         add('');
         add('Solution!');
         for i:=1 to 5 do add(goodwords[i]);
         result:=true;
         exit;
       end
       else
       begin
         {Grid "g" wil have used letters replaced by blanks, Savegrid is used to
         restore "g" when word attempt fails}
         for i:=1 to  5 do savegrid[i]:=g[i];
         {Find the position in the possibles list of the initial letter of
          word number "WordNbr}
         First:=grid[1,wordnbr];
         index:=-1;
         repeat
           inc(index);
           ch:=possibles[index][1];
         until ch=first;

         {we now have the first search word position in Possibles list}
         result:=false;
         {We'll check letter positions 2-5 of all of these words to see if
          they are contained in rows 2-5 of the grid}
         while possibles[index][1]=first do
         begin
           w:=possibles[index];
           for i:=1 to 5 do g[i]:=savegrid[i]; {restore entry grid letters}
           for i:=2 to 5 do  {For grid rows 2-5}
           begin
             for j:=1 to 5 do {for available letters in row i}
             begin
               OK:=false;
               if g[i,j]=w[i] then
               begin
                 //if g[i,j] = savegrid[i,j]then
                 // begin
                 g[i,j]:=' '; {Make the letter unavailable for further use}
                 ok:=true;
                 break;
               end;
             end;
             if not OK then break; {It's not this word}
           end;
           if OK then
           begin  {This word is valid and could be part of a solution
                   (if the rest of the words can be placed also)}
             goodwords[wordnbr]:=w;
             result:=findsolution(g, wordnbr+1); {go search the the next word}
             if not result then for i:=1 to 5 do g[i]:=savegrid[i]; {we need to restore the grid}
           end;
           inc(index);
           if index>=possibles.count then exit;{no more words to check, just exit}
         end;
         if not result then exit; ;
       end;
     end; {FindSolution}


begin  {SearchBtnClick }
  memo1.Clear;
  {find soultion}
  findsolution(grid,1); {recursive search function}
end;

{************** StringGridDrawCell *****************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  {Call the routine below to prevent highlighting the selected cell}
   IgnoreSelectedDrawCell(Sender, ACol, ARow, Rect,State);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

(*  {Discrded first attempt}
procedure TForm1.Button1Click(Sender: TObject);
var
  r:integer;
  goodwords:array[1..5] of string;

  function getnextword(Var W:string; wordnbr:integer):boolean;
  var
    r,c:integer;
    OK:boolean;
  begin
    {
    if (wordnbr>5) then {finished with all words}
    begin
      for i:=1 to 5 do memo1.Lines.Add(goodwords[i]);
      showmessage('Soulution found');
      result:=true;
    end
    else
    begin
    }
    OK:=false;
    result:=false;
    r:=length(w)+1; {Get an unused letter from the next row}
    if r>5 then exit;
    for c:=1 to 5 do
    begin
      if grid[r,c]<>' '
      then
      begin
        w:=w+grid[r,c];
        OK :=pubdic.lookuppartial(w,5,5);
        if OK then
        begin
          grid[r,c]:=' ';
          if length(w)=5 then
          begin
            result:=true;
            goodwords[wordnbr]:=w;
            if wordnbr=5 then
            begin
              showmessage('SOlution found')
            end
            else
            begin
              w:='';
              getnextword(w,wordnbr+1);
            end;

            exit;
          end;
          OK:=getnextword(w,wordnbr);
        end;
        if not OK then
        begin {can't be a word so undo the change and go on to the nex column}
          grid[r,c]:=w[length(w)];
          delete(w,length(w),1);
        end;
      end;
      result:=OK;
    end;

  end;


var
  w:string;
begin
   for r:=1 to 5 do memo1.lines.add(grid[r]);
   w:='';
   Getnextword(w,1);
end;
*)
