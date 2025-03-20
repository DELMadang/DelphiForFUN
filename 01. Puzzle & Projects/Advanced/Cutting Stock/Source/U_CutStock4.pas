unit U_CutStock4;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Grids, ShellAPI, ExtCtrls,
  UDelayedColumnGeneration, UDisplayRodpattern, DFFUtils, UGridQuickSort;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    StaticText1: TStaticText;
    IntroSheet: TTabSheet;
    SolutionSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    PartsGrid: TStringGrid;
    Supplygrid: TStringGrid;
    SolveBtn: TButton;
    Memo1: TMemo;
    Loadbtn: TButton;
    SaveBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PageControl2: TPageControl;
    TabSheet1: TTabSheet;
    Memo2: TMemo;
    TabSheet3: TTabSheet;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Image1: TImage;
    PatternIdLbl: TLabel;
    NbtToCutLblLabel5: TLabel;
    ColorDialog1: TColorDialog;
    ShowFractional: TCheckBox;
    ShowDetail: TCheckBox;
    ShowInteger: TCheckBox;
    StaticText2: TStaticText;
    TabSheet4: TTabSheet;
    Memo4: TMemo;
    Label3: TLabel;
    Memo3: TMemo;
    Label4: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure Memo3Click(Sender: TObject);
    procedure PartsGridClick(Sender: TObject);
    procedure ShowDetailClick(Sender: TObject);
    procedure LoadbtnClick(Sender: TObject);
    procedure GridKeyUp(Sender: TObject; var Key:Word; Shift:TShiftState);
    procedure SaveBtnClick(Sender: TObject);
    procedure PartsGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StaticText2Click(Sender: TObject);

  public
    { Public declarations }
    OriginalData :TCaserec;
    MinCost:extended;
    maxdec:integer;  {maximum number of decimals for any value}
    BestCaseData:TCaseRec;
    partscolors:array of TColor;  {unique colors for rods, assign by formcreate exit}
    filename : string;
    pow:integer;
    //loopcount:Integer;
    procedure setInitialcolors;
    procedure  SetupInput;
    procedure resetdisplay;
    Procedure copydata(const FromRec:TCaserec; var ToRec:TCaseRec);
    function  FindIntegerSolution(CaseData:TCaserec; level:integer):boolean;
    procedure DisplayGraphicIntegerSolution;
    procedure DisplayTextIntegerSolution;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses mathslib;

