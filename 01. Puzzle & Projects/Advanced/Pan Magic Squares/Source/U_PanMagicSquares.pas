unit U_PanMagicSquares;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 (*
I recently  needed some magic squares for another project and realized that I
did not have a generator.  In fact, there did not seem
to be a Delphi version available online, so here is my first attempt at one.

A "Magic Square" of odd order N is an square array of integers 1 through N^2
with the the property that the sum of integers in each
row, each column, and each of the 2 diagonals are all equal.

There does not seem to be an algorithm for generating all magic squares, even of
 odd order which are more amenable to solution. Two methods of generating 5x5
 magic squares are implemented here.  Neither one is very complete even for 5x5
 squares (of which there are apparently several million).  This program can
 generate 115,000 or so with the "panmagic" property.
*)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, ComCtrls, ShellAPI, ExtCtrls;

type

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    Introsheet: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Label2: TLabel;
    Vectors: TStringGrid;
    Magic: TStringGrid;
    GenerateBtn: TButton;
    ResetBtn: TButton;
    ListBox1: TListBox;
    StaticText1: TStaticText;
    Label1: TLabel;
    Label4: TLabel;
    TabSheet3: TTabSheet;
    GLTableb: TStringGrid;
    GLTablea: TStringGrid;
    Label3: TLabel;
    Label5: TLabel;
    GLMaster: TStringGrid;
    GLSquare: TStringGrid;
    GLMakeAllBtn: TButton;
    Memo2: TMemo;
    GLMake144Btn: TButton;
    Chk576btn: TButton;
    Memo3: TMemo;
    TabSheet4: TTabSheet;
    GenAllBtn: TButton;
    Memo4: TMemo;
    Label6: TLabel;
    OpenDialog1: TOpenDialog;
    Chk144btn: TButton;
    Label7: TLabel;
    Memo5: TMemo;
    Label8: TLabel;
    Label9: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MagicSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure GLTableClick(Sender: TObject);
    procedure GLMakeAllBtnClick(Sender: TObject);
    procedure GLMake144BtnClick(Sender: TObject);
    procedure Chk576btnClick(Sender: TObject);
    procedure GenAllBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure VectorsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
  private
    { Private declarations }
  public
    { Public declarations }
    sq:array[0..4,0..4] of integer;
    vcount:integer;
    abValues:array of array[1..4] of integer;
    GlSquarelist:TStringlist;
    ALimit,Astart:integer;
    procedure generatefrom(index,v1,v2:Tpoint; display:boolean);
    procedure Findrules;
    function FindOneFrom(p:TPoint; v1,v2:TPoint):TPoint;
    procedure GLMakeAll;
    function GetOKCountFromVectors(V1,V2:TPoint):integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  (*
  tableadata:array[1..6,1..3] of integer =
    ((3,4,5),(3,5,4),(4,3,5),(4,5,3),(5,3,4),(5,4,3));
  *)

  {B,C,D,E, table.  (A=0), (B=5, the first 6 rows, generate 144 squares)}
  tableAdata:array[1..24,1..4] of integer =
    ((5,10,15,20),(5,10,20,15),(5,15,10,20),(5,15,20,10),(5,20,10,15),(5,20,15,10),
     (10,5,15,20),(10,5,20,15),(10,15,5,20),(10,15,20,5),(10,20,5,15),(10,20,15,5),
     (15,5,10,20),(15,5,20,10),(15,10,5,20),(15,10,20,5),(15,20,5,10),(15,20,10,5),
     (20,5,10,15),(20,5,15,10),(20,10,5,15),(20,10,15,5),(20,15,5,10),(20,15,10,5));

  {b,c,d,e table (a=0)  }
  tableBdata:array[1..24,1..4] of integer =
    ((1,2,3,4),(1,2,4,3),(1,3,2,4),(1,3,4,2),(1,4,2,3),(1,4,3,2),
     (2,1,3,4),(2,1,4,3),(2,3,1,4),(2,3,4,1),(2,4,1,3),(2,4,3,1),
     (3,1,2,4),(3,1,4,2),(3,2,1,4),(3,2,4,1),(3,4,1,2),(3,4,2,1),
     (4,1,2,3),(4,1,3,2),(4,2,1,3),(4,2,3,1),(4,3,1,2),(4,3,2,1));

   GLMasterdata:array  [0..4,0..4,1..2] of integer=
                      (((1,1),(2,4),(3,2),(4,5),(5,3)),
                       ((4,2),(5,5),(1,3),(2,1),(3,4)),
                       ((2,3),(3,1),(4,4),(5,2),(1,5)),
                       ((5,4),(1,2),(2,5),(3,3),(4,1)),
                       ((3,5),(4,3),(5,1),(1,4),(2,2)));


