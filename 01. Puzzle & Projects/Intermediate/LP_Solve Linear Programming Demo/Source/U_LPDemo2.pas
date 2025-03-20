unit U_LPDemo2;
{Copyright © 2011, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
This program illustrates some simple examples of a Delphi interface to LP-Solve,
a free linear programming tool available from http://lpsolve.sourceforge.net/
and/or  http://tech.groups.yahoo.com/group/lp_solve/.  See my webpage
http://delphiforfun.org/programs/delphitechniques/lpsolveDemo.htm for more
details.  
*)


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, Spin, Grids, ComCtrls, lpSolve51;

type

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet3: TTabSheet;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Memo1: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    table: TStringGrid;
    NVarsEdt: TSpinEdit;
    NConstraintsEdt: TSpinEdit;
    MaxMinGrp: TRadioGroup;
    SolveBtn: TButton;
    SaveBtn: TButton;
    LoadBtn: TButton;
    NewcaseBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure SolveBtnClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TableSizeChange(Sender: TObject);
    procedure LoadSampleBtnClick(Sender: TObject);
    procedure tableDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure tableSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: String);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NewcaseBtnClick(Sender: TObject);
  public
    lp: THandle;
    modified:boolean;
    filename:string;
    savetext:string;{input problem description text is saved here to detect changes}
    procedure Loadcase(newfilename:string);
    procedure Savecase(newfilename:string);
    function checkmodified:boolean;
    function DeleteSolutiontext:integer;
  end;


var
  Form1: TForm1;

implementation

{$R *.DFM}



{************* SolveBtnClick *************}
procedure TForm1.SolveBtnClick(Sender: TObject);
var
  i,j:integer;
  rowData,colData:array[0..10] of real;
  s,s2:AnsiString;
  ch:AnsiChar;
  op:integer;
  rh,sum:real;
  nvars,nrows,r:integer;

  function getType(r:integer):string;
  var n:integer;
  begin
    n:=get_constr_type(lp,r);
    case n of
    1: result:='<=';
    2: result:='>=';
    3: result:='=';
    else result:='??';
    end;
  end;


  function getRH(r:integer):real;
  begin
    result:=get_rh(lp,r);
  end;


