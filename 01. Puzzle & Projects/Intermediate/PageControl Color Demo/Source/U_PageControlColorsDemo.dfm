�
 TFORM1 0�  TPF0TForm1Form1Left$Top� Width�Height�CaptionPageControl Colors Demo Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderPositionpoScreenCenterOnCreate
FormCreatePixelsPerInchx
TextHeight TStaticTextStaticText1Left TopdWidthxHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption4   Copyright © 2011, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrder OnClickStaticText1Click  TPageControlPageControl1Left Top WidthxHeightd
ActivePage	TabSheet1AlignalClientBiDiModebdLeftToRightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style ParentBiDiMode
ParentFontTabOrder	OnDrawTabPageControl1DrawTab 	TTabSheet	TabSheet1Caption    Introduction    Highlighted	 TMemoMemo3Left� TopaWidthHeight Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings;The default active tab drawing on  a TPageConrol has alwaysDbeen less than optimal because there is very little to distinghuish it from the inactive tabs. :Here is a simple demo program showing how to add a "Color"Aproperty to Tabsheets within a PageControl  and how to color the Btab to match the sheet.  Also other ways to tailor tab drawing to *change font properties, add graphics, etc. 
ParentFontTabOrder    	TTabSheet	TabSheet2Caption    Coloring Pages  
ImageIndex TMemoMemo2Left� TopUWidth�Height9Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings.Pagecontrol Tabsheets by default have no Color/property.  Peter Below of TeamB has posted code.which adds the Color property to the TTabsheet#control and intercepts the windoes ("EraseBbackground" message to paint the 1tabsheet with that color when the sheet is to be redrawn. 5I've included his modified version of the control in this demo program.  
ParentFontTabOrder    	TTabSheet	TabSheet3Caption      Drawing a "Smiley"    
ImageIndex TImageImage1Left�Top� Width7Height3  TImageImage2LeftCTopoWidthdHeightd  TImageImage3Left�Top� Width� Height�   TButtonTestSmileyBtnLeft�Top6WidthHeightCaptionTest Smiley drawingTabOrder OnClickTestSmileyBtnClick  TMemoMemo1Left!Top!WidthHHeight� Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings*"Just for fun" I decided to draw a smiley %face in front of the caption for the &active tabsheet.  This page draws the "face in a few different size with 'different backgrounds just to test the 
procedure. 
ParentFontTabOrder   	TTabSheet	TabSheet4Caption     Customizing Tabs  
ImageIndex TMemoMemo4Left� Top9WidthHeightpColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings=The simple solution to customizing tabs uses OnDrawTab event <exit of the TPageControl to draw the tabs any way we choose within the given tab size. CIn the tabs above, we used the exit  to color the tab to match the @new color property defined for the tabsheet.  This requires the 9tailored TPageControl previously described.  Without the ?modified TPageControl, we can still control the tab drawing by setting Aa highlight background color for the Active sheet, modifying the <font, or drawing a symbol or graphic.  Here we do all three. 9The source code for the program also includes a fix unit 6(VCLFixes) for an bug in Delphi 7 which prevented the ?OnDrawTab exit from being honored in 64-bit  Windows versions. Hooray! 
ParentFontTabOrder      