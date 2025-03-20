unit U_FourDice3;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ Find as set of dice, A,B,C,D, with the property that on average, when rolled
  in pairs, A beats B, B beats C, C neats D, and D beats A.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, Spin, printers, UTGraphSearch, ComCtrls, ExtCtrls, shellAPI;
  //, uCardComponentV2;

type
  TAnswer=record
    ans:array of integer;
    count:integer;
  end;
  pTAnswer=^Tanswer;

  TForm1 = class(TForm)
    PageControl1: TPageControl;
    StaticText1: TStaticText;
    SolveSheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    CheckLbl: TLabel;
    Memo1: TMemo;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    Edit1: TEdit;
    Solvebtn: TButton;
    SpinEdit4: TSpinEdit;
    IntroSheet: TTabSheet;
    Memo2: TMemo;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Memo4: TMemo;
    Memo3: TMemo;
    procedure SpinEditChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure SolvebtnClick(Sender: TObject);
    procedure Memo2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    Graph:TGraphList;
    answers:array of integer;  
    visited:array of boolean;
    anscount:integer;
    list:TStringlist;

    ansrec:TAnswer;
    procedure getnextfrom(const start,n:integer);
    //procedure drawcards(nbrcards:integer;showback:boolean;pagesize:TPoint; ccanvas:TCanvas);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
uses UcomboV2, U_PrintCards;

var
  maxnbr:integer=7;
  dicesides:integer=4;
  dicesidessquared:integer=16;
  minprob:real=0.60;
  maxsetsize:integer=5;
  startkey:string;

{************ Winprob ************}
function winprob(s1,s2:string):single;
{probability that s1 beats s2 on random rolls}
  var  i,j,c,n:integer;
  begin
    result:=0;
    n:=length(s1);
    if n<>length(s2) then exit;
    c:=0;
    i:=1;
    while i<=n do
    begin
      j:=1;
      while j<=n do
      begin
        if s1[i]>s2[j] then inc(c);
        inc(j,2);
      end;
      inc(i,2);
    end;
    result:=c/(diceSidesSquared);
   end;



{****************** GetNextFrom *************}
procedure Tform1.getnextfrom(const start,n:integer);
{ recursive search for valid set where last beats first}
var
  i,k:integer;
  s:string;
  p,plast:real;
  node:TNode;
  panswer:pTAnswer;
begin
  plast:=winprob(graph[n],graph[start]);
  if plast>=minprob then  {last die beats first?}
  with graph do {yes - we have a solution!}
  begin
    {Build string of results to report a completed loop}
    memo2.lines.add('Solution set of '+inttostr(anscount) + ' found: ');
    s:=strings[answers[1]];
    for k:= 2 to anscount do
    begin
      p:=winprob(strings[answers[k-1]], strings[answers[k]]);
      s:=s+format('(P:%4.2f)>',[p])+strings[answers[k]];
    end;
    s:=s+ format('(P:%4.2f)>',[plast])+strings[start]; {add last beating first}
    new(Panswer); {Build a record of results for ease of printing later}
    with panswer^ do
    begin
      setlength(ans,anscount+1);
      for i:=1 to anscount do ans[i]:=answers[i];
      count:=anscount;
    end;
    memo2.lines.add(s);
    list.addobject(s,TObject(Panswer));  {save the answer in a list}
    application.processmessages;
  end
  else
  begin
    i:= 1;
    Node:=TNode(graph.objects[n]);
    {scan through adjacent nodes looking for a set in which the last node beats the first}
    while (i<node.nbradjacents) and (anscount<maxsetsize) and (Tag=0) do
    begin
      If visited[node.adjacents[i].tonodeindex] then exit;
      inc(anscount);    {add it to the answer list}
      answers[anscount]:= node.adjacents[i].tonodeindex;
      visited[n]:=true;
      getnextfrom(start,answers[anscount]);
      visited[answers[anscount]]:=false; {retract the node}
      dec(anscount);
      inc(i);
      application.processmessages;
    end;
  end;
end;

{************** SolveBtnClick *********}
procedure TForm1.SolvebtnClick(Sender: TObject);
{search for solutions}
var
  acombo, bcombo:TComboset;
  s,s2:string;
  start:integer;
  i,j, totedges:integer;
  p:real;
