unit U_SolveUnit;
 {Copyright 2002, 2016 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Logic Problem Solver}
 {See program or www.delphiforfun.org/programs/logic_problem_solver.htm for more
  information.  U_SolveUnit processes input prepared by U_Logic and applies logic
  rules to fill truth tables for each pair of variables}


{,,,$DEFINE DEBUG} {remove ,,, to define conditional compilation symbol DEBUG}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, UComboV2, ComCtrls,  shellAPI, DFFUtils, ExtCtrls;

Const
      maxfacts=300;
      MaxVars=20;
      Maxcombos=MaxVars*maxVars;
Type
  Tnames= array[1..MaxVars*maxvars] of string[20];
  TRule=(Order,SEPARATION);
  {A fact string is a string that is one character longer than the number of
   variables  - the first nbrvar positions correspond to the variables, the final
   character is T or F corresponding to True or False value for the fact.  Each
   of the variable positions contains an "X" or a value number for the variable
   corresponding to that position.  A valid fact will have 2 value numbers and
   end in T or F.  For example X4X1F says that The 4th value of the 2nd variable
   (2nd position in rule) is not associated with the 1st value of the
   4th variable (4th position) in rule}
  TFactString=String[MaxVars+1];
  TChoiceString=String[maxvars+3];
  TFact=record
    F:TFactString;
    FactID:string;
    Enabled:boolean;
    Used:boolean;
  end;

  TChoice=record
    Choiceid:string;
    C:TChoiceString;
    Enabled:Boolean;
    Used:Boolean;
  end;
  TBaseArray=array of array of char; //[1..MaxVars,1..MaxVars] of char;
  TstatArray=array of TBAseArray;

  TOrderRule = record
          OrderId:string;
          R1:TFactstring;
          R2:TFactString;
          Diff:integer;
          VarPos1,VarPos2,CompPos:integer;
          RType:Trule;
          TrueValue:Boolean;
          Enabled:boolean;
          Used:boolean;
        end;

  TIfRule=record
    RuleID:string;
    IfPart, Thenpart: TFactString;
    Enabled:boolean;
    Used:boolean;
  end;

  TGame4=class(Tobject)
     {3 dimensional truth table for all pairs of variables}
     {1st dimension is the combination number assigned to each variable pair,
      2nd and 3rd dimensions are column and row indeices for the 2 variables}
     TruthTable:TStatArray;
     {Reasons = array of reasons for each cell in each truth table}
     Reasons: array of array of array of string;//array[1..maxvars*maxvars, 1..maxvars, 1..maxvars] of string;
     Names:array[1..MaxVars] of TFactString;
     Labels:array[1..MaxVars] of string[20];
     Facts:Array [1..maxfacts] of TFact;
     NbrFacts:integer;
     IfRules:array[1..maxfacts] of TIfRule;
     NbrIfRules:integer;
     Orderrules:array[1..maxfacts] of TOrderRule;
     NbrOrderRules:integer;
     Choices:array[1..maxfacts] of TChoice;
     NbrChoices:integer;

     ComboIndex:Array of array[1..2] of integer;
     Combonames:TNames;
     haltflag:boolean;
     InReductio:boolean;{True while checking for contradictions (Reductio ad absurdun}
     LogMsgCount:integer;
     Function Init:boolean;
     Procedure halt(err:integer);
     Function  Lookup(Fact:TFactString;pos:integer):Integer;
     Function  ComboLookup(i1,i2:integer):Integer;
     Procedure Setfact(s:TFactString;ID:String);
     Function  RuleExists(r:TFactString):Boolean;
     Procedure SetIfRule(s1,s2:TFactString; id:string);
     Procedure SetOrderRule(NRuleType:TRule;NewOrderid:string;
                              s1,s2:TFactString; D,WRT:integer;T:Boolean);
     Procedure SetChoice(s:TChoiceString; NewChoiceID:String);
     Function  ApplyFact(Fact:TFact;msg:string; reporterrors:boolean):integer;
     Procedure SetName(N:integer;Namestring:TFactString;labelstring:string);
     Procedure Solveit;
     Function  GetProblem:boolean;
     Function  makeExpanded(Fact:string):string;
     Function  StatToText(i,j,k:integer):string;
     Function  StatToTextWithDefault(i,j,k:integer; default:string):string;
     Function  StatToTextInverse(i,j,k:integer):string;
     Function  FactToText(fact:string):string;
     Function  Setcomboindex:boolean;
     Procedure PrintArray(s:string;code:integer);
     Procedure UpdateTruthtable(index,c,r:integer; TF:char;reason:string);
     Procedure TempUpdateTruthtable(index,c,r:integer; TF:char);
     procedure updateTables;
     procedure AddToLog(tablenbr,col,row:integer; r:string);
   end;


  Var
    NbrCombos:integer=0;
    NbrVars:integer=0;
    NbrValues:integer=0;
    Game:TGame4;

type
  TVariableType=class(Tobject)
    Name:string;
    Values:TStringlist;
    Numtype:boolean;
    numvalue:integer;
  end;

  TSolveForm = class(TForm)
    ResultsGrid: TStringGrid;
    TablesBtn: TButton;
    GenIfBtn: TButton;
    StaticText1: TStaticText;
    LogBtn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure VarSelectGridClick(Sender: TObject);
    procedure TablesBtnClick(Sender: TObject);
    procedure GenIfBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure LogBtnClick(Sender: TObject);
  public
    Procedure GenerateIfRules(n:integer);

  end;

{--------- Adjustwidth ------------}
  Procedure AdjustWidth(Grid:TStringgrid; acol,arow:integer);

  var
    SolveForm: TSolveForm;
    solvelist:TStringlist;
    usedlist:TStringList;
    SolutionArray: array[1..MaxVars,1..MaxVars]of char;
    Variables:TStringList;

implementation
  Uses U_PrintTables, U_Show_If, U_LogForm, U_Logic
  ;

{$R *.DFM}




    {Local ***********  Adjustwidth *********}
    Procedure AdjustWidth(Grid:TStringgrid; acol,arow:integer);
    {adjust stringgrid column width based on a specified cell}
    var len:integer;
    Begin
      len:=Grid.canvas.Textwidth(Grid.cells[acol,arow])+20;
      with Grid do
      if len>colwidths[acol]
      then colwidths[acol]:=len;
    end;

    procedure Tgame4.updatetables;
    var i,j,k,n:integer;
    begin
      if nbrvars>nbrvalues then n:=nbrvars else n:=nbrvalues;
      setlength(truthtable, nbrcombos+1,n+1, n+1);
      setlength(reasons,nbrcombos+1, n+1,n+1);
      For i:= 1 to nbrcombos do
      For j:= 1 to n do
      For k:= 1 to n do
      begin
        TruthTable[i,j,k]:='U'; {initialize all to Unknown}
        reasons[i,j,k]:=' ';
      end;
    end;


    {******************* StatToText ****************}
     Function TGame4.StatToText(i,j,k:integer):string;
     {create readable representation of truthtable cell at [i,j,k]}
     var
       conj:string;
       s,s2:string;
       r:integer;
     Begin
       r:=form1.getconnectrow(variables[comboindex[i,1]-1],
                              variables[comboindex[i,2]-1]);
       if TruthTable[i,j,k]='T'
       then conj:=' '+trim(form1.connectgrid.cells[1,r])+' '
       else
       if TruthTable[i,j,k]='F'
       then conj:=' '+trim(form1.connectgrid.cells[2,r])+' '
       else conj:=' T/F Unknown ';
       if comboindex[i,1]>0 then
       begin
         If form1.explainwithvar.checked then
         begin
           s:=variables[comboindex[i,1]-1]+' [';
           s2:=']';
         end
         else
         begin
           s:='';
           s2:='';
         end;

         with variables.objects[comboindex[i,1]-1]as tvariabletype
        do s:=s+ values[j-1]+s2;

        s:=s+' '+conj+' ';
        If form1.explainwithvar.checked then  s:=s+variables[comboindex[i,2]-1]+' [';
        with variables.objects[comboindex[i,2]-1]as tvariabletype
        do s:='"'+s+ values[k-1]+s2+'"';
      end
      else s:='"Unknown" ';
      result:=s;
    end;

   {******************* StatToTextWithDefault ****************}
     Function TGame4.StatToTextWithDefault(i,j,k:integer; default:string):string;
     {Same as StatToText, but display a default T/F value if Truthtable
      value has not been resolved - used by SetIfRule to display generated IF rules}
     var
       conj:string;
       s,s2:string;
       r:integer;
     Begin
       r:=form1.getconnectrow(variables[comboindex[i,1]-1],
                              variables[comboindex[i,2]-1]);
       if (i<length(truthtable)) and (j<length(truthtable[0])) and (k<length(truthtable[0,0])) then
       begin
         if (TruthTable[i,j,k]='T')or (default='T')
         then conj:=' '+trim(form1.connectgrid.cells[1,r])+' '
         else
         if (TruthTable[i,j,k]='F') or (default='F')
         then conj:=' '+trim(form1.connectgrid.cells[2,r])+' '
         else conj:=' T/F not set ';
       end
       else
       if default = 'T' then conj:=' '+trim(form1.connectgrid.cells[1,r])+' '
       else if default = 'F' then conj:=' '+trim(form1.connectgrid.cells[2,r])+' '
       else conj:=' T/F not set ';

       if comboindex[i,1]>0 then
       begin
         {Explainwithvar.checked shows variable names w values in square brackets}
         If form1.explainwithvar.checked then
         begin
           s:=variables[comboindex[i,1]-1]+' [';
           s2:=']';
         end
         else
         begin
           s:='';
           s2:='';
         end;

        with variables.objects[comboindex[i,1]-1]as tvariabletype
        do s:=s+ values[j-1]+s2;

        s:=s+' '+conj+' ';
        If form1.explainwithvar.checked then  s:=s+variables[comboindex[i,2]-1]+' [';
        with variables.objects[comboindex[i,2]-1]as tvariabletype
        do s:='"'+s+ values[k-1]+s2+'"';
      end
      else s:='"Unknown" ';
      result:=s;
    end;

   {**************** StatToTextInverse ************}
    Function TGame4.StatToTextInverse(i,j,k:integer):string;
    {same as stattotext except 2nd variable returned as 1st in string,
     e.g. 'b was read by a' instead of 'a read b' }
     var
       conj:string;
       s,s2:string;
       r:integer;
     begin
       r:=form1.getconnectrow(variables[comboindex[i,1]-1],
                              variables[comboindex[i,2]-1]);
       if TruthTable[i,j,k]='F'
       then conj:=' '+trim(form1.connectgrid.cells[1,r])+' '
       else
       if TruthTable[i,j,k]='T'
       then conj:=' '+trim(form1.connectgrid.cells[2,r])+' '
       else conj:=' T/F value unknown ';
       if comboindex[i,1]>0 then
       begin
         If form1.explainwithvar.checked then
         begin
           s:=variables[comboindex[i,1]-1] +' (';
           s2:=')';
         end
         else
         begin
           s:='';
           s2:='';
         end;

         with variables.objects[comboindex[i,1]-1]as tvariabletype
         do s:=s+ values[j-1]+s2;

         s:=s+conj;
         If form1.explainwithvar.checked then
         begin
           s:=s+variables[comboindex[i,2]-1]+' (';
           s2:=')';
         end;
         with variables.objects[comboindex[i,2]-1]as tvariabletype
         do s:='"'+s+ values[k-1]+s2+'"';
       end
       else s:='"Unknown"';
       result:=s;
     end;

  {*************** Init **************}
  Function TGame4.init:boolean;
  Var i:integer;
  begin {init}
    if setcomboindex then
    begin
      {reset everything}
      setlength(truthtable,0,0,0);
      setlength(reasons,0,0,0);
      For i:= 1 to maxfacts do Facts[i].F:='     ';
      For i:=1 to NbrVars do labels[i]:='';
      NbrFacts:=0;
      NbrIfRules:=0;
      NbrOrderRules:=0;
      NbrChoices:=0;
      NbrVars:=0;
      NbrValues:=0;
      LogMsgcount:=0;
      logform.logmemo.Clear;
      haltflag:=false;
      result:=true;

    end
    else result:=false;
  end; {init}

  {************ Halt ***************}
   Procedure Tgame4.halt(err:integer);
     begin
       //Showmessage('Error:'+IntToStr(err));
       {printrules;}
       haltflag:=true;
     end;


{*************** FactToText ***************}
Function TGame4.FactToText(fact:string):string;
var
  j,j1,j2:integer;
  default:string;
begin
  result:=fact;
  for j:=1 to nbrcombos do
  if (fact[comboindex[j,1]] <> 'X') and (fact[comboindex[j,2]]<>'X') then
  begin
    j1:=lookup(fact,Comboindex[j,1]);
    j2:=lookup(fact,comboindex[j,2]);

    if length(fact)=nbrvars+1 then default:=fact[length(fact)]
    else default:='';
    if (j1>0) and (j2>0) then
    begin {GGD}
      result:=StattotextWithDefault(j,j1,j2,default);
      break;
    end;
  end;
end;

{**************** MakeExpanded *************}
  Function TGame4.makeExpanded(Fact:string):string;
     {Make an expanded printable version of a fact}
     var
       i,n,errcode:integer;
       s:string;
     begin
       if fact[length(fact)]='F' then s:=fact+ ': NOT['
       else  s:=fact+': [';
       for i:=1 to length(fact)-1 do
       begin
         if fact[i]<>'X' then
         begin
           val(fact[i],n,errcode);
           if errcode=0 then
           with variables.objects[i-1] as TVariabletype do
           begin
             s:=s+' '+values[n-1];
           end;
         end;
       end;
       s:=s+']';
       result:=s;
     end;


{****************** SetComboIndex ************}
Function TGame4.Setcomboindex:boolean;
var
  c:TComboSet;
  n:integer;
begin
   result:=true;
   c:=TComboset.create;
   C.Setup(2,NbrVars,Combinations);
   NbrCombos:={trunc}(c.getcount);

   If Nbrcombos>MaxCombos then
   begin
     Showmessage('Error - too many variables,'
                 +#13 + '  '+Inttostr(NbrVars)+ ' variables generate '
                      + inttostr(Nbrcombos) + ' combinations'
                 +#13 + '   only ' + inttostr(MaxCombos)
                      + ' combo slots  available');
     result:=false;
   end
   else
   begin
     setlength(comboindex, nbrcombos+1);
     //setlength(truthtable, nbrcombos+1);
     //setlength(reasons, nbrcombos+1);


     For n:=1 to Nbrcombos do
     begin
       c.getnext;
       Comboindex[n,1]:=c.selected[1];
       ComboIndex[n,2]:=c.Selected[2];
       ComboNames[n]:=labels[comboindex[n,1]]+':'+labels[comboindex[n,2]];
     end;
   end;
   c.free;
 end;


 Procedure TGame4.UpdateTruthtable(index,c,r:integer; TF:char;reason:string);
 begin
   truthtable[index,c,r]:=upcase(TF);
   {some updates have already been explained, so skip log if reason =''}
   if reason <>'' then AddToLog(index,c,r,Reason);
 end;

 Procedure TGame4.TempUpdateTruthtable(index,c,r:integer; TF:char);
 begin
   truthtable[index,c,r]:=upcase(TF);
   AddToLog(index,c,r,'Temp update');
 end;


var
  {Soution for Mystery Koeniga puzzle}
  solution:array[0..5,0..6] of integer=
                ((1,3,1,5,3,5,3), {LARA'S properties (first,last,age,start,end,morning locs, aft locs}
                 (2,4,3,4,2,6,4), {Laura's}
                 (3,6,5,6,6,3,5), {Lena's}
                 (4,5,2,1,1,2,1), {Lina's}
                 (5,2,6,2,5,1,2), {Louisa's}
                 (6,1,4,3,4,4,6)); {Luisa's}



procedure TGame4.AddToLog(tablenbr,col,row:integer; r:string);
begin
  inc(logmsgcount);
    logform.logmemo.Lines.Add(format('%6d Table %d (%s): Column %d (%s) Row %d (%s)',
    [logmsgcount, TABLENBR, variables[game.comboindex[tablenbr,1]-1]+' vs.'+variables[game.comboindex[tablenbr,2]-1],
     col,tvariabletype(variables.objects[game.comboindex[tablenbr,1]-1]).values[col-1],
     row,tvariabletype(variables.objects[game.comboindex[tablenbr,2]-1]).values[row-1]]));
  logform.logmemo.lines.add('        '+r);
  (*
  with game do
  begin
    var1:=comboindex[tablenbr,1]-1;
    var2:=comboindex[tablenbr,2]-1;
    val1:=col-1;
    val2:=row-1;
    r1:=0;
    for i:=0 to nbrvalues-1 do
    begin
      if solution[i,var1]=val1+1 then
      begin
        r1:=i+1;
        break;
      end;
    end;
    r2:=0;
    for i:=0 to nbrvalues-1 do
    begin
      if solution[i,var2]=val2+1 then
      begin
        r2:=i+1;
        break;
      end;
    end;
    if (r1>0) and (r1=r2)
    then OK:='T'
    else OK:='F';
    if OK=truthtable[tablenbr,col,row] then OK:=OK+':OK!'
    else ok:=OK+':ERROR!';
    logmemo.lines.Add(format('     Varval1:(:%d,%d), varval2:(%d,%d) , Solrows:(%d,%d), result=%s',
      [var1,val1,var2,val2, r1,r2, OK]));

  end;
  *)
end;


   {******************** GetProblem ********************}
   { Load problem from string list - originally loaded from file}
   Function Tgame4.GetProblem:boolean;
   var line:string;

   Function ValidRule4(s:string):Boolean;

     Function Lookup(pos:integer;test:char):Integer; {find value nbr }
     Var
       i:integer;
     begin  {lookup}
       i:=0;
       While (i<NbrValues) and (Names[pos,i]<>test) Do inc(i);
       If Names[pos,i]=test then lookup:=i else lookup:=0;
     end; {lookup}

   Var i:integer;
       t:Boolean;
   begin {ValidRule4}
     If length(s)=NbrVars then t:=true else t:=False;
     If t then
     For i:= 1 to NbrVars do if (lookup(i,s[i])=0) and (s[i]<>'X') then t:=false;
     Validrule4:=t;
   end; {ValidRule4}

   Function ValidRule5(s:String):Boolean;
   Var
     t:boolean;
   begin  {ValidRule5}
     if length(s)=NbrVars+1 then t:=true Else t:=false;
     If t then t:=validrule4(copy(s,1,NbrVars));
     If t then
       if not (s[NbrVars+1] in ['T','F']) then t:=false;
    Validrule5:=t;
   end; {ValidRule5}

   Function getword(var s,w:string):boolean;
   var i:integer;
   begin
     result:=false;
     if s[length(s)]<>' ' then s:=s+' '; {make sure it ends in blank}
     trimleft(s);
     i:=pos(' ',s);
     if i>0 then
     begin
       w:=ANSIUppercase(copy(s,1,i-1));
       delete(s,1,i);
       result:=true;
     end;
   end;


   Var
     id,value1,value2:string;
     ns:string;
     n,err,i,wrt:integer;
     t:boolean;
     w1,w2:string; {work strings}


   begin  {getProblem}
     result:=true;
     NbrVars:=0;
     for i:= 0 to solvelist.count-1 do
     begin
       line:=solvelist[i];
       if getword(line,value1) then
       begin
         if value1[1]<>'{' then
         begin
           If value1 ='NAME' then
           begin
             getword(line,ns);
             getword(line,value1);
             getword(line,value2);
             inc(NbrVars);
             val(ns,n,err);
             If (err <> 0) or (n>NbrVars) then Showmessage('Invalid # ('+ns+') in SETNAME')
             else
               If NbrValues=0 then
               begin
                 NbrValues:=length(value1);
                 //updatetables;
               end;
               If (length(value2)>0) then Setname(n,value1,value2)
               Else Showmessage('Invalid or missing name or label in SETNAME statement');
           end
           Else If value1='RULE' then
           begin
             getword(line,id);
             getword(line,value1);
             if validrule5(value1) then Setfact(value1,id)
             else Showmessage('Invalid value in Fact');
           end
           Else If value1='IFRULE' then
           begin
             {id:='If rule, Line '+inttostr(i);}
             getword(line,id);
             getword(line,value1);
             getword(line,value2);
             w1:=copy(value1,1,length(value1)-1);  {remove T/F for test}
             w2:=copy(value2,1,length(value2)-1);
             If validrule4(w1) then
             If validrule4(w2)
             then setifrule(value1,value2,id)
             else Showmessage('Second value in IFRULE ('+value2+') is invalid')
             else Showmessage('First value in IFRULE ('+value1+') is invalid');
           end
           Else If value1='ORDERRULE' then
           begin
             getword(line,id);
             Getword(line,value1);
             GetWord(line,value2);
             GetWord(line,ns);
             val(ns,n,err);
             getword(line,ns);
             val(ns,wrt,err);
             getword(line,ns);
             if uppercase(ns[1])='T' then t:=true else t:=false;
             setOrderRule(Order,id,value1,value2,n,wrt,t);
           end
           Else If value1='SEPARATIONRULE' then
           begin
             getword(line,id);
             Getword(line,value1);
             GetWord(line,value2);
             GetWord(line,ns);
             val(ns,n,err);
             getword(line,ns);
             val(ns,wrt,err);
             GetWord(line,ns);
             if ns[1]='T' then t:=true else t:=false;
             setOrderRule(SEPARATION,id,value1,value2,n,wrt,t);
           end
           else If value1='CHOICE' then
           begin
             getword(line,id);
             Getword(line,value1);
             SetChoice(Value1,id);
           end
           else Showmessage('Line not recognized:' + #13+ line);
         end; {s[1]<>'{'}
       end; {getword}
     end; {getline}
     //If not SetComboIndex then result:=false;
     updatetables;
   end; {getproblem}

   {********************* SetName**********************}
   Procedure TGame4.Setname(N:Integer;NameString:TFactString;labelstring:string);
   begin
     Names[N]:=NameString;
     labels[N]:=labelstring;
   end;

 {********************* Setfact ********************}
 Procedure Tgame4.Setfact(S:TFactString; ID:String);
 begin
   inc(NbrFacts);
   Facts[NbrFacts].F:=s;
   Facts[NbrFacts].FactID:=ID;
 end;

{*************** RuleExists ************}
 Function TGame4.RuleExists(r:TFactString):Boolean;
 Var i:integer;
 begin
   i:=1;
   While (i<=NbrFacts) and (Facts[i].F<>r) do inc(i);
   If i <= NbrFacts then RuleExists:=true
   Else RuleExists:=false;
 end;


 {******************* SetIfRule *******************}
 Procedure Tgame4.SetIfrule(S1,s2:TFactString; id:string);

   {Local ******* IfFound ***************}
   Function IfFound(r1,r2:TFactString):Boolean;
   Var i:integer;
       match:boolean;
   begin
     match:=false;
     For i := 1 to nbrifrules do
       If (Ifrules[i].ifpart = r1) and (IfRules[i].thenpart=R2) then match:=true;
     IfFound:=match;
   end;

 Var
   i,j:integer;
   index:integer;
   A1,b2:TFactString;
   NonXNonMatchCount:integer;
 begin {SetIfRule}
   inc(NbrIfrules);

   with Ifrules[NbrIfRules] do
   begin
     Ifpart:=s1;
     thenpart:=s2;
     ruleId:=id;
     {s1:=s1+'T'; s2:=s2+'T'
     if id[1]='O' then  {an order rule}
     begin
        id:=id+' Generated this';
        with ShowifForm.IfRulesMemo do lines.add(inttostr(lines.count+1)
             +': If '+ facttotext(s1)+' Then ' +facttotext(s2)
         +'  ('+id+')');
     end;

   {Check this rule against existing if rules}
   {1. if Fact a==>Fact b and Fact b==>Fact c then generate Fact a==>Fact c }
   {unless..
    2. unless if Fact a==>Fact b and Fact b==>Fact c but Fact a and Fact c
       can't both be true then generate Fact"a" + false   (By  Disjunction Elimination)

       I    not A or not C
       II   A --> B
       III  B --> C
       -------------- we can conclude
       ..  not A
       We can prove this by Contradiction (Reduction ad Absurdum
       From the transitive property of the "If" relation, II) and III) mean that
       A --> C.  If we assume that A is true, then C would also be true, but by
       I) they cannot both be true so A must be false. }

     If nbrifrules>1 then
     For i := 1 to nbrifrules-1 do
     begin
       Index:=0;
       If IfRules[Nbrifrules].IfPart=IfRules[i].thenpart then
       begin
         A1:=Ifrules[i].Ifpart;
         b2:=IfRules[NbrifRules].Thenpart;
         Index:=i;
       end
       Else If IfRules[Nbrifrules].ThenPart=IfRules[i].IfPart then
       begin
         A1:=Ifrules[i].Thenpart;
         b2:=IfRules[NbrifRules].IfPart;
         index:=i;
       end;
       If index>0 then
       begin
         NonXnonMAtchCount:=0;
         for j:=1 to NbrVars+1 {GDD 7/22/14} do

          If (A1[j]=B2[j]) and (a1[j]='X') then
          Else If a1[j]=b2[j] then
               Else Inc(nonXnonMatchCount);

         //If (A1[j]=B2[j]) and (a1[j]<>'X')  then Inc(nonXnonMatchCount);

         If (NonXNonMatchCount=1) and not RuleExists(copy(A1,1,nbrvars)+'F')
          then Setfact(copy(a1,1,nbrvars)+'F','SetIF:'+ifrules[index].ruleid);
       end;
     end;
   end;
 end;

 {********************* SetOrderRule *****************}
 Procedure TGame4.SetOrderRule(NRuleType:TRule;Neworderid:string;
                               S1,s2:TFactString; D,WRT:integer;T:Boolean);

     {Local function *********** ValidORule **********}
     Function ValidORule(r:TFactString; Var varpos,comppos:integer):boolean;
     {  Validate order rule:
        Edit Criteria:
          1. R1 and R2 both contain an "_" character in the same location
             then  - this is the compare position.
          2. R1 and R2 each contain 2 X's;
          3. Non X character is valid variable value for the position
             in which it occurs.
     }
     Var
       test:boolean;
       i:integer;
     begin
       test:=true;
       if length(r)=nbrvars then
       begin
         for i:=1 to length(r) do
         If r[i]<>'X' then
         begin
           varpos:=i;
           break;
         end;
         If lookup(r,varpos)=0 then
         begin
           showmessage('OrderRule: '+ R+':  invalid variable character');
           test:=false{true?};
         end;
       end
       else test:=false;
       result:=test;
     end;  {ValidORule}

    procedure GenerateOrderFact(r:TorderRule);
    var i:integer;
        s:string;
    begin
      with r do
      if truevalue then
      begin
        i:=1;
        while i<length(r1) do
        if r1[i]<>'X' then break else inc(i);
        if r2[i]='X' then {these are values for different variables}
        begin
          s:=copy(r2,1,nbrvars);
          s[i]:=r1[i];
          Setfact(s+'F',  Orderid);
          with ShowifForm.ifrulesmemo do lines.add(inttostr(lines.count+1)
                    +': ' +facttotext(s+'F') +'('+orderid +')');
        end;
      end;
    end;



    {Local procedure ***********  GenerateIfRules ************}
    Procedure GenerateIfRules(n:integer);
    {Generate all appropriate "if" rules from SEPARATION or Order Rule}
      Function validSub(n:integer):boolean;
      begin
        If (1<=n) and (n<=NbrValues) then validsub:=true
        Else validSub:=false;
      end;

    Var
      R:TOrderRule;
      NewFact1,NewFact2:TFactString;
      sub:integer;
      i:integer;
    begin
      r:=orderRules[n];
      With R do
      If Rtype=Order then
      begin
        If truevalue then
        begin
          if diff=0 then
          with ShowIfForm do
          begin
            {if difference can be any amount then all we know is that
             lower index is not last and higher index is not first}
            NewFact1:=r1+'F';


            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[compPos]:= Names[comppos,NbrValues];
              Setfact(NewFact1, Orderid {+  ' Lower value is not last'});
              IfRulesMemo.lines.add(inttostr(IfrulesMemo.lines.count+1)+': '+facttotext(newfact1) +'('+orderid +')');
            end;
            NewFact1:=r2+'F';
            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[CompPos]:=Names[Comppos,1];
              Setfact(NewFact1,Orderid {+' Higher value not first'});
              IfRulesMemo.lines.add(inttostr(IfrulesMemo.lines.count+1)+': ' +facttotext(newfact1) +'('+orderid +')');
            end;
            NewFact1:=r1;
            {If first part next to last, 2nd part must be last}
            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[Comppos]:= Names[Comppos,NbrValues-1];
              NewFact2:=r2;
              NewFact2[CompPos]:= Names[Comppos,NbrValues];
              SetIfRule(NewFact1+'T',NewFact2+'T', r.orderid);
            end;
            {If 2nd part is next to first; 1st part must be first}

            NewFact1:=r2;
            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[Comppos]:= Names[Comppos,2];
              NewFact2:=r1;
              NewFact2[CompPos]:= Names[Comppos,1];
              SetIfRule(NewFact1+'T',NewFact2+'T',r.orderid);
            end;
          end
          Else
          for i:= 1 to NbrValues do
          begin
            NewFact1:=R.r1;
            NewFact2:=R.r2;
            If validsub(I+diff)  then
            begin
              sub:=i+diff;
              NewFact1[Comppos]:= Names[Comppos,i];
              NewFact2[CompPos]:= Names[Comppos,sub];
              SetIfRule(NewFact1+'T',NewFact2+'T', r.orderid);
              SetIfRule(NewFact2+'T',NewFact1+'T',r.orderid);
              {r2 values within  diff of top can't be true}
              if (not validsub(i-diff)) then
              begin
                NewFact2[compPos]:=NewFact1[comppos];
                If not RuleExists(NewFact2+'F')
                then Setfact(NewFact2+'F', orderid {+' too close to top'});
              end;
            end
            {r1 values within diff of botttom can't be true}
            Else
            begin
              NewFact1[Comppos]:= Names[Comppos,i];
              If not RuleExists(NewFact1+'F')
              then Setfact(NewFact1+'F',orderid {+ ' Too close to bottom' });
            end;
          end;
          generateOrderfact(r); {A before/after B,  so gen fact "A is not B"}
        end
        else
        begin
          {handle false order rule here}
          showmessage('False order rules not yet handled')
        end;
      end {Order Rule}
      Else
      begin {SEPARATION rule}
        If truevalue then
        begin
          {items separated by and amount but we don't know which is first}
          {diff=0 makes no sense for SEPARATION rule}
          if diff=0 then showmessage('Difference of 0 makes no sense for Separation rule')
          else
          for i:= 1 to NbrValues do
          begin
            NewFact1:=R.r1;
            NewFact2:=R.r2;
            NewFact1[Comppos]:= Names[Comppos,i];
            If validsub(I+diff) and not validsub(i-diff) then sub:=i+diff
            Else if validsub(i-diff) and not validsub(i+diff) then sub:=i-diff
            else sub:=0;
            If sub >0 then
            begin
              NewFact2[CompPos]:= Names[Comppos,sub];
              SetIfRule(NewFact1+'T',NewFact2+'T',r.orderid);
              NewFact1[Comppos]:= Names[Comppos,sub];
              NewFact2[CompPos]:= Names[Comppos,i];
              SetIfRule(NewFact2+'T',NewFact1+'T', r.orderid);
            end;
          end;
          GenerateOrderFact(r);
        end
        else
        begin
          {handle false sep rule here}
          showmessage('False separation rules not handled yet');
        end;

      end;
      {For any separation, if value1 and value2 are not values of the same
           variable, then we can generate fact that value1 is not value2}
    end;

 begin  {SetorderRule}
   inc(NbrOrderRules);
   With OrderRules[NbrOrderRules] do
   begin
     {Order rule format: R1 R2 diff  where R1 "precedes" R2 by amount diff
              If diff=0 then any amount is OK
      }
     OrderId:=NewOrderId;
     R1:=s1;
     R2:=s2;
     Diff:=d;
     truevalue:=t;
     RType:=NRuleType;
     comppos:=wrt;

     If  not (validORule(R1,varpos1,compPos)
          and validORule(R2,varpos2,comppos)) then
     begin
        showmessage('Invalid Order Rule '+OrderID);
        dec(nbrorderrules);
     end
     else GenerateIfRules(NbrOrderRules)
   end;
 end;

 procedure TGame4.SetChoice(s:TChoiceString; NewChoiceId:string);
 var
   i,j:integer;
   var1index, var2index:integer;
   newrule:string;
   ch,cval1,cval2,cval3:char;
   val1index:integer;
   val1name, val2name:string;
 begin  {SetChoice}
   inc(NbrChoices);
   With Choices[NbrChoices] do
   begin
     {Order rule format: R1 R2 diff  where R1 "precedes" R2 by amount diff
              If diff=0 then any amount is OK
      }
     ChoiceId:=NewChoiceId;
     C:=s;
     (*
     If  not (validRule7(R1) then
     begin
        showmessage('Invalid Choice Rule '+ChoiceID);
        dec(nbrChoices);
     end
     else
     *)
     begin
       var1Index:=0;
       var2Index:=0;
       val1index:=0;
       for i:=1 to nbrvars do
       begin
         if C[i]='Y' then var2index:=i
         else if C[i]<>'X' then
         begin
           var1index:=i;

           if C[i] in ['1'..'9'] then val1index:=strtoint(c[i])
           else if C[i] in ['A'..'F'] then val1index:=ord(c[i]) - ord(pred('A'))
           else
           begin
             showmessage('Invalid Choice statement '+ choiceId);
             dec(nbrchoices);
             var1index:=0;
           end;
         end;
       end;
       If (var1index>0) and (var2index>0) then
       begin   {rule OK so far}
         cval1:=C[nbrvars+1];
         cval2:=C[nbrvars+2];
         cval3:=C[nbrvars+3];
         if cval3='' then cval3:=cval2;  {just so we can always check 3 values for not equal}
         newrule:=copy(C,1,nbrvars)+'F';
         val1name:=TVariabletype(variables.objects[var1index-1]).values[val1index-1];
         with TVariabletype(variables.objects[var2index-1]) do
         Begin
           j:=0;
           while (j<=values.count-1) do
           begin
             //if (values[j]<>cval1) and (values[j]<>cval2)
             //  and (values[j]<>cval3) then
             ch:=inttohex(j+1,1)[1];
             if not (ch in [cval1,cval2,cval3]) then
             begin
               newrule[var2index]:=ch;
               setfact(newrule,choiceId);
               {record generated negative fact}
               val2name:=values[j];
               with ShowifForm.IfRulesMemo do lines.add( inttostr(lines.count+1)+': ' +facttotext(newrule)
                                + '  (' + Choiceid+')');
               // (val1name + ' is not associated with '
               //        + val2name  + '  (' + Choiceid+')');

             end;
             inc(j);
           end;

         end;
         usedlist.Add(choiceId); {GDD 9/6/16}
       end;
     end;
   end;
 end;


 {****************** Lookup ******************}
 Function TGame4.Lookup(Fact:TFactString;pos:integer):Integer;

     Var
       i:integer;
       test:char;
     begin
       i:=0;
       if pos=0 then
       begin
         showmessage('Invalid call to lookup');
         pos:=1;
       end;
       test:=fact[pos];
       While (i<NbrValues) and (Names[pos,i]<>test) Do inc(i);
       If Names[pos,i]=test then result:=i else lookup:=0;
     end;

{**************** ComboLookup ****************}
   Function Tgame4.ComboLookup(i1,i2:integer):Integer;
   {Find which array entry in comboindex contains [i1,i2]}
   Var i,a,b:integer;
   begin
     i:=1;
     if i1>i2 then begin a:=i2; b:=i1; end
     Else begin a:=i1; b:=i2; end;
     While (i<=Nbrcombos) and ((comboindex[i,1] <> a) or (comboindex[i,2]<>b)) do inc(i);
     If i<=Nbrcombos then Combolookup:=i else combolookup:=0;
   end;


 {********************** ApplyFact **********************}
 Function Tgame4.ApplyFact(fact:TFact; msg:string; reporterrors:boolean):integer;
  {Make truth table entries for a fact}
   Var
     i1,i2,j,j1,j2,index,k1,k2:integer;
     XCount:integer;
     error:integer;
     s:string;
   begin
     xCount:=0;
     error:=0;
     if fact.factid[1]='F' then s:='User fact '
     else if fact.factid[1]='O' then s:='Fact from Order rule '
     else if fact.factid[1]='C' then s:='Fact from Choice rule '

     else if fact.factid[1]='A'
     then s:='(Reductio Ad Absurdum) Only one possibility '
          +' for unknown cells in this row or column did not cause a contradiction: '
     else s:=' ';
     For j:=1 to NbrVars do if fact.F[j]='X' then inc(Xcount);
     if fact.F[NbrVars+1]='F' then
     begin {set false}
       Case nbrvars-Xcount of
         0:
         begin
           showmessage('Fact '''+fact.Factid+''' sets all values to false '
                      +' - shouldn''t happen?');
         end;
         1:
         {Set a single variable to false}
         begin

           showmessage(format('Check single variable fact%s - redundant at best',
                          [fact.factID]));
           for j:=1 to Nbrcombos do
           if (fact.F[comboindex[j,1]] <> 'X')
                 and (fact.F[comboindex[j,2]]<>'X') then
           begin
             {find the variable #s that go with these values}
             j1:=lookup(fact.F,Comboindex[j,1]);
             j2:=lookup(fact.F,comboindex[j,2]);
             if (j1>0) and (j2>0) then
             {Trying to set a cell to false, it had better be Unknown or already false}
             if TruthTable[j,j1,j2]<>'T' then
             begin
               If TruthTable[j,j1,j2]<>'F' then
               begin
                 showmessage('Only a single variable in fact '
                              + fact.factid+' - Ignored');
               end;
             end
             Else
             begin
               showmessage('Fact '+Fact.FactID
                           +' attempts to set True value set to False'
                           +#13+'   Ignored'    );
             end;
           end;
         end;
         2:
         {Set 2 variable values to false}
         begin
           i1:=0; i2:=0;
           for j:=1 to NbrVars do if (fact.F[j]<>'X') and (i1=0) then  i1:=j;
           For j:= 1 to NbrVars do if (fact.F[j]<>'X') and (j<>i1) then i2:=j;
           k1:=lookup(fact.F,i1); k2:=Lookup(fact.F,i2);
           If (k1>0) and (k2>0) then
           begin
             j:=combolookup(i1,i2);
             j1:= lookup(fact.F,i1);
             j2:=lookup(fact.F,i2);
             If TruthTable[j,j1,j2]<>'T' then
             begin
               If TruthTable[j,j1,j2]='U' then
               begin
                 if reporterrors then
                 begin

                   Reasons[j,j1,j2]:=s+ fact.factid +': '+stattotextwithdefault(j,j1,j2,'F')
                                 +' sets this value to false';
                   UpdateTruthTable(j,j1,j2,'F',reasons[j,j1,j2]);
                   usedlist.Add(fact.factid);
                 end
                 else tempUpdateTruthTable(j,j1,j2,'F');;
               end;
               {else entry is already F, no need to set it again}
             end
             else if reporterrors
               then showmessage(format('Rule conflict %s trying to set true cell [%d,%d,%d] to false',
                          [fact.F, j,j1,j2]));
            end
           Else
           begin
             If k1>0 then Showmessage('Invalid character in position '
                              +inttostr(i1) + ' of fact '+ fact.factID);
             If k2>0 then Showmessage('Invalid character in position '
                              +inttostr(i2) + ' of fact '+ fact.FactID);
           end;
         end
         Else
         begin
           showmessage('Input error 3 in fact '
                        +fact.F+#13+' No more than '
                        +inttostr(Nbrvars-2)+' allowed');
         end;
       end; {case};
     end
     Else {Set true}
     begin
       Case nbrvars-Xcount of
       0:
       begin
         showmessage('This fact '''+fact.Factid+''' sets all values to true - shouldn''t happen?');
       end;
       1:                                           
       begin
         showmessage('Only a single letter in fact '+fact.factid+' - shouldn''t happen?');
       end;

       2:
       begin
         i1:=0; i2:=0;
         for j:=1 to NbrVars do if (fact.f[j]<>'X') and (i1=0) then  i1:=j;
         For j:= 1 to NbrVars do if (fact.f[j]<>'X') and (j<>i1) then i2:=j;
         if (i1<>0) and (i2<>0) and (fact.f[nbrvars+1]='T') then
         begin
           j1:=lookup(fact.f,i1); j2:=lookup(fact.f,i2);
           index:=combolookup(i1,i2);
           If (TruthTable[index,j1,j2]<>'F') then
           begin
             If TruthTable[index,j1,j2]='U' then
             begin
               if reporterrors then
               begin
                 reasons[index,j1,j2]:=s+fact.factid+': ' +facttotext(fact.f)
                         +format(', set cell to true, all other cells in column %d and row %d will be set to false',
                                     [j1,j2]);
                 usedlist.add(fact.factid);
                 UpdateTruthTable(index,j1,j2,'T',reasons[index,j1,j2]);
               end
               else
               begin
                 TempUpdateTruthTable(index,j1,j2,'T'); // {This is a test, entire table wille be restored later}
               end;
             end;
             //else TruthTable[index,j1,j2]:='T';
             {Run across all other row and column entries for 2 purposes:
              1: set other entries to false and
              2: set an error code if somehow a second true value slipped in}
             for  j:=1 to NbrValues do {check all columns of row j2}
             begin
               if TruthTable[index,j,j2]<>'T' then
               begin  {Table is "F" or "U"}
                 if (TruthTable[index,j,j2]='U')
                 then
                 begin
                   if reporterrors then
                   begin

                     reasons[index,j,j2]:=s+ fact.factid
                           +': ' +facttotext(fact.f)
                           + ', so this cell must be false';
                     usedlist.add(fact.factid);
                     UpdateTruthTable(index,j,j2,'F','' {reasons[index,j,j2]});
                   end
                   else tempupdatetruthtable(index,j,j2,'F');   //
                 end;

               end
               else if j<>j1 {j<>j1==> duplicate assignment, true value already set}
               then error:=14;

               if TruthTable[index,j1,j]<>'T' then
               begin
                 If (TruthTable[index,j1,j]='U') //and reporterrors  {check column j1}
                 then
                 begin
                   if reporterrors then
                   begin
                     reasons[index,j1,j]:=s+ fact.factid
                           +': ' +facttotext(fact.f)
                           +', so this cell must be false';
                     UpdateTruthTable(index,j1,j,'F',''{reasons[index,j1,j]});
                   end
                   else TempUpdatetruthtable(index,j1,j,'F');    //
                 end
               end
               else if j<>j2 then error := 15; {j<>j2==>duplicate assignment}
             end;
           end
           else
           begin
             if reporterrors then
             begin
               showmessage(format('Rule conflict %s trying to set false cell [%d,%d,%d] to true, not chnaged',
                            [fact.F, index,j1,j2]));
               error:=18;
             end;
           end;
         end;
         if error<>0 then
         if reporterrors then
         begin
            showmessage('Error in fact '+ Fact.factid
                     +#13+ ' Conflicting value already assigned');
           halt(1);
         end;
       end;
       Else {case else}
       if reporterrors then
       begin
          showmessage('Error in fact '+ Fact.factid
                     +#13+ ' No more than 2 value assignments allowed');
         halt(1);
       end;
     end;{case}
   end;
   result:=error;
 end;



{Local function *********** ValidORule **********}
     Function ValidORule(r:TFactString; Var varpos,comppos:integer):boolean;
     {  Validate order rule:
        Edit Criteria:
          1. R1 and R2 both contain an "_" character in the same location
             then  - this is the compare position.
          2. R1 and R2 each contain 2 X's;
          3. Non X character is valid variable value for the position
             in which it occurs.
     }


     Var
       test:boolean;
       _Count,XCount:integer;
       i:integer;
     begin
       test:=true;
       _Count:=0;
       XCount:=0;
       for i:=1 to length(r) do
       begin
         if r[i]='_' then begin inc(_Count); comppos:=i; end
         Else
         If r[i]='X' then inc(XCount)  Else varpos:=i;
       end;

       If _Count <> 1 then
       begin
          showmessage('OrderRule: '+R+ ':  single "_" must be present');
          test:=false;
       end;

       If Xcount<>2 then
       begin
         showmessage('OrderRule: '+R+': 2 X''s required');
         test:=true;
       end;
       validOrule:=test;
    end;  {ValidORule}


    {***********  GenerateIfRules ************}
 Procedure TSolveForm.GenerateIfRules(n:integer);
    {Generate all appropriate "if" rules from SEPARATION or Order Rule}
      Function validSub(n:integer):boolean;
      begin
        If (1<=n) and (n<=NbrValues) then validsub:=true
        Else validSub:=false;
      end;

    Var
      R:TOrderRule;
      NewFact1,NewFact2:TFactString;
      sub:integer;
      i:integer;
    begin
      r:=game.orderRules[n];
      With R do
      If Rtype=Order then
      with game do
      begin
        If truevalue then
        begin
          if diff=0 then
          begin
            {if difference can be any amount then all we know is that
             lower index is not last and higher index is not first}
            NewFact1:=r1+'F';
            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[compPos]:= Names[comppos,NbrValues];
              Setfact(NewFact1,orderid  );
            end;
            NewFact1:=r2+'F';
             if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[CompPos]:=Names[Comppos,1];
              Setfact(NewFact1,orderid{+' GenIf2'});
            end;
            NewFact1:=r1;
            {If first part next to last, 2nd part must be last}
            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[Comppos]:= Names[Comppos,NbrValues-1];
              NewFact2:=r2;
              NewFact2[CompPos]:= Names[Comppos,NbrValues];
              SetIfRule(NewFact1+'T',NewFact2+'T',r.orderid {+ ' Generated this'});
            end;
            {If 2nd part is next to first; 1st part must be first}

            NewFact1:=r2;
            if newfact1[compPos]='X' then {unless variable is compare variable}
            begin
              NewFact1[Comppos]:= Names[Comppos,2];
              NewFact2:=r1;
              NewFact2[CompPos]:= Names[Comppos,1];
              SetIfRule(NewFact1+'T',NewFact2+'T',r.orderid {+ ' Generated this'});
            end;
          end
          Else
          for i:= 1 to NbrValues do
          begin
            NewFact1:=R.r1;
            NewFact2:=R.r2;
            If validsub(I+diff)  then
            begin
              sub:=i+diff;
              NewFact1[Comppos]:= Names[Comppos,i];
              NewFact2[CompPos]:= Names[Comppos,sub];
              SetIfRule(NewFact1+'T',NewFact2+'T',r.orderid {+' Generated this'});
              SetIfRule(NewFact2+'T',NewFact1+'T',r.orderid {+' Generated this'});
              {r2 values within  diff of bottom can't be true}
              if (not validsub(i-diff)) then
              begin
                NewFact2[compPos]:=NewFact1[comppos];
                If not RuleExists(NewFact2+'F') then Setfact(NewFact2+'F','GenIf3');
              end;
            end
            {r1 values within diff of top can't be true}
            Else
            begin
              NewFact1[Comppos]:= Names[Comppos,i];
              If not RuleExists(NewFact1+'F')
              then Setfact(NewFact1+'F', 'GebnIf4');
            end;
          end;
        end
        else
        begin
          {handle false order rule here}
        end;
      end {Order Rule}
      Else
      begin {SEPARATION rule}
        If truevalue then with game do
        begin
          {items separated by and amount but we don't know which is first}
          {diff=0 makes no sense for SEPARATION rule}
          if diff=0 then showmessage('Difference of 0 makes no sense for Separation rule')
          else
          for i:= 1 to NbrValues do
          begin
            NewFact1:=R.r1;
            NewFact2:=R.r2;
            NewFact1[Comppos]:= Names[Comppos,i];
            If validsub(I+diff) and not validsub(i-diff) then sub:=i+diff
            Else if validsub(i-diff) and not validsub(i+diff) then sub:=i-diff
            else sub:=0;
            If sub >0 then
            begin
              NewFact2[CompPos]:= Names[Comppos,sub];
              SetIfRule(NewFact1+'T',NewFact2+'T',r.orderid {+' Generated this'});
              NewFact1[Comppos]:= Names[Comppos,sub];
              NewFact2[CompPos]:= Names[Comppos,i];
              SetIfRule(NewFact2+'T',NewFact1+'T', r.orderid {+' Generated this'});
            end;
          end;
        end
        else
        begin
          {handle false sep rule here}
        end;
      end;
    end;



{******************* PrintArray *************}
Procedure TGame4.PrintArray(s:string;code:integer);
   Var  i,dim1,varnbr1,varnbr2,varvaluenbr:integer;
   begin
     with Solveform, resultsgrid do
     begin
       for i:= 0 to variables.count-1 do
       begin
         cells[i,0] := variables[i];
         AdjustWidth(Resultsgrid,i,0);
       end;
       varnbr1:=1;
       with variables.objects[varnbr1-1] as Tvariabletype do
       for  varvaluenbr:=1 to values.count do
       begin
         if varvaluenbr>=rowcount then rowcount:=varvaluenbr+1;
         cells[varnbr1-1,varvaluenbr]:=values[varvaluenbr-1];
         Adjustwidth(Resultsgrid,varnbr1-1,varvaluenbr);
         for varnbr2:=1 to variables.count do
         if varnbr2<>varnbr1 then
         begin
           Dim1:=Game.combolookup(varnbr1,varnbr2);
           i:=1;
           while (i<NbrValues) and (game.TruthTable[Dim1,varvaluenbr,i]<>'T')
           do inc(i);
           if game.TruthTable[Dim1,varvaluenbr,i]='T'
           then cells[varnbr2-1,varvaluenbr]:=TVariabletype
                                    (variables.objects[varnbr2-1]).values[i-1]
           else cells[varnbr2-1,varvaluenbr]:='?';
           Adjustwidth(Resultsgrid,varnbr2-1,varvaluenbr);
         end;
       end;
       AdjustGridSize(ResultsGrid);
     end;
     if code>=0 then showmessage(s+inttostr(code));
   end;


 Procedure TGame4.SolveIt;
 {Does the solving work}


   {***************** ApplyFacts ***********************}
   Procedure ApplyFacts;
   Var i:integer;
   begin
     for i:=1 to NbrFacts do
     if ApplyFact(Facts[i],'Apply user fact or rule:',true)<>0 then
           showmessage('Conflict in rule'+Facts[i].F+' #'+inttostr(i));
           {$IFDEF DEBUG} printarray('Conflict in rule'+Facts[i].F+' #',i);{$ENDIF}
     end;


   {************************* Fillin ************************}
   Procedure Fillin;
   {Major routine resolving all variable values that can be deduced from the current
    set of facts and rules.  Since resolving any unknown variable value may affect other
    unknown variable, the routine loops until no additional facts are created in a pass}


     {******************** FillOnePossible ******************}
      Function FillOnePossible(Table:integer):Boolean;
     {If all possible choices except one have been eliminated, that one must be
      true}
     Var change:boolean;
         IA,IB:integer;
         //c,r:integer;
         ucount1,ucount2,fcount1,fcount2:integer;
         colpos1,rowpos1,colpos2,rowpos2:integer;
         c:char;

     begin
       colpos1:=0; rowpos1:=0; colpos2:=0; rowpos2:=0;
       change:=false;
       {Search for positions with one "U" and rest "F"}
       {if found - change "U" to "T"}
       for IA:=1 to NbrValues do
       begin
         ucount1:=0; ucount2:=0;
         fcount1:=0; fcount2:=0;
         for IB:= 1 to NbrValues do
         begin
           c:=TruthTable[Table,IA,IB];
           if c='F' then inc(fcount1) {count col F"s}
           else if c='U' then begin inc(ucount1); colpos1:=IA; rowpos1:=IB; end;
           c:=TruthTable[Table,IB,IA]; {count row "F"s}
           if c='F'
           then inc(fcount2)
           else if c='U' then begin inc(ucount2); colpos2:=IB; rowpos2:=IA; end;
         end;
         If (ucount1=1) and (fcount1+ucount1=NbrValues)
         then
         begin
           If TruthTable[Table,colpos1,rowpos1]<>'T' then
           begin
             change:=true;
             If (TruthTable[Table,colpos1,rowpos1]='U') then
             begin
               if inreductio then TempUpdateTruthTable(Table,colpos1,rowpos1,'T')
               else
               begin
                 Reasons[Table,colpos1,rowpos1]:=
                 format('All other cells in column %d are false, '
                    +'so this cell must be true and all other cells in row %d will be set to false',
                    [colpos1, rowpos1]);
                                     ;
                 UpdateTruthTable(Table,colpos1,rowpos1,'T',reasons[Table,colpos1,rowpos1]);
               end;
             end
             else showmessage('T over F?');
           end;
         end;
         If (ucount2=1) and (fcount2+ucount2=NbrValues)
         then begin
           if TruthTable[Table,colpos2,rowpos2]<>'T' then
           begin
             change:=true;
             If TruthTable[Table,colpos2,rowpos2]='U' then
             begin
               if inreductio then TempUpdateTruthTable(Table,colpos2,rowpos2,'T')
               else
               begin
                 Reasons[Table,colpos2,rowpos2]:=format('All other cells in row %d are false, '
                  +'so this cell must be true and all other cells in column %d will be set to false',
                  [rowpos2,colpos2]);
                 UpdateTruthTable(Table,colpos2,rowpos2,'T', reasons[Table,colpos2,rowpos2]);
               end;
             end
             else showmessage('T over F?');
           end;
         end;
       end;
       result:=change;
     end; {FillOnePossible}

     {******************** FillFalse **********************}
     Function FillFalse(i:integer):Boolean;
     {If  two values have been associated, all other
      possible associations with these 2 values must be false
      (If Sam went skiing then nobody else went skiing and Sam
       didn't do any thing else) }
     Var
       change:Boolean;
       j,k,m:integer;
       s:string;
     begin
       {Look for "T" and change rest of row or column to "F"}
       change:=false;
       for j:= 1 to NbrValues do
       begin
         For k:=1 to NbrValues do
         If TruthTable[i,j,k]='T' then
         begin
           s:='';
           For m:=1 to NbrValues do
           begin
             If TruthTable[i,m,k]='U' then
             begin
               change:=true;
               //reasons[i,m,k]:='True fact in row '+inttostr(k)+': '+stattotext(i,j,k)
               //      + ', so ' +stattotextwithdefault(i,m,k,'F'); //this cell must be false';
               UpdateTruthTable(i,m,k,'F', '' {reasons[i,m,k]});
               if s='' then s:=Stattotext(i,m,k)
               else s:=s+ ' and '+ Stattotext(i,m,k);
             end;
           end;
         end;

         For k:=1 to NbrValues do
         If TruthTable[i,j,k]='T' then
         begin
           s:='';
           For m:=1 to NbrValues do
           begin
             if TruthTable[i,j,m]<>'T' then
             begin
               If TruthTable[i,j,m]<>'F' then
               begin
                 If TruthTable[i,j,m]='U' then
                 begin
                   change:=true;
                   //reasons[i,j,m]:='True fact in columm '+inttostr(j)+': '
                   //        +stattotext(i,j,k)
                   //        + ', so ' +stattotextwithdefault(i,j,k,'F'); //this cell must be false';
                   UpdateTruthTable(i,j,m,'F',''{reasons[i,j,m]});
                   if s='' then s:=Stattotext(i,j,m)
                   else s:=s+ ' and '+ Stattotext(i,j,m);
                 end;
               end;
             end;
           end;
         end;
       end;
       result:=change;
     end; {FillFalse}



     {*************** PositiveIdentity **************************}
     Function PositiveIdentity(var ErrCode,flag:integer; Expl:boolean):Boolean;
     {If A is B and B is C then A is C and we can fill the
                     truth table accordingly}
                    {In Rules format this is ABXT XBCT ==> AXCT}
     Var
       change,change2,change3:boolean;
       i,j,k:integer;
       ii,jj:integer;
       a,b,c:integer;
       reason1:string;

         function seths(a,b,c,d,e,f,g,h,i:integer):integer;
         begin
           change:=true;
           result:=mrOK;
           If TruthTable[g,h,i]='U' then
           begin
              //UpdateTruthTable(g,h,i,'T',reasons[g,h,i]);
             if expl then
             begin    {GDD1}
               reasons[g,h,i]:='Identity (things equal to the same thing are equal to each other): '

                             + StatToText(a,b,c)
                             + ' and ' + StatToText(d,e,f)
                             + ' therefore ' + StatToTextWithDefault(g,h,i,'T');
               UpdateTruthTable(g,h,i,'T',reasons[g,h,i]);
             end;
           end
           else If TruthTable[g,h,i]='F' then
           begin
             TruthTable[g,h,i]:='T'; {change value temporarily to get correct message}
             reason1:=StatToTextWithDefault(g,h,i,'T');
             TruthTable[g,h,i]:='F'; {restore value}
             if expl then  {GDD1}
             begin
                 result:=messagedlg('Trying to apply positive identity: '
                +' (things equal to the same thing are equal to each other): because '
                + StatToText(a,b,c)
                + ' and ' + StatToText(d,e,f)
                + ' therefore ' + reason1
                +#13+ 'But '+ stattotext(g,h,i)+ ' has already been set by '
                + reasons[g,h,i]
                +#13+ 'This identity has not been applied', mtconfirmation, [mbOK, MbCancel],0);
             end;
           end;
         end;

       {********** FindIndex ***********}
       Function FindIndex(a,b:integer):integer;
       var
         i:integer;
       begin
         i:=0;
         result:=0;
         Repeat
           inc(i);
           if ((comboindex[i,1]=a) and (comboindex[i,2]=b))
           or ((comboindex[i,1]=b) and (comboindex[i,2]=a))
           then
           begin
             result:=i;
             i:=999;
           end;
         Until i>=Nbrcombos;
       end; {FindIndex}


     begin  {PositiveIdentity}
       change:=false;
       errcode:=0;
       flag:=mrOK;
       for i:=1 to Nbrcombos do
       begin
         for j:=1 to NbrValues do
         begin
           for k:=1 to NbrValues do
           begin
             if TruthTable[i,j,k]='T' then
             begin
               for ii:= 1 to Nbrcombos do  {across all truth tables}
               begin
                 if   (comboindex[ii,1]= comboindex[i,1])
                  and (comboindex[ii,2]<>comboindex[i,2]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,j,jj]='T' then
                     begin
                       a:=comboindex[ii,2];
                       b:=comboindex[i,2];
                       c:=findindex(a,b);
                       If a<b then
                       begin
                         If TruthTable[c,jj,k]='F' then errcode:=20;
                         If TruthTable[c,jj,k]<>'T' then
                         begin
                           flag:=setHS(i,j,k,ii,j,jj,c,jj,k);
                         end;
                       end
                       Else
                       begin
                         If TruthTable[c,k,jj]='F' then errcode:=21;
                         If TruthTable[c,k,jj]<>'T' then
                         begin
                           flag:=seths(i,j,k,ii,j,jj,c,k,jj)
                         end;
                       end;
                     end;
                     if flag=mrCancel then break;
                   end;
                 end
                 Else If  (comboindex[ii,1]<>comboindex[i,1])
                      and (comboindex[ii,2]= comboindex[i,2]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,jj,k]='T' then
                     begin
                       a:=comboindex[ii,1];
                       b:=comboindex[i,1];
                       c:=findindex(a,b);
                       If a<b then
                       begin
                         If TruthTable[c,jj,j]='F' then errcode:=30;
                         If TruthTable[c,jj,j]<>'T' then flag:=seths(i,j,k,ii,jj,k,c,jj,j);
                       end
                       Else
                       begin
                         If TruthTable[c,j,jj]='F'  then errcode:=31;
                         If TruthTable[c,j,jj]<>'T' then  flag:=seths(i,j,k,ii,jj,k,c,j,jj);
                       end;

                     end;
                     if flag=mrcancel then break;
                   end;
                 end
                 Else If    (comboindex[ii,1]<>comboindex[i,2])
                        and (comboindex[ii,2]= comboindex[i,1]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,jj,j]='T' then
                     begin
                       a:=comboindex[ii,1];
                       b:=comboindex[i,2];
                       c:=findindex(a,b);
                       if a<b then
                       begin
                         //If TruthTable[c,jj,k]='F' then errcode:=(40);
                         If TruthTable[c,jj,k]<>'T' then flag:=seths(i,j,k,ii,jj,j,c,jj,k);
                       end
                       else
                       begin
                         If TruthTable[c,k,jj]='F' then errcode:=(41);
                         If TruthTable[c,k,jj]<>'T' then flag:=seths(i,j,k,ii,jj,j,c,k,jj);
                       end;

                     end;
                     if flag=mrcancel then break;
                   end;
                 end
                 Else If   (comboindex[ii,1]= comboindex[i,2])
                       and (comboindex[ii,2]<>comboindex[i,1])
                 then
                 for jj:=1 to NbrValues do
                 begin
                   If TruthTable[ii,k,jj]='T' then
                   begin
                     a:=comboindex[ii,2];
                     b:=comboindex[i,1];
                     c:=findindex(a,b);
                     If a<b then
                     begin
                       If TruthTable[c,jj,j]='F' then errcode:=(50);
                       If TruthTable[c,jj,j]<>'T' then flag:=seths(i,j,k,ii,k,jj,c,jj,j);
                     end
                     Else
                     begin
                       If TruthTable[c,j,jj]='F' then errcode:=(51);
                       If TruthTable[c,j,jj]<>'T' then flag:=seths(i,j,k,ii,k,jj,c,j,jj);

                     end;
                   end;
                 end;
                 if flag=mrCancel then break;
               end;
               if flag=mrCancel then break;
             end;
             if flag=mrCancel then break;
           end;
           if flag=mrcancel then break;
         end;
         if flag=mrcancel then break;
       end;
       if flag=mrOK then
       for i:=1 to Nbrcombos do
       begin
         change2:=fillfalse(i);
         change3:=fillOnePossible(i);
         if change2 or change3 then
         change:=true;
       end;
       result:=change;   {indicate if any truth table changes were made}
     end; {PositiveIdentity}

    {************ GetVarAndVal *********}
    Function GetVarAndVal(var1,val1:integer):string;
    {Make a string of varname(Valuename) from variablke and value numbers}
         begin
           result:=variables[var1-1]
                 + '('
                 + TVariabletype(variables.objects[var1-1]).values[val1-1]
                 + ')';
         end;
 {*************** CheckSingleModusTollens ************}
 Function CheckSingleModusTollens(matchvar,matchval1,matchval2,var1,val1:integer):boolean;

     function Settable(svar1,sval1,svar2,sval2:integer; value:char):boolean;
     var
       index:integer;
       s:string;
     begin
       result:=false;
       index:=combolookup(svar1,svar2);
       if (svar1<svar2) then
       begin
         If (TruthTable[index,sval1,sval2]='U')
         then
         begin
           s:=GetVarAndVal(matchvar,matchval1);
           delete(s,length(s),1); {delete final')'}
             s:=s+' or '+TVariabletype(variables.objects[matchvar-1]).values[matchval2-1]
                 + ')';

           reasons[index,sval1,sval2]:=GetVarAndVal(svar1,sval1) + ' is '+ s
                   +' and '+ GetvarAndVal(svar2,sval2) +' is not ' + s
                   +' therefore '+ stattotextWithDefault(index,sval1,sval2,'F');
           UpdateTruthTable(index,sval1,sval2,'F',reasons[index,sval1,sval2]);
           result:=true;
         end;
       end
       else
       if TruthTable[index,sval2,sval1]='U' then
       begin
         s:='('+ GetVarAndVal(matchvar,matchval1);
         delete(s,length(s),1); {delete final')'}
         s:=s+' or '+TVariabletype(variables.objects[matchvar-1]).values[matchval2-1]
                 + ')';

         reasons[index,sval2,sval1]:=GetVarAndVal(svar2,sval2) +' and '+ s
                 +', '+ GetvarAndVal(svar1,sval1) +' is not ' + s
                 +' therefore '+ stattotextWithDefault(index,sval2,sval1,'F');
         UpdateTruthTable(index,sval2,sval1,'F', reasons[index,sval2,sval1]);
         result:=true;
       end;
     end; {Settable}

 {implements If A then B, not B, therefore Not A}
 { Facts AXXBF, XCXBT implies ACXXF}
 {Can also extend to (AXXBF and AXXDF and XCXBT or XCXDT, ie C is B or D}
 {This is indicated by U (inknown) in truth table for C,B and for C,D and rest all F}
 var
   var2,val2:integer;
   index:integer;
 begin
   result:=false;
   for var2:= 1 to nbrvars do
   if (var2<>var1) and (var2<>matchvar) then
   begin
     index:=combolookup(matchvar,var2);
     If var2<matchvar then
     begin
       for val2:= 1 to nbrvalues do
       if (TruthTable[index,val2,matchval1]='F') and (TruthTable[index,val2,matchval2]='F')
       then result:=settable(var1,val1,var2,val2,'F');
     end
     else
     begin
       for val2:= 1 to nbrvalues do
       if (TruthTable[index,matchval1,val2]='F') and (TruthTable[index,matchval2,val2]='F')
       then result:=settable(var1,val1,var2,val2,'F');
     end;
   end;
 end;


     {************ ModusTollens **********************}
     Function modustollens:boolean;

     Var
       change:boolean;
       i,j,k:integer;
       pcount1,pcount2,fcount1,fcount2:integer;
       pos1a,pos1b,pos2b:integer;
       pos11a,pos11b,pos22a:integer;
       c:char;
       matchvar,var1:integer;
     begin  {ModusTollens}
       pos1a:=0; pos1b:=0; pos2b:=0; pos11a:=0; pos11b:=0; pos22a:=0;
       change:=false;
       For i:= 1 to Nbrcombos do
       for j:=1 to NbrValues do
       begin
         pcount1:=0; pcount2:=0;
         fcount1:=0; fcount2:=0;
         for k:= 1 to NbrValues do
         begin
           c:=TruthTable[i,j,k];
           if c='F' then inc(fcount1)
           else if c='U' then
           begin
             inc(pcount1);
             case pcount1 of
               1: begin pos1A:=j; pos1B:=k; end;
               2: begin pos2b:=k; end;

             end;
           end;
           c:=TruthTable[i,k,j];
           if c='F' then inc(fcount2)
           else if c='U' then
           begin
             inc(pcount2);
             case pcount2 of
               1: begin pos11a:=k; pos11b:=j; end;
               2: begin Pos22a:=k;end;
             end;
           end;
         end;
         If (pcount1=2) and (fcount1+pcount1=NbrValues)
         then
         begin
           matchvar:=comboindex[i,2];
           var1:=comboindex[i,1];
           If CheckSingleModustollens(matchvar,pos1b,pos2b,var1, pos1a)
           then change:=true;
         end;
         If (pcount2=2) and (fcount2+pcount2=NbrValues)
         then
         begin
           matchvar:=comboindex[i,1];
           var1:=comboindex[i,2];
           If CheckSingleModustollens(matchvar,pos11a,pos22a,var1,pos11b)
           then change:=true;
         end;
       end;
       Result:=change;
     end;{ModusTollens}

type T_RAPoints=array [1..maxvars] of tpoint;



     {************ ReductioAdAbsurdum **********************}
     Function ReductioAdAbsurdum:boolean;
     {Assume a value and try to reach a contradiction, proving that
      assumption was incorrect}

        {*********** Gen2XRule *************}
        Function Gen2XRule(i,pos1,pos2:integer):TFactString;
        Var
          n1,n2:char;
          rule:TFactString;
          j:integer;
        begin
          N1:=names[comboindex[i,1],pos1];
          N2:=names[comboindex[i,2],pos2];
          rule:='';
          for j:=1 to NbrVars do
          begin
            if j=comboindex[i,1] then rule:=rule+n1
            else if j=comboindex[i,2] then rule:=rule+n2
            else rule:=rule+'X';
          end;
          result:=rule;
        end; {Gen2XRule}

        {************* CheckOrderRules **********}
        Procedure checkOrderRules(Var err:integer);
        {Check order rules and set err <>0 if any are violated}
        Var  i,ii,j,k:integer;
             index1,index2:integer;
        begin
          err:=0;
          If NbrOrderRules>0 then
          for i:=1 to NbrOrderRules do
          With OrderRules[i] do
          begin
            index1:=0;
            index2:=0;
            ii:=comboLookup(varpos1,compPos);

            If ii=0 then ii:=combolookup(comppos,varpos1);
            if ii>0 then
            begin
              k:=lookup(R1,varpos1);
              for j:= 1 to NbrValues do
              if varpos1<compPos then
                if TruthTable[ii,k,j]='T' then index1:=j
                Else
              Else if TruthTable[ii,j,k]='T' then index1:=j;
            end;
            ii:=combolookup(varpos2,comppos);
            If ii=0 then ii:=combolookup(comppos,varpos2);
            If ii>0 then
            begin
              k:=lookup(R2,varpos2);
              for j:= 1 to NbrValues do
              if varpos2<compPos then
              if TruthTable[ii,k,j]='T' then index2:=j
              Else
              Else if TruthTable[ii,j,k]='T' then index2:=j;
            end;
            If index1*index2>0 then
            begin
              If rtype=order then
              begin
                 If (Diff=0) then
                   If (index1<index2) then err:=0
                   Else begin err:=1; Exit; end
                 Else
                 If index2-index1=diff then err:=0
                 Else begin err:=1; exit; end;
              end
              Else
              begin {SEPARATION}
                If abs(index1-index2)=diff then err:=0
                Else begin Err:=1; Exit; end;
              end;
            end;
          end; {CheckOrderRules}
        end;

        {********** TryRules ***********}
        Function TryRules(i,pos1a,pos1b,pos2a,pos2b:integer; var flag:integer):Boolean;
        Var
          stat2:TStatArray;
          err1,err2:integer;
          NewFact1,NewFact2:TFact;
          change:boolean;
          ii,j,k:integer;
         begin
           change:=false;      {save array}
           setlength(stat2, length(truthtable), length(truthtable[0]), length(truthtable[0,0]));

           flag:=MROK;
           inreductio:=true;
           //stat2:=TruthTable;  {generate a new trial rule}
           for ii:=0 to high(truthtable) do
           for j:=0 to high(truthtable[ii]) do
           for k:= 0 to high(truthtable[ii,j]) do stat2[ii,j,k]:=truthtable[ii,j,k];

           AddToLog(1,1,1,'Truth table saved before Reductio test changes');
           NewFact1.F:=Gen2XRule(i,pos1a,pos1b)+'T'; {apply new trial fact}
           Newfact1.Factid:='Assumption 1';

           {false as 3rd param in Applyfact call means this is a test,
            don't generate reasons or display errors}
           err1:=ApplyFact(NewFact1, 'Reductio Absurdum',False);
           {$IFDEF DEBUG} printarray('Part 1: After applying fact '+NewFact1+' ',err1); {$ENDIF}
           if err1=0 then PositiveIdentity(err1, flag, false); {Run PositiveIdentity and save errcode}
           If (err1=0) and (flag=mrOK)  then
           begin
             CheckOrderRules(Err1);
              //  TruthTable:=stat2; {restore array}
             for ii:=0 to high(truthtable) do
             for j:=0 to high(truthtable[ii]) do
             for k:= 0 to high(truthtable[ii,j]) do truthtable[ii,j,k]:=stat2[ii,j,k];

             AddToLog(1,1,1,'Truth table restored after 1st trial rule test');
             {$IFDEF DEBUG}printarray('Part A: Err1=',err1);{$ENDIF}
             if flag=MROK then
             begin
               NewFact2.F:=Gen2XRule(i,pos2a,pos2b)+'T'; {generate 2nd trial rule}
               Newfact2.FactID:='Assumption 2';
               {$IFDEF DEBUG}printarray('Part A Before Fact2:'+NewFact2.f,-1);{$ENDIF}
               {false in next call ==> this is a test, don't generate reasons or display errors}
               err2:=ApplyFact(NewFact2,'Reductio Absurdum',False); {apply 2nd fact}
               if err2=0 then PositiveIdentity(err2, flag,false);  {PositiveIdentity and save err code}
               if err2=0 then CheckOrderRules(err2);
               {$IFDEF DEBUG} printarray('Part A:Err2=',err2); {$ENDIF}
             end;
             inreductio:=false;
             //TruthTable:=stat2;  {restore array}
             for ii:=0 to high(truthtable) do
             for j:=0 to high(truthtable[ii]) do
             for k:= 0 to high(truthtable[ii,j]) do truthtable[ii,j,k]:=stat2[ii,j,k];
             AddToLog(1,1,1,'Truth table restored after 2nd  trial rule test');
             if (err1=0) and (err2<>0) then
             begin
               change:=true;
               {$IFDEF DEBUG} printarray('Before fact1:'+NewFact1.f,-1);{$ENDIF}

               ApplyFact(NewFact1,'1st fact led to contradiction, so apply: ', true);
               {$IFDEF DEBUG} printarray('After fact1',-1); {$ENDIF}
               PositiveIdentity(err1,flag, true);
             end
             else
             if (err2=0) and (err1<>0) then
             begin
               change:=true;
               {$IFDEF DEBUG}printarray('Before fact2:'+NewFact2.f,-1);{$ENDIF}
               ApplyFact(NewFact2,'2nd fact led to contradiction so apply: ',true);
               {$IFDEF DEBUG} printarray('After fact2',-1); {$ENDIF}
               PositiveIdentity(err2, flag, true);
             end;

             {$IFDEF DEBUG} printarray('Part A: After applying rules',-1);{$ENDIF}

               //result:=change;
           end {err1<>0) or (mrflag=mrcancel}
           else
           begin
           //  TruthTable:=stat2; {restore array}
             for ii:=0 to high(truthtable) do
             for j:=0 to high(truthtable[ii]) do
             for k:= 0 to high(truthtable[ii,j]) do truthtable[ii,j,k]:=stat2[ii,j,k];
           end;
           haltflag:=haltflag or (flag=MrCancel);
           result:=change;
         end; {TryRules}


   (* attempt to expand reductio  absurdum to more than 2 choices - not working
      Function TryRules(t,pcount:integer; rapoints:T_RAPoints):Boolean;
        Var
          stat2:TStatArray;
          err1:integer;
          NewFact1,NewFact:TFact;
          change:boolean;
          j,k:integer;
          OKCount:integer;
          val:char;
         begin
           change:=false;      {save array}
           OKCount:=0;
           {try all unknowns in a row or column in table t
            - we are looking for case where only one doesnot cause a contradiction,
              if we find that case, that must be the value for that truth table
              cell}
           for j:=1 to pcount do
           begin
             stat2:=TruthTable;  {save the truth table}
             {Set all to false except j}
             for k:=1 to pcount do
             begin
               if k=j then val:='T' else val:='F';
               NewFact1.F:=Gen2XRule(t,rapoints[j].x,rapoints[j].x)+val; {apply new trial facts}
               Newfact1.Factid:='Assumption ';
             end;


             {false as 3rd param in Applyfact call means this is a test,
              don't generate reasons or display errors}
             err1:=ApplyFact(NewFact1, 'Reductio Absurdum',False);
             {printarray('Part A: After applying fact '+NewFact1+' ',err1);}
             if err1=0 then PositiveIdentity(err1, false); {Run PositiveIdentity and save errcode}
             If err1=0 then CheckOrderRules(Err1);
             {$IFDEF DEBUG}printarray('Part A:Err1=',err1);{$ENDIF}
             TruthTable:=stat2; {restore array}
             if err1=0 then
             begin {we are looking for the case where only one cell can be validly true}
              inc(OKCount);
              Newfact:=Newfact1;
             end;
           end;
           if OKCount=1 then
           begin
             change:=true;
             ApplyFact(NewFact,'Other possibilities led to contradiction, so apply: ', true);
             {$IFDEF DEBUG} printarray('After fact1',-1); {$ENDIF}
             PositiveIdentity(err1, true);
           end;
           result:=change;
         end; {TryRules}
*)


     Var
       change1,change2:boolean;
       pos1a,pos1b,pos2a,pos2b,pos11a,pos11b,pos22a,pos22b:integer;
       i,j,k:integer;
       pcount,fcount:integer;
       c:char;
       flag:integer;

     (*
     begin  {ReductioAdAbsurdum}
       pos1a:=0; pos1b:=0; pos2a:=0; pos2b:=0; pos11a:=0; pos11b:=0; pos22a:=0; pos22b:=0;
       change1:=false; change2:=false;
       flag:=MROK;
       {check all truth tables}
       For i:= 1 to Nbrcombos do {across  all truth tables]
       begin
         {check the columns in this truth table}
         for j:=1 to NbrValues-1 do  {column j}
         begin
           pcount:=0;
           fcount:=0;
           for k:= 1 to NbrValues do
           begin {check row k}
             c:=TruthTable[i,j,k];
             if c='F' then inc(fcount)
             else if c='U' then
             begin
               inc(pcount);
               case pcount of
                 1: begin pos1A:=j; pos1B:=k; end; {the 1st U in column j}
                 2: begin pos2a:=j; pos2b:=k; end; {the 2nd U in column j}
               end;
             end;
             {Check if only 2 choices left to resolve}
             If (pcount=2) and (fcount+pcount=NbrValues)
             then
             begin  {There are 2 "U"s in column j}
               change1:=change1 or TryRules(i,pos1a,pos1b,pos2a,pos2b,flag);
               pcount:=1;
             end;
           end;
         end;
         {now check the rows}
         for j:=1 to NbrValues-1 do
         begin
           pcount:=0;
           fcount:=0;
           for k:= 1 to NbrValues do
           begin
             c:=TruthTable[i,k,j];
             if c='F' then inc(fcount)
             else if c='U' then
             begin
               inc(pcount);
               case pcount of
                 1: begin pos11a:=k; pos11b:=j; end;
                 2: begin Pos22a:=k; pos22b:=j; end;
               end;
             end;
             If (pcount=2) and (fcount+pcount=NbrValues)   {GGD}
             then
             begin
               change2:=change2 or TryRules(i,pos11a,pos11b,pos22a,pos22b,flag);
               pcount:=1;
             end;
           end;
         end;
         if flag=MrCancel then
         begin
           haltflag:=true;
           break;
         end;
       end;
       result:=change1 or change2;
     end;{ReductioAdAbsurdum}
     *)


     begin  {ReductioAdAbsurdum}
       pos1a:=0; pos1b:=0; pos2a:=0; pos2b:=0; pos11a:=0; pos11b:=0; pos22a:=0; pos22b:=0;
       change1:=false; change2:=false;
       flag:=MROK;
       {check all truth tables}
       For i:= 1 to Nbrcombos do {across  all truth tables}
       begin
         {check the columns in this truth table}
         for j:=1 to NbrValues-1 do  {column j}
         begin
           pcount:=0;
           fcount:=0;
           for k:= 1 to NbrValues do
           begin {check row k}
             c:=TruthTable[i,j,k];
             if c='F' then inc(fcount)
             else if c='U' then
             begin
               inc(pcount);
               case pcount of
                 1: begin pos1A:=j; pos1B:=k; end; {the 1st U in column j}
                 2: begin pos2a:=j; pos2b:=k; end; {the 2nd U in column j}
               end;
             end;
           end;
           {Check if only 2 choices left to resolve}
           If (pcount=2) and (fcount+pcount=NbrValues)
           then
           begin  {There are 2 "U"s in column j}
             change1:=change1 or TryRules(i,pos1a,pos1b,pos2a,pos2b,flag);
             //pcount:=1;
           end;
         end;
         {now check the rows}
         for j:=1 to NbrValues-1 do
         begin
           pcount:=0;
           fcount:=0;
           for k:= 1 to NbrValues do
           begin
             c:=TruthTable[i,k,j];
             if c='F' then inc(fcount)
             else if c='U' then
             begin
               inc(pcount);
               case pcount of
                 1: begin pos11a:=k; pos11b:=j; end;
                 2: begin Pos22a:=k; pos22b:=j; end;
               end;
             end;
           end;
           If (pcount=2) and (fcount+pcount=NbrValues)   {GGD}
           then
           begin
             change2:=change2 or TryRules(i,pos11a,pos11b,pos22a,pos22b,flag);
            // pcount:=1;
           end;
         end;
         if flag=MrCancel then
         begin
           haltflag:=true;
           //break;
         end;
       end;
       result:=change1 or change2;
     end;{ReductioAdAbsurdum}


  (* version that tries to handle more than 2 unknown choices in a row or column
    - not working
   begin  {ReductioAdAbsurdum}
       change1:=false; change2:=false;
       {check all truth tables}
       For i:= 1 to Nbrcombos do
       begin
         {check the columns in this truth table}
         for j:=1 to NbrValues-1 do
         begin
           pcount:=0;
           fcount:=0;
           for k:= 1 to NbrValues do
           begin
             c:=TruthTable[i,j,k];
             if c='F' then inc(fcount)
             else if c='U' then
             begin
               inc(pcount);
               with rapoints[pcount] do
               begin
                 x:=j;
                 y:=k;
               end;
             end;
           end;
           {Check if only F's and U's in row}
           If fcount+pcount=NbrValues
           then change1:=TryRules(i,pcount,raPoints);
         end;
         {now check the rows}
         for j:=1 to NbrValues-1 do
         begin
           pcount:=0;
           fcount:=0;
           for k:= 1 to NbrValues do
           begin
             c:=TruthTable[i,k,j];
             if c='F' then inc(fcount)
             else if c='U' then
             begin
               inc(pcount);
               with rapoints[pcount] do
               begin
                 x:=j;
                 y:=k;
               end;
             end;
           end;
           {Check if only F's and U's in column}
           If fcount+pcount=NbrValues
           then change2:=TryRules(i,pcount,raPoints);
         end;
       end;
       result:=change1 or change2;
     end;{ReductioAdAbsurdum}
     *)


     {********************** NegativeIdentity ************************}
     Function NegativeIdentity(Var errcode, flag:integer):boolean;
     {apply identity principle: if 'A is B' and 'C is not B' then 'A is not C'}
     { eg ABXXT and XBCXF ==> AXCXF}


     Function FindIndex(a,b:integer):integer;
       Var
         i:integer;
       begin
         i:=0;
         result:=0;
         Repeat
           inc(i);
           if ((comboindex[i,1]=a) and (comboindex[i,2]=b))
           or ((comboindex[i,1]=b) and (comboindex[i,2]=a))
           then
           begin
             result:=i;
             i:=999;
           end;
         Until i>=Nbrcombos;
       end; {FindIndex}

     Var
       change:boolean;
       i,j,k,ii,jj:integer;
       a,b,c:integer;


       function setident(a,b,c,d,e,f,g,h,i:integer):integer;
       begin
          change:=true;
          result:=MrOK;
          If TruthTable[g,h,i]='U' then
          begin
            //TruthTable[g,h,i]:='F';
            reasons[g,h,i]:='Neg Identity: '+ StatToText(a,b,c) + ' and '
                + StatToText(d,e,f)+ ' therefore ' + StatToTextWithDefault(g,h,i,'F');
            updatetruthTable(g,h,i,'F',reasons[g,h,i]);
          end
          else
          begin
            if Truthtable[g,h,i]='T' then
            result:= messagedlg('Neg Identity: '+ StatToText(a,b,c) + ' and '
                + StatToText(d,e,f)+ ' therefore '
                + StatToText(g,h,i) +' failed because table entry is already set to True',
                mtconfirmation, [mbOK, mbCancel],0);
            errcode:=1;
            //result:=MrCancel;
          end;
        end;

     begin  {Negativeidentity}
       change:=false;
       errcode:=0;
       flag:=MrOK;
       for i:=1 to Nbrcombos do
       begin
         for j:=1 to NbrValues do
         begin
           for k:=1 to NbrValues do
           begin
             {find a true statement}
             if TruthTable[i,j,k] ='T' then
             begin
               for ii:= 1 to Nbrcombos do
               begin
                 {find a false statement with a variable in common with above}
                 if   (comboindex[ii,1]= comboindex[i,1])
                 and (comboindex[ii,2]<>comboindex[i,2]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,j,jj]='F' then
                     begin
                       a:=comboindex[ii,2];
                       b:=comboindex[i,2];
                       c:=findindex(a,b);
                       If a<b then
                       begin
                         {if combo eliminating common varable is 'U', change it to false}
                         //If TruthTable[c,jj,k]='T' then errcode:=20;
                         if TruthTable[c,jj,k]<>'F' then flag:= setident(i,j,k,ii,j,jj,c,jj,k);
                       end
                       Else
                       begin
                          //If TruthTable[c,k,jj]='T' then errcode:=21;
                         If TruthTable[c,k,jj]<>'F' then flag:=setident(i,j,k,ii,j,jj,c,k,jj);
                       end;
                     end;
                     if flag=mrcancel then break;
                   end;
                 end   {if comboindex}
                 Else If  (comboindex[ii,1]<>comboindex[i,1])
                    and (comboindex[ii,2]= comboindex[i,2]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,jj,k]='F' then
                     begin
                       a:=comboindex[ii,1];
                       b:=comboindex[i,1];
                       c:=findindex(a,b);
                       If a<b then
                       begin
                         //If TruthTable[c,jj,j]='T' then errcode:=30;
                         If TruthTable[c,jj,j]<>'F' then flag:=setident(i,j,k,ii,jj,k,c,jj,j);
                       end
                       Else
                       begin
                         //If TruthTable[c,j,jj]='T'then errcode:=31;
                         If TruthTable[c,j,jj]<>'F' then flag:=setident(i,j,k,ii,jj,k,c,j,jj);
                       end;
                     end;
                     if flag=mrcancel then break;
                   end;
                 end
                 Else
                 If  (comboindex[ii,1]<>comboindex[i,2])
                   and (comboindex[ii,2]= comboindex[i,1]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,jj,j]='F' then
                     begin
                       a:=comboindex[ii,1];
                       b:=comboindex[i,2];
                       c:=findindex(a,b);
                       if a<b then
                       begin
                         //If TruthTable[c,jj,k]='T' then errcode:=(40);
                         If TruthTable[c,jj,k]<>'F' then flag:=setident(i,j,k,ii,jj,j,c,jj,k);
                       end
                       else
                       begin
                         //If TruthTable[c,k,jj]='T' then errcode:=(41);
                         If TruthTable[c,k,jj]<>'F' then flag:=setident(i,j,k,ii,jj,j,c,k,jj);
                       end;
                       if flag=mrcancel then break;
                     end;
                   end;
                 end
                 Else If   (comboindex[ii,1]= comboindex[i,2])
                    and (comboindex[ii,2]<>comboindex[i,1]) then
                 begin
                   for jj:=1 to NbrValues do
                   begin
                     If TruthTable[ii,k,jj]='F' then
                     begin
                       a:=comboindex[ii,2];
                       b:=comboindex[i,1];
                       c:=findindex(a,b);
                       If a<b then
                       begin
                         //If TruthTable[c,jj,j]='T' then errcode:=(50);
                         If TruthTable[c,jj,j]<>'F' then flag:=setident(i,j,k,ii,k,jj,c,jj,j);
                       end
                       Else
                       begin
                         //If TruthTable[c,j,jj]='T' then errcode:=(51);
                         If TruthTable[c,j,jj]<>'F' then flag:=setident(i,j,k,ii,k,jj,c,j,jj);
                       end;
                     end;
                     if flag=mrcancel then break;
                   end;
                 end;
                 if flag=mrcancel then break;
               end;
             end;
             if flag=Mrcancel then break;
           end; {for k=}
           if flag=Mrcancel then break;
         end; {for j=}
         if flag=Mrcancel then break;
       end; {for i =}
       result:=change;

     end; {identity}

     {**************** ApplyIfRules ***********************}
     Function ApplyIfRules:boolean;

       {return count of X's in a factstring}
       Function Xcount(s:TFactString):integer;
       Var
         count:integer;
         i:integer;
       begin
         count:=0;
         For i:=1 to length(s) do if s[i]='X' then inc(count);
         result:=count;
       end;

       {return index of first non-X in a factstring}
       Function FirstNonX(s:TFactString):integer;
       Var i:integer;
       begin
         i:=1;
         while (i<=length(s)) and (s[i]='X') do inc(i);
         If i<=length(s) then result:=i
         Else result:=0;
       end;

       {Return index of 2nd non-X in a factstring}
       Function SecondNonX(s:TFactString):integer;
       Var i:integer;
       begin
         i:=1;
         while (i<=length(s)) and (s[i]='X') do inc(i);
         If i<length(s) then
         begin
           inc(i);
           while (i<=length(s)) and (s[i]='X') do inc(i);
         end;
         If i<=length(s) then result:=i
         Else result:=0;
       end;

      {*************** LookupIndex **************}
      Function LookupIndex(pos:integer;c:char):Integer;
       Var
         test:char;
         i:integer;
       begin
         test:=c;
         i:=0;
         While (i<NbrValues) and (Names[pos,i]<>test) Do inc(i);
         If Names[pos,i]=test then result:=i else result:=0;
       end;

       {************ LookupStat *************}
       Function Lookupstat(s:TFactString; var x,y,z:integer):char;
       var i,j:integer;
       begin
         result:='?';
         i:=FirstNonX(s);
         j:=SecondNonX(s);
         x:=Combolookup(i,j);
         y:=lookupindex(i,s[i]);
         z:=lookupindex(j,s[j]);
         If x>0 then result:=TruthTable[x,y,z];
       end;

       {*************** SetStatMP *************}
       Procedure SetstatMP(s:TFactString; x,y,z:integer;{v:char;} ruleid:string);
       {Set a fact based on Modus Ponens}
       Var i,j,j1,j2,ii:integer;
            r:string;
            oldtable:char;  {truth table value before change}
            v:char;
       begin
         i:=FirstNonX(s);
         j:=SecondNonX(s);
         ii:=Combolookup(i,j);
         if ii>0 then
         begin
           j1:=lookupindex(i,s[i]);
           j2:=lookupindex(j,s[j]);
           v:=s[length(s)]; {T or F value for "then" part of rule}
           If TruthTable[ii,j1,j2]<>v then
           begin
             oldtable:=TruthTable[ii,j1,j2];
             //TruthTable[ii,j1,j2]:=v;
             r:='Modus Ponens:  If '+ Stattotext(x,y,z)+' then '
                     + StattoTextWithDefault(ii,j1,j2,v)+'(Rule: '+ruleid+'), '+stattotext(x,y,z)
                     + ' therefore '+ StattotextWithDefault(ii,j1,j2,v);
             If oldtable='U' then
             begin
               reasons[ii,j1,j2]:=r;
               usedlist.add(ruleid);
               UpdateTruthTable(ii,j1,j2,v,r); //:=v;
             end
             else
             begin
               //Showmessage('Tried to apply'
               // +#13+ r
               // +#13+' but value had already been set to '+v+', change not applied');
                 haltflag:=haltflag or (messagedlg('Tried to apply' +#13+ r
                +#13+' but value had already been set to '+v+', change not applied',
                mtconfirmation, [mbOK, MbCancel],0)=mrCancel);
                TruthTable[ii,j1,j2]:=oldtable;
             end;
           end;
         end;
       end;



       {*************** SetStatMT *************}
       Procedure SetstatMT(s:TFactString; x,y,z:integer; {v:char;} ruleid:string);
       {Set a fact based on Modus Tollens}
       {Give statements  : "If A then B"
                           "Not B"
                           we can conclude "Not A"
                           }
       Var i,j,j1,j2,ii:integer;
            v:char;
            r:string;
            oldtable:char;  {truth table value before change}
       begin
         i:=FirstNonX(s);
         j:=SecondNonX(s);
         ii:=Combolookup(i,j);
         if ii>0 then
         begin
           j1:=lookupindex(i,s[i]);
           j2:=lookupindex(j,s[j]);
           {set v to negation of T/F value of "If part" of rule}
           if s[length(s)]='T' then v:='F' else v:='T';
           If TruthTable[ii,j1,j2]<>v then
           begin
             oldtable:=TruthTable[ii,j1,j2];
             TruthTable[ii,j1,j2]:=v;
             r:='Modus Tollens:  If '
                     + StattotextInverse(ii,j1,j2)+' then '
                     + StattotextInverse(x,y,z)+' (Rule: '+ruleid+'), '+stattotext(x,y,z)
                     + ' therefore '+ StattotextWithDefault(ii,j1,j2,v);
             upDatetruthTable(ii,j1,j2,v,r);
             If oldtable='U' then
             begin
               reasons[ii,j1,j2]:=r;
               usedlist.add(ruleid);
             end
             else
             begin
               TruthTable[ii,j1,j2]:=oldtable;
               haltflag:=haltflag or
               (messagedlg('Tried to apply'  +#13+ r
               +#13+' but value had already been set to '+v+', change not applied',
               mtconfirmation, [mbOK, MbCancel],0)=mrCancel);

             end;
           end;
         end;
       end;

       {************* OneDiff **************}
       Function OneDiff(r1,r2:TFactString):Boolean;
       Var
         i:integer;
         DiffCount:integer;
       begin
         Diffcount:=0;
         for i:=1 to {NbrVars  GDD 7/22/14} NbrVars+1  do if  r1[i]<> r2[i] then inc(diffCount);
         If diffcount=1 then result:=true
         Else result:=false;
       end;


     {***************** ApplyIfRules ************}
     Var
       change:boolean;
       i,j:integer;
       Ri1,Ri2,Rj1,Rj2:TFactString;
       x,y,z:integer;
       NewFact:TFact;
       r:char;
       s:string;
     begin  {ApplyIfRules}
       change:=false;
       if NbrIfRules>0 then
       For i:= 1 to NbrIfRules do
       begin
         {check modus ponens (premise is true)}
         s:=ifrules[i].ifpart;
         r:=lookupstat(s,x,y,z);
         If (r<>'U') and (r=s[length(s)]) {'T'}
         then setstatMP(ifrules[i].ThenPart,x,y,z,ifrules[i].ruleid)
         Else   {check modus tollens (conclusion is false)}
         begin
           s:=ifrules[i].thenpart;
           r:=lookupstat(s,x,y,z);
           If (r<>'U') and (r <> s[length(s)]) {='F'}
           then setstatMT(ifrules[i].IfPart,x,y,z,ifrules[i].ruleid);
         end;
       end;

       {Here's a tricky one Contradiction - if right side of one "if" rule matches
        left side of another and nonmatching parts differ in only one
        position - then the non-matching left side is false
        eg (XPX7T==>XJX1T) and (XJX1T==>XQX7T) ==> XPX7F
        If "P is 7" implies "J is 1", and "J is 1" implies "Q is 7" then P is not 7
        }

       for i:= 1 to NbrIfRules-1 do
       for j:= i+1 to NbrIfRules do
       begin
         Ri1:=ifrules[i].IfPart;
         Ri2:=ifrules[i].Thenpart;
         Rj1:=ifrules[j].Ifpart;
         Rj2:=ifrules[j].Thenpart;
         if (Ri2=rj1) and (onediff(Ri1,rj2))
         then
         begin
           Newfact.F:=Ri1;
           newfact.F[Nbrvars+1]:='F';
           Newfact.FactID:='Apply Fact';
           ApplyFact(newfact ,' By contradiction:',true);
         end

         else if (Rj2=ri1) and (onediff(Rj2,ri2))
         then
         begin
           Newfact.F:=Rj1;
           Newfact.F[nbrvars+1]:='F';
           Newfact.FactID:='Apply Fact';
           ApplyFact(newfact ,' By Contradiction:',true);
         end;
       end;
       Result:=change;
    end; {ApplyIfRules}


   Var
     change:boolean;
     i:integer;
     err, flag:integer;
   begin {Fillin}
     Repeat
       change:=false;
       for i:=1 to Nbrcombos do
       begin
         If (flag<>mrcancel) and FillOnePossible(i)  then change:=true;
         If (flag<>mrcancel) and FillFalse(i) then change:=true;
       end;
       if flag<>mrcancel then
       begin
         {$IFDEF DEBUG} printarray('After Fill Part 1',-1); {$ENDIF}
         If PositiveIdentity(err,flag,true) then change:=true;
         If (err<>0) or (flag=mrCancel) then
         begin showmessage('PositiveIdentity error - halted');  halt(err); end;
         {$IFDEF DEBUG} printarray('After PositiveIdentity - Before Reductio ',-1); {$ENDIF}

         {$IFDEF DEBUG} printarray('Before identity',-1); {$ENDIF}
         if flag=MRCancel then haltflag:=true;
         if not haltflag then
         begin
           If Negativeidentity(err,flag) then change:=true;
           if flag=MRCancel then haltflag:=true;
         end;
         //if err<>0 then showmessage('System error in identity, code='+inttostr(err));
         {$IFDEF DEBUG} printarray('Before Apply IfRules',-1); {$ENDIF}
         If (not haltflag) and ApplyIfRules then change:=true;
         If (not haltflag) and ModusTollens then change:=true;
         if (not change) and (not haltflag)  then If ReductioAdAbsurdum then change:=true;  {use R.A. only as last resort}
       end
       else haltflag:=true;
     Until (change=false) or haltflag;
   end; {Fillin}

   begin {Solveit}
     ApplyFacts;
     {$IFDEF DEBUG} printarray('After applying rules',-1); {$ENDIF}
     FillIn; {Bulk of solution - tries several methods to resolve variable values
              and iterates as long as any cell changes}
     PrintArray('Final Arrays',-1);
   end; {Solveit}

{************** FormActivate ************}
procedure TSolveForm.FormActivate(Sender: TObject);
begin
  If tag>0 then exit; {no need to re-solve when just re-activated}
  tag:=1;
  With Game do
  begin
    if Init then
    begin
      ShowIfForm.IfRulesMemo.clear;
      If GetProblem
      then
      begin
        ResultsGrid.colcount:=nbrvars;
        resultsgrid.rowcount:=nbrvars;

        Solveit;
      end;
    end;
  end;
end;

{************ VarSelectGridClick ***********}
procedure TSolveForm.VarSelectGridClick(Sender: TObject);
begin
  With sender as tstringgrid do
  begin  game.combolookup(col,row);  end;
end;

{************TablesBtnClick *************}
procedure TSolveForm.TablesBtnClick(Sender: TObject);
begin
  with form2 do
  begin
    //width:=screen.Width;
    //height:=screen.Height;
    buildtables;
    show;
  end;
end;

{*********** GenIfBtnClick *************}
 procedure TSolveForm.GenIfBtnClick(Sender: TObject);
begin  ShowIfForm.show;  end;


{*************** LogBtnClick ************}
procedure TSolveForm.LogBtnClick(Sender: TObject);
begin
  Logform.show;
end;




procedure TSolveForm.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

Initialization
  begin  game:=TGame4.create;   end;



end.
