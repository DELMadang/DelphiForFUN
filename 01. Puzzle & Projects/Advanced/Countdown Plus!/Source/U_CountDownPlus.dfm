�
 TFORM1 0H  TPF0TForm1Form1Left TopWWidth=HeightOCaptionCountdown Plus!Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenter
OnActivateFormActivateOnCloseQueryFormCloseQueryPixelsPerInch`
TextHeight TLabelLabel1LeftpTop WidthQHeightAAutoSizeCaptionNbr.  of input valuesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontWordWrap	  TLabelLabel2Left�TopHWidthaHeight)AutoSizeCaptionMax solutions to showWordWrap	  TLabelTimelblLeft�TopPWidth� Height9AutoSizeCaption$x.x seconds,    xxxxxxxx expressionsWordWrap	  TLabelCountlblLeft�TopxWidth+HeightCaptionCount  TMemoMemo2Left�TopWidthYHeight!Lines.StringsSolutions display here TabOrder  TMemoMemo1LeftTopWidthQHeight�ColorclYellowFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold Lines.Strings&CountDown is a British TV program (or +programme)  with an anagram verbal segment )and an "expression search"  mathematical /segment. The objective is to rearrange some or /all of six semi-randomly selected numbers into ,a parenthisized arithmetic expression whose *value is  closest to a given target value. +This program solves generalized expression /search problems through brute force searching.  -In this version, operators may be optionally .excluded and up to 9 input values are allowed. *The "Use all input values" checkbox omits 1solutions that do not use all input values.  --- 2The "Filter solutions" checkbox  tries (not  very ,successfully) to avoid displaying duplicate 
solutions. (The "Generate1" button creates a random /problem with the number of values specified by *the user.   "Generate2" makes a random  6 ,value  problem  using the same rules as the "Countdown" TV program.  
ParentFontTabOrder  	TSpinEdit
NbrvarsedtLeftpTop`Width)HeightEditorEnabledMaxValue	MinValueTabOrder ValueOnChangeNbrvarsedtChangeOnClickNbrvarsedtChange  TButtonEvalBtnLeft�Top�WidthqHeight!CaptionEvaluateFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderOnClickEvalBtnClick  	TGroupBox	GroupBox1LeftpTop� WidthQHeight� Caption	OperatorsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder 	TCheckBoxPlusBoxLeftTopWidth1HeightCaption+Checked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontState	cbCheckedTabOrder   	TCheckBoxMinusBoxLeftTop0Width1HeightCaption-Checked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontState	cbCheckedTabOrder  	TCheckBoxTimesBoxLeftTopHWidth1HeightCaptionXChecked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontState	cbCheckedTabOrder  	TCheckBox	DivideBoxLeftTop`Width)HeightCaption/Checked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontState	cbCheckedTabOrder   	TGroupBox	GroupBox2LeftTop�WidthHeightACaptionValuesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder TLabelLabel6Left�TopWidth/HeightCaptionTarget  	TSpinEditV1EdtLeftTopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrder Value  	TSpinEditV2EdtLeftXTopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEditV3EdtLeft� TopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEditV4EdtLeft� TopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEditV5EdtLeftTopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEditV6EdtLeftXTopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEdit	TargetEdtLeft�TopWidthIHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue'MinValue��
ParentFontTabOrderValue   	TSpinEditV7EdtLeft�TopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEditV8EdtLeft�TopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrderValue  	TSpinEditV9EdtLeftTopWidth9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue�
ParentFontTabOrder	Value   	TSpinEdit	MaxToShowLeft8TopHWidth9HeightMaxValue�MinValueTabOrderValue
  	TCheckBox	UseAllBoxLeft Top�Width� HeightHintAlways use all input valuesCaptionUse all input valuesParentShowHintShowHint	TabOrder  	TCheckBox	FilterboxLeft� Top�Width� HeightHint"Eliminate some duplicate solutionsCaptionFilter solutionsChecked	State	cbCheckedTabOrder  TButtonGen1BtnLeft�Top�WidthqHeight!HintGenerate random problemCaption
Generate 1Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontParentShowHintShowHint	TabOrder	OnClickGen1BtnClick  TButtonStopBtnLeft�Top�WidthqHeight!CaptionStopFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrderVisibleOnClickStopBtnClick  TButtonGen2BtnLeftTop�WidthqHeight!Hint(Generate random "Countdown" game problemCaption
Generate 2Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontParentShowHintShowHint	TabOrder
OnClickGen2BtnClick  TStaticTextStaticText1Left TopWidth5HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption9Copyright  � 2003-2005, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click   