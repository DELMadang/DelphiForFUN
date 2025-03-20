unit U_CountPhrases;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  Tstringrec=record
    s:string;
  end;

  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    ListBox1: TListBox;
    LoadBtn: TButton;
    Show2Btn: TButton;
    Show3Btn: TButton;
    Show4Btn: TButton;
    CheckBox1: TCheckBox;
    OpenDialog1: TOpenDialog;
    SortByGrp: TRadioGroup;
    StaticText1: TStaticText;
    DelimsEdt: TEdit;
    Label1: TLabel;
    procedure LoadBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShowPhraseList(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure DelimsEdtChange(Sender: TObject);
  public
    w:array[1..4] of string;
    P2,p3,p4:string;
    n:integer;
    P2List,P3List,P4List:TStringlist;
    listsBuilt:boolean;  {Flag set to true after counting phrases, set false if text changes}
    delimsChanged:boolean; {Flag set to true if user modifies DelimsEdt delimiters}
    Procedure CountPhrases(List:TStrings);
    procedure resetwords;
    procedure Updatelist(list:TStringlist; p:string);
    procedure ShowSummary(list:TStrings);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  {the delimiters}
  delims: set of char=
  [' ', ',', '?', ';', '.', ':', '-','=','{','}','[',']','(',')','>','<'];

function getword( var line:string; var delim:char):string;
{destructive getword, pass a copy of the original input, not the original since
 upon return the first word will have been removed and returned as the result
 of the function }
var
  i,start:integer;
begin
  result:='';
  if length(line)>0 then
  begin
    if line[length(line)]<>' ' then line:=line+' ';
    start:=1;
    while (line[start] in delims) do inc(start);
    i:=start+1;
    if i<=length(line) then
    while not (line[i] in delims) do inc(i);
    delim:=line[i];
    result:=copy(line,start,i-start);
    delete(line,1,i);
  end;
end;

{****** ResetWords *********}
procedure TForm1.resetwords;
var  i:integer;
begin
  n:=0;
  for i:=1 to 4 do w[i]:='';
  p2:='';
  p3:='';
  p4:='';
end;

{************* UpdateList ************}
procedure TForm1.Updatelist(list:TStringlist; p:string);
{Add phrase "p" if not found and whether found or not, increment count
 of occurrences of phrase in "List"}
var index:integer;
begin
  with list do
  if not find(p,index) then addobject(p,TObject(1))
  else objects[index]:=Tobject(integer(objects[index])+1);
end;

{*********** CountPhrases ************}
procedure TForm1.CountPhrases;
{count words and add them to listbox1}
var
  i, j :integer;
  line:string;
  delim:char;
  s:string;
begin
  screen.Cursor:=crhourglass;
  listbox1.clear;
  p2list.Clear;
  p3list.Clear;
  p4list.clear;
  resetwords;
  if delimsChanged then
  with delimsedt do
  begin
    delims:=[' '];
    for i:=1 to length(text) do if text[i]<>' ' then delims:=delims+[text[i]];
    delimsChanged:=false;
  end;
  for i:=0 to memo1.lines.count-1 do
  begin
    line:=trim(memo1.lines[i]);
    while line<>'' do
    begin
      line:=line+' ';
      for j:=1 to 3 do w[j]:=w[j+1];
      s:=getword(line,delim);
      if length(s)>0 then
      begin
        w[4]:=s;
        inc(n);
        if n>=2 then
        begin
          P2:=w[3]+' '+w[4];
          updatelist(p2list,p2);
        end;

        If n>=3 then
        begin
          P3:=w[2]+' '+p2;
          updatelist(p3list,p3);
        end;
        If n>=4 then
        begin
          P4:=w[1]+' '+p3;
          updatelist(p4list,p4);
        end;
      end;
      {don't extend phrases across delimiters}
      if delim in (delims-[' ']) then resetwords;
    end;
  end;
  listsbuilt:=true;
  screen.Cursor:=crdefault;
end;


{*************** LoadBtn **************}
procedure TForm1.LoadBtnClick(Sender: TObject);
var
  line:string;
  f:textfile;
begin
  if opendialog1.execute then
  begin
    memo1.clear;
    listbox1.clear;
    resetwords;
    ListsBuilt:=false;
    assignfile(f,opendialog1.filename);
    reset(f);
    while not eof(f) do
    begin
      readln(f,line);
      memo1.lines.add(line);
    end;
    closefile(f);
  end;
end;

{************** FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  p2List:=Tstringlist.Create;
  p2List.sorted:=true;
  p3List:=Tstringlist.Create;
  p3List.sorted:=true;
  p4List:=Tstringlist.Create;
  p4List.sorted:=true;
end;

procedure TForm1.ShowPhraseList(Sender: TObject);
begin
  If not ListsBuilt then CountPhrases(memo1.lines);
  if sender = Show2Btn then showsummary(p2list)
  else if sender = Show3Btn then showsummary(p3list)
  else if sender = Show4Btn then showsummary(p4list) ;
end;



{************* ShowSummary *************}
procedure TForm1.ShowSummary(list:TStrings);
var i,j:integer;
    templist:TStringList;
    tempstr:string;
    tempobj:TObject;
begin
  listbox1.clear;
  templist:=TStringlist.Create;
  //templist.Text:=list.Text;
  templist.assign(list);

  if sortbygrp.Itemindex=1 then
  begin  {sort templist by descending count}
    with templist do
    begin
      for i:= 0 to count-2 do
      for j:=i+1 to count-1 do
      begin
        if (integer(objects[i]) < integer(objects[j]))
          or (
               (
                 (integer(objects[i]) = integer(objects[j]))
                  and (ansiCompareText(strings[i],strings[j])>0)
               )
             )

        then
        begin
          tempstr:=strings[i];
          strings[i]:=strings[j];
          strings[j]:=tempstr;
          tempobj:=objects[i];
          objects[i]:=objects[j];
          objects[j]:=tempobj;
        end;
      end;
    end;
  end;

  with templist do
  for i:=0 to count-1 do
  if not checkbox1.checked
     or ((checkbox1.checked) and (integer(objects[i])>1))
     then listbox1.Items.Add(strings[i] + ' ('+inttostr(integer(objects[i]))+')');
  templist.Free;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin
  listsbuilt:=false;
end;

procedure TForm1.DelimsEdtChange(Sender: TObject);
begin
  delimschanged:=true;
end;

end.
