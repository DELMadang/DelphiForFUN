unit UPrintPreview2;

 {Copyright  © 2004,2008 Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

 {A print preview unit that displays and  prints TMemo and TStringgrid data.
 Pages may be saved and restored for layter printing.}

 {The original version of thes unit was posted in 1996 by Ryan Peterson, address
  unknown. Only the features used in U_PreviewDemo unit have been tested}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, StdCtrls, Printers, Dialogs, ExtCtrls, Grids, Buttons;

type

  TPrintpreview = class(TForm)
    Panel1: TPanel;
    PrintBtn: TButton;
    Button6: TButton;
    Panel2: TPanel;
    PageWidthBtn: TButton;
    FullPageBtn: TButton;
    sb: TScrollBox;
    PaintBox1: TPaintBox;
    SaveBtn: TButton;
    ShowGridBtn: TButton;
    LoadBtn: TButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Label1: TLabel;
    PrintDialog1: TPrintDialog;
    FirstBtn: TBitBtn;
    PriorBtn: TBitBtn;
    NextBtn: TBitBtn;
    LastBtn: TBitBtn;
    procedure PrintBtnClick(Sender: TObject);
    procedure FirstBtnClick(Sender: TObject);
    procedure PriorBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
    procedure LastBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FullPageBtnClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure PageWidthBtnClick(Sender: TObject);
    procedure ShwGrdBtnClick(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SaveBtnClick(Sender: TObject);
    procedure LoadBtnClick(Sender: TObject);
    procedure PrintDialog1Show(Sender: TObject);
  private
    { Private declarations }
    PageDisplaying : Integer;
    FCurrentPage : Integer;
    FCanvases : TList;
    FDonePrinting : Boolean;
    FMetafiles : TList;
    FOrientation : TPrinterOrientation;

    function  GetPageCount : Integer;
    procedure SetCurrentPage(Index : Integer);
    function  GetCanvas(Index : Integer): TMetafileCanvas;
    function  GetMetafile(Index : Integer): TMetafile;
    function  GetFont : TFont;
    procedure SetFont(Value : TFont);
    function  GetPen : TPen;
    procedure SetPen(Value : TPen);
    procedure SetOrientation(Value : TPrinterOrientation);

  public
    { Public declarations }
    pXppi : Integer;
    pYppi : Integer;
    XOff : Integer;
    YOff : Integer;
    marginrect:Trect; {Printing area rectangle}
    Title : String;

    DrawList:TList;
    function PageSize : TPoint;
    function PrintSize : TPoint;
    procedure PrintPage(const PageNum : Integer);
    procedure PrintAll;
    procedure Preview;
    procedure SaveToFile(const filename : String);
    procedure LoadFromFile(const filename : String);
    procedure DisplayPage(Page : Integer);
    function  XInch(const aSingle : Single): Integer;
    function  YInch(const aSingle : Single): Integer;
    procedure TextOut(const X, Y : Integer; const Text : String);
    procedure TextOutRight(const X, Y : Integer; const Text : String);
    procedure TextOutCenter(const X, Y : Integer; const Text : String);
    procedure ExtTextOut(const X, Y : Integer; const Right : Integer;
                         const Text : String);
    procedure ExtTextOutRight(const X, Y : Integer; const Left : Integer;
                              const Text : String);
    procedure ExtTextOutCenter(const X, Y : Integer; const Left, Right : Integer;
                               const Text : String);
    procedure TextRect(const aRect:TRect; const X,Y:Integer;const Text:String);
    function  TextWidth(const Text : String): Integer;
    function  TextHeight: Integer; overload;
    function  TextHeight(const text:string) : Integer; overload;
    procedure Line(const a, b : TPoint);
    procedure Rectangle(const aRect : TRect);
    procedure SetPixelMargins(L,T,R,B:integer);
    procedure SetInchMargins(L,T,R,B:single);

    function  MemoOut(const aRect : TRect;
                           memolines:TStringlist;
                           memofont:TFont;
                           var LastCharDisplayed:integer;
                               Returnremainder:boolean ): Integer;
    procedure StringGridOut(Grid:TStringgrid; scaledpixelwidth:integer;
                            origin:TPoint; showgrid,showdata:boolean;
                            var returnedheight:integer);
    function getgridHeight(grid:TStringGrid;newwidth:integer):integer;
    procedure PutPageNums(const X, Y : Integer; Alignment : TAlignment);
    procedure NewJob;
    procedure DonePrinting;
    function  NewPage : Integer;
    destructor Destroy; override;
    property PageCount : Integer  read GetPageCount;
    property CurrentPage : Integer read FCurrentPage write SetCurrentPage;
    property Canvases[Index : Integer] : TMetafileCanvas read GetCanvas;
    property Metafiles[Index : Integer] : TMetafile read GetMetafile;
    property Font : TFont read GetFont write SetFont;
    property Pen : TPen read GetPen write SetPen;
    property Orientation : TPrinterOrientation read  FOrientation
                                               write SetOrientation;
  end;

var PrintPreview:TPrintpreview;

implementation

{$R *.DFM}

{Private methods use to set/get property values}

{*********** GetPageCount ************}
function TPrintPreview.GetPageCount : Integer;
begin
  Result := FCanvases.Count;
end;

{************** SetCurrentpage **********}
procedure TPrintPreview.SetCurrentPage(Index : Integer);
begin
if (Index <= PageCount) AND (Index > 0) then
  FCurrentPage := Index;
end;

{**************** GetCanvas ***********}
function TPrintPreview.GetCanvas(Index : Integer): TMetafileCanvas;
begin
  if (Index > 0) AND (Index <= PageCount) then
  Result := TMetafileCanvas(FCanvases[Index - 1]) else
  Result := nil;
end;

{****************** GetMetafile **********}
function TPrintPreview.GetMetafile(Index : Integer): TMetafile;
begin
if (Index > 0) AND (Index <= PageCount) AND FDonePrinting then
  Result := TMetafile(FMetafiles[Index - 1]) else
  Result := nil;
end;

{************** GetFont ***********}
function TPrintPreview.GetFont : TFont;
begin
Result := Canvases[CurrentPage].Font;
end;

{*************** SetFont ***********}
procedure TPrintPreview.SetFont(Value : TFont);
begin
Canvases[CurrentPage].Font := Value;
end;

{***************** GetPen ***********}
function TPrintPreview.GetPen : TPen;
begin
Result := Canvases[CurrentPage].Pen;
end;

{*************** SetPen **********}
procedure TPrintPreview.SetPen(Value : TPen);
begin
  Canvases[CurrentPage].Pen := Value;
end;

{****************** SetOrientation ***********}
procedure TPrintPreview.SetOrientation(Value : TPrinterOrientation);
begin
FOrientation := Value;
Printer.Orientation := Value;
end;

{************* Pagesize ***********}
function TPrintPreview.PageSize : TPoint;
{Physical size of page including the non-printable border area}
begin
Escape(Printer.Handle, GETPHYSPAGESIZE, 0, nil, @Result);
end;

{************ PrintSize ***********}
function TPrintPreview.PrintSize : TPoint;
{Dimensions of printed page area that can be printed}
begin
Result.X := Printer.PageWidth;
Result.Y := Printer.PageHeight;
end;

{************** PrintPage ***********}
procedure TPrintPreview.PrintPage(const PageNum : Integer);
begin
  if not FDonePrinting then DonePrinting;

  if (PageNum > 0) AND (PageNum <= PageCount) then
  begin
    Printer.Title := Title;
    if not printer.printing then Printer.BeginDoc;
    try
      Panel2.Caption := Format('Printing page %d of %d', [PageNum, PageCount]);
      Printer.Canvas.StretchDraw(
           Rect(0,0,Printer.PageWidth, Printer.PageHeight), Metafiles[PageNum]);
    finally
      
    end;
  end;
end;

{************ PrintAll **************}
procedure TPrintPreview.PrintAll;
{Print all pages}
var
 i : Integer;
 s : String;
 adjustedrect:Trect;
begin
  if not FDonePrinting then DonePrinting;
  if PageCount > 0 then
  begin
    Printer.Title := Title;
    if not Printer.Printing then Printer.BeginDoc;
    i := 1;
    s := Panel2.Caption;
    try
      for i := 1 to PageCount do
      begin
        Panel2.Caption := Format('Printing page %d of %d',
          [i, PageCount]);
        if i>1 then Printer.NewPage;
        Printer.Canvas.StretchDraw(
           Rect(0,0,Printer.PageWidth, Printer.PageHeight), Metafiles[i]);
      end;
      finally
        Printer.EndDoc;
        Panel2.Caption := s;
    end;
  end;
end;


{************ Preview **********}
procedure TPrintPreview.Preview;
begin
  if not FDonePrinting then DonePrinting;
  fullpagebtnclick(self);
  displaypage(1);
end;

{************* SaveToFile *************}
procedure TPrintPreview.SaveToFile(const filename : String);
var
 i : integer;
 stream:TFilestream;
begin
  if FDonePrinting then
  begin
    stream:=TFileStream.create(filename,fmCreate );
    with stream do
    begin
      i:=pagecount;
      write(i,sizeof(i));
      for i := 0 to pagecount-1 do
      begin
         TMetafile(Fmetafiles[i]).SaveTostream(stream);
      end;
    end;
    stream.free;
  end;
end;

{************* LoadFromFile *************}
procedure TPrintPreview.LoadFromFile(const filename : String);
var
 i ,n: integer;
 stream:TFilestream;
begin
  if printer.printing then printer.abort;
  if FDonePrinting then
  begin
    stream:=TFilestream.create(filename,fmopenread or fmsharecompat);
    newjob;
    with stream do
    begin
      read(n,sizeof(n));
      for i:=0 to n-1 do
      begin
        TMetafile(FMetafiles[i]).loadfromstream(stream);
        {restore the metafileCanvas}
        TMetafilecanvas(FCanvases[i]).draw(0,0,TMetafile(Fmetafiles[i]));
        if i<n-1 then newpage;
      end;
    end;
    stream.free;
    if not FDonePrinting then DonePrinting;
    displaypage(1);
  end;
end;

{************ DisplayPage ************}
procedure TPrintPreview.DisplayPage(Page : Integer);
var
  p : TPoint;
  Sc : extended;
  rfull:TRect;    {maximum printable are rectangle}
  rprint : TRect; {current printable area rectangle using margin settings}
  i : integer;
begin
  if (Page > 0) AND (Page <= PageCount) then
  begin
    Sc := PaintBox1.Width / PageSize.X; {scaling}
    PaintBox1.Canvas.Rectangle(0,0,PaintBox1.Width, PaintBox1.Height);
    PaintBox1.Canvas.FillRect(Rect(1,1,PaintBox1.Width-2,PaintBox1.Height-2));
    Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @p);
    with rfull do
    begin
      Left := Trunc(p.X * Sc);
      Top := Trunc(p.Y * Sc);
      right:=Trunc((pagesize.x-p.x)*sc);
      bottom:=Trunc((pagesize.y-p.y)*sc);
    end;
    with rprint do
    begin
      left:=trunc((marginrect.left-xoff)*sc);
      top:=trunc((marginrect.top-yoff)*sc);
      right:=trunc((marginrect.right+xoff)*sc);
      bottom:=trunc((marginrect.bottom+yoff)*sc);
    end;
    if ShowgridBtn.Caption[1] = 'H' then
    begin
      with PaintBox1.Canvas do
      begin
        Pen.Style := psDash;
        pen.color:=clblack;
        for i := 1 to (Self.PageSize.X) div Self.pXppi do
        begin
          MoveTo(Trunc(i * Self.pXppi * Sc), 0);
          LineTo(Trunc(i * Self.pXppi * Sc), Trunc((PageSize.Y) * Sc));
        end;
        for i := 1 to Self.PageSize.Y div Self.pYppi do
        begin
          MoveTo(0, Trunc(i * Self.pYppi * Sc));
          LineTo(Trunc(PageSize.X * Sc), Trunc(i * Self.pYppi * Sc));
        end;
        brush.style:=BSClear;
        pen.color:=clred;
        with rfull do polygon([topleft, point(right,top), bottomright, point(left,bottom)]);
        pen.color:=clblue;
        with rprint do polygon([topleft, point(right,top), bottomright, point(left,bottom)]);
        pen.color:=clblack;
        brush.style:=BSSolid;
      end;
    end;

    with PaintBox1 do Canvas.StretchDraw(rect(0,0,width,height), Metafiles[Page]);
    Panel2.Caption := Format('Page %d of %d', [Page, PageCount]);
    PageDisplaying := Page;
    if Page = 1 then
    begin
      FirstBtn.Enabled := False;
      PriorBtn.Enabled := False;
    end else
    begin
      FirstBtn.Enabled := True;
      PriorBtn.Enabled := True;
    end;
    if PageCount > Page then
    begin
      NextBtn.Enabled := True;
      LastBtn.Enabled := True;
    end else
    begin
      NextBtn.Enabled := False;
      LastBtn.Enabled := False;
    end;
  end;
end;


{**************** XInch *************}
function TPrintPreview.XInch(const aSingle : Single): Integer;
begin
  Result := Trunc(pXppi * aSingle);
end;

{************* YInch **********}
function TPrintPreview.YInch(const aSingle : Single): Integer;
begin
  Result := Trunc(pYppi * aSingle);
end;

{*********** TextOut *********}
procedure TPrintPreview.TextOut(const X, Y : Integer; const Text : String);
begin
  if (FCurrentPage > 0) AND (not FDonePrinting)
  then  with Canvases[FCurrentPage] do TextOut(X - XOff, Y - YOff, Text);
end;

{*********** TextOutRight *********8}
procedure TPrintPreview.TextOutRight(const X, Y : Integer; const Text : String);
begin
  if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    TextOut(X - Self.TextWidth(Text) - XOff, Y - YOff, Text);
end;

{*********** TextOutCenter ***********}
procedure TPrintPreview.TextOutCenter(const X, Y : Integer; const Text : String);
begin
if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    TextOut(X - (Self.TextWidth(Text) div 2) - XOff, Y - YOff, Text);
end;

{***************** ExttextOut ************}
procedure TPrintPreview.ExtTextOut(const X, Y, Right : Integer;
 const Text : String);
begin
if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    TextRect(Rect(X - XOff, Y - YOff, Right - XOff,
      Y + (Self.TextHeight * 2) - YOff), X - XOff, Y - YOff, Text);
end;

{**************** ExtTextOutRight ***************}
procedure TPrintPreview.ExtTextOutRight(const X, Y, Left : Integer;
 const Text : String);
begin
if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    TextRect(Rect(Left - XOff, Y - YOff, X - XOff,
      Y + (Self.TextHeight * 2) - YOff), X - Self.TextWidth(Text) - XOff,
      Y - YOff, Text);
end;

{**************** ExtTextOutCenter *************}
procedure TPrintPreview.ExtTextOutCenter(const X, Y, Left, Right : Integer;
 const Text : String);
begin
if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    TextRect(Rect(Left - XOff, Y - YOff, Right - XOff,
      Y + (Self.TextHeight * 2) - YOff), X - (Self.TextWidth(Text) div 2) - XOff,
      Y - YOff, Text);
end;

{****************** TextRect ***************}
procedure TPrintPreview.TextRect(const aRect : TRect; const X, Y : Integer;
  const Text : String);
begin
if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    TextRect(Rect(aRect.Left - XOff, aRect.Top - YOff, aRect.Right - XOff,
                   aRect.Bottom - YOff), X - XOff, Y - YOff, Text);
end;

{************** TextWidth ***********}
function TPrintPreview.TextWidth(const Text : String): Integer;
begin
  if (FCurrentPage > 0) AND (not FDonePrinting) then
  begin
    Printer.Canvas.Font := Canvases[FCurrentPage].Font;
    Result := Printer.Canvas.TextWidth(Text);
  end
  else Result := -1;
end;

{************* TextHeight ************}
function TPrintPreview.TextHeight: Integer;
begin
  result:=textheight('Xp');
end;

{*********** TextHeight(text) ***********}
function TPrintPreview.TextHeight(const text:string): Integer;
begin
  if (FCurrentPage > 0) AND (not FDonePrinting) then
  begin
    Printer.Canvas.Font := Canvases[FCurrentPage].Font;
    Result := Printer.Canvas.TextHeight('Xp');
  end
  else Result := -1;
end;

{************** Line ************}
procedure TPrintPreview.Line(const a, b : TPoint);
begin
  if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
  begin
    MoveTo(a.X - XOff, a.Y - YOff);
    LineTo(b.X - XOff, b.Y - YOff);
  end;
end;

{**************** Rectangle ***********}
procedure TPrintPreview.Rectangle(const aRect : TRect);
begin
if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
    Rectangle(aRect.Left - XOff, aRect.Top - YOff, aRect.Right - XOff,
       aRect.Bottom - YOff);
end;

procedure TPrintpreview.SetPixelMargins(L,T,R,B:integer);
{Set pixel margins in Marginrect}
begin
  with marginrect do
  begin
    {marginrect defines corners of printable area relative to (0,0)}
    Left := L+xoff;
    Top := T+yoff;
    right:=pagesize.x-xoff-R;
    Bottom :=pagesize.y-yoff-B;
  end;
end;

procedure TPrintPreview.SetInchMargins(L,T,R,B:single);
begin
  Setpixelmargins(XInch(L), YInch(T), XInch(R), YInch(B));
end;

{************* MemoOut **************}
function TPrintPreview.MemoOut(const aRect : TRect;
                           memolines:TStringlist;
                           memofont:TFont;
                           var LastCharDisplayed:integer;
                               Returnremainder:boolean ): Integer;
var
  r : TRect;
  p:Pchar;
  DrawTextParams:TDrawtextParams;
  w,h:integer;
begin
  r := aRect;

  Dec(r.Left, XOff);
  Dec(r.Right, XOff);
  Dec(r.Top, YOff);
  Dec(r.Bottom, YOff);


  w:=r.right-r.left;
  h:=r.bottom-r.top;

  Inc(r.Left, marginrect.left);
  r.Right:=r.left+w;
  if r.right>marginrect.right then r.right:=marginrect.right;
  Inc(r.Top, marginrect.top);
  r.Bottom:=r.top+h;
  if r.bottom>marginrect.bottom then r.bottom:=marginrect.bottom;


  if (FCurrentPage > 0) AND (not FDonePrinting) then
  begin
    p:=memolines.gettext;
    canvases[FcurrentPage].font.assign(memofont);
    with DrawTextParams do
    begin
      cbsize:=sizeof(Drawtextparams);
      iTablength:=0;
      iLeftMargin:=0;
      iRightMargin:=0;
    end;
    Result := DrawTextex(Canvases[FCurrentPage].Handle,
                            p, Length(p), R, DT_EXPANDTABS or
                           DT_NOPREFIX or DT_WORDBREAK or DT_EDITCONTROL,
                           @DrawtextParams);
    lastcharDisplayed:=drawtextparams.uiLengthdrawn;
    if returnremainder then
    begin
      if lastcharDisplayed<length(memolines.text) then
      begin
        memolines.text:=copy(memolines.text, lastchardisplayed+1,
                               length(memolines.text)-lastchardisplayed);
      end
      else memolines.clear;
    end;
    StrDispose(p);
  end;
end;

{****************** GetGridHeight *************}
function TPrintPreview.getgridHeight(grid:TStringGrid;newwidth:integer):integer;
var
  scale:extended;
  i, gridlinewidth:integer;
begin
  with Canvases[FCurrentPage] do
  begin
    scale:=newwidth/grid.width;
    gridlinewidth:=round(scale*grid.gridlinewidth);
    if gridlinewidth=0 then gridlinewidth:=1;
    {get actual height}
    result:=0;
    for i:=1 to grid.rowcount do
      result:=result+round(scale*grid.rowheights[i-1])+gridlinewidth;
  end;
end;

{***************** StrinGridOut ***************}
procedure TPrintPreview.StringGridOut(Grid:TStringgrid; scaledpixelwidth:integer;
                                     origin:TPoint; showgrid,showdata:boolean;
                                     var returnedheight:integer);
{draw passed stringgrid on a canvas}
var
  scale:extended;
  newheight:extended; {increment for current line (unscaled)}

    {------------- AssignVisuals ------------}
    procedure assignvisuals;
    {Scale font, pen and brush}
    begin
      with canvases[fcurrentpage] do
      begin
        font.assign(grid.font);
        font.height:=trunc(scale*grid.font.height);

        brush.assign(grid.brush);

        pen.assign(grid.canvas.pen);
        pen.width:=trunc(grid.gridlinewidth*scale);
        if pen.width=0 then pen.width:=1;

      end;

    end;

    {------------ DrawGridData ----------}
    procedure DrawgridData(originx,originy:integer;
                          gridlinesstart, GridLinesEnd:integer);
    var
      i,j:integer;
      arect:trect;
      startx,starty:extended;
      endx,endy:extended;
      begin
        startx:=originx;
        with Canvases[FCurrentPage], grid do
        for i:= 0  to colcount-1 do
        begin
          starty:=originy; {start each column at input top coordinate}
          for j:= gridlinesstart to gridlinesend do
          begin
            if (i<fixedcols) or (j<fixedrows)
            then brush.color:=fixedcolor else brush.color:=color;
            endx:=startx+scale*(grid.colwidths[i]+grid.gridlinewidth);
            endy:=starty+scale*(grid.rowheights[j]+grid.gridlinewidth);
            arect:=rect(round(startx),round(starty),round(endx),round(endy));

            {scale the font so that the same fraction of the cell height is filled}
            //font.height:=trunc(scale*font.height);
            if showdata and (defaultdrawing) {If defaultdrawing is true then we must draw the text}
            then textrect(arect,arect.left+trunc(2*scale),
                          arect.top+trunc(2*scale), grid.cells[i,j]);

            if @grid.ondrawcell<>nil then
            begin
              {we will enable the ondrawcell exit for previewing/printing by passing
               a list with two addresses as the  "sender".  Drawlist will contain
               the grid address so that the exit can access the stringgrid as needed,
               and the metafilecanvas address where the preview image of the cell
               is to be drawn.  Of course the ondrawcell exit must be aware of this
               trick and handle the list entries appropriately}
              drawlist.clear;
              drawlist.add(grid);
              drawlist.add(Canvases[currentpage]);
              ondrawcell(drawList,i,j,arect,[]);
            end;
            starty:=endy; {point to next row};
          end;
          startx:=endx; {point to next column}
        end;
      end;

    {----------------DrawgridLines ---------------}
    procedure DrawGridLines(r:Trect;gridlinesstart,gridlinesend:integer);
    var
      i:integer;
      startx,starty:extended;
      n:extended;
      intstart:integer;
        {draw the grid}
    begin
      with Canvases[FCurrentPage] do
      begin
        startx:=r.left;
        for i:=0 to grid.colcount-1 do{vertical gridlines}
        begin
          n:=scale*(grid.colwidths[i]+grid.gridlinewidth);
          intstart:=round(startx);
          If showgrid then
          begin
            moveto(intstart,r.top);
            lineto(intstart,r.bottom);
          end;
          startx:=startx+n;
        end;
        {draw the rightmost vertical gridline}
        If showgrid then
          begin
            intstart:=round(startx);
            moveto(intstart,r.top);
            lineto(intstart,r.bottom);
          end;

        starty:=r.top;
        for i:=gridlinesStart to gridlinesEnd+1 do {horizontal gridlines}
        begin
          n:=scale*(grid.rowheights[i]+grid.gridlinewidth);
          intstart:=round(starty);
          If showgrid then
          begin
            moveto(r.left,intstart);
            lineto(r.right,intstart);
          end;
          starty:=starty+n;
        end;
        update;
     end;

   end;

var
  i,j:integer;
  n:extended; {next vertical increment (unscaled)}
  gridlinesStart:integer;
  starty:integer;
  fontsave:TFont;
  brushsave:TBrush;
  pensave:TPen;
  fixedrowheight:integer;  {used for checking when to make a new page}
  oneinch:integer;
begin
  if (FCurrentPage > 0) AND (not FDonePrinting) then
  with Canvases[FCurrentPage] do
  begin
    {fill the cells, call OnDrawCell if specified}
    fontsave:=TFont.create;
    fontsave.assign(font);   {save old font}

    brushsave:=TBrush.create;
    brushsave.assign(brush);

    pensave:=TPen.create;
    pensave.assign(pen);


    {accumulate the true total width of the cells}
    with grid do
    begin
      n:=gridlinewidth*(colcount);
      for i:=0 to colcount-1 do n:=n+colwidths[i];
    end;
    scale:=scaledpixelwidth/n;

    assignvisuals;

    {accumulate height of fixedrows}
    with grid do
    begin
      fixedrowheight:=gridlinewidth*(fixedrows);
      for i:=0 to fixedrows-1 do fixedrowheight:=fixedrowheight+rowheights[i];
    end;

    {Adjust origin for margin and offset. Offset is the distance from printer's
     (0,0) point to physical left and top edges of the paper}
    inc(origin.x, marginrect.left - xoff);
    inc(origin.y, marginrect.top - yoff);

    starty:=origin.y;
    oneinch:=yinch(1);

    gridlinesStart:=0;  {Where to start printing this section of the grid}
    {get actual height}
    n:=0;
    while gridlinesStart<grid.rowcount-1 do
    begin
      newheight:=n;
      for i:=gridlinesstart to grid.rowcount-1 do
      begin
        n:=newheight+grid.rowheights[i]+grid.gridlinewidth;
        {if pagefull or all rows processed then draw the page}

        if ((gridlinesstart=0) and (starty+round(scale*n)>marginrect.bottom{printer.pageheight}))
           or ((gridlinesstart>0) and (oneinch+scale*(n+fixedrowheight)>marginrect.bottom{printer.pageheight}))

         or (i>=grid.rowcount-1) then
        begin
          if i>1 then
          begin
            {draw data from gridlinesstart to i-1, page may be the entire grid or
             one page of a multi-page grid}
            DrawgridData(origin.x,
                      {y origin}starty,
                      {fromline}gridlinesstart,
                      {toline}i-1);
            {draw grids and outline around this data}
            DrawGridLines(rect(origin.x,starty,
                             origin.x+scaledpixelwidth,
                             starty+round(scale*(newheight{-top}))),
                             gridlinesStart,i-1);
            gridlinesstart:=i; {the next start line}
          end;
          if i<grid.rowcount-1 then
          begin
            {make a new page and set it to current page}
            newpage;
            assignvisuals;
            starty:=marginrect.top {yinch(1)};  {make sure that further pages start with top margin}
            if grid.fixedrows>0 then
            begin
              drawgriddata(origin.x,starty,0,grid.fixedrows-1);
              drawgridlines(rect(origin.x,starty,
                         origin.x+scaledpixelwidth,
                         starty+round(scale*fixedrowheight)),
                         0,grid.fixedrows-1);
              starty:=starty+round(scale*fixedrowheight);  {this is where to start drawing rows (below the fixed rows)}
            end;
            newheight:=0;
            n:=0;
            break;
          end;
        end;
        newheight:=n;
      end;
    end;


    {restore metafile font, brush, and pen}
    font.assign(fontsave);
    brush.assign(brushsave);
    pen.assign(pensave);
    fontsave.free;
    brushsave.free;
    pensave.free;
    returnedheight:=round(scale*(newheight+grid.gridlinewidth));
  end;
end;

{************** PutPageNums **********}
procedure TPrintPreview.PutPageNums(const X, Y : Integer;
  Alignment : TAlignment);
var
  i : Integer;
  s : String;
  o : Integer;
begin
  o := CurrentPage;
  for i := 1 to PageCount do
  begin
    s := Format('Page %d of %d', [i, PageCount]);
    CurrentPage := i;
    case Alignment of
      taLeftJustify : TextOut(X, Y, s);
      taRightJustify : TextOutRight(X, Y, s);
      taCenter : TextOutCenter(X, Y, s);
    end;
  end;
  CurrentPage := o;
end;

{*************** NewJob *************}
procedure TPrintPreview.NewJob;
var
 i : Integer;
 p : TPoint;
begin
  if printer.printing then printer.abort;
  for i := FMetafiles.Count - 1 downto 0 do
  begin
    TMetafile(FMetafiles[i]).Free;
  end;
  FCanvases.Clear;
  FMetafiles.Clear;
  FCurrentPage := 0;
  FDonePrinting := False;
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @p);
  XOff := p.X;
  YOff := p.Y;
  pXppi := GetDeviceCaps(Printer.Handle, LOGPIXELSX);
  pYppi := GetDeviceCaps(Printer.Handle, LOGPIXELSY);
  if printer.printing then printer.abort;
  {initialize marginrect with 1 inch margins all around}
  marginrect:=Rect(1*pxppi,1*pyppi,printer.pagewidth-1*pxppi, printer.pageheight-1*pyppi);
  Printer.BeginDoc;
  NewPage;
