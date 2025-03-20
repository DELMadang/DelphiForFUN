unit U_ManualCutStock;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, DFFUtils, U_PartsEditDlg, U_SupplyEditDlg,
  URodpartition3, ComCtrls, ExtCtrls;


type
  Tf = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    PatCountLbl: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    CaseLbl: TLabel;
    Label1: TLabel;
    Label5: TLabel;
    PartsGrid: TStringGrid;
    SupplyGrid: TStringGrid;
    Memo1: TMemo;
    LoadcaseBtn: TButton;
    ResetBtn: TButton;
    SaveBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label6: TLabel;
    StaticText1: TStaticText;
    Memo2: TMemo;
    PatternSort: TRadioGroup;
    procedure FormCreate(Sender: TObject);
    procedure PatternBtnClick(Sender: TObject);
    procedure LoadcaseBtnClick(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure SupplyGridDblClick(Sender: TObject);
    procedure PartsGridDblClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure PartsGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SupplyGridKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PatternSortClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

    parts:TParts;
    NPart:integer;
    stock:TPartStock;
    NStock:integer;
    Currentstocknbr:integer;

    SolutionCost:extended;
    filename:string;
    patternshow:boolean;
    pc:TCollapsedPartition; {the current pattern being used when solving}
    modified:boolean;
    //procedure loadfromgrids;
    procedure loadcase(fname:string);
    procedure savecase(fname:string);
    function chkmodified:boolean;
    procedure Makepatterns;
    procedure showpartsgrid;
    procedure showSupplygrid;
    procedure patternchange;
  end;

var
  f: Tf;

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


{*************** Formcreate ***********}
procedure Tf.FormCreate(Sender: TObject);
var
  fname:string;
begin
  opendialog1.initialdir :=extractfilepath(application.exename);

  with partsgrid do
  begin
    cells[0,0]:='Length';
    cells[1,0]:='Nbr req.';
  end;

  with supplygrid do
  begin
    cells[0,0]:='Length';
    cells[1,0]:='Cost';
  end;
  fname:=extractfilepath(application.exename)+'Cutstok2.txt';
  if fileexists(fname)
  then  loadcase(extractfilepath(application.exename)+'Cutstok2.txt');
end;

{************* ShowpartsGrid ***********8}
procedure tf.showpartsgrid;
var
  i,j:integer;
  temp:TPart;
begin
{sort parts descending}
  for i:=0 to high(parts)-1 do
  for j:=i+1 to high(parts) do
  if parts[i].len<parts[j].Len then
  begin
    temp:=parts[i];
    parts[i]:=parts[j];
    parts[j]:=temp;
  end;

  with partsgrid do
  begin
    rowcount:=NPart+1;
    colcount:=2;
    for i:=1 to NPART do
    begin
      cells[0,i]:=floattostr(Parts[i-1].len);
      cells[1,i]:=inttostr(Parts[i-1].Qtyneeded);
    end;
    adjustgridsize(partsgrid);
     if top+height>label4.top then height:=label4.top-top;
  end;
  
end;

{************** ShowSupplygrid ************}
procedure tf.showSupplygrid;
var
  i,j:integer;
  temp:Tstock;
begin

{sort stock descending}
  for i:=0 to high(stock)-1 do
  for j:=i+1 to high(stock) do
  if parts[i].len<stock[j].Len then
  begin
    temp:=stock[i];
    stock[i]:=stock[j];
    stock[j]:=temp;
  end;

  with supplygrid do
  begin
    rowcount:=Nstock+1;
    colcount:=2;
    for i:=1 to Nstock do
    begin
      cells[0,i]:=floattostr(stock[i-1].len);
      cells[1,i]:=floattostr(stock[i-1].cost);
    end;
  end;
  adjustgridsize(supplygrid);
end;


{*************** LoadCase ***********8}
procedure Tf.loadcase(fname:string);
{load a new problem}
var
   i : integer;
   fin : textfile;
   version:string;
begin
  if chkmodified then
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
    begin
      memo1.clear;
      Readln(fin, NStock, NPART, version);
      setlength(Stock,NStock);
      setlength(Parts,NPart);
      if trim(version)='' then
      begin {old version}
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
      showsupplygrid;
      showpartsgrid;
      Caselbl.Caption:='Case: '+extractfilename(filename);
    end;
    closefile(fin);
    Makepatterns;
    modified:=false;
  end;
end;

{*************** PatternChange **********}
procedure TF.patternchange;
{called when user doubleclicks a pattern column in the partsgrid to change
 its count}
var
  oldnbrrods, newnbrrods, diff:integer;
  pc:TCollapsedPartition;
  c,r,n,i:integer;
  maxneeded:integer;
  totcost:extended;
  solved:boolean;
begin
  with partsgrid do
  if (col>2) and (col<colcount) then
  begin {User wants to modify quantity for this pattern}
    pc:=TCollapsedpartition(objects[col,0]);
    oldnbrrods:=strtoint(cells[col,rowcount-2]);
    newnbrrods:=strtoint(InputBox('Pattern '+cells[col,0]+' clicked',
                        'Enter new number of rods to use',
                         inttostr(oldnbrrods)));
    if (newnbrrods<>oldnbrrods)  or  (newnbrrods=0) then
    with pc do
    begin {apply new rod count to this column}
      for r:=0 to high(collapsed) do
      begin
        n:=defpartition.getpartindexfromlen(collapsed[r].partlen);
        if n>=0 then
        begin
          diff:=(oldnbrrods-newnbrrods)*collapsed[r].qty;
          maxneeded:=strtoint(cells[2,n+1])+diff;
          cells[2,n+1]:=inttostr(maxneeded);
          cells[col,n+1]:=inttostr(strtoint(cells[col,n+1])-diff);
        end;
      end;
      {update # of rods}
      cells[col,rowcount-2]:=format('%d',[newnbrrods]);
      i:=defpartition.getstockindexfromlen(len)+1;
      with supplygrid do cells[2,i]:=inttostr(strtoint(cells[2,i])+newnbrrods-oldnbrrods);

      {update cost of these rods}
      cells[col,rowcount-1]:=format('%.2f',[newnbrrods*cost]); {update cost of these rods}
      {update total cost}

      totcost:=strtofloat(cells[1,rowcount-1]);
      cells[1,rowcount-1]:=format('%.2f',[totcost-(oldnbrrods-newnbrrods)*cost]);
      solved:=true;
      for r:=1 to npart do
      if strtoint(cells[2,r])>0 then
      begin
        solved:=false;
        break;
      end;
      if solved then beep;

      if newnbrrods=0 then
      begin {new quantity is 0, delete the pattern}
        for c:= col to colcount-2 do
        begin
          objects[c,0]:=objects[c+1,0];
          for r:=0 to rowcount-1 do cells[c,r]:=cells[c+1,r];
        end;
        colcount:=colcount-1; {delete the last column}
        adjustgridsize(partsgrid);
        with partsgrid do
         if top+height>label4.top then height:=label4.top-top;
      end;
    end;
  end;
end;

{*************** SaveCase ***********8}
procedure Tf.Savecase(fname:string);

var
  i : integer;
  fin : textfile;
  s:string;
begin
  savedialog1.filename:=fname;
  if savedialog1.execute then
  begin
     filename:=savedialog1.filename;
     {$I-}
     assignfile(fin,filename);
     rewrite( fin );          (* open file *)
     if (ioresult <> 0) then
     begin
       ShowMessage('File can not be opened');
      {$I+}
     end
     else
     begin
       writeln(fin, NStock,' ', NPART, ' 2');  {call it version 2}
       writeln(fin,'PARTS');
       writeln(fin,#9+'Length'+#9+'# Required');
       for i:=0 to NPART-1  do
       with parts[i] do
       begin

         s:=format(#9+'%6.2f'+#9+'%d',[Len,qtyneeded]);
         Writeln(fin,s);
       end;
       writeln(fin,'');
       Writeln(fin,'STOCK');
       Writeln(fin,#9+'Length'+#9+'Cost');
       for i:=0 to NStock-1  do
       with stock[i] do
       begin
         s:=format(#9+'%6.2f'+#9+'%6.2f',[Len,cost]);
         Writeln(fin,s );
       end;
       writeln(fin,'');
       Closefile(fin);
     end;
     s:=extractfilename(filename);
     caselbl.Caption:='Case: '+s;
     showmessage('Case '+s+' saved');
   end;
end;

{************** Chkmodified **********8}
function TF.chkmodified:boolean;
{Check if modified flag is set and offer to save the current case if so}
{return true of choice is Ye ot No, return false if choice is candel}
var
  r:integer;
begin
  result:=true;
  if modified then
  begin
    r:=messagedlg('Save current case first?',mtconfirmation,mbyesnocancel,0);
    if r=mryes then
    begin
      savecase(filename);
    end
    else
    result:=r<>mrcancel;
  end;
end;


{************** Makepatterns ***********}
Procedure TF.makepatterns;
var
  i,j:integer;
  s:string;
begin
  memo1.clear;
  defpartition.initialize(stock,parts,nstock,npart);
  patternshow:=false;
  label5.visible:=false;  {the "doubleclick pattern" message}
  with defpartition do
  for i:=0 to Patternlist.Count-1 do
  begin
    with TCollapsedPartition(patternlist.objects[i]) do
    begin
      S:='';
      for j:=0 to high(collapsed) do
      with collapsed[j] do  s:=s+format('(%6.2F,%2D)',[partlen,qty])+',';
      System.delete(s,length(s),1);
      if i<300 then
      memo1.lines.add(format('%s: LEN:%6.2f COST: %6.2F  %s',
         [patternlist[i],len, cost,s]));
    end;
  end;
  patcountLbl.caption:='Pattern count = '+inttostr(memo1.lines.count);

  with partsgrid do
  begin {delete extra rows from previous pattern configuration}
    rowcount:=npart+1;
    colcount:=2;
  end;
  adjustgridsize(partsgrid);
  with partsgrid do
   if top+height>label4.top then height:=label4.top-top;
  with supplygrid do
  begin
    rowcount:=nstock+1;
    colcount:=2;
  end;
  adjustgridsize(supplygrid);
end;

{************** PatternbtnClick ************}
procedure Tf.PatternBtnClick(Sender: TObject);
begin
  memo1.clear;
  patternshow:=false;
  defpartition.initialize(stock,parts,nstock,npart);
end;

{************* LoadcasebtnClick **********8}
procedure Tf.LoadcaseBtnClick(Sender: TObject);
begin
  if chkmodified and opendialog1.Execute then loadcase(opendialog1.filename);
end;

var
  highval:integer=1000000;

{************** Memo1Click ***********8}
procedure Tf.Memo1Click(Sender: TObject);
{Click on a displayed pattern to apply it to the solution}
var
  i,n,k,r:integer;
  s:string;
  patname:string;
  scost:extended;
  maxneeded:integer;
  pc:TCollapsedPartition;
  solved:boolean;
begin
  if not patternshow then
  begin
    with partsgrid do
    begin
      {add the column for the "remaining parts needed" column}
      colcount:=3;
      cells[2, 0]:='Still need';
      for i:=1 to rowcount-1 do cells[2,i]:=cells[1,i];

      rowcount:=rowcount+1; {add an extra row for the rod count by pattern}
      cells[0,rowcount-1]:='Rods:';
      rowcount:=rowcount+1; {add an extra row for the pattern cost for each pattern}
      cells[0,rowcount-1]:='Total Cost:';
      for i:=1 to colcount-1 do
      {clear the rest of the cells on these rows, may have junk leftover from previous}
      begin
        cells[i,rowcount-1]:='';
        cells[i,rowcount-2]:='';
      end;
    end;
    adjustgridsize(partsgrid);
    with partsgrid do
     if top+height>label4.top then height:=label4.top-top;

    with supplygrid do
    begin  {add a column for total cost by stock length}
      colcount:=3;
      cells[2,0]:='Assigned';
      cells[2,1]:='0';
      for i:=1 to rowcount-1 do cells[3,i]:='0';
    end;
    adjustgridsize(supplygrid);
    label5.visible:=true;
    patternshow:=true;
  end;

  {add the pattern}
  s:=memo1.lines[memo1.caretpos.y];
  pc:=TCollapsedPartition(defpartition.patternlist.objects[memo1.caretpos.y]);
  with pc do
  begin
    patname:=copy(s,1,3);
    scost:=cost;
    with partsgrid do
    begin {add a column for the new pattern}
      colcount:=colcount+1;
      for i:=1 to rowcount-1 do cells[colcount-1,i]:=''; {clear the column}
      cells[colcount-1, 0]:=patname;
      objects[colcount-1,0]:=pc; {save to collapsed partition in row 0}
      maxneeded:=highval;  {determine how many rods to add}
      for k:=0 to high(collapsed) do
      with collapsed[k] do
      begin
        i:=defpartition.getpartindexfromlen(partlen)+1;
        if i>=1 then
        begin
          begin
            cells[colcount-1,i]:=inttostr(qty); {# of this length in each rod}
            n:=strtoint(cells[2,i]); {# of parts we need}
            n:= trunc(n / qty +0.99); {# of rods to meet the demand}
            if (n>0) and (n<maxneeded) then maxneeded:=n; {save if smaller}
          end ;
        end;
      end;

      for i:=1 to npart do
      begin
        if cells[colcount-1,i]='' then cells[colcount-1,i]:='0';
        if cells[colcount-1,i]<>'0' then
        begin
          if maxneeded=highval then
          begin
            maxneeded:=0;
            showmessage('All lengths in this pattern have been satisfied');
            break;
          end;
          n:=strtointdef(cells[colcount-1,i],0)*maxneeded;
          cells[colcount-1,i]:=inttostr(n);
          cells[2,i]:=inttostr(strtoint(cells[2,i])-n);
        end;
      end;
      

      {update # of rods}
      cells[colcount-1,rowcount-2]:=format('%d',[maxneeded]);
      i:=defpartition.getstockindexfromlen(len)+1;
      with supplygrid do cells[2,i]:=inttostr(strtointdef(cells[2,i],0)+maxneeded);
      {update cost of these rods}
      cells[colcount-1,rowcount-1]:=format('%.2f',[maxneeded*scost]); {update cost of these rods}
      {update total cost}
      if  cells[1,rowcount-1]='' then cells[1,rowcount-1]:='0';
      cells[1,rowcount-1]:=format('%.2f',[strtofloatdef(cells[1,rowcount-1],0)+maxneeded*scost]);
      {Check for solution}
      solved:=true;
      for r:=1 to npart do
      if strtoint(cells[2,r])>0 then
      begin
        solved:=false;
        break;
      end;
      if solved then beep; {showmessage('Case is solved');  }
    end;

    adjustgridsize(partsgrid);
    with partsgrid do
    if top+height>label4.top then height:=label4.top-top;
  end;
end;

procedure Tf.ResetBtnClick(Sender: TObject);
begin
   Makepatterns;
end;

{************ SupplyGridDblClick *******}
procedure Tf.SupplyGridDblClick(Sender: TObject);
begin
  with supplygrid, SupplyEditdlg do
  begin
    newlen:=strtofloat(cells[0,row]);
    newcost:=strtofloat(cells[1,row]);
    caption:='Check Stock length or cost';
    if showmodal=mrok then
    with stock[row-1] do
    begin
      len:=newlen;
      cost:=newcost;
      showsupplygrid;
      modified:=true;
      application.processmessages;
      makepatterns;
    end;
  end;
end;

{*************** PartsgridDblClick **********8}
procedure Tf.PartsGridDblClick(Sender: TObject);
{Double click to modify a part length or quantity needed}
begin
  with partsgrid, PartEditdlg do
  if (row>0) and (row<=npart) and (col<2) then
  begin {edit the parts row}
    newlen:=strtofloat(cells[0,row]);
    newqty:=strtoint(cells[1,row]);
    caption:='Change selected part';
    if showmodal=mrok then
    with parts[row-1] do
    begin
      len:=newlen;
      qtyneeded:=newqty;
      showpartsgrid;
      modified:=true;
      application.processmessages;
      makepatterns;
    end;
  end
  else if col>=2 then patternchange; {change a pattern count}
end;

{************** SaveBtnClick ************}
procedure Tf.SaveBtnClick(Sender: TObject);
begin
  savecase(filename);
end;

{************** PartsdgridKeyUp ***********8}
procedure Tf.PartsGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Check for insert or delete request}
var
  newpart:Tpart;
  i:integer;
begin
  with partsgrid do
  IF KEY=VK_INSERT then
  with parteditdlg do
  begin
    newlen:=0;
    newqty:=0;
    caption:='New part';
    if showmodal=mrOK then
    with newpart do
    begin
      len:=newlen;
      qtyneeded:=newqty;
      qtyassigned:=0;
      key:=0;
      inc(npart);
      setlength(parts, npart);
      parts[npart-1]:=newpart;
      showpartsgrid;
      makepatterns;
    end;
    key:=0;
  end
  else if key=vk_Delete then
  begin
    if (col<2) and (row>0) and (row<npart) then
    begin
      for i:= row-1 to npart-1 do parts[i]:=parts[i+1];
      dec(npart);
      showpartsgrid;
      makepatterns;
    end;
    key:=0;
  end;
end;

{************ Supplygridkeyup **********}
procedure Tf.SupplyGridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Check for insert or delete request}
var
  newstock:TStock;
  i:integer;
begin
  with supplygrid do
  IF KEY=VK_INSERT then
  with supplyEditdlg do
  begin
    newlen:=0;
    newcost:=0;
    caption:='New Stock Length';
    if showmodal=mrOK then
    with newstock do
    begin
      len:=newlen;
      cost:=newcost;
      key:=0;
      inc(nstock);
      setlength(stock, nstock);
      stock[nstock-1]:=newstock;
      showsupplygrid;
      makepatterns;
    end;
    key:=0;
  end
  else if key=vk_Delete then
  begin
    if (col<2) and (row>0) and (row<nstock) then
    begin
      for i:= row-1 to nstock-1 do stock[i]:=stock[i+1];
      dec(nstock);
      showsupplygrid;
      makepatterns;
    end;
    key:=0;
  end;
end;

procedure Tf.PatternSortClick(Sender: TObject);
begin
  defpartition.sortflag(Patternsort.itemindex);
  makepatterns;
end;

end.


