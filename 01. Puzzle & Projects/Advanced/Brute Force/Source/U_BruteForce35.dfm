�
 TFORM1 0�4  TPF0TForm1Form1LeftTTop� VertScrollBar.Visible
AutoScrollCaptionBrute Force,  Version 3.5.2ClientHeight�ClientWidth�Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style Menu	MainMenu1OldCreateOrder		PopupMenu
PopupMenu1PositionpoScreenCenter
OnActivateFormActivateOnClose	FormCloseOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInchx
TextHeight TPageControlPageControl1Left Top Width�Height�
ActivePage
IntroSheetAlignalClientFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder  	TTabSheet
IntroSheetCaptionIntroduction TMemoMemo2Left Top Width�Height�AlignalClientBorderStylebsNoneColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsmBrute Force searches for integer solutions to single or sets of equations (called Diophantine equations) withjthe restriction that variable values are chosen from a given set of integers. The number of values must bemgreater than or equal to the number of variables.   A value entry will not assigned to more than one variable*although candidate values may be repeated. cMany puzzles meet these conditions, several are included here and may be loaded and solved by BrutegForce.  Use the "File" menu to load the included sample problems.  The user may also enter and save new	problems. ^The program supports an arbitrary number of variables and equations and works by permuting thelchoices of variable values and evaluating equations looking for those that satisfy all of the equations.  Ankalternative solution technique, "Incremental Solve" finds the solution for the first equation, then retainsgthose values and tries other combinations of unused solution values to satisfy other equations. This isoapplied recursively until all equations have been satisfied. The technique works well to reduce search time for problems with lots of equations. cEquations may contain +, -, *, /, <, and > operations.  Parentheses may be used in the usual way tohcontrol the order that operations are applied.  Absolute value (abs) and Modulo (mod) functions are now 
supported. Notes:u - If all variables are single letter, then strings of letters may optionally be treated as multidigit integers.  ForWexample ABC is converted to (100*A+10*B+C) for evaluation if the option box is checked. g - Since all calculations use integer arithmetic, it may be necessary to remove division operations (byfmultiplying all terms of the equation by denominators).  For example the equation a/b+a/b=1 with valuedchoices of {1,2} will not be solved, but multiplying by b  producing a+a=b will be solved instantly. P - When defining equations, lines which begin with a semicolon (;) are comments. d - Version 2.1 adds a checkbox option to allow multiple variables to assume the same value.  ProblemI"Brothers and Sisters.prb" is an example of a problem using this feature. Y - Version 2.2 adds support for JPEG in addition to BMP images with problem descriptions. l - Version 2.3: Allows the number values to be less than the number of variables if "Multiple variables ..."ccheckbox is checked.  Also corrects error which allowed duplicate solutions to be shown.  Duplicatesolutions are now eliminated. d- Version 2.4:  Adds relational operators "<" (less than), ">" (greater than) , and "<>" (not equal) b- Version 2.5 Adds the modulo remainder function "mod" or "%".  Also, solution rows are now sorted_alphabetically by Variable name.  Solution rows previously appeared in the order that they were#encountered in the input equations. i- Version 2.6  Allowed digit values may now be entered as a range using start and stop integers separatedhby a hypen character.  E.G. Enter 0-9 to allow one each of 0,1,2,3,4,5,6,7,8,9.  New sample problem file "MENSA 11-13-11.prb" tests this. l- Version 3.0 includes a farly major rewrite of the "Incremental Solving" algorithm to imprement cases wherekvarable values can be repeated.  The motivation is problem "Mensa Puzzle 2-5-14" which has only 4 values tojbe assigned to 27 variables.  The Brute Force search took 30 minutes to find the unique solution while the,Incremental search finds it in 0.05 seconds! f- Version 3.1 adds the absolute value function "abs" to enable solving a newly included sample problemg"BilliardBalls.prb".  Note that "mod" and "abs" are now reserved words and may not be used as variable names. l- Version 3.2 Divide operations previously ignored remainders.  A new checkbox allows users to require exact^divions only, ignoring potential solution which use non-exact divisions. The new sample, Mensa6 09-26-14.prb, illustrates why this feature was added. m- Version 3.3 no longer displays saved  parameters and equations when first loaded.  Try to solve  it on yourEown first!  A new button allows saved solution stuff to be displayed. l- Version 3.4 corrects a problem introduced in version 3.3 which prompted to save when the problem is closedjeven with no changes.  Also corrects a scaling problem which occured in the "Change Title" dialogs for lowhresolution screens.  And the program now allows images associated with puzzles to be removed as well as changed. n- Version 3.5: Support was added for two addtional operations ">=" (greater than or equal to), and "<=" (less thanpor equal to). Also, equation variable names may now contain digits but not as the initial character.  Both were gimplemented to help solve a new puzzle type; Matchstick puzzles from our daily Mensa calendal.  Lots ofjvariables and lots of equations - check out "MatchSticks1 to see for yourself.   Version 3.5.1 corrects anbannoying "divide by 0" crash when zero value assignements are allowed in denominators.  New sampleicase, "PocketChange.prb", the July 16 Mensa Puzzle Calsendar case, illustrates the fix (by not crashing). 
ParentFont
ScrollBars
ssVerticalTabOrder    	TTabSheet	ProbSheetCaption  Problems  Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ImageIndex
ParentFont TLabelFileNameLblLeftFTopWidthAHeightCaption
File: NoneFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelSolutionLeftFTop<Width<HeightCaption	SolutionsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel1LeftTop� Width� HeightDHint=Enter a set of allowable integer solution separated by commasCaption]Allowable solution integers.  Use commas to separate values  or hyphen for a range. e.g 0-9  Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TLabelLabel2Left"Top�WidthAHeightHint!Enter a set of equations to solveCaption	EquationsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel3LeftATopWidthvHeightCaptionPossible solutionsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TImageImage1LeftwTopWidth� Height� Stretch	  TLabelFirstSoltimeLblLeft9Top\Width@HeightRAutoSizeCaptionFirst Solution Time hereFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TButtonStopBtnLeft"TopgWidthHeightZCaptionStop SolvingFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderVisibleOnClickStopBtnClick  TMemoMemo1LeftTop
WidthXHeight� Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsEnter new problem description !here or click File menu above to load a problem. #Right click for additional options. 
ParentFont
ScrollBars
ssVerticalTabOrder OnChange
CaseChange  TEdit	DigitsedtLeft� TopWidth9HeightHint4Enter allowable solution values, separated by commasFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontParentShowHintShowHint	TabOrderOnChange
CaseChange  TMemoEquEdtLeft"Top�WidthHeight� Hint%Enter set of equations, one per line Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont
ScrollBarsssBothTabOrderWordWrapOnExitEquEdtChange  TButton
BFSolveBtnLeft"TopoWidth� HeightHint$Solve by generating all permutationsCaptionBrute Force SolveFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontParentShowHintShowHint	TabOrderOnClickBFSolveBtnClick  TButtonIncSolveBtnLeftQTopoWidth� HeightHintSolve equation by equationCaptionIncremental Solve (faster?)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontParentShowHintShowHint	TabOrderOnClickIncSolveBtnClick  TProgressBarProgressBar1Left<Top6Width� HeightTabOrder  TStringGridSolutionGridLeftPTopWWidthHeight�ColCountDefaultColWidth 	FixedCols Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder	ColWidths&   TButton
SaveCSVBtnLeft"Top�WidthgHeightCaption-Save solutions as comma separated (.CSV) fileEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickSaveCSVBtnClick  	TCheckBox	VarSingleLeftTopGWidthHeightCaptionJVariables are single letter (i.e  ABC is interpreted as a 3 digit integer)Checked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontState	cbCheckedTabOrder	OnClickBoxClick  	TCheckBox	RepeatBoxLeftTopdWidth�HeightCaption*Multiple variables may have the same valueFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder
OnClickBoxClick  	TCheckBox	DivideBoxLeftTop�WidthHeight CaptionLDivide operations must have no remainder (remainders ignored if not checked)Checked	Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontState	cbCheckedTabOrderWordWrap	OnClickBoxClick  TButtonShowSetupBtnLeftTop� WidthHeightCaption)Show previouslt saved Setup and EquationsEnabledFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderWordWrap	OnClickShowSetupBtnClick    TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright  © 2003-2017, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click  	TMainMenu	MainMenu1Left 	TMenuItemFile1CaptionFile 	TMenuItemNew1Action	NewAction  	TMenuItemLoad1Action
LoadActionCaption&Open...  	TMenuItemN3Caption-  	TMenuItemSaveAction
SaveAction  	TMenuItemSaveas1ActionSaveAsActionCaptionSave &As...  	TMenuItemN1Caption-  	TMenuItemExit1Caption&ExitOnClick
Exit1Click   	TMenuItemOptions1CaptionOptions 	TMenuItemShowPostFix3ActionPostfix  	TMenuItemChangeTitle1ActionTitleActionCaptionChange &Title...   	TMenuItemAddimageCaptionAdd/Change &Image...OnClickAddimageClick    TOpenDialogOpenDialog1Filter\Problem Definition(*.prb)|*.prb|Image files   (*.bmp,  *.jpg)|*.bmp;*.jpg|Any file (*.*)|*.*TitleSelect a problemLeft@  TSaveDialogSaveDialog1
DefaultExttxtFilter#Brute Force  Problems (*.prb)|*.prbTitleEnter new problem file nameLeft`  
TPopupMenu
PopupMenu1Left� 	TMenuItemNew2CaptionNew...OnClickNewActionExecute  	TMenuItemLoad2CaptionLoad...ShortCutrOnClickLoadActionExecute  	TMenuItemSave1CaptionSaveOnClickSaveActionExecute  	TMenuItemSaveAs2Caption
Save As...ShortCutqOnClickSaveAsActionExecute  	TMenuItemShowPostfix1CaptionShow PostFixOnClickPostfixExecute  	TMenuItemChnageTitle1CaptionChange Title... OnClickChangeTitle1Click  	TMenuItemSave2CaptionAdd/Change Image..OnClickAddimageClick   TActionListActionList1Left� TAction	NewActionCaption&New...	OnExecuteNewActionExecute  TAction
LoadActionCaption&Load...	OnExecuteLoadActionExecute  TAction
SaveActionCaptionSave	OnExecuteSaveActionExecute  TActionSaveAsActionCaptionSave As	OnExecuteSaveAsActionExecute  TActionPostfixCaptionShow PostFix	OnExecutePostfixExecute  TActionCloseTabCaption	Close Tab  TActionTitleActionCaptionChange Title 	OnExecuteChangeTitle1Click  TActionImageActionCaptionAdd/Change &Image..	OnExecuteAddimageClick   TSaveDialog
CSVSaveDlg
DefaultExtCSVFilter&CSV (*.csv)|*.csv|Alld files (*,*)|*.*Title-Save solutions as (comma separated) CSV file Left�   