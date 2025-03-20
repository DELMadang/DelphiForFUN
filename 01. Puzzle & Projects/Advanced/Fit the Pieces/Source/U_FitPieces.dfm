object Form1: TForm1
  Left = 192
  Top = 114
  Width = 1026
  Height = 561
  Caption = 'Fit the pieces   V 1.0'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDragDrop = FormDragDrop
  OnDragOver = FormDragOver
  PixelsPerInch = 120
  TextHeight = 16
  object StaticText1: TStaticText
    Left = 0
    Top = 493
    Width = 1008
    Height = 23
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2010, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Memo1: TMemo
    Left = 28
    Top = 28
    Width = 412
    Height = 405
    Color = 14548991
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'Given the 8 lettered blocks at right, place them on the '
      'template crossword style to form common '
      'uncapitalized words reading across and down, '
      'crossword style.  There'#39's no need to rotate pieces; '
      'they'#39'll fit as shown, with each piece used exactly once.'
      ''
      'The puzzle is the first and only example of this type '
      'I'#39've found in my many years as a fan of the Mensa '
      '"Puzzle-A-Day" calendars.'
      ''
      'To play, drag and drop blocks onto the template, '
      'horizontal blocks onto horizontal spaces and vertical '
      'blocks onto vertical spaces.  To replace a block drag '
      'the incorrect block anywhere off of the template.'
      ''
      'Use the "Hint" button for a littler help if you get stuck.'
      ''
      'A future version will add dictionary lookup capabilties '
      'so that additional valid puzzles can be generated (I '
      'hope!).')
    ParentFont = False
    TabOrder = 1
  end
  object HintBtn: TButton
    Left = 771
    Top = 384
    Width = 85
    Height = 28
    Caption = 'Hint'
    TabOrder = 2
    OnClick = HintBtnClick
  end
  object Board: TStringGrid
    Left = 472
    Top = 224
    Width = 255
    Height = 204
    BorderStyle = bsNone
    DefaultColWidth = 51
    DefaultRowHeight = 51
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 4
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    GridLineWidth = 0
    ParentFont = False
    TabOrder = 3
    OnDragDrop = BoardDragDrop
    OnDragOver = BoardDragOver
    OnDrawCell = BoardDrawCell
  end
  object SGH1: TStringGrid
    Left = 472
    Top = 32
    Width = 98
    Height = 50
    ColCount = 2
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 4
    OnDrawCell = SGDrawCell
  end
  object SGV1: TStringGrid
    Left = 472
    Top = 104
    Width = 50
    Height = 98
    ColCount = 1
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 5
    OnDrawCell = SGDrawCell
  end
  object SGH2: TStringGrid
    Left = 592
    Top = 32
    Width = 98
    Height = 50
    ColCount = 2
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 6
    OnDrawCell = SGDrawCell
  end
  object SGH3: TStringGrid
    Left = 712
    Top = 32
    Width = 98
    Height = 50
    ColCount = 2
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 7
    OnDrawCell = SGDrawCell
  end
  object SGV2: TStringGrid
    Left = 592
    Top = 96
    Width = 50
    Height = 98
    ColCount = 1
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 8
    OnDrawCell = SGDrawCell
  end
  object SGV3: TStringGrid
    Left = 712
    Top = 96
    Width = 50
    Height = 98
    ColCount = 1
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 9
    OnDrawCell = SGDrawCell
  end
  object SGH4: TStringGrid
    Left = 832
    Top = 32
    Width = 98
    Height = 50
    ColCount = 2
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 10
    OnDrawCell = SGDrawCell
  end
  object SGV4: TStringGrid
    Left = 832
    Top = 96
    Width = 50
    Height = 98
    ColCount = 1
    DefaultColWidth = 48
    DefaultRowHeight = 48
    DefaultDrawing = False
    DragMode = dmAutomatic
    FixedCols = 0
    RowCount = 2
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -23
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    Options = []
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 11
    OnDrawCell = SGDrawCell
  end
  object Memo2: TMemo
    Left = 768
    Top = 232
    Width = 217
    Height = 129
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    Lines.Strings = (
      'The Hint button will remove '
      'an incorrectly placed block '
      'for each click.  If there are '
      'none incorrectly placed, it '
      'will add one random block '
      'in its correct location.')
    ParentFont = False
    TabOrder = 12
  end
  object ResetBtn: TButton
    Left = 888
    Top = 384
    Width = 91
    Height = 28
    Caption = 'Start over'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -17
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
    TabOrder = 13
    OnClick = ResetBtnClick
  end
end
