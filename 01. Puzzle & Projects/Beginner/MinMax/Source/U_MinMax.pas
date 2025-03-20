unit U_MinMax;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, StdCtrls, MathCtrl;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    NEdt: TIntEdit;
    GenerateBtn: TButton;
    OutGrid: TStringGrid;
    procedure GenerateBtnClick(Sender: TObject);
    procedure OutGridDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
  public
    { Public declarations }
    minmax,maxmin:integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.GenerateBtnClick(Sender: TObject);
var
  n,c,r,x:integer;
  max,min:integer;
begin
  n:=NEdt.value;
  with outgrid do
  Begin
    maxmin:=999;
    minmax:=0;
    rowcount:=n+2; {1st row for labels, last row for max-min values}
    colcount:=n+2; {1st column for labels, last for min-max values}

    {generate grid}
    x:=canvas.textwidth('100'); {set max column width for cells with numbers}
    for c:=1 to n do
    Begin
      colwidths[c]:=x;
      cells[c,0]:='';
      for r:=1 to n do
        cells[c,r]:=inttostr(random(100));

    End;
    {Get max per row and remember the smallest of these}
    minmax:=999;
    For r:= 1 to n do
    Begin
      max:=-999;
      cells[0,r]:='';
      for c:=1 to n do
      Begin
        x:=strtoint(cells[c,r]);
        if x>max then max:=x;
      end;
      if max<minmax then minmax:=max;
      cells[n+1,r]:=inttostr(max);
    end;
    {Get min per column and remember the largest of these}
    maxmin:=-999;
    For c:= 1 to n do
    Begin
      min:=+999;
      for r:=1 to n do
      Begin
        x:=strtoint(cells[c,r]);
        if x<min then min:=x;
      end;
      if min>maxmin then maxmin:=min;
      cells[c,n+1]:=inttostr(min);
    end;
    {Set column widths for totals columns}
    colwidths[0]:=canvas.textwidth(' Apple Sizes  ');
    colwidths[n+1]:=canvas.textwidth(' MinMax(A)  ');
    {Insert headers}
    cells[0,0]:=' Apple Sizes';
    cells[0,n+1]:=' MaxMin(B)';
    cells[n+1,0]:=' MinMax(A)';

    row:=rowcount-1; {put selection box in bottom right corner}
    col:=colcount-1;
    {Identify bigger apple}
    If minmax>maxmin then cells[col,row]:='A is bigger'
    else if minmax=maxmin then cells[col,row]:='Same size'
    else cells[col,row]:='B is bigger'
    end;

end;

procedure TForm1.OutGridDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{USe this exit to color and make bold the minmax and maxmin values}
var
  x, errcode:integer;
begin
  if (acol=outgrid.colcount-1) or (arow=outgrid.rowcount-1) then
  with outgrid do
  Begin
    val(cells[acol,arow],x,errcode);
    If errcode=0 then {ignore non-integers}
    Begin
     If (x=minmax) or (x=maxmin) then
     Begin
       canvas.font.style:=[fsbold];
       canvas.font.color:=clred;
       canvas.textout(rect.left+2,rect.top+2,cells[acol,arow]);
     end;
    end;
  end;
end;

end.
