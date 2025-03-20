unit U_TextSpinner;
{Copyright © 2009, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

(*
 Text spinning is a technique for randomly varying text based on user defined phrase
choices embedded within  the text.

In this implementation, "Phrase sets" of alternatives are defined within pairs of curly brackets,
{}.  Inside the brackets, alternatitive phrases to be randomly selected are separated by a
vertical line character, |.  If a phrase set contains only a single phrase, it will be randomly
included or omitted on a 50-50 basis.

An example is included on the "Spin Text" page.  Other spinnable text input can be entered
directly into  the Input form or copied and pasted from another source.

*)

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, strutils;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SpinBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Label1: TLabel;
    Introlbl: TLabel;
    ClearBtn: TButton;
    procedure StaticText1Click(Sender: TObject);
    procedure SpinBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Firstentry:boolean;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{********* FormCreate ***********}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  Firstentry:=true;
end;

{********* SpinBtnClick ************8}
procedure TForm1.SpinBtnClick(Sender: TObject);
var
  i:integer;
  wordcount,n,start,stop:integer;
  line,lineout:string;
  words:array [0..10] of string;
begin
  if firstentry then
  with Introlbl do
  begin {convert the Intro area into the Output area by removeing Intro formatting}
    Caption:='Output';
    with font do
    begin
      Color:=clblack;
      Size:=12;
      Style:=[];
    end;
    color:=clBtnFace;
    memo2.Color:=clWhite;
    memo2.Clear;
    Clearbtn.Visible:=true;
    firstentry:=false;
  end;
  line:='';
  with memo1 do  for i:=0 to Lines.Count-1 do line:=line+lines[i];
  lineout:='';
  n:=1;
  repeat
    start:=n;
    n:=posex('{',line,n);
    if n>0 then
    begin
      lineout:=lineout + copy(line,start, n-start);
      start:=n+1; {update next word start position}
      wordcount:=0;
      stop:=posex('}',line,n);
      if stop>0 then
      begin  {found the closing bracket }
        while (n>0) and (n<stop) do
        begin {Loop looking for phrase dividers}
          n:=posex('|',line,start);
          if (n=0) or (n>stop) then n:=stop; {didn't find one, use closing bracket as the last}
          words[wordcount]:=copy(line,start,n-start); {save the phrase}
          inc(wordcount);
          start:=n+1; {next start index is right after the divider or closing bracket}
        end;
        {We have all the phrases, pick one randomly from those found}
        if wordcount>1 then lineout:=lineout+ words[random(wordcount)]
        {unles only one phrase found, select it half the time}
        else if (wordcount=1) and (random(2)=1) then lineout:=lineout+ words[0];
        n:=stop+1; {Update N just past the closing bracket}
      end
      else
      begin
        showmessage('No closing ''}'' for choices phrase set');
        n:=0; {to stop the loop}
      end;
    end;
  until n=0;
  Memo2.Lines.add(lineout);
  memo2.lines.Add('');
end;


{************ ClearBtnClick *********}
procedure TForm1.ClearBtnClick(Sender: TObject);
begin
  memo2.clear;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