end;

{**************** Done Printing *************}
procedure TPrintPreview.DonePrinting;
{call after canvas is built and before displaying or printing
 to free metafilecanvases and transfer code to metafile -
 called by Preview, PrintPage, PrintAll, and LoadFromFile}
var
  i : integer;
begin
  if not FDonePrinting then
  begin
    for i := 1 to PageCount do Canvases[i].Free;
    FDonePrinting := True;
  end;
end;

{*************** Newpage *********}
function TPrintPreview.NewPage : Integer;
begin
  if not FDonePrinting then
  begin
    Result := FMetafiles.Add(TMetafile.Create) + 1;
    FCanvases.Add(TMetafileCanvas.Create(TMetafile(FMetafiles[Result - 1]),
       Printer.Canvas.Handle));
    FCurrentPage := Result;
    with Canvases[Result] do
    begin
      Brush.style := bsClear;
      Font.Name := 'Arial';
      Font.PixelsPerInch := pXppi;
      Font.Size := 10;
    end;
  end
  else result:=0;
end;

{**************** Destroy ***********}
destructor TPrintPreview.Destroy;
var  i : Integer;
begin
for i := FMetafiles.Count - 1 downto 0 do begin
  TMetafile(FMetafiles[i]).Free;
  end;
FCanvases.Free;
FMetafiles.Free;
if Printer.Printing then Printer.Abort;
inherited Destroy;
end;

