unit U_CountWords;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    CountLbl: TLabel;
    Memo1: TMemo;
    ListBox1: TListBox;
    CountBtn: TButton;
    SummarizeBtn: TButton;
    Button1: TButton;
    procedure CountBtnClick(Sender: TObject);
    procedure SummarizeBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  {the delimiters}
  delims: set of char=[' ', ',', '?', ';', '.', ':', '-','='];

function getword( var line:string):string;
{destructive getword, pass a copy of the original input since upon return the
 first word will have been removed and returned as the result of the function }
var
  i,start:integer;
begin
  result:='';
  if length(line)>0 then
  begin
    line:=line+' ';
    start:=1;
    while (line[start] in delims) do inc(start);
    i:=start+1;
    if i<=length(line) then
    while not (line[i] in delims) do inc(i);
    result:=copy(line,start,i-start);
    delete(line,1,i);
  end;
end;

procedure TForm1.CountBtnClick(Sender: TObject);
{count words and add them to listbox1}
var
  i, count :integer;
  line, w:string;
begin
  listbox1.clear;
  count:=0;
  for i:=0 to memo1.lines.count-1 do
  begin
    line:=memo1.lines[i];
    while line<>'' do
    begin
      w:=getword(line);
      if w<>'' then
      begin
        inc(count);
        listbox1.items.add(w);
      end;
    end;
  end;
  countlbl.caption:=inttostr(count)+' Words in '
                    +#13+opendialog1.filename;
end;

procedure TForm1.SummarizeBtnClick(Sender: TObject);
var
  i, index, count:integer;
  w:string;
  list:TStringlist;  {list to hold the words for sorting}
begin
  countbtnclick(sender);  {count and extract the words}
  list:=Tstringlist.create;
  list.sorted:=true;
  with listbox1 do
  for i:= 0 to items.count-1 do
  begin
    w:=lowercase(items[i]);
    if list.find(w,index)
    then list.objects[index]:= TObject(integer(list.objects[index]) +1)
    else   list.addobject(w,Tobject(1));
  end;
  listbox1.clear;
  for i:=0 to list.count-1 do
    listbox1.Items.Add(list[i] + ' : '+inttostr(integer(list.objects[i])));
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  line:string;
  f:textfile;
begin
  memo1.clear;
  listbox1.clear;
  if opendialog1.execute then
  begin
    assignfile(f,opendialog1.filename);
    reset(f);
    while not eof(f) do
    begin
      readln(f,line);
      memo1.lines.add(line);
   end;
 end;
 closefile(f);
end;

end.
