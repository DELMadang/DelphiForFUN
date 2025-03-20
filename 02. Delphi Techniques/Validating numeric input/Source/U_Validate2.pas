unit U_Validate2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, ShellAPI;

type
  TForm1 = class(TForm)
    IntEdt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    FloatEdt: TEdit;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure IntEdtKeyPress(Sender: TObject; var Key: Char);
    procedure editchange(Sender: TObject);
    procedure FloatEdtKeyPress(Sender: TObject; var Key: Char);
    procedure IntEdtDblCkick(Sender: TObject);
    procedure FloatEdtDblClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

const backspace=#8; {key code for backspace character}
      enter=#13;
      space=' ';

var
  validchars:set of char= [backspace, enter, ' ', '0'..'9'];


function SignOK(edit:TEdit; key:Char):boolean;
{check + or - key position.  OK if at the beginning of an integer}
{That may be the first character of the string or the first character
 after a thousandSeparator and possibly one or more space characters}

  {---------- PrevNonBlank --------}
  function prevNonBlank:char;
  {return the first non-blank character preceeding the current Selection start
   position, retur space character if no preeceding character found.}
  var  n:integer;
  begin
    with Edit do
    begin
      n:=SelStart;
      result:=' ';
      while (n>0) and (text[n]=' ') do dec(n);
      if (n>0) then result:=text[n];
    end;
  end;

begin {signOK}
  result:= false;
  if not (key in ['+','-']) then exit;
  if (Edit.SelStart = 0) or (prevnonblank=thousandSeparator)
  then result := true;
end;

{************ DecimalOK **********}
function DecimalOK(Edit:TEdit):boolean;
{check there is not a decimal point already in the number where the cursor
 is located, return true if there is none, i.e. OK to add one}
var
  start,stop:integer;
  s:string;
begin
  start:=Edit.selstart;
  stop:=start+1;
  s:=edit.text;
  result:=true;
  {find the number being built}
  while (start>0) and (s[start]<>DecimalSeparator) do dec(start);
  if start>0 then result:=false
  else
  begin
    while (stop<=length(s)) and (s[stop]<>DecimalSeparator) do inc(stop);
    if stop >length(s) then result:=false;
  end;
end;

{*********** IntEdtKetPress ************}
procedure TForm1.IntEdtKeyPress(Sender: TObject; var Key: Char);
begin
  If sender is TEdit then
  begin
    if key=enter then
    begin
      IntedtDblCkick(Sender);
      key:=#0;
      exit;
    end;
    if Key in validchars + [ThousandSeparator] then exit;
     if (key in ['+','-']) and  SignOK(TEdit(sender),key) then exit;
    Key := #0;
    beep;
  end;
end;


{************** FloatEdtKeyPress  **************}
procedure TForm1.FloatEdtKeyPress(Sender: TObject; var Key: Char);

begin
  If sender is TEdit then
  Begin
    if key=enter then
    begin  {extract the floating point numbers}
      FloatEdtDblClick(Sender);
      key:=#0;
      exit;
    end;
    if Key in validchars+ [ThousandSeparator, DecimalSeparator] then exit;{ignore these characters}
    if (Key = DecimalSeparator) and DecimalOK(Tedit(Sender)) then exit;
    if (key in ['+','-']) and  SignOK(TEdit(sender),key) then exit;
    Key := #0;
    beep;
  end;
end;

{********** EditChange ***********}
procedure TForm1.EditChange(Sender: TObject);
{Same Onchange exit works for integer and float numbers}
{Makes sure that and empty text string can be converted to 0}
var
  s:string;
begin
  If sender is TEdit then
  Begin
    if TEdit(sender).text = ''
    then TEdit(sender).text:='0';
  end;
end;

{************ IntEdtDblClick *************}
procedure TForm1.IntEdtDblCkick(Sender: TObject);
{Extract one or more integers from a TEdit sender}
var
  n:integer;
  s:string;
begin
  If sender is TEdit then
  begin
    s:=TEdit(sender).text;
    if length(s)>0 then
    begin
      s:=stringreplace(s,' ','',[rfreplaceall]);  {remove any spaces}
      if (s[length(s)]<>ThousandSeparator) then s:=s+ThousandSeparator;
      n:=pos(ThousandSeparator,s);
      while n>0 do
      begin
        memo1.Lines.add(format('Added integer %d',[strtoint(copy(s,1,n-1))]));
        delete(s,1,n);
        n:=pos(',',s);
      end;
    end;
  end;
end;

{******** FloatEdtDblClick **************}
procedure TForm1.FloatEdtDblClick(Sender: TObject);
  {Extract one or more floating point numbers from a TEdit sender}
  {Called when the user doubled clicks or presses the Enter key in the "float"  Tedit }
var
  n:integer;
  s:string;
begin
  If sender is TEdit then
  begin
    s:=TEdit(sender).text;
    if length(s)>0 then
    begin
      stringreplace(s,space,'',[rfreplaceall]);  {remove any spaces}
      if (s[length(s)]<>ThousandSeparator) then s:=s+ThousandSeparator;
      n:=pos(',',s);
      while n>0 do
      begin
        memo1.Lines.add(format('Added decimal number %f',[strtofloat(copy(s,1,n-1))]));
        delete(s,1,n);
        n:=pos(',',s);
      end;
    end;
  end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
