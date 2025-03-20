unit U_SimpleDecrypt;
{Copyright © 2006, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, shellapi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    SearchBtn: TButton;
    InputLbl: TLabel;
    Label1: TLabel;
    StaticText1: TStaticText;
    procedure SearchBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}


var fromstr, tostr:array['A'..'Z'] of char;

{*************** SearchBtnClick ************}
procedure TForm1.SearchBtnClick(Sender: TObject);
VAR
  i,j,k:integer;
  s:string;
  ch, fromch, toch:char;
begin
  {Initialize Fromstr and ToStr arrays}
  for ch:='A' to 'Z' do
  begin
    fromstr[ch]:=ch;
    tostr[ch]:=ch;
  end;
  memo3.clear;

  for i:=1 to 26 do {We'll try all 26 possible shifts, #26 will be the "no change" transform}
  begin
    toch:=tostr['A'];
    {left shift "ToStr" by one position}
    for ch:='A' to 'Y' do tostr[ch]:=tostr[succ(ch)];
    tostr['Z']:=toch; {put first character in last position}
    {Write a space between tries}
    memo3.lines.add('');
    s:='Change ''A''..''Z'' to: ';
    for ch:='A' to 'Z' do s:=s+tostr[ch];  memo3.lines.add(s);

    with memo2 do {for each line of input}
    for j:=0 to lines.count-1 do
    begin
      s:=uppercase(lines[j]); {make sure we only test for upper case letters}
      for k:= 1 to length(s) do {for each character in the ine}
      begin
        fromch:=s[k]; {this is the encoded character}
        if fromch in ['A'..'Z'] {if it is a letter}
        {then "To" character is the corresponding character in the "to" string}
        then toch:=tostr[fromstr[fromch]]
        else toch:=fromch; {Otherwise, leave it unchanged}
        s[k]:=toch; {replace encoded character with decoded character}
      end;
      memo3.lines.add(s); {display decoded line}
    end; {end  all lines loop}
  end; {end try all shifts loop}
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
