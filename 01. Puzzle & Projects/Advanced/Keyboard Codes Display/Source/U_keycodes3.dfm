�
 TFORM1 0:  TPF0TForm1Form1Left�TopWidthHeight`CaptionKey Scan Codes V3.1Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
KeyPreview	OldCreateOrderPositionpoScreenCenter
OnActivateFormActivate	OnKeyDownFormKeyDown
OnKeyPressFormKeyPressOnKeyUp	FormKeyUpPixelsPerInchx
TextHeight TLabelLabel1LeftTop�Width;HeightCaptionPress a key or key combinationFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel2LeftaTop!WidthHeight/AutoSizeCaptionLatest key pressedFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TLabelLabel3LeftiToplWidthpHeightCaption	Caps LockFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel4LeftoToplWidthkHeightCaptionNum LockFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel5Left�ToplWidthvHeightCaptionScroll LockFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TMemoMemo4LeftTop!Width!Height�Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings1A program to play with events and keyboard codes "generated  when keys are pressed.  9I used it to identify how to activate the "Pause" key on 6my M1330 Dell laptop since they forgot to document it 5in the Owners Manual.  (Fn key + Insert key does the 4job).  The Fn key also activates the Numeric Keypad 2simulator keys embedded within the normal keys.)  62009 Update: For the Dell Studio 17 laptop, the Pause key is emulated by Fn + F12. 6In addition to the keyname displayed at top right, the6key press event codes and status of the "toggle" keys are also displayed. /The device independent "Virtual Key Codes" are +available under the Virtual Key Codes tab.  4Version 2 embeds the Key code descriptions file into2the program, eliminating the need for the separateVKeys.txt text file. 4Version 3 optionally displays "Key Down" events and =identifies/verifies the left/right key state information for 6Shift, Alt, and Ctrl keys.  V3.1 improves 'Latest key 4pressed" display to display more key names for keys with no associated symbols. 
ParentFontTabOrder   TPageControlPageControl2LeftUTop� Width+Height�
ActivePage	TabSheet3TabOrder 	TTabSheet	TabSheet3CaptionEvents TMemoEventsLeft Top Width#Height�AlignalClientFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrder    	TTabSheet	TabSheet4CaptionVirtual Key Codes
ImageIndex TMemoVKTableLeft Top WidthUHeight�AlignalClientFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameCourier New
Font.Style 
ParentFont
ScrollBars
ssVerticalTabOrder     TStaticTextStaticText1Left�TopWidthHeight5BorderStyle	sbsSingleCaption  Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder  TStaticTextCapslockLeft�TopiWidth/HeightCaptionOFFFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder  TStaticTextNumlockLeft�TopiWidth/HeightCaptionOFFFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder  TStaticText
scrollLockLeftTopiWidth/HeightCaptionOFFFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder  TStaticTextStaticText2Left TopWidth�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption9   Copyright © 2008-2013, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrderOnClickStaticText2Click  	TCheckBoxIncludeKeyDownLeftaTop�WidthqHeightCaptionInclude "KeyDown" event exitsChecked	State	cbCheckedTabOrder  TButtonClearBtnLeftaTop�Width� Height CaptionClear key messages TabOrderOnClickClearBtnClick   