{*********** FormCreate **********8}
procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  with vectors do
  begin
    cells[0,1]:='Normal Vector';
    cells[0,2]:='Jump Vector';
    cells[1,0]:='X Increment';
    Cells[2,0]:='Y Increment';
  end;
  setlength(abValues,1000);

  {Setup Tablea}
  with GLTablea do
  begin

    for j:=1 to 24 do cells[0,j]:=inttostr(j);
    for i:= 1 to 4 do cells[i,0]:=char(ord('B')+i-1);
    for i:=1 to 24 do
    for j:=1 to 4 do cells[j,i]:=inttostr(tableAdata[i,j]);

  end;

  with GLTableB do
  begin
    for j:=1 to 24 do cells[0,j]:=inttostr(j);
    for i:= 1 to 4 do cells[i,0]:=char(ord('b')+i-1);
    for i:=1 to 24 do
    for j:=1 to 4 do cells[j,i]:=inttostr(tableBdata[i,j]);
  end;

  with GLMaster do
  begin
    for i:=0 to 4 do
    for j:=0 to 4 do
    cells[i,j]:= char(ord('A')+glmasterdata[j,i,1]-1)
                 +char(ord('a')+glmasterdata[j,i,2]-1);
  end;

  GLSquarelist:=TStringlist.create;
  GLSquarelist.sorted:=true;

  opendialog1.initialdir:=extractfilepath(application.exename);

  pagecontrol1.activepage:=Introsheet;
end;

