unit U_ComboTest;

{Updated to test UComboV2 routines for large N (up to 600), which now use
 a 64 bit Random Number Generator from mathsLib  for Random Unrank
 testing  11/19/2013 - GDD}

{Copyright  © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Generate combination and permutation subsets for select R of N objects}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, ShellAPI, UComboV2;

Type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    NCount: TUpDown;
    RCount: TUpDown;
    CountLbl: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Names: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    GenAllBtn: TButton;
    RandomBtn: TButton;
    RankBtn: TButton;
    Edit4: TEdit;
    Edit5: TEdit;
    UnRankBtn: TButton;
    GenRGrp: TRadioGroup;
    Label7: TLabel;
    Label8: TLabel;
    UseNames: TCheckBox;
    procedure ComputePBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure RandomBtnClick(Sender: TObject);
    procedure UnRankBtnClick(Sender: TObject);
    procedure RankBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NCountClick(Sender: TObject; Button: TUDBtnType);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Private declarations }
  public
    N,R:integer;
    CType:TCombotype;
    NameList:TstringList;
    Procedure Setparams;
    Function decodesubset:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************* FormCreate *********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  NameList:=TStringList.create;
  NCount.max:=maxentries;  {Value from UComboV2}
end;

procedure TForm1.NCountClick(Sender: TObject; Button: TUDBtnType);
begin

end;

{*************** SetParams **********}
procedure TForm1.Setparams;
{Initialization stuff, called before any action}
var
  i:integer;
begin
  n:=Ncount.position;
  i:=strtoint(edit1.text);
  if (n=0) or (i<>n) then
  begin
    N:=NCount.max;
    edit1.text:=inttostr(NCount.max);
    showmessage('Invalid N value changed to max value '+inttostr(N));
  end;
  R:=RCount.position;
  i:=strtoint(edit2.text);
  if (r<0) or (i<>r) then
  begin
    r:=rcount.max;
    edit2.text:=inttostr(R);
    showmessage('Invalid R value changed to max value '+inttostr(R));
  end;

  case genRGrp.itemindex of
      0:  {Permutations Lex up} Ctype:=Permutations;
      1:  {Permutations Lex down} Ctype:=PermutationsDown;
      2:  {PermutationsRepeat Lex up} CType:=Permutationsrepeat;
      3:  {PermutationsRepeat Lex down} CType:=PermutationsRepeatDown;
      4:  {Combinations Lex Up}  CType:=Combinations;
      5:  {Combinations Lex down}  CType:=CombinationsDown;
      6:  {CombinationsRepeat Lex up} CType:=CombinationsRepeat;
      7: {CombinationsRepeat Lex down} CType:=CombinationsRepeatDown;
      8:  {Combinations CoLex up}  CType:=CombinationsCoLex;
      9:  {Combinations CoLex down} CType:=CombinationsCoLexDown;
  end;
  if usenames.checked then
  begin
    NameList.Commatext:=Names.text;
    If (Namelist.count>0)   then
    begin
      if (nameList.COUNT<>N) then
      begin
        showmessage('Need '+inttostr(N)+' items in Names list, '
                  + inttostr(namelist.count)+ ' found, name option ignored');
        Namelist.clear;
        usenames.checked:=false;
      end
      else namelist.insert(0,'0');     {namelist now has N+1 items, 0th not used}
    end;
  end
  else namelist.clear;
  memo1.lines.Add('');
  Combos.setup(R,N,Ctype);
end;

{*************** DecodeSubset ************}
Function Tform1.decodesubset:string;
{convert combos selected fields to a string dor display}
var
  i:integer;
begin
  result:='{';
  with combos do
  if usenames.checked and (namelist.count=N+1)
  then for i:=1 to r do result:=result+namelist[selected[i]]+','
  else for i:=1 to r do result:=result+inttostr(selected[i])+',';
  result[length(result)]:='}';  //replace final comma with '}'
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  NCount.Position:=strtointdef(edit1.text,0);
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  RCount.Position:=strtointdef(edit2.text,0);
end;

{************ ComputePBtnClick ********}
procedure TForm1.ComputePBtnClick(Sender: TObject);
var
  s:string;
  i:integer;
  count:integer;
begin
  SetParams;
  Combos.setup(R,N,Ctype);
  memo1.clear;
  with combos do
  begin
    countlbl.caption:=format('Count: %.0n',[0.0+getcount]);
    count:=0;
    while getnext and (count<1000) do
    begin
      memo1.lines.add(decodesubset);
      inc(count);
    end;
  end;
end;

{****** RandomBtnClick **********}
procedure TForm1.RandomBtnClick(Sender: TObject);
begin
 setparams;
 combos.randomR(R,N,Ctype);
 memo1.lines.add(format('Rank %.0n: %s',[0.0+combos.randomrank,  decodesubset]));
end;


{****************** UnRankBtnClcik ************}
procedure TForm1.UnRankBtnClick(Sender: TObject);
{Given a rank, return its subset}
var
  s:string;
  i:integer;
  Rank:int64;
begin
  setparams;
   Rank:=strtoint64(edit4.text);
  If combos.unrankR({R,N,CType,} Rank {UpDown1.position}) then
  begin
    memo1.lines.add('Subset # '+edit4.text +' is '+decodesubset);
  end
  else memo1.lines.add(Edit4.text +' is not a valid subset number');
end;

{************** RankBtnClick ************}
procedure TForm1.RankBtnClick(Sender: TObject);
{Given a subset return its rank}
var
  list:Tstringlist;
  errcode,i, index:integer;
  errmsg:string;
begin
  setparams;
  combos.setup(R,N,CType);
  list:=TStringlist.create;
  list.commatext:=edit5.Text;

  if list.count=R then
  with combos do
  begin
    list.insert(0,'0');  {push entries up so index = position}
    errmsg:='';
    if usenames.checked and (namelist.count=N+1) then
    begin
      for i:= 1 to R   do
      if namelist.find(list[i],index) then selected[i]:=index
      else
      begin
        errmsg:=('Error: Rank set names must match Nameslist names');
        break;
      end;
    end
    else
    for i:=1 to R do
    begin
      val(list[i],index,errcode);
      if (errcode<>0) or (index<1) or (index>N) then
      begin
        errmsg:=('Error: Rank set entries must be numbers in the range 1 to '+inttostr(N));
        break;
      end
      else selected[i]:=index;
    end;
    If errmsg='' then
    begin
        memo1.lines.add('Rank of {'+edit5.text+'} is '+inttostr(combos.rankr));
    end
    else memo1.lines.add(errmsg);
  end;
end;



procedure TForm1.StaticText1Click(Sender: TObject);
{external link to DFF Website}
begin
    ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.

