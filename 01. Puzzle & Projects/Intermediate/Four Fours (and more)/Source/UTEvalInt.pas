unit UTEvalInt;
{Copyright � 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface
uses sysutils, classes, dialogs, math;

const
  evalmaxterms=10;
  {const}  {info used for evaluating expressions}
    opcount=6;
    opstrings:array[1..opcount] of string = ( '*', '/', '+', '-', '^', '(');
    {operation priorities in the stack}
    instackp:array[1..opcount] of int64 =  (2,2,1,1,3,0);
    {operation priorities as read}
    incomingp:array[1..opcount] of int64 = (2,2,1,1,3,4);
    maxopset:set of char=['*','/','+','-','^','(',')']; {valid input operator characters}

type

  numformat=int64;

type
  optype=(plus, minus, times, divideby, lparen, rparen, exp, err, none);
  Ttokentype=(variable, constant, operator, tokenerr);

  TOpRec=record  {the stack records containing an operand in the expression}
    case tokentype:TTokentype of
      variable:(variablenbr:integer);
      {"Constantvalue" is logically an integer but defining it as single allows
       interim results to be fractional values}
      constant:(Constantvalue:numformat);
      operator: (op:optype);
    end;


  TOpObj =class(TObject) {represent a operand or operator as an object}
    id:string;  {the text version of item}
    r:TOprec;
  end;


TEvalInt=class(TObject)
 private
   varlist:TStringlist; {contains variable names with integer values as "objects"}
   func:string; {the input expression}

   postfixlist:TStringlist; {list of expression terms in postfix format after parsing}
   value:numformat; {the calculated value of the expression}
   //astack:array[1..evalmaxterms] of TopObj; {temp storage while evaluating}
   OPSET:SET OF CHAR;//=['*','/','+','-','^','(',')']; {VALID INPUT OPERATOR CHARACTERS}

   function validexpression:boolean; {validate the input expression}
   function eval:Boolean; {evaluate the expression after it has been determined to be vaild}
   procedure showerror(msg:string); {post an error}


  public
    lasterror:string; {last error message}

    verboseList:TStringlist;   {evaluation text detail}
    verbose:boolean;   {flag to control whether verbose text is created}

    {the methods which the user may call}
    constructor  create;
    destructor destroy; reintroduce;
    procedure clearvariables;
    procedure SetOps(s:string); {set of operators to use for current instance}

    {pass a variable name and a value}
    function addvariable(newvarname:string; newvarval:numformat):boolean;

    {Evaluate an expression an return the value in "newval"}
    function evaluate(newexpression:string;var newval:Numformat):boolean;

    {Return the latest error message}
    function getlasterror:string;
  end;


implementation

uses mathslib;

{**** Create ***********}
constructor TEvalInt.create;
begin
  inherited;
  VarList:=TStringlist.create;
  PostFixlist:=Tstringlist.create;
  clearvariables;
  lasterror:='No error';
  verboselist:=TStringlist.create;

  opset:=maxopset;
end;


{*********** Destroy ********}
destructor TEvalInt.destroy;
var i:integer;
begin
  VarList.free;
  if postfixlist.count>0 then
  with postfixlist do for i:= count-1 downto 0 do TOpObj(objects[i]).free;
  PostFixlist.free;
  verboselist.free;
  inherited;
end;


{********** Clearvariables *****}
procedure TEvalInt.clearvariables;
begin
  varlist.clear;
end;

{*********** AddVariable *********}
function TEvalInt.addvariable(newvarname:string; newvarval:numformat):boolean;
begin
  if varlist.addobject(uppercase(newvarname),TObject(newvarval))>=0
  then result:=true
  else
  begin
    showmessage('Variable addition for '+newvarname+' failed.');
    result:=false;
  end;
end;

{********** Evaluate *********}
function TEvalInt.evaluate(newexpression:string;var newval:numformat):boolean;
{evaluate the expression defined by the string "newexpression" and return the
 value in "newval"}
begin
  func:=newexpression;
  if verbose then
  with verboselist do
  begin
    add('-------------------------------');
    add('Evaluating expression '+newexpression);
    add('Phase 1: Build PostFix list');
  end;
  if validexpression then
  begin
    if eval then
    begin
      newval:=value;
      result:=true;
    end
    else
    begin
      showerror('System error, validate expression failed to evaluate');
      result:=false;
    end;
  end
  else result:=false;
end;

{********* ShowError *******}
procedure TEvalInt.showerror(msg:string);
begin
  lasterror:=msg;
end;

{************ GetLastError ***********}
function TEvalInt.getlasterror:string;
begin
  result:=lasterror;
end;


 
//var
//  opset:set of char=['*','/','+','-','^','(',')']; {valid input operator characters}

procedure TEvalInt.Setops(s:string);
{The subset of the set ['*','/','+','-','^']  to be used.}
var
  i:integer;

begin
  opset:=['(',')'];
  for i:=1 to length(s) do if s[i] in maxopset then opset:=opset+[s[i]]
  else
  begin
    showError('Invalid operator ' +s[i] +
            ' passed in in Setops procedure psrsmeter '+s);
    opset:=maxopset;
  end;
end;


{********* ValidExpression **********}
function TEvalInt.validexpression:boolean;
{function to validate an expression before attempting to evaluate it}
{also buils the postfix list in the process}


      {**************** GetNextToken ************}
      Function getnexttoken(var s:string):String;
     {Note this is a destructive GetNextToken function,
      i.e. token is removed from the beginning of the input string
      }
       
       const
         tab:char=#09;
       var i:integer;
       Begin
         result:='';
         trimleft(s);
         if length(s)=0 then exit;
         if s[1] in opset then  {get an operator}
         begin
           if (length(s)=1) and (s<>')') then
           begin
             Showerror('Missing operand at end');
             exit;
           end;
           result:=s[1];
           delete(s,1,1);
         end
         else
         begin {get a variable or constant}
           i:=2;
           while (i<=length(s)) and not (s[i]in [' ']+opset) do inc(i);
           result:=copy(s,1,i-1);
           delete(s,1,i-1);
         end;
       end;

         {*********** getInstackP ************}
         Function getinstackp(s:string):int64;
         {Get instack priority}
           var  i:integer;
           begin
             i:=1;
             while (i<=opcount) and (s<>opstrings[i]) do inc(i);
             if i<=opcount then result:=instackp[i] else result:=-1;
           end;

         {************** GetIncomingP *********}
         Function getincomingp(s:string):int64;
         {Get priority for incoming symbols}
              var  i:integer;
            begin
              i:=1;
              while (i<=opcount) and (s<>opstrings[i]) do inc(i);
              if i<=opcount then result:=incomingp[i] else result:=-1;
            end;

         {***************** MakeOpRec ***********}
         Function makeOpRec(const t:string):Topobj;
           {build an op object - contains a tokentype field
             and the variable, constant, or operator }
           var
             index:integer;
             //n:int64;
             x:numformat;
             errcode:integer;
           begin
             result:=topobj.Create;
             result.r.op:=none;
             result.id:=t;
             {check for variable}
             if upcase(t[1]) in ['A'..'Z'] then
             begin
               result.r.tokentype:=variable;
               index:=varlist.indexof(t);  {find the variable name in varlist}

               if index<0 then
               begin
                 showmessage('Variable '+t+' not defined in expression '+func);
                 result.r.tokentype:=tokenerr;
               end
               else result.r.variablenbr:=index;
             end
             {else check for constant}
             else if t[1] in ['0'..'9'] then
             Begin
               result.r.tokentype:=constant;
               val(t,x,errcode);
               if errcode<>0 then
               Begin
                 result.r.tokentype:=tokenerr;
                 showerror('Invalid constant ' +t);
               end
               else result.r.constantvalue:=x;
             end
             else {must be an operator}
             with result.r do
             Begin
               tokentype:=operator;

               case t[1] of
                    '+': op:=plus;
                    '-': op:=minus;
                    '*': op:=times;
                    '/': op:=divideby;
                    '(': op:=lparen;
                    ')': op:=rparen;
                    '^': op:=exp;
                    else
                    begin
                      op:=err;
                      tokentype:=tokenerr;
                      showerror('Unrecognized operator '+t);
                    end;
               end;
             end;
           end;

        {**************** ParensBalanced ***********}
         Function Parensbalanced(origs:string):boolean;
         {Check for balanced partheses}
           var
             t:string;
             n:integer;
             s:string;
         begin
           s:=origs;
           t:=getnexttoken(s);

           n:=0;
           while t<>'' do
           Begin
             if t[1]='(' then inc(n) else if t[1]=')' then dec(n);
             t:=getnexttoken(s);
           end;
           result:=n=0;
           if not result then showerror('Unbalanced parentheses in  expression'+#13+origs);
         end;

 var
    i,j:integer;
    s:string;
    t,y:string;
    astack:array[1..evalmaxterms] of TopObj; {temp storage while evaluating}
    opobj, stackobj:topobj;
    prevop:string;
    scount:integer;

  begin {validequations}
    result:=true;
    scount:=0;
    s:=func;
    for j:=length(s) downto 1 do if s[j]=' ' then delete(s,j,1); {remove blanks}
    if  parensbalanced(s) then
    begin
      t:=getnexttoken(s);
      if postfixlist.count>0 then
      with postfixlist do for i:=0 to count-1 do TOpObj(objects[i]).free;
      postfixlist.clear;
      prevop:=' ';
      while t<>'' do
      {build a list of equation elements in postfix order}
      with postfixlist do
      begin
        opobj:=makeoprec(t);
        if   {check for adjacent operators}
              (prevop<>' ')
          and (prevop<>'(')
          and (prevop<>')')
          and (opobj.r.tokentype=operator)
          and (opobj.r.op<>lparen)
          and (opobj.r.op<>rparen)
        then
        begin
          showerror('Two adjacent operators found, "'
          +prevop+'" and "'+ t+'"');
          opobj.r.tokentype:=tokenerr;
        end;

        if (opobj.r.tokentype=tokenerr) then
        begin
          result:=false;
          exit;
        end;
        {save token for later check for 2 adjacent operators}
        if opobj.r.tokentype=operator
        then prevop:=t   else prevop:=' ';
        if (opobj.r.tokentype=variable) or (opobj.r.tokentype=constant)
        then
        begin
          if verbose then verboselist.add('___Add operand "'+t+ '" to PostFix');
          addobject(t,opobj);
        end
        else if opobj.r.op=rparen then
        begin  {close paren,')', found, unstack back to '('}
          if scount>0 then
          begin
            if verbose then verboselist.add('__Right paren found, unstack temp back to "("');
            while (scount>=0) and (astack[scount].id<> '(') do
            begin
              y:=astack[scount].id;
              stackobj:=topobj(astack[scount]);
              addobject(y,stackobj);
              dec(scount);
              if verbose
              then verboselist.add('______Pop "'+stackobj.id + '" from temp and add to PostFix');
            end;
            Topobj(astack[scount]).free; {free the lparen object}
            dec(scount);
            if verbose then verboselist.add('___Pop "(" from temp stack');
          end;
          opobj.free; {free the r paren object}
        end
        else
        begin  {operator}
          while (scount>0)
             and (getinstackp(astack[scount].id) >= getincomingp(t)) do
          begin
            if verbose then verboselist.add('___Push operator "'+t+ '" to a temporary stack');
            y:=astack[scount].id;
            stackobj:=TOpobj(astack[scount]);
            if verbose then verboselist.add('___Operator "'+t+ '" lower priority, pop higher priority temp stack item "'
                  + astack[scount].id +'" and add to postfix');

            addobject(y,stackobj);
            dec(scount);
          end;
          if verbose then verboselist.add('___Push "'+t+ '" to temp stack');
          inc(scount);
          astack[scount]:=opobj;
        end;
        t:=getnexttoken(s);
      end;
      {no more tokens, add remainder of stack to postfix list}
      while scount>0 do
      begin
        stackobj:=TOpobj(astack[scount]);
        if verbose then verboselist.add('___No more operators, pop temp stack item "'
                  + astack[scount].id +'" and add to PostFix');
        postfixlist.addobject(stackobj.id,stackobj);
        dec(scount);
      end;
    end
    else result:=false;
    if verbose then
    begin
      s:='';
      with postfixlist do for i:=0 to count-1 do s:=s+', '+strings[i];
      delete(s,1,2); {get rid of the extra ', ' at start od string}
      verboselist.add('___Final postfixlist: {'+s+'}');
    end;
  End;  {addequations}

{******************** TEvalInt.Eval **************************}
Function TEvalInt.eval:Boolean;
{Evaluate a single expression in postfix form, returns true if satisfied}
  const intermediateresult='Intermediate result';
  var
    opobj:TopObj;
    opa,opb:numformat;
    i:integer;
    scount:integer;
    astack:array[1..evalmaxterms] of TopObj; {temp storage while evaluating}
    x:extended; {used to test a^b result values too large for int64}
    OK:boolean;
  Begin
    result:=true;
    value:=0;
    scount:=0;
    if verbose then verboselist.add('Phase 2: Evaluate expression from PostFix List');
    with postfixlist do
    for i:= 0 to count-1 do
    begin
      opobj:= topobj(objects[i]);
      with opobj do
      begin
        if verbose then verboselist.add('___Retrieve next entry "'+id +'" from PostFix');
        if (r.tokentype in [variable,constant]) then
        Begin
          if verbose then verboselist.add('___Push "'+id + '" to temp stack');
          inc(scount);
          astack[scount]:=opobj;
        end
        else
        begin    {operation found}
          with astack[scount],r do
          {unstack 2 operands from astack}
          if tokentype=variable then
          begin
            opb:=numformat(varlist.objects[variablenbr]);
            if verbose then verboselist.add('___OpB = Pop variable '+ id
                    + ' (value '+format('%.2f',[opb]) + ') off of temp stack');
          end
          else
          begin
            opb:=constantvalue;
            if verbose then
            begin
              if id=intermediateresult
              then  verboselist.add('___OpB = Pop '+ id
                    + ' ('+format('%.2f',[opb]) + ') off of temp stack')
              else verboselist.add('___OpB = Pop constant '+id + ' off of temp stack');
            end;
          end;
          dec(scount);
          if astack[scount]<>nil then
          with astack[scount], r do
          begin
            if tokentype=variable then
            begin
              opa:=numformat(varlist.objects[variablenbr]);
              if verbose then verboselist.add('___OpA = Pop variable '+id
                    + ' value '+inttostr(opa) + ' off of temp stack');
            end
            else
            begin
              opa:=constantvalue;
              if verbose then verboselist.add('___OpA = Pop constant '+id + ' off of temp stack');
            end;
            {rather than delete the operand entry and re-add the result,
             we'll just change the properties of the existing obA stack entry}
            tokentype:=constant;
            id:=intermediateresult;
            case opobj.r.op of
              plus:  constantvalue:=opa+opb;
              times: constantvalue:=opa*opb;
              minus: constantvalue:=opa-opb;
              divideby:
                     if opb<>0 then constantvalue:=opa div opb
                     else
                     begin
                       showerror('Divide by zero, calculation aborted: '
                              +func);
                       constantvalue:=1;
                     end;
              exp:  begin
                      try
                       if opa>1 then
                       begin
                         OK:=true;

                         if abs(opb)*log10(opa)>(4000) then OK :=false
                         else
                         begin
                           x:=math.Intpower(opa+0.0,opb);
                           if x>high(int64) then OK :=false;
                         end;
                         if not OK then
                         begin
                           showerror('Result too large for Int64 type, set to 0: '
                                     +func);
                           constantvalue:=high(int64);
                         end
                         else constantvalue:=trunc(x);
                       end
                       else  constantvalue:=1; {0 or 1 to any power = 1}
                      except
                        showerror('Result too large for Int64 type, set to 0: '
                        +func);
                        constantvalue:=0;
                      end;
                    end;

            end;
            if verbose
            then verboselist.add(format('___Calculate %.2f %s %.2f = %.2f and '
                             +'push result to temp stack',[opa,opobj.id,opb,constantvalue]));
          end;
        end;
      end;
    end;
    if postfixlist.count=1 then
    begin    {expression was a single variable or constant}
      with astack[1].r do
      if tokentype=variable then value:=numformat(varlist.objects[variablenbr])
      else value:=constantvalue;
    end
    else if scount=1 then value:=astack[1].r.constantvalue
    else showerror('System error, too many operands');
    If verbose then verboselist.add(
       format('___Last added entry in temp stack is the result %6.2f',[value]));
  end;
end.




