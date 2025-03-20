unit U_AlphabetGrid3;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
{The program does a depth-first search of a grid for words in our "Full.dic"
 dictionary containing about 65,000 words.}

{Version 2 prunes the search when no possible words exist for a partial word}




interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids, jpeg, UDICt, UIntList, DFFUtils;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Panel2: TPanel;
    ListBox1: TListBox;
    Grid: TStringGrid;
    SearchBtn: TButton;
    SaveBtn: TButton;
    LoadBtn: TButton;
    ColUD: TUpDown;
    RowUD: TUpDown;
    LabeledEdit3: TLabeledEdit;
    SizeUD: TUpDown;
    RandomBtn: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    Memo3: TMemo;
    RevisitBox: TCheckBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Memo2: TMemo;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RowUDChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure ColUDChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure SizeUDChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure RevisitBoxClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure GridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure RandomBtnClick(Sender: TObject);
    procedure GridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  public
    wordsize:integer;
    RevisitOK:boolean;
    currpath:TIntList;
    OrigGridsize:TPoint;
    xoffset,yoffset:integer;  {offsets to center letters in cells}
    procedure cleargrid;
    procedure adjustgrid(grid:TStringgrid);  {set cell size and grid size}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  default:array[1..5] of STRING =
     ('ABGKY','MECHL','RNIDJ','VSPOF','XWTQU');

  {8 directional Offsets from given position to next character}
  offsets:array [1..8] of TPoint =
     ((x:-1;y:-1),(x:0;y:-1),(x:1;y:-1),
     (x:-1;y:0),(x:1;y:0),
     (x:-1;y:1),(x:0;y:1),(x:1;y:1));
    AlphaFreqs:array[1..26] of string =
     ('A 8.12','B 1.49','C 2.71','D 4.32','E 12.02',
      'F 2.30','G 2.03','H 5.92','I 7.31','J 0.10',
      'K 0.69','L 3.98','M 2.61','N 6.95','O 7.68',
      'P 1.82','Q 0.11','R 6.02','S 6.28','T 9.10',
      'U 2.88','V 1.11','W 2.09','X 0.17','Y 2.11','Z 0.07');
     Letterfreqs:array[1..26] of integer;

{************ FormCreate **********}
procedure TForm1.FormCreate(Sender: TObject);
VAR
  R,C:INTEGER;
  i,sum:integer;
begin
  origgridSize.X:=grid.Width;
  origgridSize.Y:=grid.Height;
  adjustgrid(grid);
  sizeud.position:=5;
  wordsize:=5;
  Revisitbox.checked:=false; revisitOK:=false;
  pubdic.LoadDefaultDic;  {load dictionary}
  if not pubdic.dicloaded then halt;
  with Grid do
  begin
    //canvas.Font.Assign(font);
    with canvas.pen do
    begin
      color:=clblack;
      width:=2;
    end;
    row:=rowcount-1;
    for r:=rowcount-1 downto 0 do
    for c:=colcount-1 downto 0 do
    begin
      cells[c,r]:=default[r+1][c+1];
    end;


  end;
  {set up letter frequencies table}
  sum:=0;
  for i:=1 to 26 do
  begin
    sum:=sum+trunc(100*strtofloat(copy(alphafreqs[i],3,4)));
    letterfreqs[i]:=sum;
  end;
  randomize;
end;

function max(a,b:integer):integer;
begin  if a>b then result:=a else result:=b; end;

procedure TForm1.adjustgrid(grid:TStringGrid);
var
  r,c:integer;
begin
  with grid do
  begin
    Width:=origgridsize.x;
    Height:=origgridsize.y;
    c:=width div ((colcount+1)*gridlinewidth);
    r:=height div ((rowcount+1)*gridlinewidth);
    if c>r then c:=r else r:=c;
    defaultcolwidth:=c;
    defaultrowheight:=r;

    font.size:=trunc(1.1*(25 -max(colcount,rowcount)));  {scale fonts based on larger of colcount * rowcount}
    grid.canvas.Font.Assign(grid.Font);
    xoffset:=(c - grid.canvas.TextWidth('N')) div 2;
    yoffset:=(r - grid.canvas.TextHeight('N')) div 2;
  end;
  adjustgridsize(grid); {shrink the grid down to just enclose the cells}

end;


function getrandomletter:char;
var
  i,n:integer;
begin
  n:=random(letterfreqs[26]);
  i:=1;
  while (i<=26) and (letterfreqs[i]<n) do inc(i);
  result:=char(ord(pred('A'))+i);
end;


