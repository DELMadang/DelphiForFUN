�
 TFORM1 0�W  TPF0TForm1Form1Left�Top�
AutoScrollCaptionKLogic Problem Solver   V5.7  - Click "Problem" to load or define a new caseClientHeightClientWidth@Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Menu	MainMenu1OldCreateOrderPositionpoScreenCenterOnClose	FormCloseOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInch`
TextHeight TStaticTextStaticText8Left TopWidth@HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright © 2002- 2016, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrder TransparentOnClickStaticText4Click  TPanelPanel1Left Top Width@HeightAlignalClientCaption````TabOrder TLabelNoChangeLblLeftTopYWidth]Height%AutoSizeCaption�Note:  You are in user mode and have loaded author's rules.. You may view facts and rules and check the author's solution, but problem data may not be changed.Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontVisibleWordWrap	  TLabel
RuleSetLblLeftTop	Width� HeightCaptionNo problem loadedFont.CharsetDEFAULT_CHARSET
Font.ColorclPurpleFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TPageControlPageControlLeftTopWidth�HeightxHint+Select an information item from description
ActivePage	TextSheetFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 	MultiLine	
ParentFontParentShowHintShowHint	TabOrder OnChangePageControlChange 	TTabSheet
IntroSheetCaptionProgram Introduction
ImageIndex TMemoMemo4Left Top Width�HeightXAlignalClientBorderStylebsNoneColor��� Lines.Strings�Here is a program that can help solve many logic problems commonly found in puzzle magazines and books.  Here is a simple example: �Mary, John and Pete have red, brown, and blonde hair, and are 13, 14, and 15 years old .  Determine the hair color, and age of each child using the following clues.  1. The youngest has blonde hair.2. John is older than Pete.B3. John does not have red hair and Pete does not have blonde hair. �To be solvable by this program, there must be an equal number of possible values for each variable and value assignments are unique.  In the Vexample above each of the variables (Name, Hair,  and Age)  has three possible values.xEach value must be associated with exactly one value of each of the other variables. Nearly all puzzles that I  have runacross meet this condition. vThe program operates by taking user supplied facts and rules and building truth tables for each pair of variables withtone row for each  possible value for variable 1 and one column for each possible value for variable 2.  The cells at{intersections contain "T" if the relationship (e.g. the 13 year old has red hair) is true, "F" if the relationship is false�and "U" if the truth of the relationship is unknown.  Rules of logic are used to fill in the tables.  If we reached a state where all "U"s have been  replaced, the problem is solved. �Six tab sheets to describe the problem:  Only three (FACTS, ORDER RULES, IF RULES) are used to develop solutions to pre-defined dproblems.  (Update - Version 4 adds a new CHOICE statement type.) The other three tabs (DESCRIPTION,MVARIABLES, and CONNECTING WORDS) may only be modified while in "Author" mode. tThere is a box near the bottom of the main window which allows you to view predefined "Solution rules" or  work with*"User rules" that you must write yourself. kDESCRIPTION: Defines the problem. You'll commonly find numbered paragraphs at the bottom of the descriptionipages. These may be used as reference numbers while defining facts and rules.  To be correctly recognized|reference items must appear after the body of the description and separated from the description by at least one blank line. �VARIABLES:  Each variable definition consists of the variable name and a set of vaiable values. The definitions are supplied at problem @definition time and may only be changed  while in "Author" mode. �FACTS: Use this page to define the known facts. Facts are true statements may be of positive form "John has red hair" or negative form "Mary �is not the one who is 13."  Note that a negative statement tells us that some positive proposition is false: ("Mary is not the one who is 13"  tells -us that the statement "Mary is 13" is false.) �ORDER RULES: Information is sometimes given about the ordering of values with respect to some variable.  These may be of two forms: �Order rules; "John is older than Mary" or "Pete is one year younger than John.". I call the other variation a Separation rule. Here we know the ^"distance" between two values but not the direction: "Mary and John were born two years apart" �IF RULES: These are rules that specify relationships that are conditionally true (or false) based on the truth (or "falsity") of some other Prelationship. "If the 13 year old has red hair then John reads books as a hobby" �CHOICE Statements, (new for Version 4): Simplifies the entry of statements which specify 2 or 3 possible associations for a given variable �value.  For example: "Bob lives in Boston or New York" from which we can conclude and enter facts reflect that Bob does not live in Chicago mor Detroit or any other city in the problem.   The CHOICE statement processor generates all of these negativefacts for us. fCONNECTING WORDS: When truth tables are generated, you can click on any cell to see the reasoning thatkassigned the value. By default, the text describing relationships between values uses the verb "is" and theonegation by "isn't". "John is 13" sounds fine, but "John is red hair" doesn't. You can use the Connecting Wordssgrid to provide alternative verbs so that the text would read "John has red hair" or "John doesn't have red hair" .nYou can click the "Solve" menu item to process the current set of fact and rules. You will see a page with thesresulting value  assignments. Clicking the "Display Truth Tables" button on this page will display all truth tablestand clicking on truth table cells will display the reasoning that led to that value assignment. You can also display;additional "IF Rules" that were generated from Order rules. gYou can use the "Options" menu item to make yourself an Author. Only in Author mode can new problems beYdefined or Description and Connecting Word information be modified for existing problems. XA dozen starter problems are included here - play with them, then try authoring you own. Most importantly  - have fun! 
ScrollBars
ssVerticalTabOrder    	TTabSheet	TextSheetCaptionProblem Description
ImageIndex TLabelLabel10LeftTopWidthJHeightCaptionDescription  TLabelLabel11LeftTopWidthwHeightCaptionSource Reference  TLabel
DescChgLblLeftTop{Width�HeightCaptionjNote: Description and Source refernce information may only be changed while  in Author mode (Options menu)Visible  TMemoDescMemoLeftTop)Width�Height� Hint'May only be changed when in Author modeLines.Strings>Click the "Problem" menu item to load or define a new problem. 
ScrollBars
ssVerticalTabOrder OnChange
MemoChangeOnExitDescMemoExit  TMemo
SourceMemoLeftTop2Width�Height?Hint'May only be changed when in Author modeTabOrderOnChange
MemoChange   	TTabSheetVarSheetCaption	VariablesOnExitVarSheetExit TLabel	VarChgLblLeftTopWidth�Height"CaptionMNote: Variable definitions can only be changed in Author mode (Options menu) Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  	TGroupBoxVargrpLeft Top0WidthfHeight� Caption=Variable changes - Recommend backing up before making changesTabOrderVisible TLabel	cccccccccLeftTopWidth� HeightCaption New or replacement variable nameFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TButton	VarDelBtnLeftjTop� Width� HeightCaptionDelete selected variable TabOrder OnClickVarDelBtnClick  TButtonVarBtnLeftTop[Width0HeightCaption!Add new variable using name aboveTabOrderOnClickNewVarBtnClick  TButtonEditVarValBtnLeftjTop[Width� HeightCaption!Edit values for selected variableTabOrderOnClickEditVarValBtnClick  TEditVarEditLeftTop2Width� HeightTabOrderOnChangeVarEditChange  TButtonChgVarNameBtnLeftTop� Width0HeightCaption&Change selected variable to name aboveTabOrderOnClickChgVarNameBtnClick  TMemoMemo5LeftcTopWidth� Height� Lines.StringsNote: Any changes made to $variables may effect existing facts $and rules in both original and user rule sets.    Changes in variable names or !values will automatically update #facts and rules with the new names. 'Deletion of a variable will delete all  facts and rules referencing the variable name or its values. TabOrder   TStringGridVarGrid1LeftTopWidth�Height� ColCountDefaultColWidth	FixedCols RowCount	FixedRows Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLine	goEditinggoRowSelectgoThumbTracking 
ParentFontTabOrder OnClickVarGrid1Click   	TTabSheet	FactSheetCaption Facts 
ImageIndex TLabelLabel1LeftHTopWidthDHeightHint+Select an information item from descriptionCaption	ReferenceParentShowHintShowHint	  TLabelLabel3Left� TopWidthiHeightCaptionSelect 1st  item   TLabelLabel4Left6TopWidtheHeightCaptionSelect 2nd item  TButtonSortfactsBtnLeft� TopkWidth� HeightCaptionSort  by Reference # TabOrder OnClickSortBtnClick  TButton
DelFactBtnLeft� TopKWidth� HeightCaptionDelete selectedTabOrderOnClickDelFactBtnClick  TButton
NewfactBtnLeftGTopKWidth� HeightCaption
Insert newTabOrderOnClickNewfactBtnClick  TButtonFactBtnLeftETopkWidth� HeightCaptionReplace selectedTabOrderOnClickFactBtnClick  TStringGridFactGridLeft8Top� Width(Height� HintClick to editColCountDefaultColWidthd	FixedCols RowCount	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect ParentShowHint
ScrollBars
ssVerticalShowHint	TabOrderOnClickModify1Click
OnDblClickFactGridDblClick  TMemoMemo2Left8Top�Width)Height� 
ScrollBars
ssVerticalTabOrderWantReturns  TStaticTextStaticText1Left�TopHWidth�Height9AutoSizeBorderStyle	sbsSingleCaption�Double click a fact to enable or disable.  Disabed facts are ignored in solution searches.  Facts without Reference IDs will be saved as Disabled.Color��� ParentColorTabOrder  TUpDownUpDown1LeftTop�WidthHeightDPositionTabOrderOnChangingExUpDown1ChangingEx  	TComboBox
FactRefBoxLeftHTop#WidthKHeightHint+Select an information item from description
ItemHeight ParentShowHintShowHint	TabOrderOnChangeStmtBoxChange  	TComboBoxFactBox1Left� Top#Width� Height
ItemHeight TabOrder	OnChangeFactBoxChange  TRadioGroupFactRGrpLeft�Top	Width� Height;CaptionTruth ValueItems.Stringsisisn't TabOrder
  	TComboBoxFactBox2Left8Top#Width� HeightStylecsDropDownList
ItemHeight TabOrderOnChangeFactBoxChange   	TTabSheetOrderRuleSheetCaptionOrder Rules
ImageIndex TLabelLabel12Left'TopWidthDHeightHint+Select an information item from descriptionCaption	ReferenceParentShowHintShowHint	  TLabelLabel2Left� TopWidthcHeightCaptionWith respect to  TLabelLabel5Left�Top*Width{HeightCaptionSeparation Amount  TLabelLabel8Left4Top*WidthNHeightCaption2nd variable  TLabelLabel7Left� Top*Width4HeightCaptionPosition  TLabelLabel6Left'Top*WidthJHeightCaption1st variable  TStringGrid	OrderGridLeftTop� Width\Height� HintClick to modifyColCount
DefaultColWidthK	FixedCols RowCount	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect ParentShowHintShowHint	TabOrder OnClickModify1Click
OnDblClickOrderGridDblClick  TButtonOrderRuleBtnLeft� ToplWidth� HeightCaptionReplace selectedTabOrderOnClickOrderRuleBtnClick  TMemoMemo3LeftTophWidthZHeight� 
ScrollBars
ssVerticalTabOrderWantReturns  TButtonNewOrderRuleBtnLeft!ToplWidthpHeightCaptionInsert rule TabOrderOnClickNewOrderRuleBtnClick  TButtonDelORuleBtnLeft*ToplWidthvHeightCaptionDelete selectedTabOrderOnClickDelORuleBtnClick  TButtonSortORulesBtnLeft�ToplWidth� HeightCaptionSort by reference #TabOrderOnClickSortBtnClick  TStaticTextStaticText2LeftLTopSWidth� Height3AutoSizeBorderStyle	sbsSingleCaptiong  Double click a rule to enable or disable .    Disabled rules are ignored in solution        searches Color��� ParentColorTabOrder  TUpDownUpDown2LeftTop�WidthHeightCPositionTabOrderOnChangingExUpDown2ChangingEx  	TComboBox	ComboBox1LeftjTopWidthSHeightHint+Select an information item from description
ItemHeightParentShowHintShowHint	TabOrderText	ComboBox1OnChangeStmtBoxChange  	TComboBoxOrderWithRespectToBoxLeft]TopWidth� HeightStylecsDropDownList
ItemHeightTabOrder	OnChangeOrderWithRespectToBoxChange  	TGroupBox	GroupBox2Left@TopWidth� Height)CaptionTruth valueTabOrder
 TRadioButtonTrueORuleBtnLeftTopWidth6HeightCaptionTrueChecked	TabOrder TabStop	  TRadioButtonFalseORuleBtnLeftQTopWidth7HeightCaptionFalseTabOrder   	TComboBoxOrderDifferenceBoxLeft�Top=Width_HeightStylecsDropDownList
ItemHeightTabOrderItems.StringsUnknown   	TComboBoxOrdername2BoxLeft4Top=WidthzHeightStylecsDropDownList
ItemHeightTabOrderOnChangeOrdernameBoxChange  	TComboBoxOrderRelationBoxLeft� Top=Width{HeightStylecsDropDownList
ItemHeightTabOrderItems.StringsBeforeAfterSeparated by   	TComboBoxOrdername1BoxLeft'Top=WidthzHeightStylecsDropDownList
ItemHeightTabOrderOnChangeOrdernameBoxChange   	TTabSheetIfRuleSheetCaptionIf Rules
ImageIndex TLabelLabel13LeftTopWidthDHeightCaption	Reference  TLabelLabel16LeftlTopWidthHeightCaptionIFFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TLabelLabel14Left[TopCWidth0HeightCaptionTHENFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFont  TMemoMemo1Left)TophWidth)Height� Lines.StringsMemo1 TabOrder   TStringGrid
IfRuleGridLeft)Top� Width)Height� HintClick to editColCount
	FixedCols RowCount	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect ParentShowHintShowHint	TabOrderOnClickModify1Click
OnDblClickIfRuleGridDblClick	ColWidths@@@@@@@@@@   TButton	IfRuleBtnLeft� Top}Width� HeightCaptionReplace selectedTabOrderOnClickIfRuleBtnClick  TButton	NewIfRuleLeft)Top}WidthuHeightCaptionInsert  new TabOrderOnClickNewIfRuleClick  TButtonDelifRuleBtnLeft;Top}WidthuHeightCaptionDelete selectedTabOrderOnClickDelifRuleBtnClick  TButtonSortIRulesBtnLeft�Top}Width� HeightCaptionSort by reference #TabOrderOnClickSortBtnClick  TStaticTextStaticText3LeftPTophWidthHeight>AutoSizeBorderStyle	sbsSingleCaptiong  Double click a rule to enable or disable .    Disabled rules are ignored in solution        searches Color��� ParentColorTabOrder  TUpDownUpDown3Left	Top�WidthHeightKPositionTabOrderOnChangingExUpDown3ChangingEx  	TComboBox	ComboBox2LeftTopWidthSHeight
ItemHeight TabOrderText	ComboBox1OnChangeStmtBoxChange  	TComboBox
IfValA1BoxLeft� TopWidth� Height
ItemHeight TabOrder	  TRadioGroup	TruthAGrpLeftLTopWidthuHeight+Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 	ItemIndex Items.StringsISIS NOT 
ParentFontTabOrder
  	TComboBox
IfValA2BoxLeft�TopWidth� Height
ItemHeight TabOrder  	TComboBox
IfValB1BoxLeft� TopCWidth� Height
ItemHeight TabOrder  TRadioGroup	TruthBGrpLeftLTop8WidthuHeight+Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 	ItemIndex Items.StringsISIS NOT 
ParentFontTabOrder  	TComboBox
IfValB2BoxLeft�TopCWidth� Height
ItemHeight TabOrder   	TTabSheetChoiceSheetCaptionChoice Statements
ImageIndex TLabelLabel18LefthTopWidth� HeightAutoSizeCaption5is associated with one of the values of this variableWordWrap	  TLabelLabel19Left� TopWidthgHeightCaptionSubject variable  TLabelLabel20Left@TopWidthDHeightHint+Select an information item from descriptionCaption	ReferenceParentShowHintShowHint	  TLabelLabel21LeftTopWidthHeightCaption)Use Ctrl-Click to select possible values   	TComboBox	ComboBox4Left@Top3WidthKHeightHint+Select an information item from description
ItemHeight ParentShowHintShowHint	TabOrder OnChangeStmtBoxChange  	TComboBoxChoicename1BoxLeft� Top3Width� Height
ItemHeight TabOrderOnChangeChoicename1BoxChange  TButtonNewChoiceBtnLeft'Top[Width� HeightCaption
Insert newTabOrderOnClickNewChoiceBtnClick  TButton	ChoiceBtnLeft%Top{Width� HeightCaptionReplace selectedTabOrderOnClickChoiceBtnClick  TButtonDeletChoiceBtnLeft� Top[Width� HeightCaptionDelete selectedTabOrderOnClickDeletChoiceBtnClick  TButtonSortChoiceBtnLeft� Top{Width� HeightCaptionSort  by Reference # TabOrderOnClickSortBtnClick  TStringGrid
ChoiceGridLeftTop� Width�Height� HintClick to editColCountDefaultColWidthd	FixedCols RowCount	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRowSelect ParentShowHint
ScrollBars
ssVerticalShowHint	TabOrderOnClickModify1Click
OnDblClickChoiceGridDblClick  TMemoMemo6Left!Top�Width)Height� 
ScrollBars
ssVerticalTabOrderWantReturns  TUpDownUpDown4Left	Top�WidthHeightDPositionTabOrderOnChangingExUpDown1ChangingEx  	TComboBoxChoiceOneOfBoxLefteTop>Width� HeightStylecsDropDownList
ItemHeight TabOrder	OnChangeChoiceOneOfBoxChange  TListBoxChoicesListBoxLeftTop Width8HeightyColumns
ItemHeightMultiSelect	TabOrder
  TMemoMemo7LeftTop� Width� Height� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsNote: Choice rulesgenerate negative factsfor the associatedvariable values which are not listed as valid choices.   These Choice rules do not  know if the facts get applied.. 
ParentFontTabOrder   	TTabSheetConnectingPageCaptionConnecting Words
ImageIndex TLabelLabel15Left!Top:Width�Height"Caption�For improved solution readability, fill in connecting words appropriate when displaying column 1 variable with column 3 variable, e.g. Family STAYED AT Motel, Monster IS NOT red, etc. WordWrap	  TLabelConnectChgLblLeft)Top�WidthnHeightCaption[Note: Connecting words information may only be changed while  in Author mode (Options menu)Visible  TStringGridConnectGridLeft)Top� Width�Height� ColCount	FixedCols RowCount	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRangeSelect	goEditinggoAlwaysShowEditor TabOrder OnSetEditTextConnectGridSetEditText
RowHeights     TRadioGroupRuleSetRGrpLeft'TopWidth� Height(CaptionRule set to useColor	clBtnFaceColumnsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 	ItemIndexItems.StringsAuthor's rulesMy rules ParentColor
ParentFontTabOrderOnClickRuleSetRGrpClick   	TMainMenu	MainMenu1Left� Top  	TMenuItemFile1Caption	Problem   	TMenuItemNew1CaptionNewOnClickNewProbClick  	TMenuItemLoadProbCaptionLoad ProblemOnClickLoadProbClick  	TMenuItemSave1CaptionSaveOnClick
Save1Click  	TMenuItemSaveAs1CaptionSave AsOnClickSaveAs1Click  	TMenuItemN1Caption-  	TMenuItemExit1CaptionExitOnClick
Exit1Click   	TMenuItemSolve1CaptionSolve   OnClickSolve1Click  	TMenuItemOptions1Caption  Options     	TMenuItemConnectingwords1Caption#Connecting words in explanations...  	TMenuItemExplainwithVarCaption$Show variable names in explanantionsOnClickExplainwithVarClick  	TMenuItemEnterAuthormodeCaptionToggle Author modeOnClickEnterAuthormodeClick  	TMenuItemStartUpCaptionLoad Previous at StartupOnClickStartUpClick   	TMenuItemAuthor1CaptionAuthor options    Enabled 	TMenuItemLoadUserCaptionLoad user rulesOnClickLoadUserClick  	TMenuItemLoadOriginalRules1CaptionLoad author rulesOnClickLoadOriginalRules1Click  	TMenuItemMoveoriginalrulestouserrules1CaptionMove author rules to user rulesOnClick"Moveoriginalrulestouserrules1Click  	TMenuItemMoveuserrulestooriginalrules1CaptionMove user rules to author rulesOnClick"Moveuserrulestooriginalrules1Click    TOpenDialogOpenDialog1
DefaultExtprbFilterLogic Problems (*.prb)|*.PrbOptionsofHideReadOnlyofFileMustExistofEnableSizing TitleOpen problemLeftxTop  TSaveDialogSaveDialog1
DefaultExtprbFilter]Logic Problems (*.prb)|*.prb|Include backups (*.prb, *.bak)|*.prg; *.bak|All files  (*.*)|*.*TitleSave  problemLeftTop    