begin     {SolveBtnClick}
  with memo2 do
  begin {delete any previous solution display}
    for i:=lines.count-1 downto 0 do
    begin
      if (length(lines[i])>=2) and (copy(lines[i],1,2)= '--')
      then break
      else lines.delete(i);
    end;
  end;

  with table do
  begin
    nvars:=colcount-3;
    lp := make_lp(0,nvars);
    if (lp <> 0) then

    {Set column names}
    for i:=1 to colcount-3 do
    begin
      if not set_col_name(lp,i,pchar(cells[i,0]))
      then showmessage('Set column name failed for '+ cells[i,0]);
    end;

    {Set constraints}
    for j:=2 to rowcount-1 do
    begin
      s:=cells[1,j];
      for i:=2 to colcount-3 do s:=s+' ' +cells[i,j];
      rh:=strtofloatdef(cells[colcount-1,j],0);
      s2:=uppercase(cells[colcount-2,j]);
      ch:=s2[1];
      if ch='<'then op:=LE
      else if ch='>' then op:=GE
      else if ch='=' then op:=EQ
      else
      begin
        showmessage('operation code '+ cells[colcount-2,j] +' is not valid');
        op:=LE;
      end;

      if str_add_constraint(lp,PChar(s),op, rh) then
      begin
        set_row_name(lp,j,pchar(cells[0,j]));
      end
      else showmessage('Invalid constraint '+ s+ ' ' + s2 +' '+ floattostr(rh));
    end;

    s:=cells[1,1];
    for i:=2 to nvars do s:=s + ' '+ cells[i,1];
    if  str_set_obj_fn(lp, pchar(s)) then
    begin
      set_row_name(lp,0,pchar(cells[0,1]));
      if Maxmingrp.itemindex=1 then set_maxim(lp);
      if solve(lp)=0 then
      with memo2, lines do
      begin
        add('');
        add('Solved');
        add('Optimum variable values are:');
        nvars:=get_nColumns(lp);
        get_variables(lp,@colData);
        for i:=0 to nvars-1 do  {display variable values}
        begin
          add(format('        %s = %.3f',[get_col_name(lp,i+1),colData[i]]));
        end;
        add('');
        {display objective equation}
        for r:=0 to 0 do
        begin
          s:=get_row_name(lp,r);
          add(s);
          nrows:=get_nRows(lp);
          get_row(lp,r,@rowData);
          s:=format('         %.3f * %s ',[rowData[1],get_col_name(lp,1)]);

          for i:= 2 to nvars do
          s:=s+ format(' + %.3f * %s = ???',[rowData[i],get_col_name(lp,i)]);
          add(s);

          sum:=colData[0]*rowData[1];
          s:=format('         %.3f * %.3f ',[rowData[1],colData[0]]);
          for i:= 2 to nvars do
          begin
            s:=s+ format(' + %.3f * %.3f ',[rowData[i],colData[i-1]]);
            sum:=sum+rowData[i]*colData[i-1];
          end;
          s:=s +  ' = ' + format(' %.3f',[sum]);
          add(s);
        end;

        add('');
        add('Constraints');
        for r:=1 to nrows do
        begin
          s:=get_row_name(lp,r);
          add(s);
          get_row(lp,r,@rowData);
          s:=format('         %.3f * %s ',[rowData[1],get_col_name(lp,1)]);

          for i:= 2 to nvars do
          s:=s+ format(' + %.3f * %s ',[rowData[i],get_col_name(lp,i)]);
          s:=s +  getType(r) + format(' %.3f',[getrh(r)]);
          add(s);
          sum:=colData[0]*rowData[1];
          s:=format('         %.3f * %.3f ',[rowData[1],colData[0]]);
          for i:= 2 to nvars do
          begin
            s:=s+ format(' + %.3f * %.3f ',[rowData[i],colData[i-1]]);
            sum:=sum+rowData[i]*colData[i-1];
          end;
          s:=s +  ' = ' + format(' %.3f',[sum]);
          add(s);
        end;
        pagecontrol1.activepage:=tabsheet3;
      end
      else
      with memo2 do
      begin
        clear;
        lines.add('Not solved');
      end;
    end;
  end;
  delete_lp(lp);
end;

{**************** LoadSampleBtnClick *************}
procedure TForm1.LoadSampleBtnClick(Sender: TObject);
{Only called if sample.stm  file is missing}
var
  i,j,d:integer;
begin
  with table do
  begin
    NVarsEdt.value:=2;
    NConstraintsEdt.value:=3;
    colcount:=NvarsEdt.Value+3;
    rowcount:=NConstraintsEdt.Value+2;
    cells[1,0]:='Wheat acres';
    cells[2,0]:='Barley acres';
    cells[0,1]:='Profit Objective';
    cells[0,2]:='Planting cost';
    cells[0,3]:='Bushels of storage';
    cells[0,4]:='Acres to plant';

    cells[1,1]:='143';
    cells[1,2]:='120';
    cells[1,3]:='110';
    cells[1,4]:='1';

    cells[2,1]:='60';;
    cells[2,2]:='210';
    cells[2,3]:='30';
    cells[2,4]:='1';

    cells[3,1]:='=';
    cells[3,2]:='<=';
    cells[3,3]:='<=';
    cells[3,4]:='<=';

    cells[4,1]:='???';
    cells[4,2]:='15000';
    cells[4,3]:='4000';
    cells[4,4]:='75';

    FOR i:=0 to colcount-1 do
    begin
      d:=defaultcolwidth;
      for j:=0 to rowcount-1 do
      if canvas.TextWidth(cells[i,j])+4>d then d:=canvas.TextWidth(cells[i,j])+4;
      colwidths[i]:=d;
    end;
    maxmingrp.itemindex:=1; {maximize}
  end;
  modified:=false;
  pagecontrol1.activepage:=tabsheet3;