{*********** FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  pagecontrol1.activePage := introsheet; {In case I compile with some other sheet active}
  {Make sure that text solution is active sheet for pagecontrol on Solutionsheet}
  pagecontrol2.activePage:=tabsheet1;
  {Set up inital sample problem }
  with PartsGrid do
  begin
    colwidths[1]:=68;
    colwidths[2]:=64;
    cells[0,0]:='Size';
    cells[1,0]:='Nbr required';
    cells[2,0]:='Color';
    cells[0,1]:= '45';
    cells[1,1]:= '97';
    cells[0,2]:= '36';
    cells[1,2]:= '610';
    cells[0,3]:= '31';
    cells[1,3]:= '395';
    cells[0,4]:= '14';
    cells[1,4]:= '211';
  end;

  randseed:=56894957;  {my choice of initial colors}
  //randomize;
  setInitialColors;

  with SupplyGrid do
  begin
    cells[0,0]:='Size';
    cells[1,0]:='Cost Each';
    cells[0,1]:= '100';
    cells[1,1]:= '1.00';
  end;

  opendialog1.initialdir:=extractfilepath(application.exename);
end;


{************ SetInitialColors ***********}
procedure TForm1.setInitialcolors;
var
  i,r,g,b:integer;
  ru,gu,bu:array[0..21] of integer;


      function notsame(r,g,b,n:integer):boolean;
      {Same if all of r,g,b are with 50 of already used r,g,b value}
      var
        i:integer;
      begin
        result:=true;
        for i:=1 to n do
        begin
          if  (abs(r-ru[i])<80)
              and (abs(g-gu[i])<80)
              and (abs(b-bu[i])<80)
          then
          begin
            result:=false;
            break;
          end;
        end;
      end;

begin
  setlength(partscolors,21);
  partscolors[0]:=clwhite;
  for i:=1 to high(partscolors) do
  begin
  {try to generate 20 different distinct shades of color}
  (*
    repeat
      r:=random(256);
    until notsame(r,ru,i);
    ru[i]:=r;
    repeat
      g:=random(256);
    until notsame(g,gu,i);
    gu[i]:=g;
    repeat
      b:=random(256);
    until notsame(b,bu,i);
    bu[i]:=b;
    *)

   repeat
      r:=random(256);
      g:=random(256);
      b:=random(256);
    until notsame(r,g,b,i);
    ru[i]:=r;
    gu[i]:=g;
    bu[i]:=b;


    (*
    r:=random(256);
    if (r<50) then g:=50+random(150)
    else if (r<200) then g:=random(256) else g:=random(200);
    if(r<50) or (g<50) then b:=50+random(150)
    else if (r<200) and (g<200) THEN b:=random(256) else b:=random(200);
    *)
    partscolors[i]:=rgb(r,g,b);
  end;
end;

{***************** CopyData *************}
 Procedure TForm1.copydata(const fromRec:TCaseRec; var ToRec:TCaseRec);
 {copy a case record from "FromRec" to "ToRec"}
 var
   i,j:integer;
 begin
   with ToRec do
   begin
     NPart:=FromRec.npart;
     NSOURCE:=FromRec.NSOURCE;
     verbose:=FromRec.Verbose;
     fractional:=FromRec.fractional;
     setlength(StockLengths,NSOURCE+1);
     setlength(StockCost,NSOURCE+1);
     setlength(StockUsed,NSOURCE+1);
     setlength(StockOrigloc,NSource+1);
     setlength(Partlengths,NPart+1);
     setlength(PartQty,NPart+1);
     setlength(StockUsedByPattern,NPart+1);
     setlength(IStockUsedByPattern,NPart+1);
     setlength(a,Npart+1, NPart+1);
     setlength(totparts,NPART+1);
     setlength(C1,NPart+1);
     for i:= 1 to NSOURCE do
     begin
       StockLengths:=FromRec.StockLengths;
       StockCost[i]:=FromRec.StockCost[i];
       stockused[i]:=FromRec.Stockused[i];
       stockorigloc[i]:=fromrec.stockorigLoc[i];
     end;
     for i:= 1 to nPart do
     begin
       partlengths[i]:=FromRec.PartLengths[i];
       PartQty[i]:=FromRec.PartQty[i];
       StockUsedByPattern[i]:=FromRec.StockusedByPattern[i];
       IStockUsedByPattern[i]:=FromRec.IStockusedByPattern[i];
       totparts[i]:=FromRec.totparts[i];
       C1[i]:=FromRec.C1[i];
     end;
     for i:=1 to npart do
     for j:=1 to NPart do a[i,j]:=FromRec.a[i,j];
    end;
 end;

 {*************** FindIntegerSolution *************}
 function TForm1.FindIntegerSolution(Casedata:TCaserec; level:integer):boolean;
 {Recursive depth-first search starts with a too large solution (stock counts from
  fractional solutions rounded up) and decrements backwards decrementing pattern
  repeats one-by-one, saving new lower cost solutions and stopping each branch
  when the order requirements are not met}
       {---------- TotCost ---------------}
       function totCost:extended;
       var i:integer;
       begin
         result:=0;
         with Casedata do
           for i:=1 to NPART do result:=result+ C1[i]*IStockUsedByPattern[i] ;
       end;

   var
     i,j:integer;
     NextCase:TCaserec;

   begin

     with CaseData do
     begin
       result:=true;
       if tag<>0 then exit;
       //if level>npart then exit;
       //inc(loopcount);
       //if loopcount>10000 then exit;
       {check if nbr of parts cut is >= nbr of parts ordered for each size}

       {first total each part size across pattern}
       for i:=1 to npart do totparts[i]:=0;
       for i:=1 to NPart do
       begin
         {total the parts cut}
         for j:=1 to high(a[i]) do {for each piece cut in this pattern}
              totparts[j]:=totparts[j]+A[i,j]*IStockUsedByPattern[i];
       end;

       {Check if order requirements are  met, we're done}
       for i:=1 to NPart do
       if totparts[i]<PartQty[i] then
       begin
         result:=false;
         exit;
       end;

       {Otherwise, see if cost was lowered, if so save it}
       If totcost<mincost then
       begin
         {save a new best solution}
         copydata(casedata,bestcasedata);
       end;

       {current set is OK, make a new set using this solution}
       copydata(casedata,nextcase);
       with nextcase do
       for i:= 1 to NPart do
       If iStockUsedByPattern[i]>totparts[i] {0} then
       begin
         dec(IStockusedByPattern[i]);  {Try taking one stock piece away from each pattern}
         if not FindIntegerSolution(Nextcase,level+1) then {and check to see if it is a solution}
         begin {Put that piece back before trying the next reduction}
           inc(IStockusedByPattern[i]);
         end;
       end;
     end;
   end;


{************** SolveBtnClick ************}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
   i,j : integer ;
   zb,used:extended;
begin {solvebtnclick}
  if solvebtn.caption='Stop' then
  begin
    solvebtn.caption:='Solve';
    tag:=1;
    exit;
  end;
  solvebtn.caption:='Stop';
  tag:=0;
  resetdisplay;
  setupinput; {move data from input grids to data area}
  screen.Cursor:=crHourGlass;
  application.processmessages;
  with OriginalData do
  begin
    setlength(StockUsed,NSOURCE+1);
    setlength(StockUsedByPattern,NPart+1);
    setlength(IStockUsedByPattern,NPart+1);
    setlength(a,Npart+1, NPart+1);
    setlength(totparts,NPART+1);
    for i:= 1 to NSOURCE do
    begin
      Stockused[i]:=0;
    end;
    for i:= 1 to NPart do
    begin
      for j:=1 to npart do a[i,j]:=0;
    end;
    verbose:=showdetail.checked;
    fractional:=Showfractional.checked;

    {get fractional solution}
    SolveCase(OriginalData,memo2);

    {set lengths back to original values if fractions existed}
    if (pow>0) and (pow<>1)  then
    begin
      with Originaldata do
      begin
        for i:= 1 to NSOURCE do stocklengths[i]:=stocklengths[i]/pow;
        for i:= 1 to NPart do partlengths[i]:=partlengths[i]/pow;
      end;
      with BestCaseData do
      begin
        for i:= 1 to NSOURCE do stocklengths[i]:=stocklengths[i]/pow;
        for i:= 1 to NPart do partlengths[i]:=partlengths[i]/pow;
      end;
      for i:= 1 to npart do  slength[i]:=slength[i]/pow;
    end;

    if verbose or fractional then   {Show fractional solution};
    with memo2.lines, originaldata do
    begin
      add( ' --- Optimal Fractional Solution ---');
      for i:=1 to NPART do
      begin
        used:=0;
        if (StockUsedByPattern[i] > Tolerance) then
        begin
          for j:=1 to NPart do used:=used+Partlengths[j]*trunc(A[i,j]);
          if used>0 {stockusedbypattern[i]>0}  then
          begin
            add(format('Pattern(%d)  Stock length:%10.2f  Needed: %7.2f',
                        [i,SLENGTH[i],StockUsedByPattern[i]]));
            for j:=1 to NPART do
            begin
              if (A[i,j] > 0) then
              begin
                add(format(#9+'Order length:%7.2f  Number cut from each stock piece: %5d',
                                    [Partlengths[j], A[i,j]]));
              end;
            end;
            add(format(#9+'Unused from each stock piece %f',[slength[i]-used]));
          end;
        end;
      end;
      ZB := 0.0;
      for i:=1 to NPART do ZB :=ZB + C1[i] * StockUsedByPattern[i] ;
      if verbose or fractional then
      begin
        memo2.lines.add(format('Stock cost = %10.2f',[ ZB]));
        if Verbose then memo2.lines.add(format( ' Number of Iterations =  %d',[IT]));
      end;
    end;
    application.processmessages;


    {Now setup solution with partial stock pieces rounded up.  This is an upper
     bound for the minimal integer solution}
    {Setup next search}
    for i:=1 to npart do
    begin
      IStockusedByPattern[i]:=trunc(stockusedbypattern[i]+0.999);
      for j:=1 to npart do if a[i,j]<0 then a[i,j]:=0;
    end;
    copydata(Originaldata,BestcaseData);
    mincost:=1e6;
    {Perform  search from that solution looking for possible integer reductions}
    //loopcount:=0;
    FindIntegerSolution(Originaldata,1);
  end;
  displaytextintegersolution;
  displayGraphicIntegerSolution;
  screen.Cursor:=crDefault;
  solvebtn.caption:='Solve';
end;

{*************** Display GraphiIntegerSolution ********}
procedure TForm1.DisplayGraphicIntegerSolution;
var
  i,j,k,m:integer;
  sum:extended;
  Part:TDisplayPattern;
  rodpart:TRodLengths;
  rodcolor:array of TColor;
  nexttop:integer;
  patternNbrmsg, NbrCutMsg:string;
  used:extended;
begin
  with bestcasedata do
  begin
    with partsgrid do
    begin
      colcount:=4;
      colwidths[2]:=64;
      cells[3,0]:='Nbr Cut';
      for j:=1 to nPart do cells[3,j]:=inttostr(totparts[j]);
    end;
      {Update counts in Stock grid}
      for i:=1 to NSource do StockUsed[i]:=0;

      for i:=1 to NPART do
      begin
        used:=0;
        for j:=1 to NPart do used:=used+Partlengths[j]*trunc(A[i,j]);
        if used>0 then
        for j:=1 to NSOURCE do
        begin
          if StockLengths[j]=Slength[i] then
          begin
            inc(StockUsed[j],IStockUsedByPattern[i]);
            break;
          end;
        end;
      end;
      with supplygrid do
      begin
        colcount:=4;
        cells[2,0]:='Nbr Used';
        cells[3,0]:='Cost';
        for i:= 1 to NSOURCE do
        begin
          cells[2,Stockorigloc[i]]:=inttostr(trunc(Stockused[i]));
          cells[3,Stockorigloc[i]]:=format('%6.2f',[0.0+Stockused[i]*StockCost[i]]);
        end;
      end;


      nexttop:=panel1.top;
      for i:= 1 to NPart do
      begin
        if (IStockUsedByPattern[i] > 0) then
        begin
          part:=TDisplayPattern.create(Panel1);
          part.top:=nexttop;
          patternNbrMsg:=format('Pattern #%d, Stocklength: %.1f ',[i,Slength[i]]);
          NbrCutmsg:='Number to Cut '+inttostr(IStockusedByPattern[i]);
          k:=0;
          sum:=0;
          setlength(rodpart,100);
          setlength(rodcolor,100);
          for j:=1 to NPART do
          begin
            if (A[i,j] > 0) then
            begin
              for m:=1 to a[i,j] do
              begin
                rodpart[k]:=partlengths[j];
                rodcolor[k]:=partscolors[j];
                inc(k);
                sum:=sum+partlengths[j];
              end;
            end;
          end;
          if sum>0 then
          begin
            if sum<slength[i] then
            begin
              rodpart[k]:=slength[i]-sum;  {the waste amount}
              rodcolor[k]:=clgray;
              inc(k);
            end;
            setlength(rodpart,k);{now we can shorten rodpart to the actual #}
            setlength(rodcolor,k);
            setlength(part.rod.rodpartcolor, k);
            for j:=0 to high(rodcolor) do part.rod.rodpartcolor[j]:=rodcolor[j];
            part.makepattern(rodpart,PatternNbrmsg, NbrcutMsg);
            nexttop:=nexttop+panel1.height+5;
          end;
        end;
     end;
   end;
end;




{************  DisplayTextIntegerSolution *************}
procedure TForm1.DisplayTextIntegerSolution;
var
  i,j:integer;
  used:extended;
  cost:extended;
begin
  with bestcasedata, memo2.lines do
  begin
    for i:=1 to NSOURCE do StockUsed[i]:=0;
    add('');
    add( ' --- Optimal Integer Solutuion ---');
    for i:=1 to NPART do
    begin
      used:=0;
      if showinteger.checked then
      begin
        for j:=1 to NPart do used:=used+Partlengths[j]*trunc(A[i,j]);
        if used>0 then
        begin
          add(format('Pattern(%d)  Stock length:%10.2f  Needed: %d',
                      [i,SLENGTH[i],IStockUsedByPattern[i]]));
          for j:=1 to NPART do
          begin
            if (A[i,j] > 0) then
            begin
              add(format(#9+'Order length:%7.2f  Number cut from each stock piece: %5d',
                                  [Partlengths[j], A[i,j]]));
            end;
          end;
          add(format(#9+'Unused from each stock piece %f',[slength[i]-used]));
        end;
      end;
    end;
    Cost := 0.0;
    for i:=1 to Nsource do stockused[i]:=0;
    for i:=1 to NPART do  Cost :=Cost + C1[i] * IStockUsedByPattern[i] ;

    memo2.lines.add(format('Stock cost = %10.2f',[ Cost]));
    DisplayGraphicIntegerSolution;
  end;
end;


{*********** Memo3Click **********}
procedure TForm1.Memo3Click(Sender: TObject);
{Links to reference websites}
var
  link:string;
  line:integer;
begin
  with memo3 do
  begin
    Line := Memo3.Perform(EM_LINEFROMCHAR,  -1, 0);
    case line of
      0:link:='http://www-fp.mcs.anl.gov/otc/Guide/CaseStudies/cutting/';
      1:link:='http://www.orlab.org/software/or_prog/or1/index.html';
      else link:='';
    end;
    if link<>''
    then  ShellExecute(Handle, 'open', PCHAR(link), nil, nil, SW_SHOWNORMAL) ;
  end;
end;

{********** PartsgridClick **********}
procedure TForm1.PartsGridClick(Sender: TObject);
{Allow user to change required parts list}
begin
  with partsgrid do
  begin
    if colcount>3 then colcount:=3;
    {if the last row is occupied then add an extra row for the next new entry}
    if (cells[0,rowcount-1]<>'') or (cells[1,rowcount-1]<>'')
    then
    begin
      rowcount:=rowcount+1;
      if rowcount>length(partscolors) then
      begin
        setlength(partscolors,rowcount);
        partscolors[rowcount-1]:=(64+random(164)) shl 16+(64+random(164))shl 8+64+random(164);
      end;
    end;
    if (row>0) and (col=2) then  {add the color indicator cell}
    begin
      colordialog1.color:=partscolors[row];
      if colordialog1.execute
      then partscolors[row]:=colordialog1.color;
    end;
  end;
end;

{************ ShowDetailClick *********8}
procedure TForm1.ShowDetailClick(Sender: TObject);
{Called when showInteger, showfractional or showintermediate checkboxes are clicked.
 Sets verbose option for DelyedColumnGeneration code and resolves problem}
begin
  If showdetail.checked then OriginalData.Verbose:=false else OriginalData.Verbose:=false;
  solvebtnclick(sender);
end;

{********** ResetDisplay **********}
procedure Tform1.resetDisplay;
{reset fields for a new problem or new solution}
var i:integer;
begin
  memo2.clear;
  with partsgrid do If colcount>=3 then colcount:=3;
  with SupplyGrid do If colcount>=2 then colcount:=2;

  with scrollbox1 do
  for i:= controlcount-1 downto 0 do
  begin
    if controls[i] is TDisplaypattern then TDisplayPattern(controls[i]).free;
  end;

end;

{************** LoadbtnClick ************}
procedure TForm1.LoadbtnClick(Sender: TObject);
var
   i : integer;

   fin : textfile;
   version:string;
begin
  resetdisplay;
  if opendialog1.execute then
  with originalData do
  begin
    filename:=opendialog1.filename;
    {$I-}
    assignfile(fin,filename);
    reset( fin );          (* open file *)
    if (ioresult <> 0) then
    begin
      showmessage('File can not be opened');
    {$I+}
    end
    else
    with originaldata do
    begin
      statictext1.caption:=filename;
      savedialog1.filename:=fileName;
      Readln(fin, NSOURCE, NPART, version);
      setlength(StockLengths,NSOURCE+1);
      setlength(StockOrigLoc,NSOURCE+1);
      setlength(StockCost,NSOURCE+1);
      setlength(Partlengths,NPart+1);
      setlength(PartQty,NPart+1);
      if trim(version)='' then
      begin

        for i:=1 to NSOURCE  do Read(fin, StockLengths[i]);
        for i:=1 to NSOURCE  do Read(fin, StockCost[i]);
        readln(fin);
        for i:=1 to NPART  do Read(fin, PartLengths[i]);
        for i:=1 to NPART  do Read(fin, PartQty[i]);
      end
      else {new version}
      begin
        readln(fin); readln(fin); {skip over two header lines}
        for i:=1 to NPART  do
        begin
          readln(fin,PartLengths[i],Partqty[i]);
        end;
        readln(fin); readln(fin); readln(fin);  {skip header lines}
        for i:=1 to NSOURCE  do
        begin
          readln(fin,StockLengths[i],Stockcost[i]);
        end;
      end;
      supplygrid.rowcount:=NSOURCE+1;
      with supplygrid do
      for i:=1 to NSOURCE do
      begin
        cells[0,i]:=floattostr(StockLengths[i]);
        cells[1,i]:=floattostr(StockCost[i]);
        StockOrigloc[i]:=i;
      end;
      partsgrid.rowcount:=NPart+1;
      with partsgrid do
      for i:=1 to NPART do
      begin
        cells[0,i]:=floattostr(PartLengths[i]);
        cells[1,i]:=inttostr(PartQty[i]);
      end;
    end;

    closefile(fin);
  end;
end;

{************* PartsGridKeyUp *************}
procedure TForm1.GridKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i:integer;
begin
  with TStringGrid(sender) do
  begin
    if key=vk_insert then rowcount:=rowcount+1
    else if key=vk_Delete then
    begin
      for i:=row to rowcount-2 do
      begin
        cells[0,i]:=cells[0,i+1];
        cells[1,i]:=cells[1,i+1];
      end;
      rowcount:=rowcount-1;
    end;
  end;
  if partsgrid.colcount>3 then partsgrid.colcount:=3;
  if supplygrid.colcount>2 then supplygrid.colcount:=2;
end;

{********** SetupInput *********}
procedure  TForm1.SetupInput;

       function countrows(g:TStringgrid):TPoint;
        {count the # of grid rows with data and return the maximum decimal count}
        var
          i,n,ndec:integer;
          s:string;
        begin
          with g do
          begin
            i:=1;
            result.x:=0; result.y:=0;
            while (i<=rowcount-1) do
            begin
              s:=trim(cells[0,i]);
              If (s<>'') and (trim(cells[1,i])<>'') then
              begin
                inc(result.x);
                n:=pos(decimalseparator,s);
                if (n>0) then NDec:=length(s)-n;
                if ndec>result.y then result.y:=ndec
                else ndec:=0;
              end;
              inc(i);
            end;
          end;
        end;


var i,j:integer;
    temp:extended;
    p:TPoint;
    s:string;
    itemp:integer;
begin

   Sortgrid(partsgrid, 0 {column 0}, 2 {floating point} , false {descending});
   with OriginalData do
   begin
     maxdec:=0;
     p:=countrows(partsGrid);
     NPart:=p.x;
     if p.y>maxdec then maxdec:=p.y;
     p:=countrows(SupplyGrid);
     NSOURCE:=p.x;
     if p.y>maxdec then maxdec:=p.y;
     if maxdec>2 then
     begin
       showmessage('Length values truncated to 2 digit decimal accuracy');
       maxdec:=2;
     end;
     if maxdec>0 then  pow:=intpower(10,maxdec) else pow:=1;

     setlength(StockLengths,NSOURCE+1);
     setlength(StockCost,NSOURCE+1);
     setlength(stockorigloc,NSOURCE+1);
     setlength(PartLengths,NPart+1);
     setlength(PartQty,NPart+1);
     with Supplygrid do
     for i:= 1 to NSOURCE do
     begin
       s:=cells[0,i];
       cells[0,i]:=s;
       StockLengths[i]:=pow*strtofloat(cells[0,i]);
       StockCost[i]:=strtofloatdef(cells[1,i],1);
       StockOrigLoc[i]:=i;
     end;

     {sort stock by descending length}
     for i:=1 to nsource-1 do
     for j:=i+1 to nsource do
     begin
       if stocklengths[j]>stocklengths[i] then
       begin {swap length and cost}
         temp:=stocklengths[j];
         stocklengths[j]:=stocklengths[i];
         stocklengths[i]:=temp;
         temp:=stockcost[j];
         stockcost[j]:=stockcost[i];
         stockcost[i]:=temp;
         itemp:=StockorigLoc[j];
         StockOrigLoc[j]:=StockOrigLoc[i];
         StockOrigLoc[i]:=iTEMP;
       end;
     end;

     with Partsgrid do
     for i:= 1 to NPart do
     begin
       s:=cells[0,i];
       cells[0,i]:=s;
       Partlengths[i]:=pow*strtofloat(cells[0,i]);
       PartQty[i]:=strtointdef(cells[1,i],1);
     end;
   end;
end;

{*********** SaveBtnClick *********}
procedure TForm1.SaveBtnClick(Sender: TObject);
var
   i : integer;
   fin : textfile;
   s:string;
begin
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
     with originaldata do
     begin
       setupinput;

       writeln(fin, NSOURCE,' ', NPART, ' 2');  {call it version 2}
       writeln(fin,'PARTS');
       writeln(fin,#9+'Length'+#9+'# Required');
       for i:=1 to NPART  do
       begin
         s:=format(#9+'%6.2f'+#9+'%d',[PartLengths[i],Partqty[i]]);
         Writeln(fin,s);
       end;
       writeln(fin,'');
       Writeln(fin,'STOCK');
       Writeln(fin,#9+'Length'+#9+'Cost');
       for i:=1 to NSOURCE  do
       begin
         s:=format(#9+'%6.2f'+#9+'%6.2f',[StockLengths[i],Stockcost[i]]);
         Writeln(fin,s );
       end;
       writeln(fin,'');
       If memo1.lines.count-1>0 then
       with memo2 do
       begin
         for i:=0 to lines.count-1 do writeln(fin,lines[i]);
       end;
       Closefile(fin);
     end;
     showmessage('Problem saved');
   end;
end;

{****************** PartsGridDrawCell *************}
procedure TForm1.PartsGridDrawCell(Sender: TObject; ACol, ARow: Integer;
                                   Rect: TRect; State: TGridDrawState);
{Handle text on Partsgrid so we can display colors}
begin
  with Sender as TStringGrid, canvas do
  begin
    Brush.Color := clwhite;
    FillRect(Rect);
    if (acol<>2) or (arow=0) {drawtext in these cells}
    then  textout(rect.left+5,rect.top+5, cells[acol,arow])
    else if cells[0,arow]<>'' then {draw the rod color in column 3 (index=2)}
    begin
      //FillRect(Rect);
      if arow>high(partscolors) then
      begin
        setlength(partscolors,length(partscolors)+1);
        partscolors[arow]:=(64+random(164)) shl 16+(64+random(164))shl 8+64+random(164);
      end;
      Brush.Color := partscolors[arow];
      FillRect(Rect);
      {
      //display hex color values in cell
      s:=colortostring(partscolors[arow]);
      if s[1]='c' then delete(s,1,2) else delete(s,2,2);
      font.color:=clwhite; textout(rect.left+5,rect.top+5,s);font.color:=clblack;
      }
    end;
  end;
end;


(*
procedure TForm1.Button1Click(Sender: TObject);
{temporary procedure used to find a good set of random colors}
begin
  randomize;
  label4.caption:=inttostr(randseed);
  setinitialcolors;
  partsgrid.invalidate;
end;
*)


procedure TForm1.StaticText2Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