{********** Form1Activate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Findrules; {Generate all  Loubere (a,b) (a',b') values which create panmagic squares}
  listbox1.itemindex:=0;
  listbox1click(sender);
  (*
  {generate common "start with 1 in middle of top row and move Northeast generation rule}
  with vectors do
  begin
    cells[1,1]:='1'; cells[2,1]:='-1';
    cells[1,2]:='0'; cells[2,2]:='+1';
  end;
  with magic do
  begin
    row:=0;
    col:=2;
    cells[2,0]:='1';
    generatebtnclick(sender);
  end;
  *)

end;


function Ismagic(Grid:TStringGrid; var panmagic:boolean):boolean;
var
  i,j,n:integer;
  temp:array of array of integer;
  rowsums,colsums:array of integer;
  d1,d2:integer;
  dRsums,dLsums:array of integer;
  magicsum:integer;
  errcode:integer;
begin
  result:=false;
  with grid do
  if rowcount=colcount then
  begin
    n:=rowcount;
    magicsum:=n*(n*n+1) div 2;
    setlength(temp,n,n);
    for i:=0 to n-1 do
    for j:=0 to n-1 do
    begin
      val(cells[i,j],temp[i,j],errcode);
      if errcode<>0 then exit;
    end;
    setlength(rowsums,n);
    setlength(colsums,n);
    setlength(DRsums,n);
    setlength(Dlsums,n);
    for i:=0 to n-1 do
    begin
      rowsums[i]:=0;
      colsums[i]:=0;
      dlsums[i]:=0;
      drsums[i]:=0;
    end;
    d1:=0;
    d2:=0;
    for i:=0 to n-1 do
    begin
      for j:=0 to n-1 do
      begin
        inc(colsums[i],temp[i,j]);
        inc(rowsums[i],temp[j,i]);
        if i=j then inc(d1,temp[i,j]);
        if i+j=n-1 then inc(d2,temp[i,j]);
        inc(drsums[i],temp[j,(i+j+1) mod n]);
        inc(dlsums[i],temp[j,(i-j+1+n) mod n]);
     end;
    end;
    result:=true;
    panmagic:=true;
    for i:=0 to n-1 do
    begin
      if colsums[i]<>magicsum then result:=false;
      if rowsums[i]<>magicsum then result:=false;
      if drsums[i]<>magicsum then panmagic:=false;
      if dlsums[i]<>magicsum then panmagic:=false;
      if not result then break;
    end;
    if result then result:=result and (d1=magicsum) and (d2=magicsum);
  end;
end;



{********** Generatefrom *********}
procedure TForm1.generatefrom(index,v1,v2:Tpoint; display:boolean);
{Use De la Loubere's rule to create a potenially magic square from
 the given point using the passed (a,b) and (a+a', b+b') vectors for
 normal move and "cross-step" or jump moves when normal move would
 land on an occupied space.  }
var
  i,j:integer;

  nextx,nexty:integer;
  nextx2,nexty2:integer;
  r,panmagic:boolean;
begin
  for i:=0 to 4 do for j:=0 to 4 do sq[i,j]:=0;
  nextx:=(index.x) mod 5;
  nexty:=(index.y) mod 5;
  sq[nextx,nexty]:=1;
  for i:=1 to 24 do
  begin
    nextx2:=(nextx+(v1.x)) mod 5;
    nexty2:=(nexty+(v1.y)) mod 5;
    if nextx2<0 then inc(nextx2,5);
    if nexty2<0 then inc(nexty2,5);

    if sq[nextx2,nexty2]=0 then
    begin
      nextx:=nextx2;
      nexty:=nexty2;
    end
    else
    begin
      nextx:=(nextx+(v2.x)) mod 5;
      nexty:=(nexty+(v2.y)) mod 5;
      if nextx<0 then inc(nextx,5);
      if nexty<0 then inc(nexty,5);
    end;
    sq[nextx,nexty]:=i+1;
  end;
  if display then
  begin
    for i:=0 to 4 do
    for j:=0 to 4 do
    magic.cells[i,j]:=format('%3d',[sq[i,j]]);
    r:=ismagic(magic,panmagic);
    if r then
    begin
      magic.font.color:=clgreen;
      if not panmagic then magic.font.color:=$00CAFF {a little darker than clyellow};
    end
    else magic.font.color:=clred;
  end;
end;

{************ GenerateBtnClick ************}
procedure TForm1.GenerateBtnClick(Sender: TObject);
var
  n,errcode:integer;
  v1,v2:Tpoint;
  p:TPoint;
begin
  with vectors do
  begin
    v1:=point((strtoint(cells[1,1])),(strtoint(cells[2,1])));
    v2:=point(strtoint(cells[1,2]),strtoint(cells[2,2]));
  end;
  begin
    with magic do
    begin
      val(cells[col,row],n,errcode);
      if errcode>0 then n:=1;
      if (n<1) or (n>25) then n:=1;
      if n=1 then cells[col,row]:='1';

      p:=FindOneFrom(point(col,row),v1,v2); {Find where the square should start}
      if sender=nil then Generatefrom(p, v1, v2, false)
      else Generatefrom(p, v1, v2, true);
    end;
  end;
end;

procedure TForm1.ResetBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  for i:=0 to 4 do for j:=0 to 4 do
  magic.cells[i,j]:='';
  magic.font.color:=clblack;
end;

function TForm1.GetOKCountFromVectors(V1,V2:TPoint):integer;

      {********** Validsquare **********}
      function validsquare:boolean;
      {Verify that sq array is a valid magic square}
      var
        i,j,d1,d2:integer;
        rowsums,colsums:array[0..4] of integer;
      begin
        for i:=0 to 4 do
        begin
          rowsums[i]:=0;
          colsums[i]:=0;
        end;
        d1:=0;
        d2:=0;
        for i:=0 to 4 do
        begin
          for j:=0 to 4 do
          begin
            inc(colsums[i],sq[i,j]);
            inc(rowsums[i],sq[j,i]);
            if i=j then inc(d1,sq[i,j]);
            if i+j=4 then inc(d2,sq[i,j]);
          end;
        end;
        result:=true;
        for i:=0 to 4 do
        begin
          if colsums[i]<>65 then result:=false;
          if rowsums[i]<>65 then result:=false;
        end;
        result:=result and (d1=65) and (d2=65);
      end;  {validsquare}

var
  i,j:integer;
  msg:string;
  begin
    result:=0;
    with magic do
    for i:=0 to 4 do
    begin
      for j:=0 to 4 do
      begin
        cells[i,j]:='1';
        Generatefrom(point(i,j), v1, v2,false);
        if validsquare then
        begin
          msg:='OK';
          inc(result);
        end
        else msg:='No';
      end;
    end;
  end;


{************** FindRules **********}
procedure TForm1.FindRules;
{Generate all Loubere (a,b) (a',b') parameters which generate panmagic squares}

    

var
  v1,v2:Tpoint;
  k1,k2,k1p,k2p:integer;
  okcount:integer;
begin
  listbox1.clear;
  vcount:=0;
  screen.cursor:=crhourglass;

  for k1:=-2 to 2 do
  for k2:=-2 to 2 do
  for k1p:=-2 to 2 do
  for k2p:=-2 to 2 do

  begin
    v1:=point(k1,k2);
    v2:=point((k1p),(k2p));
    okcount:=GetOKCountFromvectors(V1,V2);

    if (okcount=25) then
    begin
      listbox1.Items.add(format('#%d: V1:(%d,%d), V2:(%d,%d)',
                                [vcount+1,v1.x, v1.y,v2.x, v2.y]));
      abValues[vcount][1]:=v1.x;
      abValues[vcount][2]:=v1.y;
      abValues[vcount][3]:=v2.x-v1.x;
      abValues[vcount][4]:=v2.y-v1.y;
      inc(vcount)
    end;
  end;
  listbox1.itemindex:=0;
  screen.cursor:=crdefault;
end;


procedure TForm1.ListBox1Click(Sender: TObject);
begin
  with vectors, listbox1 do
  begin
    cells[1,1]:=inttostr(abValues[itemindex,1]);
    cells[2,1]:=inttostr(abValues[itemindex,2]);
    cells[1,2]:=inttostr(abvalues[itemindex,1]+abValues[itemindex,3]);
    cells[2,2]:=inttostr(abvalues[itemindex,2]+abValues[itemindex,4]);
  end;
  VectorsSetEditText(sender,0,0,vectors.cells[1,1]);
  GeneratebtnClick(sender);
end;

{************** FindOnefrom ************}
function TForm1.FindOneFrom(p:TPoint; v1,v2:TPoint):TPoint;
{given a location, p, the number at that cell together with the vectors
 used to generate the moves, determines where the number 1 lies in the
 square}
var
  i,j,k,n:integer;
begin
  with magic do
  begin
    i:=strtoint(cells[p.x,p.y]);;
    j:=p.x;
    k:=p.y;
    n:=(i-1) div 5; {the number of jumps that were taken to get here}
    with result do
    begin
      x:=(j-(n*v2.x)) mod 5; {back x up n*"distance for each jump" (v2.x)}
      x:=(result.x-(i-n-1)*v1.x) mod 5; {also back up the number of regular move cells}
      if x<0 then inc(x,5);  {make sure that it is positive}
      y:=(k-(n*v2.y)) mod 5;  {same for y direction}
      y:=(y-(i-n-1)*v1.y) mod 5;
      if y<0 then inc(y,5);
    end;
  end;
end;

{********** MagicSelectCell **********}
procedure TForm1.MagicSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
{exit to clear magic square when a cell is selected (in preparation for
 user to enter a value to appear in this square)}
var
  i,j:integer;

begin
  with magic do
  begin
    for i:=0 to colcount-1 do
    for j:=0 to colcount-1 do
    cells[i,j]:='';
    font.color:=clblack;
  end;
  canselect:=true;
end;

{************ GLTableClick *************}
procedure TForm1.GLTableClick(Sender: TObject);
{Make a magic square based on selected radix and units
 poermuted values from tables}
var
  i,j:integer;
  aindex,bindex,index,index2,radix,units:integer;
  key,s:string;
begin
  if sender=GLTablea then  {we are not in generateall mode}
  begin
    astart:=1;
    alimit:=24;
  end;
  aIndex:=gltablea.row;
  Bindex:=gltableb.row;
  if (aindex>0) and (bindex>0) then
  with GLMaster do
  begin
    for i:=0 to 4 do
    for j:=0 to 4 do
    begin
      key:='';
      index:=glmasterdata[i,j][1];
      if index<=Astart{1}{2} then radix:=5*(index-1)  {fixed radix }
      else radix:=tableadata[aindex,index-1];

      index2:=glmasterdata[i,j][2];
      if index2=1 then units:=0
      else units:=tablebdata[bindex,index2-1];
      s:=format('%3d',[radix+units+1]);
      glSquare.cells[j,i]:=s;
      key:= key+s;
    end;
  end;
end;


{************* Makekey ************}
function makekey(grid:TStringgrid):string;
{Make a string key of concatenated cell values}
var
  i,j:integer;
  temp:array[0..4] of string;
begin
  with grid do
  begin
    if strtoint(cells[1,0])< strtoint(cells[0,1]) then
    begin
      for i:=0 to 4 do
      for j:=0 to 4 do
      begin
        if j=0 then temp[i]:=grid.cells[j,i]
        else temp[i]:=temp[i]+grid.cells[j,i];
      end;
    end
    else
    begin
      for i:=0 to 4 do
      for j:=0 to 4 do
      begin
        if j=0 then temp[i]:=grid.cells[i,j]
        else temp[i]:=temp[i]+grid.cells[i,j];
      end;
    end;
  end;

  result:='';
  for i:=0 to 4 do result:=result+temp[i];
end;



{************ GLMakeAllBtnClick **********}
procedure TForm1.GLMakeAllBtnClick(Sender: TObject);
{make all squares with 1 in top left. A=1 and a=1 and permute [2,3,4,5] for BCDE and bcde}
begin
  Alimit:=24;
  AStart:=1;
  GLMakeAll;
end;

procedure TForm1.GLMake144BtnClick(Sender: TObject);
{make only the squares where A=1 and B=2.  Permute [3,4,5] for CDE
 and [2,3,4,5] for bcde}
begin
  Alimit:=6;
  AStart:=1;
  GLMakeAll;
end;


{************ GLMakeAll **********}
procedure TForm1.GLMakeAll;
var
  i,j:integer;
  key:string;
  index:integer;
  panmagic:boolean;
  magictest:boolean;
begin
  glsquarelist.clear;
  memo2.scrollbars:=ssBoth;
  memo2.clear;
  gltablea.onclick:=nil; {prevent calc exit when tableA row changes}
  gltablea.row:=0;
  gltableb.row:=0;
  for i:=1 to ALimit{24 for 576 squares} {6 for 144 squares} do
  begin
    gltablea.row:=i;
    for j:=1 to 24 do
    begin
      gltableb.row:=j;  {Will trigger onclick exit to generate a square}
      key:=makekey(glsquare);
      if not glsquarelist.find(key,index) then
      begin
        magictest:=ismagic(glsquare,panmagic);
        if (not magictest) or not (panmagic)
        then memo2.lines.add('Not Panmagic '+key)
        else GLSquarelist.add(key);
        memo2.lines.add('Added: '+key);
      end
      else memo2.lines.add('Duplicate: '+key);
    end;
  end;
  for i:=0 to glsquarelist.count-1 do memo2.lines.add(glsquarelist[i]);
  memo2.lines.add(inttostr(glsquarelist.count)+' unique squares generated');
  gltablea.onclick:=gltableb.onclick;  {restore the onclick exit}
end;


{************ Chk576btnclick ****************}
procedure TForm1.Chk576btnClick(Sender: TObject);
var
  i:integer;
  key:string;
  index:integer;
  v1,v2:tpoint;
begin
  if sender=chk576btn
  then GLMakeallbtnClick(sender)
  else Glmake144btnClick(sender);
  showmessage(inttostr(GLSquarelist.count)+' Greco-Latin PanMagic squares created.');

  memo3.clear;
  for i:= 0 to listbox1.items.count-1 do
  begin
    listbox1.itemindex:=i;
    listbox1click(sender);
    with magic do
    begin
      magic.row:=0;
      magic.col:=0;
      generatebtnclick(sender);
      key:=makekey(magic);
      if not glSquareList.find(key,index) then
      begin
        glSquareList.add(key);
        with vectors do
        begin
          v1:=point((strtoint(cells[1,1])),(strtoint(cells[2,1])));
          v2:=point(strtoint(cells[1,2]),strtoint(cells[2,2]));
        end;
        with memo3.lines do
        add(format('#%2d Added v1:(%d,%d),v2:(%d,%d)' ,[count+1,v1.x,v1.y,v2.x,v2.y]));
      end;
    end;
  end;
  if memo3.lines.count=0 then memo3.lines.add('No additional squares found');
end;

{************** GenAllBtnClick ************}
procedure TForm1.GenAllBtnClick(Sender: TObject);
{Generate all the panmagic squares possible from the current glsquares list by
 moving all 25 numbers to top left, and by rotating a flipping the square (8 ways)
 checking that each result not a duplicate of one already generated}

      {********** MoveRow1 *********}
      procedure moverow1(var key:string);
      {move top row to the bottom of the square}
      var r:string;
      begin
        r:=copy(key,1,15); {get the first row (5 string entries of length 3}
        delete(key,1,15); {delete it}
        key:=key+r; {add it to the end}
      end;

      {******** MoveCol1 **********}
      procedure movecol1(var key:string);
      {move leftmost column to the right end}
      var
        i:integer;
        c:string;
      begin
        for i:=4 downto 0 do
        begin
          c:=copy(key,i*15+1,3); {get the 1st entry from each row}
          insert(c,key,i*15+16); {Insert it at the right end of that row}
          delete(key,i*15+1,3); {delete it from the left end}
        end;
      end;

      {********** Rotate90 **********}
      procedure rotate90(var key:string);
      var
        i,j:integer;
        temp:string;
      begin
        for i:=0 to 4 do
        for j:=4  downto 0 do
        begin {move entries bottom to top  of columns from left to right to
               rows from left to right and top to bottom }
          temp:=temp+copy(key,15*j+3*i+1,3);
        end;
        key:=temp;
      end;

      {******** FlipH **********}
      procedure FlipH(var key:string);
      {Reverse order of rows effectively flipping the square about the center row}
      var
        r:string;
        i:integer;
      begin
        r:='';
        {Move 5 rows in reverse order to invert the square }
        for i:=4 downto 0 do
        {each row is 15 characters long, 5 columns of 3 characters each
         so we'll make a new output string by adding 15 characters at a time
         as we move backwards though the input string}
        r:= r+ copy(key,15*i+1,15);
        key:=r;
      end;

var
  AllSquares, allsquares2:TStringlist;

       {********** Make25From ********}
       procedure Make25from(const key:string);
       {generate row and columns translocations which will place each square in
       the top left corner of the square, add each key to the allsquares
       stringlist if it is not already there}
       var
          n,i,j:integer;
          s:string;
          index:integer;
      begin
        s:=key;
        {take a key and generate variations}
        for n:=0 to glsquarelist.count -1 do
        begin
          s:=glsquarelist[n];
          for i:=1 to 5 do {for each column}
          begin
            for j:=1 to 4 do
            begin
              moverow1(s); {move top row to bottom 4 times}
              begin
                if not Allsquares.find(s,index)then allsquares.add(s)
              end;
            end;
            {move next column to right end of square}
            movecol1(s); {then move the first column to be the last}
            if not Allsquares.find(s,index) then allsquares.add(s)
          end; {loop for all columns}
        end;
      end;



var
  n,i,j:integer;
  s:string;

  index:integer;
  r90count, flipcount:integer;
  savecount:integer;
begin
  screen.cursor:=crhourglass;
  memo4.clear;
  memo4.lines.add('Starting with '+inttostr(glsquarelist.count)+ ' Greco-Latin squares' );
  allsquares:=TStringlist.create;
  allsquares.sorted:=true;
  r90count:=0;
  flipcount:=0;
  make25from(s);

  memo4.lines.add('After generating 25 translations of each: '+inttostr(Allsquares.count));
  allsquares2:=TStringlist.create;
  for n:=0 to allsquares.count -1 do
  begin
    s:=allsquares[n];
    {now rotate & flip}
    for i:=1 to 4 do
    begin
      rotate90(s);
      if not Allsquares2.find(s,index)then
      begin
        allsquares2.add(s);
        {for speed, only update progress label every 1024 additionss}
        if allsquares2.count and $fff = 0 then
        begin
          label6.caption:=inttostr(allsquares2.count);
          application.processmessages;
        end;
      end
      else inc(r90count);
      savecount:=allsquares2.count;
        if allsquares2.count<>savecount
        then showmessage('rotate+make25 added new');
    end;

    flipH(s);
    savecount:=allsquares2.count;
    //make25from(s);
    if allsquares2.count<>savecount
    then showmessage('Flip+make25 added new');
    for j:=1 to 4 do
    begin
      rotate90(s);
      if not Allsquares2.find(s,index)then
      begin
        allsquares2.add(s);
        if allsquares2.count and $fff = 0 then
        {for speed, only update progress label every 1024 additionss}
        begin
          label6.caption:=inttostr(allsquares2.count);
          application.processmessages;
        end;
      end
      else inc(flipcount);
      savecount:=allsquares2.count;
      if allsquares2.count<>savecount
      then showmessage('Flip+rotate+make25 added new');
    end;
  end;

  memo4.lines.add('Rotate and flip duplicates: '+inttostr(r90count+flipcount));
  memo4.lines.add('Total after rotate and flip: '+inttostr(Allsquares2.count));
  label6.caption:=inttostr(allsquares2.count);
  screen.cursor:=crdefault;
  if messagedlg('Save squares to a file?', mtconfirmation,[mbyes, mbno],0)=mryes then
  begin
    if opendialog1.execute then
    begin
      allsquares2.savetofile(opendialog1.filename);
      memo4.lines.add(format('%d squares saved as %s.  Each record represents one square '
      +'as a 75 character record (25 two digit numbers separated by a blank)',
      [allsquares2.count,opendialog1.filename]));
    end;
  end;
end;

{****************** VectorSetEditText *************8}
procedure TForm1.VectorsSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
{Update a label indicating how many Loubere squares can be generated from the
 current V1, V2 vectors as there values are changed in the "Vectors" stringgrid}
var
  v1,v2:Tpoint;
  okcount:integer;
begin
  with vectors do
  begin
    v1.x:=strtointdef(cells[1,1],0);
    v1.y:=strtointdef(cells[2,1],0);
    v2.x:=strtointdef(cells[1,2],0);
    v2.y:=strtointdef(cells[2,2],0);
    okcount:=getOkCountFromvectors(v1,v2);
    label7.caption:=format('Generates %d magic squares',[okcount]);
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
