�
 TF 0�  TPF0TffLeft� TopWidth Height�CaptionRAll Knight's Tours (Sample tours from each square to all 32  valid ending squares)Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenter
OnActivateFormActivateOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInch`
TextHeight TLabelMoveslblLeft�TopQWidthWHeightAnchorsakLeftakBottom CaptionTotal moves tried:   TLabelLabel12Left0Top�WidthwHeightAnchorsakLeftakBottom CaptionBoard size (4x4 to 12x12)  TLabel	GamelevelLeft�TophWidthqHeightCaptionCurent tour being tested  TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:Copyright  � 2000, 2007, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsUnderline 
ParentFontTabOrder   TPanelSolvingPanelLeftToplWidthaHeightAnchorsakLeftakBottom TabOrder TLabelLabel1LeftHTopWidthUHeightCaptionSpeed adjustment  	TTrackBarSpeedbarLeftCTopWidth� Height%Max�OrientationtrHorizontal	FrequencyPosition�SelEnd SelStart TabOrder 	TickMarkstmBottomRight	TickStyletsAutoOnChangeSpeedbarChange  TButtonStopBtnLefttTop� WidthMHeightCaptionStop currentTabOrderVisibleOnClickStopBtnClick  TButton
stopallBtnLeft� Top� WidthYHeightCaptionStop allTabOrderVisibleOnClickstopallBtnClick  	TGroupBox	GroupBox1LeftTop@Width� HeightyCaptionSingle tourTabOrder TLabelLabel2LeftTopWidth3HeightCaption
Start cellFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel4LeftTop4Width0HeightCaptionEnd cellFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TEditStartEdtLeftXTopWidthHeightCharCaseecUpperCaseTabOrder TextA1  TEditEndEdtLeftXTop2WidthHeightCharCaseecUpperCaseTabOrderTextH7  TButtonFind1BtnLeft TopXWidthKHeightCaptionFind 1 tourTabOrderOnClickFind1BtnClick   	TGroupBox	GroupBox2Left� Top@Width� HeightyCaptionAll in QuadrantTabOrder TStringGridStringGrid1Left@TopWidth5Height5ColCountDefaultColWidth	FixedCols RowCount	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRangeSelectgoDrawFocusSelected TabOrder   TButton
FindAllBtnLeftTopXWidthqHeightCaptionFind all in quadrantTabOrderOnClickFindAllBtnClick    TMemoMemo1LeftTopWidth�HeightQColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Lines.StringsA Knight's Tour Investigation; @Does a path exist from every cell to every cell of the opposite color on an 8x8 chess board? CBy symmetry, only start positions in the first quadrant need to be <checked.  Board rotations could move that quadrant to cover Bevery other cell.   There are 32 potential end points for each of ?the 16 squares in the 1st quadrant or 512 altogether.  You can 1select any quadrant to search for its  512 tours. HFrom the "All in Quadrant" panel, select a quadrant (1,2,3, or 4), then Dclick the "Find all in quadrant" button to see a summary of results =displayed here.   Any specific tour may be genrated from the "Single tour" panel. BSearch uses the "Warnsdorf algorithm", cells with fewest availble Imoves going forward are filled first.  If the search as specified fails, >searches in reversed, rotated, and rotated-reversed are tried. 
ParentFont
ScrollBars
ssVerticalTabOrder  TPanelPanel1Left�TopWidthHeight�AnchorsakLeftakTopakRightakBottom CaptionPanel1TabOrderVisible  TRadioGroupRadioGroup1Left�TopWidth	Height9Caption/Max moves  before counting a tour as unsolvableColumns	ItemIndex Items.Strings10010005000 TabOrderOnClickRadioGroup1Click  TOpenDialogOpenDialog1Filter2Constraint files (*.cns)|*.cns|All files (*.*)|*.*Left�   