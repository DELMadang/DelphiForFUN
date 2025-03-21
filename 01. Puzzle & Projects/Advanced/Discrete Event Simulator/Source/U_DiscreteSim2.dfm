�
 TFORM1 0�%  TPF0TForm1Form1Left� Top� BorderIconsbiSystemMenu
biMinimize
biMaximizebiHelp BorderStylebsSingleCaptionDiscrete Event Simulation ClientHeight2ClientWidth#Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Menu	MainMenu1OldCreateOrderPositionpoDesktopCenter
OnActivateFormActivateOnClose	FormCloseOnCloseQueryFormCloseQueryPixelsPerInch`
TextHeight TShapeShape2Left�Top0WidthYHeightA  TPageControlPageControl1Left Top Width#Height2
ActivePage	CaseSheetAlignalClientTabOrder OnChangePageControl1Change 	TTabSheet
IntroSheetCaptionIntroduction TPanelPanel1LeftTop0Width�Height� Color��� TabOrder  TLabelLabel8LeftxTopHWidthHHeightCaption                  Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsUnderline 
ParentFont  TLabelLabel7Left� TopWidthfHeightCaptionWaiting areaFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel9Left�TopWidthQHeight!AutoSizeCaptionReceiving serviceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontWordWrap	  TLabelLabel6Left� Top2WidthFHeightCaptionArrivingFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsItalic 
ParentFont  TLabelLabel13Left0TopHWidth� HeightCaption              Customers       Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsItalicfsUnderline 
ParentFont  TLabelLabel12Left�TopHWidth� HeightCaption      Customers            Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsItalicfsUnderline 
ParentFont  TLabelLabel14LeftTop2WidthYHeightCaption	DepartingFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBoldfsItalic 
ParentFont  TShapeShape1Left� Top0Width� HeightABrush.Color��@   TShapeShape3Left�Top0WidthYHeightABrush.Color ��   TLabelLabel11Left�Top@WidthHeight$CaptionJColorclWhiteFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.Name	Wingdings
Font.StylefsBold ParentColor
ParentFont  TLabelLabel10Left Top=WidthqHeight$CaptionLKKKColorclWhiteFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.Name	Wingdings
Font.StylefsBold ParentColor
ParentFont   	TRichEdit	RichEdit1LeftTop� Width�HeightABorderWidth
ColorclYellowFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Lines.Strings`A system that serves customers, (humans,  automobiles, messages, jobs, or dairy cows at milking dtime),  is a typically queuing system.  Such systems have one or more waiting areas and one or more iservers.  The customers may be of different classes or priorities and be handled differently as a result Z(emergencies at the doctors office or the express line at the grocery store, for example).h�Most of our transactions involve queuing systems:  the gas station, bank, grocery store, post office,  idoctor's office, and phoning a business ("Your call is very important to us, please continue to hold for :the next available representative" ha!) , to name a few.�� fDiscrete event simulators are fun because they model these types of systems, especially this animated dversion where you can watch the little customers arrive, wait, get service and leave.  We'll define hcustomer classes and their arrival and cost characteristics.  We'll also define one or more servers and dwhat kinds of customer classes they can handle, how they process those classes and their cost.   At Ithe end of a run, statistics will let you see how well the system worked.   
ParentFontTabOrder   	TTabSheet	CaseSheetCaptionCase Defintion
ImageIndex TLabelLabel1LeftTopWidth� HeightCaptionCustomer/Job ClassesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel2LeftTop� Width7HeightCaptionServersFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel3Left ToppWidth'HeightCaptionRuntime  TMemoMemo1LeftTopWidth� Height1TabOrder OnChangeSetModified  TStringGrid
ServergridLeftToppWidth�Height� HintRight click for optionsColCountDefaultColWidthFDefaultRowHeight	FixedCols RowCount	FixedRowsOptionsgoFixedVertLine
goVertLine
goHorzLinegoRowSelect 	PopupMenu
PopupMenu1TabOrder
OnDblClickServergridClickOnKeyUpServergridKeyUp  TStringGridCustgridLeftTop(Width�Height� HintRight click for optionsColCountDefaultColWidth2DefaultRowHeight	FixedCols RowCount	FixedRowsOptionsgoFixedVertLine
goVertLine
goHorzLinegoRowSelect ParentShowHint	PopupMenu
PopupMenu1ShowHint	TabOrder
OnDblClickCustgridClickOnKeyUpCustgridKeyUp	ColWidths22M22222   TButtonRunBtnLeft Top�WidthYHeightCaptionRunTabOrderOnClickRunBtnClick  TEdit
RunTimeEdtLeft Top�WidthQHeightTabOrderOnChangeSetModified  
TStatusBar
StatusBar1Left TopWidthHeightPanels	AlignmenttaCenterText4Copyright  � 2002, Gary Darby,  www.DelphiForFun.orgWidth2  SimplePanel  	TCheckBox
AnimateBoxLeft Top�WidthaHeightCaptionShow animationTabOrder  TMemoMemo2LeftTop� Width�Height� ColorclYellowFont.CharsetDEFAULT_CHARSET
Font.ColorclBlackFont.Height�	Font.NameMS Sans Serif
Font.Style Lines.Strings6Server definitions in the grid below are in two parts: LServer number and Server name are unique to the server. Each server may haveMmultiple line entries.  Each row defines a job class and the processing time *distribution to be handled by that server. aIf selection protcol is "Class first", then the order of the entries for a server determines the [order in which jobs are processed.   The Up/Down arrow buttons below may be used to change +the order of job selection within a server.  
ParentFontTabOrder  TRadioGroupUnitsGrpLeft�TophWidthqHeight� Caption
Time units	ItemIndexItems.Strings24 hour days8 hour daysHoursMinutesSeconds TabOrderOnClickUnitsGrpClick  TBitBtnServerUpBtnLeft�Top�WidthHeightTabOrder	OnClickServerUpBtnClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 333 333333w333333	333333333333	333333333333	333333333333	333333333333	33333���330 	  3337wsww�330����3337?3373333	��3333333333	��3333s�3s33330��333337�7�33330��333337?7333333	333333333333	333333ss333333033333337�3333330333333373333	NumGlyphs  TBitBtnServerDownBtnLeft�Top�WidthHeightTabOrder
OnClickServerDownBtnClick
Glyph.Data
z  v  BMv      v   (                                    �  �   �� �   � � ��   ���   �  �   �� �   � � ��  ��� 333033333337�333333033333337?333333	333333333333	333333ss�33330��333337�7�33330��33333737?3333	��3333333333	��3333s33s�330����3337��?��330 	  3337www33333	333333333333	333333333333	333333333333	333333333333	333333333333 333333ws333	NumGlyphs   	TTabSheetSummarySheetCaptionSummary Statistics
ImageIndex TLabelLabel4Left`TopWidth5HeightCaption
Job Counts  TLabelLabel5Left(TopWidth%HeightCaptionGeneral  TStringGridGeneralSumryGridLeft(Top(Width	HeightaColCountRowCount	FixedRows TabOrder   TStringGridJobSumryGridLeft`Top(Width�Height� Hint ColCount	FixedRowsOptionsgoFixedVertLine
goVertLine
goHorzLinegoRangeSelect 
ScrollBars
ssVerticalTabOrder	ColWidths@@@@@@   TStringGridServerSumryGridLeft`TopPWidth�HeightxTabOrder   	TTabSheetDetailSheetCaptionDetail Job List
ImageIndex TStringGrid
DetailGridLeftPTop(WidthIHeight�ColCountTabOrder     	TMainMenu	MainMenu1Left�Top 	TMenuItemFile1CaptionFile 	TMenuItemNew1CaptionNewOnClick	New1Click  	TMenuItemOpen1CaptionOpen...OnClick
Open1Click  	TMenuItemSave1CaptionSaveOnClick
Save1Click  	TMenuItemSaveAs1Caption
Save As...OnClickSaveAs1Click  	TMenuItemN1Caption-  	TMenuItemExit1CaptionE&xitOnClick
Exit1Click    TOpenDialogOpenDialog1
DefaultExtsimFilter/Simulation Case(*.sim)|*.sim|All Cases(*.*)|*.*Title)Select a simulation case description fileLeft�Top  TSaveDialogSaveDialog1
DefaultExtsimFilter/Simulation Case(*.sim)|*.sim|All files(*.*)|*.*OptionsofOverwritePromptofHideReadOnlyofNoChangeDirofCreatePromptofEnableSizing Title,Select or enter name to save simulation caseLeft�Top  
TPopupMenu
PopupMenu1Left\Top 	TMenuItemModifyselectedentry1Caption&Modify (or double click row to change)OnClickModifyselectedentry1Click  	TMenuItemInsertnewentry1CaptionNew (or press Ins)OnClickInsertnewentry1Click  	TMenuItemDelete1CaptionDelete (or press Del)OnClickDelete1Click    