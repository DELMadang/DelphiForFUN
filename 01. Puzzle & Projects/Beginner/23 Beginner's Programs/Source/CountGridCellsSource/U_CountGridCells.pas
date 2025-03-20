unit U_CountGridCells;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    MakeGridBtn: TBitBtn;
    CountBtn: TButton;
    LblGrid: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    procedure MakeGridBtnClick(Sender: TObject);
    procedure CountBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure IgnoreSelectedDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{*********** FormCreate ************}
procedure TForm1.FormCreate(Sender: TObject);
begin
  randomize;
end;

{***************** MakeRandomGrid ************}
procedure MakerandomGrid(grid:TStringGrid; N:integer);
{Place N letters at random locations on a grid}
var
  i,c,r, count:integer;
begin
   with grid do
   begin
     for c:=0 to colcount-1 do
     for r:=0 to rowcount-1 do cells[c,r]:='';
     count:=0;
     while count<N do
     begin
       c:=random(colcount);
       r:=random(rowcount);
       if cells[c,r]='' then
       begin
         cells[c,r]:=char(ord('A')+random(26));
         inc(count);
       end;
     end;
   end;
end;


{*************** MakeGridBtnClick ************}
procedure TForm1.MakeGridBtnClick(Sender: TObject);
var r:integer;
begin
  MakerandomGrid(Stringgrid1,20);
  with lblgrid do for r:= 0 to rowcount-1 do cells[0,r]:='';
end;

{************ CountGridBtnClick ************}
procedure TForm1.CountBtnClick(Sender: TObject);
var
  c,r,count:integer;
  lbl:string;
begin
  with stringgrid1 do
  begin
    for r:=0 to 7 do
    begin
      count:=0;
      Lbl:='';
      for c:=0 to 7 do
      begin
        if cells[c,r]='' then inc(count)
        else if count>0 then
        begin
           Lbl:=Lbl+inttostr(count)+cells[c,r];
           count:=0;
        end
        else lbl:=lbl+cells[c,r][1];
      end;
      if count>0 then Lbl:=Lbl+inttostr(count);
      count:=0;
      lblgrid.cells[0,r]:=lbl;
      lblgrid.Update;
    end;
  end;
end;

{*********** IgnoreSelectDrawCell *************}
procedure TForm1.IgnoreSelectedDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{OK, here's the thing:  The selected cell (current row and column) is drawn with
 a highlight color which bugs the heck out of me. By setting the "OnDrawCell event
 exit to this routine, the highlight is overwritten for the selectd cell and
 we'll redraw the text ourselves.  No modifications to the TStringGrid definition are
 needed except for sett the OnDrawCell exit}
var
  g:TstringGrid;
begin
  g:=TStringGrid(Sender); {G is just shorthand the the grid object}
  If (gdselected in state) then
  with G, canvas do
  begin
    if font<>g.Font then font.assign(g.font);  {1st time, get the proper font for the canvas}
    brush.Color:=color;
    fillrect(rect);
    textrect(rect, rect.Left+4, rect.Top+4, cells[acol,arow]);
  end;
end;

end.
