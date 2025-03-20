unit U_Permutes1;

{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Investigations in generating permutations of N objects}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    ListBox1: TListBox;
    Edit1: TEdit;
    NCount: TUpDown;
    SedgewickBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    DarbyBtn: TButton;
    Label3: TLabel;
    SawadaPermuteBtn: TButton;
    DisplayGrp: TRadioGroup;
    SepaBtn: TButton;
    Label4: TLabel;
    procedure SedgewickBtnClick(Sender: TObject);
    procedure DarbyBtnClick(Sender: TObject);
    procedure SawadaPermuteBtnClick(Sender: TObject);
    procedure SepaBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    n:integer; {nbr of numbers in each permutation}
    count:integer; {calulated number of permutations (N!)}
    permutecount:integer;
    start,stop,freq:int64; {values for timing calculations}
    x:array of byte; {dynamic array of outputs}
    Procedure AddListEntry; {Add x entry to list}
    procedure setup;  {all the setup stuff for any method}
    procedure showresult; {display final stats}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
Uses UMakeCaption;

{***************** Setup **************}
Procedure TForm1.setup;
{Initialization stuff}
var
  i:integer;
Begin
  listbox1.clear;
  N:=nCount.position; {size}
  count:=1;
  permutecount:=0;
  for i:=1 to N do count:=count*(i); {This is N!, the number of permutations}
  setlength(x,n); {set length of dynamic array}
  for i:=0 to n-1 do x[i]:=i+1; {initialize output permutations}
  addlistentry;  {add first entry}
  screen.cursor:=crHourglass;
  queryperformancefrequency(freq);
  queryperformancecounter(start);
end;

{******************* AddListEntry *********}
Procedure TForm1.addlistentry;
{count and conditionally add a permutation to the list}
  var
    i:integer;
    s,w:string;
  begin
    if (displaygrp.itemindex=0) and (listbox1.items.count<1000)
    then
    begin
      s:='';
      For i:= 0 to length(x)-1 do
      begin
       if x[i]<10 then w:=inttostr(x[i])
       else w:=','+inttostr(x[i])+','; {need to separate 2 digit numbers}
       s:=s+w;
      end;
      if s[length(s)]=',' then delete(s,length(s),1);
      listbox1.items.add(s);
    end;
    inc(permutecount);
  end;

{************** ShowResult *************}
procedure TForm1.ShowResult;
begin
  queryperformancecounter(stop);
  screen.cursor:=crDefault;
  label3.caption:='Permutation count: '+inttostr(permutecount)
                  +#13+inttostr(1000*(stop-start) div freq)+' milliseconds' ;
end;


procedure TForm1.SedgewickBtnClick(Sender: TObject);
{Algorithm from "Algorithms", Robert Sedgewick, Addison-Wesley, 1984}
{Recursive - short code, but not easy to understand}
 var now:integer;  { variable used by procedure "permute"}
   Procedure Permute(k:integer);
   var
     i:integer;
   Begin
     inc(now);
     x[k-1]:=now;
     If now=N then addlistentry;
     for i:= 1 to n do
       If x[i-1]=0 then permute(i);
     dec(now);
     x[k-1]:=0;
   end;

  var i:integer;
begin
  setup;
  {setup added 1st entry, but Sedgewick generates it, so we need to undo a few things}
  listbox1.clear;
  for i:= 0 to n-1 do x[i]:=0;
  permutecount:=0;

  now:=-1;  {parameter used by "permute" procedure}
  permute(1); {generate all permutations}
  showresult;
end;

procedure TForm1.DarbyBtnClick(Sender: TObject);
{Longer and slower, but works the way most humans would generate
 permutations in lexicographic order}

     Function CanInc(p:integer; var newval:integer):boolean;
     {Tests to see if we can increment the integer at p}
     {If there is an integer greater than x[p] that doesn't appear
      to the left, then we can increment x[p] to that
      integer.  Set result to true if newval is a usable value,
      false otherwise}
     var
       i:integer;
     Begin
       if x[p]>=n then result:=false
       else
       Begin
         result:=false;
         newval:=x[p];
         {try all values > x[p] until we find an unused one,
          or run out of numbers}
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
  i,j,incpos:integer;
  OK:Boolean;
  newval:integer;


begin  {DarbyBtnClick}
  setup;
  for i:= 2 to count do
  Begin
    {find the position to increment starting with rightmost}
    incpos:=n-1;
    ok:=false;

    while (incpos>=0) and (not OK) do
    {If we can increment this position, do it}
    if CanInc(incpos,newval) then Begin x[incpos]:=newval; ok:=true; end
    else dec(incpos);  {otherwise, back-up to previous position}

    {now reset the remainder to the smallest values possible}
    for j:= incpos+1 to n-1 do
    Begin
      x[j]:=0;
      if CanInc(j,newval) then x[j]:=newval
      else showmessage('System error');
    end;
    addlistentry;
  end;
  showresult;
