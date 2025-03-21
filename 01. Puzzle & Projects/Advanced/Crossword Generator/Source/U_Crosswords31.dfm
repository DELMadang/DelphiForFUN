�
 TFORM1 0E(  TPF0TForm1Form1Left%TopHWidthRHeight�CaptionCrossword Generator V3.1Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Menu	MainMenu1OldCreateOrderPositionpoDesktopCenter
OnActivateFormActivateOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInch`
TextHeight TPageControlPageControl1Left Top WidthBHeight+
ActivePagePuzzleSheetAlignalClientTabOrder  	TTabSheetIntroCaptionOverview
ImageIndex TMemoMemo2Left(TopWidth�Height�Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Lines.StringsSHere is a program that will generate Crossword  or WordSearch puzzles based on user\specified wordlist files.   Users may specify which puzzle type is creatred, the minimum andImaximum word lengths to use, and the maximum number of words to generate. Version 3 changes:Y There is now an "Extended Search" option which will generate multiple crossword puzzles ](up to 1,000) attempting to include the number of words specified.   This may be useful when `we want to use to all the words in a relatively short list.  (Try new sample files "names.txt", b"continents.txt", "fruits.txt" for samples.)  Initial words and final puzzles are centered on the _board increasing the chance that all words can be fit.  Primary word list is displayed and may /be modifed by the user from within the program.  
Word Lists-----------------aWord lists used to create puzzles are text files with each line having the format "word=clue" .  TUsers may specifiy Primary and Secondary word lists with the secondary used only if Cnecessary to create the requested number of words in the puzzle.    \For WordSearch puzzles, only the word portion is used.  For Crossword puzzles an additional Vpage "Add/Modify Clues" is displayed where the user can modify or add clues for words ^used in the puzzle.   Changed clues can be saved back to the original word file or with a new 
file name. \The default wordlist is "small.txt" and contains 1577 common, general words.  Several other fsample topical files are included (e.g. birds.txt, skeleton.txt, elements.txt).  Small.txt has only a _few clues filled in; the others may or may not have clues filled in depending on how much time I have to work on them. UIf you build any additional topical wordlists and would like to share - send them to @feedback@delphiforfun.org and I'll add them to the distribution.  
ParentFont
ScrollBars
ssVerticalTabOrder    	TTabSheetPuzzleSheetCaptionPuzzle TLabelLabel1LeftToppWidthjHeightCaptionWord length rangeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel3LeftTop� WidthHeightCaptionMinFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel4Left@Top� WidthHeightCaptionMaxFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel2LeftTop� Width� HeightCaptionTarget number of wordsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel5LeftTop Width>HeightCaption
Board sizeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel6LeftTop0Width� HeightCaptionHorizontal   X  VerticalFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel7Left@Top@Width	HeightCaptionXFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelCountLblLeft� Top� WidthHeightCaption00Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelWordlistlblLeftTop� Width� HeightCaptionPrimary wordlist wordsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabel	PuzzleLblLeft`TopWidth(HeightCaptionPuzzleFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TStringGrid	BoardGridLeft_TopWidth�Height�ColCountDefaultColWidthDefaultDrawing	FixedCols RowCount	FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Options
goVertLine
goHorzLinegoRangeSelect 
ParentFontTabOrder 
OnDrawCellBoardGridDrawCell  	TSpinEditMinWordSizeLeftTop� Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValueMinValue
ParentFontTabOrderValue  	TSpinEditMaxWordSizeLeft@Top� Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValueMinValue
ParentFontTabOrderValue  TButtonGenerateBtnLeft� Top Width� HeightCaptionGenerate CrosswordFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickGenerateBtnClick  	TSpinEditMaxwordsLeftTop� Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValue2MinValue
ParentFontTabOrderValue  	TSpinEditHsizeedtLeftTop@Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValueMinValue
ParentFontTabOrderValueOnChangeSizeedtChange  	TSpinEditVSizeedtLeftXTop@Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValueMinValue
ParentFontTabOrderValueOnChangeSizeedtChange  TMemoMemo1LeftTopWidthHeight� Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrderOnChangeMemo1Change  TButtonWordSearchBtnLeft� TophWidth� HeightCaptionGenerate Word SearchFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickWordSearchBtnClick  TButton
PreviewBtnLeft� Top� Width� HeightCaptionPrint preview...Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder	OnClickPrintpreview1Click  	TCheckBoxExtendedBoxLeft� Top@Width� HeightHint-Try to fit target # of words up to 1000 timesCaptionExtended X-word searchFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontParentShowHintShowHint	TabOrder
  TMemoMemo3LeftTopWidthHeight� Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrderOnChangeMemo1Change   	TTabSheet
CluesSheetCaptionAdd/Modify Clues
ImageIndex TLabelLabel8LeftHTopWidth'HeightCaptionAcrossFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel9LeftHTopWidth!HeightCaptionDownFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel10Left� TopWidth!HeightCaption2Doubleclick or press F2 to enter  or change a clue  TStringGrid
AcrossgridLeftHTop(Width�Height� ColCount	FixedColsRowCountOptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRangeSelect	goEditing TabOrder OnSetEditTextCluesGridSetEditText
RowHeights   TStringGridDowngridLeftHTop Width�Height� ColCount	FixedColsRowCountOptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRangeSelect	goEditing TabOrderOnSetEditTextCluesGridSetEditText    
TStatusBar
StatusBar1Left Top+WidthBHeightPanelsTextWord list: Width^ TextPuzzle: UntitledWidth�   SimplePanel  TStaticTextStaticText1Left Top>WidthBHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption9Copyright  � 2003-2008, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsUnderline 
ParentFontTabOrderOnClickStaticText1Click  	TMainMenu	MainMenu1Left�Top 	TMenuItemFile1CaptionFile 	TMenuItemOpenwordlist1CaptionOpen word list...OnClickOpenwordlist1Click  	TMenuItemSavewordlist1CaptionSave word listOnClickSavewordlist1Click  	TMenuItemSavewordlistas1CaptionSave word list as...OnClickSavewordlistas1Click  	TMenuItemN3Caption-  	TMenuItemEnterchangeTitle1CaptionEnter/change TitleOnClickEnterchangeTitle1Click  	TMenuItemN2Caption-  	TMenuItemPrinterSetup1CaptionPrinter SetupOnClickPrinterSetup1Click  	TMenuItemPrintpreview1CaptionPrint previewOnClickPrintpreview1Click  	TMenuItemPrint1CaptionPrint puzzle OnClickPrintpreview1Click  	TMenuItemN1Caption-  	TMenuItemExit1CaptionExitOnClick
Exit1Click    TOpenDialogOpenWordsDLG1Filter,Text files (*.txt)|*.txt|All files (*.*)|*.*TitleSelect primary words file LeftpTop  TSaveDialogSavePuzzleDlgFilter)Puzzles (*.puz)|*.puz|All files (*.*)|*.*Left�Top  TPrintDialogPrintDialog1Left�Top  TOpenDialogOpenPuzzleDlgFilter)Puzzles (*.puz)|*.puz|All files (*.*)|*.*OptionsofNoValidateofPathMustExistofFileMustExistofEnableSizing LeftPTop  TSaveDialogSaveWordsDlgFilter,Text files (*.txt)|*.txt|All files (*.*)|*.*Left�Top  TOpenDialogOpenWordsdlg2Filter,Text files (*.txt)|*.txt|All files (*.*)|*.*TitleSelect secondary words file LeftpTop(  TPrinterSetupDialogPrinterSetupDialog1LeftTop   