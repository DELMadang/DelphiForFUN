unit U_Roman2;

{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{Roman numeral conversions, in both directions}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, shellAPI;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Arabic: TEdit;
    Roman: TEdit;
    Label3: TLabel;
    StaticText1: TStaticText;
    procedure ArabicKeyPress(Sender: TObject; var Key: Char);
    procedure ArabicChange(Sender: TObject);
    procedure RomanKeyPress(Sender: TObject; var Key: Char);
    procedure RomanChange(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    CR:boolean;  {convert to roman flag - set when arabic digit is entered
                                          reset when roman digit is entered
          needed to prevent loop as change in arabic cause change in roman, etc.}
    function showroman(ss:string):string;
    function showarabic(ss:string):string;
    function ValidRoman(const s:string):boolean;

  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

type
  stringrec=record
     pat:string;
     rep:char;
   end;
var
  romanset:set of char=['I','V','X','L','C','D','M'];
  romans:array[1..7] of char =('I','V','X','L','C','D','M');
  {Here is the key to conversion from roman to arabic.
    Patterns for each digit are repeated for each digit position
    but with different letters: for example, a '4' is 'IV', or 'XL', or 'CD'
    depending on whether it is in the units, tens or hundreds position.  From
    the above "romans" letter list, this is letters 1&2 or 3&4 or 5&6.  So we
    can shorten the code by checking for j & j+1 where j = 1, 3, and 5 in a loop.
    When we find that pattern we can repalce it with a '4'.  The table below
    identifies patterns for all 9 digits and the digit to be inserted in place
    of that letter pattern.  These pattern need to be checked from back to front
    so that we look for (for example), III before we look for II, etc.}

  patterns: array [1..9] of stringrec=((pat:'1';rep:'1'),
                                       (pat:'11';rep:'2'),
                                       (pat:'111';rep:'3'),
                                    (pat:'2';rep:'5'),
                                    (pat:'12';rep:'4'),
                                    (pat:'21';rep:'6'),
                                    (pat:'211';rep:'7'),
                                    (pat:'2111';rep:'8'),
                                    (pat:'13';rep:'9'));


{************** ShowArabic ************}
function TForm1.showarabic(ss:string):string;
var
  wp:array[1..9] of stringrec;
  s:string;
  i,j:integer;
  inserted:boolean;
  done, err :boolean;

  procedure convert(var s:string);
  var i,n:integer;
  begin
    for i:=9 downto 1 do
    begin
      n:=pos(wp[i].pat,s);
      if n>0 then
      begin
        s:=stringreplace(s,wp[i].pat,wp[i].rep,[rfreplaceall]);
        break;
      end;
    end;
    if n<=0 then{no digits converted, muist be a 0 here}
    begin {but we need to insert the 0 after any letters not yet converted}
      inserted:=false;
      for i:=1 to length(s) do if not (s[i] in romanset) then
      begin
        insert('0',s,i);
        inserted:=true;
        break;
      end;
      if not inserted then s:=s+'0';
    end;
  end;

begin
  result:='';
  s:=ss;
  if validroman(s) then
  begin
    j:=1;
    while j<=7 do
    begin
      for i:=1 to 9 do wp[i]:=patterns[i];
      done:=true;
      {check units (j=1), tens (j=3), hundreds (j=5) digits}
      for i:= 1 to 9 do
      begin {replace numbers with the letters that we want to cheeck for}
        wp[i].pat:=stringreplace(wp[i].pat,'1',romans[j],[rfreplaceall]);
        if j<7 then  {don't check for successors to 'M'}
        begin
          wp[i].pat:=stringreplace(wp[i].pat,'2',romans[j+1],[rfreplaceall]);
          wp[i].pat:=stringreplace(wp[i].pat,'3',romans[j+2],[rfreplaceall]);
        end
        else
        begin  {but we do have to replace the numbers with something that won't match later on}
          wp[i].pat:=stringreplace(wp[i].pat,'2','Z',[rfreplaceall]);
          wp[i].pat:=stringreplace(wp[i].pat,'3','Z',[rfreplaceall]);
        end;
      end;
      convert(s);
      for i:= 1 to length(s) do if not (s[i] in ['0'..'9']) then done:=false;
      if done then break;
      inc(j,2);
    end;
    err:=false;
    for i:=1 to length(s) do if s[i] in romanset then err:=true;
    if err then  showmessage('Invalid Roman numeral format')
    else result:=s;
  end
  else showmessage('Invalid Roman numeral format');
end;

{************* ValidRoman ***********}
function TForm1.ValidRoman(const s:string):boolean;
{validate Roman numeral}
var n:integer;
    w:string;
begin
  result:=true;
  {no more than 3 consecutve I's, X's, C's or M's}
  if pos('IIII',s)>0 then result:=false;
  if result and (pos('XXXX',s)>0) then result:=false;
  if result and (pos('CCCC',s)>0) then result:=false;
  if result and (pos('MMMM',s)>0) then result:=false;
  {no I should be before L,C,D,M}
  if result then
  begin
    n:=pos('I',s);
    if n>0 then
    begin
      w:=s;
      delete(w,1,n);
      if pos('L',w)>0 then result:=false
      else if pos('C',w)>0 then result:=false
      else if pos('D',w)>0 then result:=false
      else if pos('M',w)>0 then result:=false;
    end;
  end;
  {next letter after I must be I,V,X}
  w:=s;
  n:=pos('I',w);
  while result and (n>0) and (n<length(w))  do
  begin
    if not (w[n+1] in ['I','V','X']) then result :=false
    else delete (w,1,n);
    n:=pos('I',w);
  end;
  {no V before V,X,L,C,D,M}
  if result then
  begin
    n:=pos('V',s);
    if n>0 then
    begin
      w:=s;
      delete(w,1,n);
      if pos('V',w)>0 then result:=false
      else if pos('X',w)>0 then result:=false
      else if pos('L',w)>0 then result:=false
      else if pos('C',w)>0 then result:=false
      else if pos('D',w)>0 then result:=false
      else if pos('M',w)>0 then result:=false;
    end;
  end;
  {next letter after V must I}
  w:=s;
  n:=pos('V',w);
  while result and (n>0) and (n<length(w))  do
  begin
    if not (w[n+1] in ['I']) then result :=false
    else delete (w,1,n);
    n:=pos('V',w);
  end;
  {no X before D,M}
  if result then
  begin
    n:=pos('X',s);
    if n>0 then
    begin
      w:=s;
      delete(w,1,n);
      if pos('D',w)>0 then result:=false
      else if pos('M',w)>0 then result:=false;
    end;
  end;
  {next letter after X must be I,V,L,C,  or X}
  w:=s;
  n:=pos('X',w);
  while result and (n>0) and (n<length(w))  do
  begin
    if not (w[n+1] in ['I','V','X','L','C']) then result :=false
    else delete (w,1,n);
    n:=pos('X',w);
  end;
  {no L before L,C,D,M}
  if result then
  begin
    n:=pos('L',s);
    if n>0 then
    begin
      w:=s;
      delete(w,1,n);
      if pos('L',w)>0 then result:=false
      else if pos('C',w)>0 then result:=false
      else if pos('D',w)>0 then result:=false
      else if pos('M',w)>0 then result:=false;
    end;
  end;
  {next letter after L must be I,V or X}
  w:=s;
  n:=pos('L',w);
  while result and (n>0) and (n<length(w))  do
  begin
    if not (w[n+1] in ['I','V','X']) then result :=false
    else delete (w,1,n);
    n:=pos('L',w);
  end;

  {no D before D,M}
  if result then
  begin
    n:=pos('D',s);
    if n>0 then
    begin
      w:=s;
      delete(w,1,n);
      if pos('D',w)>0 then result:=false
      else if pos('M',w)>0 then result:=false;
    end;
  end;

  {next letter after D must be I,V,X,L, or C}
  w:=s;
  n:=pos('D',w);
  while result and (n>0) and (n<length(w))  do
  begin
    if not (w[n+1] in ['I','V','X','L','C']) then result :=false
    else delete (w,1,n);
    n:=pos('D',w);
  end;
end;

{************* ShowRoman ************}
function Tform1.ShowRoman(ss:string):string;
var
  s,s2:string;
  i, baseindex:integer;
  n1,n2,n3:char;
Begin
  s2:='';
  result:='';
  {make sure number is OK}

  if (length(ss)=0) or (strtoint(ss)=0) then exit;
  i:=strtoint(ss);
  if (i<0) or (i>3999)
  then begin beep; showmessage('Numbers must be between 1 and 3999'); end
  else
  begin
    s:=ss;
    for i:=1 to length(s) do
    Begin
    {Baseindex picks the right starting spot in the base index array}
    {Expression was found by trial and error after making a table like this

            Length of #    Position in #      Index value wanted
            ------------  --------------      -----------------
             length(s)          i               BaseIndex
            ------------  ---------------     ------------------
               1                1                   1
               2                2                   1
               2                1                   3
               3                3                   1
               3                2                   3
               3                1                   5
               4                4                   1
               4                3                   3
               4                2                   5
               4                1                   7
               }

      Baseindex:=2*(length(s)-i)+1;
      {n1, n2, and n3 are the 3 characters we might need}
      n1:=romans[baseindex];
      n2:=romans[baseindex+1];
      n3:=romans[baseindex+2];
      case s[i] of
        '1': s2:=s2+n1;  {I,X,C,M}
        '2': s2:=s2+n1+n1; {II,XX,CC,MM}
        '3': s2:=s2+n1+n1+n1;  {III,XXX,CCC,MMM}
        '4': s2:=s2+n1+n2;     {IV,XL,CD}
        '5': s2:=s2+n2;        {V,L,D}
        '6': s2:=s2+n2+n1;     {VI,LX,DC}
        '7': s2:=s2+n2+n1+n1;  {VII,LXX,DCC}
        '8': s2:=s2+n2+n1+n1+n1; {VIII,LXXX,DCCC}
        '9': s2:=s2+n1+n3;       {IX,XC,CM}
      end; {case}
      {Note - no output for 0}
    end;
  end;
 result:=s2; {Put the string back into display field}
end;

{************* ArabicKeyPress **********}
procedure TForm1.ArabicKeyPress(Sender: TObject; var Key: Char);
{We come here everytime the user presses a character key}
begin  {An exit to keep out invalid data}
  If not (key in ['0'..'9',#8]) then Begin key:=#00; beep; end
  else cr:=true;
end;

{********* ArabicChange *******}
procedure TForm1.ArabicChange(Sender: TObject);
{We come here everytime the Arabic text box changes}
begin
  if cr then roman.text:=showroman(arabic.text); {display new roman # for every change}
end;

{************** RomanKeyPress ************}
procedure TForm1.RomanKeyPress(Sender: TObject; var Key: Char);
begin
 If not (upcase(key) in ['C','D','I','L','M','V','X',#8]) then Begin key:=#00; beep; end
 else cr:=false;

end;

{********** Romanchange *************}
procedure TForm1.RomanChange(Sender: TObject);
{roman numeral changed, calc arabic equivalent}
begin
  if not cr then arabic.text:=showarabic(roman.text);
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
