unit U_PrimeFactors1;
{Copyright © 2002, 2006  Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,  Menus, ComCtrls, ShellAPI, mathslib;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    ListBox1: TListBox;
    Label2: TLabel;
    Memo1: TMemo;
    InputEdt1: TEdit;
    GroupBox1: TGroupBox;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    StaticText1: TStaticText;
    procedure Button1Click(Sender: TObject);
    procedure InputEdtKeyPress(Sender: TObject; var Key: Char);
    procedure InputEdtClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


{************ Button1Click **********}
procedure TForm1.Button1Click(Sender: TObject);
{Display prime factors for a given number}
  var
    nbr:int64;
    i: Integer;
    s:string;
  begin

  screen.Cursor := CrHourglass; {set cursor to show busy while we're working}
  ListBox1.Clear; {make sure the factor list is empty}
  ListBox1.Refresh; { Show blanked out list}
  nbr := strtoint64(InputEdt1.text); {get the number to factor}
  with Primes do
  Begin
    Getfactors(nbr);
    If nbrfactors>0 then
    Begin
      for i:= 1 to nbrfactors do
      Begin
        s:=format('%.0n',[0.0+factors[i]]);
        Listbox1.Items.Add(s); {add it to the list}
      end;
      If ListBox1.Items.Count = 1 Then ListBox1.Items[0] := 'Prime: ' + Listbox1.Items[0];
    end
    else ShowMessage('Only valid integers less than 1 billion are supported');
    screen.Cursor := crDefault;
  end;
  label2.caption:='Prime factors';
End;

{****** InputEdtKeyPress *********}
procedure TForm1.InputEdtKeyPress(Sender: TObject; var Key: Char);
begin
  If key=#13 then
  Begin
    Button1click(sender);
    key:=#00;
  end
  else
  if not (key in ['0'..'9', #08]) then
  begin
    key:=#00;
    beep;
  end;
end;

procedure TForm1.InputEdtClick(Sender: TObject);
begin
  Inputedt1.setfocus;
  Inputedt1.SelectAll;
end;

{************** Button2Click *********}
procedure TForm1.Button2Click(Sender: TObject);
{Find smallest positive integer whose prime factors sum to 100}
{We list the top 10 here}
var
  i,n:integer;
  sum,count:integer;
  s:string;
begin
  listbox1.clear;
  listbox1.Items.add('10 smallest integers whose factors sum to 100');
  n:=99;
  count:=0;
  with primes do
  repeat  {for 10 answers}
    repeat {increment N, factor it, check sum of factors}
      sum:=0;
      inc(n);
      getfactors(n);
      for i:=1 to primes.nbrfactors do inc(sum,factors[i]);
    until (sum=100) or (n>10000);
    if sum=100 then
    begin
      inc(count);
      s:=inttostr(factors[1]);
      for i:=2 to nbrfactors do s:=s+'+'+inttostr(factors[i]);
      s:=s+'=100';
      listbox1.items.add('For ' + inttostr(N)+': '+s);
    end;
  until count=10;
  label2.caption:='Integers whose factors sum to 100';
end;

{************* Button3Click **********}
procedure TForm1.Button3Click(Sender: TObject);
{Find smallest set of consective primes which sum to 106620}
var
  m,n:int64;
  sum:integer;
  i,j,k:integer;
  s:string;
  consec:array[1..50] of integer;
  conseccount:integer;
  done:boolean;
begin
  listbox1.clear;
  n:=106620; {start at the top}
  done:=false;
  with primes do
  begin
    repeat
      m:=getprevprime(n); {get next smaller prime}
      sum:=m;
      k:=m;
      conseccount:=0;
      repeat  {now get next smaller primes until sum>=106620}
        j:=getprevprime(k);
        sum:=sum+j;
        inc(conseccount);
        consec[conseccount]:=j;
        k:=j;
      until sum>=106620;
      if sum=106620 then  {solution found}
      begin
        s:=inttostr(consec[conseccount]);
        for i:=conseccount-1 downto 1 do s:=s+'+'+inttostr(consec[i]);
        s:=s+ ' = 106620';
        listbox1.items.add('Count: '+inttostr(conseccount));
        listbox1.items.add(s);
        done:=true;
        application.processmessages;
      end;
      n:=m; {start at previous prime for next search}
    until done;
  end;
  label2.caption:='Smallest # of consecutive primes summing to 106,620';
end;

{************ Button4Click ***********}
procedure TForm1.Button4Click(Sender: TObject);
{Find 10-digit prime numbers with most 0's, 1's ,2's ...... 9's}
begin
  listbox1.Clear;
  with listbox1.Items do
  begin
    add('A version of this problem may be included in the  ');
    add(    'programming challenge, Project Euler, at ');
    add(    'www.mathschallenge.net.  We will post the solution');
    add(    'here some months after it appears there');
  end;
end;

{*********** Button5Click **********}
procedure TForm1.Button5Click(Sender: TObject);
{Display prime canonical factors for a given number}
  var
    nbr:int64;
    i: Integer;
  begin
    screen.Cursor := CrHourglass; {set cursor to show busy while we're working}
    ListBox1.Clear; {make sure the factor list is empty}
    ListBox1.Refresh; { Show blanked out list}
    nbr := strtoint64(InputEdt1.text); {get the number to factor}
    if nbr>1 then
    with Primes do
    Begin
      Getcanonicalfactors(nbr);
      If nbrcanonicalfactors>0 then
      Begin
        for i:= 1 to nbrcanonicalfactors do
        with canonicalfactors[i] do
        begin
          Listbox1.Items.Add(format('%.0n^%d',[0.0+x,y])); {add it to the list}
        end;
        If ListBox1.Items.Count = 1 Then ListBox1.Items[0] := 'Prime: ' + Listbox1.Items[0];
      end
      else ShowMessage('Only valid integers less than 1 billion are supported');
      screen.Cursor := crDefault;
    end;
    label2.caption:='Prime factors (Canonincal form)';
  end;

{*********** Button6Click **********8}
procedure TForm1.Button6Click(Sender: TObject);
{get all divisors}
  var
    nbr:int64;
    i: Integer;
  begin
    Cursor := CrHourglass; {set cursor to show busy while we're working}
    ListBox1.Clear; {make sure the factor list is empty}
    nbr := strtoint64(InputEdt1.text); {get the number to factor}
    with Primes do
    Begin
      Getdivisors(nbr);
      If nbrcanonicalfactors>0 then
      Begin
        for i:= 1 to nbrdivisors do
        Begin
          Listbox1.Items.Add(format('%d',[divisors[i]])); {add it to the list}
        end;
      end
      else ShowMessage('Only valid integers less than 1 billion are supported');
      Cursor := crDefault;
      label2.caption:='All '+ inttostr(nbrdivisors) +' divisors';
    end;
  end;
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.




