�
 TFORM1 0k
  TPF0TForm1Form1Left� Top^WidthwHeightzCaption2Demo of solution searches for Sliding Coin problemColor	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrderOnCreate
FormCreatePixelsPerInch`
TextHeight TPageControlPageControl1LeftTopWidth1Height9
ActivePage	TabSheet1TabOrder  	TTabSheet	TabSheet1Caption	TabSheet1 TMemoMemo2Left TopWidth�Height� Lines.Strings^This program illustrates using Graph Searching techniques to solve the "Sliding Coins" puzzle 2presented elsewhere on DelphiForFun.org.  opuzzle  VHere's a summary of the puzzle:  Given 3 dimes and 2 quarters arranged as DQDQD, the  \objective is to re-arrange them so that the dimes precede the quarters (DDDQQ).   Each move _must move one adjacent DQ or QD pair up, over (left or right),  and back down in line with the Jother coins.  The 2 coins being moved may not be reversed during the move. cOn the next page you can generate a "graph" describing all of the possible coin congifurations for ba particular board size.  The board in this case is a linear set of positions which the coins may boccupy.  I know from trial and error that solving the puzzle requires a board size of at least 11 
positions. TabOrder    	TTabSheet	TabSheet2Caption	TabSheet2
ImageIndex TLabelLabel1Left0Top� Width8HeightCaptionBoard width  TLabelLabel2Left0Top WidthUHeightCaptionMax search depth  TButtonStopBtnLeft(Top8Width� HeightyCaptionStopFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.StylefsBold 
ParentFontTabOrder VisibleOnClickStopBtnClick  TButtonMakeNodesBtnLeft(Top8Width� HeightCaptionGenerate adjacency list graphTabOrderOnClickMakeNodesBtnClick  TButtonDFSearchBtnLeft(TophWidth� HeightCaptionGenerate Depthfirst solutionsTabOrderOnClickDFSearchBtnClick  TMemoMemo1Left`TopWidth� HeightLines.Strings  
ScrollBars
ssVerticalTabOrder  TButtonBFSearchBtnLeft(Top� Width� HeightCaptionGenerate BreadthFirst solutionsTabOrderOnClickBFSearchBtnClick  TUpDownMaxlenUpDownLeft� Top� WidthHeight	Associate	MaxLenEdtMinMaxPositionTabOrderWrapOnClickMaxlenUpDownClick  TEdit	MaxLenEdtLeftxTop� WidthHeightReadOnly	TabOrderText11  TUpDown
MaxDepthUDLeft� Top� WidthHeight	AssociateMaxDepthEdtMinMax
PositionTabOrderWrap  TEditMaxDepthEdtLeft� Top� WidthHeight	MaxLengthTabOrderText5     