{*******************************************************}
{***************** Preview form methods ****************}
{*******************************************************}

{*************** FormCreate ************}
procedure TPrintPreview.FormCreate(Sender: TObject);
begin
  savedialog1.initialdir:=extractfilepath(application.exename);
  Opendialog1.initialdir:=extractfilepath(application.exename);
  PageDisplaying := 1;
  FullPageBtnClick(Self);
  FCanvases := TList.Create;
  FMetafiles := TList.Create;
  DrawList:=TList.Create;
  FCurrentPage := 0;
  FDonePrinting := False;
  FOrientation := poPortrait;
end;

{**************** PrintBtnClick ********}
procedure TPrintPreview.PrintBtnClick(Sender: TObject);
var i:integer;
begin
  with printdialog1 do
  begin
    Options:=[poPageNums]; {allow page selection}
    frompage:=1;
    minpage:=1;
    maxpage:=pagecount;
    topage:=PageCount;
    if execute then
    begin
      if printrange = prAllPages then  PrintAll
      else
      if printrange=prPageNums then
      begin
        for i:=frompage to topage do
        begin
          printpage(i);
          if i<topage then printer.newpage; {go to next page on the printer}
        end;
        printer.enddoc;
        if sender = printbtn then displaypage(topage);
      end;
    end;
  end;
