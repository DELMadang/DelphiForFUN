unit DFFUtils;
interface
  uses Windows, Messages, Stdctrls, Sysutils, Classes, Grids;

  procedure reformatMemo(const m:TMemo);
  procedure SetMemoMargins(m:TMemo; const L,T,R,B:integer);

  procedure AdjustGridSize(grid:TDrawGrid);
  procedure DeleteGridRow(Grid: TStringGrid; Const ARow:integer);
  procedure InsertgridRow(Grid: TStringGrid; Const ARow:integer);
  procedure Sortgrid(Grid : TStringGrid; Const SortCol:integer);

  procedure sortstrDown(var s: string); {sort string characters descending}
  procedure sortstrUp(var s: string);   {sort string characters ascending}
  procedure rotatestrleft(var s: string); {rotate stringleft}
  function strtofloatdef(s:string; default:extended):extended;

  {Load comma separated text into a stringlist}
  procedure loadcommatext(list: TStringList; filename: string);

  {Free objects contained in a string list and clear the strings}
  procedure FreeAndClear(C:TListBox); overload;
  procedure FreeAndClear(C:TMemo);   overload;
  procedure FreeAndClear(C:TStringList);   overload;

implementation



{************ Reformat **********}
procedure reformatMemo(const m:TMemo);
{reformat the lines after removing existing Carriage returns and Line feeds}
{necessary to reformat input text from design time since text has hard breaks included}
var
  s:string;
  CRLF, CRCR:string;
begin
  {remove EXTRA carriage returns & line feeds}
  s:=m.text; {get memo text lines}
  CRLF:=char(13) + char(10);  {CR=#13=carriage retutn, LF=10=Linefeed}
  CRCR:=char(13)+char(13);
 {temporarily change real paragraphs (blank line), CRLFCRLF to double CR}
  s:=stringreplace(s,CRLF+CRLF,CRCR,[RfReplaceall]);
  {Eliminate input word wrap CRLFs}
  s:=stringreplace(s,CRLF,' ',[RfReplaceall]);
  {now change CRCR back to CRLFCRLF}
  s:=stringreplace(s,CRCR,CRLF+CRLF,[RfReplaceall]);
  m.text:=s;
  m.wordwrap:=true; {make sure that word wrap is on}
end;

procedure SetMemoMargins(m:TMemo; const L,T,R,B:integer);
var cr:Trect;
begin
  {Reduce clientrect by L & R margins}
  cr:=m.clientrect;
  if L>=0 then cr.left:=L;
  If T>=0 then cr.top:=T;
  If R>=0 then cr.right:=cr.right-r;
  If B>=0 then cr.bottom:=cr.Bottom-b;
  m.perform(EM_SETRECT,0,longint(@cr));
end;


{**************** AdjustGridSize *************}
procedure AdjustGridSize(grid:TDrawGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;


{************* InsertGridRow *************}
procedure InsertgridRow(Grid: TStringGrid; Const ARow:integer);
{Insert blank row after Arow}
var i:integer;
begin
  with Grid do
  if (arow>=0) and (arow<=rowcount-1) then
  begin
    rowcount:=rowcount+1;
    for i:=rowcount-1 downto Arow+2 do rows[i]:=rows[i-1];
    rows[arow+1].clear;
    row:=arow+1;
    {if insert is within fixed rows then increase fixed row count}
    {if insert is at or after the last fixed row, leave fixed row count alone}
    if fixedrows>arow then fixedrows:=fixedrows+1;
  end;
end;

{************* DeleteGridRow *************}
procedure DeleteGridRow(Grid: TStringGrid; Const ARow:integer);
{delete a stringgrid row.  Arow is a row index between 0 and rowcount-1}
var i:integer;
begin
  with Grid do
  if (arow>=0) and (arow<=rowcount-1) then
  begin
    //rows[arow].clear;
    for i:=Arow to rowcount-1 do rows[i]:=rows[i+1];
    rowcount:=rowcount-1;
    if fixedrows>arow then fixedrows:=fixedrows-1;
  end;
end;

{*********** SortGrid ************}
procedure Sortgrid(Grid : TStringGrid; Const SortCol:integer);
var
   i,j : integer;
   temp:tstringlist;
begin
  temp:=tstringlist.create;
  with Grid do
  for i := FixedRows to RowCount - 2 do  {because last row has no next row}
  for j:= i+1 to rowcount-1 do {from next row to end}
  if AnsiCompareText(Cells[SortCol, i], Cells[SortCol,j]) > 0
  then
  begin
    temp.assign(rows[j]);
    rows[j].assign(rows[i]);
    rows[i].assign(temp);
  end;
  temp.free;
end;


{************** SortStrDown ************}
procedure sortstrDown(var s: string);
var
  i, j: integer;
  ch:   char;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[j] > s[i] then
      begin  {swap}
        ch   := s[i];
        s[i] := s[j];
        s[j] := ch;
      end;
end;

{************** SortStrUp ************}
procedure sortstrUp(var s: string);
var
  i, j: integer;
  ch:   char;
begin
  for i := 1 to length(s) - 1 do
    for j := i + 1 to length(s) do
      if s[j] < s[i] then
      begin  {swap}
        ch   := s[i];
        s[i] := s[j];
        s[j] := ch;
      end;
end;
{************ RotateStrLeft **********}
procedure rotatestrleft(var s: string);
var
  ch:     char;
  len: integer;
begin
  len := length(s);
  if len > 1 then
  begin
    ch := s[1];
    move(s[2],s[1],len-1);
    s[len] := ch;
  end;
end;

{********** StrToFloatDef **********}
function strtofloatdef(s:string; default:extended):extended;
{Convert input string to extended}
{Return "default" if input string is not a valid real number}
begin
  try
    result:=strtofloat(trim(s));
    except  {on any conversion error}
      result:=default; {use the default}
  end;
end;


{**************** LoadCommaText **********}
procedure loadcommatext(list: TStringList; filename: string);

var
  f:    Textfile;
  line: string;
begin
  assignfile(f, filename);
  reset(f);
  readln(f, line);
  list.commatext := line;
  closefile(f);
end;

{*************** FreeAndClear *********}
procedure FreeAndClear(C:TListbox);   overload;
  var i:integer;
  begin
    with c.items do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

  procedure FreeAndClear(C:TMemo);   overload;
  var i:integer;
  begin
    with c.lines do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

  procedure FreeAndClear(C:TStringList);   overload;
  var i:integer;
  begin
    with c do
    for i:=0 to count-1 do
    if assigned(objects[i]) then objects[i].free;
    c.clear;
  end;

end.

