unit URodPartition3;

interface
uses classes, sysutils;
type


  TPart=record
    Len:extended;
    QtyNeeded:integer;
    QtyAssigned:integer;
  end;

  TStock=record
    Len:extended;
    Cost:extended;
  end;

  TPartStock=array of TStock;
  Tparts=array of TPart;

  TCollapsedRec=record
    partlen:extended;
    Qty:integer;
  end;

  TPartition= record
    len:extended;
    cost:extended;
    divisions:array of extended;
  end;

  TCollapsedPartition= class(TObject)
    len:extended;
    Cost:extended;
    CostUtilization:extended;  {waste cost per usable unit length}
    Collapsed:array of TCollapsedRec;
  end;


  TRodPartitions=class(TObject)
  {private}
    stock:TPartStock;  {the stock lengths}
    nbrlengths:integer;
    parts:TParts; {the allowable lengths of the parts}
    nbrparts:integer;
    partitions:array of TPartition; {array of length patterns for each stock length }
    nextpart:integer; {the next partition to retrieve}
    //nextlen:integer;
    Patternlist:TStringlist;
    fsortby:integer; {0=costutilization, 1 = part lengths}
    procedure makenext(maxlen:extended; nbr, nextentry:integer);

  {public}
    constructor create;
    destructor destroy;   reintroduce;
    function Initialize(const newstock:TPartStock; const newparts:TParts;
                         const newnbrlengths, newnbrparts:integer):boolean;
    function getfirstpartition(var p:TPartition):boolean; overload;
    function getfirstpartition(var pc:TCollapsedPartition):boolean; overload;
    function getnextpartition(var p:TPartition):boolean; overload;
    function getnextpartition(var pc:TCollapsedPartition):boolean; overload;
    function getpartindexfromlen(x:extended):integer;
    function getstockindexfromlen(x:extended):integer;
    procedure sortflag(index:integer);
  end;

  var
    DefPartition:TRodPartitions;

implementation

constructor TRodPartitions.create;
begin
  inherited;
  patternlist:=Tstringlist.create;
  fsortby:=0;
end;

destructor TRodPartitions.destroy;
var
  i:integer;
begin
  for i:=patternlist.count-1 downto 0 do tCollapsedPartition(patternlist.objects[i]).free;
  patternlist.clear;
  inherited;
end;

function TRodpartitions.getpartindexfromlen(x:extended):integer;
{search the parts array looking for length x and return the array index if found}
var
  i:integer;
begin
  result:=-1;
  for i:=0 to high(parts) do
  with parts[i] do
  begin
    if len=x then
    begin
      result:=i;
      break;
    end;
  end;
end;

function TRodpartitions.getStockIndexfromlen(x:extended):integer;
{Search the stock array looking for length x and return the array index if found}
var
  i:integer;
begin
  result:=-1;
  for i:=0 to high(stock) do
  with stock[i] do
  begin
    if len=x then
    begin
      result:=i;
      break;
    end;
  end;
end;

procedure TRodpartitions.sortflag(index:integer);
begin
  fsortby:=index;
end;

{****************** Makenext *****************}
procedure TRodPartitions.makenext(maxlen:extended; nbr, nextentry:integer);
{Recursive procedure to generate patterns}
var
  i,j,n:integer;
  x:extended;

begin
  with partitions[nextpart] do
  if nbr>=nbrparts-1 then {we have collected all of the information for a pattern}
  begin
    x:=parts[nbr].len;
    n:= trunc(maxlen / x);
    for j:=1 to n do
    begin
      divisions[nextentry+j-1]:=x;
      maxlen:=maxlen-x;
    end;
    If maxlen>0 then
    begin {there is some waste, this is the final "leftover" entry}
      setlength(partitions[nextpart].divisions,nextentry+n+1);
      divisions[nextentry+n]:=maxlen;
    end
    else setlength(partitions[nextpart].divisions,nextentry+n);

    inc(nextpart);
    if length( partitions)<=nextpart
    then  setlength(partitions,nextpart+10);
    setlength(partitions[nextpart].divisions,
              length(partitions[0].divisions));
    partitions[nextpart].len:=partitions[nextpart-1].len;
    partitions[nextpart].cost:=partitions[nextpart-1].cost;

    for i:=0 to high(partitions[nextpart-1].divisions) do
      partitions[nextpart].divisions[i]:=
      partitions[nextpart-1].divisions[i];
  end
  else
  begin
    x:=parts[nbr].len;
    n:= trunc(maxlen / x);
    if n>0 then
    begin
      for i:=0 to n do
      begin
        for j:=0 to i-1 do partitions[nextpart].divisions[nextentry+j]:=x;
        makenext(maxlen-i*x, nbr+1, nextentry+i);
      end;
    end
    else makenext(maxlen, nbr+1, nextentry);
  end;

end;

