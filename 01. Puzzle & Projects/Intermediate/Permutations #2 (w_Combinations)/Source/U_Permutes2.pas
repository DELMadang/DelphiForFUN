unit U_Permutes2;
  {Copyright  © 2002-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Generate combination and permutations for select R of N objects.
 Also uses revised Combo unit for testing}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Spin, ShellAPI;

type
  TForm1 = class(TForm)
    TestComboCombosBtn: TButton;
    DisplayGrp: TRadioGroup;
    NLbl: TLabel;
    ComputeCBtn: TButton;
    Label2: TLabel;
    Label3: TLabel;
    ComputePBtn: TButton;
    CountLbl: TLabel;
    TestComboPermutesBtn: TButton;
    TranslateStrings: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    RCount: TSpinEdit;
    NCount: TSpinEdit;
    StaticText1: TStaticText;
    procedure ComputeCBtnClick(Sender: TObject);
    procedure ComputePBtnClick(Sender: TObject);
    procedure TestComboPermutesBtnClick(Sender: TObject);
    procedure TestComboCombosBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NCountChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    n,r:integer;
    count:integer;
    actualCount:integer;
    freq,start,stop:int64;
    x:array of integer; {dynamic array of outputs}
    translatelist:TStringlist;
    Procedure AddListEntry; {Add x entry to list}
    Procedure Setup; {Operations common to both permutations and combinations}
    procedure showresults;
  end;

var Form1: TForm1;

implementation

{$R *.DFM}

Uses combo;

{*************** Setup *************}
Procedure TForm1.Setup;
{Common routine to setup permutations or combinations}
var i:integer;
Begin
  memo1.clear;
  translatelist.commatext:=translatestrings.text;
  if translatelist.count>0 then
  begin
    if translatelist.count<>ncount.value then
    begin
      showmessage('Translate list must be blank or contain '
                  + inttostr(ncount.value)+' entries.'
                  +#13+'Your list has '+inttostr(translatelist.count)+' entries.'
                  +#13+'List will be ignored');
      translatelist.clear;
    end;
  end;
  if rcount.value>ncount.value then rcount.value:=ncount.value;
  n:=nCount.value;
  r:=rCount.value;
  count:=1;
  actualcount:=0;
  {Calculate permutation count as N!/(N-R)!}
  for i:=1 to r do count:=count*(n-(i-1)); {This is N!/(N-R)!}
  setlength(x,r); {set length of dynamic array}
  for i:=0 to r-1 do x[i]:=i+1; {initialize output permutations}
  addlistentry; {add inital X to list}

  screen.cursor:=crHourglass;
  queryperformancefrequency(freq);
  queryperformancecounter(start);
end;

{******************* AddListEntry ************}
Procedure TForm1.addlistentry;
{Common routine to add entries to listbox}
  var
    i:integer;
    s:string;
  begin
    if (displaygrp.itemindex=0) and (memo1.lines.count<1000) then
    begin
      s:='';
      For i:= 0 to length(x)-1 do
         if translatelist.count=0 then s:=s+','+inttostr(x[i])
         else s:=s+','+translatelist[x[i]-1];
      delete(s,1,1);
      memo1.lines.add(s);
    end;
    inc(actualCount);
  end;

{****************** ShowResults ***********}
procedure TForm1.showresults;
{Common routine to display final count & time}
begin
  queryperformancecounter(stop);
  countlbl.caption:='Count: '+inttostr(actualCount)
                 +#13+'Time: '+inttostr(1000*(stop-start) div freq)+' ms';
 screen.cursor:=crdefault;                
end;

{**************** ComputeCBthClick ****************}
procedure TForm1.ComputeCBtnClick(Sender: TObject);
{generate combinations}
var
  i,j:integer;
  incpos:integer;
begin
  Setup;
  for i:=2 to r do count:=count div i; {Now divide by R! to get combo count}
  for i:= 2 to count do
  Begin
    {find the position to increment starting with rightmost}
    incpos:=r-1;
    {Count down until we find one that is not at max}
    while x[incpos]>=n-r+incpos+1 do dec(incpos);
    {Increment that one}
    inc(x[incpos]);
    {And set rest from there to end as previous nbr + 1}
    for j:=incpos+1 to r-1 do x[j]:=x[j-1]+1;
    addlistentry;
  end;
  showresults;
end;

{******************* ComputePBtnClick ***********}
procedure TForm1.ComputePBtnClick(Sender: TObject);
{generate permutations}

     Function CanInc(p:integer; var newval:integer):boolean;
     var
       i:integer;
     Begin
       if x[p]>=n then result:=false
       else
       Begin
         result:=false;
         newval:=x[p];
         while (result=false) and (newval<n) do
         Begin
           inc(newval);
           result:=true;
           for i:= 0 to p-1 do
           if x[i]=newval then Begin result:=false;  break; end;
         end;
       end;
     end;

var
  i,j, newval:integer;
  incpos:integer;
  ok:boolean;
begin
  Setup;
  for i:= 2 to count do
  Begin
    {find the position to increment starting with rightmost}
    incpos:=r-1;
    ok:=false;
    while (incpos>=0) and (not OK) do
    if CanInc(incpos,newval) then Begin x[incpos]:=newval; ok:=true; end
    else dec(incpos);
    {now reset the remainder to the smallest values possible}
    for j:= incpos+1 to r-1 do
    Begin
      x[j]:=0;
      if CanInc(j,newval) then x[j]:=newval
      else showmessage('System error');
    end;
    addlistentry;
  end;
  showresults;
end;

{*************** TestComboPermutesBtnClick ********}
procedure TForm1.TestComboPermutesBtnClick(Sender: TObject);
var i:integer;
begin
  setup;
  memo1.clear;
  actualcount:=0;
  combos.setup(r,n, permutations);
  while combos.getnextpermute do
  begin
    for i:=0 to r-1 do  x[i]:=combos.selected[i+1];
    addlistentry;
  end;
  showresults;
  If combos.getcount<>actualcount
  then showmessage('Count error: '+inttostr(combos.getcount));
end;

{************ TestComboCombosBtnClick *********}
procedure TForm1.TestComboCombosBtnClick(Sender: TObject);
var i:integer;
begin
  setup;
  memo1.clear;
  actualcount:=0;
  combos.setup(r,n,combinations);
  while combos.getnextcombo do
  begin
    for i:=0 to r-1 do  x[i]:=combos.selected[i+1];
    addlistentry;
  end;
  showresults;
  If combos.getcount<>actualcount
  then showmessage('Count error: '+inttostr(combos.getcount));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  translateList:=TStringlist.create;
  ncountchange(sender);
end;

procedure TForm1.NCountChange(Sender: TObject);
begin
  rcount.maxvalue:=ncount.value;  {can't select more than we have}
  NLbl.caption:=inttostr(ncount.value);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