end;


{********************* SawadaBtnClick ******************}
procedure TForm1.SawadaPermuteBtnClick(Sender: TObject);
{Derived from a program by Joe Sawada, 1997. }
{
{===================================================================}
{ Pascal program for distribution from the Combinatorial Object     }
{ Server. Generate permutations in lexicographic order. This is     }
{ the same version used in the book "Combinatorial Generation."     }
{ The program can be modified, translated to other languages, etc., }
{ so long as proper acknowledgement is given (author and source).   }
{ Programmer: Joe Sawada, 1997.                                     }
{ The latest version of this program may be found at the site       }
{ http://sue.uvic.ca/~cos/inf/perm/PermInfo.html                    }
{===================================================================}
{Same algorithm as Sepa Algorithm below - just not as well documented}
{But fairly fast and concise}


      procedure swap(i:integer; j:integer);
      {swap x[i] and x[j]}
      var temp : byte;
      begin temp := x[i];x[i] := x[j]; x[j] := temp;  end;

      {************** Nextpermute ***************}
      function NextPermute(var x:array of byte): Boolean;
      {X, permutation result array,  is a 0 based array,
       so index value of k refers to (k-1)th entry}
      var k,j,r,s : integer;
      begin
        k := n-2;
        while (k>=0) and (x[k] > x[k+1]) do dec(k);
        if k<0 then result:=false
        else
        begin
          j := n-1;
          while x[k] > x[j] do j:=j-1;
          swap(j,k);
          r:=n-1;
          s:=k+1;
          while r>s do
          begin
            swap(r,s);
            r:=r-1;
            s:=s+1;
          end;
          result:=true;
        end;
      end;


begin {SawadaBtnClick}
  setup;
  while nextpermute(x) do addlistentry;
  showresult;
end;

{******************** SEPABtnClick ***************}
procedure TForm1.SepaBtnClick(Sender: TObject);
  {
   SEPA: A Simple, Efficient Permutation Algorithm
   Jeffrey A. Johnson, Brigham Young University-Hawaii Campus
   http://www.cs.byuh.edu/~johnsonj/permute/soda_submit.html
  }
  {My new favorite - short, fast,  understandable  and requires no data
  structures or intialization, each output is generated as the
  next permutation after the permutation passed!}

  function nextpermute(var a:array of byte):boolean;
  var
    i,j,key,temp,rightmost:integer;
  begin
    {1. Find Key, the leftmost byte of rightmost in-sequence pair
        If none found, we are done}

    {  Characters to the right of key are the "tail"}
    {  Example 1432 -
       Step 1:  check pair 3,2 - not in sequence
               check pair 4,3 - not in sequence
               check pair 1,4 - in sequence ==> key is a[0]=1, tail is 432

    }
    rightmost:=high(a);
    i:=rightmost-1; {Start at right end -1}
    while (i>=0) and (a[i]>=a[i+1]) do dec(i); {Find in-sequence pair}
    if i>=0 then  {Found it, so there is another permutation}
    begin
      result:=true;
      key:=a[i];

      {2A. Find rightmost in tail that is > key}
      j:=rightmost;
      while (j>i) and (a[j]<a[i]) do dec(j);
      {2B. and swap them} a[i]:=a[j]; a[j]:=key;
      {Example - 1432  1=key 432=tail
       Step 2:  check 1 vs 2,  2 > 1 so swap them producing 2431}

      {3. Sort tail characters in ascending order}
      {   By definition, the tail is in descending order now,
          so we can do a swap sort by exchanging first with last,
          second with next-to-last, etc.}
      {Example - 2431  431=tail
        Step 3:
                 compare 4 vs 1 - 4 is greater so swap producing 2134
                 tail sort is done.

                final array = 2134
     }
      inc(i); j:=rightmost; {point i to tail start, j to tail end}
      while j>i do
      begin
        if a[i]>a[j] then
        begin {swap}
          temp:=a[i]; a[i]:=a[j]; a[j]:=temp;
        end;
        inc(i); dec(j);
      end;
    end
    else result:=false; {else please don't call me any more!}
  end;

begin {SepaBtnClick}
  setup;
  {replaces the passed permutation with the next, in lexicographic order}
  while nextpermute(x) do addlistentry;
  showresult;
end;

{*************** FormCreate ***************}
procedure TForm1.FormCreate(Sender: TObject);
begin
   makecaption('Permutes1',#169+' 2002, G. Darby, delphiforfun.org', self);
end;

end.


