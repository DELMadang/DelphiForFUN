unit U_Invertedtext;

interface

Uses Windows,StdCtrls, classes, graphics;

   procedure InitInvertedText(canvas:TCanvas; bgcolor:TColor; pagewidth,pageheight:integer);
   procedure DrawInvertedText(Canvas:TCanvas; pagewidth,pageheight:integer;
                               linenbr:integer; s:string);
   Procedure MemoTextFixUp(memo:TMemo {var text:string});

implementation

  {************* MemoTextFixUp **************}
 Procedure MemoTextFixUp(memo:TMemo {var text:string});
  var
  s:string;
  eol:boolean;
  i:integer;
  begin
  {This attempts to fix-up Tmemo text by removing Carriage Return/LineFeed
   (CR/LF)pairs inserted by Delphi at design time.  When you enter text into
   the Lines property at design time,  Delphi (incorrectly, in my opinion)
   inserts CR/LF at the end of each line. If WordWrap property is set to true,
   each displayed lines will break as required even if windows size or font is
   changed. This is not the case with hard breaks inserted by Delphi

   Unfortunately, breaks entered by Delphi cannot be distinguished from those
   you might have entered as paragraph breaks.  This fix recongizes two successive
   line breaks  (CR/LF/CR/LF) as a user defined paragraph.  ThIs leaves a blank
   line between paragraphs.  Single CRLF pairs are assumed to have been inserted
   by Delphi and are deleted}

  s:=memo.text;
  i:=length(s);
  while i>=1 do
  begin
    if (i>=4) and (s[i]=#10)  and (not eol) then
    begin
      if (copy(s,i-3,4) = #13#10#13#10)
      then dec(i,4) {double carriage control - keep them}
      else
      begin {delete CR and LF pair because it was probably inserted by Delphi IDE}
        delete(s,i,1);
        dec(i);
        if (s[i]=#13) then
        begin
          delete(s,i,1);
          dec(i);
        end;
        eol:=true;
      end;
    end
    else eol:=false;
    dec(i);
  end;
  memo.text:=s;
end;


var lineheight:integer;

{************* InitInvertedtext ************}
 procedure initInvertedText(canvas:TCanvas; bgcolor:TColor; pagewidth,pageheight:integer);

 {Initialize the image canvas font to be rotated by 180 degrees}
 var
   tm:TextMetric;
   LogRec: TLOGFONT;
begin
  with  canvas do
  begin
    brush.color:= bgcolor;
    fillrect{rectangle}(classes.rect(0,0,pagewidth,pageheight));
    gettextmetrics(handle,tm);
    with TM do
    Lineheight := tmheight+tmexternalLeading; {my best guess for line separation pixels}
    brush.style:=bsClear; {required for rotated text}
    GetObject(Font.Handle, SizeOf(LogRec),Addr(LogRec)); {get font info}
    LogRec.lfEscapement := 1800;  {change escapement to 180 degrees}
    Font.Handle := CreateFontIndirect(LogRec ); {And send it back to the font}
  end;
end;

{******************** DrawInvertedText ***************}
  procedure DrawInvertedText(Canvas:TCanvas; pagewidth,pageheight:integer; linenbr:integer; s:string);
  {uses Lineheight value set by InitInvertedText proceudre}
  begin
    with canvas do TextOut(pagewidth-10,pageheight  - (linenbr-1)*Lineheight ,s);
  end;


end.
