object Form1: TForm1
  Left = 301
  Top = 110
  Width = 696
  Height = 600
  Cursor = crHandPoint
  Caption = 'Word Squares'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlue
  Font.Height = -16
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold, fsUnderline]
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object Lettergrid: TStringGrid
    Left = 24
    Top = 32
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
    Font.Height = -24
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnKeyPress = LettergridKeyPress
  end
  object MakeBtn: TButton
    Left = 24
    Top = 360
    Width = 185
    Height = 25
    Caption = 'New Puzzle'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = MakeBtnClick
  end
  object Memo1: TMemo
    Left = 328
    Top = 40
    Width = 329
    Height = 321
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'Click "New puzzle" button to create the initial word for a '
      'new word square puzzle.   '
      ''
      'Complete the square using the letters in the table '
      'below so that each word can be read across and '
      'down.'
      ''
      'To enter letters, click the desired square  (excluding '
      'the initial word row and column) and enter the new '
      'letter.'
      ''
      'The "Restart Puzzle" will clear the entered data for the '
      'current puzzle so you can start over.  The "Give up" '
      'button will fill in the correct letters.'
      ''
      ''
      '  '
      ' ')
    ParentFont = False
    TabOrder = 2
  end
  object WordSizegrp: TRadioGroup
    Left = 24
    Top = 280
    Width = 185
    Height = 65
    Caption = 'Word size'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemIndex = 0
    Items.Strings = (
      '4 characters'
      '5 characters')
    ParentFont = False
    TabOrder = 3
  end
  object ShowBtn: TButton
    Left = 24
    Top = 440
    Width = 185
    Height = 25
    Caption = 'I give up'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = ShowBtnClick
  end
  object StatsGrid: TStringGrid
    Left = 328
    Top = 384
    Width = 328
    Height = 81
    DefaultColWidth = 24
    DefaultDrawing = False
    RowCount = 3
    TabOrder = 5
    OnDrawCell = StatsGridDrawCell
  end
  object RestartBtn: TButton
    Left = 24
    Top = 400
    Width = 185
    Height = 25
    Caption = 'Restart puzzle'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = RestartBtnClick
  end
  object StaticText1: TStaticText
    Left = 0
    Top = 542
    Width = 688
    Height = 24
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright © 2006, Gary Darby,  www.DelphiForFun.org'
    TabOrder = 7
    OnClick = StaticText1Click
  end
end
