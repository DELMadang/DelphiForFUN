unit U_AllWords;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Given a set of letters, list all possible permutations of  letters or,
 optionally, of words found in a dictionary}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellAPI, UcomboV2, UDict, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    ListBox1: TListBox;
    StopBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Shortest: TUpDown;
    Longest: TUpDown;
    Label4: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  public
    procedure checkforwords(usedic:boolean);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{**************** SortWord **********}
procedure sortword(var s:string);
{sort the letters in string "s" in ascending sequence}
var i,j:integer;
    ch:char;
begin
  for i:= 1 to length(s)-1 do
  for j:= i+1 to length(s) do
  if s[i]> s[j] then
  begin  {swap s[i] & s[j]}
    ch:=s[i]; s[i]:=s[j]; s[j]:=ch;
  end;
end;


{************** Button1Click **********}
procedure TForm1.Button1Click(Sender: TObject);
{List all permutations of subsets of letters}
var usedic:boolean;
begin
  usedic:=false;
  checkforwords(usedic);
end;

{************ Button2Click ************}
procedure TForm1.Button2Click(Sender: TObject);
{List all dictionary words found in a given set of letters}
var usedic:boolean;
begin
  usedic:=true;
  checkforwords(usedic);
end;


{************** CheckForWords *********}
procedure TForm1.checkforwords(usedic:boolean);
{Check for "words" for lengths 1 to N.  Optionally check against dictionary
 based on passed parameter "usedic"}
var i,j,n,cnt,count,index:integer;
    s,w:string;
    a,f,c:boolean; {abbreviation, foreign, & capitalized word flags}
    list:TStringlist;  {A list to temporarily hold words to check for duplicates}
begin
  {Initialization}
  stopbtn.visible:=true;
  tag:=0;
  screen.cursor:=crhourglass;
  list:=Tstringlist.create;  list.sorted:=true;
  listbox1.clear;
  s:=edit1.text;
  sortword(s);
  n:=length(s);

  {Loop for all possible word lengths from shortest to longest}
  for i:= shortest.position  to longest.position do
  begin
    count:=0;
    combos.setup(i,n,permutations); {Set up to choose i of n}
    label1.caption:='Checking for words of length '+inttostr(i);
    cnt:=combos.getcount; {total nbr of permutaions to check}
    list.clear;  {we can clear the temp word list for each word length}
    {loop for all permutations of i of n letters}
    while combos.getnext do
    begin
      inc(count);
      if  (i<=3) or ((count mod 100) =0)or (count=cnt) then  {only update every 100 times for efficiency}
      begin
        label2.caption:=format('Checking %d of %d for this length',[count,cnt]);
        application.processmessages;
        if tag<>0 then  break;  {user clicked the Stop button}
      end;
      w:='';
      {build the output "word" by converting permutation numbers to corresponding
       letters from the input word}
      for j:=1 to i do w:=w+s[combos.selected[j]];
      If (usedic and (pubdic.lookup(w, a,f,c))
                and (not a) {Exclude abbreviations and foreign words}
                and (not f)
          )
         or (not usedic)
      then
      If not (list.find(w,index)) then  {if is not a word previously found}
      begin
        listbox1.items.add(w);
        list.add(w);
      end;
    end; {of getnext perumtation loop}
    if tag<>0 then break;
  end; {of get next word length loop}
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
end;

{********** FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
   //s:=extractfilepath(application.exename)+'full.dic';
  //if fileexists(s) then pubdic.loaddicfromfile(s)
  {else} if dicform.opendialog1.execute
       then pubdic.loaddicfromfile(dicform.opendialog1.filename);
  edit1change(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

{************** StopBtnClick ************}
procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;  {set stop flag}
end;

{********** Edit1Change *************}
procedure TForm1.Edit1Change(Sender: TObject);
begin
  with edit1 do
  begin
    longest.max:=length(text);
    longest.position:=longest.max;
    shortest.max:=longest.max;
    shortest.position:=1;
  end;
end;

end.