{************* SearchbtnClick ***********}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  path:TIntlist; {Integer list of positions used in current word}
  wordlist:TStringlist;

  {------------ CheckWordsFrom ------------}
  procedure  checkwordsfrom(c,r:integer; s:string);
  {Recursive depth first search for words formed from adjacent grid letters in
   any direction with or without revisiting letters permitted.}
  var
    i,j,k:integer;
    n:integer;
    index:integer;
    list:TIntList;
  begin
    if length(s)=wordsize then
    begin
      if Pubdic.Lookup(s) then
      if not wordlist.find(s,index) then
      begin {A new word has been found!}
        list:=TIntlist.Create;
        {copy the path to a new integer list so we can display it later}
        for i:=0 to path.Count-1 do list.add(path[i]);
        listbox1.Items.add(s); {add the word and the path to listbox1}
        wordlist.AddObject(s,list);
        memo3.lines[2]:=inttostr(listbox1.items.count)+' words found';
        application.processmessages; {let the visuals update}
      end;
    end
    else
    begin {no word found yet}
      for k:=1 to 8 do
      with offsets[k] do
      begin  {check up 8 adjoining cells}
        i:=c+x;
        j:=r+y;
        with Grid do
        if (i>=0) and (i<colcount) and (j>=0) and (j<rowcount) and (trim(cells[i,j])<>'')
        then
        begin
          {Encode the cell column and row}
          n:=i shl 8 + j;    {16*column + row makes a unique key to track path}
          index:=path.indexof(n); {Has this cell already been visited?}
          if revisitOK or ((not RevisitOK) and (index<0)) then
          begin
             index:=path.add(n); {OK to add this letter to the potential word}
             if pubdic.lookuppartial(s+cells[i,j], wordsize, wordsize)
             {and if there is a word that begins with these letters}
             then checkwordsfrom(i,j,s+cells[i,j]); {then search next letter}
             path.delete(index); {back from search, remove current letter to continue search}
          end;
        end;
      end;
    end;
  end;


var
  i,j:integer;
begin   {SearchBtnClick}
  if (searchBtn.caption='Stop') then
  begin
    tag:=1;
    exit;
  end
  else
  begin
    form1.tag:=0;
    path:=TIntlist.create;
    path.sorted:=false;
    currpath:=nil;
    pubdic.setrange('a',wordsize,'z',wordsize);
    wordlist:=TStringlist.Create;
    wordlist.sorted:=true;
    wordlist.duplicates:=duperror;
    with listbox1 do
    begin   {clear previous entries}
      if items.count>0 then
      for i:=0 to items.count-1 do Tintlist(items.objects[i]).free;
      clear;
      update;
    end;
    grid.invalidate;
    with memo3, lines do
    begin
      clear;
      add(''); add(''); add('');      {add 3 blank lines}
    end;
    screen.cursor:=crHourGlass;
    searchbtn.Caption:='Stop';
    {perform a wordlength deep depth-first search for valid dictionary words}
    with Grid, memo3 do
    begin
      for j:= 0 to rowcount-1  do
      begin
        for i:=0 to colcount-1 do
        begin
          path.add(i shl 8 + j);

          lines[0]:='Check words beginning with';
          lines[1]:=format('%s in Row %d, Column %d',
                 [cells[i,j], j+1, i+1]);

          if trim(cells[i,j])<>'' then checkwordsfrom(i,j,cells[i,j]);
          path.delete(0);
          application.processmessages;
          if form1.tag<>0 then break;
        end;
        if form1.tag<>0 then break;
      end;
    end;
    searchbtn.caption:='Search';
    screen.cursor:=crdefault;
    with memo3,lines do
    begin
      Clear;
      if wordlist.count>0
      then
      begin
        wordlist.sort;
        listbox1.clear;
        for i:=0 to wordlist.count-1 do
          listbox1.items.AddObject(wordlist[i],wordlist.objects[i]);
        add(inttostr(listbox1.items.count)+' words found');
        add('Click a word at left to see its path on the grid.');
      end
      else lines.add('No words found');
    end;
    path.free;
    wordlist.free;
  end;
end;


{********* ClearGrid **********}
procedure TForm1.cleargrid;
{empty the grid letter contents and any traces}
var r,c:integer;
begin
  with grid do
  begin
    for c:=0 to colcount-1 do
    for r:=0 to rowcount-1 do cells[c,r]:='';
  end;
end;


{************ RowUDChangingClick **********}
procedure TForm1.RowUDChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: Smallint; Direction: TUpDownDirection);

begin
  grid.rowcount:=Newvalue;
  adjustgrid(grid);
  cleargrid;
end;

{************ ColUDChangingEx ************}
procedure TForm1.ColUDChangingEx(Sender: TObject; var AllowChange: Boolean;
  NewValue: Smallint; Direction: TUpDownDirection);
