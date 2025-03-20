Unit U_MeasuringCups;
{Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TCup=class(TObject)
    visited, checked:boolean;
    path:TStringlist;
    constructor create;
    destructor destroy;  override;
  end;

  TState1=array of TCup;

  TForm1 = class(TForm)
    Label1: TLabel;
    Cup1Edt: TEdit;
    Cup1UD: TUpDown;
    Label2: TLabel;
    Cup2Edt: TEdit;
    Cup2UD: TUpDown;
    GoBtn: TButton;
    ListBox1: TListBox;
    Target: TLabel;
    Memo1: TMemo;
    TargetBox: TListBox;
    BFSearchBtn: TCheckBox;
    AboutBtn: TButton;
    procedure GoBtnClick(Sender: TObject);
    procedure TargetBoxClick(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure AboutBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    State: array of TState1;
    possibles:array of TstringList;
    C1,C2:integer;
    function makemove(i,j:integer):boolean;
    function FindShortest(var i,j:integer):boolean;
  end;

var
  Form1: TForm1;

implementation

uses math, U_About;

{$R *.DFM}
 {************ TCup.create **********}
 constructor TCup.create;
 begin
   inherited;
   path:=TStringlist.create;
 end;

{************** TCup.Destroy ***********}
 destructor TCup.destroy;
 begin
   path.free;
   inherited;
 end;

{********************* MakeMove *****************}
function TForm1.makemove(i,j:integer):boolean;

   procedure checkmove(a,b:integer;msg:string);
   begin
     if not state[a,b].visited then
     begin
       state[a,b].visited:=true;
       state[a,b].path.assign(state[i,j].path);
       state[a,b].path.add('Step '+inttostr(state[a,b].path.count+1)+': '+msg+
                           '  ('+inttostr(a)+','+inttostr(b)+')');
       result:=true;
     end;
   end;

begin
  result:=false;
  if not state[i,j].visited then exit;
  {empty j}  checkmove(i,0,'Empty B');
  {empty i}  checkmove(0,j,'Empty A');
  {fill i}   checkmove(c1,j,'Fill A from faucet');
  {fill j}   checkmove(i,c2,'Fill B from faucet');

  {pour j into i}
  if (i+j<=c1) then checkmove(i+j,0,'Pour B into A');
  if (j>=i) and (c1<=j+i) then checkmove(c1,J+i-c1,'Fill A from B');

  {pour i into j}
  if (i+j<=c2) then checkmove(0,i+j,'Pour A into B');
  if (i>=j) and (c2<=j+i) then checkmove(i+j-c2,c2,'Fill B from A');
end;

{******************* FindShortest ******************}
function TForm1.FindShortest(var i,j:integer):boolean;
{find the shortest unchecked path and return coordinates }
{return false if no more unchecked}
 var
   ii,jj:integer;
   imin,jmin:integer;
   minpath:integer;

begin
  result:=false;
  ii:=-1;
  minpath:=999;
  while (ii<c1) do
  begin
    inc(ii);
    jj:=-1;
    while (jj<C2) do
    begin
      inc(jj);
      with state[ii,jj] do
      If (visited) and (not checked) and (state[ii,jj].path.count<=minpath) then
      begin
        minpath:=state[ii,jj].path.count;
        imin:=ii;
        jmin:=jj;
      end;
    end;
  end;
  if minpath<999 then
  begin
    i:=imin;
    j:=jmin;
    result:=true;
  end;
end;

{********************* GoBtnClick ******************}
procedure TForm1.GoBtnClick(Sender: TObject);
var
  i,j:integer;
  newvisit:boolean;
begin
  {free up old entries}
  if length(state)>0 then
  for i:= low(state) to high(state) do
  for j:=low(state[i]) to high(state[i]) do state[i,j].free;
  if length(possibles)>0 then
  for i:= low(possibles) to high(possibles) do possibles[i].free;

  {set up new case}
  C1:=Cup1UD.position;
  C2:=Cup2UD.position;
  setlength(State,C1+1);
  for i:=0 to C1 do setlength(State[i],C2+1);
  setlength(possibles,C1+C2+1);
  for i:= 0 to C1+C2 do possibles[i]:=TStringlist.create;
  for i:=0 to C1 do for j:=0 to c2 do state[i,j]:=TCup.create;
  state[0,0].visited:=true;
 If not bfsearchbtn.checked then
  repeat
    newvisit:=false;
    for i:=0 to C1 do for j:=0 to c2 do
    if makemove(i,j) then
    begin
      newvisit:=true;
      break;
    end;
  until not newvisit
  else {breadth first}
  while Findshortest(i,j) do
  begin
    makemove(i,j);
    state[i,j].checked:=true;
  end;

  for i:= 0 to c1 do
  if (state[i,0].visited) then
  begin
    if (possibles[i].count=0) then possibles[i].assign(state[i,0].path);
  end;
  for j:= 0 to c2 do
  if (state[0,j].visited) then
  begin
    if (possibles[j].count=0) or (possibles[j].count>State[0,j].path.count)
    then possibles[j].assign(state[0,j].path);
  end;
  for i:= 0 to c1 do for j:= 0 to c2 do
  if (i+j>max(c1,c2)) and (state[i,j].visited) then
  begin
    if (possibles[i+j].count=0) or (possibles[i+j].count>State[i,j].path.count)
    then possibles[i+j].assign(state[i,j].path);
  end;
  TargetBox.clear;
  for i:=1 to c1+c2 do if possibles[i].count>0
  then TargetBox.items.addobject(inttostr(i),possibles[i]);
  TargetBox.itemindex:=0;
  TargetBoxclick(sender);
end;

(****************** TargetBoxClick ****************)
procedure TForm1.TargetBoxClick(Sender: TObject);
begin
  with listbox1 do
  begin
    clear;
    items.assign(tstringlist(TargetBox.items.objects[TargetBox.itemindex]));
    items.insert(0,''); {header info}
    items.insert(0,'To Measure '+ TargetBox.items[TargetBox.itemindex]+' ...');
  end;
end;

(********************** ListBox1DrawItem **********************)
procedure TForm1.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  h,w,n,base,offset:integer;
  s:string;
  i,j:integer;
begin
  with control as TListbox, canvas do
  begin
    {decide where to place stuff}
    s:=items[index];
    h:=textheight('Iy');
    offset:=(itemheight-h) div 2;
    base:=itemheight-offset;
    textout(rect.left+5,rect.top+offset,s); {write the text}
    if index>1 then {we're into the moves}
    begin
      w:=200 {textwidth(s)+10};
      {extract the liquid volumes (i and j) from the text}
      n:=pos('(',s);
      delete(s,1,n);
      n:=pos(',',s);
      i:=strtoint(copy(s,1,n-1));
      delete(s,1,n);
      n:=pos(')',s);
      j:=strtoint(copy(s,1,n-1));
      with rect do
      begin
        {draw the first cup}
        polyline([point(left+w-1,top+base-c1-1),point(left+w,top+base-c1),point(left+w,top+base),
                  point(left+w+10,top+base),point(left+w+10,top+base-c1),
                  point(left+w+12,top+base-c1-1)]);
        moveto(left+w,top+base-i); lineto(left+w+10,top+base-i);
        brush.color:=clblue;
        if i>1 then floodfill(left+w+1,top+base-1,clblack,fsborder);
        w:=w+20; {move over}
        {draw the second cup}
        polyline([point(left+w-1,top+base-c2-1),point(left+w,top+base-c2),point(left+w,top+base),
                  point(left+w+10,top+base),point(left+w+10,top+base-c2),
                  point(left+w+12,top+base-c2-1)]);
        moveto(left+w,top+base-j); lineto(left+w+10,top+base-j);
        brush.color:=clblue;
        if j>1 then floodfill(left+w+1,top+base-1,clblack,fsborder);
      end;
    end;
  end;
end;

procedure TForm1.AboutBtnClick(Sender: TObject);
begin
   Aboutbox.showmodal;
end;

end.
