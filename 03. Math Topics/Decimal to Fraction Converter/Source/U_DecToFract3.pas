unit U_DecToFract3;
 {Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Convert decimals to fractions}


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Grids, StdCtrls, ComCtrls, Menus, dffutils, Spin, ShellAPI;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label2: TLabel;
    SolveBtn: TButton;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    Label3: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    RadioGroup2: TRadioGroup;
    SpinEdit2: TSpinEdit;
    StaticText2: TStaticText;
    procedure SolveBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    maxdenom: integer;
    multipleOf:boolean;
    showdecimal:boolean;
    maxdecimals:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses math, mathslib;


procedure swap(var a,b:int64);
var  t:int64;
begin
  t:=a; a:=b; b:=t;
end;

{************** Edit1KayPress ***************}
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   case Key of
     '0'..'9', #8, ' ','/': ;
     '.',','   : if (pos(DecimalSeparator,Edit1.Text)=0)
                  then  Key:=DecimalSeparator
                  else  Key:=#0;
     else        Key:=#0;
   end;   // case
end;


{*************** ConvertStringToDecimal ***************}
function convertStringToDecimal(s:string; var n:extended):Boolean;
{convert a string that may be decimal of fraction form to a floating point number}

var errflag:boolean;

  procedure error(msg:string; index:integer);
  begin
    if index>0 then showmessage(msg+' at position '+inttostr(index))
    else showmessage(msg);
    errflag:=true;
  end;

var
  i,x:integer;
  part:integer;
  decpart:extended;
  nbr:array[1..4] of int64;
  decimaldigits:integer;
begin
  for i:=1 to 4 do nbr[i]:=0;
  decimaldigits:=0;
  part:=1;
  s:=trim(s);
  errflag:=false;
  repeat
    x:=pos(thousandseparator,s);
    if x>0 then delete(s,x,1);
  until x=0;
  repeat
    x:=pos('  ',s);
    if x>0 then delete(s,x,1);
  until x=0;
  if (pos('/',s)>0) and (pos(decimalseparator,s)>0)
  then error('Numbers cannot contain decimal and ''/''',0);

  for i:= 1 to length(s) do
  begin
    if  s[i] = decimalseparator
    then  if (part=1) then part:=2 else error('misplaced ''.''',i)
    else
    case s[i] of
      ' ': if ((part=1) or (part=2)) then part:=3
           else error('Misplaced space ',i);
      '/': begin
             if part=1 then  {not integer part, but numerator}
             begin
               nbr[3]:=nbr[1];
               nbr[1]:=0;
               part:=3;
             end;
             if (part=3) then part:=4
             else error('Misplaced ''/''',i);
           end;
      '0'..'9':
            begin
              if part=2 then
              begin
                if decimaldigits<17 then
                begin
                  inc(decimaldigits); {for decimalpart, leading zeros are important}
                  nbr[part]:=nbr[part]*10 +strtoint(s[i]);
                end;
              end
              else nbr[part]:=nbr[part]*10 +strtoint(s[i]);
            end;
    end; {case}
    if errflag then break;
  end;
    if ((nbr[3]>0) and (nbr[4]=0))
      or ((nbr[4]>0) and (nbr[3]=0)) then error('Invalid fraction',0);
    result:=not errflag;
    if result then
    begin
      if nbr[3]=0 then nbr[4]:=1; {to avoid divide by zero}
      if nbr[2]>0 then decpart:=nbr[2]/power(10,decimaldigits)
      else decpart:=0;
      n:=nbr[1]+ decpart + nbr[3]/nbr[4];
    end;
end;

{*************** ConvertfloatFractionString *************}
function convertfloattofractionstring( N:extended; maxdenom:integer;multipleof:boolean):string;
{Convert floating point number, Nto a mixed  fraction display  string.

 If not constrained, N could have very large denominator (up to 19 or 20 digits
 for extended type),  "Maxdenom" specifies the largest denominator to be
 considered  If "Multipleof" is false, the best representation of N using
 denominators  in  the range of 2  to maxdenom is returned.  If "multipleof" is
 true, only  mixed fractions with maxdenom as the denominator are returned.
 Returned fraction strings are always in lowest terms, e.g. 4/16 will be
 returned as 1/4
 }
var
  decpart, offset:extended;
  intpart, denom:integer;
  valtable:array of extended;
  i:integer;
  newdenominator, newnumerator,g:integer;
  s:string;
  minerror:extended;
  fract,e:extended;
  num,m:integer;
