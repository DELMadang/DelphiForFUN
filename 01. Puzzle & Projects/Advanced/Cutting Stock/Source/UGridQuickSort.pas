unit UGridQuickSort;

interface
Uses windows, controls, forms, sysutils, grids;

procedure Sortgrid(Grid : TStringGrid;  {the grid to sort}
                   sortcol:integer; {the column to sort on}
                   datatype:integer;  {0=alpha, 1=integer, 2=real}
                   ascending:boolean  {true= ascending, false=descending}
                    );




implementation


{**************** QuickSort *************8}
procedure Quicksort(Grid:TStringGrid; var List:array of integer;
    min, max,sortcol,datatype: Integer; Ascending:boolean);
{List is a list of rownumbers in the grid being sorted}
var
    med_value : integer;
    hi, lo, i : Integer;

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
      end;
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
        while
           (ascending and (compare(Grid.cells[sortcol,List[hi]]
                             ,grid.cells[sortcol,med_value])>=0))
           or ((not ascending) and (compare(Grid.cells[sortcol,List[hi]]
                             ,grid.cells[sortcol,med_value])<=0))
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
procedure Sortgrid(Grid : TStringGrid; sortcol,datatype:integer; ascending:boolean);
{Setup to run quicksort then call it}
var
   i : integer;
   tempgrid:tstringGrid;
   list:array of integer;
begin
  screen.cursor:=crhourglass;
  tempgrid:=TStringgrid.create(nil);
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
    quicksort(Grid, list,0,rowcount-fixedrows-1,sortcol,datatype, ascending);
    {set flag to draw arrow on grid header (requires OnDrawCell exit,
     also defaultdrawing property for the grid should be set to false)}
    If ascending then grid.tag:=sortcol+1 else grid.tag:=-sortcol-1;

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

end.
 