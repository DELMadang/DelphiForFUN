unit U_DoubletsX3;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }
 {Scans a dictionary for words containg 3 sets of doubled letters and flags any
  where the 3 sets are adjacent}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ComCtrls, ExtCtrls, shellapi, UDict;

type
  TForm1 = class(TForm)
    Searchbtn: TButton;
    Memo1: TMemo;
    StaticText1: TStaticText;
    procedure SearchbtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  end;

var
  Form1: TForm1;
implementation

{$R *.DFM}

procedure TForm1.SearchbtnClick(Sender: TObject);
  var
    i:integer;
    a,f,c:boolean;
    validword:string;
    totcount,dcount,count:integer;
    startsAt:array[1..3] of integer; {array of where doublets start}
  begin
    pubDic.LoadDefaultDic; {load the default dictionary}
    memo1.clear;
    totcount:=0;
    DCount:=0;
    PubDic.SetRange('a',6,'z',12);   {check 6 to 12 letter words}
    while (Pubdic.getnextword(validword,a,f,c)) do
    if (not a) and (not f) and (not c) then {don't use abbreviations, foreign, or capitalized}
    begin
      inc(Totcount); {count the words}
      count:=0; {reset count of double letters in thus word}
      for i:= 2 to length(validword) do {count letter pairs}
      if validword[i]=validword[i-1] then
      begin
        inc(count);
        if count<=3 then startsat[count]:=i;
      end;
      if (count>=3) then
      begin
        inc(DCount); {count words with 3 or more doublets}
        {if they are adjacent then flag the word}
        if (startsat[2]-startsat[1]=2) and (startsat[3]-startsat[2]=2)
        then validword:='*** '+validword;
        memo1.lines.add(validword);
      end;
    end; {while}
    with memo1,lines do
    begin
      add('-------------------');
      add(format('%d words checked, %d contain 3 sets of double letters',
                            [totcount,dcount]));
      selStart:=0;  {force scoll back to top of memo1}
      selLength:=1;
    end;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
