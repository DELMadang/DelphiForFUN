unit U_SquaresCubes2;
{Keywords: dynamic arrays, break }
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;
const maxsums=1000;
type
  TForm1 = class(TForm)
    Memo1: TMemo;
    SquaresBtn: TButton;
    CubesBtn: TButton;
    procedure SquaresBtnClick(Sender: TObject);
    procedure CubesBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


type
  Tsumrec=record
    f1,f2:integer; {integrs whose squares add to sum}
    sum:integer; {the sum f1^2+f2^2}
  end;

procedure TForm1.SquaresBtnClick(Sender: TObject);
{Here's the plan:
 For increasing values of n, generate sums of i^2+n^2
    for all values of i < n.  For each value, check
    sums already generated for a match - done when found}


var
  i,j,n,n2,index,test:integer;
  sums:array of Tsumrec; {array to hold all prior sums}
  nbrsums:integer;
  found:boolean;{A Boolean stopper}
begin
  setlength(sums,100); {start with 100 entries - add more later if necessary}
  nbrsums:=0;
  found:=false;
  n:=1;
  while not found do
  Begin
    inc(n);
    n2:=n*n;
    {generate sums for all values of i < n}
    for i:= 1 to n-1 do
    Begin
      test:=i*i+n2;
      for j:=1 to nbrsums do
      if sums[j].sum=test then
      Begin
        {found match!  exit loop}
        found:=true;
        index:=j;
        break;
      end;
      {save new info in a new record}
      inc(nbrsums);
      {increase size of array by 100 if we run out of space}
      if nbrsums >sizeof(sums) then setlength(sums,nbrsums+100);
      with sums[nbrsums] do
      Begin
        f1:=n;
        f2:=i;
        sum:=test;
      end;
      if found then break;
    end;
    if found or (nbrsums>maxsums) then break;
  end;
  if found then
  begin
    Showmessage(inttostr(sums[index].sum)+' is '
                + inttostr(sums[index].f2) + ' squared +'
                + inttostr(sums[index].f1) + ' squared, and also '
                + inttostr(sums[nbrsums].f1) + ' squared +'
                + inttostr(sums[nbrsums].f2) + ' squared! ');
  end;
  setlength(sums,0);
end;

procedure TForm1.CubesBtnClick(Sender: TObject);
{Here's the plan:
 For increasing values of n, generate sums of i^3+n^3
    for all values of i < n.  For each value, check
    sums already generated for a match - done when found}


var
  i,j,n,n2,index,test:integer;
  sums:array of Tsumrec;
  nbrsums:integer;
  found:boolean;
begin
  setlength(sums,100);
  nbrsums:=0;
  found:=false;
  n:=1;
  while not found do
  Begin
    inc(n);
    n2:=n*n*n;
    for i:= 1 to n-1 do
    Begin
      test:=i*i*i+n2;
      for j:=1 to nbrsums do
      if sums[j].sum=test then
      Begin
        found:=true;
        index:=j;
        break;
      end;
      inc(nbrsums);
      {increase size of array by 100 if we run out of space}
      if nbrsums >sizeof(sums) then setlength(sums,nbrsums+100);
      with sums[nbrsums]do
      {add the new record}
      Begin
        f1:=n;
        f2:=i;
        sum:=test;
      end;
       if found then break;
    end;
    if found or (nbrsums>maxsums) then break;
  end;
  if found then
  begin
    Showmessage(inttostr(sums[index].sum)+' is '
                + inttostr(sums[index].f1) + ' cubed +'
                + inttostr(sums[index].f2) + ' cubed, and '
                + inttostr(sums[nbrsums].f1) + ' cubed +'
                + inttostr(sums[nbrsums].f2) + ' cubed! ');
  end
  else Showmessage(inttostr(maxsums) +' sums were tested and no solution found');
  setlength(sums,0);
end;
end.
