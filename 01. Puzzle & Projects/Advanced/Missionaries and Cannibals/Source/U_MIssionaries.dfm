object Form1: TForm1
  Left = 138
  Top = 79
  Width = 700
  Height = 600
  Caption = 'Cannibals and Missionaries'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object SolutionsGrp: TRadioGroup
    Left = 16
    Top = 432
    Width = 129
    Height = 105
    Caption = 'Click to view a solution'
    Items.Strings = (
      'Solution 1'
      'Solution 2'
      'etc.')
    TabOrder = 3
    Visible = False
    OnClick = SolutionsGrpClick
  end
  object SolveBtn: TButton
    Left = 16
    Top = 472
    Width = 129
    Height = 25
    Caption = 'Solve it for me'
    TabOrder = 0
    OnClick = SolveBtnClick
  end
  object MoveList: TListBox
    Left = 416
    Top = 40
    Width = 241
    Height = 409
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    Items.Strings = (
      '     Left Bank                         Right Bank'
      ' 3 C, 3 M, Boat                0 C, 0 M  No Boat')
    ParentFont = False
    TabOrder = 1
  end
  object MoveGrp: TRadioGroup
    Left = 184
    Top = 360
    Width = 193
    Height = 105
    Caption = 'Who is in the boat for next crossing?'
    Items.Strings = (
      '1 Cannibal'
      '2 Cannibals'
      '1 Missionary'
      '2 Missionaries'
      '1 Cannibal, 1 Missionary')
    TabOrder = 2
    OnClick = MoveGrpClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 553
    Width = 692
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2004, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
  object CLearMovesBtn: TButton
    Left = 184
    Top = 512
    Width = 129
    Height = 25
    Caption = 'Clear moves'
    TabOrder = 5
    OnClick = CLearMovesBtnClick
  end
  object UndoBtn: TButton
    Left = 184
    Top = 472
    Width = 129
    Height = 25
    Caption = 'Undo last move'
    TabOrder = 6
    OnClick = UndoBtnClick
  end
  object Panel1: TPanel
    Left = 16
    Top = 32
    Width = 361
    Height = 321
    Caption = 'Panel1'
    Color = 14548991
    TabOrder = 7
    object Memo1: TMemo
      Left = 16
      Top = 16
      Width = 329
      Height = 297
      BorderStyle = bsNone
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Lines.Strings = (
        'A River Crossing Puzzle'
        ''
        'Three cannibals and three missionaries need to cross'
        'from the left bank to the right bank of a river.  There is a'
        'boat that will only carry a maximum of two persons at a'
        'time.   The cannibals and the missionaries share a'
        'comon goal of reaching the village, so any member of'
        'the party will cooperate by piloting the boat as'
        'necessary.'
        ''
        'However,  if there is ever a situation where the cannibals'
        'outnuimber the missionaries on either bank, their'
        'natural tendencies will take over and the outnumbered'
        'missionaries will be eaten!'
        ''
        'Can you figure out how to get them all cross?  Click'
        '"Who is in the boat? " box to make each move.'
        ''
        ''
        ''
        ''
        ''
        ' ')
      ParentFont = False
      TabOrder = 0
    end
  end
end
