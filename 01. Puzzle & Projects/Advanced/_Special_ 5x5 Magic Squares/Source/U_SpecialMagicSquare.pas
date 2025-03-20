unit U_SpecialMagicSquare;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids;

type
  string5=string[5];
  TGrid=array[0..4,0..4] of char;
  TRowSum=array[0..4] of integer;

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Phase1Btn: TButton;
    Phase1Memo: TMemo;
    Phase2Btn: TButton;
    StatusMemo: TMemo;
    Phase2Memo: TMemo;
    StopBtn: TButton;
    PauseBox: TCheckBox;
    StringGrid1: TStringGrid;
    Label1: TLabel;
    Timer1: TTimer;
    Memo1: TMemo;
    ClickLbl: TLabel;
    SearchModeGrp: TRadioGroup;
    TimeLbl1: TLabel;
    Label2: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure Phase1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Phase2BtnClick(Sender: TObject);
    procedure Phase2MemoClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  public
    list:TStringlist;
    stop, paused:boolean;
    solvecount:integer;
    starttime,pausetime,totpausetime:TDatetime;
    procedure updatestatus;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses ucombov2,DFFutils;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

var
  {The number which must appear in each solutions}
  numbers:array[1..25] of integer=(1,1,2,2,2,2,2,3,3,3,3,3,3,4,5,5,5,5,6,6,6,6,6,7,9);
  ord0:integer=ord('0'); {we can quickly convert single digit character n to integer using "ord(n)-ord0"}

