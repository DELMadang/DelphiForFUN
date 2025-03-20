unit U_DictionaryWordSearch;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{
Our "Brain Games" daily calendar puzzles are usually pretty good, but the
author of the one included here thinks that "Cyclist" is the only answer (he
does not consider "Y" to be a vowel).

Fill in the parameters in the parameter boxes to check it out for yourself.

Future enhancements may include searches for puzzle variations which require
finding embedded or interlaced words from a given set  of letters.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, UDict, Spin, jpeg;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    SearchBtn: TButton;
    Memo1: TMemo;
    GroupBox1: TGroupBox;
    MinLettersEdt: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    MaxLettersEdt: TSpinEdit;
    Label3: TLabel;
    GroupBox2: TGroupBox;
    Label7: TLabel;
    MinVowelsEdt: TSpinEdit;
    Label8: TLabel;
    MaxVowelsEdt: TSpinEdit;
    Label9: TLabel;
    Label10: TLabel;
    MinConsonantsEdt: TSpinEdit;
    Label11: TLabel;
    MaxConsonantsEdt: TSpinEdit;
    Label12: TLabel;
    Memo2: TMemo;
    YBox: TCheckBox;
    VowelsBox: TCheckBox;
    ConsonantsBox: TCheckBox;
    Image1: TImage;
    procedure StaticText1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure MaxLettersEdtChange(Sender: TObject);
    procedure VowelsEdtChange(Sender: TObject);
    procedure ConsonantsEdtChange(Sender: TObject);
  public
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
  pubdic.loadLargeDic;
end;

procedure TForm1.SearchBtnClick(Sender: TObject);
Var
  w:string;
  a,b,f:boolean;
  nv,nc:integer;
  vowelset:set of char;

  function nbrvowels(w:string):integer;
  var i:integer;
  begin
    result:=0;
    for i := 1 to length(w) do if w[i] in vowelset then inc(result);
  end;

  function nbrconsonants(w:string):integer;
  var i:integer;
  begin
    result:=0;
    for i := 1 to length(w) do if not (w[i] in vowelset) then inc(result);
  end;

begin
  vowelset:=['a','e','i','o','u'];
  if ybox.checked then vowelset:=vowelset+['y'];
  memo2.clear;

  with pubdic do
  begin
    setrange('a',minlettersedt.Value,'z',maxlettersedt.value);
    while getnextword(w,a,b,f) do
    begin
      nv:=nbrvowels(w);
      nc:=nbrconsonants(w);

      if (vowelsbox.checked and (nv>=minvowelsedt.Value)  and  (nv<=maxvowelsedt.Value))
        or
        (consonantsbox.checked and (nc>=minconsonantsEdt.value) and (nc<=maxconsonantsEdt.value))
        or
          ((not vowelsbox.checked) and (not consonantsbox.checked))
      then
      begin
        memo2.lines.add(w);
      end;
    end;
  end;
  showmessage(format('%d words found',[memo2.lines.count]));
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm1.MaxLettersEdtChange(Sender: TObject);
var
  v:integer;
begin
  v:=MaxLettersEdt.value;
  maxvowelsedt.maxvalue:=v;
  maxconsonantsedt.maxvalue:=v;
end;

procedure TForm1.VowelsEdtChange(Sender: TObject);
begin
  vowelsBox.checked:=true;
end;

procedure TForm1.ConsonantsEdtChange(Sender: TObject);
begin
  consonantsBox.checked:=true;
end;

end.
