�
 TSPELLBOUNDFORM 0�  TPF0TSpellboundformSpellboundformLeftTopx
AutoScrollCaptionSpellbound V2.0ClientHeightUClientWidth[Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Menu	MainMenu1OldCreateOrder	PositionpoScreenCenterScaled
OnActivateFormActivateOnCreate
FormCreatePixelsPerInch`
TextHeight TStaticTextStaticText1Left Top?Width[HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption5   Copyright  © 2016, Gary Darby,  www.DelphiForFun.orgColorclCreamFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline ParentColor
ParentFontTabOrder TransparentOnClickStaticText1Click  TPanelPanel1Left Top Width[Height?AlignalClientParentColor	TabOrder TLabelLabel1LeftlTop8WidthjHeightCaptionScrambled LettersFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel2LeftlTopXWidthUHeight$AutoSizeCaptionWord Lengths: (3 to 7 letters)Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TLabelLabel6LeftlTopWidth�HeightCaptionAGiven a set of letters, find all words within given  length rangeFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel7LeftTop�Width� Height Caption;Load a larger or smaller dictionary  (small, general, full)WordWrap	  TLabelDicLblLeftTop'Width$HeightCaptionDicLbl  TLabelScoreLblLeft�Top� Width� HeightCaptionScores: User 0   Computer 0  TMemoMemo1LeftTopWidthHeight�Color��� Lines.Strings!Spellbound is the name of a game available online from the games$section of the AARP website (search "AARP Spellbound" to find it). !The objective is to find as many $words as possible  from a given set (of letters in a limited amount of time.  -I wrote the original version version to help &improve my scores by searcing out the ,words for me. This version (V2.0) adds user 'play while the program searches in the *background, but it can hardly be called a fair competition. (The program restarts its search whenever%1. The word size to search is changed*2. The generate and new random letter set button is clicked)3. You enter your own set of letters and -press Enter or the "Use these for search" is clicked.   
ScrollBars
ssVerticalTabOrder   TEdit
LettersEdtLeft�Top3Width� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderTextmonarch
OnKeyPressLettersEdtKeyPress  TUpDownUpDown1Left�Top}WidthHeight	AssociateWordLengthEdtMinMaxPositionTabOrder  TEditWordLengthEdtLeftpTop}WidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderText5OnChangeWordLengthEdtChange  TButton
LoadDicBtnLeftTop�Width� HeightCaptionChange DictionaryTabOrderOnClickLoadDicBtnClick  TButtonGenerateBtnLeft�Top0Width� HeightCaptionNew random letter setTabOrderOnClickGenerateBtnClick  TPageControlPageControl1Left`Top� Width�Height
ActivePage	TabSheet1Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontRaggedRight	TabOrder 	TTabSheet	TabSheet1CaptionUser resultsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont TLabelLabel5LeftTop(Width� Height)AutoSizeCaption1Enter your next word guess  below and press EnterWordWrap	  TLabelLabel8Left� TopWidth\HeightCaptionUser Word ListFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFont  TEditEdit1LeftTopSWidth� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder 
OnDblClickEdit1DblClick
OnKeyPressEdit1KeyPress  TMemoUserWordListLeft� Top Width� Height� ParentShowHintReadOnly	
ScrollBars
ssVerticalShowHintTabOrder   	TTabSheet	CompSheetCaptionProgram resultsFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ImageIndex
ParentFont TLabelTimeLblLeft	TopjWidth$HeightCaptionTime:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TLabelLabel9Left� TopWidthqHeightCaptionProgram word list  TMemoMemo3Left� Top Width� Height� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold Lines.Strings       
ParentFontParentShowHint
ScrollBars
ssVerticalShowHintTabOrder  TButtonStopBtnLeftTop,Width� HeightCaptionStopFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder WordWrap	OnClickStopBtnClick    TButton	SearchBtnLeft�TopTWidthYHeightCaptionUse these letters for searchTabOrderOnClickSearchBtnClick   	TMainMenu	MainMenu1Left�Top8 	TMenuItemOptions1CaptionOptions 	TMenuItem
UseabbrevsCaptionInclude abbreviationsOnClickoptionchange  	TMenuItem
UseforeignCaptionInclude foreign wordsOnClickoptionchange  	TMenuItemUsecapsCaptionInclude capitialized wordsOnClickoptionchange  	TMenuItemChangeDictionary1CaptionChange Dictionary     