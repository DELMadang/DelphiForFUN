�
 TFORM1 0�  TPF0TForm1Form1LeftpTop� WidthHeight�AnchorsakLeftakTopakRightakBottom CaptionBig Combos Test V 2.1Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenter
OnActivateFormActivate
DesignSize�v PixelsPerInch� 
TextHeight TLabel	CCountLblLeft�Top�Width8Height� AnchorsakLeftakRightakBottom AutoSizeCaption%Count of permutations or combinationsWordWrap	  TMemoMemo1Left�TopWidth;HeightAnchorsakLeftakTopakRightakBottom Lines.Strings  
ScrollBars
ssVerticalTabOrder   TMemoInfomemoLeftTopWidthHeight� Color��� Lines.Strings'This program generates combinations or 0permutations for large numbers in lexicographic 
order.     -N= number of items, R = number to be selected .Press "Show Mth" with default values to see a 1numeric representation of the 10,000,000,000 (10 6billionth) permutation of the letters of the alphabet. :"Write all" will write up to  2 billion results to a file. TabOrder  TPanelPanel1LeftTop+WidthHeightColor��� TabOrder TLabelLabel1LeftTop� Width!Height$CaptionN:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel2Left� Top� Width!Height$CaptionR:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel4LeftTop� Width`HeightCaptionMax to show   TButtonStopBtnLeftTopWidth� Height� CaptionStopTabOrder	VisibleOnClickStopBtnClick  TButtonShowManyBtnLeftTopWidth� Height&Caption	Show manyTabOrderOnClick	ShowClick  TEditEdit2Left>Top� Width&HeightTabOrder Text26  TUpDownUpDown1LeftdTop� WidthHeight	AssociateEdit2PositionTabOrder  TEditEdit3Left� Top� Width'HeightTabOrderText26  TUpDownUpDown2Left� Top� WidthHeight	AssociateEdit3PositionTabOrder  TEditEdit4Left� Top� WidthdHeightTabOrderText100  TUpDownMaxDisplayUDLeft� Top� WidthHeight	AssociateEdit4MinMax'PositiondTabOrder  TEditEdit1LeftJTop�Width� HeightTabOrderText10,000,000,000  TRadioGroupTypeRGrpLeftTopWidth� HeightdCaptionShow...	ItemIndex Items.StringsPermutationsCombinations TabOrder  TButton
ShowMthBtnLeftTop�Width� Height'Caption	Show Mth TabOrder
OnClick	ShowClick  TStaticTextStaticText1LeftTop�Width'Height(CaptionM:Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder  TButtonPrntBtnLeftTop@Width� Height&CaptionWrite all to fileTabOrderOnClickPrntBtnClick   TStaticTextStaticText2Left TopYWidth�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright  © 2003-2009, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText2Click  TSaveDialogSaveDialog1
DefaultExttxtFilter,Text files (*.txt)|*.txt|All files (*.*)|*.*OptionsofOverwritePromptofHideReadOnlyofEnableSizing Left@Top�   