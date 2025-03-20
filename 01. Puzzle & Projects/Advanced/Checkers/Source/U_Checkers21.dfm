object Form1: TForm1
  Left = 192
  Top = 120
  Width = 835
  Height = 600
  Caption = 'Checkers V2.1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnKeyPress = FormKeyPress
  PixelsPerInch = 96
  TextHeight = 13
  object Turnlbl: TLabel
    Left = 416
    Top = 16
    Width = 96
    Height = 24
    Caption = 'Red moves'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object MustJumpLbl: TLabel
    Left = 640
    Top = 16
    Width = 87
    Height = 24
    Caption = 'Must jump'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 24
    Top = 456
    Width = 158
    Height = 20
    Caption = 'Pieces captured by:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScoreLbl1: TLabel
    Left = 24
    Top = 488
    Width = 54
    Height = 20
    Caption = 'Red: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ScoreLbl2: TLabel
    Left = 192
    Top = 488
    Width = 65
    Height = 20
    Caption = 'Black: 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object UndoLbl: TLabel
    Left = 680
    Top = 480
    Width = 105
    Height = 37
    AutoSize = False
    Caption = 'Click here or press U key to undo last move'
    WordWrap = True
    OnClick = UndoLblClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 553
    Width = 827
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2007, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object ResetBtn: TButton
    Left = 552
    Top = 480
    Width = 75
    Height = 25
    Caption = 'Reset  game'
    TabOrder = 1
    OnClick = ResetBtnClick
  end
  object Panel1: TPanel
    Left = 8
    Top = 8
    Width = 329
    Height = 417
    Caption = 'Panel1'
    Color = 14548991
    TabOrder = 2
    object Memo1: TMemo
      Left = 16
      Top = 16
      Width = 313
      Height = 377
      BorderStyle = bsNone
      Color = 14548991
      Lines.Strings = (
        'This program started life as an exercise in techniques'
        'for creating and managing a checkerboard in Delphi..  Along'
        'the way it turned into a basic version of "American rule" or'
        '"Straight" Checkers.'
        ''
        'In this implementation, a move is made by dragging a'
        'checker to a valid location. A text label above the'
        'board will indicate whose turn and whether a jump'
        'exists.  Multiple jumps are made as a series of single'
        'jumps.'
        ''
        'Rules:'
        ''
        '1. Pieces move diagonally; up for black, down for red'
        'pieces.'
        ''
        '2. Players alternate turns, Black moves first.'
        ''
        '3. Pieces are taken by "jumping", moving diagonally'
        'over an adjacent piece of the opposite color to an'
        'adjacent empty square. If the jumping piece has another jump'
        'available, the turn continues and that jump must be taken.'
        ''
        '4. If more than one jump is available at the start of a turn,'
        'any one may be taken.'
        ''
        '5. If a checker reaches the opposite side of the board'
        'it become a "king" and may move or jump diagonally in'
        'any direction.'
        ''
        '6. The game is over when one side captures all of the'
        'pieces, or his opponent is trapped with no move'
        'available.'
        ''
        ' ')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
