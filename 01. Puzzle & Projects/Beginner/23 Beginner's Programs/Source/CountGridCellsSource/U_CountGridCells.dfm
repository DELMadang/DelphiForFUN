object Form1: TForm1
  Left = 327
  Top = 61
  Width = 1305
  Height = 750
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -20
  Font.Name = 'MS Sans Serif'
  Font.Style = [fsBold]
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 24
  object Label1: TLabel
    Left = 672
    Top = 48
    Width = 62
    Height = 24
    Caption = 'Labels'
  end
  object Label2: TLabel
    Left = 896
    Top = 80
    Width = 361
    Height = 105
    AutoSize = False
    Caption = 
      'Make random grids and count consecutive empty cells in each row ' +
      'returning a Chess notation FEN style key for each.'
    Color = 14548991
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    WordWrap = True
  end
  object StringGrid1: TStringGrid
    Left = 208
    Top = 80
    Width = 409
    Height = 401
    TabStop = False
    ColCount = 8
    DefaultColWidth = 48
    DefaultRowHeight = 48
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
    OnDrawCell = IgnoreSelectedDrawCell
  end
  object MakeGridBtn: TBitBtn
    Left = 896
    Top = 200
    Width = 369
    Height = 33
    Caption = 'Make random grid'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    OnClick = MakeGridBtnClick
  end
  object CountBtn: TButton
    Left = 896
    Top = 256
    Width = 369
    Height = 33
    Caption = 'Count empty cells'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    OnClick = CountBtnClick
  end
  object LblGrid: TStringGrid
    Left = 656
    Top = 80
    Width = 193
    Height = 393
    ColCount = 1
    DefaultColWidth = 190
    DefaultRowHeight = 48
    FixedCols = 0
    RowCount = 8
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 3
    OnDrawCell = IgnoreSelectedDrawCell
  end
end
