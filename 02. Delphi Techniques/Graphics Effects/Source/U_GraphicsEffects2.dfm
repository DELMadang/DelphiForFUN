�
 TFORM1 0�L  TPF0TForm1Form1Left�Top� Width�Height�Caption!15 Graphics Effects,  Version 2.0Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderPositionpoScreenCenterOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInchx
TextHeight TLabelLabel1Left� Top WidthHeight Caption-      Hello !! here is the List of examples :Font.CharsetEASTEUROPE_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFont  TPageControlPageControl1Left Top(Width�Heightq
ActivePage	TabSheet3Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style HotTrack		MultiLine	
ParentFontRaggedRight	Style	tsButtonsTabOrder  	TTabSheet	TabSheet2CaptionRaised Text
ImageIndex TPanelPanel3Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageImg2LeftTopWidthHeight�  TLabelLabel18Left
Top<WidthUHeightCaptionText to write  TButtonButton2Left
ToplWidth� HeightnCaptionDo TextTabOrder OnClickButton2Click  TMemoMemo4Left
Top
WidthHeightColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings!This an example of how to create special text, using the canvas "textout" method. #The shadow-side text is written in "black a few pixels down and right  of the real text location,  The &light-side text is written in white a %few pixels up and left.  And finally $the original text is wriiten in the original location. #Simply click the "Do Text"  button and see it in action. 
ParentFontTabOrder  TEditRaisedTextEditLeftjTop<WidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderText
HoHoHo  :)    	TTabSheet	TabSheet3CaptionRotated text
ImageIndex TPanelPanel4Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageImg3LeftTop
Width(Height�  TLabelLabel5LeftTopvWidth� HeightCaptionAngle (in degrees)  TEditValue1Left� TopvWidth(HeightTabOrder Text34
OnKeyPressValue1KeyPress  TButtonButton3LeftTop� Width� Height)CaptionDo rotated text !TabOrderOnClickButton3Click  TButtonButton4LeftTop�Width� HeightFCaptionTest Animation !TabOrderOnClickButton4Click  TMemoMemo3Left
Top
WidthHeightPColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsThis is an easy example of how !to create a "rotated" text using canvas "textout" function. 
ParentFontTabOrder    	TTabSheet	TabSheet1Caption	Selection TPanelPanel1Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageimg1Left�Top
Width�HeightZ  TImageoriginalImg1LeftCTop
WidthwHeightZOnMouseDownoriginalImg1MouseDownOnMouseMoveoriginalImg1MouseMove	OnMouseUporiginalImg1MouseUp  TPanelPanel2Left�Top WidthHeightnTabOrder   TButtonButton1Left
Top
Width/HeightHintLoad PictureCaptionLoadTabOrderOnClickLoadBtnClick  TMemoMemo5LefttTopvWidth�Height� Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsAThis is an easy example of how to use the tool like "select tool" [First, click the "load"  button (i f not loaded) and you will see the loaded picture in the]first view, then "select" a region using mouse, and selected region will be displayed in the second view. 
ParentFontTabOrder    	TTabSheet	TabSheet5CaptionPixel filtering
ImageIndex TPanelPanel7Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageoriginalImg2LeftOTop
WidthwHeightw  TImageImg4Left-Top
WidthwHeightw  TButtonButton7Left
Top
Width2HeightCaptionLoadTabOrder OnClickLoadBtnClick  TButtonButton8Left�Top� Width\HeightCaptionProceed !!!!!!TabOrderOnClickButton8Click  TMemoMemo6LeftETop�WidthdHeightoColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringssThis is an easy example of how to use the image canvas pixels and modify them as you would like.  In this example, Mwe get pixel color, modify color to red and draw new modified pixel to Image. qFiltering RGB  (Red, Green, Blue) one color at a time will demonstrate the CMY (Cyan, Magenta, Yellow) pallette.  
ParentFontTabOrder  	TCheckBox	GreenBox5Left� Top
Width� HeightCaptionFilter out greenChecked	State	cbCheckedTabOrder  	TCheckBoxRedBox5LeftOTop
WidthwHeightCaptionFilter out redTabOrder  	TCheckBoxBlueBox5Left�Top
WidthxHeightCaptionFilter out blueChecked	State	cbCheckedTabOrder    	TTabSheet	TabSheet6Caption	Grayscale
ImageIndex TPanelPanel8Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageImg5Left=Top
WidthwHeightw  TImageoriginalImg3LeftETop
WidthvHeightw  TLabelLabel3Left=Top
WidthkHeightCaptionWeighting for RedFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel4Left� Top
WidthvHeightCaptionWeighting for GreenFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabelLabel6Left�Top
WidthlHeightCaptionWeighting for BlueFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TButtonButton9Left
Top
Width2HeightCaptionLoadFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder OnClickLoadBtnClick  TMemoMemo7LeftTop�Width�HeightwColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings�This is an example of how to use "CONVERT TO GRAYSCALE" function.    The weights determine the relative importance of each color (red, �green, blue) as they are averaged to get the shade of gray.  Notice that the NTCS standard weights reflect the fact that the human eye is least /senisitive to green and most sensitive to blue. �Click on the "load" button, you will see loaded picture, adjust the weights if desired, and then click on the "proceed" button, and see what happens...:) 
ParentFontTabOrder  TButtonButton10Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton10Click  	TSpinEdit	RedWeightLeft� TopWidth3HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue 
ParentFontTabOrderValue+  	TSpinEditGreenWeightLeftvTopWidth3HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue�MinValue 
ParentFontTabOrderValueK  	TSpinEdit
BlueWeightLeft;TopWidth3HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style MaxValue MinValue 
ParentFontTabOrderValuer  TButtonButton33Left�TopWidth� HeightCaptionRestore NTSC default weightsFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontTabOrderOnClickButton33Click    	TTabSheet	TabSheet7CaptionBlack && White
ImageIndex TPanelPanel9Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageoriginalImg4LeftETop
WidthvHeightw  TImageImg6LeftETop
WidthwHeightw  TLabelLabel14Left'Top�Width� HeightCaption"Black-white  split value (0 - 255)  TMemoMemo8LeftETop�Width�HeightZColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings^This is an easy example of how to use "BLACK AND WHITE" function .Simply, click on the "load" dbutton, you will se loaded picture, and thenclick on the "proceed" button, and see what happens...:) 
ParentFontTabOrder   TButtonButton11Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton12Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton12Click  	TSpinEdit
BlackWhiteLeftTop�Width<HeightMaxValue� MinValue TabOrderValue    	TTabSheet	TabSheet8CaptionPixel  distribution
ImageIndex TPanelPanel10Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageoriginalImg5LeftETop
WidthvHeightw  TImageImg7Left=Top
WidthwHeightw  TMemoMemo9LeftETop�Width�HeightZColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameApril
Font.Style Lines.Stringsathis is an easy example on how to use "PIXELS DISTRIBUTION" function.Simply, click on the "load" dbutton, you will se loaded picture, and thenclick on the "proceed" button, and see what happens...:) 
ParentFontTabOrder   TButtonButton13Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton14Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton14Click    	TTabSheet	TabSheet9CaptionInvert colors
ImageIndex TPanelPanel11Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageoriginalImg6LeftETop
WidthvHeightw  TImageImg8Left=TopWidthwHeightw  TMemoMemo10LeftETop�Width�HeightZColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings\this is an easy example on how to use "INVERT COLORS" function. Simply, click on the "load" ebutton, you will se loaded picture, and then click on the "proceed" button, and see what happens...:) 
ParentFontTabOrder   TButtonButton15Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton16Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton16Click    	TTabSheet
TabSheet10CaptionContrast control
ImageIndex	 TPanelPanel12Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageoriginalImg7LeftETop
WidthvHeightw  TImageImg9Left=Top
WidthwHeightw  TLabelLabel10LeftOTop�WidthHeightCaption(Contrast value (1 to 50,  10=no change )  TLabelLabel2Left�Top�Width
HeightCaption$Brightness (0 to 100, 10=no changes)  TMemoMemo11LeftETop�WidthlHeight_Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsoThis is an  example of how to use "CONTRAST"  and "BRIGHTNESS" functions.Simply, click on the "Load" button if Zdesired to load picture, and then click on the "Proceed" button, and see what happens...:) RYou  may use the Contrast and Brightness edit fields below to change those values. 
ParentFontTabOrder   TButtonButton17Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton18Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton18Click  	TSpinEditContrastEditLeftoTop�Width<Height	MaxLengthdMaxValue2MinValueTabOrderValue  	TSpinEdit
BrightEditLeft�Top�Width<HeightMaxValuedMinValue TabOrderValue    	TTabSheet
TabSheet11CaptionRelief image
ImageIndex
 TPanelPanel13Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageoriginalImg8LeftETop
