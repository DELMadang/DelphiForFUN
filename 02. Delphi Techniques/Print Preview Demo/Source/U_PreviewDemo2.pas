Unit U_PreviewDemo2;
{Copyright  © 2004,2007 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {Demonstrates some features of a TPrintPreview unit}
 { Version 2.1 adds margin controls}
 {Version 2.2 adds a Margin Test button and fixes some
  margin errors. }
 {Version 2.3:  Margins which extend into the non-printable
  area are now displayed in red.}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Grids, printers, UPrintPreview2, Spin, UDFFSpinEdit;

type
  TForm1 = class(TForm)
    PreviewBtn: TButton;
    Memo1: TMemo;
    StringGrid1: TStringGrid;
    StaticText1: TStaticText;
    PrinterSetupDialog1: TPrinterSetupDialog;
    PrintDialog1: TPrintDialog;
    SetupBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MarginChkBtn: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    procedure PreviewBtnClick(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
                                  Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure PrintDialog1Show(Sender: TObject);
    procedure MarginChkBtnClick(Sender: TObject);
    procedure SetupBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SetminMarginColors(Sender: TObject);
  public
    { Public declarations }
    Initialized:boolean;
    TopMargin:TDFFSpinEdit;
    LeftMargin:TDFFSpinEdit;
    BottomMargin:TDFFSpinEdit;
    RightMargin:TDFFSpinEdit;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

{*************** FormCreate ************8}
procedure TForm1.FormCreate(Sender: TObject);
begin
  
end;

{************* FormActivate ***************}
procedure TForm1.FormActivate(Sender: TObject);
var i,j:integer;
{Initialize the stringgrid cells with random numbers and letters}
begin
  randomize;
  with stringgrid1 do
  begin
    {Turning off default drawing will allow the programmer to set cell color
    in the OnDrawCell exit}
    defaultdrawing:=false; {could also be set in the Object Inspector}

    for i:=0 to colcount-1 do
    for j:=0 to rowcount-1 do
    begin
      if (i=0) and (j=0) then cells[i,j]:=''
      else if (j=0) and (i>0) then cells[i,j]:='Column '+inttostr(i)
      else if (i=0) and (j>0) then cells[i,j]:='Row '+inttostr(j)
      else
      begin
        if random(3)=0 then cells[i,j]:=inttostr(random(1000)) {about 1/3 will be numbers}
        else cells[i,j]:= char(ord('A')+random(26)); {and 2/3 will be letters}
      end;
    end;
  end;
  printpreview.newjob;
  TopMargin:=TDFFSpinedit.create(Edit1,0,10,100);
  TopMargin.Name:='TopMargin';
  LeftMargin:=TDFFSpinedit.create(Edit2,0,10,100);
  Leftmargin.Name:='LeftMargin';
  BottomMargin:=TDFFSpinedit.create(Edit3,0,10,100);
  Bottommargin.Name:='BottomMargin';
  RightMargin:=TDFFSpinedit.create(Edit4,0,10,100);
  Rightmargin.name:='RightMargin';
  Initialized:=true;

end;

{************* PreviewBtnClick ***********}
procedure TForm1.PreviewBtnClick(Sender: TObject);
var
  r : TRect;
  newheight:integer;
  lastchar:integer;
  rlist:TStringlist;
begin
  if printer.printing then printer.abort;
  rlist:=TStringlist.create;
  rlist.text:=memo1.text;
  try
    with PrintPreview, marginrect do
    begin
      NewJob;
      setInchmargins(Leftmargin.value/10,    {Left}
                     TopMargin.value/10,     {Top}
                     Rightmargin.value/10,   {Right}
                     BottomMargin.value/10); {Bottom}

      (*
      Top := YInch({1}0.0+TopMargin.value/10);
      Left := XInch({1}Leftmargin.value/10);
      right:=printer.pagewidth-xinch({7.5}Rightmargin.value/10);
      Bottom := printer.pageheight-YInch({10} BottomMargin.value/10);
      *)
      r:=rect(0,0,right-left, bottom-top); {our boundaries relative to margins}
    end;

    with PrintPreview, r do
    begin
      {Stringgrid 1" down from top of page, etc.}

      stringgridOut({the stringgrid}Stringgrid1,
                    {the target width}right-left,
                    {the origin} point(0,0),
                    {show the grid lines} true,
                    {show the data in cells} true,
                    {newheight= returned height of on last page displayed grid
                     in pixels}
                     newheight);

      {set top of memo at bottom of grid + 1/2 inch}
      r.top:=r.top+newheight+YInch(0.5)  {half inch below grid};
      {let it use the rest of the page}

      newheight:=memoOut({the bounding rectangle}r ,
                         {the text strings} rlist,
                         {the font}  memo1.font,
                         {the position of the last character displayed} lastchar,
                         {whether to removed displayed text from the input list} true);

      while rlist.count>0 do  {if didn't fit on page 2, loop until all printed}
      begin
        newpage;             {so put the rest on the page 3, etc}
        r.top:=yinch(0);
        r.bottom:=yinch(marginrect.bottom-marginrect.top);
        newheight:=memoOut(r, rlist, memo1.font, lastchar, true);
      end;

      {Print another copy of memo at a different width}
      right:=XInch(3); {make it narrow (3" wide)}
      top:=top + newheight + yinch(0.5);

      rlist.text:=memo1.text;
      rlist.insert(0,'This is a second copy of the text in narrow format');
      rlist.insert(1,'');

      newheight:=memoOut(r, rlist, memo1.font, lastchar, true);

      while rlist.count>0 do  {if didn't fit on page, loop until all printed}
      begin
        newpage;             {so put the rest on the page 3, etc}
        r.top:=yinch(0);
        //r.bottom:=yinch(9);
        r.bottom:=yinch(marginrect.bottom-marginrect.top);
        newheight:=memoOut(r, rlist, memo1.font, lastchar, true);
      end;

      top:=top+newheight + yinch(0.5); {drop down 1/2"}

     {Put the stringgrid out again}
      stringgridOut(Stringgrid1,xinch(4),point(0,top),
                   true,true,newheight);

    end;
    finally
      rlist.free;
  end;


  if Sender = PreviewBtn  then
  begin
    PrintPreview.Preview;
    PrintPreview.showmodal;
  end;
end;

{**************** Stringgrid1DrawCell ****************}
procedure TForm1.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
{OnDrawCell exit which handles calls fron TStringGrid and from StringGridOut
 procedure in PrintPreview unit.  StringGridOut replaces the Sender field which
 normally points to the  StringGrid  with a TList conbtaining two addresses:
 the TStringgrid pointer in TList[0] and the MetaFileCanvas to be used for
 drawing in TList[1]
}
 var
    PCan:TCanvas; {canvas to draw on}
    grid:TStringgrid; {the grid containing the cell to draw}
    offsetx, offsety:integer;
    n:integer;
    savecolor:TColor;
    savestyle:TFontStyles;
begin
  {start text 10% of rectangle size from left edge and top}
  offsetx:= (rect.right-rect.left) div 10;
  offsety:=(rect.bottom-rect.top) div 10;
  if sender is TStringgrid then
  begin
    PCan:=TStringGrid(sender).canvas;
    Grid:=TStringGrid(sender);
  end
  else
  if (sender is TList) then
  {this is an entry from printpreview and we must draw on a different canvas
   passed to us by that unit}
  begin
    Grid:=TStringgrid(TList(sender)[0]);
    PCan:=TCanvas(TList(sender)[1]);
  end
  else exit;

  If Pcan<>nil then
  with Pcan, Grid do
  begin
    if (acol=2) and (arow=2) then pcan.brush.color:=clLime
    else pcan.brush.color:=clwhite;
    if (acol<fixedcols) or (arow<fixedrows)
    then pcan.brush.color:=fixedcolor;
    pcan.fillrect(rect);      {clear the grid}
    n:=strtointdef(cells[acol,arow],maxint); {test if it's number}
    if n<>maxint then
    begin
      savecolor:=pcan.font.color;
      savestyle:=pcan.font.style;
      pcan.font.color:=clred;
      pcan.font.style:=font.style+[fsUnderline,fsbold];
    end;
    pcan.textout(rect.left+offsetx, rect.top+offsety, cells[acol,arow]);
    if n<>maxint then
    begin
      pcan.font.color:=savecolor;
      pcan.font.style:=savestyle;
    end;
  end;
end;



procedure TForm1.PrintDialog1Show(Sender: TObject);
begin
  if printer.printing then printer.abort;
end;

{************ MarginChkBtnClick *********}
procedure TForm1.MarginChkBtnClick(Sender: TObject);
//var
//  p : TPoint;
begin
  if printer.printing then printer.abort;
  with PrintPreview, marginrect do
  begin
    NewJob;
    SetInchmargins(Leftmargin.value/10,TopMargin.value/10,

                   Rightmargin.value/10,Bottommargin.value/10);
    font.size:=24;
    textout(left,top,'Top Left');
    textoutright(right,top,'Top Right');
    textout(left,bottom-textheight(Text),'Bottom Left');
    textoutright(right,bottom-textheight(Text),'Bottom Right');
    Preview;
    showmodal;
  end;
end;

procedure TForm1.SetupBtnClick(Sender: TObject);
begin
  printersetupdialog1.execute;
  SetMinMarginColors(self);
end;

{**************** SetMinMarginColors ****************}
procedure TForm1.SetMinMarginColors(sender:TObject);
begin
  if (sender is TDFFSpinedit) then
  with Printpreview, TDFFSpinEdit(sender) do
  begin
    case upcase(name[1]) of
    {Left}
    'L':if value/10*Pxppi<xoff then font.Color:=clred else font.Color:=clblack;
    {Right}
    'R':if value/10*Pxppi<(Pagesize.x-Printsize.x-xoff)
        then font.Color:=clred else font.Color:=clblack;
    {Top}
    'T':if value/10*Pyppi<yoff then font.Color:=clred else font.Color:=clblack;
    {Bott'om}
    'B':if value/10*Pyppi<(Pagesize.y-Printsize.y-yoff)
        then font.Color:=clred else font.Color:=clblack;
    end;
  end;
end;




end.
