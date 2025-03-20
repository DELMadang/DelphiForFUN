unit U_GridQuicksort3;
{Copyright  © 2002-2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Sample program to sort rows of a stringgrid based on any selected column
 Version 2 - adds datatype to correctly sort alpha, integer, or real data types
 }

 {Addendum - March 2004 - added ascending/descending sort capablity}
 {Addendum  - February 2005 - added arrow indicator of sort column and direction}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ComCtrls, ExtCtrls, ShellAPI;

type

  TSortPanel = class(TPanel)
    SortLbl:TLabel;
    SortCol:TComboBox;
    Order:TComboBox;
  public
    PositionNbr:Integer;
    constructor create(const proto:TPanel; const nbr:integer);
  end;

  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Label1: TLabel;
    RowsEdt: TEdit;
    Label2: TLabel;
    RowsUD: TUpDown;
    DataTypeGrp: TRadioGroup;
    StaticText1: TStaticText;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    Label3: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    AddColBtn: TButton;
    DelColBtn: TButton;
    SortBtn: TButton;
    Label6: TLabel;
    SortGrp: TRadioGroup;
    Memo1: TMemo;
    SortTimeLbl: TLabel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DataTypeGrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure AddColBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure DelColBtnClick(Sender: TObject);
    procedure Panel1Enter(Sender: TObject);
    procedure SortBtnClick(Sender: TObject);
  public
    { Public declarations }
    sort1:TSortpanel;
    nbrsortpanels:integer;
    SortPanels:array[2..5] of Tsortpanel; {could be as many as one for each column}
    hasfocus:integer;
    procedure SortGrid(Grid : TStringGrid; const SortCol,datatype:integer; const ascending:boolean);
    procedure Quicksort(Grid:TStringGrid; var List:array of integer;
            min, max:integer; sortcol:integer; datatype: Integer; Ascending:boolean);
    procedure Shellsort(Grid:TStringgrid; var ASort:array of integer; sortcol,datatype:integer; ascending:boolean);
    procedure BubbleSort(Grid:TStringgrid; var ASort:array of integer; sortcol,datatype:integer; ascending:boolean);
    procedure Mergesort(Grid:TStringgrid; var Vals: array of integer; sortcol,datatype:integer; ascending:boolean);
    procedure makegrid(r:integer);
    procedure adjustGridWidth(grid:TStringGrid);
  end;

  var
  Form1: TForm1;

implementation

{$R *.DFM}



Constructor TSortpanel.create(const Proto:TPanel; const nbr:integer);

  procedure boxassign(Outbox,C:TCombobox);
  begin
    with outbox do
    begin
      parent:=self;
      left:=c.left;
      top:=c.top;
      width:=c.width;
      height:=c.height;
      items.assign(c.items);
      itemindex:=c.itemindex;
      Style:=csdropdownList;
    end;
  end;


begin
  inherited create(proto.owner);
  left:=proto.left;
  top:=proto.top+(proto.Height*(nbr-1));
  width:=proto.width;
  height:=proto.height;
  parent:=proto.parent;
  visible:=true;
  positionNbr:=nbr+1;
  onenter:=proto.OnEnter;

  Sortlbl:=TLabel.create(self);
  if proto.controls[0] is TLabel then
  with TLabel(proto.Controls[0]) do
  begin
    SortLbl.Left:=left;
    Sortlbl.Top:=top;
    Sortlbl.Caption:=caption;
    sortlbl.Parent:=self;
  end;
  if nbr>1 then sortlbl.caption:='Then by';

  SortCol:=TComboBox.create(self);
  if proto.controls[1] is TComboBox then boxassign(sortcol, tcombobox(proto.controls[1]));

  Order:=TCombobox.create(self);
  if proto.controls[2] is TComboBox then boxassign(Order,TCombobox(proto.controls[2]));
end;



