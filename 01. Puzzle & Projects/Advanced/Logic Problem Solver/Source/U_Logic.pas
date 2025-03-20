unit U_Logic;
{Copyright 2002-2016 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Logic Problem Solver}
 {See program or www.delphiforfun.org/programs/logic_problem_solver.htm for more
  information.  U_Logic handles user input and prepares data for solving
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Grids, CheckLst, Menus, ExtCtrls, IniFiles,
  U_SolveUnit, Buttons, shellAPI, dffutils;

 type
    Tstmttypes=(SourceTextDef,textdef, vardef, Fact, seprule, ifrule
                   ,ChoiceStmt, Connect, Unknown );
 Const
    maxrefs=50;  {max reference statements in a case}
    varstrings:array[TStmttypes] of string=('SOURCE ', 'TEXT ','VAR ','STMT ',
                           'SEP ', 'IFRULE ', 'CHOICESTMT ','CONNECTWORD ','UNKNOWN ');
type
  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    LoadProb: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Solve1: TMenuItem;
    New1: TMenuItem;
    Author1: TMenuItem;
    Moveoriginalrulestouserrules1: TMenuItem;
    Moveuserrulestooriginalrules1: TMenuItem;
    Options1: TMenuItem;
    Connectingwords1: TMenuItem;
    ExplainwithVar: TMenuItem;
    LoadUser: TMenuItem;
    LoadOriginalRules1: TMenuItem;
    EnterAuthormode: TMenuItem;
    StaticText8: TStaticText;
    Panel1: TPanel;
    PageControl: TPageControl;
    IntroSheet: TTabSheet;
    Memo4: TMemo;
    TextSheet: TTabSheet;
    Label10: TLabel;
    Label11: TLabel;
    DescChgLbl: TLabel;
    DescMemo: TMemo;
    SourceMemo: TMemo;
    VarSheet: TTabSheet;
    VarChgLbl: TLabel;
    Vargrp: TGroupBox;
    ccccccccc: TLabel;
    VarDelBtn: TButton;
    VarBtn: TButton;
    EditVarValBtn: TButton;
    VarEdit: TEdit;
    ChgVarNameBtn: TButton;
    Memo5: TMemo;
    VarGrid1: TStringGrid;
    FactSheet: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SortfactsBtn: TButton;
    DelFactBtn: TButton;
    NewfactBtn: TButton;
    FactBtn: TButton;
    FactGrid: TStringGrid;
    Memo2: TMemo;
    StaticText1: TStaticText;
    UpDown1: TUpDown;
    FactRefBox: TComboBox;
    FactBox1: TComboBox;
    FactRGrp: TRadioGroup;
    FactBox2: TComboBox;
    OrderRuleSheet: TTabSheet;
    Label12: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    Label7: TLabel;
    Label6: TLabel;
    OrderGrid: TStringGrid;
    OrderRuleBtn: TButton;
    Memo3: TMemo;
    NewOrderRuleBtn: TButton;
    DelORuleBtn: TButton;
    SortORulesBtn: TButton;
    StaticText2: TStaticText;
    UpDown2: TUpDown;
    ComboBox1: TComboBox;
    OrderWithRespectToBox: TComboBox;
    GroupBox2: TGroupBox;
    TrueORuleBtn: TRadioButton;
    FalseORuleBtn: TRadioButton;
    OrderDifferenceBox: TComboBox;
    Ordername2Box: TComboBox;
    OrderRelationBox: TComboBox;
    Ordername1Box: TComboBox;
    IfRuleSheet: TTabSheet;
    Label13: TLabel;
    Label16: TLabel;
    Label14: TLabel;
    Memo1: TMemo;
    IfRuleGrid: TStringGrid;
    IfRuleBtn: TButton;
    NewIfRule: TButton;
    DelifRuleBtn: TButton;
    SortIRulesBtn: TButton;
    StaticText3: TStaticText;
    UpDown3: TUpDown;
    ComboBox2: TComboBox;
    IfValA1Box: TComboBox;
    TruthAGrp: TRadioGroup;
    IfValA2Box: TComboBox;
    IfValB1Box: TComboBox;
    TruthBGrp: TRadioGroup;
    IfValB2Box: TComboBox;
    ChoiceSheet: TTabSheet;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    ComboBox4: TComboBox;
    Choicename1Box: TComboBox;
    NewChoiceBtn: TButton;
    ChoiceBtn: TButton;
    DeletChoiceBtn: TButton;
    SortChoiceBtn: TButton;
    ChoiceGrid: TStringGrid;
    Memo6: TMemo;
    UpDown4: TUpDown;
    ChoiceOneOfBox: TComboBox;
    ChoicesListBox: TListBox;
    ConnectingPage: TTabSheet;
    Label15: TLabel;
    ConnectChgLbl: TLabel;
    ConnectGrid: TStringGrid;
    RuleSetRGrp: TRadioGroup;
    NoChangeLbl: TLabel;
    RuleSetLbl: TLabel;
    Memo7: TMemo;
    StartUp: TMenuItem;
    procedure SaveAs1Click(Sender: TObject);
    procedure LoadProbClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure OrdernameBoxChange(Sender: TObject);
    procedure OrderRuleBtnClick(Sender: TObject);
    procedure OrderWithRespectToBoxChange(Sender: TObject);
    procedure Ordername1BoxChange(Sender: TObject);
    procedure Solve1Click(Sender: TObject);
    procedure DescMemoExit(Sender: TObject);
    procedure StmtBoxChange(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Modify1Click(Sender: TObject);
    procedure DeleteRowClick(Sender: TObject);
    procedure GridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure GridMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure GridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure NewProbClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MemoChange(Sender: TObject);
    procedure VarEditChange(Sender: TObject);
    procedure FactBtnClick(Sender: TObject);
    procedure GridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Moverow1Click(Sender: TObject);
    procedure VarGrid1Click(Sender: TObject);
    procedure IfRuleBtnClick(Sender: TObject);
    procedure OriginalRules1Click(Sender: TObject);
    procedure NewfactBtnClick(Sender: TObject);
    procedure NewOrderRuleBtnClick(Sender: TObject);
    procedure NewIfRuleClick(Sender: TObject);
    procedure ConnectGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure ExplainwithVarClick(Sender: TObject);
    procedure Moveoriginalrulestouserrules1Click(Sender: TObject);
    procedure Moveuserrulestooriginalrules1Click(Sender: TObject);
    procedure LoadUserClick(Sender: TObject);
    procedure LoadOriginalRules1Click(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure FactBoxChange(Sender: TObject);
    procedure VarSheetExit(Sender: TObject);
    procedure SortBtnClick(Sender: TObject);
    procedure NewVarBtnClick(Sender: TObject);
    procedure RuleSetRGrpClick(Sender: TObject);
    procedure EnterAuthormodeClick(Sender: TObject);
    procedure VarDelBtnClick(Sender: TObject);
    procedure ChgVarNameBtnClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure EditVarValBtnClick(Sender: TObject);
    procedure DelFactBtnClick(Sender: TObject);
    procedure DelORuleBtnClick(Sender: TObject);
    procedure DelifRuleBtnClick(Sender: TObject);
    procedure OrderGridDblClick(Sender: TObject);
    procedure IfRuleGridDblClick(Sender: TObject);
    procedure FactGridDblClick(Sender: TObject);
    procedure UpDown1ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDown2ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure UpDown3ChangingEx(Sender: TObject; var AllowChange: Boolean;
      NewValue: Smallint; Direction: TUpDownDirection);
    procedure StaticText4Click(Sender: TObject);
    procedure ChoiceOneOfBoxChange(Sender: TObject);
    procedure NewChoiceBtnClick(Sender: TObject);
    procedure ChoiceBtnClick(Sender: TObject);
    procedure DeletChoiceBtnClick(Sender: TObject);
    procedure ChoiceGridDblClick(Sender: TObject);
    procedure Choicename1BoxChange(Sender: TObject);
    procedure StartUpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    authorflag:boolean;
  public
    { Public declarations }
    filename:string;
    modified:array[TStmtTypes] of boolean;
    problemloaded:boolean;
    nbrdescstmts:integer; {Number of numbered statements in description text}
    errorflag:boolean;
    {These arrays keep track of locations and counts of description statements
    - those that start with numbers and can be referenced by facts and rules}

    stmtstarts,stmtlines:array[1..maxrefs]of integer;
    stmtids:array[0..maxrefs] of string;

    startrow:integer;
    DragGrid:TStringgrid;
    rowdragging:boolean;
    modrow:integer;
    section:string;
    ini:TInifile;
    UnsavedVar:boolean;
    //Nbrvalues: integer;  {the number of values for each variable -
    //                        based on # defined for first variable}
    ChangeOK:boolean; {flag to prevent updating author data while in user mode}
    StartIniName:string;

    procedure adjustupdatepermissions;
    function  anyModified:boolean;
    Procedure CheckVarChange(oldvar,newvar:string); {update rules and facts
                                                     after variable name change}
    function CheckOrderVarBox(OrderNameBox:TComboBox):boolean;
    Procedure CheckValueChange(oldval,newval:string); {update rules and facts
                                                     after variable value change}
    procedure deleterow(grid:TStringgrid; r:integer); {delete a row from a stringgrid}

    procedure error(stmttype,errormsg,errorline:string);
    Procedure AddConnectGridHdr(Grid:TStringgrid);
    Procedure AddfactGridHdr(Fgrid:TStringgrid);
    Procedure AddChoiceGridHdr(Cgrid:TStringgrid);
    Procedure AddIfGridHdr(IGrid:TStringgrid);
    Procedure AddOrderGridHdr(Ogrid:TStringgrid);
    function  GetConnectRow(v1,v2:string):Integer;
    Function  GetVarIndex(s:string):integer;
    Function  GetVarname(inputvalue:string; var varnameindex,varvalueindex:integer):String;
    Function  GetValueCount(varname:string):integer;
    Procedure InitConnectGrid;
    Procedure InitProblem(newfilename:string);
    Procedure LoadDescStmtList(var List:TComboBox);
    Procedure LoadNameList(var list:TComboBox);
    procedure loadproblem;
    Procedure Loadsection;
    Procedure Loadstmt(memo:Tmemo;index:integer);
    Procedure LoadValList(var list:TComboBox);
    Procedure LoadValueItems(i:integer; listItems:Tstrings);
    Procedure MakeFact(FGrid:TStringgrid; Hdr:string; list:TStringlist);
    Procedure MakeIfRule(IGrid:TStringGrid; list:TStringList);
    Procedure MakeOrderRule(OGrid:TStringGrid; list:TStringList);
    Procedure MakeChoice(CGrid:TStringgrid; list:TStringlist);

    Procedure SaveProb;
    Procedure SetCaption;
    Procedure SetupSolution(FGrid,OGrid,Igrid, CGrid:TStringGrid);
    procedure Sortgrid(Grid : TStringGrid; const SortCol:array of integer);
    function  stmttype(s:string):TStmttypes;
    Function  ValidOneVarValue(varname,valname:string):boolean;
    Function  validvarvalue(s:string):Boolean;
    Function  validvarname(s:string; var index:integer):Boolean;
    Function  ValidTFValue(s:string):boolean;
    procedure setcell(grid:TStringGrid; col,row:integer; val:string);
  end;


var  Form1: TForm1;

implementation

{$R *.DFM}
Uses UcomboV2, math, U_EditVarValue, U_GetValCountDlg{, U_LogForm},
  U_LogForm;


{***************** StmtType *****************}
  function TForm1.stmttype(s:string):TStmttypes;
  var
    i:Tstmttypes;
    vs:string;
  begin
    result:=unknown;
    for i:=low(Tstmttypes) to  high(TStmtTypes) do
    Begin
      vs:=trimright(varstrings[i]);
      if (length(s)>=length(vs))
       and (comparetext(vs,copy(s,1,length(vs)))=0)
      then Begin result:=i; break; end;
    end;
  end;

  {************** AnyModified **********}
   function TForm1.anymodified:boolean;
   var  i:TStmtTypes;
   begin
     result:=false;
     for i:= low(TStmtTypes) to High(TStmtTypes) do if modified[i] then
     begin
       result:=true;
       break;
     end;
   end;


   {************** SetCaption **************}
   Procedure TForm1.SetCaption;
   var s:string;
   Begin
     s:=section;
     if s='ORIG' then s:='AUTHOR';
     Rulesetlbl.caption:=ExtractFileName(FileName)+ ' - '+ s + ' Facts & Rules';
   end;

  {*************** SortGrid ***********}
  procedure Tform1.Sortgrid(Grid : TStringGrid; const SortCol:array of integer);
  {Sort a grid on a specified column}
  var
     i,j : integer;
     temp:tstringlist;
     n:integer;
     swap:boolean;
  begin
    temp:=tstringlist.create;
    with Grid do
    for i := FixedRows to RowCount - 2 do  {because last row has no next row}
    for j:= i+1 to rowcount-1 do
    begin
      swap:=false;
      for n:=sortcol[0] to sortcol[high(sortcol)] do
      begin
        if AnsiCompareText(Cells[n, i], Cells[n,j]) > 0  then
        begin
          swap:=true;
          break;
        end
        else if AnsiCompareText(Cells[n, i], Cells[n,j]) <0 then break; {no swap}
      end; {only continue to next column is current columns are equal}

      if swap then
      begin
        temp.assign(rows[j]);
        rows[j].assign(rows[i]);
        rows[i].assign(temp);
        if row=j then row:=i else if row=i then row:=j;
        modified[fact]:=true;
      end;
    end;
    temp.free;
  end;


   {**************** LoadValueItems ***************}
   Procedure TForm1.LoadValueItems(i:integer; listItems:TStrings);
   {load values for a single variable into a combobox}
   var
    j:integer;
    w:string;
   Begin
     with TVariabletype(variables.objects[i]) do
     for j:= 0 to values.count-1 do
     Begin
       w:=values[j];
       listitems.add(w);
     end;
  end;

{************** LoadValList **************}
  Procedure TForm1.LoadValList(var list:TComboBox);
  {Load variable values into a list}
  var
    i:integer;
  Begin
    list.items.clear;
    list.items.add('No selection');
    list.itemindex:=0;
    for i:= 0 to variables.count-1 do LoadValueItems(i,list.items);
  end;


{************** LoadDescStmtList **************}
  Procedure TForm1.LoadDescStmtList(var List:TComboBox);
  var
    i:integer;
  Begin
    list.clear;
    list.items.add('None');

    for i:=1 to nbrdescstmts do list.items.add(Stmtids[i]);
    list.itemindex:=0;

  end;

{*************** LoadNameList ************}
  Procedure TForm1.LoadNameList(var list:TComboBox);
  var
    i:integer;
    w:string;
  Begin
    list.clear;
    list.items.add('No selection');
    list.itemindex:=0;
    for i:= 0 to variables.count-1 do
    with TVariabletype(variables.objects[i]) do
    Begin
      w:=name;
      list.items.add(w);
    end;
  end;

{***************** GetVarIndex ****************}
   Function TForm1.GetVarIndex(s:string):integer;
   {Return the variable index from the variables list}
   begin
     result:=variables.indexof(s);
   end;

{**************** GetVarName **************}
  Function TForm1.GetVarname(inputvalue:string; var varnameindex, varvalueindex:integer):String;
  {Given a variable value, get the variable name}
  var
    i,j:integer;
    found:boolean;
  Begin
    result:='Not found';
    Begin
      i:=0;
      found:=false;
      varnameindex:=-1;
      varvalueindex:=-1;
      while (i<=variables.count-1) and not found do
      with TVariabletype(variables.objects[i]) do
      Begin
        j:=0;
        while (j<=values.count-1) and not found do
        if comparetext(values[j],inputvalue)=0 then found:=true
        else inc(j);
        if not found then inc(i)
        else Begin result:=name; varnameindex:=i; varvalueindex:=j; end;
      end;
    end;
  end;


{******************* GetValueCount ******************}
  Function TForm1.GetValueCount(varname:string):integer;
  var
    i:integer;
    found:boolean;
  Begin
    result:=0;
    i:=0;
    found:=false;
    while (i<=variables.count-1) and not found do
    with TVariabletype(variables.objects[i]) do
    Begin
      if comparetext(name,varname)=0 then found:=true
      else inc(i);
      if found then result:=values.count;
    end;
  end;

{****************** ValiidTFValue *************}
  Function TForm1.ValidTFValue(s:string):boolean;
  Begin
    result:=false;
    If length(s)<>1 then exit;
    If (s[1] in ['T','F']) then result:=true;
  end;

{*************** ValidVarValue **************}
  Function TForm1.validvarvalue(s:string):Boolean;
  var
    i,j:integer;
    found:boolean;
  Begin
    i:=0;
    found:=false;
    while (i<=variables.count-1) and not found do
    with TVariabletype(variables.objects[i]) do
    Begin
      j:=0;
      while (j<=values.count-1) and not found do
      if (comparetext(values[j],s)=0) then found:=true
      else inc(j);
      if not found then inc(i);
    end;
    result:=found;
  end;

{*************** ValidOneVarValue ****************}
  Function TForm1.ValidOneVarValue(varname,valname:string):boolean;
  var
    i,j:integer;
  Begin
    result:=false;
    i:=GetVarIndex(varname);
    If i>=0 then
    with TVariabletype(variables.objects[i]) do
    Begin
      j:=values.indexof(valname);
      if j>=0 then result:=true;
    end;
  end;


{************** ValidVarName ****************}
  Function TForm1.validvarname(s:string; var index:integer):Boolean;
  {returns true if "s" is a valid variable name}
  var
    i:integer;
    found:boolean;
  Begin
    i:=0;
    index:=-1;
    found:=false;
    while (i<=variables.count-1) and not found do
    with TVariabletype(variables.objects[i]) do
    Begin
      if comparetext(name,s)=0 then
      begin
        found:=true;
        index:=i;
      end
      else inc(i);
    end;
    result:=found;
  end;



{VARIABLE SHEET ROUTINES}


procedure TForm1.setcell(grid:TStringGrid; col,row:integer; val:string);
    begin
      grid.cells[col,row]:=val;
      adjustwidth(grid,col,row);
    end;

{******************* VarGrid1Click *****************}
{User clicked on the variable grid - move item from grid back to
{    edit box so he can change or delete it}
procedure TForm1.VarGrid1Click(Sender: TObject);
var
  s:string;
begin
  s:='';
  with Vargrid1 do
  Begin
    
    VarEdit.text:=cells[0,row];
    UnSavedVar:=false;
  end;
end;


{***************** NewVarBtnClick *************}
procedure TForm1.NewVarBtnClick(Sender: TObject);
var
  i,j,k, index:integer;
  w:string;
  v:TVariableType;
  begin
    with varGrid1 do
    begin
      w:=varEdit.text;
      if trim(w)='' then showmessage('Please enter new variable name first')
      else
      begin
        if not validvarname(w,index) then
        begin  {new variable name}
          if (nbrvalues=0) then {for first variable, get nbr of values for each}
          with game do
          begin
            getvalcountdlg.showmodal;
            nbrvalues:=getvalcountdlg.valcount.value;
            setlength(truthtable,nbrcombos+1, nbrvalues+1, nbrvalues+1);
            setlength(reasons,nbrcombos+1, nbrvalues+1, nbrvalues+1);
            for i:=1 to high(truthtable) do
            for j:=1 to nbrvalues do
            for k:=1 to nbrvalues do
            begin
              truthtable[i,j,k]:='U';
              reasons[i,j,k]:='';
            end;
          end;

          if nbrvalues>0 then
          begin
            colcount:=nbrvalues+1;
            rowcount:=rowcount+1;
            fixedrows:=1; {in case this was the first variable added}
            row:=rowcount-1;
            v:=TVariabletype.create;
            v.numtype:=false;
            v.values:=TStringList.create;
            v.name:=w;
            variables.AddObject(w,v);
            setcell(vargrid1, 0,row,w); //cells[0,row]:=w;
            //adjustwidth(vargrid1,0,row);
            nbrvars:=variables.count;

            for i:=1 to colcount-1 do
            begin
              setcell(vargrid1,i,row,w+'_V'); //cells[i,row]:=w+'_V'+inttostr(i);
              v.values.add(cells[i,row]);
              //adjustwidth(vargrid1,i,row);
            end;
            modified[vardef]:=true;
            addconnectgridhdr(connectgrid);
          end;
        end
        else showmessage('Variable name already exists, cannot be added');
      end;
    end;
  end;


{******************* CheckVarChange ***************}
Procedure Tform1.CheckVarChange(oldvar,newvar:string);
var i:integer;
    list:Tstringlist;
    s:string;
begin
  with ordergrid do for i:=rowcount-1 downto 1 do
  if cells[4,i]=oldvar
  then if newvar='' then deleterow(ordergrid,i) else setcell(ordergrid,4,i,newvar); //cells[4,i]:=newvar;
  with choicegrid do for i:=rowcount-1 downto 1 do
  if cells[3,i]=oldvar
  then if newvar='' then deleterow(choicegrid,i) else setcell(ordergrid,3,i,newvar); //cells[3,i]:=newvar;

  {update the problem file}
  if problemloaded and fileexists(filename) then
  begin
    list:=TStringlist.create;
    list.loadfromfile(filename);
    for i:= list.count-1 downto 0 do
    begin
      s:=list[i];
      if (length(s)>5) and (copy(s,1,4)<>'TEXT') then {don't change description lines}
      begin
        if newvar<>'' then
        begin
          s:=stringreplace(s,oldvar,newvar,[rfReplaceall]);
          list[i]:=s;
        end
        else if pos(oldvar,s)>0 then list.delete(i);
      end;
    end;
    list.savetofile(filename);
    list.free;
  end;
end;

{************* CheckValueChange ***********}
Procedure Tform1.CheckValueChange(oldval,newval:string);
var i:integer;
    d:boolean;
    list:Tstringlist;
    s:string;



begin
  with factgrid do
  for i:=rowcount-1 downto 1 do
  begin
    d:=false;
    if cells[2,i]=oldval then
    if newval='' then d:=true else setcell(Factgrid,2,i,newval);//cells[2,i]:=newval;
    if cells[3,i]=oldval then
    if newval='' then d:=true else setcell(Factgrid,3,i,newval);//cells[3,i]:=newval;
    if d then deleterow(factgrid,i);
  end;
  with ordergrid do
  for i:=rowcount-1 downto 1 do
  begin
    d:=false;
    if cells[3,i]=oldval then
    if newval='' then d:=true else setcell(Ordergrid,3,i,newval); //cells[3,i]:=newval;
    if cells[5,i]=oldval then
    if newval='' then d:=true else setcell(Ordergrid,5,i,newval);//)cells[5,i]:=newval;
    if d then deleterow(ordergrid,i);
  end;
   with ifrulegrid do
   for i:=rowcount-1 downto 1 do
   begin
     d:=false;
     if cells[2,i]=oldval then
     if newval='' then d:=true else setcell(IfRuleGrid,2,i,newval);//cells[2,i]:=newval;
     if cells[4,i]=oldval then
     if newval='' then d:=true else setcell(IfRuleGrid,4,i,newval); //cells[4,i]:=newval;
     if cells[5,i]=oldval then
     if newval='' then d:=true else setcell(IfRuleGrid,5,i,newval); //cells[5,i]:=newval;
     if cells[7,i]=oldval then
     if newval='' then d:=true else setcell(IfRuleGrid,7,i,newval); //cells[7,i]:=newval;
     if d then deleterow(ifrulegrid,i);
   end;

   with choicegrid do
   for i:=rowcount-1 downto 1 do
   begin
     d:=false;
     if cells[2,i]=oldval then
     if newval='' then d:=true else setcell(ChoiceGrid,2,i,newval); //cells[2,i]:=newval;
     if cells[4,i]=oldval then
     if newval='' then d:=true else setcell(ChoiceGrid,4,i,newval); //cells[4,i]:=newval;
     if cells[5,i]=oldval then
     if newval='' then d:=true else setcell(ChoiceGrid,5,i,newval); //cells[5,i]:=newval;
     if cells[6,i]=oldval then
     if newval='' then d:=true else setcell(ChoiceGrid,6,i,newval); //cells[6,i]:=newval;
     if d then deleterow(factgrid,i);
   end;

   {update the problem file}
   if problemloaded and fileexists(filename) then
   begin
     list:=TStringlist.create;
     list.loadfromfile(filename);
     for i:= list.count-1 downto 0 do
     begin
       s:=list[i];
       if (length(s)>5) and (copy(s,1,4)<>'TEXT') then
       begin
         if newval<>'' then
         begin
           s:=stringreplace(s,oldval,newval,[rfReplaceall]);
           list[i]:=s;
         end
         else if pos(oldval,s)>0 then list.delete(i);
       end;
     end;
     list.savetofile(filename);
     list.free;
   end;
end;

{**************** ChgVarNameBtnClick **************}
procedure TForm1.ChgVarNameBtnClick(Sender: TObject);
var
  index :integer;
  w :string;
  begin
    with varGrid1 do
    begin
      w:=varEdit.text;
      if not validvarname(cells[0,row],index) then showmessage('System error - '
                            + cells[0,row] +' not found in variable table')
      else {change variable name}
      begin
        {i:=variables.indexof(cells[0,row]w);}
        variables[index]:=varedit.text;
        TVariabletype(variables.objects[index]).name:=varedit.text;
      end;
      CheckVarChange(cells[0,row],w); {change all occurences of old name to new
                                      in all rules and facts}

      setcell(vargrid1, 0, row,w);//cells[0,row]:=w;
      //adjustwidth(vargrid1,0,row);
      {unsavedvar:=false;}
      {modified[vardef]:=true;}
    end;
  end;

{***************** EditVarValBtnClick ***********}
procedure TForm1.EditVarValBtnClick(Sender: TObject);
var
  list:TStringList;
  w:string;
  i,index:integer;
begin
  with varGrid1 do
  begin
    w:=cells[col,row];
    if not validvarname(w, index) then showmessage('System error - '+ cells[col,row]
                                       +' not found in variable table')
    else {set up add/change variable values}
    with varvaldlg do
    begin
      caption:='Edit values for '+ w;
      label1.caption:='Enter '+inttostr(nbrvalues)+' values for '+w;
      Nbrval:=nbrvalues;
      list := TVariabletype(variables.objects[index]).values;
      varvalmemo.clear;
      for i:= 0 to list.count-1 do varvalmemo.lines.add(list[i]);
      if  varvaldlg.showmodal=mrOK then
      begin
        for i:= 0 to varvalmemo.lines.count-1 do
        with varvalmemo do
        begin
          if  list[i]<>lines[i] then
          begin
            checkvaluechange(list[i],lines[i]); {change facts and rules if necessary}
            cells[i+1,row]:=lines[i];
            list[i]:=lines[i];
          end;
        end;
      end;
    end;
  end;
end;


{******************* VarDelBtnClick **********}
procedure TForm1.VarDelBtnClick(Sender: TObject);
{Delete a variable }
var
    i, index:integer;
    s:string;
    v:TVariableType;
begin
  s:=vargrid1.cells[0,vargrid1.row];
  if (messagedlg('You are about to delete variable '+s
          +'. All facts, rules and other references to '+s
          + ' or any of its values will be deleted.  Proceed?',
          mtwarning, [mbyes,mbno],0)=mryes)
          and validvarname(s,index) then
  begin
    v:=Tvariabletype(variables.objects[index]);
    for i:=0 to v.Values.count-1 do checkvaluechange(v.values[i],'');
    Checkvarchange(s,'');
    deleterow(vargrid1,vargrid1.row);
    variables.delete(index);
    modified[vardef]:=true;
  end;
end;


{***************************************************}
{                Grid header Procedures             }
{***************************************************}


{****************** AddFactGridHdr ***************}
Procedure TForm1.AddfactGridHdr(Fgrid:TStringgrid);
var
  i:integer;
  Begin
    with Fgrid do
    Begin
      canvas.font.size:=font.size;
      colcount:=7;
      cells[0,0]:='Fact Nbr  ';
      cells[1,0]:='Ref  ';
      cells[2,0]:='Var #1  ';
      cells[3,0]:='Var #2  ';
      cells[4,0]:='T/F  ';
      cells[5,0]:='Enabled';
      cells[6,0]:='Used';
      for i:= 0 to colcount-1 do
      Begin
        colwidths[i]:=8;
        Adjustwidth(Fgrid,i,0);
      end;
      rowcount:=1;
    end;
  end ;



  {****************** AddOrderGridHdr ****************}
 Procedure TForm1.AddOrdergridHdr(OGrid:TStringgrid);
 var
   i:integer;
 Begin
   With {Ordergrid} Ogrid do
   Begin
     canvas.font.size:=font.size;
     cells[0,0]:='Order ID';
     cells[1,0]:='Ref  ';
     cells[2,0]:='Var #1  ';
     cells[3,0]:='Where  ';
     cells[4,0]:='Var #2  ';
     cells[5,0]:='W/respect to  ';
     cells[6,0]:='Separation  ';
     cells[7,0]:='T/F  ';
     cells[8,0]:='Enabled';
     cells[9,0]:='Used';
     for i:= 0 to 7 do
      Begin
        colwidths[i]:=8;
        Adjustwidth(Ogrid,i,0);
      end;
   end;
 end;

{******************** AddIfGridHdr ***************}
 Procedure TForm1.AddIfGridHdr(IGrid:TStringgrid);
 var
   i:integer;
 Begin
   With Igrid do
   Begin
     canvas.font.size:=font.size;
     cells[0,0]:='Rule Id  ';
     cells[1,0]:='Ref  ';
     cells[2,0]:='Var #1  ';
     cells[3,0]:='Truth  ';
     cells[4,0]:='Val #1  ';
     cells[5,0]:='Var #2  ';
     cells[6,0]:='Truth  ';
     cells[7,0]:='Val #2  ';
     cells[8,0]:='Enabled';
     cells[9,0]:='Used';
     for i:= 0 to 7 do
      Begin
        colwidths[i]:=8;
        Adjustwidth(igrid,i,0);
      end;
   end;
 end;
{****************** AddChoiceGridHdr ***************}
Procedure TForm1.AddChoiceGridHdr(Cgrid:TStringgrid);
var
  i:integer;
  Begin
    with Cgrid do
    Begin
      canvas.font.size:=font.size;
      colcount:=9;
      cells[0,0]:='Choice Nbr  ';
      cells[1,0]:='Ref  ';
      cells[2,0]:='Var #1  ';
      cells[3,0]:='One of Var ';
      cells[4,0]:='Choice 1  ';
      cells[5,0]:='Choice 2';
      cells[6,0]:='Choice 3';
      cells[7,0]:='Enabled';
      cells[8,0]:='Used';
      for i:= 0 to colcount-1 do
      Begin
        colwidths[i]:=8;
        Adjustwidth(Cgrid,i,0);
      end;
      rowcount:=1;
    end;
  end ;

{***************** AddConnectGridHdr ************}
 Procedure TForm1.AddConnectGridHdr(Grid:TStringGrid);
 {Build, or rebuild, connecting words grid}
 var
   i,j,n:integer;
   max:integer;
 Begin
   with Grid do
   Begin
     canvas.font.size:=font.size;
     rowcount:=2;
     colcount:=4;
     fixedrows:=1;
     fixedcols:=0;
     cells[0,0]:='Variable 1  ';
     cells[1,0]:='Positive verb  ';
     cells[2,0]:='Negative verb  ';
     cells[3,0]:='Variable 2  ';
     Adjustwidth(Grid,1,0);
     Adjustwidth(Grid,2,0);
     If Variables.count>0 then
     Begin
       Max:=variables.count*(variables.count-1);
       rowcount:=max+1;
       n:=1;
       for i:= 0 to variables.count-1 do
       for j:= 0 to variables.count-1 do
       if i<>j then
       begin
         cells[0,n]:=variables[i];
         cells[1,n]:=' is ';
         cells[2,n]:=' isn''t ';
         cells[3,n]:=variables[j];
         Adjustwidth(Grid,0,n);
         Adjustwidth(Grid,3,n);
         inc(n);
       end;
       rowcount:=n+1;
     end;

   end;
 end;

{STATEMENT SHEET ROUTINES}


{********************* MakeFact ********************}
Procedure Tform1.MakeFact(FGrid:TStringGrid;
                     hdr:string; list:TStringlist {refnbr, Name1, name2,Value, enabled:String});
 var i:integer;
  Begin
    with FGrid do
    Begin
      if rowcount=1 then AddfactGridHdr(FGrid);
      if modrow<0 then
      Begin
        rowcount:=rowcount+1;
        modrow:=rowcount-1;
        hdr:=hdr+inttostr(rowcount-1);
      end
      else hdr:=cells[0,modrow];

      fixedrows:=1;
      setcell(FGrid,0,modrow,hdr);
      //adjustwidth(FGrid,0,modrow);
      for i:=1 to 5 do
      begin
        setcell(FGrid,i,modrow,list[i-1]); //Cells[i,modrow]:=list[i-1];
        //AdjustWidth(Fgrid,i,modrow);
      end;
      {for single character reference, prefix with blank for sorting purposes}
      if length(cells[1,modrow])=1 then cells[1,modrow]:=' '+cells[1,modrow];
      cells[6,modrow]:='';  {blank out "used" column}
      col:=0;
      row:=modrow;
     { modrow:=-1;}
    end;
  end;

{******************** MakeOrderRule*************}
 Procedure TForm1.MakeOrderRule(OGrid:TStringGrid; list:TStringList);
 var i:integer;
  begin
    with Ogrid do
    begin
      if rowcount=1 then AddOrdergridHdr(OGrid);
      if rowcount<=modrow then rowcount:=modrow+1;
      if modrow<0 then
      begin
        rowcount:=rowcount+1;
        modrow:=rowcount-1;
        cells[8,modrow]:='X';
      end;
      fixedrows:=1;
      if trim(list[0])='' then cells[0,modrow]:='OR'+inttostr(modrow)
      else cells[0,modrow]:=list[0];
      adjustwidth(ogrid,0,modrow);
      for i:=1 to list.count-1 do
      begin
        setcell(Ogrid,i,modrow,list[i]);//cells[i,modrow]:=list[i];
        //Adjustwidth(Ogrid,i,modrow);
      end;
      {for single character ref #, prefix with blank for sorting purposes}
      if length(cells[1,modrow])=1 then cells[1,modrow]:=' '+cells[1,modrow];
      cells[9,modrow]:=''; {blank 'used' column}
      col:=0;
      row:=modrow;
      {modrow:=-1;}
    end;
  end;


{++++++++++++++++ MakeIfRule ***************}
Procedure TForm1.MakeIfRule(IGrid:TStringGrid; list:TStringList);
 var i:integer;
  begin
    with Igrid do
    begin

      if rowcount=1 then AddIfgridHdr(IGrid);
      if modrow<0 then
      begin
        rowcount:=rowcount+1;
        modrow:=rowcount-1;
        cells[8,modrow]:='X';
      end;
      if list[0]='' then cells[0,modrow]:='IR'+inttostr(modrow)
      else cells[0,modrow]:=list[0];
      fixedrows:=1;
      for i:=1 to list.count-1 do
      Begin
        cells[i,modrow]:=list[i];
        Adjustwidth(Igrid,i,modrow);
      end;
      {for single character ref #, prefix with blank for sorting purposes}
      if length(cells[1,modrow])=1 then cells[1,modrow]:=' '+cells[1,modrow];
      cells[9,modrow]:=''; {mark  col as unused'}
      col:=0;
      row:=modrow;
      {modrow:=-1;}
    end;
  end;

{****************************************************}
{               Fact Sheet procedures                }
{****************************************************}

{******************* FactBtnClick *************}
procedure TForm1.FactBtnClick(Sender: TObject);
var
  s:string;
  list:Tstringlist;
begin
  if not changeOK then
  begin
    showmessage('Author''s facts can be changed '
         +' only in "Author" mode.'+#13+'Use Options menu');
    exit;
  end;
    begin
      If FactRGrp.itemindex=0 then s:='True' else s:='False';
      list:=TStringlist.create;
      with list, FactRefBox do
      begin
        if itemindex>0 then add(stmtids[itemindex])
        else add('None');
        add(factbox1.text);
        add(factbox2.text);
        add(s);
        add('X');
      end;
      if FactRefBox.itemindex <=0 then list[0]:=' ';
      MakeFact(FactGrid,'F',list);
      list.free;
      modified[fact]:=true;
    end;
  {end;}
end;


{INITIALIZATION}

{******************* FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
  Startini:TInifile;
  test:boolean;
begin
  //authorflag:=true;
  reformatmemo(memo4);
  Enterauthormode.checked:=true;
  Enterauthormodeclick(sender); {will make author flag false}
  ini:=nil;
  If paramcount>0 then
  For i:= 1 to paramcount do
  if Uppercase(paramstr(i))='AUTHOR' then EnterAuthorModeclick(sender); {set flag true}
  Variables:=TStringlist.create;
  Initproblem('');

  nbrvalues:=0;
  PageControl.Activepage:=IntroSheet;

  SetMemoMargins(memo4, 20,4,10,4);  {in pixels}
  reformatMemo(memo4);
  Opendialog1.InitialDir:=extractfilepath(application.ExeName);
  StartIniName:=opendialog1.InitialDir+'\Logic.ini';
  StartIni:=TInifile.Create(StartIniName);
  with startini do
  begin
    test:=readBool('General', 'Startup',False);
    if test then
    begin
      startup.checked:=test;
      self.filename:=readstring('General','Problemname','');
      opendialog1.filename:=self.filename;
      loadProblem;
    end;
  end;
  startIni.Free;
end;

{*************** FormClose **************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var
  StartIni:TInifile;
begin
  Startini:=TInifile.Create(startIniName);
  with Startini do
  begin
    writeBool('General','Startup',Startup.checked);
    writestring('General', 'ProblemName', self.filename);
  end;
  StartIni.Free;
end;

{***************** Error ****************}
procedure TForm1.error(stmttype,errormsg,errorline:string);
begin
  showmessage(stmttype+#13+errormsg+#13+errorline);
  errorflag:=true;
end;

{MENU ROUTINES}

{******************* LoadSection ****************}
Procedure TForm1.Loadsection;

  {local procedure ****** MakeList *************}
  Procedure makelist(list:TStringList; s:String);
  {Load the current section values (USER or ORIG) }
  var
    i:integer;
    w:string;
  begin
    if list=nil then list:=TStringlist.create
    else list.clear;
    i:=1;
    w:='';
    while i<=length(s) do
    begin
      while (i<=length(s)) and (s[i]<>',') do
      begin
        w:=w+s[i];
        inc(i);
      end;
      inc(i);
      w:=trim(w);
      list.add(w);
      w:='';
    end;
  end;

  {local function **************** GetStmtType *************}
  Function getstmttype(sin:string; var sout:string; var linenbr:integer):TStmttypes;
  var
    n:integer;
    t:TStmttypes;
    line, nbrstring:string;
  begin
    result:=unknown;
    line:=sin;
    n:=pos('=',line);
    if n>0 then
    begin
      result:=unknown;
      sout:=copy(line,n+1,length(line)-n);
      line:=copy(line,1,n-1);
      nbrstring:='';
      while (length(line)>0) and (line[length(line)] in ['0'..'9'])
      do
      begin
        nbrstring:=line[length(line)]+nbrstring;
        delete(line,length(line),1);
      end;
      if nbrstring='' then nbrstring:='0';
      linenbr:=strtoint(nbrstring);
      line:=line+' '; {varstrings have a trailing blank}
      for t:=low(varstrings) to high(varstrings)
      do if varstrings[t]=line then
      begin
        result:=t;
        break;
      end;
    end;
  end;


  {---------- MakeNewvar ---------}
  procedure makenewvar(s:string);
  var
  i, index, c, r :integer;
  w:string;
  v:TVariableType;
  p:integer;
  begin
    w:='';
    if s[length(s)]<>',' then  s:=s+',';
    p:=pos(',',s);
    if p=0 then showmessage('Invalid variable name in problem file'
                     +#13+s+#13+' Variable name must be followed by '','''
                             +#13 + 'Variable update stopped')
    else
    with varGrid1 do
    begin
      w:=copy(s,1,p-1);
      delete(s,1,p);
      if not validvarname(w, index) then
      begin
        rowcount:=rowcount+1;
        fixedrows:=1; {in case this was the first variable added}
        r:=rowcount-1;
        v:=TVariabletype.create;
        v.numtype:=false;
        v.values:=TStringList.create;
        v.name:=w;
        variables.AddObject(w,v);
        nbrvars:=variables.count;
      end
      else
      begin
        {r:=variables.indexof(w)+1;}
        r:=index+1;
        v:=TvariableType(variables.objects[index]);
        v.values.clear;
        for i:=1 to colcount-1 do cells[i,r]:='';
      end;
      cells[0,r]:=w;
      adjustwidth(vargrid1,0,r);
      p:=pos(',',s);
      c:=0;
      row:=r; {"select" row to be added or updated}
      while p<>0 do
      begin
        inc(c);
        w:=copy(s,1,p-1);
        w:=trim(w);
        v.values.add(w);
        if (nbrvalues=0)
          or ((nbrvalues>0) and (v.values.count<=nbrvalues)) then
        begin
          if c=colcount then
          begin
            colcount:=colcount+1; {add a column if necessary}
            cells[c,0]:='Value '+inttostr(colcount-1);
          end;
          cells[c, r]:= w;
          Adjustwidth(Vargrid1,c,r);
          delete(s,1,p);
          p:=pos(',',s);
        end
        else
        begin
           showmessage('Only '+inttostr(nbrvalues)+ ' allowed for each variable, '
                         +#13+ cells[0,r] +' has more, extras ignored');
           p:=0;
        end;

      end;
      if nbrvalues=0 then nbrvalues:=v.values.count; {set number of values based
                                        on first variable encountered}
      unsavedvar:=false;
      modified[vardef]:=true;
    end;
  end;

 var
   s,s2:string;
   filelist,list:TStringlist;
   i,index,j,nbr,r:integer;
   p:integer;
   v1,v2,posverb,negverb:string;
   ti:TStmtTypes;
  begin  {loadsection}
    initproblem(filename);
    Vargrid1.canvas.font.size:=font.size;
    Filelist:=TStringlist.create;
    list:=TStringlist.create;
    If not assigned(ini) then ini:=TInifile.create(filename);
    sourcememo.clear;
    descmemo.Clear;

    { Load DESCRIPTION Section}
    ini.readsectionValues('DESCRIPTION', FileList);
    for i:=0 to Filelist.count-1 do
    begin
      case getstmttype(Filelist[i],s,nbr) of
        SourcetextDef:
         begin
           Sourcememo.lines.add(s);
         end;
        TextDef:
          begin
           {fill in any blank lines}
           for j:=descmemo.lines.count+2 to nbr do Descmemo.lines.add(' ');
           Descmemo.lines.add(s);
         end;
         VarDef:
          begin   {Variable definition}
            {Simulate manual entry}

            makenewvar(s);

            If nbrvars>1 then game.Setcomboindex;
          end;
         Connect:
           begin
             If connectgrid.rowcount<=1 then AddConnectGridHdr(Connectgrid);
             p:=pos(',',s);
             v1:=copy(s,1,p-1);
             delete(s,1,p);
             p:=pos(',',s);
             posVerb:=copy(s,1,p-1);
             delete(s,1,p);
             p:=pos(',',s);
             negVerb:=copy(s,1,p-1);
             delete(s,1,p);
             v2:=s;
             r:=getconnectrow(v1,v2);
             if r>0 then
             with connectgrid do
             begin
               If rowcount<r+1 then rowcount:=r+1;
               cells[0,r]:=v1;
               cells[1,r]:=posverb;
               cells[2,r]:=negverb;
               cells[3,r]:=v2;
             end;
           end;
      end; {Case}
    end;
    {Load USER or ORIG section}
    filelist.clear;
    ini.readSectionValues(section, Filelist);

    for i:=0 to Filelist.count-1 do
    begin
      case getstmttype(Filelist[i],s,nbr) of
        Fact:
          begin  {Facts}
            makelist(list,s); {expand string into components}
            if list.count=4 then list.add('X');
            If list.count<>5 then error('Fact','Must have 5 elements',s)
            else
            if (not validvarvalue(list[1]) or not validvarvalue(list[2]))
            then error('Fact','Elements 2 and 3 must be variable values',s)
            else
            begin
              s2:= ansiuppercase(list[3]);
              if not ((s2[1]='T') or (s2[1]='F'))
              then error('Statement','4th element must be True or False',s )
              else
              begin
                s2:='F';
                MakeFact(FactGrid,s2,list);
                modrow:=-1;  {so that the next line adds a new row}
              end;
            end;
          end;

        {Separation rules}
        SepRule:
          begin
            makelist(list,s); {expand sting into components}
            if list.count=7 then list.add('T');
            if list.count=8 then list.Add('X');
            If list.count<>9 then error('Separation rule','Must have 9 elements',s)
            else
            if not validvarname(list[5],index) then error('SeparationRule','6th variable must be variable name',s)
            else if not validvarvalue(list[2]) or not validvarvalue(list[4])
            then error('Separation Rule','Elements 3 and 5 must be variable values',s)
            else
            begin
              s2:= ANSIUpperCase(list[3]);
              if not ((Comparetext(s2,'BEFORE')=0)
                    or (Comparetext(s2,'AFTER')=0)
                    or (Comparetext(s2,'SEPARATED BY')=0)
                    )
              then error('Separation Rule','3rd element must be Before/After/Separated by',s)
              else
              begin
                s2:=AnsiUppercase(list[7]);
                if not((s2[1]='T') or (s2[1]='F'))
                then error('Separation Rule', '8th element must be T or F',s)
                else MakeOrderRule(Ordergrid,list)
              end;
            end;
          end;
        IfRule:
          begin
            makelist(list,s); {expand sting into components}
            if list.count=7 then list.insert(0,'IR0');
            if list.count=8 then list.add('X');
            If list.count<>9 then error('If rule','Must have 9 elements',s)
            else
            if  not validvarvalue(list[2]) or not validvarvalue(list[5])
             or not validvarvalue(list[4]) or not validvarvalue(list[7])
            then error('If Rule','3rd, 4th, 6th and 8th items must be variable values',s)
            else if not validTFvalue(list[3]) or not validTFvalue(list[6])
            then error('If Rule','4th and 7th items must be ''T'' or ''F'' ',s)
            else
            MakeIfRule(IfRuleGrid,list);
          end;
        ChoiceStmt:
          begin
            makelist(list,s); {expand sting into components}
            if list.count=7 then list.add('X');
            If list.count<>8 then error('Choice rule','Must have 8 elements',s)
            else
            if  not validvarvalue(list[2]) or not validvarvalue(list[4])
             or not validvarvalue(list[5])
            then error('Choice','3rd, 5th, and 6th items must be variable values',s)
            else if (length(list[6])>0) and (not validvarvalue(list[6]))
            then error('Choice', '7th item must be blank or a valid varible value',s)
            else if not validvarname(list[3], j)
            then error('Choice','4th item must be a valid variable name',s)
            else
            MakeChoice(ChoiceGrid,list);
          end;


      end; {Case}
      modrow:=-1;
    end;

    {Data loaded - initialze grids}

    Descmemoexit(self); {rebuild stmt data}
    Descmemo.Selstart:=1;
    Descmemo.selLength:=1;

    With FactGrid do
    begin
      If rowcount>1 then row:=1;  {select 1st row initially}
      If colcount>1 then col:=0;
    end;

    With OrderGrid do
    begin
      If rowcount>1 then row:=1;  {select 1st row initially}
      If colcount>1 then col:=0;
    end;

    With IfRuleGrid do
    begin
      If rowcount>1 then row:=1;  {select 1st row initially}
      If colcount>1 then col:=0;
    end;

    With ChoiceGrid do
    begin
      If rowcount>1 then row:=1;  {select 1st row initially}
      If colcount>1 then col:=0;
    end;

    if connectgrid.rowcount<=1 then InitConnectGrid;

    {Initialize lists & boxes}
    If vargrid1.rowcount>1 then
    begin
      vargrid1.row:=1;
      vargrid1click(self);
    end;

    {Factsheet}
    {with changefactdlg do}
    begin
      LoadDescStmtList(FactRefBox);
      LoadValList(FactBox1);
      LoadValList(FactBox2);
    end;



    {OrderRuleSheet}
    {with ChangeORuleDlg do}
    begin

    end;

    {IfRuleSheet}
    begin
      LoadDescStmtList(ComboBox2);
      LoadVallist(IfValA1Box);
      LoadValList(IfValA2Box);
      LoadVallist(IfValB1Box);
      LoadVallist(IfValB2Box);
      IfValA1Box.Itemindex:=0;
      IfValA2Box.Itemindex:=0;
      IfValB1Box.ItemIndex:=0;
      IfValB2Box.ItemIndex:=0;
      TruthAGrp.itemindex:=0;
      TruthBGrp.itemindex:=0;
      ComboBox2.itemindex:=0;
    end;

    {Choicesheet}
    begin
      LoadDescStmtList(Combobox4);
      LoadValList(Choicename1box);
      LoadNameList(ChoiceOneOfBox);
      Combobox4.itemindex:=0;
      Choicename1Box.itemindex:=0;
      ChoiceOneOfBox.itemindex:=0;

      modify1click(Choicegrid);
    end;



    For ti:= low(TStmttypes) to high(tStmtTypes) do modified[ti]:=false;
    problemloaded:=true;
    Form1.setcaption;
    filelist.free;
    list.free;
    FreeandNil(Ini); {Delphi5 and later only}
    adjustupdatepermissions;  {may have to enable or disable update authority}
  end;

{************* LoadProblem ***********}
Procedure TForm1.LoadProblem;
  begin
    initproblem(opendialog1.filename);
    if rulesetrGrp.itemindex=1 then section:='USER'
    else section:='ORIG';
    LoadSection;
  end;


{********************** LoadProbClick *****************}
procedure TForm1.LoadProbClick(Sender: TObject);
{Load a problem}
var canclose:boolean;
begin
  FormClosequery(sender,canclose);
  If opendialog1.execute then LoadProblem;
end;

{************ Saveprob ***************}
Procedure tform1.saveprob;
{ Save the problem - called from save and saveas menu items}
var
  i,j:integer;
  bakname:string;
  Filelist:TStringlist;
  ti:TStmtTypes;

  {local procedure ********* WriteGrid *************}
  Procedure Writegrid(grid:TStringGrid;stmttype:TStmttypes; Fromcol, tocol:integer;sect:string);
  var
    r,c:integer;
    s, enabledx:string;
  begin
    with grid do
    begin
      for r:=1 to rowcount-1 do
      begin
        s:='';
        if trim(cells[1,r])=''  {if no reference ID}
        then enabledx:='-' {then mark it disabled in the saved version}
        else enabledx:=cells[colcount-2,r];  {else preserve user setting}
        for c:=fromcol to tocol do
        begin
          if c=colcount-2 then s:=s+enabledx else s:=s+cells[c,r];
          s:=s+',';
        end;
        if length(s)>0 then
        begin
          {while s[length(s)]=',' do} delete(s,length(s),1);
          ini.writestring(sect,TrimRight(varstrings[stmttype])+inttostr(r),s);
        end;
      end;
    end;
  end;

begin  {SaveProb}
  if filename<>'' then
  begin
    if uppercase(filename)='NEW' then
    begin
      saveas1click(self);
      exit;
    end;
    if fileexists(filename) then
    begin
      bakname:=changefileext(filename,'.BAK');
      //copyfile(PCHAR(filename),PCHAR(bakname), false); {fails sometimes}
      If fileexists(bakname) then  deletefile(bakname);
      copyfile(PCHAR(filename),PCHAR(bakname), false); {no need to overwrite now}
    end;

    If (section='ORIG') and not authorflag then
    begin
      If Messagedlg('Author''s content cannot be overwritten except in author mode'
                    +#13+'Would you like to save this data in user content section?',
                    mtconfirmation,[mbyes,mbno],0)=mrYes
      then
      begin
        section:='USER';
        Form1.SetCaption;
      end
      else
      begin
        ini.free;
        ini:=nil;
        exit;
      end;
    end;

    ini:=TIniFile.create(filename);
    filelist:=TStringlist.create;
    try
      //If authorflag then
      begin
        ini.EraseSection('DESCRIPTION');
        with Sourcememo do
        begin
          if lines.count>0 then
          for i:= 0 to lines.count-1 do
            ini.writestring('DESCRIPTION',trimright(varstrings[sourcetextdef])+inttostr(i+1),lines[i]);
        end;
        with Descmemo do
        begin
          if lines.count>0 then
          for i:= 0 to lines.count-1 do
            ini.writestring('DESCRIPTION',TrimRight(varstrings[textdef])+inttostr(i+1),lines[i]);
        end;
        writegrid(VarGrid1,vardef,0,vargrid1.colcount-1,'DESCRIPTION');
        with connectgrid do
        for j:=1 to rowcount-1 do
          ini.writestring('DESCRIPTION',trimright(varstrings[Connect])+inttostr(j),
                        cells[0,j]+','+cells[1,j]+','+cells[2,j] + ',' + cells[3,j]);
      end;

      If (Section='USER') or (authorflag) then
      begin
        ini.erasesection(section);
        {Don't write the last column (Used column) in the following grids}
        writegrid(FactGrid,Fact,1,factgrid.colcount-2,section);
        writegrid(Ordergrid,Seprule,0,ordergrid.colcount-2,section);
        writegrid(IfRuleGrid,IfRule,0,ifrulegrid.colcount-2,section);
        writegrid(ChoiceGrid,ChoiceStmt,0,ChoiceGrid.colcount-2,section);
      end;
      for ti:=low(TStmtTypes) to high(TStmtTypes) do modified[ti]:=false;
    finally;
      ini.free;
      ini:=nil;
      filelist.free;
    end;
  end;

end;

{***************** SaveAs1Click ***************}
procedure TForm1.SaveAs1Click(Sender: TObject);
begin
   with savedialog1 do
   begin
     if initialdir='' then initialdir:=extractfilepath(application.exename);
     If SaveDialog1.Execute then
     begin
       self.filename:=SaveDialog1.filename;
       label10.caption:='Description: '+extractfilename(filename);
       saveprob;
       initialdir:=Getcurrentdir;
       setcaption;
     end;
   end;
end;

{********************* Exit1Click ****************}
procedure TForm1.Exit1Click(Sender: TObject);
begin   close;  end;

{*************** OrderNameBoxChange **************}
procedure TForm1.OrdernameBoxChange(Sender: TObject);
var
  OrdernameBox:TCombobox;
begin
  If sender is TComboBox then
  begin
    ordernamebox:=TCombobox(sender);
    with ordernamebox do
    begin
      If OrderWithRespectToBox.Itemindex=0
      then
      begin
        Showmessage('Select "With respect to variable" first');
        itemindex:=0;
      end
      else
      if not CheckOrderVarBox(orderNameBox) then
      begin
       showmessage('Selected variable cannot match WithRespectTo variable');
        itemindex:=0;
        exit;
      end;
    end;  
  end;
end;


{*************** OrderRuleBtnClick *********}
procedure TForm1.OrderRuleBtnClick(Sender: TObject);
var list:TStringList;
begin
  if (not changeOK) then
  begin
    showmessage('Author''s Order rules can be changed '
        + ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  (*
  If modrow<=0 then ChangeORuleDlg.caption:='New Order Rule'
    else ChangeORuleDlg.caption:='Change OrderRule '+OrderGrid.cells[0,modrow];

  if ChangeOruledlg.showmodal=MROK then
  with ChangeOruleDlg do
  *)
  begin
    If Orderwithrespecttobox.itemindex=0
      then ShowMessage('With respect to variable must be selected')
    else
    If (Ordername1Box.itemindex=0) or (Ordername2box.itemindex=0)
      then Showmessage('Two "ordered" variables must be selected')
    else
    begin
      list:=TStringlist.create;
      list.add('');
      with Combobox1 do list.add(items[itemindex]);
      with OrderName1Box do list.add(items[itemindex]);
      with OrderrelationBox do list.add(items[itemindex]);
      with Ordername2Box do list.add(items[itemindex]);
      with OrderWithrespectToBox do list.add(items[itemindex]);
      with OrderDifferenceBox do list.add(items[itemindex]);
      If TrueORuleBtn.checked then list.add('T') else list.add('F');
      MakeOrderRule(OrderGrid,list);
      list.free;
    end;
    modified[SepRule]:=true;
  end;
end;

{******************* CheckOrderVarBox ************}
 function TForm1.CheckOrdervarBox(OrderNameBox:TComboBox):boolean;
    var
      varname:string;
      i, vindex:integer;
    begin
      result:=true;
      with Ordernamebox do
      If (itemindex>0) then
      begin
        varname:=Getvarname(items[itemindex],i,vindex);
        with OrderWithRespectToBox do
        If varname=items[itemindex] then result:=false;
      end;
    end;

{******************** OrderWithRespectToBoxChange ***********}
procedure TForm1.OrderWithRespectToBoxChange(Sender: TObject);
{remove with respect to variable from Ordernamebox lists}
{build separation amount list with number of w.r.t. values}
var
  varname,s:string;
  i,r,vindex:integer;
begin
  {with changeoruledlg do}
  begin
    If OrderWithrespectToBox.itemindex=0 then exit;
    if not checkOrdervarBox(Ordername1box)
    then
    begin
      showmessage('1st selected variable cannot match WithRespectTo variable');
      OrderWithRespectToBox.itemindex:=0;
      exit;
    end;

    if not checkordervarBox(Ordername2box) then
    begin
      showmessage('2nd selected variable cannot match WithRespectTo variable');
      OrderWithRespectToBox.itemindex:=0;
      exit;
    end;
    with OrderDifferenceBox do
    begin
      clear;
      items.add('Unknown');
      itemindex:=0;
      with OrderWithRespectToBox do
      r:=Getvaluecount(items[itemindex]);
      for i:= 1 to r do
      begin
        str(i,s);
        items.add(s);
      end;
    end;
  end;
end;

{************* OrderName1BoxChange **************}
procedure TForm1.Ordername1BoxChange(Sender: TObject);
begin  ordernameboxchange(sender);  end;

{******************** SetUpSolution ***************}
Procedure TForm1.SetupSolution(FGrid,OGrid,IGrid,CGrid:TStringGrid);
{User clicked solve button, do setup work to generate additional rules, etc.}
 var
   i,j,varindex,valindex:integer;
   s,t,v,saverule, rule,rule2,wrt:string;
 begin
  if not assigned(solvelist) then solvelist:=TStringlist.create
  else solvelist.clear;
  if not assigned(usedlist) then usedlist:=TStringlist.create
  else usedlist.clear;
  saverule:='';
  for i:=0 to variables.count-1 do
  begin  {assign names to variables and add to solvelist}
    saverule:=saverule+'X';
    s:='NAME '+inttostr(i+1)+' ';
    with TVariabletype(variables.objects[i]) do
    begin
      for j:=0 to values.count-1 do s:=s+inttohex(j+1,1); {Use value nbr as id}
      s:=s+' '+name;
    end;
    solvelist.add(s);
  end;
  {Process FactGrid}
  with Fgrid do
  for i:= 1 to rowcount-1 do
  if cells[5,i]='X' then {if it's enabled}
  begin  {Add facts to solvelist}
    rule:=saverule; {initialize fact}
    v:=cells[2,i];
    s:=Getvarname(v ,varindex, valindex); {varindex = variable varindex, valindex=value varindex within variable}
    rule[varindex+1]:=inttohex(valindex+1,1)[1];
    v:=cells[3,i];
    s:=Getvarname(v ,varindex,valindex);
    //rule[varindex+1]:=inttostr(valindex+1)[1];
    rule[varindex+1]:=inttohex(valindex+1,1)[1];
    if ANSIUppercase(cells[4,i])='TRUE'
    then rule:=rule+'T' else rule:=rule+'F';
    solvelist.add('Rule '+cells[0,i]+' '+rule);
  end;
  with ogrid do
  begin  {add order rules to solvelist}
    for i:= 1 to rowcount-1 do
    if cells[8,i]='X' then {rule is enabled}
    begin
      rule:=saverule;  {Initialize fact}
      rule2:=saverule;
      varindex:=variables.indexof(cells[5,i] ); {get 'with respect to' variable #}
      if varindex>=0 then
      begin
        wrt:=inttostr(varindex+1);
        v:=cells[2,i];
        {Fill in compare variables}
        s:=Getvarname(v ,varindex, valindex);
        rule[varindex+1]:=inttohex(valindex+1,1)[1];
        v:=cells[4,i];
        s:=Getvarname(v ,varindex,valindex);
        rule2[varindex+1]:=inttohex(valindex+1,1)[1];
        if AnsiUpperCase(cells[3,i])='AFTER' then
        {swap values to make 'before' form}
        begin
          s:=rule;
          rule:=rule2;
          rule2:=s;
        end;
        s:=cells[6,i]; {get sep amount}
        s:=uppercase(s[1]);
        if not (s[1] in ['1'..'9']) then s:='0'; {0=unknown}
        t:=cells[7,i];
        if length(t)>0 then t:=uppercase(t[1])else t:='T';

        If (AnsiComparetext(cells[3,i],'AFTER')=0) or
         (AnsiCompareText(cells[3,i],'BEFORE')=0)  then
          solvelist.add('OrderRule '+cells[0,i]+' '+rule+' '+rule2
                                    + ' '+ s+ ' '+wrt+' '+t)
         else solvelist.add('SeparationRule '+cells[0,i]+' '+rule+' '+rule2
                                    + ' '+ s+' '+wrt+' '+t)
      end;
    end;
  end;
  with igrid do
  begin  {add IF rules to solvelist}
    for i:= 1 to rowcount-1 do
    if cells[8,i]='X' then
    begin
      rule:=saverule;  {Initialize facts}
      rule2:=saverule;
      v:=cells[2,i];
      s:=Getvarname(v ,varindex, valindex);
      rule[varindex+1]:=inttohex(valindex+1,1)[1];
      v:=cells[4,i];
      s:=Getvarname(v ,varindex, valindex);
      rule[varindex+1]:=inttohex(valindex+1,1)[1];
      rule:=rule+cells[3,i];
      v:=cells[5,i];
      s:=Getvarname(v ,varindex,valindex);
      rule2[varindex+1]:=inttohex(valindex+1,1)[1];
      v:=cells[7,i];
      s:=Getvarname(v ,varindex,valindex);
      rule2[varindex+1]:=inttohex(valindex+1,1)[1];
      rule2:=rule2+cells[6,i];
      solvelist.add('IFRULE '+cells[0,i] + ' '+ rule+' '+rule2 );
    end;
  end;

  {Generate facts from Choice statements}
  with Cgrid do
  for i:= 1 to rowcount-1 do
  if cells[7,i]='X' then {if it's enabled}
  begin  {Add negative facts to solvelist}
    rule:=saverule; {initialize fact}
    v:=cells[2,i]; {V=value name}
    s:=Getvarname(v ,varindex, valindex);
    {now for all of the values for variable 2 that are not choices 1,2, or 3,
     generate a negative fact for that value}
    rule[varindex+1]:=inttohex(valindex+1,1)[1];
    v:=cells[4,i];
    s:=Getvarname(v ,varindex,valindex);
    rule[varindex+1]:='Y'; {This is the variable which the given value is one of}
    rule:=rule+inttohex(valindex+1,1)[1];
    v:=cells[5,i];
    s:=Getvarname(v ,varindex,valindex)[1];
    rule:=rule+inttohex(valindex+1,1)[1];
    v:=cells[6,i];
    if v<>'' then
    begin
      s:=Getvarname(v ,varindex,valindex);
      rule:=rule+(inttohex(valindex+1,1))[1];
    end
    else rule:=rule+' ';
    solvelist.add('CHOICE '+cells[0,i]+' '+rule);
  end;
end;

{****************** Solve1Click *************}
procedure TForm1.Solve1Click(Sender: TObject);
{Solve with current data}
var
  i:integer;
  mr:integer;
begin
  if filename='' then LoadProbclick(sender);
  if filename='' then exit;
  if anymodified then
  begin
   mr:=messagedlg('Rules modified, save first?',mtconfirmation,[mbYes,mbNo,mbCancel],0);
    if mr=mryes then saveprob
    else if mr=mrcancel then exit;
  end;
  If (factgrid.rowcount>=2) or (ordergrid.rowcount>=2)
  or (ifrulegrid.rowcount>=2) or (choicegrid.rowcount>-2)
  then
  begin
    SetupSolution(Factgrid,OrderGrid,IfRuleGrid, ChoiceGrid);
    solveform.tag:=0; {to tell solveform that this is a new request}
    //solveform.hide;
    solveform.show;
    solveform.bringtofront;
    solveform.windowstate:=wsnormal;
    {now fill in grids with "used flags" for all facts & rules used in reaching conclusions}
    with factgrid do
    for i:=1 to rowcount-1 do
    if usedlist.indexof(cells[0,i])>=0 then cells[6,i]:='X' else cells[6,i]:='';
    with ordergrid do
    for i:=1 to rowcount-1 do
    if usedlist.indexof(cells[0,i])>=0 then cells[9,i]:='X' else cells[9,i]:='';
    with ifrulegrid do
    for i:=1 to rowcount-1 do
    if usedlist.indexof(cells[0,i])>=0 then cells[9,i]:='X' else cells[9,i]:='';
    with choicegrid do
    for i:=1 to rowcount-1 do
    cells[9,i]:='N/A';
   // if usedlist.indexof(cells[0,i])>=0 then cells[9,i]:='X' else cells[9,i]:='';
  end
  else
  if filename='' then showmessage('Use "Problem" menu item to load a problem')
  else if rulesetRgrp.itemindex=0
  then showmessage('No Solution facts or rules are defined.')
  else if rulesetRgrp.itemindex=1
  then showmessage('No User facts or rules defined. Use "Facts" and "Rules" tabs to define them - or'
         + #13+ 'select "Solution Rules" below to see facts && rules which solve the problem');
end;

{******************* DescMemoExit ****************}
procedure TForm1.DescMemoExit(Sender: TObject);
var
  i, j, prevlinelen:integer;
  s:string;

begin
  {look for statements that can be referenced in rules}
  {identified by a blank line followed by a line that starts with a number}
  nbrdescstmts:=0;
  prevlinelen:=1;
  for i:=0 to Descmemo.lines.count-1 do
  with Descmemo do
  begin
    s:=trim(lines[i]);
    if length(s) = 0 then prevlinelen:=0
    else
    begin
      if prevlinelen=0 then
      begin
        j:=0;
        while (j<=length(s)) and (s[j+1] in ['0'..'9']) do inc(j);
        if  (j=1) or (j=2) then
        begin
          if nbrdescstmts>0 then stmtlines[nbrdescstmts]:=i-stmtstarts[nbrdescstmts];
          inc(nbrdescstmts);
          stmtstarts[nbrdescstmts]:=i;
          stmtids[nbrdescstmts]:=copy(s,1,j);
          if j=1 then stmtids[nbrdescstmts] := ' '+ stmtids[nbrdescstmts]
        end;
      end;
    end;
  end;
  if nbrdescstmts>0 then stmtlines[nbrdescstmts]:=Descmemo.lines.count-stmtstarts[nbrdescstmts];
end;

{****************** LoadStmt *****************}
 Procedure TForm1.Loadstmt(memo:Tmemo;index:integer);
 {load reference # index  to memo}
 var
   i:integer;
 begin
   if (index>0) and (index<=nbrdescstmts) then
   begin
     memo.clear;
     for i := 0 to stmtlines[index]-1 do
     begin
       memo.lines.add(Descmemo.lines[stmtstarts[index]+i]);
     end;
   end;
   memo.selstart:=1;
   memo.sellength:=1;
 end;

{******************** StmtBoxChange *************}
procedure TForm1.StmtBoxChange(Sender: TObject);
var  memo:TMemo;
begin
  {with changefactdlg, changeoruledlg, changeiruledlg do}
  begin
    if sender=FactRefBox then memo:=memo2
    else if sender=ComboBox1 then memo:=memo3
    else if sender=ComboBox2 then memo:=memo1
    else if sender=combobox4 then memo:=memo6
    else
    begin
      showmessage('Invalid ComboBox name, Contact Grandpa');
      exit;
    end;
    Loadstmt(memo,TComboBox(sender).itemindex);
  end;
end;

{***************** Save1Click *************}
procedure TForm1.Save1Click(Sender: TObject);
begin    saveprob;  end;

{***************** Modify1Click ***************}
procedure TForm1.Modify1Click(Sender: TObject);
{prepare a grid row for editing}
var  n:integer;
  begin
    If (sender = FactGrid)  then
    begin
      with factGrid {, Changefactdlg}  do
      if rowcount>1  then
      begin
        {move fact to editing boxes and set modify flag}
        n:= FactRefBox.items.indexof(cells[1,row]);
        if n>0 then
        begin
          FactRefBox.itemindex:=n;
          stmtboxchange(FactRefBox);
        end
        else FactRefBox.itemindex:=0;

        begin
          n:= Factbox1.items.indexof(cells[2,row]);
          if n>0 then FactBox1.itemindex:=n else FactBox1.itemindex:=0;
          n:= Factbox2.items.indexof(cells[3,row]);
          if n>0 then FactBox2.itemindex:=n else FactBox2.itemindex:=0;
          FactBoxChange(sender);
          if cells[4,row][1]='T' then FactRGrp.itemindex:=0{truefactbtn.checked:=true}
          else FactRGrp.itemindex:=1{falsefactbtn.checked:=true};
          modrow:=row;
        end;
      end;
    end
    else If sender = OrderGrid then
    with OrderGrid {, changeoruledlg} do
    begin
      n:= Combobox1.items.indexof(cells[1,row]);
      if n>0 then begin   combobox1.itemindex:=n;  stmtboxchange(combobox1); end
      else Combobox1.itemindex:=0;
      {if changeOK then}
      begin
        n:= Ordername1box.items.indexof(cells[2,row]);
        if n>0 then OrderName1Box.itemindex:=n else OrderName1Box.itemindex:=0;
        n:= OrderRelationbox.items.indexof(cells[3,row]);
        if n>0 then Orderrelationbox.itemindex:=n else OrderrelationBox.itemindex:=0;
        n:= OrderName2box.items.indexof(cells[4,row]);
        if n>0 then Ordername2Box.itemindex:=n else Ordername2Box.itemindex:=0;
        n:= OrderWithRespectTobox.items.indexof(cells[5,row]);
        if n>0 then OrderWithRespectToBox.itemindex:=n else OrderWithRespectToBox.itemindex:=0;
        n:= OrderDifferenceBox.items.indexof(cells[6,row]);
        if n>0 then OrderDifferenceBox.itemindex:=n else OrderDifferenceBox.itemindex:=0;
        If length(cells[7,row])=0 then cells[7,row]:=' ';
        if cells[7,row][1]='T' then TrueORuleBtn.checked:=true
        else falseORuleBtn.checked:=true;
        modrow:=row;
      end;
    end
    else If sender = IfRuleGrid then
    with IfRuleGrid do
    {with changeiRuleDlg do}
    begin
       n:= Combobox2.items.indexof(cells[1{0},row]);
      if n>0 then begin Combobox2.itemindex:=n; stmtboxchange(combobox2); end
      else Combobox2.itemindex:=0;
      {if changeOK then}
      begin
        n:= IfValA1Box.items.indexof(cells[2,row]);
        if n>0 then IfValA1Box.itemindex:=n else IfValA1Box.itemindex:=0;
        If cells[3,row]='T' then TruthAGrp.itemindex:=0 else TruthAGrp.itemindex:=1;
        n:= IfValA2Box.items.indexof(cells[4,row]);
        if n>0 then IfValA2Box.itemindex:=n else IfValA2Box.itemindex:=0;
        n:= IfValB1Box.items.indexof(cells[5,row]);
        if n>0 then IfValB1Box.itemindex:=n else IfValB1Box.itemindex:=0;
        If cells[6,row]='T' then TruthBGrp.itemindex:=0 else TruthBGrp.itemindex:=1;
        n:= IfValB2Box.items.indexof(cells[7,row]);
        if n>0 then IfValB2Box.itemindex:=n else IfValB2Box.itemindex:=0;
        modrow:=row;
      end;
    end
    else If (sender = ChoiceGrid)  then
    begin
      with ChoiceGrid  do
      if rowcount>1  then
      begin
        {move Choice to editing boxes and set modify flag}
        n:= Combobox4.items.indexof(cells[1,row]);
        if n>0 then
        begin
          Combobox4.itemindex:=n;
          stmtboxchange(ComboBox4);
        end
        else Combobox4.itemindex:=0;

        begin
          n:= Choicename1box.items.indexof(cells[2,row]);
          if n>0 then ChoiceName1Box.itemindex:=n else Choicename1Box.itemindex:=0;
          Choicename1BoxChange(sender);
          n:= ChoiceOneOfBox.items.indexof(cells[3,row]);
          if n>0 then ChoiceOneOfBox.itemindex:=n else ChoiceOneOfBox.itemindex:=0;
          ChoiceoneofboxChange(sender);
          modrow:=row;
        end;
      end;
    end
    else showmessage ('Unknown caller '+TComponent(sender).name+' to Modify1 procedure');
  end;

{******************** DeleteRow *****************}
procedure TForm1.deleterow(grid:TStringgrid; r:integer);
{delete row "r" from stringgrid "Grid:}
    var i,j:integer;
    begin
      with grid do
      begin
        for i:=r to rowcount-1 do
        for j:= 0 to colcount-1 do cells[j,i]:=cells[j,i+1];
        rowcount:=rowcount-1;
      end;
    end;


{************************* DeletefactBtn ********************}
procedure TForm1.DeleteRowClick(Sender: TObject);
var
 s:string;
 t:TStmttypes;
 Grid:TStringGrid;
begin
    If sender = FactGrid then
    begin
      s:='Fact';
      t:=fact;
      Grid:=factGrid;
    end
    else
    If sender = Ordergrid then
    begin
      s:='Order Rule';
      Grid:=OrderGrid;
      t:=seprule;
    end
    else
    If sender = IfRulegrid then
    begin
      s:='If Rule';
      Grid:=IfRuleGrid;
      t:=ifrule;
    end
    else
    If sender = ChoiceGrid then
    begin
      s:='Choive Statement';
      Grid:=ChoiceGrid;
      t:=ChoiceStmt;
    end
    else

    begin
      showmessage('Unrecognized caller of Delete');
      exit;
    end;

    If messagedlg('Are you sure you want to delete this '+s+'?',mtconfirmation,
                [MBYES,MBNO],0)=mryes
    then
    {delete fact or rule here}
    deleterow(grid,grid.row);
    if modrow>=grid.rowcount then modrow:=grid.rowcount-1;
    modified[t]:=true;
  end;


{********************* GridMouseDown ***************}
procedure TForm1.GridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Rowdragging:=true;
  with Sender as TStringgrid do startrow:=row;
end;

{******************** GridMouseMove ******************}
procedure TForm1.GridMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  acol,arow:longint;
  temprow:TStrings;
  a,b,i:integer;
begin
  if not (ssleft in shift) then rowdragging:=false;
  if not rowdragging then exit;
  with sender as TStringgrid do
  begin
    mousetocell(x,y, acol, arow);
    if (arow>0) and (arow<>startrow) then
    begin

      temprow:=Tstringlist.create;
      a:=max(startrow,arow);
      b:=min(startrow,arow);
      for i:= a-1 downto b do
      begin
        temprow.assign(rows[a]);
        rows[a]:=rows[a-1];
        rows[a-1].assign(temprow);
      end;
      startrow:=b;
      temprow.free;
    end;
  end;
end;

{******************** GridMouseUp ******************}
procedure TForm1.GridMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  rowdragging:=false;
end;

{******************* InitProblem *************}
Procedure TForm1.InitProblem(newfilename:string);
var i:TStmtTypes;
begin
  variables.clear;
  nbrvalues:=0;
  filename:=newfilename;
  label10.caption:='Description: '+extractfilename(filename);
  nbrdescstmts:=0; {Number of numbered statements in description text}
  errorflag:=false;
  startrow:=0;
  rowdragging:=false;
  For i:= low(TStmttypes) to high(tStmtTypes) do modified[i]:=false;
  Unsavedvar:=false;
  modrow:=-1;
  Problemloaded:=false;
  Sourcememo.clear;
  Descmemo.clear;
  Descmemo.lines.add('Click the "Problem" menu item to load a problem or start a new one');
  modified[textdef]:=false; {changing descmemo sets this to true, reset it to false here}
  VarGrid1.rowcount:=1;
  Vargrid1.colcount:=1;
  VarGrid1.Cells[0,0]:='Variable';
  VarEdit.text:='';
  Adjustwidth(Vargrid1,0,0);
  FactGrid.rowcount:=1;
  Ordergrid.rowcount:=1;
  IfRuleGrid.rowcount:=1;
  ChoiceGrid.rowcount:=1;
  //Connectgrid.rowcount:=0;
  Connectgrid.rowcount:=1;
  updown1.min:=0;
  updown2.min:=0;
  updown3.min:=0;
  updown4.min:=0;
  memo1.Clear;
  memo2.clear;
  memo3.clear;
  memo6.clear;
  Descmemo.clear;
  Sourcememo.clear;
  variables.clear;
  PageControl.Activepage:=Textsheet {Pagecontrol.Pages[0]}; {make sure we're back on 1st page}
end;


{******************** NewProbClick ***********}
procedure TForm1.NewProbClick(Sender: TObject);
var canclose:boolean;
begin
  FormCloseQuery(Sender, canclose); {Force check for probem to save}
  If not authorflag then
  begin
    EnterAuthormodeClick(sender);
    showmessage('Author mode has been turned on (required for new problem)');
  end;
  filename:='NEW';
  section:='ORIG';
  RuleSetRGrp.itemindex:=0;
  setcaption;
  Initproblem('New');
end;

{**************** FormCloseQuery **************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var result:integer;
begin
  canclose:=true;
  if anymodified then
  begin
    result:=messagedlg('Save '+section +' rules for ' +filename+'?',mtconfirmation,[mbyes,mbno,mbcancel],0);
    if result=mryes then
    begin
      if filename='NEW' then saveas1click(sender)
      else saveprob;
    end
    else if result=mrcancel then canclose:=false;
  end;
end;

{**************** MemoChange **************}
procedure TForm1.MemoChange(Sender: TObject);
begin
  if sender is TMemo then
  begin
    If sender = Descmemo then modified[TextDef]:=true
    else If sender=Sourcememo then modified[SourceTextDef]:=true
    else Showmessage('Unrecognized memo change - name ='+TComponent(sender).name);
  end
  else Showmessage('Unrecognized memo change - name ='+TComponent(sender).name);
end;

{***************** VarEdit *************}
procedure TForm1.VarEditChange(Sender: TObject);
begin
  Unsavedvar:=true;
end;


(*
{***************** GridSelectCell ****************}
procedure TForm1.GridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);

  Function getStmtIndex(s:String):integer;
  var i:integer;
  begin
    result:=-1;
    i:=1;
    while (i<nbrdescstmts) and (stmtids[i]<>s) do inc(i);
    If stmtids[i]=s then result:=i;
  end;

begin
  {Workgrid:=TStringgrid(Sender);}
   sender=ordergrid then begin memo:=memo3; c:=0; end
  else if sender=factgrid then begin memo:=memo2; c:=1; end
  else if sender=ifrulegrid then begin memo:=memo1; c:=0; end
  else exit;
  with Workgrid do
  begin
    {n:= FactRefBox.items.indexof(cells[0,arow]);}
    n:= Getstmtindex(cells[c,arow]);
    {if (n>0) and (n<=nbrdescstmts) then Loadstmt(memo,n);}

    begin
      memo.clear;
      for i := 0 to stmtlines[n]-1 do
        memo.lines.add(Descmemo.lines[stmtstarts[n]+i]);
    end;
    memo.selstart:=1;
    memo.sellength:=1;
  end;
end;
*)


{****************** GridKeyDown *****************}
procedure TForm1.GridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i:integer;
  saverow:TStringList;
  t:TStmttypes;
begin
  If Sender=factgrid then t:=fact
  else if sender=ordergrid then t:=seprule
  else t:=unknown;
  if t<>unknown then
  with Sender as TStringGrid do
  begin
    {delete a fact, "order" rule or "if" rule}
    if key=vk_delete then deleterowclick(sender)
    {Move rows}
    else If (key=vk_Up) and (SSShift in shift) and (row>0) then
    begin
      saverow:=TStringList.create;
      for i:=0 to colcount-1 do saverow.add(cells[i,row]);
      rows[row]:=rows[row-1];
      for i:=0 to colcount-1 do cells[i,row-1]:=saverow[i];
      saverow.free;
      modified[t]:=true;
    end
    else If (key=vk_down) and (ssShift in shift) and (row<rowcount-1) then
    begin
      saverow:=TStringList.create;
      saverow.assign(rows[row]);
      rows[row]:=rows[row+1];
      rows[row+1].assign(saverow);
      saverow.free;
      modified[t]:=true;
    end;

  end;
end;

{****************** MoveRow1Click *****************}
procedure TForm1.Moverow1Click(Sender: TObject);
begin
  showmessage('Hold shift key and press up/down arrow keys to move selected row');
end;


{********************* IfRuleBtnClick *****************}
procedure TForm1.IfRuleBtnClick(Sender: TObject);
var
  list:TStringList;
begin
  If (not changeOK) then
  begin
    showmessage('Author''s "IF" rules can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  (*
   If modrow<=0 then ChangeIRuleDlg.caption:='New If Rule'
    else ChangeIRuleDlg.caption:='Change If Rule '+IfRuleGrid.cells[0,modrow];
  if ChangeIRuleDlg.showmodal=MROK  then
  with changeiRuleDlg do
  *)
  begin
    If    (IfValA1Box.itemindex=0) or (IfValA2Box.itemindex=0)
      or  (IfValB1Box.itemindex=0) or (IfValB2Box.itemindex=0)
      then Showmessage('Four variable values must be selected')
    else
    begin
      list:=TStringlist.create;
      if modrow<=0 then list.add('')
      else list.add(Ifrulegrid.cells[0,modrow]);
      with Combobox2 do list.add(items[itemindex]);
      with IfValA1Box do list.add(items[itemindex]);
      If   TruthAGrp.itemindex=0 then list.add('T') else list.add('F');
      with IfValA2Box do list.add(items[itemindex]);
      with IfValB1Box do list.add(items[itemindex]);
      If   TruthBGrp.itemindex=0 then list.add('T') else list.add('F');
      with IfValB2Box do list.add(items[itemindex]);
      MakeIfRule(IfRuleGrid,list);
      list.free;
    end;
    modified[IfRule]:=true;
  end;  
end;


{**************** OriginalRules1Click **************}
procedure TForm1.OriginalRules1Click(Sender: TObject);
begin
  If anymodified then saveprob;
  initproblem(filename);
  Section:='ORIG';
  LoadSection;
  If factgrid.rowcount>=2 then
  begin
    SetupSolution(Factgrid,OrderGrid,IfRuleGrid,Choicegrid);
    solveform.tag:=0;
    solveform.show;
  end
  else showmessage('No facts/rules present');
end;

{******************* NewFactBtnClick ***********}
procedure TForm1.NewfactBtnClick(Sender: TObject);
begin
  if (not changeOK) then
  begin
    showmessage('Author''s facts can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  modrow:=-1;
  Factbtnclick(sender);
end;

{****************** NewOrderRuleBtnClick *********}
procedure TForm1.NewOrderRuleBtnClick(Sender: TObject);
begin
  If (not changeOK) then
  begin
    showmessage('Author''s Order rules can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;

    modrow:=-1;
    OrderRuleBtnClick(sender);
 end;

{************* DelORuleBtnClick **************}
procedure TForm1.DelORuleBtnClick(Sender: TObject);
begin
  if (not changeOK) then
  begin
    showmessage('Author''s rules can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  deleterowclick(ordergrid);
end;



{************** NewIfRuleBtnClick ************}
procedure TForm1.NewIfRuleClick(Sender: TObject);
begin
  If (not changeOK) then
  begin
    showmessage('Author''s "IF" rules can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  modrow:=-1;
  IfRuleBtnClick(sender);
end;


{**************** DelifRuleBtnClick ************}
procedure TForm1.DelifRuleBtnClick(Sender: TObject);
begin
  If (not changeOK) then
  begin
    showmessage('Author''s "IF" rules can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  deleterowclick(IfRuleGrid);
end;


{************* InitConnectGrid **********}
Procedure Tform1.InitConnectGrid;
  begin
    AddConnectGridHdr(ConnectGrid);
    modified[connect]:=true;
  end;

{******************* ConnectGridSetEditText ***********}
procedure TForm1.ConnectGridSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
  modified[connect]:=true;
  Adjustwidth(ConnectGrid,Acol,Arow);
end;

{************** ExplainWithVarClick ************}
procedure TForm1.ExplainwithVarClick(Sender: TObject);
begin
  ExplainWithVar.checked := not ExplainWithVar.checked;
end;

{*********** MoveOriginalRulesToUserRules1Click ***********}
procedure TForm1.Moveoriginalrulestouserrules1Click(Sender: TObject);
begin
  If section='ORIG' then
  begin
    section:='USER';
    saveprob;
    ini:=TInifile.create(filename);
    ini.Erasesection('ORIG');
    ini.free;
    ini:=nil;
    loadproblem;
  end
  else showmessage('Load Author''s rules first');
end;

{************ MoveUserRulesToOriginalRulesClick **********}
procedure TForm1.MoveuserrulestoOriginalrules1Click(Sender: TObject);
begin
  If section='USER' then
  begin
    section:='ORIG';
    saveprob;
    ini:=TInifile.create(filename);
    ini.erasesection('USER');
    ini.free;
    ini:=nil;
    loadproblem;
  end
  else showmessage('Load User rules first');
end;

{***************** LoadUserClick ************}
procedure TForm1.LoadUserClick(Sender: TObject);
begin
  Initproblem(filename);
  Section:='USER';
  SetCaption;
  LoadSection;
end;

{****************** LoadOriginalRulesClick ***********}
procedure TForm1.LoadOriginalRules1Click(Sender: TObject);
begin
  Initproblem(filename);
  section:='ORIG';
  SetCaption;
  LoadSection;

end;

{******************* PageControlChange ************}
procedure TForm1.PageControlChange(Sender: TObject);
{Initialization for new active page}
begin
  with PageControl do
  If activepage =  Factsheet then
  {with changefactdlg do}
  begin
    LoadDescStmtList(FactRefBox);
    {FactRefBox.itemindex:=0;}
    with updown1 do
    begin
      max:=nbrdescstmts;
      if min=0 then
      begin
        min:=1;
        position:=max;
      end;
      loadstmt(memo2,max-position+1);
    end;
    LoadValList(FactBox1);
    LoadValList(FactBox2);
    FactGrid.setfocus;
    If factgrid.rowcount>1 then modify1click(FactGrid);
  end
  Else
  If activepage =  OrderRuleSheet then
  {with changeoruledlg do}
  begin
    LoadDescStmtList(ComboBox1);
    with updown2 do
    begin
      max:=nbrdescstmts;
      if min=0 then
      begin
        min:=1;
        position:=max;
      end;
      loadstmt(memo3,max-position+1);
    end;
    LoadNamelist(OrderwithrespecttoBox);
    LoadValList(Ordername1Box);
    LoadValList(Ordername2Box);
    OrderrelationBox.Itemindex:=0;
    OrderDifferenceBox.ItemIndex:=0;
    OrderGrid.Setfocus;
    If ordergrid.rowcount>1 then modify1click(OrderGrid);
    OrderWithRespectToBoxChange(Sender);
  end
  Else
  If activepage =  IfRuleSheet then
  {with changeIruledlg do}
  begin
    LoadDescStmtList(ComboBox2);
    with updown3 do
    begin
      max:=nbrdescstmts;
      if min=0 then
      begin
        min:=1;
        position:=max;
      end;
      loadstmt(memo1,max-position+1);
    end;
    LoadVallist(IfValA1Box);
    LoadValList(IfValA2Box);
    LoadVallist(IfValB1Box);
    LoadVallist(IfValB2Box);
    IfValA1Box.Itemindex:=0;
    IfValA2Box.Itemindex:=0;
    IfValB1Box.ItemIndex:=0;
    IfValB2Box.ItemIndex:=0;
    TruthAGrp.itemindex:=0;
    TruthBGrp.itemindex:=0;
    ComboBox2.itemindex:=0;
    IfRulegrid.setfocus;
    if Ifrulegrid.rowcount>1 then modify1click(IfRuleGrid);
  end
  else if activepage= ChoiceSheet then
  begin
    LoadDescStmtList(ComboBox4);
    with updown4 do
    begin
      max:=nbrdescstmts;
      if min=0 then
      begin
        min:=1;
        position:=max;
      end;
      loadstmt(memo6,max-position+1);
    end;
    LoadVallist(Choicename1Box);
    LoadNamelist(ChoiceOneOfBox);
    
    (*
    with ChoicesListBox do
    begin
      items.clear;
      itemindex:=0;
    end;
    *)
    if choicegrid.rowcount>1 then modify1click(choicegrid);
  end
  Else
  If activepage =  ConnectingPage then
  begin
    if connectgrid.rowcount<=1 then {none loaded - set up defaults}
    with connectgrid do InitConnectGrid;
  end;

end;

procedure TForm1.ChoiceOneOfBoxChange(Sender: TObject);
var
  i,j:integer;
begin
  for i:= 0 to variables.count-1 do if
  variables[i]=choiceoneofbox.Items[choiceoneofbox.ItemIndex] then
  begin
    choiceslistbox.clear;
    loadvalueItems(i,choicesListBox.items);
    {multiselect the choice 1,2, & 3 boxes (columns 4,5, &6}
    with TVariabletype(variables.objects[i]), choicegrid do
    begin
      for j:=0 to values.count-1 do
      if (values[j]=cells[4,row]) or (values[j]=cells[5,row])
         or (values[j]=cells[6,row])
      then choiceslistbox.selected[j]:=true;
    end;
    break;
  end;
end;
{******************* GetConnectRow **********}
function TForm1.GetConnectRow(v1,v2:string):Integer;
var i:integer;
begin
  i:=1;
  result:=-1;
  with Connectgrid do
  while (result<0) and (i<rowcount-1) do
  begin
    if (v1=cells[0,i]) and (v2=cells[3,i]) then result:=i
    else inc(i);
  end;
end;

{******************* FactBoxChange *************}
procedure TForm1.FactBoxChange(Sender: TObject);
var index,valindex, connectrow:integer;
     var1,var2:string;
begin
  begin
    with factbox1 do var1:=GetVarname(items[itemindex], index,valindex);
    with factbox2 do var2:=GetVarname(items[itemindex], index,valindex);
    connectrow:=GetConnectRow(var1,var2);
    if connectrow>=0 then
    begin
      FactRGrp.items[0]:=Connectgrid.cells[1,connectrow];
      FactRGrp.items[1]:=Connectgrid.cells[2,connectrow];
    end
    else
    begin
      factrgrp.items[0]:=' is ';
      factrgrp.items[1]:=' isn''t ';
    end;
  end;
end;

procedure TForm1.Choicename1BoxChange(Sender: TObject);
begin

end;

{************ VarSheetExit *************}
procedure TForm1.VarSheetExit(Sender: TObject);
begin
  (*
  If UnsavedVar and (messagedlg('Save variable'+ varedit.text+ ' first?',
                      mtconfirmation,[mbyes,mbno],0)=mryes)
  then varBtnClick(Sender) ;
  If connectgrid.rowcount<>nbrvars then AddConnectGridHdr(Connectgrid);
  *)
end;



{**************** SortFactsClick *********}
procedure TForm1.SortBtnClick(Sender: TObject);
{Sort facts}
var i,j:integer;
    s:string;
    grid:TstringGrid;
    sortcols:array of integer;
begin
  if not changeOK then
  begin
    showmessage('Author''s facts can be changed '
         +' only in "Author" mode.'+#13+'Use Options menu');
    exit;
  end;
  if sender= SortfactsBtn then grid:=Factgrid
  else if sender=SortORulesBtn then grid:=Ordergrid
  else if sender=SortIRulesBtn then grid:=IfRuleGrid
  else if sender=SortChoiceBtn then grid:=Choicegrid
  else exit;

  {sort grid  by reference btn}
  setlength(sortcols,3);
  sortcols[0]:=1;
  sortcols[1]:=2;
  sortcols[2]:=4;
  If (sender=Sortfactsbtn) or (sender=SortChoicebtn) then sortcols[2]:=3;
  sortgrid(grid,sortcols);{sort by col 3 or 4 within sort by col 2 within sort by col 1}
  {renumber facts}
  For i:=1 to grid.rowcount do
  with grid do
  begin
    s:=cells[0,i];
    for j:= length(s) downto 1 do if s[j] in ['0'..'9'] then delete(s,j,1);
    cells[0,i]:=s +inttostr(i);
  end;
end;

{***************** DelFactBtnClick ************}
procedure TForm1.DelFactBtnClick(Sender: TObject);
{Delete a fact}
begin
  if (not changeOK) then
  begin
    showmessage('Author''s facts can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  deleterowclick(Factgrid);
end;

{*************** RuleSetGrpClick ***********}
procedure TForm1.RuleSetRGrpClick(Sender: TObject);
begin
  If anymodified then saveprob;
  initproblem(filename);
  if filename<>'NEW' then
  if RuleSetRGrp.itemindex=0
  then  LoadOriginalRules1Click(sender)
  else LoadUserclick(sender);
end;

{***************** EnterAuthormodeClick ********}
procedure TForm1.EnterAuthormodeClick(Sender: TObject);
{flip authorflag}
begin
  With EnterAuthorMode do
  begin
    checked:=not checked;
    authorflag:=checked;
  end;
  if {not} authorflag then  {enter authormode}
  begin
    //authorflag:=true;
    enterauthormode.caption:='Leave Author mode';
    author1.enabled:=true;

    descmemo.readonly:=false;
    sourcememo.readonly:=false;
    descchglbl.visible:=false;

    connectgrid.options:= connectgrid.options+[goediting];
    ConnectChgLbl.visible:=false;
    vargrp.visible:=true;  {show variable change buttons}

  end
  else
  begin   {leave authormode, user can update his own rules but not author info}
    //authorflag:=false;
    enterauthormode.caption:='Enter Author mode';
    author1.enabled:=false;

    descmemo.readonly:=true;  {user can't change description}
    sourcememo.readonly:=true; {or source}
    descchglbl.visible:=true;
    connectgrid.options:= connectgrid.options-[goediting];
    ConnectChgLbl.visible:=true;
    vargrp.visible:=false; {hide variable change buttons}
  end;
  adjustupdatepermissions;
end;

{**************** AdjustUpdatePermisions ***********}
procedure TForm1.adjustupdatepermissions;
var newmode:boolean;
begin
  if (not authorflag) and (section='ORIG') then newmode:=false
  else newmode:=true;
  Nochangelbl.visible:= not newmode;
  changeOK:=newmode;
end;

{************** FactGridDblClick **************}
procedure TForm1.FactGridDblClick(Sender: TObject);
begin
  with factgrid do
  begin
    if cells[5,row]='X' then cells[5,row]:='-' else cells[5,row]:='X';
  end;
end;

{************** OrderGridDblClick ***********}
procedure TForm1.OrderGridDblClick(Sender: TObject);
{flag order rule as enabled/disabled}
begin
  with ordergrid do
  begin
    if cells[8,row]='X' then cells[8,row]:='-' else cells[8,row]:='X';
  end;
end;

procedure TForm1.IfRuleGridDblClick(Sender: TObject);
begin
  with ifrulegrid do
  begin
    if cells[8,row]='X' then cells[8,row]:='-' else cells[8,row]:='X';
  end;
end;



procedure TForm1.UpDown1ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  loadstmt(memo2,updown1.max-newvalue+1);
end;

procedure TForm1.UpDown2ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  loadstmt(memo3, updown2.max-newvalue+1);
end;

procedure TForm1.UpDown3ChangingEx(Sender: TObject;
  var AllowChange: Boolean; NewValue: Smallint;
  Direction: TUpDownDirection);
begin
  loadstmt(memo1, updown3.max-newvalue+1);
end;

procedure TForm1.StaticText4Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



procedure TForm1.NewChoiceBtnClick(Sender: TObject);
begin
  If (not changeOK) then
  begin
    showmessage('Author''s Order rules can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;

  modrow:=-1;
  ChoiceBtnClick(sender);
end;

procedure TForm1.ChoiceBtnClick(Sender: TObject);
var
  list:TStringList;
  i:integer;
begin
if (not changeOK) then
  begin
    showmessage('Author''s Order rules can be changed '
        + ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  begin
    If (ChoiceName1Box.itemindex=0)
      then Showmessage('The "Select 1st item" variable must be selected')
    else
      If ChoiceOneOfBox.itemindex=0
      then ShowMessage('The "Choose one of" variable must be selected')
    else with choicesListbox do
      if (selcount<1) or (selcount>3)
      then ShowMessage(format('Choose 1 to 3 alternative values of %s for %s',
                [choicename1box.items[choicename1box.itemindex],
                 ChoiceOneOfBox.items[ChoiceOneOfBox.itemindex]]))
    else
    begin
      list:=      TStringlist.create;
      list.add('');
      with Combobox4 do list.add(items[itemindex]);
      with ChoiceName1Box do list.add(items[itemindex]);
      with ChoiceOneOfBox do list.add(items[itemindex]);
      with choiceslistbox do
      begin
        for i:=0 to count-1 do
        begin
          if selected[i] then list.add(items[i]);
        end;
      end;
      MakeChoice(ChoiceGrid,list);
      list.free;
      modified[choicestmt]:=true;
    end;
  end;
end;

procedure TForm1.DeletChoiceBtnClick(Sender: TObject);
begin
  if (not changeOK) then
  begin
    showmessage('Author''s facts can be changed '
       +  ' only in "Author" mode.'+#13+'See Options above');
    exit;
  end;
  deleterowclick(ChoiceGrid);
end;

procedure TForm1.ChoiceGridDblClick(Sender: TObject);
begin
  with choicegrid do
  begin
    if cells[7,row]='X' then cells[7,row]:='-' else cells[7,row]:='X';
  end;
end;


Procedure TForm1.MakeChoice(CGrid:TStringgrid; list:TStringlist);
{need code}
var i:integer;
  Begin
    with CGrid do
    Begin
      if rowcount=1 then AddChoiceGridHdr(CGrid);
      if modrow<0 then
      Begin
        rowcount:=rowcount+1;
        modrow:=rowcount-1;
        cells[7,modrow]:='X';
      end;
      if list[0]='' then cells[0,modrow]:='C'+inttostr(modrow)
      else cells[0,modrow]:=list[0];
      fixedrows:=1;
      for i:=1 to list.count-1 do
      begin
        Cells[i,modrow]:=list[i];
        AdjustWidth(Cgrid,i,modrow);
      end;
      {for single character reference, prefix with blank for sorting purposes}
      if length(cells[1,modrow])=1 then cells[1,modrow]:=' '+cells[1,modrow];
      cells[8,modrow]:='';  {blank out "used" column}
      col:=0;
      row:=modrow;
    end;
end;



(*
procedure TForm1.LogSheetEnter(Sender: TObject);
begin
  //findbtn.BringToFront;
  //finddialog1.execute;
end;
*)

{*************** StartUpClick ***********}
procedure TForm1.StartUpClick(Sender: TObject);
begin
  with StartUp do checked := not checked;
end;



end.





