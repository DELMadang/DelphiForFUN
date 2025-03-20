unit U_PierrotsPuzzle;
 {Copyright  © 2002, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Find four digit numbers which if treated as two
numbers  (1 digt and 3 digits or 2 digits and 2
digits), the product contains the same digits as
the original number.  e.g 15x93= 1395,

This puzzle was invented by H.E. Dudeney, a
recreational mathematician and published in  his
book "Amusements in Mathematics" around
1917 (reprinted by Dover Publications).

Pierrot is a well known French clown/mime
frequently seen in white face and wearing a
pointed hat.  Dudeney drew him with arms and
legs extended to form the X representing
multiplication.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, jpeg, ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    ListBox1: TListBox;
    SearchBtn: TButton;
    StatusBar1: TStatusBar;
    Image1: TImage;
    LZeroBox: TCheckBox;
    Label1: TLabel;
    procedure SearchBtnClick(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{******************* SameDigits ***************}
function samedigits(a,b:integer; LeadingZeros:boolean;  var S:string):boolean;
{Returns true if a and b contain the same digits, not necessarily in the same
 order.  If LeadingZeros is true and  a and b are not the same length, the
 shorter  number is extended on the left with zeros before setting result.
 If result is true, the digits found in variable parameter S}
var
  i,j,x:integer;
  countsa, countsb:array[0..10] of integer;
begin
  for i:=0 to 10 do begin  countsa[i]:=0; countsb[i]:=0; end;
  while a >0 do {count occurences of digits in a}
  begin
    x:=a mod 10;
    inc(countsa[x]);
    a:=a div 10;
    inc(countsa[10]);
  end;
  while b >0 do  {count occurences of digits in b}
  begin
    x:=b mod 10;
    inc(countsb[x]);
    b:=b div 10;
    inc(countsb[10]);
  end;
  result:=true;
  s:='';
  if leadingzeros then
  begin
    {add leading zeros to make lengths equal}
    if countsa[10]<countsb[10] then inc(countsa[0], countsb[10]-countsa[10])
    else if countsb[10]<countsa[10] then inc(countsb[0], countsa[10]-countsb[10]);
  end;

  for i:= 0 to 9 do
  begin
    if countsa[i]<>countsb[i] then
    begin  {counts differ, get out}
      result:=false;
      s:='';  {wipe out any partial return string}
      break;
    end
    else {count was equal, add this digit to the string}
    for j:=1 to countsa[i] do s:=s+','+char(i+ord('0'));
  end;
  if length(s)>0 then delete(s,1,1); {delete initial ','}
end;

{************** SearchBtnClick *************}
procedure TForm1.SearchBtnClick(Sender: TObject);
{Look for solutions}
var i,n1,n2,n:integer;
    str:string;  {the string version of the matching digits, if they match}
    list:Tstringlist;
begin
  list:=Tstringlist.create;
  for i:=1000 to 9999 do {check all 4 digit numbers}
  begin {split 1 and 3 digits}
    n1:=i div 1000;  {get 1st digit}
    n2:=i mod 1000;  {get last 3 digits}
    if n2>=100 then n:= n1*n2
    else n:=0;
    if not samedigits(i,n,LZeroBox.Checked, str) then
    begin {split 2 and 2 digits}
      n1:=i div 100;  {get the 1st 2 digits}
      n2:=i mod 100;  {get the last 2 dgits}
      if (n1 < n2) {only check arrangments with n1<n2, n1>n2 is redundant}
      then
      begin
        n:= n1*n2; {since we'll check the other arrangement anyway}
        samedigits(i,n, LZeroBox.checked, str);
      end;
    end;
    if str<>'' {we have a solution!}
    then list.add(format('%4s:   %d x %d = %.4d ',[str,n1,n2, n]));
  end;
  list.sort;
  listbox1.items.assign(list); {move solutions to listbox}

  i:=1;
  with listbox1, items do
  while I<=count-1 do  {Insert breaks between unique solutions}
  begin
    if (copy(items[i],1,7)<>copy(items[i-1],1,7)) then
    begin
      insert(i,' ');
      inc(i);
    end;
    inc(i);
  end;
  list.free;
end;

end.
