�
 TFORMLAB3D 0k  TPF0
TFormLab3D	FormLab3DLeft!Top� BorderIconsbiSystemMenu
biMinimize BorderStylebsSingleCaption3D LabClientHeight�ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterOnCreate
FormCreatePixelsPerInchx
TextHeight TLabelLabelFigureSelectLeft
TopWidth� HeightCaptionSelect Figure to Display  	TGroupBoxGroupBoxEyePositionLeftTopCWidth� Height� CaptionEye PositionFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder  TLabelLabelAzimuthLeftTopWidth� HeightCaptionAzimuth[degrees]Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabelElevationLeftTopEWidth� HeightCaptionElevation[degrees]Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabelDistanceLeftToplWidthHHeightCaptionDistanceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  	TSpinEditSpinEditAzimuthLeft� TopWidth<Height$Hint0 .. 360Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 	IncrementMaxValuehMinValue 
ParentFontTabOrder ValueOnChangeSpinEditBoxChange  	TSpinEditSpinEditElevationLeft� Top@Width<Height$Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 	IncrementMaxValueZMinValue�
ParentFontTabOrderValue-OnChangeSpinEditBoxChange  	TSpinEditSpinEditDistanceLeft� TopgWidth<Height$Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue
ParentFontTabOrderValueOnChangeSpinEditBoxChange   	TGroupBoxGroupBoxScreenLeftTop�Width� HeightsCaptionScreenFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder TLabelLabel1LeftTopWidthsHeightCaptionWidth / HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel3Left*TopEWidthXHeightCaption	To CameraFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  	TSpinEditSpinEditScreenWidthHeightLeft� TopWidth<Height$Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValuedMinValue
ParentFontTabOrder Value
OnChangeSpinEditBoxChange  	TSpinEditSpinEditScreenToCameraLeft� TopEWidth<Height$Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 	IncrementMaxValuedMinValue
ParentFontTabOrderValueOnChangeSpinEditBoxChange   	TComboBoxComboBoxFigureLeft
TopWidth� Height
ItemHeightTabOrderTextComboBoxFigureOnChangeComboBoxFigureChangeItems.StringsCubeSphereSphere In CubeSurfaceFootball Field   TPanel
Panel3DLabLeftTopWidth�Height�TabOrder TImageImageLeftTopWidth�Height�   	TGroupBox	GroupBox1LeftTop� Width� Height� CaptionRotation SpeedFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrder TLabelLabel4LeftTopXWidth� HeightCaptionElevation (Vertical) Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel2LeftTop0Width� HeightCaptionAzimuth (Horizontal)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  	TSpinEditAzSpeedLeft� Top0Width<Height$EditorEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue
MinValue 
ParentFontTabOrder Value OnChangeSpeedChange  	TSpinEditElspeedLeft� TopXWidth<Height$EditorEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue
MinValue 
ParentFontTabOrderValue OnChangeSpeedChange   TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption4   Copyright © 2018  Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click  TStaticTextStaticText2Left TopzWidth�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaptionECopyright (C) 1997-1998 Earl F. Glynn, All Rights Reserved,  efg2.comFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText2Click  TMemoMemo1LeftTop Width�HeightqColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsUHere's a demo drawing 3D objects at various orientations (or viewing from various eyeVpositions) and projecting them onto a flat screen. Thanks to Earl Glynn for permissionTto post his code for the "3D Lab" program.  It has been in my Future Projects folder`for 20 years and it's still cool! I've used his math units in several DFF programs involving 3D Tobject smulations.  I added the animation bit to this one to automate the rotations.  
ParentFontTabOrder  TTimerTimer1IntervalOnTimerTimer1TimerLeft�Top    