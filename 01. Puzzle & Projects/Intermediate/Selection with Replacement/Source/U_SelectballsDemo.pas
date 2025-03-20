unit U_SelectballsDemo;
   {Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Combo, SHellAPI;

type

  TForm1 = class(TForm)

    TotalEdit: TSpinEdit;
    SelectEdit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    OrderBox: TCheckBox;
    CountLbl: TLabel;
    RandomBtn: TButton;
    NamesEdt: TEdit;
    Label3: TLabel;
    ClearBtn: TButton;
    Memo1: TMemo;
    Button3: TButton;
    ReplaceBox: TCheckBox;
    SumBox: TCheckBox;
    SumEdit: TSpinEdit;
    StaticText1: TStaticText;
    StopBtn: TButton;
    procedure RandomBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ShowAllBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure SelectEditChange(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure NamesEdtExit(Sender: TObject);
    public
      n:integer; {number of balls}      r:integer; {number to select}
      values:array of integer;
      namelist:TStringlist;
      randomlist:TStringlist;
      LastWasShowAll:boolean;
      procedure BuildNameList;
      function  SetType:TComboType;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



{*************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  namelist:=Tstringlist.create;
  randomlist:=TStringlist.create;
  n:=totaledit.value;
  r:=selectedit.value;
  buildnamelist;
  randomize;
  stopbtn.top:=randombtn.top;
  stopbtn.left:=randombtn.left;
end;


{***********  BuildNameList **********}
Procedure TForm1.buildnamelist;
{Fill namelist with the ball labels (names or numbers) entered by the user
 in nameedt.text}
var i,j, errcode:integer;
    messagegiven:boolean;
begin
  namelist.commatext:=namesedt.text;
  if namelist.count>n then
  begin
    for j:=namelist.count-1 downto n
    do namelist.delete(namelist.count-1);
    namesedt.text:=namelist.commatext;
    showmessage('Names list truncated to '+inttostr(n)+' strings');
  end
  else
  if namelist.count<n then
  begin
    for j:=namelist.count+1 to n
    do namelist.add(inttostr(j));
    namesedt.text:=namelist.commatext;
    showmessage('Names list expanded to '+inttostr(n)+' strings');
  end;
  setlength(values,namelist.count+1);
  if sumbox.checked then  {report only outcome that match a predetermined sum}
  begin
    messagegiven:=false;
    for i:=0 to namelist.count-1 do
    begin
      val(namelist[i],values[i+1],errcode);
      if errcode<>0 then
      begin
        if (not messagegiven) then showmessage('Ball # '+inttostr(i+1) +'('+namelist[i]+') not numeric, 0 assumed for all invalid');
        messagegiven:=true;
        values[i+1]:=0;
        namelist[i]:=namelist[i]+'(0)'; {Change the invalid name to reflect the zero assumed value}
      end;
    end;
  end;
end;

{***************** SetType ************}
function TForm1.SetType:TComboType;
{Set combo retirval type based on selected checkbox options}
  begin
    if replacebox.checked then
        if orderbox.checked then result:=permutationsWithRep
        else result:=combinationsWithRep
    else if orderbox.checked then result:=permutations
        else result:=combinations;
  end;

(*
{*************** RandomBtnClick *************}
procedure TForm1.RandomBtnClick(Sender: TObject);
{The easiest way to get a random outcome meeting the conditions set by
 checkboxes is to build a list of all valid outcomes and then select one
 of those randomly.  So that's what we do here  by calling ShowAllBtnClick method.
 That method checks and if the sender is not a button, which this is not, it puts
 the outcomes in RandomList}
var
  s:string;
  i:integer;
  stype:TComboType;
begin
  BuildNameList;
  stype:=settype;
  combos.setup(selectedit.value,totaledit.value, stype);
  If lastwasShowAll then  {clear list after show all call}
  begin
    listbox1.clear;
    lastwasShowAll:=false;;
  end;
  showallbtnclick(self);  {call showall jut to build the list from which to randomly select}
  if randomlist.count>0
  then listbox1.items.add(randomlist[random(randomlist.count)])
  else listbox1.items.add('No outcomes meet conditions')
end;
*)


{*************** RandomBtnClick *************}
procedure TForm1.RandomBtnClick(Sender: TObject);
{The easiest way to get a random outcome meeting the conditions set by
 checkboxes is to build a list of all valid outcomes and then select one
 of those randomly.  But with a large number of balls, this may not be practical
 so, for the non-sum versions, we'll just generate them.  FGor sum versions we'll
 limit the samples gathered to 100,000 }
var
  s:string;
  i,j:integer;
  stype:TComboType;
  a:string;
begin
  n:=totaledit.value;
  r:=selectedit.value;
  If lastwasShowAll then  {clear list after showall call}
  begin
    listbox1.clear;
    lastwasShowAll:=false;;
  end;

  if  sumbox.checked then
  begin
    showallbtnclick(self);  {call showall just to build the list from which to randomly select}
    if randomlist.count>0 then listbox1.items.add(randomlist[random(randomlist.count)])
    else listbox1.items.add('No outcomes meet conditions')
  end
  else
  begin
    BuildNameList;
    s:='';
    randomlist.clear;
    if replacebox.checked then
    begin  {replacement}
      for i:=1 to r do
      begin
        j:=random(n); {pick a random ball}
        {add ball ordinal + ball name to list}
        randomlist.add(format('%2d'+namelist[j],[j]));
      end;
    end
    else {no replacement}
    while randomlist.count<r do
    begin
      i:=random(n); {pick a random ball}
      a:=format('%2d'+namelist[i],[i]);
      {add it to the list if is has not been previuosly selected}
      if  randomlist.indexof(a) < 0 then randomlist.add(a);
    end;

    {distribution of random  selections whether or not order is significant will be
     identical, but if order of draw is not signioficant, we'll display them in order}
    if not orderbox.checked then randomlist.sort;
    for i:=0 to randomlist.count-1 do   {delete the ball order number}
    begin
      a:=randomlist[i];
      delete(a,1,2);
      randomlist[i]:=a;
    end;
    s:=randomlist.commatext;
    listbox1.items.add(s);
  end;

end;

{************* ClearBtnClick ***********}
procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  listbox1.clear;
end;


{**************** ShowAllBtnClick ***********}
procedure TForm1.ShowAllBtnClick(Sender: TObject);
var
  stype:TComboType;
  i:integer;
  s:string;
  errcode:integer;
  messagegiven:boolean;
  v:integer;
begin
  n:=totaledit.value;
  r:=selectedit.value;
  tag:=0;
  StopBtn.visible:=true;
  stopbtn.update;
  if sender is TButton then
  begin
    listbox1.clear; {Clear list for showall button click, but not for random call}
    LastWasShowAll:=true;
  end;
  screen.cursor:=crhourglass;
  randomlist.clear;
  buildnamelist;
  setlength(values,namelist.count+1);
  if sumbox.checked then  {report only outcome that match a predetermined sum}
  begin
    messagegiven:=false;
    for i:=0 to namelist.count-1 do
    begin
      val(namelist[i],values[i+1],errcode);
      if errcode<>0 then
      begin
        if (not messagegiven) then showmessage('Ball # '+inttostr(i+1) +'('+namelist[i]+') not numeric, 0 assumed for all invalid');
        messagegiven:=true;
        values[i+1]:=0;
        namelist[i]:=namelist[i]+'(0)'; {Change the invalid name to reflect the zero assumed value}
      end;
    end;
  end;
  stype:=SetType;

  Combos.setup(r,n, stype);
  with combos do
  while (getnext) and (tag=0) do
  begin
    If sumbox.checked then
    begin
       v:=0;
      for i:=1 to r do v:=v+values[selected[i]];
    end;

    if (v=sumedit.value) or (not sumbox.checked) then
    begin
      s:=namelist[selected[1]-1];
      for i:=2 to r  do s:=s+', '+namelist[selected[i]-1];
      if sender is tbutton then
      begin
        if listbox1.items.count>1000 then
        begin
          showmessage(format('There are %8d outcomes, only the first 1000 displayed',[combos.getcount]));
          break;
        end;
        listbox1.items.add(s);
       end
      {else we were called just to build selection list for random button click}
       else
       begin
         if randomlist.count<1000000 then randomlist.add(s) {only select from 1st 100,000 outvcomes}
         else break;
       end;
    end;
  end;
  if sender is tButton then
  begin
    CountLbl.caption:=format('%10d outcomes',[combos.getcount]);
    if (listbox1.items.count<=1000) and (not sumbox.checked) and (listbox1.items.count<>combos.GetCount)
    then showmessage('Count error, should be '+inttostr(combos.getcount));
    if listbox1.items.count=0 then listbox1.items.add('No outcomes meet conditions')
  end;
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.SelectEditChange(Sender: TObject);
{Max number of balls to select cannot exceed the max number of balls in the bag}
begin
  Selectedit.maxvalue:=totaledit.value;
  if selectedit.value>selectedit.maxvalue then selectedit.value:=selectedit.maxvalue;
end;


procedure TForm1.StopBtnClick(Sender: TObject);
begin
  tag:=1;
end;

procedure TForm1.NamesEdtExit(Sender: TObject);
begin
  namelist.commatext:=namesedt.text;
  TotalEdit.value:=namelist.count;
  n:=namelist.count;
  buildnamelist;

end;

end.
