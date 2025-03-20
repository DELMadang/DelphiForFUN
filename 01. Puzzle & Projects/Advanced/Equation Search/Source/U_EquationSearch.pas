unit U_EquationSearch;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Given four sets of four numbers each, rearrange them and  insert two
 operators to form an equation of the form (N1 op1 N2) op2 N3 = N4 which is
 satisfied by all four sets}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TNumset=array [1..4] of integer;
  TOpset= array[1..4] of char;
  TForm1 = class(TForm)
    SolveBtn: TButton;
    Panel1: TPanel;
    Edit1: TEdit;
    Edit4: TEdit;
    Edit3: TEdit;
    Edit2: TEdit;
    Panel2: TPanel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Panel4: TPanel;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit15: TEdit;
    Edit16: TEdit;
    Panel3: TPanel;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit19: TEdit;
    Edit20: TEdit;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel5: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    GenerateBtn: TButton;
    InstructLbl: TLabel;
    CheckBtn: TButton;
    V1Box: TListBox;
    V2Box: TListBox;
    V3Box: TListBox;
    AnsBox: TListBox;
    EqLbl: TLabel;
    O2Box: TListBox;
    O1Box: TListBox;
    ScoreLbl: TStaticText;
    ResetBtn: TButton;
    ProbLbl: TLabel;
    OptionBtn: TButton;
    procedure SolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
    procedure CheckBtnClick(Sender: TObject);
    procedure BoxClick(Sender: TObject);
    procedure ResetBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OptionBtnClick(Sender: TObject);
  public
    nums:array[1..4] of TNumset;
    solution:integer;
    attempts: integer;
    correct:single; {score counters}
    solved: boolean;
    firstguess:boolean; {true until user makes an incorrect guess}
    boxes:array[1..6] of TListBox;

    function tryset(numsetindex, numComboNbr, opComboNbr:integer;
                       var op1,op2:char; var ans:integer):boolean;
    function applyop(x1:integer; op:char; x2:integer):integer;
    procedure setinit;
  end;

var
  Form1: TForm1;
  rewardlevel:single;
  ProblemsPerSet:integer;
  MaxVal:Integer;
  UsePlus,UseMinus,UseTimes,UseDivide:boolean;
  opset:set of char; {the available operation choices}

const
  divide=char($F7);
  times=char($D7);

implementation
{$R *.DFM}
Uses UMakeCaption, UReward, IniFiles, U_SetOptions;



type
  tchoices=record
    op1,op2:char;  {1st and 2nd operations}
    oprange:array[1..3] of TPoint; {min/max for the 3 operands}
  end;

