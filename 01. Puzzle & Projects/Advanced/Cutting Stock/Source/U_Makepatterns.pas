unit U_Makepatterns;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, URodpartition2;


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

  TPatPart=record
    partnbr:integer;
    Qty:integer;
  end;

  TRod=record
    stocknbr:integer;
    patpart: array [1..10] of TPatPart; {the parts that make up this pattern}
    nbrpatparts:integer;
    totlength:extended;
    remaininglength:extended;
    QtyAssigned:integer;
    wasteratio:extended;
  end;


  TForm1 = class(TForm)
    PartsGrid: TStringGrid;
    SupplyGrid: TStringGrid;
    Memo1: TMemo;
    PatternBtn: TButton;
    LoadcaseBtn: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Showcollapsed: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure PatternBtnClick(Sender: TObject);
    procedure LoadcaseBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    newstock:TPartStock;
    newparts:tparts;

    parts:array of TPart;
    NPart:integer;

    stock:array  of TStock;
    NStock:integer;
    Currentstocknbr:integer;

    Pattern:array of TRod;
    NPats:integer;

    Solution:array  of TRod;
    NSolution:integer;
    SolutionCost:extended;
    filename:string;

    procedure loadfromgrids;
    procedure loadcase(fname:string);
    //procedure loadgridsfromfile;
    //procedure initialize(var rod:TRod; currentstocknbr:integer);
    //function addparts(oldrod:TRod; partToAdd:integer):boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
{Test case 1}
parts1:array[1..4,0..1] of extended =
        ((45.00,97),
         (36.00,610),
         (31.00,395),
         (14.00,211)
         );
stock1:array[1..1,0..1] of extended=
         ((100.00,1.00)
         );


procedure TForm1.FormCreate(Sender: TObject);
var
  r:integer;

begin
  opendialog1.initialdir :=extractfilepath(application.exename);

  with partsgrid do
  begin
    cells[0,0]:='Length';
    cells[1,0]:='Nbr req.';
    rowcount:=high(parts1)+1;
    for r:=1 to high(parts1) do
    begin
      cells[0,r]:=format('%6.2f',[parts1[r,0]]);
      cells[1,r]:=format('%5.0f',[parts1[r,1]]);
    end;
  end;

  with supplygrid do
  begin
    cells[0,0]:='Length';
    cells[1,0]:='Cost';
    rowcount:=high(stock1)+1;
    for r:=1 to high(stock1) do
    begin
      cells[0,r]:=format('%6.2f',[stock1[r,0]]);
      cells[1,r]:=format('%6.2f',[stock1[r,1]]);
    end;
  end;
  (*
  NPart:=0;
  NStock:=0;
  NPats:=0;
  NSolution:=0;
  *)
  loadcase(extractfilepath(application.exename)+'Default.txt');
end;


procedure TForm1.loadfromgrids;
var
  i,j:integer;
begin

  with partsgrid do
  begin
    setlength(newparts,rowcount-1);
    for i:=1 to rowcount-1 do
    with parts[i-1] do
    begin
      len:=strtofloat(cells[0,i]);
      qtyNeeded:=strtoint(cells[1,i]);
      qtyassigned:=0;
      newparts[i-1]:=len;
    end;
    NPart:=rowcount-1;
  end;

  with supplygrid do
  begin
    for i:=1 to rowcount-1 do
    with stock[i-1] do
    begin
      len:=strtofloat(cells[0,i]);
      cost:=strtofloat(cells[1,i]);
      newstock[i-1]:=len;
    end;
    NStock:=rowcount-1;
  end;
end;


procedure TForm1.PatternBtnClick(Sender: TObject);
var
  i,j:integer;
  s:string;
  p:Tpartition;
  pc:TCollapsedPartition;
  patcount,count2:integer;
  L:extended;

  procedure showpattern(const p:TPartition);
  var
    i:integer;
    s:string;
    begin
      with p do
      begin
        s:='';
        for i:=0 to high(divisions) do
        s:=s+format('%f',[divisions[i]])+',';
        system.delete(s,length(s),1);
        memo1.lines.add(s);
      end;
    end;

