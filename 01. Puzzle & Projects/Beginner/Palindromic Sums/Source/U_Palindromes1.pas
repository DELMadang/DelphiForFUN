unit U_Palindromes1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SolveBtn: TButton;
    ListBox1: TListBox;
    procedure SolveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Function ispalindromic(n:int64):boolean;
{reuturns true if N is a palindrome}
var
  i:integer;
  s:string;
Begin
  result:=true;
  if n>0 then
  Begin
    s:=inttostr(n);{make it a string}
    i:=length(s);
    {fill out the beginning with as many 0's as are at the end}
    while s[i]='0' do s:='0'+s;
    i:=1;
    {check digits forward from beginning against backwards from end}
    while result and (i<= length(s) div 2 ) do
    Begin
      if s[i]<>s[length(s)-i+1] then result:=false;
      inc(i);
    End;
  end
  else result:=false;
End;

Function reverse(n:int64):int64;
{make an integer that has the digits of input reversed}
var
  s,s2:string;
  i:integer;
Begin
  s:=inttostr(n);
  s2:='';
  for i:= length(s) downto 1 do s2:=s2+s[i];
  result:=strtoint64(s2);
end;

Function sumpalindrome(n:int64; var lpsum:int64; var lsteps:integer):boolean;
{Find the palindromic sum of n and reverse(n)}
{makes rescursive call to itself until palindrome is found}
var n2:int64;
const
  limit=high(int64) div 2;
Begin
  lsteps:=lsteps+1;
  n2:=reverse(n);
  lpsum:=n+n2;
  if (n<=Limit) and (n2<=limit)
  then if  not ispalindromic(lpsum)
       then result:=sumpalindrome(n+n2,lpsum,lsteps)
       else result:=true
  else result:=false;
end;

procedure TForm1.SolveBtnClick(Sender: TObject);
{User clicked Solvebtn}
var
  n,steps:integer;
  psum:int64;
begin
  listbox1.clear;
  for n:= 10 to 99 do
  Begin
    psum:=0;
    steps:=0;
    if sumpalindrome(n,psum,steps)
    then listbox1.Items.Add(inttostr(n) + ' PSum='+inttostr(psum)
                             +' Steps='+inttostr(steps))
    else listbox1.Items.Add(inttostr(n)
              + ' ****** No palindrome found (at least ' +inttostr(steps) +' steps')
  end;
end;

end.
