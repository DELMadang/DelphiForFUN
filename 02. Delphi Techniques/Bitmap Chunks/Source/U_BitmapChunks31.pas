unit U_BitmapChunks31;
{Copyright © 2007, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{A laboraory investigating how to scan black/white or 8bit bmp files for
 connected "chunks".
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, shellapi, Spin;

type
  tChunk=record
    x,y:integer; {x=nbr of points in chunk, y=row (or startrow for a chunk)}
    points:TStringList; {a list of the points in the chunk}
  end;
  TChunks=array of TChunk;
  tIntArray=array of integer;
  tImageType=(None,Preview,FullColors,UsedColors,Piece);


  TForm1 = class(TForm)
    ScanBtn: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Filegrp: TRadioGroup;
    KeepPoints: TCheckBox;
    Timelbl: TLabel;
    Label2: TLabel;
    StaticText1: TStaticText;
    DoDiag: TCheckBox;
    Label3: TLabel;
    OpenDialog1: TOpenDialog;
    Label4: TLabel;
    UsedColorsBtn: TButton;
    ListBox2: TListBox;
    SpinEdit1: TSpinEdit;
    FormatGrp: TRadioGroup;
    Label5: TLabel;
    Label6: TLabel;
    PreviewBtn: TButton;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Memo1: TMemo;
    SelectType: TRadioGroup;
    FullColortableBtn: TButton;
    ZoomImage: TImage;
    RowCollbl: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure ScanBtnClick(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure FilegrpClick(Sender: TObject);
    procedure StaticText1Click(Sender: TObject);
    procedure UsedColorsBtnClick(Sender: TObject);
    procedure ListBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormatGrpClick(Sender: TObject);
    procedure PreviewBtnClick(Sender: TObject);
    procedure SelectTypeClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  public
    { Public declarations }
    b:TBitmap;
    line1:TIntArray;
    line2:TIntArray;
    chunks:TChunks;
    blackcutoff:integer;
    nbrchunks:integer;
    Colorstable:array[0..255] of tcolor; {for 8 bit pixelformat, store actual colors here}
    CutoffValuesTable:array[0..255] of integer; {Table of colorcutoff value computed for each color}
    filename:string;
    zoomMap:TBitmap;  {Use to hold piece of original image to be zoomed}
    Imagetype:TImageType; {what image is currently displayed}
    procedure countchunks; {the heart of the program, does the scanning}
    procedure loadfile;
    procedure magnify(x,y:integer); {magnify a 32x32 pixel piece of Image1}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses math;

var
  FormTitle:string='Bitmap chunks V3.1  (Scans bitmaps for connected "chunks")';

type
   THSBColor = record
     Hue,
     Saturnation,
     Brightness : Double;
   end;

function RGBToHSB(rgbColor : TColor) : THSBColor;
{Convert TColor (RGB) to HSB (hue, saturation, brightness) color type }
{Adapted from article at http://delphi.about.com/od/adptips2006/qt/RgbToHsb.htm  }
{Modifed to use TColor input value instead of RGB type}
var
   minRGB, maxRGB, delta : Double;
   h , s , b : Double ;
   green,blue,red:integer;
begin
   H := 0.0 ;
   blue:=(rgbcolor shr 16) and $FF;
   green:=(rgbcolor shr 8) and $FF;
   red:=(rgbcolor) and $FF;

   minRGB := Min(Min(Red, Green), Blue) ;
   maxRGB := Max(Max(Red, Green), Blue) ;
   delta := ( maxRGB - minRGB ) ;
   b := maxRGB ;
   if (maxRGB <> 0.0) then s := 255.0 * Delta / maxRGB
   else s := 0.0;
   if (s <> 0.0) then
   begin
     if Red = maxRGB then h := (Green - Blue) / Delta
     else
       if Green = maxRGB then h := 2.0 + (Blue - Red) / Delta
       else
         if Blue = maxRGB then h := 4.0 + (Red - Green) / Delta
   end
   else h := -1.0;
   h := h * 60 ;
   if h < 0.0 then h := h + 360.0;
   with result do
   begin
     Hue := h;
     Saturnation := s * 100 / 255;
     Brightness := b * 100 / 255;
   end;
end;

{*************** FormActivate **********}
procedure TForm1.FormActivate(Sender: TObject);
{Initialization}
begin
  b:=tbitmap.create;
  opendialog1.initialdir:=extractfilepath(application.exename);
  filegrpclick(sender);
  label1.caption:='';
  Imagetype:=preview;
  ZoomMap:=TBitmap.create;
  with zoommap do
  begin
    height:=32;
    width:=32;
    pixelformat:=pf8bit;
    handletype:=bmDIB;
  end;
  with zoomimage.picture.bitmap do
  begin
    height:=zoomimage.height;
    width:=zoomimage.width;
    pixelformat:=pf8bit;
    handletype:=bmDIB;
  end;
end;

var
  {mask to isolate 1 bit pixels in a pf1Bit image}
  bitmask:array[0..7] of byte = ($80,$40,$20,$10,$08,$04,$02,$01);

{************ CountChunks **************}
procedure Tform1.countchunks;
{The idea is to process row by row and accumulate connected sections as we move down}
{Line1 and line2 reflect two consctutive rows with "chunk" numbers assigned.  If
two chunks number line up vertically, we need to combine the two chunk numbers into a single
chunk, assign the lower number. Point counts for each get summed and the point lists
get combined point info is being retained.

This may take more than one pass;  for example when
2 vertical elements which had looked like separate chunks get joined by a horizontal
chunk, pass #1 changes the horizontal chunk # to the left vertical chunk #, and a
2nd pass changes the right vertical chunk info to the new horizontal chunk # so that
the whole structure gets combined into a single chunk.}


   {-------------------------------------------------}
   {--------- Local Procedures and Functions --------}
   {-------------------------------------------------}


   {-------------- CheckLength ---------------}
   procedure checklength;
   {See if Chunk and points arrays might need expanding for current row}
   var
     i:integer;
    begin
      if length(chunks)<nbrchunks+b.width then {increase chunks size if necessary}
      begin {set chunks array length}
        setlength(chunks,nbrchunks+b.width);
      end;
    end;

      {-------------- PreProcessRow -------------}
      procedure preprocessrow(var line:TIntArray; const row:integer);
      {Pre-process one row identifying contiguous chunks with temporary chunk numbers}
      var
        i:integer;
        n:integer;
        inchunk:boolean;
      begin
        n:=nbrchunks+1;
        inchunk:=false;
        for i:=0 to high(line) do
        if (line[i]<>0) then
        begin
          inchunk:=true;
          line[i]:=n;
          inc(chunks[n].x);
          chunks[n].y:=row;
          if (keepPoints.checked) then
          with chunks[n] do
          begin
            if not assigned(points) then points:=TStringlist.create;  {GDD}
            points.add(format('%4d,%4d',[row,i]));
          end;
          {next line to simulate empty pixel at end of row and make sure last chunk is retained}
          if i=high(line) then inc(n); {to simulate empty pixel at end of row}
        end
        else
        begin
          if inchunk then inc(n);{point to the next location}
          inchunk:=false;
        end;
        if not inchunk then nbrchunks:=n-1{that last n value was not used}
        else nbrchunks:=n;
      end; {preprocessrow}

      {------------ChunkToProcess-----------}
      function ChunkToProcess(var col1,col2:integer):boolean;
      {Scan line1 and line2 looking for the next pair of chunks to process.
       Return true if such a pair is found, false otherwise}
      var
        i:integer;
      begin
        result:=false;
        for i:=0 to b.width-1 do
        begin
          If (line1[i]>0) and (line2[i]>0) and (line1[i]<>line2[i]) then
          begin
            col1:=i;
            col2:=i;
            result:=true;
            break;
          end
          else if dodiag.checked then
          begin
            if (i>0) and (line1[i-1]>0) and (line2[i]>0) and (line1[i-1]<>line2[i]) then
            begin
              col1:=i-1;
              col2:=i;
              result:=true;
              break;
            end
            else if (i<b.width-1) and (line1[i+1]>0) and (line2[i]>0) and (line1[i+1]<>line2[i]) then
            begin
              col1:=i+1;
              col2:=i;
              result:=true;
              break;
            end;
          end;
        end;
      end;

    {------------- ProcessChunk ---------}
    procedure processchunk(const col1, col2:integer);
    {Build chunk data from two preprocessed lines}

      procedure mergechunks(var linea,lineb:TIntArray; const colA,colB:integer);
      {Merge lineB values into lineA}
      {May merge line2 into line1 or line1 into line2 depending on calling parameters}
        var
          j:integer;
          start:integer;
          A,B:integer;
        begin
           {short names good for lazy programmers!}
           A:=linea[cola];
           B:=lineb[colb];
           {add lineB chunk value & points to lineA chunk}
          if (keeppoints.checked) and assigned(chunks[b].points) 
          then
          begin {move the points over to combined chunk}
            if not assigned(chunks[a].points) then chunks[a].points:=tstringlist.create;
            chunks[A].points.addstrings(chunks[B].points);
            chunks[B].points.clear;
            freeandnil(chunks[b].points);
          end;

          inc(chunks[A].x,chunks[B].x);
          chunks[B].x:=0; {zero out old}
          if chunks[B].y < chunks[A].y  {update startrow for the chunk}
          then chunks[A].y:=chunks[B].y;

          {find start of lineB chunk and replace all values of this chunk with
           the new lower chunk number}
          start:=colB;
          while (start>0) and (lineB[start-1]<>0) do dec(start); {back up to start of chunk}
          for j:=start to high(lineB) do
          begin
            {for the rest of the line, change all occurrences of old chunk # to new}
            if lineB[j]=B then lineB[j]:=A; {put new chunk nbr in the line}
          end;
        end;

     begin
      {extend smaller chunk # to the larger}
      if line1[col1]<line2[col2]then MERGECHUNKS(LINE1,LINE2,COL1,COL2)
      else  MERGECHUNKS(LINE2,LINE1,COL2,COL1);
    end; {ProcessChunk}

    {---------- ColorSum -----------}
    function colorsum(const r,c,index:integer):integer;
    {Returns a normalized sum of the R,G, B color values from the color index passed}
    {100 = white, 0 = black, higher numbers are lighter}

    var  temprgb:TColor;
         HSB:THSBColor;
    begin
      if CutoffValuesTable[index]<0 then
      begin  {add new color to cutoff value table and to actual color table}
        temprgb:=b.canvas.pixels[c,r];
        Colorstable[index]:=temprgb;
        case selectType.itemindex of
        {select by average color value}
        0: CutoffValuesTable[index]:= ((temprgb and $FF) +
                                 +((temprgb shr 8) and $FF)
                                 +((temprgb shr 16)and $FF)
                                 ) div 3;
        1:
          begin  {select by brightness}
            hsb:=rgbtoHSB(temprgb);
            CutoffValuesTable[index]:=trunc(255*HSB.brightness/100);
          end;
        end; {case}
      end;
      result:=CutoffValuesTable[index];
    end;

var
  i,j,row,col1,col2:integer;
  n,pixelpos:integer;
  P:PBytearray;
  freq,start,stop:int64; {timing fields}

begin  {countchunks}
  screen.cursor:=crhourglass;
  blackcutoff:=spinedit1.value;  {0=black, 255 = white}
  if length(chunks)>0 {nbrchunks>0}
  then for i:=0 to high(chunks) do
  with chunks[i] do if assigned(points) then freeandnil(points);
  nbrchunks:=0;
  setlength(chunks,0);
  for i:=0 to 255 do CutoffValuesTable[i]:=-1;
  queryperformanceFrequency(freq);
  queryPerformanceCounter(start);
  with b do
  begin
    p:=scanline[0];
    checklength;
    {change scanline to 0=white, 1=black}
    if pixelformat=pf1bit then
    begin
      {scan the line when each bit = a pixel.}
      n:=b.width div 8; {number of bytes to scan}

      for col1:= 0 to N -1  do {for all exccept the last byte}
      begin
        pixelpos:=8*col1; {the pixel number without the bit position}
        for i:=0 to 7 do
        if p^[col1] and bitmask[i]>0
        then line2[pixelpos+i]:=0
        else line2[pixelpos+i]:=1;
      end;
      col1:= N; {do the last few bits of the line}
      for i:=0 to N mod 8 -1 do
         if p^[col1] and bitmask[i]>0 then  line2[8*col1+i]:=0 else line2[8*col1+i]:=1;
    end
    else
    for col1:= 0 to b.width-1 do
      if  colorsum(0,col1,p^[col1])>=BlackCutoff then line2[col1]:=0 else line2[col1]:=1;


    preprocessrow(line2,0);  {fill in chunks for this starting from current high chunks nbr}
                                 {these are subject to change in the next step}

    for row:=1 to b.height-1 do  {for the rest of the rows}
    begin
      {get rid of unused chunks at end of list}
      while (nbrchunks>0) and (chunks[nbrchunks].x=0) do
      begin
        //If keepPoints.checked then chunks[nbrchunks].points.clear;
        dec(nbrchunks);
      end;
      checklength;  {increase chunks and points arrays if necessary}
      p:=scanline[row];


    {change scanline to 0=white, 1=black}
    if pixelformat=pf1bit then
    begin
      for col1:= 0 to b.width div 8 -1 do
      begin
        for i:=0 to 7 do
        begin
          j:=8*col1+i; {this is the pixel position on the line}
          line1[j]:=line2[j];
          if p^[col1] and bitmask[i]>0 then  line2[j]:=0 else line2[j]:=1;
        end;
      end;
    end
    else {8 bit indexed color image}
    for col1:= 0 to b.width-1 do
    begin
      line1[col1]:=line2[col1];
      if  colorsum(row,col1,p^[col1])>=BlackCutoff then line2[col1]:=0 else line2[col1]:=1;
    end;
    {now process again identifying chunks}
    preprocessrow(line2,row);
    while ChunkToProcess(col1,col2) do ProcessChunk(col1,col2);
    end;  {for row loop}
  end;  {with b do}
  queryPerformanceCounter(stop);
  TimeLbl.caption:=format('Procecessed %d chunks in %dx%d image in %6.4f seconds',
                          [nbrchunks,b.width,b.height, (stop-start)/freq]);
  screen.cursor:=crdefault;
end;



{************ ScanbtnClick ************}
procedure TForm1.ScanBtnClick(Sender: TObject);
{scan the input image and find chunks}
var
  i:integer;
  stop:integer;
  //mem1:integer;
begin
  //mem1:=allocmemsize;
  countchunks;
  listbox1.clear;
  listbox2.clear;
  label1.caption:='';
  if nbrchunks>1000 then
  begin
    stop:=1000;
    listbox1.items.add(format('1000 of %d chunks listed',[nbrchunks]));
  end
  else stop:=nbrchunks;
  for i:= 0 to stop do
  if chunks[i].x>0 then
  with chunks[i] do
  begin
    If keepPoints.checked
    then listbox1.items.addobject(format('# %d Size:%d, StartRow: %d', [i,x,y]),points)
    else listbox1.items.add(format('# %d Size:%d, StartRow: %d', [i,x,y]));
  end;
  {for debugging memory leak}
  //listbox3.items.add(format('Scan btn: In:%d Out:%d',[mem1,allocmemsize]));
end;

{************ ListBox1Click *********}
procedure TForm1.ListBox1Click(Sender: TObject);
{draw the chunk that was clicked}
var
  i:integer;
  p:array of Tpoint;
  list:TStringlist;
  bounds:Trect;
  x,y:integer;
  s:string;

begin
  Imagetype:=piece;
  listbox2.clear;
  if not keepPoints.checked then
  with listbox2.items do
  begin
    add('Click "Retain points" checkbox');
    add('and rescan to view points');
    exit;
  end;
  with listbox1 do
  begin
    list:=TStringlist(items.objects[itemindex]);
    setlength(p,list.count);
    bounds:=rect(10000,10000,0,0); {Initialize bounds rectangle}

    {find the dimensions of the chunk}
    for i:=0 to list.count-1 do
    begin
      s:=list[i];
      y:=strtoint(copy(s,1,4));
      x:=strtoint(copy(s,6,4));

      listbox2.items.add(s);
      with bounds do
      begin
        if x<left then left:=x;
        if x>right then right:=x;
        if y<top then top:=y;
        if y>bottom then bottom:=y;
        p[i].x:=x;
        p[i].y:=y;
      end;
    end;

    label1.caption:=format('Left %d, top %d',[bounds.left,bounds.top]);

    {set the image size}
    with image1 do
    begin
      width:=bounds.right-bounds.left+4; {leave room for a 2 pixel border}
      height:=bounds.bottom-bounds.top+4;
      picture.bitmap.width:=width;
      picture.bitmap.height:=height;
      with canvas do
      begin
        image1.canvas.brush.color:=clwhite;
        fillrect(clientrect);
        //brush.color:=clblack;
        for i:= 0 to list.count-1 do {move point over and down by 2 pixels for border}
          pixels[p[i].x-bounds.left+1,p[i].y-bounds.top+1]:=clblack;
      end;
    end;
  end;
end;

{*********** FileGrpClick **********}
procedure TForm1.FilegrpClick(Sender: TObject);
{Select and load a BMP file to process}
begin
  with filegrp do if itemindex>0 then  filename:=items[itemindex]
  else
  if opendialog1.execute then filename:=opendialog1.filename
  else showmessage('No file loaded');
  loadfile;
end;

{************* LoadFile ***********}
procedure TForm1.loadfile;
  var i:integer;
begin
  b.free;
  b:=TBitmap.create;
  b.loadfromfile(filename);
  listbox1.clear;
  listbox2.clear;
  label1.caption:='';
  image1.height:=0;
  if formatgrp.itemindex=0 then
  begin
    b.monochrome:=true;
    b.pixelformat:=pf1bit;
  end
  else
  begin
    b.monochrome:=false;
    b.pixelformat:=pf8bit;
  end;
  for i:=0 to 255 do CutoffValuesTable[i]:=-1;
  if length(chunks)>0 then
  for i:=0 to high(chunks) do
  with chunks[i] do if assigned(points) then points.free;
  setlength(chunks, 0);
  nbrchunks:=0;
  setlength(line1, b.width);
  setlength(line2, b.width);
  caption:=formtitle+'           Current file: '+filename;
  previewbtnclick(self);
end;

{************ UsedColorsBtnClick *********}
procedure TForm1.UsedColorsBtnClick(Sender: TObject);
{Display color table values for used colors}
var
  col,row:integer;
  index:integer;
  offsetx,offsety:integer;
  colors:array [0..255] of RGBQuad;
  FullTable:Boolean;

begin
  Imagetype:=Usedcolors;
  If sender = UsedColorsBtn then
  begin
    label1.caption:='Look up table of colors used';
    FullTable:=false;
  end
  else
  begin
    GetDIBColorTable(b.canvas.Handle,0,256,colors);
    label1.caption:='System Lookup table of all colors';
    FullTable:=true;
  end;
  label1.update;
  with image1 do
  begin
    offsetx:=canvas.textwidth('555  ')+8;
    offsety:=canvas.textheight('5')+8;
    width:=8+offsetx+20*16;
    height:=8+offsety+20*16;
    picture.bitmap.width:=width;
    picture.bitmap.height:=height;
    image1.canvas.brush.color:=clwhite;
    canvas.rectangle(image1.clientrect);

    with image1.canvas do
    for col:=0 to 15 do
    begin
      brush.color:=clwhite;
      textout(offsetx+20*col,4,'+'+inttostr(col));
      for row:=0 to 15 do
      begin
        brush.color:=clwhite;
        if col=0 then textout(4,offsety+20*row,format('%3d',[16*row]));
        index:=16*row+col;
        if FullTable
        then with colors[index] do brush.color:= rgb(rgbred,rgbgreen,rgbblue)
        else
        begin  {Get actual table translation color for colors that were used}
          if CutoffValuesTable[index]>=0  then
          begin
            brush.style:=bssolid;
            brush.color:= Colorstable[index];
          end
          else
          begin  {unused - display "empty" value}
            brush.style:=bsDiagCross;
            brush.color:=clblack;
          end;
        end;
        rectangle(offsetx+20*col,offsety+20*row,offsetx+20*col+18,offsety+20*row+18);
      end;
    end;
    brush.color:=clWindow;
    brush.style:=bsSolid;
  end;
end;

{***************** Listbox2DrawItem ************8}
procedure TForm1.ListBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
{Draw the listbox entry of the point detail (row, column, color)}
var
  x,y:integer;
  s:string;
  p:PBytearray;
begin
  with listbox2 do
  if keepPoints.checked then
  begin
    y:=strtoint(copy(items[index],1,4));
    x:=strtoint(copy(items[index],6,4));
    p:=b.scanline[y];
    canvas.brush.color:=clwhite;
    canvas.fillrect(rect);
    canvas.pen.color:=clblack;
    s:=items[index]+' Tbl Index:'+inttostr(p[x]);
    canvas.textout(rect.left+itemheight+2,rect.top+2,s);
    canvas.brush.color:=b.canvas.pixels[x,y];
    with rect do canvas.rectangle(left+1,top+1,left+itemheight-2,top+itemheight-2);
    canvas.brush.color:=clwhite;
  end
  else
  begin
    canvas.brush.color:=clwhite;
    canvas.fillrect(rect);
    canvas.textout(rect.left+itemheight+2,rect.top+2,items[index]);
  end;
end;

procedure TForm1.FormatGrpClick(Sender: TObject);
begin
  loadfile;{reload file}
end;

{************ PreviewbtnClick **********}
procedure TForm1.PreviewBtnClick(Sender: TObject);
begin
  Imagetype:=preview;
  label1.caption:='File preview. Hold left mouse button for "magnifying glass".';
  with image1 do
  begin
    autosize:=true;
    height:=400;
    width:=400;
    picture.bitmap:=b; {.loadfromfile(filename);}
    autosize:=false;
  end;
end;

procedure TForm1.SelectTypeClick(Sender: TObject);
var i:integer;
begin
  for i:=0 to 255 do Colorstable[i]:=-1; {force recalc of color values}
end;


{*************** Magnify **********}
procedure TForm1.magnify(x,y:integer);
{Magnify and display a 32x32 pievce of the displayed image}
  var
    p:PByteArray;
    p2:array[0..3] of PByteArray;
    i,j,k1,k2:integer;
    r:TRect;
  begin
    //if not preview then exit;
    RowcolLbl.caption:=format('(Row %d, Col %d',[y,x]);
    with zoomMap do
    begin  {copy the 32x32 square at mouse position to the ZoomMap bitmap}
      canvas.brush.color:=clWhite;
      r:=rect(0,0,width-1,height-1);
      canvas.rectangle(r);
      canvas.copyrect(r,image1.canvas,rect(x,y,x+31,y+31));
    end;
    with zoomimage do
    begin {Now enlarge the ZoomMap to the ZoomImage TImage}
      left:=x-scrollbox1.horzscrollbar.position;
      top:=y-scrollbox1.vertscrollbar.position;
      canvas.brush.color:=clWhite;
      canvas.rectangle(clientrect);
      showcursor(false);
      for j:=0 to zoommap.height-1 do
      begin
        p:=zoommap.scanline[j]; {for each line of the original image}
        {Get 4 scanlines of zoomed image the lazy way - use an array just to save writing code}
        for k1:=0 to 3 do p2[k1]:=picture.bitmap.scanline[4*j+k1];
        {and copy each pixel of the origin image to a 4x4 segment of the zoomed image}
        for i:=0 to zoommap.width-1 do
        begin
          for k1:=0 to 3 do
          for k2:=0 to 3 do p2[k1][4*i+k2]:=p[i];
        end;
      end;
      visible:=true;
      showcursor(true);
    end;
  end;


{************** Image1MouseMove *************}
procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
                                 Y: Integer);
{Handle magnifying feature}
var
  rgbval:Tcolor;
begin
  If (imagetype=preview) and  (ssLeft in Shift) then magnify(X,y)
  else
  begin
    zoomimage.visible:=false;
    if (imagetype=usedcolors) or (imagetype=Fullcolors)
    then
    begin
      rgbval:=image1.canvas.pixels[x,y];
      rowcollbl.caption:=format('(R:%d,G:%d,B:%d)',
           [(rgbval) and $FF, (rgbval shr 8) and $ff,  (rgbval shr 16) and $FF]);
    end;
  end;
end;

{************ Image1MouseDown *************}
procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Handle magnifying feature}
begin
  If (imagetype=preview) and  (ssLeft in Shift) then magnify(X,y);
end;

{************** Image1MouseUp ************}
procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Hide any magnified image display}
begin
  zoomImage.visible:=false;
  rowcolLbl.caption:='';
end;



procedure TForm1.StaticText1Click(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'http://www.delphiforfun.org/',
  nil, nil, SW_SHOWNORMAL) ;
end;


{************* FormClose ***************}
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
{clean up allocated memory.  Not necessary, but code was written to verify
 that an earlier real memory leak had been plugged, so I left this code in.
 It does no harm, but also does no good as Delphi memory management and/or
 Windows process management will free all allocated memory for this program
 in the next few microseconds anyway!}
var
  i:integer;
begin
  b.free;
  zoommap.free;
  for i:=0 to high(chunks) do with chunks[i] do
  if assigned(points) then freeandnil(points);
  listbox1.items.clear;
  listbox2.items.clear;
  action:=cafree;
end;

end.


