unit U_RectCount2;
{Copyright © 2012, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }


{Here's a puzzle sent to me by a viewer who says it is from a set of questions
written by Clive Sinclair and published in a magazine, perhaps "Design Technology",
many years ago as "Mensa Steps":
"If you draw a nine by nine square, thus giving yourself eight one small squares
in total; how many rectangles can you count in total? "

}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    procedure StaticText1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses mathslib, ugetparens;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


procedure shuffle(var deck:array of integer);
var
  i,n:integer;
  temp:integer;
begin
  i:= high(deck);
  while i>0 do
  begin
    n:=random(i+1);
    temp:=deck[i];
    deck[i]:=deck[n];
    deck[n]:=temp;
    dec(i);
  end;
end;

{************ Button1Click ***********8}
procedure TForm1.Button1Click(Sender: TObject);
var
  h,v, N:integer;
  tot, nrow, ncol, calctot : integer;
begin
  for n:=1 to 9 do  {check all grid sizes from 1x1 to 9x9}
  begin
    tot:=0;
    for h:=0 to N-1 do {for each column}
    begin
      ncol:= n - h; {this is the number of rectangles of width H}
      for v:=0 to N-1 do {for each row}
      begin
        nrow:=n - v; {this is the number of rectangles of height V that will fit}
        inc(tot, ncol*nrow);
      end;
    end;
    //calctot:=sqr(n*(N+1) div 2); {the formula from http://oeis.org/A000537}
    memo1.Lines.add(format('For %d x %d grid, counted %d rectangles',[n,n,tot{, calctot}]));
  end;
end;


end.
