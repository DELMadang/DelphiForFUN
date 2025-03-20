unit U_Keno2;
{Copyright  © 2005, 2008  Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, ComCtrls, shellAPI, UBigIntsV3, UBigFloatV3,
  Spin;

type
  TPayoutrec=record
    pay,prob:extended;
  end;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    Play1Btn: TButton;
    ClearBtn: TButton;
    RandomFill: TCheckBox;
    PayTableSheet: TTabSheet;
    StaticText1: TStaticText;
    OpenDialog1: TOpenDialog;
    GroupBox1: TGroupBox;
    Payoutfile: TMemo;
    LoadBtn: TButton;
    SaveBtn: TButton;
    SaveAsBtn: TButton;
    Memo2: TMemo;
    FileLbl: TLabel;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Memo3: TMemo;
    PoolEdit: TSpinEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    DrawEdit: TSpinEdit;
    SpotEdit: TSpinEdit;
    StopBtn: TButton;
    ResultsSheet: TTabSheet;
    Payoutgrid: TStringGrid;
    Memo1: TMemo;
    PayoutTableLbl: TLabel;
    Label8: TLabel;
    KenoSetupBtn: TButton;
    LotomaniaSetupBtn: TButton;
    GamesPerSpots: TSpinEdit;
    Label1: TLabel;
    NbrgamesGrp: TRadioGroup;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure PlayBtnClick(Sender: TObject);
    //procedure Play5BtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    //procedure Play20x5BtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure SaveAsBtnClick(Sender: TObject);
    procedure PDSClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure PayoutfileChange(Sender: TObject);
    procedure PayTableSheetEnter(Sender: TObject);
    procedure PayTableSheetExit(Sender: TObject);
    procedure LotomaniaSetupBtnClick(Sender: TObject);
    procedure KenoSetupBtnClick(Sender: TObject);
  public
    Pool, Draw, Spots: integer;
    filename:string;
    selcount:integer;
    hitcount:integer;
    numcount:integer;
    gamecount:integer;
    hits:array[0..20] of integer; {count the distribution of catches to match theory}
    totpayout:extended;
    showdetail:boolean;  {control results detail displayed}
    board:array[0..99] of boolean;
    selected:array[1..20] of integer;
    payouttable: array[0..20,0..20] of TPayOutrec;  {payout=payouttable[spots,catches].pay}
    allnums:array[1..100] of integer;
    PayouttableChanged:boolean; {flag used by Payout table maintenance to
                                 force rebuild of displayed table}
    drawarray:array[1..100] of boolean;
    procedure reset;
    procedure Play1(const current:integer);
    procedure save(f:string);
    function payout(const catches, nbrspots:integer; var prob:extended):extended;
    function GetCombocount(Const r,n:integer):extended;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  AllFalse:array[0..99] of boolean;

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

{*********** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
var
  i:integer;
begin
  pool:=80;
  draw:=20;
  spots:=10;
  randomize;
  opendialog1.initialdir:=extractfilepath(application.exename);
  pagecontrol1.activepage:=tabsheet1;
  for i:=0 to pool-1 do
  begin
    stringgrid1.cells[i mod 10,i div 10]:=inttostr(i+1);
    AllFalse[i]:=false;
  end;

  payoutgrid.cells[0,0]:='Catches';
  payoutgrid.cells[1,0]:='Probability';
  payoutgrid.cells[2,0]:='Odds';
  payoutgrid.cells[3,0]:='Payout';
  payoutgrid.cells[4,0]:='Expected Val.';
  payoutgrid.cells[5,0]:='Obs. Odds';

  gamecount:=0;
  totpayout:=0;
  for i:=0 to 20 do hits[i]:=0;
  stopbtn.bringtofront;  {Stopbtn in back during design time for convenience}
  //save(extractfilepath(application.exename)+'Default.pay');
  spots:=0; {force new spots to be selected by PDSClick}
  Pdsclick(sender);
end;


{********* Reset ********}
procedure TForm1.reset;
begin
  move(Allfalse[0],board[0],length(board));
  selcount:=0;
end;

{************* StringGrid1DrawCell ************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var i:integer;
begin
  with stringgrid1.canvas do
  begin
    i:= arow*10+acol;
    if not board[i] then
    begin
    brush.color:=stringgrid1.color;
    font.style:=[];
    end
    else
    begin
      brush.color:=cllime;
      font.style:=[fsbold];
    end;
    rectangle(rect);
    inc(i); {make index relative to 1}
    if i<=pool then
    textout(rect.left+5,rect.top+5,inttostr(i))
    else textout(rect.left+5,rect.top+5,'');
  end;
end;

{************ Stringrid1SelectCell **********}
procedure TForm1.StringGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  i:integer;
begin
  canselect:=true;
  i:=arow*10 + acol;
  if i<=pool then
  begin
    board[i]:= not board[i];
    if board[i]
    then if selcount<spots
         then
         begin
           inc(selcount);
           selected[selcount]:=i+1;
         end
         else
         begin
           board[i]:=false;
           beep;
         end
    else dec(selcount);
  end;
end;

{************* Shuffle *********}
procedure shuffle(const count:integer; var a:array of integer);
var
  i,j,temp:integer;

begin
  for j:=count-1 downto 0 do
  begin
    i:=random(j+1);
    temp:=a[i];
    a[i]:=a[j];
    a[j]:=temp;
  end;
end;

{************ PlayBtnClick ********}
(*
procedure TForm1.Play1BtnClick(Sender: TObject);
begin
  showdetail:=true;
  pagecontrol1.activepage:=resultssheet;
  play1;
  reset;
end;
*)

{******** Play1 **********}
procedure Tform1.Play1(const current:integer);
{play a single game}
var
  i,j:integer;
  n:integer;
  pay :extended;
  hitstring:string;
  selectstr:string;
  numstring:string;
  s:string;
begin
  if current mod GamesperSpots.value = 1 then
  begin
    {fill in any missing spots if box was checked}
    if current>1 then reset;
    if (selcount<spots) and RandomFill.checked
    then
    begin
      shuffle(pool, allnums);
      i:=1;
      while selcount<spots do
      begin
        {make sure the number has not already been selected}
        n:=allnums[i];  {try the next number from the shuffled pool set}
        if not board[n] then
        begin
          board[n]:=true;
          inc(selcount);
          selected[selcount]:=n ;
        end;
        inc(i);
      end;
    end;
  end;
  if selcount<spots then showmessage('Select '+inttostr(spots) +' numbers first')
  else
  begin
    shuffle(pool, allnums); {shuffle the pool}
    hitcount:=0;
    //numstring:='';
    //for i:=1 to pool do drawarray[i]:=false;
     move(Allfalse[0],drawarray[1],length(drawarray));
    for i:=1 to draw do  {and take the first "DRAW" numbers as the draw}
    begin
      n:=allnums[i];
      drawarray[n]:=true;
      //if i>1 then numstring:=numstring+', '+inttostr(n)
      //else numstring:=inttostr(n);
    end;
    for i:=1 to spots do {check for matches}
    begin
      if drawarray[selected[i]] then
      begin  {found one}
        inc(hitcount);
      end;
    end;
    {update statistics}
    inc(gamecount);
    pay:=payouttable[spots,hitcount].pay;
    totpayout:=totpayout+pay;
    inc(hits[hitcount]);

    {Show detail for the 1st 20 games}
    if current<=20 then
    with memo1.lines do
    begin
      hitstring:='';
      numstring:='';
      for j:=1 to draw do  {and take the first "DRAW" numbers as the draw}
      begin
        if i>1 then numstring:=numstring+', '+inttostr(allnums[j])
        else numstring:=inttostr(allnums[j]);
      end;
      for j:=1 to spots do {check for matches}
      begin
        if j=1 then
        begin
          selectstr:=inttostr(selected[1]);
          if drawarray[selected[j]] then hitstring:=selectstr;
        end
        else
        begin
          s:=inttostr(selected[j]);
          selectstr:=selectstr+','+s;
          if drawarray[selected[j]]
          then if hitstring='' then hitstring:= s
          else hitstring:=hitstring+','+s;
        end;
      end;
      add('------------');
      add('Game #'+inttostr(gamecount));
      add('You selected: '+selectstr);
      add('Drawn numbers: '+numstring);
      add(inttostr(hitcount) + ' hit(s): '+hitstring);
      add('Payout: '+format('%m',[pay]));
      add('Tot payout:'+format('%m',[totpayout]));
    end;
  end;
end;

{************** TenLBtnClick ***********}
procedure TForm1.PlayBtnClick(Sender: TObject);
{play 100,000 or 1,000,000 random games}
var i,j,lim:integer;
  freq,start,stop:int64;

begin
  case NbrGamesGrp.itemindex of
    0: lim:=1;
    1: lim:=5;
    2: lim:=10;
    3: lim:=100;
    4: lim:=1000;
    5: lim:=100000;
    6: lim:=1000000;
    7: lim:=10000000;
  end;
  showdetail:=false; {omit detailed output}
  screen.cursor:=crhourglass;
  stopbtn.visible:=true;
  pagecontrol1.activepage:=resultssheet;
  memo1.clear;
  tag:=0;
  for i:=1 to 3 do memo1.lines.add('');
  queryperformancefrequency(freq);
  queryperformancecounter(start);
  for i:=1 to lim do
  begin
    play1(i);  {play the next game game}
    if (gamecount and $FFF = 0) or (i=lim) then {Display interim stats every 4096 games}
    with memo1 do
    begin
      lines[0]:=(format('%.0n Games played',[0.0+gamecount]));
      lines[1]:=('Tot payout:'+format('%m',[totpayout]));
      queryperformancecounter(stop);
      lines[2]:=format('%.1n games/second',[gamecount*freq/(stop-start)]);
      application.processmessages;
    end;

    if tag>0 then break;  {stopBtn was clicked}
    //reset;
  end;
  for i:=0 to draw do
  if hits[i]>0
  then payoutgrid.cells[5,i+1]:=format('%9.1f',[gamecount/hits[i]])
  else payoutgrid.cells[5,i+1]:='N/A';
  reset;
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
end;

{********* ClearBtnClick ***********}
procedure TForm1.ClearBtnClick(Sender: TObject);
{reset global stats}
var
  i:integer;
begin
  gamecount:=0;
  totpayout:=0;
  for I:=0 to draw do
  begin
    hits[i]:=0;
    payoutgrid.cells[5,i+1]:='';
  end;
  memo1.clear;
end;


{**************** GetComboCount *************}
function TForm1.GetCombocount(Const r,n:integer):extended; //var ccount:TInteger);
{Return number of combinations -- n things taken r at a time
 without replacement}
{Return number of combinations -- n things taken r at a time
 without replacement}
  var
    work:TInteger;
    ccount:TInteger;
    a:TBigFloat;
  begin
    work:=TInteger.create;
    ccount:=TInteger.create;
    a:=TBigFloat.create;
    if (r>0) and (r<n) then
    begin
      ccount.assign(N);
      ccount.factorial;
      work.assign(r); work.factorial;
      ccount.divide(work);
      work.assign(n-r); work.factorial;
      ccount.divide(work);
    end
    else if r=n then ccount.assign(1)
    else ccount.assign(1);  {(0)?}
    a.assign(ccount);
    a.converttoextended(result);
    work.Free;
    ccount.free;
    a.free;
  end;

{********** Payout ************}
function TForm1.payout(const catches, nbrspots:integer; var prob:extended):extended;
{Return the "break even" payout for matching "catches" numbers, and the probability
of that occurrence.}

{The probability of an event is defined as the number of successful outcomes of an event
 divided by the total number of possible outcomes.  Here we are talking about the
 probability of matching "catches" numbers out of a draw of 20 when "nbrspots"
 number were selected from a poool of 80.

 The number of successful outcomes in this case is the number of ways we can
  match the "catches' out of 20 drawn numbers  times the number of ways we could
  have picked the rest from the  60 that were not drawn. The total outcomes
  is the number of ways to select 20 numbers out of 80. In general the ways to
  choose A items out of B is the number of combinations of A out of B  (also
  frequently denoted as "B choose A").  If all outcomes are considered valid,
  the fair payout per dollar, the result from returned this function,  is the
  inverse of the probability.  For example, if the probability of an event is
  0.5, we can afford to pay out $2 for each success and still break even in the
  long run.}
begin
  prob:= getComboCount(catches,draw)*getcombocount(nbrspots-catches,pool-draw)
                     /getcomboCount(nbrspots,Pool);
  if nbrspots=0 then result:=0 else result:=(1/prob)/(nbrspots+1);
end;

{*************** LoadBtnClick ***********}
procedure TForm1.LoadBtnClick(Sender: TObject);
{Load a payout table}
var
  i,j,n:integer;
  f:Textfile;
  payout:extended;
  line, origline:string;
begin
  if opendialog1.execute then
  begin
    filename:=opendialog1.filename;
    assignfile(f, filename);
    system.reset(f);
    {clear the table - any payouts not specified will be 0}
    for i:=low(payouttable) to high(payouttable) do
    for j:= low(payouttable[i]) to high(payouttable[i]) do payouttable[i,j].pay:=0.0;
    payoutfile.clear;
    while not eof(f) do
    begin
      readln(f,line);
      origline:=line;  {in case we need to display an error}
      {get rid all $ and commas in the input numbers}
      line:=stringreplace(line,'$',' ', [rfreplaceAll]);
      line:=stringreplace(line,',','', [rfreplaceAll]);

      if length(line)>0 then
      if line[1]<>';' then  {; indicates a comment line}
      {Note - comment lines will be lost if the file is saved.  Comments could be
       saved and reinserted later at write time, but not implemented yet}
      begin
        line:=trimleft(line)+' ';
        n:=pos(' ',line);
        i:=strtointdef(copy(line,1,n-1),-1); {Get nbr spots (1st number)}
        if i>=0 then
        begin {it was valid so}
          delete(line,1,n-1); {delete it from the input line}
          line:=trimleft(line);
          n:=pos(' ',line);    {and get the 2nd number}
          j:=strtointdef(copy(line,1,n-1),-1); {Get possible catches for "i" sptos}
          if j>=0 then
          begin
            delete(line,1,n-1);
            line:=trimleft(line);
            n:=pos(' ',line);
            {Both spots and catches were OK, get payout value}
            payout:=strtofloatdef(copy(line,1,n-1),0.0);
            payoutfile.lines.add(format('%d %d %m',[i,j,payout]));
            payouttable[i,j].pay:=payout
          end;
        end;
        if (i<0) or (j<0) then showmessage('Error in record: '+origline);
      end;
    end;
    closefile(f);
    Payouttablechanged:=true;
  end;
end;

{***************  Save *************}
procedure TForm1.save(f:string);
begin
  payoutfile.lines.savetofile(f);
  filename:=f;
  filelbl.caption:=extractfilename(f);
end;

{************* SaveBtnClick ***********}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  save(filename);
end;

{***************** SaveAsBtnClick *************}
procedure TForm1.SaveAsBtnClick(Sender: TObject);
begin
  savedialog1.filename:=filename;
  if savedialog1.execute then  save(savedialog1.filename);
end;


{********** PDSClick ***********}
procedure TForm1.PDSClick(Sender: TObject);
{Procedure to handle change of Pool, Draw, or Spots values}
var i,j:integer;
    prob, pay, totprob, totev:extended;
    rebuildtable:boolean;

    {---------- IsInt -----------}
    function isint(const s:string):boolean;
    {Is it an integer?}
    {Onchange exit for TSpineEdit will take exit even if Text field is blank}
    begin
      result:=s<>'';
    end;

begin
  if isint(pooledit.text) and isint(drawedit.text) and isint(spotedit.text) then
  begin
    rebuildTable:=false;
    if pool<>pooledit.Value then
    begin
      pool:=pooledit.Value;
      rebuildtable:=true;
      if drawedit.value>pool then drawedit.value:=pool;
    end;
    If draw<>drawedit.value then
    begin
      draw:=drawedit.value;
      rebuildtable:=true;
      if spotedit.value>draw then spotedit.value:=draw;
    end;
    If spots<>spotedit.value then
    begin
      spots:=spotedit.value;
      rebuildtable:=true;
    end;
    If rebuildtable then
    begin
      payoutfile.clear;
      for i:= 0 to spots do
      for j:= 0 to i do
      with payouttable[i,j] do
      begin
        pay:=payout(j,i,prob);
        payoutfile.lines.add(format('%d  %d  %m',[i,j,pay]));
      end;
    end;
    payoutgrid.rowcount:=spots+3;
    totprob:=0;
    totev:=0;
     PayoutTableLbl.caption:='Payout Table for '+inttostr(spots)+' Spots';
    with payoutgrid do
    begin
      for j:=0 to spots do
      begin
        pay:=payouttable[spots,j].pay;
        prob:=payouttable[spots,j].prob;
        cells[0,j+1]:=inttostr(j);
        cells[1,j+1]:=format('%9.8f',[prob]);
        cells[2,j+1]:=format('%.0f',[1/prob]);
        cells[3,j+1]:=format('%m',[pay]);
        cells[4,j+1]:=format('%m',[prob*pay]);
        totprob:=totprob+prob;
        totev:=totev+pay*prob;
      end;
      cells[0,spots+2]:='Total';
      cells[1,spots+2]:= format('%6.3f',[totprob]);
      cells[2,spots+2]:='';
      cells[3,spots+2]:='';
      cells[4,spots+2]:=format('%m',[totev]);
    end;
    reset;
    clearbtnclick(self);
    for i:= 1 to pool do allnums[i]:=i; {reset the AllNums table}
  end;
end;

{************ KenoSetupBtnClick *********}
procedure TForm1.KenoSetupBtnClick(Sender: TObject);
begin
  PoolEdit.value:=80;
  DrawEdit.value:=20;
  SpotEdit.value:=10;
end;

{*********** LotomaniaSetupBtnClick **********}
procedure TForm1.LotomaniaSetupBtnClick(Sender: TObject);
begin
  PoolEdit.value:=100;
  DrawEdit.value:=50;
  SpotEdit.value:=20;
end;

{************* StopBtnClick ************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;  {set stop flag}
end;


{******** PayOutFileChange ************}
procedure TForm1.PayoutfileChange(Sender: TObject);
{Payoutfile data was modified, set a flag}
begin
  PayoutTableChanged:=true;
end;

{************ PayTableSheetEnter *********}
procedure TForm1.PayTableSheetEnter(Sender: TObject);
{Initialize the changed flag}
begin
  PayoutTableChanged:=false;
end;

{********* PayTableSheetExit ********}
procedure TForm1.PayTableSheetExit(Sender: TObject);
{If payouttable data was changed then force a rebuild of curent payout table}
begin
  If payouttableChanged then PDSClick(sender);  {force rebuild of table}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