end;

{**************** SaveBtnClick *************}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  savedialog1.FileName:=filename;
  if savedialog1.execute then
  begin
    savecase(savedialog1.filename);
    tabsheet3.Caption:=extractfilename(savedialog1.FileName);
  end;
end;

{**************** LoadBtnClick *********}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  if checkmodified and opendialog1.execute then
  begin
    loadcase(opendialog1.filename);
  end;
end;

{***************** FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
var
  dir:string;
  filename:string;
begin
  dir:=extractfilepath(application.ExeName);
  opendialog1.InitialDir:=dir;
  savedialog1.InitialDir:=dir;
  filename:=dir+'sample.stm';
  modified:=false;
  if fileexists(filename) then loadcase(filename)
  else loadsamplebtnclick(sender);
  Pagecontrol1.activepage:=Tabsheet1;
end;

{************ Tablesizechange ***********}
procedure TForm1.TableSizeChange(Sender: TObject);
{Called when nbr variables or nbr constraints changes}
var
  r,c:integer;
begin
  with table do
  begin
    ColCount:=NVarsEdt.Value+3;
    RowCount:=NConstraintsEdt.value+2;
    modified:=true;
    if filename='New case' then newcasebtnclick(sender);
  end;
end;


{************ TableDrawCell *************}
procedure TForm1.tableDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Detect change in field size}
var n:integer;
begin
  with table, canvas  do
  begin
    n:=textwidth(cells[acol,arow]);
    if n>colwidths[acol]
    then  colwidths[acol]:=n;
  end;
end;

