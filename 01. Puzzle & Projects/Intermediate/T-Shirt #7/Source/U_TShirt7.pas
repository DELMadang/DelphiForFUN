unit U_TShirt7;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    FindPrimesBtn: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    FindSumsBtn: TButton;
    StatusBar1: TStatusBar;
    Image1: TImage;
    procedure FindPrimesBtnClick(Sender: TObject);
    procedure FindSumsBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    primes:array[1..987-123] of integer;
    count:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*************** IsPrime ************}
function isprime(n:integer):boolean;
{Test an integer for "primeness"}
var i,stop:integer;
begin
  result:=false;
  {get rid of most of the cases right away}
  if (n mod 2 = 0) or (n mod 3=0) or (n mod 5 =0) then exit;
  result:=true;
  i:=7;
  stop:=trunc(sqrt(n+0.0)); {no need to check higher than this number}
  while result and (i<=stop) do
  begin
    if i*(n div i)=n then result:=false;
    inc(i);
  end;
end;

 function nodups(n:integer):boolean;
{return true if n has no duplicated digits}
var
  i:integer;
  ch:char;
  s:string;
  digits:array['0'..'9'] of boolean;
begin
  for ch:= '0' to '9' do digits[ch]:=false;
  s:=inttostr(n);
  result:=true; {in case we do not find any duplicates}
  for i:= 1 to length(s) do
  begin
    if digits[s[i]]=true then
    begin
      result:=false;
      break;
    end
    else digits[s[i]]:=true;
  end;
end;

function nozero(n:integer):boolean;
{return true if n has no zeros}
var
  i:integer;
  s:string;
begin
  s:=inttostr(n);
  result:=true; {in case we do not find any duplicates}
  for i:= 1 to length(s) do
  begin
    if s[i]='0' then
    begin
      result:=false;
      break;
    end;
  end;
end;

function nodups2(n1,n2:integer):boolean;
{return true if n1 has no  digits in common with n2}
var
  i:integer;
  ch:char;
  s:string;
  digits:array['0'..'9'] of boolean;
begin
  for ch:= '0' to '9' do digits[ch]:=false;
  s:=inttostr(n1);
  result:=true; {in case we do not find any duplicates}
  for i:= 1 to length(s) do digits[s[i]]:=true;
  s:=inttostr(n2);
  for i:=1 to length(s) do
  begin
    if digits[s[i]]=true then
    begin
      result:=false;
      break;
    end;
  end;
end;

procedure TForm1.FindPrimesBtnClick(Sender: TObject);
var i:integer;
begin
  listbox1.clear;
  {First let's list all possible 3 digit primes with no repeat digits}
  count:=0;
  for i := 123 to 987 do
  begin
    if isprime(i) and  nodups(i) and nozero(i) then
    begin
      listbox1.items.add(format('%3d - %3d',[listbox1.Items.count+1,i]));
      inc(count);
      primes[count]:=i;
    end;
  end;
end;

procedure TForm1.FindSumsBtnClick(Sender: TObject);
var i,j,k:integer;
    n1,n2,n3:integer;
    sum,minsum:integer;
begin
  {Now build all sets of three primes with no dups, sum them list the smallest}
  minsum:=10000;  {minimum will be samller than this for sure}
  for i:=1 to count-2 do
  begin
    n1:=PRIMES[I];  {get the first prime}
    for j:= i+1 to count-1 do
    begin
      n2:=primes[j]; {get the second prime}
      if nodups2(n1,n2) then {if uniqiue from n1 then...}
      for k:= j+1 to count do
      begin
        n3:=PRIMES[K]; {get the third prime}
        if nodups2(n1,n3) and nodups2(n2,n3) then {if unique from n1 and n2 then...}
        begin
          sum:=n1+n2+n3;   {add them up}
          if sum<minsum then {and see if the sum iks smallest yet}
          begin  {if it is, then save it and list it}
            minsum:=sum;
            listbox2.items.add(format('** %d+%d+%d=%d',[n1,n2,n3,sum]));
          end;
          {to see the other sets}
          {else listbox2.items.add(format('Test - %d+%d+%d=%d',[n1,n2,n3,sum])); }
        end;
      end;
    end;
  end;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  count:=0;  {initialize count for list of primes}
end;

end.