//procedure MergeSort(var Vals:array of integer;ACount:Integer);
procedure TForm1.Mergesort(Grid:TStringgrid; var Vals: array of integer; sortcol,datatype:integer; ascending:boolean);
var AVals:array of integer;

  function compare(val1,val2:string):integer;
  var
    int1,int2:integer;
    errcode:integer;
    float1,float2:extended;
  begin
    case datatype of
      0: result:=ANSIComparetext(val1,val2);
      1: begin
           int1:=strtointdef(val1,0);
           int2:=strtointdef(val2,0);
           if (int1>int2) then result:=1
           else if int1<int2 then result:=-1
           else result:=0;
         end;

      2: begin
           val(val1,float1,errcode);
           if errcode<>0 then float1:=0;
           val(val2,float2,errcode);
           if errcode<>0 then float2:=0;
           if float1>float2 then result:=1
           else if float1<float2 then result:=-1
           else result:=0;
         end;
       else result:=0;
      end;{case}
    end;

  {---------- Merge -------------}
  procedure Merge(ALo,AMid,AHi:Integer);
  var i,j,k,m,n:Integer;
  begin
    i:=0;
    setlength(Avals,Amid-alo+1);
    for j:=ALo to AMid do
    begin
      {copy lower half of Vals into temporary array AVals}
      AVals[i]:=Vals[j];
      inc(i);
    end;

    i:=0;
    j:=AMid + 1;
    k:=ALo;
    while ((k < j) and (j <= AHi)) do
    begin
      {Merge: Compare upper half to copied verasion of the lower half and move the
       appropriate value (smallest for ascending, largest for descending) into
       the lower half positions, for equals use Avals to preserve original order}
      with grid do
      n:=compare(cells[sortcol,Vals[j]],cells[sortcol,Avals[i]]);
      if ascending and (n>=0)
      or ((not ascending) and (n<=0))
      then
      begin
        Vals[k]:=AVals[i];
        inc(i);inc(k);
      end
      else
      begin
        Vals[k]:=Vals[j];
        inc(k);inc(j);
      end;
    end;

    {copy any remaining, unsorted, elements}
    for m:=k to j - 1 do
    begin
      Vals[m]:=AVals[i];
      inc(i);
    end;
  end;

  {------------ PerformMergeSort ------------}
  procedure PerformMergeSort(ALo,AHi:Integer);
  {recursively split the split the value into 2 pieces and merge them back
   together as we unwind the recursion}
  var AMid:Integer;
  begin
    if (ALo < AHi) then
    begin
      AMid:=(ALo + AHi) shr 1;
      PerformMergeSort(ALo,AMid);
      PerformMergeSort(AMid + 1,AHi);
      Merge(ALo,AMid,AHi);
    end;
  end;

begin
  PerformMergeSort(0,high(vals));
end;



procedure TForm1.BubbleSort(Grid:TStringgrid; var ASort: array of integer; sortcol,datatype:integer; ascending:boolean);
var
  i,j,n:integer;

    procedure swap(var a,b:integer);
    var  temp:integer;
    begin
      temp:=a;
      a:=b;
      b:=temp;
    end;


    function compare(const val1,val2:string):integer;
    var
      int1,int2:integer;
      float1,float2:extended;
      errcode:integer;
    begin
      case datatype of
      0: result:=ANSIComparetext(val1,val2);
      1: begin
           int1:=strtointdef(val1,0);
           int2:=strtointdef(val2,0);
           if (int1>int2) then result:=1
           else if int1<int2 then result:=-1
           else result:=0;
         end;

      2: begin
           val(val1,float1,errcode);
           if errcode<>0 then float1:=0;
           val(val2,float2,errcode);
           if errcode<>0 then float2:=0;
           if float1>float2 then result:=1
           else if float1<float2 then result:=-1
           else result:=0;
         end;
       else result:=0;
      end;{case}
    end;



begin
  for i:=0 to high(asort)-1 do
  begin
    for j:=i+1 to high(asort) do
    begin
      n:=compare(grid.Cells[sortcol,asort[i]],
                   grid.cells[sortcol,asort[j]]);
      if ascending
      then if  (n>0)
           then swap(asort[i],asort[j])
           else
      else if n<0 then swap(asort[i],asort[j]);
    end;
  end;
end;



