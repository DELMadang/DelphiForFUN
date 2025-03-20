unit U_TextSpinner2;
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

Version 2 adds handling of the awkward result of the "{Not} A but B" structure of the Version
1 included sample which could produce "A but B".  The syntax now allows %X, immediately
following the { start symbol where X is any single letter or digit to uniquely identify this phrase
set. This identifying symbol may be referenced in a later phrase set and the same index that
applied to the X phrase set will be applied the the referrencing phase set.  To allow for the
single phrase set, I also now recognize a phrase consisting of a the lower case letter "b" as a
place holder for "no phrase to be inserted" condition. Referrencing is indicated by an &X
symbol+character following the opening { bracket.   So a revised spin might look like
"{%1Not|b} A {&1but|and also} B." which could produce either sentence "Not A but B." or "A
and also B."
*)



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, strutils, ComCtrls;

type

  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    SpinBtn: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    ClearBtn: TButton;
    Memo3: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure SpinBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
  public
    SpinSets:TStringlist;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** FormCreate **********8}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
  Spinsets:=TStringList.create;
end;


{********** SpinBtnClick ***********}
procedure TForm1.SpinBtnClick(Sender: TObject);
var
  i:integer;
  PhraseCount,n,start,stop:integer;
  index, PhraseIndex:integer;
  line,lineout:string;
  Phrases:array [0..10] of string;
  id,idref:string;
begin
  SpinSets.clear;
  line:='';
  {copy all of the input text into a single string}
  with memo1 do  for i:=0 to Lines.Count-1 do line:=line+lines[i];
  lineout:='';
  n:=1;
  repeat
    start:=n; {next start point for scanning the line}
    n:=posex('{',line,n); {find next phrase set}
    if n>0 then
    begin
      lineout:=lineout + copy(line,start, n-start);
      start:=n+1; {update next word start position}
      PhraseCount:=0;
      stop:=posex('}',line,n);
      if stop>0 then
      begin  {found the closing bracket }
        id:='';
        idref:='';
        if line[start]='%' then
        begin {"id" specified for this spinset}
          id:=line[start+1];
          inc(start,2);
        end
        else if line[start]='&' then
        begin {this is a reference to a previously defined spinset}
          idref:=line[start+1];
          inc(start,2);
        end;
        while (n>0) and (n<stop) do
        begin {Loop looking for phrase dividers}
          n:=posex('|',line,start);
          if (n=0) or (n>stop) then n:=stop; {didn't find one, use closing bracket as the last}
          Phrases[PhraseCount]:=copy(line,start,n-start); {save the phrase}
          inc(PhraseCount);
          start:=n+1; {next start index is right after the divider or closing bracket}
        end;
         PhraseIndex:=-1;
        if idref<>'' then
        begin {add the worded indexed by the referenced phrase's word index to the line}
          phraseindex:=-1;
          for i:=0 to spinsets.Count-1 do
          begin
            if spinsets[i][1]=idref then
            begin
              phraseindex:=strtoint(copy(spinsets[i],2,length(spinsets[i])-1));
              break;
            end;
          end;
          if phraseindex<0 then showmessage('The referenced item  &'+idref + ' is undefined');
        end
        else
        begin {add a random phrase to the output}
          {We have all the phrases, pick one randomly from those found}
          if PhraseCount>1 then PhraseIndex:=random(PhraseCount)
          {unles only one phrase found, select it half the time}
          else if (PhraseCount=1) then if (random(2)=1) then PhraseIndex:=0;
        end;
        If PhraseIndex>=0 then
          if Phrases[PhraseIndex]<>'b' then lineout:=lineout+ Phrases[PhraseIndex];
        if id<>'' then
        begin
          spinsets.add(id+ inttostr(PhraseIndex));
        end;
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



{*********** ClearBtnClick ***********}
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
