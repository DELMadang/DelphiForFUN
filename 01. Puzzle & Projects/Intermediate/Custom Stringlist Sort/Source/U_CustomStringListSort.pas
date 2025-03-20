unit U_CustomStringListSort;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Memo1: TMemo;
    Button1: TButton;
    Memo2: TMemo;
    Memo3: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    procedure StaticText1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
 end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

 //var    {Variables temporarily moved outside of FixKey for debugging}
 //  i,j:integer;

  {*************** FixKey ************}
  procedure fixkey(key:string; var fix1:string; var fix2:integer; var fix3:string);
  {{Parse string "key" into alpha, numeric, and alpa parts}
   var
     i,j:integer;
   begin
     i:=1;
     while (i<=length(key)) and (not (key[i] in ['0'..'9'])) do inc(i);
     if i<=length(key) then
     begin {digits found}
       fix1:=uppercase(copy(key,1,i-1));
       j:=i;
       while (j<=length(key)) and (key[j] in ['0'..'9']) do inc(j);
       fix2:=strtoint(copy(key,i, j-i));
       fix3:=uppercase(copy(key,j,length(key)-j+1));
     end
     else
     begin {what to do if there is no number in the name?}
       fix1:=uppercase(key);
       fix2:=0;
       fix3:='';
     end;
   end;

{*************** ListSort ****************}
function Listsort(List:TStringList; index1,index2:integer):integer;
{Sort the "list: stringlist in customized sort order}
var
  i,n1,n2:integer;
  s1A,s2A, S1B, S2B:string;
begin
  with list do
  begin
    result:=0;
    fixkey(list[index1], S1a, N1, S1B); {split first key into 3 parts}
    fixkey(list[index2], S2a, N2, S2B); {split 2nd key into 3 parts}
    if s1a<s2a then result:=-1  {1st part of 1st key is low}
    else if s1a>s2a then result:=+1 {1st part of 1st key is high}
    else  {1st parts are equal}
    begin {compare numeric parts}
      if n1<n2 then result:=-1
      else if n1>n2 then result:=+1
      else
      begin {numeric parts also equal, compare 3rd parts}
        if S1b<s2b then result:=-1
        else if s1b>s2b then result:=+1;
       end;
    end;
  end;
end;


{************ SortBtnClick **********8}
procedure TForm1.Button1Click(Sender: TObject) ;
Var
  i:integer;
  List:TStringList;
begin
  List:=TStringlist.create;
  list.text:=Memo2.lines.text; {Move memo data into stringlist}
  list.customsort(Listsort);   {Sort the stringlist}
  Memo3.lines.Text:=list.text; {Move sorted data back to the other memo}
  list.Free;
end;


{************ FormCreate **********8}
procedure TForm1.FormCreate(Sender: TObject);
var list:TStringList;
begin
  list:=TStringList.Create;
  list.Text:=memo2.Lines.Text;
  list.Sort; {resort "properly"sorted input list back to dictionary order
              so we can test the custom sort}
  memo2.Lines.Text:=list.text;
  list.free;
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
