unit U_MagicMatrix;
{Copyright  © 2002-2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, Grids, ComCtrls, shellapi;

type
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    MagicEdt: TSpinEdit;
    CreateBtn: TButton;
    Label1: TLabel;
    SizeGrp: TRadioGroup;
    Memo1: TMemo;
    ResultLbl: TLabel;
    ExplainBtn: TButton;
    Button1: TButton;
    StaticText1: TStaticText;
    procedure SizeGrpClick(Sender: TObject);
    procedure CreateBtnClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure ExplainBtnClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
  public
    { Public declarations }
    clickcount:integer;
    sum:integer;
    sumstr:string;
    gridmask:array of array of integer;
    explainmode:boolean; {set when playing the matrix on the explaindlg form}
    val1, val2: array of integer;
    minval:integer; 
    procedure makegrid(sender:TStringGrid);
    procedure drawgrid;
  end;

var    Form1: TForm1;

implementation

uses U_Explain;

{$R *.DFM}

{**************** AdjustGridSize *************}
procedure adjustGridSize(grid:TStringGrid);
{Adjust borders of grid to just fit cells}
var   w,h,i:integer;
begin
  with grid do
  begin
    w:=0;
    for i:=0 to colcount-1 do w:=w+colwidths[i];
    width:=w;
    repeat width:=width+1 until fixedcols+visiblecolcount=colcount;
    h:=0;
    for i:=0 to rowcount-1 do h:=h+rowheights[i];
    height:=h;
    repeat height:=height+1 until fixedrows+visiblerowcount=rowcount;
    invalidate;
  end;
end;

{**************** SizeGrpClick ***********}
procedure TForm1.SizeGrpClick(Sender: TObject);
{user changed the matrix size}
begin
  with stringgrid1 do
  begin
    rowcount:=sizegrp.itemindex+3;
    colcount:=rowcount;
    adjustgridsize(stringgrid1);
    makegrid(stringgrid1);
  end;
end;

{********************* MakeGrid **************}
procedure Tform1.makegrid(sender:TStringGrid);
{Create a magic matrix in the StringGrid passed as "sender"}
var
  n, count, sum:integer;
  {val1, val2: array of integer;}
  i,j,range:integer;
  tries:integer;
begin
  tries:=0;
  repeat  {modification to generate only positive numbers, if possible}
    count:=sender.rowcount;
    setlength(gridmask,count,count);
    for i:=0 to count-1 do
    for j:=0 to count-1 do
    begin
      if explainmode and ((i=0) or (j=0)) then gridmask[i,j]:=2
      else gridmask[i,j]:=0;
    end;
    if explainmode then exit; {no need to generate values for explaination grid}
    resultlbl.caption:='';
    clickcount:=0;
    if explainmode then exit; {no need to generate values for explaination grid}

    setlength(val1,count);
    setlength(val2,count);
    n:= magicEdt.value;
    sum:=0;
    if n>10 then range:=n else range:=10;
    begin
      for i:=0 to count-1 do
      begin
        val1[i]:=random(range div 2)+1;
        sum:=sum+val1[i];
        if sum>n then
        begin
          val1[i]:=-val1[i];
          sum:=sum+2*val1[i];
        end;
        val2[i]:=random(range div 5)+1;
        sum:=sum+val2[i];
        if sum>n then
        begin
          val2[i]:=-val2[i];
          sum:=sum+2*val2[i];
        end;
      end;
      val2[count-1]:=n-sum+val2[count-1];
    end;
    {now generate the table}
    minval:=9999;
    with sender do
    for i:= 0 to colcount-1 do
    for j:=0 to rowcount-1 do
    begin
      cells[i,j]:=inttostr(val1[i]+val2[j]);
      if val1[i]<minval then minval:=val1[i];
      if val2[j]<minval then minval:=val2[j];
    end;
    inc(tries);
  until (tries>1000) or (minval>=0);{try 1000 times or until all numbers are >=0}
end;

procedure TForm1.drawgrid;
var i,j:integer;

begin
  with stringgrid1 do
  for i:= 0 to colcount-1 do
    for j:=0 to rowcount-1 do
    begin
      gridmask[i,j]:=0;
      cells[i,j]:=inttostr(val1[i]+val2[j]);
      (*
      if val1[i]<minval then minval:=val1[i];
      if val2[j]<minval then minval:=val2[j];
      *)
    end;
    resultlbl.caption:='';
 end;

{***************** CreateBtnClick *********}
procedure TForm1.CreateBtnClick(Sender: TObject);
begin
  makegrid(StringGrid1);
end;

{************** FormActivate *********}
procedure TForm1.FormActivate(Sender: TObject);
begin
  randomize;
  makegrid(stringgrid1);
  adjustgridsize(stringgrid1);
end;

{****************** StringGrid1Click *********}
procedure TForm1.StringGrid1Click(Sender: TObject);
{User clicked the grid -
  set gridmask to draw clicked cell with green background and
  blank out other cells in the same row and column.
  In "Explainmode" the grid is being shown with generating values displayed
  in row 0 and column 0, these values will be remain displayed as other cells
  are clicked.
 }

var
  x:integer;
  signval:string;
  i:integer;
  start:integer;
  lbl:TLabel;
begin
  with sender as Tstringgrid do
  if gridmask[col,row]=0 then {0 ==> clickable cell}
  begin
    if gridmask[col,row]=0 then
    if clickcount=0 then sumstr:='';;
    inc(clickcount);   {count the clicks}
    {add the clicked value to the equation being formed}
    x:=strtoint(cells[col,row]);
    sum:=sum+x;
    if x<0 then signval:='-' else signval:='+';
    signval:=signval+inttostr(abs(x));

    if explainmode then
    begin
      lbl:=Explaindlg.resultlbl;
      start:=1;
    end
    else
    begin
      lbl:=resultlbl;
      start:=0;
    end;

    sumstr:=sumstr+signval;
    if clickcount=rowcount-start then
    begin
      sumstr:=sumstr+'=' +inttostr(sum);
      clickcount:=0;
      sum:=0;
    end;
    if sumstr[1]='+' then sumstr[1]:=' ';
    lbl.caption:=Sumstr;
    gridmask[col,row]:=1;
    for i:=start to colcount-1 do if i<>col then gridmask[i,row]:=-1;
    for i:=start to rowcount-1 do if i<>row then gridmask[col,i]:=-1;
    invalidate; {force complete redraw of the grid cells}
  end;
end;

{************* StringGrid1DrawCll ***********}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
  var s:string;
{Draw cells based on current gridmask values}
begin
  with sender as Tstringgrid do
  begin
    if gridmask[acol,arow]<0 then Canvas.Brush.Color := clgray
    else if gridmask[acol,arow]=0 then Canvas.Brush.Color := clwindow
    else if gridmask[acol,arow]>1 then Canvas.Brush.Color := clyellow
    else Canvas.Brush.Color := cllime;
    Canvas.FillRect(Rect);
    s:=cells[acol,arow];
    if gridmask[acol,arow]>=0
    then canvas.textout(rect.left+2, rect.top+2,s);
  end;

end;

{**************** ExplainBtnClick **********}
procedure TForm1.ExplainBtnClick(Sender: TObject);
begin
  explainmode:=true;
  makegrid(ExplainDlg.stringgrid1); {make a grid and gridmask for the explaination matrix}
  ExplainDlg.showmodal;
  explainmode:=false;
  makegrid(stringgrid1);  {make the real matrix again}
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  drawgrid;
end;

procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

end.
