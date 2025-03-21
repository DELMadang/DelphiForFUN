�
 TFORM1 0  TPF0TForm1Form1Left�Top� WidthdHeight�CaptionCatalan Numbers,  Version 2.0Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderPositionpoScreenCenterPixelsPerInchx
TextHeight TLabelLabel1LeftTop WidthaHeightCaption# of variables  TLabelLabel2LeftTop
Width<HeightCaptionPhase 1  TLabelLabel3Left0Top
Width<HeightCaptionPhase 2  TLabelCatlblLeft�Top�WidthHeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style 
ParentFont  TLabel	CatNbrLblLeftvTop�WidthEHeightCaption	Catalan #  	TSpinEdit	SpinEdit1Left~Top�Width3HeightFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style MaxValue
MinValue
ParentFontTabOrder Value  TListBoxListBox1Left�TopWidthHeight�Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ItemHeight
ParentFontTabOrder  TButtonGenerateBtnLeft� Top�Width� HeightCaptionGenerate expresionsTabOrderOnClickGenerateBtnClick  TListBoxListBox2Left�TopWidthQHeight�Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ItemHeight
ParentFontTabOrder  TMemoMemo1LeftTopWidth�Height�Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.Strings1Catalan numbers were discovered by Euler when he 4went looking for the number of ways that an N-sided 2convex polygon could be divided into triangles by 3drawing non-intersecting diagonals.  A more recent 5interpretation notes that this is also the number of 5simultaneous handshakes between guests at a circular 6table that can occur without any arm crossing another guest's arm. 1In 1838 Eugene Catalan documented the same series9(shifted by a couple of positions) as the number of ways 8that an expression with N +1 variables and connected by (binary operators could be parenthesized. >It is this latter definition that interests us here.  Catalan :gave us the definition - the Nth Catalan is the number od 0ways that we can select N object from among 2N, 5divided by (N+1).  Cat(N) = Combinations(2N,N)/(N+1). .So expressions with 4 variables, abcd, can be 1parenthesized in Cat(3) = Comb(6,3)/4 = 20/4 = 5 4ways. . But knowing the number is quite a different (problem than generating the expressions. 4The algorithm here starts by creating a sequence of 72N-2 "1"s and "0"s for N variables.   Each string must 6have the property that the number  of "1"s equals the 9number of "0"s and the number of "0"s to the left of any ;"0" must be less than the numbers "1"s to the left of that 8position. So for Cat(3) then 5 valid configurations are 1"101010", "101100", "110010", "110100", "101010". /Once we have that string, replace "1"s by left =parentheses, "(", and "0"s by variable letters. In the final 9phases it is easy to figure out where to place the right  paren ,")" and operator symbols. 
ParentFont
ScrollBars
ssVerticalTabOrder  TStaticTextStaticText1Left TopBWidthRHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption:   Copyright © 2003, 2009, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsBoldfsUnderline 
ParentFontTabOrderOnClickStaticText1Click   