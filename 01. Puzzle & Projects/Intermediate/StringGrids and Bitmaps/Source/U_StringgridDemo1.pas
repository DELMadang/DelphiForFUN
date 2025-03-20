unit U_StringgridDemo1;
{Copyright © 2013, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  shellAPI, StdCtrls, ExtCtrls, ComCtrls, jpeg,Grids;

type
  TForm1 = class(TForm)
    StaticText1: TStaticText;
    Panel1: TPanel;
    PageControl1: TPageControl;
    IntroSheet: TTabSheet;
    DemoSheet1: TTabSheet;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    Demosheet2: TTabSheet;
    Memo2: TMemo;
    StringGrid2: TStringGrid;
    DemoSheet3: TTabSheet;
    Memo3: TMemo;
    StringGrid3: TStringGrid;
    Image2: TImage;
    OpenBtn: TButton;
    DrawMode: TRadioGroup;
    OpenDialog1: TOpenDialog;
    Memo4: TMemo;
    PicLbl: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure StaticText1Click(Sender: TObject);
    procedure StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PageControl1Change(Sender: TObject);
    procedure StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure StringGrid3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure OpenBtnClick(Sender: TObject);
    procedure DemoSheet3Enter(Sender: TObject);
    procedure DemoSheet3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure DrawModeClick(Sender: TObject);
  private
    { Private declarations }
  public
    savecol,saverow:integer;
    saveCell:string;

    {Grid V3 fields}
    dir:string;
    B1:TBitmap;
    //prevcol,prevrow:integer;
    procedure loadnew(Fname:string);  {load new image from file Fname}
    procedure ClearGrid3;
end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{************** FormCreate **************}
procedure TForm1.FormCreate(Sender: TObject);
var c,r:integer;
begin
  {Make the Intropage the one displayed at startup time in case we forgot to
  reset it there after changes}
  Pagecontrol1.activepage:=IntroSheet;

  {Initialize the grids}
  randomize; {to make different grid values for each execution}
  with stringgrid1 do
  for c:=0 to colcount-1 do for r:=0 to rowcount-1 do cells[c,r]:=inttostr(random(100));
  with stringgrid2 do
  for c:=0 to colcount-1 do for r:=0 to rowcount-1 do cells[c,r]:=inttostr(random(100));

  {Initialization stuff for Grid3 demo - image painting}
  B1:=TBitmap.create;
  opendialog1.initialdir:=extractfilepath(application.exename);

  b1.Width:=Stringgrid3.width;
  b1.Height:=Stringgrid3.height;

  {Statement below doesn't work - Can't access bitmap of a preloaded Timage (?)}
  //with B1 do canvas.stretchdraw(rect(0,0,width,height),image2.picture.bitmap);

  LoadNew(OpenDialog1.InitialDir+'\'+'August Sunset from the back deck.jpg');
  Cleargrid3;
end;

{************* PageControl1Change ***********}
procedure TForm1.PageControl1Change(Sender: TObject);
begin
  savecol:=-1;  {reset initial value for each page change}
end;

{*********** StringGrid1MouseMove **********}
procedure TForm1.StringGrid1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  with stringgrid1 do
  begin
    mouseToCell(x,y,savecol,saverow);
    invalidate;  {redraw entire grid on each mouse move}
  end;
end;

{*************** StringGrid1DrawCell ****************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with stringgrid1, canvas do
  begin
    if (acol=savecol) and (arow=saverow)
    then brush.color:=clyellow else brush.color:=clWhite;
    rectangle(rect);
    with rect do textout(left+4, top+4, cells[acol,arow]);
  end;
end;

{*********** StringGrid2MouseMove **********}
procedure TForm1.StringGrid2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  newcol,newrow:integer;  
begin
  stringGrid2.mouseToCell(x,y,newcol,newrow);
  if (newcol>=0) and (newrow>=0) {mouse is on the grid and on a cell within the grid}
    and ((savecol<>newcol) or (saverow<>newrow)) {and location not the same as previous entry}
  then
  with stringgrid2 do
  begin

    if savecol>=0 then  {there has been a prior entry to this cell}
    begin {Savecol and Saverow point to the previous cell occupied by the mouse cursor. }
      {Reset its value back to the original value}
      cells[savecol,saverow]:=savecell;
    end;
    savecol:=newcol; saverow:=newrow;  {save the new current values}
    savecell:=cells[savecol,saverow];
    cells[savecol,saverow]:='!!!!';{temporarily change the text of the new current cell}

    update;  {redraw changed cells only, typically put the original value back in
              the previous cell and highlight and change text of the current cell}
  end;
end;

{*************** StringGrid2DrawCell ****************}
procedure TForm1.StringGrid2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with stringgrid2, canvas do
  begin
    if (acol=savecol) and (arow=saverow)
    then brush.color:=clyellow else brush.color:=clWhite;
    rectangle(rect);
    with rect do textout(left+4, top+4, cells[acol,arow]);
  end;
end;

{*********** StringGrid3MouseMove **********}
procedure TForm1.StringGrid3MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  newcol,newrow:integer;
begin
  StringGrid3.MouseToCell(x,y,newcol,newrow);
  if (newcol>=0) and (newrow>=0) {mouse is on the grid and on a cell within the grid}
    and ((savecol<>newcol) or (saverow<>newrow)) {and location not the same as previous entry}
  then
  with stringgrid3 do
  begin


    with stringgrid3 do
    begin   {we are in a new cell, refresh it one time}
      savecol:=newcol; saverow:=newrow;
      if (Drawmode.itemindex=1) and (cells[Savecol,Saverow]='E')
      then Stringgrid3.cells[Savecol,Saverow]:='P'
      else Stringgrid3.cells[Savecol,Saverow]:='E';
      //prevcol:=savecol;  {Save the cell location so that we do not load the picture}
      //prevrow:=saverow;  {segment again while the mouse moves around within it}
      update;
    end;
    update;  {redraw changed cells only}
  end;
end;

{*************** StringGrid3DrawCell ****************}
procedure TForm1.StringGrid3DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  with stringgrid3, canvas do
  begin
    if cells[Acol,Arow]='E'  then copyrect(rect, b1.canvas, rect)
    else
    begin
      brush.color:=color;
      rectangle(rect);
    end;
  end;
end;

{********** ClearGrid ***********}
procedure TForm1.cleargrid3;
  var i,j:integer;
  begin
    {fill cells with P to prevent initial DrawCell entry from filling in the picture}
    with stringgrid3 do
    for i:=0 to colcount-1 do for j:=0 to rowcount-1 do cells[i,j]:='P';
    {stretch image to bitmap B1 for easy transfer of pieces to the stringgrid}
    with B1 do canvas.stretchdraw(rect(0,0,width,height),image2.picture.bitmap);
  end;

{************* Loadnew ***********}
procedure TForm1.loadnew(Fname:string);
{Load image from filename  "Fname"  into Image2 and bitmap B1}
var
  jpeg:TJPegImage;
  s:string;
begin
  s:=uppercase(extractfileext(fname));
  if s='.JPG' then
  begin
    jpeg:=TJPegImage.create;
    jpeg.loadfromfile(fname);
    image2.picture.bitmap.assign(jpeg);
    jpeg.free;
  end
  else Image2.picture.LoadFromFile(Fname);
  image2.update;
  PicLbl.Caption:=extractfilename(FName);
  Cleargrid3;
end;

{************* OpenBtnClick *************88}
procedure TForm1.OpenBtnClick(Sender: TObject);
begin
  {Load an image to "paint" to the version 3 grid}
  if opendialog1.execute then Loadnew(opendialog1.filename);
end;

{***********DemoSheet3Enter ***********}
procedure TForm1.DemoSheet3Enter(Sender: TObject);
begin
  cleargrid3;{initialize the grid}
end;

{************* DrawMode ****************}
procedure TForm1.DrawModeClick(Sender: TObject);
{Re-initialized the grid when paint style changes}
var i:integer;
begin
  Cleargrid3;
  If drawmode.itemindex =1 then {If Tricky mode, preload a few random cell images}
  with stringgrid3 do
  begin
     for i:= 1 to 4 do cells[random(colcount), random(rowcount)]:= 'E';
     update;
   end;
end;

{************* DemoSheet3MouseMove ************}
procedure TForm1.DemoSheet3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  //prevcol:=-1;  {Ensure that next entry to grid gets recognized as new}
end;


procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;



end.