procedure TForm1.Shellsort(Grid:TStringgrid; var ASort: array of integer; sortcol,datatype:integer; ascending:boolean);
var
  iI, iJ, iK,
  iSize: integer;
  wTemp: integer;

  function compare(val1,val2:string):integer;
  var
    int1,int2:integer;
    float1,float2:extended;
    errcode:integer;
  begin
          case datatype of
          0: result:=ANSIComparetext(val1,val2);
          1: begin
               int1:=strtointdef(val1,0);
               int2:=strtointdef(val2,0);
               if (int1>int2) then result:=1
               else if int1<int2 then result:=-1
               else result:=0;
             end;

          2: begin
               val(val1,float1,errcode);
               if errcode<>0 then float1:=0;
               val(val2,float2,errcode);
               if errcode<>0 then float2:=0;
               if float1>float2 then result:=1
               else if float1<float2 then result:=-1
               else result:=0;
             end;
           else result:=0;
        end;{case}
      end;

begin
  iSize := High(aSort);
  iK := iSize shr 1;
  while iK > 0 do
  begin
    with grid do
    for iI := 0 to iSize - iK do
    begin
      iJ := iI;
      while (iJ >= 0) do
      begin
        If ascending and (compare(cells[sortcol,aSort[iJ]],
                                 cells[sortcol,aSort[iJ + iK]])<=0)
        then break
        else
        if (not ascending) and (compare(grid.cells[sortcol,aSort[iJ]],
                               cells[sortcol,aSort[iJ + iK]])>=0)
        then break;

        wTemp := aSort[iJ];
        aSort[iJ] := aSort[iJ + iK];
        aSort[iJ + iK] := wTemp;
        if iJ > iK then
          Dec(iJ, iK)
        else
          iJ := 0
      end;
    end;
    iK := iK shr 1;
  end;
end;






{**************** QuickSort *************8}
procedure TForm1.Quicksort(Grid:TStringGrid; var List:array of integer;
            min, max:integer; sortcol:integer; datatype: Integer; Ascending:boolean);
{List is a list of rownumbers in the grid being sorted}
var
    med_value : integer;
    hi, lo, i : Integer;

    function compare(const val1, val2: string):integer;
    var
      i:integer;
      int1,int2:integer;
      float1,float2:extended;
      errcode:integer;
    begin
        case datatype of
          0: result:=ANSIComparetext(val1,val2);
          1: begin
               int1:=strtointdef(val1,0);
               int2:=strtointdef(val2,0);
               if (int1>int2) then result:=1
               else if int1<int2 then result:=-1
               else result:=0;
             end;

          2: begin
               val(val1,float1,errcode);
               if errcode<>0 then float1:=0;
               val(val2,float2,errcode);
               if errcode<>0 then float2:=0;
               if float1>float2 then result:=1
               else if float1<float2 then result:=-1
               else result:=0;
             end;
           else result:=0;
        end;{case}
   end; {compare}