begin
  memo1.clear;
  setlength(newstock,1);
  {load partition case info from grid}
  loadfromgrids;
  with defpartition do
  begin
    initialize(newstock,newparts,nstock,npart);

    if showcollapsed.checked then

    begin
      if getfirstpartition(pc) then
      with memo1.lines do
      begin
        patcount:=0;
        for i:=0 to nstock-1 do inc(patcount,length(partitions[i]));
        label1.caption:= 'Pattern count = '+inttostr(patcount);
        count2:=0;
        L:=-1.0;
        repeat
          If (patcount>1000) then
               if (count2=0) then add('First 250 patterns')
               else if count2=patcount-250 then
               begin add(''); add('Last 250 patterns'); end;
          if (patcount<1000) or
            ((patcount>1000) and ((count2<250) or (count2>patcount-250)))then
          with pc do
          begin
            if (pc.len<>L ) then
            begin
              add('');
              add('Stock Length: ' +floattostr(pc.len));
              L:=Pc.len;
            end;
            s:='';
            for i:=0 to high(collapsed) do
              with collapsed[i] do
              s:=s+format('(%f,%d)',[partlen,qty])+',';
              system.delete(s,length(s),1);
              memo1.lines.add(s);
            end;
          inc(count2);
        until not getnextpartition(pc);
      end;
    end
    else
    begin
      patcount:=0;
      for i:=0 to nstock-1 do inc(patcount,length(partitions[i]));
      label1.caption:= 'Pattern count = '+inttostr(patcount);
      count2:=0;
      L:=-1.0;
      if getfirstpartition(p) then
      with memo1.lines do
      repeat
        If (patcount>1000) then
             if (count2=0) then add('First 250 patterns')
             else if count2=patcount-250 then
             begin add(''); add('Last 250 patterns'); end;
        if (patcount<1000) or
          ((patcount>1000) and ((count2<250) or (count2>patcount-250)))then
        with p do
        begin
          if (p.len<>L ) then
          begin
            add('');
            add('Stock Length: ' +floattostr(p.len));
            L:=P.len;
          end;
          showpattern(p);


        end;

        inc(count2);
      until not getnextpartition(p);
    end;
  end;
end;


procedure TForm1.LoadcaseBtnClick(Sender: TObject);
begin
  if opendialog1.Execute then loadcase(opendialog1.filename);
end;


procedure TForm1.loadcase(fname:string);

var
   i : integer;
   fin : textfile;
   version:string;
begin
  begin
    filename:=fname;
    {$I-}
    assignfile(fin,filename);
    reset( fin );          (* open file *)
    if (ioresult <> 0) then
    begin
      showmessage('File can not be opened');
    {$I+}
    end
    else
    //with originaldata do
    begin
      //statictext1.caption:=filename;
      //savedialog1.filename:=fileName;
      Readln(fin, NStock, NPART, version);
      setlength(Stock,NStock);
      setlength(newstock,Nstock);
      setlength(Parts,NPart);
      setlength(newparts,NPart);
      if trim(version)='' then
      begin
        for i:=0 to NStock-1  do Read(fin, Stock[i].len);
        for i:=0 to NStock-1  do Read(fin, Stock[i].cost);
        readln(fin);
        for i:=0 to NPART-1  do Read(fin, Parts[i].len);
        for i:=0 to NPART-1  do Read(fin, Parts[i].qtyNeeded);
      end
      else {new version}
      begin
        readln(fin); readln(fin); {skip over two header lines}
        for i:=0 to NPART-1  do
        begin
          readln(fin,Parts[i].Len,Parts[i].qtyNeeded);
        end;
        readln(fin); readln(fin); readln(fin);  {skip header lines}
        for i:=0 to NStock-1  do
        begin
          readln(fin,Stock[i].len,Stock[i].cost);
        end;
      end;
      supplygrid.rowcount:=NStock+1;
      with supplygrid do
      for i:=1 to NStock do
      begin
        cells[0,i]:=floattostr(Stock[i-1].len);
        cells[1,i]:=floattostr(Stock[i-1].cost);
        newstock[i-1]:=stock[i-1].len;
      end;
      partsgrid.rowcount:=NPart+1;
      with partsgrid do
      for i:=1 to NPART do
      begin
        cells[0,i]:=floattostr(Parts[i-1].len);
        cells[1,i]:=inttostr(Parts[i-1].Qtyneeded);
        newparts[i-1]:=parts[i-1].len;
      end;
    end;
    closefile(fin);
  end;
end;
end.

(*
Parts
45.00	97
36.00	610
31.00	395
14.00	211

Stock
100.00	  1.00

Cost
453.00

All patterns:
{45,45,10}
{45,36,14,5}
{45,31,14,10}
{45,14,14,14,13}
{36,36,14,14}
{36,31,31,2}
{36,31,14,14,5}
{36,14,14,14,14,8}
{31,31,31,7}
{31,31,14,14,10}
{31,14,14,14,14,13}
{14,14,14,14,14,14,14,2}

-------------
PARTS
2.00	20
3.00	10
4.00	20

STOCK
9.00	 10.00
6.00	  7.00
5.00	  6.00

Cost
170.00
--------------------

PARTS
10.00	20
30.00	40
40.00	30
60.00	100

STOCK
160.00	2200.00

Cost
118800.00
-----------------------
PARTS
8.00	2
6.00	4
4.00	5
1.00	4

STOCK
12.00	 12.00
10.00	  9.00

Cost
66.00
*)
