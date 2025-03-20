object Form1: TForm1
  Left = 384
  Top = 191
  AutoScroll = False
  AutoSize = True
  Caption = 'Scrambled Letter Blocks'
  ClientHeight = 563
  ClientWidth = 777
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
  object StaticText1: TStaticText
    Left = 0
    Top = 541
    Width = 777
    Height = 22
    Cursor = crHandPoint
    Align = alBottom
    Alignment = taCenter
    Caption = 'Copyright '#169' 2011, Gary Darby,  www.DelphiForFun.org'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -15
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
    TabOrder = 0
    OnClick = StaticText1Click
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 777
    Height = 541
    Align = alClient
    TabOrder = 1
    object Label1: TLabel
      Left = 456
      Top = 384
      Width = 259
      Height = 57
      AutoSize = False
      Caption = 
        'The button below will find one word each time it is clicked.  An' +
        'y incorrectly placed letter groups will  be removed from the gri' +
        'd.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object SearchBtn: TButton
      Left = 462
      Top = 453
      Width = 219
      Height = 25
      Caption = 'Find one word '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = SearchBtnClick
    end
    object Memo1: TMemo
      Left = 36
      Top = 16
      Width = 361
      Height = 521
      Color = 14548991
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'From the October 17, 2011 Mensa Puzzle Calendar:'
        ''
        'Form six 9-letter words by combining two 3-letter'
        'blocks found below with endings already placed in '
        'the grid.  All blocks will be used.  If you do it'
        'correctly, one of the vertical columns will spell a '
        'bonus word.'
        ''
        'Select a letter group below and click that group'
        'and then the area of the grid where it is to be '
        'placed.   (Grid columns 1-3 for the leftmost gorup,  '
        'columns 4-6 for the middle group.) If the grid area '
        'clicked is already occupied, that group will be '
        'returned to the availble group list.'
        '-----'
        'AFT'
        'ARC'
        'BET'
        'DEM'
        'ERG'
        'HEN'
        'KEB'
        'ROT'
        'SCO'
        'SNA'
        'UND'
        'YST')
      ParentFont = False
      TabOrder = 1
      OnClick = Memo1Click
    end
    object StringGrid1: TStringGrid
      Left = 448
      Top = 56
      Width = 233
      Height = 153
      ColCount = 9
      DefaultColWidth = 24
      FixedCols = 0
      RowCount = 6
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = StringGrid1Click
    end
    object Memo2: TMemo
      Left = 456
      Top = 232
      Width = 233
      Height = 113
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Results so far:'
        ''
        '0 Valid words'
        '0 Unrecognized words'
        '6 Partial words'
        ' ')
      ParentFont = False
      TabOrder = 3
    end
  end
end
