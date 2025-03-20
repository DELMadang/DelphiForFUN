unit U_Heaps_Permute;
{An algorithm to generate permutations of data items developed by
J.R. Heap in 1963.  It is quite efficient because it swaps only 2 elements
for each one generated.  The disadvantage may be that that there is no
apparent order in the generated permutations.  Search "Heap's
algorithm"on Wikipedia for more information.

The Wikipedia article has "pseudocode" for both recursive and non-
recursive implementations of the algorithm.  This demo has two Delphi
versions of each; inputs as an array of characters and as a strig of
characters.

The four versions (PermuteCharArray_R, PermuteString_R,
PermuteCharArray_NR, and PermuteStringArray_NR) all run about
the same speed generatig the 3.6 million permutations of 10 characters
in less than 200 milliseconds.   Displaying first 1,000 takes considerably
longer!
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, shellAPI {,dffutils};

type
  chararray=array of char;
  TOnPermute = procedure (s:string);
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    Label1: TLabel;
    Edit1: TEdit;
    TypeGrp: TRadioGroup;
    DisplayBox: TCheckBox;
    PermuteBtn: TButton;
    VerboseBox: TCheckBox;
    procedure PermuteBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure VerboseBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    pcount:integer;
    swapMsg:string;
    procedure PermuteCallBack(s:string);  overload;
    procedure PermuteCallBack(A:charArray); overload;
    procedure Permute_R(n:integer; var A:String);  overload;
    procedure Permute_R(n:integer; var A:CharArray); overload;
    procedure Permute_NR(n:integer; var A:charArray); overload;
    procedure Permute_NR(n:integer; var S:String); overload;
    procedure swap(var a,b:Char);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{************ FormCreate *************}
procedure TForm1.FormCreate(Sender: TObject);
 {The simplest recursive example? }
 function factorial(N:integer):integer;
 begin  If N>1 then result:=N*factorial(N-1)else result:=1; end;
 
begin
  //showmessage('(9!='+ inttostr(factorial(9)));
end;


{************ PermuteCallback **************}
procedure TForm1.PermuteCallBack(s:string);
{Gets called for every permutation returned }
begin
  if (displaybox.Checked) and (pcount<1000)
  then memo1.lines.add(swapmsg+s);
  inc(pcount);
end;

{************ PermuteArrayCallback **************}
procedure TForm1.PermuteCallBack(A:chararray);
{Gets called for every permutation returned }
var
  i:integer;
  s:string;
begin
  if (displaybox.Checked) and (pcount<1000) then
  begin
    for i:=0 to high(A) do if i=0 then s:=A[0] else s:=s+ ','+a[i];
    memo1.lines.add(swapmsg+s);
  end;
  inc(pcount);
end;

{************* PermuteBtClick *************}
procedure TForm1.PermuteBtnClick(Sender: TObject);
{Calls any of the 4 permute procedures for testing}
var
  i,n:integer;
  A:CharArray;
  S:string;
  startTime,stoptime:extended;
begin
  n:=length(edit1.text);
  If verbosebox.Checked then displaybox.Checked:=true;
  SwapMsg:='';
  s:=edit1.text;
  memo1.clear;
  pcount:=0;
  screen.cursor:=crHourGlass;
  starttime:=now;
  Case typegrp.ItemIndex of
    0:
    begin
      setlength(A,n);
      for i := 1 to length(s)do A[i-1]:=s[i];
      Permute_R(n,A);
    end;

    1:Permute_R(n,s);
    2:
    begin
      setlength(A,n);
      for i := 1 to length(s)do A[i-1]:=s[i];
      Permute_NR(n,A);
    end;
    3:Permute_NR(n,S);
  end;
  stoptime:=now;
  screen.cursor:=crDefault;
  with Memo1.lines do
  begin
    add(inttostr(pcount)+' permutations generated');
    add(format('Run time %.2f seconds',[(stoptime-startTime)*secsperday]));
  end;
end;

procedure TForm1.swap(var a,b:Char);
var temp:char;
begin
  if verboseBox.checked
  then SwapMsg:=format('Swapped %s and %s:    ',[a,b]);
  temp:=a;
  a:=b;
  b:=temp;
end;

(*   Pseudocode for recursuve version of Heap's Algorithm (from Wikipedia)
procedure generate(n : integer, A : array of any):
    if n = 1 then
          output(A)
    else
        for i := 0; i < n - 1; i += 1 do
            generate(n - 1, A)
            if n is even then
                swap(A[i], A[n-1])
            else
                swap(A[0], A[n-1])
            end if
        end for
        generate(n - 1, A)
    end if
*)

{****************PermuteCharArray_R *****************}
Procedure TForm1.Permute_R(n:integer; var A:CharArray);
{Overloaded recursive character array version of  Heap's permute}
var
  i:integer;
begin
  if n = 1 then
  begin
    PermuteCallback(A);
  end
  else
  begin
    for i := 0 to n-2 do
    begin
      Permute_R(n-1,A);
      if  n mod 2 =0 then swap(A[i], A[n-1])
      else swap(A[0], A[n-1])
    end;
    Permute_R(n - 1, A)
  end;
end;

{*************** PermuteString_R *******************}
procedure TForm1.Permute_R(n:integer; var A:String);
{Overloaded recursive string version of  Heap's permute}
{String characters are indexed from 1 rather than from 0}
var
  i,j:integer;
  s:string;
begin
  if n = 1 then PermuteCallBack(A)
  else
  begin
    for i := 0 to n-2 do
    begin
      Permute_R(n-1,A);
      if  (n) mod 2 =0 then swap(A[i+1], A[n]) {swaps indexed from 1}
      else swap(A[1], A[n])
    end;
    Permute_R(n - 1, A)
  end;
end;

(* Pseudociode for non-recursive version (from Wikipedia)
procedure generate(n : integer, A : array of any):
    c : array of int

    for i := 0; i < n; i += 1 do
        c[i] := 0
    end for

    output(A)

    i := 0;
    while i < n do
        if  c[i] < i then
            if i is even then
                swap(A[0], A[i])
            else
                swap(A[c[i]], A[i])
            end if
            output(A)
            c[i] += 1
            i := 0
        else
            c[i] := 0
            i += 1
        end if
    end while
*)

{************** PermuteCharArray **************}
procedure TForm1.Permute_NR(n:integer; var a:charArray);
{Overloaded nonrecursive character array version of  Heap's permute}
var
  i,j:integer;
  c : array of integer;
  s:string;
begin
  setlength(c,n);
  for i := 0 to n-1 do
  begin
    c[i]:=0;
    if i=0 then s:=A[0]
    else s:=s+','+A[i];
  end;
  Permutecallback(s);

  i := 0;
  while i < n do
  begin
    if  c[i] < i then
    begin
      if i mod 2 =0 { is even}
      then swap(A[0], A[i])
      else swap(A[c[i]], A[i]);
      PermuteCallback(A);
      inc (c[i]);
      i := 0;
    end
    else
    begin
      c[i] := 0;
      inc(i);
    end;
  end;  {while}
end;

{************* PermuteString_NR ***************}
procedure TForm1.Permute_NR(n:integer; var s:string);
{Overloaded nonrecursive string version of  Heap's permute}
var
  i:integer;
  c : array of integer;
begin
  setlength(c,n);
  for i := 0 to n-1 do c[i]:=0;
  Permutecallback(s);

  i := 0;
  while i < n do
  begin
    if  c[i] < i then
    begin
      if i mod 2 =0 {is even}
      then swap(s[1], s[i+1])  {Swaps indexed from 1 rather than 0}
      else swap(s[c[i]+1], s[i+1]);
      Permutecallback(s);
      inc (c[i]);
      i := 0;
    end
    else
    begin
      c[i] := 0;
      inc(i);
    end;
  end;  {while}
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



procedure TForm1.VerboseBoxClick(Sender: TObject);
begin
  //if length(edit1.text) > 4 then verbosebox.checked := false;
  If verbosebox.Checked then displaybox.Checked :=true;  
end;

end.