WidthvHeightw  TImageImg10Left=Top
WidthwHeightw  TLabelLabel11Left Top Width� HeightCaptionMedian gray value (0 to 255)  TMemoMemo12LeftETop�Width�Height_Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsgThis is an easy example of how to use "RELIEF" function.  Simply, click on the "load" button, you will Tse loaded picture, and then click on the "proceed" button, and see what happens...:) LYou may adjust the gray value of the final image using the edit field below. 
ParentFontTabOrder   TButtonButton19Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton20Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton20Click  	TSpinEditMedian11Left�Top�Width<HeightMaxValue� MinValue TabOrderValue�     	TTabSheet
TabSheet12CaptionPixel sorrting
ImageIndex TImageoriginalImg9LeftETop
WidthvHeightw  TImageImg11Left5Top
WidthwHeightw  TMemoMemo13LeftETop�Width�HeightZColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings^This is an easy example of how to use "PIXELS SORTING" function.  Simply, click on the "load" ebutton, you will se loaded picture, and then click on the "proceed" button, and see what happens...:) 
ParentFontTabOrder   TButtonButton21Left
Top
Width2HeightCaptionLoadTabOrderOnClickButton21Click  TButtonButton22Left�ToplWidth\HeightCaptionStartTabOrderOnClickButton22Click  TButtonButton23Left�Top� Width\HeightCaptionStopTabOrderOnClickButton23Click   	TTabSheet
TabSheet13CaptionBlob deformation
ImageIndex TImageoriginalImg10LeftETop
WidthwHeightw  TImageImg12Left=Top
WidthwHeightw  TLabelLabel7LeftOTop�WidthOHeightCaptionX Blob size  TLabelLabel8Left Top�WidthLHeightCaption
Y Bob size  TLabelLabel12Left�Top�Width� HeightCaptionPoints to randomize per blob  TLabelLabel13Left�Top�WidthUHeightCaptionNbr of blobs  TMemoMemo14LeftETop�Width\HeightZColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsBThis is an easy example of how to use "Blob Deformation" function. vSimply, click on the "load" button, you will se loaded picture, and then click on the "proceed" button,  and see what happens...:)  NYou may adlust the blob size and other parameters using the edit fields below.  
ParentFontTabOrder   TButtonButton24Left Top
Width<HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton25Left�Top� Width\HeightCaptionProceed !!!TabOrderOnClickButton25Click  	TSpinEditXBlobLeft� Top�Width<HeightMaxValueMinValueTabOrderValue  	TSpinEditYBlobLeftETop�Width<HeightMaxValueMinValueTabOrderValue  	TSpinEditBlobCntLeftOTop�Width<HeightMaxValuedMinValueTabOrderValue
  	TSpinEditNbrBlobsLeft Top�WidthPHeightMaxValue�� MinValuedTabOrderValue N   	TTabSheet
