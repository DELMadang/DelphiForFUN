�
 TFORM1 0�  TPF0TForm1Form1Left�TopVWidthJHeight�CaptionMind Your ABCD's   Version 2.0Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderPositionpoScreenCenter
OnActivateFormActivatePixelsPerInchx
TextHeight TStaticTextStaticText1Left TopAWidthBHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright © 2016-2017,  Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrder OnClickStaticText1Click  TPanelPanel1Left Top WidthBHeightAAlignalClientTabOrder
DesignSizeBA  TLabelLabel1LeftTophWidth� HeightCaptionSelect a puzzle to load  TMemoMemo1LeftTop#WidthHeight.AnchorsakLeftakTopakRightakBottom Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsKPlace one of A, B, C, D into each of the 25 empty cells so that the number Jof letters in each row and column areas is as  indicated by the numbers.  RIdentical letters cannot be next to each other in the grid either horizontally or Kvertically. This puzzle, based on the August 11, 2016 daily Mensa Calendar OPuzzle, aids solving by automatically updating the available letter as letters are entered.  GTo play, enter one letter per cell.  Change a letter by typing over it Jwhich updates counts appropriately.   Remove a letter by selecting it and Husing the "Del" key or entering a space character. The puzzle is solved  when all count cells are zero.   LHint: The "no duplicate adjacent cells" rule,requires a fixed placement for 7any row or column with a count value 3 for that letter. KThe "Solve" button will display moves made at a rate selected by the user. GThe "Debug" radio button shows all placements attempted as well as the successful placements. JThere is currently only one puzzle available, but more may be added in theJfuture.  Search "Mind Your ABCDs" at delphiforfun.org for more informationabout the program. FVersion 2.0 adds a second puzzle and modifies the Load button to allow&selection of the the case to be loaded  
ParentFont
ScrollBars
ssVerticalTabOrder   TStringGridStringGrid1LeftToptWidth�Height�ColCount	DefaultColWidthDefaultRowHeight	FixedCols RowCount		FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBold OptionsgoAlwaysShowEditor 
ParentFontTabOrder
OnDrawCellStringGrid1DrawCell	OnKeyDownStringGrid1KeyDown
OnKeyPressStringGrid1KeyPress  TButtonSolveBtnLeftTop&Width� Height Caption Solve it for meTabOrderOnClickSolveBtnClick  TMemoMemo2LeftPTop~Width�Height�Lines.Strings  
ScrollBarsssBothTabOrder  	TCheckBoxDebugBoxLeft5Top$WidthHeightCaptionDebug  (show actions)TabOrderOnClickDebugBoxClick  TRadioGroupCrNbrGrpLeft	TopWidth Height?CaptionColumn/Row Numbering Color	clBtnFaceColumns	ItemIndexItems.StringsStart from 0Start from 1 ParentColorTabOrderVisibleOnClickCrNbrGrpClick  TRadioGroupSpeedGrpLeftTop^Width� HeightgCaptionDelay between messagesColumnsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 	ItemIndexItems.Strings00.250.501.02.0Pause  
ParentFontTabOrderOnClickSpeedGrpClick  TListBoxListBox1LeftTop�Width	Height9
ItemHeightItems.StringsPuzzle 1: August 11, 2016Puzzle 2: September 7, 2017 TabOrderOnClickListBox1Click    