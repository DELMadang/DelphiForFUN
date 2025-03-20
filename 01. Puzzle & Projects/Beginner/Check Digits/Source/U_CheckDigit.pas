unit U_CheckDigit;
{Copyright  © 2003, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved


 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*  Information from http://www.cs.queensu.ca/home/bradbury/checkdigit/creditcardcheck.htm
 "When dealing with credit cards it is important to realize that some have
 different lengths and have different prefixs.

 "MasterCard is of length 16 and has a prefix of 51, 52, 53, 54, 55.  VISA is
 of length 13 or 16 and has a prefix of 4.  American Express is of length 15
 and has a prefix of 34 or 37.  Discover has length 16 and a prefix of 6011.
 All of the above credits use (mod 10) to determine a check digit, and in all
 cases the check digit is the right-most digit in the number. To determine the
 check digit for a credit card follow the below steps."

 "NOTE: In MasterCard and VISA include the prefix digits in the calculation.
 In American Express and Discover the prefix digits are omitted from all
 calculations."   (Or maybe not - see program)
*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ShellAPI;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    CardNbrEdt: TEdit;
    CreditCardBtn: TButton;
    ResultLbl: TLabel;
    Memo1: TMemo;
    CheckType: TRadioGroup;
    Edit1: TEdit;
    ValidateBtn: TButton;
    CalcBtn: TButton;
    resultText: TStaticText;
    Eqtext: TLabel;
    Memo2: TMemo;
    Memo3: TMemo;
    StaticText1: TStaticText;
    procedure CreditCardBtnClick(Sender: TObject);
    procedure ValidateBtnClick(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var Form1: TForm1;

implementation

{$R *.DFM}

{****************** Mod10Check **************}
 function  mod10check(s:string; var equation:string):char;
 {calculate mod 10 check digit for input string 's'
  all non digits are ignored,
  also returns an 'explanation' in the form of a string containing the equation
  applied}
  var i,w,sum:integer;
      plusstr:string;
      position:integer;
  begin
    sum:=0;
    equation:='';
    position:=0;
    plusstr:=''; {blank first time, ' + ' after that}
    for i:=length(s) downto 1 do
    begin
      if s[i] in ['0'..'9'] then
      begin
        inc(position);
        if position mod 2 = 1 then w:=1 else w:=2; {weights, 1 for odd positions, 2 for even}
        sum:=sum+strtoint(s[i])*w;
        equation:=s[i]+'x'+inttostr(w)+plusstr+equation;
        plusstr:=' + ';
      end;
    end;
    result:=inttostr(sum mod 10)[1];
    equation:='('+equation+ ') mod 10 = '+result;
  end;

{****************** Mod11Check **************}
function  mod11check(s:string; var equation:string):char;
 {calculate mod 11 check digit for string 's'
  all non digits are ignored,
  also returns an 'explanation' in the form of a string containing the equation
  applied}
  var i,w,sum:integer;
      plusstr:string;
      position:integer;
      r:integer;
  begin
    sum:=0;
    equation:='';
    position:=0;
    plusstr:=''; {blank first time, ' + ' after that}
    for i:=length(s) downto 1 do
    begin
      if s[i] in ['0'..'9'] then
      begin
        inc(position);
        w:=10 - position mod 10;  {weights for each digit 9,8,7,6,5,4,3,2,1 from right to left}
        sum:=sum+strtoint(s[i])*w;   {add up the digit*weight products}
        equation:=s[i]+'x'+inttostr(w)+plusstr+equation;
        plusstr:=' + ';
      end;
    end;
    r:=sum mod 11;
    if r=10 then result:='X' else result:=inttostr(r)[1];
    equation:='('+equation+ ') mod 11 = '+result;
  end;

{***************** FormAciovate **********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  eqtext.caption:='';
  resulttext.caption:='';
  resultlbl.caption:='';
  Pagecontrol1.activepage:=tabsheet1;
end;


{**************** CreditCardBtnCLick *************}
procedure TForm1.CreditCardBtnClick(Sender: TObject);
var
  s:string;
  valid:boolean;
  cardtype:string;
  n,i,sum:integer;
begin
  sum:=0;
  s:=cardNbredt.text;
  n:=pos(' ',s);
  while n>0 do {delete blanks}
  begin
    delete(s,n,1);
    n:=pos(' ',s);
  end;
  valid:=true; {check that everything remaining is a digit}
  for i:= 1 to length(s) do  if not (s[i]in ['0'..'9'])
  then
  begin
    valid:=false;
    break;
  end;
  if not valid then  resultlbl.caption:='Invalid characters in card number'
  else {Determine card type based on number length and prefix}
  {MasterCard is of length 16 and has a prefix of 51, 52, 53, 54, 55}
  begin {Check length and prefix}
    cardtype:='';
    if (length(s)=16) and  (s[1]='5') and  (s[2] in ['1'..'5']) then
    begin
      cardtype:='Mastercard';
    end
    else
    { VISA is of length 13 or 16 and has a prefix of 4}
    if ((length(s)=13) or (length(s)=16))and (s[1]='4') then
    begin
      cardtype:='Visa';
    end
    { American Express is of length 15 and has a prefix of 34 or 37}
    else if (length(s)=15) and (s[1]='3') and (s[2] in ['3','7']) then
    begin
      cardtype:='AmEx';
    end
    {Discover has length 16 and a prefix of 6011}
    else if (length(s)=16) and (copy(s,1,4)='6011') then
    begin
      cardtype:='Discover';
    end;
    If cardtype =''
    then resultlbl.caption:='Number is not a recognized credit card type'
    else
    begin {check the check digit}
      {
      Step 1: Starting from the second digit from the right and moving towards the
      left, multiply every digit by 2 summing the resulting digits.
      }
      i:=length(s)-1;
      while i>0 do
      begin
        n:=(ord(s[i])-ord('0'))*2; {get twice the digit value}
        sum:=sum + n mod 10 + n div 10;{n mod 10=units digit, n div 10=10's digit}
        dec(i,2); {backup 2 positions}
      end;
      {Step 2: Add digits not originally mutliplied by 2 to sum}
      i:=length(s);
      while i>0 do
      begin
        n:=(ord(s[i])-ord('0'));
        sum:=sum + n;
        dec(i,2);
      end;

      {Step 3: result should  be a multiple of 10;  }
      if sum mod 10 = 0
      then  resultlbl.caption:='Card number has valid format and check check digit for a  '+cardtype+' number'
      else  resultlbl.caption:='Card number entered has invalid checkdigit';
    end;
  end;
end;

{***************** CalcBtnClick ************}
procedure TForm1.CalcBtnClick(Sender: TObject);
var
  d:char;
  explain:string;
begin
  if CheckType.itemindex=0 then d:=mod10check(edit1.text, explain)
  else  d:=mod11check(edit1.text, explain);
  resulttext.caption:=edit1.text+ ' - '+ d;
  eqtext.caption:=explain;
end;

{******************* ValidateBtnClick ************}
procedure TForm1.ValidateBtnClick(Sender: TObject);

var
  cd, d:char;
  explain:string;
  s:string;
begin
  eqtext.caption:='';
  s:=trim(edit1.text);
  cd:=upcase(s[length(s)]);
  if (cd in ['0'..'9']) or (CheckType.itemindex=1) then
  begin
    delete(s,length(s),1);
    if CheckType.itemindex=0 then  d:=mod10check(s, explain)
    else d:=mod11check(s,explain);
    s:='Check digit '+cd;
    if d=cd then s:= s + ' is valid.'
    else s:=s+' is not valid, should be '+d + '.';
    resulttext.caption:=s;
    eqtext.caption:=explain;
  end
  else resulttext.caption:='Last character of input, "'+cd+'", should be a check digit';
end;

{****************StaticText1Click ********}
procedure TForm1.StaticText1Click(Sender: TObject);
{Show delphiforfun homepage when clicked}
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL);
end;

end.
