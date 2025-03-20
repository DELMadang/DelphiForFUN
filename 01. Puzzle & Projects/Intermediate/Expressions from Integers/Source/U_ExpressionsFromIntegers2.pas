unit U_ExpressionsFromIntegers2;

{Copyright  © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
  Insert + (plus) , - (minus),  * (times) and / (divide) signs and parentheses
  as required into a given set of source digits to form an expression that
  evaluates to the given Target value.

  Within parrens, operations will be performed in normal order of precedence
  (multiplcation and division before addition and subtrraction; left to right
  within equal precedence operatorsi).
                    //
  Division operations are allowed only if the resulting quotient is an exact integer.
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellapi, CheckLst, UGetParens, UCombov2, uParser10,
  jpeg, ExtCtrls, DFFutils
  ;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    Solversheet: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    SolveBtn: TButton;
    TargetEdt: TEdit;
    SourceEdt: TEdit;
    OpsBox1: TCheckListBox;
    PermuteBox: TCheckBox;
    ShowAllBox: TCheckBox;
    Image1: TImage;
    Memo2: TMemo;
    TabSheet1: TTabSheet;
    Memo3: TMemo;
    Solve2Btn: TButton;
    Image2: TImage;
    MultiInput: TMemo;
    Memo4: TMemo;
    Image4: TImage;
    SolutionBox1: TListBox;
    Label4: TLabel;
    Label5: TLabel;
    OpsBox2: TCheckListBox;
    Label6: TLabel;
    SolutionBox2: TListBox;
    procedure SolveBtnClick(Sender: TObject);
    procedure EdtKeyPress(Sender: TObject; var Key: Char);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Solve2BtnClick(Sender: TObject);
    public
      Parser:TCustomparser;
      Templates:TStringList;
      {Several adjustment must be made in solving the multiple box mode vs a single set:
       1. Single box puzzle can allow given numbers to be permuted because any set which
          leads to a solution is sufficient to complete the target figure.
       2, Mulitple box puzzles must follow a common arrangement since what solves one must solve all
       }
      MultiMode:boolean;
      Permutes:boolean;
      function GetVarCount(s:String):integer;
      procedure MakeExpressionTemplates(Varcount:integer;  Exp2list:TStringlist;
                                        opsbox:TCheckListBox);
      function Solve(varsource:string; Exp2List:TStringList;
                     SolutionBox:TListBox; var orderindex:array of integer):boolean;
  end;

var Form1: TForm1;

implementation

{$R *.DFM}
type Tarray=array of integer;


{************ FormCreate ***********8}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  setmemomargins(Memo2, 20,20,20,20);
  for i:=0 to 3 do
  begin
    opsbox1.Checked[i]:=true;
    opsbox2.checked[i]:=true;
  end;
  setMemoMargins(memo2,25,10,10,10);
  setMemoMargins(memo1,20,10,10,10);
  pagecontrol1.activepage:=Introsheet;
  Parser:=TCustomParser.create(self);
end;

function TForm1.GetVarCount(s:String):integer;
var
  VarList:TStringList;
begin
  VarList:=TStringlist.Create;
  varList.commatext:=s;
  result:=varlist.count-1;  {Input text includes the target, so subtract 1}
  Varlist.free;
end;

{************** TForm1.Solve1BtnClick ********}
procedure TForm1.SolveBtnClick(Sender: TObject);
{Solve the problem}
var
  i, num:integer;
  vars:string;
  varcount:integer;
  orderindex:array of integer;  {these are pointers to the order variables from
                                 varlist are inserted into the solution in case
                                 a permutaiton provifr the solution}
   varlist:TStringList;
   express:string;
begin
    solutionbox1.items.clear;
    screen.Cursor:=crHourGlass;
    if not assigned(Templates) then Templates:=TStringlist.Create
    else Templates.Clear;
    multimode:=false;
    vars:=sourceEdt.text;
    permutes:=permutebox.checked;
    varcount:=getvarcount(vars);
    MakeexpressionTemplates(varcount, Templates,  OpsBox1);
    setlength(orderindex,varcount);
    Solve(vars, Templates, SolutionBox1, orderindex);
    If templates.Count>0 then
    begin
      express:=templates[0];
      varlist:=TStringList.create;
      varlist.commatext:=targetedt.text;
      for i:=0 to varcount-1 do express:=stringreplace(express,'a',VarList[orderindex[i]],[]);

      parser.expression:=stringreplace(express,'/','DIVZ',[rfReplaceAll]);
      num:=trunc(parser.value);
      with solutionBox1.items do
      begin
        add('');
        add('Solution using last valid equation is: ');
        add( express  + ' = ' +inttostr(num));
      end;  
      varlist.free;
    end;
  end;


{************* Solve2BtnClick **************}
procedure TForm1.Solve2BtnClick(Sender: TObject);
var
  i, varcount, num:integer;
  orderIndex:array of integer;
  express:string;
  varlist:TStringlist;
begin
  solutionbox2.clear;
  multimode:=true;
  permutes:=true;
  with multiInput do
  begin
    for i:=0 to lines.count-2 do
    begin
      if i=0 then
      begin  {for the first line, genrate a complete set of expression templates}
             {after the first line, other liness will use the solution templates
             for the previous line}
        if not assigned(Templates) then Templates:=TStringlist.Create
        else Templates.Clear;
        varcount:=getvarcount(lines[i]);
        MakeexpressionTemplates(varcount, Templates,OpsBox2);
        setlength(orderindex,varcount);
      end;
      Solutionbox2.items.add(''); 
      Solutionbox2.items.add('Checking completed figure #'+inttostr(i+1));
      {Search for solutions}
      if not Solve(lines[i], Templates, SolutionBox2, orderindex) then
      begin
        showmessage('No solution found for line ' + lines[i] ) ;
        break;
      end;
      //permutes:=false;
    end;
    If templates.Count>0 then
      begin
        express:=templates[0];
        varlist:=TStringList.create;
        with lines do varlist.commatext:=strings[count-1];
        for i:=0 to varcount-1 do express:=stringreplace(express,'a',VarList[orderindex[i]],[]);

          //for i:=1 to varcount-1 do  express:=stringreplace(express,opchar,opslist[orderindex[i]],[]);
        parser.expression:=stringreplace(express,'/','DIVZ',[rfReplaceAll]);
        num:=trunc(parser.value);
        solutionBox2.items.add('Solution for last valid equation is: ');
        solutionbox2.items.add( express  + ' = ' +inttostr(num));
        varlist.free;
      end;
  end;
end;

{************ MakeExpressionTemplate ***************}
procedure TForm1.makeExpressionTemplates(Varcount:integer;  Exp2list:TStringlist;
                  opsbox:TCheckListBox);
      {Varcount is the list of variables}
      var
        i,j:integer;
        variables, express:string;
        opchar:char;
        Exp1List, Opslist:TStringList;
    {Phase 1:}
    {make Exp1List with all parenthesized arrangements of variables with  'a's
    where the variable values wil be and and '?'s where the operations will be insterted}
    {'(a?a)?a' for example}
    begin
      opchar:='?';
      setlength(variables,varcount);

      for i:=0 to varcount-1 do variables[i+1]:='a'; {let 'a's stand for permuted variable values}
      Exp1List:=TStringList.create;
      GetParens(variables,opchar,Exp1List); {generate all templates}

      {Make an operations list in case user has unchecked some choices}
      OpsList:=TStringlist.Create;
      with OpsBox do for i:=0 to items.Count-1 do if checked[i] then opslist.Add(items[i]) ;
      with combos do
      begin

      {Phase 2}
        {Now we'll permute the operations and insert them into the expressions built in Phase 1
         and evaluate them by passing the completred expression to Parser}
        if tag=0 then
        begin
          setup(varcount-1,opslist.Count,PermutationsRepeat);   {Permute all selected operations, with repeats,
                                   one less than the number of variables, (n-1) ,at a time}
          while getnext do {get next operation arrangement}
          begin
            for j:= 0 to Exp1List.count-1 do
            begin {apply current arrangement of operations to previously built expression templates}
              //inc(loopcount);
              express:=Exp1List[j];  {for each expression template}
              {replace the '?'s with permuted operations}
              for i:=1 to varcount-1 do  express:=stringreplace(express,opchar,opslist[selected[i]-1],[]);
              Exp2List.add(express); {and save it in Exp2List}
            end;
          end;
        end;
      end;
    end;

const
  ops=['+','-','*','/'];

{************** Solve *************}
function TForm1.solve(varsource:string ; exp2list:TStringList;
                      solutionBox:TListbox; var orderindex:array of integer):boolean;
  var
    i,j,num:integer;
    n:integer;
    target:integer;
    loopcount:integer;
    s:string;
    express:string;
    VarList, Exp3List, TrialsList, solutionsList:TStringlist;


        function fixup(exp:string):string;
        var
          s:string;
        {rearrange numbers in the expression to a standard format by exchanging
         operands if necessary so that smaller is first for + and *}

           procedure fixop(var s:string; op:char);
           var
             i:integer;
           begin
             (*
             OK:=true;
             for i:=1 to length(s) do
             if (s[i] in ops) and (s[i]<>op)
             then
             begin
               OK:=false;
               break;
             end;
             if OK then
             begin {extract numbers, sort them, re-inset op between each}
               count:=0;
               maxcount:=0;
               for i:=1 to length(s) do if s[i] ['0'..'9'] then inc(count)
               else
               begin
                 s[i]:=' ';
                 if count>maxcount then maxcount:=count;
                 count:=0;
               end;
               list:=tstringlist.create;
               list.commatext:=s;
               for i:= 0 to list.count-1 do if length(list[i])< maxcount
               list[i]:= stringofchar('0', maxcount-length(list[i]))+list[i];
               list.Sort;


               if s[i]in ['(','(']
               then  delete(s,i,1);
               for i:=1 to length(s) do
           *)
             end;



        begin {fixup  - not ready yet!}
          s:=exp;
          {1. look for pattern '(a+b)' or '(a*b)' and swap a & b if >a}
          fixop(s,'+');
          fixop(s,'*');
          result:=s;

          {2. if only operator  is "+" or '*", resort all values in ascending sequence)}
          (*
          repeat
            if (not inop1) and (exp[i]='(') then
            begin
              inop1:=true;
              op1:='';
              goodop:=false;
              op2:='';
              inc(i)
              while (i<( length(exp) and (exp[i] in ['0'..'9']) do
              begin
                op1:=op1+exp[i];
                inc(i);
              end
              else if exp][i] in ['+', '*' ] then goodop:=true;
              else if exp[i]=')'
            ;              if exp[i] in ['0'..'9'] then
                if op1='' then op1:=op1+exp[i]
                else op2:=op2+;
            n:=posex(
          *)
        end;


  begin {Solve}
    result:=false;
    VarList:=TStringlist.Create;
    with varlist do
    begin
      CommaText:=varsource;
      target:=strtoint(strings[count-1]);
      varlist.delete(count-1);
    end;
    N:=VarList.count; {nbr of terms}
    Exp3List:=TStringlist.create;
    TrialsList:=TStringList.create;
    solutionslist:=TStringlist.create;

    with combos do
    begin
      {permute the "n" variable values}
      setup(n,n,permutations);
      loopcount:=0;
      while getnext do
      begin {For each permutation of variable values}
        for j:=0 to Exp2List.count-1 do  {for each parenthesized template of opearions }
        begin
          express:=Exp2List[j];
          {replace the 'a's left to right in the expression template with the permuted values}
          for i:=1 to n do express:=stringreplace(express,'a',VarList[selected[i]-1],[]);
          inc(loopcount);
          {pass the expression to the parser changing '/' to DIVZ to force integer division}
          parser.expression:=stringreplace(express,'/','DIVZ',[rfReplaceAll]);
          num:=trunc(parser.value);

          if num=target then
          begin { WE HAVE A SOLUTION}
            fixup(express);
            for i:= 1 to n do orderindex[i-1]:=selected[i]-1;
            express:=express+'='+inttostr(num); {convert the expression to an equation }
            if solutionsList.indexof(express)<0 then
            begin  {new solution}
              s:='Solution !!!!!!!';
              solutionbox.items.add(express+' valid equation');
              solutionsList.add(express);
              exp3list.add(exp2list[j]);  {These are the templates that further number sets can use}
            end
            else s:='';
          end
          else s:='';
          if (not multimode) and showallbox.Checked and (trialslist.count<100)
          then TrialsList.add(express+s);   {Save all equations tested (up to 100)}
        end;
        {if not permuting the values, we're done with this phase}
        if (not permutes) then break;
      end;
      with solutionsList do
      begin
        insert(0, Inttostr(loopcount) +' Expressions tested'+s);
        if (loopcount>100) and showallbox.checked  and (not multimode)
        then
        begin
          insert(1,'Only first 100 displayed.');
        end;
        If count=0 then solutionbox.items.add('No valid equations found')
        else
        begin
          solutionbox.items.add(Inttostr(count-1) +' valid equation(s) found');
          result:=true;
        end;
      end;

      if (not multimode) and showallbox.checked then
      with solutionbox.items do
      begin
        add('');
        add('All tested equations');
        for i:= 0 to TrialsList.count-1 do add(TrialsList[i]);
      end;
    end;
    exp2list.text:=exp3list.text;  {return only the templates that led to solutions}
                    {These will used as template after the initial solve if
                     multiple sets are being evaluated}
    exp3list.free;
    varlist.free;
    TrialsList.free;
    solutionsList.Free;
    screen.cursor:=crdefault;
  end;

{*************** TForm1.TargetEdtKeyPress ***********}
procedure TForm1.EdtKeyPress(Sender: TObject; var Key: Char);
{make sure only digits (or backspace) are entered in the edit field}
begin
  If not (key in ['0'..'9',',',' ',#8]) then
  begin
    key:=#0;
    beep
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;





end.
