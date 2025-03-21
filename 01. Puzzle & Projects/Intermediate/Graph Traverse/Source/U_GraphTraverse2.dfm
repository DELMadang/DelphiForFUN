�
 TFORM1 0�  TPF0TForm1Form1Left� TopaWidthrHeightrCaption>Graph Traverse V2.0 :  Find max and min paths through the gridColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderShowHint	OnCreate
FormCreatePixelsPerInch`
TextHeight TLabelLabel1LeftTopxWidthEHeightCaptionPaths tried:'  TLabelLabel2LeftTop�WidthPHeightCaptionRun seconds:  TLabelLabel3LeftSTop�WidthHeightColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style ParentColor
ParentFont  TLabelLabel7LeftTop�Width8HeightCaptionMax Path  TLabelLabel4LeftPTop�WidthHeightColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style ParentColor
ParentFont  TLabelLabel8LeftTop�Width9HeightCaption	Min Path:  TLabelLabel9LeftTop`WidthBHeightCaptionBoard size:  TButtonSolveBtnLeft�Top@Width� HeightCaptionV1: Solve (Search all paths)TabOrder OnClickSolveBtnClick  TButtonGenerateBtnLeft�TopWidth� HeightCaptionGenerate random boardTabOrderOnClickGenerateBtnClick  TMemoMemo1LeftTopWidthyHeight9Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings1Find the  largest and smallest paths through the 6number grid as you move from 'S' to 'F'.    Paths can 7move horizontally or diagonally to the right but never 6to the left. The size of a path is the sum of all the numbers in the path.  4Version 1 does an exhaustive search of all possible 9paths through a grid to find the liargest and smallest.   /Version 2 adds a "left to right" search where  5additional arrays are built with the numbers in each -column  replaced by the maximum (or minimum) 5path sum to that position.  This is very fast, up to 51000 times faster than exhaustive search, because it 2only requires checking the (maximum of) 3 sums in 4the preceding column for each sum being calculated.   
ParentFontTabOrder  TStaticTextStaticText1Left Top:WidthbHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterBorderStyle	sbsSunkenCaption@   Copyright  © 2001-2003, 2008, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click  TButtonSmartSolveBtnLeft�TophWidth� HeightCaption$V2: Solve (Left to right sum search)TabOrderOnClickSmartSolveBtnClick  TPageControlPageControl1Left�Top� Width�Height�
ActivePage	TabSheet1TabOrderOnChangePageControl1Change
OnChangingPageControl1Changing 	TTabSheet	TabSheet1CaptionProblem valuesHighlighted	OnEnterTabSheetEnterOnExitTabSheetExit TStringGridStringGrid1LeftTopWidthYHeightUBorderStylebsNoneColorclWhiteColCountDefaultColWidthDefaultRowHeightDefaultDrawing	FixedCols RowCount	FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBarsssNoneTabOrder 
OnDrawCellStringGrid1DrawCell   	TTabSheet	TabSheet2CaptionMin sum values
ImageIndexOnEnterTabSheetEnterOnExitTabSheetExit TStringGridStringGrid2LeftTopWidthYHeightUHint)Display the minimum sum path to each cellBorderStylebsNoneColorclWhiteColCountDefaultColWidthDefaultRowHeightDefaultDrawing	FixedCols RowCount	FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBarsssNoneTabOrder 
OnDrawCellStringGrid1DrawCell   	TTabSheet	TabSheet3CaptionMax sum values
ImageIndexOnEnterTabSheetEnterOnExitTabSheetExit TStringGridStringGrid3LeftTopWidthYHeightUHint)Display the maximum sum path to each cellBorderStylebsNoneColorclWhiteColCountDefaultColWidthDefaultRowHeightDefaultDrawing	FixedCols RowCount	FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBarsssNoneTabOrder 
OnDrawCellStringGrid1DrawCell    	TCheckBox
AnimateBoxLeft�Top8Width� Height!CaptionShow paths as checked (V1 only)TabOrderWordWrap	OnClickAnimateBoxClick   