TabSheet14CaptionBlend 2 pictures
ImageIndex TPanelPanel14Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageImg13LeftETop
WidthvHeightw  TImageImg14Left=Top
WidthwHeightwStretch	  TMemoMemo15Left%Top�Width�HeightgColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringsEThis is an easy example of how to use then "BLEND Pictures" function. }Simply, click on the first "load" button, you will see loaded picture in the first image,and then click on the second "load" ~button,you will see the second loaded picture in the second image, and finally click on the "proceed !!!" button and see what happens...:)  @The radio buttons below will adjust left to right blend levels.  
ParentFontTabOrder   TButton
Load14bBtnLeft�TopWidth3HeightCaptionLoadTabOrderOnClickLoad14bBtnClick  TButtonButton27Left� TopWidth2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton28Left�Top� Width\HeightCaptionProceed --> TabOrderOnClickButton28Click  TRadioGroupBlendgrpLeftMTop�Width�Height1Columns	ItemIndex Items.StringsConstant blendMore picture 1 on rightLess picture 1 on right TabOrder    	TTabSheet
TabSheet15CaptionSine deformation
ImageIndex TImageImg15LeftETop
WidthvHeightw  TImageImg16Left=Top
WidthwHeightw  TLabelLabel15LeftvTopWidthtHeightCaptionAmplitude factor  TLabelLabel16Left'TopWidthZHeightCaptionPeriod factor  TMemoMemo16LeftETop�WidthdHeightoColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringstThis is an easy example on how to use "DEFORM Picture SINE" function.  Simply, click on the "load" button, you will osee loaded picture in the first image, and finally click on the "proceed !!!" button and see what happens...:)  RYou can use the fields below to adjust the amplitude and period of the distortion. 
ParentFontTabOrder   TButtonButton29Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  TButtonButton30Left�Top� Width\HeightCaptionProceedTabOrderOnClickButton30Click  	TSpinEditAmpEditLeft� TopWidth3HeightMaxValuedMinValue TabOrderValue  	TSpinEdit
PeriodEditLeft�TopWidth2HeightMaxValuedMinValue TabOrderValue2   	TTabSheet
TabSheet16CaptionMagnify deformation
ImageIndex TPanelPanel15Left Top Width�Height,AlignalClient
BevelInner	bvLoweredTabOrder  TImageImg17LeftETop
WidthwHeightwAutoSize	  TImageImg18Left=Top
WidthwHeightwOnClick
Img18Click  TLabelLabel9LeftCTopWidth� HeightCaption%Magnification bubble size (1 to  200)  TLabelLabel17Left�TopWidth� HeightCaptionArea limit (1 to 1000)  TMemoMemo17LeftETop�WidthtHeightoColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringspThis is an example of how to use the "DEFORM Picture MAGNIFY" function.  Click on the "load"  button, to load a +picture in the left hand image if desired,  xClick anywhere on the right hand image and see what happens...:)  Use the edit field below to adjust magnification level    
ParentFontTabOrder   TButtonButton31Left
Top
Width2HeightCaptionLoadTabOrderOnClickLoadBtnClick  	TSpinEdit	NumEdit16LeftLTopWidth<HeightMaxValue� MinValue TabOrderValued  	TSpinEditMagAreaEditLeft�TopWidthZHeightMaxValue�MinValueTabOrderValued     TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaptionG   Copyright © 2003, 2015  Gary Darby & Ivan Sivak,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrder  TOpenPictureDialogOpenPictureDialog1Left�Top   