begin


    {If the list has <= 1 element, it's sorted}
    if (min >= max) then Exit;
    {Pick a dividing item randomly}
    i := min + Trunc(Random(max - min + 1));
    med_value := List[i];
    List[i] := List[min]; { Swap it to the front so we can find it easily}
    {Move the items smaller than this into the left
     half of the list. Move the others into the right}
    lo := min;
    hi := max;
    while (True) do
    begin
        // Look down from hi for a value < med_value (for ascending)
        with grid do
        while
           ((ascending and (compare(cells[sortcol,list[hi]],
                                    cells[sortcol,med_value])>=0))
           or ((not ascending) and (compare(cells[sortcol,List[hi]],
                                    cells[sortcol,med_value])<=0))
              )
        do
        begin
            dec(hi);
            if (hi <= lo) then Break;
        end;
        if (hi <= lo) then
        begin {We're done separating the items}
          List[lo] := med_value;
          Break;
        end;

        // Swap the lo and hi values.
        List[lo] := List[hi];
        inc(lo); {Look up from lo for a value >= med_value}

        while
          (ascending and (Compare(grid.cells[sortcol,List[lo]],
                 grid.cells[sortcol,med_value])<0))
          or ((not ascending) and (Compare(grid.cells[sortcol,List[lo]],
                 grid.cells[sortcol,med_value])>0))
        do
        begin
            inc(lo);
            if (lo >= hi) then break;
        end;
        if (lo >= hi) then
        begin  {We're done separating the items}
          lo := hi;
          List[hi] := med_value;
          break;
        end;
        List[hi] := List[lo];
    end;
    {Sort the two sublists}
    Quicksort(Grid,List, min, lo - 1,sortcol,datatype, ascending);
    Quicksort(Grid,List, lo + 1, max,sortcol,datatype, ascending);

end;


{************** Sortgrid ***************}
//procedure Tform1.Sortgrid(Grid : TStringGrid; sortcol,datatype:integer; ascending:boolean);
procedure TForm1.SortGrid(Grid : TStringGrid; const SortCol:integer; const datatype:integer; const ascending:boolean);
{Setup to run quicksort then call it}
var
   i : integer;
   tempgrid:tstringGrid;
   list:array of integer;
begin
  screen.cursor:=crhourglass;
  tempgrid:=TStringgrid.create(self);
  with tempgrid do
  begin
    rowcount:=grid.rowcount;
    colcount:=grid.colcount;
    fixedrows:=grid.fixedrows;
  end;
  with Grid do
  begin
    setlength(list,rowcount-fixedrows);
    for i:= fixedrows to rowcount-1 do
    begin
      list[i-fixedrows]:=i;
      tempgrid.rows[i].assign(grid.rows[i]);
    end;
    //quicksort(Grid, list,0,rowcount-fixedrows-1,sortcols,datatype, ascending);
    //Shellsort(Grid, list,sortcol+1,datatype, ascending);
    //BubbleSort(Grid, list,sortcol+1,datatype, ascending);
    MergeSort(Grid, list,sortcol+1,datatype, ascending);



    {set flag to draw arrow on grid header (requires OnDrawCell exit,
     also defaultdrawing property for the grid should be set to false)}
    //If dirgrp.itemindex=0 then grid.tag:=sortcol+1 else grid.tag:=-sortcol-1;

    for i:=0 to rowcount-fixedrows-1 do
    begin
      rows[i+fixedrows].assign(tempgrid.rows[list[i]])
    end;
    row:=fixedrows;
  end;
  tempgrid.free;
  setlength(list,0);
  screen.cursor:=crdefault;
end;

{************ FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  stringGrid1.defaultdrawing:=false;  {needed for proper OndrawCell processing}
  makegrid(rowsud.position);
end;

{**************** AdjustGridWidth *************}
procedure TForm1.adjustGridWidth(grid:TStringGrid);
{Adjust borders of grid to just fit cells}
var
  w,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;

  end;
end;

{************* Makegrid ***********}
procedure TForm1.makegrid(r:integer);
{Make a new random grid of specified size and data type}
var
  i,j,k:integer;
  s:string;

begin
  with stringgrid1 do
  begin
    if r>1 then rowcount:=r;
    for i:=1 to colcount-1 do colwidths[i]:=defaultcolwidth+random(20);
    adjustgridwidth(stringgrid1);
    for j := 1 to rowcount-1 do
    for i:= 1 to colcount-1 do
    case datatypegrp.itemindex of
      0: {alpha}
      begin
        s:='';
        for k:=1 to 3 do s:=s+char(ord('A')+random(26));
        cells[i,j]:=s;
      end;
      1: cells[i,j]:=inttostr(random({10*r)-5*r} r div 2)); {integers}
      2: cells[i,j]:=floattostrf(random*10*r-5*r,fffixed,7,3); {reals}
    end;
    for i:= 1 to rowcount-1 do cells[0,i]:='Row '+ format('%4d',[i]);
    for i:= 0 to colcount-1 do cells[i,0]:='Column '+ inttostr(i+1);
  end;
end;

{************** StringgridMouseUp ***********}
procedure TForm1.StringGrid1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  c,j:integer;
  rect:Trect;
{Set up and sort on clicked column if click is on 1st row}
begin
  c:=0;
  with stringgrid1 do
  if y<=rowheights[0] then
  begin
    if rowcount<>rowsUD.position then makegrid(rowsud.position);
    for j:= 0 to colcount-1 do {determine which column was clicked}
    begin
      rect := cellrect(j,0);
      if (rect.Left < x) and (rect.Right> x) then
      begin
        c := j;
        break;
      end;
    end;
    //sortgrid(stringgrid1,c,dataTypeGrp.itemindex);
 end;

end;

{********* DataTypegrpClick *********8}
procedure TForm1.DataTypeGrpClick(Sender: TObject);
begin
  {Make a new random grid}
  makegrid(rowsud.position);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
{link to DFF homepage}
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{***************** StringgridDrawCell ********}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

  {DrawArrow procedure}
  procedure DrawArrow;
  {draw and up or down arrow in column Acol, based on sign of sender.tag}
  var tw,ah:integer;
      L,t:integer;
      ahbase, ahpeak:integer;
  begin
    with Tstringgrid(sender), canvas do
    begin
      brush.color:=clblack;
      pen.color:=clblack;
      tw:=textwidth(cells[acol,arow]);
      ah:=rowheights[arow]div 3;
      {check that there is enough space for the arrow}
      if colwidths[acol]< 6+tw+ah
      then colwidths[acol]:=6+tw+ah;
      L:=rect.left;
      t:=rect.top;
      if tag<0 then
      begin
        ahbase:=t+ah div 2;
        ahpeak:= t+2*ah;
      end
      else
      begin
        ahbase:=t+2*ah;
        ahpeak:= t+ah div 2;
      end;
      moveto(L+tw+4,ahbase);
      lineto(L+tw+2+ah,ahbase);
      lineto(L+tw+4+ah div 2, ahpeak);
      lineto(L+tw+4,ahbase);
      floodfill(L+tw+3+ah div 2, (ahbase + ahpeak) div 2, clblack,fsBorder);
    end;
  end;

begin {StringgridDrawCell}
  with sender as Tstringgrid, canvas do
  begin
    If (acol<fixedcols) or (arow<fixedrows) then  brush.color:=fixedcolor
    else brush.color:=color;
    fillrect(rect);
    textout(rect.left+2, rect.top+2, cells[acol,arow]);
    if (arow=0) and (fixedrows>0) and (acol+1=abs(tag)) then drawarrow;
  end;
end;


procedure TForm1.AddColBtnClick(Sender: TObject);
begin

  if nbrsortpanels<4 then
  begin
    inc(nbrsortpanels);
    Sortpanels[nbrsortpanels+1]:=TSortPanel.Create(panel1,nbrsortpanels);
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  nbrsortpanels:=0;
  addcolbtnclick(sender);
end;

procedure TForm1.DelColBtnClick(Sender: TObject);
var
  i,j:integer;
begin
  if hasfocus>0 then
  for i:=low(sortpanels) to nbrsortpanels+1 do
  with sortpanels[i] do
  begin
    if hasfocus >1 then
    begin
      sortpanels[hasfocus].free;
      for j:=hasfocus to nbrsortpanels do
      begin
        sortpanels[j]:=sortpanels[j+1];
        with sortpanels[j] do top:= top-height;
      end;
      dec(nbrsortpanels);
      break;
    end;
  end;
end;

procedure TForm1.Panel1Enter(Sender: TObject);
begin
  If sender is TSortpanel
  then hasfocus:=TSortpanel(sender).positionNbr
  else hasfocus:=-1;
end;

procedure TForm1.SortBtnClick(Sender: TObject);
var
  i:integer;
  starttime, endtime, freq:int64;
begin
  queryperformancecounter(starttime);
  If nbrsortpanels>0 then
  begin
    for i:=1 to nbrsortpanels do
    with sortpanels[i+1] do
    sortgrid(stringgrid1,sortcol.ItemIndex,datatypegrp.itemindex,order.itemindex=0);
  end
  else showmessage('Click "Add column" and select columns to sort first');
  queryperformancecounter(endtime);
  queryPerformancefrequency(freq);
  sortTimeLbl.Caption:=format('%6.2f ms',[1000*(endtime-starttime)/freq]);
end;

end.
