�
 TFORM1 0�  TPF0TForm1Form1Left'Top� WidthHeight�CaptionClock Angles,  Version 2Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrder
OnActivateFormActivateOnCloseQueryFormCloseQueryPixelsPerInch`
TextHeight TPageControlPageControl1Left Top Width�Height�
ActivePage	TabSheet2AlignalClientTabOrder  	TTabSheet	TabSheet1CaptionIntroduction TMemoMemo2Left Top Width�Height�AlignalClientColor��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringscThis project started as a beginner's level program that was adapted from this  ACM (Association of aComputing Machinery) Programming Contest problem: "Given  integers representing  hour and minute bof a time of day,  calculate the angle between the hour and minute hands when looking at a normal analog clock." ^An interesting addition answers the question "How many times do the Hour and Minute hands formea right angle in a 12 hour period?" Here is a brief explanation of the logic used to find the answer: g1. The Hour hand of a regular clock rotates 360 degrees in 12 hours.  The rate at which the hand moves Lis therefore 360/12 or 30 degrees per hour.  That is 0.5 degrees per minute.]2. The Minute hand makes a complete revolution in 60 minutes or 360/60= 6 degrees per minute.g3. This means that for each passing minute, the minute hand picks up 5.5 degrees on the Hour hand (6 - h0.5). As an equation, X degrees lead = 5.5 x M minutes  How long will it take the Minute hand to get 90 ddegrees ahead?  We can turn the equation around and compute M = X / 5.5.  Assuming both hands start ]a 0 degrees, the Minute hand will be 90 degrees ahead in 90/5.5 or in about 16.36 minutes at e(HH:MM:SS) 12:16:22. It will again be separated by 90 degrees, counterclockwise this time, after the bMinute hand has moved 270 degrees more than the Hour hand.  That is  270/5.5, about 49.09 minutes or at about 12:49:05.i4. We can continue calculating this way for each 180 degree increase of the difference in hand positions +until times start repeating after 12 hours. *The "Clock" page wil show you the results.    
ParentFont
ScrollBars
ssVerticalTabOrder    	TTabSheet	TabSheet2Caption	The Clock
ImageIndex TLabelLHALeftxTop� WidthHeightCaption0  TLabelLMALeft0Top� WidthHeightCaption0  TLabelLDaLeft� TopWidthHeightCaption0  TLabelLabel1Left8Top� WidthHeightCaptionHour  TLabelLabel2Left� Top� Width'HeightCaptionMinute  TLabelLabel3Left0Top� Width?HeightCaption
Hour Angle  TLabelLabel4Left� Top� WidthKHeightCaptionMinute Angle  TLabelLabel5Left0TopWidth|HeightCaptionAngle between hands  TImageImage1Left�TopWidth� Height� OnClickImage1Click  TLabelCountLblLeftTop:Width� HeightWAutoSizeCaption22 times   in 12 hoursFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TLabel	NinetyLblLeft Top(Width9HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontVisible  TLabelLabel7LeftTop� Width,HeightCaptionSecond  TEditEdit1LeftXTop� Width!Height Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontReadOnly	TabOrder Text0  TEditEdit2Left� Top� Width!Height Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontReadOnly	TabOrderText0  TUpDownHourValLeftyTop� WidthHeight 	AssociateEdit1Min�MaxTabOrderOnClickValClick  TUpDown	MinuteValLeft� Top� WidthHeight 	AssociateEdit2Min�Max<TabOrderOnClickValClick  TMemoMemo1LeftTopWidth�Height� Color��� Lines.Strings?You can move the clock hands by clicking the up/down arrows on (the Hour, Minute and Second boxes below. BClick the "How many times..." button to see the clock run at high Aspoeed and count the right angle passings for the whole 12 hours. ;Click the "Pause..." checkbox to make the clock pause each @time the hands are 90 degrees apart.  Click the paused clock to 
continue.   TabOrder  TButton	SearchBtnLeftTopHWidth�HeightCaptionEHow many times per day are the hands at right angles from each other?Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderOnClickSearchBtnClick  	TCheckBoxPauseBoxLeft ToppWidth�HeightCaption9Pause on each right angle. ( Click on clock to continue.)Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder  TEditEdit3Left@Top� Width!Height Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFontReadOnly	TabOrderText0  TUpDownSecValLeftaTop� WidthHeight 	AssociateEdit3Min�Max<TabOrderOnClickValClick  TButtonResetBtnLeft�TopWidth� HeightCaption
Start overFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontTabOrder	OnClickResetBtnClick    TStaticTextStaticText1Left Top�Width�HeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright  © 2001-2011, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrderOnClickStaticText1Click   