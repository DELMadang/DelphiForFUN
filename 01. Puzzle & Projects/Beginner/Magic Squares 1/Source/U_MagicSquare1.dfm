�
 TFORM1 0�  TPF0TForm1Form1LeftzTopqWidth�Height.Caption Magic Squares of odd size, V 1.1Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder
OnActivateFormActivatePixelsPerInch`
TextHeight TLabelLabel1Left"Top�Width� HeightCaptionEnter odd number order: (<=51):  TLabelSumLblLeft� Top�Width� Height)AutoSizeCaptionSumLblVisibleWordWrap	  TStringGridStringGrid1LeftKTopWidth� Height� DefaultColWidth	FixedCols 	FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLine 
ParentFont
ScrollBarsssNoneTabOrder  TBitBtnCalcBtnLeft!Top�WidthxHeightCaption	CalculateTabOrder OnClickCalcBtnClick  TEditIntEdit1LeftTop�Width1HeightTabOrderText5
OnKeyPressIntEdit1KeyPress  TMemoMemo1LeftTop Width1HeightqColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings/A magic square of order N conrtains all of the *integers from 1 to NxN arranged in an NxN /matrix so that the sum of the integers in each +row, column and corner-to-corner diagonals adds to a common sum. /This program builds Magic Squares of odd order 1(1,3,5,7, etc.) for orders up to 51.  It uses an *algorithm known for at least 500 years as follows: 1"Start with 1 in the middle of the top row; then /go up and left assigning numbers in increasing 4order to empty cells; if you fall off of the square ,imagine the same square as tiling the plane /and continue; if a cell is occupied, move down instead and continue." 0March 2017:  Version  1.1; after 17 years, just /discovered and fixed grid sizing error for 3X3 grid . 
ParentFont
ScrollBars
ssVerticalTabOrder  TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption#   Copyright © 2000, 2017  Gary DarbyFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderTransparent   