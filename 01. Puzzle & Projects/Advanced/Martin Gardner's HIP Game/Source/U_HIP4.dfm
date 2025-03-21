�
 TFORM1 0  TPF0TForm1Form1Left� Top]WidthRHeightXCaption' HIP V4.0 - Martin Gardner's Hip Game  Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style OldCreateOrderOnCloseQueryFormCloseQueryOnCreate
FormCreatePixelsPerInch`
TextHeight TStaticTextStaticText1Left Top WidthBHeightCursorcrHandPointAlignalBottom	AlignmenttaCenterCaption9Copyright � 2001, 2008, Gary Darby,  www.DelphiForFun.orgFont.CharsetDEFAULT_CHARSET
Font.ColorclBlueFont.Height�	Font.NameArial
Font.StylefsUnderline 
ParentFontTabOrder OnClickStaticText1Click  TPageControlPageControl1Left Top WidthBHeight 
ActivePage	TabSheet2AlignalClientTabOrder 	TTabSheet	TabSheet1CaptionIntroduction TMemoMemo1LeftTopWidth�Height�Color��� Font.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style Lines.StringstHip is a game invented by the well known recreational mathematician Martin Gardner.  He named it HIP "because of the'hipster's reputed distain for squares". sThe game is played on a 6X6 board.  Each player has 18 tokens and they take turns placing tokens on any unoccupied zsquare.  The objective is to avoid completing any square by marking all 4 corners with his tokens.  The square may be any |size and tipped at any angle There are 105 such squares on the 6x6 board (several sample squares are initially displayed).  GYou can right click on any point to see the squares with corners there. {The first player to complete a square is the loser. In his book, My Best Mathematical and Logical Puzzles, Martin Gardner, {Dover Pubs., 1994, he says that there is essentially only one way for a game to end in a tie. We have found three that are 3unique under rotations, flips, and color reversals. ~To help study the game, Version 2 allows moves to be retracted by clicking on any dot of the last player's color. Retractions zare during games when the computer is one or both of the players.  The retraction box may be set at the end of a computer game. uVersion 3 also allows three board sizes.  7x7 produces no ties games, 6x6 has three, 5x5 has many.  The 6x6 tie games:may be replayed by clicking the "Replay Tie Games" button. �Version 4 adds a variation of play rules where each move after the inital turn, requires that 2 dots be selected.  This variation|appears to largely offset the advantage that player B has when he can play moves symmetric to A's to ensure that he will not{be the first to form a square.  Move retraction was also enhanced so that moves maybe be retracted in the reverse order of }the way they were played or in an arbitrary order (except that only dots matching the color of the previously played dot may }be retracted).  When playing in human vs. computer or computer vs. computer, selecting the "Allow retractions" checkbox will reset computer play options. 
ParentFont
ScrollBars
ssVerticalTabOrder    	TTabSheet	TabSheet2CaptionPlay
ImageIndex TImageBoardLeft(Top7WidthiHeightiOnClick
BoardClickOnMouseDownBoardMouseDown	OnMouseUpBoardMouseUp  TLabelLabel1LeftTop WidthHeight)AutoSizeCaptionIt is Player A's moveFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TLabelLabel2Left(TopWidthYHeight)AutoSizeCaptionaRight click a point to see all squares with a corner there.                                      Font.CharsetDEFAULT_CHARSET
Font.Color� @ Font.Height�	Font.NameArial
Font.StylefsBold 
ParentFontWordWrap	  TLabelLabel3Left�Top Width%HeightCaptionMoves  TLabelLabel5LeftTop(WidthHeightIAutoSizeCaptionPlayer B can retract a moveFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.Style 
ParentFontWordWrap	  TButtonNewBtnLeft� TopXWidthiHeightCaptionNew gameFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrder OnClickNewBtnClick  	TCheckBox
Player1BoxLeftTopWidth� HeightCaption!Computer plays for Player A (Red)TabOrderOnClickCheckBoxClick  	TCheckBox
Player2BoxLeftTop8Width� HeightCaption"Computer plays for Player B (Blue)TabOrderOnClickCheckBoxClick  TButtonStartBtnLeftTopXWidthKHeightCaptionStartFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameArial
Font.StylefsBold 
ParentFontTabOrderOnClickStartBtnClick  	TCheckBox
CanRetractLeftTop� Width� HeightHintBClick button below or any dot of previous players color to retractCaptionAllow retractionsParentShowHintShowHint	TabOrderOnClickCanRetractClick  TRadioGroupSizeGrpLeftTopxWidth� Height9Caption
Board sizeColumns	ItemIndexItems.Strings5x56x67x7 TabOrderOnClickSizeGrpClick  TButton
TieGameBtnLeftTop�Width� HeightCaptionReplay 6x6 Tie Game #1TabOrderOnClickTieGameBtnClick  	TCheckBoxDoubleMoveBoxLeftTop� WidthHeightCaptionPlay "2 moves per turn" versionTabOrderOnClickDoubleMoveBoxClick  TListBoxMovelistLeft�Top8Width� Heighti
ItemHeightTabOrderVisible  TButton
RetractBtnLeftTop� Width� HeightCaptionRetract last moveTabOrder	VisibleOnClickRetractBtnClick  	TCheckBox	ShowMovesLeftTop�Width� HeightCaptionShow moves so far?TabOrder
OnClickShowMovesClick     