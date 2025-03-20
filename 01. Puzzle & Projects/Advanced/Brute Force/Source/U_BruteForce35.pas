unit U_BruteForce35;
 {Copyright  © 2000-2017, Gary Darby,  www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ BruteForce tries solves a class of problems that requires finding, from a
  defined set of possible solutions, a set of integers  which satisfy a given
  set of equations

 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, UcomboV2, Menus, Grids, ComCtrls, ActnList, shellAPI, ExtCtrls,
  Buttons, DFFUtils, JPEG;

const
  maxdigits=50; {maximum solutions}
  maxequations=50;
  maxterms=50; {max nbr of terms in an equation}

type
  TValueArray=array [0..maxdigits] of int64;
  float=single;
  optype=(plus, minus, times, divideby, power, lparen, rparen, equ, err, gt, lt, ne,le,ge,omod, oabs, none);
  Ttokentype=(variable, constant, operator, tokenerr);
  TOpRec=record
    case tokentype:TTokentype of
      variable:(variablenbr:int64);
      constant:(Constantvalue:int64{float});
      operator: (op:optype);
    end;

  TOpObj =class(TObject) {represent a term in equation list}
    r:TOprec;
  end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;

    Load1: TMenuItem;
    Save: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    New1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Load2: TMenuItem;
    Save1: TMenuItem;
    Save2: TMenuItem;
    New2: TMenuItem;
    ShowPostfix1: TMenuItem;
    ActionList1: TActionList;
    NewAction: TAction;
    LoadAction: TAction;
    SaveAction: TAction;
    SaveAsAction: TAction;
    Postfix: TAction;
    CloseTab: TAction;
    N3: TMenuItem;
    TitleAction: TAction;
    ChnageTitle1: TMenuItem;
    ShowPostFix3: TMenuItem;
    Options1: TMenuItem;
    ChangeTitle1: TMenuItem;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    ProbSheet: TTabSheet;
    Memo1: TMemo;
    FileNameLbl: TLabel;
    Solution: TLabel;
    Label1: TLabel;
    Digitsedt: TEdit;
    Label2: TLabel;
    EquEdt: TMemo;
    BFSolveBtn: TButton;
    IncSolveBtn: TButton;
    ProgressBar1: TProgressBar;
    Label3: TLabel;
    SolutionGrid: TStringGrid;
    StopBtn: TButton;
    StaticText1: TStaticText;
    Image1: TImage;
    Addimage: TMenuItem;
    SaveCSVBtn: TButton;
    CSVSaveDlg: TSaveDialog;
    VarSingle: TCheckBox;
    RepeatBox: TCheckBox;
    ImageAction: TAction;
    SaveAs2: TMenuItem;
    Memo2: TMemo;
    FirstSoltimeLbl: TLabel;
    DivideBox: TCheckBox;
    ShowSetupBtn: TButton;

    procedure BFSolveBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EquEdtChange(Sender: TObject);
    procedure CaseChange(Sender: TObject);
    procedure IncSolveBtnClick(Sender: TObject);
    procedure NewActionExecute(Sender: TObject);
    procedure LoadActionExecute(Sender: TObject);
    procedure SaveActionExecute(Sender: TObject);
    procedure SaveAsActionExecute(Sender: TObject);
    procedure PostfixExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure ChangeTitle1Click(Sender: TObject);
    procedure AddimageClick(Sender: TObject);
    procedure SaveCSVBtnClick(Sender: TObject);
    procedure BoxClick(Sender: TObject);
    procedure ShowSetupBtnClick(Sender: TObject);
  public
    errmsg:string;
    varlist:TStringlist; {list of variable for current problem}
    comboset:TComboset;
    solving:boolean; {Solving in progress}
    starttime,firstsolutiontime,tottime:TDateTime;
    newset:Tlist;
    digits,trialdigits,varflags:TValueArray;
    nbrdigits:integer;
    nbrEquations:integer;
    eqlist: array[1..maxequations] of TStringlist;
    astack:array[1..maxterms] of TopObj;
    scount:integer;
    loopcount,totloops:integer;
    combosets:array[1..maxequations] of Tcomboset;

    loadfilename,savefilename, imagefilename:string;
    modified:boolean; {True ==> loaded case has been modified}
    firsttime:boolean;  {first entry to form after creation}

    {case solution parameters holding variab;les}
    digitsEdtText:string;
    equeditLines:array of string;
    VarSinglechecked, RepeatBoxchecked, DivideboxChecked:Boolean;

    Function Solved:boolean;
    Function validdigits:boolean;
    Function validequations:boolean;
    Procedure showerror(newerrmsg:string);
    Function getdigits:boolean;
    Function eval(const equation:TStringlist; const trialdigits:TValueArray):Boolean;
    Procedure setuppostfix;
    Function Showsolution:integer;
    Function IncrementalSolve(equnbr:integer;
                              SelectedDigits,AvailableDigits,
                              varflags:TValueArray):boolean;
    function checkmodified:boolean;
    procedure loadfile(filename:string);
    procedure setsolvingstatus(r:boolean);
    procedure MakeNewProb;
  end;

var
  Form1: TForm1;
{
Mensa problem -
 'A*(100000000*A+10000000*B+1000000*C+100000*D+10000*E+1000*F+100*G+10*H+I)= (100000000*A+10000000*A+1000000*A+100000*A+10000*A+1000*A+100*A+100*A+10*A+A)'
}
implementation
  uses U_GetTitle, U_PostFix;

{$R *.DFM}

{****************** TFormq.ShowError **********}
Procedure tform1.showerror(newerrmsg:string);
  Begin
    errmsg:=newerrmsg;
    showmessage(errmsg);
  end;

{********************* TForm1.ValidDigits ****************}
Function TForm1.validdigits:boolean;
  var
    s,s2:string;
    p,n,errcode:integer;
    start,stop:integer;
  Begin
    result:=true;
    nbrdigits:=0;
    s:=trim(digitsedt.text);
    if length(s)>0 then
    begin
      if s[length(s)]<>',' then s:=s+',';
      while length(s)>0 do
      begin
        p:=pos(',',s);
        if p>0 then
        Begin
          s2:=copy(s,1,p-1);
          delete(s,1,p);
          p:=pos('-',s2);
          if p=0 then
          begin
            val(s2,n,errcode);
            if errcode=0 then
            begin
              inc(nbrdigits);
              if nbrdigits>maxdigits then
              begin
                showerror(format('No more than %d trial digits can be defined',
                                  [maxdigits]));
                break;
              end;
              digits[nbrdigits]:=n;
            end
            else if length(s2)>0 then showerror('Invalid digit ' + s2);
          end
          else
          begin {process a range of digits}
            val(copy(s2,1,p-1),start,errcode);
            if errcode=0
            then val(copy(s2,p+1,length(s2)-p),stop,errcode);
            if errcode=0 then
            begin
              if start<=stop then
              for n:=start to stop do
              begin
                inc(nbrdigits);
                if nbrdigits>maxdigits then
                begin
                  showerror(format('No more than %d trial digits can be defined',
                                    [maxdigits]));
                  break;
                end;
                digits[nbrdigits]:=n;
              end;
            end
            else showerror('Invalid range specified ' + s2);
          end;
        end;
      end;
    end
    else
    begin
      result:=false;
      showerror('Fill valid digits first');
    end;
  end;


{********************* TForm1.ValidEquations ******************}
Function TForm1.validequations:boolean;
{Validate all equations for the problem
 This is a large function with a number of embedded local functions}

  const
    opcount=14;
    opstrings:array[1..opcount] of string = ('**', '*', '/', '+', '-', '(','=','>','<','<>','>=','<=','%','|');
    {operation priorities in the stack}
    instackp:array[1..opcount] of int64 =  (3,2,2,1,1,0,0,0,0,0,0,0,2,2);
    {operation priorities as read}
    incomingp:array[1..opcount] of int64 = (4,2,2,1,1,4,0,0,0,0,0,0,2,4);

      {------------- GetNextToken ----------------}
      Function getnexttoken(var s:string):String;
     {Note this is a destructive GetNextToken function,
      i.e. token is removed from the beginning of the input string
      }
       const
         //'%'=mod, '|'=abs, '{'='<=', '}'='>='
         opset=['*','/','+','-','(',')','=','>','<','%','|']; {valid operator characters}
         tab:char=#09;
       var i, Len:integer;

       Begin
         result:='';
         trimleft(lowercase(s));
         Len:=length(s);
         if len=0 then exit;
         if (s[1] in opset)
             {or  ((len>3) and (lowercase(copy(s,1,4))='abs('))} then  {get an operator}
         Begin
           if (len=1) and (s<>')') then Begin Showerror('Missing operand at end'); exit; end
           else if (s[1]='*') and (s[2]='*') then Begin result:='**'; delete(s,1,2); exit; end
           else if (s[1]='<') and (s[2]='>') then Begin result:='<>'; delete(s,1,2);  exit; end
           else if (s[1]='<') and (s[2]='=') then Begin result:='<='; delete(s,1,2);  exit; end
           else if (s[1]='>') and (s[2]='=') then Begin result:='>='; delete(s,1,2);  exit; end;
           //else if (s[1]=len>3) and (s[1]='a') then begin result:='|'; delete(s,1,3); exit; end;


           result:=s[1];
           delete(s,1,1);
         end
         else
         Begin {get a variable or constant}
           i:=2;
           while (i<=length(s)) and not (s[i]in [' ']+opset) do inc(i);
           result:=copy(s,1,i-1);
           delete(s,1,i-1);
         end;
       end;

          {----------- getInstackP ------------}
          Function getinstackp(s:string):int64;
          {Get instack priority}
              var  i:integer;
            Begin
              i:=1;
              while (i<=opcount) and (s<>opstrings[i]) do inc(i);
              if i<=opcount then result:=instackp[i] else result:=-1;
            end;

        {-------------- GetIncomingP ---------}
         Function getincomingp(s:string):int64;
         {Get priority for incoming symbols}
              var  i:integer;
            Begin
              i:=1;
              while (i<=opcount) and (s<>opstrings[i]) do inc(i);
              if i<=opcount then result:=incomingp[i] else result:=-1;
            end;

         {----------------- MakeOpRec -----------}
         Function makeOpRec(const t:string):Topobj;
           {build an op object - contains a tokentype field
             and the variable, constant, or operator }
           var
             index:integer;
             n:int64;
             errcode:integer;
           Begin
             result:=topobj.Create;
             result.r.op:=none;
             {result.optoken:=t;}
             {check for variable}
             if upcase(t[1]) in ['A'..'Z'] then
             begin
               result.r.tokentype:=variable;
               index:=varlist.indexof(t);
               if index<0 then
               begin
                 varlist.add(t);
                 index:=varlist.count-1;
               end;
               result.r.variablenbr:=index;
             end
             {else check for constant}
             else if t[1] in ['0'..'9'] then
             Begin
               result.r.tokentype:=constant;
               val(t,n,errcode);
               if errcode<>0 then
               Begin
                 result.r.tokentype:=tokenerr;
                 showerror('Invalid constant ' +t);
               end
               else result.r.constantvalue:=n;
             end
             else {must be an operator}
             with result.r do
             Begin
               tokentype:=operator;
               case t[1] of
                    '+': op:=plus;
                    '-': op:=minus;
                    '*': if length(t)>1 then op:=power else op:=times;
                    '/': op:=divideby;
                    '=': op:=equ;
                    '(': op:=lparen;
                    ')': op:=rparen;
                    '>': if (length(t)=2) and (t[2]='=') then op:=ge else op:=gt;
                    '<': If (length(t)=2) then
                         begin
                           if t[2]='>' then op:=ne
                           else if t[2]='=' then op :=le;
                         end
                         else op:=lt;
                    '%': op:=omod;
                    '|': op:=oabs;
                    else
                    begin
                      op:=err;
                      tokentype:=tokenerr;
                      showerror('Unrecognized operator '+t);
                    end;
                end;
              end;
           end;

        {---------------- ParensBalanced -----------}
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
           if not result then showerror('Unbalanced parentheses in  equation'+#13+origs);
         end;

         {------------------ OneEqualsSign -------------}
         Function OneEqualsSign(origs:string):boolean;
         {Check for a single relations operator, =, <. or > for now}
           var
             s:string;
             t:string;
             n:integer;
         begin
           result:=true;
           s:=origs;
           t:=getnexttoken(s);
           if length(t)>0 then
           Begin
             n:=0;
             while t<>'' do
             Begin
               if (t[1] in ['=','>','<']) then
               begin
                  inc(n);
                  if (t[1]='<') and (s[1]='>') then delete(s,1,1);
               end;
               t:=getnexttoken(s);
             end;
             result:=n=1;
           end;
           if not result then showerror('Equation must contain one = or < or > sign'+#13+origs);
         end;

         {-------------- CheckMultiDigit ---------------}
         function CheckMultiDigit(var origs:string): boolean;
         {ABCD will be replaced by  ((((A*10+B)*10)+C)*10+D)
         assuming "Single letter variables" box is checked }

            function TwoLetters(s:string):integer;
            {check for first occurrents of 2 or more adjacent letters,
             return 0 to index of 1st qualifying letter}
             var
               i:integer;
             begin
               result:=0;
               for i:=1 to length(s)-1do
               if (s[i] in ['A'..'Z']) and (s[i+1] in ['A'..'Z']) then
               begin
                 result:=i;
                 break;
               end;
             end;


         var s:string;
             n:integer;
             i,j:integer;
             outs:string;
         begin  {CheckMultiDigit}
           result:=true;
           If not VarSingle.checked then exit;

           outs:='';
           s:=uppercase(origs);

           repeat
             n:=TwoLetters(s); {check for adjacent letters}
             if n>0 then
             begin
               outs:=outs+copy(s,1,n-1);
               delete(s,1,n-1);
               i:=1; {start of 1 character variable names}
               While (i<=length(s)) and (s[i] in ['A'..'Z']) do inc(i);
               //If s[i]<>')' then result:=false
               //else
               begin
                 dec(i);
                 outs:=outs+stringofchar('(',i);
                 for j:= 1 to i-1 do outs:=outs+s[j]+')*10+';
                 outs:=outs+s[i]+')';
               end;
               delete(s,1,i);
             end;
           until (n=0) or (result=false);
           if result then
           begin
             origs:=outs+s;
           end;
         end;

 var
    i,j:integer;
    s:string;
    t,y:string;
    stack:Tstringlist; {could use TStack here with later versions of Delphi}
    opobj, stackobj:topobj;
    prevop:string;

  Begin {validequations}
    result:=true;
    nbrequations:=0;
    stack:=TStringlist.create;
    varlist.clear;
    for i:=0 to equedt.lines.count-1 do
    if (length(trim(equedt.lines[i]))>0) and (equedt.lines[i][1]<>';') then
    Begin

      s:=equedt.lines[i];
      {use % for mod function}
      s:=stringreplace(s,' MOD ',' % ',[rfreplaceall, rfignorecase]);
      s:=stringreplace(s,'ABS(',' |(',[rfreplaceall, rfignorecase]);
      s:=stringreplace(s,' LE ',' { ',[rfreplaceall, rfignorecase]);
      s:=stringreplace(s,' GE ',' } ',[rfreplaceall, rfignorecase]);

      for j:=length(s) downto 1 do if s[j]=' ' then delete(s,j,1); {remove blanks}
      if CheckMultidigit(s) and parensbalanced(s) and oneEqualsSign(s) then
      Begin
        errmsg:='';
        stack.clear;
        t:=getnexttoken(s);
        inc(nbrequations);
        if assigned (eqlist[nbrequations]) then
        with eqlist[nbrequations] do
        begin
          {GDD - memory leak fixed Dec 2008}
          for j:=0 to count-1 do TOpOBj(objects[j]).free;
          freeandnil(eqlist[nbrequations]);
        end;
        //if assigned (eqlist[nbrequations]) then freeandnil(eqlist[nbrequations]);
        eqlist[nbrequations]:=TStringlist.create;
        prevop:=' ';
        while t<>'' do
        {build a list of equation elements in postfix order}
        with eqlist[nbrequations] do
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
          Begin
            showerror('Error reported in equation '+equedt.lines[i]);
            result:=false;
            exit;
          end;
          {save token for later check for 2 adjacent opeators}
          if opobj.r.tokentype=operator
          then prevop:=t   else prevop:=' ';
          if (opobj.r.tokentype=variable) or (opobj.r.tokentype=constant)
          then addobject(t,opobj)
          else if opobj.r.op=rparen then
          Begin  {close paren,')', found, unstack back to '('}
            while stack[stack.count-1]<> '(' do
            Begin
              y:=stack[stack.count-1];
              stackobj:=topobj(stack.objects[stack.count-1]);
              addobject(y,stackobj);
              stack.delete(stack.count-1);
            end;
            Topobj(stack.objects[stack.count-1]).free; {free the lparen object}
            stack.delete(stack.count-1);
            opobj.free; {free the r paren object}
          end
          else
          Begin  {operator}
            while (stack.count>0)
               and (getinstackp(stack[stack.count-1]) >= getincomingp(t)) do
            Begin
              y:=stack[stack.count-1];
              stackobj:=TOpobj(stack.objects[stack.count-1]);
              addobject(y,stackobj);
              stack.delete(stack.count-1);
            end;
            stack.Addobject(t, opobj);
          end;
          t:=getnexttoken(s);
        end;

        {no more tokens, add remainder of stack to postfix list}
        while stack.count>0 do
        Begin
          stackobj:=TOpobj(stack.objects[stack.count-1]);
          eqlist[nbrequations].addobject(stack[stack.count-1],stackobj);
          stack.delete(stack.count-1);
        end;
      end;
      if errmsg<>'' then result:=false;
    end;
    if nbrdigits=0 then validdigits;
    if (varlist.count>nbrdigits) and (not repeatbox.checked) then
    Begin
      showerror('Number of variables ('+ inttostr(varlist.count)
              +') exceeds the number of available digits ('+inttostr(nbrdigits)+')');
      result:=false;
    end;
    stack.free;
    setuppostfix;
    if result then
    with solutiongrid do
    Begin
      rowcount:=varlist.count+1;
      colcount:=1;
      for i:=0 to varlist.count-1 do cells[0,i+1]:=varlist[i]+'=';
      SaveCSvBtn.enabled:=false;
    end;
  End;  {validequations}




{********************** TForm1.GetDigits ********************}
Function TForm1.getdigits:boolean;
{Get the next permutation of solutions digits to try}
var  i:integer;
  Begin
    result:=Comboset.getnext;
    if result then
    for i:=1 to {nbrdigits} varlist.count do
      trialdigits[i]:=digits[comboset.selected[i]];
  end;

{******************** TForm1.Eval **************************}
Function TForm1.eval(const equation:TStringlist; const trialdigits:TValueArray):Boolean;
{Evaluate a single equation, true if satisfied}
  var
    opobj,workobj:TopObj;
    opa,opb:{float}int64;
    i:integer;
  Begin
    result:=false;
    scount:=0     ;
    with equation do
    for i:= 0 to count-1 do
    begin
      opobj:= topobj(objects[i]);
      with opobj do
      begin
        if (r.tokentype in [variable,constant]) then
        Begin
          inc(scount);
          workobj:=astack[scount];
          with workobj do
          Begin
            r:=opobj.r;
          end;
        end
        else
        begin    {op found}
          with astack[scount].r do
          if tokentype=variable then
          opb:=trialdigits[variablenbr+1]
          else opb:=constantvalue;
          if  opobj.r.op<>oabs then
          begin
            dec(scount);
            with astack[scount].r do
            begin
              if tokentype=variable then opa:=trialdigits[variablenbr+1]
              else opa:=constantvalue;
            end;
          end
          else opa:=high(integer);
          with astack[scount].r do
          begin
            tokentype:=constant;
            {variablenbr:=0;}
            case opobj.r.op of
              plus:  constantvalue:=opa+opb;
              times: constantvalue:=opa*opb;
              minus: constantvalue:=opa-opb;
              divideby:
              begin
                if opb<>0 then constantvalue:=opa div opb
                else exit;
                if dividebox.checked and (constantvalue*opb <> opa) then exit;
              end;
              equ: result:=opa=opb;{abs(opa -opb)<1e-6;}
              gt: result:=opa>opb;
              lt: result:=opa<opb;
              ne: result:=opa<>opb;
              le: result:=opa<=opb;
              ge: result:=opa>=opb;
              omod: constantvalue:=opa mod opb;
              oabs: constantvalue:=abs(opb);
            end;
          end;
        end;
      end;
    end;
  end;


{****************** TForm1.setuppostfix *********************}
  Procedure tform1.setuppostfix;
  {Put the postfix form of the equations into display form }
    var
      i,j:integer;
      s:string;
    Begin

      Postfixform.postfixmemo.lines.clear;
      for i:= 1 to nbrequations do
      Begin
        s:='';
        for j:=1 to eqlist[i].count
          do s:=s+' '+eqlist[i].strings[j-1];
        PostFixForm.postfixmemo.LineS.add(s);
      end;
    end;


{******************** TForm1.Solved **********************}
Function TForm1.Solved:boolean;
{The main Brute Force solve loop}
  var
    i:integer;
    qsolved,triedall:boolean;
    count:int64;
  Begin
    triedall:=false;
    qsolved:=false;
    loopcount:=0;
    count:=0;
    progressbar1.max:=(comboset.getcount{numberOfSubsets}) mod high(integer);
    repeat
      {get a permutation of solution digits to try}
      if not getdigits
      then triedall:=true
      else
      begin
        inc(count);
        //trialdigits:=test;   {for testing}
        qsolved:=true;
        i:=1;
        while (i<=nbrequations) and qsolved  do
        begin
          inc(loopcount);
          if (loopcount and $FFFFF)=0 then  {update display and process messages occasionally}
          begin
            label3.caption:=format('%.0n',[0.0+(comboset.getcount{numberOfSubsets}-count)])
                                     +' possible solutions remaining';
            progressbar1.position:=(count) mod high(integer);
            application.processmessages;
            loopcount:=0;
          end;
          {check this solution for equation i}
          if not eval(eqlist[i],trialdigits) then qsolved:=false;
          inc(i);
        end;
      end;
    until qsolved or triedall or (tag>0);
    label3.caption:='0 possible solutions remaining';
    result:=qsolved;
    if result then SaveCsvBtn.enabled:=true;
  end; {Solved}


{*********************** TForm1.IncrementalSolve ***************}
Function TForm1.IncrementalSolve(equnbr:integer;
                            SelectedDigits, AvailableDigits,
                            varflags:TValueArray):boolean;
{Alternate solution method}
{Recursive function to Find the solution for the first equation, then retain these
  values and try other combinations of unused solution values to satisfy other equations.
  Do this recusively until all equations have been satisfied}
 {Works best in problems with lots of equations and allowing the same value
  to be assigned to multple variables }
  {Varflags is an integer array with an entry for each variable.  If for variable
   N, varflags[N] is greater than 0 then that variable has had its value assigned
   by equation varflags[n].

   }

  var
    eqsolved,triedall:boolean;
    NewAvailable, NewSelectedDigits:TValueArray;
    comboset2:TComboset;
    nbrnewvars,i,k:integer;

  Function GetAvailable(const Selected:TValueArray):TvalueArray;
  {Return the original digits which are not in the Selected digits array}
   var
     i,j,k:integer;
     nbrselected:integer;
   begin
     result:=digits;
     nbrselected:=selected[0];
     k:=0;
     for i:=1 to digits[0] do
     Begin
       j:=1;
       while (j<=nbrselected) and (selected[j]<>digits[i]) do inc(j);
       if j>nbrselected then
       Begin
         inc(k);
         result[k]:=digits[i];
       end;
     end;
     result[0]:=digits[0]-nbrselected;
    { if k<>nbrdigits-nbrselected then showmessage('GetAvailable error');}
   end;


   Function getdigits2(const digits:TValueArray; var trialdigits:TValueArray):boolean;
   {Digits is the array of values available to be assigned to variables}
   {Trialdigits will be filled with the next permuted subset "Digits" to fill
    into the current equation to test if it represents a solution for that equation}
     var
       i:integer;
    begin
      result:=Comboset2.getnext;
      if result then
      begin
        for i:=1 to comboset2.getr do
          trialdigits[i]:=digits[comboset2.selected[i]];
          trialdigits[0]:=comboset2.getr;
      end
      else trialdigits[0]:=0;
    end;

  var
    l:Tstringlist;

  Begin   {IncrementalSolve}
    {debug}
    (*
    with memo3.lines do
    begin
      s:=''; for i:=1 to digits[0] do s:=s+inttostr(digits[i]);
      s2:=''; for i:=1 to trialdigits[0] do s2:=s2+inttostr(trialdigits[i]);
      add(format('Eq:%d, Used %s, Avail: %s',[equnbr,s2,s]));
    end;
    *)
    comboset2:=combosets[equnbr];
    nbrnewvars:=0;
    {Get current equation, fill in varflags array for variables
    that exist in this equation, and count new variables not used in previous equations}
    L:=eqlist[equnbr];
    for i:= 0 to L.count-1 do
    with tOpobj(l.objects[i]).r do
    Begin {scan this equation looking for variables}
      if tokentype=variable then
      Begin
        if varflags[variablenbr+1]=0 then
        Begin
          inc(nbrnewvars);
          varflags[variablenbr+1]:=equnbr;
        end;
      end;
    end;

    if not repeatbox.checked then Comboset2.setup(nbrnewvars,AvailableDigits[0],permutations)
    else Comboset2.setup(nbrnewvars,AvailableDigits[0],PermutationsWithRep);
    eqsolved:=false;
    triedall:=false;

    {loop for this equation}
    //label3.caption:='Trying solutions for equation '+inttostr(equnbr);
    //label3.Update;
    //DebugMemo.lines.add(label3.caption);
    while (tag=0) and (not triedall) do
    Begin
      inc (loopcount);
      if loopcount and $FFFFF=0 {>=10000} then
      Begin
        totloops:=totloops+loopcount;
        label3.caption:='Trying solution '+inttostr(totloops)
                        +#13+' Current equation '+inttostr(equnbr);
        application.processmessages;
        loopcount:=0;
      end;
      if (nbrnewvars=0) then
      Begin
        triedall:=true;
        NewSelectedDigits:=selecteddigits;
      end
      else
      Begin
        NewSelectedDigits:=selecteddigits;
        {we have new variables to permute on}
        if  not getdigits2(AvailableDigits,trialdigits) then
        begin
          triedall :=true;
          nbrnewvars:=0;
        end
        else
        begin
          k:=0;
          {fill in NewSelectedDigits from old digits array for previous
           equations, plus the new digits for the curent
           equation}
          if equnbr=1 then NewSelectedDigits[0]:=selecteddigits[0]+trialdigits[0];
          i:=1;
          while varflags[i]>0 do
          Begin
            if {(varflags[i]>0) and} (varflags[i]<equnbr)
            then NewSelectedDigits[i]:=selectedDigits[i]
            else if varflags[i]=equnbr then
            Begin
              inc(k);
              NewSelectedDigits[i]:=trialdigits[k];
            end;
            inc(i);
          end;
          NewSelectedDigits[0]:=i-1;
          end;
          NewSelectedDigits[0]:=selectedDigits[0]+nbrnewvars;
        end;
        (*
        s:=''; for i:=1 to selecteddigits[0] do s:=s+inttostr(selecteddigits[i]);
        s2:=''; for i:=1 to newselecteddigits[0] do s2:=s2+inttostr(newselecteddigits[i]);
        if triedall then msg:='Tried all' else msg:='';
        memo3.lines.add(format('   %s  %d OldSel: %s, %d Newsel: %s',[msg, selecteddigits[0],s,newselecteddigits[0],s2]));
        *)
        {evaluate current equation with this set}
        if eval(eqlist[equnbr],NewSelectedDigits) then
        Begin
          (*  {Debugging code}
          s:='';
          for i:=1 to NewSelectedDigits [0] do s:=s+inttostr(NewSelectedDigits[i])+', ';
          debugmemo.lines.add(format('Eq %d solved w values %s',[equnbr,s]));
          *)
          if (equnbr=nbrequations) and (newselectedDigits[0]=varlist.count) then {solution found for all equations!}
          Begin
            trialdigits:=NewSelectedDigits;
            if  showsolution <>mryes then triedall:=true;
            eqsolved:=true;
          end
          else
          if equnbr<nbrequations then
          Begin {get the new list of solutions we have left to work with}
            if not repeatBox.checked then NewAvailable:=GetAvailable(NewSelectedDigits)
            else NewAvailable:=AvailableDigits;  {same set for each trial};
            {and try solving the next equation}

            eqsolved:=IncrementalSolve(equnbr+1,NewSelectedDigits,NewAvailable,
                                  varflags);
          end;
        end;
      end;
 //end;

    result:=eqsolved; {feed status back to previous level}
    if result then
    begin
      SaveCsvBtn.enabled:=true;
    end
  end;



{**************************** TForm1.ShowSolution ***************}
Function TForm1.Showsolution:integer;
{Display a solution }
   var
     i,j:integer;
     unique,match:boolean;
     stringdigits:array[1..maxdigits] of string;

   begin
     result:=mryes;
     tottime:=tottime+time-starttime;
     with solutiongrid do
     if colcount>100 then
     begin
       showmessage('Max of 100 solutons found');
       self.tag:=1;
       result:=mrno;
     end
     else
     begin
       if colcount=1 then
       begin
         unique:=true;
         firstsolutiontime:=time-starttime;
         FirstSolTimeLbl.caption:=' 1st solution found in '+format('%.2f',[firstsolutiontime*SecsPerDay])+' seconds';
       end
       else
       begin
         {convert trialdigits to string form to check against existing solutions}
         for i:=1 to varlist.count do stringdigits[i]:=inttostr(trialdigits[i]);
         {make sure it's unique}
         unique:=true;
         {set unique to false if all values match values in any column}
         for i := 1 to colcount-1 do
         begin
           match:=true;
           for j:=1 to varlist.count do
           if cells[i,j]<>stringdigits[j]
           then
           begin
             match:=false;
             break;
           end;
           if match=true then
           begin
             unique:=false;
             break;
           end;
           if not unique then break;
         end;
       end;

       if unique then
       begin
           colcount:=colcount+1;
           fixedcols:=1;
           cells[colcount-1,0]:='#'+inttostr(colcount-1);
           for i:=1 to varlist.count do
             cells[colcount-1,i]:=inttostr(trialdigits[i]);
        end;
        application.processmessages;
        //sortgrid(solutiongrid,0);
        starttime:=time;
     end;
   end;

 {********************* TForm1.SetSolvingStatus ***************}
 procedure Tform1.setsolvingstatus(r:boolean);
 var
   i:integer;
 begin
   If r then {set display things up for solving}
   begin

     {Initialize combination sets}
     if not repeatbox.checked then
     begin
       if (nbrdigits<varlist.count) then
       begin
         for i:=nbrdigits+1to varlist.count do digits[i]:=digits[nbrdigits];
         nbrdigits:=varlist.count;
       end;
       Comboset.setup(varlist.count,nbrdigits,permutations)
     end
     else
     begin
       comboset.setup(varlist.count,nbrdigits,PermutationsWithRep);
     end;
     starttime:=time;
     tottime:=0;
     Stopbtn.visible:=true;
     tag:=0;
     solving:=true;
     screen.cursor:=crhourglass;
     stopbtn.cursor:=crdefault;
     FirstSolTimeLbl.Caption:='';
     with actionlist1 do
     for i:=0 to actioncount-1 do TAction(actions[i]).enabled:=false;
     setupPostFix;  {Load postfix form with equations}
   end
   else
   begin  {reset to normal after solving}
     tag:=0;
     solving:=false;
     Stopbtn.visible:=false;
     {tabcontrol1.enabled:=true;}
     screen.cursor:=crdefault;
     with actionlist1 do
     for i:=0 to actioncount-1 do TAction(actions[i]).enabled:=true;
   end;
 end; {SetSolvingStatus}


{********************** TForm1.SolveBtnClick ***************}
procedure TForm1.BFSolveBtnClick(Sender: TObject);
  var
    result:integer;
  begin
    If validdigits and validequations then
    Begin
      setsolvingstatus(true);
      repeat
        if not Solved then  {call Solved function}
        Begin
          screen.cursor:=crdefault;
          tottime:=tottime+time-starttime;
          sortgrid(solutiongrid,0);
          messagedlgpos(inttostr(SolutionGrid.colcount-1)+' solutions found'+#13
                 +' Run time was '+format('%6.2f',[tottime*SecsPerDay])+' seconds',
                 mtconfirmation,[mbOK],0,left+5,top+5);
          result:=mrno;

        end
        else result:=showsolution;
      until (tag>0) or (result<>mryes);
      setsolvingstatus(false);
    end;
  end;

{****************** TForm1.IncSolveBtnClick **************}
procedure TForm1.IncSolveBtnClick(Sender: TObject);
{inceremental solve}
 var
    gooddigits:tvaluearray;
    i:integer;

  begin
    If validDigits and validequations then
    Begin
      setsolvingstatus(true);
      gooddigits[0]:=0;
      for i:=1 to varlist.Count {high(digits)} do varflags[i]:=0;
      digits[0]:=nbrdigits;
      totloops:=0;
      loopcount:=0;
      //{debug} memo3.clear;
      IncrementalSolve(1,gooddigits,digits,varflags);
      tottime:=tottime+time-starttime;
      sortgrid(solutiongrid,0);
      messagedlgpos(inttostr(SolutionGrid.colcount-1)+' solutions found'+#13
              +' Run time was '+Format('%6.2f',[tottime*SecsPerDay])+' seconds',
               mtconfirmation,[mbOK],0,left+5,top+5);
      setsolvingstatus(false);
    end;
  end;

{********************** TForm1.FormActivate *******************}
procedure TForm1.FormActivate(Sender: TObject);
  var
    i:integer;
  begin
    if firsttime then {initialization stuff}
    begin
      varlist:=tstringlist.create;
      comboset:=TComboset.create;
      for i:= 1 to maxterms do astack[i]:=topobj.create;
      solving:=false;
      newset:=Tlist.create;
      for i:=1 to maxequations do combosets[i]:=Tcomboset.create;
      Probsheet.caption{Tabname}:='New';
      firsttime:=false;
      opendialog1.initialdir:=extractfilepath(application.exename);
      savedialog1.initialdir:=opendialog1.initialdir;
      CSVSavedlg.initialdir:=opendialog1.initialdir;
      Pagecontrol1.activepage:=Introsheet;
      Stopbtn.bringtofront;
      reformatmemo(memo2);
      modified:=false;
    end
  end;

{********************** Tform1.FormCloseQuery ******************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  tag:=1; {Stop execution if solving (?)}
  application.processmessages;
  if checkmodified {give user a chance to save any problem changes}
  then canclose:=true else canclose:=false;
end;

{******************* TForm1.FormClose ***************************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   action:=cafree;
end;

{****************** TFom1.EquEdtChange *******************}
procedure TForm1.EquEdtChange(Sender: TObject);
{An equation changed - revalidate}
begin
  If length(digitsedt.text)>0 {check equations if some digits have been entered}
  then validequations;
  modified:=true;
end;

{**************************TForm1.Case Change ***************}
procedure TForm1.CaseChange(Sender: TObject);
{General input parameter change exit, mark case as modified}
begin
  modified:=true;
end;

{***************** TForm1.Loadfile *****************}
 procedure Tform1.loadfile(filename:string);
 {Load a new problem file}
  var
    line:string;
    mode:integer;
    f:Textfile;
    tempmod:boolean;  {need to set modifed to true only if bad picture data is found, else false}
    OK:boolean;
 begin
   checkmodified;
   assignfile(F,filename);
   loadfilename:=filename;
   reset(f);
   nbrequations:=0;
   digitsEdtText:='';
   setlength(equeditLines,10);
   varlist.clear;
   equedt.lines.clear;
   memo1.lines.clear;
   mode:=255;
   Solutiongrid.colcount:=1;
   image1.picture.bitmap:=nil;// .Height:=0;
   image1.Update;  {make existing image disappear!}

   imagefilename:='';
   varSingle.checked:=true;  {defaults}
   repeatbox.checked:=false;
   dividebox.Checked:=true;
   VarSinglechecked:=true;
   RepeatBoxChecked:=false;
   DivideboxChecked:=true;
   OK:=true;
   tempmod:=false;
   while not eof(f) do
   begin
     readln(f,line);
     if (length(line)>0) and (ord(line[1])<=08) then  mode:=ord(line[1])
     else
     begin
       If mode =1 then  probsheet.caption:=line
       else if mode =2 then  memo1.Lines.add(line)
       else if mode=5 then {Image}
       begin
         if fileexists(line) then
         try
           image1.Picture.loadfromfile(line);
           imagefilename:=line;
         except
           begin
             showmessage('Image file '+line+ ' appears to be invalid.');
             tempmod:=true;
           end;
         end
         else
         begin
           showmessage('Image file '+line +' does not exist.');
           tempmod:=true;
         end
       end
       else
       case ord(mode) of
        03: {Numbers} digitsEdtText:=line;// digitsedt.text:=line;
        04: {Equations}
          begin
            if length(line)>0 then
            begin
              inc(nbrequations);
              if nbrequations>high(equeditLines) then setlength(equeditlines,nbrequations+10);
              equeditLines[nbrequations]:=line;
              //equedt.lines.add(line);
            end;
          end;
        06: VarSinglechecked:=Boolean(strtoint(line[1]));
        07: RepeatBoxchecked:=Boolean(strtoint(line[1]));
        08: DivideboxChecked:=Boolean(strtoint(line[1]));
        else
        begin
          showmessage('Puzzle file format error, no Title, Description, Numbers, or '
                             +'Equations line found before line'
                           +#13+line);
          OK:=false;
        end;
       end; {case}
       if not OK then break;
     end;
   end;
   closefile(f);
   savefilename:=loadfilename;
   filenamelbl.caption:='File: '+extractfilename(loadfilename);
   pagecontrol1.activepage:=Probsheet;
   if OK then
   begin
     reformatMemo(Memo1);
     SaveCSVBtn.enabled:=false;
     setlength(equeditlines, nbrequations+1); {+1 because index 0 string is not used}
     showSetupBtn.Enabled:=true;
     if messagedlg('Prefill setup and equations?', mtconfirmation, [mbyes,mbno],0)=mryes
     then showsetupBtnClick(self);
     modified:=tempmod;  {normally false, true if specified picture was not found, saving will remove image file name}
   end;
 end;

{***************** ShowSetupBtnClick **********}
procedure TForm1.ShowSetupBtnClick(Sender: TObject);
var
  i:integer;
  savemodified:boolean;
begin
  savemodified:=modified;
  {loading these fields will set  modified flag to true}
  {we'll save and restore to leave it unchanged}
  Digitsedt.text:=digitsEdtText;
  equedt.clear;
  For i:=1 to nbrequations do equedt.Lines.add(equeditLines[i]);
  varsingle.checked:=VarSinglechecked;
  RepeatBox.checked:=RepeatBoxchecked;
  dividebox.checked:=DivideboxChecked;
  modified:=savemodified;
  scrolltotop(equedt);
end;




{****************** TForm1.Checkmodified *****************}
function Tform1.CheckModified:boolean;
{Call before loading a new file to ensure chance to save old case}
var
  msg:string;
  r:integer;
begin
  result:=true;
  If modified then
  begin
    if loadfilename='' then msg:='Save new file?'
    else msg:='Save file '+loadfilename+'?';
    r:=messagedlg(msg,mtconfirmation,[mbyes,mbno,MBCANCEL],0);
    if r=mryes
    then
    begin
      savefilename:=loadfilename;
      saveActionExecute(self);
    end;
    if r=mrcancel then result:=false
    else modified:=false;
  end;
end;

{****************** MakeNewProb **********}
procedure TForm1.MakeNewProb;
var i:integer;
begin
  if checkmodified then
  begin
    Memo1.lines.clear;
    EquEdt.lines.clear;
    loadfilename:='';
    savefilename:='';
    imagefilename:='';
    image1.picture.bitmap:=nil;// .height:=0;
    image1.update;
    DigitsEdt.text:='';
    modified:=false;;
    with solutionGrid do
    begin
      colcount:=1;
      for i:=0 to rowcount-1 do cells[0,i]:='';
    end;
    SaveCSVBtn.enabled:=false;
    Probsheet.caption:='New';
    varsingle.checked:=true;
    repeatbox.Checked:=false;
    dividebox.Checked:=true;
    ShowSetupBtn.Enabled:=false;
    pagecontrol1.ActivePage:=Probsheet;
  end;
end;


{************** NewActionExecute **********}
procedure TForm1.NewActionExecute(Sender: TObject);
begin
  MakeNewProb;
end;

{******************* TForm1.LoadActionExecute ************}
procedure TForm1.LoadActionExecute(Sender: TObject);
{Action to load a problem}
begin
  with opendialog1 do
  begin
    opendialog1.filterindex:=1;
    title:='Select a problem';
    filename:=loadfilename;
    If execute then loadfile(FileName);
  end;
end;

{******************* TForm1.SaveActionExecute **************}
procedure TForm1.SaveActionExecute(Sender: TObject);
{Save a problem}
  var
    i:integer;
    f:textfile;
    s:string;
 begin
   If (savefilename='') and (loadfilename='')
   then SaveasActionExecute(sender)
   else
   begin
     {Make names match if either is blank}
     If (loadfilename<>'') and (savefilename='') then savefilename:=loadfilename;
     If (savefilename<>'') and (loadfilename='') then loadfilename:=savefilename;
     {save if names match, or names don't match and file exists  and user says OK to replace,
      or file doesn't exist}
     If  (loadfilename=savefilename)
       or
       ((loadfilename<>savefilename)
        and  (fileexists(savefilename))
        and (messagedlg('Overwrite '+savefilename+'?',mtConfirmation,[mbyes,mbno],0)=mryes)
       )
       or (not fileexists(savefilename))
     then
     Begin
       If probsheet.caption='New' then
       begin
         s:=extractfilename(savefilename);
         probsheet.caption:=copy(s,1,length(s)-4);
       end;
       assignfile(f,savefilename);
       rewrite(f);
       writeln(f,#01+'Title');
       writeln(f,probsheet.Caption);
       writeln(f,#02+'Description');
       for i:= 0 to memo1.lines.count-1 do writeln(f,memo1.lines[i]);
       writeln(f,#03+'Numbers');
       writeln(f,digitsedt.text);
       writeln(f,#04+'Equations');
       for i:=0 to equedt.lines.count-1 do writeln(f,equedt.lines[i]);
       loadfilename:=savefilename;
       filenamelbl.caption:='File: '+extractfilename(loadfilename);
     end;
     If image1.picture.height>0 then
     begin
       s:=extractfileext(imagefilename);     {preserve the image file type}
       imagefilename:=changefileext(savefilename,s);
       image1.picture.savetofile(imagefilename);
       writeln(f,#05+'Imagefile');
       writeln(f,extractfilename(Imagefilename));
     end;
     writeln(f,#06+'SingleCharacterVariables?');
     writeln(f,inttostr(integer(varSingle.checked)));
     writeln(f,#07+'DuplicateVarValuesOK?');
     writeln(f,inttostr(integer(RepeatBox.checked)));
     writeln(f,#08+'Divides must be exact?');
     writeln(f,inttostr(integer(Dividebox.checked)));
     closefile(f);
     modified:=false;
   end;
 end;

{************TForm1.SaveAsActionExecute ***************}
procedure TForm1.SaveAsActionExecute(Sender: TObject);
{SaveAs }
begin
  savedialog1.options:=savedialog1.options+[ofoverwritePrompt];
  If savedialog1.execute then
  Begin
    savefilename:=savedialog1.filename;
    saveActionExecute(sender);
  end;
  savedialog1.options:=savedialog1.options-[ofoverwritePrompt];
end;

{*********************TForm1.PostFixExecute ****************}
procedure TForm1.PostfixExecute(Sender: TObject);
{show postfix form of equations}
begin
  Postfixform.show;
end;

{*************** TForm1.FormCreate **************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  firsttime:=true; {first time switch tested by formactivate}
  {MakeCaption('Brute Force', #169 +'2000, G Darby, DelphiForFun.org',self);}
  reformatmemo(memo1);

  setmemomargins(memo2, 16,16,16,16);
  reformatmemo(memo2);
end;

{******************** TForm1.StopBtnClick *****************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

{*************** Exit1Click ***********}
procedure TForm1.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
               nil, nil, SW_SHOWNORMAL);
end;

{************** ChangeTitleClick ***********}
procedure TForm1.ChangeTitle1Click(Sender: TObject);
begin
  gettitle.titleEdt.text:=probsheet.caption;
  If getTitle.showmodal=mrOK then
  begin
    Probsheet.caption:=gettitle.titleEdt.text;
    modified:=true;
  end
end;

{**************** AddImageClick *************}
procedure TForm1.AddimageClick(Sender: TObject);
{Add or change the image associated with a puzzle}
var
  s:string;
begin
  with opendialog1 do
  begin
    filterindex:=2;
    title:='Select an image';
    if imagefilename<>'' then filename:=imagefilename
    else filename:=changefileext(loadfilename,',jpg');
    if not fileexists(filename) then
    begin
      filename:=changefileext(loadfilename,',bmp');
      if not fileexists(filename) then filename:='';
    end;
    if fileExists(filename) and (messagedlg('Remove current image?', mtconfirmation,
                    [MBYes, MBNo], 0) = MrYes)
    then
    begin
      imagefilename:='';
      image1.picture:=nil;
      modified:=true;
    end
    else
    if Execute then
    begin
      imagefilename:=filename;
      s:=lowercase(extractfileext(filename));
      if not ((s='.bmp') or (s='.jpg'))
      then
      begin
        showmessage('Ignored - Only ".bmp" or ".jpg" image files are allowed');
        image1.Picture.bitmap.Height:=0;
      end
      else image1.picture.loadfromfile(imagefilename);

    end;
  end;
end;

{*************** SaveCSVBtnClick ***********}
procedure TForm1.SaveCSVBtnClick(Sender: TObject);
{Save solutions as a "comma separated values" (CSV) file}
var
  i,j:integer;
  f:textfile;
  s:string;
  CSVfilename:string;
begin
   CSVSaveDlg.filename:=changefileext(savefilename,'.CSV');
   if CSVSaveDlg.execute  then
   with  solutiongrid do
   begin
     CSVfilename:=CSVSaveDlg.filename;
     assignfile(f,csvfilename);
     rewrite(f);
     writeln(f,probsheet.caption);
     for i:= 0 to colcount-1 do
     begin
       s:='';
       for j:=0 to rowcount-1 do s:=s+cells[i,j]+',';
       writeln(f,s);
     end;
     closefile(f);
   end;
end;

procedure TForm1.BoxClick(Sender: TObject);
{Set modified flag for any checkboc click}
begin
  modified:=true;
end;


end.




