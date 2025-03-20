unit U_DrawScrambledPie;
 {Copyright  © 2004, Gary Darby,  www.DelphiForFun.org
 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface
  uses Windows,Forms,Graphics,Classes,SysUtils,Extctrls, types;

  (*
  type
  PSize = ^TSize;
  tagSIZE = packed record
    cx: Longint;
    cy: Longint;
  end;
  {$EXTERNALSYM tagSIZE}
  TSize = tagSIZE;
  SIZE = tagSIZE;
  {$EXTERNALSYM SIZE}
  *)

  procedure drawWords(w1,w2,w3,w4:string; Canvas:TCanvas; width,height:integer);
  procedure fillCenter(ch:char; canvas:TCanvas; width,height:integer);

implementation

function intersects(r1,r2:Trect):boolean;
var r:TRect;
begin
  Intersectrect(r,r1,r2);
  with r do result:=(left<>0) or (right<>0) or (top<>0) or (bottom<>0);
end;

procedure drawWords(w1,w2,w3,w4:string; Canvas:TCanvas; width,height:integer);
var
  minr,maxr:integer;
  quadrantrects:array[1..4] of TRect;
  Letterrects:array[1..50] of TRect;
  LetterCount:integer;
  m:integer;

      {************}
      procedure clearimage;
      var   p:tagSize;
      begin
        with canvas do
        begin
          {Need to fill the background with form color, but only for moinitor displays,
           not for printers - resolution test works, but there must be a
           better way}
          if font.pixelsperinch<100 then
          begin
            brush.color:=application.mainform.color;
            fillrect(rect(0,0,width,height));
          end;

          brush.color:=clwhite;
          minr:= width div 15;
          maxr:= width div 2 - minr;
          ellipse(rect(0,0,width,height));

          moveto(width div 2, 0);
          lineto(width div 2, height);
          moveto(0, height div 2);
          lineto(width, height div 2);

          ellipse(rect(width div 2-minr, height div 2 - minr, width div 2+minr, height div 2+minr));
          font.size:=14;
          p:=textextent('?');
          textout((width -p.cx) div 2, (height - p.cy) div 2, '?');
          font.size:=10;
        end;
      end;

      {****** AddWord *************}
    procedure addword(w:string;quadrant:integer);
    var
      startangle:extended;
      letterrect:TRect;
      OK, OK2:boolean;
      r:integer;
      a:extended;
      x,y:integer;
      lettersize:TagSize;
      i,j:integer;
    begin
      w:=uppercase(w);
      lettercount:=0;
      startangle:=(quadrant-1)*pi/2.0+0.01;
      canvas.font.style:=[FSBOLD];
      with canvas do
      for i:=1 to length(w) do
      begin
        font.size:=14;
        lettersize:=TextExtent(w[i]);
        font.size:=10;
        OK:=false;
        while not OK do
        begin
          r:=2*minr+random(maxr-2*minr);
          a:=-pi/2+startangle+pi/2.0*random;
          x:=trunc(r*cos(-a));
          y:=-trunc(r*sin(-a));
          x:=width div 2 + (x -lettersize.cx div 2);
          y:=height div 2 + (y - lettersize.cy div 2);
          ok2:=true;
          letterrect:=rect(x,y,x+lettersize.cx,y+lettersize.cy);

          for j:= 1 to 4 do {check that the letter does not overlap into another quadrant}
          if j<>quadrant then
          begin
            if  intersects(letterrect,quadrantrects[j]) then
            begin
              Ok2:=false;
              break;
           end;
         end;

         if OK2 then {make sure that it does not overlap into another letter}
         begin
           for j:=1 to lettercount do
           begin
             if intersects(letterrect,letterrects[j]) then
             begin
               Ok2:=false;
               break;
             end;
           end;
         end;
         if ok2 then
         begin
           textout(x,y,w[i]);
           inc(lettercount);
           letterrects[lettercount]:=letterrect;
           OK:=true;
         end;
       end;
     end;
   end;

begin
  clearimage;
  with  canvas do
  begin
    m:=5;  {margins - enlarge quadrants by this many pixels to keep letters from
             coming to close to an edge (used in overlap check, letter close to
             an edge will look like it overlaps an adjacent quadrant)}
    quadrantrects[1]:=rect(width div 2-m, 0, width, height div 2+m);
    quadrantrects[2]:=rect(width div 2-m, height div 2-m, width, height);
    quadrantrects[3]:=rect(0, height div 2+m, width div 2+m, height);
    quadrantrects[4]:=rect(0,0 ,width div 2+m, height div 2+m);
    (*
    {just to check quadrant rectangles}
    for i:=1 to 4 do
    begin
      brush.color:=rgb(random(256),random(256), random(256));
      fillrect(quadrantrects[i]);
    end;
    *)
    lettercount:=0;
    addword(w1,1);
    addword(w2,2);
    addword(w3,3);
    addword(w4,4);
  end;
end;

procedure fillCenter(ch:char; canvas:TCanvas; width,height:integer);
var
  p:TagSize;
  minr,maxr:integer;
begin
  with  canvas do
  begin
    {clear the center}
    minr:= width div 15;
    maxr:= width div 2 - minr;
    ellipse(rect(width div 2-minr, height div 2 - minr, width div 2+minr, height div 2+minr));
    {draw the letter}
    font.size:=12;
    p:=textextent(ch);
    textout((width -p.cx) div 2, (height - p.cy) div 2, ch);
    font.size:=10;
  end;
end;

end.