begin
  with colud do
  if newvalue>=colud.min then
  begin
    grid.colcount:=NewValue;
    adjustgrid(grid);
    cleargrid;
    allowchange:=true;
  end
  else allowchange:=false;
end;

{*********** SizeUDChangingEx **********8}
procedure TForm1.SizeUDChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  WordSize:=Newvalue;
end;

{********** NoRevisitBoxClick ********}
procedure TForm1.RevisitBoxClick(Sender: TObject);
begin
  ReVisitOK:=Revisitbox.Checked;
end;

{*********** SaveBtnClick **********8}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
  f:Textfile;
  r,c:integer;
  i:integer;
begin
  If savedialog1.execute then
  with grid do
  begin
    assignfile(f, savedialog1.filename);
    rewrite(f);
    writeln(f, format('%2d%2d%2d%2d',[rowcount,colcount,sizeud.Position,ord(revisitbox.Checked)]));
    for r:= 0 to rowcount-1 do
    begin
      for c:=0 to colcount-1 do write(f, cells[c,r]);
      writeln(f);
    end;

    with memo1 do {save any user "clues" associated wioth this puzzle}
    for i:=0 to lines.count-1 do writeln(f,lines[i]);
    closefile(f);
  end;
end;

{************* LoadBtnClick **************}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  f:Textfile;
  r,c:integer;
  s:string;
begin
  If opendialog1.execute then
  with grid do
  begin
    assignfile(f, opendialog1.filename);
    reset(f);
    readln(f,s);
    rowUD.position:=strtoint(copy(s,1,2));
    colUD.position:=strtoint(copy(s,3,2));
    rowcount:=rowud.position;
    colcount:=colud.position;
    sizeud.position:=strtoint(copy(s,5,2));
    revisitbox.Checked:=copy(s,8,1)='1';
    for r:= 0 to rowcount-1 do
    begin
      readln(f, s);
      for c:=0 to colcount-1 do cells[c,r]:=s[c+1];
    end;
    memo1.Clear;   {load any clues user entered for this puzzle}
    while not eof(f) do
    begin
      readln(f,s);
      memo1.Lines.add(s);
    end;
    with memo1.lines do if count=0 then add('No clues available');
    closefile(f);
  end;

end;

{********** ListBox1Click ***********}
procedure TForm1.ListBox1Click(Sender: TObject);
begin
  with listbox1 do currpath:=TIntlist(items.objects[itemindex]);
  grid.Invalidate; {force the grid to be redrawn, OnDrawCell exit will handle
                    drawing the trrace lines for letters in "currpath"}
  application.processmessages;
  currpath:=nil;
end;

{********* GridDrawCell *************}
procedure TForm1.GridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
n,i:integer;
prev,prevcol,prevrow:integer;
prevrect:TRect;
begin

  with grid,canvas do
  begin
    fillrect(rect);
    with rect do textout(left +2 , top+2, cells[acol,arow]);
    if assigned(currpath) then
    begin
      pen.color:=clblack;
      pen.width:=2;
      copymode:=cmSrcPaint;
      n:=Acol shl 8 + arow;
      for i:=0 to currpath.count-1 do
      with currpath, grid do
      begin
        if integers[i]=n then
        begin
          if i>0 then
          begin
            prev:=integers[i-1];
            prevcol:=prev shr 8;
            prevrow:=prev and $FF;
            prevrect:=grid.cellrect(prevcol,prevrow);
            with prevrect do canvas.moveto((left+right) div 2, (top+bottom) div 2);
            with rect do canvas.lineto((left+right) div 2, (top+bottom) div 2);
          end;
          if i<count-1 then
          begin
            prev:=integers[i+1];
            prevcol:=prev shr 8;
            prevrow:=prev and $FF;
            prevrect:=grid.cellrect(prevcol,prevrow);
            with prevrect do canvas.moveto((left+right) div 2, (top+bottom) div 2);
            with rect do canvas.lineto((left+right) div 2, (top+bottom) div 2);
          end;
        end;
      end;
    end;
  end;

end;

{************ RandomBtnClick *************}
procedure TForm1.RandomBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  memo1.Clear; {clear old clues}
  with listbox1 do
  begin   {clear previous entries}
    if items.count>0 then
    for i:=0 to items.count-1 do Tintlist(items.objects[i]).free;
    clear;
    update;
  end;

  with grid do
  begin
    for i:=0 to colcount-1 do
    for j:=0 to rowcount-1 do
    begin
      cells[i,j]:=getrandomletter {char(ord('A')+random(26))};
    end;
    cells[row,col]:=cells[row,col];
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  canselect:=false;
end;

end.
