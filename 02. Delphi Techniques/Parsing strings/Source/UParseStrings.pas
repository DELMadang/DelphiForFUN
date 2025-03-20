unit UParseStrings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Wordlist: TListBox;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure countwords;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


function getnextword(var s,w:string):boolean;
{Note that this a "destructive" getword.
  The first word of the input string s is returned in w and
  the word is deleted from the input string}

const
  delims:set of char = [' ','.',',','(',')',':',';','"'];
var
  i:integer;
begin
  w:='';
  if length(s)>0 then
  begin
    i:=1;
    while (i<length(s))  and (s[i] in delims) do inc(i);
    delete(s,1,i-1);
    i:=1;
    while (i<=length(s)) and (not (s[i] in delims)) do inc(i);
    w:=copy(s,1,i-1);
    delete(s,1,i);
  end;
  result := (length(w) >0);
end;


type
  TCount=class(TObject)
    count:integer;
  end;
procedure TForm1.countwords;
  var
  i, index:integer;
  s,w:string;
  c:TCount;

begin
  with memo1 do
  for i:= 0 to memo1.lines.count-1 do
  begin
    s:=lines[i];
    while getnextword(s,w) do
    begin
      w:=lowercase(w);
      Index:= wordlist.Items.Indexof(w);
      with wordlist.items do
      if index>=0
      then TCount(objects[index]).count:=TCount(objects[index]).count+1
      else
      begin
        c:=TCount.create;
        c.count:=1;
        addobject(w,c);
      end;
    end;
    application.processmessages;
  end;
  for i:= 0 to wordlist.items.count-1 do
  with wordlist.Items do
  begin
    strings[i]:= strings[i] + '   (' + inttostr(TCount(objects[i]).count)+')';
    objects[i].free;
  end
end;


procedure TForm1.Button1Click(Sender: TObject);

begin
  If opendialog1.execute then
  begin
    wordlist.clear;
    memo1.lines.loadfromfile(opendialog1.FileName);
    caption:='File: '+opendialog1.filename;
    countwords;
  end
end;

end.
