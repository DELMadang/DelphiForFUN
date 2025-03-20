unit UPrintgrid;
{Copyright © 2008, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

{ A "Printgrid" procedure to print a StringGrid using Stretchdraw to the
  printer canvas at a specified location and of a specified dimensions.  The
  printed grid is scaled to maximum size within the given width and height
  while maintaining the height/width ration of the input grid.

  Functions Xoffset and YOffset may be called to determine minimum physical
  offsets from page edges for printing.  Starting locations
  less than these values or start location plus size values that exceed the
  maximum printable location wil be will be adjusted so that the entire grid
  is printed.}



interface

Uses Windows, Classes, Graphics, Grids, Dialogs, Printers;

{Xoffset=The physical offset to the leftmost pixel that can be printed}
function XOffset:integer;
{Yoffset=The physical offset to the topmost pixel that can be printed}
function YOffset:integer;
{Printgrid scales a stringgrid to size specified and prints it at the location sepcified}
{Aspect ration of the input string grid is maintained}
procedure Printgrid(Grid:TStringgrid;
          aleft,  {left starting pixel location on the printed page}
          atop,   {top starting location on the printed page}
          awidth, {width of stringgrid on the printed page}
          aheight:integer);{height of stringgrid on the printed page}

implementation

{$IFDEF Debug}
uses U_PrintGridTest;
{Printgrid will draw the image on form1's  TImage canvas instead of printing
 if Debug conditional defined is set}
{$ENDIF}

{******* XOffset *****}
function XOffset:integer;
var p:TPoint;
begin
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @p);
  result := p.X;
end;

{********** YOffSet *******}
function YOffset:integer;
var p:TPoint;
begin
  Escape(Printer.Handle, GETPRINTINGOFFSET, 0, nil, @p);
  Result := p.Y;
end;

{**************** Printgrid ***********88}
procedure Printgrid(Grid:TStringgrid; aleft, atop, awidth, aheight:integer);
{Print a stringgrid using stretchdraw.}
{ aleft, atop, awidth, aheight parameters are adjusted for printer physical
  offsets if necessary}
var
  b:TBitmap;
  scalew,scaleh,scale:extended;
  h,w:integer;
  FromRect, ToRect:Trect;
  Xoff,Yoff:integer;
begin
  {$IFNDEF Debug}
  if not printer.printing then
  begin
    Showmessage('Program must call "Begindoc" before "Printgrid" '
          +#13+ 'and "Enddoc" when printing is complete.');
    exit;
  end;
  {$ENDIF}


  with Grid  do
  begin
    {We'll copy the grid to a Device independent Bitmap (DIB) which will in turn
     be "stretchdrawn" on the printer canvas, unles Debug conditional define is
     set.  It that case, no printing, just check the bitmap image on the screen
     (saves paper!) }

    {$IFDEF Debug}
    form1.image1.picture.bitmap:=TBitmap.create;
    b:=form1.image1.picture.bitmap;
    {$ELSE}
       b:=TBitmap.create;
    {$ENDIF}
    with b do
    begin
      handletype:=bmDIb;
      width:=gridwidth+2;
      height:=gridheight+2;
      {$IFDEF Debug}
      form1.image1.width:=width;
      form1.Image1.height:=height;
      {$ENDIF}
      FromRect:=rect(0,0,gridwidth,gridheight);
      ToRect:=rect(2,2,gridwidth+2,gridheight+2);
      with canvas do
      begin
        canvas.pen.width:=2;
        canvas.copyrect(ToRect,grid.canvas,FromRect);
        pen.color:=clgray;
        moveto(1,height); lineto(1,0); {left vertical centerd on x=1}
        moveto(0,1); lineto(width,1); {top horizontal centered on y=1}
      end;
    end;
  end;

  {$IFNDEF Debug}
  with printer do
  begin
    XOff := Xoffset;
    YOff := YOffset;
    h:=aheight;
    if atop+aheight>pageheight-Yoff then h:=pageheight-Yoff-atop;
    w:=awidth;
    if aleft+awidth>pagewidth-Xoff then w:=pagewidth-Xoff-aleft;
    scalew:=w/b.width;
    scaleh:=h/b.height;
    if scalew>scaleh then scale:=scaleh else scale:=scalew;
    canvas.stretchdraw(rect(aleft,atop,aleft+trunc(scale*b.width),atop+Trunc(scale*b.height)),b);
  end;
  b.free;
  {$ENDIF}
end;

end.
