�
 TWORDLADDERFORM 0Q  TPF0TWordLadderFormWordLadderFormLeft�Topk
AutoScrollAutoSize	CaptionWord LadderClientHeight�ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenter
OnActivateFormActivateOnClose	FormCloseOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInch`
TextHeight TBevelBevel1Left Top Width�Height�AlignalClient  TLabelStepsLblLeft`Top�Width7HeightCaption0 StepsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel1Left�Top:Width\Height0Caption&Click to set up these addional samplesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontWordWrap	  TLabelLabel2Left�TopWidthHeightCaptiontoFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel3Left� TopjWidth;Height'CaptionMaximum list length to checkWordWrap	  TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright  © 2001-2009, Gary Darby,  www.DelphiForFun.orgColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline ParentColor
ParentFontTabOrder TransparentOnClickStaticText1Click  TButtonStopBtnLeftTopjWidth� Height9CaptionStopTabOrderVisibleOnClickStopBtnClick  TEditFromEdtLeftPTopWidthyHeightTabOrderTextDUCK  TEditToEdtLeft�TopWidthyHeightTabOrderTextBILL  TButton
DFSolveBtnLeftTopoWidth� HeightCaptionSolve (Depth first)TabOrderOnClickDFSolveBtnClick  TListBoxSolutionListBoxLeftPTopbWidth� Height
ItemHeightTabOrder  TEditMaxWordsEdtLeftTopmWidthHeightTabOrderText10  TUpDownMaxLevelLeft1TopmWidthHeight	AssociateMaxWordsEdtMinMax2Position
TabOrder  TButton
BFSolveBtnLeftTop�Width� HeightCaptionSolve (Breadth first)TabOrderOnClickBFSolveBtnClick  TListBoxListBox2Left�TopbWidthyHeight
ItemHeightItems.StringsOIL-GAS	PONY-CART	HATE-LOVE	MORE-LESS	WARM-COLD	TAKE-GIVE	MICE-RATSSLEEP-DREAM	FOOL-WISETEARS-SMILEFLOUR-BREADGRASS-GREEN	ARMY-NAVY	BLUE-PINKSUMMER-WINTERWHITE-BLACKSTONE-MONEYSMOKES-CANCER   TabOrder	OnClickListBox2Click  TMemoMemo1LeftTopWidth1Height@Color��� Lines.Strings>A Word Ladder is a string of valid words each differing by one>letter from the word above.  You are given the first and last Ewords in the ladder.  It is your job to fill in the words in between. :You can try the samples given on your own with pencil and .paper.   Or you can see the prgram's solution. >The depth-first search changes one letter in the first word to<produce a second word which most closely matches the target ?word.  It  then finds a letter to change in the second word to =produce a third word, etc. following each each string of new Bwords down as far a possible (or until, the max depth limit value Cis reached).  It then backs up one word and tries the next letter, Betc.  This type of search  will eventually find a solution if one 2exists,  but it may not be the shortest solutuion. @Breadth first searches, on the other hand, will check all words >with a single letter changed from the starting word, then all Bwords at the second level down from the top, etc, until the final >word is found.  This solution may require more tests, but the ;solution found is guaranteed to be the shortest because we ;have checked all possible solutions for any shorter ladder before we get to each level. TabOrder
  TButtonLoadBtnLeft�Top�WidthyHeightCaptionChange  dictionaryFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameLoadBtn
Font.Style 
ParentFontTabOrderOnClickLoadBtnClick   