unit U_DecToFract2;
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
    Label5: TLabel;
    Label1: TLabel;
    ListBox1: TListBox;
    Label3: TLabel;
    Memo1: TMemo;
    StaticText1: TStaticText;
    RadioGroup1: TRadioGroup;
    procedure SolveBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses UBigIntsV2;


procedure swap(var a,b:int64);
var  t:int64;
begin
  t:=a; a:=b; b:=t;
end;

Function gcd(a,b:int64):int64;
   {return gcd of a and b}
   {used to reduce fraction to lowest terms}
   {Euclids method}
   var
     g,z:integer;
   Begin
     g:=b;
     If b<>0 then
     while g<>0 do
     Begin
       z:=a mod g;
       a:=g;
       g:=z;
     end;
     result:=a;
   end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   case Key of
     '0'..'9', #8 : ;
     '.',','   : if (pos(DecimalSeparator,Edit1.Text)=0)
                  then  Key:=DecimalSeparator
                  else  Key:=#0;
     else        Key:=#0;
   end;   // case

end;

procedure TForm1.SolveBtnClick(Sender: TObject);
{find the closest fraction to a given decimal where the denominator of the fraction
 does exceed another given integer value. }
var
  i,maxdenom:integer;
  denom,g, newnumerator, newdenom:TInteger;
  intpart:int64;
  decpart:TInteger;
  decfound, OK: boolean;
  e,minerror,fract:extended;
  s:string;
  num,d1,d2:int64;
  c1,c2:integer;
begin
  maxdenom:=spinedit1.value;
  {separate the integer and fractional parts of the input decimal number}
  {count numbers,N, to the right of the decimal point and set 10^N as denominator
  and fractional part converted to integer as numerator}
  intpart:=0;
  decpart:=TInteger.create;
  decpart.assign(0);
  denom:=TInteger.create;
  denom.assign(1);
  OK:=true;
  decfound:=false;
  s:=trim(edit1.text);
  for i:= 1 to length(s) do
  begin
    if s[i] in ['0'..'9'] then
    begin
      if not decfound then intpart:=intpart*10 + strtoint(s[i])
      else
      begin
        denom.mult(10);
        decpart.mult(10); decpart.add(strtoint(s[i]));
        //decpart:=decpart*10+strtoint(s[i]);
      end;
    end
    else if (s[i]=decimalseparator) and not decfound then decfound:=true
    else
    begin
      showmessage('Invalid number');
      Ok:=false;
    end;
  end;

  If OK then
  {Find gcd of numerator and denominator and divide both by the gcd}
  begin
    g:=Tinteger.create;
    newnumerator:=TInteger.create;
    newdenom:=TInteger.create;

    if radiogroup1.ItemIndex = 1 then denom.subtract(1); { denominator = 999... }
    g.assign(decpart); g.gcd(denom);
    newnumerator.assign(decpart); newnumerator.divide(g);
    newdenom.assign(denom); newdenom.divide(g);
    if (newdenom.compare(maxdenom)<=0) or (radiogroup1.ItemIndex = 1) then
    {If denominator is now less than max denominator value, we're done}
    begin
      If intpart<>0
      then Label2.Caption:=format('%s = %d + %s/%s',
                                   [edit1.text,intpart,
                                   newnumerator.converttodecimalstring(false),
                                   newdenom.converttoDecimalstring(false)])
      else Label2.Caption:=format('%s = %s/%s',[edit1.text,
                                   newnumerator.converttodecimalstring(false),
                                   newdenom.converttoDecimalstring(false)]);
    end
    else
    begin
      {otherwise find closest approximation}
      minerror:=1;

      c1:=decpart.compare(high(int64));
      c2:=denom.compare(high(int64));
      while (c1>=0) or (c2>=0) do
      begin
        decpart.divide(10);
        denom.divide(10);
        c1:=decpart.compare(high(int64));
        c2:=denom.compare(high(int64));
      end;
      if (c1<0) and (c2<0)
      then
      begin
        decpart.converttoint64(d1); denom.converttoint64(d2);
        fract:=d1/d2;
        for i:= 2 to maxdenom do
        begin
          num := round(fract*i);
          if num=0 then num:=1;
          e:=fract-num/i;
          if  (abs(e)< abs(minerror)) then
          begin
            minerror:=e;
            newnumerator.Assign(num); newdenom.assign(i);
          end;
        end;
        if intpart<>0
        then Label2.Caption:=format('%S = %d + %s/%s'+#13+#13+'Error: %g',
                       [EDIT1.TEXT, intpart,newnumerator.converttodecimalstring(false),
                                   newdenom.converttodecimalstring(false),minerror])
        else Label2.Caption:=format('%S = %s/%s'+#13+#13+'Error: %g',
                       [EDIT1.TEXT, newnumerator.converttodecimalstring(false),
                                    newdenom.converttodecimalstring(false)
                                    ,minerror]);
      end
      else showmessage('Decimal part or denominator too long fo this version');
    end;
  end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
begin
  with listbox1 do edit1.text:=items[itemindex];
  solvebtnclick(sender);
end;

procedure TForm1.FormActivate(Sender: TObject);
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
     add('0'+decimalseparator+ '023255813953488372093');
   end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


end.