begin
  if solvebtn.caption='Stop' then
  begin
    tag:=1; {set flag to stop loop}
    solvebtn.caption:='Solve';
    memo3.lines.add{checklbl.caption:=checklbl.caption+#13+}('Search stopped by user');
    application.processmessages;
    exit;
  end
  else
  begin
    tag:=0;
    if list.count>0 then
    begin
      for i:= 0 to list.count-1 do dispose(PTanswer(list.objects[i]));
      list.clear;
    end;
    memo2.clear;
    If assigned(graph) then  graph.free;
    graph:=TGraphlist.create;
    spineditchange(sender);
    solvebtn.caption:='Stop';
    acombo:=TComboset.create;
    bcombo:=TComboset.create;
    memo3.clear;
    {Build a graph where nodes are all possible arrangements of available
     numbers on a die}
    acombo.setup(dicesides,maxnbr,CombinationsWithrep);
    Memo3.lines.add('Building Nodes'); memo3.update;
    screen.cursor:=crhourglass;
    while acombo.getnext do
    begin
      s:=inttostr(acombo.selected[1]);
      for i:= 2 to dicesides do s:=s+','+inttostr(acombo.selected[i]);
      graph.addnode(s);
    end;
    graph.finalize;
    memo3.lines[0]:= 'Building nodes,' +inttostr(graph.count)+' Nodes built';
    memo3.lines.add('For each die, find those which it beats ');
    memo3.update;
    acombo.setup(dicesides,maxnbr,CombinationsWithrep);
    totedges:=0;
    while (acombo.getnext) and (tag=0) do
    begin
      s:=inttostr(acombo.selected[1]);
      for i:= 2 to dicesides do s:=s+','+inttostr(acombo.selected[i]);
      bcombo.setup(dicesides,maxnbr,CombinationsWithrep);
      while bcombo.getnext and (tag=0) do
      begin
        s2:=inttostr(Bcombo.selected[1]);
        for i:= 2 to dicesides do s2:=s2+','+inttostr(bcombo.selected[i]);
        p:= winprob(s,s2);
        if p>=minprob
        then
        begin
          Graph.addedge(s,s2,round(dicesidesSquared*p));
          inc(totedges);
        end;
      end;
      application.processmessages;
    end;
    setlength(answers, graph.count+1);
    setlength(visited, graph.count+1);
    if tag=0 then
    begin
      memo3.lines[1]:=memo3.lines[1]+', '+inttostr(totedges)+' pairs built';
      memo3.lines.add('Searching for solutions');
    end
    else memo3.lines.add('Search stopped by user');

    memo3.update;
    if graph.find(startkey,start) then else start:=1;
    with graph do
    for i:=start to count-1 do
    begin
      if tag<>0 then break;
      anscount:=1;
      answers[anscount]:=i;
      memo3.lines[memo3.lines.count-1]:='Checking from '+graph[i];  memo3.update;
      edit1.text:=graph[i];
      if graph[i][1]>'1' then
      with memo3 do
      begin
        clear;
        lines.add('All sets containing a ''1'' have been found');
        lines.add('Remaining sets can be found faster by reducing the max number on a die and finding sets containing a ''1''');
        break;
      end;
      for j := 0 to high(visited) do visited[j]:=false;
      getnextfrom(i,i); {Start recursive search for solutions}
      application.processmessages;
    end;
    acombo.free;
    bcombo.free;
    Solvebtn.caption:='Solve';
    screen.cursor:=crdefault;
    tag:=0;
  end;
end;

{*********** SpinEdit1Change ************}
procedure TForm1.SpinEditChange(Sender: TObject);
{one of the parameters (nbr of sides per die, max value on a side,
 minimum probability for a solution, max nbr of dice in a solution), changed -
 recalculate all}
var
  i:integer;
  s:string;
  xlist:Tstringlist;
begin
  dicesides:=spinedit1.value;
  DiceSidesSquared:=dicesides*dicesides;
  maxnbr:=spinedit2.Value;
  minprob:=spinedit3.value/100;
  maxSetsize:=spinedit4.value;
  {check the starting die configuration and reset to all 1' if not valid}
  xlist:=TStringlist.create;
  xlist.commatext:=edit1.text;
  if xlist.count=dicesides then
  begin
    startkey:=edit1.text;
  end
  else
  begin
    s:='1';
    for i:=  2 to dicesides do s:=s+',1';
    edit1.text:=s;
  end;
  xlist.free;
end;

{************** FormCloseQuery ***********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1; {To stop search for solutions if running}
  canclose:=true;
end;

{************* FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
{Set default run parameters}
begin
  spineditchange(sender);
  If assigned(list) then list.free;
  list:=TStringlist.create;
  if assigned(graph) then graph.free;
  graph:=TGraphList.create;
  pagecontrol1.activepage:=Introsheet;
end;

procedure TForm1.Memo2Click(Sender: TObject);
{User clicked on a solution - show form to display/print card version}
var
  n:integer;
  ansptr:PTanswer;
begin
  tag:=2;  {pause current search}
  application.processmessages;
  screen.cursor:=crdefault;
  n:=(memo2.caretpos.y) div 2;  {two lines displayed per solution, line number = solution number}
  ansptr:= PTAnswer(list.objects[n]);  {Pass the solution to the form}
  form2.dicesides:=dicesides;
  form2.ansrec:=ansptr^;
  form2.  showmodal;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
{Link to DFF website}
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
