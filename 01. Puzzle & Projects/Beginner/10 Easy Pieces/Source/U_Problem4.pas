unit U_Problem4;
{
  Problem 4

A palindromic number reads the same both ways. The largest palindrome made from
the product of two 2-digit numbers is 9009 = 91 × 99.

Find the largest palindrome made from the product of two 3-digit numbers.
}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

function isPalindrome(n:integer):boolean;
var
  s:string;
  i:integer;
begin
  s:=inttostr(n);
  result:=true;
  for i:= 1 to length(s) div 2 do
  begin
    if not (s[i]=s[length(s)+1-i]) then
    begin
      result:=false;
      break;
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j:integer;
  largest,vi,vj:integer;
begin
  largest:=0;
  for i:=999 downto 100 do
  for j:= i downto 100 do
  begin
    if ispalindrome(i*j) then
    if i*j> largest then
    begin
      largest:=i*j;
      vi:=i;
      vj:=j;
    end;
  end;
  showmessage(inttostr(vi)+' X '+inttostr(vj)+' = '+inttostr(largest));
end;

end.
