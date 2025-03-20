unit U_IntListtest;
 {Copyright  © 2005, 2009 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
     UIntList, StdCtrls, ExtCtrls, ComCtrls, shellAPI;

type
  Twordobj=class(Tobject)
     s:string;
  end;

  TForm1 = class(TForm)
    GenUnsortedBtn: TButton;
    GenSortedBtn: TButton;
    DuplicatesBox: TRadioGroup;
    Label1: TLabel;
    SaveBtn: TButton;
    LoadBtn: TButton;
    UpBtn: TButton;
    Button2: TButton;
    ListBox2: TListBox;
    UpDown1: TUpDown;
    Edit1: TEdit;
    FindBtn: TButton;
    DelBtn: TButton;
    AddBtn: TButton;
    Label2: TLabel;
    StaticText1: TStaticText;
    Memo1: TMemo;
    procedure GenUnsortedBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GenSortedBtnClick(Sender: TObject);
    procedure DuplicatesBoxClick(Sender: TObject);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure SortBtnClick(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    IntList1:TIntlist;
    procedure LoadListBox(List:TIntlist);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

var
  ascending:integer; {flag controlling direction for custom sort
                      +1 = ascending, -1 = descending}

  {Constants for converting numbers to words}
const                      
  nbrstr:array[1..10] of string=('one','two','three','four','five',
                                 'six', 'seven','eight','nine','ten');
  decadestr:array[2..9] of string=('twenty','thirty','forty','fifty','sixty',
                            'seventy','eighty','ninety');
  teenstr:array[11..19] of string=('eleven','twelve','thirteen','fourteen', 'fifteen',
                           'sixteen','seventeen','eighteen','nineteen');

{********** MakeNumberString *************}
function makenumberstring(const newn:integer):string;
{Convert integer 0<=N<10000 to string}
var m,n:integer;
    s:string;
begin
  n:=newn;
  if n=0 then s:='zero'
  else if n<10000 then
  begin
    m:=n div 1000;
    n:=n mod 1000;
    if m>0 then s:=s+nbrstr[m]+' thousand ';
    m:=n div 100;
    n:=n mod 100;
    if m>0 then s:=s+nbrstr[m]+' hundred ';
    if n>19 then
    begin
      m:=n div 10;
      n:=n mod 10;
      s:=s+decadestr[m];
      if n>0 then s:=s+'-'+nbrstr[n];
    end
    else
    begin
      if n>10 then {11 to 19}
      begin
        s:=s + teenstr[n];

      end
      else if n>0 then s:=s+ nbrstr[n]
    end;
  end
  else s:='Number too large';
  result:=s;
end;

{********** GenUnsortedBtnClick  ***********}
procedure TForm1.GenUnsortedBtnClick(Sender: TObject);
{Generate Unsorted Intlist}
var
  i,n:integer;
  w:TWordObj;
begin
  intlist1.clear;
  intlist1.sorted:=false;
  for i:= 0 to 99 do
  begin
    n:=random(10000);
    w:=twordobj.create;
    w.s:=makenumberstring(n);
    intlist1.addobject(n,w);
  end;
  loadlistbox(Intlist1);
end;

{************ LoadListBox ***********}
procedure TForm1.loadlistbox(List:TIntList);
var
  i:integer;
begin
  memo1.clear;
  for i:= 0 to list.count-1 do
  if list.objects[i]<>nil
  then memo1.lines.add(format('%4d  %s',[list[i],TWordObj(list.objects[i]).s]))
  else memo1.lines.add(format('%4d  ',[list[i]]));
  Label1.caption:='List size = '+inttostr(list.count);
end;

{************ Compare ***********}
Function Compare(List:TIntlist;index1,index2:integer):integer;
{Compare function for custom sort}
//TIntListSortCompare = function(List: TIntList; Index1, Index2: Integer): Integer;
begin
  if list[index1]>list[index2] then result:=ascending
  else if list[index1]<list[index2] then result:=-ascending
       else result:=0;
end;


{************* FormCreate ******}
procedure TForm1.FormCreate(Sender: TObject);
begin
   IntList1:=TIntList.create;
   randomize;
   DuplicatesBoxClick(Sender);
end;

{**************** GenSortedBtnClick ********}
procedure TForm1.GenSortedBtnClick(Sender: TObject);
{Generate a sorted Int list}
var
  n:integer;
  w:TWordobj;
begin
  memo1.clear;
  listbox2.clear;
  intlist1.clear;
  intlist1.sorted:=true;
    repeat
    try
     n:=random(10000);
     w:=TWordobj.create;
     w.s:=makenumberstring(n);
     intlist1.addobject(n,w);
     except
       on e:EStringListerror do
       begin
         listbox2.items.add('duplicate value '+inttostr(n)+' dropped');
         continue;
       end;
     end;
     until intlist1.count=100;
  LoadListbox(intlist1);
end;

{************* DuplicatesBoxClcik **********}
procedure TForm1.DuplicatesBoxClick(Sender: TObject);
begin
  with DuplicatesBox, Intlist1 do
  Case itemindex of
    0: duplicates:=DupIgnore;
    1: duplicates:=DupAccept;
    2: duplicates:=DupError;
  end;
end;

{************ SaveBtnClick **********}
procedure TForm1.SaveBtnClick(Sender: TObject);
begin
  intlist1.savetofile('intlist.stm');
 end;

{********** LoadBtnClick ************}
procedure TForm1.LoadBtnClick(Sender: TObject);
begin
  intlist1.loadfromfile('intlist.stm');
  loadlistbox(Intlist1);
end;


{*************** SortBtnClick ******************}
procedure TForm1.SortBtnClick(Sender: TObject);
begin
  intlist1.sorted:=false; {sorted must be off for customsort to work}
  If sender=UpBtn then ascending:=+1 else ascending:=-1;
  intlist1.customsort(Compare);
  loadlistbox(Intlist1);
  if ascending=1 then intlist1.sorted:=true; {OK to leave sorted set for ascending}
end;

{************ FindBtnClick ************}
procedure TForm1.FindBtnClick(Sender: TObject);
var n,index:integer;
begin
  n:=updown1.position;
  index:=intlist1.indexof(n);
  if index>=0 then listbox2.items.add(Inttostr(n)+' found at index '+inttostr(index))
  else listbox2.items.add(Inttostr(n)+' not found');
end;

{*********** DelBtnClick ***********}
procedure TForm1.DelBtnClick(Sender: TObject);
var n,index:integer;
begin
  n:=updown1.position;
  index:=intlist1.indexof(n);
  if index>=0 then
  begin
    intlist1.objects[index].free;
    intlist1.delete(index);
    listbox2.items.add(Inttostr(n)+' deleted from index '+inttostr(index))
  end
  else listbox2.items.add(Inttostr(n)+' not found');
end;

{*********** AddBtnClick ***********}
procedure TForm1.AddBtnClick(Sender: TObject);
var n,index:integer;
    w:Twordobj;
begin
  n:=updown1.position;
  try
     w:=Twordobj.create;
     w.s:=makenumberstring(n);
    index:=intlist1.addobject(n,w);  {adds at end if unsorted}
                                {adds at proper position if sorted ascending}
     listbox2.items.add(Inttostr(n)+' added at index '+inttostr(index));
   except
     on e:EStringListerror do
       listbox2.items.add('Duplicate value '+inttostr(n)+' dropped');
   end;
   loadlistbox(intlist1);
end;

{*********** StaticText1Click **********}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
