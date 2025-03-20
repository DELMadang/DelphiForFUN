unit U_WaterJugs4;
{Copyright  © 2005, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 { Thanks to Charles Doumar for the idea and the initial version of this program}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    StdCtrls, ExtCtrls, ShellAPI, ComCtrls,
    Grids, Spin, MathsLib,strutils, dffutils
    ;

const
  maxjugs=7;
type

 IntArray=array of Integer;

  trip=array [0..2] of integer;
  triples=array [0..maxjugs-1] of trip;

  tStringObj=class(TObject)
    str:string;
  end;

  TAction=(transfer,fill,empty);

 TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TotLbl: TLabel;
    StopBtn: TButton;
    SearchBtn: TButton;
    Memo3: TMemo;
    StaticText1: TStaticText;
    Memo1: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Panel1: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    ResetBtn: TButton;
    Memo2: TMemo;
    StringGrid1: TStringGrid;
    StartEdt: TEdit;
    EndEdt: TEdit;
    JarsEdt: TEdit;
    DefaultGrp: TRadioGroup;
    UndoBtn: TButton;
    Label4: TLabel;
    Label5: TLabel;
    TypeGrp: TRadioGroup;
    OpenLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure StartCBClick(Sender: TObject);
    procedure PourBtnClick(Sender: TObject);
    procedure EndCBClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Stringgrid1click(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure DefaultGrpClick(Sender: TObject);
    procedure UndoBtnClick(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: Char);
    procedure TypeGrpClick(Sender: TObject);
  public
    JarTotal:integer;
    movecount:integer;  {current move count for user moves}
    bestcount:integer; {best solution move count form program solution}
    vmax:integer;  {max capacity of any jar}
    goalkey:string;
    fromindex, toindex:integer; {node from and to indices for a move}
    StartConfigSetup:boolean;
    nbrjars:integer;
    new:intarray;
    caps,inits,finals,current:intarray;
    saveundo:array of intarray;  {save states to allow move undo}
    action:TAction;
    Function ResetGoal:boolean;   {return false if inputs are not all valid}
    Procedure MakeDefaultcase(size:integer);
    function  MakeKey(const tryvals:intarray):string; {convert contents array to string}
    procedure ExpandKey(const key:string; var new:intarray);{convert string to content array}
    procedure setupgrid;  {Set up display grid}
    procedure SolutionSearch; {Perform breadth-first search for solution}
    function  MakeMoveString(before, after:string):string; {Describe a moved given before and after positions}
    function  Inserthyphens(s:string):string; {Insert "-" into key string for readability}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

var ltBlue:Tcolor=($f9dd93);

    {each triple represents capacity, start, and goal positions for a jar}
    DefaultClosedCaseDefinitions:array[2..7] of triples =
              (
               ((1,1,0),(1,0,1),(0,0,0),(0,0,0),(0,0,0),(0,0,0),(0,0,0)),
               ((3,0,0),(5,2,3),(9,9,8),(0,0,0),(0,0,0),(0,0,0),(0,0,0)),
               ((24,24,8),(5,0,0),(11,0,8),(13,0,8),(0,0,0),(0,0,0),(0,0,0)),
               ((3,0,1),(5,0,1),(9,8,9),(3,3,2),(9,3,1),(0,0,0),(0,0,0)),
               ((10,9,3),(10,7,10),(7,6,7),(7,5,0),(7,0,0),(7,0,7),(0,0,0)),
               ((10,10,9),(10,10,5),(10,0,5),(10,0,0),(7,0,5),(7,7,5),(7,7,5)));
          {or} //((10,10,4),(10,10,6),(10,0,10),(10,0,0),(7,0,0),(7,7,7),(7,7,7)));

   DefaultOpenCaseDefinitions:array[2..7] of triples =
              (
               ((5,0,4),(3,0,0),(0,0,0),(0,0,0),(0,0,0),(0,0,0),(0,0,0)),
               ((5,0,0),(8,0,6),(9,0,0),(0,0,0),(0,0,0),(0,0,0),(0,0,0)),
               ((12,0,6),(5,0,0),(7,0,6),(3,0,1),(0,0,0),(0,0,0),(0,0,0)),
               ((1,1,0),(1,0,0),(1,0,0),(1,0,0),(1,0,1),(0,0,0),(0,0,0)),
               ((1,1,0),(1,0,0),(1,0,0),(1,0,0),(1,0,0),(1,0,1),(0,0,0)),
               ((1,1,0),(1,0,0),(1,0,0),(1,0,0),(1,0,0),(1,0,0),(1,0,1)));

   ClosedInstructions:string ='Closed puzzle - For user play, click "From"  water jar  folowed by'
                        +' a click on the "To" jar.  If you change your mind after clicking'
                        +' "From", click it again to reset the selection.   Use the "Undo"'
                        +' button to remove completed moves.';

  OpenInstructions:string ='Open puzzle - For user play, click "From"  water jar  folowed by '
                        +'key "F" to fill it, kay "E" to em[ty it, or click on the "To" jar to pour.'
                        +' If you change your mind after clicking'
                        +' "From", click it again to reset the selection.  Use the "Undo"'
                        +' button to remove completed moves.';


   {*********** Makekey **********}
   function TForm1.makekey(const tryvals:intarray):string;
      {Keys are concatenated string versions of tryvals}
      var
        i:integer;
      begin
        result:='';
        for i:=0 to nbrjars-1 do result:=result+format('%2.2d',[tryvals[i]]);
      end;


{**************** AdjustGridSize *************}
procedure adjustGridWidth(grid:TStringGrid);
{Adjust height and width  of grid to just fit cells}
var
  w,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do
    w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
  end;
end;

{************* FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  StopBtn.bringtofront;
  randomize;
end;

{*********** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);

begin
  makedefaultcase(DefaultGrp.itemindex+2);
  resetgoal;
end;


{************ Setupgrid ************}
procedure Tform1.setupgrid;
var i:integer;
begin
  with stringgrid1 do
  begin
    colcount:=nbrjars+1;
    for i:=0 to nbrjars-1 do
    begin
      cells[i+1,0]:='Jar #'+inttostr(i+1);
      cells[i+1,2]:=inttostr(current[i]);
      cells[i+1,3]:=inttostr(finals[i]);
      cells[i+1,4]:=inttostr(caps[i]);
    end;

    cells[0,1]:='';
    cells[0,2]:='Current';
    cells[0,3]:='Goal';
    cells[0,4]:='Capacity';
    rowheights[1]:=100;
    colwidths[0]:=56;

  end;
  adjustgridwidth(stringgrid1);
  stringgrid1.width:=stringgrid1.width+1;
  fromindex:=-1;
  toindex:=-1;
  movecount:=0;
  setlength(saveundo,10, nbrjars);
end;



{************ MakeDefaultCase *************}
Procedure TForm1.Makedefaultcase(size:integer);
{Set up the default case for "size" jars}
var
  j:integer;
  capsPos,initpos,finalpos:string;
begin
  nbrjars:=size;
  capspos:='';
  initpos:='';
  finalpos:='';
  jartotal:=0;
  If typegrp.ItemIndex =0 then
  for j:= 0 to nbrjars-1 do
  begin
    capspos:=capspos+inttostr(DefaultClosedCaseDefinitions[size][j][0])+'-';
    initpos:=initpos+inttostr(DefaultClosedCaseDefinitions[size][j][1])+'-';
    finalpos:=finalpos+inttostr(DefaultClosedCaseDefinitions[size][j][2])+'-';
    inc(jartotal,DefaultClosedCaseDefinitions[size][j][1]);
  end
  else for j:= 0 to nbrjars-1 do
  begin
    capspos:=capspos+inttostr(DefaultOpenCaseDefinitions[size][j][0])+'-';
    initpos:=initpos+inttostr(DefaultOpenCaseDefinitions[size][j][1])+'-';
    finalpos:=finalpos+inttostr(DefaultOpenCaseDefinitions[size][j][2])+'-';
    inc(jartotal,DefaultOpenCaseDefinitions[size][j][1]);
  end;
  delete(capspos,length(capspos),1);
  delete(initpos,length(initpos),1);
  delete(finalpos,length(finalpos),1);
  jarsedt.text:=capspos;
  startedt.text:= initpos;
  endedt.text:=finalpos;
end;



{*************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Search  for solutions}
var
  startcount,stopcount,freq:int64;
  i:integer;
begin
  if not resetgoal then exit;
  Goalkey:=Makekey(Finals);
  stopbtn.Visible:=true;
  panel1.Enabled:=false;
  tag:=0;
  application.processmessages;
  //memo5.Lines.Add('Mem before: '+inttostr(allocmemsize)); {check for memory leak}
  SolutionSearch;
  //memo5.Lines.Add('Mem after: '+inttostr(allocmemsize)); {check for memory leak}
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
  panel1.Enabled:=true;
end;


{*********** InsertHyphens ************8}
function  TForm1.Inserthyphens(s:string):string;
{Separate a concatenated string of 2 digit jar values by inserting hyphens}
  var i:integer;
      n:integer;
  begin
    for i:= 0 to nbrjars-1 do
    begin
      n:=strtoint(copy(s,2*i+1,2));
      If i=0 then result:=inttostr(n)
      else result:=result+'-'+inttostr(n);
    end;
  end;



{***************** MakeMoveString ****************}
function TForm1.makemovestring(before, after:string):string;
  {given strings representing jar contents before and after a move, describe
   move that was made}
  var
    i:integer;
    ins,outs:intarray;
    fromjar, tojar, fromamount, toamount:integer;
  begin
    setlength(ins,nbrjars);
    setlength(outs,nbrjars);
    for i:=0 to nbrjars-1 do
    begin
      ins[i]:=strtoint(copy(before,2*i+1,2));
      outs[i]:=strtoint(copy(after,2*i+1,2));
    end;
    {one of the jars has decreased from ins to outs and one has gained the
     same amount, let's find which ones they are }
    fromamount:=0;
    toamount:=0;
    fromjar:=-1;
    tojar:=-1;
    for i:=0 to nbrjars-1 do
    begin
      if ins[i]>outs[i] then
      begin
        fromjar:=i;
        fromamount:=ins[i]-outs[i];
      end
      else if ins[i]<outs[i] then
      begin
        tojar:=i;
        toamount:=outs[i]-ins[i];
      end;
    end;
    if (fromamount=toamount)  then
    begin
      result:=format('From #%d to #%d (%2d)',[fromjar+1, tojar+1, fromamount]);
    end
    else If (typegrp.itemindex=1) then
    begin
      if fromjar=-1 then result:=format('Fill #%d (%2d)',[tojar+1, toamount])
      else if tojar=-1 then result:=format('Empty #%d (%2d)',[fromjar+1, fromamount])
    end
    else result:=format('System error: From %s to %s is not a valid move',[before, after]);
  end;





{*********** ResetGoal ************}
function TForm1.resetgoal:boolean;
{initialize after jars, starting, or goal configuration has changed}
var
  msg:string;

      {-------------- Extractvalues ----------------}
      Function ExtractValues(ss:string; var tot:integer):intarray;
      {return integer array from a-b-c-d type string where a,b,c,d,etc. are non-negative}
      var
        i:integer;
        s:string;
        n,v,count:integer;
        OK:boolean;
        vv:intarray;

      begin
        setlength(result,0);
        setlength(vv,maxjugs);
        OK:=true;
        s:=stringreplace(ss,' ','',[rfReplaceAll]);
        if length(s)>0 then
        begin
          if s[length(s)]<>'-' then s:=s+'-';
          n:=pos('-',s);
          count:=0;
          tot:=0;
          while (n>0) and OK do
          begin
            v:=strtointdef(copy(s,1,n-1),-1);
            if v>=0 then
            begin
              tot:=tot+v;
              vv[count]:=v;
              delete(s,1,n);
              n:=pos('-',s);
              inc(count)
            end
            else OK:=false;
          end;
          if not OK
          then showmessage(format('Error in %s, must be non-negative separated by hyphen (-) characters', [s]))
          else
          begin
            setlength(result, count);
            for i:=0 to count-1 do result[i]:=vv[i];
          end;
        end;
      end;  {extract values}

  var
    i,n:integer;
    tot1,tot2:integer;
begin {resetgoal}
  {Validate the inputs}
  result:=false;
  caps:=extractvalues(JarsEdt.text,tot1);
  if (length(caps)>0) and (length(caps)<=7) then
  begin
    nbrjars:=length(caps);
    vmax:=caps[0];
    for i:= 1 to nbrjars-1 do vmax:=max(vmax,caps[i]);
    inits:=extractvalues(StartEdt.text, tot1);

    n:=length(inits);
    msg:='';
    if (n>0) and (n<>nbrjars)
    then msg:=format('Nbr of Start values does not match Capacity count, %d',[nbrjars])
    else
    begin
      setlength(current,nbrjars);
      for i:=0 to nbrjars-1 do current[i]:=inits[i];
      finals:=extractvalues(EndEdt.text, Tot2);
      n:=length(finals);
      if (n>0) and (n<>nbrjars)
      then msg:=format('Nbr of Goal values does not match Capacity count, %d',[nbrjars])
      else
      begin
        if (Tot1<>tot2) and (typegrp.itemindex=0)
        then msg:=format('For closed puzzle, total of Goal values must match total of Initial values , %d',[Tot1])
        else
        begin
          Jartotal:=tot1;
          for i:=0 to nbrjars-1 do
          begin
            if inits[i]>caps[i]  then
            begin
              msg:=format('Inital liquid in Jar %d exceeds capacity',[i]);
              break;
            end;
            if finals[i]>caps[i]  then
            begin
              msg:=format('Goal liquid in Jar %d exceeds capacity',[i]);
              break;
            end;
          end;
        end;
      end;
    end;
    if msg<>'' then showmessage(msg)
    else
    begin  {Inputs are OK}
      result:=true;
      Setupgrid;
      StringGrid1.Invalidate;
      TotLbl.Caption:='';
      memo4.clear;
      memo5.clear;
    end;
  end;
  action:=transfer;
  openLbl.caption:='';
end;

{***************** ExpandKey *****************}
procedure TForm1.expandkey(const key:string; var new:intarray);
var
  i:integer;
begin
  for i:=0 to nbrjars-1 do
  new[i]:=strtoint(copy(key,2*i+1,2));
end;



{************* SolutionSearch *****************}
procedure TForm1.SolutionSearch;
var
  startcount,stopcount,freq:int64;
  i,j,k,n,n2,index:integer;
  key1,key2:string;
  prevkeyobj:TStringObj;
  List, NextMoveQueue:TStringList;
  ObjList:TList;
  startkey,goalkey:string;
  cur,new:IntArray;
  done:boolean;
  loops:integer;

begin
  screen.cursor:=crhourglass;
  list:=TStringList.Create;
  list.Sorted:=true;
  NextMoveQueue:=TStringlist.create;
  ObjList:=TList.Create;
  setlength(new,nbrjars);
  queryPerformancefrequency(Freq);
  queryperformancecounter(startcount);
  {Breadth first search
   We'll generate all neighbors from the start position, adding each new neigbor
   to "NextMoveQueue"    and processing them in FIFO (First in - First out) order.
   We don't know which of these paths will lead to the solution, so we'll save them
   all in sorted list "List" until we find the goal or generate all neighbors.
   With each position added to the list, we'll also save the previous position
   that led to this one.  When the goal is found we can retrieve the postions
   in reverse order, but one more pass adding them to the queue can reverse them
   again and let us list the moves from start to goal positions.
  }
  {This algorithm replaced the original recursive processing which caused Stack
   Overflow errors for large cases}

  setlength(cur,nbrjars);
  setlength(new,nbrjars);
  for i:=0 to nbrjars-1 do cur[i]:=inits[i];
  goalkey:=makekey(finals);
  key2:=makekey(cur);

  NextMoveQueue.add(key2); {start the queue of configurations to check}
  done:=false;
  loops:=0;
  while (NextMoveQueue.count>0) and (goalkey<>key2) and  (tag=0) do
  begin
    inc(loops);
    if loops and $FFF = 0 then application.processmessages; {let stop btn get handled}
    if tag=1 then break;
    expandkey(NextMoveQueue[0], cur); {for this sending jar}
    key1:=NextMoveQueue[0];
    prevkeyobj:=TStringobj.Create;
    prevkeyobj.str:=key1;
    ObjList.add(prevkeyobj);
    for i:=0 to nbrjars-1 do
    begin  {try pourng each jar in this configuration into each other jar}
      n:=cur[i];
      if n>0 then
      begin
        for j:=0 to nbrjars-1 do {each of the receiving jars}
        if i<>j then  {do not pour into self!}
        begin
          for k:=0 to nbrjars-1 do new[k]:=cur[k];
          n2:=new[j];
          if caps[j]>n2 then
          begin {there is some room in jar j}
            if caps[j]>n2+n then
            begin   {there is enough room to pour all of jar i into jar j}
              new[j]:=n2+n;
              new[i]:=0;
            end
            else
            begin   {there is only enough room to pour part of jar i into jar j}
              new[j]:=caps[j];;
              new[i]:=n+n2-caps[j];
            end;
            key2:=makekey(new); {here's the new receiving key}
            if not list.find(key2,k) then
            begin
              {save the new configuration with back link in case it leads to the solution}
              list.addobject(key2,prevKeyObj);
              {and save it in the queue for possible futher processing}
              NextMoveQueue.add(key2);
              if key2=goalkey then done:=true;
            end;
          end;
          if done then break;
        end;
      end;
      if done then break;
      if (typegrp.itemindex=1) then
      {Try filling each empty or partially full jug and emtpying each non-empty jug}
      begin
        if cur[i]<caps[i] then {fill}
        begin
          for k:=0 to nbrjars-1 do new[k]:=cur[k];
          new[i]:=caps[i];
          key2:=makekey(new);
          if not list.find(key2,k) then
          begin
            list.addobject(key2,prevKeyObj);
            NextMoveQueue.add(key2);
            if key2=goalkey then done:=true;
          end;
        end;
        if cur[i]>0 then {empty it}
        begin
          for k:=0 to nbrjars-1 do new[k]:=cur[k];
          new[i]:=0;
          key2:=makekey(new);
          if not list.find(key2,k) then
          begin
            list.addobject(key2,prevKeyObj);
            NextMoveQueue.add(key2);
            if key2=goalkey then done:=true;
          end;
        end;
        if done then break;
      end;
    end;
    NextMoveQueue.delete(0); {done with this config, delete it}
  end;
  //if tag=0 then {done with no interruption}
  //begin
  NextMoveQueue.clear;
  startkey:=makekey(inits);
  If key2=goalkey then
  begin     {process the list prevkey links to get path then sort it forwards}
    key1:=goalkey;
    NextMoveQueue.add(key1);

    while key1 <> startkey do
    begin
      if list.Find(key1,index) then
      begin
        key1:=TStringObj(list.objects[index]).str;
        NextMoveQueue.insert(0,key1);
      end
    end;

    with memo5, lines do
    begin
      add('Shortest Path from ');
      add(insertHyphens(startkey)+' to '+insertHyphens(goalkey));
      add('');
      with NextMoveQueue  do
      for i:=0 to count-1 do
      begin
        if i=0 then lines.add('Start ' + InsertHyphens(strings[i]) )
        else lines.add(format('%2d) %s  %s',
          [i,Makemovestring(strings[i-1],strings[i]),inserthyphens(strings[i])]));
      end;
      movetotop(memo5);   {from DFFUtils, force scroll to line 0 of memo5}
    end;
    queryPerformancecounter(stopcount);
  end
  else
  begin
    queryPerformancecounter(stopcount);
    if tag>0 then showmessage('Search interrupted')
    else showmessage('No solution exists');
  end;
  totlbl.caption:=format('Configurations checked: %d. Time: %6.3f secs',
                      [list.count, (stopcount-startcount)/freq]);

  {clean up}
  for i:=0 to objlist.count-1 do
    try
      TStringobj(objlist.items[i]).Free;
      finally
    end;

  list.free;
  NextMoveQueue.free;
  ObjList.free;
  screen.cursor:=crdefault;
end;

{*************** StartCbClick **********}
procedure TForm1.StartCBClick(Sender: TObject);
begin
  resetgoal;
end;

{*********** EndCBClick **********}
procedure TForm1.EndCBClick(Sender: TObject);
begin
  resetgoal;
end;


{************* PourbtnClick ***********}
procedure TForm1.PourBtnClick(Sender: TObject);
var i,j,k,cap,pour:integer;
    OK:boolean;
begin
  i:=fromindex;
  j:=toindex;
  if (action=fill) or (current[i]>0)then
  begin
    if movecount>=length(saveundo) then setlength(saveundo, movecount+10,nbrjars);
    for k:=0 to nbrjars-1 do saveundo[movecount][k]:=current[k];
    inc(movecount);
    {pour all of the water in i or else j is full, whichever is smallest}

    if action=fill then
    begin
      pour:=caps[i]-current[i];
      current[i]:=caps[i]; {request to fill}
      memo4.lines.Add(format('%2d) Fill %3d from source (%3d)',
                              [movecount,i+1,pour]));
    end
    else if action=empty then
    begin
      pour:=current[i];
      current[i]:=0;{request to empty}
      memo4.lines.Add(format('%2d) Empty %3d (%3d)',
                              [movecount,i+1,pour]));
    end
    else
    begin
      cap:=caps[j]-current[j];
      pour:=min(current[i],cap);
      current[i]:=current[i]-pour;
      current[j]:=current[j]+pour;
      memo4.lines.Add(format('%2d) From %3d to %3d (%3d)',
                              [movecount,i+1,j+1, pour]));
    end;

    for i:=0 to nbrjars-1 do
    with stringgrid1 do
    begin
      cells[i+1,1]:='';  {force redaraw}
      cells[i+1,2]:=inttostr(current[i]);
      cells[i+1,5]:='';
    end;
    OK:=true;
    for k:=0 to nbrjars-1 do
    If (current[k]<>finals[k]) then
    begin
      OK:=false;
      break;
    end;
    if ok then
    with memo4.lines do
    begin
      messagebeep(Mb_OK);
      sleep(100);
      showmessage('You did it!!');
    end;
  end
  else memo4.lines.add('Nothing to pour from jar '+inttostr(i+1));
  openlbl.caption:='';
  action:=transfer;
  fromindex:=-1;
  toindex:=-1;

end;



{***************** StringGrid1DrawCell ************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
    base, vaseheight, vasewidth,offset:integer;
    i:integer;

   procedure drawvase(n:integer);
    var
      w,v:integer;
    begin

      with stringgrid1.canvas do
      if length(caps)>0 then
      begin
        brush.color:=clWindow;
        fillrect(rect);
        w:=offset;
        v:=vaseheight*caps[n] div vmax;
        pen.color:=clblack;
        polyline( [point(w-4,base-v-4),
                point(w,base-v),
                point(w,base),
                point(w+vasewidth,base),
                point(w+vasewidth,base-v),
                point(w+vasewidth+4,base-v-4)]);
        If caps[n]>0 then
        begin
          {Draw line at current water level}
          i:=v*current[n] div caps[n];
          moveto(w,base-i); lineto(w+vasewidth,base-i);
          {fill it }
          If acol-1 = fromindex then brush.color:= ltBlue else brush.color:=clblue;
          if i>1 then floodfill(w+v div 2, base-1,clblack,fsborder);
          brush.color:=clwhite;
        end;
      end;
    end;

begin
  with stringgrid1 do
  begin
    If (arow<>1) or (acol=0) then
    { just draw the text}
    with canvas do
    begin
      if (acol=0) or (arow=0) then brush.color:=clbtnface
      else brush.color:=clWindow;
      fillrect(rect);
      if (acol>0) then font.style:=[fsbold] else font.style:=[];
      textout(rect.left+4, rect.top+4, cells[acol,arow]);
    end
    else  if acol>0 then {For row 1, draw the jar mimage}
    begin
      base:=rect.bottom-10;
      vaseheight:=rect.bottom-rect.top-20;
      vasewidth:=rect.right-rect.left-20;
      offset:=rect.left+10;
      drawvase(acol-1);
    end;
  end;
end;

{******** StringGrid1Click ************}
procedure TForm1.StringGrid1click(Sender: TObject);
var
  msg:string;
begin
  with stringgrid1 do
  begin
    if (row=1) and (col>0) and (col<=nbrjars) then
    begin
      if fromindex<0 then
      begin
        fromindex:=col-1;
        If typegrp.itemindex=1 then
        begin
          if current[fromindex]=caps[fromindex] then msg:='Type E to Empty or click a jug to pour to'
          else if current[fromindex]>0 then msg:='Type F to Fill, E to Empty , or click a jug to pour to'
          else msg:='Type F to Fill';
          Openlbl.caption:=msg;
        end
        else openlbl.caption:='Click a jug to pour to';
      end
      else
      begin
        if col-1=fromindex then fromindex:=-1 {reset from choice}
        else
        begin
          toindex:=col-1;
          pourbtnclick(sender);
        end;
      end;
      cells[col,row]:='';  {force redraw}
    end;
  end;
end;

{***************** ResetBtnClick ***********}
procedure TForm1.ResetBtnClick(Sender: TObject);
begin
  memo4.clear;
  totlbl.caption:='';
  resetgoal;
end;

{************ StopBtnClick ***********}
procedure TForm1.StopBtnClick(Sender: TObject);
{Interrupt the solution precalcuation phase}
begin
  tag:=1;
  application.processmessages;
end;


{************** DefaultGrpClick *************}
procedure TForm1.DefaultGrpClick(Sender: TObject);
{make string versions of jar description arrays for default cases}
var
  i,n:integer;
  J,S,E:string;
begin
  n:=defaultgrp.itemindex+2;
  J:='';
  S:='';
  E:='';
  if typegrp.itemindex=0 then
  for i:=0 to n-1 do
  begin
    j:=j+inttostr(DefaultClosedCaseDefinitions[n][i][0])+'-';
    S:=S+inttostr(DefaultClosedCaseDefinitions[n][i][1])+'-';
    E:=E+inttostr(DefaultClosedCaseDefinitions[n][i][2])+'-';
  end
  else
  for i:=0 to n-1 do
  begin
    j:=j+inttostr(DefaultOpenCaseDefinitions[n][i][0])+'-';
    S:=S+inttostr(DefaultOpenCaseDefinitions[n][i][1])+'-';
    E:=E+inttostr(DefaultOpenCaseDefinitions[n][i][2])+'-';
  end;
  delete(J,length(j),1);
  delete(S,length(S),1);
  delete(E,length(E),1);
  JarsEdt.Text:=j;
  StartEdt.Text:=S;
  EndEdt.Text:=E;
  resetgoal;
end;

{*********** VaseChange ***********}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{************* UndoBtnClick ************}
procedure TForm1.UndoBtnClick(Sender: TObject);
var
  i:integer;
begin
  If movecount>0 then
  begin
    dec(movecount);
    for i:=0 to nbrjars-1 do current[i]:=saveundo[movecount][i];
    with memo4.lines do delete(count-1);
    for i:=0 to nbrjars-1 do
    with stringgrid1 do
    begin
      cells[i+1,1]:='';  {force redaraw}
      cells[i+1,2]:=inttostr(current[i]);
    end;
    application.ProcessMessages
  end;
end;

{**********  StringGrid1KeyPress *********}
procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: Char);
{Check for F (Fill) or E (Empty) keys on the display grid after a jug has been selected}
begin
  If (typegrp.itemindex=1) and (fromindex>=0) then
  begin
    case upcase(key) of
      'F': {fill jar fromindex}  action:=fill;
      'E': {empty jar fromindex} action:=empty;
      else action:=transfer;
    end;
    if action<>transfer then pourbtnclick(sender);
  end;
end;

{******* TypegrpClick **********}
procedure TForm1.TypeGrpClick(Sender: TObject);
begin
   action:=transfer;
   openlbl.Caption:='';
   if typegrp.itemindex=0 then memo2.Text:=Closedinstructions
   else memo2.Text:=OpenInstructions;
   DefaultGrpClick(sender);
end;

end.
