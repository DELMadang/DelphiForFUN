�
 TEXPLAINDLG 0  TPF0TExplainDlg
ExplainDlgLeft� ToptBorderStylebsDialogCaptionMagic Matric ExplanationClientHeight�ClientWidth�Color	clBtnFace
ParentFont	OldCreateOrder	PositionpoScreenCenter
OnActivateFormActivatePixelsPerInch`
TextHeight TLabel	ResultlblLeftHTop� WidthHeightCaptionxxxx  TButtonOKBtnLeftGTop� WidthKHeightCaptionOKDefault	ModalResultTabOrder   TMemoMemo1LeftTopWidthHeightiColorclYellowFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Lines.Strings/The magic matrix is actually an addition table *with the sum of the row and column header #values equal to the magic number.   (At right,  we have generated a playable (sample 4X4 matrix whose magic number is +36. The numbers used to generate the table (displayed in the yellow squares - these ,values are NOT normally visible in the real magic matrix..    ,Notice that the number in each of the white .cells is the sum of the column header and the *row header numbers.When we select a cell, -we are selecting the sum of these two header -values.  When we select a cell from each row ,and column, we have selected the sum of all +of the row and column header values, which )of course is the magic number because we made it that way. 
ParentFontTabOrder  TStringGridStringGrid1LeftHTopWidth� Height� DefaultColWidth DefaultDrawing
FixedColorclYellowTabOrderOnClickStringGrid1Click
OnDrawCellStringGrid1DrawCell   