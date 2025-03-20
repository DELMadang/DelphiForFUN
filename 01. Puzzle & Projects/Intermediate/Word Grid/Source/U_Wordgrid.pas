unit U_Wordgrid;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }



interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, Grids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    StringGrid1: TStringGrid;
    MakeBtn: TButton;
    Memo1: TMemo;
    SearchBtn: TButton;
    Memo2: TMemo;
    Label1: TLabel;
    TestLbl: TLabel;
    Memo3: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure MakeBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure SearchBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses Udict, strutils;

var defaultcase: array[0..2, 0..2] of char = (('P','M','?'),('?','N','A'),('I','?','I')) ;

{*********** FormActivate **********8}
procedure TForm1.FormActivate(Sender: TObject);
var i,j:integer;
begin
  pubdic.loadlargedic; {load the large dictionary}
 {and make the default puzzle}
  for i:=0 to 2 do for j:=0 to 2 do stringgrid1.cells[i,j]:=defaultcase[i,j];
end;

{************* MakeBtn ************}
procedure TForm1.MakeBtnClick(Sender: TObject);

    procedure MakeTemplates(s:string);
    var i:integer;
    begin
      for i:=1 to 4 do
      begin
        memo1.Lines.add(s+stringgrid1.cells[1,1]);  {clockwise string plus the center character}
        {move 1st 2 characters to the end to get cw or ccw template from next corner}
        s:=copy(s,3,6)+copy(s,1,2);
      end;
    end;
var
  i,j:integer;
  scw,sccw:string;
begin
  memo1.clear;
  with stringgrid1 do
  begin
    with stringgrid1 do options:=options - [goAlwaysShowEditor]; {exit edit mode}
    invalidate;  {force a grid redraw in case changes were made}
    for i:=0 to 2 do for j:=0 to 2 do
    begin  {Validate the grid}
      if length(cells[i,j])>=1 then cells[i,j]:=upcase(cells[i,j][1])
      else cells[i,j]:='?';
      if not (cells[i,j][1] in ['A'..'Z','?']) then cells[i,j]:='?';
    end;
    {make a clockwise string around the border from top left corner}
    scw:=cells[0,0]+cells[1,0]+cells[2,0]+cells[2,1]+cells[2,2]
       +cells[1,2]+cells[0,2]+cells[0,1];
    sccw:= reverseString(scw); {make counterclockwise version}
    maketemplates(scw);
    maketemplates(sccw);
  end;
  searchbtn.enabled:=true; {OK to search now}
end;

{************ SearchBtn **********}
procedure TForm1.SearchBtnClick(Sender: TObject);
var
  i,j:integer;
  s,w,wu:string;
  A,F,C:boolean;
  OK:boolean;
begin
  memo2.clear;

  begin
    with pubdic, memo1 do
    begin
      setrange('a',9,'z',9);  {set to retrieve all 9 letter words}
      while getnextword(w,a,f,c) do {start retrieving words}
      begin
        wu:=uppercase(w);
        testlbl.caption:=wu;
        testlbl.update;
        for i:=0 to lines.count-1  do
        begin {for all templates}
          s:=lines[i];
          ok:=true;
          for j:=1 to length(wu) do
          if (s[j]<>'?') and (s[j]<>wu[j])  then
          begin
            ok:=false;
            break;
          end;
          if OK then
          begin  {a solution!}
            memo2.Lines.add(s+' = '+wu);
            memo2.update;
          end;
        end;
      end;
    end;
  end;
end;

{************ StringGrid1DrawCell *****************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var s:string;
begin
  with stringgrid1, canvas do
  begin
    canvas.font:=stringgrid1.font;
    rectangle(rect);
    s:=cells[acol,arow];
    {center the letter in the cell rectangle}
    with rect do textout((left + right - textwidth(s)) div 2,
                         (top + bottom -textheight(s)) div 2, s);
  end;
end;

{************** StringGrid1Click ************}
procedure TForm1.StringGrid1Click(Sender: TObject);
begin
  {Turn on the grid editor when grid is clicked}
  with stringgrid1 do options:=options + [goAlwaysShowEditor];
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.

