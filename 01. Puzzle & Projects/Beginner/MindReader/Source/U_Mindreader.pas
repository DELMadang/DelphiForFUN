unit U_Mindreader;
{Copyright  © 2005, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, ExtCtrls, shellapi, jpeg;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    TryAgainBtn: TButton;
    Panel2: TPanel;
    Memo1: TMemo;
    ShowMeBtn: TButton;
    Image1: TImage;
    Memo2: TMemo;
    StaticText1: TStaticText;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure ShowMeBtnClick(Sender: TObject);
    procedure TryAgainBtnClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    answer:string;
    cleargrid:boolean;
    procedure redrawgrid;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}
var
  {I picked ordinals of wingding symbols that are not too dark (so any pattern
   in the result would not be obvious :>)}
  symbols:array[0..19] of byte=(37,38,150,151,152,{153,}63,64,65,79,80,
                                82,94,95,96,97,98,100,101,102,103);

{****************  StringGridDrawCell *************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  {Draw a cell in the symbol table, we need this exit because we need two different
   fonts to draw each cell, the number and the symbol}
  var n,w:integer;
begin
   With Stringgrid1, canvas do
   if cleargrid then fillrect(rect)
   else
   begin
     n:=(acol)*20+ Arow;
     font.size:=18;
     font.name:='arial';
     canvas.textout(rect.left+2, rect.top+1,inttostr(n));
     w:=textwidth(inttostr(n));
     font.name:='wingdings';
     textout(rect.left+4+w,rect.top+1,cells[acol,arow]);
   end;
end;

{********** ReDrawGrid ******}
procedure TForm1.redrawgrid;
{Set up to clear symbol board or to
 create a new symbol list}
var  c,r:integer;
begin
  with stringgrid1 do
  begin
    cleargrid:=true;
    invalidate; {force the grid to redraw}
    application.processmessages;
    sleep(500); {A slight pause to make the user think that this is a lot of work}
    cleargrid:=false;
    for c:=0 to colcount-1 do for r:=0 to rowcount-1
    do cells[c,r]:=char(SYMBOLS[random(length(symbols))]);
    for c:=0 to 4 do {ahhh -- the secret mindreader's trick}
    begin
      cells[c,9-2*c]:=answer;
      cells[c,18-2*c]:=answer;
    end;
  end;
end;

{************* FormActivate ***********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  Answer:=char(symbols[random(length(symbols))]);
  redrawgrid;
  panel2.visible:=true;
end;

{*********** ShowMeBtnClick ************}
procedure TForm1.ShowMeBtnClick(Sender: TObject);
var h,w:integer;
begin
  sleep(1000); {we're reading the viewer's mind and making our decision now!}
  panel2.visible:=false;  {hide the instruction panel}
  stringgrid1.visible:=false; {hide the symbols so that the answer panel shows up}
  with image1,canvas do {Show the image the viewer was thinkiung of}
  begin
    font.name:='wingdings';
    font.size:=36;
    w:=textwidth(answer);
    h:=textheight(answer);
    textout((width-w) div 2, (height-h) div 2, answer);
  end;
end;

{************** TryAgainBtnClick ***********}
procedure TForm1.TryAgainBtnClick(Sender: TObject);
{User doesn't believe it and wants to see if the first time was just dumb luck!}
begin
  Answer:=char(symbols[random(length(symbols))]); {get the next answer symbol}
  redrawgrid; {draw the new symbol table}
  panel2.visible:=true; {show the instructions}
  stringgrid1.visible:=true; {show the symbols}
  with image1,canvas do {don't forget to erase the old symbol display}
  begin
    brush.color:=clwindow;
    fillrect(image1.clientrect);
  end;
end;

{********** StaticText1Click ************}
procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
