unit UMakeCaption;
 {Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface
uses Forms, windows, graphics;
procedure makecaption(leftSide, Rightside:string; form:TForm);

implementation


procedure makecaption(leftSide, Rightside:string; form:TForm);
var
  Metrics:NonClientMetrics;
  captionarea,spacewidth,nbrspaces:integer;
  b:TBitmap;
begin
  b:=TBitmap.create;  {to get a canvas}
  metrics.cbsize:=sizeof(Metrics);
  if SystemParametersInfo(SPI_GetNonCLientMetrics, sizeof(Metrics),@metrics,0)
  then  with metrics   do
  begin
    b.canvas.font.name:=Pchar(@metrics.LFCaptionFont.LfFaceName);
    with metrics.LFCaptionFont, b.canvas.font do
    begin
      height:=LFHeight;
      if lfweight=700 then style:=[fsbold];
      if lfitalic<>0 then style:=style+[fsitalic];
    end;
    {subtract 3 buttons + Icon + some border space}
    captionarea:=form.clientwidth-4*iCaptionwidth-4*iBorderWidth;;
    {n = # of spaces to insert}
    spacewidth:=b.canvas.textwidth(' ');
    nbrspaces:=(captionarea-b.canvas.textwidth(Leftside + Rightside)) div spacewidth;
    if nbrspaces>3 then form.caption:=LeftSide+stringofchar(' ',nbrspaces)+RightSide
    else form.caption:=LeftSide+' '+RightSide;
  end;
  b.free;
end;
end.