var
    {array of operator combination possibilities
     with generated ranges for each - used in creating random problems}
    Opselect:array[0..15] of Tchoices=
    ((op1:'+';op2:'+';oprange:((x:1;y:20),(x:1;y:20),(x:1;y:20))),
     (op1:'+';op2:'-';oprange:((x:1;y:9),(x:1;y:9),(x:1;y:9))),
     (op1:'+';op2:Times;oprange:((x:1;y:5),(x:1;y:5),(x:1;y:5))),
     (op1:'+';op2:Divide;oprange:((x:1;y:9),(x:1;y:9),(x:1;y:10))),
     (op1:'-';op2:'+';oprange:((x:8;y:20),(x:1;y:7),(x:1;y:10))),
     (op1:'-';op2:'-';oprange:((x:10;y:20),(x:1;y:9),(x:1;y:9))),
     (op1:'-';op2:Times;oprange:((x:10;y:20),(x:1;y:10),(x:1;y:5))),
     (op1:'-';op2:Divide;oprange:((x:10;y:20),(x:1;y:10),(x:1;y:10))),
     (op1:Times;op2:'+';oprange:((x:1;y:8),(x:1;y:8),(x:1;y:6))),
     (op1:Times;op2:'-';oprange:((x:1;y:8),(x:1;y:8),(x:1;y:6))),
     (op1:Times;op2:Times;oprange:((x:1;y:8),(x:1;y:8),(x:1;y:6))),
     (op1:Times;op2:Divide;oprange:((x:1;y:8),(x:1;y:8),(x:1;y:6))),
     (op1:Divide;op2:'+';oprange:((x:10;y:20),(x:1;y:8),(x:1;y:9))),
     (op1:Divide;op2:'-';oprange:((x:10;y:20),(x:1;y:8),(x:1;y:9))),
     (op1:Divide;op2:Times;oprange:((x:10;y:20),(x:1;y:8),(x:1;y:9))),
     (op1:Divide;op2:Divide;oprange:((x:10;y:20),(x:1;y:8),(x:1;y:9)))
    );

  {the 24 combinations of the digits 1-4 used to generate
  all possible orderings of the 3 variables & the answer within
  each panel - just the lazy man's way of creating them}
  combos:array[1..24] of array[1..4] of integer=
  (
  (1,2,3,4),(1,2,4,3),(1,3,2,4),(1,3,4,2),(1,4,2,3),(1,4,3,2),
  (2,1,3,4),(2,1,4,3),(2,3,1,4),(2,3,4,1),(2,4,1,3),(2,4,3,1),
  (3,1,2,4),(3,1,4,2),(3,2,1,4),(3,2,4,1),(3,4,1,2),(3,4,2,1),
  (4,1,2,3),(4,1,3,2),(4,2,1,3),(4,2,3,1),(4,3,1,2),(4,3,2,1)
  );

  opstring:string='+-*/';  {the four operations}

{******************* FormActivate *****************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  makecaption('Equation Search',#169+' 2002  G Darby, www.delphiforfun.org',self);
  boxes[1]:=v1box; boxes[2]:=o1box; boxes[3]:=v2box;
  boxes[4]:=o2box; boxes[5]:=v3box; boxes[6]:=ansbox;

  attempts:=0;
  correct:=0.0;
  randomize;
  generatebtnclick(sender);
  solvebtnclick(sender);
  attempts:=0; {don't count the initial sample problem}
  problbl.caption:='Problem 0 of '+inttostr(Problemsperset);
  ScoreLbl.caption:=format('Score: %4.1f of %2d',[correct,attempts]);
  InstructLbl.caption:='SAMPLE, Click "Generate" button to start';

end;


{************************* ApplyOp *****************}
function TForm1.applyop(x1:integer; op:char; x2:integer):integer;
{apply operation to two operands and return result}
  begin
    case op of
      '+': result:=x1+x2;
      '-': result:=x1-x2;
      Times: result:=x1*x2;
      Divide: result:= x1 div x2;
      else result:=0;
    end;
  end;

{********************* Tryset ***************}
function TForm1.tryset(numsetindex, numComboNbr, opComboNbr:integer;
                       var op1,op2:char; var ans:integer):boolean;
{see if the set of numbers defined by numsetindex is a valid equation when
 operations specified by opComboNbr are applied. Return op1 and op2 and ans
 if true}

var  x:integer;
begin
  x:=nums[numsetindex][combos[numcombonbr,1]];
  op1:=OpSelect[opcombonbr].op1;
  x:=applyop(x,op1,nums[numsetindex][combos[numcombonbr,2]]);
  op2:= opselect[opcombonbr].op2 ;
  x:=applyop(x,op2,nums[numsetindex][combos[numcombonbr,3]]);
  result:=x=nums[numsetindex][combos[numcombonbr,4]];
  ans:=x;
end;

{****************** SolveBtnClick *************}
procedure TForm1.SolveBtnClick(Sender: TObject);

   procedure showresult(n,j,k:integer; lbl:TLabel);
   var x:integer;
       op1,op2:char;
   begin
      tryset(n,j,k,op1,op2,x);
      lbl.caption:='('+inttostr(nums[n,combos[j,1]])+op1
                      +inttostr(nums[n,combos[j,2]])+')'+op2
                      +inttostr(nums[n,combos[j,3]])+' = ' +inttostr(x);
   end;

  {Local procedure ****** buildnums ********}
  procedure buildnums(p:TPanel; index:integer);
  var i,j:integer;
  begin
    j:=0;
    with p do
    begin
      for i:=0 to controlcount-1 do
      if controls[i] is TEdit then
      begin
        inc(j);
        nums[index,j]:=strtoint(TEdit(Controls[i]).text);
      end;
    end;
  end;

var
  i,j,k:integer;
  Yes:boolean;
  op1,op2:char;
  x:integer;
begin
  buildnums(panel1,1);
  buildnums(panel2,2);
  buildnums(panel3,3);
  buildnums(panel4,4);
  Label1.caption:='...'; Label2.caption:='...';
  Label3.caption:='...'; Label4.caption:='...';
  j:=1;  {number arrangement}
  Yes:=false;
  while (j<24) and (not yes) do
  begin
    k:=0; {operation arrangement, 16 arrangements of 2 operations}
    while (k<16) and (not yes) do
    begin
      i:=1;
      while (i<=4)  do {try all 4 sets of numbers}
      begin
        yes:= tryset(i,j,k, op1,op2, x);
        If not yes then break
        else inc(i);
      end;
      if not yes then inc(k);
    end;
    if not yes then inc(j);
  end;
  if yes then
  begin
    solved:=true;
    Showresult(1,j,k,label1);
    Showresult(2,j,k,label2);
    Showresult(3,j,k,label3);
    Showresult(4,j,k,label4);

    with panel5 do
    begin
      V1Box.itemindex:=combos[j,1]-1;
      V2Box.itemindex:=combos[j,2]-1;
      V3Box.itemindex:=combos[j,3]-1;
      AnsBox.itemindex:=combos[j,4]-1;
      case op1 of
        '+':  O1Box.itemindex:=0;
        '-': O1Box.itemindex:=1;
        Times: O1Box.itemindex:=2;
        Divide:o1Box.itemindex:=3;
      end;
      case op2 of
        '+':  O2Box.itemindex:=0;
        '-': O2Box.itemindex:=1;
        Times: O2Box.itemindex:=2;
        Divide:O2Box.itemindex:=3;
      end;
      BoxClick(sender);
      {user gave up, so update the score anyway}
      ScoreLbl.caption:=format('Score: %4.1f of %2d',[correct,attempts]);
    end;
  end
  else showmessage('No solution found');
end;


 {**************** GenerateBtnClick *************}
procedure TForm1.GenerateBtnClick(Sender: TObject);
{Create a new random problem}
var
  v:array[1..4,1..4] of integer;
  position:array[1..4] of integer;
      {Local procedure ******* SetNums ******8}
      procedure setnums(p:TPanel; index:integer);
      {fill in the display values with the generated numbers}
      var i,j:integer;
      begin
        j:=0;
        with p do
        begin
          for i:=0 to controlcount-1 do
          if controls[i] is Tedit then
          begin
            inc(j);
            Tedit(Controls[i]).text:=inttostr(v[index,position[j]]);
          end;
        end;
      end;

var
  i,k,n,r,r1,r2,prevr,check:integer;
  OK:boolean;
  count:integer;

begin  {GenerateBtnClick}
  {select a  random equation and generate 4 instances}
  {instances must meet 3 criteria
    1. result>0
    2. result<=99
    3. result must be an integer
   }
   repeat
     repeat r1:=random(4) until opselect[4*r1].op1 in opset;
     repeat r2:=random(4) until opselect[4*r1+r2].op2 in opset;
     n:=4*r1+r2;
     k:=0;
     with Opselect[n] do
     repeat
       inc(k);
       count:=0;
       repeat
         OK:=true;
         for i:=1 to 3 do v[k,i]:=random(oprange[i].y-oprange[i].x)+oprange[i].x+1;
         r:=v[k,1];
         prevr:=r;
         case op1 of
           '+': r:=r+v[k,2];
           '-': r:=r-v[k,2];
             Times: r:=r*v[k,2];
             Divide: r:=r div v[k,2];
         end;
         if op1<>Divide then check:=prevr else check:=r*v[k,2];
         if (r<=0) or (r>maxval) or (prevr<>check) then OK:=false
         else
         begin
           prevr:=r;
           case op2 of
             '+': r:=r+v[k,3];
             '-': r:=r-v[k,3];
             Times: r:=r*v[k,3];
             Divide: r:=r div v[k,3];
           end;
           if op2<>Divide then check:=prevr else check:=r*v[k,3];
           if (r<=0) or (r>maxval) or (prevr<>check) then OK:=false
         end;
         v[k,4]:=r;
         inc(count); {we'll try 1000 times before giving up}
       until (OK) or (count>1000);
     until (k=4) or (count>1000);
   until OK and (count<=1000);
   {now assign the 4 variables randomly to the 4 positions}
   for i:=1 to 4 do position[i]:=i; {get numbers 1,2,3,4}
   for i:=1 to 100 do  {scramble them by making 100 random swaps}
   begin
     r1:=random(3)+1;
     repeat r2:=random(3)+1 until r2<>r1;
     k:=position[r1];
     position[r1]:=position[r2];
     position[r2]:=k;
   end;
   with panel5 do
   begin
   end;
   setnums(panel1,1);
   setnums(panel2,2);
   setnums(panel3,3);
   setnums(panel4,4);
   Label1.caption:='...'; Label2.caption:='...';
   Label3.caption:='...'; Label4.caption:='...';
   inc(attempts);
   ProbLbl.caption:='Problem '+inttostr(attempts)+' of '+inttostr(Problemsperset);
   InstructLbl.caption:='Click 4 variables and 2 operations to form an equation '
                         +'that is satisfied by the number sets above';
   solved:=false;
   firstguess:=true;  {reset first guess flag}
   {reset score label}
   for i:=1 to 6 do boxes[i].itemindex:=-1;
   boxclick(sender); {display the equation}
end;

{***************** CheckBtnClick **************}
procedure TForm1.CheckBtnClick(Sender: TObject);
{Check an equation for correctness}
var
  pos:array[1..6] of integer; {item indices of the six listboxes}
  v:array[0..3] of integer; {four values to be evaluated}

    {Local procedure ******* BuildNums *****}
    procedure buildnums(p:TPanel);
    {extract a set of numbers into array "v" from a panel}
      var i,j:integer;
      begin
        j:=-1;
        with p do
        begin
          for i:=0 to controlcount-1 do
          if controls[i] is TEdit then
          begin
            inc(j);
            v[j]:=strtoint(Tedit(Controls[i]).text);
          end;
        end;
      end;

    {Local procedure ******** Check *******}
    function check(p:TPanel):boolean;
    {check the equation}
    var ans:integer;
    begin
      buildnums(p); {extract a set of values}
      {evaluate expression}
      ans:=applyop(applyop(v[pos[1]],o1box.items[pos[2]][1],v[pos[3]]),
                         o2box.items[pos[4]][1],v[pos[5]]);
      result:= ans=v[pos[6]]; {check if expression = desired answer}
    end;

var
  OK:boolean;
  i:integer;
  msg:string;
begin  {checkBtnClick}
  OK:=true;
  for i:=1 to 6 do
  with boxes[i] do
  begin
    if itemindex<0 then
    begin OK:=false; break;  end;
    pos[i]:=itemindex; {just a shorthand place to hold the index values}
  end;

  if OK then
  begin
    {make sure that same variable is not selected more than once}
    if (pos[1]=pos[3]) or (pos[1]=pos[5]) or (pos[1]=pos[6])
       or (pos[3]=pos[5]) or (pos[3]=pos[6]) or (pos[5]=pos[6])
    then Showmessage('Sorry, each variable must occur exactly one time')
    else
    begin
      OK:=check(panel1);
      if OK then check(panel2);
      If OK then check(panel3);
      if OK then check(panel4);
      if not OK then
      begin
        showmessage('Sorry');
        firstguess:=false;
      end
      else
      begin   {solved it!}
        if (not solved) then
        begin
          If firstguess then
          begin
            msg:='You got it!';
            correct:=correct+1.0
          end
          else
          begin
            msg:='Correct, but only half credit for multiple guesses';
            correct:=correct+0.5; {only half credit if it took more than one guess}
          end;
          if (attempts>=problemsPerSet) then
          begin
            if (correct/attempts>=rewardlevel) {10 problems tried, deliver reward}
            then
            begin
              showmessage(msg);
              rewarddlg.showmodal;
            end
            else showmessage(msg+
               #13+'Nice try on this set of problems, but I''m sure you can do better.');
            resetbtnclick(sender);
          end
          else showmessage(msg);
          solved:=true;
        end
        else showmessage('Hey! No extra credit for solving twice!');
        ScoreLbl.caption:=format('Score: %4.1f of %2d',[correct,attempts]);
        generatebtnclick(sender);
      end;
    end;
  end
  else showmessage('Oh no, I''m not going to fill in those blanks for you!');
end;


{************* BoxClick *************}
procedure TForm1.BoxClick(Sender: TObject);
{User clicked a Listbox to form equation, display the equation}
var
  i:integer;
  val:array[1..6] of char;
begin
  for i:=1 to 6 do
  with boxes[i] do if itemindex<0 then val[i]:='_' else val[i]:=items[itemindex][1];
    EqLbl.caption:='( '+val[1]+'      '
                  + val[2] +'      ' + val[3]+' )    ' + val[4]+'     '
                  + val[5] +'  =  ' + val[6];
end;

{*************** ResetBtnCloick *************}
procedure TForm1.ResetBtnClick(Sender: TObject);
{reset the score}
begin
  ScoreLbl.caption:= ' Score: 0 of 0';
  attempts:=0;
  correct:=0.0;
  generatebtnclick(sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin setinit; end;


procedure Tform1.Setinit;
{read/initialize then init file}
var
  ini:TInifile;
begin
  ini:=TInifile.create(extractfilepath(application.exename)+'EquSearch.ini');
  opset:=[];
  {Insert special characters for multiple and divide}
  o1box.items[2]:=times; o1box.items[3]:=Divide;
  o2box.items[2]:=times; o2box.items[3]:=Divide;
  with ini do
  begin
    if ReadBool('General','UsePlus',true) then opset:=opset+['+'];
    if ReadBool('General','UseMinus',true) then opset:=opset+['-'];
    if ReadBool('General','UseTimes',true) then opset:=opset+[Times];
    if ReadBool('General','UseDivide',true) then opset:=opset+[Divide];
    ProblemsPerSet:=readInteger('General','ProblemsPerSet',10);
    rewardlevel:=ReadFloat ('General', 'RewardLevel',0.75);
    MaxVal:=ReadInteger('General','MaxVal',99);
  end;
  ini.free;
  if not (divide in opset)
  then begin o1box.items.delete(3); o2box.items.delete(3); end;
  if not (times in opset) then
  begin o1box.items.delete(2); o2box.items.delete(2); end;
  if not ('-' in opset) then
  begin o1box.items.delete(1); o2box.items.delete(1); end;
  if not ('+' in opset) then
  begin o1box.items.delete(0); o2box.items.delete(0);  end;
  if o1box.items.count<1 then
  begin
    Showmessage('No operations available, program halted');
    halt;
  end;


end;

procedure TForm1.OptionBtnClick(Sender: TObject);
begin
  If Form2.showmodal=mrOK
  then setinit;

end;

end.