{------------ DeleteSolutionText -------}
  function TForm1.DeleteSolutionText:integer;
  {Called to delete any previous solution display following the final
   line of the problem description (which starts with ---- characters}
  var i:integer;
  begin
    result:=0;
    with memo2 do
    begin
      for i:=0 to lines.count-1 do
      if (length(lines[i])>2) and (copy(lines[i],1,2)='--') then
      begin
        result:=i;
        break;
      end;
      if result>0 then for i:=lines.count-1 downto result+1 do lines.delete(i);
    end;
  end;

{*********** SaveCase *********}
procedure TForm1.savecase(newfilename:string);
var
  stream:TFileStream;
  i,j,len:integer;
  s:string;
  c,r,n:integer;

  {--------- SaveString --------}
  procedure savestring(wideStr:string);
  var  n:integer;
       s:ansistring;  {save strings as ansistrings for compatibility with Delphi 7}
  begin
    with stream do
    begin
      s:=wideStr;
      n:=length(s);
      writebuffer(n,sizeof(n));
      if n>0 then writebuffer(s[1],n);
    end;
  end;




begin  {savecase}
  stream:=TFileStream.create(newfilename,fmCreate);
  with stream do
  begin
    n:=nvarsedt.value;
    writebuffer(n,sizeof(n));
    n:=nconstraintsEdt.value;
    writebuffer(n,sizeof(n));
    n:=maxmingrp.itemindex;
    writebuffer(n,sizeof(n));
    with table do
    begin
      n:=colcount;
      writebuffer(n,sizeof(n));
      n:=rowcount;
      writebuffer(n,sizeof(n));
      for c:=0 to colcount-1 do
      for r:=0  to rowcount-1 do
      begin
        savestring(cells[c,r]);
      end;
    end;
    n:=DeleteSolutionText;
    if n>1 then savestring(memo2.text)
    else
    begin  {write "no description available" indicator}
      n:=0;
      writebuffer(n,sizeof(n));
    end;
  end;
  stream.free;
  modified:=false;
  savetext:=memo2.text;
end;

{************* Loadcase **********}
procedure TForm1.Loadcase(newfilename:string);
var
  stream:TFileStream;
  i,j,d:integer;
  s:string;
  c,r,n:integer;

  {---------- LoadString -----------}
  procedure loadstring(var WideStr:string );
  var n:integer;
      S:ansistring; {Strings were saved as ansistrings, so reload them the same way}
  begin
    with stream do
    begin
      readbuffer(n,sizeof(n));
      setlength(s,n);
      if n>0 then readbuffer(s[1],n)
      else s:='';
      wideStr:=s;
    end;
  end;


begin {Loadcase}
  stream:=TFileStream.create(newfilename,fmOpenread);
  filename:=newfilename;
  with stream do
  begin  {read size, then value, for each saved field}
    modified:=false;
    readbuffer(n,sizeof(n));
    nvarsedt.value:=n;   {# of variables}

    readbuffer(n,sizeof(n));
    nconstraintsEdt.value:=n; {# of constraints}

    readbuffer(n,sizeof(n));
    maxmingrp.itemindex:=n;   {Max or min objective type index}

    with table do
    begin  {read stringgrid size and values}
      readbuffer(n,sizeof(n));
      colcount:=n;
      readbuffer(n,sizeof(n));
      rowcount:=n;
      for c:=0 to colcount-1 do
      for r:=0  to rowcount-1 do
      begin
        loadstring(s);
        cells[c,r]:=s;
      end;
      for i:=0 to colcount-1 do
      begin
        d:=defaultcolwidth;
        for j:=0 to rowcount-1 do
        if canvas.TextWidth(cells[i,j])>d then d:=canvas.TextWidth(cells[i,j])+8;
        colwidths[i]:=d;
      end;
      readbuffer(n,sizeof(n));  {read problem text size}
      modified:=false;
      if n>0 then
      with memo2, lines do
      begin
        seek(-sizeof(n),soFromCurrent); {back position up because loadstring will reread n value}
        clear;
        loadstring(s);
        text:=s;
        s:=lines[count-1];
        if (length(s)<2) or (copy(s,1,2)<>'--') then
        begin
          lines.Add('--------------');
          modified:=true;
        end;

        {If input text changes we'll catch it later by comparing text to savetext
         and give user a chance to save before overlaying it}
        savetext:=text;
      end;

    end;
  end;
  stream.free;
  tabsheet3.Caption:='Case: '+extractfilename(filename);
end;

{************ CheckModified ***********}
Function TForm1.CheckModified:Boolean;
{If current case was modified, give the user a chance to save it before
 exiting or loading a new case over it}
var r:integer;
begin
  result:=true;
  deletesolutiontext;
  if memo2.text<>savetext then modified:=true;
  if modified then
  begin
    R:=MessageDlg('Case '+ extractfilename(filename)+' has been modified. Save it first?',
                  mtconfirmation,[Mbyes, mbno, mbCancel],0);
    If r=mrcancel then result:=false
    else if r= mryes then
    begin
      savedialog1.FileName:=filename;
      if savedialog1.execute then savecase(Savedialog1.filename)
    end;
    modified := not result;   {If user canceled (result=false) then leave "modified" at true}
  end;
end;

{************** TableSetEdittext ************}
procedure TForm1.tableSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: String);
  {Detect table change}
begin
  modified:=true; {flag the case as modified}
end;

{*************** FormCloseQuery ********}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose:=checkmodified;   {If user said cancel to save request, stay in program}
end;

{*************** NewCasebtnClick ***********}
procedure TForm1.NewcaseBtnClick(Sender: TObject);
var
  c,r:integer;
begin
  if (filename='New case') or checkmodified then
  with table do
  begin
    for c:=0 to colcount-1 do
    for r:=0 to rowcount-1 do  cells[c,r]:='';
    cells[colcount-1, 0]:='Constant';
    cells[colcount-2,0]:='Op';
    for c:=1 to colcount-3 do cells[c,0]:='x'+inttostr(c);
    cells[colcount-2,1]:='=';
    cells[colcount-1,1]:='???';
    cells[0,1]:='Objective';
    for r:=2 to rowcount-1 do cells[0,r]:='Constraint '+inttostr(r-1);
    filename:='New case';
    memo2.clear;
    memo2.lines.add('Problem description goes here');
    memo2.lines.add('');
    memo2.lines.add('--------');
    modified:=true;
    tabsheet3.caption:=filename;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
