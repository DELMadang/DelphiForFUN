unit U_FontViewer;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A program to view all characters in any selected font}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, UMakeCaption;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    FontDialog1: TFontDialog;
    FontBtn: TButton;
    Label1: TLabel;
    FontLbl: TLabel;
    Memo1: TMemo;
    procedure adjustGridSize;
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FontBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    public
      procedure setfont;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}



{***************** FormActivate *************}
procedure TForm1.FormActivate(Sender: TObject);
begin
  setfont;
  adjustgridsize;
  stringgrid1.refresh;
end;

{**************** SetFont ************}
Procedure TForm1.setfont;
{set font labels and force grid redraw}
begin
  Fontlbl.caption:=fontdialog1.Font.name;
  makecaption('FontViewer - '+fontdialog1.font.name,
                       #169+' 2002, G.Darby, www.delphiforfun.org',self);
  stringgrid1.refresh;
end;


{**************** AdjustGridSize *************}
procedure TForm1.adjustGridSize;
{Adjust borders of grid to just fit cells}
var
  h:integer;
begin
  with stringgrid1 do
  begin
    h:=(defaultrowheight+GridLineWidth)*rowcount+gridlinewidth+2 {+2 for border};
    if (h<height) then height:=h;
    width:=colcount*(defaultcolwidth+gridlinewidth)+gridlinewidth+2 {+2 for border};
  end;
end;

{************************ StringGrid1DrawCell **************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{Called for each cell to be drawn}
{Label rows and columns 1-16 with hex value, actually labels run 0-15 }
{Insert character representation of 16*row+column for the currently
 selected font}
var n:integer;
begin
  with StringGrid1 do
  begin
    if (Acol>0) and (Arow>0) then {we're in the data area}
    begin
      Canvas.Font.assign(FontDialog1.Font);
      Canvas.Brush.Color := clwhite;
      Canvas.FillRect(Rect);
      canvas.textout(rect.left+4, rect.top+4, char((Acol-1)+16*(arow-1)))
    end
    else
    begin {we're in the label area}
      Canvas.Brush.Color := clMenu;
      Canvas.FillRect(Rect);
      if acol+arow>0 then {not at 0,0}
      begin
        canvas.font.assign(self.font);
        If acol>0 then n:=acol-1 else n:=arow-1; {which label to show}
        canvas.textout(rect.left+4, rect.top+4, inttohex((n),1))
      end;
    end;
  end
end;

{************* FontBtnClick *************}
procedure TForm1.FontBtnClick(Sender: TObject);
begin
  fontdialog1.execute;
  setfont;
end;


end.