end;

{************** FirstBtnClick ************}
procedure TPrintPreview.FirstBtnClick(Sender: TObject);
begin
  DisplayPage(1);
end;

{*************** PriorBtnClick ************}
procedure TPrintPreview.PriorBtnClick(Sender: TObject);
begin
  DisplayPage(PageDisplaying - 1);
end;

{*****************  NextBtnClick ************}
procedure TPrintPreview.NextBtnClick(Sender: TObject);
begin
  DisplayPage(PageDisplaying + 1);
end;

{************** LastBtnClick ************}
procedure TPrintPreview.LastBtnClick(Sender: TObject);
begin
  DisplayPage(PageCount);
end;

{***************** FullPageBtnClick *************}
procedure TPrintPreview.FullPageBtnClick(Sender: TObject);
{display the full page on one screen}
begin
  with paintbox1 do
  begin
    Visible := False;
    Top := 15;
    Left:=15;
    Height := Sb.height - 30;
    {scale paintbox width by pagesize dimensions}
    Width := PaintBox1.Height*PageSize.X div PageSize.Y;
    if width>sb.width then
    begin  {maybe landscape display, scale the other way}
      width:=sb.width-30;
      height:=width*pagesize.x div pagesize.y;
    end
    else Left := (sb.Width - Width) div 2;
    Visible := True;
  end;
