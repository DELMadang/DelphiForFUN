�
 TFORM1 0�  TPF0TForm1Form1Left� TopYCaption=Combinations and Permutations  (Test TComboSet)   Version 2.0ClientHeight�ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderPositionpoScreenCenterScaledOnCreate
FormCreatePixelsPerInchx
TextHeight TLabelLabel2LeftYTop+WidthWHeightCaptionthings takenFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel3Left� Top+Width>HeightCaption	at a timeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelCountLblLeftETopWidth>HeightCaptionCount: 0Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel5LeftTopWidthHeightCaptionNFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel6Left� TopWidthHeightCaptionRFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TEditEdit1LeftTop'Width9HeightTabOrder Text4OnChangeEdit1Change  TEditEdit2Left� Top'Width#HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderText3OnChangeEdit2Change  TUpDownNCountLeftATop'WidthHeight	AssociateEdit1MaxXPositionTabOrderOnClickNCountClick  TUpDownRCountLeft� Top'WidthHeight	AssociateEdit2Max
PositionTabOrder  TMemoMemo1LeftETop%Width�Height�Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsPThis program tests the generating options of our TComboset class, a class which 9generates combinations and permutations of various types.    UTComboset can generate subsets from a set of numbers in 10 different ways.  Briefly, Q"Permutations" represent all possible subsets of R objects selected from N.  For QCombinations, no two subsets contain the same members.   Normally each subset is Rcreated "Wtihout Replacement" so no subset will contain the same member more than Ronce.  "With Replacement" or "With repeats" allows the same member to be selected multiple times within a subset.    UFinally subsets themsels may be listed "Lexicographically", the way they appear in a Pdictionary, or in the reversed sequence, "Lexicographically descending" or "Lex down".      VFor Combinations, it is sometimes useful to generate subsets in a different sequence, V"CoLexicographically", where the order of each subset is determined as if its members Rwere arranged from high to low, even though they are listed in normal low to high 	order.    YFor a  more complete description of the terms and types, click the link at the bottom of #this page and search for TComboset.    QVersion 2 expands the range of combinations by using Int64 (64 bit) integers for calculations.  
ParentFont
ScrollBars
ssVerticalTabOrder  TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright  © 2005, 2013 Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1ClickExplicitWidthc  TEditNamesLeftTop@Width�HeightTabOrderTextApple,  Banana, Grape, Pear  TPageControlPageControl1LeftTophWidth� Height� 
ActivePage	TabSheet1Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder 	TTabSheet	TabSheet1CaptionGenerateExplicitLeft ExplicitTop ExplicitWidth ExplicitHeight  TLabelLabel1LeftTop)Width� Height@AutoSizeCaption@(For this program, lists are limited to the first 1000 subsets.)WordWrap	  TButton	GenAllBtnLeftTopWidthaHeightCaption AllFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder OnClickComputePBtnClick  TButton	RandomBtnLeftpTopWidthyHeightCaptionRandomTabOrderOnClickRandomBtnClick   	TTabSheet	TabSheet2CaptionRank/Unrank
ImageIndexExplicitLeft ExplicitTop ExplicitWidth ExplicitHeight  TLabelLabel7LeftTopWidth� HeightCaptionReturn rank from subset  TLabelLabel8LeftTop@WidthYHeightDAutoSizeCaptionReturn subset from rankFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TButtonRankBtnLeft� TopWidthKHeightCaptionRankTabOrder OnClickRankBtnClick  TEditEdit4LefthTopJWidthyHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderText4  TEditEdit5LeftTopWidthyHeightTabOrderText1,2,3  TButton	UnRankBtnLeft� TopkWidthKHeightCaptionUnRankFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickUnRankBtnClick    TRadioGroupGenRGrpLeftTopPWidthHeightCaptionTypeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 	ItemIndex Items.StringsPermutations Lex upPermutations Lex downPermutationsRepeat Lex upPermutationsRepeat Lex downCombinations Lex upCombinations Lex downCombinationsRepeat Lex upCombinationsRepeat Lex downCombinations CoLex upCombinations CoLex down 
ParentFontTabOrder  	TCheckBoxUseNamesLeftTop0WidthHeightCaptionKUse these N strings instead of numbers  (Enter N names separated by commas)TabOrder	   