unit U_PrintRoutines;
{Copyright 2002, Gary Darby, Intellitech Systems Inc., www.DelphiForFun.org

 This program may be used or modified for any non-commercial purpose
 so long as this original notice remains in place.
 All other rights are reserved
 }

interface
Uses controls, stdctrls, grids, windows, classes, graphics, forms;

  Function SetPrintscale(form:TControl):real;
  Procedure Printlabel(Lbl:Tlabel);
  Procedure PrintTable(Grid:TStringGrid);
  Procedure PrintMemo(Memo:TMemo);

implementation

Uses math, printers;

{**************** SetPrintScale ***********}
  Function SetPrintscale(form:TControl):real;
  begin
    result:=min(printer.pagewidth/form.width,printer.pageheight/form.height);
  end;

{************** Printlabel ***********}
Procedure Printlabel(Lbl:Tlabel);
{print a label  at same relative position as the table on the form}
var
  scale:real;
  margins:Trect;
begin
  scale:=setprintscale(TControl(lbl.owner));
  with lbl do
  margins:=rect(trunc(left*scale),trunc(top*scale),
                          trunc((left+width)*scale),
                          trunc((top+height)*scale));
  with printer.canvas do
  begin
    Font.Assign( lbl.Font );
    Font.Color :=clBlack;
    font.height:=trunc(lbl.font.height*scale);
    Pen.Color := clBlack;
    Textout( margins.left,margins.top, lbl.caption );
  end;
end;

{*************** PrintMemo ***************}
Procedure PrintMemo(Memo:TMemo);
{print a memo at same relative position as on the form}
var
  scale:real;
  margins:Trect;
  lineheight,linenbr,linesperpage, i:integer;
begin
  scale:=setprintscale(TControl(memo.owner));
  with memo do
  margins:=rect(trunc(left*scale),trunc(top*scale),
                          trunc((left+width)*scale),
                          trunc((top+height)*scale));
  with printer.canvas do
  begin
    Font.Assign( memo.Font );
    Font.Color :=clBlack;
    font.height:=trunc(memo.font.height*scale);
    Pen.Color := clBlack;
    Lineheight:=5*textheight('Ay') div 4;
    linenbr:=0;
    linesperpage:=(printer.pageheight-2*margins.top) div lineheight;
    for i:=0 to memo.lines.count-1 do
    begin
      Textout(margins.left,margins.top+linenbr*lineheight,memo.lines[i]);
      inc(linenbr);
      If linenbr>linesperpage then
      begin
        printer.newpage;
        linenbr:=0;
      end;
    end;
  end;
end;

{***************** PrintTable *************}
Procedure PrintTable(Grid:TStringGrid);
{Print a stringgrid at same relative position on page as on screen}
  Var
    margins: TRect;
    spacing: Integer;
    Cols: TList;

       {*** Setcolumnwidth ***}
      Procedure SetColumnWidth;
        Var
          i, k, w: Integer;
          scale:real;
          {set column widths to widest cell in column}
        begin
          scale:=SetPrintScale(TControl(grid.owner));

          Printer.Canvas.Font.Style := [fsBold];
          Printer.Canvas.Font.Height := 8*trunc(Grid.canvas.font.height*scale) div 10;

          For i := 0 To Pred( Grid.ColCount ) Do
            Cols.Add( Pointer( Printer.Canvas.TextWidth( Grid.Cells[ i,0 ] )));
          Printer.Canvas.Font.Style := [];
          For i := 1 To Pred( Grid.RowCount ) Do
          For k := 0 To Pred( Grid.ColCount ) Do
          begin
            w:= Printer.Canvas.TextWidth( Grid.Cells[ k, i ] );
            If w > Integer( Cols[ k ] ) Then Cols[ k ] := Pointer( w );
          End; { For }

          {Set margins}
          margins:=rect(trunc(grid.left*scale),trunc(grid.top*scale),
                              trunc((grid.left+grid.width)*scale),
                              trunc((grid.top+grid.height)*scale));

          spacing := Printer.Canvas.Font.PixelsPerInch div 10;

          w := 0;
          For i := 0 To Pred(cols.Count) Do w := w + Integer( cols[ i ] ) + spacing;
          w := w - spacing;
          {If table is wider than page - do something- reduce width of next to last column}
          If w > (margins.right-margins.left ) Then
          repeat
            for i:= 0 to cols.count-1 do cols[i]:= Pointer( Integer( cols[i])-1 );
            dec(w,cols.count);
          until w<=(margins.right-margins.left);
          (*
          begin
            w := w - (margins.right-margins.left );
            cols[ cols.Count-2 ] :=
            Pointer( Integer( cols[ cols.Count-2 ] ) - w );
          End; { If }
          *)
          w:= 0;
          For i := 0 To Pred(cols.Count) Do w := w + Integer( cols[ i ] ) + spacing;
          margins.right := w - spacing + margins.left;
        End; { SetColumnWidth }

{***************** DoPrint *************}
   Procedure DoPrint;
   Var
     i,w,n: Integer;
     y: Integer;

     Procedure DoLine(lineno: Integer);
     Var
       x, n: Integer;
       r: TRect;
       th: Integer;
     begin
       If Length(Grid.Cells[1,lineno]) = 0 Then Exit;
       x:= margins.left;
       With Printer.Canvas Do
       begin
         th := TextHeight( 'Žy' );
         For n := 0 To Pred( Cols.Count ) Do
         begin
           If (n<Grid.fixedcols) or (lineno<grid.fixedrows)
           then font.style:=[fsbold, fsitalic]
           else font.style:=[];
           r := Rect( 0, 0, Integer(Cols[ n ]), th);
           OffsetRect( r, x, y );
           TextRect( r, x, y, Grid.Cells[ n, lineno ] );
           x := r.right + spacing;
          End; { For }
        End; { With }
        y := y + th;
      End; { DoLine }

    Procedure DoHeaders;
    var
      n:integer;
      begin
        y:= margins.top;
        With Printer.Canvas Do
        begin
          {Font.Style := [ fsBold, fsItalic ];}
          for n:= 0 to pred(grid.Fixedrows) do DoLine( n );
          Pen.Width := Font.PixelsPerInch div 72;
          Pen.Color := clBlack;
          MoveTo( margins.left, y );
          LineTo( margins.right, y );
          Inc( y, 2 * Pen.Width );
        End; { With }
       End; { DoHeader }

    begin {Doprint}
      y:= 0;
      DoHeaders;
      For i := Grid.fixedrows To Pred( Grid.RowCount ) Do
      begin
        DoLine( i );
        If y >= margins.bottom Then
        begin
          Printer.NewPage;
          y:= 0;
        End; { If }
      End; { For }

      {Draw left vertical separator line}
      w:=margins.left;
      For n := 0 To Pred( grid.fixedcols) Do w:=w+Integer(Cols[ n ])+spacing;
      w:=w- spacing div 2;
      with printer.canvas do
      begin
        moveto(w,margins.top);
        lineto(w,y);
      end;
    End; { DoPrint }

   begin {Printtable}
      cols:=nil;
      try
        Cols:= TLIst.Create;
        SetColumnWidth;
        Application.ProcessMessages;
        DoPrint;
      finally
        Cols.Free;
      end;
  end; {PrintTable }

end.
