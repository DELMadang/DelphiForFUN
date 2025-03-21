�
 TFORM1 0[  TPF0TForm1Form1LeftTop� Width�Height�CaptionLPDemo Version 2.1.1Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderPositionpoScreenCenterOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInchx
TextHeight TStaticTextStaticText1Left Top�WidthxHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption4   Copyright © 2011, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrder OnClickStaticText1Click  TPageControlPageControl1Left Top WidthxHeight�
ActivePage	TabSheet1AlignalClientTabOrder 	TTabSheet	TabSheet1CaptionIntroduction TMemoMemo1Left Top WidthpHeight�AlignalClientFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringspThis program illustrates some simple examples of a Delphi interface to LP-Solve, a free linear programming tool uavailable from http://lpsolve.sourceforge.net/ and/or  http://tech.groups.yahoo.com/group/lp_solve/.  See my webpage Shttp://delphiforfun.org/programs/delphitechniques/lpsolveDemo.htm for more details. wThe "Cases" page displays the initial sample program.  The word description of the problem occupies the top portion of zthe page.  A table describing the variables, the problem objective and the constraints appear at the bottom of the page.  tThe "Solve" button transfers the information form the table to the record format required by LP_Solve and calls its e"Solve" function to attempt a solution. Results appear below the problem description in that display. xThe "Load" button will load text and detailed information for several sample cases included. The "Save" button saves thextext and problem detail to a file.  If you want to modify the sample problems or define your own, here are some details: sOnly the basic options available in LP_Solve are implemented here.  You can specify the number of variables and thepnumber of constraints to change the size of the table.  You can also specify whether to look for the maximum or wminunum for the objective function. The objection function is the expression describing the quantity to be optimized.  rThe top row of the table is reserved for names of the variables.  The row below that defines the objective.  Each ufollowing row defines a constraint.  The first column is reserved for names of the constraints. Columns to the right {define coefficients for each of the variables in the objective function and each of the constraint equations.  The next to ylast column contains the relation of the constraint to the constant contained in the rightmost column.  Allowed relation foperators ar ">=", "<=", or "=".  For the objective row, the final 2 columns should remain as "= ???".    
ParentFontTabOrder    	TTabSheet	TabSheet3BorderWidthCaptionCases  
ImageIndex TLabelLabel1LeftToppWidthuHeightCaptionNbr of VariablesFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel2LeftTop�Width� HeightCaptionNbr of ConstraintsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TLabelLabel3LeftTopPWidthRHeightCaption0Table defining the objective and the constraintsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFont  TMemoMemo2Left Top WidthlHeight9AlignalTopLines.StringsnSuppose a farmer has 75 acres on which to plant two crops: wheat  and barley. To produce these crops, it costsqthe farmer (for seed, fertilizer, etc.) $120 per acre for the wheat and  $210 per acre for the barley. The farmershas $15000 available for expenses. But after the harvest, the farmer must store the crops while awaiting favorable mmarket conditions. The farmer has storage space for 4000 bushels. Each acre yields an average of 110 bushels vof wheat or 30 bushels of barley.  If the net profit per bushel of wheat (after all expenses have been subtracted) is [$1.30 and for barley is $2.00, how should the farmer plant the 75 acres to maximize profit? aIf W = acres of Wheat and B = acres of Barley then we want to find the best W and B  values for:  KMaximum Profit = $1.30 per bushel of wheat * 110 bushels per acre * W acres[                              +  $2.00 per bushel of barley * 30 bushels per acre * B acres Subject to constraints::(  Total expenses = $120*W+$210*B<=$15000*  Total bushels = 110*W+30*B <= 4000   and  Toal acres = W+B<=750--------------------------Solution displays here 
ScrollBars
ssVerticalTabOrder   TStringGridtableLeft� TopjWidth�Height� Constraints.MaxHeight� Constraints.MaxWidth�	FixedCols 	FixedRows OptionsgoFixedVertLinegoFixedHorzLine
goVertLine
goHorzLinegoRangeSelect	goEditing TabOrder
OnDrawCelltableDrawCellOnSetEditTexttableSetEditText	ColWidths@@@@@ 
RowHeights   	TSpinEditNVarsEdtLeftTop�Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValue
MinValue
ParentFontTabOrderValueOnChangeTableSizeChange  	TSpinEditNConstraintsEdtLeftTop�Width)HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValue
MinValue
ParentFontTabOrderValueOnChangeTableSizeChange  TRadioGroup	MaxMinGrpLeftTop�Width� HeightYCaptionMin/Max  TypeFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 	ItemIndex Items.StringsMinimizeMaximize 
ParentFontTabOrder  TButtonSolveBtnLeft�Top{WidthmHeightCaption	Solve it!Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickSolveBtnClick  TButtonSaveBtnLeft�Top�WidthiHeightCaption	Save caseFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickSaveBtnClick  TButtonLoadBtnLeft�Top�WidthqHeightCaption	Load caseFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickLoadBtnClick  TButton
NewcaseBtnLeft�TopWidthiHeightCaptionNew caseFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrderOnClickNewcaseBtnClick    TOpenDialogOpenDialog1
DefaultExtstmFilter*LP Case (*..stm)|*.stm|All files (*.*)|*.*LeftHTop`  TSaveDialogSaveDialog1
DefaultExtstmFilter)LP case (*.stm)|*.stm|All files (*.*)|*.*Left(Toph   