{*************** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
{Initialization stuff}
begin
  reformatmemo(memo1);
  list:=TStringlist.create;
  list.Sorted:=true;
  stringgrid1.Col:=4;
  pagecontrol1.activepage:=Tabsheet1;
end;

{**************** Phase1BtnClick ***********}
procedure TForm1.Phase1BtnClick(Sender: TObject);
var
  i,j, sum, count :integer;
  index:integer;
  s,s2,ps:string5;
  combos2:TComboset;
  newlist:TStringlist;
begin
  combos2:=TComboset.create;
  phase1memo.clear;
  Statusmemo.Clear;
  count:=0;
  list.Clear;
  combos.setup(5,25,combinations);
  with combos do
  begin
    while getnext do
    begin
      sum:=numbers[selected[1]];
      for i:=2 to 5 do
      begin
        inc(sum,numbers[selected[i]]);
        if sum>20 then break;
      end;
      if sum=20 then
      begin
        inc(count);
        s:=inttostr(numbers[selected[1]]); {the numbers}
        s2:=inttostr(selected[1]); {s2=indices of the numbers}
        for i:=2 to 5 do
        begin
          s:=s+inttostr(numbers[selected[i]]);
          s2:=s2+inttostr(selected[i]);
        end;
        if not list.find(s,j) then
        begin {this is a unique set of 5 digits}
          {Now we'll attach all the permutaions to s as a stringlist}
          combos2.setup(5,5,permutations);
          newlist:=TStringlist.create;
          newlist.sorted:=true;
          setlength(ps,5);
          while combos2.getnext do
          begin
            for i:= 1 to 5 do  ps[i]:=s[combos2.selected[i]];
            if not newlist.find(ps, index) then newlist.add(ps);
          end;
          list.addobject(s, newlist);
          Phase1memo.Lines.add(format('%s',[s]));
        end;
      end;
    end;
    scrolltotop(Phase1memo);
    StatusMemo.Lines.add(format('Phase 1 - There are %d 5-digit combinations summing to 20, of these %d are unique',[count, list.count]));
    Statusmemo.Lines.add('Each string represents the digits of a solution row or column, but not necessarily in the correct order');
  end;
end;

{*********** Phase2BtnClick ***********}
procedure TForm1.Phase2BtnClick(Sender: TObject);


  {------------- MakeCountKey ----------}
  procedure makecountkey(key:string; var countkey:string);
  var i,n:integer;
  begin
    setlength(countkey,9);
    countkey:='000000000';
    for i:=1 to length(key) do
    begin
      n:=ord(key[i])-ord0;
      countkey[n]:= char(ord(countkey[n])+1);
    end;
  end;
  {----------- MakeMasterCountKey -----------}
  procedure MakemasterCountkey(var countkey:string);
  var s:string;
      i:integer;
  begin
    s:='';
    for i:=1 to 25 do s:=s+inttostr(numbers[i]);
    MakeCountkey(s,countkey);
  end;


var
  i:integer;
  s9:string;
  s,line:string;
  masterCountkey:string;

begin     {Phase2btnclick}
  {select groups of 5 which contain all of the given numbers}
  if list.count=0 then Phase1Btnclick(sender);
  makemastercountkey(mastercountkey);
  {pick groups of 5 keys from this list (each key represents the digits of
   a solution row or column), (but not necessarily in the correct order),
   with the characteristic that each group of  5 keys contains all of the
   given digits to be used}
  with combos do
  begin
    Phase2memo.Clear;
    setup(5,list.count, combinations);
    while getnext do
    begin
      s:='';
      for i:=1 to 5 do s:=s+list[selected[i]-1];
      makecountkey(s,s9);
      if s9=mastercountkey then
      begin
        line:='';
        for i:=1 to length(s) do
        begin
          line:=line+s[i];
          if i mod 5 = 0 then line:=line+' ';
        end;
        with Phase2memo do Lines.Add(format('#%3d %s',[lines.Count+1, trim(line)]));
      end;
    end;
    clicklbl.visible:=true;
    Phase2memo.lines.insert(0,'Click a group line to test if it contains solutions');
    Statusmemo.Lines.add('');
    Statusmemo.Lines.Add('Phase 2 - Groups of 5 digit strings from Phase 1 which contain all of the given numbers');
    scrolltotop(Phase2memo);
  end;
end;




{************ Phase2MemoClick **************}
procedure TForm1.Phase2MemoClick(Sender: TObject);
{This is Phase 3, findin solutions from 1 or more Phase 2 candidates}

var
  candidates:array[0..4] of string5;
  
  {----------- PermuteNextCol ------------}
  function permutenextcol(var grid:TGrid; const col:integer; var rowsum:Trowsum):boolean;
  {Recursive search function}
  var
    i,j,row,n, index:integer;
    plist:TStringlist;
    sum,sum2:integer;  {work field for conputing row and diagonal sums}
    nextrowsum:TRowsum;
    OK:boolean;
    s:string;

  begin
    result:=false;
    if stop then exit;
    if col=2 then application.processmessages; {allow interruptions occasionally}
    if col=5 then
    begin {check for solution}
      s:='';
      result:=true;
      {we have 5 candidate columns built, now need to see if rows sum to 20}
      for row:=0 to 4 do
      begin
        sum:=0;
        s:='';
        for i:=0 to 4 do
        begin
          inc(sum,ord(grid[i,row])-ord0);
          s:=s+grid[i,row];
        end;

        if sum<>20 then
        begin
          result:=false;
          break;
        end;
      end;
      If result then
      begin  {one more check, diagonals must also sum to 20}
        sum:=0; sum2:=0;
        for i:=0 to 4 do
        begin
          inc(sum, ord(grid[i,i])-ord0);
          inc(sum2, ord(grid[4-i,i])-ord0);
        end;
        if (sum<>20) or (sum2<>20) then result:=false
        else
        begin
          for i:=0 to 4 do for j:=0 to 4 do stringgrid1.cells[i,j]:=grid[i,j];
          if pausebox.Checked then
          begin
            pausetime:=now;
            paused:=true;
            if messagedlg('Solution found! Continue?',mtconfirmation,[mbyes,mbno],0)=mrno
            then stop:=true;
            totpausetime:=totpausetime+now-pausetime;
            paused:=false;
          end;
          inc(solvecount);
          updatestatus;
        end;
      end;
    end
    else
    begin
      {try all permutations of all unused keys
      {if adding one to the grid leaves it still valid, then
      go to the next column, other wise return false}
      if list.Find(candidates[col],index) then
      begin  {index points to the next 5 digit set to try as a column}
        plist:=TStringlist(list.Objects[index]);
        {Plist is the list of unique permutaions of these 5 digits}
        {5 dufferent digits will have 120 permitations, but each repeated digit
         will reduce the number by 1/2}
        for i:=0 to plist.count-1 do
        begin
          s:=plist[i];
          {fill the grid for this column}
          nextrowsum:=rowsum;
          OK:=true;
          for row:=0 to 4 do
          begin
            n:=ord(s[row+1])-ord0;
            if col=0 then nextrowsum[row]:=n
            else inc(nextrowsum[row], n);
            if nextrowsum[row]>20 then
            begin    {prune the search space}
            {if any row sum exceeds 20, no need to check the rest of teh columns}
             OK:=false;
             break;
            end
            else grid[col,row]:=s[row+1];
          end;
          if OK then result:=permutenextcol(grid,col+1, nextrowsum);
        end;
      end;
    end;
  end;

  {-------- RotateCandidates ------------}
  procedure rotatecandidates; {currently unused}
  {Rotating columns will increase the number of solutions found}
  var
    col,row:integer;
    temp:char;
  begin
    for row:=1 to 5 do
    begin
      temp:=candidates[4,row];
      for col:=3 downto 0 do candidates[col+1,row]:=candidates[col,row];
      candidates[0,row]:=temp;
    end;
  end;

var
  i,n,index:integer;
  start,stopindex:integer;
  s:string;
  
  grid: TGrid;
  rsum:TRowsum;
  totsolved, totcandidates:integer;
  runtime, totruntime:extended;


begin  {Phase2MemoClick}
  stop:=false;

  with phase2memo do
  begin
    totruntime:=0;
    totsolved:=0;
    totcandidates:=0;
    start:=memolineclicked(Phase2memo);
    {Set indices to do 1 or all from clicked line}
    if searchmodegrp.itemindex=0 then stopindex:=start
    else stopindex:=lines.count-1;
    for n:= start to stopindex do
    begin
      totpausetime:=0  ;
      solvecount:=0;
      s:=Phase2memo.lines[n];
      delete(s,1,5);
      if (length(s)=29) and (s[1] in ['1'..'9']) then
      with statusmemo,lines do
      begin
        Phase2memo.onclick:=nil; {prevent  2nd search from starting while 1st is running}
        stopbtn.visible:=true;
        Phase1Btn.enabled:=false;
        Phase2Btn.enabled:=false;
        {extract the clicked digit groups into a 5x5 array}
        for i:=0 to 4 do
        begin
          candidates[i]:= copy(s,6*i+1,5);
          rsum[i]:=0;
        end;
        add('');
        add('Starting "Phase 3" for group: '+phase2Memo.lines[n]);
        {we'll update this next line for each solution found}
        add(format('%d solutions found in: %6.1f seconds',[0, 0.0]));
        screen.cursor:=crHourGlass;
        starttime:=now;
        timer1.Enabled:=true;
        //for i:= 0 to 4 do
        begin
          permutenextcol(grid, 0, rsum); {start recursive search}
          //rotatecandidates;
        end;
        {final line}
        timer1.Enabled:=false;
        runtime:=(now-starttime-totpausetime)*secsperday;
        totruntime:=totruntime+runtime;
        totsolved:=totsolved+solvecount;
        inc(totcandidates);
        lines[lines.count-1]:=format('%d solutions found in: %6.1f seconds',
                            [solvecount,runtime]);

      end;
      if stop then break;
    end;
    if totsolved>1 then
    Statusmemo.Lines.add('');
    Statusmemo.Lines.add(format('Totals: Processed %d candidates and found %d solutions in: %6.1f seconds',
                            [totcandidates,totsolved,totruntime]));
    {Search done, set things back to normal}
    screen.cursor:=crDefault;
    stopbtn.visible:=false;
    Phase1Btn.enabled:=true;
    Phase2Btn.enabled:=true;
    Phase2memo.onclick:=Phase2MemoClick; {restore the OnClick exit}
  end;
end;

{************* UpdateStatus *************}
procedure TForm1.updatestatus;
{Update the status message showing solution count and runtime}
  var  solutionstr:string;
  begin
    if not paused then
    with statusmemo do
    begin
      if solvecount=1 then solutionstr:='solution' else solutionstr:='solutions';
      //lines[lines.count-1]:=format('%d %s found in: %6.1f seconds',
      //        [solvecount,solutionstr,(now-starttime-totpausetime)*secsperday]);
      lines[lines.count-1]:=format('%d %s found',
              [solvecount,solutionstr]);
      timelbl1.caption:=format('%6.0f seconds',[(now-starttime-totpausetime)*secsperday]);
      update;
    end;
  end;


{************ StopBtnClick **********}
procedure TForm1.StopBtnClick(Sender: TObject);
{Stop current solution search}
begin
  Stop:=true;
end;

{*********** Timer1Timer *********8}
procedure TForm1.Timer1Timer(Sender: TObject);
{Update the solution time display once per second dring searches}
begin
  updatestatus;
end;

{******** FormCloseQuery **********8}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  stop:=true; {Stop any ongoing search}
  canclose:=true;
end;


{************* Stringgrid1DrawCell ************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Do our own cell drawing to prevent the stupid highlighted "selected" cell from
 showing up colored!}
begin
  with stringgrid1,rect do
  begin
    canvas.font:=font;
    canvas.rectangle(rect);
    canvas.textout(left+8, top+4, cells[acol,arow]);
  end;
end;

end.
