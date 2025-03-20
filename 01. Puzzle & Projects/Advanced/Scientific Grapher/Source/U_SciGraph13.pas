unit U_SciGraph13;
{Sci-Grapher }
 {Copyright  © 2000-2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  TeEngine, Series, ExtCtrls, TeeProcs, Chart, StdCtrls, Menus,
  ComCtrls, UParser10, ShellAPI;

type
  TConstObj=class(TObject)
    constname:char;
    rename:char;
    constvalue:extended;
  end;

  TExpression=class(TObject) {Expression object}
   protected
    function FindIndependent(s:String):char;
    procedure ChangeIndependent(var s:String; Newvar:char);
    procedure Fixup(var s:string);
  public
    expressionName:string;
    constants:TStringlist;
    Xexpression:string;
    YExpression:string;
    ConstantExpression:string;
    ExpressionText, ConstantText:string;
    AnglesInDegrees:Boolean;
    MinV, MaxV:double;
    ScaleMin, ScaleMax:double;
    Autoscale:boolean;
    NbrPoints:integer;
    Title:string;
    defined, errorflag :boolean;
    constructor create(newexpname:string);
    procedure setdata; {move data from expression to expressiondlg}
    procedure getdata; {move data rom expressiondlg to expression}
    procedure cleardata;  {clear expressiondlg data}
    procedure convertXYExpression(InputExp:String);
    procedure convertConstantExpression(InputExp:String);
  end;

  TForm1 = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Print1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    Saveas1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    ExpressionSets1: TMenuItem;
    ExpressionSet11: TMenuItem;
    ExpressionSet21: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    About1: TMenuItem;
    Chart1: TChart;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    About2: TMenuItem;
    DefiningFunctions1: TMenuItem;
    Navigatingthechart1: TMenuItem;
    New1: TMenuItem;
    Savepic1: TMenuItem;
    StaticText1: TStaticText;
    procedure FormActivate(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure ExpressionSet11Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Saveas1Click(Sender: TObject);
    procedure ExpressionSet21Click(Sender: TObject);
    procedure PrintSetup1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure DefiningFunctions1Click(Sender: TObject);
    procedure Chart1Resize(Sender: TObject);
    procedure Chart1Click(Sender: TObject);
    procedure Navigatingthechart1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Savepic1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    currentfilename:string;
    currentpath:string;
    version:string;
    Parser1, Parser2:TExParser;
    errorflag:boolean;
    Expression1, Expression2:TExpression;
    modified:boolean;  {flag that chart has been modified}
    procedure loadgraph(filename:string);
    procedure savegraph(filename:string);
    procedure ShowGraph;
    function checkmodified:boolean;
  end;

var  Form1: TForm1;

implementation

uses DFFUtils, U_ExpressionDlg, Inifiles, U_Aboutpas, U_FuncNotes, U_NavigateHelp;

{$R *.DFM}

{***************************************************}
{          TExpression Class Methods                }
{***************************************************}

constructor TExpression.create(NewExpName:string);
begin
  inherited create;
  expressionname:=newexpName;
  constants:=TStringlist.create;
  constants.duplicates:=dupignore;
end;

{****************** ConvertXYExpression ************}
procedure TExpression.ConvertXYExpression(InputExp:String);
 var
  s:string;
  v1,v2:string;
  n:integer;
 Begin
    XExpression:='';
    YExpression:='';
    Expressiontext:=trim(InputExp);
    s:=deblank(uppercase(InputExp));
    If length(s)=0 then exit;
    v1:=' '; v2:=' ';
    errorflag:=false;
    {parametric expressions contain 2 expressions
      X=xxxxx; Y=......
    }
    if s[2]='=' then
    Begin
      if s[1]='X' then
      Begin
        n:=pos(';',s);
        if n>0 then
        Begin
          xexpression := copy(s,1,n-1);
          delete(Xexpression,1,2); {get rid of the X=}
          delete(s,1,n); {Get rid of everything up through ';' in input expr.}
        end
        else
        Begin
          showmessage('Error: If X is specified as an indepenedent variable '
                     + 'then Y must be also specified in a separate equation'
                     +'preceded by a '';''');
          errorflag:=true;
        end;
      end
      else XExpression:='';
      s:=trim(s);  {check the Y= part}
      if (s[1]='Y') and (s[2]='=') then
      Begin
        YExpression:=s;
        delete(YExpression,1,2); {get rid of Y= part}
      end
      else Yexpression:='';
    end
    else Yexpression:=s;
    If not errorflag then
    Begin
      If Xexpression<>'' then
      Begin
        V1:=FindIndependent(Xexpression);
        Fixup(Xexpression);
      end;
      V2:=FindIndependent(YExpression);
      Fixup(YExpression);
    end;

    If (v1<>' ') and (V1<>v2) then
    Begin
      showmessage('Error: If equations in X and Y are provided, they '
                +' must contain the same independent parametric variable');
      errorflag:=true;
    end;
    {make everything  parametric in T}
    If xExpression='' then XExpression:='T';
    ChangeIndependent(XExpression,'T');
    ChangeIndependent(YExpression,'T');
  end;


{************** Val  (my version) **************}
  procedure val(const s:string; var v:extended; var errcode:integer);
  {version of Val function that handles decimalseparator correctly,
   One difference: after an error, "errcode" points to last character in string
   rather than the error character}
  var digits:set of char;
  begin
    try
      digits:=['0'..'9'];
      errcode:=0;
      v:=strtoFloat(s);
    except
        On econverterror do
        begin  {there is an error, let's find it and point to it}
          errcode:=1;
          if s[errcode] in ['+','-'] then inc(errcode);
          while (errcode<=length(s)) and (s[errcode] in digits+[decimalseparator]) do inc(errcode);
          if (errcode<length(s)) and (s[errcode] in ['e','E']) then
          begin
            inc(errcode);
            if (errcode<length(s)) then
            begin
              if s[errcode] in ['+','-'] then inc(errcode);
              while (errcode<=length(s)) and (s[errcode] in digits) do inc(errcode);
            end;
          end;
        end;
    end; {try}
  end;

{****************** ConvertConstant ************}
procedure TExpression.ConvertConstantExpression(InputExp:String);
 var                                           
  s:string;
  n:integer;
  cname:char;
  cvalue:extended;
  cexpression:string;
  errcode:integer;
  i:integer;
  constobj:TConstObj;

  begin
    with constants do
    for i:=count-1 downto 0 do tconstObj(objects[i]).free;
    Constants.clear;
    Constanttext:=InputExp;
    s:=deblank(uppercase(InputExp));
    if (length(s)>0) and (s[length(s)]<>';') then s:=s+';';
    If length(s)<=1 then exit;
    errorflag:=false;
    {constant equations contain constant equations
      A=number; B=number; etc.
    }
    while (length(s)>0) and (not errorflag) do
    begin
      if s[2]='=' then
      begin
        if (s[1] in ['A'..'Z']) and (Not (s[1] in ['X','Y'])) then
        begin
          n:=pos(';',s);
          if n>0 then
          begin
            cexpression := copy(s,1,n-1);
            cname:=s[1];
            delete(cexpression,1,2); {get rid of the K=}
            delete(s,1,n); {Get rid of everything up through ';' in input expr.}
            s:=trim(s); {remove leading blanks}
            val(cexpression,cvalue,errcode);
            if errcode>0 then errorflag:=true
            else
            begin;
              ConstObj:=TConstObj.create;
              constobj.constname:=cname;
              constobj.constvalue:=cvalue;
              constants.addobject(cname,constobj);
            end;
          end
          else errorflag:=true;
        end
        else errorflag:=true;
      end
      else errorflag:=true;
    end;
    if errorflag then
    begin
      showmessage('Error: Constant equation must have form letter=number'
             + ' where "letter" is a single letter not "X" or "Y", '
             +'and number is a valid integer or floating point number. '
             +' Multiple constant equations must be separated by a ";".');
    end
    else
    begin
      with constants do
      begin
        if count>5 then
        begin
          showmessage('Only 5 constants allowed, extras ignored');
        end
        else
        begin
          for i:=0 to count-1 do
              TConstObj(objects[i]).rename:=char(ord('A')+i);
          sort;
        end;
      end;
    end;
  end;


{***************** GetData **********}
procedure TExpression.Getdata;
{transfer data from expressiondlg fields to expressions}
Begin
  defined:=true;
  With expressionDlg do
  Begin
    ConvertConstantExpression(ConstEdt.text);
    ConvertXYExpression(Expressionedt.text);
    minV:=strtofloat(minVEdt.text);
    maxV:=strtofloat(maxVedt.text);
    autoscale:=AutoScaleBox.checked;
    Scalemin:=StrToFloat(ScaleMinEdt.text);
    Scalemax:=StrToFloat(ScaleMaxEdt.text);
    nbrpoints:=(strtoint(nbrpointsedt.text));
    title:=SeriesTitleEdt.text;
    anglesinDegrees:=Angleconvertbox.checked;
  end;
end;

{**************** SetData *************}
 procedure TExpression.setdata;
 {Put expression data into the dialog}
 Begin
   with ExpressionDlg do
   begin
     if defined then
     Begin
       expressionedt.text:=Expressiontext;
       constedt.text:=Constanttext;
       nbrpointsEdt.text:=inttostr(nbrpoints);
       minVEdt.text:=floatTostr(minv);
       MaxVEdt.text:=floattostr(maxV);
       AutoScaleBox.checked:=autoscale;
       ScaleMinEdt.text:=floatTostr(Scalemin);
       ScaleMaxEdt.text:=floattostr(Scalemax);
       if autoscalebox.checked then
       begin
         scaleminedt.enabled:=false;
         scalemaxedt.enabled:=false;
         label6.enabled:=false;
         label7.enabled:=false;
       end
       else
       begin
         scaleminedt.enabled:=true;
         scalemaxedt.enabled:=true;
         label6.enabled:=true;
         label7.enabled:=true;
       end;

       If anglesInDegrees then AngleConvertBox.checked:=true
       else AngleConvertBox.checked:=false;
       seriestitleEdt.text:=title;
     end;
   end;
 end;

 {************ ClearData ***********}
procedure TExpression.cleardata;
 {Put clear dialog data}
 Begin
   with ExpressionDlg do
   begin
      expressionedt.text:=' ';
       nbrpointsEdt.text:='100';
       minVEdt.text:='-10';
       MaxVEdt.text:='+10';
       AutoScale:=true;
       AngleConvertBox.checked:=true;
       seriestitleEdt.text:='';
   end;
 end;

{****************** FindIndependent ************}
function TExpression.FindIndependent(s:String):char;
{check for single letter variable and return it to caller}
{It will be a letter surrounded by  paren, operator or ',' since there are no
 single letter functions, also must not be in the Constants stringlist}
const delims=['+','-','*','/','(',')','^'];
var
  i, index:integer;
  prevdelim, nextdelim:boolean;
Begin
  result:=' ';
  s:=uppercase(s);
  for i:= 1 to length(s) do
  Begin
    prevdelim:=false;
    nextdelim:=false;
    if i=1 then prevdelim:=true
    else if s[i-1] in delims then prevdelim:=true;
    if i=length(s) then nextdelim:=true
    else if s[i+1] in delims then nextdelim:=true;
    if (s[i] in ['A'..'Z']) and prevdelim and nextdelim
            and ( not constants.find(s[i],index)) then
    begin
      result:=s[i];
      break;
    end;
  end;
end;


{***************** ChangeIndependent **************}
procedure TExpression.ChangeIndependent(var s:String; Newvar:char);
{check for single letter variable not in constants stringlist.}
{It will be a letter surrounded by  paren, operator or ','
 when found, change it to Newvar.  If a letter surrounded by
 delims is in the constants stringlist, change it to the "rename"
 constant name.  This is a letter in the range 'A'..'E' expected by
 the parser}

const delims=['+','-','*','/','(',')','^'];
var
  i, index:integer;
  prevdelim, nextdelim:boolean;

Begin
  for i:= 1 to length(s) do
  Begin
    prevdelim:=false;
    nextdelim:=false;
    if i=1 then prevdelim:=true
    else if s[i-1] in delims then prevdelim:=true;
    if i=length(s) then nextdelim:=true
    else if s[i+1] in delims then nextdelim:=true;
    if (s[i] in ['A'..'Z']) and prevdelim and nextdelim
    then
    begin  {change constants to range 'A'..'E' expected by parser}
      if constants.find(s[i],index) then
      begin
        s[i]:=TConstObj(constants.objects[index]).rename;
      end
      else s[i]:=newvar;
    end;
  end;
end;


{*************** Fixup **************}
procedure TExpression.Fixup(var s:string);
{insert multiplier to convert trig function to radians for cases where angles are
input in degrees}
var
  j,n:integer;
const
  m='0.017453292519943*('; {pi/180}
Begin
  If anglesinDegrees then
  Begin
    n:=pos('SIN(',s);

    If n>0 then
    while n>0 do
    Begin
      if (n<=3) or ((n>3) and (copy(s,n-3,3)<>'ARC')) {don't change Arcsin}
      then
      Begin
        for j:=n+1 to length(s) do if s[j]=')' then break;
        insert(')',s,j);
        s[n]:='s';
        insert(m,s,n+4);
      end;
      n:=pos('SIN(',s);
    end;
    n:=pos('COS(',s);
    If n>0 then
    while n>0 do
    Begin
      if (n<=3) or ((n>3) and (copy(s,n-3,3)<>'ARC')) {don't change ArcCos}
      then
      Begin
        for j:=n+1 to length(s) do if s[j]=')' then break;
        insert(')',s,j);
        s[n]:='c';{change COS to cOS so we don't find it again}
        insert(m,s,n+4);
      end;
      n:=pos('COS(',s);
    end;
  end;
  s:=uppercase(s);
end;

{***************************************************}
{              TForm1 Class Methods                 }
{***************************************************}


{******************* FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  Parser1:=TExParser.create(self);  {Parser object for 1st expression}
  Parser2:=TExParser.create(self); {Parser object for 2nd expression}
  Expression1:=TExpression.create('Expression1');
  Expression1.defined:=false;
  Expression2:=TExpression.create('expression2');
  Expression2.defined:=false;
  {Don't sort points by x value-allows parametric expressions to plot correctly}
  Series1.xvalues.order:=loNone;
  Series2.xvalues.order:=loNone;
  currentfilename:='None';
  currentpath:=extractfilepath(application.exename);
  //showmessage('Current search path for graphs is '+currentpath);
  SetCurrentdir(currentpath);
  version:='Sci-Graph V1.3';
  if fileexists(currentpath+'default.grf') then loadgraph(currentpath+'default.grf');
end;

{************** Checkmodified ***********}
function tform1.checkmodified:boolean;
{Check to see if modified flag is set and ask use about saving if true}
var r:integer;
begin
  if modified
  then
  begin
    r:=messagedlg('Save '+currentfilename+' first?', mtconfirmation,
           [mbYes, Mbno, Mbcancel],0);
    if r=mrcancel then
    begin
      result:=false;
      modified:=false;
    end
    else
    begin
      if r=mryes then savegraph(currentfilename);
      modified:=false;
      result:=true;
    end;
  end
  else result:=true;
end;

{***************** ShowGraph *************}
procedure TForm1.ShowGraph;
{Display the graph}
var
  x,y,V,delta,minx,maxx :double;

    procedure BuildSeries(expression:TExpression; Series:TFastLineSeries);
    {build the data series for charting a particular expressiono}
    var
      i,n:integer;
    begin
      series.showinlegend:=false;
      with expression do
      If defined and (not errorflag) and (length(expressiontext)>0) then
      Begin
        parser1.expression:=XExpression;
        parser2.expression:=YExpression;
        Series.title:=title;
        series.showinlegend:=true;

        Chart1.title.Text.add('Plot of '+ expressiontext);
        if constanttext<>'' then Chart1.title.Text.add('Constants: '+ constanttext);
        if autoscale then chart1.LeftAxis.automatic:=true
        else with chart1.leftaxis do
        begin
          automatic:=false;
          minimum:=scalemin;
          maximum:=scalemax;
        end;

        delta:=(maxV-minV)/nbrpoints;
        V:=minV;
        {Evaluate the points to plot for expression1}
        {Finds max and min for setting axis points - not currently used}
        minx:=1E100;
        maxx:=-1E100;

        {assign constants to parser}
        with constants do
        for i:=0 to count-1 do
        if i<5 then
        with TConstObj(objects[i]) do
        case rename of
          'A':begin
               parser1.a:=constvalue;
               parser2.a:=constvalue;
              end;
          'B':begin
                parser1.b:=constvalue;
                parser2.b:=constvalue;
              end;
          'C':begin
                parser1.c:=constvalue;
                parser2.c:=constvalue;
              end;
          'D':begin
                parser1.d:=constvalue;
                parser2.d:=constvalue;
              end;
          'E':begin
                parser1.e:=constvalue;
                parser2.e:=constvalue;
              end;

        end;

        for n:= 1 to nbrpoints-1 do
        Begin
          parser1.T:=V;
          x:=parser1.value;
          if x<minx then minx:=x;
          If x>maxx then maxx:=x;
          parser2.T:=V;
          y:=parser2.value;
          Series.Addxy(x,y,'',clBlue);
          v:=v+delta;
        end;
      end;
    end;


begin
  {Show title fields in legends}
  if not expression2.defined then expression2.title:='';
  If (expression1.title<>'') or (expression2.title<>'')
  then chart1.legend.visible:=true
  else chart1.legend.visible:=false;
  series1.clear;
  series2.clear;
  Chart1.title.text.clear;
  buildSeries(expression1, series1);
  buildSeries(expression2,series2);
end;

{******************** Print1Click ***********}
procedure TForm1.Print1Click(Sender: TObject);
{Print the chart}
var
  save:TColor;
begin
  with chart1 do
  Begin
    save:=backcolor;
    backcolor:=clWhite;
    print;
    backcolor:=save;
  end;
end;

{******************* ExpressionSet11Click ***********}
procedure TForm1.ExpressionSet11Click(Sender: TObject);
begin
  expressionDlg.caption:='Series 1';
  If expression1.defined then
  Begin
     expression1.SetData;  {initialize expression1 display}
     If expression1.title<>'' then expressionDlg.caption:=expression1.title;
  end;

  If ExpressionDlg.showmodal=MrOK  then
  Begin
    modified:=true;
    expression1.getdata; {retrieve expression data from dialog}
    ShowGraph;
  end;
end;

{********************* ExpressionSet21Click **************}
procedure TForm1.ExpressionSet21Click(Sender: TObject);
begin
  expressionDlg.caption:='Series 2';
  If expression2.defined then
  Begin
    expression2.SetData;
    If expression2.title<>'' then expressionDlg.caption:=expression2.title;
  end
  else expression2.cleardata;

  If ExpressionDlg.showmodal=MrOK  then
  Begin
    modified:=true;
    expression2.getdata;
    showGraph;
  end;
end;

{****************** New1Click ************}
procedure TForm1.New1Click(Sender: TObject);
begin
  if checkmodified then
  begin
    currentfilename:='New';
    series1.clear;
    series2.clear;
    modified:=false;
    expression1.cleardata;
    expression2.cleardata;
    chart1.title.text.clear;
    series1.showInLegend:=false;
    self.caption:=version+' - Current chart: '+extractfilename('New');
  end;
end;


{********************* LoadGraph ************}
procedure TForm1.loadgraph(filename:string);
var ini:Tinifile;

 procedure getexp(expression:TExpression);
 begin
   with expression, ExpressionDlg, Ini do
   begin
     ExpressionText:=ReadString(expressionName, 'ExpressionText','x^2');
     ConstantText:=readstring(expressionName,'ConstantText','');
     MinV:=ReadFloat(expressionName, 'MinV',-10);
     MaxV:=ReadFloat(expressionName, 'MaxV',+10);
     Autoscale:=ReadBool(expressionName,'AutoScale',true);
     Scalemin:=ReadFloat(expressionName,'LeftScaleMin',-10);
     Scalemax:=ReadFloat(expressionName,'LeftScaleMax',10);
     NbrPoints:=ReadInteger(expressionName, 'NbrPoints',100);
     AnglesInDegrees:=ReadBool(expressionName, 'AnglesInDegrees',true);
     ConvertConstantExpression(Constanttext);
     ConvertXYExpression(ExpressionText);
     title:=Readstring(Expressionname, 'Title','');
     if expressiontext<>'' then defined:=true
     else defined:=false;
   end;
 end;


begin
  if checkmodified then
  begin
    currentpath:=extractfilepath(filename);
    {we use an init file format to save and restore values}
    Ini:=TiniFile.create(filename);
    currentfilename:=filename;
    modified:=false;
    getexp(expression1);
    getexp(expression2);
    self.caption:=version+' - Current chart: '+extractfilename(filename);
    showGraph;
    Ini.free;
  end;
end;

{***************** Open1Click *************}
procedure TForm1.Open1Click(Sender: TObject);
{User requested to open graph file}
begin
  if checkmodified then
  begin
    opendialog1.initialdir:=currentpath;
    If opendialog1.execute then loadgraph(opendialog1.FileName);

  end;
end;

procedure TForm1.Saveas1Click(Sender: TObject);
begin
  If SaveDialog1.execute then
  Begin
    currentfilename:=SaveDialog1.filename;
    savegraph(SaveDialog1.filename);
  end;
end;


{******************* SaveGraph *************}
procedure TForm1.savegraph(filename:String);
var Ini:Tinifile;
  procedure saveexp(expression:TExpression);
  begin
  with ini, expressionDlg, expression do
    Begin
      writeString(expressionname, 'ExpressionText',ExpressionText);
      writeString(expressionname, 'ConstantText',ConstantText);
      WriteFloat(ExpressionName, 'MinV',MinV);
      WriteFloat(ExpressionName, 'MaxV',MaxV);
      WriteBool(ExpressionName,'AutoScale',Autoscale);
      WriteFloat(ExpressionName,'LeftScaleMin',ScaleMin);
      WriteFloat(ExpressionName,'LeftScaleMax',ScaleMax);
      WriteInteger(ExpressionName, 'NbrPoints',NbrPoints);
      WriteBool(ExpressionName, 'AnglesInDegrees',AnglesInDegrees);
      WriteString(ExpressionName,'Title',title);
    end;
  end;


begin
  currentfilename:=filename;
  self.caption:=version+' - Current chart: '+extractfilename(currentfilename);
  Ini:=TInifile.create(currentfilename);
  with Ini, ExpressionDlg do
  Begin
    {We'll save the expression data as an Init file}
    saveexp(expression1);
    saveexp(expression2);
   (*
    with expression2 do
    Begin
      writeString('Expression2', 'ExpressionText',ExpressionText);
      writeString('Expression2', 'Constanttext',ConstantText);
      WriteFloat('Expression2', 'MinV',MinV);
      WriteFloat('Expression2', 'MaxV',MaxV);
      WriteBool('Expression2','AutoScale',Autoscale);
      WriteFloat('Expression2','LeftScaleMin',ScaleMin);
      WriteFloat('Expression2','LeftScaleMax',ScaleMax);
      WriteInteger('Expression2', 'NbrPoints',NbrPoints);
      WriteBool('Expression2', 'AnglesInDegrees',AnglesInDegrees);
      WriteString('Expression2','Title',title);
    end;
    *)
  end;
  modified:=false;
end;

{***************** PrintSetup1Click *********}
procedure TForm1.PrintSetup1Click(Sender: TObject);
begin  printersetupDialog1.execute; end;

{**************** About1Click *********}
procedure TForm1.About1Click(Sender: TObject);
begin Aboutbox.showmodal;  end;

{**************** Save1Click ************}
procedure TForm1.Save1Click(Sender: TObject);
begin
  if currentfilename='New'
  then showmessage('Not yet named, use ''Save as...'' to assign a name ')
  else savegraph(currentfilename);
end;

{**************** DefiningFunctions1Click *************}
procedure TForm1.DefiningFunctions1Click(Sender: TObject);
begin  FuncNotesDlg.showmodal; end;

{************* Chart1Resize ***********}
procedure TForm1.Chart1Resize(Sender: TObject);
{keep the chart square}
begin
   with chart1 do
   begin
     if width>height then width:=height
     else height:=width;
     left:=(self.width-width) div 2;
   end;
end;

{*************** Chart1Click ************}
procedure TForm1.Chart1Click(Sender: TObject);
 var t,tmp:Longint;
     x,y:Double;
begin
  for t:=0 to Chart1.SeriesCount-1 do
  with chart1 do
  begin
     Series[t].GetCursorValues(x,y);
     tmp:=Series[t].GetCursorValueIndex;
     if tmp<>-1 then
         ShowMessage(' Clicked Series: '+Series[t].Name+' near point: '
       + Floattostrf(Series[t].XValue[tmp],ffnumber,8,3) + ','
       + Floattostrf(Series[t].YValue[tmp],ffnumber,8,3))
  end;
end;

{**************** NavigatingtheChart1Click *********}
procedure TForm1.Navigatingthechart1Click(Sender: TObject);
begin    NavNotesDlg.showmodal  end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if checkmodified then canclose:=true else canclose:=false;
end;

   procedure TForm1.SavePic1Click(Sender: TObject);
var b:TBitmap;
begin
  b:=TBitmap.create;
  b.height:=chart1.height;
  b.width:=chart1.width;
  b.canvas.draw(0,0,TGraphic(chart1.canvas));
  b.savetofile('graphpic.bmp');
  b.free;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
