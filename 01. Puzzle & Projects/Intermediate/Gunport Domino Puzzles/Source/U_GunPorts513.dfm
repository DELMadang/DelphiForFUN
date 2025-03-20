object Form1: TForm1
  Left = 281
  Top = 176
  AutoScroll = False
  AutoSize = True
  Caption = 'Gunports Version 51.3'
  ClientHeight = 682
  ClientWidth = 1181
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 19
  object Label1: TLabel
    Left = 392
    Top = 552
    Width = 39
    Height = 19
    Caption = 'Rows'
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 659
    Width = 1181
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1181
    Height = 659
    Align = alClient
    TabOrder = 1
    object borderimage: TImage
      Left = 600
      Top = 48
      Width = 489
      Height = 409
    end
    object Image1: TImage
      Left = 632
      Top = 80
      Width = 425
      Height = 345
      OnClick = Image1Click
    end
    object Placedlabel: TLabel
      Left = 400
      Top = 528
      Width = 140
      Height = 19
      Caption = '0 Dominoes placed'
    end
    object RowsLbl: TLabel
      Left = 24
      Top = 528
      Width = 39
      Height = 19
      Caption = 'Rows'
    end
    object ColsLbl: TLabel
      Left = 112
      Top = 528
      Width = 32
      Height = 19
      Caption = 'Cols'
    end
    object BoardLbl: TLabel
      Left = 24
      Top = 584
      Width = 65
      Height = 19
      Caption = 'BoardLbl'
    end
    object TimeLbl: TLabel
      Left = 616
      Top = 632
      Width = 69
      Height = 19
      Caption = 'Run time:'
    end
    object ClickLbl: TLabel
      Left = 600
      Top = 24
      Width = 276
      Height = 19
      Caption = 'Click cells to add or remove dominoes'
    end
    object Memo1: TMemo
      Left = 17
      Top = 14
      Width = 552
      Height = 507
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        
          'This puzzle is played on a board divided into square cells on wh' +
          'ich'
        'dominoes are placed. A  "Gunport" is an unoccupied square '
        'surrounded by the outside border or dominoes. Dominoes are 1 '
        
          'square x 2 squares in size and me be oriented horizontally or ve' +
          'rtically,'
        ''
        'The objective for the chosen board size is to  leave the maximum'
        'number of gunports by placing dominoes on the board. The target'
        
          'number of  gunports is given each size.  Define a domino by clic' +
          'king '
        
          'two adjacent squares.  Clicking a defined domino or a previously' +
          ' '
        'selected single square will remove it.'
        ''
        
          'Version 2: Users can now choose any board size from 3x3 to 10x10' +
          '.  A'
        
          '"Solve" button implements an LP (Linear Programming) search for ' +
          'a'
        
          'solution to the current puzzle size.  The search algorithm used ' +
          'is the '
        
          '4th version described in an excellent paper by Chlond and Bosch,' +
          ' "The '
        'Gunport Problem" available at '
        'http://archive.ite.journal.informs.org/Vol6No2/ChlondBosch/.'
        ''
        
          'Options allow search for either the "first" or the "optimal" sol' +
          'ution.  '
        
          'Note: "Optimal" may run for many hours for larger puzzle sizes. ' +
          ' The '
        '"Eliminate Symmetries" checkbox speeds searches by eliminating '
        
          'checking for some configuration representing rotations or mirror' +
          'ing of '
        
          'the board. New solutions are added to a file of previously solve' +
          'd '
        
          'puzzles which may be seen by clicking the "View all solutions" b' +
          'utton.  '
        
          'Click any of the resulting puzzle size lines to view the solutio' +
          'n.'
        ''
        
          'Version 2.1 replaces version 5.1 of the LPSolve solver with vers' +
          'ion 5.5. '
        ' This shows significantly improved search performance on cases '
        'tested so far.'
        ''
        
          'Version 2.2 adds user access to the LPSolve "Presolve" options w' +
          'hich can '
        
          'significantly reduce run times (or occasionally incrase them).  ' +
          'I implmemented '
        
          'this for my use in testing but decided to release it in case oth' +
          'ers wanted to '
        'explore run times.'
        ''
        '')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnClick = Memo1Click
      OnKeyUp = Memo1KeyUp
    end
    object SolveBtn: TButton
      Left = 616
      Top = 480
      Width = 241
      Height = 25
      Caption = 'Program search for solutions'
      TabOrder = 1
      OnClick = SolveBtnClick
    end
    object ColsUD: TUpDown
      Left = 161
      Top = 544
      Width = 20
      Height = 27
      Associate = ColsEdt
      Min = 3
      Max = 12
      Position = 3
      TabOrder = 2
    end
    object ColsEdt: TEdit
      Left = 112
      Top = 544
      Width = 49
      Height = 27
      TabOrder = 3
      Text = '3'
      OnChange = SizeEdtChange
    end
    object EliminateSymmetries: TCheckBox
      Left = 616
      Top = 560
      Width = 201
      Height = 17
      Caption = 'Eliminate Symmetries'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object ViewBtn: TButton
      Left = 904
      Top = 480
      Width = 177
      Height = 25
      Caption = 'View saved solutions'
      TabOrder = 5
      OnClick = ViewBtnClick
    end
    object SearchOptimum: TCheckBox
      Left = 616
      Top = 512
      Width = 201
      Height = 41
      Caption = 'Search for optimum only     (May run long)'
      Checked = True
      State = cbChecked
      TabOrder = 6
      WordWrap = True
    end
    object RowsEdt: TEdit
      Left = 24
      Top = 544
      Width = 49
      Height = 27
      TabOrder = 7
      Text = '3'
      OnChange = SizeEdtChange
    end
    object Rowsud: TUpDown
      Left = 73
      Top = 544
      Width = 20
      Height = 27
      Associate = RowsEdt
      Min = 3
      Max = 12
      Position = 3
      TabOrder = 8
    end
    object AllowSave: TCheckBox
      Left = 912
      Top = 528
      Width = 177
      Height = 57
      Caption = 'Allow Add, Delete, Replace of saved solutions'
      TabOrder = 9
      WordWrap = True
    end
    object ClearBtn: TButton
      Left = 24
      Top = 616
      Width = 137
      Height = 25
      Caption = 'Clear board'
      TabOrder = 10
      OnClick = ClearBtnClick
    end
    object Button1: TButton
      Left = 616
      Top = 592
      Width = 225
      Height = 25
      Caption = 'Choose PreSolve options'
      TabOrder = 11
      OnClick = Button1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 1104
    Top = 56
  end
end