end;

{************* PaintBox1Paint ***************}
procedure TPrintPreview.PaintBox1Paint(Sender: TObject);
begin
  DisplayPage(PageDisplaying);
end;

{***************** PageWidthbtnClick ***************}
procedure TPrintPreview.PageWidthBtnClick(Sender: TObject);
{Display preview at full page width = full screen width }
begin
  PaintBox1.Visible := False;
  PaintBox1.Top := Panel1.Height + 15;
  PaintBox1.Left := 15;
  PaintBox1.Width := ClientWidth - 45;
 PaintBox1.Height := (Longint(PaintBox1.Width) * Longint(PageSize.Y)) div
     Longint(PageSize.X);
  PaintBox1.Visible := True;
end;

{***************** SwowGridBtnClick ************}
procedure TPrintPreview.ShwGrdBtnClick(Sender: TObject);
begin
  if ShowgridBtn.Caption[1] = 'H' {change the button caption}
  then  ShowGridBtn.Caption := 'Show 1" Grid'
  else  ShowGridBtn.Caption := 'Hide Grid';
  PaintBox1.Refresh;
end;

{************** PaintBoxMouseDown ***************}
procedure TPrintPreview.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
 i : Integer;
begin
  case Button of
    mbLeft : {zoom in}
      with paintbox1 do
      begin

        Visible := False;
        (*
        PaintBox1.Top := 1 {(ClientHeight div 2) - Y};
        PaintBox1.Left := 1 {(ClientWidth div 2) - X};
        *)
        i := Trunc(Width * 0.35) div 2;
        Width := Width + i;
        left:= left-i div 2;
        if left<0 then  left:=1;
        {PaintBox1.Left := PaintBox1.Left - i;}
        i := Trunc(Height * 0.35) div 2;
        Height := Height + i;
        Top:=top - i div 2;
        if top<0 then top:=1;
        {PaintBox1.Top := PaintBox1.Top - i; }

        PaintBox1.Visible := True;
      end;
    mbRight :    {zoom out}
      begin
        PaintBox1.Visible := False;
        i := Trunc(PaintBox1.Width * 0.35) div 2;
        PaintBox1.Width := PaintBox1.Width - i;
        {PaintBox1.Left := PaintBox1.Left + i;}
        i := Trunc(PaintBox1.Height * 0.35) div 2;
        PaintBox1.Height := PaintBox1.Height - i;
        {
        PaintBox1.Top := PaintBox1.Top + i;
        PaintBox1.Top := (ClientHeight div 2) - Y;
        PaintBox1.Left := (ClientWidth div 2) - X;
        }
        PaintBox1.Visible := True;
      end;
  end;
end;

{********************* SaveBtnClick ****************}
procedure TPrintPreview.SaveBtnClick(Sender: TObject);
begin
  If savedialog1.execute then savetofile(savedialog1.filename);
end;

{***************** LoadBtnClick *************}
procedure TPrintPreview.LoadBtnClick(Sender: TObject);
begin
  If Opendialog1.execute then loadFromFile(opendialog1.filename);
end;

{**************** PrintDialog ***********}
procedure TPrintPreview.PrintDialog1Show(Sender: TObject);
begin
  if printer.printing then printer.abort;
end;

end.