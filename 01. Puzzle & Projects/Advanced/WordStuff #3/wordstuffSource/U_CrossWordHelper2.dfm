�
 TWORDCOMPLETEFORM 0   TPF0TWordCompleteFormWordCompleteFormLeft�Top� Width7Height�BorderWidthCaptionWord Completion  V2.4Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Menu	MainMenu1OldCreateOrder	PositionpoScreenCenter
OnActivateFormActivatePixelsPerInchx
TextHeight TLabelLabel1LeftTopWidth�HeightdCaption�Enter known letters, use '-',  '_',  '/', or '?' for single unknown letters. Use asterisk (*) for multiple unknown letters.   Words with a single missing letter may optionally be anagrammed  to find all possible words. Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	  TLabelLabel2LeftTop� Width�HeightKAutoSizeCaptionxCandidate words can be filtered by specifying letters which must or cannot be used to fill the missing letter positions Font.CharsetDEFAULT_CHARSET
Font.Color� @ Font.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	  TButtonSolveBtnLeft(TopWidth� Height"CaptionSearchFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderOnClickSolveBtnClick  TEditEdit1LeftTop� Width� HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder Text_a_o_n_
OnKeyPressEdit1KeyPressOnKeyUp
Edit1KeyUp  TListBoxListBox1LeftSTopWidth� Height`Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ItemHeight
ParentFontTabOrder  TButtonLoadBtnLeft$Top�Width� HeightCaptionChange dictionaryFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickLoadBtnClick  TEditIncExcLettersLeftTop�Width�HeightFont.CharsetDEFAULT_CHARSET
Font.Color� @ Font.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderTextkl  TStaticTextStaticText1Left Top%Width-HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption9   Copyright  © 2001-201, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsUnderline 
ParentFontTabOrderOnClickStaticText1Click  TRadioGroup	IncExcGrpLeftTop4WidthHeight� CaptionWord completion filtering Font.CharsetDEFAULT_CHARSET
Font.Color� @ Font.Height�	Font.NameArial
Font.Style 	ItemIndexItems.StringsFill from letters below)0Added letter(s) must NOT come from letters belowNo filtering 
ParentFontTabOrderOnClickIncExcGrpClick  	TCheckBox
AnagramBoxLeftTop� Width�HeightCaption*Add a letter and unscramble when searchingFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder  	TMainMenu	MainMenu1Left�Top� 	TMenuItemOptions1CaptionOptions 	TMenuItem
UseabbrevsCaptionInclude abbreviations  	TMenuItem
UseforeignCaptionInclude foreign wordsOnClickIncludeMenuItemClick  	TMenuItemUsecapsCaptionInclude capialized wordsOnClickIncludeMenuItemClick     