begin
  decpart:=frac(N);
  intpart:=trunc(N);
  denom:=trunc(decpart*1e8);
  m:=trunc(1e8);
  //maxdecimals:=8;

  if multipleof then  {express fractional part as nearest multiple of 1/Maxdenom}
  begin
    offset:=1/maxdenom/2;
    setlength(valtable,maxdenom+1);
    for i:=0 to maxdenom-1 do valtable[i]:=i/maxdenom+offset;
    i:=0;
    while valtable[i]<=decpart do inc(i);
    g:=gcd2(i,maxdenom);
    if g>1 then
    begin
      newnumerator:=i div g;
      newdenominator:=maxdenom div g;
    end
    else
    begin
      newnumerator:=i;
      newdenominator:=maxdenom;
    end;
    if (intpart=0) then
    begin
       if (i=0) then s:='0'
       else s:=format('%d/%d',[newnumerator,newdenominator]);
    end
    else {intpart>0}
    begin
      if (i=0) then s:=inttostr(intpart)
      else s:=format('%d %d/%d',[intpart,newnumerator,newdenominator]);
    end;
  end
  else {express fractional part as best estimate a/b with b<=maxdenom}
  begin
    g:=gcd2(denom,m);
    newnumerator:=denom div g;
    newdenominator:= m div g;
    if (newdenominator>=maxdenom)  then
    begin
      {find closest approximation}
      minerror:=1;
      fract:=decpart;
      for i:= 2 to maxdenom do
      begin
        num := round(fract*i);
        if num=0 then num:=1;
        e:=fract-num/i;
        if  (abs(e)< abs(minerror)) then
        begin
          minerror:=e;
          newnumerator:=num;
          newdenominator:=i;
        end;
      end;
    end;
    If intpart<>0
      then if newnumerator>0
           then s:=format('%d  %d/%d',[intpart,newnumerator,newdenominator])
           else s:=inttostr(intpart)
      else if newnumerator>0
           then s:=format('%d/%d',[newnumerator,newdenominator])
           else s:='0';
  end;
  result:=s;
end;

{************ DigitCount *************}
function digitcount(n:int64):integer;
{count nbr of digits in an integer}
begin
  result:=0;
  while n>0 do
  begin
    n:=n div 10;
    inc(result);
  end;
end;


{************** SolveBtnClick **************}
procedure TForm1.SolveBtnClick(Sender: TObject);
{find the closest fraction to a given decimal where the denominator of the fraction
 does exceed another given integer value. }
var
  OK: boolean;
  s:string;
  n:extended;
  d1,d2:integer;
  begin
    {separate the integer and fractional parts of the input decimal number}
    {count numbers,N, to the right of the decimal point and set 10^N as denominator
    and fractional part converted to integer as numerator}

    s:=trim(edit1.text);
    Ok:=convertstringtodecimal(s, N);

    If OK then
    begin
      d1:=digitcount(trunc(n));
      if d1+maxdecimals>18 then d2:=18-d1 else d2:=maxdecimals;
      if showdecimal then s:=format('%*.*f',[d1+d2+1,d2,n])
      else s:=convertfloatTofractionString(N,maxdenom,multipleOf);
      label2.caption:=s;
    end;
end;

{************* ListBox1Click ***********}
procedure TForm1.ListBox1Click(Sender: TObject);
{set up a new sample input fields and convert it}
begin
  with listbox1 do edit1.text:=items[itemindex];
  solvebtnclick(sender);
end;

{************** FormActivate ************}
procedure TForm1.FormActivate(Sender: TObject);
{initialize listbox with sample inpout fields, etc.}
begin
   setmemomargins(memo1,10,10,10,10);
   reformatMemo(memo1);
   edit1.text:=format('%10.6f',[1/7]);

   listbox1.clear;
   with listbox1.items do
   begin
     add(format('%f',[5/4]));
     add('0'+decimalseparator+'125');
     add('3'+decimalseparator+'063829787');
     add('0'+decimalseparator+'02');
     add(decimalseparator+'1538461538');
     add('0'+decimalseparator+'123456789');
     add('0'+decimalseparator+ '023255813953488372');
     add('1/4');
     add('2  3/32');
     add('27/64');
     add('1  5/8');
     add('43 3/16');
     add('2/13');
     add('37/16');
   end;
   radiogroup2click(sender);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{************ RadioGroup2Click **********}
procedure TForm1.RadioGroup2Click(Sender: TObject);
{User clicked a display option - setup and redisplay the conversion result}
begin
  with radiogroup2 do
  begin
    showdecimal:=false;
    case itemindex of
      0: begin
           maxdecimals:=spinedit2.value;
           showdecimal:=true;
         end;
      1: begin
           maxdenom:=spinedit1.value;
           multipleOf:=false;
         end;
      2: begin
           maxdenom:=16;
           multipleOf:=true;
         end;
      3: begin
           maxdenom:=32;
           multipleOf:=true;
         end;
      4: begin
           maxdenom:=64;
           multipleOf:=true;
         end;
    end; {case}
    solvebtnclick(sender);
  end;
end;

{************* Edit1KeyUp *************}
procedure TForm1.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
{Treat data entry "Enter" key as signal to process the field}
begin
  if key=vk_return then
  begin
    solvebtnclick(sender);
    key:=0;
  end;
end;

end.
