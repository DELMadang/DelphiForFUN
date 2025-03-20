object Form1: TForm1
  Left = 146
  Top = 84
  Width = 640
  Height = 482
  Caption = 'The Coach'#39's Dilemma'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 184
    Top = 200
    Width = 31
    Height = 22
    Caption = 'VS.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 352
    Top = 24
    Width = 71
    Height = 14
    Caption = 'Known Ranks '
  end
  object Label3: TLabel
    Left = 496
    Top = 24
    Width = 54
    Height = 14
    Caption = 'High to low'
  end
  object Label4: TLabel
    Left = 16
    Top = 176
    Width = 55
    Height = 16
    Caption = 'Player #1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 16
    Top = 232
    Width = 55
    Height = 16
    Caption = 'Player #2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object MatchLbl: TLabel
    Left = 248
    Top = 278
    Width = 11
    Height = 22
    Caption = '0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label7: TLabel
    Left = 278
    Top = 280
    Width = 59
    Height = 18
    Caption = 'Matches'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Memo1: TMemo
    Left = 16
    Top = 16
    Width = 289
    Height = 137
    Color = clYellow
    Lines.Strings = (
      '8 tennis players must be ranked playing less than '
      '20 matches.  You may assume that  if player A '
      'defeats player B and player B defeats player C, '
      'then player A would defeat player C even though '
      'they do not actually play the match. '
      ''
      'Select a player from each row below to define '
      'each match.   The grids at right will display partial '
      'rankings based on matches played')
    TabOrder = 0
  end
  object SolveBtn: TButton
    Left = 248
    Top = 320
    Width = 89
    Height = 25
    Caption = 'Solve'
    TabOrder = 1
    OnClick = SolveBtnClick
  end
  object ListBox1: TListBox
    Left = 16
    Top = 272
    Width = 209
    Height = 137
    ItemHeight = 14
    TabOrder = 2
  end
  object PlayerGrid1: TStringGrid
    Left = 96
    Top = 167
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 3
    OnClick = PlayerGridClick
    OnDrawCell = PlayerGridDrawCell
  end
  object PlayerGrid2: TStringGrid
    Left = 96
    Top = 223
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 4
    OnClick = PlayerGridClick
    OnDrawCell = PlayerGridDrawCell
  end
  object StringGrid3: TStringGrid
    Left = 360
    Top = 48
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 5
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid4: TStringGrid
    Left = 360
    Top = 95
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 6
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid5: TStringGrid
    Left = 360
    Top = 142
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 7
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid6: TStringGrid
    Left = 359
    Top = 189
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 8
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid7: TStringGrid
    Left = 359
    Top = 235
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 9
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid8: TStringGrid
    Left = 359
    Top = 282
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 10
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid9: TStringGrid
    Left = 359
    Top = 329
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 11
    OnDrawCell = RankGridDrawCell
  end
  object StringGrid10: TStringGrid
    Left = 359
    Top = 376
    Width = 209
    Height = 33
    ColCount = 8
    DefaultColWidth = 24
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    TabOrder = 12
    OnDrawCell = RankGridDrawCell
  end
  object RestartBtn: TButton
    Left = 248
    Top = 352
    Width = 89
    Height = 25
    Caption = 'Start over'
    TabOrder = 13
    OnClick = RestartBtnClick
  end
  object NewBtn: TButton
    Left = 248
    Top = 384
    Width = 89
    Height = 25
    Caption = 'New  players'
    TabOrder = 14
    OnClick = NewBtnClick
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 429
    Width = 632
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = 'Copyright  © 2003, Gary Darby,  www.DelphiForFun.org'
        Width = 50
      end>
    SimplePanel = False
  end
end
