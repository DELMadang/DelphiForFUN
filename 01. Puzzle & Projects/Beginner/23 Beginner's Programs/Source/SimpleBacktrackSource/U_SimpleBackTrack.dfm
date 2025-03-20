object Form1: TForm1
  Left = 186
  Top = 120
  Width = 696
  Height = 480
  Caption = 'Beginner'#39's Backtracking Demo'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object StringGrid1: TStringGrid
    Left = 40
    Top = 192
    Width = 201
    Height = 201
    ColCount = 4
    DefaultColWidth = 48
    DefaultRowHeight = 48
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object MakeCaseBtn: TButton
    Left = 48
    Top = 64
    Width = 75
    Height = 25
    Caption = 'Make Case'
    TabOrder = 1
    OnClick = MakeCaseBtnClick
  end
  object SolveItBtn: TButton
    Left = 48
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Solve it'
    TabOrder = 2
    OnClick = SolveItBtnClick
  end
  object Memo1: TMemo
    Left = 312
    Top = 32
    Width = 337
    Height = 361
    Lines.Strings = (
      
        'Find a path from '#39'S'#39' in the bottom right hand corner through all' +
        ' of '
      'the letters '#39'A'#39', '#39'B'#39', '#39'C'#39', and '#39'D'#39'. '
      ''
      
        'You can pass through blank but not through '#39'X'#39' cells.  Moves can' +
        ' '
      
        'be left, right, up, or down.  Not diagonally.  Do not revisit an' +
        'y cell.  '
      ''
      
        'There will be the 4 target letters, 4 blocked ('#39'X'#39') cells and 8 ' +
        'blank '
      'cells in each  case.   '
      ''
      'Columns and rows are numbered from 0 through 3.  This area will '
      
        'contain a list of moves tried and the resulting path if a soluti' +
        'on is '
      'found.  Moves are displayed as "(column,row)".'
      ''
      
        'The search is "depth first" meaning each path tried will proceed' +
        ' '
      
        'until it finds a solution or a dead end.  Depth first searches a' +
        're '
      'easier to implement than "breadth first" searches but finds the '
      'shortest path to a solution only by luck.')
    ScrollBars = ssVertical
    TabOrder = 3
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 429
    Width = 688
    Height = 20
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright  © 2005, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsUnderline]
    ParentFont = False
    TabOrder = 4
    OnClick = StaticText1Click
  end
end
