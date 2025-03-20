unit U_PrintTables;
{Copyright 2002,2012 Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
   stdctrls, grids, Menus, ComCtrls, shellAPI, U_PrintRoutines;

type
  TForm2 = class(TForm)
    MainMenu1: TMainMenu;
    Print1: TMenuItem;
    Exit1: TMenuItem;
    PrintDialog1: TPrintDialog;
    PrinterSetupDialog1: TPrinterSetupDialog;
    Memo1: TMemo;
    StaticText1: TStaticText;
    ScrollBox1: TScrollBox;
    procedure Print1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure buildtables;
    Procedure DrawGrids( c:TCanvas; size:TPoint);
    procedure TTClicked(Sender:Tobject);
    procedure GridDrawCell(Sender: TObject; ACol,
                            ARow: Integer; Rect: TRect; State: TGridDrawState);
end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

Uses Printers, Math, U_SolveUnit {, U_PrintRoutines};

{******************* DrawGrids ***************}
Procedure TForm2.Drawgrids(c:TCanvas; size:TPoint);
{Creat viewable stringgrid version of truth tables}
var
  index:integer;
  i,j,k1,k2:integer;
  lbl:TLabel;
  grid:TStringGrid;
  lastbottom:integer;
  lastright:integer;
  lastheight:integer;
  lasttop:integer;
  len:Integer;
begin
  lastright:=0;
  lasttop:=5; //memo1.top+memo1.height+5;
  lastbottom:=lasttop;
  lastheight:=0;
  visible:=false;
  //memo1.Clear;
  //memo1.lines.add('Size='+inttostr(size.x));
  for i:= 0 to variables.count-1 do
  for j:= 0 to variables.count-1 do
  if i<j then
  begin
    grid:=TStringgrid.create(scrollbox1);
    c.Font.Size:=10;

    lbl:=TLabel.create(scrollbox1);
    lbl.parent:=scrollbox1;
    with lbl do
    begin
      top:=lasttop;
      left:=lastright+10;
      if left>size.x then
      begin
        left:=10;
        top:=lastbottom+10;
      end;
      font.Size:=10;
      caption:= TVariabletype(variables.objects[i]).name
               +' vs '
               + Tvariabletype(variables.objects[j]).name;
    end;

    with grid do
    begin
      parent:=scrollbox1;
      onclick:=TTClicked;
      rowcount:=nbrvalues+1;
      colcount:=rowcount;
      fixedrows:=1;
      fixedcols:=1;
      canvas.font.Size:=10;
      defaultcolwidth:=20;
      defaultdrawing:=false;
      ondrawcell:=GridDrawCell;

      with variables.objects[i] as TVariabletype do
      for k1:=1 to values.count do
      begin
        cells[k1,0]:=values[k1-1];
        len:=c.Textwidth(cells[k1,0])+4;
        if len>colwidths[k1] then colwidths[k1]:=len;
      end;
      with variables.objects[j] as tvariabletype do
      for k1:=1 to values.count do
      begin
        cells[0,k1]:=values[k1-1];
        len:=c.Textwidth(cells[0,k1])+4;
        if len>colwidths[0] then colwidths[0]:=len;
      end;
      k1:=0;
      for k2:=0 to colcount-1 do k1:=k1+colwidths[k2];
      width:=k1+2*gridlinewidth*(colcount);
      k1:=0;
      for k2:=0 to rowcount-1 do k1:=k1+rowheights[k2];
      height:=k1+2*gridlinewidth*(rowcount);
      left:=lbl.left;
      if lbl.left+width>size.x then
      begin {set up next row}
        lastbottom:=lastbottom+lastheight+lbl.height+20;
        lbl.left:=10;
        lbl.top:=lastbottom;
      end;
      left:=lbl.left;
      top:=lbl.top+lbl.height+10;
      lastheight:=height;
      lasttop:=lbl.top;
      lastright:=left+width;
      index:=game.combolookup(i+1, j+1);
      tag:=index;
      if index>0 then
      for k1:= 1 to nbrvalues do
      for k2:= 1 to nbrvalues do
      cells[k1,k2]:= game.TruthTable[index,k1,k2];

      (*
      with memo1.lines do
      begin
        add(format('%s (%d,%d) (%d,%d) Last H:%d T:%d R:%d',
              [lbl.Caption, lbl.left, lbl.top, grid.left, grid.top, lastheight, lastTop, lastRight]));
      end;
      *)
    end;
  end;
  visible:=true;
end;

{******************* TTClicked **************}
procedure TForm2.TTClicked(sender:tobject);
{User clicks on truthtable - display reason entry for this cell}
begin
  memo1.Clear;
  if sender is TStringGrid then
  with sender as TStringGrid do
  if cells[col,row]<>'U'
  then
     if tag>0 then memo1.lines.add(game.reasons[tag,col,row])
     else memo1.Lines.add('Reason not recorded')
  else memo1.lines.add('Not resolved');
end;

{******************* BuidTables **************}
procedure TForm2.BuildTables;
{free all existing truthtable stringgrids and recreate them}
var  i:integer;
begin
  i:=0;
  with scrollbox1 do
  begin
    while i<= controlcount-1 do
    if (controls[i] is tlabel) or (controls[i] is TStringgrid)
    then controls[i].free else inc(i);
    //memo1.Lines.add('Width before='+inttostr(form2.width));
    windowstate:=wsmaximized;
    sleep(100);
    application.processmessages;
    //memo1.Lines.add('Width after='+inttostr(form2.width));
    width:=form2.clientwidth;
    Drawgrids (canvas, point(form2.clientwidth,9*{client}height div 10));
  end;
end;

{***************** Print1Click **************}
procedure TForm2.Print1Click(Sender: TObject);
var i:integer;
begin
  if printdialog1.execute then
  begin
    printer.orientation:=poLandscape;
    {Printer.Canvas.Font.Assign( Grid.Font );}
    Printer.Canvas.Font.Color :=clBlack;
    Printer.Canvas.Pen.Color := clBlack;
    printer.Begindoc;
    try
      with scrollbox1 do
      for i:= 0 to controlcount-1 do
      If (controls[i] is TLabel)
      then  PrintLabel(TLabel(controls[i]))
      else if (controls[i] is TStringGrid)
        then  PrintTable(TStringgrid(controls[i]));
    finally
      printer.enddoc;
    end;
  end;
end;

{******************* GridDrawCell **************}
 procedure TForm2.GridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
  {Control cell drawing}
begin
  with sender as TStringgrid do
  begin
    if gdfixed in  state then Canvas.Brush.Color := clbtnface
    else if gdfocused in state then Canvas.Brush.Color := clHighlight
    else Canvas.Brush.Color := clwindow;
    Canvas.FillRect(Rect);
    Canvas.textout(Rect.Left+2,Rect.Top+2,cells[acol,arow]);
  end;
end;

procedure TForm2.Exit1Click(Sender: TObject);
begin
  close;
end;

procedure TForm2.StaticText1Click(Sender: TObject);
begin
   ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;

procedure TForm2.FormResize(Sender: TObject);
begin
  form2.Width:=screen.Width;
  scrollbox1.width:=form2.clientwidth;
end;

end.
