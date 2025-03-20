unit U_AliquotSums;
 {Copyright 2001, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Investigates aliquot factors and sums, "perfect", "amicable", and "sociable" numbers.

Requires TIntEdit integer edit component be installed, available at the website.
Alternatively, TintEdit instances can be replaced by TEdit and text fields
converted to int64 value fields.
}

{Features:}
{Uses TIntlist inter list class keep a list of aliquot sums displayed}
{Uses EM_SetMargin to set left and right margins to for the description TMemo}
{Uses TIntEdit to get numeric start values required}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NumEdit, U_IntList;

type
  TForm1 = class(TForm)
    LowIntEdt: TIntEdit;
    HighIntEdt: TIntEdit;
    Label1: TLabel;
    Label2: TLabel;
    MaxCycleLengthEdt: TIntEdit;
    Label3: TLabel;
    SocialBtn: TButton;
    Memo1: TMemo;
    StopBtn: TButton;
    Memo2: TMemo;
    ClickLbl: TLabel;
    MaxValEdt: TIntEdit;
    Label4: TLabel;
    procedure SocialBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure MaxValEdtChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    maxval:int64;  {stop cycle if member exceeds this value}
    function AliquotSum(n:int64):int64;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses U_Primes, math;

Const
  maxfactors=100; {Numbers cannot cantain more than this many factors}


{***************** TForm1.AliquotSum **************}
function TForm1.AliquotSum(n:int64):int64;
{calculate an aliquot sum for n}
var
  i:integer;
  p:array [1..Maxfactors] of integer;
  e:array [1..Maxfactors] of integer;
  nf:integer;
begin
  primes.getfactors(n);
  {get unique prime factors and powers}
  nf:=0;
  p[1]:=0;
  e[1]:=0;
  result:=0;
  if primes.nbrfactors>maxfactors
  then showmessage('Number '+inttostr(n)+ ' has more than '+inttostr(maxint)
                    +' factors , program change required')
  else
  begin
    for i:= 1 to primes.nbrfactors do
    begin
      if (nf>0) and (primes.factors[i]=p[nf])
      then inc(e[nf])
      else
      begin
        inc(nf);
        p[nf]:=primes.factors[i];
        e[nf]:=2;
      end;
    end;
    result:=1;
    try
      for i:= 1 to nf
      do if p[i]<>1 then result:=result*trunc(intpower(p[i],e[i])-1) div (p[i]-1);
    except
      result:=n;
    end;
    result:=result-n;
  end;
end;


{***************** TForm1.SocialBtnClick **************}
procedure TForm1.SocialBtnClick(Sender: TObject);
{find sociable chains starting in range and up to maxcyclelength
 numbers long}
var
  i,n:int64;
  j,k, index:integer;
  aliquot, displayed:TIntlist;
  s:string;
  used:boolean;
begin
  screen.cursor:=crHourGlass;
  memo1.clear;
  aliquot:=TIntList.create;
  displayed:=TIntList.create;
  displayed.sorted:=true;
  i:= -1;
  stopbtn.visible:=true;
  clickLbl.visible:=false;
  tag:=0;
  {for the range of numbers do}
  while (i< highintedt.value-lowintedt.value) and (tag=0) do
  begin
    inc(i);
    {give windows a chance to check mesages once in awhile}
    if i mod 1024=0 then application.processmessages;
    aliquot.clear;
    {put the starting number in the list}
    aliquot.add(i+lowintedt.value);
    {for a long as max cycle length do}
    for j:= 1 to MaxCycleLengthEdt.value do
    begin
      {sum got too big or too small - quit}
      if (aliquot[j-1]<=1) or (aliquot[j-1]>maxval) then break;
      n:=aliquotsum(Aliquot[j-1]); {get the sum}
      if n=aliquot[0] then {new one = first entry ==> cycle found}
      begin
        {put them into a string}
        s:=inttostr(aliquot[0]);
        used:=false;
        for k:= 1 to aliquot.count-1 do
        begin
          {check to see if this result has already been displayed}
          if displayed.find(aliquot[k],index) then
          begin
            used:=true; {if so, exit}
            break;
          end
          else     s:=s+', '+ inttostr(ALIQUOT[K]);
        end;
        if not used then
        begin
          memo1.lines.add(s); {display the answer}
          {and put the used numbers into an intlist so we don't show them again}
          for k:= 0 to aliquot.count-1 do displayed.add(aliquot[k]);
        end;
        application.processmessages;
        break;
      end
      else aliquot.add(n) {not a cycle, yet - just add it to the list}
    end;
  end;
  aliquot.free;
  screen.cursor:=crdefault;
  stopbtn.visible:=false;
  clickLbl.visible:=true;
end;

{***************** TForm1.StopBtnClick **************}
procedure TForm1.StopBtnClick(Sender: TObject);
{set the stop flag}
begin
  tag:=1;
end;

{***************** TForm1.Memo1Click **************}
procedure TForm1.Memo1Click(Sender: TObject);
{display the factors of a clicked number}

   function getclickedword:string;
   {Scan forawrd and backward to find extent of number}
   var
     start,stop:integer;
   begin
     with memo1 do
     if selstart>0 then
     begin
       start:=selstart;
       while (start>0) and (text[start] in ['0'..'9']) do dec(start);
       stop:=selstart;
       while (stop<length(text)) and (text[stop] in ['0'..'9']) do inc(stop);
       result:=copy(text,start+1,stop-start-1);
     end;
    end;

var
  s:string;
  i:integer;
  n,tot:int64;
begin
  n:=strtoint64def(getclickedword,0); {GET THE NUMBER}
  tot:=0;
  {try all possible factors, add to string if i divides n evenly}
  if n>0 then
  for i:= 1 to n div 2 do
  if n mod i = 0 then
  begin
    s:=s + inttostr(i)+', ';
    tot:=tot+i;
  end;
  showmessage('Aliquot divisors for '+inttostr(n) + ' are '
             +#13+s +#13+'Sum is '+inttostr(tot));
end;


{***************** TForm1.Formactivate **************}
procedure TForm1.FormActivate(Sender: TObject);
var
  templist:TStringList;
begin
  {experiment to add margin around a Tmemo}
  with memo2 do
  begin
    {save the text - must have been saved at design time with wordwrap=false}
    templist:=TStringlist.create;
    templist.addstrings(lines);
    lines.clear;
    wordwrap:=true;  {turn wordwrap on}
    Perform(EM_SetMargins,EC_LEFTMARGIN+EC_RIGHTMARGIN, Makelong(24,16));
    lines.addstrings(templist);
    templist.free;
  end;
  MaxValEdtChange(sender); {Set maxval}
end;

{************** TForm1.MaxValEdtChange **************}
procedure TForm1.MaxValEdtChange(Sender: TObject);
begin
  if maxvaledt.value>18 then maxvaledt.value:=18;
  maxval:=trunc(intpower(10,maxvalEdt.value));
end;

end.
