�
 TFORM1 0  TPF0TForm1Form1Left� Top2Width�HeightCaptionWRally Version 2.0 - Adapted from book "Playthinks",  Ivan Moscovich, Workman PublishingColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderPositionpoDesktopCenterScaledWindowStatewsMaximized
OnActivateFormActivateOnResize
FormResize
DesignSize�� PixelsPerInchx
TextHeight TImageImage1Left�Top� Width�Height�AnchorsakLeftakTopakRightakBottom   TMemomemo1LeftTopWidth�HeightIBorderStylebsNoneColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings?32 marbles can move in horizontal or  vertical tracks.  A move ;consists of rotating  marbles in either track clockwise or Ccounterclockwise for as many positions as desired.The objective is ?to transform  the red marble square into a blue marble square.  >It can be solved in three moves!  (Or nine moves if you shift >marbles only one position per move.).  How close can you come? HVersion 2 adds a "Search" button which  displays solutions that have 8, J9, or 10 single  moves. Solutions for each depth are listed in text formatGbut not animated.  You can check any solution by manually entering the moves listed. 
ParentFont
ScrollBars
ssVerticalTabOrder  TButtonResetBtnLeftHTop{Width� HeightAnchorsakLeftakBottom CaptionResetFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder OnClickResetBtnClick  	TGroupBoxMoveBoxLeftTopWidth!HeightAnchorsakLeft CaptionManual play movesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder TLabelLabel1LeftTop Width� HeightCaptionHow  many positions?Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel2LeftTop� WidthjHeightCaptionMove Count: Font.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelMoveCountLblLeftpTop� WidthHeightCaption0Font.CharsetDEFAULT_CHARSET
Font.ColorclGreenFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  	TSpinEdit	MoveCountLeft� TopWidth1HeightMaxValueMinValueTabOrder Value  TButtonHCWBtnLeftTopHWidthHeightCaptionHorizontal  Clockwise (HCW)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickHCWBtnClick  TButtonHCCWBtnLeftToppWidthHeightCaption#Horizontal Counter Clockwise (HCCW)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickHCCWBtnClick  TButtonVCWBtnLeftTop� WidthHeightCaptionVertical Clockwise (VCW)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickVCWBtnClick  TButtonVCCWBtnLeftTop� WidthHeightCaption!Vertical Counter Clockwise (VCCW)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickVCCWBtnClick   TButton	ShowmeBtnLeftpTopKWidth� HeightAnchorsakLeftakBottom CaptionSearchFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderOnClickShowmeBtnClick  TMemoMemo2LeftTophWidth�Height� Lines.StringsSearch button results: 
ScrollBars
ssVerticalTabOrder  TRadioGroup	SearchboxLeftXTopWidth� Height9CaptionMax search depthColumns	ItemIndex Items.Strings8910 TabOrder  TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption;   Copyright  © 2002, 2010, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click   