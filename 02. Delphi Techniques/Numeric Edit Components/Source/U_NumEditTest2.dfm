�
 TFORM1 0&  TPF0TForm1Form1Left� TopyWidth�Height�Caption@TIntEdit, TFloatedit Test:  Version 2 - No installation requiredColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderOnCreate
FormCreatePixelsPerInch`
TextHeight TLabelLabel1Left�Top WidthrHeightCaptionEnter an integer  TLabelLabel2Left@TopHWidth� HeightCaptionEnter a floating point number  TLabelSumLblLeftHTop� WidthHHeightCaption	Sum = 0.0  TEditEdit1Left Top WidthyHeightTabOrder Text47OnChangeEdit1Change  TEditEdit2Left TopHWidthyHeightTabOrderText27.999OnChangeEdit1Change  TMemoMemo1LeftTop WidthHeightQLines.StringsTIntEdit and TFloatEdit are !descendants of TEdit tailored to #ensure that only valid integers or #floating numbers are retained in a "Value" property. These versions of TIntEdit and )TFloatEdit do not require installation.  $Instead the controls are created at #startup time and constructors take $normal TEdits as  prototypes of the *controls to set size and locations, font, (color, exits, and most other properties that may be defined. TabOrder  TStaticTextStaticText1Left Top�Width�HeightAlignalBottom	AlignmenttaCenterCaption9Copyright  � 2001-2005, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click   