{******************* Initialize ***************}
function TRodpartitions.Initialize(const newstock:TPartStock; const newparts:TParts;
                                    const newNbrLengths, newNbrParts:integer):boolean;
  var
    i,j:integer;
    temp:TPart;
    pc:TCollapsedpartition;
    minpartlen,wastelen:extended;
    s:string;
  begin

    for i:=patternlist.count-1 downto 0 do tCollapsedPartition(patternlist.objects[i]).free;
    patternlist.clear;
    result:=true;
    nbrparts:=newnbrparts;
    setlength(parts,nbrparts);
    for i:=0 to nbrparts-1 do parts[i]:=newparts[i];
    (*
    {sort parts in descending length}
    for i:=0 to high(parts)-1 do
    for j:=i+1 to high(parts) do
    if parts[i].len<parts[j].len then
    begin
      temp:=parts[i];
      parts[i]:=parts[j];
      parts[j]:=temp;
    end;
    *)
    nbrlengths:=newnbrlengths;
    setlength(stock,nbrlengths);
    for i:=0 to nbrlengths-1 do
    begin
      stock[i]:=newstock[i];
    end;
    nextpart:=-1;
    setlength(partitions,10);
    for i:=0 to nbrlengths-1 do
    begin
      inc(nextpart);

      if nextpart>high(partitions) then setlength(partitions,3*nextpart div 2);
      partitions[nextpart].len:=stock[i].len;
      partitions[nextpart].cost:=stock[i].cost;
      {set length to the most parts that can occur which is length divided by
       shortest part}
      setlength(partitions[nextpart].divisions,trunc(stock[i].len / parts[high(parts)].len));
      makenext(stock[i].len,0,0);
      {makenext generates one partition entry ahaead which we'll delete here}
      setlength(partitions,nextpart);
      dec(nextpart); {and subtract from the count}
    end;

    pc:=TCollapsedPartition.create;
    if getfirstpartition(pc) then
    begin
     // patcount:=length(pc.Collapsed);
      repeat
        with pc do
        begin
          minpartlen:=parts[nbrparts-1].len;
          if collapsed[high(collapsed)].partlen<minpartlen
            {this is the "waste" length}
          then wastelen:=collapsed[high(collapsed)].partlen
          else wastelen:=0.0;
          s:='';

          case fsortby of
            0:
            begin
              {sort by cost utilization}
              costutilization:=cost*wastelen/len;
              s:=format('%8.2f',[costutilization])
            end;
            1:
            begin
              {alternative - sort by part lengths within pattern}
              for i:=0 to high(collapsed) do
              s:=s+format('%4.0f',[9999-collapsed[i].partlen]);
            end;
          end; {case}

          patternlist.addobject(s,pc);
        end;
        pc:=TCollapsedPartition.create;
      until not getnextpartition(pc);
      pc.free;
    end;
    patternlist.sort;
    if patternlist.count>500 then
    for i:= patternlist.count-1 downto 500 do
    begin
      TCollapsedPartition(patternlist.objects[i]).free;
      patternlist.delete(i);
    end;


    with patternlist do
    for i:=0 to count-1 do
    begin
      //costutilization:=TCollapsedpartition(objrct[i]);
      patternlist[i]:=format('P%2.0d',[i+1]);
    end;
  end;

{**************** GetFirstPartition ****************8}
  function TRodpartitions.getfirstpartition(var p:TPartition):boolean;
  begin
    nextpart:=0;
    result:=getnextpartition(p)
  end;


{**************** GetFirstPartition (Collapsed version)*****************}
  function TRodpartitions.getfirstpartition(var pc:TCollapsedPartition):boolean;
  begin
    nextpart:=0;
    result:=getnextpartition(pc);
  end;

{************* GetNextPartition **************}
  function TRodpartitions.getnextpartition(var p:TPartition):boolean;
  begin
    result:=false;
    if nextpart<=high(partitions) then
    begin
      p:=partitions[nextpart];
      result:=true;
      inc(nextpart);
    end;
  end;

{**************** GetNextPartition (Collapsed version) **********}
  function TRodpartitions.getnextpartition(var pc:TCollapsedPartition):boolean;
  var
    i:integer;
    p:TPartition;
    nextcollpart:integer;
  begin
    setlength(pc.collapsed,10);
    nextcollpart:=0;
    result:=getnextpartition(p);
    if result then
    begin
      pc.len:=p.len;
      pc.cost:=p.cost;
      pc.collapsed[0].partlen:=p.divisions[0];
      pc.collapsed[0].Qty:=1;
      for i:=1 to high(p.divisions) do
      begin
        if p.divisions[i]=pc.collapsed[nextcollpart].partlen
        then inc(pc.Collapsed[nextcollpart].Qty)
        else
        begin
          inc(nextcollpart);
          if nextcollpart>length(pc.collapsed)
          then setlength(pc.collapsed, length(pc.collapsed)+10);
          pc.collapsed[nextcollpart].partlen:=p.divisions[i];
          pc.collapsed[nextcollpart].Qty:=1;
          result:=true;
        end;
      end;
      setlength(pc.collapsed, nextcollpart+1);
    end;
  end;

  initialization
     defpartition:=TRodPartitions.create;

end.
